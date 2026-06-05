# v16e export-all + clean reference layers

Changes:

- Added `export-tiled-all`.
- Stage 2 exports all visual profiles by default.
- Stopped exporting `HUD Boundary` and `Player X Clamp` layers because they are derived/debug-only and were easy to mistake for editable data.
- Kept `World Bounds`, `Camera Scroll Range`, and `Camera Debug Values` hidden reference layers.

Examples:

```bat
python level_tools_clean_v16e_export_all_clean_refs\shin4_level_pipeline.py export-tiled-all old_game.gb tiled --stages 0-4
```

Use `--stage2-default-only` if you only want `stage2_initial.tmx`.
