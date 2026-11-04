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



INCLUDE "data/sgb/border_patterns.asm"

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



INCLUDE "data/sgb/transfers.asm"
