"""Export editable material masks without changing the original pixel/animation data."""

import json
from pathlib import Path

from PIL import Image

ART = Path(__file__).resolve().parent / "art/color"

STAGE_SHEETS = (
    "background_pixels", "sprite_pixels", "boss_pixels",
    "squirrel_pixels", "cockroach_pixels", "chicken_pixels", "kamen_pixels",
    "school_background", "school_final_background", "school_objects", "school_boss_pixels",
    "mall_background", "mall_objects", "mall_middle_tiles", "mall_top_tiles",
    "mall_overlay_objects", "mall_boss_pixels", "guam_background", "guam_objects", "guam_boss_pixels",
)
SCENE_NAMES = (
    "title", "password", "intro", "continue", "ending", "scrolling_ending", "ending_hint",
    "bonus", "bug_hunt", "mekemeke", "slide_jump", "tutorial",
    "dialogue_0", "dialogue_1", "dialogue_2", "dialogue_3",
)
WORLD_SIZES = {
    "picnic": (3584, 256),
    "school": (3584, 256),
    "mall": (1024, 1024),
    "mall-middle": (1024, 1024),
    "mall-upper": (1024, 1024),
    "mall-top": (1024, 256),
    "guam": (2560, 1280),
}


def palettes():
    colors = json.loads((ART / "palette.json").read_text(encoding="utf-8"))
    if not 1 <= len(colors) <= 64 or any(len(palette) != 4 for palette in colors.values()):
        raise ValueError("The color palette needs 1–64 named four-color materials")
    result = [[int(color.lstrip("#"), 16) for color in palette] for palette in colors.values()]
    if any(value < 0 or value > 0xffffff for palette in result for value in palette):
        raise ValueError("Material colors must be 24-bit RGB values")
    return result


def scene_tones():
    colors = json.loads((ART / "sgb-tones.json").read_text(encoding="utf-8"))
    names = ("ink", "red", "green", "gold", "blue", "pink", "teal", "paper")
    if set(colors) != set(names):
        raise ValueError("SGB scene tones need the eight named color anchors")
    result = [int(colors[name], 16) for name in names]
    if any(value < 0 or value > 0xffffff for value in result):
        raise ValueError("SGB scene tones must be 24-bit RGB values")
    return result


def read_mask(name, size, colors):
    with Image.open(ART / (name + ".png")) as image:
        if image.mode != "P" or image.size != size:
            raise ValueError(f"{name}: expected an indexed PNG of size {size}")
        expected = [channel for palette in colors for color in palette
                    for channel in ((color >> 16) & 255, (color >> 8) & 255, color & 255)]
        if image.getpalette()[:len(expected)] != expected:
            raise ValueError(f"{name}: palette differs from palette.json")
        pixels = image.tobytes()
        if max(pixels) >= len(colors) * 4:
            raise ValueError(f"{name}: unknown material index")
        return pixels


