LoadMaskedGfx:: ; Load custom bitmask-compressed graphics from A:HL to DE.
    push hl
    ld l, a
    ld a, [ROM_BANK_ID_ADDR]
    ld h, a
    ld a, l
    ld [rRomBankSelect], a
    ld a, h
    pop hl
    push af
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    dec de

LoadMaskedGfx_NextGroup::
    push bc
    ld b, $08
    ld c, [hl]
    inc hl
    ld a, [de]

LoadMaskedGfx_NextByte::
    sla c
    jr c, LoadMaskedGfx_StoreByte

    ld a, [hl+]

LoadMaskedGfx_StoreByte::
    inc de
    ld [de], a
    dec b
    jr nz, LoadMaskedGfx_NextByte

    pop bc
    dec bc
    ld a, c
    or b
    jr nz, LoadMaskedGfx_NextGroup

    pop af
    ld [rRomBankSelect], a
    ret
