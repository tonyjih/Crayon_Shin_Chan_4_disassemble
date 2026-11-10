CopyTilemapRectToVram::
    call CopyTilemapRowToVram
    dec c
    jr nz, CopyTilemapRectToVram

    ret


CopyTilemapRowToVram::
    push bc
    push hl

CopyTilemapRowToVram_Loop::
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, CopyTilemapRowToVram_Loop

    pop hl
    ld bc, $0020
    add hl, bc
    pop bc
    ret


QueueSequential4x4Tilemap::
; Unused entry: build sixteen sequential tile IDs starting at A, then queue a 4x4 rectangle at HL.
    push hl
    ld b, $10
    ld hl, wSequentialTilemapBuffer

QueueSequential4x4Tilemap_NextTile::
    ld [hl+], a
    inc a
    dec b
    jr nz, QueueSequential4x4Tilemap_NextTile

    pop hl
    ld de, wSequentialTilemapBuffer
    ld bc, $0404

QueueTilemapRect:: ; Queue a rectangular tilemap upload. HL=dest, DE=src, B=width, C=height.
    ld a, l
    ldh [hVramRectDestLo], a
    ld a, h
    ldh [hVramRectDestHi], a
    call GetVramQueueTail

QueueTilemapRect_NextRow::
    ldh a, [hVramRectDestHi]
    ld [hl+], a
    ldh a, [hVramRectDestLo]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    push bc

QueueTilemapRect_CopyRow::
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, QueueTilemapRect_CopyRow

    pop bc
    ldh a, [hVramQueuePos]
    add b
    add $03
    ldh [hVramQueuePos], a
    ldh a, [hVramRectDestLo]
    add $20
    ldh [hVramRectDestLo], a
    ldh a, [hVramRectDestHi]
    adc $00
    ldh [hVramRectDestHi], a
    dec c
    jr nz, QueueTilemapRect_NextRow

    ld [hl], $00
    ret


CopyBankedTilemapRectToVram::
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ldh a, [hTileStreamWritePos]
    ld [rRomBankSelect], a
    call CopyTilemapRectToVram
    pop af
    ld [rRomBankSelect], a
    ret


    ld a, [ROM_BANK_ID_ADDR]
    push af
    ldh a, [hTileStreamWritePos]
    ld [rRomBankSelect], a
    call QueueTilemapRect
    pop af
    ld [rRomBankSelect], a
    ret


CopyTextLineToVram::
    ld a, [de]
    inc de
    cp TEXT_END
    ret z

    cp TEXT_DAKUTEN
    jr z, CopyTextLineToVram_Diacritic

    cp TEXT_HANDAKUTEN
    jr z, CopyTextLineToVram_Diacritic

    ld [hl+], a
    jr CopyTextLineToVram

CopyTextLineToVram_Diacritic::
    ld bc, -$0020
    add hl, bc
    ld [hl], a
    ld bc, $0020
    add hl, bc
    jr CopyTextLineToVram

QueueTextLine:: ; DE is FF-terminated text; dakuten/handakuten are queued one tile row above the base glyphs.
    push hl
    push de
    call QueueTextDiacriticsAndMeasure
    pop de
    pop hl
    push hl
    call GetVramQueueTail
    ld a, b
    pop bc
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    ld [hl+], a
    add $03
    ld b, a

QueueTextLine_NextBaseGlyph::
    ld a, [de]
    cp TEXT_END
    jr z, QueueTextLine_Finish

    inc de
    cp TEXT_DAKUTEN
    jr z, QueueTextLine_NextBaseGlyph

    cp TEXT_HANDAKUTEN
    jr z, QueueTextLine_NextBaseGlyph

    ld [hl+], a
    jr QueueTextLine_NextBaseGlyph

QueueTextLine_Finish::
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add b
    ldh [hVramQueuePos], a
    ret


QueueTextDiacriticsAndMeasure::
    ld bc, -$0020
    add hl, bc
    ld b, $00

QueueTextDiacriticsAndMeasure_Next::
    ld a, [de]
    cp TEXT_END
    ret z

    inc de
    cp TEXT_DAKUTEN
    jr z, QueueTextDiacriticsAndMeasure_Emit

    cp TEXT_HANDAKUTEN
    jr z, QueueTextDiacriticsAndMeasure_Emit

    inc b
    inc hl
    jr QueueTextDiacriticsAndMeasure_Next

QueueTextDiacriticsAndMeasure_Emit::
    push hl
    push bc
    call QueueTilemapByte
    pop bc
    pop hl
    jr QueueTextDiacriticsAndMeasure_Next

    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, b
    ld [rRomBankSelect], a
    ld c, [hl]
    pop af
    ld [rRomBankSelect], a
    ret
