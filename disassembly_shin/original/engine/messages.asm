DEF MESSAGE_NO_DIACRITIC EQU $ff ; Buffered upper-row tile: leave the previous tile alone.

InitMessageStream::
    ldh a, [hTileStreamWritePos]
    add a
    push af
    ld hl, MessageDescriptorTable
    rst $20
    ld a, $01
    ld [wMessageState], a
    ld a, l
    ld [wMessageDestLo], a
    ld a, h
    ld [wMessageDestHi], a
    pop af
    inc a
    ld hl, MessageDescriptorTable
    rst $20
    ld a, l
    ld [wMessageSourceLo], a
    ld a, h
    ld [wMessageSourceHi], a
    ld a, [wMessageFlags]
    and $f0
    jr nz, InitMessageStream_AlternateDiacritics

    ld a, TEXT_DAKUTEN
    ld [wMessageDakutenTile], a
    ld a, TEXT_HANDAKUTEN
    ld [wMessageHandakutenTile], a
    jr InitMessageStream_ResetLine

InitMessageStream_AlternateDiacritics::
    or $0a
    ld [wMessageDakutenTile], a
    and $f0
    or $0b
    ld [wMessageHandakutenTile], a

InitMessageStream_ResetLine::
    xor a
    ld [wMessagePrintedGlyphs], a
    ld [wMessageLineGlyphs], a
    ld a, $01
    ld [wMessageCharDelay], a
    ld a, [wMessageFlags]
    bit 1, a
    ret z

InitMessageStream_WaitUntilComplete::
    call UpdateMessageFar
    ld a, [wMessageState]
    or a
    jr nz, InitMessageStream_WaitUntilComplete

    xor a
    ldh a, [hVramQueuePos]
    ret


UpdateMessageStream::
    xor a
    ldh [hMessageResumePtrHi], a
    ld a, [wMessageState]
    or a
    ret z

    ld a, [wMessageFlags]
    ld c, a
    bit 0, c
    jr z, MessageStream_CheckEndState

    ld a, [wMessageCharDelay]
    dec a
    ld [wMessageCharDelay], a
    or a
    ret nz

    bit 3, c
    jr nz, MessageStream_ResetCharacterDelay

    ld a, $41
    call PlaySound

MessageStream_ResetCharacterDelay::
    ld a, [wMessageCharPeriod]
    ld [wMessageCharDelay], a
    ld a, [wMessagePrintedGlyphs]
    ld b, a
    ld a, [wMessageLineGlyphs]
    cp b
    jr z, MessageStream_CheckEndState

    ld de, wMessageLineBuffer
    ld a, [wMessagePrintedGlyphs]
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld hl, wMessageDestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wMessagePrintedGlyphs]
    rst $38
    ld bc, -$0040
    add hl, bc
    ld a, [de]
    push hl
    call QueueTilemapByte
    pop hl
    ld de, wStageLayoutMap
    ld a, [wMessagePrintedGlyphs]
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, [wMessagePrintedGlyphs]
    inc a
    ld [wMessagePrintedGlyphs], a
    ld a, [de]
    cp MESSAGE_NO_DIACRITIC
    ret z

    ld bc, -$0020
    add hl, bc
    call QueueTilemapByte
    ret


MessageStream_CheckEndState::
    ld a, [wMessageState]
    cp $02
    jr nz, MessageStream_PrepareNextLine

    xor a
    ld [wMessageState], a
    ret


MessageStream_PrepareNextLine::
    ld hl, wMessageDestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    bit 0, c
    jr z, MessageStream_SetSource

    ld hl, wMessageLineBuffer

MessageStream_SetSource::
    ld de, -$0020
    add hl, de
    ld a, [wMessageSourceLo]
    ld e, a
    ld a, [wMessageSourceHi]
    ld d, a
    ld b, $00

MessageStream_MeasureLine::
    call ReadMessageTileWithControlCodes
    cp TEXT_END
    jr z, MessageStream_FinishMeasurement

    cp TEXT_NEWLINE
    jr z, MessageStream_FinishMeasurement

    inc de
    cp TEXT_DAKUTEN
    jr z, MessageStream_Dakuten

    cp TEXT_HANDAKUTEN
    jr z, MessageStream_Handakuten

    bit 0, c
    jr z, MessageStream_CountBaseGlyph

    ld a, MESSAGE_NO_DIACRITIC
    ld [hl], a

MessageStream_CountBaseGlyph::
    inc b
    inc hl
    jr MessageStream_MeasureLine

