InitMinigame2::
; Mode 2 initialization.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $8c
    ldh [hOamMaxY], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, BANK(GfxRle_b06_5851)
    ld hl, GfxRle_b06_5851
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_60db)
    ld hl, LayoutRle_b06_60db
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenSubstate], a
    ld [wScreenPhaseCounter], a
    ld a, $0e
    ld [wScreenPaletteId], a
    ret


UpdateMinigame2::
; Mode 2 update.
    ld a, [wScreenSubstate]
    rst $00

Minigame2StateHandlers::
    dw Minigame_WaitForStart ; $00
    dw BugHunt_UpdateRoundIntro ; $01
    dw BugHunt_UpdateRound ; $02

BugHunt_UpdateRoundIntro::
    call UpdateMessageFar
    ld bc, $4050
    ld d, $1a
    call DrawBank3MetaspriteNormal
    ld bc, $4920
    ld d, $3e
    ld a, [wMinigameRound]
    cp $04
    call nc, DrawBank3MetaspriteNormal
    ld bc, $4980
    ld d, $46
    ld a, [wMinigameRound]
    cp $07
    call nc, DrawBank3MetaspriteNormal
    ld a, [wMinigamePhaseCounter]
    cp $ff
    jr nz, BugHunt_TickStartCountdown

    ld a, [wMinigameRound]
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $14
    call StartMessageFar
    ld bc, _SCRN0 + $201
    ld de, $9111 ; Fill 17 columns with tile $91.
    call QueueVramFill
    ld bc, _SCRN0 + $221
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [wMinigamePhaseCounter], a
    ret


BugHunt_TickStartCountdown::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ld b, a
    ld a, [wMinigamePhaseCounter]
    or b
    jp nz, BugHunt_ShowCountdownDigit

    call InitSound
    ld a, $24
    call PlaySound_Queue3
    ld de, BugHuntHudTiles
    ld hl, _SCRN0 + $201
    ld bc, $1102
    call QueueTilemapRect
    ld bc, _SCRN0 + $148
    ld de, $0004
    call QueueVramFill
    ld hl, _SCRN0 + $129
    xor a
    call QueueTilemapByte
    ld a, [wMinigameRound]
    ld b, a
    sla a
    add b
    ld hl, BugHuntRoundGoalTiles
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, _SCRN0 + $22f
    ld a, [de]
    cp $04
    jr nz, BugHunt_DrawRoundGoal

    inc de
    inc hl
    dec b

BugHunt_DrawRoundGoal::
    call QueueTilemapRect
    xor a
    ld [wMinigameTimerHundreds], a
    ld a, $09
    ld [wMinigameTimerTens], a
    ld [wMinigameTimerOnes], a
    ld a, $04
    ld [wMinigameScoreHundreds], a
    ld [wMinigameScoreTens], a
    ld [wMinigameScoreOnes], a
    ld a, $32
    ld [wMinigamePhaseCounter], a
    ld a, $02
    ld [wScreenSubstate], a
    ld a, $a0
    ld [wBugSpawnDelay], a
    ld hl, SceneAnim_7913
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wBugPhase], a
    ld [wBugPlayerBlinkTimer], a
    ld a, $50
    ld [wBugPlayerX], a
    ld a, $40
    ld [wBugPlayerY], a
    ld a, $02
    ld [wBugPlayerFacing], a
    ld hl, BugHuntInitialHazardRecords
    ld de, wBugHazardSlots
    ld b, $10

BugHunt_CopyHazardInitialState::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, BugHunt_CopyHazardInitialState

    ld a, $80
    ld hl, wBugSlots
    ld bc, $0008
    ld d, $10

BugHunt_ClearNextBugSlot::
    ld [hl], a
    add hl, bc
    dec d
    jr nz, BugHunt_ClearNextBugSlot

    call AdvanceScreenRandomByte
    and $03
    ld [wBugSpawnGate], a
    ret


BugHunt_ShowCountdownDigit::
    ld a, [wScreenFrameCounter]
    or a
    ret nz

    xor a
    ld [wMessageFlags], a
    ld a, [wMinigamePhaseCounter]
    dec a
    ld [wMinigamePhaseCounter], a
    add $10
    call StartMessageFar
    ld bc, _SCRN0 + $226
    ld de, $0008
    call QueueVramFill
    ld hl, _SCRN0 + $20c
    ld a, $91
    call QueueTilemapByte
    ld a, $32
    ld [wScreenFrameCounter], a
    ld a, [wMinigamePhaseCounter]
    or a
    ld a, $59
    jr nz, BugHunt_PlayCountdownCue

    ld a, $5a

