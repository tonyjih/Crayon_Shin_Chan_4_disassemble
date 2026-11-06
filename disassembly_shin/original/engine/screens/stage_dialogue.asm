InitStageDialogueScreen::
; State 4, substate 3; scene index / 2 selects the stage picture.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [wScreenFrameCounter], a
    ld [wScreenPhaseCounter], a
    ld [wStageDialogueHighlightApplied], a
    ld a, [wStageSceneIndex]
    bit 0, a
    jr z, StageDialogue_LoadSceneGraphics

    call InitSound
    ld a, $20
    call PlaySound_Queue3

StageDialogue_LoadSceneGraphics::
    ld a, BANK(GfxRle_b06_7700)
    ld hl, GfxRle_b06_7700
    ld de, _VRAM
    call LoadMaskedGfx
    ld hl, StageDialogueSceneGfxPointers
    ld a, [wStageSceneIndex]
    srl a
    rst $20
    ld de, _VRAM + $600
    ld a, $06
    call LoadMaskedGfx
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $e00
    ld bc, $0200
    call BankedMemcpy
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, $60
    ldh [hTileStreamWritePos], a
    call BuildMenuPatternBackground
    ld a, $ef
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $021
    ld bc, $1007
    call DrawTilemapBox
    ld a, [wStageSceneIndex]
    ld c, $0e
    call MultiplyBCByA8bit
    ld bc, StageDialogueBackgroundStencils
    add hl, bc
    ld d, h
    ld e, l
    ld hl, _SCRN0 + $162
    call ClearSgbTilemapStencil16x7
    ld a, [wStageSceneIndex]
    ld hl, StageDialogueScriptPointers
    rst $20
    ld a, l
    ld [wStageDialogueScriptPtrLo], a
    ld a, h
    ld [wStageDialogueScriptPtrHi], a
    ld a, $ff
    ld [wStageDialogueAnimSelectors], a
    ld [wStageDialogueAnimSelectors + 1], a
    ld [wStageDialogueAnimSelectors + 2], a
    xor a
    ldh [hTileStreamCount], a
    call StartNextStageDialogueMessage
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, [wStageSceneIndex]
    srl a
    jr nc, StageDialogue_StoreScenePalette

    add $08

StageDialogue_StoreScenePalette::
    add $08
    ld [wScreenPaletteId], a
    ret


UpdateStageDialogueScreen::
; State 4, substate 3.
    call UpdateStageDialogueHighlights
    ld a, [wStageSceneIndex]
    cp $07
    jr z, StageDialogue_DrawActors

    ldh a, [hJoyPressed]
    bit 3, a
    jp nz, StageScene_AdvanceOrResumeGameplay

StageDialogue_DrawActors::
    ld de, wStageDialogueAnimSelectors
    ld b, $03

StageDialogue_DrawNextActor::
    push bc
    ld a, b
    dec a
    ld hl, StageDialogueActorXPositions
    rst $38
    ld c, [hl]
    ld a, [de]
    inc de
    push de
    cp $40
    jr c, StageDialogue_DrawAnimatedActor

    cp $7f
    jr z, StageDialogue_AdvanceDrawSlot

    ld d, a
    ld b, $88
    call DrawBank3MetaspriteNormal
    jr StageDialogue_AdvanceDrawSlot

StageDialogue_DrawAnimatedActor::
    ld de, wSceneAnim0PtrLo
    ld a, b
    sla a
    add b
    sub $03
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld b, $88
    call AnimateSceneMetasprite

StageDialogue_AdvanceDrawSlot::
    pop de
    pop bc
    dec b
    jr nz, StageDialogue_DrawNextActor

    ld a, [wScreenPhaseCounter]
    cp $ff
    jr nz, StageDialogue_CheckFlashSound

    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenPhaseCounter], a

StageDialogue_CheckFlashSound::
    ld a, [wScreenPhaseCounter]
    cp $30
    jr nz, StageDialogue_CheckPaletteFlash

    ld a, $49
    call PlaySound_Queue1

StageDialogue_CheckPaletteFlash::
    ld a, [wScreenPhaseCounter]
    or a
    jr z, StageDialogue_UpdateMessage

    ld a, [wScreenPhaseCounter]
    bit 3, a
    ld a, $e4
    jr z, StageDialogue_ApplyPaletteFlash

    cpl

StageDialogue_ApplyPaletteFlash::
    ld [wPaletteBGP], a
    ld a, [wScreenPhaseCounter]
    dec a
    ld [wScreenPhaseCounter], a
    ret


StageDialogue_UpdateMessage::
    call UpdateMessageFar
    ld hl, _SCRN0 + $111
    ld a, [wScreenFrameCounter]
    bit 4, a
    ld a, $00
    jr z, StageDialogue_DrawAdvanceMarker

    ld a, $e1

