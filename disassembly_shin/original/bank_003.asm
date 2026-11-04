; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $003", ROMX[ROM_BANK_ID_ADDR], BANK[$3]

; Text encoding notes (partial, verified from password screen and bank 3 messages):
;   $fe = line break / message row separator, $ff = terminator, $fd = dynamic value.
;   $fc = message control code handled by HandleMessageControlFC.
;   $43 + kana = handakuten, $45 + kana = dakuten.
;   $44 = Japanese fullwidth dot-like punctuation, $7d = ！, $7e = ー, $7f = ？.
;   $06/$07/$08 = fullwidth ２/３/４ in message text.
;   $0f = D-pad icon, $40 = A-button icon, $7b = B-button icon in tutorial text.


RomBankId_Bank3::
    db $03
Bank3FarCallTable::
    dw InitMessageStream ; $00
    dw UpdateMessageStream ; $02

Bank3MetaspriteTableReference::
; Word containing the bank-3 metasprite pointer-table address, not a callable handler.
    dw Bank3MetaspritePtrTable ; $04
    dw DrawBank3MetaspriteById ; $06
    dw ApplySgbScreenPaletteProfile ; $08
    dw InitSgbBorder ; $0a
    dw UpdateSgbBorderColorMode ; $0c


rle_b03_400f_to_8900::
GfxRle_b03_400f::
; Source: gfx/compressed/b03_400f.png (prevbyte, 368 decoded bytes).
    INCBIN "../build/original/assets/b03_400f.bin"

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

    ld a, $45
    ld [wMessageDakutenTile], a
    ld a, $43
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
    cp $ff
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
    cp $ff
    jr z, MessageStream_FinishMeasurement

    cp $fe
    jr z, MessageStream_FinishMeasurement

    inc de
    cp $45
    jr z, MessageStream_Dakuten

    cp $43
    jr z, MessageStream_Handakuten

    bit 0, c
    jr z, MessageStream_CountBaseGlyph

    ld a, $ff
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
    cp $ff
    jr z, MessageStream_MarkEnd

    cp $fe
    jr z, MessageStream_AdvanceLine

    cp $45
    jr z, MessageStream_CopyBaseGlyphs

    cp $43
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
    ld a, $45
    ld [wMessageDakutenTile], a
    ld a, $43
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
    cp $ff
    jr z, ReadMessageByte_HandleTerminatorOrResume

    cp $fc
    call z, HandleMessageControlFC
    cp $fd
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

DrawBank3MetaspriteById::
    ld a, d
    ld hl, Bank3MetaspritePtrTable
    rst $20
    call DrawMetasprite
    ret


ApplySgbScreenPaletteProfile::
    ld a, [wSgbEnabled]
    or a
    ret z

    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld de, wSgbPalSetPacket
    ld a, $51
    ld [de], a
    inc de
    ld a, [wScreenPaletteId]
    add a
    ld b, a
    add a
    add b
    ld hl, SgbScreenPaletteTable_4d5f
    rst $38
    ld b, $04

SgbPalette_CopyPaletteIds::
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    dec b
    jr nz, SgbPalette_CopyPaletteIds

    ld a, [hl+]
    ld b, a
    or a
    jr z, SgbPalette_BuildControlByte

    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a

SgbPalette_BuildControlByte::
    ld a, b
    set 7, a
    ld [de], a
    inc de
    ld b, $06
    xor a

SgbPalette_ClearPacketTail::
    ld [de], a
    inc de
    dec b
    jr nz, SgbPalette_ClearPacketTail

    call DelayFramesOrCycles
    ld hl, wSgbPalSetPacket
    call SendSgbPacket
    call DelayFramesOrCycles
    ld a, [wScreenPaletteId]
    cp $18
    jr z, SgbPalette_BlankTransition

    cp $14
    ret nz

SgbPalette_BlankTransition::
    xor a
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ret


UpdateSgbBorderColorMode::
    ld b, $00
    ld a, [wAlternateModeFlags]
    or a
    jr z, SgbBorder_CheckSpecialMode

    ld b, $01

SgbBorder_CheckSpecialMode::
    ld a, [wSpecialModeFlags]
    or a
    jr z, SgbBorder_CheckModeChanged

    ld b, $02

SgbBorder_CheckModeChanged::
    ld a, [wSgbBorderColorMode]
    cp b
    ret z

    ld a, b
    ld [wSgbBorderColorMode], a

RebuildSgbBorderTilemap::
; Buffer is a 32x32 little-endian SNES tilemap; the GB viewport occupies columns 6-25, rows 5-22.
    ld de, wStageLayoutMap
    ld b, $03
    ld c, $01

SgbBorder_SelectRowPattern::
    ld hl, SgbBorderRowPatternPointers
    ld a, [wSgbBorderColorMode]
    swap a
    and $f0
    rst $38
    ld a, c
    dec a
    push de
    rst $20
    ld a, b
    rst $38
    pop de

SgbBorder_CopyRowPattern::
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, $10
    ld [de], a
    inc de
    ld a, [hl]
    cp $ff
    jr nz, SgbBorder_CheckRowComplete

    push de
    ld de, -$0007
    ld a, [wSgbBorderColorMode]
    cp $02
    jr nz, SgbBorder_RewindPattern

    ld de, -$0008

SgbBorder_RewindPattern::
    add hl, de
    pop de

SgbBorder_CheckRowComplete::
    ld a, e
    and $3f
    jr nz, SgbBorder_CopyRowPattern

    dec c
    jr nz, SgbBorder_CheckMapComplete

    ld c, $07
    push de
    ld d, $07
    ld a, [wSgbBorderColorMode]
    cp $02
    ld a, b
    jr nz, SgbBorder_AdvancePatternPhase

    ld d, $08
    add $02

SgbBorder_AdvancePatternPhase::
    add $04
    ld b, a
    cp d
    jr c, SgbBorder_RestoreDestination

    sub d
    ld b, a

SgbBorder_RestoreDestination::
    pop de

SgbBorder_CheckMapComplete::
    ld a, d
    cp $d0
    jr nz, SgbBorder_SelectRowPattern

    ld hl, wSgbBorderPaletteBuffer
    ld bc, $0080
    call bzero
    ld a, [wSgbBorderColorMode]
    add a
    add a
    ld hl, SgbBorderPaletteAssignments
    rst $38
    ld de, wSgbBorderPaletteBuffer + 4
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    ld hl, wSgbBorderTilemapBuffer + $14c
    ld b, $12
    ld de, $0018
    xor a

SgbBorder_ClearViewportNextRow::
    ld c, $14

SgbBorder_ClearViewportNextTile::
    ld [hl+], a
    inc hl
    dec c
    jr nz, SgbBorder_ClearViewportNextTile

    add hl, de
    dec b
    jr nz, SgbBorder_ClearViewportNextRow

    ld de, wSgbBorderTilemapBuffer + $10c
    ld hl, wSgbBorderTilemapBuffer + $5cc
    ld b, $14

SgbBorder_DrawHorizontalViewportEdges::
    ld a, $1d
    ld [hl+], a
    ld [de], a
    inc hl
    inc de
    inc de
    dec b
    jr nz, SgbBorder_DrawHorizontalViewportEdges

    ld hl, wSgbBorderTilemapBuffer + $14a
    ld a, $1c
    ld b, $12
    ld d, $00

SgbBorder_DrawVerticalViewportEdges::
    ld [hl], a
    ld e, $2a
    add hl, de
    ld [hl], a
    ld e, $16
    add hl, de
    dec b
    jr nz, SgbBorder_DrawVerticalViewportEdges

    ld a, $1e
    ld [wSgbBorderTilemapBuffer + $10a], a
    ld a, $1e
    ld [wSgbBorderTilemapBuffer + $134], a
    ld a, $50
    ld [wSgbBorderTilemapBuffer + $135], a
    ld a, $1e
    ld [wSgbBorderTilemapBuffer + $5ca], a
    ld a, $90
    ld [wSgbBorderTilemapBuffer + $5cb], a
    ld a, $1e
    ld [wSgbBorderTilemapBuffer + $5f4], a
    ld a, $d0
    ld [wSgbBorderTilemapBuffer + $5f5], a
    ld de, SgbPacket_PctTrn
    ld hl, wStageLayoutMap
    ld bc, $0880
    call TransferSgbDataFromBuffer
    ret



SgbBorderRowPatternPointers::
    dw SgbBorderRowPattern_456a
    dw SgbBorderRowPattern_4562
    dw SgbBorderRowPattern_455a
    dw SgbBorderRowPattern_4552
    dw SgbBorderRowPattern_454a
    dw SgbBorderRowPattern_4542
    dw SgbBorderRowPattern_453a
    dw 0
    dw SgbBorderRowPattern_45a2
    dw SgbBorderRowPattern_459a
    dw SgbBorderRowPattern_4592
    dw SgbBorderRowPattern_458a
    dw SgbBorderRowPattern_4582
    dw SgbBorderRowPattern_457a
    dw SgbBorderRowPattern_4572
    dw 0
    dw SgbBorderRowPattern_45e0
    dw SgbBorderRowPattern_45d7
    dw SgbBorderRowPattern_45ce
    dw SgbBorderRowPattern_45c5
    dw SgbBorderRowPattern_45bc
    dw SgbBorderRowPattern_45b3
    dw SgbBorderRowPattern_45aa
    dw 0

SgbBorderRowPattern_453a::
    db $01, $01, $02, $01, $01, $01, $01, $ff

SgbBorderRowPattern_4542::
    db $01, $03, $04, $05, $06, $01, $01, $ff

SgbBorderRowPattern_454a::
    db $01, $07, $08, $09, $0a, $01, $01, $ff

SgbBorderRowPattern_4552::
    db $0b, $0c, $0d, $0e, $0f, $10, $01, $ff

SgbBorderRowPattern_455a::
    db $11, $12, $13, $14, $15, $16, $01, $ff

SgbBorderRowPattern_4562::
    db $17, $18, $19, $1a, $1b, $01, $01, $ff

SgbBorderRowPattern_456a::
    db $01, $01, $01, $01, $01, $01, $01, $ff

SgbBorderRowPattern_4572::
    db $1f, $20, $21, $22, $01, $01, $01, $ff

SgbBorderRowPattern_457a::
    db $24, $25, $26, $27, $01, $01, $23, $ff

SgbBorderRowPattern_4582::
    db $29, $2a, $2b, $2c, $2d, $01, $28, $ff

SgbBorderRowPattern_458a::
    db $2e, $2f, $30, $31, $01, $01, $01, $ff

SgbBorderRowPattern_4592::
    db $32, $33, $34, $35, $01, $01, $01, $ff

SgbBorderRowPattern_459a::
    db $36, $37, $38, $39, $01, $01, $01, $ff

SgbBorderRowPattern_45a2::
    db $01, $01, $01, $01, $01, $01, $01, $ff

SgbBorderRowPattern_45aa::
    db $01, $4b, $4c, $4d, $4e, $4f, $50, $51, $ff

SgbBorderRowPattern_45b3::
    db $01, $52, $53, $54, $55, $01, $01, $01, $ff

SgbBorderRowPattern_45bc::
    db $01, $56, $57, $58, $01, $01, $01, $01, $ff

SgbBorderRowPattern_45c5::
    db $01, $01, $01, $01, $01, $01, $01, $3a, $ff

SgbBorderRowPattern_45ce::
    db $3c, $3d, $3e, $01, $01, $01, $01, $3b, $ff

SgbBorderRowPattern_45d7::
    db $40, $41, $42, $01, $01, $01, $01, $3f, $ff

SgbBorderRowPattern_45e0::
    db $48, $49, $4a, $43, $44, $45, $46, $47, $ff

SgbBorderPaletteAssignments::
    db $0e, $7b, $df, $7f, $7f, $36, $df, $7f, $75, $4f, $df, $7f

SgbPacket_PctTrn::
    db $a1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
InitSgbBorder::
    di
    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld hl, SgbPacket_MaskFreeze
    call SendSgbPacket
    call DelayFramesOrCycles
    ld hl, SgbInitialColorPatterns
    ld b, $08

InitSgbBorder_SendInitialColorPacket::
    push hl
    push bc
    call SendSgbPacket
    call DelayFramesOrCycles
    pop bc
    pop hl
    ld de, $0010
    add hl, de
    dec b
    jr nz, InitSgbBorder_SendInitialColorPacket

    ld hl, wStageLayoutMap
    ld de, Bank0TrailingGraphicsData_3ca2
    ld b, $59

InitSgbBorder_Next1bppTile::
    ld c, $08

InitSgbBorder_ExpandTileRows::
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, $ff
    ld [hl+], a
    dec c
    jr nz, InitSgbBorder_ExpandTileRows

    xor a
    ld c, $08

InitSgbBorder_ClearUpperPlanes::
    ld [hl+], a
    ld [hl+], a
    dec c
    jr nz, InitSgbBorder_ClearUpperPlanes

    dec b
    jr nz, InitSgbBorder_Next1bppTile

    ld hl, wStageLayoutMap
    ld bc, $0020
    call bzero
    ld de, SgbPacket_ChrTrn
    ld hl, wStageLayoutMap
    ld bc, $0b20
    call TransferSgbDataFromBuffer
    call RebuildSgbBorderTilemap
    ld hl, SgbPaletteTransferSource
    ld de, wStageLayoutMap
    ld bc, $0400
    call memcpy
    ld de, SgbPacket_PalTrn
    ld hl, wStageLayoutMap
    ld bc, $1000
    call TransferSgbDataFromBuffer
    ld a, BANK(SgbBorderTilemapRle)
    ld hl, SgbBorderTilemapRle
    ld de, wStageLayoutMap
    call LoadMaskedGfx
    ld de, SgbPacket_AttrTrn
    ld hl, wStageLayoutMap
    ld bc, $05fa
    call TransferSgbDataFromBuffer
    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld a, $81
    ldh [rLCDC], a
    ld hl, SgbPacket_MaskCancel
    call SendSgbPacket
    call DelayFramesOrCycles
    ret


    ld a, $1f
    ldh [hSgbColorScale], a

BuildScaledSgbPaletteSequence_NextScale::
    push hl
    ld b, $10

BuildScaledSgbPaletteSequence_NextColor::
    push bc
    call ScaleSgbBgr555Color
    ld a, c
    ld [de], a
    inc de
    ld a, b
    ld [de], a
    inc de
    pop bc
    dec b
    jr nz, BuildScaledSgbPaletteSequence_NextColor

    pop hl
    ldh a, [hSgbColorScale]
    sub $02
    ldh [hSgbColorScale], a
    jr nc, BuildScaledSgbPaletteSequence_NextScale

    ret


ScaleSgbBgr555Color:: ; Scales each 5-bit BGR555 component; preserves the packed color layout in BC.
    push de
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    push hl
    ld h, $03
    ld bc, $0000

SgbColor_NextComponent::
    ld a, e
    and $1f
    push bc
    call ScaleSgbColorComponent
    pop bc
    or c
    ld c, a
    ld l, $05

SgbColor_ShiftComponent::
    srl d
    rr e
    srl c
    rr b
    jr nc, SgbColor_ContinueComponentShift

    set 7, c

SgbColor_ContinueComponentShift::
    dec l
    jr nz, SgbColor_ShiftComponent

    dec h
    jr nz, SgbColor_NextComponent

    srl c
    rr b
    jr nc, SgbColor_Return

    set 7, c

SgbColor_Return::
    pop hl
    pop de
    ret


ScaleSgbColorComponent:: ; Returns 31 - floor((31 - A) * hSgbColorScale / 31); scale descends from 31 to 1.
    push hl
    xor $1f
    ld c, a
    ldh a, [hSgbColorScale]
    call MultiplyBCByA8bit
    ld c, $ff

SgbColor_DivideBy31::
    inc c
    ld a, l
    sub $1f
    ld l, a
    ld a, h
    sbc $00
    ld h, a
    jr nc, SgbColor_DivideBy31

    ld a, c
    xor $1f
    pop hl
    ret



SgbPacket_ChrTrn::
    db $99, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_PalTrn::
    db $59, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_AttrTrn::
    db $a9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_MaskFreeze::
    db $b9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_MaskCancel::
    db $b9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SgbInitialColorPatterns::
    db $79, $1b, $08, $00, $0b, $ea, $ea, $ea, $ea, $ea, $a9, $01, $cd, $4f, $0c, $d0
    db $79, $26, $08, $00, $0b, $39, $cd, $48, $0c, $d0, $34, $a5, $c9, $c9, $80, $d0
    db $79, $31, $08, $00, $0b, $0c, $a5, $ca, $c9, $7e, $d0, $06, $a5, $cb, $c9, $7e
    db $79, $3c, $08, $00, $0b, $f0, $12, $a5, $c9, $c9, $c8, $d0, $1c, $a5, $ca, $c9
    db $79, $47, $08, $00, $0b, $c4, $d0, $16, $a5, $cb, $c9, $05, $d0
    db $10
    db $a2, $28, $79, $52, $08, $00, $0b, $a9, $e7, $9f, $01, $c0, $7e, $e8, $e8, $e8
    db $e8, $e0, $79, $5d, $08, $00, $04, $8c, $d0
    db $f4
    db $60, $00, $00, $00, $00, $00, $00, $00, $79
    db $10
    db $08, $00, $0b, $4c, $20, $08, $ea, $ea, $ea, $ea, $ea, $60
    db $ea
    db $ea


SgbBorderTilemapRle::
; Source: sgb/border_tilemap.bin (prevbyte, 1536 decoded bytes).
    INCBIN "../build/original/assets/b03_47f4.bin"


SgbPaletteTransferSource::
    db $9f, $67, $1c, $16, $13, $0d, $00, $00, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $3f, $3b, $a0, $7d, $00, $00, $ff, $7f, $94, $52, $4a, $29, $00, $00
    db $fb, $7f, $ff, $7f, $ff, $7f, $c0, $7c, $fb, $7f, $3f, $3f, $24, $6d, $00, $00
    db $fb, $7f, $ff, $7f, $52, $02, $00, $00, $fb, $7f, $7f, $55, $ff, $03, $4b, $1d
    db $ff, $4b, $48, $7d, $00, $00, $00, $00, $ff, $4b, $3f, $3b, $7d, $2c, $00, $00
    db $ff, $4b, $f8, $3f, $5f, $28, $20, $0c, $ff, $4b, $00, $00, $00, $00, $80, $02
    db $77, $6b, $ea, $43, $a7, $0d, $00, $00, $77, $6b, $ff, $7f
    db $e3
    db $7d, $00, $00, $77, $6b, $ff, $4a, $1f, $13, $00
    db $00, $77, $6b, $7f, $0a, $1f, $00, $00, $00, $ff, $7f, $ff, $03, $33, $02, $00
    db $00, $ff, $7f, $ff, $32, $34, $26, $00, $00, $ff, $7f, $e7, $67, $00, $00, $00
    db $00, $ff, $7f, $bf, $11, $00, $00, $00, $00, $ff, $7f, $1c, $02, $1f, $00, $00
    db $00, $ff, $7f, $ff, $32, $1e, $05, $00, $00, $ff, $7f, $e7, $67, $00, $00, $00
    db $00, $ff, $7f, $bf, $11, $00, $00, $00, $00, $ff, $7f, $74, $7e, $ff, $7f, $00
    db $00, $ff, $7f, $3f, $3b, $84, $03, $00, $00, $ff, $7f, $3f, $3b, $1b, $09, $00
    db $00, $ff, $7f, $ff, $03, $1b, $09, $00, $00, $ff, $7f, $9f, $42, $00, $00, $00
    db $00, $ff, $7f, $3f, $3b, $ff, $03, $00, $00, $ff, $7f, $3f, $3b, $02, $7e, $00
    db $00, $ff, $7f, $3f, $3b, $1b, $09, $00, $00, $ff, $7f, $3f, $2f, $00, $00, $00
    db $00, $ff, $7f, $3f, $3b, $66, $46, $00, $00, $ff, $7f, $3f, $3b, $1b, $09, $00
    db $00, $ff, $7f
    db $e3
    db $7f, $1f, $00, $00, $00, $ff, $7f, $e9, $2f, $00, $00, $00, $00, $ff, $7f, $ff
    db $6b
	db $c2
	db $7E
	db $00

    db $00, $ff, $7f, $3f, $3b, $1f, $5a, $00, $00, $ff, $7f, $ff, $03, $1f, $00, $00
    db $00
    db $fc
    db $3b, $e0, $53, $9f, $00, $00, $00
    db $fc
    db $3b
    db $db
    db $26, $24, $6d, $00, $00
    db $fc
    db $3b, $ff, $7f, $52, $02, $00, $00
    db $fc
    db $3b, $00, $00, $00, $00, $7c, $00, $bd, $77, $f1, $7a, $8a, $4d, $00, $00, $bd
    db $77, $3f, $33
    db $d3
    db $36, $00, $00, $bd, $77, $6c, $7d, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $ff, $7f, $be, $2d, $00, $00, $00, $00, $ff, $7f, $3f, $3b, $d5
    db $1d, $00, $00, $ff, $7f, $8c, $51, $e7, $44, $00, $00, $ff, $7f, $00, $00, $1f
    db $00, $00, $00, $bd, $77, $5f, $5a
    db $fd
    db $0c, $00, $00, $bc, $63, $ff, $29, $76, $31, $00, $00, $bd, $77, $9f, $5f, $39
    db $25, $00, $00, $ff, $7f, $00, $00, $00, $00, $00, $00, $bd, $77, $5d, $3b
    db $cc
    db $0e
    db $00, $00, $bd, $77, $90, $57, $32, $7e, $00, $00, $bd, $77
    db $dd
    db $5a, $8e, $6e, $00, $00, $bd, $77, $9c, $3b, $2c, $33, $00, $00, $bd, $77, $ee
    db $7e, $00, $00, $c0, $01, $bd, $77, $3f, $3b, $7e, $03, $00, $00, $bd, $77, $58
    db $02, $93, $01, $00, $00, $bd, $77, $00, $7c, $00, $00, $00, $00
