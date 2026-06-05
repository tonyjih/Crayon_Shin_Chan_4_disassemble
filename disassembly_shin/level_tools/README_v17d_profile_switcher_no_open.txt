v17d - profile switcher no longer opens TSX tabs

Fixes the Tiled extension switchProfile path:
- Uses tiled.tilesetFormatForFile(path).read(path) instead of tiled.open(path), so switching profiles does not open the TSX in the editor.
- Wraps map.replaceTileset in a macro and reports replace failure cleanly.
- Keeps the shared-layout single-TMX design from v17c.
