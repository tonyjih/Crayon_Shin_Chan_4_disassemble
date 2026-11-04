#!/usr/bin/env python3
"""Extract editable original assets; accepts only the documented original ROM."""
from __future__ import annotations

import argparse
from collections import defaultdict
import csv
import hashlib
import json
from pathlib import Path

from shin_prev_byte_rle import decode as decode_prev
from shin_rleff import decode as decode_rleff


def rom_offset(bank: int, address: int) -> int:
    return address if bank == 0 else bank * 0x4000 + address - 0x4000


def save_tiles(path: Path, raw: bytes, bpp: int) -> None:
    from PIL import Image

    tile_size = 8 * bpp
    if len(raw) % tile_size:
        raise ValueError(f"unaligned tile data: {path}")
    count = len(raw) // tile_size
    columns = min(16, count)
    img = Image.new("P", (columns * 8, ((count + columns - 1) // columns) * 8), 0)
    shades = [255, 0] if bpp == 1 else [255, 170, 85, 0]
    img.putpalette([component for shade in shades for component in (shade,) * 3]
                   + [0] * (768 - len(shades) * 3))
    for tile in range(count):
        for y in range(8):
            for x in range(8):
                color = sum(((raw[tile * tile_size + y * bpp + plane] >> (7 - x)) & 1)
                            << plane for plane in range(bpp))
                img.putpixel(((tile % columns) * 8 + x, (tile // columns) * 8 + y), color)
    img.save(path, bits=bpp)


def sound_track_source(data: bytes, start: int) -> str:
    if len(data) < 5 or data[-1] != 255 or len(data) % 2 != 1:
        raise ValueError(f"invalid native sound track at ${start:04x}")
    label = f"AudioTrack_{start:04x}"
    targets = {data[i + 1] for i in range(4, len(data) - 1, 2)
               if 0xB0 <= data[i] < 0xC0 and 2 <= data[i + 1] < len(data) // 2}
    lines = [f"{label}::", "    audio_header " + ", ".join(f"${x:02x}" for x in data[:4])]
    names = {0xA0: "volume", 0xA1: "pitch_offset", 0xA2: "duty_or_wave_length",
             0xA3: "vibrato", 0xA5: "pan", 0xA6: "master_volume", 0xA7: "wait",
             0xAE: "pitch_mode", 0xAF: "tempo", 0xFD: "loop_start"}
    for pos in range(4, len(data) - 1, 2):
        word = pos // 2
        if word in targets:
            lines.append(f".word_{word:02x}:")
        opcode, parameter = data[pos:pos + 2]
        if opcode < 0xA0:
            instruction = f"audio_note ${opcode:02x}, ${parameter:02x}"
        elif opcode in names:
            instruction = f"audio_{names[opcode]} ${parameter:02x}"
        elif 0xB0 <= opcode < 0xC0:
            target = (f"(.word_{parameter:02x} - {label}) / 2" if parameter in targets
                      else f"${parameter:02x}")
            instruction = f"audio_repeat ${opcode & 15:02x}, {target}"
        elif 0xC0 <= opcode < 0xF0:
            name = {0xC0: "envelope", 0xD0: "volume_up", 0xE0: "volume_down"}[opcode & 0xF0]
            instruction = f"audio_{name} ${opcode & 15:02x}, ${parameter:02x}"
        else:
            instruction = f"audio_command ${opcode:02x}, ${parameter:02x}"
        lines.append("    " + instruction)
    lines.append("    audio_end")
    return "\n".join(lines) + "\n"


def extract(rom_path: Path, destination: Path, manifest: dict) -> None:
    rom = rom_path.read_bytes()
    digest = hashlib.md5(rom).hexdigest().upper()
    if len(rom) != 131072 or digest != manifest["rom_md5"]:
        raise ValueError(f"expected the original 128 KiB ROM; got MD5 {digest}")
    for asset in manifest["assets"]:
        offset = rom_offset(asset["bank"], asset["address"])
        packed = rom[offset:offset + asset["stored_size"]]
        if asset["codec"] == "prevbyte":
            raw, used = decode_prev(packed)
        elif asset["codec"] == "rleff":
            raw, used = decode_rleff(packed, asset["decoded_size"])
        else:
            raw, used = packed, len(packed)
        if len(raw) != asset["decoded_size"] or used != len(packed):
            raise ValueError(f"asset boundary mismatch: {asset['id']}")
        path = destination / asset["source"]
        path.parent.mkdir(parents=True, exist_ok=True)
        if path.suffix == ".png":
            save_tiles(path, raw, asset["bpp"])
        elif asset["codec"] == "spawns":
            if raw[-1] != 255 or (len(raw) - 1) % 5:
                raise ValueError(f"invalid spawn list: {asset['id']}")
            with path.open("w", encoding="utf-8", newline="") as handle:
                writer = csv.writer(handle)
                writer.writerow(("type_raw", "x", "y_raw"))
                for pos in range(0, len(raw) - 1, 5):
                    writer.writerow((f"0x{raw[pos]:02x}", int.from_bytes(raw[pos + 1:pos + 3], "little"),
                                     f"0x{int.from_bytes(raw[pos + 3:pos + 5], 'little'):04x}"))
        else:
            path.write_bytes(raw)
    audio = manifest["audio"]
    sound_dir = destination / "audio"
    (sound_dir / "tracks").mkdir(parents=True, exist_ok=True)
    start = rom_offset(7, audio["table_address"])
    records = []
    for index in range(audio["entry_count"]):
        slot, channel, lo, hi = rom[start + index * 4:start + index * 4 + 4]
        records.append((slot, channel, lo | hi << 8))
    ids = defaultdict(list)
    for index, (_, _, ptr) in enumerate(records):
        ids[ptr].append(index)
    starts = sorted(ids)
    for index, ptr in enumerate(starts):
        end = starts[index + 1] if index + 1 < len(starts) else audio["end_address"]
        data = rom[rom_offset(7, ptr):rom_offset(7, end)]
        text = "; Sound IDs: " + ", ".join(f"${i:02x}" for i in ids[ptr]) + "\n"
        text += sound_track_source(data, ptr)
        (sound_dir / "tracks" / f"track_{ptr:04x}.asm").write_text(text, encoding="utf-8", newline="")
    table = ["; Six virtual slots mix four hardware channels; IDs can share a track.", "SoundDirectory::"]
    for index, (slot, channel, ptr) in enumerate(records):
        table.extend((f"    db ${slot:02x}, ${channel:02x} ; sound ${index:02x}", f"    dw AudioTrack_{ptr:04x}"))
    table += ["", *[f'INCLUDE "audio/tracks/track_{ptr:04x}.asm"' for ptr in starts]]
    (sound_dir / "sound_data.asm").write_text("\n".join(table) + "\n", encoding="utf-8", newline="")
    (sound_dir / "sound_ids.csv").write_text(
        "id,slot,hardware_channel,track\n" + "".join(
            f"0x{i:02x},0x{slot:02x},{channel},AudioTrack_{ptr:04x}\n"
            for i, (slot, channel, ptr) in enumerate(records)), encoding="utf-8", newline="")
    print(f"Extracted {len(manifest['assets'])} assets and {len(starts)} native audio tracks.")


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path)
    parser.add_argument("--out", type=Path, default=root / "original")
    args = parser.parse_args()
    manifest = json.loads((root / "original" / "assets.json").read_text(encoding="utf-8"))
    try:
        extract(args.rom, args.out, manifest)
    except (OSError, ValueError) as error:
        parser.exit(1, f"{error}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
