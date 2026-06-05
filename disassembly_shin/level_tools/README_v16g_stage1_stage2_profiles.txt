v16g - Stage 1/2 visual profile fixes

Changes:
- export-tiled-all now exports all Stage 1 visual profiles by default:
  stage1_normal.tmx and stage1_after_checkpoint2.tmx.
  Use --stage1-default-only to export only the default Stage 1 profile.
- Stage 2 after_switch now uses the transition-complete VRAM overlay:
  bank0:$3902 -> VRAM $9450, size $0390
  bank5:$6411 -> VRAM $8c00, size $00d0
  plus metatile_variant=2 and collision_variant=1.
- Stage 2 checkpoint still uses bank0:$3572 -> $9450.

Source-code basis:
- Stage 1 c0b4>=2 path copies bank7:$4ee1 -> $91a0 and then uses camera/start profile $449f.
- Stage 2 Call_001_43e1 checkpoint path loads bank0:$3572 -> $9450 and bank5:$6411 -> $8c00.
- Stage 2 Call_001_56c2 transition tile streaming uses bank0:$3572 when c0b3==2, otherwise bank0:$3902. The c0b3==5 after-switch profile should therefore use the $3902 graphics state.

Typical command:
python level_tools_clean_v16g_stage1_stage2_profiles/shin4_level_pipeline.py export-tiled-all old_game.gb tiled --stages 0-4
