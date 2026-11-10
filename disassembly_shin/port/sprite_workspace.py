"""Export complete, freely editable RGBA sprite poses with their original frame mappings."""

import argparse
from functools import lru_cache
import hashlib
import io
import json
from pathlib import Path
import re
from tempfile import TemporaryDirectory
import zipfile

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
ART = ROOT / "port/art/color"
ROM_MD5 = "bcb3d47c291fd0a26b2c7b1082c3ad88"


def numbers(text):
    return [int(value, 0) for value in re.findall(r"-?0x[0-9a-fA-F]+|-?\d+", text)]


def read_frames(stage_header, scene_header):
    banks = {}
    for name, body in re.findall(r"inline constexpr SpriteFrame (\w+)\[\] = \{\n(.*?)\n\};", stage_header, re.S):
        frames = {}
        for index, line in enumerate(body.splitlines()):
            values = numbers(line)
            count = values.pop()
            if len(values) != count * 4:
                raise ValueError(f"Unexpected sprite declaration: {name}/{index}")
            frames[index] = [values[i:i + 4] for i in range(0, len(values), 4)]
        banks[name] = frames
    scene = {}
    for index, body in re.findall(r"inline constexpr SpritePart frame_(\d+)\[\] = \{(.*?)\};", scene_header):
        values = numbers(body)
        if len(values) % 4:
            raise ValueError(f"Unexpected scene sprite: {index}")
        scene[int(index)] = [values[i:i + 4] for i in range(0, len(values), 4)]
    for index in re.findall(r"inline constexpr std::span<const SpritePart> frame_(\d+)\{\};", scene_header):
        scene[int(index)] = []
    if set(scene) != set(range(0xf2)) or len(banks.get("normal_frames", {})) != 22:
        raise ValueError("The generated sprite tables are incomplete")
    banks["scene_frames"] = scene
    banks["bonus_border_frames"] = {0: [[0, 0, 0xaf, 0x10]]}
    cursors = {}
    for index, name in enumerate(("grid", "input")):
        declaration = re.search(r"SpritePart password_" + name + r"_cursor\[\] = \{(.*?)\};", scene_header)
        if not declaration:
            raise ValueError(f"Missing password cursor: {name}")
        values = numbers(declaration[1])
        cursors[index] = [values]
    banks["password_cursor_frames"] = cursors
    animations = {}
    for name, body in re.findall(r"inline constexpr SceneFrame (\w+)_frames\[\] = \{(.*?)\};", scene_header):
        frames = [{"ticks": int(ticks), "frame": int(frame), "mirrored": flip == "true"}
                  for ticks, frame, flip in re.findall(r"\{(\d+), (\d+), (true|false)\}", body)]
        declaration = re.search(r"SceneAnimation " + re.escape(name) + r"\{\w+_frames, (\d+), (true|false)\}", scene_header)
        if not declaration:
            raise ValueError(f"Missing animation control: {name}")
        animations[name] = {"frames": frames, "loop": int(declaration[1]), "hold": declaration[2] == "true"}
    return banks, animations


def load_original():
    # Use the same asset exporters as the game, rather than stale build caches.
    from export_stage import array, build, export, export_screens, read_symbols
    with TemporaryDirectory() as temporary:
        work = Path(temporary)
        build(work)
        rom = (work / "game.gb").read_bytes()
        if hashlib.md5(rom).hexdigest() != ROM_MD5:
            raise ValueError("The original ROM no longer matches the sprite catalog")
        symbols = read_symbols(work / "game.sym")
        assets = {}

        def record(out, name, values, element_type="unsigned char"):
            if element_type == "unsigned char":
                assets[name] = bytes(values)
            array(out, name, values, element_type)

        stage, scenes = io.StringIO(), io.StringIO()
        tutorial = export(stage, rom, symbols, record)
        export_screens(scenes, rom, symbols, record, tutorial)
        banks, animations = read_frames(stage.getvalue(), scenes.getvalue())
        return assets, banks, animations


def source_tiles(sheet, overlay=None, first=0, end=256):
    result = {tile: (sheet, tile) for tile in range(256)}
    if overlay:
        result.update({tile: (overlay, tile - first) for tile in range(first, end)})
    return result


