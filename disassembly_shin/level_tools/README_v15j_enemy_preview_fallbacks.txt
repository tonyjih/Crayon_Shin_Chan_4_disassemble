v15j enemy preview fallbacks

Fixes editor-only object icon previews:
- Umbrella kid preview now uses its idle animation sequence ($0c/$0d/$0e) before the hit/bounce frame $0f.
- Party-horn kid tries active horn frames before fallback walking frames, and uses stage3 as a known-good preview graphics context when other stage previews are wrong or blank.
- Object icon rendering now tries current-stage VRAM first, then fallback stage VRAM contexts, so stage1 enemy previews no longer disappear just because the local reconstructed OBJ tiles do not contain that preview frame.

These changes only affect Tiled icon generation. Import/export of raw spawn coordinates and object type data is unchanged.
