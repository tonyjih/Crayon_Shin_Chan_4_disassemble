"""Compile original assets into headers for the native game."""

import argparse
from pathlib import Path
import sys
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parent.parent
sys.path[:0] = [str(ROOT / "tools"), str(ROOT / "level_tools")]

from build_original import build, read_spawns
from export_screens import export_screens
from export_colors import export_colors
from shin4_level_pipeline import (
    decode_2bpp_tile,
    decode_obj_2bpp_tile,
    parse_metasprite,
    rom_offset,
    vram_copy_from_rom,
)

ORIGINAL = ROOT / "original"
STAGE = ORIGINAL / "levels/stage0"


def read_symbols(path):
    symbols = {}
    for line in path.read_text(encoding="ascii").splitlines():
        if line and not line.startswith(";"):
            address, name = line.split()
            symbols[name] = tuple(int(value, 16) for value in address.split(":"))
    return symbols


def array(out, name, values, element_type="unsigned char"):
    out.write(f"inline constexpr {element_type} {name}[] = {{\n")
    for start in range(0, len(values), 24):
        out.write("    " + ", ".join(f"0x{value:02x}" for value in values[start:start + 24]) + ",\n")
    out.write("};\n\n")


def sprite_frames(out, name, rom, bank, addresses):
    out.write(f"inline constexpr SpriteFrame {name}[] = {{\n")
    for address in addresses:
        parts = parse_metasprite(rom, bank, address)
        fields = ", ".join(f"{{{x}, {y}, 0x{tile:02x}, 0x{flags:02x}}}"
                           for y, x, tile, flags in parts)
        out.write(f"    {{{{{fields}}}, {len(parts)}}},\n")
    out.write("};\n\n")


