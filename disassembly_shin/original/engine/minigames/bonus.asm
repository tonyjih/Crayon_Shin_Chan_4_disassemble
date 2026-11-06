InitBonusStage::
; Mode 0 initialization.
    ld a, [wScreenSubstate]
    or a
    jr nz, Bonus_InitPaletteAndTiles

    xor a
    ld [wBonusDestination], a
    ld a, $01
    ld [wBonusWalkDeltaX], a
    ld a, $e8
    ld [wBonusActorX], a
    ld a, BANK(Gfx_b05_5701)
    ld hl, Gfx_b05_5701
    ld de, _VRAM + $d00
    ld bc, $0300
    call BankedMemcpy

Bonus_InitPaletteAndTiles::
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld a, $d0
    ld [hl+], a
    ld a, $e4
    ld [hl], a
    ld a, [wStateChangeParamHi]
    ld [wBonusReturnRequest], a
    call InitGameplayHudAndWindow
    ld a, BANK(GfxRle_b06_5334)
    ld hl, GfxRle_b06_5334
    ld de, _VRAM + $130
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_53ec)
    ld hl, GfxRle_b06_53ec
    ld de, _VRAM + $300
    call LoadMaskedGfx
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $800
    ld bc, $0200
    call BankedMemcpy
    ld a, BANK(GfxRle_b06_5556)
    ld hl, GfxRle_b06_5556
    ld de, _VRAM + $a00
    call LoadMaskedGfx
    ld a, [wScreenSubstate]
    cp $03
    jr z, Bonus_InitInstructionBackground

    ld a, $e3
    ld [wLCDCShadow], a
    ld hl, LayoutRle_b06_5787
    ld de, wStageLayoutMap
    ld bc, $0168
    ld a, BANK(LayoutRle_b06_5787)
    call BankedMemcpy_RLEFF
    ld hl, _SCRN0
    ld bc, $1412
    ld de, wStageLayoutMap
    call CopyTilemapRectToVram
    ld a, $03
    ld [wScreenPaletteId], a
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    jr Bonus_InitActorAndMessageState

Bonus_InitInstructionBackground::
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hTileStreamWritePos], a
    call BuildMenuPatternBackground
    ld a, $8f
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $023
    ld bc, $0c0d
    call DrawTilemapBox
    ld a, [wSgbEnabled]
    or a
    jr z, Bonus_SetInstructionPalette

    ld hl, wStageLayoutMap
    ld bc, $0010
    call bzero
    ld hl, _SCRN0 + $1a0
    ld bc, $0303
    ld de, wStageLayoutMap
    call CopyTilemapRectToVram

Bonus_SetInstructionPalette::
    ld a, $14
    ld [wScreenPaletteId], a

Bonus_InitActorAndMessageState::
    ld hl, SceneAnim_Scene3Mode0Primary
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wMessageState], a
    ld [wScreenFrameCounter], a
    ld [wScreenPhaseCounter], a
    ld [wBonusRewardChoiceDelay], a
    ld a, [wScreenSubstate]
    cp $03
    jr nz, Bonus_DrawInitialRoundNumbers

    ld a, $82
    ld [wMessageFlags], a
    ld a, [wBonusDestination]
    add $09
    cp $0c
    jr c, Bonus_PlayInstructionMusic

    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, [wBonusDestination]
    sub $03
    add $5a
    jr Bonus_StartInstructionMessage

Bonus_PlayInstructionMusic::
    push af
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    pop af

Bonus_StartInstructionMessage::
    call StartMessageFar
    ld hl, SceneAnim_Scene3Mode0State1
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    ld a, $40
    ld [wScreenFrameCounter], a
    ret


Bonus_DrawInitialRoundNumbers::
    call Bonus_DrawRoundNumbers
    ld a, [wScreenSubstate]
    cp $06
    ret z

