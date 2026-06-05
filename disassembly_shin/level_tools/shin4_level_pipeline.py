#!/usr/bin/env python3
"""Shin-chan 4 clean level asset pipeline (v14).

Root-cause fix compared with the previous draft:
  * Do not hardcode stage init/layout/metatile/spawn pointer addresses per stage.
  * Read the same pointer tables that the game code reads:
      bank1:$40af  collision table pointers
      bank1:$40b9  metatile quad table pointers
      bank1:$40c3  stage init block pointers
      bank1:$423c  layout RLE pointers
      bank1:$4b24  spawn list pointers
  * Then slice page_table.bin from init_block[0x08:0x4e].

If this still reports a bad page table, the ROM file being passed does not match
this disassembly. Run the probe command to dump the exact ROM bytes at the
source tables.

V4 adds a real-ish offline stage renderer. V5 adds stage-specific VRAM variants.
V6 adds camera/world-X range based composite rendering, so one stage image can use
multiple VRAM/metatile profiles across different horizontal ranges.

V8 adds ROM-derived stage event analysis. V9 corrects Stage 2 analysis: the switch is a state-machine transition, not a direct X split. It scans the decoded world map through
the stage collision-attribute table to find metatiles that enter special stage
interaction states, especially stage2 tiles that drive tileset/metatile switches.
"""
from __future__ import annotations

import argparse
import binascii
import csv
import json
import struct
import xml.etree.ElementTree as ET
import sys
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

STAGE_COUNT = 5
PAGE_W = 16
PAGE_H = 16
PAGE_SIZE = PAGE_W * PAGE_H
PAGE_COLS = 14
MAX_PAGE_ROWS = 5
FULL_PAGE_TABLE_SIZE = PAGE_COLS * MAX_PAGE_ROWS  # 0x46
INIT_BLOCK_SIZE = 0x4E
PAGE_TABLE_OFFSET = 0x08
SPAWN_RECORD_SIZE = 5
SPAWN_END = 0xFF

# Pointer tables used by the game code in bank1.
BANK_STAGE_TABLES = 1
COLLISION_PTR_TABLE = 0x40AF
METATILE_PTR_TABLE = 0x40B9
INIT_BLOCK_PTR_TABLE = 0x40C3
LAYOUT_RLE_PTR_TABLE = 0x423C
SPAWN_PTR_TABLE = 0x4B24
GFX_SCRIPT_PTR_TABLE = 0x4286

# ROM bank containing layout/metatile/collision data.
LEVEL_DATA_BANK = 4
SPAWN_BANK = 1
INIT_BANK = 1

# The code special-cases stage 3 layout load: hl=$6b77, bc=$1100.
STAGE3_SPECIAL_LAYOUT_PTR = 0x6B77
LAYOUT_DECODED_SIZES = [0x0E00, 0x0E00, 0x0E00, 0x1100, 0x0100]
STAGE_PAGE_COLS = [PAGE_COLS, PAGE_COLS, PAGE_COLS, PAGE_COLS, 1]

# GB LCD is 160x144, but this game places the Window/HUD at WY=$80.
# Camera gameplay coverage should therefore use only the visible playfield
# height ($80), not the full LCD height ($90). The bottom $10 pixels are HUD.
LCD_VIEWPORT_W = 0xA0
LCD_VIEWPORT_H = 0x90
GAMEPLAY_VIEWPORT_H = 0x80
HUD_HEIGHT = LCD_VIEWPORT_H - GAMEPLAY_VIEWPORT_H
HUD_START_Y = GAMEPLAY_VIEWPORT_H

# Known hard end points used only to determine source ranges.
# Stage4 layout ends where collision attr blob begins.
COLLISION_ATTR_BLOB_START = 0x7632
COLLISION_ATTR_BLOB_END = 0x7ABA
# Stage4 spawn list is short and ends before title/demo data. The terminator is
# included by scanning from the pointer, so this is only a safety cap.
SPAWN_SCAN_END = 0x7C00

# VRAM reconstruction used by Call_001_425e.
VRAM_BASE = 0x8000
VRAM_SIZE = 0x2000
COMMON_GFX_COPIES = [
    (5, 0x4001, 0x8000, 0x0130),
    (5, 0x5701, 0x8D00, 0x0300),
]

# Extra graphics copies performed outside Call_001_425e by stage-specific
# init/re-entry code. Stage 1 uses $c0b4 as a sub-area/checkpoint selector:
#   c0b4=0: initial tileset
#   c0b4=1: same VRAM as initial, different camera/player bounds
#   c0b4=2: copies bank7:$4ee1 -> VRAM $91a0, size $0480 before setting bounds
# See bank1:jr_001_4408 around $4430.
STAGE_VRAM_VARIANT_OVERLAYS = {
    # Stage 1 second-half/c0b4=2 overlay.
    (1, 2): [(7, 0x4EE1, 0x91A0, 0x0480)],
    # Stage 2 checkpoint/special-area overlay from Call_001_43e1.
    # The game loads this with A=$04, HL=$3572, but HL is in the fixed
    # $0000-$3fff window.  BankedMemcpy switches the ROMX window only; the
    # actual CPU read source remains bank0:$3572.
    (2, 1): [(0, 0x3572, 0x9450, 0x0390), (5, 0x6411, 0x8C00, 0x00D0)],
    # Stage 2 transition-complete/after-switch VRAM state.  bank1:Call_001_56c2
    # streams tiles into $9450 from bank0:$3572 when c0b3==2, otherwise from
    # bank0:$3902.  The c0b3==5 path also switches hStageMetatileTable to
    # bank4:$4a31 and patches collision attrs, so the editor after_switch
    # profile needs the $3902 graphics state, not the checkpoint $3572 state.
    (2, 3): [(0, 0x3902, 0x9450, 0x03B0), (5, 0x6411, 0x8C00, 0x00D0)],
}

# Optional metatile table overrides for render profiles. Stage 2 has a later
# interaction path that points hStageMetatileTable to bank4:$4a31. Keep this as
# a profile option so the renderer can switch metatile interpretation by range
# without changing extracted layout data.
STAGE_METATILE_VARIANT_PTRS = {
    (2, 2): 0x4A31,
}

# Built-in horizontal render ranges. Coordinates are world/camera X pixels on the
# output stage image. end=None means to the rendered stage width.
# Stage1 c0b4=2 starts with SCX=$0900 in the known init record at bank1:$449f.
BUILTIN_RANGE_PROFILES = {
    1: [
        {"start": 0x0000, "end": 0x0900, "vram_variant": 0, "metatile_variant": 0, "name": "stage1_front"},
        {"start": 0x0900, "end": None,   "vram_variant": 2, "metatile_variant": 0, "name": "stage1_back_c0b4_2"},
    ],
}

DMG_PALETTE_LIGHT_TO_DARK = (255, 170, 85, 0)
DMG_PALETTE_GREENISH = (224, 248, 208, 52)  # rough display-friendly fallback, optional only


def stage_page_cols(stage_index: int) -> int:
    if 0 <= stage_index < len(STAGE_PAGE_COLS):
        return STAGE_PAGE_COLS[stage_index]
    return PAGE_COLS



# Editor/render profiles. A profile describes how the same world_map.raw should be
# interpreted visually: VRAM overlay, metatile table override, and optionally a
# collision variant for debug overlays/future editor UI.
STAGE_PROFILE_DEFS = {
    0: {
        "default": "normal",
        "profiles": {
            "normal": {"label": "Normal", "vram_variant": 0, "metatile_variant": 0, "collision_variant": 0},
        },
    },
    1: {
        "default": "normal",
        "profiles": {
            "normal": {"label": "Normal / c0b4=0 or 1", "vram_variant": 0, "metatile_variant": 0, "collision_variant": 0},
            "after_checkpoint2": {"label": "Late / c0b4>=2, bank7:$4ee1 overlay", "vram_variant": 2, "metatile_variant": 0, "collision_variant": 0},
        },
    },
    2: {
        "default": "initial",
        "profiles": {
            "initial": {"label": "Initial", "vram_variant": 0, "metatile_variant": 0, "collision_variant": 0},
            "checkpoint": {"label": "Checkpoint/resume", "vram_variant": 1, "metatile_variant": 0, "collision_variant": 0},
            "after_switch": {"label": "After switch / c0b3==5", "vram_variant": 3, "metatile_variant": 2, "collision_variant": 1},
        },
    },
    3: {
        "default": "normal",
        "profiles": {
            "normal": {"label": "Normal", "vram_variant": 0, "metatile_variant": 0, "collision_variant": 0},
        },
    },
    4: {
        "default": "normal",
        "profiles": {
            "normal": {"label": "Normal", "vram_variant": 0, "metatile_variant": 0, "collision_variant": 0},
        },
    },
}


