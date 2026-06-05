v17c dynamic profile menu

- TMX metadata shin4.profiles/shin4.current_profile is already written by the shared export path.
- The Tiled extension now reads shin4.profiles from the active map and hides/disables unavailable profile actions.

Usage:
python level_tools_clean_v17c_dynamic_profile_menu/shin4_level_pipeline.py export-tiled-shared-all old_game.gb tiled --stages 0-4 --write-extension