StageDialogue_DrawAdvanceMarker::
    call QueueTilemapByte
    ld a, [wStageSceneIndex]
    cp $07
    jr z, StageDialogue_WaitForMessageEnd

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, StageDialogue_WaitForMessageEnd

    ld a, $02
    ld [wMessageCharPeriod], a

StageDialogue_WaitForMessageEnd::
    ld a, [wMessageState]
    or a
    ret nz

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, StageDialogue_AdvanceAfterInput

    ld a, [wStageDialogueAdvanceStep]
    or a
    ret z

StageDialogue_AdvanceAfterInput::
    ld a, [wStageDialogueAdvanceStep]
    inc a
    ld [wStageDialogueAdvanceStep], a
    ldh [hTileStreamCount], a
    cp $05
    jp z, StartNextStageDialogueMessage

    jr c, StageDialogue_PrepareTextEraseRows

    ret


StageDialogue_PrepareTextEraseRows::
    dec a
    add a
    ld h, a
    ld l, $02

StageDialogue_EraseNextTextRow::
    ld bc, _SCRN0 + $022
    ld de, $e210
    ld a, h
    or a
    jr z, StageDialogue_QueueTextEraseRow

    ld d, $00

StageDialogue_QueueTextEraseRow::
    swap a
    and $f0
    add a
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    push hl
    call QueueVramFill
    pop hl
    inc h
    dec l
    jr nz, StageDialogue_EraseNextTextRow

    xor a
    ret


UpdateStageDialogueHighlights::
    ld a, [wSgbEnabled]
    or a
    ret z

    ld a, [wStageDialogueHighlightApplied]
    or a
    ret nz

    ld a, [wStageSceneIndex]
    cp $07
    jr nz, StageDialogue_CheckHiddenActorHighlight

    ld a, [wStageDialogueAnimSelectors]
    cp $7f
    jr z, StageDialogue_CheckHiddenActorHighlight

    ld hl, SgbPacket_DialogueFinalSceneHighlight
    call SendSgbPacket
    ld hl, StageDialogueFinalSceneVramQueue
    call GetVramQueueTailDE
    ld b, $0d

StageDialogue_CopyFinalSceneQueue::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, StageDialogue_CopyFinalSceneQueue

    ldh a, [hVramQueuePos]
    add $0c
    ldh [hVramQueuePos], a
    ld a, $01
    ld [wStageDialogueHighlightApplied], a
    ret


StageDialogue_CheckHiddenActorHighlight::
    ld hl, StageDialogueHiddenActorSlots
    ld a, [wStageSceneIndex]
    rst $38
    ld a, [hl]
    bit 7, a
    ret nz

    ld b, a
    ld hl, wStageDialogueAnimSelectors
    rst $38
    ld a, [hl]
    cp $7f
    ret nz

    ld a, b
    push af
    ld hl, StageDialogueSgbPacketPointers
    rst $20
    call SendSgbPacket
    pop af
    ld hl, StageDialogueVramQueuePointers
    rst $20
    call GetVramQueueTailDE
    ldh a, [hVramQueuePos]
    ld b, a

StageDialogue_CopyActorHighlightQueue::
    ld a, [hl+]
    ld [de], a
    inc de
    inc b
    or a
    jr nz, StageDialogue_CopyActorHighlightQueue

    dec b
    ld a, b
    ldh [hVramQueuePos], a
    ld a, $01
    ld [wStageDialogueHighlightApplied], a
    ret


StartNextStageDialogueMessage::
; Consume one five-byte dialogue record and optional FE control-write descriptor.
    xor a
    ld [wStageDialogueAdvanceStep], a
    ld [wScreenFrameCounter], a
    ld a, $08
    ld [wMessageCharPeriod], a
    ld hl, wStageDialogueScriptPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wStageSceneIndex]
    srl a
    inc a
    ld d, a
    ld a, [wAlternateModeFlags]
    add d
    ld [wMsgSubstitutionId], a
    ld a, $e1
    ld [wMessageFlags], a
    ld a, [hl+]
    cp $ff
    jp z, StageScene_AdvanceOrResumeGameplay

    ld b, a
    push hl
    cp $29
    jr nz, StageDialogue_StartSelectedMessage

    ld a, [wSpecialModeFlags]
    or a
    jr z, StageDialogue_PreparePasswordLine

    ld b, $3c

StageDialogue_PreparePasswordLine::
    ld a, $e0
    ld [wMessageFlags], a
    ld hl, PasswordCodeTable - $14
    ld a, [wStageSceneIndex]
    srl a
    inc a
    ld d, a
    ld a, [wAlternateModeFlags]
    add d
    ld d, a
    ld a, [wSpecialModeFlags]
    or a
    ld a, $00
    jr z, StageDialogue_ApplyPasswordGroupOffset

    ld a, $04

StageDialogue_ApplyPasswordGroupOffset::
    add d
    ld de, $0014

