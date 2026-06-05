v15g - OAM-derived object bounds

Object icons and Tiled object boxes now use the real metasprite/OAM footprint when
a preview metasprite is known. For each supported object type, the tool parses the
metasprite signed x/y offsets and derives:

  display_offset_x = min OAM x offset
  display_offset_y = min OAM y offset
  width  = max_x - min_x
  height = max_y - min_y

These values are written into each Tiled object as display_offset_x/y and
visual_width/height, so import remains reversible. This should line up enemies
and moving platforms much closer to BGB than the previous hand-authored boxes.