BugHunt_PlayCountdownCue::
    call PlaySound
    ret


BugHunt_UpdateRound::
    ld a, [wBugHazardFrameCounter]
    inc a
    ld [wBugHazardFrameCounter], a
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, PauseMinigame
    ld a, [wBugPlayerX]
    ld c, a
    ld a, [wBugPlayerY]
    ld b, a
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wBugPlayerBlinkTimer]
    or a
    jr z, BugHunt_UpdateHazardsAndTimer

    dec a
    ld [wBugPlayerBlinkTimer], a
    bit 3, a
    jr z, BugHunt_UpdateHazardsAndTimer

    xor a
    ldh [hOamWritePos], a

BugHunt_UpdateHazardsAndTimer::
    call BugHunt_UpdateRoundHazards
    call BugHunt_DrawCaughtBugPopup
    ld a, [wBugWingFrameCounter]
    inc a
    ld [wBugWingFrameCounter], a
    call TickMinigameCountdown
    or a
    jr nz, BugHunt_TickSpawnGate

    ld a, $04
    ld [wBugPhase], a
    ld hl, SceneAnim_7960
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $01
    ld [wMinigameResultFlag], a
    ld a, $90
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3

BugHunt_TickSpawnGate::
    ld a, [wBugSpawnDelay]
    dec a
    ld [wBugSpawnDelay], a
    cp $60
    jp nc, BugHunt_UpdateBugSlots

    and $0f
    jp nz, BugHunt_UpdateBugSlots

    ld a, [wBugSpawnGate]
    sla a
    sla a
    ld hl, BugHuntSpawnGates
    rst $38
    ld a, [hl+]
    push hl
    ld h, [hl]
    ld l, a
    ld a, [wBugSpawnDelay]
    ld de, BugHuntGateBaseTiles
    bit 4, a
    jr z, BugHunt_DrawSpawnGate

    ld a, [wBugPhase]
    cp $04
    jp z, BugHunt_DrawSpawnGate

    ld de, BugHuntGateBlinkTiles

BugHunt_DrawSpawnGate::
    ld bc, $0301
    call QueueTilemapRect
    pop hl
    ld a, [wBugSpawnDelay]
    or a
    jp nz, BugHunt_UpdateBugSlots

    ld a, [wBugPhase]
    cp $04
    jp z, BugHunt_UpdateBugSlots

    inc hl
    ld a, [hl+]
    ldh [hBugSpawnX], a
    ld a, [hl]
    ldh [hBugSpawnY], a
    ld a, [wMinigameRound]
    dec a
    add a
    add a
    ld hl, BugHuntRoundSpawnWeights
    rst $38
    call AdvanceScreenRandomByte
    and $07
    ld b, $00

BugHunt_SelectWeightedBugType::
    sub [hl]
    jr c, BugHunt_SelectSpawnDirection

    inc b
    inc hl
    jr BugHunt_SelectWeightedBugType

BugHunt_SelectSpawnDirection::
    ld a, b
    ldh [hBugSpawnType], a
    ld a, [wBugSpawnGate]
    ld b, a
    add a
    add b
    ld hl, BugHuntGateDirectionChoices
    rst $38
    ldh a, [hBugSpawnType]
    cp $03
    jr nz, BugHunt_PickOrdinaryBugDirection

    call AdvanceScreenRandomByte
    bit 0, a
    jr z, BugHunt_FindFreeBugSlot

    inc hl
    jr BugHunt_FindFreeBugSlot

BugHunt_PickOrdinaryBugDirection::
    call ChooseScreenRandomThird
    rst $38

BugHunt_FindFreeBugSlot::
    ld d, [hl]
    ld hl, wBugSlots
    ld b, $10

BugHunt_CheckNextBugSlot::
    ld a, [hl]
    bit 7, a
    jr nz, BugHunt_WriteSpawnedBug

    ld a, $08
    rst $38
    dec b
    jr nz, BugHunt_CheckNextBugSlot

    jr BugHunt_UpdateBugSlots

BugHunt_WriteSpawnedBug::
    ldh a, [hBugSpawnType]
    ld [hl+], a
    ld [hl], d
    inc hl
    ldh a, [hBugSpawnX]
    ld [hl+], a
    ldh a, [hBugSpawnY]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl], a
    call AdvanceScreenRandomByte
    and $7f
    add $40
    ld [wBugSpawnDelay], a
    call AdvanceScreenRandomByte
    and $03
    ld [wBugSpawnGate], a