# Tiled visual object profiles.
#
# Spawn records store the game's logical object origin. That origin is not always
# the same as the visible sprite box in an editor. These offsets are applied only
# when exporting/importing Tiled object layers:
#
#   tiled_x = spawn_x + display_offset_x
#   tiled_y = spawn_y + display_offset_y
#
# and reversed on import. The ROM spawn coordinates remain unchanged.
# Unknown object types use a conservative 16x16 box at the raw origin.
OBJECT_PROFILES = {
    # Enemy-like actors. These use 16x24 visual boxes so Tiled does not stretch
    # their idle-frame icons vertically. The ROM origin is near the lower center.
    0x0A: {"name": "OBJ_ENEMY_WALKING_KID", "display_offset_x": -8, "display_offset_y": -24, "width": 16, "height": 24},
    0x0B: {"name": "OBJ_ENEMY_PARTY_HORN_KID", "display_offset_x": -8, "display_offset_y": -24, "width": 16, "height": 24},
    0x0C: {"name": "OBJ_ENEMY_UMBRELLA_KID", "display_offset_x": -8, "display_offset_y": -24, "width": 16, "height": 24},
    0x0D: {"name": "OBJ_ENEMY_PAPER_AIRPLANE_KID", "display_offset_x": -8, "display_offset_y": -24, "width": 16, "height": 24},
    0x0E: {"name": "OBJ_ENEMY_PAPER_AIRPLANE", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x0F: {"name": "OBJ_ENEMY_PROJECTILE_B", "display_offset_x": -8, "display_offset_y": -16, "width": 16, "height": 16},

    # Stage-specific actors/events verified in stage3.
    0x08: {"name": "OBJ_STAGE3_FLOATING_BEACH_BALL", "display_offset_x": -8, "display_offset_y": -16, "width": 16, "height": 16},
    0x23: {"name": "OBJ_STAGE3_FALLING_COCONUT", "display_offset_x": -8, "display_offset_y": -16, "width": 16, "height": 16},

    # Pickups. These are drawn around a logical center-ish origin, so use a
    # 16x16 visual box shifted half a metatile up-left for Tiled.
    0x10: {"name": "OBJ_PICKUP_BONUS_COUNTER", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x11: {"name": "OBJ_PICKUP_BONUS_COUNTER_ANIM", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x12: {"name": "OBJ_PICKUP_EXTRA_LIFE", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x13: {"name": "OBJ_PICKUP_EXTRA_LIFE_ANIM", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x14: {"name": "OBJ_PICKUP_HEALTH", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x15: {"name": "OBJ_PICKUP_HEALTH_ANIM", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x16: {"name": "OBJ_FORM_FLYING_SQUIRREL", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x17: {"name": "OBJ_FORM_COCKROACH", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x18: {"name": "OBJ_FORM_CHICKEN", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},
    0x19: {"name": "OBJ_FORM_ACTION_KAMEN", "display_offset_x": -8, "display_offset_y": -8, "width": 16, "height": 16},

    # Platforms: keep mostly raw for now, but give boxes closer to the visible
    # footprint. These can be refined as each type is verified against BGB.
    0x1A: {"name": "OBJ_PLATFORM_MOVING_VERTICAL_A", "display_offset_x": -16, "display_offset_y": -8, "width": 32, "height": 16},
    0x1B: {"name": "OBJ_PLATFORM_MOVING_VERTICAL_B", "display_offset_x": -16, "display_offset_y": -8, "width": 32, "height": 16},
    0x1C: {"name": "OBJ_PLATFORM_DROP_A", "display_offset_x": -16, "display_offset_y": -8, "width": 32, "height": 16},
    0x1D: {"name": "OBJ_PLATFORM_BOUNCE_PAD", "display_offset_x": -8, "display_offset_y": -16, "width": 16, "height": 16},
    0x1E: {"name": "OBJ_PLATFORM_DROP_B", "display_offset_x": -16, "display_offset_y": -8, "width": 32, "height": 16},
    0x22: {"name": "OBJ_PLATFORM_MOVING_HORIZONTAL", "display_offset_x": -16, "display_offset_y": -8, "width": 32, "height": 16},
}

DEFAULT_OBJECT_PROFILE = {"name": "OBJ_UNKNOWN", "display_offset_x": 0, "display_offset_y": 0, "width": 16, "height": 16}

# Spawn object types that are better shown as stage/event controllers than as
# ordinary enemies/items. They still import/export through the same ROM spawn
# list; this is an editor-only layer split to reduce confusion in Tiled.
STAGE_EVENT_OBJECT_TYPES = {0x06, 0x07, 0x08, 0x1F, 0x20, 0x23}

# Optional editor-only sprite icon support for Tiled object layers.
# Values are bank0 metasprite pointers used by the normal object draw path.
# Unsupported object types still export as normal rectangles, so import remains safe.
OBJECT_METASPRITE_PTRS = {
    0x08: 0x2486,  # stage3 floating beach ball
    0x23: 0x2475,  # stage3 falling coconut
    0x10: 0x2C85,  # bonus counter
    0x11: 0x2C85,
    0x12: 0x2C9F,  # extra life
    0x13: 0x2C9F,
    0x14: 0x2C8E,  # health
    0x15: 0x2C8E,
    0x16: 0x2C41,  # flying squirrel form
    0x17: 0x2C74,  # cockroach form
    0x18: 0x2C63,  # chicken form
    0x19: 0x2C52,  # Action Kamen form
    0x1A: 0x70DE,  # moving platform vertical A
    0x1B: 0x70DE,  # moving platform vertical B
    0x1C: 0x70BB,  # drop platform A, bank1 data but same metasprite format
    0x1D: 0x70C4,  # bounce pad idle
    0x1E: 0x70BB,
    0x22: 0x21CE,  # horizontal moving platform
}

# Enemy/object idle preview icons that are normally selected through
# Jump_001_4c06: bank0:$1b25 stage object-animation pointer table + animation id.
OBJECT_ANIM_IDS = {
    0x0A: 0x00,  # walking kid idle
    0x0B: 0x06,  # party-horn kid idle
    # Umbrella kid does not use the same first-frame convention as the normal
    # walking enemy.  The update routine can select $0f for the visible umbrella
    # frame, so prefer that for editor previews and keep $0c-$0e as fallbacks.
    0x0C: 0x0F,  # umbrella kid idle/open-umbrella preview
    0x0D: 0x00,  # paper-airplane kid idle
    0x0E: 0x04,  # paper airplane projectile
    0x0F: 0x10,  # projectile B / child object preview
}

# Optional per-object animation candidates for editor icons.  These are used only
# for preview generation; the ROM object data is not affected.  The first
# candidate that resolves to a non-empty metasprite in the current/fallback stage
# is used.

# Editor-only preview stage priority.  Some enemy metasprites are paired with
# stage-specific OBJ graphics; if a type is visible/correct in one stage but
# blank or wrong in another, prefer the known-good preview context.
# This does not affect imported spawn data.
OBJECT_PREVIEW_STAGE_PRIORITY = {
    # Stage3-specific actors need the stage3 OBJ graphics context for icon previews.
    0x08: [3],
    0x23: [3],

    # Party-horn kid preview should reuse the stage3-known-good context first.
    # Stage0/stage1 can contain compatible spawn type but a misleading local
    # preview frame/OBJ context, so keep the stage3 idle sequence as canonical.
    0x0B: [3, 0, 1, 2],
}

OBJECT_ANIM_ID_CANDIDATES = {
    0x0A: [0x00, 0x01, 0x02, 0x03],
    0x0B: [0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B],
    # Umbrella kid idle uses the walking-table sequence at $64fb: $0c,$0d,$0c,$0e.
    # $0f is selected by the hit/bounce states and was a bad editor preview.
    0x0C: [0x0C, 0x0D, 0x0E, 0x0F],
    0x0D: [0x00, 0x01, 0x02, 0x03],
    0x0E: [0x04, 0x05],
    0x0F: [0x10, 0x0F],
}


def object_profile_for_type(typ: int) -> dict[str, int | str]:
    base = dict(DEFAULT_OBJECT_PROFILE)
    base.update(OBJECT_PROFILES.get(typ & 0x7F, {}))
    return base


def write_object_profiles_json(path: Path, overrides: dict[int, tuple[int, int, int, int]] | None = None) -> None:
    profiles = {k: dict(v) for k, v in OBJECT_PROFILES.items()}
    if overrides:
        for typ, (dx, dy, width, height) in overrides.items():
            typ &= 0x7F
            cur = dict(profiles.get(typ, object_profile_for_type(typ)))
            cur["display_offset_x"] = dx
            cur["display_offset_y"] = dy
            cur["width"] = width
            cur["height"] = height
            profiles[typ] = cur
    serializable = {f"0x{k:02x}": v for k, v in sorted(profiles.items())}
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(serializable, indent=2) + "\n", encoding="utf-8")


def _parse_object_profile_key(key: str) -> int:
    k = str(key).strip().lower()
    if k.startswith("0x"):
        return int(k, 16) & 0x7F
    return int(k, 0) & 0x7F


def load_object_profiles_json(path: Path, merge_defaults: bool = True) -> dict[int, dict[str, int | str]]:
    """Load an editable object profile JSON.

    The file may use keys like "0x14" or "20". Values override the built-in
    defaults per object type. This is intentionally editor-side only; it does not
    change ROM data or spawn record format.
    """
    if not path.exists():
        raise FileNotFoundError(path)
    raw = json.loads(path.read_text(encoding="utf-8"))
    base: dict[int, dict[str, int | str]] = {k: dict(v) for k, v in OBJECT_PROFILES.items()} if merge_defaults else {}
    for key, value in raw.items():
        typ = _parse_object_profile_key(key)
        cur = dict(base.get(typ, {}))
        if not isinstance(value, dict):
            raise ValueError(f"object profile {key!r} must be an object")
        cur.update(value)
        base[typ] = cur
    return base


def apply_object_profiles_json(path: Path) -> None:
    OBJECT_PROFILES.clear()
    OBJECT_PROFILES.update(load_object_profiles_json(path, merge_defaults=True))


@dataclass(frozen=True)
class StageAssets:
    index: int
    collision_ptr: int
    metatile_ptr: int
    metatile_end: int
    init_ptr: int
    layout_ptr: int
    layout_end: int
    layout_decoded_size: int
    spawn_ptr: int
    spawn_end: int
    gfx_script_ptr: int


@dataclass(frozen=True)
class RenderRangeProfile:
    start: int
    end: int | None
    vram_variant: int = 0
    metatile_variant: int = 0
    name: str = ""


def rom_offset(bank: int, addr: int) -> int:
    if bank == 0:
        if not 0 <= addr < 0x4000:
            raise ValueError(f"bank0 address out of range: ${addr:04x}")
        return addr
    if not 0x4000 <= addr < 0x8000:
        raise ValueError(f"ROMX address out of range: bank={bank} addr=${addr:04x}")
    return bank * 0x4000 + (addr - 0x4000)


def slice_rom(rom: bytes, bank: int, start: int, end: int) -> bytes:
    if end < start:
        raise ValueError(f"negative range bank{bank}:${start:04x}-${end:04x}")
    off = rom_offset(bank, start)
    size = end - start
    data = rom[off:off + size]
    if len(data) != size:
        raise ValueError(
            f"ROM too small: bank {bank} ${start:04x}-${end - 1:04x} needs 0x{size:x} bytes"
        )
    return data


def read_u16(rom: bytes, bank: int, addr: int) -> int:
    b = slice_rom(rom, bank, addr, addr + 2)
    return b[0] | (b[1] << 8)


def read_ptr_table(rom: bytes, addr: int, count: int = STAGE_COUNT) -> list[int]:
    return [read_u16(rom, BANK_STAGE_TABLES, addr + i * 2) for i in range(count)]


def scan_spawn_end(rom: bytes, start: int, safety_end: int = SPAWN_SCAN_END) -> int:
    """Return exclusive end address including the 0xff terminator."""
    addr = start
    while addr < safety_end:
        first = slice_rom(rom, SPAWN_BANK, addr, addr + 1)[0]
        if first == SPAWN_END:
            return addr + 1
        addr += SPAWN_RECORD_SIZE
    raise ValueError(f"spawn list at ${start:04x} did not terminate before ${safety_end:04x}")


def load_stage_assets(rom: bytes) -> list[StageAssets]:
    collision_ptrs = read_ptr_table(rom, COLLISION_PTR_TABLE)
    metatile_ptrs = read_ptr_table(rom, METATILE_PTR_TABLE)
    init_ptrs = read_ptr_table(rom, INIT_BLOCK_PTR_TABLE)
    layout_ptrs = read_ptr_table(rom, LAYOUT_RLE_PTR_TABLE)
    spawn_ptrs = read_ptr_table(rom, SPAWN_PTR_TABLE)
    gfx_script_ptrs = read_ptr_table(rom, GFX_SCRIPT_PTR_TABLE)

    # The game code hardcodes stage3 layout source to $6b77. It matches the
    # table in the currently known ROM, but assign explicitly to mirror code.
    layout_ptrs[3] = STAGE3_SPECIAL_LAYOUT_PTR

    stages: list[StageAssets] = []
    for i in range(STAGE_COUNT):
        metatile_end = metatile_ptrs[i + 1] if i + 1 < STAGE_COUNT else layout_ptrs[0]
        if i < STAGE_COUNT - 1:
            # Source stream range is from this layout pointer to next stage's
            # pointer. Stage2 naturally ends at stage3 special pointer.
            layout_end = layout_ptrs[i + 1]
        else:
            layout_end = COLLISION_ATTR_BLOB_START
        spawn_end = scan_spawn_end(rom, spawn_ptrs[i])
        stages.append(StageAssets(
            index=i,
            collision_ptr=collision_ptrs[i],
            metatile_ptr=metatile_ptrs[i],
            metatile_end=metatile_end,
            init_ptr=init_ptrs[i],
            layout_ptr=layout_ptrs[i],
            layout_end=layout_end,
            layout_decoded_size=LAYOUT_DECODED_SIZES[i],
            spawn_ptr=spawn_ptrs[i],
            spawn_end=spawn_end,
            gfx_script_ptr=gfx_script_ptrs[i],
        ))
    return stages


def rleff_decode(data: bytes, out_size: int) -> tuple[bytes, int]:
    out = bytearray()
    i = 0
    while len(out) < out_size:
        if i >= len(data):
            raise ValueError(f"RLEFF ended early: produced 0x{len(out):x}/0x{out_size:x} bytes")
        b = data[i]
        i += 1
        if b == 0xFF:
            if i + 1 >= len(data):
                raise ValueError("truncated RLEFF run marker at end of stream")
            count = data[i]
            value = data[i + 1]
            i += 2
            out.extend([value] * count)
        else:
            out.append(b)
    return bytes(out[:out_size]), i


def rleff_encode(raw: bytes) -> bytes:
    """Encode layout bytes using the game's RLEFF dialect.

    This deliberately mirrors the original tool's non-optimal behavior:
    - runs of length >= 3 are encoded, even when length 3 is size-neutral;
    - long runs avoid leaving a 1- or 2-byte literal tail.

    Example: a run of 256 bytes is emitted as 251+5, not 255+literal1.
    """
    out = bytearray()
    i = 0
    n = len(raw)
    while i < n:
        value = raw[i]
        run = 1
        while i + run < n and raw[i + run] == value:
            run += 1

        if value == 0xFF or run >= 3:
            remaining = run
            while remaining > 0:
                if remaining <= 0xFF:
                    chunk = remaining
                else:
                    chunk = 0xFF
                    rem = remaining - chunk
                    # The original encoder appears to avoid producing a
                    # 1- or 2-byte literal tail after a max-length RLE run.
                    if rem in (1, 2):
                        chunk -= 4
                out += bytes([0xFF, chunk, value])
                remaining -= chunk
            i += run
        else:
            out += raw[i:i + run]
            i += run
    return bytes(out)


def page_table_from_init_block(block: bytes) -> bytes:
    if len(block) != INIT_BLOCK_SIZE:
        raise ValueError(f"init block must be 0x{INIT_BLOCK_SIZE:x} bytes, got 0x{len(block):x}")
    return block[PAGE_TABLE_OFFSET:PAGE_TABLE_OFFSET + FULL_PAGE_TABLE_SIZE]


def infer_active_page_rows(full_table: bytes, layout_raw: bytes) -> int:
    """Return how many leading 14-entry rows are real layout rows.

    Root cause of the previous bug: InitStageResources copies 0x4e bytes from
    overlapping per-stage blocks. Bytes after the active page rows can be the
    next stage's runtime config, not page indices. Therefore the full
    init_block[0x08:0x4e] slice is a maximum table window, not always a 14x5 map.
    A row is active only while every entry points to an existing physical layout
    page. The first invalid row marks the end of the actual editor map.
    """
    if len(full_table) != FULL_PAGE_TABLE_SIZE:
        raise ValueError(f"full page table window must be 0x{FULL_PAGE_TABLE_SIZE:x} bytes")
    physical_pages = len(layout_raw) // PAGE_SIZE
    rows = 0
    for py in range(MAX_PAGE_ROWS):
        row = full_table[py * PAGE_COLS:(py + 1) * PAGE_COLS]
        if all(entry < physical_pages for entry in row):
            rows += 1
        else:
            break
    if rows == 0:
        raise ValueError(
            f"no valid page-table rows; layout has {physical_pages} physical pages; "
            f"first row={' '.join(f'{b:02x}' for b in full_table[:PAGE_COLS])}"
        )
    return rows


def active_page_table(full_table: bytes, layout_raw: bytes) -> tuple[bytes, int]:
    rows = infer_active_page_rows(full_table, layout_raw)
    return full_table[:rows * PAGE_COLS], rows


def unpack_layout_pages(layout_raw: bytes, page_table: bytes, page_rows: int, page_cols: int = PAGE_COLS) -> bytes:
    width = page_cols * PAGE_W
    height = page_rows * PAGE_H
    expected_table = page_cols * page_rows
    if len(page_table) < expected_table:
        raise ValueError(f"page table needs 0x{expected_table:x} bytes for {page_rows} rows, got 0x{len(page_table):x}")
    out = bytearray(width * height)
    physical_pages = len(layout_raw) // PAGE_SIZE
    for py in range(page_rows):
        for px in range(page_cols):
            page_no = page_table[py * page_cols + px]
            if page_no >= physical_pages:
                raise ValueError(f"active page table references page {page_no}, but layout has {physical_pages} pages")
            src_base = page_no * PAGE_SIZE
            page = layout_raw[src_base:src_base + PAGE_SIZE]
            for row in range(PAGE_H):
                src = row * PAGE_W
                dst = (py * PAGE_H + row) * width + px * PAGE_W
                out[dst:dst + PAGE_W] = page[src:src + PAGE_W]
    return bytes(out)


def infer_rows_from_world_map(world_map: bytes, page_cols: int = PAGE_COLS) -> int:
    width = page_cols * PAGE_W
    row_bytes = width * PAGE_H
    if len(world_map) % row_bytes != 0:
        raise ValueError(f"world map size 0x{len(world_map):x} is not a whole number of 14-page rows")
    rows = len(world_map) // row_bytes
    if not 1 <= rows <= MAX_PAGE_ROWS:
        raise ValueError(f"world map has invalid page row count: {rows}")
    return rows


def normalize_page_table_for_rows(data: bytes, layout_raw: bytes | None, page_rows: int, page_cols: int = PAGE_COLS) -> bytes:
    if len(data) == INIT_BLOCK_SIZE:
        data = page_table_from_init_block(data)
    if page_cols == 1:
        # Stage4 is a single physical page. Ignore stale full-width init tables.
        data = bytes([0]) if not data else data[:1]
    elif len(data) == FULL_PAGE_TABLE_SIZE and layout_raw is not None:
        table, _ = active_page_table(data, layout_raw)
        data = table
    expected = page_cols * page_rows
    if len(data) < expected:
        raise ValueError(f"page table needs at least 0x{expected:x} bytes, got 0x{len(data):x}")
    return data[:expected]

def pack_layout_pages(world_map: bytes, page_table: bytes, page_count: int, page_cols: int = PAGE_COLS) -> bytes:
    page_rows = infer_rows_from_world_map(world_map, page_cols)
    width = page_cols * PAGE_W
    expected = width * page_rows * PAGE_H
    if len(world_map) != expected:
        raise ValueError(f"world map size must be 0x{expected:x}, got 0x{len(world_map):x}")
    if len(page_table) < page_cols * page_rows:
        raise ValueError(f"page table too short for {page_rows} rows")
    pages: list[bytearray | None] = [None] * page_count
    for py in range(page_rows):
        for px in range(page_cols):
            page_no = page_table[py * page_cols + px]
            if page_no >= page_count:
                raise ValueError(f"page table references {page_no}, but page_count={page_count}")
            page = bytearray(PAGE_SIZE)
            for row in range(PAGE_H):
                src = (py * PAGE_H + row) * width + px * PAGE_W
                page[row * PAGE_W:(row + 1) * PAGE_W] = world_map[src:src + PAGE_W]
            if pages[page_no] is None:
                pages[page_no] = page
            elif pages[page_no] != page:
                raise ValueError(f"page {page_no} appears multiple times with different tile data; cannot repack shared page table")
    for i, page in enumerate(pages):
        if page is None:
            pages[i] = bytearray(PAGE_SIZE)
    return b"".join(bytes(p) for p in pages if p is not None)

def write_png_gray_pixels(path: Path, pixels: bytes, width: int, height: int, scale: int = 1) -> None:
    """Write 8-bit grayscale PNG from already-expanded pixel values."""
    write_png_gray(path, pixels, width, height, scale)


def write_png_rgb(path: Path, rgb: bytes, width: int, height: int, scale: int = 1) -> None:
    if scale < 1:
        raise ValueError("scale must be >= 1")
    if len(rgb) != width * height * 3:
        raise ValueError("RGB buffer size mismatch")
    scaled_w = width * scale
    scaled_h = height * scale
    rows = []
    for y in range(height):
        src = rgb[y * width * 3:(y + 1) * width * 3]
        expanded = bytearray()
        for x in range(width):
            px = src[x * 3:x * 3 + 3]
            for _ in range(scale):
                expanded.extend(px)
        row = b"\x00" + bytes(expanded)
        for _ in range(scale):
            rows.append(row)
    raw = b"".join(rows)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", binascii.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", scaled_w, scaled_h, 8, 2, 0, 0, 0)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b"")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)




def write_png_rgba(path: Path, rgba: bytes, width: int, height: int, scale: int = 1) -> None:
    if scale < 1:
        raise ValueError("scale must be >= 1")
    if len(rgba) != width * height * 4:
        raise ValueError("RGBA buffer size mismatch")
    scaled_w = width * scale
    scaled_h = height * scale
    rows = []
    for y in range(height):
        src = rgba[y * width * 4:(y + 1) * width * 4]
        expanded = bytearray()
        for x in range(width):
            px = src[x * 4:x * 4 + 4]
            for _ in range(scale):
                expanded.extend(px)
        row = b"\x00" + bytes(expanded)
        for _ in range(scale):
            rows.append(row)
    raw = b"".join(rows)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", binascii.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", scaled_w, scaled_h, 8, 6, 0, 0, 0)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b"")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)

def vram_copy_from_rom(rom: bytes, vram: bytearray, bank: int, src: int, dst: int, size: int) -> None:
    if not (VRAM_BASE <= dst <= VRAM_BASE + VRAM_SIZE):
        raise ValueError(f"VRAM copy destination out of range: ${dst:04x}")
    end = dst + size
    if end > VRAM_BASE + VRAM_SIZE:
        raise ValueError(f"VRAM copy overruns VRAM: ${dst:04x}+0x{size:x}")
    vram[dst - VRAM_BASE:end - VRAM_BASE] = slice_rom(rom, bank, src, src + size)


def vram_load_masked_gfx(rom: bytes, vram: bytearray, bank: int, src: int, dst: int) -> int:
    """Replay bank0:LoadMaskedGfx into VRAM and return encoded bytes consumed.

    Format: u16 mask_group_count, then one mask byte per 8 output bytes plus
    literal bytes for zero mask bits. A one mask bit repeats the previous output
    byte, exactly like the game routine.
    """
    start_off = rom_offset(bank, src)
    off = start_off
    if off + 2 > len(rom):
        raise ValueError(f"truncated LoadMaskedGfx header at bank{bank}:${src:04x}")
    groups = rom[off] | (rom[off + 1] << 8)
    off += 2
    dst_off = dst - VRAM_BASE
    if dst_off < 0 or dst_off >= len(vram):
        raise ValueError(f"LoadMaskedGfx destination out of range: ${dst:04x}")
    prev = vram[dst_off - 1] if dst_off > 0 else 0
    out = dst_off
    for _ in range(groups):
        if off >= len(rom):
            raise ValueError(f"truncated LoadMaskedGfx mask at bank{bank}:${src:04x}")
        mask = rom[off]
        off += 1
        for bit in range(7, -1, -1):
            if (mask >> bit) & 1:
                value = prev
            else:
                if off >= len(rom):
                    raise ValueError(f"truncated LoadMaskedGfx literal at bank{bank}:${src:04x}")
                value = rom[off]
                off += 1
            if out >= len(vram):
                raise ValueError(f"LoadMaskedGfx writes past VRAM: dst=${dst:04x}")
            vram[out] = value
            prev = value
            out += 1
    return off - start_off


def parse_gfx_copy_script(rom: bytes, ptr: int) -> list[tuple[int, int, int, int]]:
    """Parse jr_000_06ea copy records: src16, dst16, size16, bank8, ... ff."""
    records: list[tuple[int, int, int, int]] = []
    off = rom_offset(1, ptr)
    while True:
        marker = rom[off]
        if marker == 0xFF:
            return records
        if off + 7 > len(rom):
            raise ValueError(f"truncated gfx copy script at bank1:${ptr:04x}")
        src = rom[off] | (rom[off + 1] << 8)
        dst = rom[off + 2] | (rom[off + 3] << 8)
        size = rom[off + 4] | (rom[off + 5] << 8)
        bank = rom[off + 6]
        records.append((bank, src, dst, size))
        off += 7


def reconstruct_bg_vram(rom: bytes, stage: StageAssets, include_form_gfx: bool = False, vram_variant: int = 0) -> tuple[bytes, list[tuple[int, int, int, int]]]:
    """Replay background-relevant VRAM loads for a stage/profile.

    Stage 0-3 use the normal gameplay loader at bank1:Call_001_425e. Stage 4
    is the tutorial/special scene and uses a different init path at bank1:$7b8b:
      bank6:$50c4 -> $8800 size $0100
      LoadMaskedGfx bank3:$400f -> $8900
      LoadMaskedGfx bank6:$4bc0 -> $9000
    Replaying the normal loader for stage4 gives a valid layout but the wrong
    tileset, which is why the Tiled view did not match BGB.
    """
    vram = bytearray(VRAM_SIZE)
    applied: list[tuple[int, int, int, int]] = []

    if stage.index == 4 and vram_variant == 0:
        # Stage 4's tutorial loader only initializes BG/tutorial graphics.
        # Object icon preview still needs the common OBJ/form graphics that the
        # game has available for pickups/forms.  When include_form_gfx is set,
        # replay the common object/player-form copies into $8000-$859f before
        # applying the tutorial BG loads.  These ranges do not overlap the
        # tutorial BG copies at $8800+.
        if include_form_gfx:
            # Object icons need the same common OBJ graphics as normal stages,
            # not only the player-form copy.  v15/v15b forgot the $8d00 common
            # OBJ tiles (bank5:$5701->$8d00), so many pickup/form metasprites
            # decoded to fully transparent icons even though the stage BG tiles
            # were correct.
            for rec in (
                (5, 0x4001, 0x8000, 0x0130),
                (5, 0x4131, 0x8130, 0x0470),
                (5, 0x5701, 0x8D00, 0x0300),
            ):
                vram_copy_from_rom(rom, vram, *rec)
                applied.append(rec)
        rec = (6, 0x50C4, 0x8800, 0x0100)
        vram_copy_from_rom(rom, vram, *rec)
        applied.append(rec)
        used = vram_load_masked_gfx(rom, vram, 3, 0x400F, 0x8900)
        applied.append((3, 0x400F, 0x8900, used))
        used = vram_load_masked_gfx(rom, vram, 6, 0x4BC0, 0x9000)
        applied.append((6, 0x4BC0, 0x9000, used))
        return bytes(vram), applied

    for rec in COMMON_GFX_COPIES:
        bank, src, dst, size = rec
        vram_copy_from_rom(rom, vram, bank, src, dst, size)
        applied.append(rec)
    if include_form_gfx:
        # Normal form only. Useful for experiments, not needed for BG render.
        rec = (5, 0x4131, 0x8130, 0x0470)
        vram_copy_from_rom(rom, vram, *rec)
        applied.append(rec)
    for rec in parse_gfx_copy_script(rom, stage.gfx_script_ptr):
        bank, src, dst, size = rec
        vram_copy_from_rom(rom, vram, bank, src, dst, size)
        applied.append(rec)

    for rec in STAGE_VRAM_VARIANT_OVERLAYS.get((stage.index, vram_variant), []):
        bank, src, dst, size = rec
        vram_copy_from_rom(rom, vram, bank, src, dst, size)
        applied.append(rec)
    return bytes(vram), applied


def bg_tile_addr(tile_id: int, mode: str = "signed") -> int:
    if mode != "signed":
        raise ValueError("only signed BG tile addressing is supported; gameplay uses LCDC bit4=0")
    signed_id = tile_id if tile_id < 0x80 else tile_id - 0x100
    return 0x9000 + signed_id * 16


def decode_2bpp_tile(vram: bytes, tile_id: int, mode: str) -> list[int]:
    addr = bg_tile_addr(tile_id, mode)
    if not (VRAM_BASE <= addr <= VRAM_BASE + VRAM_SIZE - 16):
        return [0] * 64
    off = addr - VRAM_BASE
    out: list[int] = []
    tile = vram[off:off + 16]
    for y in range(8):
        lo = tile[y * 2]
        hi = tile[y * 2 + 1]
        for bit in range(7, -1, -1):
            out.append(((hi >> bit) & 1) << 1 | ((lo >> bit) & 1))
    return out


def load_metatile_quads_for_variant(rom: bytes, stage: StageAssets, variant: int) -> bytes:
    """Return the metatile quad table for a render profile.

    variant 0 is the stage's normal table from bank1:$40b9. Non-zero variants
    are explicit per-stage overrides discovered from gameplay code.
    """
    if variant == 0:
        return slice_rom(rom, LEVEL_DATA_BANK, stage.metatile_ptr, stage.metatile_end)
    ptr = STAGE_METATILE_VARIANT_PTRS.get((stage.index, variant))
    if ptr is None:
        raise ValueError(f"no metatile variant {variant} is known for stage{stage.index}")
    # A metatile table is indexed by metatile id * 4. 0x400 bytes covers all 256
    # possible metatiles and is safe even when the original table is shorter.
    return slice_rom(rom, LEVEL_DATA_BANK, ptr, min(0x8000, ptr + 0x400))


def parse_int_auto(value: object, default: int | None = None) -> int | None:
    if value is None:
        return default
    if isinstance(value, int):
        return value
    text = str(value).strip()
    if text == "" or text.lower() in {"none", "null", "end"}:
        return default
    return int(text, 0)


def parse_range_text(text: str) -> list[RenderRangeProfile]:
    """Parse a compact range profile string.

    Format examples:
      0-0x900:0,0x900-end:2
      0-0x900:v0:m0:front,0x900-end:v2:m0:back
      0x500-end:v1:m2
    The first number after ':' is the VRAM variant unless prefixed by m/v.
    """
    out: list[RenderRangeProfile] = []
    for part in text.split(','):
        part = part.strip()
        if not part:
            continue
        span, *fields = part.split(':')
        if '-' not in span:
            raise ValueError(f"range must be start-end: {part}")
        a, b = span.split('-', 1)
        start = int(a, 0)
        end = parse_int_auto(b, None)
        vram_variant = 0
        metatile_variant = 0
        name = ""
        for idx, field in enumerate(fields):
            f = field.strip()
            if not f:
                continue
            if f.startswith('v'):
                vram_variant = int(f[1:], 0)
            elif f.startswith('m'):
                metatile_variant = int(f[1:], 0)
            elif idx == 0:
                vram_variant = int(f, 0)
            else:
                name = f
        out.append(RenderRangeProfile(start, end, vram_variant, metatile_variant, name))
    return out


def load_range_profiles(stage_index: int, range_file: Path | None = None, range_text: str | None = None) -> list[RenderRangeProfile]:
    if range_text:
        return parse_range_text(range_text)
    if range_file:
        data = json.loads(range_file.read_text(encoding="utf-8"))
        if isinstance(data, dict):
            data = data.get("ranges", [])
        out: list[RenderRangeProfile] = []
        for item in data:
            out.append(RenderRangeProfile(
                start=int(str(item.get("start", 0)), 0),
                end=parse_int_auto(item.get("end"), None),
                vram_variant=int(str(item.get("vram_variant", item.get("variant", 0))), 0),
                metatile_variant=int(str(item.get("metatile_variant", 0)), 0),
                name=str(item.get("name", "")),
            ))
        return out
    return [RenderRangeProfile(**r) for r in BUILTIN_RANGE_PROFILES.get(stage_index, [
        {"start": 0, "end": None, "vram_variant": 0, "metatile_variant": 0, "name": "default"}
    ])]


def normalize_range_profiles(ranges: list[RenderRangeProfile], width: int) -> list[RenderRangeProfile]:
    if not ranges:
        return [RenderRangeProfile(0, None)]
    out: list[RenderRangeProfile] = []
    for r in sorted(ranges, key=lambda x: x.start):
        start = max(0, min(width, r.start))
        end = width if r.end is None else max(0, min(width, r.end))
        if end <= start:
            continue
        out.append(RenderRangeProfile(start, end, r.vram_variant, r.metatile_variant, r.name))
    if not out:
        raise ValueError("no non-empty render ranges remain after clipping to stage width")
    return out


def render_world_map_pixels_with_ranges(
    rom: bytes,
    stage: StageAssets,
    world_map: bytes,
    page_rows: int,
    tile_mode: str,
    palette: Sequence[int],
    ranges: list[RenderRangeProfile],
) -> tuple[bytes, int, int, list[str]]:
    """Composite a full-stage image from multiple VRAM/metatile profiles.

    Coordinates are output world pixels. This does not emulate live scrolling;
    it renders each profile as a full image then copies the requested vertical
    strip. That is deliberate: it keeps range transitions deterministic and lets
    editor users tune split points with normal image coordinates.
    """
    mt_w = PAGE_COLS * PAGE_W
    mt_h = page_rows * PAGE_H
    width = mt_w * 16
    height = mt_h * 16
    ranges = normalize_range_profiles(ranges, width)
    final = bytearray(width * height)
    log: list[str] = []
    cache: dict[tuple[int, int], bytes] = {}
    for r in ranges:
        key = (r.vram_variant, r.metatile_variant)
        if key not in cache:
            vram, copies = reconstruct_bg_vram(rom, stage, vram_variant=r.vram_variant)
            quads = load_metatile_quads_for_variant(rom, stage, r.metatile_variant)
            img, w, h = render_world_map_pixels(world_map, quads, vram, page_rows, tile_mode, palette)
            if w != width or h != height:
                raise ValueError("internal render size mismatch during range composite")
            cache[key] = img
            log.append(f"profile vram={r.vram_variant} metatile={r.metatile_variant}: {len(copies)} VRAM copies")
            for bank, src, dst, size in copies:
                log.append(f"  bank{bank}:${src:04x} -> VRAM ${dst:04x}, size=0x{size:04x}")
        src_img = cache[key]
        start = r.start
        end = width if r.end is None else r.end
        log.append(f"range ${start:04x}-${end:04x}: vram={r.vram_variant} metatile={r.metatile_variant} {r.name}")
        for y in range(height):
            row = y * width
            final[row + start:row + end] = src_img[row + start:row + end]
    return bytes(final), width, height, log


def render_world_map_pixels(world_map: bytes, metatile_quads: bytes, vram: bytes, page_rows: int, tile_mode: str, palette: Sequence[int]) -> tuple[bytes, int, int]:
    mt_w = PAGE_COLS * PAGE_W
    mt_h = page_rows * PAGE_H
    if len(world_map) != mt_w * mt_h:
        raise ValueError(f"world_map size mismatch: got 0x{len(world_map):x}, expected 0x{mt_w * mt_h:x}")
    width = mt_w * 16
    height = mt_h * 16
    out = bytearray(width * height)
    tile_cache: dict[int, list[int]] = {}

    def tile_pixels(tid: int) -> list[int]:
        if tid not in tile_cache:
            tile_cache[tid] = decode_2bpp_tile(vram, tid, tile_mode)
        return tile_cache[tid]

    for my in range(mt_h):
        for mx in range(mt_w):
            mt = world_map[my * mt_w + mx]
            qoff = mt * 4
            if qoff + 4 > len(metatile_quads):
                quads = (0, 0, 0, 0)
            else:
                quads = metatile_quads[qoff:qoff + 4]
            for qi, tid in enumerate(quads):
                ox = 8 if (qi & 1) else 0
                oy = 8 if (qi & 2) else 0
                pix = tile_pixels(tid)
                base_x = mx * 16 + ox
                base_y = my * 16 + oy
                for ty in range(8):
                    dst = (base_y + ty) * width + base_x
                    src = ty * 8
                    for tx in range(8):
                        out[dst + tx] = palette[pix[src + tx]]
    return bytes(out), width, height


def render_world_map_rgb(world_map: bytes, metatile_quads: bytes, vram: bytes, page_rows: int, tile_mode: str, palette: Sequence[int]) -> tuple[bytes, int, int]:
    gray, width, height = render_world_map_pixels(world_map, metatile_quads, vram, page_rows, tile_mode, palette)
    rgb = bytearray(width * height * 3)
    for i, g in enumerate(gray):
        rgb[i * 3:i * 3 + 3] = bytes((g, g, g))
    return bytes(rgb), width, height


def write_png_gray(path: Path, pixels: bytes, width: int, height: int, scale: int = 4) -> None:
    if scale < 1:
        raise ValueError("scale must be >= 1")
    if len(pixels) != width * height:
        raise ValueError("pixel buffer size mismatch")
    scaled_w = width * scale
    scaled_h = height * scale
    rows = []
    for y in range(height):
        src = pixels[y * width:(y + 1) * width]
        scaled_row = bytearray()
        for v in src:
            scaled_row.extend([v] * scale)
        row = b"\x00" + bytes(scaled_row)
        for _ in range(scale):
            rows.append(row)
    raw = b"".join(rows)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", binascii.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", scaled_w, scaled_h, 8, 0, 0, 0, 0)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b"")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)


