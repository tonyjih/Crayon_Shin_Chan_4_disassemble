v16d gameplay viewport / HUD boundary fix

Changes from v16c:
- Camera Scroll Range now uses the gameplay playfield height ($80) instead of the full LCD height ($90).
- This matches the game code that sets WY=$80, meaning the bottom $10 pixels are HUD/window area.
- Added constants:
    LCD_VIEWPORT_W = $A0
    LCD_VIEWPORT_H = $90
    GAMEPLAY_VIEWPORT_H = $80
    HUD_HEIGHT = $10
- Added a hidden HUD Boundary layer to mark where gameplay camera coverage stops for each camera profile.
- Existing reference layers remain not imported to ROM.

Expected stage0 result:
- camera SCX range $0000-$0d60
- gameplay camera coverage x $0000-$0e00
- gameplay camera coverage y $0000-$0100, not $0110