BugHunt_UpdateBugSlots::
    ld b, $10
    ld hl, wBugSlots

BugHunt_UpdateNextBug::
    push bc
    push hl
    ld a, [hl]
    and $c0
    jp nz, BugHunt_AdvanceBugSlot

    ld a, [hl]
    push hl
    cp $03
    call nc, BugHunt_UpdateSpecialBugMotion
    pop hl
    ld a, [hl]
    sla a
    ld de, BugHuntMotionSteps
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld bc, $0004
    add hl, bc
    ld a, [de]
    inc de
    add [hl]
    ld [hl], a
    ld a, [de]
    adc $00
    dec hl
    dec hl
    dec hl
    ld b, [hl]
    inc hl
    push hl
    bit 1, b
    jr nz, BugHunt_SelectMotionAxis

    cpl
    inc a

BugHunt_SelectMotionAxis::
    bit 0, b
    jr nz, BugHunt_MoveBugAndCheckX

    inc hl

BugHunt_MoveBugAndCheckX::
    add [hl]
    ld [hl], a
    pop hl
    ld a, [hl]
    ld c, a
    bit 7, a
    jr z, BugHunt_CheckBugY

    cp $a0
    jr c, BugHunt_CheckBugY

    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr BugHunt_AdvanceBugSlot

BugHunt_CheckBugY::
    inc hl
    ld a, [hl]
    ld b, a
    bit 7, a
    jr z, BugHunt_SelectBugAnimationPhase

    cp $80
    jr c, BugHunt_SelectBugAnimationPhase

    dec hl
    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr BugHunt_AdvanceBugSlot

BugHunt_SelectBugAnimationPhase::
    dec hl
    dec hl
    ld a, [wBugWingFrameCounter]
    and $10
    jr z, BugHunt_SelectBugMetasprite

    scf

BugHunt_SelectBugMetasprite::
    ld a, [hl-]
    rla
    ld d, a
    ld a, [hl]
    swap a
    srl a
    or d
    ld hl, BugHuntBugFrames
    rst $38
    ld a, $01
    ld d, [hl]
    bit 7, d
    jr nz, BugHunt_DrawBug

    xor a

BugHunt_DrawBug::
    ldh [hSpriteFlags], a
    ld a, d
    and $7f
    ld d, a
    call DrawBank3MetaspriteFar

BugHunt_AdvanceBugSlot::
    pop hl
    ld bc, $0008
    add hl, bc
    pop bc
    dec b
    jp nz, BugHunt_UpdateNextBug

    ld a, [wBugPhase]
    rst $00

BugHuntRoundPhaseHandlers::
    dw BugHunt_UpdatePlayerInput ; $00
    dw BugHunt_UpdateCatch ; $01
    dw BugHunt_UpdateHitReaction ; $02
    dw BugHunt_Phase03Return ; $03, no normal writer to wBugPhase
    dw BugHunt_UpdateResult ; $04

BugHunt_Phase03Return::
    ret


BugHunt_UpdateSpecialBugMotion::
; Types 3 and 4 alternate timed phases. Type 3 also reads the signed Y wobble table.
    ld a, [hl]
    and $01
    jr z, BugHunt_TickSpecialBugDirectionPhase

    ld bc, $0005
    add hl, bc
    ld a, [hl]
    dec hl
    dec hl
    ld bc, BugHuntSpecialBugYOffsets
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, [bc]
    add [hl]
    ld [hl], a
    inc hl
    inc hl
    dec [hl]
    ret nz

    ld [hl], $20
    ld bc, -$0005
    add hl, bc
    inc [hl]
    ret


BugHunt_TickSpecialBugDirectionPhase::
    ld bc, $0005
    add hl, bc
    dec [hl]
    ld a, [hl]
    cp $10
    jr nz, BugHunt_WaitOrSwitchSpecialBugPhase

    inc hl
    inc [hl]
    ld e, [hl]
    bit 0, e
    ret nz

    ld bc, -$0005
    add hl, bc
    call ChooseScreenRandomThird
    dec a
    ld d, a
    ld a, e
    and $fc
    jr nz, BugHunt_StoreSpecialBugDirection