SgbScreenPaletteTable_4d5f::
    ; 6-byte records indexed by wScreenPaletteId.
    ; id  pal0 pal1 pal2 pal3 ctl  extra
    db $01, $01, $01, $01, $00, $00 ; $00
    db $04, $05, $06, $07, $01, $01 ; $01
    db $28, $29, $2a, $2b, $02, $03 ; $02
    db $08, $09, $0a, $0b, $03, $08 ; $03
    db $00, $00, $00, $00, $00, $00 ; $04
    db $10, $11, $12, $13, $05, $03 ; $05
    db $14, $15, $16, $17, $06, $03 ; $06
    db $2c, $2d, $2e, $00, $04, $03 ; $07
    db $18, $19, $1a, $1b, $07, $03 ; $08
    db $1c, $1d, $1e, $1f, $08, $03 ; $09
    db $20, $21, $22, $23, $0a, $03 ; $0a
    db $24, $25, $26, $27, $0c, $03 ; $0b
    db $34, $34, $34, $34, $00, $08 ; $0c
    db $0c, $0d, $0e, $0f, $0e, $08 ; $0d
    db $35, $35, $35, $35, $00, $08 ; $0e
    db $00, $00, $00, $00, $00, $05 ; $0f
    db $18, $19, $1a, $1b, $07, $03 ; $10
    db $1c, $1d, $1e, $1f, $09, $03 ; $11
    db $20, $21, $22, $02, $0b, $03 ; $12
    db $24, $25, $26, $27, $0d, $03 ; $13
    db $03, $03, $03, $03, $0f, $08 ; $14
    db $03, $03, $03, $03, $00, $00 ; $15
    db $01, $01, $01, $01, $0f, $00 ; $16
    db $3c, $3d, $3e, $3f, $0e, $00 ; $17
    db $03, $03, $03, $03, $00, $07 ; $18
    db $3c, $3d, $3e, $3f, $10, $04 ; $19
    db $38, $38, $38, $38, $00, $09 ; $1a
    db $39, $39, $39, $39, $00, $07 ; $1b
    db $3a, $3a, $3a, $3a, $00, $06 ; $1c
    db $3b, $3b, $3b, $3b, $00, $0a ; $1d
    db $00, $00, $00, $00, $00, $02 ; $1e


Bank3MetaspritePtrTable::
    dw UiMetasprite_00 ; metasprite $00
    dw UiMetasprite_01 ; metasprite $01
    dw UiMetasprite_02 ; metasprite $02
    dw UiMetasprite_03 ; metasprite $03
    dw UiMetasprite_04 ; metasprite $04
    dw UiMetasprite_05 ; metasprite $05
    dw UiMetasprite_06 ; metasprite $06
    dw UiMetasprite_07 ; metasprite $07
    dw UiMetasprite_08 ; metasprite $08
    dw UiMetasprite_09 ; metasprite $09
    dw UiMetasprite_0a ; metasprite $0a
    dw UiMetasprite_0b ; metasprite $0b
    dw UiMetasprite_0c ; metasprite $0c
    dw UiMetasprite_0d ; metasprite $0d
    dw UiMetasprite_0e ; metasprite $0e
    dw UiMetasprite_0f ; metasprite $0f
    dw UiMetasprite_10 ; metasprite $10
    dw UiMetasprite_11 ; metasprite $11
    dw UiMetasprite_12 ; metasprite $12
    dw UiMetasprite_13 ; metasprite $13
    dw UiMetasprite_14 ; metasprite $14
    dw UiMetasprite_15 ; metasprite $15
    dw UiMetasprite_16 ; metasprite $16
    dw UiMetasprite_17 ; metasprite $17
    dw UiMetasprite_18 ; metasprite $18
    dw UiMetasprite_19 ; metasprite $19
    dw UiMetasprite_1a ; metasprite $1a
    dw UiMetasprite_1b ; metasprite $1b
    dw UiMetasprite_1c ; metasprite $1c
    dw UiMetasprite_1d ; metasprite $1d
    dw UiMetasprite_1e ; metasprite $1e
    dw UiMetasprite_1f ; metasprite $1f
    dw UiMetasprite_20 ; metasprite $20
    dw UiMetasprite_21 ; metasprite $21
    dw UiMetasprite_22 ; metasprite $22
    dw UiMetasprite_23 ; metasprite $23
    dw UiMetasprite_24 ; metasprite $24
    dw UiMetasprite_25 ; metasprite $25
    dw UiMetasprite_26 ; metasprite $26
    dw UiMetasprite_27 ; metasprite $27
    dw UiMetasprite_28 ; metasprite $28
    dw UiMetasprite_29 ; metasprite $29
    dw UiMetasprite_2a ; metasprite $2a
    dw UiMetasprite_2b ; metasprite $2b
    dw UiMetasprite_2c ; metasprite $2c
    dw UiMetasprite_2d ; metasprite $2d
    dw UiMetasprite_2e ; metasprite $2e
    dw UiMetasprite_2f ; metasprite $2f
    dw UiMetasprite_30 ; metasprite $30
    dw UiMetasprite_31 ; metasprite $31
    dw UiMetasprite_32 ; metasprite $32
    dw UiMetasprite_33 ; metasprite $33
    dw UiMetasprite_34 ; metasprite $34
    dw UiMetasprite_35 ; metasprite $35
    dw UiMetasprite_36 ; metasprite $36
    dw UiMetasprite_37 ; metasprite $37
    dw UiMetasprite_38 ; metasprite $38
    dw UiMetasprite_39 ; metasprite $39
    dw UiMetasprite_3a ; metasprite $3a
    dw UiMetasprite_3b ; metasprite $3b
    dw UiMetasprite_3c ; metasprite $3c
    dw UiMetasprite_3d ; metasprite $3d
    dw UiMetasprite_3e ; metasprite $3e
    dw UiMetasprite_3f ; metasprite $3f
    dw UiMetasprite_40 ; metasprite $40
    dw UiMetasprite_41 ; metasprite $41
    dw UiMetasprite_42 ; metasprite $42
    dw UiMetasprite_43 ; metasprite $43
    dw UiMetasprite_44 ; metasprite $44
    dw UiMetasprite_45 ; metasprite $45
    dw UiMetasprite_46 ; metasprite $46
    dw UiMetasprite_47 ; metasprite $47
    dw UiMetasprite_48 ; metasprite $48
    dw UiMetasprite_49 ; metasprite $49
    dw UiMetasprite_4a ; metasprite $4a
    dw UiMetasprite_4b ; metasprite $4b
    dw UiMetasprite_4c ; metasprite $4c
    dw UiMetasprite_4d ; metasprite $4d
    dw UiMetasprite_4e ; metasprite $4e
    dw UiMetasprite_4f ; metasprite $4f
    dw UiMetasprite_50 ; metasprite $50
    dw UiMetasprite_51 ; metasprite $51
    dw UiMetasprite_52 ; metasprite $52
    dw UiMetasprite_53 ; metasprite $53
    dw UiMetasprite_54 ; metasprite $54
    dw UiMetasprite_55 ; metasprite $55
    dw UiMetasprite_56 ; metasprite $56
    dw UiMetasprite_57 ; metasprite $57
    dw UiMetasprite_58 ; metasprite $58
    dw UiMetasprite_59 ; metasprite $59
    dw UiMetasprite_5a ; metasprite $5a
    dw UiMetasprite_5b ; metasprite $5b
    dw UiMetasprite_5c ; metasprite $5c
    dw UiMetasprite_5d ; metasprite $5d
    dw UiMetasprite_5e ; metasprite $5e
    dw UiMetasprite_5f ; metasprite $5f
    dw UiMetasprite_60 ; metasprite $60
    dw UiMetasprite_61 ; metasprite $61
    dw UiMetasprite_62 ; metasprite $62
    dw UiMetasprite_63 ; metasprite $63
    dw UiMetasprite_64 ; metasprite $64
    dw UiMetasprite_65 ; metasprite $65
    dw UiMetasprite_66 ; metasprite $66
    dw UiMetasprite_67 ; metasprite $67
    dw UiMetasprite_68 ; metasprite $68
    dw UiMetasprite_69 ; metasprite $69
    dw UiMetasprite_6a ; metasprite $6a
    dw UiMetasprite_6b ; metasprite $6b
    dw UiMetasprite_6c ; metasprite $6c
    dw UiMetasprite_6d ; metasprite $6d
    dw UiMetasprite_6e ; metasprite $6e
    dw UiMetasprite_6f ; metasprite $6f
    dw UiMetasprite_70 ; metasprite $70
    dw UiMetasprite_71 ; metasprite $71
    dw UiMetasprite_72 ; metasprite $72
    dw UiMetasprite_73 ; metasprite $73
    dw UiMetasprite_74 ; metasprite $74
    dw UiMetasprite_75 ; metasprite $75
    dw UiMetasprite_76 ; metasprite $76
    dw UiMetasprite_77 ; metasprite $77
    dw UiMetasprite_78 ; metasprite $78
    dw UiMetasprite_79 ; metasprite $79
    dw UiMetasprite_7a ; metasprite $7a
    dw UiMetasprite_7b ; metasprite $7b
    dw UiMetasprite_7c ; metasprite $7c
    dw UiMetasprite_7d ; metasprite $7d
    dw UiMetasprite_7e ; metasprite $7e
    dw UiMetasprite_7f ; metasprite $7f
    dw UiMetasprite_80 ; metasprite $80
    dw UiMetasprite_81 ; metasprite $81
    dw UiMetasprite_82 ; metasprite $82
    dw UiMetasprite_83 ; metasprite $83
    dw UiMetasprite_84 ; metasprite $84
    dw UiMetasprite_85 ; metasprite $85
    dw UiMetasprite_86 ; metasprite $86
    dw UiMetasprite_87 ; metasprite $87
    dw UiMetasprite_88 ; metasprite $88
    dw UiMetasprite_89 ; metasprite $89
    dw UiMetasprite_8a ; metasprite $8a
    dw UiMetasprite_8b ; metasprite $8b
    dw UiMetasprite_8c ; metasprite $8c
    dw UiMetasprite_8d ; metasprite $8d
    dw UiMetasprite_8e ; metasprite $8e
    dw UiMetasprite_8f ; metasprite $8f
    dw UiMetasprite_90 ; metasprite $90
    dw UiMetasprite_91 ; metasprite $91
    dw UiMetasprite_92 ; metasprite $92
    dw UiMetasprite_93 ; metasprite $93
    dw UiMetasprite_94 ; metasprite $94
    dw UiMetasprite_95 ; metasprite $95
    dw UiMetasprite_96 ; metasprite $96
    dw UiMetasprite_97 ; metasprite $97
    dw UiMetasprite_98 ; metasprite $98
    dw UiMetasprite_99 ; metasprite $99
    dw UiMetasprite_9a ; metasprite $9a
    dw UiMetasprite_9b ; metasprite $9b
    dw UiMetasprite_9c ; metasprite $9c
    dw UiMetasprite_9d ; metasprite $9d
    dw UiMetasprite_9e ; metasprite $9e
    dw UiMetasprite_9f ; metasprite $9f
    dw UiMetasprite_a0 ; metasprite $a0
    dw UiMetasprite_a1 ; metasprite $a1
    dw UiMetasprite_a2 ; metasprite $a2
    dw UiMetasprite_a3 ; metasprite $a3
    dw UiMetasprite_a4 ; metasprite $a4
    dw UiMetasprite_a5 ; metasprite $a5
    dw UiMetasprite_a6 ; metasprite $a6
    dw UiMetasprite_a7 ; metasprite $a7
    dw UiMetasprite_a8 ; metasprite $a8
    dw UiMetasprite_a9 ; metasprite $a9
    dw UiMetasprite_aa ; metasprite $aa
    dw UiMetasprite_ab ; metasprite $ab
    dw UiMetasprite_ac ; metasprite $ac
    dw UiMetasprite_ad ; metasprite $ad
    dw UiMetasprite_ae ; metasprite $ae
    dw UiMetasprite_af ; metasprite $af
    dw UiMetasprite_b0 ; metasprite $b0
    dw UiMetasprite_b1 ; metasprite $b1
    dw UiMetasprite_b2 ; metasprite $b2
    dw UiMetasprite_b3 ; metasprite $b3
    dw UiMetasprite_b4 ; metasprite $b4
    dw UiMetasprite_b5 ; metasprite $b5
    dw UiMetasprite_b6 ; metasprite $b6
    dw UiMetasprite_b7 ; metasprite $b7
    dw UiMetasprite_b8 ; metasprite $b8
    dw UiMetasprite_b9 ; metasprite $b9
    dw UiMetasprite_ba ; metasprite $ba
    dw UiMetasprite_bb ; metasprite $bb
    dw UiMetasprite_bc ; metasprite $bc
    dw UiMetasprite_bd ; metasprite $bd
    dw UiMetasprite_be ; metasprite $be
    dw UiMetasprite_bf ; metasprite $bf
    dw UiMetasprite_c0 ; metasprite $c0
    dw UiMetasprite_c1 ; metasprite $c1
    dw UiMetasprite_c2 ; metasprite $c2
    dw UiMetasprite_c3 ; metasprite $c3
    dw UiMetasprite_c4 ; metasprite $c4
    dw UiMetasprite_c5 ; metasprite $c5
    dw UiMetasprite_c6 ; metasprite $c6
    dw UiMetasprite_c7 ; metasprite $c7
    dw UiMetasprite_c8 ; metasprite $c8
    dw UiMetasprite_c9 ; metasprite $c9
    dw UiMetasprite_ca ; metasprite $ca
    dw UiMetasprite_cb ; metasprite $cb
    dw UiMetasprite_cc ; metasprite $cc
    dw UiMetasprite_cd ; metasprite $cd
    dw UiMetasprite_ce ; metasprite $ce
    dw UiMetasprite_cf ; metasprite $cf
    dw UiMetasprite_d0 ; metasprite $d0
    dw UiMetasprite_d1 ; metasprite $d1
    dw UiMetasprite_d1 ; metasprite $d2
    dw UiMetasprite_d3 ; metasprite $d3
    dw UiMetasprite_d4 ; metasprite $d4
    dw UiMetasprite_d5 ; metasprite $d5
    dw UiMetasprite_d6 ; metasprite $d6
    dw UiMetasprite_d7 ; metasprite $d7
    dw UiMetasprite_d8 ; metasprite $d8
    dw UiMetasprite_d9 ; metasprite $d9
    dw UiMetasprite_da ; metasprite $da
    dw UiMetasprite_db ; metasprite $db
    dw UiMetasprite_dc ; metasprite $dc
    dw UiMetasprite_dd ; metasprite $dd
    dw UiMetasprite_de ; metasprite $de
    dw UiMetasprite_df ; metasprite $df
    dw UiMetasprite_e0 ; metasprite $e0
    dw UiMetasprite_e1 ; metasprite $e1
    dw UiMetasprite_e2 ; metasprite $e2
    dw UiMetasprite_e3 ; metasprite $e3
    dw UiMetasprite_e4 ; metasprite $e4
    dw UiMetasprite_e5 ; metasprite $e5
    dw UiMetasprite_e6 ; metasprite $e6
    dw UiMetasprite_e7 ; metasprite $e7
    dw UiMetasprite_e8 ; metasprite $e8
    dw UiMetasprite_e9 ; metasprite $e9
    dw UiMetasprite_ea ; metasprite $ea
    dw UiMetasprite_eb ; metasprite $eb
    dw UiMetasprite_ec ; metasprite $ec
    dw UiMetasprite_ed ; metasprite $ed
    dw UiMetasprite_ee ; metasprite $ee
    dw UiMetasprite_ef ; metasprite $ef
    dw UiMetasprite_f0 ; metasprite $f0
    dw UiMetasprite_f1 ; metasprite $f1

MessageText_00::
; Message text referenced by descriptor $00.
    db $0f, $ff

MessageText_01::
; Message text referenced by descriptor $01.
    db $00, $00, $6d, $53, $6d, $53, $45, $1f, $11, $1a, $17, $1d, $42, $fe, $5b, $74
    db $54, $45, $66, $45, $15, $05, $09, $54, $33, $34, $13, $36, $45, $59, $7d, $ff

MessageText_02::
; Message text referenced by descriptor $02.
    db $00, $00, $00, $19, $42, $20, $3c, $12, $10, $21, $32, $fe, $2d, $42, $1b, $42
    db $58, $5d, $5f, $45, $15, $33, $34, $13, $36, $45, $59, $7d, $ff

MessageText_03::
; Message text referenced by descriptor $03.
    db $00, $00, $00
    db $14, $1c, $45, $2d, $35, $45, $56, $70, $7c, $43, $67, $fe, $1b, $42, $20, $3a
    db $42, $45, $15, $2b, $24, $35, $2c, $13, $36, $45, $59, $7d, $ff

MessageText_04::
; Message text referenced by descriptor $04.
    db $00, $00, $00
    db $00, $00, $45, $23, $45, $17, $20, $fe, $30, $45, $16, $41, $14, $1d, $45, $2a
    db $21, $45, $16, $29, $57, $5e, $7e, $45, $56, $45, $1f, $ff

MessageText_05::
; Message text referenced by descriptor $05.
    db $00, $00, $00, $00
    db $00, $39, $22, $1f, $7d, $fe, $5b, $74, $54, $45, $66, $41, $05, $09, $54, $33
    db $34, $22, $1f, $45, $59, $7d, $ff

MessageText_06::
; Message text referenced by descriptor $06.
    db $00, $00, $00, $00, $00, $39, $22, $1f, $7d, $fe, $fd, $58, $5d, $5f, $41, $33
    db $34, $22, $1f, $45, $59, $7d, $ff

MessageText_07::
; Message text referenced by descriptor $07.
    db $00, $00
    db $00, $00, $00, $39, $22, $1f, $7d, $fe, $1b, $42, $20, $3a, $42, $45, $15, $2b
    db $24, $35, $2c, $13, $1f, $45, $59, $7d, $ff

MessageText_08::
; Message text referenced by descriptor $08.
    db $00, $00, $1b, $22, $43, $2a, $11, $1b, $20, $3a, $22, $1f, $7d, $ff

MessageText_09::
; Message text referenced by descriptor $09.
    db $00, $6d, $53, $6d, $53, $45, $1f, $11, $1a
    db $17, $1d, $42, $fe, $0f, $51, $7e, $29, $00, $12, $13, $24, $1b, $1f, $45, $23
    db $fe, $1b, $42, $20, $3a, $42, $41, $00, $1e, $12, $1a, $1b, $23, $fe, $40, $45
    db $69, $5a, $7c, $45, $23, $00, $19, $12, $45, $18, $16, $7d, $fe, $52, $76, $46
    db $7e, $43, $69, $48, $7c, $5f, $41, $fe, $15, $1d, $11, $45, $23, $00, $46, $52
    db $56, $74, $7c, $fe, $57, $5f, $7e, $7c, $41, $00, $2f, $33, $38, $12, $7d, $ff

MessageText_0a::
; Message text referenced by descriptor $0a.
    db $00, $00, $19, $42, $20, $3c, $12, $10, $21, $32, $fe, $0f, $51, $7e, $45, $23
    db $00, $1b, $42, $20, $3a, $42, $41, $fe, $1e, $12, $1a, $1b, $23, $00, $40, $45
    db $69, $5a, $7c, $45, $23, $fe, $31, $1b, $41, $21, $15, $2f, $13, $3d, $12, $7d
    db $fe, $1d, $11, $45, $18, $42, $45, $1b, $15, $42, $25, $11, $26, $fe, $52, $76
    db $46, $7e, $43, $69, $48, $7c, $5f, $41, $fe, $15, $1d, $45, $17, $42, $45, $1f
    db $7d, $ff