def make_preview_pixels(world_map: bytes) -> bytes:
    return bytes(((v * 5) & 0xFF) for v in world_map)


def parse_spawn_records(data: bytes) -> list[dict[str, int]]:
    records: list[dict[str, int]] = []
    off = 0
    idx = 0
    while off < len(data):
        typ = data[off]
        if typ == SPAWN_END:
            break
        if off + SPAWN_RECORD_SIZE > len(data):
            raise ValueError(f"spawn list truncated at offset 0x{off:x}")
        x = data[off + 1] | (data[off + 2] << 8)
        y_raw = data[off + 3] | (data[off + 4] << 8)
        records.append({
            "index": idx,
            "type": typ & 0x7F,
            "flags": typ & 0x80,
            "type_raw": typ,
            "x": x,
            "y": y_raw & 0xFFF8,
            "param": data[off + 3] & 0x07,
            "y_byte_raw": data[off + 3],
        })
        idx += 1
        off += SPAWN_RECORD_SIZE
    return records


def write_spawns_csv(path: Path, data: bytes) -> None:
    records = parse_spawn_records(data)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["index", "type", "flags", "type_raw", "x", "y", "param", "y_byte_raw"])
        writer.writeheader()
        writer.writerows(records)


def build_spawns_from_csv(csv_path: Path) -> bytes:
    out = bytearray()
    with csv_path.open(newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if not row or not row.get("type", "").strip():
                continue
            typ = int(row["type"], 0) & 0x7F
            flags = int(row.get("flags") or 0, 0) & 0x80
            x = int(row["x"], 0) & 0xFFFF
            y = int(row["y"], 0) & 0xFFFF
            param = int(row.get("param") or 0, 0) & 0x07
            out += bytes([typ | flags, x & 0xFF, (x >> 8) & 0xFF, (y & 0xF8) | param, (y >> 8) & 0xFF])
    out.append(SPAWN_END)
    return bytes(out)


def _int_prop(parent: ET.Element, name: str, value: int) -> None:
    ET.SubElement(parent, "property", {"name": name, "type": "int", "value": str(int(value))})


def _get_tiled_property(obj: ET.Element, name: str, default: str | None = None) -> str | None:
    props = obj.find("properties")
    if props is None:
        return default
    for prop in props.findall("property"):
        if prop.attrib.get("name") == name:
            return prop.attrib.get("value", default)
    return default


def _parse_optional_int(text: str | None, default: int = 0) -> int:
    if text is None or str(text).strip() == "":
        return default
    return int(str(text).strip(), 0)


def spawns_to_tiled_objects(
    objectgroup: ET.Element,
    spawns: bytes,
    object_firstgid: int | None = None,
    object_icon_bounds: dict[int, tuple[int, int, int, int]] | None = None,
    include_types: set[int] | None = None,
    exclude_types: set[int] | None = None,
    start_id: int = 1,
) -> int:
    """Append one Tiled object per spawn record. Returns next object id.

    Tiled object x/y is the *visual editor box* position, not necessarily the raw
    ROM spawn origin. Only editor-facing properties are written; raw/debug
    reconstruction details live in object_profiles.json and the TMX geometry.
    """
    next_id = start_id
    for rec in parse_spawn_records(spawns):
        typ7 = rec["type"] & 0x7F
        if include_types is not None and typ7 not in include_types:
            continue
        if exclude_types is not None and typ7 in exclude_types:
            continue
        profile = object_profile_for_type(rec["type"])
        dx = int(profile.get("display_offset_x", 0))
        dy = int(profile.get("display_offset_y", 0))
        width = int(profile.get("width", 16))
        height = int(profile.get("height", 16))
        # Prefer the real OAM/metasprite footprint when an object preview is known.
        # The game draws object metasprites at raw spawn screen position plus each
        # part's signed x/y offsets, so min offsets are the correct Tiled visual
        # box offset and max-min is the correct box size.
        if object_icon_bounds is not None and object_type_uses_oam_bounds(typ7):
            bounds = object_icon_bounds.get(typ7)
            if bounds is not None:
                dx, dy, width, height = bounds
        obj_name = str(profile.get("name") or f"OBJ_{rec['type']:02x}")
        visual_x = rec["x"] + dx
        visual_y = rec["y"] + dy
        attrs = {
            "id": str(next_id),
            "name": f"spawn_{rec['index']:03d}_type_{rec['type']:02x}",
            "type": obj_name,
            "x": str(visual_x),
            "y": str(visual_y),
            "width": str(width),
            "height": str(height),
        }
        # Tiled uses bottom-left positioning for tile objects. For editor visual
        # parity keep the logical visual box top-left in properties/import math,
        # but store y+height for the tile-object drawing origin.
        if object_firstgid is not None and object_icon_supported(rec["type"] & 0x7F):
            attrs["gid"] = str(object_firstgid + (rec["type"] & 0x7F))
            attrs["y"] = str(visual_y + height)
        obj = ET.SubElement(objectgroup, "object", attrs)
        props = ET.SubElement(obj, "properties")
        # Editor-facing properties only.  The importer derives raw ROM x/y from
        # the object geometry plus object_profiles.json, so raw/debug properties
        # are intentionally not shown in Tiled.
        _int_prop(props, "index", rec["index"])
        _int_prop(props, "type", rec["type"])
        _int_prop(props, "flags", rec["flags"])
        _int_prop(props, "param", rec["param"])
        _int_prop(props, "active", 1)
        next_id += 1
    return next_id


def tiled_objects_to_spawns(tmx_path: Path, object_layer_name: str = "Spawns") -> bytes:
    tree = ET.parse(tmx_path)
    root = tree.getroot()

    layer_names: list[str]
    if object_layer_name == "Spawns":
        # v16 editor split: ordinary objects are in Spawns, special controllers
        # are in Stage Events. Both are still one ROM spawn list after import.
        layer_names = ["Spawns", "Stage Events"]
    else:
        layer_names = [object_layer_name]

    groups: list[ET.Element] = []
    for wanted in layer_names:
        for candidate in root.findall("objectgroup"):
            if candidate.attrib.get("name") == wanted:
                groups.append(candidate)
                break

    if not groups:
        all_groups = root.findall("objectgroup")
        if not all_groups:
            raise ValueError("TMX has no object layers; expected a Spawns object layer")
        groups = [all_groups[0]]

    entries = []
    for group in groups:
        for obj in group.findall("object"):
            # Tiled may keep deleted/hidden helper objects around; allow disabling by active=0.
            active = _parse_optional_int(_get_tiled_property(obj, "active", "1"), 1)
            if active == 0:
                continue
            order = _parse_optional_int(_get_tiled_property(obj, "index"), int(obj.attrib.get("id", "0")))

            # Editable type/flags properties are the source of truth. Older TMX files
            # may still contain type_raw, so keep a compatibility fallback.
            type_prop = _get_tiled_property(obj, "type")
            flags_prop = _get_tiled_property(obj, "flags")
            if type_prop not in (None, ""):
                typ = _parse_optional_int(type_prop, 0) & 0x7F
                flags = _parse_optional_int(flags_prop, 0) & 0x80
            else:
                type_raw = _parse_optional_int(_get_tiled_property(obj, "type_raw"), 0) & 0xFF
                typ = type_raw & 0x7F
                flags = type_raw & 0x80

            param = _parse_optional_int(_get_tiled_property(obj, "param"), 0) & 0x07

            # Reverse the visual offset used at export. New TMX files keep the UI
            # clean and do not store per-object debug offsets; the per-type values
            # come from object_profiles.json next to the TMX. The property fallback
            # preserves compatibility with v15q-and-earlier TMX files.
            profile = object_profile_for_type(typ)
            dx = _parse_optional_int(_get_tiled_property(obj, "display_offset_x"), int(profile.get("display_offset_x", 0)))
            dy = _parse_optional_int(_get_tiled_property(obj, "display_offset_y"), int(profile.get("display_offset_y", 0)))
            visual_x = int(round(float(obj.attrib.get("x", "0"))))
            visual_y = int(round(float(obj.attrib.get("y", "0"))))

            # Tiled tile objects store y as the bottom edge; rectangle objects store y as top edge.
            if "gid" in obj.attrib:
                visual_height = int(round(float(obj.attrib.get("height", "16"))))
                visual_y -= visual_height

            x = (visual_x - dx) & 0xFFFF
            y = (visual_y - dy) & 0xFFFF
            entries.append((order, typ | flags, x, y, param))

    entries.sort(key=lambda e: e[0])
    out = bytearray()
    for _order, type_raw, x, y, param in entries:
        out += bytes([type_raw, x & 0xFF, (x >> 8) & 0xFF, (y & 0xF8) | param, (y >> 8) & 0xFF])
    out.append(SPAWN_END)
    return bytes(out)


def write_tiled_spawns_csv_from_tmx(tmx_path: Path, csv_path: Path, object_layer_name: str = "Spawns") -> None:
    data = tiled_objects_to_spawns(tmx_path, object_layer_name)
    write_spawns_csv(csv_path, data)


def parse_stage_list(text: str | None) -> list[int]:
    if not text:
        return list(range(STAGE_COUNT))
    out: list[int] = []
    for part in text.split(','):
        part = part.strip()
        if not part:
            continue
        if '-' in part:
            a, b = part.split('-', 1)
            out.extend(range(int(a, 0), int(b, 0) + 1))
        else:
            out.append(int(part, 0))
    for i in out:
        if not 0 <= i < STAGE_COUNT:
            raise ValueError(f"unknown stage index: {i}")
    return sorted(set(out))


def extract_shared(rom: bytes, out_root: Path) -> None:
    shared = out_root / "levels" / "shared"
    shared.mkdir(parents=True, exist_ok=True)
    shared.joinpath("collision_attrs_blob.bin").write_bytes(
        slice_rom(rom, LEVEL_DATA_BANK, COLLISION_ATTR_BLOB_START, COLLISION_ATTR_BLOB_END)
    )


def extract_stage(rom: bytes, out_root: Path, stage: StageAssets, preview_scale: int) -> None:
    stage_dir = out_root / "levels" / f"stage{stage.index}"
    stage_dir.mkdir(parents=True, exist_ok=True)

    metatile_quads = slice_rom(rom, LEVEL_DATA_BANK, stage.metatile_ptr, stage.metatile_end)
    layout_rle_range = slice_rom(rom, LEVEL_DATA_BANK, stage.layout_ptr, stage.layout_end)
    init_block = slice_rom(rom, INIT_BANK, stage.init_ptr, stage.init_ptr + INIT_BLOCK_SIZE)
    full_page_table = page_table_from_init_block(init_block)
    spawns = slice_rom(rom, SPAWN_BANK, stage.spawn_ptr, stage.spawn_end)

    layout_raw, consumed = rleff_decode(layout_rle_range, stage.layout_decoded_size)
    page_table, page_rows = active_page_table(full_page_table, layout_raw)
    world_map = unpack_layout_pages(layout_raw, page_table, page_rows)

    stage_dir.joinpath("metatile_quads.bin").write_bytes(metatile_quads)
    stage_dir.joinpath("layout.rleff").write_bytes(layout_rle_range[:consumed])
    stage_dir.joinpath("layout.rleff.padded_source.bin").write_bytes(layout_rle_range)
    stage_dir.joinpath("layout.raw").write_bytes(layout_raw)
    stage_dir.joinpath("init_block.bin").write_bytes(init_block)
    stage_dir.joinpath("page_table_full_window.bin").write_bytes(full_page_table)
    stage_dir.joinpath("page_table.bin").write_bytes(page_table)
    stage_dir.joinpath("world_map.raw").write_bytes(world_map)
    stage_dir.joinpath("stage_meta.txt").write_text(f"page_rows={page_rows}\npage_cols={PAGE_COLS}\nphysical_pages={len(layout_raw)//PAGE_SIZE}\n", encoding="utf-8")
    stage_dir.joinpath("spawns.bin").write_bytes(spawns)
    write_spawns_csv(stage_dir / "spawns.csv", spawns)
    write_png_gray(stage_dir / "world_map_preview.png", make_preview_pixels(world_map), PAGE_COLS * PAGE_W, page_rows * PAGE_H, preview_scale)

    # True tile-pixel render. This reconstructs VRAM from the ROM copy scripts. BG tiles are rendered using signed addressing.
    vram, gfx_records = reconstruct_bg_vram(rom, stage)
    rendered, render_w, render_h = render_world_map_pixels(
        world_map, metatile_quads, vram, page_rows, "signed", DMG_PALETTE_LIGHT_TO_DARK
    )
    write_png_gray(stage_dir / "stage_render_signed.png", rendered, render_w, render_h, 1)
    with (stage_dir / "vram_copy_log.txt").open("w", encoding="utf-8") as f:
        for bank, src, dst, size in gfx_records:
            f.write(f"bank{bank}:${src:04x} -> VRAM ${dst:04x}, size=0x{size:04x}\n")

    # Stage-specific range composite render. For stage1 this automatically uses
    # the c0b4=2 overlay from x=$0900 onward. Other stages can use the
    # render-stage-ranges command with a custom JSON/text range file.
    if stage.index in BUILTIN_RANGE_PROFILES:
        range_img, rw, rh, range_log = render_world_map_pixels_with_ranges(
            rom, stage, world_map, page_rows, "signed", DMG_PALETTE_LIGHT_TO_DARK,
            load_range_profiles(stage.index),
        )
        write_png_gray(stage_dir / "stage_render_signed_by_range.png", range_img, rw, rh, 1)
        (stage_dir / "vram_range_log.txt").write_text("\n".join(range_log) + "\n", encoding="utf-8")

    print(
        f"stage{stage.index}: init=${stage.init_ptr:04x} page_rows={page_rows} page_first={page_table[0]:02x} "
        f"layout=${stage.layout_ptr:04x}-${stage.layout_end:04x} used=0x{consumed:x} "
        f"raw_pages={len(layout_raw)//PAGE_SIZE} unique_active_pages={sorted(set(page_table))} "
        f"spawns={len(parse_spawn_records(spawns))}"
    )



def command_render_stage(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes()
    stages = load_stage_assets(rom)
    st = stages[args.stage]
    stage_dir = args.assets_dir / "levels" / f"stage{args.stage}"
    world_map_path = stage_dir / "world_map.raw"
    page_meta_path = stage_dir / "stage_meta.txt"
    metatile_path = stage_dir / "metatile_quads.bin"
    if world_map_path.exists() and metatile_path.exists() and page_meta_path.exists():
        world_map = world_map_path.read_bytes()
        metatile_quads = metatile_path.read_bytes()
        page_rows = infer_rows_from_world_map(world_map)
    else:
        # No extracted assets yet; build the needed stage data in memory.
        metatile_quads = slice_rom(rom, LEVEL_DATA_BANK, st.metatile_ptr, st.metatile_end)
        layout_rle_range = slice_rom(rom, LEVEL_DATA_BANK, st.layout_ptr, st.layout_end)
        layout_raw, _ = rleff_decode(layout_rle_range, st.layout_decoded_size)
        init_block = slice_rom(rom, INIT_BANK, st.init_ptr, st.init_ptr + INIT_BLOCK_SIZE)
        full_table = page_table_from_init_block(init_block)
        page_table, page_rows = active_page_table(full_table, layout_raw)
        world_map = unpack_layout_pages(layout_raw, page_table, page_rows)
    vram, copy_log = reconstruct_bg_vram(rom, st, include_form_gfx=args.include_form_gfx, vram_variant=args.vram_variant)
    palette = DMG_PALETTE_LIGHT_TO_DARK if args.palette == "dmg" else DMG_PALETTE_GREENISH
    pixels, width, height = render_world_map_pixels(world_map, metatile_quads, vram, page_rows, args.tile_mode, palette)
    write_png_gray(args.output_png, pixels, width, height, args.scale)
    if args.copy_log:
        args.copy_log.parent.mkdir(parents=True, exist_ok=True)
        args.copy_log.write_text("".join(f"bank{b}:${src:04x} -> VRAM ${dst:04x}, size=0x{size:04x}\n" for b, src, dst, size in copy_log), encoding="utf-8")
    print(f"rendered stage{args.stage}: {width}x{height}, mode={args.tile_mode}, vram_variant={args.vram_variant}, wrote {args.output_png}")


def command_render_stage_ranges(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes()
    stages = load_stage_assets(rom)
    st = stages[args.stage]
    stage_dir = args.assets_dir / "levels" / f"stage{args.stage}"
    world_map_path = stage_dir / "world_map.raw"
    if not world_map_path.exists():
        # Build extracted data if the user has not run `all` yet.
        extract_shared(rom, args.assets_dir)
        extract_stage(rom, args.assets_dir, st, args.preview_scale)
    world_map = world_map_path.read_bytes()
    page_rows = infer_rows_from_world_map(world_map)
    ranges = load_range_profiles(args.stage, args.range_file, args.ranges)
    palette = DMG_PALETTE_LIGHT_TO_DARK if args.palette == "dmg" else DMG_PALETTE_GREENISH
    pixels, width, height, log = render_world_map_pixels_with_ranges(
        rom, st, world_map, page_rows, args.tile_mode, palette, ranges
    )
    write_png_gray(args.output_png, pixels, width, height, args.scale)
    if args.copy_log:
        args.copy_log.parent.mkdir(parents=True, exist_ok=True)
        args.copy_log.write_text("\n".join(log) + "\n", encoding="utf-8")
    print(f"rendered stage{args.stage} by ranges: {width}x{height}, wrote {args.output_png}")
    for line in log:
        if line.startswith("range "):
            print("  " + line)


def command_dump_vram(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes()
    st = load_stage_assets(rom)[args.stage]
    vram, copy_log = reconstruct_bg_vram(rom, st, include_form_gfx=args.include_form_gfx, vram_variant=args.vram_variant)
    args.output_bin.parent.mkdir(parents=True, exist_ok=True)
    args.output_bin.write_bytes(vram)
    if args.copy_log:
        args.copy_log.parent.mkdir(parents=True, exist_ok=True)
        args.copy_log.write_text("".join(f"bank{b}:${src:04x} -> VRAM ${dst:04x}, size=0x{size:04x}\n" for b, src, dst, size in copy_log), encoding="utf-8")
    print(f"wrote reconstructed VRAM to {args.output_bin}")


def command_all(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes()
    stages = load_stage_assets(rom)
    extract_shared(rom, args.outdir)
    wanted = set(parse_stage_list(args.stages))
    for st in stages:
        if st.index in wanted:
            extract_stage(rom, args.outdir, st, args.preview_scale)


def command_probe(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes()
    print(f"ROM size=0x{len(rom):x}")
    for name, addr in [
        ("collision", COLLISION_PTR_TABLE),
        ("metatile", METATILE_PTR_TABLE),
        ("init", INIT_BLOCK_PTR_TABLE),
        ("layout", LAYOUT_RLE_PTR_TABLE),
        ("spawn", SPAWN_PTR_TABLE),
        ("gfx", GFX_SCRIPT_PTR_TABLE),
    ]:
        ptrs = read_ptr_table(rom, addr)
        raw = slice_rom(rom, 1, addr, addr + STAGE_COUNT * 2)
        print(f"bank1:${addr:04x} {name:9s} raw={' '.join(f'{b:02x}' for b in raw)} ptrs={[f'${p:04x}' for p in ptrs]}")
    stages = load_stage_assets(rom)
    for st in stages:
        init = slice_rom(rom, INIT_BANK, st.init_ptr, st.init_ptr + INIT_BLOCK_SIZE)
        page = page_table_from_init_block(init)
        layout_rle_range = slice_rom(rom, LEVEL_DATA_BANK, st.layout_ptr, st.layout_end)
        layout_raw, _ = rleff_decode(layout_rle_range, st.layout_decoded_size)
        rows = infer_active_page_rows(page, layout_raw)
        print(
            f"stage{st.index}: init=${st.init_ptr:04x} init_first16={' '.join(f'{b:02x}' for b in init[:16])} "
            f"page_first16={' '.join(f'{b:02x}' for b in page[:16])} active_rows={rows}"
        )


def command_inspect(args: argparse.Namespace) -> None:
    data = args.page_table_or_init.read_bytes()
    if len(data) == INIT_BLOCK_SIZE:
        table = page_table_from_init_block(data)
        src = "init_block[0x08:0x4e]"
    else:
        table = data
        src = "page_table.bin"
    print(f"source={src} size=0x{len(table):x}")
    print("first16=", " ".join(f"{b:02x}" for b in table[:16]))
    print("unique=", sorted(set(table)))
    if args.layout_raw:
        layout = args.layout_raw.read_bytes()
        pages = len(layout) // PAGE_SIZE
        bad = [b for b in table if b >= pages]
        rows = infer_active_page_rows(table if len(table) == FULL_PAGE_TABLE_SIZE else table + bytes(FULL_PAGE_TABLE_SIZE-len(table)), layout) if len(table) <= FULL_PAGE_TABLE_SIZE else 0
        print(f"layout_pages={pages} active_rows={rows} bad_entries_in_full_window={bad[:16]}{'...' if len(bad) > 16 else ''}")


def command_preview(args: argparse.Namespace) -> None:
    world = args.world_map_raw.read_bytes()
    page_rows = infer_rows_from_world_map(world)
    write_png_gray(args.output_png, make_preview_pixels(world), PAGE_COLS * PAGE_W, page_rows * PAGE_H, args.scale)
    print(f"wrote {args.output_png}")


def command_rebuild_layout(args: argparse.Namespace) -> None:
    stages = load_stage_assets(args.rom.read_bytes()) if args.rom else None
    world = args.world_map_raw.read_bytes()
    stage_size = LAYOUT_DECODED_SIZES[args.stage]
    page_count = args.page_count if args.page_count is not None else stage_size // PAGE_SIZE
    dummy_layout = bytes(stage_size)
    page_cols = stage_page_cols(args.stage)
    page_rows = infer_rows_from_world_map(world, page_cols)
    page_table = normalize_page_table_for_rows(args.page_table_bin.read_bytes(), dummy_layout, page_rows, page_cols)
    layout_raw = pack_layout_pages(world, page_table, page_count, page_cols)
    encoded = rleff_encode(layout_raw)
    args.output_layout_raw.parent.mkdir(parents=True, exist_ok=True)
    args.output_layout_raw.write_bytes(layout_raw)
    args.output_layout_rleff.parent.mkdir(parents=True, exist_ok=True)
    args.output_layout_rleff.write_bytes(encoded)
    msg = f"wrote {args.output_layout_raw} 0x{len(layout_raw):x}; {args.output_layout_rleff} 0x{len(encoded):x}"
    if args.max_rleff_size is not None and len(encoded) > args.max_rleff_size:
        msg += f" WARNING exceeds max 0x{args.max_rleff_size:x}"
    print(msg)




def stage_profile_names(stage_index: int) -> list[str]:
    defs = STAGE_PROFILE_DEFS.get(stage_index)
    if not defs:
        return ["normal"]
    return list(defs["profiles"].keys())


def resolve_stage_profile(stage_index: int, profile_name: str | None) -> dict[str, object]:
    defs = STAGE_PROFILE_DEFS.get(stage_index)
    if defs is None:
        defs = {"default": "normal", "profiles": {"normal": {"label": "Normal", "vram_variant": 0, "metatile_variant": 0, "collision_variant": 0}}}
    if profile_name is None or profile_name == "default":
        profile_name = str(defs["default"])
    profiles = defs["profiles"]
    if profile_name not in profiles:
        known = ", ".join(profiles.keys())
        raise ValueError(f"unknown profile '{profile_name}' for stage{stage_index}; known: {known}")
    prof = dict(profiles[profile_name])
    prof["name"] = profile_name
    prof.setdefault("label", profile_name)
    prof.setdefault("vram_variant", 0)
    prof.setdefault("metatile_variant", 0)
    prof.setdefault("collision_variant", 0)
    return prof


def write_metatile_tileset_png(
    output_png: Path,
    rom: bytes,
    stage: StageAssets,
    profile: dict[str, object],
    palette: Sequence[int],
    columns: int = 16,
) -> tuple[int, int, int]:
    """Write a 16x16-metatile tileset PNG for Tiled.

    Tiled works best when each selectable tile is a full 16x16 game metatile.
    We therefore render metatile id 0..255 into a 16x16 sheet. TMX gid 1 maps
    to metatile 0, gid 2 maps to metatile 1, and so on.
    """
    vram_variant = int(profile.get("vram_variant", 0))
    metatile_variant = int(profile.get("metatile_variant", 0))
    vram, _copy_log = reconstruct_bg_vram(rom, stage, vram_variant=vram_variant)
    quads = load_metatile_quads_for_variant(rom, stage, metatile_variant)
    tile_count = 256
    rows = (tile_count + columns - 1) // columns
    width = columns * 16
    height = rows * 16
    out = bytearray(width * height)
    tile_cache: dict[int, list[int]] = {}

    def tile_pixels(tid: int) -> list[int]:
        if tid not in tile_cache:
            tile_cache[tid] = decode_2bpp_tile(vram, tid, "signed")
        return tile_cache[tid]

    for mt in range(tile_count):
        sheet_x = (mt % columns) * 16
        sheet_y = (mt // columns) * 16
        qoff = mt * 4
        quads4 = quads[qoff:qoff + 4] if qoff + 4 <= len(quads) else bytes([0, 0, 0, 0])
        for qi, tid in enumerate(quads4):
            ox = 8 if (qi & 1) else 0
            oy = 8 if (qi & 2) else 0
            pix = tile_pixels(tid)
            for ty in range(8):
                dst = (sheet_y + oy + ty) * width + sheet_x + ox
                src = ty * 8
                for tx in range(8):
                    out[dst + tx] = palette[pix[src + tx]]
    write_png_gray(output_png, bytes(out), width, height, scale=1)
    return width, height, tile_count


def relpath_for_xml(path: Path, base_dir: Path) -> str:
    try:
        rel = path.resolve().relative_to(base_dir.resolve())
        return rel.as_posix()
    except Exception:
        return path.as_posix().replace('\\', '/')



def signed8(v: int) -> int:
    return v - 0x100 if v & 0x80 else v


def object_metasprite_bank_for_ptr(ptr: int) -> int:
    # Most object/item metasprites live in bank0 fixed ROM; the platform
    # metasprites around $70xx are inline in bank1.
    return 1 if ptr >= 0x4000 else 0


def parse_metasprite(rom: bytes, bank: int, ptr: int, max_parts: int = 64) -> list[tuple[int, int, int, int]]:
    parts: list[tuple[int, int, int, int]] = []
    off = rom_offset(bank, ptr)
    for _ in range(max_parts):
        if off >= len(rom):
            break
        y = rom[off]
        off += 1
        if y == 0x80:
            break
        if off + 3 > len(rom):
            break
        x = rom[off]
        tile = rom[off + 1]
        attr = rom[off + 2]
        off += 3
        parts.append((signed8(y), signed8(x), tile, attr))
    return parts


def metasprite_bounds(parts: list[tuple[int, int, int, int]]) -> tuple[int, int, int, int] | None:
    """Return (min_x, min_y, width, height) in the coordinate space used by
    the game's OAM writer.
    """
    if not parts:
        return None
    min_x = min(x for _y, x, _tile, _attr in parts)
    min_y = min(y for y, _x, _tile, _attr in parts)
    max_x = max(x + 8 for _y, x, _tile, _attr in parts)
    max_y = max(y + 8 for y, _x, _tile, _attr in parts)
    return min_x, min_y, max_x - min_x, max_y - min_y


def decode_obj_2bpp_tile(vram: bytes, tile_id: int) -> list[int]:
    off = (int(tile_id) & 0xFF) * 16
    if off < 0 or off + 16 > len(vram):
        return [0] * 64
    tile = vram[off:off + 16]
    out: list[int] = []
    for y in range(8):
        lo = tile[y * 2]
        hi = tile[y * 2 + 1]
        for bit in range(7, -1, -1):
            out.append(((hi >> bit) & 1) << 1 | ((lo >> bit) & 1))
    return out


def _read_u16_bank0(rom: bytes, ptr: int) -> int:
    # Some special scenes, notably stage4/tutorial, have pointer table entries
    # that are not valid fixed-bank addresses for the normal enemy animation
    # tables.  Treat those as absent instead of aborting object icon export.
    if not 0 <= ptr <= 0x3FFE:
        return 0
    off = rom_offset(0, ptr)
    if off < 0 or off + 2 > len(rom):
        return 0
    return rom[off] | (rom[off + 1] << 8)


def _stage_anim_table_ptr(rom: bytes, stage_index: int | None) -> int:
    if stage_index is None or not 0 <= int(stage_index) < STAGE_COUNT:
        return 0
    ptr = _read_u16_bank0(rom, 0x1B25 + (int(stage_index) * 2))
    return ptr if 0 <= ptr <= 0x3FFE else 0


def resolve_object_icon_metasprite_candidates(rom: bytes, typ: int, stage_index: int | None = None) -> list[tuple[int, int]]:
    typ &= 0x7F
    ptr = OBJECT_METASPRITE_PTRS.get(typ)
    if ptr is not None:
        return [(object_metasprite_bank_for_ptr(ptr), ptr)]

    anim_ids = OBJECT_ANIM_ID_CANDIDATES.get(typ)
    if anim_ids is None:
        anim_id = OBJECT_ANIM_IDS.get(typ)
        anim_ids = [] if anim_id is None else [anim_id]
    if not anim_ids:
        return []

    # Prefer the current stage's object animation table.  If that table is
    # missing/invalid or the chosen frame is empty because the stage-specific OBJ
    # graphics are not loaded in the editor reconstruction, try other normal
    # stages as preview fallbacks.  This keeps stage1/stage4 Tiled views useful
    # without changing the imported spawn data.
    stage_order: list[int] = []
    preferred = OBJECT_PREVIEW_STAGE_PRIORITY.get(typ, [])
    for st in preferred:
        if 0 <= int(st) < STAGE_COUNT and int(st) not in stage_order:
            stage_order.append(int(st))
    if stage_index is not None and 0 <= int(stage_index) < STAGE_COUNT and int(stage_index) not in stage_order:
        stage_order.append(int(stage_index))
    for st in (0, 1, 2, 3):
        if st not in stage_order:
            stage_order.append(st)

    out: list[tuple[int, int]] = []
    seen: set[tuple[int, int]] = set()
    for st in stage_order:
        table = _stage_anim_table_ptr(rom, st)
        if table == 0:
            continue
        for anim_id in anim_ids:
            ptr = _read_u16_bank0(rom, table + (int(anim_id) * 2))
            if ptr == 0 or ptr >= 0x4000:
                continue
            item = (0, ptr)
            if item not in seen:
                seen.add(item)
                out.append(item)
    return out


def resolve_object_icon_metasprite_ptr(rom: bytes, typ: int, stage_index: int | None = None) -> tuple[int, int] | None:
    candidates = resolve_object_icon_metasprite_candidates(rom, typ, stage_index)
    return candidates[0] if candidates else None


def object_icon_supported(typ: int) -> bool:
    typ &= 0x7F
    return typ in OBJECT_METASPRITE_PTRS or typ in OBJECT_ANIM_IDS


def object_type_uses_oam_bounds(typ: int) -> bool:
    """Return True when the editor box should be derived from the real metasprite footprint.

    v15g applied OAM-derived bounds to every object with an icon. That fixed
    16x24 enemies, but it regressed pickups such as Chocobi/bonus counters: their
    first idle metasprite may have a smaller occupied footprint than the intended
    editable pickup cell, so Tiled rendered them as squashed/narrow icons.

    Keep pickups/forms at their fixed 16x16 profile, and use OAM-derived bounds
    for actor/platform classes where the footprint genuinely differs by type.
    """
    typ &= 0x7F
    return typ in {0x08, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x22, 0x23}


def object_icon_oam_bounds(rom: bytes, typ: int, stage_index: int | None = None) -> tuple[int, int, int, int] | None:
    for bank, ptr in resolve_object_icon_metasprite_candidates(rom, typ, stage_index):
        parts = parse_metasprite(rom, bank, ptr)
        if parts:
            bounds = metasprite_bounds(parts)
            if bounds is not None:
                return bounds
    return None


def render_object_icon_rgba(
    rom: bytes,
    vram: bytes,
    typ: int,
    palette: Sequence[int],
    width: int = 16,
    height: int = 16,
    stage_index: int | None = None,
) -> bytes:
    # Try the current-stage metasprite first, then preview fallbacks.  Return the
    # first candidate that actually draws non-transparent pixels with the
    # reconstructed VRAM.
    for bank, ptr in resolve_object_icon_metasprite_candidates(rom, typ, stage_index):
        rgba = bytearray(width * height * 4)
        parts = parse_metasprite(rom, bank, ptr)
        if not parts:
            continue
        bounds = metasprite_bounds(parts)
        if bounds is None:
            continue
        min_x, min_y, w, h = bounds
        base_x = (width - w) // 2 - min_x
        base_y = (height - h) // 2 - min_y
        for yoff, xoff, tile_id, attr in parts:
            pix = decode_obj_2bpp_tile(vram, tile_id)
            xflip = bool(attr & 0x20)
            yflip = bool(attr & 0x40)
            for ty in range(8):
                sy = 7 - ty if yflip else ty
                dy = base_y + yoff + ty
                if dy < 0 or dy >= height:
                    continue
                for tx in range(8):
                    sx = 7 - tx if xflip else tx
                    dx = base_x + xoff + tx
                    if dx < 0 or dx >= width:
                        continue
                    color = pix[sy * 8 + sx]
                    if color == 0:
                        continue
                    shade = int(palette[color])
                    pos = (dy * width + dx) * 4
                    rgba[pos:pos + 4] = bytes([shade, shade, shade, 255])
        if any(rgba[i + 3] for i in range(0, len(rgba), 4)):
            return bytes(rgba)
    return bytes(bytearray(width * height * 4))



def object_preview_vram_contexts(rom: bytes, stage: StageAssets, profile: dict[str, object], typ: int) -> list[bytes]:
    """Return VRAM contexts to try for editor-only object icon rendering.

    The real game may pair the same object type with stage-specific OBJ graphics.
    For Tiled previews, try the current stage first, then known-good preview
    stages so stage1 can still show useful enemy icons even when its local
    reconstructed VRAM does not contain the needed enemy tiles.
    """
    vram_variant = int(profile.get("vram_variant", 0))
    stage_order: list[int] = []
    # If a type has a known-good preview stage, keep its metasprite and OBJ VRAM
    # context paired by trying that stage first.  v15k only prioritized the
    # metasprite pointer; stage0 could still render the party-horn kid with
    # stage0 VRAM and stop on a non-empty-but-wrong icon.
    for st in OBJECT_PREVIEW_STAGE_PRIORITY.get(typ & 0x7F, []):
        if 0 <= int(st) < STAGE_COUNT and int(st) not in stage_order:
            stage_order.append(int(st))
    if stage.index not in stage_order:
        stage_order.append(stage.index)
    for st in (0, 1, 2, 3):
        if st not in stage_order:
            stage_order.append(st)
    stages = load_stage_assets(rom)
    contexts: list[bytes] = []
    seen: set[bytes] = set()
    for st in stage_order:
        try:
            vram, _ = reconstruct_bg_vram(rom, stages[st], include_form_gfx=True, vram_variant=(vram_variant if st == stage.index else 0))
        except Exception:
            continue
        if vram not in seen:
            seen.add(vram)
            contexts.append(vram)
    return contexts


def render_object_icon_rgba_with_vram_fallbacks(
    rom: bytes,
    vram_contexts: Sequence[bytes],
    typ: int,
    palette: Sequence[int],
    width: int,
    height: int,
    stage_index: int | None = None,
) -> bytes:
    for vram in vram_contexts:
        rgba = render_object_icon_rgba(rom, vram, typ, palette, width, height, stage_index)
        if any(rgba[i + 3] for i in range(0, len(rgba), 4)):
            return rgba
    return bytes(bytearray(width * height * 4))

def write_object_icon_collection_tsx(
    tsx_path: Path,
    image_dir: Path,
    rom: bytes,
    stage: StageAssets,
    profile: dict[str, object],
    palette: Sequence[int],
    tile_count: int = 0x28,
) -> tuple[int, int, int, dict[int, tuple[int, int, int, int]]]:
    """Write a Tiled image-collection tileset for object icons.

    Unlike a uniform 16x16 tilesheet, this allows enemies to be native 16x24 and
    platforms to be native 32x16, so Tiled does not stretch the icon to match the
    object box.
    """
    image_dir.mkdir(parents=True, exist_ok=True)
    root = ET.Element("tileset", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "name": "object_icons",
        "tilewidth": "32",
        "tileheight": "24",
        "tilecount": str(tile_count),
        "columns": "0",
    })
    bounds_by_type: dict[int, tuple[int, int, int, int]] = {}
    for typ in range(tile_count):
        if not object_icon_supported(typ):
            continue
        prof = object_profile_for_type(typ)
        bounds = object_icon_oam_bounds(rom, typ, stage.index) if object_type_uses_oam_bounds(typ) else None
        if bounds is not None:
            bounds_by_type[typ] = bounds
            _dx, _dy, w, h = bounds
        else:
            # Pickups/forms intentionally stay at their editor profile size
            # instead of shrinking to the non-transparent OAM footprint.
            w = int(prof.get("width", 16))
            h = int(prof.get("height", 16))
        vram_contexts = object_preview_vram_contexts(rom, stage, profile, typ)
        rgba = render_object_icon_rgba_with_vram_fallbacks(rom, vram_contexts, typ, palette, w, h, stage.index)
        if not any(rgba[i + 3] for i in range(0, len(rgba), 4)):
            continue
        img_path = image_dir / f"object_{typ:02x}.png"
        write_png_rgba(img_path, rgba, w, h)
        tile = ET.SubElement(root, "tile", {"id": str(typ)})
        ET.SubElement(tile, "image", {
            "source": relpath_for_xml(img_path, tsx_path.parent),
            "width": str(w),
            "height": str(h),
        })
    ET.indent(root)
    tsx_path.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(root).write(tsx_path, encoding="UTF-8", xml_declaration=True)
    return 32, 24, tile_count, bounds_by_type


def write_object_tiled_tsx(tsx_path: Path, image_path: Path, image_width: int, image_height: int, tile_count: int, columns: int = 8) -> None:
    root = ET.Element("tileset", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "name": "object_icons",
        "tilewidth": "16",
        "tileheight": "16",
        "tilecount": str(tile_count),
        "columns": str(columns),
    })
    ET.SubElement(root, "image", {
        "source": relpath_for_xml(image_path, tsx_path.parent),
        "width": str(image_width),
        "height": str(image_height),
    })
    for typ in range(tile_count):
        profile = object_profile_for_type(typ)
        tile = ET.SubElement(root, "tile", {"id": str(typ), "type": str(profile.get("name") or f"OBJ_{typ:02x}")})
        props = ET.SubElement(tile, "properties")
        _int_prop(props, "object_type", typ)
    ET.indent(root)
    tsx_path.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(root).write(tsx_path, encoding="UTF-8", xml_declaration=True)

def write_tiled_tsx(tsx_path: Path, image_path: Path, profile: dict[str, object], image_width: int, image_height: int, tile_count: int, columns: int = 16) -> None:
    root = ET.Element("tileset", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "name": f"stage_profile_{profile['name']}",
        "tilewidth": "16",
        "tileheight": "16",
        "tilecount": str(tile_count),
        "columns": str(columns),
    })
    props = ET.SubElement(root, "properties")
    for key in ("name", "label", "vram_variant", "metatile_variant", "collision_variant"):
        ET.SubElement(props, "property", {"name": str(key), "value": str(profile.get(key, ""))})
    ET.SubElement(root, "image", {
        "source": relpath_for_xml(image_path, tsx_path.parent),
        "width": str(image_width),
        "height": str(image_height),
    })
    ET.indent(root)
    tsx_path.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(root).write(tsx_path, encoding="UTF-8", xml_declaration=True)



def _le_word(data: list[int], offset: int) -> int:
    return int(data[offset]) | (int(data[offset + 1]) << 8)


def _camera_scroll_rect(cam_x_min: int, cam_x_max: int, cam_y_max: int, world_w: int, world_h: int) -> tuple[int, int, int, int]:
    # cam_x_max / cam_y_max are scroll limits. Convert them to the world
    # coverage rectangle visible across the full camera range by adding the
    # gameplay viewport. The LCD is 0x90 pixels tall, but this game starts the
    # Window/HUD at WY=0x80, so only the top 0x80 pixels are stage playfield.
    x0 = max(0, int(cam_x_min))
    y0 = 0
    x1 = min(world_w, int(cam_x_max) + LCD_VIEWPORT_W)
    y1 = min(world_h, int(cam_y_max) + GAMEPLAY_VIEWPORT_H)
    if x1 <= x0:
        x1 = min(world_w, x0 + 16)
    if y1 <= y0:
        y1 = min(world_h, y0 + 16)
    return x0, y0, x1 - x0, y1 - y0


def stage_camera_reference_profiles(stage_index: int, width_mt: int, height_mt: int) -> list[dict[str, object]]:
    """Return decoded camera/player clamp profiles for editor reference.

    This follows the code path that initializes $c40e/$c418/$c410/$c414 and
    related camera runtime variables. The important distinction is:

      $c40e/$c40f = camera scroll X min
      $c418/$c419 = camera scroll X max
      $c41a/$c41b = camera scroll Y max
      $c410/$c411 = player world X min
      $c414/$c415 = player world X max

    Older tool versions incorrectly treated $c414 as a camera bound.
    """
    world_w = width_mt * 16
    world_h = height_mt * 16

    # Generic stage init block copied to $c414 onward. The first word is
    # player_x_max, the third word is camera_x_max, and the fourth is
    # camera_y_max. player_x_min/camera_x_min are set earlier to $0008/$0000.
    generic_init_blocks = {
        0: ("init_block_0_1_4", [0xF8, 0x0D, 0xFF, 0x00, 0x60, 0x0D, 0x80, 0x00]),
        1: ("init_block_0_1_4", [0xF8, 0x0D, 0xFF, 0x00, 0x60, 0x0D, 0x80, 0x00]),
        2: ("init_block_2",     [0x00, 0x04, 0x00, 0x04, 0x60, 0x03, 0x80, 0x03]),
        3: ("init_block_3",     [0xF8, 0x09, 0x00, 0x05, 0x60, 0x09, 0x80, 0x04]),
    }

    out: list[dict[str, object]] = []

    if stage_index in generic_init_blocks:
        name, b = generic_init_blocks[stage_index]
        player_x_min = 0x0008
        player_x_max = _le_word(b, 0)
        unknown_416 = _le_word(b, 2)
        cam_x_min = 0x0000
        cam_x_max = _le_word(b, 4)
        cam_y_max = _le_word(b, 6)
        x, y, w, h = _camera_scroll_rect(cam_x_min, cam_x_max, cam_y_max, world_w, world_h)
        out.append({
            "name": name,
            "kind": "generic_init",
            "source_label": "StageInitBlock_0_1_4" if stage_index in (0, 1, 4) else ("StageInitBlock_2" if stage_index == 2 else "StageInitBlock_3"),
            "source_writable": True,
            "camera_x_min": cam_x_min,
            "camera_x_max": cam_x_max,
            "camera_y_max": cam_y_max,
            "player_x_min": player_x_min,
            "player_x_max": player_x_max,
            "unknown_c416": unknown_416,
            "scroll_rect": (x, y, w, h),
            "note": "decoded from stage init block; $c414 is player_x_max, not camera bound",
        })

    # Stage 1 has additional 16-byte camera/start profiles selected by c0b4/c0bc.
    if stage_index == 1:
        stage1_profiles = [
            ("stage1_profile_0_447f", [0x00,0x00, 0x60,0x04, 0x08,0x00, 0x00,0x05, 0x18,0x00, 0x70,0x00, 0x00,0x00, 0x18,0x00]),
            ("stage1_profile_1_448f", [0x00,0x05, 0x60,0x08, 0x08,0x05, 0x00,0x09, 0x18,0x05, 0xC0,0x00, 0x00,0x05, 0x68,0x00]),
            ("stage1_profile_2_449f", [0x00,0x09, 0x60,0x0D, 0x08,0x09, 0xF8,0x0D, 0x18,0x09, 0xF0,0x00, 0x00,0x09, 0x80,0x00]),
            # The last profile is emitted as code-looking bytes by mgbdis, but
            # jr_001_4475 explicitly loads HL=$44af and falls through the same
            # 16-byte copier. Keep it as decoded reference data.
            ("stage1_resume_profile_44af", [0x00,0x05, 0x60,0x08, 0x08,0x05, 0x00,0x09, 0x28,0x05, 0x80,0x00, 0xD3,0x06, 0x28,0x00]),
        ]
        label_by_name = {
            "stage1_profile_0_447f": "Stage1CameraProfile0",
            "stage1_profile_1_448f": "Stage1CameraProfile1",
            "stage1_profile_2_449f": "Stage1CameraProfileAfterCheckpoint2",
            "stage1_resume_profile_44af": "Stage1CameraProfileResume",
        }
        writable_by_name = {
            "stage1_profile_0_447f": True,
            "stage1_profile_1_448f": True,
            "stage1_profile_2_449f": True,
            # Resume is still intentionally emitted as instruction-looking raw bytes
            # in the current source, so do not rewrite it from Tiled yet.
            "stage1_resume_profile_44af": False,
        }
        for name, b in stage1_profiles:
            cam_x_min = _le_word(b, 0)
            cam_x_max = _le_word(b, 2)
            player_x_min = _le_word(b, 4)
            player_x_max = _le_word(b, 6)
            player_start_x = _le_word(b, 8)
            player_start_y = _le_word(b, 10)
            initial_scx = _le_word(b, 12)
            initial_scy = _le_word(b, 14)
            # Stage 1 profile table does not set a Y max in this 16-byte record.
            # Use the generic stage init Y max as a conservative reference.
            cam_y_max = 0x0080
            x, y, w, h = _camera_scroll_rect(cam_x_min, cam_x_max, cam_y_max, world_w, world_h)
            out.append({
                "name": name,
                "kind": "stage1_special_profile",
                "source_label": label_by_name.get(name, ""),
                "source_writable": writable_by_name.get(name, False),
                "camera_x_min": cam_x_min,
                "camera_x_max": cam_x_max,
                "camera_y_max": cam_y_max,
                "player_x_min": player_x_min,
                "player_x_max": player_x_max,
                "player_start_x": player_start_x,
                "player_start_y": player_start_y,
                "initial_scx": initial_scx,
                "initial_scy": initial_scy,
                "scroll_rect": (x, y, w, h),
                "note": "stage1 special camera/start profile selected by c0b4/c0bc",
            })

    if stage_index == 4:
        out.append({
            "name": "tutorial_special_scene",
            "kind": "tutorial_special",
            "source_label": "",
            "source_writable": False,
            "camera_x_min": 0,
            "camera_x_max": max(0, world_w - 0xA0),
            "camera_y_max": max(0, world_h - GAMEPLAY_VIEWPORT_H),
            "player_x_min": 0,
            "player_x_max": world_w,
            "scroll_rect": (0, 0, world_w, world_h),
            "note": "stage4 uses a tutorial/special scene path, not the normal scrolling stage path",
        })

    return out


def _append_rect_object(group: ET.Element, obj_id: int, name: str, obj_type: str, x: int, y: int, width: int, height: int, props_dict: dict[str, object] | None = None) -> int:
    obj = ET.SubElement(group, "object", {
        "id": str(obj_id),
        "name": name,
        "type": obj_type,
        "x": str(int(x)),
        "y": str(int(y)),
        "width": str(int(width)),
        "height": str(int(height)),
    })
    if props_dict:
        props = ET.SubElement(obj, "properties")
        for key, value in props_dict.items():
            if isinstance(value, bool):
                ET.SubElement(props, "property", {"name": str(key), "type": "bool", "value": "true" if value else "false"})
            elif isinstance(value, int):
                ET.SubElement(props, "property", {"name": str(key), "type": "int", "value": str(value)})
            else:
                ET.SubElement(props, "property", {"name": str(key), "value": str(value)})
    return obj_id + 1


def append_world_bounds_layer(root: ET.Element, layer_id: int, width_mt: int, height_mt: int) -> int:
    group = ET.SubElement(root, "objectgroup", {"id": str(layer_id), "name": "World Bounds", "visible": "0"})
    next_obj_id = int(root.attrib.get("nextobjectid", "1"))
    next_obj_id = _append_rect_object(
        group,
        next_obj_id,
        "world_layout_bounds",
        "WORLD_BOUNDS_READONLY",
        0,
        0,
        width_mt * 16,
        height_mt * 16,
        {
            "editable": False,
            "width_metatiles": width_mt,
            "height_metatiles": height_mt,
            "note": "actual TMX/world_map layout extent; reference only; not imported to ROM",
        },
    )
    root.set("nextobjectid", str(next_obj_id))
    return layer_id + 1


def append_camera_scroll_range_layer(root: ET.Element, layer_id: int, stage_index: int, width_mt: int, height_mt: int) -> int:
    group = ET.SubElement(root, "objectgroup", {"id": str(layer_id), "name": "Camera Scroll Range", "visible": "0"})
    next_obj_id = int(root.attrib.get("nextobjectid", "1"))
    for item in stage_camera_reference_profiles(stage_index, width_mt, height_mt):
        x, y, w, h = item["scroll_rect"]
        next_obj_id = _append_rect_object(
            group,
            next_obj_id,
            f"camera_scroll_{item['name']}",
            "CAMERA_SCROLL_RANGE",
            int(x),
            int(y),
            int(w),
            int(h),
            {
                "editable": bool(item.get("source_writable", False)),
                "stage": stage_index,
                "source_label": str(item.get("source_label", "")),
                "source_writable": bool(item.get("source_writable", False)),
                "profile_kind": item.get("kind", "unknown"),
                "camera_x_min": int(item.get("camera_x_min", 0)),
                "camera_x_max": int(item.get("camera_x_max", 0)),
                "camera_y_max": int(item.get("camera_y_max", 0)),
                "visible_width": LCD_VIEWPORT_W,
                "visible_height": GAMEPLAY_VIEWPORT_H,
                "hud_start_screen_y": HUD_START_Y,
                "note": str(item.get("note", "reference only; not imported to ROM")) + "; height uses gameplay viewport $80 because bottom $10 px is HUD/window",
            },
        )
    root.set("nextobjectid", str(next_obj_id))
    return layer_id + 1


def append_player_x_clamp_layer(root: ET.Element, layer_id: int, stage_index: int, width_mt: int, height_mt: int) -> int:
    group = ET.SubElement(root, "objectgroup", {"id": str(layer_id), "name": "Player X Clamp", "visible": "0"})
    next_obj_id = int(root.attrib.get("nextobjectid", "1"))
    world_h = height_mt * 16
    for item in stage_camera_reference_profiles(stage_index, width_mt, height_mt):
        x0 = int(item.get("player_x_min", 0))
        x1 = int(item.get("player_x_max", x0 + 16))
        if x1 <= x0:
            x1 = x0 + 16
        next_obj_id = _append_rect_object(
            group,
            next_obj_id,
            f"player_x_clamp_{item['name']}",
            "PLAYER_X_CLAMP_READONLY",
            x0,
            0,
            x1 - x0,
            world_h,
            {
                "editable": False,
                "stage": stage_index,
                "profile_kind": item.get("kind", "unknown"),
                "player_x_min": x0,
                "player_x_max": x1,
                "note": item.get("note", "reference only; not imported to ROM"),
            },
        )
    root.set("nextobjectid", str(next_obj_id))
    return layer_id + 1


def append_hud_boundary_layer(root: ET.Element, layer_id: int, stage_index: int, width_mt: int, height_mt: int) -> int:
    # Reference line showing where the Window/HUD begins on the screen when
    # the camera is at its maximum vertical scroll. This is hidden by default
    # and not imported; it explains why full LCD coverage is 0x10 px taller
    # than the gameplay camera coverage.
    group = ET.SubElement(root, "objectgroup", {"id": str(layer_id), "name": "HUD Boundary", "visible": "0"})
    next_obj_id = int(root.attrib.get("nextobjectid", "1"))
    world_w = width_mt * 16
    for item in stage_camera_reference_profiles(stage_index, width_mt, height_mt):
        y = int(item.get("camera_y_max", 0)) + HUD_START_Y
        next_obj_id = _append_rect_object(
            group,
            next_obj_id,
            f"hud_boundary_{item['name']}",
            "HUD_BOUNDARY_READONLY",
            0,
            y,
            world_w,
            1,
            {
                "editable": False,
                "stage": stage_index,
                "profile_kind": item.get("kind", "unknown"),
                "camera_y_max": int(item.get("camera_y_max", 0)),
                "hud_start_screen_y": HUD_START_Y,
                "hud_height": HUD_HEIGHT,
                "note": "HUD/window starts at screen Y=$80; stage camera playfield coverage stops here; not imported to ROM",
            },
        )
    root.set("nextobjectid", str(next_obj_id))
    return layer_id + 1


def append_camera_debug_layer(root: ET.Element, layer_id: int, stage_index: int, width_mt: int, height_mt: int) -> int:
    group = ET.SubElement(root, "objectgroup", {"id": str(layer_id), "name": "Camera Debug Values", "visible": "0"})
    next_obj_id = int(root.attrib.get("nextobjectid", "1"))
    for item in stage_camera_reference_profiles(stage_index, width_mt, height_mt):
        props = {
            "editable": False,
            "stage": stage_index,
            "profile_kind": item.get("kind", "unknown"),
            "camera_x_min": int(item.get("camera_x_min", 0)),
            "camera_x_max": int(item.get("camera_x_max", 0)),
            "camera_y_max": int(item.get("camera_y_max", 0)),
            "player_x_min": int(item.get("player_x_min", 0)),
            "player_x_max": int(item.get("player_x_max", 0)),
            "note": item.get("note", "debug only; not imported to ROM"),
        }
        for key in ("unknown_c416", "player_start_x", "player_start_y", "initial_scx", "initial_scy"):
            if key in item:
                props[key] = int(item[key])
        # Tiny marker object. The useful information is in properties; the
        # visual range is represented by the two dedicated layers above.
        next_obj_id = _append_rect_object(
            group,
            next_obj_id,
            f"camera_debug_values_{item['name']}",
            "CAMERA_DEBUG_VALUES_READONLY",
            int(item.get("camera_x_min", 0)),
            0,
            16,
            16,
            props,
        )
    root.set("nextobjectid", str(next_obj_id))
    return layer_id + 1

def append_reference_layers(root: ET.Element, layer_id: int, stage_index: int, width_mt: int, height_mt: int) -> int:
    # Keep the editor TMX clean: only include reference layers that are broadly useful.
    # HUD boundary and player-X clamp are derived/debug-only and were easy to mistake
    # for editable level data, so v16e stops exporting those layers.
    layer_id = append_world_bounds_layer(root, layer_id, width_mt, height_mt)
    layer_id = append_camera_scroll_range_layer(root, layer_id, stage_index, width_mt, height_mt)
    layer_id = append_camera_debug_layer(root, layer_id, stage_index, width_mt, height_mt)
    return layer_id

def write_tiled_tmx(
    tmx_path: Path,
    tsx_path: Path,
    world_map: bytes,
    page_rows: int,
    stage_index: int,
    profile: dict[str, object],
    spawns: bytes | None = None,
    page_cols: int = PAGE_COLS,
    object_tsx_path: Path | None = None,
    object_tile_count: int = 0x28,
    object_icon_bounds: dict[int, tuple[int, int, int, int]] | None = None,
) -> None:
    width_mt = page_cols * PAGE_W
    height_mt = page_rows * PAGE_H
    if len(world_map) != width_mt * height_mt:
        raise ValueError("world_map size does not match page_rows")
    has_spawns = spawns is not None
    root = ET.Element("map", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "orientation": "orthogonal",
        "renderorder": "right-down",
        "width": str(width_mt),
        "height": str(height_mt),
        "tilewidth": "16",
        "tileheight": "16",
        "infinite": "0",
        "nextlayerid": "5" if has_spawns else "3",
        "nextobjectid": "1",
    })
    props = ET.SubElement(root, "properties")
    for key, value in [
        ("game", "Shin-chan 4"),
        ("stage", stage_index),
        ("profile", profile.get("name", "normal")),
        ("vram_variant", profile.get("vram_variant", 0)),
        ("metatile_variant", profile.get("metatile_variant", 0)),
        ("collision_variant", profile.get("collision_variant", 0)),
        ("source_format", "world_map.raw metatile ids; gid = metatile_id + 1; Spawns/Stage Events x/y are visual editor boxes; raw spawn offset comes from object_profiles.json"),
    ]:
        ET.SubElement(props, "property", {"name": str(key), "value": str(value)})
    ET.SubElement(root, "tileset", {"firstgid": "1", "source": relpath_for_xml(tsx_path, tmx_path.parent)})
    object_firstgid = None
    if object_tsx_path is not None:
        object_firstgid = 1 + 256
        ET.SubElement(root, "tileset", {"firstgid": str(object_firstgid), "source": relpath_for_xml(object_tsx_path, tmx_path.parent)})
    layer = ET.SubElement(root, "layer", {"id": "1", "name": "Layout", "width": str(width_mt), "height": str(height_mt)})
    data = ET.SubElement(layer, "data", {"encoding": "csv"})
    lines: list[str] = []
    for y in range(height_mt):
        row = [str(world_map[y * width_mt + x] + 1) for x in range(width_mt)]
        lines.append(",".join(row))
    data.text = "\n" + ",\n".join(lines) + "\n"
    next_layer_id = 2
    if has_spawns:
        normal_group = ET.SubElement(root, "objectgroup", {"id": str(next_layer_id), "name": "Spawns"})
        next_layer_id += 1
        next_obj = spawns_to_tiled_objects(
            normal_group,
            spawns or b"\xff",
            object_firstgid=object_firstgid,
            object_icon_bounds=object_icon_bounds,
            exclude_types=STAGE_EVENT_OBJECT_TYPES,
            start_id=1,
        )
        event_group = ET.SubElement(root, "objectgroup", {"id": str(next_layer_id), "name": "Stage Events"})
        next_layer_id += 1
        next_obj = spawns_to_tiled_objects(
            event_group,
            spawns or b"\xff",
            object_firstgid=object_firstgid,
            object_icon_bounds=object_icon_bounds,
            include_types=STAGE_EVENT_OBJECT_TYPES,
            start_id=next_obj,
        )
        root.set("nextobjectid", str(next_obj))
    next_layer_id = append_reference_layers(root, next_layer_id, stage_index, width_mt, height_mt)
    root.set("nextlayerid", str(next_layer_id))
    ET.indent(root)
    tmx_path.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(root).write(tmx_path, encoding="UTF-8", xml_declaration=True)


def read_tiled_layer_csv(tmx_path: Path, layer_name: str = "Layout") -> tuple[bytes, int, int, dict[str, str]]:
    tree = ET.parse(tmx_path)
    root = tree.getroot()
    width = int(root.attrib["width"])
    height = int(root.attrib["height"])
    props: dict[str, str] = {}
    props_node = root.find("properties")
    if props_node is not None:
        for prop in props_node.findall("property"):
            props[prop.attrib.get("name", "")] = prop.attrib.get("value", "")
    layer = None
    for candidate in root.findall("layer"):
        if candidate.attrib.get("name") == layer_name:
            layer = candidate
            break
    if layer is None:
        layers = root.findall("layer")
        if not layers:
            raise ValueError("TMX has no tile layers")
        layer = layers[0]
    lw = int(layer.attrib.get("width", width))
    lh = int(layer.attrib.get("height", height))
    if lw != width or lh != height:
        raise ValueError("layer size differs from map size; unsupported")
    data = layer.find("data")
    if data is None:
        raise ValueError("tile layer has no data node")
    if data.attrib.get("encoding") != "csv":
        raise ValueError("only CSV-encoded TMX tile layers are supported in this MVP")
    text = data.text or ""
    values = [v.strip() for v in text.replace("\n", ",").split(",") if v.strip()]
    if len(values) != width * height:
        raise ValueError(f"TMX layer has {len(values)} gids, expected {width * height}")
    out = bytearray()
    for idx, item in enumerate(values):
        gid = int(item, 0) & 0x1FFFFFFF  # strip Tiled flip flags if present
        if gid == 0:
            mt = 0
        else:
            mt = gid - 1
        if not 0 <= mt <= 0xFF:
            y, x = divmod(idx, width)
            raise ValueError(f"metatile id out of range at x={x} y={y}: gid={gid} -> mt={mt}")
        out.append(mt)
    return bytes(out), width, height, props


def command_export_tiled(args: argparse.Namespace) -> None:
    if getattr(args, "object_profiles", None):
        apply_object_profiles_json(args.object_profiles)
    rom = args.rom.read_bytes()
    stage = load_stage_assets(rom)[args.stage]
    layout_raw, page_table, world_map, page_rows = build_stage_world_map_in_memory(rom, stage)
    # Preserve the exact original RLEFF stream used by the ROM.
    layout_rle_source = slice_rom(rom, LEVEL_DATA_BANK, stage.layout_ptr, stage.layout_end)
    _layout_check, layout_rle_consumed = rleff_decode(layout_rle_source, stage.layout_decoded_size)
    layout_rle_exact = layout_rle_source[:layout_rle_consumed]
    spawns = slice_rom(rom, SPAWN_BANK, stage.spawn_ptr, stage.spawn_end)
    profiles = stage_profile_names(args.stage) if args.profile == "all" else [args.profile]
    base_stage_dir = args.outdir / f"stage{args.stage}"
    base_stage_dir.mkdir(parents=True, exist_ok=True)
    base_stage_dir.joinpath("world_map.raw").write_bytes(world_map)
    base_stage_dir.joinpath("page_table.bin").write_bytes(page_table)
    base_stage_dir.joinpath("layout.rleff").write_bytes(layout_rle_exact)
    base_stage_dir.joinpath("spawns.bin").write_bytes(spawns)
    write_spawns_csv(base_stage_dir / "spawns.csv", spawns)
    stage_object_bounds: dict[int, tuple[int, int, int, int]] = {}
    base_stage_dir.joinpath("stage_meta.txt").write_text(
        f"stage={args.stage}\npage_rows={page_rows}\npage_cols={stage_page_cols(args.stage)}\nwidth_metatiles={stage_page_cols(args.stage) * PAGE_W}\nheight_metatiles={page_rows * PAGE_H}\nspawn_count={len(parse_spawn_records(spawns))}\n",
        encoding="utf-8",
    )
    for profile_name in profiles:
        profile = resolve_stage_profile(args.stage, profile_name)
        stem = f"stage{args.stage}_{profile['name']}"
        tileset_png = base_stage_dir / f"{stem}_tileset.png"
        tsx = base_stage_dir / f"{stem}.tsx"
        tmx = base_stage_dir / f"{stem}.tmx"
        iw, ih, count = write_metatile_tileset_png(tileset_png, rom, stage, profile, DMG_PALETTE_LIGHT_TO_DARK)
        write_tiled_tsx(tsx, tileset_png, profile, iw, ih, count)
        object_icons_dir = base_stage_dir / f"{stem}_object_icons"
        object_tsx = base_stage_dir / f"{stem}_object_icons.tsx"
        _obj_w, _obj_h, obj_count, obj_bounds = write_object_icon_collection_tsx(object_tsx, object_icons_dir, rom, stage, profile, DMG_PALETTE_LIGHT_TO_DARK)
        for typ, bounds in obj_bounds.items():
            if object_type_uses_oam_bounds(typ):
                stage_object_bounds[typ & 0x7F] = bounds
        write_tiled_tmx(
            tmx,
            tsx,
            world_map,
            page_rows,
            args.stage,
            profile,
            spawns=spawns,
            page_cols=stage_page_cols(args.stage),
            object_tsx_path=object_tsx,
            object_tile_count=obj_count,
            object_icon_bounds=obj_bounds,
        )
        print(f"exported Tiled stage{args.stage} profile={profile['name']}: {tmx} (spawns={len(parse_spawn_records(spawns))})")
    # Keep the editable object UI small.  Technical per-type offsets/bounds are
    # stored here instead of being repeated on every Tiled object.
    write_object_profiles_json(base_stage_dir / "object_profiles.json", overrides=stage_object_bounds)


def export_tiled_stage(rom_path: Path, stage_index: int, outdir: Path, profile: str = "default", object_profiles: Path | None = None) -> None:
    ns = argparse.Namespace(rom=rom_path, stage=stage_index, outdir=outdir, profile=profile, object_profiles=object_profiles)
    command_export_tiled(ns)


def command_export_tiled_all(args: argparse.Namespace) -> None:
    stages = parse_stage_list(args.stages)
    for stage_index in stages:
        if stage_index == 1 and args.stage1_all:
            profile = "all"
        elif stage_index == 2 and args.stage2_all:
            profile = "all"
        else:
            profile = "default"
        try:
            export_tiled_stage(args.rom, stage_index, args.outdir, profile=profile, object_profiles=args.object_profiles)
        except Exception as e:
            raise RuntimeError(f"stage{stage_index}: {e}") from e



def _set_or_add_tmx_property(root: ET.Element, name: str, value: object) -> None:
    props = root.find("properties")
    if props is None:
        props = ET.SubElement(root, "properties")
    for prop in props.findall("property"):
        if prop.attrib.get("name") == name:
            prop.set("value", str(value))
            return
    ET.SubElement(props, "property", {"name": name, "value": str(value)})


def _write_shared_profile_metadata(
    tmx_path: Path,
    stage_index: int,
    current_profile: str,
    profile_tsx_paths: dict[str, Path],
) -> None:
    tree = ET.parse(tmx_path)
    root = tree.getroot()
    _set_or_add_tmx_property(root, "shin4.shared_profiles", "1")
    _set_or_add_tmx_property(root, "shin4.current_profile", current_profile)
    _set_or_add_tmx_property(root, "shin4.profiles", ",".join(profile_tsx_paths.keys()))
    for name, path in profile_tsx_paths.items():
        _set_or_add_tmx_property(root, f"shin4.profile.{name}.tsx", relpath_for_xml(path, tmx_path.parent))
    ET.indent(root)
    tree.write(tmx_path, encoding="UTF-8", xml_declaration=True)


def _replace_first_profile_tileset(tmx_path: Path, profile_name: str) -> None:
    tree = ET.parse(tmx_path)
    root = tree.getroot()
    props: dict[str, str] = {}
    props_node = root.find("properties")
    if props_node is not None:
        for prop in props_node.findall("property"):
            props[prop.attrib.get("name", "")] = prop.attrib.get("value", "")
    source = props.get(f"shin4.profile.{profile_name}.tsx")
    if not source:
        profiles = props.get("shin4.profiles", "")
        raise ValueError(f"profile {profile_name!r} is not available in {tmx_path}; profiles={profiles}")
    replaced = False
    for tileset in root.findall("tileset"):
        if tileset.attrib.get("firstgid") == "1":
            tileset.set("source", source)
            replaced = True
            break
    if not replaced:
        raise ValueError(f"{tmx_path} has no firstgid=1 tileset to switch")
    _set_or_add_tmx_property(root, "profile", profile_name)
    _set_or_add_tmx_property(root, "shin4.current_profile", profile_name)
    ET.indent(root)
    tree.write(tmx_path, encoding="UTF-8", xml_declaration=True)


def write_tiled_profile_switcher_extension(outdir: Path) -> Path:
    """Write an optional Tiled JavaScript extension for switching profile TSX files."""
    ext_dir = outdir / "extensions"
    ext_dir.mkdir(parents=True, exist_ok=True)
    js = ext_dir / "shin4_profile_switcher.js"
    js.write_text(r'''// Shin4 Tiled helper extension (experimental).
// It switches the firstgid=1 metatile tileset while keeping the TMX layout unchanged.
// Reads TMX properties written by export-tiled-shared:
//   shin4.profiles
//   shin4.profile.<name>.tsx
//   shin4.current_profile

(function() {
    var KNOWN_PROFILES = ["normal", "initial", "checkpoint", "after_switch", "after_checkpoint2"];
    var actions = {};

    function prop(map, name, fallback) {
        try {
            var v = map.property(name);
            if (v === undefined || v === null || v === "")
                return fallback;
            return String(v);
        } catch (e) {
            return fallback;
        }
    }

    function currentMap() {
        var asset = tiled.activeAsset;
        if (!asset || !asset.isTileMap)
            return null;
        return asset;
    }

    function profileList(map) {
        var profiles = prop(map, "shin4.profiles", "");
        if (!profiles)
            return [];
        var raw = profiles.split(",");
        var out = [];
        for (var i = 0; i < raw.length; i++) {
            var name = raw[i].replace(/^\s+|\s+$/g, "");
            if (name)
                out.push(name);
        }
        return out;
    }

    function hasProfile(list, profile) {
        for (var i = 0; i < list.length; i++) {
            if (list[i] === profile)
                return true;
        }
        return false;
    }

    function profilePath(map, profile) {
        var explicit = prop(map, "shin4.profile." + profile + ".tsx", "");
        var base = FileInfo.path(map.fileName);
        if (explicit)
            return FileInfo.joinPaths(base, explicit);
        var stage = prop(map, "stage", "");
        return FileInfo.joinPaths(base, "profiles/stage" + stage + "_" + profile + ".tsx");
    }

    function refreshProfileActions() {
        var map = currentMap();
        var list = map ? profileList(map) : [];
        for (var i = 0; i < KNOWN_PROFILES.length; i++) {
            var profile = KNOWN_PROFILES[i];
            var action = actions[profile];
            if (!action)
                continue;
            var available = hasProfile(list, profile);
            action.enabled = available;
            try { action.visible = available; } catch (e) {}
        }
    }

    function switchProfile(profile) {
        var map = currentMap();
        if (!map) {
            tiled.alert("Open a Shin4 TMX map first.");
            return;
        }
        var list = profileList(map);
        if (!hasProfile(list, profile)) {
            tiled.alert("Profile '" + profile + "' is not available for this map.\nAvailable: " + list.join(", "));
            refreshProfileActions();
            return;
        }
        var path = profilePath(map, profile);
        var fmt = tiled.tilesetFormatForFile(path);
        if (!fmt || !fmt.canRead) {
            tiled.alert("No readable tileset format for:\n" + path);
            return;
        }
        var ts = null;
        try {
            ts = fmt.read(path);
        } catch (e) {
            tiled.alert("Could not read profile tileset:\n" + path + "\n" + e);
            return;
        }
        if (!ts || !ts.isTileset) {
            tiled.alert("Profile file did not load as a tileset:\n" + path);
            return;
        }
        var old = null;
        for (var i = 0; i < map.tilesets.length; i++) {
            var name = map.tilesets[i].name;
            if (name.indexOf("stage_profile_") === 0 || name.indexOf("metatile") >= 0) {
                old = map.tilesets[i];
                break;
            }
        }
        if (!old && map.tilesets.length > 0)
            old = map.tilesets[0];
        if (!old) {
            tiled.alert("No tileset found on this map.");
            return;
        }
        var ok = false;
        try {
            map.macro("Switch Shin4 Profile", function() {
                ok = map.replaceTileset(old, ts);
                if (ok) {
                    map.setProperty("profile", profile);
                    map.setProperty("shin4.current_profile", profile);
                }
            });
        } catch (e) {
            tiled.alert("Failed to replace tileset:\n" + e);
            return;
        }
        if (!ok) {
            tiled.alert("Failed to replace tileset. The target tileset may already be referenced, or the old tileset was not found.");
            return;
        }
        refreshProfileActions();
        tiled.log("Shin4 profile switched to " + profile);
    }

    function makeAction(profile) {
        var action = tiled.registerAction("Shin4SwitchProfile_" + profile, function() {
            switchProfile(profile);
        });
        action.text = "Switch Profile: " + profile;
        actions[profile] = action;
    }

    for (var i = 0; i < KNOWN_PROFILES.length; i++)
        makeAction(KNOWN_PROFILES[i]);

    tiled.extendMenu("Map", [
        { separator: true },
        { action: "Shin4SwitchProfile_normal" },
        { action: "Shin4SwitchProfile_initial" },
        { action: "Shin4SwitchProfile_checkpoint" },
        { action: "Shin4SwitchProfile_after_switch" },
        { action: "Shin4SwitchProfile_after_checkpoint2" }
    ]);

    if (tiled.activeAssetChanged)
        tiled.activeAssetChanged.connect(refreshProfileActions);
    if (tiled.assetAboutToBeSaved)
        tiled.assetAboutToBeSaved.connect(refreshProfileActions);
    refreshProfileActions();
})();
''', encoding="utf-8")
    return js


def shared_profile_names_for_stage(stage_index: int) -> list[str]:
    return stage_profile_names(stage_index)


def command_export_tiled_shared(args: argparse.Namespace) -> None:
    if getattr(args, "object_profiles", None):
        apply_object_profiles_json(args.object_profiles)
    rom = args.rom.read_bytes()
    stage = load_stage_assets(rom)[args.stage]
    layout_raw, page_table, world_map, page_rows = build_stage_world_map_in_memory(rom, stage)
    layout_rle_source = slice_rom(rom, LEVEL_DATA_BANK, stage.layout_ptr, stage.layout_end)
    _layout_check, layout_rle_consumed = rleff_decode(layout_rle_source, stage.layout_decoded_size)
    layout_rle_exact = layout_rle_source[:layout_rle_consumed]
    spawns = slice_rom(rom, SPAWN_BANK, stage.spawn_ptr, stage.spawn_end)

    base_stage_dir = args.outdir / f"stage{args.stage}"
    profiles_dir = base_stage_dir / "profiles"
    base_stage_dir.mkdir(parents=True, exist_ok=True)
    profiles_dir.mkdir(parents=True, exist_ok=True)
    base_stage_dir.joinpath("world_map.raw").write_bytes(world_map)
    base_stage_dir.joinpath("page_table.bin").write_bytes(page_table)
    base_stage_dir.joinpath("layout.rleff").write_bytes(layout_rle_exact)
    base_stage_dir.joinpath("spawns.bin").write_bytes(spawns)
    write_spawns_csv(base_stage_dir / "spawns.csv", spawns)
    base_stage_dir.joinpath("stage_meta.txt").write_text(
        f"stage={args.stage}\nshared_tmx=stage{args.stage}.tmx\npage_rows={page_rows}\npage_cols={stage_page_cols(args.stage)}\nwidth_metatiles={stage_page_cols(args.stage) * PAGE_W}\nheight_metatiles={page_rows * PAGE_H}\nspawn_count={len(parse_spawn_records(spawns))}\n",
        encoding="utf-8",
    )

    profile_names = shared_profile_names_for_stage(args.stage)
    default_name = default_tiled_profile_for_stage(args.stage)
    if default_name not in profile_names:
        default_name = profile_names[0]
    profile_tsx_paths: dict[str, Path] = {}
    stage_object_bounds: dict[int, tuple[int, int, int, int]] = {}
    obj_tsx_for_default: Path | None = None
    obj_count_for_default = 0
    obj_bounds_for_default: dict[int, tuple[int, int, int, int]] = {}

    for profile_name in profile_names:
        profile = resolve_stage_profile(args.stage, profile_name)
        stem = f"stage{args.stage}_{profile['name']}"
        tileset_png = profiles_dir / f"{stem}_tileset.png"
        tsx = profiles_dir / f"{stem}.tsx"
        iw, ih, count = write_metatile_tileset_png(tileset_png, rom, stage, profile, DMG_PALETTE_LIGHT_TO_DARK)
        write_tiled_tsx(tsx, tileset_png, profile, iw, ih, count)
        profile_tsx_paths[str(profile["name"])] = tsx
        if profile["name"] == default_name:
            object_icons_dir = base_stage_dir / f"stage{args.stage}_object_icons"
            object_tsx = base_stage_dir / f"stage{args.stage}_object_icons.tsx"
            _obj_w, _obj_h, obj_count, obj_bounds = write_object_icon_collection_tsx(object_tsx, object_icons_dir, rom, stage, profile, DMG_PALETTE_LIGHT_TO_DARK)
            obj_tsx_for_default = object_tsx
            obj_count_for_default = obj_count
            obj_bounds_for_default = obj_bounds
            for typ, bounds in obj_bounds.items():
                if object_type_uses_oam_bounds(typ):
                    stage_object_bounds[typ & 0x7F] = bounds

    default_profile = resolve_stage_profile(args.stage, default_name)
    tmx = base_stage_dir / f"stage{args.stage}.tmx"
    write_tiled_tmx(
        tmx,
        profile_tsx_paths[default_name],
        world_map,
        page_rows,
        args.stage,
        default_profile,
        spawns=spawns,
        page_cols=stage_page_cols(args.stage),
        object_tsx_path=obj_tsx_for_default,
        object_tile_count=obj_count_for_default,
        object_icon_bounds=obj_bounds_for_default,
    )
    _write_shared_profile_metadata(tmx, args.stage, default_name, profile_tsx_paths)
    write_object_profiles_json(base_stage_dir / "object_profiles.json", overrides=stage_object_bounds)
    if getattr(args, "write_extension", False):
        js = write_tiled_profile_switcher_extension(args.outdir)
        print(f"wrote Tiled extension helper: {js}")
    print(f"exported shared-layout Tiled stage{args.stage}: {tmx} profiles={','.join(profile_tsx_paths.keys())} spawns={len(parse_spawn_records(spawns))}")


def export_tiled_shared_stage(rom_path: Path, stage_index: int, outdir: Path, object_profiles: Path | None = None, write_extension: bool = False) -> None:
    ns = argparse.Namespace(rom=rom_path, stage=stage_index, outdir=outdir, object_profiles=object_profiles, write_extension=write_extension)
    command_export_tiled_shared(ns)


def command_export_tiled_shared_all(args: argparse.Namespace) -> None:
    stages = parse_stage_list(args.stages)
    wrote_extension = False
    for stage_index in stages:
        try:
            export_tiled_shared_stage(args.rom, stage_index, args.outdir, object_profiles=args.object_profiles, write_extension=(args.write_extension and not wrote_extension))
            wrote_extension = wrote_extension or args.write_extension
        except Exception as e:
            raise RuntimeError(f"stage{stage_index}: {e}") from e


def command_switch_tiled_profile(args: argparse.Namespace) -> None:
    _replace_first_profile_tileset(args.tmx, args.profile)
    print(f"switched {args.tmx} to profile={args.profile}")




def _set_tiled_property(root: ET.Element, name: str, value: object, prop_type: str | None = None) -> None:
    props = root.find("properties")
    if props is None:
        props = ET.SubElement(root, "properties")
    for prop in props.findall("property"):
        if prop.attrib.get("name") == name:
            if prop_type:
                prop.set("type", prop_type)
            elif "type" in prop.attrib:
                del prop.attrib["type"]
            prop.set("value", str(value))
            return
    attrib = {"name": name, "value": str(value)}
    if prop_type:
        attrib["type"] = prop_type
    ET.SubElement(props, "property", attrib)


def _word_bytes(value: int) -> list[int]:
    value &= 0xFFFF
    return [value & 0xFF, (value >> 8) & 0xFF]


def _parse_db_values_from_line(line: str) -> list[int] | None:
    # Very small RGBDS db parser for the generated camera/profile data lines.
    # It intentionally supports only comma-separated numeric constants used by
    # this disassembly, e.g. "db $f8, $0d, 0".
    stripped = line.split(';', 1)[0].strip()
    if not stripped.lower().startswith('db '):
        return None
    body = stripped[3:].strip()
    if not body:
        return []
    vals = []
    for part in body.split(','):
        t = part.strip()
        if not t:
            continue
        if t.startswith('$'):
            vals.append(int(t[1:], 16) & 0xFF)
        elif t.lower().startswith('0x'):
            vals.append(int(t, 16) & 0xFF)
        else:
            vals.append(int(t, 0) & 0xFF)
    return vals


def _format_db_line(values: list[int]) -> str:
    return "    db " + ", ".join(f"${v:02x}" for v in values)


def _read_label_db_block(lines: list[str], label: str) -> tuple[int, int, list[int], list[int]]:
    label_idx = None
    for i, line in enumerate(lines):
        if line.startswith(label + "::") or line.startswith(label + ":"):
            label_idx = i
            break
    if label_idx is None:
        raise ValueError(f"source label not found: {label}")
    db_line_indices: list[int] = []
    values: list[int] = []
    i = label_idx + 1
    while i < len(lines):
        line = lines[i]
        # Stop on the next global/local label at column 0. A comment/blank line is okay.
        if line and not line.startswith((' ', '\t')) and (line.endswith('::') or '::' in line or line.endswith(':')):
            break
        parsed = _parse_db_values_from_line(line)
        if parsed is not None:
            db_line_indices.append(i)
            values.extend(parsed)
        elif db_line_indices and line.strip() and not line.lstrip().startswith(';'):
            # We only support contiguous db blocks for writeback.
            break
        i += 1
    if not db_line_indices:
        raise ValueError(f"label {label} does not contain a writable contiguous db block")
    return label_idx, i, db_line_indices, values


def _replace_label_db_block(lines: list[str], label: str, new_values: list[int], per_line: int = 16) -> None:
    _label_idx, _end_idx, db_indices, _old = _read_label_db_block(lines, label)
    new_db_lines = [_format_db_line(new_values[i:i+per_line]) for i in range(0, len(new_values), per_line)]
    start = db_indices[0]
    end = db_indices[-1] + 1
    lines[start:end] = new_db_lines


def parse_camera_writebacks_from_tmx(tmx_path: Path) -> dict[str, dict[str, int]]:
    """Read editable Camera Scroll Range objects from TMX.

    Returns mapping keyed by source_label.  The object rectangle represents the
    world coverage over the full camera scroll range, so:
      camera_x_min = object.x
      camera_x_max = object.x + object.width - 0xa0
      camera_y_max = object.y + object.height - 0x80
    """
    root = ET.parse(tmx_path).getroot()
    stage = _parse_optional_int(_get_tiled_property(root, "stage"), -1)
    out: dict[str, dict[str, int]] = {}
    group = None
    for candidate in root.findall("objectgroup"):
        if candidate.attrib.get("name") == "Camera Scroll Range":
            group = candidate
            break
    if group is None:
        return out
    for obj in group.findall("object"):
        typ = obj.attrib.get("type", "")
        if typ not in ("CAMERA_SCROLL_RANGE", "CAMERA_SCROLL_RANGE_READONLY"):
            continue
        writable_text = _get_tiled_property(obj, "source_writable", "false") or "false"
        writable = str(writable_text).lower() in ("1", "true", "yes")
        label = _get_tiled_property(obj, "source_label", "") or ""
        if not writable or not label:
            continue
        x = int(round(float(obj.attrib.get("x", "0"))))
        y = int(round(float(obj.attrib.get("y", "0"))))
        w = int(round(float(obj.attrib.get("width", "0"))))
        h = int(round(float(obj.attrib.get("height", "0"))))
        cam_x_min = max(0, x)
        cam_x_max = max(0, x + w - LCD_VIEWPORT_W)
        cam_y_max = max(0, y + h - GAMEPLAY_VIEWPORT_H)
        entry = {
            "stage": stage,
            "camera_x_min": cam_x_min,
            "camera_x_max": cam_x_max,
            "camera_y_max": cam_y_max,
            "source_tmx": str(tmx_path),
        }
        if label in out and any(out[label].get(k) != entry.get(k) for k in ("camera_x_min", "camera_x_max", "camera_y_max")):
            raise ValueError(f"conflicting camera writeback for {label}: {out[label]} vs {entry}")
        out[label] = entry
    return out


def apply_camera_writebacks_to_bank1(bank1_in: Path, bank1_out: Path, camera_updates: dict[str, dict[str, int]]) -> None:
    lines = bank1_in.read_text(encoding="utf-8").splitlines()
    for label, upd in sorted(camera_updates.items()):
        if label.startswith("StageInitBlock_"):
            _li, _ei, _idxs, vals = _read_label_db_block(lines, label)
            if len(vals) < 8:
                raise ValueError(f"{label} too short for StageInitBlock writeback")
            # Preserve player_x_max (+00) and unknown +02. Only camera max words are written.
            vals[4:6] = _word_bytes(int(upd["camera_x_max"]))
            vals[6:8] = _word_bytes(int(upd["camera_y_max"]))
            _replace_label_db_block(lines, label, vals, per_line=16)
        elif label.startswith("Stage1CameraProfile"):
            if label == "Stage1CameraProfileResume":
                raise ValueError("Stage1CameraProfileResume is currently not writable because it is still instruction-shaped source")
            _li, _ei, _idxs, vals = _read_label_db_block(lines, label)
            if len(vals) < 16:
                raise ValueError(f"{label} too short for Stage1CameraProfile writeback")
            vals[0:2] = _word_bytes(int(upd["camera_x_min"]))
            vals[2:4] = _word_bytes(int(upd["camera_x_max"]))
            # Keep player clamps/start/initial scroll untouched. The camera layer edits camera bounds only.
            _replace_label_db_block(lines, label, vals, per_line=16)
        else:
            raise ValueError(f"unsupported camera writeback label: {label}")
    bank1_out.parent.mkdir(parents=True, exist_ok=True)
    bank1_out.write_text("\n".join(lines) + "\n", encoding="utf-8")


def command_write_camera_source(args: argparse.Namespace) -> None:
    updates: dict[str, dict[str, int]] = {}
    stages = parse_stage_list(args.stages)
    for st in stages:
        if args.tiled_root.is_file():
            if len(stages) != 1:
                raise ValueError("when tiled_root is a TMX file, --stages must name exactly one stage")
            tmx = args.tiled_root
        else:
            tmx = args.tiled_root / f"stage{st}" / f"stage{st}.tmx"
            if not tmx.exists():
                # Compatibility fallback for older exports.
                tmx = args.tiled_root / f"stage{st}" / f"stage{st}_normal.tmx"
        if not tmx.exists():
            if args.skip_missing:
                continue
            raise FileNotFoundError(f"stage{st}: missing TMX {tmx}")
        stage_updates = parse_camera_writebacks_from_tmx(tmx)
        for label, upd in stage_updates.items():
            if label in updates and any(updates[label].get(k) != upd.get(k) for k in ("camera_x_min", "camera_x_max", "camera_y_max")):
                raise ValueError(f"conflicting camera writeback for shared {label}: {updates[label]} vs {upd}")
            updates[label] = upd
    if not updates:
        print("no writable camera changes found")
        if args.output_bank1 != args.input_bank1:
            args.output_bank1.write_text(args.input_bank1.read_text(encoding="utf-8"), encoding="utf-8")
        return
    apply_camera_writebacks_to_bank1(args.input_bank1, args.output_bank1, updates)
    print(f"wrote {args.output_bank1} with {len(updates)} camera writeback block(s):")
    for label, upd in sorted(updates.items()):
        if label.startswith("StageInitBlock_"):
            print(f"  {label}: camera_x_max=${upd['camera_x_max']:04x} camera_y_max=${upd['camera_y_max']:04x}")
        else:
            print(f"  {label}: camera_x_min=${upd['camera_x_min']:04x} camera_x_max=${upd['camera_x_max']:04x}")


def command_import_tiled(args: argparse.Namespace) -> None:
    profile_path = getattr(args, "object_profiles", None)
    if profile_path is None:
        candidate = args.tmx.parent / "object_profiles.json"
        if candidate.exists():
            profile_path = candidate
    if profile_path is not None:
        apply_object_profiles_json(profile_path)
    world, width, height, props = read_tiled_layer_csv(args.tmx, args.layer_name)
    stage_prop = props.get("stage")
    expected_width = stage_page_cols(int(stage_prop)) * PAGE_W if stage_prop is not None and stage_prop.isdigit() else width
    if width != expected_width:
        raise ValueError(f"TMX width must be {expected_width} metatiles for stage {stage_prop}, got {width}")
    if height % PAGE_H != 0:
        raise ValueError(f"TMX height must be a multiple of {PAGE_H}, got {height}")
    page_rows = height // PAGE_H
    if not 1 <= page_rows <= MAX_PAGE_ROWS:
        raise ValueError(f"TMX has invalid page row count {page_rows}")
    args.output_world_map.parent.mkdir(parents=True, exist_ok=True)
    args.output_world_map.write_bytes(world)
    msg = f"imported {args.tmx} layer={args.layer_name} -> {args.output_world_map} ({width}x{height} metatiles, page_rows={page_rows}, profile={props.get('profile','')})"
    if args.output_spawns_bin:
        spawns = tiled_objects_to_spawns(args.tmx, args.object_layer_name)
        args.output_spawns_bin.parent.mkdir(parents=True, exist_ok=True)
        args.output_spawns_bin.write_bytes(spawns)
        msg += f"; spawns -> {args.output_spawns_bin} ({len(parse_spawn_records(spawns))} records)"
    print(msg)


def command_import_tiled_spawns(args: argparse.Namespace) -> None:
    profile_path = getattr(args, "object_profiles", None)
    if profile_path is None:
        candidate = args.tmx.parent / "object_profiles.json"
        if candidate.exists():
            profile_path = candidate
    if profile_path is not None:
        apply_object_profiles_json(profile_path)
    spawns = tiled_objects_to_spawns(args.tmx, args.object_layer_name)
    args.output_spawns_bin.parent.mkdir(parents=True, exist_ok=True)
    args.output_spawns_bin.write_bytes(spawns)
    if args.output_csv:
        write_spawns_csv(args.output_csv, spawns)
    print(f"imported Tiled object layer '{args.object_layer_name}' from {args.tmx} -> {args.output_spawns_bin} ({len(parse_spawn_records(spawns))} records)")




def default_tiled_profile_for_stage(stage_index: int) -> str:
    defs = STAGE_PROFILE_DEFS.get(stage_index)
    if not defs:
        return "normal"
    return str(defs.get("default", "normal"))


def default_tiled_tmx_path(tiled_root: Path, stage_index: int) -> Path:
    # v17 shared-layout mode prefers one canonical TMX per stage.
    # Fall back to the older profile-specific TMX naming for compatibility.
    shared = tiled_root / f"stage{stage_index}" / f"stage{stage_index}.tmx"
    if shared.exists():
        return shared
    profile = default_tiled_profile_for_stage(stage_index)
    return tiled_root / f"stage{stage_index}" / f"stage{stage_index}_{profile}.tmx"



def extract_original_layout_rleff_from_rom(rom: bytes, stage_index: int) -> bytes:
    stage = load_stage_assets(rom)[stage_index]
    src = slice_rom(rom, LEVEL_DATA_BANK, stage.layout_ptr, stage.layout_end)
    _decoded, consumed = rleff_decode(src, stage.layout_decoded_size)
    return src[:consumed]


def choose_lossless_rleff_for_layout(
    stage_index: int,
    layout_raw: bytes,
    stage_dir: Path,
    tmx_path: Path,
    rom: bytes | None,
) -> tuple[bytes, str]:
    """Return an RLEFF stream for layout_raw, preserving exact original bytes when possible."""
    stage_size = LAYOUT_DECODED_SIZES[stage_index]
    candidates: list[tuple[str, bytes]] = []
    if rom is not None:
        try:
            candidates.append(("rom", extract_original_layout_rleff_from_rom(rom, stage_index)))
        except Exception:
            pass
    for label, path in (
        ("tiled", tmx_path.parent / "layout.rleff"),
        ("existing", stage_dir / "layout.rleff"),
    ):
        if path.exists():
            try:
                candidates.append((f"{label}:{path}", path.read_bytes()))
            except Exception:
                pass
    for label, data in candidates:
        try:
            decoded, consumed = rleff_decode(data, stage_size)
        except Exception:
            continue
        if consumed == len(data) and decoded == layout_raw:
            return data, f"preserved:{label}"
    return rleff_encode(layout_raw), "encoded"


def build_tiled_stage(
    stage_index: int,
    tmx_path: Path,
    stage_dir: Path,
    *,
    layer_name: str = "Layout",
    object_layer_name: str = "Spawns",
    object_profiles: Path | None = None,
    rom: bytes | None = None,
    verify: bool = True,
) -> dict[str, object]:
    """Import one Tiled TMX into the source-build level asset files.

    Writes:
      world_map.raw
      layout.raw
      layout.rleff
      spawns.bin
      spawns.csv

    page_table.bin is reused from the stage directory when present. If it is
    missing and --rom was supplied, it is extracted from the ROM's init block.
    """
    if object_profiles is None:
        candidate = tmx_path.parent / "object_profiles.json"
        if candidate.exists():
            object_profiles = candidate
    if object_profiles is not None:
        apply_object_profiles_json(object_profiles)

    world, width, height, props = read_tiled_layer_csv(tmx_path, layer_name)
    page_cols = stage_page_cols(stage_index)
    expected_width = page_cols * PAGE_W
    if width != expected_width:
        raise ValueError(f"stage{stage_index}: TMX width must be {expected_width} metatiles, got {width}")
    if height % PAGE_H != 0:
        raise ValueError(f"stage{stage_index}: TMX height must be a multiple of {PAGE_H}, got {height}")
    page_rows = height // PAGE_H
    if not 1 <= page_rows <= MAX_PAGE_ROWS:
        raise ValueError(f"stage{stage_index}: invalid page row count {page_rows}")

    stage_dir.mkdir(parents=True, exist_ok=True)
    page_table_path = stage_dir / "page_table.bin"
    tiled_page_table_path = tmx_path.parent / "page_table.bin"
    if page_table_path.exists():
        page_table_bytes = page_table_path.read_bytes()
    elif tiled_page_table_path.exists():
        page_table_bytes = tiled_page_table_path.read_bytes()
        page_table_path.write_bytes(page_table_bytes)
    elif page_cols == 1:
        page_table_bytes = bytes([0])
        page_table_path.write_bytes(page_table_bytes)
    elif rom is not None:
        stage = load_stage_assets(rom)[stage_index]
        init_block = slice_rom(rom, INIT_BANK, stage.init_ptr, stage.init_ptr + INIT_BLOCK_SIZE)
        layout_raw_dummy = bytes(LAYOUT_DECODED_SIZES[stage_index])
        page_table_bytes = normalize_page_table_for_rows(page_table_from_init_block(init_block), layout_raw_dummy, page_rows, page_cols)
        page_table_path.write_bytes(page_table_bytes)
    else:
        raise ValueError(f"stage{stage_index}: missing {page_table_path} and {tiled_page_table_path}; run export-tiled/extraction first or pass --rom")

    stage_size = LAYOUT_DECODED_SIZES[stage_index]
    page_count = stage_size // PAGE_SIZE
    page_table = normalize_page_table_for_rows(page_table_bytes, bytes(stage_size), page_rows, page_cols)
    layout_raw = pack_layout_pages(world, page_table, page_count, page_cols)
    layout_rleff, rleff_source = choose_lossless_rleff_for_layout(stage_index, layout_raw, stage_dir, tmx_path, rom)
    spawns = tiled_objects_to_spawns(tmx_path, object_layer_name)

    (stage_dir / "world_map.raw").write_bytes(world)
    (stage_dir / "layout.raw").write_bytes(layout_raw)
    (stage_dir / "layout.rleff").write_bytes(layout_rleff)
    (stage_dir / "spawns.bin").write_bytes(spawns)
    write_spawns_csv(stage_dir / "spawns.csv", spawns)
    (stage_dir / "stage_meta.txt").write_text(
        f"stage={stage_index}\npage_rows={page_rows}\npage_cols={page_cols}\nwidth_metatiles={width}\nheight_metatiles={height}\nspawn_count={len(parse_spawn_records(spawns))}\nsource_tmx={tmx_path.as_posix()}\nprofile={props.get('profile', '')}\n",
        encoding="utf-8",
    )

    if verify:
        decoded, consumed = rleff_decode(layout_rleff, stage_size)
        if decoded != layout_raw:
            raise ValueError(f"stage{stage_index}: layout.rleff decode verification failed")
        rt_world = unpack_layout_pages(decoded, page_table, page_rows, page_cols)
        if rt_world != world:
            raise ValueError(f"stage{stage_index}: layout page roundtrip verification failed")
        if consumed != len(layout_rleff):
            raise ValueError(f"stage{stage_index}: layout.rleff decoder consumed 0x{consumed:x}, file is 0x{len(layout_rleff):x}")

    return {
        "stage": stage_index,
        "tmx": str(tmx_path),
        "stage_dir": str(stage_dir),
        "world_map": str(stage_dir / "world_map.raw"),
        "layout_raw": str(stage_dir / "layout.raw"),
        "layout_rleff": str(stage_dir / "layout.rleff"),
        "layout_rleff_size": len(layout_rleff),
        "layout_rleff_source": rleff_source,
        "spawns_bin": str(stage_dir / "spawns.bin"),
        "spawn_count": len(parse_spawn_records(spawns)),
        "page_rows": page_rows,
        "profile": props.get("profile", ""),
    }


def command_build_tiled_stage(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes() if args.rom else None
    result = build_tiled_stage(
        args.stage,
        args.tmx,
        args.stage_dir,
        layer_name=args.layer_name,
        object_layer_name=args.object_layer_name,
        object_profiles=args.object_profiles,
        rom=rom,
        verify=not args.no_verify,
    )
    print(
        f"built stage{result['stage']} from {result['tmx']} -> {result['stage_dir']} "
        f"layout.rleff=0x{result['layout_rleff_size']:x} ({result.get('layout_rleff_source','')}) "
        f"spawns={result['spawn_count']} profile={result['profile']}"
    )


def command_build_tiled_all(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes() if args.rom else None
    stages = parse_stage_list(args.stages)
    results: list[dict[str, object]] = []
    for stage_index in stages:
        tmx_path = default_tiled_tmx_path(args.tiled_root, stage_index)
        if not tmx_path.exists():
            if args.skip_missing:
                print(f"skip stage{stage_index}: missing {tmx_path}")
                continue
            raise ValueError(f"stage{stage_index}: missing TMX {tmx_path}")
        stage_dir = args.levels_root / f"stage{stage_index}"
        try:
            result = build_tiled_stage(
                stage_index,
                tmx_path,
                stage_dir,
                layer_name=args.layer_name,
                object_layer_name=args.object_layer_name,
                object_profiles=args.object_profiles,
                rom=rom,
                verify=not args.no_verify,
            )
        except Exception as e:
            raise RuntimeError(f"stage{stage_index}: {e}") from e
        results.append(result)
        print(
            f"built stage{stage_index}: layout.rleff=0x{result['layout_rleff_size']:x} "
            f"({result.get('layout_rleff_source','')}) spawns={result['spawn_count']} from {tmx_path}"
        )
    if args.output_json:
        args.output_json.parent.mkdir(parents=True, exist_ok=True)
        args.output_json.write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")
        print(f"wrote {args.output_json}")


def command_build_spawns(args: argparse.Namespace) -> None:
    data = build_spawns_from_csv(args.spawns_csv)
    args.output_spawns_bin.parent.mkdir(parents=True, exist_ok=True)
    args.output_spawns_bin.write_bytes(data)
    print(f"wrote {args.output_spawns_bin} 0x{len(data):x} bytes")



# Stage-interaction collision attributes observed in the player ground-collision table.
# These attributes enter PlayerState_StageInteraction0C and drive the multi-step
# stage transitions used by stage2.
STAGE_INTERACTION_ATTRS = {
    0x23: "GroundTileEnterStageInteraction03/c0b1=3",
    0x24: "GroundTileEnterStageInteraction01/c0b1=1",
}


def stage_collision_attrs(rom: bytes, stage: StageAssets, variant: int = 0) -> bytes:
    """Return the 0x100 collision/interaction attribute table active for a stage.

    The base table is loaded by InitStageResources from bank4:stage.collision_ptr.
    Stage2 has a later interaction path that patches the first 0x30 bytes from
    bank4:$78ca when c0b3 reaches 5. Keep that as collision variant 1 so the
    analyzer can compare before/after trigger semantics.
    """
    attrs = bytearray(slice_rom(rom, LEVEL_DATA_BANK, stage.collision_ptr, stage.collision_ptr + 0x100))
    if stage.index == 2 and variant == 1:
        patch = slice_rom(rom, LEVEL_DATA_BANK, 0x78CA, 0x78CA + 0x30)
        attrs[:0x30] = patch
    elif variant != 0:
        raise ValueError(f"no known collision variant {variant} for stage{stage.index}")
    return bytes(attrs)


def build_stage_world_map_in_memory(rom: bytes, stage: StageAssets) -> tuple[bytes, bytes, bytes, int]:
    """Return (layout_raw, page_table, world_map, page_rows).

    Stages 0-3 use the normal 14-page-wide streamed map. Stage 4's ROM
    layout decodes to exactly one physical 16x16 metatile page; its init block
    reuses an older full-width page table, so using that table here is wrong.
    Treat stage4 as a one-page editor map and rebuild it as a one-page RLEFF.
    """
    layout_rle_range = slice_rom(rom, LEVEL_DATA_BANK, stage.layout_ptr, stage.layout_end)
    layout_raw, _ = rleff_decode(layout_rle_range, stage.layout_decoded_size)
    if stage_page_cols(stage.index) == 1:
        page_table = bytes([0])
        page_rows = 1
        world_map = layout_raw
        return layout_raw, page_table, world_map, page_rows
    init_block = slice_rom(rom, INIT_BANK, stage.init_ptr, stage.init_ptr + INIT_BLOCK_SIZE)
    full_table = page_table_from_init_block(init_block)
    page_table, page_rows = active_page_table(full_table, layout_raw)
    world_map = unpack_layout_pages(layout_raw, page_table, page_rows)
    return layout_raw, page_table, world_map, page_rows


def scan_collision_attr_positions(world_map: bytes, attrs: bytes, wanted: set[int]) -> dict[int, list[tuple[int, int, int]]]:
    """Return attr -> [(x_px, y_px, metatile_id), ...]."""
    rows = infer_rows_from_world_map(world_map) * PAGE_H
    width = PAGE_COLS * PAGE_W
    out: dict[int, list[tuple[int, int, int]]] = {a: [] for a in sorted(wanted)}
    for y in range(rows):
        row_base = y * width
        for x in range(width):
            metatile = world_map[row_base + x]
            attr = attrs[metatile] & 0x3F
            if attr in out:
                out[attr].append((x * 16, y * 16, metatile))
    return out


def summarize_attr_runs(positions: list[tuple[int, int, int]]) -> list[dict[str, int]]:
    """Group scan results by contiguous x-ranges on each metatile row."""
    by_y: dict[int, list[tuple[int, int]]] = {}
    for x_px, y_px, mt in positions:
        by_y.setdefault(y_px, []).append((x_px, mt))
    runs: list[dict[str, int]] = []
    for y_px, xs in sorted(by_y.items()):
        xs = sorted(xs)
        if not xs:
            continue
        start_x = prev_x = xs[0][0]
        mts = {xs[0][1]}
        for x_px, mt in xs[1:]:
            if x_px == prev_x + 16:
                prev_x = x_px
                mts.add(mt)
                continue
            runs.append({"x0": start_x, "x1": prev_x + 16, "y": y_px, "count": (prev_x - start_x)//16 + 1, "metatile_min": min(mts), "metatile_max": max(mts)})
            start_x = prev_x = x_px
            mts = {mt}
        runs.append({"x0": start_x, "x1": prev_x + 16, "y": y_px, "count": (prev_x - start_x)//16 + 1, "metatile_min": min(mts), "metatile_max": max(mts)})
    return runs


def suggest_stage2_switches_from_rom(rom: bytes, stage: StageAssets, world_map: bytes, page_rows: int) -> list[str]:
    """Produce a ROM-grounded Stage 2 state model.

    Stage 2 is not a pure camera-X tileset split. bank1 shows that the visual
    changes are keyed by stage state variables:
      * c0a8 != 0 at init replays the VRAM overlay and sets c0b3=3.
      * PlayerState_StageInteraction0C eventually increments c0b3.
      * When the finalization path sees c0b3==5 it changes hStageMetatileTable
        to bank4:$4a31 and patches c700[0:0x30] from bank4:$78ca.

    Therefore the ROM can infer state profiles, but not a unique global X split.
    The 0x23/0x24 collision tiles are transition triggers and may appear at the
    left edge, so using min(trigger_x) as a range split is wrong.
    """
    if stage.index != 2:
        return []
    attrs = stage_collision_attrs(rom, stage, 0)
    found = scan_collision_attr_positions(world_map, attrs, set(STAGE_INTERACTION_ATTRS))
    all_x = [x for pos in found.values() for x, _y, _mt in pos]
    lines: list[str] = []
    lines.append("stage2 code-derived state model:")
    lines.append("  state new/initial: c0a8=0, c0b3 starts at 0 -> vram_variant=0, metatile_variant=0, collision_variant=0")
    lines.append("  state resume/checkpoint: c0a8!=0 -> replay bank0:$3572->$9450 and bank5:$6411->$8c00; set c0b3=3 -> vram_variant=1, metatile_variant=0")
    lines.append("  state after c0b3 reaches 5: hStageMetatileTable=bank4:$4a31 and patch c700[0:0x30] from bank4:$78ca -> vram_variant=1, metatile_variant=2, collision_variant=1")
    lines.append("  c0b3 increments in PlayerState_StageInteraction0C's c0b1=0 scroll/transition path, so the switch is transition-count/state driven.")
    if all_x:
        first = min(all_x)
        last = max(all_x) + 16
        lines.append(f"  transition trigger X span: ${first:04x}-${last:04x}")
        lines.append("  IMPORTANT: this span is not a safe render split. x=$0000 triggers are valid transitions/entrances, not a tileset boundary.")
        lines.append("  recommended editor render profiles:")
        lines.append("    stage2_initial        : v0:m0:c0")
        lines.append("    stage2_checkpoint     : v1:m0:c0")
        lines.append("    stage2_after_switch   : v3:m2:c1  ; bank0:$3902 -> $9450 transition-complete VRAM, 0x3b tiles")
        lines.append("  Use range compositing only after mapping those state profiles to rooms/areas; do not infer 0x0000-end:v1:m2 from trigger min-X.")
    else:
        lines.append("  no 0x23/0x24 interaction tiles found with the base collision table; inspect alternate collision variant or stage event objects.")
    return lines


def command_analyze_stage_events(args: argparse.Namespace) -> None:
    rom = args.rom.read_bytes()
    stages = load_stage_assets(rom)
    st = stages[args.stage]
    layout_raw, page_table, world_map, page_rows = build_stage_world_map_in_memory(rom, st)
    attrs = stage_collision_attrs(rom, st, args.collision_variant)
    wanted = set(args.attrs) if args.attrs else set(STAGE_INTERACTION_ATTRS)
    found = scan_collision_attr_positions(world_map, attrs, wanted)

    print(f"stage{st.index}: world={PAGE_COLS * PAGE_W}x{page_rows * PAGE_H} metatiles, physical_pages={len(layout_raw)//PAGE_SIZE}")
    print(f"collision_ptr=${st.collision_ptr:04x}, collision_variant={args.collision_variant}")
    for attr in sorted(wanted):
        positions = found.get(attr, [])
        name = STAGE_INTERACTION_ATTRS.get(attr, "custom")
        print(f"attr ${attr:02x} {name}: {len(positions)} tile(s)")
        runs = summarize_attr_runs(positions)
        for run in runs[:args.max_runs]:
            print(
                f"  x=${run['x0']:04x}-${run['x1']:04x} y=${run['y']:04x} "
                f"count={run['count']} metatile=${run['metatile_min']:02x}-${run['metatile_max']:02x}"
            )
        if len(runs) > args.max_runs:
            print(f"  ... {len(runs) - args.max_runs} more run(s)")

    if args.stage == 2:
        print("")
        for line in suggest_stage2_switches_from_rom(rom, st, world_map, page_rows):
            print(line)



def _asm_label_for_stage_asset(stage: int, kind: str) -> str:
    return f"Stage{stage}{kind}"


def _choose_asset_file(stage_dir: Path, base_name: str, prefer_new: bool) -> Path | None:
    candidates = []
    if prefer_new:
        candidates.append(stage_dir / f"{base_name}.new")
    candidates.append(stage_dir / base_name)
    for c in candidates:
        if c.exists():
            return c
    return None


def _posix_rel(path: Path, base: Path) -> str:
    try:
        rel = path.resolve().relative_to(base.resolve())
    except Exception:
        rel = path
    return rel.as_posix()


def command_write_object_profiles(args: argparse.Namespace) -> None:
    write_object_profiles_json(args.output_json)
    print(f"wrote default object profile table: {args.output_json}")


def command_write_rgbds_manifest(args: argparse.Namespace) -> None:
    """Write a source-level RGBDS include manifest for edited level assets.

    This does not modify bank_001.asm/bank_004.asm by itself. It produces stable
    labels and INCBIN lines so the disassembly can be migrated away from raw db
    blobs in a controlled reviewable patch.
    """
    levels_root = args.levels_root
    project_root = args.project_root or levels_root.parent.parent
    stages = parse_stage_list(args.stages) if args.stages else list(range(STAGE_COUNT))
    lines: list[str] = []
    lines.append('; Auto-generated by shin4_level_pipeline.py write-rgbds-manifest')
    lines.append('; Review and include this from the appropriate ROM bank source files.')
    lines.append('; Layout assets belong in bank4 data; spawn lists belong in bank1 data.')
    lines.append('')
    lines.append('; Layout RLE assets')
    for st in stages:
        stage_dir = levels_root / f"stage{st}"
        f = _choose_asset_file(stage_dir, 'layout.rleff', args.prefer_new)
        if f is None:
            lines.append(f'; Stage {st}: missing layout.rleff(.new)')
            continue
        lines.append(f'{_asm_label_for_stage_asset(st, "LayoutRle")}::')
        lines.append(f'    INCBIN "{_posix_rel(f, project_root)}"')
    lines.append('')
    lines.append('; Spawn list assets')
    for st in stages:
        stage_dir = levels_root / f"stage{st}"
        f = _choose_asset_file(stage_dir, 'spawns.bin', args.prefer_new)
        if f is None:
            lines.append(f'; Stage {st}: missing spawns.bin(.new)')
            continue
        lines.append(f'{_asm_label_for_stage_asset(st, "SpawnList")}::')
        lines.append(f'    INCBIN "{_posix_rel(f, project_root)}"')
    lines.append('')
    lines.append('; Suggested pointer table form after migrating labels:')
    lines.append('StageLayoutRlePtrs::')
    for st in stages:
        lines.append(f'    dw {_asm_label_for_stage_asset(st, "LayoutRle")}')
    lines.append('StageSpawnListPtrs::')
    for st in stages:
        lines.append(f'    dw {_asm_label_for_stage_asset(st, "SpawnList")}')
    args.output_asm.parent.mkdir(parents=True, exist_ok=True)
    args.output_asm.write_text('\n'.join(lines) + '\n', encoding='utf-8')

    manifest = {
        'type': 'shin4_level_asset_manifest',
        'prefer_new': bool(args.prefer_new),
        'stages': stages,
        'levels_root': str(levels_root),
        'asm': str(args.output_asm),
        'note': 'This is source-level manifest only; it does not inject bytes into the ROM.',
    }
    if args.output_json:
        args.output_json.parent.mkdir(parents=True, exist_ok=True)
        args.output_json.write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
    print(f"wrote RGBDS manifest: {args.output_asm}")
    if args.output_json:
        print(f"wrote JSON manifest: {args.output_json}")

def build_parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description="Shin-chan 4 clean level extraction/editor pipeline v14")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("all", help="Extract stage assets and editor-ready derived files from ROM")
    p.add_argument("rom", type=Path)
    p.add_argument("outdir", type=Path)
    p.add_argument("--stages", help="Stage list, e.g. 0 or 0,2,4 or 0-4")
    p.add_argument("--preview-scale", type=int, default=4)
    p.set_defaults(func=command_all)

    p = sub.add_parser("probe", help="Dump source pointer tables and init/page bytes from ROM")
    p.add_argument("rom", type=Path)
    p.set_defaults(func=command_probe)

    p = sub.add_parser("inspect-page-table", help="Inspect page_table.bin or init_block.bin")
    p.add_argument("page_table_or_init", type=Path)
    p.add_argument("--layout-raw", type=Path)
    p.set_defaults(func=command_inspect)

    p = sub.add_parser("preview", help="Regenerate PNG preview from world_map.raw")
    p.add_argument("world_map_raw", type=Path)
    p.add_argument("output_png", type=Path)
    p.add_argument("--scale", type=int, default=4)
    p.set_defaults(func=command_preview)

    p = sub.add_parser("rebuild-layout", help="Pack edited world_map.raw back into layout.raw and layout.rleff")
    p.add_argument("stage", type=int)
    p.add_argument("world_map_raw", type=Path)
    p.add_argument("page_table_bin", type=Path, help="0x46-byte page table or 0x4e-byte init block")
    p.add_argument("output_layout_raw", type=Path)
    p.add_argument("output_layout_rleff", type=Path)
    p.add_argument("--page-count", type=int)
    p.add_argument("--max-rleff-size", type=lambda x: int(x, 0))
    p.add_argument("--rom", type=Path, help="reserved for future ROM-aware rebuild checks")
    p.set_defaults(func=command_rebuild_layout)

    p = sub.add_parser("render-stage", help="Render stage PNG using reconstructed BG VRAM and metatile quads")
    p.add_argument("rom", type=Path)
    p.add_argument("stage", type=int)
    p.add_argument("assets_dir", type=Path, help="Asset root from `all`; used if world_map.raw/metatile_quads.bin exist")
    p.add_argument("output_png", type=Path)
    p.add_argument("--tile-mode", choices=["signed"], default="signed", help="BG tile addressing mode. Gameplay uses signed mode with LCDC bit4=0.")
    p.add_argument("--palette", choices=["dmg", "green"], default="dmg")
    p.add_argument("--scale", type=int, default=1)
    p.add_argument("--include-form-gfx", action="store_true", help="Also replay normal player-form graphics copy into VRAM $8130 for experiments")
    p.add_argument("--vram-variant", type=int, default=0, help="Stage-specific VRAM variant. For stage1, 2 applies the c0b4=2 second-half overlay bank7:$4ee1->$91a0.")
    p.add_argument("--copy-log", type=Path)
    p.set_defaults(func=command_render_stage)

    p = sub.add_parser("render-stage-ranges", help="Render a stage PNG by compositing multiple VRAM/metatile profiles over X ranges")
    p.add_argument("rom", type=Path)
    p.add_argument("stage", type=int)
    p.add_argument("assets_dir", type=Path)
    p.add_argument("output_png", type=Path)
    p.add_argument("--ranges", help="Compact ranges, e.g. 0-0x900:0,0x900-end:2 or 0x500-end:v1:m2")
    p.add_argument("--range-file", type=Path, help="JSON list/dict with ranges: start,end,vram_variant,metatile_variant,name")
    p.add_argument("--tile-mode", choices=["signed"], default="signed")
    p.add_argument("--palette", choices=["dmg", "green"], default="dmg")
    p.add_argument("--scale", type=int, default=1)
    p.add_argument("--preview-scale", type=int, default=4, help="Only used if extraction is needed first")
    p.add_argument("--copy-log", type=Path)
    p.set_defaults(func=command_render_stage_ranges)

    p = sub.add_parser("dump-vram", help="Dump reconstructed 0x2000-byte VRAM tile data for a stage")
    p.add_argument("rom", type=Path)
    p.add_argument("stage", type=int)
    p.add_argument("output_bin", type=Path)
    p.add_argument("--include-form-gfx", action="store_true")
    p.add_argument("--vram-variant", type=int, default=0)
    p.add_argument("--copy-log", type=Path)
    p.set_defaults(func=command_dump_vram)



    p = sub.add_parser("analyze-stage-events", help="Scan ROM-derived world map for special collision/interaction tiles and print the Stage 2 state model")
    p.add_argument("rom", type=Path)
    p.add_argument("stage", type=int)
    p.add_argument("--collision-variant", type=int, default=0, help="Collision table variant. Stage2 variant 1 applies the bank4:$78ca c700 patch.")
    p.add_argument("--attrs", type=lambda s: [int(x, 0) for x in s.split(',')], help="Comma-separated collision attrs to scan, default: 0x23,0x24")
    p.add_argument("--max-runs", type=int, default=32)
    p.set_defaults(func=command_analyze_stage_events)


    p = sub.add_parser("export-tiled", help="Export a stage/profile to Tiled TMX + TSX + 16x16 metatile tileset PNG")
    p.add_argument("rom", type=Path)
    p.add_argument("stage", type=int)
    p.add_argument("outdir", type=Path)
    p.add_argument("--profile", default="default", help="Profile name, or 'all'. Stage2 examples: initial, checkpoint, after_switch")
    p.add_argument("--object-profiles", type=Path, help="Optional editable object_profiles.json to override spawn visual boxes/offsets")
    p.set_defaults(func=command_export_tiled)

    p = sub.add_parser("export-tiled-all", help="Export default Tiled TMX files for multiple stages in one command")
    p.add_argument("rom", type=Path)
    p.add_argument("outdir", type=Path)
    p.add_argument("--stages", help="Stage list, e.g. 0 or 0-4. Defaults to all stages")
    p.add_argument("--stage1-all", action="store_true", default=True, help="Export all Stage 1 visual profiles; enabled by default")
    p.add_argument("--stage1-default-only", dest="stage1_all", action="store_false", help="Export only Stage 1's default/front profile")
    p.add_argument("--stage2-all", action="store_true", default=True, help="Export all Stage 2 visual profiles; enabled by default")
    p.add_argument("--stage2-default-only", dest="stage2_all", action="store_false", help="Export only Stage 2's default/initial profile")
    p.add_argument("--object-profiles", type=Path, help="Optional editable object_profiles.json to override spawn visual boxes/offsets")
    p.set_defaults(func=command_export_tiled_all)

    p = sub.add_parser("export-tiled-shared", help="Export one canonical TMX per stage plus switchable profile TSX files")
    p.add_argument("rom", type=Path)
    p.add_argument("stage", type=int)
    p.add_argument("outdir", type=Path)
    p.add_argument("--object-profiles", type=Path, help="Optional editable object_profiles.json to override spawn visual boxes/offsets")
    p.add_argument("--write-extension", action="store_true", help="Also write an optional Tiled JavaScript profile switcher helper")
    p.set_defaults(func=command_export_tiled_shared)

    p = sub.add_parser("export-tiled-shared-all", help="Export one canonical TMX per stage plus profile TSX files for all requested stages")
    p.add_argument("rom", type=Path)
    p.add_argument("outdir", type=Path)
    p.add_argument("--stages", help="Stage list, e.g. 0 or 0-4. Defaults to all stages")
    p.add_argument("--object-profiles", type=Path, help="Optional editable object_profiles.json to override spawn visual boxes/offsets")
    p.add_argument("--write-extension", action="store_true", help="Also write an optional Tiled JavaScript profile switcher helper")
    p.set_defaults(func=command_export_tiled_shared_all)

    p = sub.add_parser("switch-tiled-profile", help="Switch a shared-layout TMX to another visual profile by replacing its firstgid=1 TSX source")
    p.add_argument("tmx", type=Path)
    p.add_argument("profile")
    p.set_defaults(func=command_switch_tiled_profile)


    p = sub.add_parser("write-camera-source", help="Apply editable Tiled Camera Scroll Range objects back to bank_001.asm source")
    p.add_argument("tiled_root", type=Path, help="Tiled root containing stageX/stageX.tmx, or a single TMX when --stages has one stage")
    p.add_argument("input_bank1", type=Path)
    p.add_argument("output_bank1", type=Path)
    p.add_argument("--stages", help="Stage list, e.g. 0 or 0-4. Defaults to all stages")
    p.add_argument("--skip-missing", action="store_true")
    p.set_defaults(func=command_write_camera_source)

    p = sub.add_parser("import-tiled", help="Import a Tiled TMX Layout layer back to world_map.raw, optionally also importing Spawns")
    p.add_argument("tmx", type=Path)
    p.add_argument("output_world_map", type=Path)
    p.add_argument("--layer-name", default="Layout")
    p.add_argument("--output-spawns-bin", type=Path, help="Also import the Tiled object layer back to spawns.bin")
    p.add_argument("--object-layer-name", default="Spawns")
    p.add_argument("--object-profiles", type=Path, help="Object profile JSON. If omitted, uses object_profiles.json next to the TMX when present")
    p.set_defaults(func=command_import_tiled)

    p = sub.add_parser("import-tiled-spawns", help="Import the Tiled Spawns object layer back to spawns.bin")
    p.add_argument("tmx", type=Path)
    p.add_argument("output_spawns_bin", type=Path)
    p.add_argument("--object-layer-name", default="Spawns")
    p.add_argument("--output-csv", type=Path, help="Optional CSV debug export after importing objects")
    p.add_argument("--object-profiles", type=Path, help="Object profile JSON. If omitted, uses object_profiles.json next to the TMX when present")
    p.set_defaults(func=command_import_tiled_spawns)


    p = sub.add_parser("build-tiled-stage", help="Import one Tiled TMX into assets/levels/stageX layout.rleff + spawns.bin")
    p.add_argument("stage", type=int)
    p.add_argument("tmx", type=Path)
    p.add_argument("stage_dir", type=Path, help="Path like assets/levels/stage0")
    p.add_argument("--layer-name", default="Layout")
    p.add_argument("--object-layer-name", default="Spawns")
    p.add_argument("--object-profiles", type=Path, help="Object profile JSON. If omitted, uses object_profiles.json next to the TMX when present")
    p.add_argument("--rom", type=Path, help="Optional original ROM, used only if page_table.bin is missing")
    p.add_argument("--no-verify", action="store_true")
    p.set_defaults(func=command_build_tiled_stage)

    p = sub.add_parser("build-tiled-all", help="Import default Tiled TMX files for multiple stages into assets/levels")
    p.add_argument("tiled_root", type=Path, help="Root containing stage0/stage0_normal.tmx, stage2/stage2_initial.tmx, etc.")
    p.add_argument("levels_root", type=Path, help="Path like assets/levels")
    p.add_argument("--stages", help="Stage list, e.g. 0 or 0-4. Defaults to all stages")
    p.add_argument("--layer-name", default="Layout")
    p.add_argument("--object-layer-name", default="Spawns")
    p.add_argument("--object-profiles", type=Path, help="Object profile JSON override used for all stages")
    p.add_argument("--rom", type=Path, help="Optional original ROM, used only if page_table.bin is missing")
    p.add_argument("--skip-missing", action="store_true")
    p.add_argument("--no-verify", action="store_true")
    p.add_argument("--output-json", type=Path, help="Optional build summary JSON")
    p.set_defaults(func=command_build_tiled_all)

    p = sub.add_parser("write-object-profiles", help="Write the default editable object_profiles.json")
    p.add_argument("output_json", type=Path)
    p.set_defaults(func=command_write_object_profiles)

    p = sub.add_parser("write-rgbds-manifest", help="Write source-level RGBDS INCBIN manifest for edited layout/spawn assets")
    p.add_argument("levels_root", type=Path, help="Path like assets_clean_v13/levels")
    p.add_argument("output_asm", type=Path)
    p.add_argument("--stages", help="Stage list, e.g. 0 or 0-4. Defaults to all stages")
    p.add_argument("--prefer-new", action="store_true", help="Prefer layout.rleff.new / spawns.bin.new when present")
    p.add_argument("--project-root", type=Path, help="Base directory for relative INCBIN paths")
    p.add_argument("--output-json", type=Path, help="Optional JSON manifest summary")
    p.set_defaults(func=command_write_rgbds_manifest)

    p = sub.add_parser("build-spawns", help="Build spawns.bin from spawns.csv")
    p.add_argument("spawns_csv", type=Path)
    p.add_argument("output_spawns_bin", type=Path)
    p.set_defaults(func=command_build_spawns)

    return ap


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        args.func(args)
    except Exception as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
