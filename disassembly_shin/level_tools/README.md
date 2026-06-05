# Shin4 level tools v13

This version keeps the v12 Tiled workflow and adds two editor-side pieces:

1. `object_profiles.json` is now editable and can be passed back into export/import.
   Use it to tune Tiled visual boxes/offsets for enemies and platforms without
   touching ROM spawn coordinates.
2. `write-rgbds-manifest` emits a source-level RGBDS `INCBIN` manifest for edited
   `layout.rleff(.new)` and `spawns.bin(.new)` files. It does not inject bytes into
   the ROM; it is meant for a reviewable disassembly/source migration.

## Export to Tiled

```bat
python level_tools_clean_v13\shin4_level_pipeline.py export-tiled game.gb 0 tiled_out_v13 --profile default
```

The stage folder contains:

```text
stage0_normal.tmx
stage0_normal.tsx
stage0_normal_tileset.png
object_profiles.json
world_map.raw
page_table.bin
spawns.bin
spawns.csv
stage_meta.txt
```

## Tune object visual boxes

Edit `tiled_out_v13\stage0\object_profiles.json`.

Example enemy entry:

```json
"0x0a": {
  "name": "OBJ_ENEMY_WALKING_KID",
  "display_offset_x": -8,
  "display_offset_y": -16,
  "width": 16,
  "height": 24
}
```

Then export again using that table:

```bat
python level_tools_clean_v13\shin4_level_pipeline.py export-tiled game.gb 0 tiled_out_v13b --profile default --object-profiles tiled_out_v13\stage0\object_profiles.json
```

Import also auto-loads `object_profiles.json` next to the TMX, or you can pass it explicitly:

```bat
python level_tools_clean_v13\shin4_level_pipeline.py import-tiled-spawns ^
  tiled_out_v13\stage0\stage0_normal.tmx ^
  assets_clean_v13\levels\stage0\spawns.bin.new ^
  --object-profiles tiled_out_v13\stage0\object_profiles.json ^
  --output-csv assets_clean_v13\levels\stage0\spawns.from_tiled.csv
```

## Import layout and spawns

```bat
python level_tools_clean_v13\shin4_level_pipeline.py import-tiled ^
  tiled_out_v13\stage0\stage0_normal.tmx ^
  assets_clean_v13\levels\stage0\world_map.raw ^
  --output-spawns-bin assets_clean_v13\levels\stage0\spawns.bin.new
```

Rebuild layout RLE:

```bat
python level_tools_clean_v13\shin4_level_pipeline.py rebuild-layout 0 ^
  assets_clean_v13\levels\stage0\world_map.raw ^
  tiled_out_v13\stage0\page_table.bin ^
  assets_clean_v13\levels\stage0\layout.raw.new ^
  assets_clean_v13\levels\stage0\layout.rleff.new
```

## Generate a source-level RGBDS manifest

After producing edited `layout.rleff.new` and/or `spawns.bin.new`, generate an include file:

```bat
python level_tools_clean_v13\shin4_level_pipeline.py write-rgbds-manifest ^
  assets_clean_v13\levels ^
  assets_clean_v13\level_assets_manifest.inc ^
  --stages 0-4 ^
  --prefer-new ^
  --output-json assets_clean_v13\level_assets_manifest.json
```

The `.inc` contains labels and `INCBIN` lines like:

```asm
Stage0LayoutRle::
    INCBIN "assets_clean_v13/levels/stage0/layout.rleff.new"

Stage0SpawnList::
    INCBIN "assets_clean_v13/levels/stage0/spawns.bin.new"
```

This is intentionally not an automatic bank patch. You still need to migrate the
bank1/bank4 pointer tables and data blocks in the disassembly source when ready.


## v15l
Stage0 party-horn kid preview now uses the paired stage3-known-good metasprite+VRAM context before local stage0 fallback.
