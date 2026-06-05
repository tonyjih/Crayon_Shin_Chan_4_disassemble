#!/usr/bin/env python3
"""Encode/decode Kureyon Shin-chan 4's previous-byte RLE graphics format.

Format:
  u16 group_count, little endian
  repeat group_count times:
    u8 flags, MSB first
    8 output bytes controlled by flag bits:
      bit 0 -> literal byte follows; output it and update previous byte
      bit 1 -> repeat previous output byte

The game decoder reads the initial previous byte from destination - 1.  For the
Debug Menu font stream, the original encoder emits the first byte as a literal;
this script does the same by default so it can reproduce that stream exactly.
"""
from __future__ import annotations

import argparse
from pathlib import Path


def decode(data: bytes, initial_prev: int = 0) -> tuple[bytes, int]:
    if len(data) < 2:
        raise ValueError("compressed data is too short")
    pos = 0
    group_count = data[pos] | (data[pos + 1] << 8)
    pos += 2

    out = bytearray()
    prev = initial_prev & 0xff

    for _ in range(group_count):
        if pos >= len(data):
            raise ValueError("unexpected end of compressed stream at flag byte")
        flags = data[pos]
        pos += 1

        for _ in range(8):
            if flags & 0x80:
                value = prev
            else:
                if pos >= len(data):
                    raise ValueError("unexpected end of compressed stream at literal byte")
                value = data[pos]
                pos += 1
                prev = value
            out.append(value)
            flags = (flags << 1) & 0xff

    return bytes(out), pos


def encode(raw: bytes, initial_prev: int = 0, force_first_literal: bool = True) -> bytes:
    if len(raw) % 8 != 0:
        raise ValueError("raw length must be a multiple of 8 bytes")
    if len(raw) // 8 > 0xffff:
        raise ValueError("raw data is too large for this format")

    group_count = len(raw) // 8
    out = bytearray(group_count.to_bytes(2, "little"))
    prev = initial_prev & 0xff
    pos = 0

    for group_index in range(group_count):
        flag_pos = len(out)
        out.append(0)
        flags = 0

        for bit_index in range(8):
            value = raw[pos]
            is_first_output = pos == 0
            pos += 1

            can_repeat = value == prev and not (force_first_literal and is_first_output)
            if can_repeat:
                flags |= 0x80 >> bit_index
            else:
                out.append(value)
                prev = value

        out[flag_pos] = flags

    return bytes(out)


def main() -> None:
    parser = argparse.ArgumentParser(description="Encode/decode Shin-chan 4 previous-byte RLE graphics")
    sub = parser.add_subparsers(dest="cmd", required=True)

    dec = sub.add_parser("decode")
    dec.add_argument("input", type=Path)
    dec.add_argument("output", type=Path)
    dec.add_argument("--initial-prev", type=lambda x: int(x, 0), default=0)
    dec.add_argument("--used-output", type=Path, help="optional file to write consumed compressed byte count")

    enc = sub.add_parser("encode")
    enc.add_argument("input", type=Path)
    enc.add_argument("output", type=Path)
    enc.add_argument("--initial-prev", type=lambda x: int(x, 0), default=0)
    enc.add_argument("--allow-first-repeat", action="store_true", help="do not force first output byte to be literal")

    args = parser.parse_args()
    data = args.input.read_bytes()

    if args.cmd == "decode":
        raw, used = decode(data, args.initial_prev)
        args.output.write_bytes(raw)
        if args.used_output:
            args.used_output.write_text(str(used) + "\n")
        print(f"decoded {len(raw)} bytes; consumed {used} compressed bytes")
    elif args.cmd == "encode":
        comp = encode(data, args.initial_prev, force_first_literal=not args.allow_first_repeat)
        args.output.write_bytes(comp)
        print(f"encoded {len(data)} raw bytes into {len(comp)} compressed bytes")


if __name__ == "__main__":
    main()
