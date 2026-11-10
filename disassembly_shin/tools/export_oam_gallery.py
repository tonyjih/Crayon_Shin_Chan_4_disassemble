#!/usr/bin/env python3
"""Build a browsable OAM gallery from the original grayscale pose pack."""

import argparse
from base64 import b64encode
from collections import defaultdict
import csv
from hashlib import sha256
import json
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original"
GFX = ORIGINAL / "gfx"


def read_csv(name):
    with (GFX / name).open(encoding="utf-8", newline="") as file:
        return list(csv.DictReader(file))


def png_data(path):
    return "data:image/png;base64," + b64encode(path.read_bytes()).decode("ascii")


def tile_lookup(assets):
    result = {}
    for row in read_csv("sprite_tile_sources.csv"):
        sheet = row["reference_sheet"]
        first = int(row["first_tile"], 16)
        count = int(row["tile_count"])
        source = row["source_png"]
        start = int(row["first_source_tile"], 16) if source else 0
        if count <= 0 or (source and start + count > assets[source]["tiles"]):
            raise ValueError(f"Invalid tile range: {row}")
        for i in range(count):
            key = (sheet, first + i)
            if key in result:
                raise ValueError(f"Overlapping tile ranges: {key}")
            result[key] = (source, start + i if source else None)
    return result


def gallery_data(pack):
    original = json.loads((ORIGINAL / "assets.json").read_text(encoding="utf-8"))
    manifest = json.loads((pack / "manifest.json").read_text(encoding="utf-8"))
    if (manifest.get("format"), manifest.get("color_mode"), manifest.get("rom_md5", "").upper()) != (
        1, "dmg", original["rom_md5"]
    ):
        raise ValueError("Expected a grayscale pose pack for the matching original ROM")

    assets = {}
    for asset in original["assets"]:
        source = asset["source"]
        if not source.startswith("gfx/") or not source.endswith(".png"):
            continue
        path = ORIGINAL / source
        with Image.open(path) as image:
            width, height = image.size
        assets[source] = {
            "image": png_data(path), "width": width, "height": height, "url": path.as_uri(),
            "tiles": asset["decoded_size"] // (8 * asset["bpp"]),
            "address": f"{asset['bank']:02x}:{asset['address']:04x}", "codec": asset["codec"],
        }
    tiles = tile_lookup(assets)

    actions = defaultdict(list)
    for action in read_csv("sprite_actions.csv"):
        frames = {int(token.split("@")[0], 16) for token in action["frames"].split()}
        for group in filter(None, action["groups"].split("|")):
            for frame in frames:
                actions[group, frame].append({"name": action["action"], "symbol": action["rom_symbol"]})

    index = {row["pose_png"]: row for row in read_csv("sprite_poses.csv")}
    counts = defaultdict(int)
    poses = []
    for frame in manifest["frames"]:
        row = index.pop(frame["file"])
        if (frame["group"], frame["frame"], frame["bank"]) != (
            row["group"], int(row["frame"], 16), row["export_table"]
        ):
            raise ValueError(f"Frame index mismatch: {frame['file']}")
        path = pack / "reference" / Path(frame["file"]).relative_to("editable")
        with Image.open(path) as image:
            rgba = image.convert("RGBA")
            if list(image.size) != frame["size"] or sha256(rgba.tobytes()).hexdigest() != frame["reference_hash"]:
                raise ValueError(f"Original reference pixels changed: {path}")
            left, top, right, bottom = rgba.getchannel("A").getbbox() or (0, 0, *image.size)

        parts = []
        for part in frame["parts"]:
            source, tile = tiles[part["sheet"], part["source_tile"]]
            parts.append({**part, "source": source, "png_tile": tile})
        used = {part["source"] or "zero" for part in parts}
        if used != set(filter(None, row["original_tile_sources"].split("|"))):
            raise ValueError(f"Tile sources disagree with the pose index: {frame['file']}")
        for source in used - {"zero"}:
            counts[source] += 1
        poses.append({
            "group": frame["group"], "frame": row["frame"], "subject": row["subject"],
            "image": png_data(path), "size": frame["size"], "anchor": frame["anchor"],
            "crop": [left, top, right - left, bottom - top], "parts": parts,
            "table": row["rom_pointer_table"], "record": row["record_kind"],
            "symbol": row["metasprite"], "address": row["rom_address"],
            "actions": actions[frame["group"], frame["frame"]],
        })
    if index:
        raise ValueError(f"Pose pack is missing {len(index)} indexed frames")
    for source, asset in assets.items():
        asset["pose_count"] = counts[source]
    groups = [{"id": group["id"], "label": group["label"], "count": group["count"]}
              for group in manifest["groups"]]
    return {"groups": groups, "poses": poses, "assets": assets, "md5": original["rom_md5"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pack", nargs="?", type=Path, default=ROOT / "Shin4-Sprites-GB-Original")
    parser.add_argument("--out", type=Path, default=ROOT / "build/oam-gallery/index.html")
    args = parser.parse_args()
    data = gallery_data(args.pack.resolve())
    payload = json.dumps(data, ensure_ascii=False, separators=(",", ":")).replace("<", "\\u003c")
    template = Path(__file__).with_name("oam_gallery.html").read_text(encoding="utf-8")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(template.replace("<!-- GALLERY_DATA -->", payload), encoding="utf-8")
    print(f"{len(data['poses'])} poses, {len(data['groups'])} groups, {len(data['assets'])} source PNGs")
    print(args.out.resolve())


if __name__ == "__main__":
    main()