StageDialogue_AdvancePasswordRecord::
    add hl, de
    dec a
    jr nz, StageDialogue_AdvancePasswordRecord

    push bc
    ld e, l
    ld d, h
    ld hl, PasswordCodeLengths
    ld a, [wStageSceneIndex]
    srl a
    rst $38
    ld b, [hl]
    inc b
    srl b
    ld hl, _SCRN0 + $0ca
    ld a, l
    sub b
    ld l, a
    ld bc, $0a02
    call QueueTilemapRect
    call InitSound
    ld a, $64
    call PlaySound_Queue3
    pop bc

StageDialogue_StartSelectedMessage::
    ld a, b
    call StartMessageFar
    pop hl
    ld a, [hl+]
    ldh [hStageDialogueSpeakerMask], a
    ld b, $03
    ld de, wStageDialogueAnimSelectors

StageDialogue_UpdateActorSelector::
    ld a, [de]
    ld c, a
    ld a, [hl+]
    cp c
    jr z, StageDialogue_NextActorSlot

    ld [de], a
    cp $40
    jr nc, StageDialogue_NextActorSlot

    push hl
    push de
    ld hl, StageDialogueAnimationPointers
    rst $20
    ld a, b
    sla a
    add b
    sub $03
    ld de, wSceneAnim0PtrLo
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    inc de
    xor a
    ld [de], a
    pop de
    pop hl

StageDialogue_NextActorSlot::
    inc de
    dec b
    jr nz, StageDialogue_UpdateActorSelector

    ld a, [hl]
    cp $fe
    jr nz, StageDialogue_SaveScriptPointer

    inc hl
    ld a, [hl+]
    ld [wMessageControlValue], a
    ld a, [hl+]
    ld [wMessageControlPtrLo], a
    ld a, [hl+]
    ld [wMessageControlPtrHi], a

StageDialogue_SaveScriptPointer::
    ld a, l
    ld [wStageDialogueScriptPtrLo], a
    ld a, h
    ld [wStageDialogueScriptPtrHi], a
    ld a, [wSgbEnabled]
    or a
    jr z, StageDialogue_BuildActorHighlightBoxes

    ld hl, SgbPacket_DialogueSpeakerTemplate
    ld de, wSgbPalSetPacket
    ld b, $10

StageDialogue_CopyPalettePacketTemplate::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, StageDialogue_CopyPalettePacketTemplate

    ldh a, [hStageDialogueSpeakerMask]
    ld b, a
    add a
    add b
    ld hl, StageDialogueSpeakerAttributes
    rst $38
    ld a, [hl+]
    ld [wSgbPalSetPacket + 7], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 8], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 9], a
    ld hl, wSgbPalSetPacket
    call SendSgbPacket

StageDialogue_BuildActorHighlightBoxes::
    ld b, $03
    ld hl, _SCRN0 + $124
    ldh a, [hStageDialogueSpeakerMask]
    ld c, a

StageDialogue_NextActorHighlightBox::
    ld de, StageDialogueSpeakerMarkerTiles
    rr c
    jr c, StageDialogue_WriteSpeakerMarker

    ld a, b
    add a
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a

StageDialogue_WriteSpeakerMarker::
    push bc
    push hl
    ld bc, $0102
    ldh a, [hTileStreamCount]
    or a
    call z, CopyTilemapRectToVram
    ldh a, [hTileStreamCount]
    or a
    call nz, QueueTilemapRect
    pop hl
    pop bc
    ld de, $0006
    add hl, de
    ld a, b
    cp $02
    jr nz, StageDialogue_AdvanceSpeakerMarker

    dec hl

StageDialogue_AdvanceSpeakerMarker::
    dec b
    jr nz, StageDialogue_NextActorHighlightBox

    ret


StageScene_DoubleIndexAndAdvance::
    ld a, [wStageSceneIndex]
    sla a
    ld [wStageSceneIndex], a

StageScene_AdvanceOrResumeGameplay::
    xor a
    ld [wMessageState], a
    ld [wVramQueue], a
    ld a, [wStateChangeParamHi]
    cp $04
    jp z, RequestSavedMenuDestination

    ld a, [wStageSceneIndex]
    bit 0, a
    jr nz, StageScene_AdvanceAfterStageClear

    srl a
    ldh [hStageIndex], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld a, [wStageSceneIndex]
    inc a
    ld [wStageSceneIndex], a
    cp $01
    ret nz

    ldh a, [hJoyHeld]
    and $08
    ret nz

    ld a, $08
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


StageScene_AdvanceAfterStageClear::
    inc a
    ld [wStageSceneIndex], a
    cp $08
    jr z, StageScene_SelectEndingMode

    ld e, a
    ld d, $08
    ld bc, $0100
    jp RequestStateChange_Menu


StageScene_SelectEndingMode::
    ld b, $09
    ld a, [wAlternateModeFlags]
    ld c, $00
    or a
    jr z, StageScene_RequestEnding

    ld c, $01

StageScene_RequestEnding::
    ld de, $0400
    jp RequestStateChange_Menu