Bonus_ShowNoHealthMessage::
    ldh a, [hPlayerHealth]
    or a
    ret nz

    ld a, $80
    ld [wMessageFlags], a
    ld a, $0c
    call StartMessageFar
    ld hl, SceneAnim_Scene3Mode0State2
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $01
    ld [wBonusWalkDeltaX], a
    xor a
    ld [wScreenSubstate], a
    ret


UpdateBonusStage::
; Mode 0 update, dispatched by wScreenSubstate.
    ld a, [wScreenSubstate]
    and $07
    rst $00

BonusStageStateHandlers::
    dw Bonus_WalkBetweenStations ; $00
    dw Bonus_WaitAtStation ; $01
    dw Bonus_EnterMinigameAfterAnimation ; $02
    dw Bonus_ShowInstructionsOrPasswordHint ; $03
    dw Bonus_LeaveAfterFade ; $04
    dw Bonus_LaunchAfterInstructionFade ; $05
    dw Bonus_ShowResultAndApplyReward ; $06
    dw Bonus_SelectRewardByRoundTier ; $07

Bonus_WalkBetweenStations::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wBonusWalkDeltaX]
    ld b, a
    ldh a, [hPlayerHealth]
    or a
    jr nz, Bonus_MoveActor

    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $03
    jr nz, Bonus_MoveActor

    ld b, $00

Bonus_MoveActor::
    ld a, [wBonusActorX]
    add b
    ld [wBonusActorX], a
    ld c, a
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld hl, BonusDestinationExitX
    ld b, $05

Bonus_CheckNextDestinationX::
; Scan the five destination positions in reverse order.
    ld a, [wBonusActorX]
    cp [hl]
    jr z, Bonus_HandleReachedDestination

    dec hl
    dec b
    jr nz, Bonus_CheckNextDestinationX

    ret


Bonus_HandleReachedDestination::
    dec b
    ld a, b
    cp $04
    jr z, Bonus_BeginExitFade

    ldh a, [hPlayerHealth]
    or a
    ret z

    ld a, b
    ld [wBonusDestination], a
    ld a, $01
    ld [wScreenSubstate], a
    ld a, $10
    ld [wScreenFrameCounter], a
    ld a, $80
    ld [wMessageFlags], a
    ld a, b
    inc a
    call StartMessageFar
    ret


Bonus_BeginExitFade::
    ld a, $3f
    ld [wFadeTransitionTimer], a
    ld a, $04
    ld [wScreenSubstate], a
    ret


Bonus_LeaveAfterFade::
    call Bonus_DrawMovingBorderSprites
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0400
    ld de, $0000
    ld a, [wBonusReturnRequest]
    cp $04
    jp z, RequestStateChange_Menu

    ld a, [wStageSceneIndex]
    ld e, a
    srl a
    ld c, a
    ld b, $06
    ld d, $08
    jp RequestStateChange_Menu


    ret


Bonus_WaitAtStation::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wBonusActorX]
    ld c, a
    ld b, $7f
    ld d, $0e
    call DrawBank3MetaspriteNormal
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, Bonus_CheckResumeWalking

    ld a, [wMessageState]
    or a
    jr nz, Bonus_CheckResumeWalking

    ld a, [wBonusDestination]
    cp $03
    jr z, Bonus_CheckResumeWalking

    ld hl, SceneAnim_Scene3Mode0Secondary
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wMessageState], a
    ld a, $40
    ld [wFadeTransitionTimer], a
    ld a, $02
    ld [wScreenSubstate], a
    ldh a, [hPlayerHealth]
    cp $04
    ret nc

    ldh a, [hPlayerHealth]
    dec a
    ldh [hPlayerHealth], a
    call QueueHealthHudAfterDamage
    ret


Bonus_CheckResumeWalking::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    bit 7, a
    ret z

    xor a
    ld [wScreenFrameCounter], a
    ldh a, [hJoyHeld]
    bit 4, a
    call nz, Bonus_StartWalkingRight
    ldh a, [hJoyHeld]
    bit 5, a
    call nz, Bonus_StartWalkingLeft
    ret


