; Standalone 20-by-18 Continue / Game Over tilemap.
INCLUDE "text/macros.inc"
INCLUDE "charmap.inc"

SECTION "Continue tilemap", ROM0[0]
ContinueTilemap:
    ds 20, 0

ContinueLogoRows:
    ; Rows 1-2. GAME OVER logo from gfx/compressed/b06_663c.png (tiles $80-$9c).
    db 0, 0, $80, $81, $82, $83, $84, $85, $86, $87, $80, $89, $8a, $8b, $86, $87, $8c, $8d, 0, 0
    db 0, 0, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $96, $97, $9c, $88, 0, 0

    ; Rows 3-15. The scene draws its actors and adds messages $69/$6a when continues remain.
    ds 13 * 20, 0

ContinueRemainingCountRows:
    ; Rows 16-17. あと [count]かいだよ, with the dakuten for だ one row above its base tile.
    PUSHC shin_text
    ds 18, 0
    db CHARVAL("だ", 0), 0
    ds 12, 0
    db "あと "
ContinueRemainingCountDigit:
    ; Message_19_RemainingAttempts rewrites the line using wContinuesRemaining.
    db 0
    db "かい", CHARVAL("だ", -1), "よ"
    POPC

    ASSERT @ - ContinueTilemap == 20 * 18
