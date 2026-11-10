#!/usr/bin/env python3
"""Build the original ROM, a test ROM, or a DEBUG ROM from original/."""
from __future__ import annotations

import argparse
from collections.abc import Iterator
import csv
import hashlib
import json
from pathlib import Path
import re
import shutil
from struct import pack
import subprocess
from tempfile import TemporaryDirectory

from shin_prev_byte_rle import decode as decode_prev, encode as encode_prev
from shin_rleff import decode as decode_rleff, encode as encode_rleff


ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "original"
OUTPUT = ROOT / "build" / "original"
TEST_OUTPUT = ROOT / "build" / "test-rom"
DEBUG_OUTPUT = ROOT / "build" / "debug-rom"


def tool(name: str) -> str:
    for path in (ROOT.parent / (name + ".exe"), ROOT.parent / name):
        if path.is_file():
            return str(path)
    found = shutil.which(name)
    if not found:
        raise FileNotFoundError(f"{name} was not found in PATH or {ROOT.parent}")
    return found


def rgbds_tools() -> dict[str, str]:
    version = (ROOT / ".rgbds-version").read_text(encoding="ascii").strip()
    paths = {name: tool(name) for name in ("rgbasm", "rgblink", "rgbfix", "rgbgfx")}
    for name, path in paths.items():
        result = subprocess.run([path, "--version"], capture_output=True, text=True)
        reported = (result.stdout or result.stderr).strip()
        if result.returncode or reported != f"{name} v{version}":
            raise RuntimeError(
                f"{name} requires RGBDS v{version}; {path} reported {reported!r} "
                f"(exit {result.returncode})"
            )
    return paths


def run(command: list[str]) -> None:
    result = subprocess.run(command, cwd=SOURCE, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)


def spawn_type_ids() -> dict[str, int]:
    constants = (SOURCE / "constants.inc").read_text(encoding="utf-8")
    entries = re.findall(r"^DEF (OBJ_[A-Z0-9_]+)\s+EQU\s+\$([0-9a-fA-F]+)\b", constants, re.MULTILINE)
    return {name: int(value, 16) for name, value in entries}


def read_spawns(path: Path) -> Iterator[tuple[int, int, int, int]]:
    """Read kind (including flags), X, aligned Y, and the three-bit spawn parameter."""
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        fields = set(reader.fieldnames or [])
        named = {"object", "x", "y", "param"} <= fields
        if named:
            types = spawn_type_ids()
        elif not {"type_raw", "x", "y_raw"} <= fields:
            raise ValueError(f"{path}: expected object,x,y,param or type_raw,x,y_raw CSV columns")

        for row in reader:
            try:
                x = int(row["x"], 0)
                if named:
                    kind = types[row["object"]]
                    y = int(row["y"], 0)
                    param = int(row["param"], 0)
                    flags = int(row.get("flags") or "0", 0)
                    if not 0 <= kind <= 0x3f:
                        raise ValueError("object type must fit in six bits")
                    if flags & ~0xc0:
                        raise ValueError("flags may only use bits 6 and 7 of the object byte")
                    kind |= flags
                else:
                    kind = int(row["type_raw"], 0)
                    raw_y = int(row["y_raw"], 0)
                    y, param = raw_y & ~7, raw_y & 7
                if not 0 <= kind < 255 or not 0 <= x <= 65535 or not 0 <= y <= 65535:
                    raise ValueError("object byte or coordinates out of range")
                if y & 7 or not 0 <= param <= 7:
                    raise ValueError("Y must be a multiple of 8 and param must be in 0..7")
            except (KeyError, TypeError, ValueError) as error:
                raise ValueError(f"{path}:{reader.line_num}: invalid spawn: {error}") from error
            yield kind, x, y, param


def pack_spawns(path: Path) -> bytes:
    return b"".join(pack("<BHH", kind, x, y | param)
                    for kind, x, y, param in read_spawns(path)) + b"\xff"


