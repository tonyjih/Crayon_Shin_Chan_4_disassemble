#!/usr/bin/env python3
"""Build the original ROM or a separate test ROM from original/."""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
from tempfile import TemporaryDirectory

from shin_prev_byte_rle import decode as decode_prev, encode as encode_prev
from shin_rleff import decode as decode_rleff, encode as encode_rleff


ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "original"
OUTPUT = ROOT / "build" / "original"
TEST_OUTPUT = ROOT / "build" / "test-rom"


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


def pack_spawns(path: Path) -> bytes:
    result = bytearray()
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if not {"type_raw", "x", "y_raw"}.issubset(reader.fieldnames or []):
            raise ValueError(f"{path}: expected type_raw,x,y_raw CSV columns")
        for row in reader:
            kind, x, y = (int(row[key], 0) for key in ("type_raw", "x", "y_raw"))
            if not 0 <= kind < 255 or not 0 <= x <= 65535 or not 0 <= y <= 65535:
                raise ValueError(f"invalid spawn in {path}: {row}")
            result.append(kind)
            result.extend(x.to_bytes(2, "little"))
            result.extend(y.to_bytes(2, "little"))
    return bytes(result + b"\xff")


def assemble(assets: list[dict], output: Path) -> None:
    rgbds = rgbds_tools()
    rgbgfx = rgbds["rgbgfx"]
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
            raise ValueError(f"{path}: compressed size changed; fixed ROM layout needs updating")
        target.write_bytes(packed)
    obj, rom = output / "game.o", output / "game.gb"
    run([rgbds["rgbasm"], "-I", str(output), "-o", str(obj), "game.asm"])
    run([rgbds["rgblink"], "-n", str(output / "game.sym"), "-m", str(output / "game.map"),
         "-o", str(rom), str(obj)])
    run([rgbds["rgbfix"], "-v", "-p", "255", str(rom)])


def build(output: Path = OUTPUT, *, verify_original: bool = True) -> str:
    manifest = json.loads((SOURCE / "assets.json").read_text(encoding="utf-8"))
    output.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(dir=output) as directory:
        work = Path(directory)
        assemble(manifest["assets"], work)
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
    parser.add_argument("--test-rom", action="store_true",
                        help="build in build/test-rom/ without requiring the original MD5")
    parser.add_argument("--clean", action="store_true", help="remove the selected build directory")
    args = parser.parse_args()
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
            build(output, verify_original=not args.test_rom)
    except (OSError, ValueError, RuntimeError) as error:
        parser.exit(1, f"{error}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
