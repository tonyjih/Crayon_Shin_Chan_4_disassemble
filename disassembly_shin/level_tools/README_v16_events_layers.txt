v16 events/camera layer cleanup

Changes from v15t:
- Export splits normal spawn actors and stage/event actors into separate Tiled object layers.
  - Spawns: ordinary editable enemies/items/platforms.
  - Stage Events: special controller/event-like spawn types currently identified as $06, $07, $08, $1f, $20, $23.
- Import combines both Spawns and Stage Events back into one ROM spawn list, sorted by index, so the ROM format is unchanged.
- Adds a hidden Camera Bounds layer with read-only reference rectangles based on the currently identified stage init camera profiles.
- Keeps clean object properties from v15s/v15t: index/type/flags/param/active only.

Notes:
- Camera Bounds is editor reference only and is not imported back to ROM yet.
- Stage Events are still ROM spawn records; the layer split is editor-only to reduce confusion.
- If you pass --object-layer-name with a custom layer, only that layer is imported. The default "Spawns" imports both Spawns and Stage Events.