Bonus_EnterMinigameAfterAnimation::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wSceneAnim0Timer]
    cp $01
    jr nz, Bonus_PlayEntryAnimation

    ld hl, wSceneAnim0PtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    dec hl
    ld a, [hl]
    cp $12
    jr nz, Bonus_PlayEntryAnimation

    ld a, $54
    call PlaySound

Bonus_PlayEntryAnimation::
    ld a, [wBonusActorX]
    ld c, a
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    or a
    ret z

    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld hl, wBonusMinigameRounds
    ld a, [wBonusDestination]
    rst $38
    ld a, [hl]
    ld [wMinigameRound], a
    ld hl, wBonusInstructionPending
    ld a, [wBonusDestination]
    rst $38
    ld b, $03
    ld a, [wBonusDestination]
    ld c, a
    ld de, $0106
    ld a, [hl]
    or a
    jp z, RequestStateChange_Menu

    xor a
    ld [hl], a
    ld b, $02
    ld a, [wBonusDestination]
    ld c, a
    ld de, $0106
    jp RequestStateChange_Menu


Bonus_StartWalkingRight::
    ld a, $01
    ld [wBonusWalkDeltaX], a
    ld hl, SceneAnim_Scene3Mode0Primary
    jr Bonus_SetWalkingAnimation

Bonus_StartWalkingLeft::
    ld a, [wBonusDestination]
    or a
    ret z

    ld a, $ff
    ld [wBonusWalkDeltaX], a
    ld hl, SceneAnim_Scene3Mode0Variant

Bonus_SetWalkingAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenSubstate], a
    call Bonus_ClearMessageBox
    ret


Bonus_ClearMessageBox::
    xor a
    ld [wMessageState], a
    ld d, $82
    ld bc, _SCRN0 + $083

Bonus_ClearNextMessageRow::
    ld e, $0e
    push bc
    call QueueVramFill
    pop bc
    ld d, $00
    ld a, $20
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, c
    cp $03
    jr nz, Bonus_ClearNextMessageRow

    ret


Bonus_DrawMovingBorderSprites::
    ld a, [wBonusBlinkCounter]
    inc a
    ld [wBonusBlinkCounter], a
    ld c, $00
    and $10
    jr z, Bonus_DrawHorizontalBorderSprites

    ld c, $08

Bonus_DrawHorizontalBorderSprites::
    ld b, $00
    push bc
    ld hl, BonusHorizontalBorderMetasprite
    call DrawMetaspriteNormal
    pop bc
    ld a, c
    xor $08
    ld c, a
    ld b, $18
    ld hl, BonusHorizontalBorderMetasprite
    call DrawMetaspriteNormal
    ld a, [wBonusBlinkCounter]
    ld b, $00
    and $10
    jr nz, Bonus_DrawVerticalBorderSprites

    ld b, $08

Bonus_DrawVerticalBorderSprites::
    ld c, $00
    push bc
    ld hl, BonusVerticalBorderMetasprite
    call DrawMetaspriteNormal
    pop bc
    ld a, b
    xor $08
    ld b, a
    ld c, $78
    ld hl, BonusVerticalBorderMetasprite
    call DrawMetaspriteNormal
    ret


Bonus_ShowInstructionsOrPasswordHint::
    ld c, $0c
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFadeWithLateSgbPalSet
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld a, [wBonusDestination]
    cp $03
    jr nc, Bonus_WaitBeforePasswordHintConfirm

    ld a, [wBonusBlinkCounter]
    inc a
    ld [wBonusBlinkCounter], a
    and $0f
    jr nz, Bonus_CheckInstructionConfirm

    ld a, [wBonusBlinkCounter]
    and $10
    ld a, $81
    jr nz, Bonus_DrawInstructionAdvanceMarker

    xor a

Bonus_DrawInstructionAdvanceMarker::
    ld hl, _SCRN0 + $1cf
    call QueueTilemapByte

Bonus_CheckInstructionConfirm::
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld a, $3f
    ld [wFadeTransitionTimer], a
    ld a, $05
    ld [wScreenSubstate], a
    xor a
    ld hl, _SCRN0 + $1cf
    call QueueTilemapByte
    ret


