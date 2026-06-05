# v15o lossless RLEFF no-op preservation

RLEFF has multiple valid encodings for the same decoded layout. v15o keeps the original ROM/exported `layout.rleff` bytes when the Tiled-imported layout decodes to the same raw layout. If the layout was edited, it falls back to the normal encoder.

Use `--rom game.gb` for the most reliable preservation source:

```bat
python level_tools_clean_v15o\shin4_level_pipeline.py build-tiled-all tiled assets\levels --stages 0-4 --rom game.gb
```

`export-tiled` now also writes `tiled/stageX/layout.rleff` as an exact original copy.
