BuildMenuPatternBackground::
; Fill a 20x18 tilemap using three repeating row patterns.
    ld c, $00
    ld de, _SCRN0

MenuBackground_NextThreeRowGroup::
    ld b, $03

MenuBackground_SelectRowPattern::
    ld hl, MenuBackgroundPatternPtrs
    ld a, b
    dec a
    push de
    rst $20
    pop de
    ld a, c
    rst $38
    push bc
    ld c, $14

MenuBackground_ReadPatternTile::
    push bc
    ld a, [hl+]
    cp $ff
    jr nz, MenuBackground_ApplyTileBase

    ld bc, -$0007
    add hl, bc
    ld a, [hl+]

MenuBackground_ApplyTileBase::
    or a
    jr z, MenuBackground_StoreTile

    ld b, a
    ldh a, [hTileStreamWritePos]
    add b

MenuBackground_StoreTile::
    ld [de], a
    pop bc
    inc de
    dec c
    jr nz, MenuBackground_ReadPatternTile

    ld a, e
    and $e0
    add $20
    ld e, a
    ld a, d
    adc $00
    ld d, a
    pop bc
    dec b
    jr nz, MenuBackground_SelectRowPattern

    inc c
    ld a, c
    cp $06
    jr c, MenuBackground_NextThreeRowGroup

    ret
