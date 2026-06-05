# v18 Camera writeback MVP

Adds source-level camera writeback from editable Tiled `Camera Scroll Range` objects.

Supported writeback targets:
- StageInitBlock_0_1_4 / StageInitBlock_2 / StageInitBlock_3
  - writes camera_x_max and camera_y_max only
  - preserves player_x_max, unknown +02, page table bytes
- Stage1CameraProfile0 / Stage1CameraProfile1 / Stage1CameraProfileAfterCheckpoint2
  - writes camera_x_min and camera_x_max only
  - preserves player clamps, player start, initial scroll

Not written by this MVP:
- Stage1CameraProfileResume, because current source still emits it as instruction-looking bytes.
- Stage2 runtime transition camera writes (code-driven c0b3==5 path), by design.
- Player X clamps, HUD boundary, camera debug markers.

Workflow:
1. Export Tiled shared maps:
   python level_tools_clean_v18_camera_writeback/shin4_level_pipeline.py export-tiled-shared-all old_game.gb tiled --stages 0-4 --write-extension

2. In Tiled, edit the hidden `Camera Scroll Range` layer object rectangle.
   The rectangle means total gameplay-visible world coverage across that camera profile.
   Formula:
     camera_x_min = object.x
     camera_x_max = object.x + object.width  - 0xa0
     camera_y_max = object.y + object.height - 0x80

3. Apply changes to source:
   python level_tools_clean_v18_camera_writeback/shin4_level_pipeline.py write-camera-source tiled bank_001.asm bank_001.camera.asm --stages 0-4

4. Review diff, then replace bank_001.asm if correct.

Warning:
StageInitBlock_0_1_4 is shared by stages 0, 1, and 4. If their Tiled files disagree, the command reports a conflict.