MessageText_0b::
; Message text referenced by descriptor $0b.
    db $00, $00, $14, $1c, $45, $2d, $35, $45, $56, $70, $7c, $43, $67, $fe
    db $40, $45, $69, $5a, $7c, $45, $23, $00, $1b, $42, $20, $3a, $42, $41, $fe, $45
    db $56, $70, $7c, $43, $67, $1a, $1d, $23, $fe, $1b, $42, $20, $3a, $42, $26, $42
    db $45, $16, $3e, $12, $41, $fe, $51, $70, $5d, $5b, $1c, $36, $42, $45, $1f, $7d
    db $fe, $2f, $45, $1c, $2a, $00, $56, $79, $45, $15, $00, $14, $23, $2e, $42, $fe
    db $41, $00, $30, $1d, $23, $17, $37, $36, $3d, $7d, $ff

MessageText_0c::
; Message text referenced by descriptor $0c.
    db $00, $00, $00, $00, $00
    db $45, $1a, $42, $28, $42, $7d, $fe, $00, $00, $00, $57, $5a, $7c, $43, $67, $45
    db $15, $25, $11, $45, $59, $7d, $ff

MessageText_0d::
; Message text referenced by descriptor $0d.
    db $1b, $42, $20, $3a, $42, $24, $10, $1e, $45
    db $2c, $fe, $24, $20, $3c, $12, $15, $34, $10, $1e, $45, $2c, $fe, $6b, $61, $45
    db $53, $7e, $6c, $45, $23, $10, $1e, $45, $2c, $ff


MessageText_0e::
; Message text referenced by descriptor $0e.
    db $6d, $53, $6d, $53, $45, $1f, $11, $1a, $17, $1d, $42, $fe, $19, $42, $20, $3c

    db $12, $10, $21, $32, $fe, $14, $1c, $45, $2d, $35, $45, $56, $70, $7c, $43, $67
    db $ff

MessageText_0f::
; Message text referenced by descriptor $0f.
    db $15, $11, $3f, $00, $00, $00, $00, $05, $fe, $45, $5e, $6e, $00, $00, $00
    db $00, $00, $05, $fe, $4c, $7c, $45, $5e, $49, $7c, $45, $52, $00, $05, $fe, $58
    db $78, $52, $5f, $45, $5e, $6e, $00, $05, $ff


MessageText_10::
; Message text referenced by descriptor $10.
    db $57, $5a, $7e, $5f, $7d, $ff

MessageText_11::
; Message text referenced by descriptor $11.
    db $00, $05, $ff

MessageText_12::
; Message text referenced by descriptor $12.
    db $00, $06, $ff

MessageText_13::
; Message text referenced by descriptor $13.
    db $00, $07, $ff

; -----------------------------------------------------------------------------
; Message $4C: level text
; レべル<VAR>

Message_4C_LevelText::
    db $78, $45, $2d, $77, $fd, $ff

MessageText_15::
; Message text referenced by descriptor $15.
    db $a0, $43, $66, $52, $61, $5d, $52, $2d, $11, $17, $45, $59, $a1, $ff

MessageText_16::
; Message text referenced by descriptor $16.
    db $a0, $3d, $12, $20, $13, $42, $45, $23, $10, $1e, $45, $2c, $45, $59, $a1, $ff

MessageText_17::
; Message text referenced by descriptor $17.
    db $00, $a0, $45, $5e, $43, $65, $7e, $5f, $2d, $11, $17, $45, $59, $a1, $ff

MessageText_18::
; Message text referenced by descriptor $18.
    db $a0, $45, $52, $46, $6c, $35, $3e, $19, $12, $45, $1f, $45, $59
    db $a1, $ff


MessageText_19::
; Message text referenced by descriptor $19.
    db $10, $24, $00, $fd, $15, $11, $45, $1f, $3d, $ff

MessageText_1a::
; Message text referenced by descriptor $1a.
    db $8e, $14, $45, $18, $42

    db $16, $8f, $ff

MessageText_1b::
; Message text referenced by descriptor $1b.
    db $8e, $45, $1f, $1b, $23, $7d, $8f, $ff


; -----------------------------------------------------------------------------
; Message $1C: Stage 1 intro / picnic
; きょうは しんちゃんが
; たのしみにしていたピクニック
; の ひ です
; ところが おやつのチョコビを
; タケシくんに とられてしまい
; ました！

Message_1C_Stage1Intro::
    db $16, $3e, $12, $2a, $00, $1b, $42, $20, $3a, $42, $45, $15, $fe, $1f, $29, $1b
    db $30, $26, $1b, $23, $11, $1f, $43, $66, $52, $61, $5d, $52, $fe

    db $29, $00, $2b, $00, $45, $23, $1c, $fe, $24, $19, $38, $45

    db $15, $00, $14, $39, $21, $29, $5b, $74, $54, $45, $66, $41, $fe, $5a

    db $53, $56, $17, $42, $26, $00, $24, $34, $37, $23, $1b, $2f, $11, $fe, $2f, $1b
    db $1f, $7d, $ff


; -----------------------------------------------------------------------------
; Message $1D: Stage 2 intro / kindergarten rivals
; しんちゃんが かよっている
; ひまわりぐみには ゆかいな
; おともだちが いっぱい！
; でも となりのバラぐみには
; かわむらくんのような
; ライバルばかり なんだ！

Message_1D_Stage2Intro::
    db $1b, $42, $20, $3a, $42, $45, $15, $00, $15, $3d, $22, $23, $11, $36, $fe, $2b
    db $2f, $3f, $35, $45, $17, $30, $26, $2a, $00, $3b, $15, $11, $25, $fe, $14, $24
    db $33, $45, $1f, $20, $45, $15, $00, $11, $22, $43, $2a, $11, $7d, $fe, $45, $23
    db $33, $00, $24, $25, $35, $29, $45, $65, $75, $45, $17, $30, $26, $2a, $fe, $15
    db $3f, $31, $34, $17, $42, $29, $3d, $12, $25, $fe, $75, $48, $45, $65, $77, $45
    db $2a, $15, $35, $00, $25, $42, $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $1E: Stage 3 intro / Action Department
; きょうの アクションデパート
; は すごい ひとだかり！
; なぜなら おくじょうで
; アクションかめんショーが
; おこなわれるからです！

Message_1E_Stage3Intro::
    db $16, $3e, $12, $29, $00, $46, $52, $56, $74, $7c, $45, $5e, $43, $65, $7e, $5f
    db $fe, $2a, $00, $1c, $45, $19, $11, $00, $2b, $24, $45, $1f, $15, $35, $7d, $fe
    db $25, $45, $1d, $25, $34, $00, $14, $17, $45, $1b, $3e, $12, $45, $23, $fe, $46
    db $52, $56, $74, $7c, $15, $32, $42, $56, $74, $7e, $45, $15, $fe, $14, $19, $25
    db $3f, $37, $36, $15, $34, $45, $23, $1c, $7d, $ff

; -----------------------------------------------------------------------------
; Message $1F: Stage 4 intro / Guam trip
; みさえが おうぼしたクイズで
; グアムりょこうが あたって
; しまった！
; さっそく かぞくみんなで
; グアムへ やってきたのですが
; ．．．？

Message_1F_Stage4Intro::
    db $30, $1a, $13, $45, $15, $00, $14, $12, $45, $2e, $1b, $1f, $52, $48, $45, $57
    db $45, $23, $fe, $45, $52, $46, $6c, $35, $3e, $19, $12, $45, $15, $00, $10, $1f
    db $22, $23, $fe, $1b, $2f, $22, $1f, $7d, $fe, $1a, $22, $1e, $17, $00, $15, $45
    db $1e, $17, $30, $42, $25, $45, $23, $fe, $45, $52, $46, $6c, $2d, $00, $39, $22
    db $23, $16, $1f, $29, $45, $23, $1c, $45, $15, $fe, $44, $44, $44, $7f, $ff


; -----------------------------------------------------------------------------
; Message $20: Takeshi steals Chocobi
; へっへっへっへー
; チョコビ いっただきー！
; ．．．おい！ なにニヤケてんだよ
; きもちワリーな！！

Message_20_TakeshiStealsChocobi::
    db $2d, $22, $2d, $22, $2d, $22, $2d, $7e, $fe, $5b, $74, $54, $45, $66, $00, $11
    db $22, $1f, $45, $1f, $16, $7e, $7d, $fe, $44, $44, $44, $14, $11, $7d, $00, $25
    db $26, $61, $6f, $53, $23, $42, $45, $1f, $3d, $fe, $16, $33, $20, $7a

    db $76, $7e, $25, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $21: Shin-chan meta intro
; いやー ゲームボーイにでるの
; ひさしぶりなもんで．．．
; どーも どーも しんのすけですう
; すきな おパンツのガラは．．

Message_21_ShinchanMetaIntro::
    db $11, $39, $7e, $00, $45, $53, $7e, $6c, $45, $69, $7e, $48, $26, $45, $23, $36
    db $29, $fe, $2b, $1a, $1b, $45, $2c, $35, $25, $33, $42, $45, $23, $44, $44, $44
    db $fe, $45, $24, $7e, $33, $00, $45, $24, $7e, $33, $00, $1b, $42, $29, $1c, $18
    db $45

    db $23, $1c, $12, $fe, $1c, $16, $25, $00, $14, $43, $65, $7c, $5c, $29, $45, $50
    db $75, $2a, $44, $44, $ff

; -----------------------------------------------------------------------------
; Message $22: Takeshi runs away
; ends with control $fc before $ff
; えーい なにブツブツいってんだ！
; こいつは いただいていくぜ
; あばよ！

Message_22_TakeshiRunsAway::
    db $13, $7e, $11, $00, $25, $26, $45, $67, $5c, $45, $67, $5c, $11, $22, $23, $42
    db $45, $1f, $7d, $fe, $19, $11, $21, $2a, $00, $11, $1f, $45, $1f, $11, $23, $11
    db $17, $45, $1d, $fe, $10, $45, $2a, $3d, $7d, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $23: Tutorial lead-in
; おおっ オラのチョコビ
; とりかえさなくっちゃ！
; [control $fc]
; でも そのまえに オラのうごかし
; かたを せつめいするゾ！

Message_23_TutorialLeadIn::
    db $14, $14

    db $22, $00

    db $4e, $75, $29, $5b, $74, $54, $45, $66, $fe, $24, $35, $15, $13, $1a, $25, $17
    db $22, $20, $3a

    db $7d, $fe, $fc, $45, $23, $33, $00, $1e, $29, $2f, $13, $26, $00, $4e, $75, $29
    db $12, $45, $19, $15, $1b, $fe, $15, $1f, $41, $00, $1d, $21, $32, $11, $1c, $36
    db $45, $59, $7d, $ff


; -----------------------------------------------------------------------------
; Message $24: Takeshi returns Chocobi
; ちっ しょうがないなあ
; チョコビ かえしてやるよ！

Message_24_TakeshiReturnsChocobi::
    db $20, $22, $00, $1b, $3e, $12, $45, $15, $25, $11, $25, $10, $fe, $5b, $74, $54
    db $45, $66, $00, $15, $13, $1b, $23, $39, $36, $3d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $25: Chocobi recovered
; ワーイ ワーイ
; チョコビだ チョコビだー！

Message_25_ChocobiRecovered::
    db $7a, $7e, $48, $00, $7a, $7e, $48, $fe, $5b, $74, $54, $45, $66, $45, $1f, $00
    db $5b, $74, $54, $45, $66, $45, $1f, $7e, $7d, $ff

; -----------------------------------------------------------------------------
; Message $26: sound effect text
; ザーッ

Message_26_DrinkSound::
    db $45, $55, $7e, $5d, $ff

; -----------------------------------------------------------------------------
; Message $27: drinking reaction
; す．すげえ
; いっきのみ してやがる．．．

Message_27_DrinkReaction::
    db $1c, $44, $1c, $45, $18, $13, $fe, $11, $22, $16, $29, $30, $00, $1b, $23, $39
    db $45, $15, $36, $44, $44, $44, $ff

; -----------------------------------------------------------------------------
; Message $28: Chocobi after a sweat
; いやー ひとあせ かいたあとの
; チョコビ！
; うまいんだな これが！！

Message_28_ChocobiAfterSweat::
    db $11, $39, $7e, $00, $2b, $24, $10, $1d, $00, $15, $11, $1f, $10, $24, $29, $fe
    db $5b, $74, $54, $45, $66, $7d, $fe, $12, $2f, $11, $42, $45, $1f, $25, $00, $19
    db $37, $45, $15, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $29: stage clear password prompt
;    ステージ<VAR> おしまい
;      パスワード

Message_29_StageClearPassword::
    db $00, $00, $00, $57, $5e, $7e, $45, $56, $fd, $00, $14, $1b, $2f, $11, $fe, $00
    db $00, $00, $00, $00, $43, $65, $57, $7a, $7e, $45, $5f, $ff

; -----------------------------------------------------------------------------
; Message $2A: Kawamura appears
; ふっふっふっふっ
; ひさしぶりだな しんのすけ！

Message_2A_KawamuraAppears::
    db $2c, $22, $2c, $22, $2c, $22, $2c, $22, $fe, $2b, $1a, $1b, $45, $2c, $35, $45
    db $1f, $25, $00, $1b, $42, $29, $1c, $18, $7d, $ff

; -----------------------------------------------------------------------------
; Message $2B: Who are you?
; あんた だれ？

Message_2B_WhoAreYou::
    db $10, $42, $1f, $00, $45, $1f, $37, $7f, $ff

; -----------------------------------------------------------------------------
; Message $2C: Kawamura / Cheetah introduction
; ようちえん バラぐみの チーター
; こと かわむらさまだ！！
; わすれるとは ぶれいなやつだ

Message_2C_KawamuraIntroducesHimself::
    db $3d, $12, $20, $13, $42, $00, $45, $65, $75, $45, $17, $30, $29, $00, $5b, $7e
    db $5a, $7e, $fe, $19, $24, $00, $15, $3f, $31, $34, $1a, $2f, $45, $1f, $7d, $7d
    db $fe, $3f, $1c, $37, $36, $24, $2a, $00, $45, $2c, $37, $11, $25, $39, $21, $45
    db $1f, $ff

; -----------------------------------------------------------------------------
; Message $2D: Shin-chan teases Kawamura
; ねえーん
; そんなに おこらないでよおーん
; ゆるしてえええーん

Message_2D_ShinchanTeasesKawamura::
    db $28, $13, $7e, $42, $fe, $1e, $42, $25, $26, $00, $14, $19, $34, $25, $11, $45
    db $23, $3d, $14, $7e, $42, $fe, $3b, $36, $1b, $23, $13, $13, $13, $7e, $42, $ff

; -----------------------------------------------------------------------------
; Message $2E: Kawamura challenge
; ends with control $fc before $ff
; だあーっ！ きもちわりーなー！！
; きょうは ひごろの うらみを
; はらすために しょうぶだ！
; ホールで まっているぞ！！

Message_2E_KawamuraChallenge::
    db $45, $1f, $10, $7e, $22, $7d, $00, $16, $33, $20, $3f, $35, $7e, $25, $7e, $7d
    db $7d, $fe, $16, $3e, $12, $2a, $00, $2b, $45, $19, $38, $29, $00, $12, $34, $30
    db $41, $fe, $2a, $34, $1c, $1f, $32, $26, $00, $1b, $3e, $12, $45, $2c, $45, $1f
    db $7d, $fe, $69, $7e, $77, $45, $23, $00, $2f, $22, $23, $11, $36, $45, $1e, $7d
    db $7d, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $2F: Shin-chan after Kawamura leaves
; ううーん オラだって わるぎが
; あったわけじゃないしー
; ううーん いやーん い．け．ずー
; [control $fc]
; ．．あれ？ いなくなっちゃった

Message_2F_ShinchanAfterKawamuraLeaves::
    db $12, $12, $7e, $42, $00, $4e, $75, $45, $1f, $22, $23, $00, $3f, $36, $45, $16
    db $45, $15, $fe, $10, $22, $1f, $3f, $18, $45, $1b, $3a, $25, $11, $1b, $7e, $fe
    db $12, $12, $7e, $42, $00, $11, $39, $7e, $42, $00, $11, $44, $18, $44, $45, $1c
    db $7e, $fe, $fc, $44, $44, $10, $37, $7f, $00, $11, $25, $17, $25, $22, $20, $3a
    db $22, $1f, $ff

; -----------------------------------------------------------------------------
; Message $30: Kawamura loses again
; $06=２, $07=３, $08=４; quote glyphs are shown here as 「」.
; うわーん！
; 「しんちゃん２」「３」に
; ひきつづいて 「４」でも
; また まけちまったあー！

Message_30_KawamuraLosesAgain::
    db $12, $3f, $7e, $42, $7d, $fe, $68, $1b, $42, $20, $3a, $42, $06, $71, $68, $07
    db $71, $26, $fe, $2b, $16, $21, $45, $21, $11, $23, $00, $68, $08, $71, $45, $23
    db $33, $fe, $2f, $1f, $00, $2f, $18, $20, $2f, $22, $1f, $10, $7e, $7d, $ff

; -----------------------------------------------------------------------------
; Message $31: Kawamura retry prompt
; つぎだ！ つぎこそ オレさまが
; かってみせるぞー！
; しんのすけ！
; ステージ<VAR> もういちど やれ！

Message_31_KawamuraRetry::
    db $21, $45, $16, $45, $1f, $7d, $00, $21, $45, $16, $19, $1e, $00, $4e, $78, $1a
    db $2f, $45, $15, $fe, $15, $22, $23, $30, $1d, $36, $45, $1e, $7e, $7d, $fe, $1b
    db $42, $29, $1c, $18, $7d, $fe, $57, $5e, $7e, $45, $56, $fd, $00, $33, $12, $11
    db $20, $45, $24, $00, $39, $37, $7d, $ff

; -----------------------------------------------------------------------------
; Message $32: password text
; わがままだなあ

Message_32_Password_WagamamaDanaa::
    db $3f, $45, $15, $2f, $2f, $45, $1f, $25, $10, $ff

; -----------------------------------------------------------------------------
; Message $33: stage number text
; ステージ<VAR>

Message_33_StageNumberText::
    db $57, $5e, $7e, $45, $56, $fd, $ff

; -----------------------------------------------------------------------------
; Message $34: Action Kamen show intro
; よかったわねー しんちゃん
; あこがれの アクションかめんに
; あえるわよ！

Message_34_ActionKamenShowIntro::
    db $3d, $15, $22, $1f, $3f, $28, $7e, $00, $1b, $42, $20, $3a, $42, $fe, $10, $19
    db $45, $15, $37, $29, $00, $46, $52, $56, $74, $7c, $15, $32, $42, $26, $fe, $10
    db $13, $36, $3f, $3d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $35: Hiroshi embarrassed
; はずかしいから はしゃぐなよ
; みさえ

Message_35_HiroshiEmbarrassed::
    db $2a, $45, $1c, $15, $1b, $11, $15, $34, $00, $2a, $1b, $3a, $45, $17, $25, $3d
    db $fe, $30, $1a, $13, $ff

; -----------------------------------------------------------------------------
; Message $36: Misae tells Shin-chan to go
; あんたが いきたいってゆーから
; きたんでしょーが！
; はやく いってきなさい！！

Message_36_MisaeTellsShinchanToGo::
    db $10, $42, $1f, $45, $15, $00, $11, $16, $1f, $11, $22, $23, $3b, $7e, $15, $34
    db $fe, $16, $1f, $42, $45, $23, $1b, $3e, $7e, $45, $15, $7d, $fe, $2a, $39, $17
    db $00, $11, $22, $23, $16, $25, $1a, $11, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $37: Ho-hoi
; ホッホーイ

Message_37_HoHoi::
    db $69, $5d, $69, $7e, $48, $ff

; -----------------------------------------------------------------------------
; Message $38: Action Kamen show already started
; おおっ もう はじまっているゾー
; がんばれ アクションかめーん！！

Message_38_ActionKamenShowAlreadyStarted::
    db $14, $14, $22, $00, $33, $12, $00, $2a, $45, $1b, $2f, $22, $23, $11, $36, $45
    db $59, $7e, $fe, $45, $15, $42, $45, $2a, $37, $00, $46, $52, $56, $74, $7c, $15
    db $32, $7e, $42, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $39: Action Great Beam
; ends with control $fc before $ff
; くらえ ブラックメケメケだん！
; アクション グレートビーム！！！

Message_39_ActionGreatBeam::
    db $17, $34, $13, $00, $45, $67, $75, $5d, $52, $6d, $53, $6d, $53, $45, $1f, $42
    db $7d, $fe, $46, $52, $56, $74, $7c, $00, $45, $52, $78, $7e, $5f, $45, $66, $7e
    db $6c, $7d, $7d, $7d, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $3A: Action Kamen victory
; みたか せいぎのちからを！
; わたしが いるかぎり
; ちきゅうは へいわで
; ありつづけるのだ！！

