"""Shin-chan 4's FF/count/value layout compression."""
from __future__ import annotations


def decode(data: bytes, size: int) -> tuple[bytes, int]:
    if size < 0:
        raise ValueError("negative decoded size")
    out = bytearray()
    pos = 0
    while len(out) < size:
        if pos >= len(data):
            raise ValueError("truncated RLEFF stream")
        value = data[pos]
        pos += 1
        if value == 0xFF:
            if pos + 2 > len(data):
                raise ValueError("truncated RLEFF run")
            count, value = data[pos:pos + 2]
            pos += 2
            # The SM83 decoder decrements an 8-bit counter: zero means 256.
            out.extend([value] * min(count or 256, size - len(out)))
        else:
            out.append(value)
    return bytes(out), pos


def encode(raw: bytes) -> bytes:
    out = bytearray()
    pos = 0
    while pos < len(raw):
        value = raw[pos]
        run = 1
        while pos + run < len(raw) and raw[pos + run] == value:
            run += 1
        remaining = run
        while remaining:
            # The original compressor splits at 251, including runs of 280.
            count = min(remaining, 251)
            if value == 0xFF or count >= 3:
                out.extend((0xFF, count, value))
            else:
                out.extend([value] * count)
            remaining -= count
        pos += run
    return bytes(out)
