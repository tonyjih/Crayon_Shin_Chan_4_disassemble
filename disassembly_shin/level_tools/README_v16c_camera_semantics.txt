v16c camera/player clamp reference layers

Fixes the v16/v16b camera reference layers:
- StageInitBlock bytes are now decoded using the source-code runtime meaning.
- $c414/$c415 is treated as player_x_max, not a camera bound.
- $c418/$c419 is camera scroll X max.
- $c41a/$c41b is camera scroll Y max.
- Adds separate hidden Tiled reference layers:
  * World Bounds
  * Camera Scroll Range
  * Player X Clamp
  * Camera Debug Values

All of these layers are editor/reference only. They are not imported back into ROM.