def catalog(banks):
    groups = []

    def add(key, label, bank, sheet, ids=None, overlay=None, first=0, end=256, style="material", profile=None, anchor=(80, 96)):
        frames = banks[bank]
        groups.append({"id": key, "label": label, "bank": bank,
                       "frames": {i: frames[i] for i in (ids if ids is not None else frames)},
                       "sources": source_tiles(sheet, overlay, first, end), "style": style,
                       "profile": profile, "preview_anchor": anchor,
                       "default_mirrored": key == "03-bosses/mall"})

    for name, label in (("normal", "小新"), ("squirrel", "松鼠裝"), ("cockroach", "蟑螂裝"),
                        ("chicken", "小雞裝"), ("kamen", "動感超人")):
        add(f"01-player/{name}", label, name + "_frames", "sprite_pixels",
            overlay=None if name == "normal" else name + "_pixels", first=0x13, end=0x66)
    for name, label, bank, boss_first in (("picnic", "野餐", "actor_frames", 16),
                                         ("school", "學校", "school_frames", 20),
                                         ("mall", "百貨", "mall_frames", 21),
                                         ("guam", "關島", "guam_frames", 21)):
        sheet = "sprite_pixels" if name == "picnic" else name + "_objects"
        boss = "boss_pixels" if name == "picnic" else name + "_boss_pixels"
        add(f"02-actors/{name}", label + "敵人與物件", bank, sheet, range(boss_first))
        add(f"03-bosses/{name}", label + "頭目", bank, sheet, range(boss_first, len(banks[bank])), boss, 0x70, 0xd0)
        add(f"04-props/{name}-pickups", label + "道具", "pickup_frames", sheet)
        if name == "picnic":
            add("04-props/picnic-platforms", "野餐平台", "platform_frames", sheet)
    for form, ids in (("squirrel", range(2)), ("chicken", [2]), ("kamen", [3, 4])):
        add(f"04-props/{form}-shots", form + "投射物", "shot_frames", "sprite_pixels", ids,
            form + "_pixels", 0x13, 0x66)
    add("04-props/mall-carts", "百貨下層購物車", "mall_prop_frames", "mall_objects", [0, 1])
    add("04-props/mall-upper-props", "百貨上層商品與吊飾", "mall_prop_frames", "mall_objects", range(2, 10),
        overlay="mall_overlay_objects", first=0xc0, end=0xcd)
    add("04-props/guam-projectiles", "關島椰子與球", "guam_prop_frames", "guam_objects")
    add("05-scenes/bonus-border", "BONUS 閃爍星星", "bonus_border_frames", "bonus_objects")
    add("05-scenes/password-cursors", "密碼輸入游標", "password_cursor_frames", "password_objects")

    for name, label, ids in (("title", "標題小新與小白", range(14)),
                             ("password", "密碼畫面角色", range(14)),
                             ("bonus", "BONUS 與說明角色", range(14, 26)),
                             ("continue", "接關角色", range(84, 96)),
                             ("intro", "開場與關卡卡片", [177, 178]),
                             ("ending_hint", "片尾提示角色", [21, 22])):
        add(f"05-scenes/{name}", label, "scene_frames", name + "_objects", ids,
            style="title" if name == "title" else "material", profile=1 if name == "title" else None,
            anchor=(104, 96))
    for level in range(4):
        add(f"05-scenes/dialogue-{level + 1}", f"第 {level + 1} 關劇情角色", "scene_frames",
            f"dialogue_{level}_objects", range(124, 156))
    add("06-minigames/bug-hunt", "捕蟲角色與昆蟲", "scene_frames", "bug_hunt_objects", range(26, 84))
    add("06-minigames/mekemeke", "メケメケ角色與敵人", "scene_frames", "mekemeke_objects", range(96, 124))
    add("06-minigames/slide-jump", "滑水角色與效果", "scene_frames", "slide_jump_objects", range(156, 177))
    add("07-ending/cast", "一般片尾全體角色", "scene_frames", "ending_objects", range(179, 230),
        style="sgb", profile=0x19, anchor=(80, 72))
    add("07-ending/scrolling", "捲動片尾與粒子", "scene_frames", "scrolling_ending_objects", range(230, 242),
        style="sgb-scrolling", profile=0x0f, anchor=(48, 88))
    return groups