Message_3A_ActionKamenVictory::
    db $30, $1f, $15, $00, $1d, $11, $45, $16, $29, $20, $15, $34, $41, $7d, $fe, $3f
    db $1f, $1b, $45, $15, $00, $11, $36, $15, $45, $16, $35, $fe, $20, $16, $3c, $12
    db $2a, $00, $2d, $11, $3f, $45, $23, $fe, $10, $35, $21, $45, $21, $18, $36, $29
    db $45, $1f, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $3B: Action Kamen laugh
; ワーッハッハッハッハッハッ
; ワーッハッハッハッハッハッ！！！

Message_3B_ActionKamenLaugh::
    db $7a, $7e, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $fe, $7a, $7e
    db $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $7d, $7d, $7d, $ff


; -----------------------------------------------------------------------------
; Message $3C: turbo stage clear password prompt
;  ステージ<VAR>ターボ おしまい
;      パスワード

Message_3C_TurboStageClearPassword::
    db $00, $57, $5e, $7e, $45, $56, $fd, $5a, $7e, $45, $69, $00, $14, $1b, $2f, $11
    db $fe, $00, $00, $00, $00, $00, $43, $65, $57, $7a, $7e, $45, $5f, $ff


; -----------------------------------------------------------------------------
; Message $3D: Guam excitement
; ホッホーイ
; グアム グアムー

Message_3D_GuamExcitement::
    db $69, $5d, $69, $7e, $48, $fe, $45, $52, $46, $6c, $00, $45, $52, $46, $6c, $7e
    db $ff

; -----------------------------------------------------------------------------
; Message $3E: arrived after a long trip
; ふうーっ なんとか ついたぞ
; ながい みちのりだった．．．

Message_3E_ArrivedAfterLongTrip::
    db $2c, $12, $7e, $22, $00, $25, $42, $24, $15, $00, $21, $11, $1f, $45, $1e, $fe
    db $25, $45, $15, $11, $00, $30, $20, $29, $35, $45, $1f, $22, $1f, $44, $44, $44
    db $ff

; -----------------------------------------------------------------------------
; Message $3F: what is Guam?
; で グアムって なに？
; オラに かんけいあるもの？

Message_3F_WhatIsGuam::
    db $45, $23, $00, $45, $52, $46, $6c, $22, $23, $00, $25, $26, $7f, $fe, $4e, $75
    db $26, $00, $15, $42, $18, $11, $10, $36, $33, $29, $7f, $ff

; -----------------------------------------------------------------------------
; Message $40: Misae expected that
; やっぱり そんなことだろうと
; おもったわよ

Message_40_MisaeExpectedThat::
    db $39, $22, $43, $2a, $35, $00, $1e, $42, $25, $19, $24, $45, $1f, $38, $12, $24
    db $fe, $14, $33, $22, $1f, $3f, $3d, $ff

; -----------------------------------------------------------------------------
; Message $41: gals
; ends with control $fc before $ff
; お ギャル

Message_41_Gals::
    db $14, $00, $45, $51, $70, $77, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $42: Hiroshi calls Shin-chan
; お．おい しんのすけー！

Message_42_HiroshiCallsShinchan::
    db $14, $44, $14, $11, $00, $1b, $42, $29, $1c, $18, $7e, $7d, $ff

; -----------------------------------------------------------------------------
; Message $43: Misae expected trouble
; やっぱり こんなことに
; なるだろうと おもったわよ．．．

Message_43_MisaeExpectedTrouble::
    db $39, $22, $43, $2a, $35, $00, $19, $42, $25, $19, $24, $26, $fe, $25, $36, $45
    db $1f, $38, $12, $24, $00, $14, $33, $22, $1f, $3f, $3d, $44, $44, $44, $ff

; -----------------------------------------------------------------------------
; Message $44: Misae finds Shin-chan
; ends with control $fc before $ff
; あーっ いた いた！
; しんのすけ！
; あんた どこいってたのよ！？

Message_44_MisaeFindsShinchan::
    db $10, $7e, $22, $00, $11, $1f, $00, $11, $1f, $7d, $fe, $1b, $42, $29, $1c, $18
    db $7d, $fe, $10, $42, $1f, $00, $45, $24, $19, $11, $22, $23, $1f, $29, $3d, $7d
    db $7f, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $45: secret
; ないしょ

Message_45_Secret::
    db $25, $11, $1b, $3e, $ff

; -----------------------------------------------------------------------------
; Message $46: Misae angry at secret
; なにが ないしょ よ！
; ひとの き も しらないでーっ！

Message_46_MisaeAngrySecret::
    db $25, $26, $45, $15, $00, $25, $11, $1b, $3e, $00, $3d, $7d, $fe, $2b, $24, $29
    db $00, $16, $00, $33, $00, $1b, $34, $25, $11, $45, $23, $7e, $22, $7d, $ff

; -----------------------------------------------------------------------------
; Message $47: Hiroshi calms Misae
; まあ まあ
; しんのすけも グアムへ きて
; うれしかったんだよ

Message_47_HiroshiCalmsMisae::
    db $2f, $10, $00, $2f, $10, $fe, $1b, $42, $29, $1c, $18, $33, $00, $45, $52, $46
    db $6c, $2d, $00, $16, $23, $fe, $12, $37, $1b, $15, $22, $1f, $42, $45, $1f, $3d
    db $ff

; -----------------------------------------------------------------------------
; Message $48: time to go home
; [control $fc]
; さっ もう かえるじかんだ
; たのしかったか？ しんのすけ

Message_48_TimeToGoHome::
    db $fc, $1a, $22, $00, $33, $12, $00, $15, $13, $36, $45, $1b, $15, $42, $45, $1f
    db $fe, $1f, $29, $1b, $15, $22, $1f, $15, $7f, $00, $1b, $42, $29, $1c, $18, $ff

; -----------------------------------------------------------------------------
; Message $49: Shin-chan asks Misae
; うん たのしかった
; たのしかったか？ みさえ

Message_49_ShinchanAsksMisae::
    db $12, $42, $00, $1f, $29, $1b, $15, $22, $1f, $fe, $1f, $29, $1b, $15, $22, $1f
    db $15, $7f, $00, $30, $1a, $13, $ff

; -----------------------------------------------------------------------------
; Message $4A: stop imitating dad
; あーっ もお！
; パパの くちまねは
; やめなさーい！！

Message_4A_StopImitatingDad::
    db $10, $7e, $22, $00, $33, $14, $7d, $fe, $43, $65, $43, $65, $29, $00, $17, $20
    db $2f, $28, $2a, $fe, $39, $32, $25, $1a, $7e, $11, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $4B/$4D: press Start prompt
; スタートおせば？

; -----------------------------------------------------------------------------
; Message $4D aliases Message $4B
; スタートおせば？

Message_4B_PressStartPrompt::
Message_4D_PressStartPrompt_Alias::
    db $57, $5a, $7e, $5f, $14, $1d, $45, $2a, $7f, $ff

; -----------------------------------------------------------------------------
; Message $4E: title text
;    クレヨンしんちゃん４
;  ーオラのいたずらだいへんしんー

Message_4E_TitleText::
    db $00, $00, $00, $52, $78, $73, $7c, $1b, $42, $20, $3a, $42, $08, $fe, $00, $7e
    db $4e, $75, $29, $11, $1f, $45, $1c, $34, $45, $1f, $11, $2d, $42, $1b, $42, $7e
    db $ff

; -----------------------------------------------------------------------------
; Message $4F: credit original author
;   ゲンサク
; うすい よしと

Message_4F_CreditOriginalAuthor::
    db $00, $00, $45, $53, $7c, $55, $52, $fe, $12, $1c, $11, $00, $3d, $1b, $24, $ff

; -----------------------------------------------------------------------------
; Message $50: producer credit
; プロデューサー
; さとう つよし

Message_50_CreditProducer::
    db $43, $67, $79, $45, $5e, $72, $7e, $55, $7e, $fe, $1a, $24, $12, $00, $21, $3d
    db $1b, $ff

; -----------------------------------------------------------------------------
; Message $51: special thanks
; スペシャル サンクス
;  やすかわ たけし
;  いそがい たけお

Message_51_CreditSpecialThanks1::
    db $57, $43, $2d, $56, $70, $77, $00, $55, $7c, $52, $57, $fe, $00, $39, $1c, $15
    db $3f, $00, $1f, $18, $1b, $fe, $00, $11, $1e, $45, $15, $11, $00, $1f, $18, $14
    db $ff

; -----------------------------------------------------------------------------
; Message $52: special thanks
; スペシャル サンクス
;  まえはた ただたか
;   あらい まさゆき

Message_52_CreditSpecialThanks2::
    db $57, $43, $2d, $56, $70, $77, $00, $55, $7c, $52, $57, $fe, $00, $2f, $13, $2a
    db $1f, $00, $1f, $45, $1f, $1f, $15, $fe, $00, $00, $10, $34, $11, $00, $2f, $1a
    db $3b, $16, $ff

; -----------------------------------------------------------------------------
; Message $53: coordinator credit
; コーディネーター
;  しみちょん

Message_53_CreditCoordinator::
    db $54, $7e, $45, $5e, $49, $63, $7e, $5a, $7e, $fe, $00, $1b, $30, $20, $3e, $42
    db $ff

; -----------------------------------------------------------------------------
; Message $54: programmer credit
; プログラマー
;  はうあん
;  よしふみ

Message_54_CreditProgrammer::
    db $43, $67, $79, $45, $52, $75, $6a, $7e, $fe, $00, $2a, $12, $10, $42, $fe, $00
    db $3d, $1b, $2c, $30, $ff

; -----------------------------------------------------------------------------
; Message $55: designer credit
; デザイナー
;  かっけー

Message_55_CreditDesigner::
    db $45, $5e, $45, $55, $48, $60, $7e, $fe, $00, $15, $22, $18, $7e, $ff

; -----------------------------------------------------------------------------
; Message $56: composer credit
;    コンポーザー
; ブーイング ブー みずたに

Message_56_CreditComposer::
    db $00, $00, $00, $54, $7c, $43, $69, $7e, $45, $55, $7e, $fe, $45, $67, $7e, $48
    db $7c, $45, $52, $00, $45, $67, $7e, $00, $30, $45, $1c, $1f, $26, $ff

; -----------------------------------------------------------------------------
; Message $57: test players credit
; Some glyphs in this credit still use tentative mappings.
; テスト プレイヤーズ
;   オニキス
; ビッグメン  ばじ

Message_57_CreditTestPlayers::
    db $5e, $57, $5f, $00, $43, $67, $78, $48, $6f, $7e, $45, $57, $fe, $00, $00, $4e
    db $61, $51, $57, $fe, $4c, $5d, $45, $52, $6d, $7c, $00, $00, $45, $2a, $45, $1b
    db $ff

; -----------------------------------------------------------------------------
; Message $58: presents by
; プレゼンツ バイ
;   バンダイ

Message_58_CreditPresentsBy::
    db $43, $67, $78, $45, $58, $7c, $5c, $00, $45, $65, $48, $fe, $00, $00, $45, $65
    db $7c, $45, $5a, $48, $ff

; -----------------------------------------------------------------------------
; Message $59: ending text
; おしまい

Message_59_CreditEnd::
    db $14, $1b, $2f, $11, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff

; -----------------------------------------------------------------------------
; Message $5A: password / hard loop hint
; $06 is used here as ２.
;   「おべんきでね」
; パスワードがめんで
; うえの パスワードを
; にゅうりょくしてみよう！
; ちょっと むずかしい
; ２しゅうめ が
; はじまるゾ！

Message_5A_PasswordHardModeHint::
    db $00, $00, $68, $14, $45, $2d, $42, $16, $45, $23, $28, $71, $fe, $43, $65, $57
    db $7a, $7e, $45, $5f, $45, $15, $32, $42, $45, $23, $fe, $12, $13, $29, $00, $43
    db $65, $57, $7a, $7e, $45, $5f, $41, $fe, $26, $3c, $12, $35, $3e, $17, $1b, $23
    db $30, $3d, $12, $7d, $fe, $20, $3e, $22, $24, $00, $31, $45, $1c, $15, $1b, $11
    db $fe, $06, $1b, $3c, $12, $32, $00, $45, $15, $fe, $2a, $45, $1b, $2f, $36, $45
    db $59, $7d, $ff


MessageText_5b::
; Message text referenced by descriptor $5b.
    db $00, $68, $1b, $42, $20, $3a

    db $42, $1f, $10, $45, $2e, $71, $fe, $43, $65, $57, $7a, $7e, $45, $5f, $45, $15
    db $32, $42, $45, $23, $fe, $12, $13, $29, $00, $43, $65, $57, $7a, $7e, $45, $5f
    db $41, $fe, $26, $3c, $12, $35, $3e, $17, $1b, $23, $30, $3d

    db $12, $7d, $fe, $1c, $45, $19, $11, $00, $2a, $39, $1a, $29, $fe, $4e

    db $75, $45, $15, $00, $1f, $29, $1b, $32, $36, $45, $59, $7d, $ff

; -----------------------------------------------------------------------------
; Message $5D: clear congratulations
;  クリアーおめでとう！
; オラのぼうけん
; たのしんでもらえたかな？
; またオラと あそんでね！
; じゃ！

Message_5D_ClearCongratulations::
    db $00, $52, $76, $46, $7e, $14, $32, $45, $23, $24, $12, $7d, $fe, $4e, $75, $29
    db $45, $2e, $12, $18, $42

    db $fe, $1f, $29, $1b, $42, $45, $23, $33, $34, $13, $1f, $15, $25

    db $7f, $fe, $2f, $1f, $4e, $75, $24, $00, $10, $1e, $42, $45, $23, $28, $7d

    db $fe, $45, $1b, $3a, $7d, $ff

; -----------------------------------------------------------------------------
; Message $5E: tutorial move and jump
; $0F = D-pad icon, $40 = A button icon.
; {D-Pad}キーでオラを うごかして
; {A}ボタンで ジャンプ！

Message_5E_TutorialMoveAndJump::
    db $0f, $51, $7e, $45, $23, $4e, $75, $41, $00, $12, $45, $19, $15, $1b, $23, $fe
    db $40, $45, $69, $5a, $7c, $45, $23, $00, $45, $56, $70, $7c, $43, $67, $7d, $ff


; -----------------------------------------------------------------------------
; Message $5F: tutorial stomp enemies
; いじめっこたちは ふんづけて
; やっつけちゃえ！

Message_5F_TutorialStompEnemies::
    db $11, $45, $1b, $32, $22, $19, $1f, $20, $2a

    db $00, $2c, $42, $45, $21, $18, $23, $fe, $39, $22, $21, $18, $20, $3a, $13, $7d
    db $ff

; -----------------------------------------------------------------------------
; Message $60: tutorial transformation basics
; へんしんセットを とれば いろんな
; オラに へんしんするけど きほんてき
; な そうさは だいたい おなじ！

Message_60_TutorialTransformationBasics::
    db $2d, $42, $1b, $42, $58, $5d, $5f, $41, $00, $24, $37, $45, $2a, $00, $11, $38
    db $42, $25, $fe, $4e, $75, $26, $00, $2d, $42

    db $1b, $42, $1c, $36, $18, $45, $24, $00, $16, $2e, $42, $23, $16, $fe, $25, $00
    db $1e, $12, $1a, $2a, $00, $45, $1f, $11, $1f, $11, $00, $14, $25, $45, $1b, $7d
    db $ff

; -----------------------------------------------------------------------------
; Message $61: tutorial flying squirrel jump
;    「むささびしんちゃん」
; ジャンプして {A}ボタンを れんだ
; すれば そらをとべるゾ！

Message_61_TutorialFlyingSquirrelJump::
    db $00, $00, $00

    db $68, $31, $1a, $1a, $45, $2b, $1b, $42, $20, $3a

    db $42, $71, $fe, $45, $56, $70, $7c, $43, $67, $1b, $23, $00, $40, $45, $69, $5a
    db $7c, $41, $00, $37, $42, $45, $1f, $fe, $1c, $37, $45, $2a, $00, $1e, $34, $41
    db $24, $45, $2d, $36, $45, $59, $7d, $ff

; -----------------------------------------------------------------------------
; Message $62: tutorial flying squirrel attack
; $7B = B button icon.
;    「むささびしんちゃん」
; {B}ボタンで このは を なげて
; こうげきだ！

Message_62_TutorialFlyingSquirrelAttack::
    db $00, $00, $00, $68, $31, $1a, $1a, $45, $2b, $1b, $42, $20, $3a

    db $42, $71, $fe, $7b, $45

    db $69, $5a, $7c, $45, $23, $00, $19, $29, $2a, $00, $41, $00, $25, $45, $18, $23

    db $fe, $19, $12, $45, $18, $16

    db $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $63: tutorial chicken jump
;    「にわとりしんちゃん」
; いつもより たかくジャンプできるから
; たかい ばしょにも すぐとどくゾ！

Message_63_TutorialChickenJump::
    db $00, $00, $00, $68, $26, $3f, $24, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $11, $21, $33, $3d, $35, $00, $1f, $15, $17, $45

    db $56, $70

    db $7c, $43, $67, $45, $23, $16, $36, $15, $34, $fe, $1f, $15, $11, $00, $45, $2a
    db $1b, $3e, $26, $33, $00, $1c, $45, $17, $24, $45, $24, $17, $45, $59, $7d, $ff

; -----------------------------------------------------------------------------
; Message $64: tutorial chicken attack
;    「にわとりしんちゃん」
; {B}ボタンで たまごを ころがして
; こうげきだ！

Message_64_TutorialChickenAttack::
    db $00, $00, $00, $68, $26, $3f, $24, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $7b, $45, $69, $5a, $7c, $45, $23, $00, $1f, $2f, $45, $19, $41
    db $00, $19, $38, $45

    db $15, $1b, $23, $fe, $19, $12, $45, $18, $16

    db $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $65: tutorial cockroach narrow passage
;    「ごきぶりしんちゃん」
; せまくて とおれない ばしょも
; これなら だいじょうぶ！

Message_65_TutorialCockroachNarrowPassage::
    db $00, $00, $00, $68, $45, $19, $16, $45, $2c, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $1d

    db $2f, $17, $23, $00, $24, $14, $37

    db $25, $11, $00, $45, $2a, $1b, $3e, $33, $fe, $19, $37, $25, $34, $00, $45, $1f
    db $11, $45, $1b, $3e, $12, $45, $2c, $7d, $ff

; -----------------------------------------------------------------------------
; Message $66: tutorial cockroach attack
;    「ごきぶりしんちゃん」
; {B}ボタンで しょっかくを のばして
; こうげきだ！

Message_66_TutorialCockroachAttack::
    db $00, $00, $00, $68, $45, $19

    db $16, $45, $2c, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $7b, $45, $69, $5a, $7c

    db $45, $23, $00, $1b, $3e, $22, $15, $17, $41, $00, $29, $45, $2a, $1b, $23, $fe
    db $19, $12, $45, $18, $16

    db $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $67: tutorial outro
; オラのうごかしかた わかったかな？
; それでは オラの ぼうけんの
; はじまり はじまりー！

Message_67_TutorialOutro::
    db $4e, $75, $29, $12, $45, $19, $15, $1b, $15, $1f, $00, $3f, $15, $22, $1f, $15
    db $25, $7f

    db $fe, $1e, $37, $45, $23, $2a, $00

    db $4e, $75, $29, $00, $45, $2e, $12, $18, $42

    db $29, $fe, $2a, $45, $1b, $2f, $35, $00, $2a, $45, $1b, $2f, $35, $7e, $7d, $ff

