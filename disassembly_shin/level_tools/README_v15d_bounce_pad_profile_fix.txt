v15d bounce pad object profile fix

Changes from v15c:
- OBJ_PLATFORM_BOUNCE_PAD ($1d) visual box now matches its metasprite bbox better.
  old: offset=(-16,-8), size=32x16
  new: offset=(-8,-16), size=16x16
- Import remains reversible: ROM spawn = Tiled visual x/y - display_offset.

Re-export TMX files after updating. If an old object_profiles.json exists next to the TMX, replace/regenerate it or pass a new --object-profiles file, because local JSON overrides built-in defaults.
