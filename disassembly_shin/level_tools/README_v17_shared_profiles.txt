Shin4 level tools v17 - shared-layout Tiled profiles

New workflow:
  export-tiled-shared-all old_game.gb tiled --stages 0-4 --write-extension

This exports one main TMX per stage:
  tiled/stage0/stage0.tmx
  tiled/stage1/stage1.tmx
  tiled/stage2/stage2.tmx
  tiled/stage3/stage3.tmx
  tiled/stage4/stage4.tmx

Visual profiles are stored as swappable TSX files:
  tiled/stage2/profiles/stage2_initial.tsx
  tiled/stage2/profiles/stage2_checkpoint.tsx
  tiled/stage2/profiles/stage2_after_switch.tsx

The Layout layer remains a 1-byte metatile-id map:
  gid = metatile_id + 1

Switch profile from CLI:
  python level_tools_clean_v17_shared_profiles/shin4_level_pipeline.py switch-tiled-profile tiled/stage2/stage2.tmx after_switch

Build uses shared TMX automatically when it exists:
  python level_tools_clean_v17_shared_profiles/shin4_level_pipeline.py build-tiled-all tiled assets/levels --stages 0-4

Optional Tiled JavaScript helper:
  export with --write-extension, then install/copy tiled/extensions/shin4_profile_switcher.js into Tiled's extension path.
  It adds Map menu actions to switch common Shin4 profiles.

Notes:
  - This does not change ROM format.
  - Profile switching only replaces the firstgid=1 metatile TSX.
  - Spawns and Stage Events remain in the single canonical TMX.
  - Object icons are generated from the default profile for now.