MessageText_67::
; Message text referenced by descriptor $67.
    db $52, $78, $73, $7c, $1b, $42, $20, $3a

    db $42, $08, $fe, $01, $01, $4e, $75, $29, $11, $1f, $45, $1c, $34, $fe, $fc, $01
    db $01, $45, $1f, $11, $2d, $42, $1b, $42, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01

    db $fe, $01, $01, $01, $45, $53, $7c, $55, $52, $fe, $01, $12, $1c, $11, $01, $3d

    db $1b, $24, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $43, $67, $79, $45
    db $5e, $72, $7e, $55, $7e, $fe, $01, $1a, $24, $12, $01, $21, $3d, $1b, $fe, $01
    db $fe, $01, $fe, $01, $fe, $57, $43, $2d, $56, $70, $77, $01, $55, $7c, $52, $57
    db $fe, $01, $39, $1c, $15, $3f, $01, $1f, $18, $1b, $fe, $01, $11, $1e, $45, $15
    db $11, $01, $1f, $18, $14

    db $fe, $01, $2f, $13, $2a, $1f, $01, $1f, $45, $1f, $1f, $15, $fe, $01, $01, $10
    db $34, $11, $01, $2f

    db $1a, $3b, $16, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $fc, $01, $fe, $01
    db $fe, $01, $fe, $01, $fe, $01, $54, $7e, $45, $5e, $49, $63, $7e, $5a, $7e, $fe
    db $01, $01, $1b, $30, $20, $3e

    db $42, $fe, $01, $fe, $01, $fe, $fc, $01, $fe, $01, $01, $43, $67, $79, $45, $52
    db $75, $6a, $7e, $fe, $01, $01, $01, $2a, $12, $10, $42, $fe, $01, $01, $01, $3d
    db $1b, $2c

    db $30, $fe

    db $01, $fe, $01, $fe, $01, $fe, $01, $01, $45, $5e, $45, $55, $48, $60, $7e, $fe
    db $01, $01, $01, $15, $22, $18, $7e

    db $fe, $01, $fe, $01, $fe, $01, $fe, $01, $01, $54, $7c, $43, $69, $7e, $45, $55
    db $7e, $fe, $01, $45, $67, $7e, $48, $7c, $45, $52, $01, $45, $67, $7e, $fe, $01
    db $01, $01, $30, $45, $1c, $1f, $26, $fe, $01, $fe, $01, $fe, $01, $fe, $5e, $57
    db $5f, $01, $43, $67, $78, $48, $6f, $7e, $45, $57, $fe, $01, $01, $4e, $61, $51
    db $57, $fe, $01, $01, $4c, $5d, $45, $52, $6d, $7c, $fe, $01, $01, $01, $45, $2a
    db $45, $1b, $fe, $01, $fe, $01, $fe, $01, $fe, $fc, $01, $fe, $01, $fe, $01, $fe
    db $01, $fe, $01, $fe, $01, $43, $67, $78, $45, $58, $7c, $5c, $01, $45, $65, $48
    db $fe, $01, $01, $01, $45, $65, $7c, $45, $5a, $48, $fe, $01, $fe, $01

    db $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $01, $01, $14, $1b, $2f, $11, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $fe, $01, $ff


MessageText_68::
; Message text referenced by descriptor $68.
    db $fd, $58, $5d, $5f, $ff


MessageText_69::
; Message text referenced by descriptor $69.
    db $21, $45, $21, $16, $39, $36, $7f, $ff

MessageText_6a::
; Message text referenced by descriptor $6a.
    db $4e, $75, $39, $36, $45, $1e, $fe, $16, $3e, $12, $2a, $39, $32, $24, $17, $ff

MessageSubstitutionText_00::
    db $04, $ff


MessageSubstitutionText_01::
    db $05, $ff

MessageSubstitutionText_02::
    db $06, $ff

MessageSubstitutionText_03::
    db $07, $ff

MessageSubstitutionText_04::
    db $08, $ff


MessageSubstitutionText_05::
    db $09, $ff

MessageSubstitutionText_06::
    db $0a, $ff

MessageSubstitutionText_07::
    db $0b, $ff

MessageSubstitutionText_08::
    db $0c, $ff

MessageSubstitutionText_09::
    db $0d, $ff

MessageSubstitutionText_0a::
    db $c5, $ff


MessageSubstitutionText_0b::
    db $31, $1a, $1a, $45, $2b, $ff

MessageSubstitutionText_0c::
    db $45, $19, $16, $45, $2c, $35, $ff

MessageSubstitutionText_0d::
    db $26, $3f, $24

; -----------------------------------------------------------------------------
; Message VRAM/text pointer table at $5F2F
; Each message id uses two consecutive word entries: VRAM destination and text pointer.
MessageSubstitutionLastGlyph::
    db $35, $ff


MessageDescriptorTable::
    dw _SCRN0 + $000, MessageText_00 ; message $00
    dw _SCRN0 + $0a3, MessageText_01 ; message $01
    dw _SCRN0 + $0a3, MessageText_02 ; message $02
    dw _SCRN0 + $0a3, MessageText_03 ; message $03
    dw _SCRN0 + $0a3, MessageText_04 ; message $04
    dw _SCRN0 + $0a3, MessageText_05 ; message $05
    dw _SCRN0 + $0a3, MessageText_06 ; message $06
    dw _SCRN0 + $0a3, MessageText_07 ; message $07
    dw _SCRN0 + $0a3, MessageText_08 ; message $08
    dw _SCRN0 + $044, MessageText_09 ; message $09
    dw _SCRN0 + $044, MessageText_0a ; message $0a
    dw _SCRN0 + $044, MessageText_0b ; message $0b
    dw _SCRN0 + $0a3, MessageText_0c ; message $0c
    dw _SCRN0 + $1a6, MessageText_0d ; message $0d
    dw _SCRN0 + $1a6, MessageText_0e ; message $0e
    dw _SCRN0 + $0a6, MessageText_0f ; message $0f
    dw _SCRN0 + $228, MessageText_10 ; message $10
    dw _SCRN0 + $228, MessageText_11 ; message $11
    dw _SCRN0 + $228, MessageText_12 ; message $12
    dw _SCRN0 + $228, MessageText_13 ; message $13
    dw _SCRN0 + $148, Message_4C_LevelText ; message $14
    dw _SCRN0 + $084, MessageText_15 ; message $15
    dw _SCRN0 + $084, MessageText_16 ; message $16
    dw _SCRN0 + $084, MessageText_17 ; message $17
    dw _SCRN0 + $084, MessageText_18 ; message $18
    dw _SCRN0 + $22c, MessageText_19 ; message $19
    dw _SCRN0 + $0e7, MessageText_1a ; message $1a
    dw _SCRN0 + $0e7, MessageText_1b ; message $1b
    dw _SCRN0 + $083, Message_1C_Stage1Intro ; message $1c
    dw _SCRN0 + $083, Message_1D_Stage2Intro ; message $1d
    dw _SCRN0 + $083, Message_1E_Stage3Intro ; message $1e
    dw _SCRN0 + $083, Message_1F_Stage4Intro ; message $1f
    dw _SCRN0 + $042, Message_20_TakeshiStealsChocobi ; message $20
    dw _SCRN0 + $042, Message_21_ShinchanMetaIntro ; message $21
    dw _SCRN0 + $042, Message_22_TakeshiRunsAway ; message $22
    dw _SCRN0 + $042, Message_23_TutorialLeadIn ; message $23
    dw _SCRN0 + $042, Message_24_TakeshiReturnsChocobi ; message $24
    dw _SCRN0 + $042, Message_25_ChocobiRecovered ; message $25
    dw _SCRN0 + $042, Message_26_DrinkSound ; message $26
    dw _SCRN0 + $042, Message_27_DrinkReaction ; message $27
    dw _SCRN0 + $042, Message_28_ChocobiAfterSweat ; message $28
    dw _SCRN0 + $042, Message_29_StageClearPassword ; message $29
    dw _SCRN0 + $042, Message_2A_KawamuraAppears ; message $2a
    dw _SCRN0 + $042, Message_2B_WhoAreYou ; message $2b
    dw _SCRN0 + $042, Message_2C_KawamuraIntroducesHimself ; message $2c
    dw _SCRN0 + $042, Message_2D_ShinchanTeasesKawamura ; message $2d
    dw _SCRN0 + $042, Message_2E_KawamuraChallenge ; message $2e
    dw _SCRN0 + $042, Message_2F_ShinchanAfterKawamuraLeaves ; message $2f
    dw _SCRN0 + $042, Message_30_KawamuraLosesAgain ; message $30
    dw _SCRN0 + $042, Message_31_KawamuraRetry ; message $31
    dw _SCRN0 + $042, Message_32_Password_WagamamaDanaa ; message $32
    dw _SCRN0 + $047, Message_33_StageNumberText ; message $33
    dw _SCRN0 + $042, Message_34_ActionKamenShowIntro ; message $34
    dw _SCRN0 + $042, Message_35_HiroshiEmbarrassed ; message $35
    dw _SCRN0 + $042, Message_36_MisaeTellsShinchanToGo ; message $36
    dw _SCRN0 + $042, Message_37_HoHoi ; message $37
    dw _SCRN0 + $042, Message_38_ActionKamenShowAlreadyStarted ; message $38
    dw _SCRN0 + $042, Message_39_ActionGreatBeam ; message $39
    dw _SCRN0 + $042, Message_3A_ActionKamenVictory ; message $3a
    dw _SCRN0 + $042, Message_3B_ActionKamenLaugh ; message $3b
    dw _SCRN0 + $042, Message_3C_TurboStageClearPassword ; message $3c
    dw _SCRN0 + $042, Message_3D_GuamExcitement ; message $3d
    dw _SCRN0 + $042, Message_3E_ArrivedAfterLongTrip ; message $3e
    dw _SCRN0 + $042, Message_3F_WhatIsGuam ; message $3f
    dw _SCRN0 + $042, Message_40_MisaeExpectedThat ; message $40
    dw _SCRN0 + $042, Message_41_Gals ; message $41
    dw _SCRN0 + $042, Message_42_HiroshiCallsShinchan ; message $42
    dw _SCRN0 + $042, Message_43_MisaeExpectedTrouble ; message $43
    dw _SCRN0 + $042, Message_44_MisaeFindsShinchan ; message $44
    dw _SCRN0 + $042, Message_45_Secret ; message $45
    dw _SCRN0 + $042, Message_46_MisaeAngrySecret ; message $46
    dw _SCRN0 + $042, Message_47_HiroshiCalmsMisae ; message $47
    dw _SCRN0 + $042, Message_48_TimeToGoHome ; message $48
    dw _SCRN0 + $042, Message_49_ShinchanAsksMisae ; message $49
    dw _SCRN0 + $042, Message_4A_StopImitatingDad ; message $4a
    dw _SCRN0 + $042, Message_4B_PressStartPrompt ; message $4b
    dw _SCRN0 + $3e8, Message_4C_LevelText ; message $4c
    dw _SCRN0 + $3e6, Message_4B_PressStartPrompt ; message $4d
    dw _SCRN1 + $042, Message_4E_TitleText ; message $4e
    dw _SCRN1 + $046, Message_4F_CreditOriginalAuthor ; message $4f
    dw _SCRN1 + $046, Message_50_CreditProducer ; message $50
    dw _SCRN1 + $045, Message_51_CreditSpecialThanks1 ; message $51
    dw _SCRN1 + $045, Message_52_CreditSpecialThanks2 ; message $52
    dw _SCRN1 + $046, Message_53_CreditCoordinator ; message $53
    dw _SCRN1 + $047, Message_54_CreditProgrammer ; message $54
    dw _SCRN1 + $047, Message_55_CreditDesigner ; message $55
    dw _SCRN1 + $044, Message_56_CreditComposer ; message $56
    dw _SCRN1 + $045, Message_57_CreditTestPlayers ; message $57
    dw _SCRN1 + $046, Message_58_CreditPresentsBy ; message $58
    dw _SCRN1 + $048, Message_59_CreditEnd ; message $59
    dw _SCRN0 + $044, Message_5A_PasswordHardModeHint ; message $5a
    dw _SCRN0 + $044, MessageText_5b ; message $5b
    dw _SCRN0 + $044, Message_5D_ClearCongratulations ; message $5c
    dw _SCRN1 + $041, Message_5E_TutorialMoveAndJump ; message $5d
    dw _SCRN1 + $041, Message_5F_TutorialStompEnemies ; message $5e
    dw _SCRN1 + $041, Message_60_TutorialTransformationBasics ; message $5f
    dw _SCRN1 + $041, Message_61_TutorialFlyingSquirrelJump ; message $60
    dw _SCRN1 + $041, Message_62_TutorialFlyingSquirrelAttack ; message $61
    dw _SCRN1 + $041, Message_63_TutorialChickenJump ; message $62
    dw _SCRN1 + $041, Message_64_TutorialChickenAttack ; message $63
    dw _SCRN1 + $041, Message_65_TutorialCockroachNarrowPassage ; message $64
    dw _SCRN1 + $041, Message_66_TutorialCockroachAttack ; message $65
    dw _SCRN1 + $041, Message_67_TutorialOutro ; message $66
    dw _SCRN0 + $329, MessageText_67 ; message $67
    dw _SCRN0 + $0e6, MessageText_68 ; message $68
    dw _SCRN0 + $0a7, MessageText_69 ; message $69
    dw _SCRN0 + $188, MessageText_6a ; message $6a

MessageSubstitutionPointers::
    dw MessageSubstitutionText_00 ; substitution $00
    dw MessageSubstitutionText_01 ; substitution $01
    dw MessageSubstitutionText_02 ; substitution $02
    dw MessageSubstitutionText_03 ; substitution $03
    dw MessageSubstitutionText_04 ; substitution $04
    dw MessageSubstitutionText_05 ; substitution $05
    dw MessageSubstitutionText_06 ; substitution $06
    dw MessageSubstitutionText_07 ; substitution $07
    dw MessageSubstitutionText_08 ; substitution $08
    dw MessageSubstitutionText_09 ; substitution $09
    dw MessageSubstitutionText_0a ; substitution $0a
    dw MessageSubstitutionText_0b ; substitution $0b
    dw MessageSubstitutionText_0c ; substitution $0c
    dw MessageSubstitutionText_0d ; substitution $0d
    dw MessageDescriptorTable ; substitution $0e
    dw MessageDescriptorTable ; substitution $0f

UiMetasprite_7b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $00, $00, $e9, $00, $01, $00, $f1, $f8, $02, $00, $f1, $00, $03, $00
    db $f9, $f9, $04, $20, $f9, $00, $04, $00, $80


UiMetasprite_7c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $05, $00, $e9, $00, $06, $00, $f1, $f8, $07, $00, $f1, $00, $08, $00
    db $f9, $f8, $09, $00, $f9, $00, $0a, $00, $80

UiMetasprite_7d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $05, $00, $e9, $00, $06
    db $00, $f1, $f8, $0b, $00, $f1, $00, $08, $00, $f9, $f8, $09, $00, $f9, $00, $0a
    db $00, $80

UiMetasprite_7e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $0c, $00, $e9, $00, $0d, $00, $f1, $f8, $0e, $00, $f1, $00, $0f, $00
    db $f9, $f9, $04, $20, $f9, $00, $04, $00, $80

UiMetasprite_7f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $0d, $20, $e9, $00, $0c
    db $20, $f1, $f8, $0f, $20, $f1, $00, $0e, $20, $f9, $f9, $04, $20, $f9, $00, $04
    db $00, $80

UiMetasprite_80::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f6, $00, $00, $e9, $fe, $01, $00, $f1, $ee, $14, $20, $f1, $f6, $10, $00
    db $f1, $fe, $11, $00, $f9, $f8, $09, $00, $f9, $ff, $1b, $20, $80

UiMetasprite_81::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9
    db $f8, $0c, $00, $e9, $00, $0d, $00, $f1, $f8, $12, $00, $f1, $00, $13, $00, $f1
    db $08, $14, $00, $f9, $f7, $15, $00, $f9, $ff, $16, $00, $80

UiMetasprite_82::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $19, $00
    db $e9, $00, $1a, $00, $f1, $f8, $17, $00, $f1, $00, $18, $00, $f0, $08, $14, $00
    db $f9, $f7, $15, $00, $f9, $ff, $16, $00, $80

UiMetasprite_83::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ea, $f8, $05, $00, $ea, $00, $06
    db $00, $ea, $08, $1d, $00, $f2, $f8, $1e, $00, $f2, $00, $1f, $00, $f2, $08, $20
    db $00, $fa, $f8, $21, $00, $fa, $00, $22, $00, $80

UiMetasprite_84::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $05, $00, $e9, $00
    db $23, $00, $e8, $08, $1d, $00, $f1, $f8, $25, $00, $f1, $00, $26, $00, $f0, $08
    db $24, $00, $f9, $f8, $1b, $00, $f9, $00, $1c, $00, $80

UiMetasprite_85::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $27, $00, $e9
    db $00, $28, $00, $f1, $f9, $29, $20, $f1, $00, $29, $00, $f9, $f9, $16, $20, $f9
    db $00, $16, $00, $80

UiMetasprite_86::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $27, $00, $e9, $00, $28, $00, $f1, $f9, $2a, $20, $f1, $00, $2a, $00
    db $f9, $f9, $16, $20, $f9, $00, $16, $00, $80

UiMetasprite_87::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $00
    db $00, $e9, $00, $01, $00, $f1, $f8, $2b, $00, $f1, $00, $2c, $00, $f1, $08, $2d
    db $00, $f9, $f9, $04, $20, $f9, $00, $04, $00, $80

UiMetasprite_88::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $00, $00, $e9, $00
    db $01, $00, $f1, $f8, $2e, $00, $f1, $00, $2f, $00, $f9, $f9, $04, $20, $f9, $00
    db $04, $00, $80

UiMetasprite_89::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $05, $00, $e9, $00, $06, $00, $f1, $f9, $30, $00, $f1, $01, $31, $00
    db $f9, $f9, $16, $20, $f9, $00, $16, $00, $80

UiMetasprite_8a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ea, $f8, $05, $00
    db $ea, $00, $06, $00, $f2, $f9, $30, $00, $f2, $01, $31, $00, $f9, $f9, $16, $20
    db $f9, $00, $16, $00, $80

UiMetasprite_8b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ea, $f8, $05, $00, $ea, $00, $06, $00, $f1, $f0, $14
    db $20, $f2, $f8, $32, $00, $f2, $00, $33, $00, $f9, $f8, $34, $00, $f9, $00, $35
    db $00, $80

UiMetasprite_8c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $05, $00, $e9, $00, $06, $00, $f1, $f8, $36, $00, $f1, $00, $33, $00
    db $f9, $f8, $37, $00, $f9, $00, $38, $00, $80

UiMetasprite_8d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $05, $00, $e9
    db $00, $06, $00, $f1, $f8, $39, $00, $f1, $00, $33, $00, $f9, $f8, $37, $00, $f9
    db $00, $38, $00, $80

UiMetasprite_8e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $f8, $06, $20, $e9, $00, $05, $20, $f1, $f8, $3f, $20, $f1, $00, $3e, $20
    db $f9, $f8, $04, $20, $f9, $ff, $04, $00, $80

UiMetasprite_8f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f0, $3a
    db $00, $e9, $f8, $06, $20, $e9, $00, $05, $20, $f1, $f8, $3f, $20, $f1, $00, $3e
    db $20, $f9, $f8, $04, $20, $f9, $ff, $04, $00, $80

UiMetasprite_90::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e2, $ee, $3b, $00, $ea, $ee
    db $3c, $00, $ea, $f6, $3d, $00, $e9, $f8, $06, $20, $e9, $00, $05, $20, $f1, $f8
    db $3f, $20, $f1, $00, $3e, $20, $f9, $f8, $04, $20, $f9, $ff, $04, $00, $80

UiMetasprite_91::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0
    db $f8, $61, $20, $e0, $00, $60, $20, $e7, $f3, $1d, $00, $e8, $f8, $63, $20, $e8
    db $00, $62, $20, $ef, $f3, $24, $00, $ee, $f0, $14, $20, $f0, $f8, $65, $20, $f0
    db $00, $64, $20, $f8, $f8, $67, $20, $f8, $00, $66, $20, $80

UiMetasprite_92::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f8, $61, $20
    db $e0, $00, $60, $20, $e8, $f8, $69, $20, $e8, $00, $68, $20, $f0, $f8, $6b, $20
    db $f0, $00, $6a, $20, $f8, $f8, $67, $20, $f8, $ff, $67, $00, $80

UiMetasprite_93::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f8, $61
    db $20, $e0, $00, $60, $20, $e8, $f8, $63, $20, $e8, $00, $62, $20, $f0, $f8, $65
    db $20, $f0, $00, $64, $20, $f8, $f8, $66, $20, $f8, $ff, $66, $00, $80

UiMetasprite_94::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4
    db $61, $20, $e8, $fc, $60, $20, $f0, $f4, $69, $20, $f0, $fc, $68, $20, $f0, $04
    db $67, $20, $f8, $f4, $6c, $20, $f8, $fc, $6b, $20, $f8, $04, $6a, $20, $80

UiMetasprite_95::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8
    db $f4, $61, $20, $e8, $fc, $60, $20, $f0, $f4, $6e, $20, $f0, $fc, $6d, $20, $f0
    db $04, $67, $20, $f8, $f4, $6c, $20, $f8, $fc, $6b, $20, $f8, $04, $6a, $20, $80

UiMetasprite_96::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e2, $f0, $66, $20, $f8, $00, $6b, $20, $f8, $f8, $6c, $20, $f0, $00, $69, $20
    db $f0, $f8, $6a, $20, $e8, $00, $67, $20, $e8, $f8, $68, $20, $e0, $00, $64, $20
    db $e0, $f8, $65, $20, $d8, $00, $62, $20, $d8, $f8, $63, $20, $d0, $00, $60, $20
    db $d0, $f8, $61, $20, $80

UiMetasprite_97::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $d0, $fa, $6e, $20, $d0, $02, $6d, $20, $d6, $ec, $72
    db $20, $d8, $f4, $71, $20, $d8, $fc, $70, $20, $d8, $04, $6f, $20, $e0, $f4, $75
    db $20, $e0, $fc, $74, $20, $e0, $04, $73, $20, $e8, $f8, $76, $00, $e8, $00, $77
    db $00, $f0, $f5, $78, $00, $f0, $fd, $79, $00, $f0, $04, $78, $20, $f8, $f5, $7a
    db $00, $f8, $fd, $7b, $00, $f8, $04, $7a, $20, $80