def assemble(assets: list[dict], output: Path, *, test_rom: bool, debug: bool = False) -> None:
    rgbds = rgbds_tools()
    rgbgfx = rgbds["rgbgfx"]
    asm_flags = ["-D", "DEBUG=1"] if debug else []
    for asset in assets:
        path = SOURCE / asset["source"]
        target = output / "assets" / (asset["id"] + ".bin")
        target.parent.mkdir(parents=True, exist_ok=True)
        if path.suffix == ".png":
            raw_path = target.with_suffix(".2bpp" if asset["bpp"] == 2 else ".1bpp")
            run([rgbgfx, "--colors", "embedded", "-d", str(asset["bpp"]),
                 "-o", str(raw_path), str(path)])
            pixels = raw_path.read_bytes()
            size = asset["decoded_size"]
            if len(pixels) < size or any(pixels[size:]):
                raise ValueError(f"{path}: unexpected tile count or nonempty padding tiles")
            raw = pixels[:size]
        elif asset["codec"] == "spawns":
            raw = pack_spawns(path)
        else:
            raw = path.read_bytes()
        if len(raw) != asset["decoded_size"]:
            raise ValueError(f"{path}: expected {asset['decoded_size']} bytes, got {len(raw)}")
        if asset["codec"] == "prevbyte":
            packed = encode_prev(raw)
            decoded, used = decode_prev(packed)
            if decoded != raw or used != len(packed):
                raise ValueError(f"previous-byte RLE round trip failed: {path}")
        elif asset["codec"] == "rleff":
            packed = encode_rleff(raw)
            decoded, used = decode_rleff(packed, len(raw))
            if decoded != raw or used != len(packed):
                raise ValueError(f"RLEFF round trip failed: {path}")
        else:
            packed = raw
        if len(packed) != asset["stored_size"]:
            if not test_rom or asset["id"] != "b06_5334" or asset["codec"] != "prevbyte":
                raise ValueError(f"{path}: compressed size changed; fixed ROM layout needs updating")
            asm_flags.extend(["-D", "TEST_RELOCATE_BONUS_GFX=1"])
        target.write_bytes(packed)
    obj, rom = output / "game.o", output / "game.gb"
    run([rgbds["rgbasm"], *asm_flags, "-I", str(output), "-o", str(obj), "game.asm"])
    run([rgbds["rgblink"], "-n", str(output / "game.sym"), "-m", str(output / "game.map"),
         "-o", str(rom), str(obj)])
    run([rgbds["rgbfix"], "-v", "-p", "255", str(rom)])


def build(output: Path = OUTPUT, *, verify_original: bool = True, debug: bool = False) -> str:
    manifest = json.loads((SOURCE / "assets.json").read_text(encoding="utf-8"))
    output.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(dir=output) as directory:
        work = Path(directory)
        assemble(manifest["assets"], work, test_rom=not verify_original, debug=debug)
        data = (work / "game.gb").read_bytes()
        digest = hashlib.md5(data).hexdigest().upper()
        if len(data) != 131072 or (verify_original and digest != manifest["rom_md5"]):
            raise ValueError(f"ROM verification failed: size={len(data)}, MD5={digest}")

        # Publish the ROM after verification, leaving the previous result usable on build failure.
        (output / "assets").mkdir(exist_ok=True)
        for path in (work / "assets").iterdir():
            path.replace(output / "assets" / path.name)
        for name in ("game.o", "game.sym", "game.map", "game.gb"):
            (work / name).replace(output / name)

    print(f"Built {len(manifest['assets'])} assets and the native audio sources.")
    kind = "ROM" if verify_original else "Test ROM"
    print(f"{kind}: {output / 'game.gb'}")
    print(f"MD5 = {digest}")
    return digest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--test-rom", action="store_true",
                      help="build in build/test-rom/ without requiring the original MD5")
    mode.add_argument("--debug-rom", action="store_true",
                      help="build in build/debug-rom/ with the in-game DEBUG shortcut")
    parser.add_argument("--clean", action="store_true", help="remove the selected build directory")
    args = parser.parse_args()
    if args.debug_rom:
        output = DEBUG_OUTPUT
    else:
        output = TEST_OUTPUT if args.test_rom else OUTPUT
    try:
        if args.clean:
            if output.resolve() != ROOT.resolve() / "build" / output.name:
                raise ValueError("refusing to clean an unexpected output directory")
            if output.is_symlink():
                raise ValueError("refusing to clean a linked output directory")
            if output.exists():
                shutil.rmtree(output)
            print(f"Removed generated build/{output.name}/ files.")
        else:
            build(output, verify_original=not (args.test_rom or args.debug_rom), debug=args.debug_rom)
    except (OSError, ValueError, RuntimeError) as error:
        parser.exit(1, f"{error}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
