; Standalone 20-by-18 BONUS room background.
INCLUDE "text/macros.inc"
INCLUDE "charmap.inc"

DEF BONUS_STATION_COUNT EQU 3
DEF BONUS_BANNER_STAR_TILE EQU $bf
DEF BONUS_FLOOR_TILE EQU $c6

SECTION "Bonus room tilemap", ROM0[0]
BonusTilemap:
BonusBannerRows:
    ; Rows 0-3. ゲームコーナー lettering and outlined stars from gfx/compressed/b06_5556.png.
    ; Bonus_DrawMovingBorderSprites overlays the animated stars as OBJ.
    db 0, 0
    ds 16, BONUS_BANNER_STAR_TILE
    db 0, 0
    db 0, 0, BONUS_BANNER_STAR_TILE
    db $a0, $a1, 0, 0, $a2, 0, $b4, $a5, 0, 0, $c2, $c3, 0, 0
    db BONUS_BANNER_STAR_TILE, 0, 0
    db 0, 0, BONUS_BANNER_STAR_TILE
    db $b0, $b1, $a3, $a4, $b2, $b3, $b4, $b5, $a3, $a4, $c4, $b1, $a3, $a4
    db BONUS_BANNER_STAR_TILE, 0, 0
    db 0, 0
    ds 16, BONUS_BANNER_STAR_TILE
    db 0, 0

BonusMessageBoxRows:
    ; Rows 4-8. The frame is fixed. The room writes station, exit, and result messages inside it.
    db 0, 0, $89
    ds 14, $82
    db $88, 0, 0
    REPT 3
        db 0, 0, $83
        ds 14, 0
        db $84, 0, 0
    ENDR
    db 0, 0, $87
    ds 14, $85
    db $86, 0, 0
    ds 20, 0

BonusLevelSignRows:
    ; Rows 10-12. レベル signs for Mekemeke, bug catching, and slide jump.
    ds 2, 0
    REPT BONUS_STATION_COUNT
        db $ab, $ad, $ad, $ad, $ac
    ENDR
    ds 3, 0
    ; The digits in columns 5, 10, and 15 start at １ in the map.
    ; Bonus_DrawRoundNumbers and Bonus_QueueUpdatedRoundNumber use wBonusMinigameRounds.
    ds 2, 0
    REPT BONUS_STATION_COUNT
        db $ae, $bb, $bc
        text "１"
        db $ae
    ENDR
    ds 3, 0
    ds 2, 0
    REPT BONUS_STATION_COUNT
        db $bd, $ad, $ad, $ad, $be
    ENDR
    ds 3, 0

BonusCabinetAndExitRows:
    ; Rows 13-15. Three cabinets, floor, and the arrow and EXIT sign at the right.
    ; The walking Shin-chan is drawn separately as OBJ.
    db 0
    REPT BONUS_STATION_COUNT
        db 0, 0, $a8, $a9, $aa
    ENDR
    ds 4, 0
    db 0
    REPT BONUS_STATION_COUNT
        db 0, 0, $b8, $b9, $ba
    ENDR
    db 0, $a6, $a7, 0
    REPT BONUS_STATION_COUNT
        ds 3, BONUS_FLOOR_TILE
        db $c0, $c1
    ENDR
    db BONUS_FLOOR_TILE, BONUS_FLOOR_TILE, $b6, $b7, BONUS_FLOOR_TILE

    ; Rows 16-17. The gameplay HUD window covers these blank background rows.
    ds 2 * 20, 0

    ASSERT @ - BonusTilemap == 20 * 18
