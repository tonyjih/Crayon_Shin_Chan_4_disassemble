V16b bounds layer fix
======================

V16 interpreted the first bytes of StageInitBlock as authoritative Camera Bounds.
That was misleading, especially on stage0.

Changes:
- Removed the visible/editor-facing "Camera Bounds" interpretation.
- Added hidden "World Bounds" layer: actual TMX/world_map extent only.
- Added hidden "Camera Debug" layer: raw init-block hints only, explicitly marked debug/read-only.
- Import/build behavior is unchanged: only Layout + Spawns + Stage Events are imported.

Use:
  python level_tools_clean_v16b_bounds_fix/shin4_level_pipeline.py export-tiled old_game.gb 0 tiled --profile default
