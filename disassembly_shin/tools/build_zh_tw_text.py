#!/usr/bin/env python3
"""Compile Fusion Pixel 10px zh-TW text to Game Boy tile rows."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from io import BytesIO
from pathlib import Path
from struct import pack
from tempfile import TemporaryDirectory
from zipfile import ZipFile

from shin_prev_byte_rle import encode as encode_prev

SOURCE = Path(__file__).resolve().parents[1] / "original"
TEXT = SOURCE / "text" / "zh_tw"
FONT_SIZE = 10
FONT_ASCENT = 9
FONT_SHA256 = "a6c58b0d23eb0e0dc011ab11c49974b9fccd069f22a89a49e889d205dbd4a2f3"
FONT_BDF = "fusion-pixel-10px-monospaced-zh_tw.bdf"
DEFAULT_FONT_ARCHIVE = SOURCE.parent / "build" / "fusion-pixel-10px-bdf.zip"
TOKENS = {"<DPAD>": 0x0F, "<A>": 0x40, "<B>": 0x7B}
TEXT_TOKENS = re.compile("|".join(map(re.escape, TOKENS)) + "|.")
VARIABLES = {**{i: str(i) for i in range(11)}, 11: "飛鼠", 12: "蟑螂", 13: "公雞"}
JP_PASSWORD_TILES = set(range(0x10, 0x43)) | {0x45}
NATIVE_TILES = set(range(0x10)) | {0x40, 0x43, 0x45, 0x7B, 0x7E, 0x7F}
LOW_TILES = set(range(0x80)) - NATIVE_TILES
MINIGAME_HUD_MESSAGES = (0x10, 0x11, 0x12, 0x13, 0x4B)
BONUS_BOX_MESSAGES = (*range(1, 9), 0x0C)
CREDIT_MESSAGES = range(0x4E, 0x5A)
STORY_MESSAGES = range(0x1C, 0x20)
STAGE_DIALOGUE_MESSAGES = set(range(0x20, 0x4B)) - {0x33}
PASSWORD_MESSAGES = {0x29, 0x3C}
TYPEWRITER_MESSAGES = set(STORY_MESSAGES) | (STAGE_DIALOGUE_MESSAGES - PASSWORD_MESSAGES) | set(CREDIT_MESSAGES)

# These strings share space with the original kana grid and its input rows.
PASSWORD_PROMPTS = ("輸入密碼？", "密碼錯了喔", "走吧，小白！")
TITLE_SUBTITLE = "小新的惡作劇大變身"
TITLE_NAME = "蠟筆小新"
BONUS_HEADER = "小遊戲區"
# L from LICENSED and V from TV ASAHI in the Japanese title credits.
BONUS_LEVEL_LABEL = (0x0000, 0x30D8, 0x30D8, 0x30D8, 0x30D8, 0x3070, 0x3070, 0x3E20)


def read_messages(path=TEXT / "messages.txt") -> dict[int, list[str]]:
    messages = {}
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        if not line or line.startswith("#"):
            continue
        key, body = line.split(" ", 1)
        message = int(key, 16)
        if message in messages:
            raise ValueError(f"Duplicate message {message:02X}")
        messages[message] = body.split("|")
    assert set(messages) == set(range(0x6B)) - {0x67}
    native = (SOURCE / "text/messages.asm").read_text(encoding="utf-8")
    block = native.split("Message_67_ScrollingCredits::", 1)[1].split("    done", 1)[0]
    lines = re.findall(r'"([^"]*)"', block)
    credit_lines = iter((
        "蠟筆小新4", "小新的惡作劇", "大變身", "原作", "臼井儀人",
        "製作人", "さとうつよし", "特別感謝",
        "やすかわたけし", "いそがいたけお", "まえはたただたか", "あらいまさゆき",
        "統籌", "しみちょん", "程式", "はうあん", "よしふみ", "美術", "かっけー",
        "作曲", "ブーイングブー", "みずたに", "試玩", "オニキス", "エッグメン", "ばじ",
        "出品", "萬代", "劇終",
    ))
    messages[0x67] = [
        ("!" if "<WRITE>" in line else "") + (next(credit_lines) if re.sub(r"<[^>]*>", "", line) else "")
        for line in lines
    ]
    assert next(credit_lines, None) is None
    credits = messages[0x67]
    long_name = credits.index("まえはたただたか")
    credits[long_name] = "まえはた"
    credits.insert(long_name + 1, "ただたか")
    del credits[credits.index("", long_name)]
    return messages


def import_font(archive: Path, characters: set[str]) -> None:
    archive_bytes = archive.read_bytes()
    if hashlib.sha256(archive_bytes).hexdigest() != FONT_SHA256:
        raise ValueError("請選擇 Fusion Pixel Font 2026.11.10 的 10px monospaced BDF ZIP（SHA-256 不符）。")
    glyphs = {}
    with ZipFile(BytesIO(archive_bytes)) as release:
        bdf = release.read(FONT_BDF).decode("ascii")
        for glyph in re.finditer(
            r"ENCODING (\d+)\n[^\n]*\nDWIDTH (\d+) 0\nBBX (\d+) (\d+) (-?\d+) (-?\d+)\nBITMAP\n(.*?)^ENDCHAR",
            bdf, re.M | re.S,
        ):
            code, advance, width, height, x, y = map(int, glyph.groups()[:6])
            if chr(code) not in characters:
                continue
            rows = [0] * FONT_SIZE
            for i, row in enumerate(glyph[7].splitlines()[:height]):
                top = FONT_ASCENT - y - height + i
                assert 0 <= top < FONT_SIZE and x >= 0 and x + width <= advance, glyph.group()
                rows[top] = int(row, 16) >> ((8 - width % 8) % 8) << (FONT_SIZE - x - width)
            glyphs[code] = (advance, rows)
        missing = characters - {chr(code) for code in glyphs}
        if missing:
            codes = "、".join(f"{char!r}（U+{ord(char):04X}）" for char in sorted(missing))
            raise ValueError(f"Fusion Pixel 10px 臺灣字型缺少 {codes}。請在翻譯中替換這些字再建置。")
        for member in ("OFL.txt", "LICENSES/ark-pixel/OFL.txt", "LICENSES/boutique-bitmap-9x9/OFL.txt",
                       "LICENSES/galmuri/LICENSE.txt"):
            target = TEXT / member
            data = release.read(member)
            if not target.is_file() or target.read_bytes() != data:
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
    subset = "# Fusion Pixel 10px Mono zh-TW 2026.11.10\n" + "".join(
        f"{code:04X}\t{advance}\t{''.join(f'{row:03x}' for row in rows)}\n"
        for code, (advance, rows) in sorted(glyphs.items())
    )
    with TemporaryDirectory(dir=TEXT) as directory:
        pending = Path(directory) / "glyphs.tsv"
        pending.write_text(subset, encoding="ascii", newline="\n")
        pending.replace(TEXT / pending.name)


def rebuild_glyphs(archive: Path) -> None:
    characters = {
        token for lines in read_messages().values() for line in lines
        for token in TEXT_TOKENS.findall(line.removeprefix("!").replace("{n}", ""))
        if token not in TOKENS
    }
    fixed = "".join(VARIABLES.values()) + "".join(PASSWORD_PROMPTS) + TITLE_SUBTITLE + TITLE_NAME + BONUS_HEADER
    import_font(archive, characters | set(fixed))


def read_glyphs() -> dict[str, tuple[int, tuple[int, ...]]]:
    glyphs = {}
    for line in (TEXT / "glyphs.tsv").read_text(encoding="ascii").splitlines():
        if not line.startswith("#"):
            code, advance, bits = line.split("\t")
            assert len(bits) == FONT_SIZE * 3
            glyphs[chr(int(code, 16))] = int(advance), tuple(int(bits[i:i+3], 16) for i in range(0, len(bits), 3))
    return glyphs


def draw_line(text, width, glyphs, *, center=False, top_offset=3, glyph_ends=None):
    x = 0
    pixels = [0] * 16
    icons = {}
    for token in TEXT_TOKENS.findall(text):
        if token in TOKENS:
            x = (x + 7) & ~7
            icons[x // 8] = TOKENS[token]
            x += 8
        else:
            advance, rows = glyphs[token]
            shift = width * 8 - FONT_SIZE - x
            for y, bits in enumerate(rows, top_offset):
                pixels[y] |= bits << shift if shift >= 0 else bits >> -shift
            x += advance
        if glyph_ends is not None:
            glyph_ends.append(x)
    if x > width * 8:
        raise ValueError(f"{text!r} needs {x}px, only {width * 8}px available")
    if center and not icons:
        shift = (width * 8 - x) // 2
        pixels = [row >> shift for row in pixels]
    columns = width if center else (x + 7) // 8
    tiles = [
        bytes(row >> (width * 8 - (column + 1) * 8) & 255 for row in pixels[y:y+8])
        if y == 0 or column not in icons else icons[column]
        for y in (0, 8) for column in range(columns)
    ]
    return columns, tiles


def layout(message, dest):
    """Choose the original box bounds and reserve any other text visible at the same time."""
    native = LOW_TILES
    width = 20 - (dest & 31)
    center = False
    if message in BONUS_BOX_MESSAGES:
        dest, width, center = dest + 0x20, 14, True
    elif message in (9, 10, 11, 0x5A, 0x5B, 0x5C):
        dest, width, center = dest + 0x20, 12, True
    elif message in (0x0D, 0x0E):
        width = 13
        native = native & set(range(0x10, 0x50))
    elif message == 0x0F:
        width = 7
    elif message in range(0x15, 0x19):
        dest, width, center = 0x98A4, 12, True
        native = native - set(range(0x68, 0x7B))
    elif message == 0x33:
        dest, width, center = 0x9864, 12, True
        native = set(range(0x68, 0x7B))
    elif message in (0x29, 0x3C):
        # Keep the kana tiles used by the separately displayed password.
        native = native - JP_PASSWORD_TILES
        width = 16
    elif 0x20 <= message <= 0x4A:
        width = 16
    elif message in (0x1A, 0x1B):
        width = 6
        native = set(range(0x71, 0x7E)) - NATIVE_TILES
    elif message == 0x19:
        width = 8
        native = set(range(0x46, 0x56))
    elif message == 0x69:
        native = set(range(0x27, 0x46)) - NATIVE_TILES - {0x3D}
        width = 12
    elif message == 0x6A:
        native = set(range(0x56, 0x71))
        width = 12
    elif 0x1C <= message <= 0x1F:
        dest, width = dest + 0x20, 14
    elif message in (0x14, 0x4C):
        native = set(range(0x57, 0x7B)) - {0x57, 0x5A, 0x5F}
        width, center = 4, True
    elif message in MINIGAME_HUD_MESSAGES:
        # Align the waiting prompt and countdown with the TIME column.
        dest, width, center = 0x9A26, 8, True
        native = set(range(0x31, 0x57)) - {0x40, 0x43, 0x45}
    elif message == 0x4D:
        width, center = 8, True
        native = set(range(0x31, 0x57)) - {0x40, 0x43, 0x45}
    elif message == 0x67:
        width = 11
        native = native | set(range(0x81, 0xF0))
    elif 0x4E <= message <= 0x59:
        width = 20 - (dest & 31) - 1
    elif message == 0x68:
        width = 12
    if message < 0x0D or message == 0x68:
        native = native - {0x05, 0x14, 0x1D, 0x2A, 0x57, 0x5A, 0x5F}
        if message not in (9, 10, 11):
            native = native - set(range(0x10, 0x30))
    if 0x20 <= message <= 0x4A and message not in (0x29, 0x3C):
        # Reserve kana needed by the password on the following page.
        native = (native - JP_PASSWORD_TILES) | set(range(0xA0, 0xD0))
    return dest, width, sorted(native), center


def stage_line_limit(message):
    if message in STORY_MESSAGES:
        return 5
    if message in PASSWORD_MESSAGES:
        return 2
    if message in STAGE_DIALOGUE_MESSAGES:
        return 4
    return None


def stage_line_width(message, width, index):
    # The dialogue cursor replaces the last tile on the fourth line.
    return width - 1 if message in STAGE_DIALOGUE_MESSAGES and index == 3 else width


def message_rows(message, lines, width, center, glyphs):
    if message in BONUS_BOX_MESSAGES:
        # Pack two 10px lines 12px apart in the box's three interior tile rows.
        assert 1 <= len(lines) <= 2
        _, first = draw_line(lines[0], width, glyphs, center=True, top_offset=1)
        if len(lines) == 1:
            yield width, first, False, None
            return
        _, second = draw_line(lines[1], width, glyphs, center=True, top_offset=5)
        shared = [bytes(a | b for a, b in zip(lower, upper, strict=True))
                  for lower, upper in zip(first[width:], second[:width], strict=True)]
        yield width, first[:width] + shared, False, None
        # The renderer writes pairs of rows. Copy the native bottom edge into the last row.
        tilemap = (SOURCE / "maps/bonus.bin").read_bytes()
        bottom_edge = list(tilemap[8 * 20 + 3:8 * 20 + 3 + width])
        yield width, second[width:] + bottom_edge, False, None
        return

    limit = stage_line_limit(message)
    if limit is not None and lines[limit:] not in ([], ["!"]):
        raise ValueError(f"對話框最多容納 {limit} 行文字")
    for index, text in enumerate(lines):
        control = text.startswith("!")
        text = text.removeprefix("!")
        glyph_ends = [] if message in TYPEWRITER_MESSAGES else None
        assert glyph_ends is None or not center
        cols, pixels = draw_line(text, stage_line_width(message, width, index), glyphs,
                                 center=center, glyph_ends=glyph_ends)
        if message in MINIGAME_HUD_MESSAGES:
            # Both minigames put a one-pixel rule at the top of this row.
            pixels[:cols] = [b"\xff" + tile[1:] for tile in pixels[:cols]]
        if message == 0x0F:
            # The scene-test cursor updates the original one-tile numbers in column 13.
            top = pixels[:cols] + [0] * (width + 1 - cols)
            bottom = pixels[cols:] + [0] * (width - cols) + [0x05]
            pixels = top + bottom
            cols = width + 1
        yield cols, pixels, control, glyph_ends


def encode_message(message, lines, width, pool, center, glyphs):
    result = bytearray()
    used = {}
    frontier = {}
    erase = message in CREDIT_MESSAGES
    for index, (cols, pixels, control, glyph_ends) in enumerate(message_rows(message, lines, width, center, glyphs)):
        if message == 0x67:
            used = {key: val for key, val in used.items() if index - val[1] < 11}
        if not erase:
            frontier.clear()
        pending = []
        occupied = {entry[0] for entry in used.values()} | set(frontier.values())
        blank = 1 if message == 0x67 else 0

        def tile_id_for(tile, *, temporary=False):
            if isinstance(tile, int):
                return tile
            if not any(tile):
                return blank
            if tile in used:
                tile_id = used[tile][0]
                used[tile] = tile_id, index
                return tile_id
            if tile in frontier:
                return frontier[tile]
            tile_id = next((i for i in pool if i not in occupied), None)
            if tile_id is None:
                raise ValueError(f"message {message:02X} row {index+1}: used all {len(pool)} tiles")
            occupied.add(tile_id)
            pending.extend((tile_id, *tile))
            if temporary:
                frontier[tile] = tile_id
            else:
                used[tile] = tile_id, index
            return tile_id

        ids = [tile_id_for(tile) for tile in pixels]

        def glyph_updates(clearing):
            steps = bytearray()
            previous_end = 0
            for end in glyph_ends:
                first, last = previous_end // 8, (end - 1) // 8
                count = last - first + 1
                assert 1 <= count <= 3
                step = bytearray((first, count))
                for row in (0, cols):
                    step.extend([blank] * (count - 1) if clearing else ids[row + first:row + last])
                    last_tile = pixels[row + last]
                    if clearing or end % 8:
                        # Keep the unrevealed glyphs out of the last tile, or retain the next glyph when erasing.
                        left_mask = (0xFF << (8 - end % 8) & 0xFF) if end % 8 else 0xFF
                        mask = 0xFF ^ left_mask if clearing else left_mask
                        last_tile = bytes(bits & mask for bits in last_tile)
                    step.append(tile_id_for(last_tile, temporary=True))
                steps.extend(step.ljust(8, b"\x00"))
                previous_end = end
            return steps

        steps = bytearray()
        if glyph_ends is not None:
            steps = glyph_updates(False)
            if erase:
                # Credits are read a second time to erase them. Reserve their partial tiles across the whole page.
                steps.extend(glyph_updates(True))
            assert len(steps) < 256

        result.extend((cols | (0x80 if control else 0) | (0x40 if blank or erase else 0)
                       | (0x20 if glyph_ends is not None else 0),
                       *ids, len(pending) // 9, *pending))
        if glyph_ends is not None:
            result.extend((len(glyph_ends), *steps))
    return bytes(result) + b"\xff"


def title_tile(pixels):
    return bytes(sum((row[x] >> plane & 1) << (7 - x) for x in range(8))
                 for row in pixels for plane in (0, 1))


def title_sgb_shade(color, x, y):
    if color == "_":
        return 0
    if x >= 136:
        return 3 if color == "B" else 1
    if color == "O":
        return 1 + ((x + y) & 1)
    if color == "G":
        return 2 + ((x + y) & 1)
    return {"D": 3, "K": 3, "P": 1, "Y": 2}[color]


def compile_title_logo(output, titlemap):
    logo = json.loads((TEXT / "title-logo.json").read_text(encoding="utf-8"))
    pixels = logo["pixels"]
    palettes = logo["bg_palettes"]
    obj_palettes = logo["obj_palettes"]
    # Palette 2 stays with the original subtitle and copyright. Actors use OBJ 1 and 2.
    bg_slots = (0, 1, 3, 4, 5, 6, 7)
    assert len(palettes) == len(bg_slots) and len(obj_palettes) == 2
    assert palettes[0][0] == palettes[1][0] == "_"
    assert len(pixels) == 40 and all(len(row) == 160 for row in pixels)
    assert len(logo["bg_map"]) == 5 and all(len(row) == 20 for row in logo["bg_map"])
    chunks = (range(0x90, 0xC0), range(0xEC, 0x100), range(0x67, 0x80))
    slots = [i for chunk in chunks for i in chunk]
    assert not set(slots).intersection(titlemap[100:])
    fallback = {bytes(16): 0}
    missing = {}
    bg_tiles = bytearray()
    bg_attrs = bytearray()
    for row in range(5):
        for col, palette_id in enumerate(logo["bg_map"][row]):
            top, left = 8 * row, 8 * col
            palette = palettes[palette_id]
            bg_pixels = []
            for y in range(top, top + 8):
                bg_row = []
                for x in range(left, left + 8):
                    color = pixels[y][x]
                    if color in palette:
                        bg_row.append(palette.index(color))
                    else:
                        missing[x, y] = color
                        bg_row.append(0)
                bg_pixels.append(bg_row)
            bg_tiles.extend(title_tile(bg_pixels))
            bg_attrs.append(8 | bg_slots[palette_id])
            tile = title_tile([[title_sgb_shade(pixels[y][x], x, y) for x in range(left, left + 8)]
                               for y in range(top, top + 8)])
            if tile not in fallback:
                assert len(fallback) <= len(slots), "Title logo exceeds the free GB background tiles"
                fallback[tile] = slots[len(fallback) - 1]
            titlemap[row * 20 + col] = fallback[tile]
        bg_attrs.extend(bytes(12))

    obj_tiles = bytearray()
    parts = bytearray()
    assert len(logo["sprites"]) <= 16
    assert all(sum(y <= line < y + 8 for _, y, _ in logo["sprites"]) <= 10 for line in range(40))
    for index, (left, top, palette_id) in enumerate(logo["sprites"]):
        palette = obj_palettes[palette_id]
        part = []
        for y in range(top, top + 8):
            row = []
            for x in range(left, left + 8):
                color = missing.get((x, y))
                row.append(1 + palette.index(missing.pop((x, y))) if color is not None and color in palette else 0)
            part.append(row)
        obj_tiles.extend(title_tile(part))
        parts.extend((top, left, index, 8 | (6 + palette_id)))
    assert not missing

    colors = {symbol: tuple(v >> 3 for v in bytes.fromhex(rgb)) for symbol, rgb in logo["colors"].items()}
    palette_bytes = bytearray()
    for level in range(4):
        block = bytearray()
        for symbol in "".join(palettes) + "".join("_" + p for p in obj_palettes):
            channels = ((base * (3 - level) + color * level + 1) // 3
                        for base, color in zip(colors["_"], colors[symbol], strict=True))
            block.extend(pack("<H", sum(v << (5 * i) for i, v in enumerate(channels))))
        palette_bytes.extend(block.ljust(128, b"\x00"))

    fallback_tiles = {i: tile for tile, i in fallback.items()}
    (output / "zh_title_logo_gb.2bpp").write_bytes(b"".join(fallback_tiles.get(i, bytes(16)) for i in slots))
    (output / "zh_title_logo_cgb.2bpp").write_bytes(bg_tiles)
    (output / "zh_title_logo_obj.2bpp").write_bytes(obj_tiles)
    (output / "zh_title_logo.oam").write_bytes(parts + b"\x80")
    (output / "zh_title_logo.attrs").write_bytes(bg_attrs)
    (output / "zh_title_logo.palettes").write_bytes(palette_bytes)


def compile_fixed_screens(output, glyphs):
    def rows(text, width, tiles, first_id, upper=bytes(16), *, top_offset=3):
        _, masks = draw_line(text, width, glyphs, center=True, top_offset=top_offset)
        indices = bytearray()
        for i, mask in enumerate(masks):
            edge = upper if i < width else bytes(16)
            data = bytes(edge[j] | mask[j // 2] for j in range(16))
            if data == edge:
                indices.append(0x92 if any(edge) else 0)
            else:
                if data not in tiles:
                    tiles[data] = first_id + len(tiles)
                indices.append(tiles[data])
        return indices

    native_symbols = (output / "assets/b06_50c4.bin").read_bytes()
    border = native_symbols[0x20:0x30]
    password = {}
    headers = [rows(text, 10, password, 0x46, border) for text in PASSWORD_PROMPTS]
    assert max(password.values()) <= 0x7A
    (output / "zh_password.2bpp").write_bytes(b"".join(password))
    (output / "zh_password.tilemap").write_bytes(b"".join(headers))

    title = {}
    tilemap = bytearray((SOURCE / "maps/title.bin").read_bytes())
    header = rows(TITLE_SUBTITLE, 15, title, 0x50, top_offset=0)
    for i in range(2):
        start = (5 + i) * 20 + 2
        tilemap[start:start + 15] = header[i * 15:(i + 1) * 15]
    assert max(title.values()) < 0x67
    compile_title_logo(output, tilemap)
    (output / "zh_title.2bpp").write_bytes(b"".join(title))
    (output / "zh_title.tilemap").write_bytes(tilemap)

    bonus = {}
    tilemap = bytearray((SOURCE / "maps/bonus.bin").read_bytes())
    header = rows(BONUS_HEADER, 14, bonus, 0x10)
    for i in range(2):
        start = (i + 1) * 20 + 3
        tilemap[start:start + 14] = header[i * 14:(i + 1) * 14]
    level = bytearray()
    for shift in (8, 0):
        tile = bytes(plane for row in BONUS_LEVEL_LABEL for plane in ((row >> shift & 255),) * 2)
        bonus.setdefault(tile, 0x10 + len(bonus))
        level.append(bonus[tile])
    for x in (3, 8, 13):
        start = 11 * 20 + x
        tilemap[start:start + 2] = level
    assert max(bonus.values()) <= 0x2F
    (output / "zh_bonus.2bpp").write_bytes(b"".join(bonus))
    (output / "zh_bonus.tilemap").write_bytes(tilemap)


def message_destinations():
    native = (SOURCE / "data/messages.asm").read_text(encoding="utf-8")
    descriptors = [
        (0x9C00 if screen == "1" else 0x9800) + int(offset, 16)
        for screen, offset in re.findall(r"dw _SCRN([01]) \+ \$([0-9a-f]+),", native)
    ]
    assert len(descriptors) == 0x6B
    return descriptors


def compile_message_data(messages, glyphs):
    pointers = bytearray()
    lookup = bytearray()
    banks: list[bytearray] = [bytearray()]
    records = {}
    for message, dest in enumerate(message_destinations()):
        dest, width, pool, center = layout(message, dest)
        lines = messages[message]
        dynamic = any("{n}" in line for line in lines)
        pointers.extend(pack("<H", len(lookup)))
        lookup.extend(pack("<HB", dest, dynamic))
        for value in (VARIABLES if dynamic else (None,)):
            if dynamic:
                substitution = max(value, 11) if message in (6, 0x68) else min(value, 10)
                text = [line.replace("{n}", VARIABLES[substitution]) for line in lines]
            else:
                text = lines
            try:
                record = encode_message(message, text, width, pool, center, glyphs)
            except (KeyError, ValueError) as exc:
                raise ValueError(f"message {message:02X}: {exc}") from exc
            if record not in records:
                if len(banks[-1]) + len(record) > 0x3F00:
                    banks.append(bytearray())
                records[record] = 10 + len(banks) - 1, len(banks[-1])
                banks[-1].extend(record)
            bank, offset = records[record]
            lookup.extend(pack("<BH", bank, 0x4100 + offset))
    if len(banks) > 6:
        raise ValueError("Traditional Chinese messages exceed the six text banks")
    return pointers + lookup, banks


def compile_text(output: Path) -> None:
    glyphs = read_glyphs()
    descriptors, banks = compile_message_data(read_messages(), glyphs)
    output.mkdir(parents=True, exist_ok=True)
    compile_fixed_screens(output, glyphs)
    attrs = bytearray((SOURCE / "sgb/border_tilemap.bin").read_bytes())
    # Extend the SGB title colors to row 4, then the subtitle colors to row 6.
    attrs[90 + 4 * 5:90 + 5 * 5] = attrs[90:90 + 5]
    attrs[90 + 6 * 5:90 + 7 * 5] = attrs[90 + 5 * 5:90 + 6 * 5]
    # Dialogue boxes start one tile higher in zh-TW. Extend the frame palette to that row.
    for file_index in range(0x07, 0x0E):
        top = file_index * 90
        attrs[top:top + 5] = attrs[top + 5:top + 10]
    (output / "zh_sgb_attrs.bin").write_bytes(attrs)
    (output / "zh_sgb_attrs.rle").write_bytes(encode_prev(attrs))
    (output / "zh_descriptors.bin").write_bytes(descriptors)
    for bank, data in enumerate(banks + [b""] * (6 - len(banks)), 10):
        (output / f"zh_data_{bank}.bin").write_bytes(data)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Update the glyph subset from the pinned Fusion Pixel Font release.")
    parser.add_argument("font_archive", type=Path)
    args = parser.parse_args()
    try:
        rebuild_glyphs(args.font_archive)
    except (OSError, ValueError) as exc:
        parser.exit(1, f"{exc}\n")
