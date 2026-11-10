ProcessVramQueue_NextCommand::
    inc de
    ld h, a
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    inc de
    ld c, a
    and $3f
    ld b, a
    ld a, c
    rlca
    rlca
    and $03
    jr z, ProcessVramQueue_CopyRow

    dec a
    jr z, ProcessVramQueue_ReadFillByte

    dec a
    jr z, ProcessVramQueue_CopyColumn

ProcessVramQueue_FillColumn::
    ld a, [de]
    ld [hl], a
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, ProcessVramQueue_FillColumn

    inc de
    jr ProcessVramQueue_CheckNextCommand

ProcessVramQueue_CopyRow::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, ProcessVramQueue_CopyRow

ProcessVramQueue_CheckNextCommand::
    ld a, [de]
    or a
    jr nz, ProcessVramQueue_NextCommand

    ret


ProcessVramQueue_ReadFillByte::
    ld a, [de]
    inc de

ProcessVramQueue_FillRow::
    ld [hl+], a
    dec b
    jr nz, ProcessVramQueue_FillRow

    jr ProcessVramQueue_CheckNextCommand

ProcessVramQueue_CopyColumn::
    ld a, [de]
    ld [hl], a
    inc de
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, ProcessVramQueue_CopyColumn

    jr ProcessVramQueue_CheckNextCommand