Bonus_WaitBeforePasswordHintConfirm::
    ld a, [wBonusDestination]
    cp $05
    ret z

    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    cp $d0
    ret c

    ld a, $e0
    ld [wScreenPhaseCounter], a
    jr Bonus_CheckInstructionConfirm

Bonus_LaunchAfterInstructionFade::
    ld c, $0c
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld b, $03
    ld a, [wBonusDestination]
    cp $03
    jp nc, RequestSavedMenuDestination

    ld c, a
    ld a, [wStateChangeParamLo]
    ld e, a
    ld a, [wStateChangeParamHi]
    ld d, a
    jp RequestStateChange_Menu


Bonus_ShowResultAndApplyReward::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wBonusActorX]
    ld c, a
    ld b, $7f
    ld d, $14
    call DrawBank3MetaspriteNormal
    ld a, [wBonusDestination]
    cp $01
    jp nz, Bonus_UpdateResultMessageTimer

    ld a, [wMinigameResultFlag]
    or a
    jr nz, Bonus_UpdateResultMessageTimer

    ld a, [wScreenFrameCounter]
    or a
    jr nz, Bonus_UpdateResultMessageTimer

    ld a, [wBonusRewardChoiceDelay]
    cp $01
    jr nz, Bonus_IncrementRewardChoiceDelay

    ld hl, _SCRN0 + $0a7
    ld bc, $0501 ; width/height constant, not a ROM0 QueueVramFill pointer
    ld de, BonusFormRewardHeadingTiles
    call QueueTilemapRect

Bonus_IncrementRewardChoiceDelay::
    ld a, [wBonusRewardChoiceDelay]
    inc a
    cp $40
    jr c, Bonus_StoreRewardChoiceDelay

    ld a, $60

Bonus_StoreRewardChoiceDelay::
    ld [wBonusRewardChoiceDelay], a
    ld a, [wScreenPhaseCounter]
    bit 7, a
    jr nz, Bonus_WaitAfterFormRewardChoice

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, Bonus_CycleFormRewardPreview

    ld a, [wBonusRewardChoiceDelay]
    cp $60
    ret nz

    ld a, $80
    ld [wScreenPhaseCounter], a
    ret


Bonus_CycleFormRewardPreview::
    ld a, [wScreenPhaseCounter]
    inc a
    cp $0c
    jr c, Bonus_UpdateFormPreviewTilemap

    xor a

Bonus_UpdateFormPreviewTilemap::
    ld [wScreenPhaseCounter], a
    and $03
    ret nz

    ld a, [wScreenPhaseCounter]
    srl a
    srl a
    add $0b
    ld [wMsgSubstitutionId], a
    xor a
    ld a, [wMessageFlags]
    ld a, $68
    call StartMessageFar
    ld bc, _SCRN0 + $0c6
    ld de, $0004
    call QueueVramFill
    ret


Bonus_WaitAfterFormRewardChoice::
    inc a
    ld [wScreenPhaseCounter], a
    cp $e0
    ret nz

    ld bc, _SCRN0 + $0c6
    ld de, $0004
    call QueueVramFill

Bonus_UpdateResultMessageTimer::
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $01
    jr nz, Bonus_CheckRewardFrame

    ld a, $80
    ld [wMessageFlags], a
    ld a, [wMinigameResultFlag]
    or a
    ld a, $08
    jr nz, Bonus_StartResultMessage

    ld a, [wBonusDestination]
    ld hl, wBonusMinigameRounds
    rst $38
    inc [hl]
    ld a, [hl]
    cp $0b
    jr c, Bonus_SelectSuccessMessage

    ld [hl], $0a

Bonus_SelectSuccessMessage::
    ld a, [wBonusDestination]
    add $05

Bonus_StartResultMessage::
    call StartMessageFar
    ld a, [wBonusDestination]
    cp $01
    ret nz

    ld a, [wMinigameResultFlag]
    or a
    ret nz

    ld a, $46
    call PlaySound_Queue1
    ret