def export(out, rom, symbols, array=array):
    def address(label):
        bank, pointer = symbols[label]
        if bank != 0:
            raise ValueError(f"expected {label} in bank 0")
        return pointer

    # LoadStageGraphics and StageGfxLoadList_Stage0 use these VRAM slots.
    vram = bytearray(0x1800)
    for label, destination, size in (
        ("Gfx_b05_4001", 0x8000, 0x130),
        ("Gfx_b05_4131", 0x8130, 0x470),
        ("Gfx_b05_5701", 0x8d00, 0x300),
        ("Gfx_b05_5ad1", 0x8700, 0x3f0),
        ("Gfx_b05_5a01", 0x8b00, 0x0d0),
        ("Gfx_b07_4001", 0x9000, 0x800),
    ):
        bank, source = symbols[label]
        vram_copy_from_rom(rom, vram, bank, source, destination, size)

    def stage_graphics(label):
        script = rom_offset(*symbols[label])
        target = vram.copy()
        target[0x700:0xd00] = bytes(0x600)
        while rom[script] != 0xff:
            source, destination, size = (int.from_bytes(rom[i:i + 2], "little")
                                         for i in range(script, script + 6, 2))
            vram_copy_from_rom(rom, target, rom[script + 6], source, destination, size)
            script += 7
        return target

    def pixels(name, vram, first=0, end=256, background=False):
        decode = (lambda tile: decode_2bpp_tile(vram, tile, "signed")) if background else (
            lambda tile: decode_obj_2bpp_tile(vram, tile))
        array(out, name, [pixel for tile in range(first, end) for pixel in decode(tile)])

    out.write('#pragma once\n\n#include "stage.hpp"\n\nnamespace shin4::data {\n\n')
    array(out, "layout", (STAGE / "layout.bin").read_bytes())
    array(out, "metatiles", (STAGE / "metatiles.bin").read_bytes())
    attributes = (ORIGINAL / "levels/shared/collision_attrs.bin").read_bytes()
    array(out, "attributes", attributes[:256])
    background = [pixel for tile in range(256) for pixel in decode_2bpp_tile(vram, tile, "signed")]
    array(out, "background_pixels", background)
    array(out, "sprite_pixels",
          [pixel for tile in range(256) for pixel in decode_obj_2bpp_tile(vram, tile)])

    form_names = ("normal", "squirrel", "cockroach", "chicken", "kamen")
    for name, label in zip(form_names[1:], ("Gfx_b05_45a1", "Gfx_b05_53a1",
                                            "Gfx_b05_4f41", "Gfx_b05_4ad1")):
        form_vram = vram.copy()
        bank, source = symbols[label]
        vram_copy_from_rom(rom, form_vram, bank, source, 0x8130, 0x530)
        array(out, name + "_pixels", [pixel for tile in range(0x13, 0x66)
                                    for pixel in decode_obj_2bpp_tile(form_vram, tile)])
    out.write("inline constexpr const unsigned char* form_pixels[] = {nullptr, squirrel_pixels, "
              "cockroach_pixels, chicken_pixels, kamen_pixels};\n\n")

    boss_vram = vram.copy()
    bank, source = symbols["Gfx_b05_64e1"]
    vram_copy_from_rom(rom, boss_vram, bank, source + 0x80, 0x8700, 0x600)
    array(out, "boss_pixels", [pixel for tile in range(0x70, 0xd0)
                              for pixel in decode_obj_2bpp_tile(boss_vram, tile)])
    school_vram = stage_graphics("StageGfxLoadList_Stage1")
    array(out, "school_background",
          [pixel for tile in range(256) for pixel in decode_2bpp_tile(school_vram, tile, "signed")])
    array(out, "school_objects",
          [pixel for tile in range(256) for pixel in decode_obj_2bpp_tile(school_vram, tile)])
    tile_bank, tile_source = symbols["Gfx_b07_4ee1"]
    vram_copy_from_rom(rom, school_vram, tile_bank, tile_source, 0x91a0, 0x480)
    array(out, "school_final_background",
          [pixel for tile in range(256) for pixel in decode_2bpp_tile(school_vram, tile, "signed")])
    vram_copy_from_rom(rom, school_vram, bank, source + 0x340, 0x8700, 0x600)
    array(out, "school_boss_pixels", [pixel for tile in range(0x70, 0xd0)
                                     for pixel in decode_obj_2bpp_tile(school_vram, tile)])
    for name, index, boss_offset in (("mall", 2, 0x610), ("guam", 3, 0x9a0)):
        stage_vram = stage_graphics(f"StageGfxLoadList_Stage{index}")
        pixels(name + "_background", stage_vram, background=True)
        pixels(name + "_objects", stage_vram)
        if index == 2:
            for suffix, label in (("middle", "Bank0TrailingGraphicsData_3572"),
                                  ("top", "Bank0TrailingGraphicsData_3902")):
                patch = stage_vram.copy()
                tile_bank, tile_source = symbols[label]
                vram_copy_from_rom(rom, patch, tile_bank, tile_source, 0x9450, 0x3b0)
                pixels(f"mall_{suffix}_tiles", patch, 0x45, 0x80, background=True)
            tile_bank, tile_source = symbols["Gfx_b05_6411"]
            vram_copy_from_rom(rom, stage_vram, tile_bank, tile_source, 0x8c00, 0xd0)
            pixels("mall_overlay_objects", stage_vram, 0xc0, 0xcd)
        vram_copy_from_rom(rom, stage_vram, bank, source + boss_offset, 0x8700, 0x600)
        pixels(name + "_boss_pixels", stage_vram, 0x70, 0xd0)
        start = rom_offset(*symbols[f"StageInitBlock_{index}"]) + 8
        rows = index + 2
        array(out, name + "_pages", rom[start:start + rows * 14])

    for name, table, count in (
        ("normal_frames", "SpriteAnimPointerTable_1a23", 22),
        ("squirrel_frames", "SpriteAnimPointerTable_1a4f", 26),
        ("cockroach_frames", "SpriteAnimPointerTable_1a83", 30),
        ("chicken_frames", "SpriteAnimPointerTable_1abf", 26),
        ("kamen_frames", "SpriteAnimPointerTable_1af3", 25),
        ("actor_frames", "SpriteAnimPointerTable_1b2d", 26),
        ("school_frames", "SpriteAnimPointerTable_1b61", 28),
        ("mall_frames", "SpriteAnimPointerTable_1b99", 28),
        ("guam_frames", "SpriteAnimPointerTable_1bd1", 32),
    ):
        start = address(table)
        pointers = (int.from_bytes(rom[pos:pos + 2], "little")
                    for pos in range(start, start + count * 2, 2))
        sprite_frames(out, name, rom, 0, pointers)
    out.write("inline constexpr const SpriteFrame* player_frames[] = {" +
              ", ".join(name + "_frames" for name in form_names) + "};\n\n")

    sprite_frames(out, "pickup_frames", rom, 0,
                  [address(label) for label in ("SpriteFrameData_2c85", "SpriteFrameData_2c8e",
                                                "SpriteFrameData_2c9f", "SpriteFrameData_2c41",
                                                "SpriteFrameData_2c74", "SpriteFrameData_2c63",
                                                "SpriteFrameData_2c52")])
    platform_frames = ("MovingPlatformVerticalSprite", "DropPlatformSpriteA",
                       "BouncePadSpriteIdle", "BouncePadSpritePressed")
    sprite_frames(out, "platform_frames", rom, 1, [symbols[label][1] for label in platform_frames])
    sprite_frames(out, "shot_frames", rom, 0,
                  [address(label) for label in ("SpriteFrameData_2e96", "SpriteFrameData_2e9b",
                                                "SpriteFrameData_30e2", "SpriteFrameData_32e7",
                                                "SpriteFrameData_32d2")])
    sprite_frames(out, "mall_prop_frames", rom, 0,
                  [address(f"SpriteFrameData_{label}") for label in
                   ("21ce", "21ff", "2230", "223f", "2235", "223a", "2244", "2255", "2266", "2277")])
    sprite_frames(out, "guam_prop_frames", rom, 0,
                  [address(f"SpriteFrameData_{label}") for label in ("2475", "2486")])
    tutorial = ORIGINAL / "levels/stage4"
    school = ORIGINAL / "levels/stage1"
    array(out, "school_layout", (school / "layout.bin").read_bytes())
    array(out, "school_metatiles", (school / "metatiles.bin").read_bytes())
    start = rom_offset(*symbols["Stage1CollisionAttrsWindow_Bank4"])
    array(out, "school_attributes", rom[start:start + 256])
    array(out, "tutorial_layout", (tutorial / "layout.bin").read_bytes())
    array(out, "tutorial_metatiles", (tutorial / "metatiles.bin").read_bytes())
    start = rom_offset(*symbols["Stage4CollisionAttrsWindow_Bank4"])
    array(out, "tutorial_attributes", rom[start:start + 256])
    mall = ORIGINAL / "levels/stage2"
    guam = ORIGINAL / "levels/stage3"
    for name, index, directory in (("mall", 2, mall), ("guam", 3, guam)):
        array(out, name + "_layout", (directory / "layout.bin").read_bytes())
        array(out, name + "_metatiles", (directory / "metatiles.bin").read_bytes())
        start = rom_offset(*symbols[f"Stage{index}CollisionAttrsWindow_Bank4"])
        array(out, name + "_attributes", rom[start:start + 256])
    # The original points at this table even while the last scroll still shows the floor below.
    start = rom_offset(*symbols["Stage2MetatileQuadsAfterSwitch_Bank4"])
    array(out, "mall_top_metatiles", rom[start:start + 256 * 4])
    start = rom_offset(*symbols["Stage2CollisionPatch_Bank4"])
    array(out, "mall_top_attributes", rom[start:start + 0x30])
    for name, directory in (("spawns", STAGE), ("school_spawns", school),
                            ("mall_spawns", mall), ("guam_spawns", guam), ("tutorial_spawns", tutorial)):
        out.write(f"inline constexpr Spawn {name}[] = {{\n")
        for kind, x, y, param in read_spawns(directory / "spawns.csv"):
            out.write(f"    {{0x{kind:02x}, {x}, {y}, {param}}},\n")
        out.write("};\n\n")
    out.write("} // namespace shin4::data\n")

    # The tutorial loads the last stage's tiles, then replaces the text area.
    return stage_graphics("StageGfxLoadList_Stage3")


