QueueVramFill_SetHighBit::
    set 7, e
    jr QueueVramFill

QueueVramFill:: ; Queue a VRAM fill/single-byte command at wVramQueue.
    call GetVramQueueTail
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, e
    set 6, a
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $04
    ldh [hVramQueuePos], a
    ret


QueueTilemapByte:: ; Queue one tile byte A at tilemap address HL.
    push de
    ld d, a
    ld e, $01
    ld b, h
    ld c, l
    call QueueVramFill
    pop de
    ret


QueueBankedVramTile8000:: ; Queue one 16-byte tile to VRAM $8000 + E*16. D=bank, HL=source base, C=source tile index.
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, d
    ld [rRomBankSelect], a
    call QueueVramTile8000_FromCurrentBank
    pop af
    ld [rRomBankSelect], a
    ret


QueueBankedVramTile9000:: ; Queue one 16-byte BG tile to VRAM $9000 + E*16. D=bank, HL=source base, C=source tile index.
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, d
    ld [rRomBankSelect], a

QueueBankedVramTile9000_CopyAndRestoreBank::
    call QueueVramTile9000_FromCurrentBank
    pop af
    ld [rRomBankSelect], a
    ret


QueueVramTile9000_FromCurrentBank:: ; Internal version of QueueBankedVramTile9000 after bank has been selected.
    ld a, c
    ld b, h
    ld c, l
    ld h, $00
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, bc
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, _VRAM + $1000
    jr QueueOne16ByteVramCopy

QueueVramTile8000_FromCurrentBank:: ; Internal version of QueueBankedVramTile8000 after bank has been selected.
    ld a, c
    ld b, h
    ld c, l
    ld h, $00
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, bc
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, _VRAM

QueueOne16ByteVramCopy:: ; Shared tail: append destination + 16 data bytes to the VRAM queue.
    add hl, de
    ld d, h
    ld e, l
    call GetVramQueueTail
    ld a, d
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    pop de
    ld b, $10

QueueOne16ByteVramCopy_CopyBytes::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, QueueOne16ByteVramCopy_CopyBytes

    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $13
    ldh [hVramQueuePos], a
    ret
