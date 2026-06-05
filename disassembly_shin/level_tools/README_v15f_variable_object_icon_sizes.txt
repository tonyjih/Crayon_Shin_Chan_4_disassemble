v15f: variable-size Tiled object icon fix

- Object icons now use a Tiled image-collection tileset instead of a uniform 16x16 sheet.
- Enemy icons can be native 16x24, pickups/forms 16x16, and platforms 32x16.
- This avoids Tiled stretching a 16x16 enemy preview into a 16x24 object box.
- Added built-in profiles for enemy types $0a-$0f.
- Added preview support for moving platform types $1a/$1b/$22.

If old object_profiles.json files exist next to TMX files, delete them or regenerate them so the new built-in sizes are used.