BugHunt_TryNextSpecialBugDirection::
    ld a, d
    inc a
    cp $02
    jr nz, BugHunt_SetDirectionProbeDelta

    ld a, $ff

BugHunt_SetDirectionProbeDelta::
    ld d, a
    add [hl]
    ld b, a
    push hl
    ld c, $3c
    bit 1, b
    jr nz, BugHunt_SelectDirectionProbeAxis

    ld c, $c4

BugHunt_SelectDirectionProbeAxis::
    inc hl
    bit 0, b
    jr nz, BugHunt_CheckDirectionProbeBounds

    inc hl

BugHunt_CheckDirectionProbeBounds::
    ld a, c
    add [hl]
    pop hl
    cp $0c
    jr c, BugHunt_TryNextSpecialBugDirection

    cp $88
    jr nc, BugHunt_TryNextSpecialBugDirection

BugHunt_StoreSpecialBugDirection::
    ld a, d
    add [hl]
    and $03
    ld [hl], a
    ret


BugHunt_WaitOrSwitchSpecialBugPhase::
    ld a, [hl]
    or a
    ret nz

    ld [hl], $10
    ld bc, -$0005
    add hl, bc
    dec [hl]
    ret


BugHunt_UpdatePlayerInput::
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, BugHunt_CheckMovementInput

    ld a, [wBugPlayerFacing]
    and $03
    ld hl, Minigame2ActionAnimationPointers
    rst $20
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $01
    ld [wBugPhase], a
    ld a, $11
    ld [wScreenFrameCounter], a
    ld a, $ff
    ld [wBugCatchType], a
    ret


BugHunt_CheckMovementInput::
    ldh a, [hJoyHeld]
    and $f0
    jr nz, BugHunt_ComputePlayerStep

    ld a, [wSceneAnim0Timer]
    inc a
    ld [wSceneAnim0Timer], a
    ret


BugHunt_ComputePlayerStep::
    ld bc, $0180
    ld a, [wBugPlayerStepFraction]
    add c
    ld [wBugPlayerStepFraction], a
    ld a, $00
    adc b
    ld c, a
    ld d, $00
    ld e, d
    ldh a, [hJoyHeld]
    ld h, a
    ld b, $ff
    bit 6, h
    jr z, BugHunt_CheckLeftInput

    ld b, $00
    ld a, $00
    sub c
    ld e, a

BugHunt_CheckLeftInput::
    bit 5, h
    jr z, BugHunt_CheckDownInput

    ld b, $01
    ld a, $00
    sub c
    ld d, a

BugHunt_CheckDownInput::
    bit 7, h
    jr z, BugHunt_CheckRightInput

    ld b, $02
    ld e, c

BugHunt_CheckRightInput::
    bit 4, h
    jr z, BugHunt_MovePlayerAndSetFacing

    ld b, $03
    ld d, c

BugHunt_MovePlayerAndSetFacing::
    ld a, [wBugPlayerX]
    add d
    ld [wBugPlayerX], a
    ld a, [wBugPlayerY]
    add e
    ld [wBugPlayerY], a
    ld a, [wBugPlayerFacing]
    ld hl, BugHuntFacingJoyMasks
    rst $38
    ld c, [hl]
    ldh a, [hJoyHeld]
    and c
    jr nz, BugHunt_ClampPlayerMinX

    ld a, b
    bit 7, a
    jr nz, BugHunt_ClampPlayerMinX

    ld [wBugPlayerFacing], a
    and $03
    ld hl, Minigame2IdleAnimationPointers
    rst $20
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

BugHunt_ClampPlayerMinX::
    ld a, [wBugPlayerX]
    cp $0a
    jr nc, BugHunt_ClampPlayerMaxX

    ld a, $0a

BugHunt_ClampPlayerMaxX::
    cp $95
    jr c, BugHunt_StoreXAndClampMinY

    ld a, $95

BugHunt_StoreXAndClampMinY::
    ld [wBugPlayerX], a
    ld a, [wBugPlayerY]
    cp $0a
    jr nc, BugHunt_ClampPlayerMaxY

    ld a, $0a

BugHunt_ClampPlayerMaxY::
    cp $75
    jr c, BugHunt_StorePlayerY

    ld a, $75

BugHunt_StorePlayerY::
    ld [wBugPlayerY], a
    ret