MessageStream_Dakuten::
    ld a, [wMessageDakutenTile]
    jr MessageStream_EmitDiacritic

MessageStream_Handakuten::
    ld a, [wMessageHandakutenTile]

MessageStream_EmitDiacritic::
    bit 1, c
    jr z, MessageStream_CheckBlankDiacritic

    ld [hl], a
    jr MessageStream_MeasureLine

MessageStream_CheckBlankDiacritic::
    bit 2, c
    jr z, MessageStream_QueueDiacritic

    xor a

MessageStream_QueueDiacritic::
    push hl
    push bc
    call QueueTilemapByte
    pop bc
    pop hl
    jr MessageStream_MeasureLine

MessageStream_FinishMeasurement::
    xor a
    ld [wMessagePrintedGlyphs], a
    ld a, b
    ld [wMessageLineGlyphs], a
    bit 0, c
    jr nz, MessageStream_BufferedLine

    bit 1, c
    jr z, MessageStream_BeginQueueCommand

    ld hl, wMessageDestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jr MessageStream_LoadSourceCursor

MessageStream_BufferedLine::
    ld hl, wMessageLineBuffer
    jr MessageStream_LoadSourceCursor

MessageStream_BeginQueueCommand::
    call GetVramQueueTail
    ld a, [wMessageDestHi]
    ld [hl+], a
    ld a, [wMessageDestLo]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    add $03
    ld b, a
    ldh a, [hVramQueuePos]
    add b
    ldh [hVramQueuePos], a

MessageStream_LoadSourceCursor::
    ld a, [wMessageSourceLo]
    ld e, a
    ld a, [wMessageSourceHi]
    ld d, a

MessageStream_CopyBaseGlyphs::
    call ReadMessageTileWithControlCodes
    inc de
    cp TEXT_END
    jr z, MessageStream_MarkEnd

    cp TEXT_NEWLINE
    jr z, MessageStream_AdvanceLine

    cp TEXT_DAKUTEN
    jr z, MessageStream_CopyBaseGlyphs

    cp TEXT_HANDAKUTEN
    jr z, MessageStream_CopyBaseGlyphs

    bit 2, c
    jr z, MessageStream_StoreBaseGlyph

    xor a

MessageStream_StoreBaseGlyph::
    ld [hl+], a
    jr MessageStream_CopyBaseGlyphs

MessageStream_MarkEnd::
    ld a, $02
    ld [wMessageState], a

MessageStream_AdvanceLine::
    ld a, TEXT_DAKUTEN
    ld [wMessageDakutenTile], a
    ld a, TEXT_HANDAKUTEN
    ld [wMessageHandakutenTile], a
    ld a, e
    ld [wMessageSourceLo], a
    ld a, d
    ld [wMessageSourceHi], a
    ld a, [wMessageFlags]
    bit 1, a
    jr nz, MessageStream_AdvanceVramDestination

    ld [hl], $00

MessageStream_AdvanceVramDestination::
    ld hl, wMessageDestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $0040
    ld a, h
    add hl, bc
    and $fc
    ld b, a
    ld a, h
    and $fc
    cp b
    jr z, MessageStream_StoreVramDestination

    ld bc, -$0400
    add hl, bc

MessageStream_StoreVramDestination::
    ld a, l
    ld [wMessageDestLo], a
    ld a, h
    ld [wMessageDestHi], a
    ret


ReadMessageTileWithControlCodes::
    ld a, [de]
    cp TEXT_END
    jr z, ReadMessageByte_HandleTerminatorOrResume

    cp TEXT_WRITE
    call z, HandleMessageControlFC
    cp TEXT_SUB
    ret nz

    ld a, e
    ldh [hMessageResumePtrLo], a
    ld a, d
    ldh [hMessageResumePtrHi], a
    push hl
    ld a, [wMsgSubstitutionId]
    ld hl, MessageSubstitutionPointers
    rst $20
    ld d, h
    ld e, l
    ld a, [de]
    pop hl
    ret


ReadMessageByte_HandleTerminatorOrResume::
    ldh a, [hMessageResumePtrHi]
    or a
    ld a, [de]
    ret z

    ldh a, [hMessageResumePtrLo]
    ld e, a
    ldh a, [hMessageResumePtrHi]
    ld d, a
    xor a
    ldh [hMessageResumePtrHi], a
    inc de
    ld a, [de]
    ret

HandleMessageControlFC::
    push hl
    ld hl, wMessageControlPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wMessageControlValue]
    ld [hl], a
    pop hl
    inc de
    ld a, [de]
    ret