UiMetasprite_98::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $00, $77, $00, $e1, $fc
    db $74, $20, $e1, $04, $73, $20, $e9, $f8, $76, $00, $d1, $fa, $6e, $20, $d1, $02
    db $6d, $20, $d7, $ec, $72, $20, $d9, $f4, $71, $20, $d9, $fc, $70, $20, $d9, $04
    db $6f, $20, $e1, $f4, $75, $20, $f0, $fd, $79, $00, $f0, $f5, $78, $00, $f0, $04
    db $78, $20, $f8, $f5, $7a, $00, $f8, $fd, $7b, $00, $f8, $04, $7a, $20, $80

UiMetasprite_99::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $d8
    db $04, $7c, $20, $e0, $f5, $7f, $00, $e0, $04, $7f, $20, $e0, $fc, $80, $20, $d0
    db $fa, $6e, $20, $d0, $02, $6d, $20, $d8, $f4, $7e, $20, $d8, $fc, $7d, $20, $e8
    db $f8, $81, $00, $e8, $00, $82, $00, $f0, $f5, $78, $00, $f0, $fd, $79, $00, $f0
    db $04, $78, $20, $f8, $f5, $7a, $00, $f8, $fd, $7b, $00, $f8, $04, $7a, $20, $80

UiMetasprite_9a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1, $f0, $66, $20, $f8, $00, $6b, $20, $f8, $f8, $6c, $20, $f0, $00, $69, $20
    db $f0, $f8, $6a, $20, $e8, $00, $67, $20, $e8, $f8, $68, $20, $e0, $00, $64, $20
    db $e0, $f8, $65, $20, $d8, $00, $62, $20, $d8, $f8, $63, $20, $d0, $00, $60, $20
    db $d0, $f8, $61, $20, $80

UiMetasprite_9b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $d0, $fd, $6d, $20, $d0, $f5, $6e, $20, $d8, $05, $6f
    db $20, $d8, $fd, $70, $20, $d8, $f5, $71, $20, $e0, $05, $72, $20, $e0, $fd, $73
    db $20, $e0, $f5, $74, $20, $e8, $05, $75, $20, $e8, $fd, $76, $20, $e8, $f5, $77
    db $20, $f0, $03, $79, $00, $f0, $fb, $78, $00, $f0, $f4, $79, $20, $f8, $03, $7b
    db $00, $f8, $fb, $7a, $00, $f8, $f4, $7b, $20, $80

    db $d1, $f6, $6e, $20, $d1, $fe, $6d, $20, $d7, $e8, $72, $20, $d9, $f0, $71, $20
    db $d9, $f8, $70, $20, $d9, $00, $6f, $20, $e1, $00, $73, $20, $e1, $f8, $74, $20
    db $e1
    db $f0, $75, $20, $e9
    db $fc
    db $77, $00, $e9
    db $f4
    db $76, $00, $f8, $00, $7a, $20, $f0, $00, $78, $20, $f8, $f1, $7a, $00, $f8, $f9
    db $7b, $00, $f0, $f1
    db $78, $00, $f0, $f9
    db $79, $00, $80, $f0, $00, $78, $20, $f8, $00, $7a, $20, $f8, $f1, $7a, $00, $f8
    db $f9, $7b, $00, $f0, $f1, $78, $00, $f0, $f9, $79, $00, $e8, $f4, $81, $00, $e8
    db $fc, $82, $00, $e0, $f1, $7f, $00, $d0, $fe, $6d, $20, $d0, $f6, $6e, $20, $e0
    db $00, $7f, $20, $e0, $f8, $80, $20, $d8, $00, $7c, $20, $d8, $f8, $7d, $20, $d8
    db $f0, $7e, $20, $80

UiMetasprite_60::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ee, $f0, $07, $00, $ea, $f8, $00, $00, $ea, $00, $01, $00, $f6, $f0, $08, $00
    db $f2, $f8, $02, $00, $f2, $00, $03, $00, $f2, $08, $04, $00, $fa, $f8, $05, $00
    db $fa, $00, $06, $00, $80

UiMetasprite_61::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ee, $f0, $07, $00, $ea, $f8, $00, $00, $ea, $00, $01
    db $00, $f6, $f0, $08, $00, $f2, $f8, $02, $00, $f2, $00, $03, $00, $f2, $07, $04
    db $00, $fa, $f8, $05, $00, $fa, $00, $06, $00, $80

UiMetasprite_62::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc, $09, $10, $80

UiMetasprite_63::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ee
    db $f0, $07, $00, $ea, $f8, $00, $00, $ea, $00, $01, $00, $f6, $f0, $08, $00, $f2
    db $f8, $0b, $00, $f2, $00, $0c, $00, $fa, $f8, $0d, $00, $fa, $00, $06, $00, $80

UiMetasprite_64::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ee, $f0, $07, $00, $ea, $f8, $0a, $00, $ea, $00, $01, $00, $f6, $f0, $08, $00
    db $f2, $f8, $0e, $00, $f2, $00, $0c, $00, $fa, $f8, $05, $00, $fa, $00, $06, $00
    db $80

UiMetasprite_65::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ee, $f0, $07, $00, $ea, $f8, $0a, $00, $ea, $00, $01, $00, $ea, $08, $0f
    db $00, $f6, $f0, $08, $00, $f2, $f8, $0e, $00, $f2, $00, $0c, $00, $fa, $f8, $05
    db $00, $fa, $00, $06, $00, $80

UiMetasprite_66::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $06, $10, $00, $ee, $f0, $07, $00, $ea, $f8
    db $0a, $00, $ea, $00, $01, $00, $ec, $06, $11, $00, $ec, $0e, $12, $00, $f6, $f0
    db $08, $00, $f2, $f8, $0e, $00, $f2, $00, $0c, $00, $fa, $f8, $05, $00, $fa, $00
    db $06, $00, $80


UiMetasprite_67::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed
    db $f8, $13, $00
    db $ed
    db $00, $14, $00, $f0, $f0, $07, $00, $f5, $f8, $15, $00, $f5, $00, $16, $00, $f5
    db $08, $17, $00, $f8, $f0, $08, $00, $fd, $f8, $18, $00
    db $fd
    db $00, $19, $00, $80

UiMetasprite_68::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed
    db $f8, $13, $00
    db $ed
    db $00, $14, $00, $f0, $f0, $07, $00, $f5, $f8, $1a, $00, $f5, $00, $1b, $00, $f8
    db $f0, $08, $00, $fd, $f8, $18, $00
    db $fd
    db $00, $1c, $00, $80

UiMetasprite_69::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $1f, $30, $f0, $fc, $1e, $30, $f0, $04, $1d, $30, $f8, $f4, $22, $30
    db $f8, $fc, $21, $30, $f8, $04, $20, $30, $80

UiMetasprite_6a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $1f, $30, $f0, $fc, $24
    db $30, $f0, $04, $23, $30, $f8, $f4, $27, $30, $f8, $fc, $26, $30, $f8, $04, $25
    db $30, $80

UiMetasprite_6b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $1f, $30, $f0, $fc, $29, $30, $f0, $04, $28, $30, $f8, $f5
    db $2c, $30, $f8, $fd, $2b, $30, $f8, $05, $2a, $30, $80


UiMetasprite_6c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $fb, $2e, $30, $e8, $03, $2d, $30, $f0
    db $fc
    db $30, $30, $f0, $04, $2f, $30, $f8
    db $fd
    db $32, $30, $f8, $05, $31, $30, $80

UiMetasprite_6d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $34, $30, $f0, $fc, $33, $30, $f0, $04, $1d, $30, $f8, $f4, $36, $30
    db $f8, $fc, $35, $30, $f8, $04, $20, $30, $80

UiMetasprite_6e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $43, $20, $f0, $fc, $42
    db $20, $f0, $04, $41, $20, $f8, $f3, $46, $20, $f8, $fb, $45, $20, $f8, $03, $44
    db $20, $80

UiMetasprite_6f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $43, $20, $f0, $fc, $48, $20, $f0, $04, $47, $20, $f8, $f4, $4b, $20
    db $f8, $fc, $4a, $20, $f8, $04, $49, $20, $80

UiMetasprite_70::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $43, $20, $f0
    db $fc, $4d, $20, $f0, $04, $4c, $20, $f8, $f4, $50, $20, $f8, $fc, $4f, $20, $f8
    db $04, $4e, $20, $80

UiMetasprite_71::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $52, $20, $f0, $fc, $51, $20, $f0, $04, $41, $20
    db $f8, $f3, $54, $20, $f8, $fb, $53, $20, $f8, $03, $44, $20, $80


UiMetasprite_72::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc
    db $40, $20, $80

UiMetasprite_73::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f9, $38, $20, $e8, $01, $37, $20, $f0
    db $fc
    db $3a, $20, $f0
    db $04, $39, $20, $f8
    db $fc

    db $3c, $20, $f8, $04
    db $3b, $20, $80

UiMetasprite_74::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f9, $3e, $20, $e8, $01, $3d, $20, $f0
    db $fc
    db $3f
    db $20, $f0
    db $04, $39, $20, $f8
    db $fc
    db $3c, $20, $f8, $04, $3b, $20, $80

UiMetasprite_75::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f3, $56, $20, $f0, $fb, $55, $20, $f0, $03, $5a, $20, $f8, $f4, $59, $20
    db $f8, $fc, $58, $20, $f8, $04, $57, $20, $80

UiMetasprite_76::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f8, $5b, $00, $f0, $00, $5c
    db $00, $f8, $f8, $5d, $00, $f8, $00, $5e, $00, $80


UiMetasprite_77::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed
    db $f0, $07, $00, $ea, $f8, $5f, $00, $ea, $00, $60, $00, $f5, $f0, $08, $00, $f2
    db $f8, $61, $00, $f2, $00, $62, $00, $fa, $f8, $63, $00, $fa, $00, $64, $00, $80

UiMetasprite_78::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ea, $f8, $67, $00, $ea, $00, $68, $00, $ee, $f0, $65, $00, $f2, $f8, $69, $00
    db $f2, $00, $6a, $00, $f6, $f0, $66, $00, $fa, $f8, $6b, $00, $fa, $00, $06, $00
    db $80

UiMetasprite_79::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ea, $f8, $67, $00, $ea, $00, $68, $00, $ea, $08, $0f, $00, $ee, $f0, $65
    db $00, $f2, $f8, $69, $00, $f2, $00, $6a, $00, $f6, $f0, $66, $00, $fa, $f8, $6b
    db $00, $fa, $00, $06, $00, $80

UiMetasprite_7a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4
    db $06, $10, $00, $ea, $f8, $67, $00, $ea, $00, $68, $00
    db $ec
    db $06, $11, $00
    db $ec
    db $0e, $12, $00, $ee, $f0, $65, $00, $f2, $f8, $69, $00, $f2, $00, $6a, $00, $f6
    db $f0, $66, $00, $fa, $f8, $6b, $00, $fa, $00, $06, $00, $80

UiMetasprite_1a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $dc, $00, $01, $00, $dc, $f8, $00, $00, $e4, $00, $02, $20, $e4, $f8, $02, $00
    db $ec, $f9, $03, $00, $f4, $00, $05, $00, $f4, $f8, $04, $00, $fc, $00, $07, $00
    db $fc, $f8, $06, $00, $04, $00, $09, $00, $04, $f8, $08, $00, $80

UiMetasprite_1b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $dd, $00, $01
    db $00, $dd, $f8, $00, $00, $e5, $00, $02, $20, $e5, $f8, $02, $00, $ed, $f9, $03
    db $00, $f5, $00, $05, $00, $f5, $f8, $04, $00, $fd, $f8, $06, $00, $fd, $00, $07
    db $00, $05, $f9, $09, $20, $05, $00, $0a, $00, $80

UiMetasprite_1c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $00, $05, $00, $f4, $f8
    db $04, $00, $fc, $00, $0c, $00, $fc, $f8, $0b, $00, $04, $f8, $0d, $00, $04, $00
    db $0e, $00, $80

UiMetasprite_1d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $00, $05, $00, $f4, $f8, $04, $00, $fc, $00, $10, $00, $fc
    db $f8, $0f, $00, $04, $00, $12, $00, $04, $f8, $11, $00, $0c, $00, $14, $00, $0c
    db $f8, $13, $00, $14, $00, $16, $00, $14, $f8, $15, $00, $80

UiMetasprite_1e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $dc, $eb, $17, $00
    db $e4, $eb, $19, $00, $dc, $f3, $18, $00, $e4, $f3, $1a, $00, $ec, $f8, $1b, $00
    db $f4, $00, $1d, $00, $f4, $f8, $1c, $00, $fc, $00, $1f, $00, $fc, $f8, $1e, $00
    db $04, $01, $08, $20, $04, $fd, $08, $20, $80

UiMetasprite_1f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $dd, $f3, $18, $00, $dd, $eb, $17
    db $00, $e5, $eb, $19, $00, $e5, $f3, $1a, $00, $ed, $f8, $1b, $00, $f5, $00, $1d
    db $00, $f5, $f8, $1c, $00, $fd, $00, $1f, $00, $fd, $f8, $1e, $00, $05, $fd, $20
    db $00, $80

UiMetasprite_20::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ee, $18, $25, $00, $ec, $08, $21, $00, $ec, $10, $22, $00, $f4, $10
    db $24, $00, $f4, $08, $23, $00, $f5, $00, $27, $00, $f5, $f8, $26, $00, $fd, $f8
    db $28, $00, $fd, $00, $29, $00, $05, $fc, $0a, $00, $05, $00, $0a, $00, $80

UiMetasprite_21::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00
    db $18, $2f, $00, $00, $10, $2e, $00, $ff, $08, $2d, $00, $f7, $00, $1d, $00, $f7
    db $f8, $26, $00, $ff, $00, $2b, $00, $ff, $f8, $2a, $00, $07, $fa, $2c, $00, $80

UiMetasprite_22::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $18, $00, $01, $40, $18, $f8, $00, $40, $10, $00, $02, $60, $10, $f8, $02, $40
    db $08, $f9, $03, $00, $f4, $00, $31, $00, $f4, $f8, $30, $00, $fc, $00, $33, $00
    db $fc, $f8, $32, $00, $04, $00, $35, $00, $04, $f8, $34, $00, $80

UiMetasprite_23::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $00, $31
    db $00, $f5, $f8, $30, $00, $fd, $00, $33, $00, $fd, $f8, $32, $00, $19, $00, $01
    db $40, $19, $f8, $00, $40, $11, $00, $02, $60, $11, $f8, $02, $40, $09, $f9, $03
    db $00, $05, $f8, $36, $00, $05, $00, $37, $00, $80

UiMetasprite_24::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $00, $31, $00, $f4, $f8
    db $30, $00, $fc, $00, $39, $00, $fc, $f8, $38, $00, $04, $00, $3b, $00, $04, $f8
    db $3a, $00, $80

UiMetasprite_25::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $dc, $00, $15, $60, $dc, $f8, $16, $60, $e4, $00, $13, $60, $e4
    db $f8, $14, $60, $ec, $f9, $03, $00, $f4, $00, $3d, $00, $f4, $f8, $3c, $00, $fc
    db $00, $3f, $00, $fc, $f8, $3e, $00, $04, $00, $40, $00, $04, $f8, $08, $00, $80

UiMetasprite_26::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $00, $41, $00, $f4, $f8, $26, $00, $fc, $00, $43, $00, $fc, $f8, $42, $00
    db $04, $f8, $44, $00, $04, $00, $45, $00, $80

UiMetasprite_27::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $00, $3d, $00, $f4, $f8, $3c
    db $00, $fc, $00, $3f, $00, $fc, $f8, $3e, $00, $04, $00, $45, $00, $04, $f8, $44
    db $00, $80

UiMetasprite_28::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $f9, $3d, $20, $f4, $01, $3c, $20, $fc, $f9, $3f, $20, $fc, $01, $3e, $20
    db $04, $f9, $45, $20, $04, $01, $44, $20, $80

UiMetasprite_29::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $f9, $41, $20, $f4
    db $01, $26, $20, $fc, $f9, $43, $20, $fc, $01, $42, $20, $04, $f9, $45, $20, $04
    db $01, $44, $20, $80


UiMetasprite_2a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $00, $3d, $00
    db $f4
    db $f8, $48, $00
    db $fc
    db $00, $4a, $00
    db $fc
    db $f8, $49, $00, $04
    db $fd
    db $4d, $00, $04, $f8, $4d, $00, $80

UiMetasprite_2b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $00, $3d, $00
    db $f4
    db $f8, $4c, $00
    db $fc
    db $00, $4a, $00
    db $fc
    db $f8, $4b, $00, $04
    db $fd
    db $4d, $00, $04, $f8, $4d, $00, $80

UiMetasprite_2c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $51, $00, $00, $f8, $50, $00, $f8, $00, $4f, $00, $f8, $f8, $4e, $00
    db $80

UiMetasprite_2d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fc, $00, $53, $00, $fc, $f8, $52, $00, $80

UiMetasprite_2e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fc, $00, $55, $00, $fc, $f8, $54, $00, $80

UiMetasprite_2f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $fc, $57, $00, $f8, $fc, $56, $00, $80

UiMetasprite_30::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $fc, $59, $00, $f8, $fc, $58, $00, $80

UiMetasprite_31::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fc, $00, $5b, $00, $fc, $f8, $5a, $00, $80

UiMetasprite_32::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fc, $00, $5d, $00, $f4, $00, $5e, $00, $fc, $f8, $5c, $00, $80

UiMetasprite_33::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $00, $5f, $20, $00, $00, $60, $20, $00, $f8, $60, $00, $f8, $f8, $5f, $00
    db $80

UiMetasprite_34::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fa, $00, $62, $00, $fc, $f8, $61, $00, $80

UiMetasprite_35::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $66, $00, $00, $f8, $65, $00, $f8, $00, $64, $00, $f8, $f8, $63, $00
    db $80

UiMetasprite_36::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $ff, $63, $20, $f8, $f7, $64, $20, $00, $ff, $65, $20, $00, $f7, $66, $20
    db $80

UiMetasprite_37::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $00, $69, $00, $00, $00, $68, $00, $00, $f8, $67, $00, $80

UiMetasprite_38::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $00, $69, $00, $00, $00, $6b, $00, $00, $f8, $6a, $00, $80

UiMetasprite_39::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4, $f8, $46, $00, $fc, $f8, $77, $00, $04, $f9, $79, $20, $f4, $00, $47, $00
    db $fc, $00, $78, $00, $04, $00, $79, $00, $80

UiMetasprite_3a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $72, $00, $f8, $00, $71, $00, $00, $f8, $70, $00, $f8, $f8, $6f, $00
    db $80

UiMetasprite_3b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $6e, $40, $f8, $00, $6e, $00, $00, $f8, $70, $00, $f8, $f8, $6f, $00
    db $80

UiMetasprite_3c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $76, $00, $00, $f8, $75, $00, $f8, $00, $74, $00, $f8, $f8, $73, $00
    db $80

UiMetasprite_3d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $6e
    db $40, $f8, $00, $6e, $00, $00, $f8, $6d, $00, $f8, $f8, $6c, $00, $80


UiMetasprite_3e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $00, $7b, $00
    db $f4
    db $f8, $7a, $00
    db $fc
    db $00, $7d, $00
    db $fc
    db $f8, $7c, $00, $04, $f8, $08, $00, $04, $00, $09, $00, $80

UiMetasprite_3f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $f8, $7a, $00
    db $05, $f9
    db $09, $20, $fd, $f8, $7e, $00, $f5, $00, $7b, $00
    db $fd
    db $00, $7f, $00, $05, $00, $0a, $00, $80

UiMetasprite_40::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $f8, $7a, $00
    db $fc
    db $f8, $93, $00, $04
    db $fc
    db $08, $20, $f4, $00, $7b, $00
    db $fc
    db $00, $94, $00, $04, $00, $08, $20, $80

UiMetasprite_41::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $f8, $7a, $00, $f5, $00, $7b, $00
    db $fd
    db $f8, $7c, $00
    db $fd
    db $00, $7f, $00, $05
    db $fc
    db $20, $00
    db $80

UiMetasprite_42::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $00, $96, $00
    db $f4
    db $f8, $95, $00
    db $fc
    db $00, $98, $00
    db $fc
    db $f8, $97, $00, $04, $f8, $08, $00, $04, $00, $09, $00, $80

UiMetasprite_43::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $f8, $95, $00
    db $fd
    db $f8, $99, $00, $05, $f9, $09, $20, $f5, $00, $96, $00
    db $fd
    db $00, $9a, $00, $05, $00, $0a, $00, $80

UiMetasprite_44::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $9e, $00, $00, $f8, $9d, $00, $f8, $00, $9c, $00, $f8, $f8, $9b, $00
    db $80

