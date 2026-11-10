BankedMemcpy_RLEFF:: ; Banked copy with $ff count/value RLE expansion.
    push hl
    ld l, a
    ld a, [ROM_BANK_ID_ADDR]
    ld h, a
    ld a, l
    push hl
    ld [rRomBankSelect], a
    pop hl
    ld a, h
    pop hl
    push af
    call DecodeRleff_NextByte
    pop af
    ld [rRomBankSelect], a
    ret


DecodeRleff_NextByte::
    ld a, [hl+]
    cp $ff
    jr z, DecodeRleff_ReadRun

    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, DecodeRleff_NextByte

    ret


DecodeRleff_ReadRun::
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    push hl
    ld h, a
    ldh a, [hTileStreamWritePos]
    ld l, a

DecodeRleff_CopyRun::
    ld a, h
    ld [de], a
    inc de
    dec l
    jr z, DecodeRleff_RunComplete

    dec bc
    ld a, b
    or c
    jr nz, DecodeRleff_CopyRun

    pop hl
    ret


DecodeRleff_RunComplete::
    pop hl
    dec bc
    ld a, b
    or c
    jr nz, DecodeRleff_NextByte

    ret
