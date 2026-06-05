v15m fixes stage4 build-tiled-all import from icon-backed Tiled objects.

Tiled stores tile-object y at the bottom-left, while the importer previously treated it as top-left.
This could corrupt stage4 spawn import and could surface as a generic index-out-of-range error during build-tiled-all.

Changes:
- tiled_objects_to_spawns subtracts visual_height for gid tile objects before reversing display offsets.
- build-tiled-all wraps stage errors with the stage index for easier diagnosis.