UiMetasprite_45::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $a0, $00, $00, $f8, $9f
    db $00, $f8, $00, $9c, $00, $f8, $f8, $9b, $00, $80

UiMetasprite_46::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $00, $a2, $00
    db $f4
    db $f8, $a1, $00
    db $fc
    db $00, $7d, $00
    db $fc
    db $f8, $7c, $00, $04, $00, $09, $00, $04, $f8, $08, $00, $80

UiMetasprite_47::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $00, $a2, $00
    db $f5, $f8, $a1, $00
    db $fd
    db $f8, $7e, $00
    db $fd
    db $00, $7f, $00, $05, $f9, $09, $20, $05, $00, $0a, $00, $80

UiMetasprite_48::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4

    db $f8, $a1, $00
    db $f4
    db $00, $a2, $00
    db $fc
    db $f8, $93, $00
    db $fc
    db $00, $94, $00, $04
    db $fc
    db $08, $20, $04, $00, $08, $20, $80

UiMetasprite_49::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $f8, $a1, $00, $f5, $00, $a2, $00
    db $fd
    db $f8, $7c, $00
    db $fd
    db $00, $7f, $00, $05
    db $fc
    db $20, $00
    db $80

UiMetasprite_4a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f4
    db $00, $a4, $00
    db $f4
    db $f8, $a3, $00
    db $fc
    db $00, $98, $00
    db $fc
    db $f8, $a5, $00, $04, $00, $09, $00, $04, $f8, $08, $00, $80

UiMetasprite_4b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f5, $f8, $a3, $00
    db $f5, $00, $a4, $00
    db $fd
    db $f8, $a6, $00
    db $fd
    db $00, $9a, $00, $05, $f9, $09, $20, $05, $00, $0a, $00, $80

UiMetasprite_4c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $00, $51, $40, $f8, $f8, $50, $40, $00, $00, $4f, $40, $00, $f8, $4e, $40
    db $80

UiMetasprite_4d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc, $57, $40, $00, $fc, $56, $40, $80

UiMetasprite_4e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc, $59, $40, $00, $fc, $58, $40, $80

UiMetasprite_4f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $00, $5f, $60, $f8, $00, $60, $60, $f8, $f8, $60, $40, $00
    db $f8, $5f, $40, $80


UiMetasprite_50::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $00, $66, $40, $f8, $f8, $65, $40, $00, $00, $64, $40, $00, $f8, $63, $40
    db $80

UiMetasprite_51::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $00, $ff, $63, $60, $00, $f7, $64, $60, $f8, $ff, $65, $60, $f8, $f7, $66
    db $60, $80

UiMetasprite_52::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fd
    db $f3, $a8, $00, $f5, $fb, $26, $00, $f5, $03, $a7, $00
    db $fd
    db $03, $aa, $00
    db $fd
    db $fb, $a9, $00, $05, $fb, $ab, $00, $80

UiMetasprite_53::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $fd
    db $f4
    db $a8, $00, $f5
    db $fc
    db $ac, $00, $f5, $04, $a7, $00
    db $fd
    db $04, $aa, $00
    db $fd
    db $fc
    db $ad, $00, $05, $fb, $ae, $00, $80

UiMetasprite_54::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb
    db $f8, $00, $00
    db $eb
    db $00, $01, $00, $f3, $f9, $02, $00, $f3, $01, $03, $00, $fb, $f8, $04, $00, $fb
    db $00, $05, $00, $80

UiMetasprite_55::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb
    db $f8, $06, $00
    db $eb
    db $00, $07, $00, $f3, $f8, $08, $00, $f3, $00
    db $09, $00, $fb
    db $fc
    db $0a, $00, $80

UiMetasprite_56::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb
    db $f8, $06, $00
    db $eb
    db $00, $07, $00, $f3, $f8, $0b, $00, $f3, $00, $0c, $00, $fb
    db $fd
    db $0d, $00, $80

UiMetasprite_57::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $0f, $20, $f0
    db $fc
    db $0e, $00, $f0, $04, $0f, $00, $f8, $f4
    db $11, $20, $f8
    db $fc
    db $10, $00, $f8, $04
    db $11, $00, $80

UiMetasprite_58::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $13, $20, $f0
    db $fc
    db $12, $00, $f0, $04, $13, $00, $f8, $f4
    db $15, $20, $f8
    db $fc
    db $14, $00, $f8, $04, $15, $00, $80

UiMetasprite_59::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $16, $20, $f0, $fc
    db $0e, $00, $f0, $04, $16, $00, $f8, $f4, $18, $20, $f8, $fc, $17, $00, $f8, $04
    db $18, $00
    db $80

UiMetasprite_5a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb
    db $f8, $1a, $20, $eb, $00, $19, $20, $f3, $f8, $1c, $20, $f3, $00, $1b, $20, $fb
    db $f8, $1e, $20, $fb, $00
    db $1d
    db $20, $80

UiMetasprite_5b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec

    db $f8, $1a, $20, $ec, $00, $19, $20, $f4, $f8, $20, $20, $f4
    db $00, $1f, $20, $fc
    db $f8, $22, $20, $fc, $00
    db $21, $20, $80

UiMetasprite_5c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec

    db $f8, $1a, $20, $ec, $00, $19, $20, $f4, $f8, $24, $20, $f4
    db $00, $23, $20, $fc
    db $f8, $26, $20, $fc, $00, $25, $20, $80

UiMetasprite_5d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f8, $28, $20, $f0, $00, $27, $20, $f8, $f8, $2a, $20, $f8, $00, $29, $20
    db $80

UiMetasprite_5e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f8, $28, $20, $f0, $00, $27
    db $20, $f8, $f8, $2c, $20, $f8, $00, $2b, $20, $80

UiMetasprite_5f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f1
    db $f8, $28, $20, $f1
    db $00, $27, $20, $f8, $f8, $2e, $20, $f8, $00, $2d, $20, $80

UiMetasprite_0e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e3, $f8, $30, $00, $e3, $00, $31, $00, $eb, $f8, $32, $00, $eb, $00, $33, $00
    db $f3, $f8, $34, $00, $f3, $00, $35, $00, $fb, $f8, $17, $00, $fb, $00, $18, $00
    db $80

UiMetasprite_0f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8, $30, $00, $e4, $00, $31, $00, $ec, $f8, $32, $00, $ec, $00, $33
    db $00, $f4, $f8, $36, $00, $f4, $00, $37, $00, $fc, $f8, $1b, $00, $fc, $00, $1c
    db $00, $80

UiMetasprite_10::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8, $30, $00, $e4, $00, $31, $00, $ec, $f8, $32, $00, $ec, $00
    db $33, $00, $f4, $f8, $36, $00, $f4, $00, $37, $00, $fc, $f8, $1f, $00, $fc, $00
    db $20, $00, $80

UiMetasprite_11::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb, $f8, $13, $00, $eb, $00, $38, $00, $f3, $f8, $39, $00, $f3
    db $00, $3a, $00, $ee, $08, $3c, $00, $fb, $f9, $3b, $20, $fb, $00, $3b, $00, $80

UiMetasprite_12::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb, $f8, $13, $00, $eb, $00, $14, $00, $ec, $05, $3d, $00, $f3, $f8, $39, $00
    db $f3, $00, $3a, $00, $fb, $f9, $3b, $20, $fb, $00, $3b, $00, $80

UiMetasprite_13::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb, $f8, $13
    db $00, $eb, $00, $14, $00, $f3, $f8, $39, $00, $f3, $00, $3a, $00, $fb, $f9, $3b
    db $20, $fb, $00, $3b, $00, $80

UiMetasprite_14::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb, $f8, $3e, $20, $eb, $00, $3e, $00, $f3, $f8, $3f, $20, $f3, $00, $3f, $00
    db $fb, $f8, $3b, $20, $fb, $00, $3b, $00, $80

UiMetasprite_15::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec
    db $f8, $13, $00, $ec, $00, $40, $00, $f4, $f8, $41, $00, $f4, $00, $42, $00, $fc
    db $f9, $47, $20, $fc, $00, $47, $00, $80

UiMetasprite_16::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $43, $00, $ec, $00, $44, $00
    db $f4, $f8, $45, $00, $f4, $00, $46, $00, $fc, $f9, $47, $20, $fc, $00, $47, $00
    db $80

UiMetasprite_17::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $eb, $f8, $13, $00, $eb, $00, $14, $00, $f3, $f8, $15, $00, $f3, $00, $16, $00
    db $fb, $f8, $17, $00, $fb, $00, $18, $00, $80

UiMetasprite_18::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $13, $00, $ec, $00
    db $14, $00, $f4, $f8, $19, $00, $f4, $00, $1a, $00, $fc, $f8, $1b, $00, $fc, $00
    db $1c, $00, $80

UiMetasprite_19::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $13, $00, $ec, $00, $14, $00, $f4, $f8, $1d, $00, $f4, $00, $1e, $00
    db $fc, $f8, $1f, $00, $fc, $00, $20, $00, $80

UiMetasprite_00::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f8, $00, $00
    db $e0, $00, $01, $00, $e0, $08, $02, $00, $e8, $f0, $03, $00, $e8, $f8, $04, $00
    db $e8, $00, $05, $00, $e8, $08, $06, $00, $f0, $f7, $07, $00, $f0, $ff, $08, $00
    db $f0, $07, $09, $00, $f8, $f2, $0a, $00, $f8, $fa, $0b, $00, $f8, $02, $0c, $00
    db $80

UiMetasprite_01::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1, $f7, $00, $00, $e1, $ff, $01, $00, $e1, $07, $02, $00, $e9, $ef, $0d
    db $00, $e9, $f7, $04, $00, $e9, $ff, $0e, $00, $e9, $07, $0f, $00, $f1, $f7, $07
    db $00, $f1, $ff, $10, $00, $f1, $07, $11, $00, $f9, $f2, $0a, $00, $f9, $fa, $12
    db $00, $f9, $02, $13, $00, $80

UiMetasprite_02::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f5, $14, $00, $e0, $fd, $15, $00, $e0, $05
    db $16, $00, $e8, $f0, $17, $00, $e8, $f8, $18, $00, $e8, $00, $19, $00, $e8, $08
    db $1a, $00, $f0, $f2, $1b, $00, $f0, $fa, $1c, $00, $f0, $02, $1d, $00, $f8, $f1
    db $1e, $00, $f8, $f9, $1f, $00, $f8, $01, $20, $00, $80

UiMetasprite_03::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f4, $14, $00, $e0
    db $fc, $15, $00, $e0, $04, $02, $00, $e8, $ef, $21, $00, $e8, $f7, $18, $00, $e8
    db $ff, $22, $00, $e8, $07, $23, $00, $f0, $f1, $24, $00, $f0, $f9, $1c, $00, $f0
    db $01, $25, $00, $f0, $09, $26, $00, $f8, $f0, $1e, $00, $f8, $f8, $27, $00, $f8
    db $00, $28, $00, $80

UiMetasprite_04::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f4, $14, $00, $e0, $fc, $15, $00, $e0, $04, $02, $00
    db $e8, $ef, $29, $00, $e8, $f7, $18, $00, $e8, $ff, $22, $00, $e8, $07, $23, $00
    db $f0, $f1, $2a, $00, $f0, $f9, $1c, $00, $f0, $01, $2b, $00, $f0, $09, $2c, $00
    db $f8, $f0, $1e, $00, $f8, $f8, $27, $00, $f8, $00, $2d, $00, $f8, $08, $2e, $00
    db $80

UiMetasprite_05::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f6, $2f, $00, $e0, $fe, $30, $00, $e0, $06, $31, $00, $e8, $f6, $32
    db $00, $e8, $fe, $33, $00, $e8, $06, $34, $00, $f2, $f0, $39, $00, $f0, $f8, $35
    db $00, $f0, $00, $36, $00, $f8, $f8, $37, $00, $f8, $00, $38, $00, $80

UiMetasprite_06::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f3
    db $3b, $20, $e0, $fb, $3a, $20, $e0, $01, $3a, $00, $e0, $09, $3b, $00, $e8, $f1
    db $3c, $00, $e8, $f9, $3d, $00, $e8, $01, $3e, $00, $e8, $09, $3f, $00, $f0, $f1
    db $40, $00, $f0, $f9, $41, $00, $f0, $01, $42, $00, $f0, $09, $43, $00, $f8, $f1
    db $44, $00, $f8, $f9, $45, $00, $f8, $01, $46, $00, $80

UiMetasprite_07::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f3, $3b, $20, $e0
    db $fb, $3a, $20, $e0, $01, $3a, $00, $e0, $09, $3b, $00, $e8, $f1, $47, $00, $e8
    db $f9, $3d, $00, $e8, $01, $3e, $00, $e8, $09, $48, $00, $f0, $f1, $49, $00, $f0
    db $f9, $4a, $00, $f0, $01, $42, $00, $f0, $09, $4b, $00, $f8, $f1, $4c, $00, $f8
    db $f9, $45, $00, $f8, $01, $46, $00, $80

UiMetasprite_08::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1, $f2, $2f, $00, $e1, $fa, $4d, $00
    db $e1, $02, $4e, $00, $e9, $f2, $4f, $00, $e9, $fa, $50, $00, $e9, $02, $51, $00
    db $f1, $ee, $52, $00, $f1, $f6, $53, $00, $f1, $fe, $54, $00, $f9, $ee, $55, $00
    db $f9, $f6, $56, $00, $f9, $fe, $57, $00, $80

UiMetasprite_09::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f8, $58, $00, $e0, $00, $59
    db $00, $e2, $08, $5a, $00, $e8, $f0, $5b, $00, $e8, $f8, $5c, $00, $e8, $00, $5d
    db $00, $ea, $08, $5e, $00, $f0, $f0, $5f, $00, $f0, $f8, $60, $00, $f0, $00, $61
    db $00, $f8, $f0, $62, $00, $f8, $f8, $63, $00, $f8, $00, $64, $00, $80

UiMetasprite_0a::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f8
    db $65, $00, $e0, $00, $66, $00, $e2, $08, $67, $00, $e8, $f0, $5b, $00, $e8, $f8
    db $68, $00, $e8, $00, $69, $00, $ea, $08, $6a, $00, $f0, $f0, $5f, $00, $f0, $f8
    db $6b, $00, $f0, $00, $6c, $00, $f8, $f0, $62, $00, $f8, $f8, $63, $00, $f8, $00
    db $64, $00, $80

UiMetasprite_0b::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1, $f8, $02, $20, $e1, $00, $15, $20, $e1, $08, $14, $20, $e9
    db $f5, $6d, $00, $e9, $fd, $6e, $00, $e9, $05, $18, $20, $e9, $0d, $6f, $00, $f1
    db $f3, $70, $00, $f1, $fb, $71, $00, $f1, $03, $72, $00, $f9, $fb, $73, $00, $f9
    db $03, $74, $00, $80

UiMetasprite_0c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4, $75, $00, $e8, $fc, $76, $00, $e8, $04, $77, $00
    db $f0, $f4, $78, $00, $f0, $fc, $79, $00, $f0, $04, $7a, $00, $f8, $f7, $7b, $00
    db $f8, $ff, $7c, $00, $80

UiMetasprite_0d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4, $7d, $00, $ea, $fc, $76, $00, $e8, $04, $7e
    db $00, $f0, $f5, $80, $20, $f0, $fc, $7f, $00, $f0, $04, $80, $00, $f8, $f4, $81
    db $00, $f8, $fc, $82, $00, $f8, $04, $83, $00, $80

UiMetasprite_9c::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f0, $00, $00, $e0, $f8
    db $01, $00, $e0, $00, $02, $00, $e0, $08, $03, $00, $e8, $f0, $04, $00, $e8, $f8
    db $05, $00, $e8, $00, $06, $00, $e8, $08, $07, $00, $f0, $f5, $08, $00, $f0, $fd
    db $09, $00, $f0, $05, $0a, $00, $f8, $f7, $0b, $00, $f8, $ff, $0c, $00, $f8, $07
    db $0d, $00, $80

UiMetasprite_9d::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f0, $00, $00, $e0, $f8, $01, $00, $e0, $00, $02, $00, $e0
    db $08, $03, $00, $e8, $f0, $0e, $00, $e8, $f8, $0f, $00, $e8, $00, $06, $00, $e8
    db $08, $07, $00, $f0, $f5, $10, $00, $f0, $fd, $11, $00, $f0, $05, $12, $00, $f8
    db $f1, $13, $00, $f8, $f9, $14, $00, $f8, $01, $15, $00, $80

UiMetasprite_9e::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f0, $00, $00
    db $e0, $f8, $01, $00, $e0, $00, $02, $00, $e0, $08, $03, $00, $e8, $f0, $17, $00
    db $e8, $f8, $05, $00, $e8, $00, $18, $00, $e8, $08, $07, $00, $f0, $f0, $19, $00
    db $f0, $f8, $1a, $00, $f0, $00, $1b, $00, $f0, $08, $1c, $00, $f8, $f8, $1d, $00
    db $f8, $00, $1e, $00, $f8, $08, $1f, $00, $80

UiMetasprite_9f::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $fc, $20, $00, $e8, $04, $21
    db $00, $f0, $ec, $22, $00, $f0, $f4, $23, $00, $f0, $fc, $24, $00, $f0, $04, $25
    db $00, $f0, $0c, $26, $00, $f8, $ec, $27, $00, $f8, $f4, $28, $00, $f8, $fc, $29
    db $00, $f8, $04, $2a, $00, $f8, $0c, $2b, $00, $80

UiMetasprite_a0::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $fc, $20, $00, $e8, $04
    db $21, $00, $f0, $ec, $22, $00, $f0, $f4, $23, $00, $f0, $fc, $24, $00, $f0, $04
    db $25, $00, $f0, $0c, $26, $00, $f8, $ec, $27, $00, $f8, $f4, $2c, $00, $f8, $fc
    db $2d, $00, $f8, $04, $2e, $00, $f8, $0c, $2f, $00, $80

UiMetasprite_a1::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $fc, $20, $00, $e8
    db $04, $21, $00, $f0, $ec, $22, $00, $f0, $f4, $23, $00, $f0, $fc, $24, $00, $f0
    db $04, $25, $00, $f0, $0c, $26, $00, $f8, $ec, $27, $00, $f8, $f4, $30, $00, $f8
    db $fc, $31, $00, $f8, $04, $32, $00, $f8, $0c, $33, $00, $80

UiMetasprite_a2::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f3, $34, $00
    db $e0, $fb, $35, $00, $e0, $03, $36, $00, $e0, $0b, $37, $00, $e8, $f3, $38, $00
    db $e8, $fb, $39, $00, $e8, $03, $3a, $00, $e8, $0b, $3b, $00, $e8, $13, $3c, $00
    db $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $3f, $00, $f0, $0f, $40, $00
    db $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80

UiMetasprite_a3::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f3, $34
    db $00, $e0, $fb, $35, $00, $e0, $03, $36, $00, $e0, $0b, $37, $00, $e8, $f3, $38
    db $00, $e8, $fb, $39, $00, $e8, $03, $3a, $00, $e8, $0b, $43, $00, $e8, $13, $3c
    db $00, $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $3f, $00, $f0, $0f, $40
    db $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80

UiMetasprite_a4::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f3
    db $34, $00, $e0, $fb, $35, $00, $e0, $03, $36, $00, $e0, $0b, $37, $00, $e8, $f3
    db $38, $00, $e8, $fb, $39, $00, $e8, $03, $44, $00, $e8, $0b, $45, $00, $e8, $13
    db $3c, $00, $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $3f, $00, $f0, $0f
    db $40, $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80

UiMetasprite_a5::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1
    db $f3, $34, $00, $e1, $fb, $35, $00, $e1, $03, $36, $00, $e1, $0b, $37, $00, $e9
    db $f3, $38, $00, $e9, $fb, $39, $00, $e8, $03, $46, $00, $e8, $0b, $47, $00, $e8
    db $13, $3c, $00, $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $48, $00, $f0
    db $0f, $40, $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80

UiMetasprite_a6::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4, $49, $00, $e8, $fc, $4a, $00, $e8, $04, $4b, $00, $f0, $f4, $4c, $00
    db $f0, $fc, $4d, $00, $f0, $04, $4e, $00, $f8, $f6, $4f, $00, $f8, $fe, $50, $00
    db $80

UiMetasprite_a7::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4, $51, $00, $e8, $03, $52, $00, $f0, $ec, $53, $00, $f0, $f4, $54
    db $00, $f0, $fc, $55, $00, $f0, $04, $56, $00, $f8, $f4, $57, $00, $f8, $fc, $58
    db $00, $f8, $04, $59, $00, $80

UiMetasprite_a8::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4, $5a, $00, $e8, $fc, $5b, $00, $e8, $04
    db $5c, $00, $f0, $f4, $69, $00, $f0, $fc, $5d, $00, $f0, $04, $5e, $00, $f8, $f7
    db $5f, $00, $f8, $ff, $60, $00, $80