def export_sound(out, rom, symbols):
    bank, address = symbols["SoundDirectory"]
    _, first_track = symbols["AudioTrack_63a5"]
    out.write("#pragma once\n\nnamespace shin4::data {\n\n")
    out.write(f"inline constexpr unsigned sound_base = {address:#x};\n")
    out.write(f"inline constexpr unsigned sound_count = {(first_track - address) // 4};\n\n")
    array(out, "sound_rom", rom[rom_offset(bank, address):rom_offset(bank, 0x7fff) + 1])
    for name, label, size in (
        ("wave_patterns", "SoundWavePatterns_10d0", 64),
        ("noise_periods", "SoundNoiseNoteIndexTable_1282", 16),
        ("note_periods", "SoundFrequencyTable_14c3", 48),
        ("pitch_envelope", "SoundPitchEnvelopeTable_14e3", 160),
        ("duty_envelope", "SoundDutyEnvelopeTable_1583", 256),
        ("vibrato_offsets", "SoundVibratoOffsetTable_1683", 128),
    ):
        start = rom_offset(*symbols[label])
        array(out, name, rom[start:start + size])
    out.write("} // namespace shin4::data\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("header", type=Path)
    parser.add_argument("sound_header", type=Path)
    parser.add_argument("screen_header", type=Path)
    parser.add_argument("color_header", type=Path)
    parser.add_argument("sprite_header", type=Path, nargs="?")
    args = parser.parse_args()
    header = args.header
    header.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(dir=header.parent) as temporary:
        work = Path(temporary)
        build(work)
        rom = (work / "game.gb").read_bytes()
        symbols = read_symbols(work / "game.sym")
        assets = {}

        def record_array(out, name, values, element_type="unsigned char"):
            if element_type == "unsigned char":
                assets[name] = bytes(values)
            array(out, name, values, element_type)

        generated = work / header.name
        with generated.open("w", encoding="ascii") as out:
            tutorial_vram = export(out, rom, symbols, record_array)
        generated_sound = work / args.sound_header.name
        with generated_sound.open("w", encoding="ascii") as out:
            export_sound(out, rom, symbols)
        generated_screens = work / args.screen_header.name
        with generated_screens.open("w", encoding="ascii") as out:
            export_screens(out, rom, symbols, record_array, tutorial_vram)
        generated_colors = work / args.color_header.name
        with generated_colors.open("w", encoding="ascii") as out:
            export_colors(out, assets, array, header.parent / "painted")
        if args.sprite_header:
            from sprite_workspace import export_bindings
            generated_sprites = work / args.sprite_header.name
            with generated_sprites.open("w", encoding="ascii") as out:
                export_bindings(out, assets, generated.read_text(encoding="ascii"),
                                generated_screens.read_text(encoding="ascii"))
            generated_sprites.replace(args.sprite_header)
        generated.replace(header)
        generated_sound.replace(args.sound_header)
        generated_screens.replace(args.screen_header)
        generated_colors.replace(args.color_header)


if __name__ == "__main__":
    main()