Bonus_CheckRewardFrame::
    ld a, [wScreenFrameCounter]
    cp $60
    jr nz, Bonus_ReturnToStationChoice

    ld a, [wMinigameResultFlag]
    or a
    jr nz, Bonus_QueueUpdatedRoundNumber

    ld a, [wBonusDestination]
    or a
    jr nz, Bonus_ApplyFormOrLifeReward

    ld a, $0f
    call AddBonusCounter
    jr Bonus_QueueUpdatedRoundNumber

Bonus_ApplyFormOrLifeReward::
    dec a
    jr nz, Bonus_ApplyExtraLifeReward

    ld a, [wMsgSubstitutionId]
    sub $0a
    ldh [hPlayerForm], a
    call QueuePlayerFormHudIcon
    jr Bonus_QueueUpdatedRoundNumber

Bonus_ApplyExtraLifeReward::
    call AddExtraLife
    ld a, $46
    call PlaySound_Queue1

Bonus_QueueUpdatedRoundNumber::
    ld a, [wBonusDestination]
    ld hl, wBonusMinigameRounds
    rst $38
    ld a, [wBonusDestination]
    ld d, a
    ld a, [hl]
    cp $0a
    jr c, Bonus_EncodeRoundNumberTile

    ld a, $c1

Bonus_EncodeRoundNumberTile::
    add $04
    inc d
    ld bc, $0005
    ld hl, _SCRN0 + $160

Bonus_AdvanceToRoundNumberColumn::
    add hl, bc
    dec d
    jr nz, Bonus_AdvanceToRoundNumberColumn

    call QueueTilemapByte
    call Bonus_ClearMessageBox
    ld a, $80
    ld [wMessageFlags], a
    ld a, [wBonusDestination]
    inc a
    call StartMessageFar

Bonus_ReturnToStationChoice::
    ld a, [wScreenFrameCounter]
    cp $60
    ret c

    ld a, $01
    ld [wScreenSubstate], a
    ld [wScreenFrameCounter], a
    jp Bonus_ShowNoHealthMessage


Bonus_DrawRoundNumbers::
    ld b, $03
    ld hl, _SCRN0 + $165
    ld de, wBonusMinigameRounds

Bonus_ReadNextRoundNumber::
    ld a, [de]
    inc de
    cp $0a
    jr c, Bonus_StoreRoundNumberTile

    ld a, $c1

Bonus_StoreRoundNumberTile::
    add $04
    ld [hl], a
    push bc
    ld bc, $0005
    add hl, bc
    pop bc
    dec b
    jr nz, Bonus_ReadNextRoundNumber

    ret


Bonus_SelectRewardByRoundTier::
    ld a, [wBonusMinigameRounds + 1]
    ld c, $0b
    ld d, $02
    cp $04
    jr c, Bonus_StoreRoundRewardSelection

    ld c, $0c
    ld d, $03
    cp $07
    jr c, Bonus_StoreRoundRewardSelection

    ld c, $0d
    ld d, $01

Bonus_StoreRoundRewardSelection::
; C selects the displayed form name. D records $02/$03/$01 for rounds 1-3/4-6/7-10.
; Downstream use of the HRAM output is unconfirmed. See notes/symbol_cleanup.md.
    ld a, d
    ldh [hBonusRoundTierOutput], a
    ld a, c
    ld [wMsgSubstitutionId], a
    ret


BonusDestinationXPositions::
; Three minigames, followed by the exit marker and right screen boundary.
    db $1e, $46, $6e, $8e

BonusDestinationExitX::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $b0

BonusHorizontalBorderMetasprite::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $10, $af, $10, $00, $20, $af, $10, $00, $30, $af, $10, $00, $40, $af, $10
    db $00, $50, $af, $10, $00, $60, $af, $10, $00, $70, $af, $10, $00, $80, $af, $10
    db $80

BonusVerticalBorderMetasprite::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $08, $10, $af, $10, $80

BonusFormRewardHeadingTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $c7, $c8, $c9, $ca, $7d