UiMetasprite_a9::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f5, $61, $00, $e8, $fd, $62, $00, $e8
    db $05, $63, $00, $f0, $f5, $64, $00, $f0, $fd, $65, $00, $f0, $05, $66, $00, $f8
    db $f7, $67, $00, $f8, $ff, $68, $00, $80

UiMetasprite_aa::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f5, $63, $20, $e8, $fd, $62, $20
    db $e8, $05, $61, $20, $f0, $f5, $66, $20, $f0, $fd, $65, $20, $f0, $05, $64, $20
    db $f8, $f7, $67, $00, $f8, $ff, $68, $00, $80


UiMetasprite_ab::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $f4, $6a, $00, $e8, $fc, $6b, $00, $e8, $04, $6c, $00, $f0, $fc, $6d, $00
    db $f8, $f4, $6c, $60, $f8, $fc, $6b, $60, $f8, $04, $6a, $60, $80

UiMetasprite_ac::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f4, $70
    db $00, $f0, $fc, $71, $00, $f0, $04, $72, $00, $f8, $f4, $72, $60, $f8, $fc, $71
    db $60, $f8, $04, $70, $60, $80

UiMetasprite_ad::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f8, $73, $00, $f0, $00, $74, $00, $f8, $f8, $75, $00, $f8, $00, $76, $00
    db $80

UiMetasprite_ae::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $f8, $77, $20, $e5, $00, $77, $00, $ed, $f8, $78, $20, $ed, $00, $78, $00
    db $f8, $f8, $79, $20, $f8, $00, $79, $00, $80

UiMetasprite_af::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f0, $f8, $6e, $20, $f0, $00
    db $6e, $00, $f8, $f8, $6f, $20, $f8, $00, $6f, $00, $80


UiMetasprite_b0::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f0, $00, $00, $e0, $f8, $01, $00, $e0, $00, $02, $00, $e0, $08, $03, $00
    db $e8, $eb, $7a, $00, $e8, $f3, $7b, $00, $e8, $fb, $7c, $00, $e8, $03, $7d, $00
    db $e8, $0b, $7e, $00, $f0, $f3, $7f, $00, $f0, $fb, $bc, $00, $f0, $03, $bd, $00
    db $f0, $0b, $be, $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $bf, $00
    db $80

UiMetasprite_b1::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ff, $10, $db, $20, $ff, $e8, $db, $00, $f8, $08, $cf, $00, $f8, $00, $ce, $00
    db $f8, $f8, $cd, $00, $f8, $f0, $cc, $00, $f0, $08, $cb, $00, $f0, $00, $ca, $00
    db $f0, $f8, $c9, $00, $f0, $f0, $c8, $00, $80

UiMetasprite_b2::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $d0, $f8, $b3, $00, $d0, $e8, $b1
    db $00, $d0, $e0, $b0, $00, $c8, $10, $a6, $00, $c8, $08, $a5, $00, $c8, $00, $a4
    db $00, $d0, $18, $b7, $00, $d0, $10, $b6, $00, $d0, $08, $b5, $00, $d0, $00, $b4
    db $00, $d0, $f8, $b3, $00, $d8, $18, $c7, $00, $d8, $10, $c6, $00, $d8, $08, $c5
    db $00, $d8, $00, $c4, $00, $d8, $f8, $c3, $00, $d8, $f0, $c2, $00, $d8, $e8, $c1
    db $00, $d8, $e0, $c0, $00, $e0, $18, $ad, $00, $e0, $10, $ac, $00, $e0, $08, $ab
    db $00, $e0, $00, $aa, $00, $e0, $f8, $a9, $00, $e0, $f0, $a8, $00, $e8, $10, $bc
    db $00, $e8, $08, $bb, $00, $e8, $00, $ba, $00, $e8, $f8, $b9, $00, $e8, $f0, $b8
    db $00, $f0, $f8, $a3, $00, $f0, $f0, $a2, $00, $f0, $00, $a7, $00, $f0, $10, $af
    db $00, $f0, $08, $ae, $00, $f8, $10, $bf, $00, $f8, $08, $be, $00, $f8, $00, $bd
    db $00, $f8, $f8, $b2, $00, $80

UiMetasprite_b3::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8, $03, $20, $f4, $00, $02, $20
    db $fc, $fb, $04, $20, $80

UiMetasprite_b4::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $01, $20, $ed
    db $00, $00, $20, $f5, $f8, $06, $20, $f5, $00, $05, $20, $fd, $f8, $08, $20, $fd
    db $00, $07, $20, $80

UiMetasprite_b5::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $01, $20, $ed, $00, $00, $20, $f5, $f8, $0a, $20, $f5, $00, $09, $20
    db $fd, $f8, $0c, $20, $fd, $00, $0b, $20, $80

UiMetasprite_b6::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01
    db $20, $ec, $00, $00, $20, $f4, $f8, $11, $20, $f4, $00, $10, $20, $fc, $f8, $0f
    db $20, $fc, $ff, $0f, $00, $80

UiMetasprite_b7::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8, $0e, $20, $f4, $00, $10, $20
    db $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_b8::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec
    db $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8, $0e, $20, $f4, $00, $0d, $20, $fc
    db $f8, $0f, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_b9::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00, $20
    db $f4, $f8, $11, $20, $f4, $00, $0d, $20, $fc, $f8, $0f, $20, $fc, $ff, $0f, $00
    db $80

UiMetasprite_ba::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $13, $20, $ec, $00, $12, $20, $f4, $f8, $15, $20, $f4, $00, $14, $20
    db $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_bb::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $13, $20, $ec, $00
    db $12, $20, $f4, $f0, $17, $20, $f4, $f8, $16, $20, $f4, $00, $14, $20, $fc, $f8
    db $18, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_bc::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4
    db $f0, $1a, $20, $f4, $f8, $19, $20, $f4, $00, $10, $20, $fc, $f0, $1b, $20, $fc
    db $f8, $0f, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_bd::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00, $20
    db $f4, $f0, $1a, $20, $f4, $f8, $1d, $20, $f4, $00, $1c, $20, $fc, $f0, $1b, $20
    db $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_be::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00
    db $20, $f4, $f0, $1a, $20, $f4, $f8, $19, $20, $f4, $00, $1c, $20, $fc, $f0, $1b
    db $20, $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80

UiMetasprite_bf::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00
    db $00, $20, $f4, $f8, $1f, $20, $f4, $00, $1e, $20, $fc, $f8, $21, $20, $fc, $00
    db $20, $20, $80

UiMetasprite_c0::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $01, $20, $ed, $00, $00, $20, $f5, $f8, $1f, $20, $f5, $00, $1e, $20
    db $fd, $f8, $22, $20, $fd, $00, $07, $20, $80

UiMetasprite_c1::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $01, $20
    db $ed, $00, $00, $20, $f5, $f8, $1f, $20, $f5, $00, $1e, $20, $fd, $f8, $23, $20
    db $fd, $00, $0b, $20, $80

UiMetasprite_c2::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8, $43, $20, $f4, $00, $42, $20
    db $fc, $f8, $21, $20, $fc, $00, $20, $20, $80

UiMetasprite_c3::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8
    db $01, $20, $ec, $00, $00, $20, $f4, $f8, $2c, $20, $f4, $00, $42, $20, $fc, $f8
    db $21, $20, $fc, $00, $20, $20, $80

UiMetasprite_c4::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $24, $00, $ec, $00, $25, $00, $f4
    db $f8, $10, $00, $f4, $00, $11, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80

UiMetasprite_c5::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $2d, $00, $ec, $00, $2e, $00, $f4, $f8, $2f, $00, $f4, $00, $30, $00
    db $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80

UiMetasprite_c6::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $24, $00, $ec, $00, $25, $00, $f4, $f8, $02, $00, $f4, $00, $03, $00
    db $fc, $fd, $04, $00, $80

UiMetasprite_c7::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8
    db $24, $00, $ed, $00, $25, $00, $f5, $f8, $05, $00, $f5, $00, $06, $00, $fd, $f8
    db $07, $00, $fd, $00, $08, $00, $80

UiMetasprite_c8::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $24, $00, $ed, $00, $25, $00, $f5
    db $f8, $09, $00, $f5, $00, $0a, $00, $fd, $f8, $0b, $00, $fd, $00, $0c, $00, $80

UiMetasprite_c9::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $25, $20, $ec, $00, $24, $20, $f4, $f8, $27, $20, $f4, $00, $26, $20
    db $fa, $f0, $28, $40, $fc, $f8, $21, $20, $fc, $00, $29, $20, $80

UiMetasprite_ca::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $25
    db $20, $ed, $00, $24, $20, $f5, $f8, $27, $20, $f5, $00, $26, $20, $fb, $f0, $28
    db $40, $fd, $f8, $22, $20, $fd, $00, $2a, $20, $80

UiMetasprite_cb::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $25, $20, $ed, $00
    db $24, $20, $f5, $f8, $27, $20, $f5, $00, $26, $20, $fb, $f0, $28, $40, $fd, $f8
    db $23, $20, $fd, $00, $2b, $20, $80

UiMetasprite_cc::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ec, $f8, $25, $20, $ec, $00, $24, $20, $f4
    db $f8, $27, $20, $f4, $00, $1e, $20, $fa, $f0, $28, $40, $fc, $f8, $21, $20, $fc
    db $00, $20, $20, $80

UiMetasprite_cd::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $25, $20, $ed, $00, $24, $20, $f5, $f8, $27, $20
    db $f5, $00, $1e, $20, $fb, $f0, $28, $40, $fd, $f8, $22, $20, $fd, $00, $07, $20
    db $80

UiMetasprite_ce::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $ed, $f8, $25, $20, $ed, $00, $24, $20, $f5, $f8, $27, $20, $f5, $00, $1e, $20
    db $fb, $f0, $28, $40, $fd, $f8, $23, $20, $fd, $00, $0b, $20, $80

UiMetasprite_cf::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8
    db $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00, $f4, $f8
    db $35, $00, $f4, $00, $36, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80

UiMetasprite_d0::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4
    db $f8, $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00, $f4
    db $f8, $37, $00, $f4, $00, $36, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80

UiMetasprite_d1::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8, $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00
    db $f4, $f8, $38, $00, $f4, $00, $36, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00
    db $80

UiMetasprite_d3::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8, $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00
    db $f4, $f8, $39, $00, $f4, $00, $3a, $00, $fc, $fc, $04, $00, $80

UiMetasprite_d4::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $f8
    db $31, $00, $e5, $00, $32, $00, $ed, $f8, $33, $00, $ed, $00, $34, $00, $f5, $f8
    db $3b, $00, $f5, $00, $3c, $00, $fd, $f8, $07, $00, $fd, $00, $08, $00, $80

UiMetasprite_d5::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5
    db $f8, $31, $00, $e5, $00, $32, $00, $ed, $f8, $33, $00, $ed, $00, $34, $00, $f5
    db $f8, $3d, $00, $f5, $00, $3e, $00, $fd, $f8, $0b, $00, $fd, $00, $0c, $00, $80

UiMetasprite_d6::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8, $32, $20, $e4, $00, $31, $20, $ec, $f8, $34, $20, $ec, $00, $33, $20
    db $f2, $f0, $5c, $00, $f4, $f8, $40, $20, $f4, $00, $3f, $20, $fc, $f0, $5c, $40
    db $fc, $f8, $21, $20, $fc, $00, $29, $20, $80

UiMetasprite_d7::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $f8, $32, $20, $e5, $00, $31
    db $20, $ed, $f8, $34, $20, $ed, $00, $33, $20, $f3, $f0, $5c, $00, $f5, $f8, $40
    db $20, $f5, $00, $3f, $20, $fd, $f0, $5c, $40, $fd, $f8, $22, $20, $fd, $00, $2a
    db $20, $80

UiMetasprite_d8::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $f8, $32, $20, $e5, $00, $31, $20, $ed, $f8, $34, $20, $ed, $00
    db $33, $20, $f3, $f0, $5c, $00, $f5, $f8, $40, $20, $f5, $00, $3f, $20, $fd, $f0
    db $5c, $40, $fd, $f8, $23, $20, $fd, $00, $2b, $20, $80

UiMetasprite_d9::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $f8, $32, $20, $e4
    db $00, $31, $20, $ec, $f8, $34, $20, $ec, $00, $33, $20, $f2, $f0, $5c, $00, $f4
    db $f8, $40, $20, $f4, $00, $41, $20, $fc, $f0, $5c, $40, $fc, $f8, $21, $20, $fc
    db $00, $20, $20, $80

UiMetasprite_da::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $f8, $32, $20, $e5, $00, $31, $20, $ed, $f8, $34, $20
    db $ed, $00, $33, $20, $f3, $f0, $5c, $00, $f5, $f8, $40, $20, $f5, $00, $41, $20
    db $fd, $f0, $5c, $40, $fd, $f8, $22, $20, $fd, $00, $07, $20, $80

UiMetasprite_db::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $f8, $32
    db $20, $e5, $00, $31, $20, $ed, $f8, $34, $20, $ed, $00, $33, $20, $f3, $f0, $5c
    db $00, $f5, $f8, $40, $20, $f5, $00, $41, $20, $fd, $f0, $5c, $40, $fd, $f8, $23
    db $20, $fd, $00, $0b, $20, $80

UiMetasprite_dc::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $fb, $44, $00, $ec, $f8, $45, $00, $ec, $00
    db $46, $00, $f4, $f8, $47, $00, $f4, $00, $48, $00, $fc, $f9, $0f, $20, $fc, $00
    db $0f, $00, $80

UiMetasprite_dd::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $fb, $44, $00, $ec, $f8, $49, $00, $ec, $00, $4a, $00, $f4
    db $f8, $4b, $00, $f4, $00, $4c, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80

UiMetasprite_de::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $fe, $53, $00, $ec, $f8, $4d, $00, $ec, $00, $4e, $00, $f4, $f8, $47, $00
    db $f4, $00, $4f, $00, $f2, $08, $50, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00
    db $80

UiMetasprite_df::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $fb, $44, $00, $ec, $f8, $51, $00, $ec, $00, $52, $00, $f4, $f8, $47
    db $00, $f4, $00, $4f, $00, $f2, $08, $50, $00, $fc, $f9, $0f, $20, $fc, $00, $0f
    db $00, $80

UiMetasprite_e0::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $fb, $44, $00, $ec, $f8, $45, $00, $ec, $00, $46, $00, $f4, $f8, $54, $00
    db $f4, $00, $55, $00, $fc, $fc, $04, $00, $80

UiMetasprite_e1::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $fb, $44, $00, $ed
    db $f8, $45, $00, $ed, $00, $46, $00, $f5, $f8, $56, $00, $f5, $00, $57, $00, $fd
    db $f8, $07, $00, $fd, $00, $08, $00, $80

UiMetasprite_e2::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $fb, $44, $00, $ed, $f8, $45, $00
    db $ed, $00, $46, $00, $f5, $f8, $58, $00, $f5, $00, $59, $00, $fd, $f8, $0b, $00
    db $fd, $00, $0c, $00, $80

UiMetasprite_e3::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e4, $fb, $44, $00, $ec, $f8, $46, $20, $ec, $00, $45
    db $20, $f4, $f0, $28, $00, $f4, $f8, $5b, $20, $f4, $00, $5a, $20, $fc, $f8, $21
    db $20, $fc, $00, $29, $20, $80

UiMetasprite_e4::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $fb, $44, $00, $ed, $f8, $46, $20, $ed, $00
    db $45, $20, $f5, $f0, $28, $00, $f5, $f8, $5b, $20, $f5, $00, $5a, $20, $fd, $f8
    db $22, $20, $fd, $00, $2a, $20, $80

UiMetasprite_e5::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e5, $fb, $44, $00, $ed, $f8, $46, $20, $ed
    db $00, $45, $20, $f5, $f0, $28, $00, $f5, $f8, $5b, $20, $f5, $00, $5a, $20, $fd
    db $f8, $23, $20, $fd, $00, $2b, $20, $80


UiMetasprite_e6::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e0, $f5, $00, $80, $e0, $fd, $01, $80, $e0, $05, $02, $80, $e8, $f0, $03, $80
    db $e8, $f8, $04, $80, $e8, $00, $05, $80, $e8, $08, $06, $80, $f0, $f1, $07, $80
    db $f0, $f9
    db $08, $80, $f0, $01, $09, $80, $f8, $f0, $0a, $80, $f8, $f8, $0b, $80, $f8, $00
    db $0c, $80, $80

UiMetasprite_e7::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1, $f5, $00, $80, $e1
    db $fd
    db $01, $80, $e1, $05, $02, $80, $e9, $f0, $03, $80, $e9, $f8, $04, $80, $e9, $00
    db $05, $80, $e9, $08, $06, $80, $f1, $f1, $0d, $80, $f1, $f9, $08, $80, $f1, $01
    db $0e, $80, $f1, $09, $0f, $80, $f9, $f7
    db $10
    db $80, $f9, $ff, $11, $80, $f9, $07, $12, $80, $80

UiMetasprite_e8::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e1, $f5, $00, $80, $e1
    db $fd
    db $01, $80, $e1, $05, $02, $80, $e9, $f0, $03, $80, $e9, $f8, $04, $80, $e9, $00
    db $05, $80, $e9, $08, $06, $80, $f1, $f0, $13, $80, $f1, $f8, $14, $80, $f1, $00
    db $15, $80, $f9, $f0, $16, $80, $f9, $f8, $17, $80, $f9, $00, $18, $80, $80

UiMetasprite_e9::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $dc
    db $f5, $00, $80, $dc, $fd, $01, $80, $dc, $05, $02, $80
    db $e4
    db $f0, $03, $80
    db $e4
    db $f8, $04, $80
    db $e4
    db $00, $05, $80
    db $e4
    db $08, $06, $80
    db $ec
    db $f0, $19, $80
    db $ec
    db $f8, $1a, $80
    db $ec
    db $00, $1b, $80
    db $ec
    db $08, $1c, $80
    db $f4
    db $f0, $1d, $80
    db $f4
    db $f8, $1e, $80
    db $f4
    db $00, $1f, $80
    db $f4
    db $08, $20, $80
    db $fc
    db $f1, $21, $80, $fc, $f9, $22, $80
    db $fc
    db $01, $23, $80, $80

UiMetasprite_ea::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $db
    db $f5, $00, $80
    db $db
    db $fd
    db $01, $80, $db, $05, $02, $80
    db $e3
    db $f0, $03, $80
    db $e3
    db $f8, $04, $80
    db $e3
    db $00
    db $05, $80
    db $e3
    db $08, $06, $80
    db $eb
    db $f0, $24, $80
    db $eb
    db $f8, $25, $80
    db $eb
    db $00, $26, $80
    db $eb
    db $08, $27, $80, $f3, $f0, $28, $80, $f3, $f8, $29, $80, $f3, $00, $2a
    db $80, $f3, $08, $2b, $80, $fb, $f3, $2c, $80, $fb, $fb, $2d, $80, $fb, $03, $2e
    db $80, $80

UiMetasprite_eb::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $da, $f5, $00, $80, $da, $fd, $01, $80, $da, $05, $02, $80, $e2, $f0
    db $03, $80, $e2, $f8, $04, $80, $e2, $00, $05, $80, $e2, $08, $06, $80, $ea, $f0
    db $24, $80, $ea, $f8, $25, $80, $ea, $00, $26, $80, $ea, $08, $27, $80, $f2, $f0
    db $28, $80, $f2, $f8, $29, $80, $f2, $00, $2f, $80, $f2, $08, $30, $80, $fa, $f3
    db $31, $80, $fa, $fb, $32, $80, $fa, $03, $33, $80, $80

UiMetasprite_ec::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e9, $04, $38, $80
    db $ed
    db $f4
    db $34, $80, $ee, $fc, $35, $80, $f1, $04, $39, $80, $f5
    db $f4
    db $36, $80, $f6, $fc, $37, $80, $f9, $04, $3a, $80, $80

UiMetasprite_ed::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $fc, $3d, $80, $e8
    db $04, $40, $80, $ef
    db $f4
    db $3b, $80, $f0, $fc, $3e, $80, $f0, $04, $41, $80, $f7
    db $f4
    db $3c, $80, $f8, $fc, $3f, $80, $f8, $04, $42, $80, $80

UiMetasprite_ee::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $e8, $fc, $45, $80, $e8
    db $04, $48, $80, $ee, $f4, $43, $80, $f0, $fc, $46, $80, $f0, $04, $49, $80, $ef
    db $0c, $4b, $80, $f6, $f4, $44, $80, $f8, $fc, $47, $80, $f8, $04, $4a, $80, $80

UiMetasprite_ef::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc, $4c, $80, $80

UiMetasprite_f0::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc, $4d, $80, $f8, $04, $4e, $80, $80

UiMetasprite_f1::
; Four-byte parts are dy, dx, tile, flags; $80 terminates the metasprite.
    db $f8, $fc
    db $4f, $80, $f8, $04, $50, $80, $80, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