@lru_cache(maxsize=None)
def soften_sgb(rgb):
    values = json.loads((ART / "sgb-tones.json").read_text(encoding="utf-8"))
    tones = [int(values[name], 16) for name in ("ink", "red", "green", "gold", "blue", "pink", "teal", "paper")]
    channels = rgb
    mixed = [0, 0, 0]
    for corner, tone in enumerate(tones):
        weight = 1
        for channel in range(3):
            weight *= channels[channel] if corner & (1 << channel) else 255 - channels[channel]
        for channel in range(3):
            mixed[channel] += weight * ((tone >> (16 - channel * 8)) & 255)
    value = max(channels)
    result = [channel // (255 ** 3) for channel in mixed]
    if value < 128:
        ink = tones[0]
        result = [(((ink >> (16 - channel * 8)) & 255) * (128 - value) + tone * value) // 128
                  for channel, tone in enumerate(result)]
    return tuple(result)


def sgb_colors(assets, profile, softened=False):
    config = assets["sgb_profiles"][profile * 6:profile * 6 + 6]
    attributes = assets["sgb_attribute_files"][config[4] * 90:(config[4] + 1) * 90]

    @lru_cache(maxsize=None)
    def color(shade, column, row):
        if not 0 <= column < 20 or not 0 <= row < 18:
            raise ValueError("SGB sprite preview is outside the screen")
        cell = row * 20 + column
        palette = (attributes[cell // 4] >> (6 - cell % 4 * 2)) & 3
        identifier = config[0] if shade == 0 else config[palette]
        offset = identifier * 8 + shade * 2
        word = int.from_bytes(assets["sgb_colors"][offset:offset + 2], "little")
        values = [(word >> shift) & 31 for shift in (0, 5, 10)]
        rgb = tuple((value << 3) | (value >> 2) for value in values)
        return soften_sgb(rgb) if softened else rgb
    return color


def bounds_for(frames, padding=16):
    parts = [part for frame in frames.values() for part in frame]
    if not parts:
        return (-padding, -padding, padding, padding)
    return (min(part[0] for part in parts) - padding, min(part[1] for part in parts) - padding,
            max(part[0] for part in parts) + 8 + padding, max(part[1] for part in parts) + 8 + padding)


def compose(parts, sources, sheets, bounds, color=None, clothing=(), anchor=(80, 96), style="material", dmg_palettes=None):
    left, top, right, bottom = bounds
    image = Image.new("RGBA", (right - left, bottom - top))
    occupied = set()
    mappings = []
    for x, y, tile, flags in parts:
        sheet, source_tile = sources[tile]
        mappings.append({"x": x, "y": y, "tile": tile, "flags": flags, "sheet": sheet, "source_tile": source_tile})
    # Lower-X parts win, with original OAM order resolving equal X.
    for index in sorted(range(len(parts)), key=lambda i: (parts[i][0], i)):
        x, y, tile, flags = parts[index]
        sheet_name, source_tile = sources[tile]
        sheet = sheets[sheet_name]
        palette = sheet.getpalette()
        for py in range(8):
            for px in range(8):
                sx = source_tile % 16 * 8 + (7 - px if flags & 0x20 else px)
                sy = source_tile // 16 * 8 + (7 - py if flags & 0x40 else py)
                value = sheet.getpixel((sx, sy))
                target = (x - left + px, y - top + py)
                if value % 4 == 0 or target in occupied:
                    continue
                rgb = tuple(palette[value * 3:value * 3 + 3])
                if dmg_palettes is not None:
                    object_palette = dmg_palettes[bool(flags & 0x10)]
                    shade = (object_palette >> ((value % 4) * 2)) & 3
                    rgb = (255 - shade * 85,) * 3
                elif color and (style != "title" or value // 4 in clothing):
                    shade = ((0xe0 if style == "sgb-scrolling" else 0xe4) >> ((value % 4) * 2)) & 3
                    rgb = color(shade, (anchor[0] + x + px) // 8, (anchor[1] + y + py) // 8)
                image.putpixel(target, (*rgb, 255))
                occupied.add(target)
    return image, mappings


def pixel_hash(image):
    return hashlib.sha256(image.convert("RGBA").tobytes()).hexdigest()


def contact_sheet(frames, size, monochrome=False):
    scale, columns, margin = 3, 6, 12
    width, height = size
    cell_w, cell_h = width * scale + margin * 2, height * scale + 34
    output = Image.new("RGB", (cell_w * columns, cell_h * ((len(frames) + columns - 1) // columns)),
                       "#e5e5e5" if monochrome else "#e5e0d5")
    draw = ImageDraw.Draw(output)
    for index, (identifier, image) in enumerate(frames):
        x, y = index % columns * cell_w, index // columns * cell_h
        draw.text((x + margin, y + 6), f"{identifier:03d} / 0x{identifier:02X}",
                  fill="#343434" if monochrome else "#342e39")
        enlarged = image.resize((width * scale, height * scale), Image.Resampling.NEAREST)
        output.paste(enlarged, (x + margin, y + 24), enlarged)
    return output


def load_sheets(assets, groups):
    from export_colors import palettes, read_mask, sheet_size, tile_at
    materials = palettes()
    needed = {sheet for group in groups for frame in group["frames"].values()
              for _, _, tile, _ in frame for sheet, _ in [group["sources"][tile]]}
    sheets = {}
    for name in needed:
        raw = assets[name]
        size = sheet_size(raw)
        indexed = read_mask(name, size, materials)
        for tile in range(len(raw) // 64):
            original = bytes(value % 4 for value in tile_at(indexed, size[0], tile % 16, tile // 16))
            if original != raw[tile * 64:(tile + 1) * 64]:
                raise ValueError(f"{name}: color source changes the original tile {tile:02x}")
        with Image.open(ART / (name + ".png")) as source:
            sheets[name] = source.copy()
    return sheets


def group_images(group, sheets, assets, monochrome=False):
    names = list(json.loads((ART / "palette.json").read_text(encoding="utf-8")))
    clothing = {i for i, name in enumerate(names) if name in ("shirt", "shirt-fill", "shorts", "shorts-fill")}
    bounds = bounds_for(group["frames"])
    palette = sgb_colors(assets, group["profile"], group["style"] == "title") if group["profile"] and not monochrome else None
    dmg = None
    if monochrome:
        dmg = (0xd0, 0xe4)
        if group["id"] == "05-scenes/intro" or group["id"].startswith("05-scenes/dialogue-"):
            dmg = (0xd0, 0xd0)
        elif group["id"] == "06-minigames/mekemeke":
            dmg = (0xd0, 0xe0)
        elif group["id"] == "07-ending/scrolling":
            dmg = (0xe0, 0xe0)
    for identifier, parts in group["frames"].items():
        anchor = (48, 48) if group["style"] == "sgb-scrolling" and identifier >= 236 else group["preview_anchor"]
        image, mapping = compose(parts, group["sources"], sheets, bounds, palette, clothing, anchor, group["style"], dmg)
        yield identifier, image, mapping, anchor


def export_bindings(out, assets, stage_header, scene_header):
    banks, _ = read_frames(stage_header, scene_header)
    groups = catalog(banks)
    sheets = load_sheets(assets, groups)
    out.write('#pragma once\n#include "sprite_edits.hpp"\n#include "stage_data.hpp"\n#include "screen_data.hpp"\n'
              '\nnamespace shin4 {\ninline const SpriteBinding sprite_bindings[] = {\n')
    for group in groups:
        bounds = bounds_for(group["frames"])
        bank = group["bank"]
        scene = bank in ("scene_frames", "bonus_border_frames", "password_cursor_frames")
        sheet = group["sources"][0][0]
        source = "nullptr" if group["id"].startswith("01-player/") or bank == "shot_frames" else (
            "scene_data::" if scene else "data::") + sheet
        for identifier, image, _, _ in group_images(group, sheets, assets):
            if bank == "scene_frames":
                frame = f"scene_data::frames[{identifier}].data()"
            elif bank == "bonus_border_frames":
                frame = "scene_data::bonus_border_sprite"
            elif bank == "password_cursor_frames":
                frame = "scene_data::password_" + ("input" if identifier else "grid") + "_cursor"
            else:
                frame = f"&data::{bank}[{identifier}]"
            hash_ = 0xcbf29ce484222325
            for value in image.tobytes():
                hash_ = ((hash_ ^ value) * 0x100000001b3) & 0xffffffffffffffff
            out.write(f'    {{{frame}, {source}, "editable/{group["id"]}/{identifier:03d}.png", '
                      f'{image.width}, {image.height}, {-bounds[0]}, {-bounds[1]}, 0x{hash_:016x}ULL}},\n')
    out.write('};\n} // namespace shin4\n')


def export_workspace(output, monochrome=False):
    if output.exists():
        raise ValueError("Output already exists; choose a new directory to protect edited sprites")
    assets, banks, animations = load_original()
    groups = catalog(banks)
    sheets = load_sheets(assets, groups)
    tile_folder = output / "reference/tiles"
    tile_folder.mkdir(parents=True)
    for name, sheet in sheets.items():
        image = sheet.convert("RGBA")
        if monochrome:
            image.putdata([(255 - value % 4 * 85,) * 3 + (255 if value % 4 else 0,) for value in sheet.tobytes()])
        image.putalpha(Image.frombytes("L", sheet.size, bytes(255 if value % 4 else 0 for value in sheet.tobytes())))
        image.save(tile_folder / (name + ".png"))
    manifest = {"format": 1, "rom_md5": ROM_MD5, "pixel_format": "RGBA8",
                "color_mode": "dmg" if monochrome else "color", "groups": [], "frames": []}
    overview = []
    for group in groups:
        bounds = bounds_for(group["frames"])
        size = (bounds[2] - bounds[0], bounds[3] - bounds[1])
        anchor = [-bounds[0], -bounds[1]]
        folder = output / "editable" / group["id"]
        folder.mkdir(parents=True)
        reference = output / "reference" / group["id"]
        reference.mkdir(parents=True)
        previews = []
        for identifier, image, mapping, preview_anchor in group_images(group, sheets, assets, monochrome):
            name = f"{identifier:03d}.png"
            image.save(folder / name)
            image.save(reference / name)
            previews.append((identifier, image))
            manifest["frames"].append({"file": (folder / name).relative_to(output).as_posix(),
                                       "group": group["id"], "bank": group["bank"], "frame": identifier,
                                       "size": list(size), "anchor": anchor, "parts": mapping,
                                       "reference_hash": pixel_hash(image), "preview_anchor": list(preview_anchor)})
        preview_file = f"previews/{group['id'].replace('/', '--')}.png"
        (output / "previews").mkdir(exist_ok=True)
        contact_sheet(previews, size, monochrome).save(output / preview_file)
        scripts = {name: script for name, script in animations.items()
                   if group["bank"] == "scene_frames" and script["frames"] and
                   all(frame["frame"] in group["frames"] for frame in script["frames"])}
        manifest["groups"].append({"id": group["id"], "label": group["label"], "count": len(previews),
                                   "size": list(size), "anchor": anchor, "preview": preview_file, "animations": scripts,
                                   "default_mirrored": group["default_mirrored"]})
        representative = dict(previews).get(4, previews[0][1]) if group["id"].startswith("01-player/") else previews[0][1]
        overview.append((group["id"], representative))
    (output / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    write_guide(output, manifest)
    write_overview(output, overview, monochrome)
    if monochrome:
        write_monochrome_guide(output, manifest)
    return manifest


def write_overview(output, groups, monochrome=False):
    width, height, columns = 210, 180, 5
    image = Image.new("RGB", (columns * width, ((len(groups) + columns - 1) // columns) * height),
                      "#e5e5e5" if monochrome else "#e5e0d5")
    draw = ImageDraw.Draw(image)
    for index, (name, sprite) in enumerate(groups):
        x, y = index % columns * width, index // columns * height
        draw.text((x + 8, y + 8), name, fill="#343434" if monochrome else "#342e39")
        sprite = sprite.copy()
        factor = max(1, min(3, 190 // sprite.width, 145 // sprite.height))
        sprite = sprite.resize((sprite.width * factor, sprite.height * factor), Image.Resampling.NEAREST)
        image.paste(sprite, (x + (width - sprite.width) // 2, y + 29), sprite)
    image.save(output / "OVERVIEW.png")


def write_monochrome_guide(output, manifest):
    rows = "\n".join(f"| {group['id']} | {group['label']} | {group['count']} |" for group in manifest["groups"])
    text = f"""# GB 原版黑白 Sprite 加工底稿

共 {len(manifest['groups'])} 組、{len(manifest['frames'])} 個姿勢，從原版 GB 像素與精靈調色盤還原。
原本的輪廓、點陣紋樣及透明區域完整保留。顯示色階為純白、淺灰、深灰、純黑；每張依原版 OBJ 調色盤選用。

## 開始加工

- 直接畫 `editable/` 的透明 PNG，可自由上色、改輪廓及透明度。
- 檔名、畫布尺寸及基準點與彩色包相同，四周也保留 16 像素。請勿自動裁切或縮放。
- `reference/` 是原版黑白底稿，可隨時複製回去復原。
- `previews/` 是放大對照表，`OVERVIEW.png` 是全部分類總覽。
- `reference/tiles/` 保留原始 2bpp 圖塊的灰階，尚未套用各個 Sprite 的 OBJ 調色盤。
- `manifest.json` 保留原版編號、圖塊、翻轉與動畫對應；請保留。

## 在遊戲裡邊畫邊看

在目前專案內雙擊 `preview-live.cmd`，或指定這份黑白包的根目錄：

```powershell
shin4-live-sprites.exe --sprites "{output.resolve()}"
```

黑白底稿會先以黑白 Sprite 出現在彩色模式裡；存檔後約 0.25 秒重新載入，對應姿勢顯示時即可看到修改。
`F2` 凍結畫面但保持 PNG 更新，`F5` 強制重讀。PNG 尺寸錯誤或尚未存完時會保留上一張圖，錯誤見 `sprite-reload.log`。

也可把需要的黑白姿勢複製到原本 `Shin4-Sprites-Editable/` 的相同路徑，再繼續加工；不用整包覆蓋彩色素材。
`F1` 切到 DMG 模式可看原版整體黑白畫面；要預覽自己的 PNG，請切回彩色模式。碰撞範圍與動畫時序維持原版。

| 資料夾 | 內容 | 姿勢數 |
| --- | --- | ---: |
{rows}
"""
    (output / "README.md").write_text(text, encoding="utf-8")
    launcher = '''@echo off
setlocal
set "SHIN4_EXE=%~dp0..\\build\\sdl-win\\Release\\shin4-live-sprites.exe"
if not exist "%SHIN4_EXE%" set "SHIN4_EXE=%~dp0..\\shin4-live-sprites.exe"
if not exist "%SHIN4_EXE%" set "SHIN4_EXE=%~dp0shin4-live-sprites.exe"
if not exist "%SHIN4_EXE%" (
  echo Please put shin4-live-sprites.exe and SDL3.dll beside this folder.
  pause
  exit /b 1
)
start "" "%SHIN4_EXE%" --sprites "%~dp0."
'''
    (output / "preview-live.cmd").write_text(launcher, encoding="ascii", newline="\r\n")


def write_guide(output, manifest):
    rows = "\n".join(f"| {group['id']} | {group['label']} | {group['count']} | {group['size'][0]}×{group['size'][1]} |"
                     for group in manifest["groups"])
    text = f"""# 蠟筆小新 4：Sprite 手動編輯包

共 {len(manifest['groups'])} 組、{len(manifest['frames'])} 個完整姿勢。直接編輯 `editable/` 裡的透明 PNG。

## 怎麼修改

1. 先看 `OVERVIEW.png` 找角色，再用 `previews/` 的放大圖找到姿勢編號。
2. 開啟 `editable/<分類>/<角色>/<編號>.png`，一個像素就是遊戲的一個像素。
3. 可自由改 RGB 顏色、外輪廓與透明度，不受四階色盤或原本 8×8 圖塊限制。
4. 保留原檔名與畫布大小，PNG 四周已預留 16 像素。不要自動裁切透明邊緣或縮放。
5. 同一組的基準點相同，腳底／角色原點不會因不同姿勢移位。左右翻轉通常由遊戲處理，只需改這份原姿勢。
6. 啟動支援 PNG 即時載入的新版遊戲，存檔後約 0.25 秒會重讀；該姿勢再次播放時就會看到新圖。

新版遊戲會自動尋找 `Shin4-Sprites-Editable` 資料夾，直接讀取 `editable/` 的 PNG。不要把它們覆蓋到 `port/art/color/` 的索引圖塊。

## 即時預覽

- `F2`：凍結／繼續遊戲更新。凍結時 PNG 仍會重新載入，方便停在同一個姿勢修圖。
- `F5`：強制重讀已顯示過的 PNG；適用於繪圖工具保留檔案時間戳的情況。
- `F1`：切換彩色與原版 DMG 顯示。PNG 僅影響彩色模式。
- 從 `reference/` 複製對應姿勢回 `editable/`，即可恢復原本繪製；未修改底稿仍保留原版 SGB 動態配色。
- 圖片尚未存完、尺寸不符或解碼失敗時，保留上一張可用圖。修好並再次存檔即可恢復。
- 載入／錯誤紀錄在資料夾內的 `sprite-reload.log`。
- 圖像修改不會改變碰撞範圍、動畫編號與時序。保留 `manifest.json` 供查閱，執行時只需 PNG。

資料夾可放在程式旁、專案根目錄，或自行指定：

```powershell
shin4.exe --sprites "{output.resolve()}"
```

加上 `--no-sprites` 可使用完整內建素材。舊版執行檔不支援即時載入，請使用新版一次，之後改圖不需重編譯。

## 其他檔案

- `reference/`：未修改的 RGBA 底稿，方便比較或復原。
- `reference/tiles/`：原始材質圖塊表，供查找來源；SGB 場景的最終配色以完整姿勢 PNG 為準。
- `previews/`：放大對照表，僅供看圖，不是要修改的素材。
- `manifest.json`：原版 frame、圖塊、翻轉旗標、基準點、底稿雜湊，以及劇情動畫順序與時長。請保留。
- PNG 編號是十進位；對照表同時標示十六進位，方便和程式核對。

片尾使用目前的 SGB 配色。SGB 原作會依角色在畫面上的位置調色，這裡取主要演出位置作為編輯底稿。
同一圖塊原本可能被多個姿勢共用；本包把姿勢分開保存，修改時可獨立處理。
檔案採原始姿勢朝向；百貨頭目在遊戲中會固定鏡像，對應表以 `default_mirrored` 標示。
原版保留的姿勢也一併輸出，空白的保留編號可能是全透明圖。

## 分類

| 資料夾 | 內容 | 姿勢數 | 畫布大小 |
| --- | --- | ---: | --- |
{rows}

## 檢查修改

在原專案執行：

```powershell
python -B port/sprite_workspace.py check "{output.resolve()}"
```

會列出已修改的姿勢，並檢查缺檔、尺寸及圖片格式；不會覆寫圖片或原遊戲素材。
"""
    (output / "README.md").write_text(text, encoding="utf-8")


def check_workspace(output):
    manifest = json.loads((output / "manifest.json").read_text(encoding="utf-8"))
    if manifest.get("format") != 1 or not manifest.get("frames"):
        raise ValueError("Unsupported or empty sprite manifest")
    changed = []
    for frame in manifest["frames"]:
        path = output / frame["file"]
        if not path.resolve().is_relative_to(output.resolve()) or path.suffix.lower() != ".png":
            raise ValueError("Sprite path escapes the workspace")
        with Image.open(path) as image:
            if image.format != "PNG" or list(image.size) != frame["size"] or image.mode not in ("RGBA", "RGB"):
                raise ValueError(f"{frame['file']}: keep the original canvas size and save as RGB/RGBA PNG")
            if pixel_hash(image) != frame["reference_hash"]:
                changed.append(frame["file"])
    return changed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("export", "check", "zip"))
    parser.add_argument("directory", type=Path)
    parser.add_argument("--monochrome", action="store_true", help="export original GB sprite shades as the editing base")
    args = parser.parse_args()
    if args.command == "export":
        manifest = export_workspace(args.directory, args.monochrome)
        print(f"Exported {len(manifest['frames'])} poses in {len(manifest['groups'])} groups to {args.directory}")
    else:
        changed = check_workspace(args.directory)
        print(f"Valid workspace: {len(changed)} modified poses")
        for name in changed:
            print(name)
        if args.command == "zip":
            path = args.directory.with_suffix(".zip")
            if path.exists():
                raise ValueError(f"Archive already exists: {path}")
            with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as archive:
                for source in sorted(args.directory.rglob("*")):
                    if source.is_file():
                        if not source.resolve().is_relative_to(args.directory.resolve()):
                            raise ValueError("Archive file escapes the workspace")
                        archive.write(source, Path(args.directory.name) / source.relative_to(args.directory))
            print(path)


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError) as error:
        raise SystemExit(str(error))