BugHunt_UpdateCatch::
    ld a, [wBugCatchType]
    bit 7, a
    jr z, BugHunt_TickCatchAnimation

    ld a, [wBugPlayerFacing]
    add a
    add a
    ld b, a
    add a
    add b
    ld hl, BugHuntCatchBounds
    rst $38
    ld a, [wScreenFrameCounter]
    ld bc, $0004
    cp $06
    jr nc, BugHunt_CheckLateCatchFrame

    add hl, bc

BugHunt_CheckLateCatchFrame::
    cp $0c
    jr nc, BugHunt_BuildCatchBounds

    add hl, bc

BugHunt_BuildCatchBounds::
    ld a, [wBugPlayerX]
    ld b, a
    ld a, [wBugPlayerY]
    ld c, a
    ld a, [hl+]
    add b
    ldh [hBugCatchMinX], a
    ld a, [hl+]
    add c
    ldh [hBugCatchMinY], a
    ld a, [hl+]
    add b
    ldh [hBugCatchMaxX], a
    ld a, [hl+]
    add c
    ldh [hBugCatchMaxY], a
    ld b, $10
    ld hl, wBugSlots

BugHunt_TestNextBugAgainstCatchBounds::
    push hl
    ld a, [hl+]
    bit 7, a
    jr nz, BugHunt_AdvanceCatchTestSlot

    inc hl
    ld c, [hl]
    ldh a, [hBugCatchMinX]
    cp c
    jr nc, BugHunt_AdvanceCatchTestSlot

    ldh a, [hBugCatchMaxX]
    cp c
    jr c, BugHunt_AdvanceCatchTestSlot

    inc hl
    ld c, [hl]
    ldh a, [hBugCatchMinY]
    cp c
    jr nc, BugHunt_AdvanceCatchTestSlot

    ldh a, [hBugCatchMaxY]
    cp c
    jr c, BugHunt_AdvanceCatchTestSlot

    dec hl
    dec hl
    dec hl
    ld a, [hl]
    cp $04
    jr nz, BugHunt_StoreCaughtType

    ld a, $03

BugHunt_StoreCaughtType::
    ld [wBugCatchType], a
    ld a, $80
    ld [hl], a
    pop hl
    jr BugHunt_TickCatchAnimation

BugHunt_AdvanceCatchTestSlot::
    pop hl
    ld a, $08
    rst $38
    dec b
    jr nz, BugHunt_TestNextBugAgainstCatchBounds

BugHunt_TickCatchAnimation::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    xor a
    ld [wBugPhase], a
    ld a, [wBugCatchType]
    bit 7, a
    jr nz, BugHunt_RestoreFacingAnimation

    ld [wBugLastCaughtType], a
    ld a, $44
    call PlaySound
    ld a, [wBugPlayerX]
    ld [wBugPopupX], a
    ld a, [wBugPlayerY]
    ld [wBugPopupY], a
    ld a, $20
    ld [wScreenPhaseCounter], a
    ld a, [wBugLastCaughtType]
    ld hl, BugHuntTypeScoreDigits
    rst $20
    ld b, l
    ld c, h
    ld hl, BugHuntRoundGoalTiles
    call Minigame_AddScoreAndCompareGoal
    jr c, BugHunt_RestoreFacingAnimation

    ld a, $04
    ld [wBugPhase], a
    xor a
    ld [wMinigameResultFlag], a
    ld a, $90
    ld [wScreenFrameCounter], a
    xor a
    ld [wBugHazardSlots + BUG_HAZARD_OFS_AIM_REFRESH], a
    ld [wBugHazardSlots + BUG_HAZARD_SIZE + BUG_HAZARD_OFS_AIM_REFRESH], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


BugHunt_RestoreFacingAnimation::
    ld a, [wBugPlayerFacing]
    and $03
    ld hl, Minigame2IdleAnimationPointers
    rst $20
    ld a, $04
    rst $38
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ret


BugHunt_DrawCaughtBugPopup::
    ld a, [wScreenPhaseCounter]
    or a
    ret z

    ld a, [wScreenPhaseCounter]
    dec a
    ld [wScreenPhaseCounter], a
    srl a
    ld hl, BugHuntCaughtPopupXOffsets
    rst $38
    ld a, [wBugPopupX]
    add [hl]
    ld c, a
    ld a, [wScreenPhaseCounter]
    srl a
    sub $18
    ld b, a
    ld a, [wBugPopupY]
    add b
    ld b, a
    ld hl, BugHuntCaughtPopupFrames
    ld a, [wBugLastCaughtType]
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteNormal
    ret