def sheet_size(pixels):
    return 128, ((len(pixels) // 64 + 15) // 16) * 8


def tile_at(image, width, column, row):
    return bytes(image[(row * 8 + y) * width + column * 8 + x] for y in range(8) for x in range(8))


def world_tiles(assets, name):
    stage = name.split("-")[0]
    width, height = WORLD_SIZES[name]
    prefix = "" if stage == "picnic" else stage + "_"
    layout, quads = assets[prefix + "layout"], assets[prefix + "metatiles"]
    if name == "mall-top":
        quads = assets["mall_top_metatiles"]
    result = []
    for row in range(height // 8):
        for column in range(width // 8):
            page = column // 32
            if stage not in ("picnic", "school"):
                page = assets[stage + "_pages"][(row // 32) * 14 + page]
            offset = page * 256 + (row % 32 // 2) * 16 + column % 32 // 2
            result.append(quads[layout[offset] * 4 + row % 2 * 2 + column % 2])
    return result


def world_graphics(assets, name, column, tile):
    stage = name.split("-")[0]
    if stage == "school" and column * 8 >= 2304:
        return assets["school_final_background"][tile * 64:(tile + 1) * 64]
    if name.startswith("mall-") and tile >= 0x45 and tile < 0x80:
        patch = "mall_middle_tiles" if name == "mall-middle" else "mall_top_tiles"
        return assets[patch][(tile - 0x45) * 64:(tile - 0x44) * 64]
    source = "background_pixels" if stage == "picnic" else stage + "_background"
    return assets[source][tile * 64:(tile + 1) * 64]


def animated_graphic(stage, tile, phase):
    groups = {"picnic": ((0x2e, 2), (0x39, 3), (0x3c, 2)),
              "school": ((0x29, 2),), "guam": ((0x5e, 2),)}
    for first, count in groups.get(stage, ()):
        if first <= tile < first + count:
            return first + (tile - first + phase) % count
    return tile


def world_frame(name, indexed, assets, tiles, phase):
    width = indexed.width
    stage = name.split("-")[0]
    frame = bytearray(indexed.tobytes())
    for index, tile in enumerate(tiles):
        live = animated_graphic(stage, tile, phase)
        if live == tile:
            continue
        row, column = divmod(index, width // 8)
        shades = world_graphics(assets, name, column, live)
        for pixel, shade in enumerate(shades):
            offset = (row * 8 + pixel // 8) * width + column * 8 + pixel % 8
            frame[offset] = frame[offset] // 4 * 4 + shade
    image = Image.frombytes("P", indexed.size, bytes(frame))
    image.putpalette(indexed.getpalette())
    return image


def rgb_tile(image, width, column, row):
    return b"".join(image[((row * 8 + y) * width + column * 8) * 3:
                           ((row * 8 + y) * width + column * 8 + 8) * 3] for y in range(8))


def argb(pixels):
    return [0xff000000 | int.from_bytes(pixels[i:i + 3], "big") for i in range(0, len(pixels), 3)]


def export_colors(out, assets, array, preview_dir=None):
    colors = palettes()
    clothing = {i for i, name in enumerate(json.loads((ART / "palette.json").read_text(encoding="utf-8")))
                if name in ("shirt", "shirt-fill", "shorts", "shorts-fill")}
    if preview_dir:
        preview_dir.mkdir(parents=True, exist_ok=True)

    def preview(name, image):
        if preview_dir:
            image.save(preview_dir / (name + ".png"))

    out.write('#pragma once\n\n#include "color.hpp"\n#include "stage_data.hpp"\n'
              '#include "screen_data.hpp"\n\nnamespace shin4::color_data {\n\n')
    array(out, "sgb_tones", scene_tones(), "std::uint32_t")
    sheets = [(name, "data") for name in STAGE_SHEETS]
    sheets += [(name + suffix, "scene_data") for name in SCENE_NAMES for suffix in ("_background", "_objects")]
    for name, _ in sheets:
        source = assets[name]
        width, height = sheet_size(source)
        image = read_mask(name, (width, height), colors)
        clothing_rows = []
        for tile in range(len(source) // 64):
            pixels = tile_at(image, width, tile % 16, tile // 16)
            if bytes(index % 4 for index in pixels) != source[tile * 64:(tile + 1) * 64]:
                raise ValueError(f"{name}: tile {tile:02x} changes the original shades")
            if name == "title_objects":
                clothing_rows.extend(sum(1 << x for x in range(8) if pixels[y * 8 + x] // 4 in clothing)
                                     for y in range(8))
        if name == "title_objects":
            array(out, "title_clothing_rows", clothing_rows)
        with Image.open(ART / (name + ".png")) as indexed:
            painted = indexed.convert("RGB")
        preview(name, painted)
        pixels = painted.tobytes()
        packed = b"".join(rgb_tile(pixels, width, tile % 16, tile // 16) for tile in range(len(source) // 64))
        array(out, name + "_colors", argb(packed), "std::uint32_t")
    out.write("inline constexpr color::Sheet sheets[] = {\n")
    for name, namespace in sheets:
        out.write(f"    {{{namespace}::{name}, {name}_colors, {len(assets[name])}}},\n")
    out.write("};\n\n")
    for name, (width, height) in WORLD_SIZES.items():
        tiles = world_tiles(assets, name)
        frames = []
        image = read_mask(name + "-world", (width, height), colors)
        with Image.open(ART / (name + "-world.png")) as indexed:
            for index, source in enumerate(tiles):
                row, column = divmod(index, width // 8)
                pixels = tile_at(image, width, column, row)
                if bytes(value % 4 for value in pixels) != world_graphics(assets, name, column, source):
                    raise ValueError(f"{name}: color tile ({column}, {row}) changes the original shades")
            for phase in range(3):
                painted = world_frame(name, indexed, assets, tiles, phase).convert("RGB")
                preview(name + f"-world-{phase}", painted)
                frames.append(painted.tobytes())
        sources, pixels, tilemap, variants = [], bytearray(), [], {}
        frame_map, pool = [], {}
        for index, source in enumerate(tiles):
            row, column = divmod(index, width // 8)
            tile_frames = tuple(rgb_tile(frame, width, column, row) for frame in frames)
            key = source, tile_frames
            if key not in variants:
                variants[key] = len(sources)
                sources.append(source)
                for tile in tile_frames:
                    if tile not in pool:
                        pool[tile] = len(pool)
                        pixels.extend(tile)
                    frame_map.append(pool[tile])
            tilemap.append(variants[key])
        symbol = name.replace("-", "_")
        array(out, symbol + "_sources", sources)
        array(out, symbol + "_colors", argb(pixels), "std::uint32_t")
        array(out, symbol + "_frames", frame_map, "std::uint32_t")
        array(out, symbol + "_map", tilemap, "std::uint32_t")
        out.write(f"inline constexpr color::Atlas {symbol}{{{symbol}_sources, {symbol}_colors, {symbol}_frames, "
                  f"{symbol}_map, {width // 8}, {height // 8}}};\n\n")
    out.write("} // namespace shin4::color_data\n")
