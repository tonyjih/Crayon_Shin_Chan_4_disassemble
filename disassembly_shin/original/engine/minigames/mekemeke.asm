InitMinigame1::
; Mode 1 initialization; the scene work area is shared with the other minigames.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld [wMekemekePaletteFlashTimer], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, BANK(GfxRle_b06_5851)
    ld hl, GfxRle_b06_5851
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_6839)
    ld hl, GfxRle_b06_6839
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_6e44)
    ld hl, GfxRle_b06_6e44
    ld de, _VRAM + $900
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_6fe5)
    ld hl, LayoutRle_b06_6fe5
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
IF DEF(ZH_TW)
    call Minigame_DrawStartPromptZh
ENDC
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenSubstate], a
    ld [wMekemekeEnemySlotsEnd], a
    ld a, $0d
    ld [wScreenPaletteId], a
    ret


UpdateMinigame1::
; Mode 1 update.
    ld a, [wMekemekePaletteFlashTimer]
    or a
    jr z, Mekemeke_RestoreNormalPalette

    dec a
    ld [wMekemekePaletteFlashTimer], a
    ld a, $1b
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    jr Mekemeke_DispatchPhase

Mekemeke_RestoreNormalPalette::
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, [wSgbEnabled]
    or a
    jr z, Mekemeke_DispatchPhase

    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a

Mekemeke_DispatchPhase::
    ld a, [wScreenSubstate]
    rst $00

Minigame1StateHandlers::
    dw Minigame_WaitForStart ; $00
    dw Mekemeke_UpdateRoundIntro ; $01
    dw Mekemeke_UpdateRound ; $02
    dw Mekemeke_UpdateFailure ; $03
    dw Mekemeke_UpdateClear ; $04

Mekemeke_UpdateRoundIntro::
    xor a
    ld [wScreenPhaseCounter], a
    call Mekemeke_QueueLaneTileAnimation
    call UpdateMessageFar
    ld c, $0f
    ld b, $1c
    ld d, $60
    call DrawBank3MetaspriteNormal
    ld a, [wMinigamePhaseCounter]
    cp $ff
    jr nz, Mekemeke_TickStartCountdown

    ld a, [wMinigameRound]
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $14
    call StartMessageFar
    ld bc, _SCRN0 + $201
    ld de, $ac11
    call QueueVramFill
    ld bc, _SCRN0 + $221
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [wMinigamePhaseCounter], a
    ret


Mekemeke_TickStartCountdown::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ld b, a
    ld a, [wMinigamePhaseCounter]
    or b
    jp nz, Mekemeke_ShowCountdownDigit

    call InitSound
    ld a, $2c
    call PlaySound_Queue3
    ld bc, _SCRN0 + $128
    ld de, $0004
    call QueueVramFill
    ld bc, _SCRN0 + $148
    ld de, $0004
    call QueueVramFill
    ld de, MekemekeHudTiles
    ld hl, _SCRN0 + $201
    ld bc, $1102
    call QueueTilemapRect
    ld a, $02
    ld [wScreenSubstate], a
    xor a
    ld [wMekemekePlayerLane], a
    ld [wMekemekePlayerShotX], a
    ld a, [wMinigameRound]
    ld b, a
    sla a
    add b
    ld hl, MekemekeRoundGoalTiles
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, _SCRN0 + $22f
    ld a, [de]
    cp $04
    jr nz, Mekemeke_DrawRoundGoal

    inc de
    inc hl
    dec b

Mekemeke_DrawRoundGoal::
    call QueueTilemapRect
    ld a, [wMinigameRound]
    dec a
    ld b, a
    add a
    add b
    ld hl, MekemekeRoundTimerDigits
    rst $38
    ld a, [hl+]
    ld [wMinigameTimerHundreds], a
    ld a, [hl+]
    ld [wMinigameTimerTens], a
    ld a, [hl+]
    ld [wMinigameTimerOnes], a
    ld a, $01
    ld [wMinigamePhaseCounter], a
    ld a, $04
    ld [wMinigameScoreHundreds], a
    ld [wMinigameScoreTens], a
    ld [wMinigameScoreOnes], a
    ld hl, SceneAnim_79bb
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wMekemekeHitReactionTimer], a
    ld [wMekemekeBlastSpan], a
    cpl
    ld [wMekemekeBlastLaneFlags], a
    call AdvanceScreenRandomByte
    and $07
    add $0a
    ld [wMekemekeBlastPickCooldown], a
    ld b, $04
    ld hl, wMekemekeEnemySlots

Mekemeke_InitNextEnemySlot::
    xor a
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $9c
    ld [hl+], a
    ld a, $23
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    dec b
    jr nz, Mekemeke_InitNextEnemySlot

    ret


Mekemeke_ShowCountdownDigit::
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
IF !DEF(ZH_TW)
    ld bc, _SCRN0 + $226
    ld de, $0008
    call QueueVramFill
    ld hl, _SCRN0 + $20c
    ld a, $ac
    call QueueTilemapByte
ENDC
    ld a, $32
    ld [wScreenFrameCounter], a
    ld a, [wMinigamePhaseCounter]
    or a
    ld a, $59
    jr nz, Mekemeke_PlayCountdownCue

    ld a, $5a

Mekemeke_PlayCountdownCue::
    call PlaySound
    ret


Mekemeke_UpdateRound::
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, PauseMinigame
    ld a, [wMekemekePlayerLane]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wMinigamePhaseCounter]
    cp $01
    jr nz, Mekemeke_UpdateBlast

    ld a, [wMekemekeBlastPickCooldown]
    or a
    jr z, Mekemeke_UpdateBlast

    dec a
    ld [wMekemekeBlastPickCooldown], a

Mekemeke_UpdateBlast::
    ld a, [wMekemekeBlastSpan]
    or a
    jp z, Mekemeke_CheckAttackInput

    ld c, a
    ld a, [wMekemekeBlastLaneFlags]
    bit 7, a
    jr z, Mekemeke_ProjectBlast

    ld a, [wMekemekeBlastSpan]
    dec a
    ld [wMekemekeBlastSpan], a

Mekemeke_ProjectBlast::
    ld a, [wMekemekeBlastLaneFlags]
    and $7f
    swap a
    add a
    or $18
    ld b, a
    ld a, $00
    bit 7, c
    jr z, Mekemeke_DrawBlastAndCheckLane

    ld a, $02

Mekemeke_DrawBlastAndCheckLane::
    ldh [hSpriteFlags], a
    ld d, $76
    call DrawBank3MetaspriteFar
    ld a, [wMekemekePlayerLane]
    ld b, a
    ld a, [wMekemekeBlastLaneFlags]
    bit 7, a
    jr z, Mekemeke_CheckAttackInput

    and $7f
    cp b
    jr nz, Mekemeke_CheckAttackInput

    ld a, [wMekemekeBlastSpan]
    cp $18
    jr nc, Mekemeke_CheckAttackInput

    ld a, $20
    ld [wMekemekePaletteFlashTimer], a
    ld a, $49
    call PlaySound_Queue1
    xor a
    ld c, a
    ld [wMekemekeBlastSpan], a
    ld hl, wMekemekeEnemySlots
    ld de, $0008
    ld b, $04

Mekemeke_BlastNextEnemy::
    push hl
    ld a, [hl]
    res 3, [hl]
    set 1, [hl]
    inc hl
    inc hl
    bit 1, a
    jr nz, Mekemeke_AdvanceBlastSlot

    ld a, [hl]
    cp $98
    inc hl
    inc hl
    inc hl
    ld [hl], $00
    jr nc, Mekemeke_AdvanceBlastSlot

    inc c

Mekemeke_AdvanceBlastSlot::
    pop hl
    add hl, de
    dec b
    jr nz, Mekemeke_BlastNextEnemy

    ld a, c
    ld c, $00
    bit 0, a
    jr z, Mekemeke_AddBlastScore

    ld c, $05

Mekemeke_AddBlastScore::
    srl a
    ld b, a
    ld hl, MekemekeRoundGoalTiles
    call Minigame_AddScoreAndCompareGoal
    jp nc, Mekemeke_BeginClearAnimation

Mekemeke_CheckAttackInput::
    ldh a, [hJoyPressed]
    and $03
    jr z, Mekemeke_UpdateEnemiesAndCountdown

    ld a, [wMekemekePlayerShotX]
    or a
    jr nz, Mekemeke_UpdateEnemiesAndCountdown

    ld a, [wMekemekePlayerLane]
    ld [wMekemekePlayerShotLane], a
    ld a, $1a
    ld [wMekemekePlayerShotX], a
    xor a
    ld [wMekemekePlayerShotXSubpixel], a
    ld a, $50
    call PlaySound
    ld hl, SceneAnim_79b7
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

Mekemeke_UpdateEnemiesAndCountdown::
    call Mekemeke_UpdateEnemyLanes
    call TickMinigameCountdown
    or a
    jr nz, Mekemeke_TickHitReaction

    ld a, $03
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79cd
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    ret


Mekemeke_TickHitReaction::
    ld a, [wMekemekeHitReactionTimer]
    dec a
    ld [wMekemekeHitReactionTimer], a
    cp $ff
    jr z, Mekemeke_ReadLaneInput

    or a
    ret nz

    ld hl, SceneAnim_79bb
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

Mekemeke_ReadLaneInput::
    xor a
    ld [wMekemekeHitReactionTimer], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wMekemekePlayerLane]
    bit 6, b
    jr z, Mekemeke_CheckDownInput

    or a
    jr z, Mekemeke_CheckDownInput

    dec a

Mekemeke_CheckDownInput::
    bit 7, b
    jr z, Mekemeke_StoreLaneAndMoveShot

    cp $03
    jr nc, Mekemeke_StoreLaneAndMoveShot

    inc a

Mekemeke_StoreLaneAndMoveShot::
    ld [wMekemekePlayerLane], a
    ld hl, wMekemekePlayerShotXSubpixel
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    or a
    ret z

    ld bc, $0300
    add hl, bc
    ld a, l
    ld [wMekemekePlayerShotXSubpixel], a
    ld a, h
    ld [wMekemekePlayerShotX], a
    ld a, h
    cp $98
    jr nc, Mekemeke_ClearPlayerShot

    ld c, h
    ld a, [wMekemekePlayerShotLane]
    swap a
    add a
    or $16
    ld b, a
    ld d, $62
    call DrawBank3MetaspriteNormal
    ret


Mekemeke_ClearPlayerShot::
    xor a
    ld [wMekemekePlayerShotX], a
    ret


Mekemeke_UpdateEnemyLanes::
    call Mekemeke_QueueLaneTileAnimation
    ldh a, [hMekemekeVariantCount]
    ldh [hMekemekePrevVariantCount], a
    xor a
    ldh [hMekemekeVariantCount], a
    ld a, $04
    ldh [hMekemekeSlotsRemaining], a
    ld hl, wMekemekeEnemySlotsEnd

Mekemeke_UpdateNextEnemyLane::
    ldh a, [hMekemekeSlotsRemaining]
    dec a
    ldh [hMekemekeLaneIndex], a
    swap a
    add a
    or $17
    ldh [hMekemekeLaneY], a
    ld bc, -MEKEMEKE_ENEMY_SIZE
    add hl, bc
    push hl
    ld a, [wScreenSubstate]
    cp $04
    jr nz, Mekemeke_CountActiveVariant

    set 1, [hl]
    res 3, [hl]

Mekemeke_CountActiveVariant::
    ld a, [hl+]
    ld d, a
    and $07
    cp $01
    jr nz, Mekemeke_SelectEnemyVelocity

    ldh a, [hMekemekeVariantCount]
    inc a
    ldh [hMekemekeVariantCount], a

Mekemeke_SelectEnemyVelocity::
    ld bc, $0200
    bit 1, d
    jr nz, Mekemeke_CheckStationaryAttack

    push hl
    push de
    ld a, [wMinigameRound]
    dec a
    ld hl, MekemekeRoundEnemyVelocities
    bit 0, d
    jr z, Mekemeke_ReadRoundEnemyVelocity

    add $0a

Mekemeke_ReadRoundEnemyVelocity::
    rst $20
    ld c, l
    ld b, h
    pop de
    pop hl

Mekemeke_CheckStationaryAttack::
    bit 3, d
    jr z, Mekemeke_MoveEnemyAndCheckDefenseLine

    ld bc, $0000

Mekemeke_MoveEnemyAndCheckDefenseLine::
    ld a, c
    add [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a
    ld a, [hl-]
    dec hl
    cp $2a
    jr nc, Mekemeke_CheckEnemyRespawn

    push hl
    ld a, $03
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79cd
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop hl

Mekemeke_CheckEnemyRespawn::
    inc hl
    inc hl
    ld a, [hl]
    bit 1, d
    jr z, Mekemeke_UpdateBlastSpanFromEnemy

    cp $a8
    jr c, Mekemeke_UpdateBlastSpanFromEnemy

    inc hl
    inc hl
    call AdvanceScreenRandomByte
    and $3f
    add $38
    ld [hl-], a
    dec hl
    call AdvanceScreenRandomByte
    and $3f
    add $a8
    ld [hl-], a
    dec hl
    ld a, [wMinigameRound]
    dec a
    add LOW(MekemekeVariantChances)
    ld c, a
    ld a, $00
    adc HIGH(MekemekeVariantChances)
    ld b, a
    ld a, [bc]
    ld c, a
    ldh a, [hMekemekePrevVariantCount]
    cp $03
    jr c, Mekemeke_RollEnemyVariant

    ld c, $00

Mekemeke_RollEnemyVariant::
    call AdvanceScreenRandomByte
    and $07
    cp c
    ld a, $00
    jr nc, Mekemeke_StoreVariantAndPickBlastLane

    ld a, $01

Mekemeke_StoreVariantAndPickBlastLane::
    ld [hl+], a
    inc hl
    ld a, [wMekemekeBlastPickCooldown]
    or a
    jr nz, Mekemeke_UpdateBlastSpanFromEnemy

    call AdvanceScreenRandomByte
    and $07
    add $0a
    ld [wMekemekeBlastPickCooldown], a
    ld a, [wMekemekeBlastSpan]
    or a
    jr nz, Mekemeke_UpdateBlastSpanFromEnemy

    ldh a, [hMekemekeSlotsRemaining]
    dec a
    ld [wMekemekeBlastLaneFlags], a

Mekemeke_UpdateBlastSpanFromEnemy::
    ld a, [wMekemekeBlastLaneFlags]
    bit 7, a
    jr nz, Mekemeke_CheckEnemyAttackStart

    ld a, [wMekemekeBlastLaneFlags]
    inc a
    ld b, a
    ldh a, [hMekemekeSlotsRemaining]
    cp b
    jr nz, Mekemeke_CheckEnemyAttackStart

    ld a, [hl]
    sub $14
    ld [wMekemekeBlastSpan], a

Mekemeke_CheckEnemyAttackStart::
    ld a, [hl+]
    ld c, a
    inc hl
    bit 3, d
    jr nz, Mekemeke_TickEnemyAttackWindup

    bit 0, d
    jr z, Mekemeke_SelectEnemyFrame

    ld a, [hl]
    cp c
    jr c, Mekemeke_SelectEnemyFrame

    ld [hl], $30
    pop de
    push de
    ld a, [de]
    set 3, a
    ld [de], a
    jr Mekemeke_SelectEnemyFrame

Mekemeke_TickEnemyAttackWindup::
    dec [hl]
    ld a, [hl]
    or a
    jr nz, Mekemeke_SelectEnemyFrame

    pop de
    push de
    ld a, [de]
    res 3, a
    ld [de], a
    inc hl
    ld a, c
    ld [hl-], a

Mekemeke_SelectEnemyFrame::
    dec hl
    push hl
    ldh a, [hMekemekeLaneY]
    ld b, a
    ld a, c
    srl a
    srl a
    srl a
    and $03
    bit 1, d
    jr z, Mekemeke_SelectAttackFrame

    ld a, $04

Mekemeke_SelectAttackFrame::
    bit 3, d
    jr z, Mekemeke_SelectVariantFrameTable

    ld a, $05

Mekemeke_SelectVariantFrameTable::
    ld hl, MekemekeEnemyFrames
    bit 0, d
    jr z, Mekemeke_DrawEnemyAndCheckIncomingShot

    ld hl, MekemekeVariantEnemyFrames

Mekemeke_DrawEnemyAndCheckIncomingShot::
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteWithPriority
    pop hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    jr z, Mekemeke_NextLaneOrCheckPlayerShot

    cp $20
    jr nc, Mekemeke_MoveIncomingShot

    cp $10
    jr c, Mekemeke_MoveIncomingShot

    ldh a, [hMekemekeLaneIndex]
    ld b, a
    ld a, [wMekemekePlayerLane]
    cp b
    jr nz, Mekemeke_MoveIncomingShot

    ld bc, SceneAnim_79cd
    ld a, c
    ld [wSceneAnim0PtrLo], a
    ld a, b
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [hl], a
    ld a, $78
    ld [wMekemekeHitReactionTimer], a
    ld a, $51
    call PlaySound

Mekemeke_MoveIncomingShot::
    inc hl
    ld bc, -$0280
    ld a, [hl]
    add c
    ld [hl-], a
    ld a, [hl]
    adc b
    cp $f0
    jr c, Mekemeke_StoreAndDrawIncomingShot

    xor a

Mekemeke_StoreAndDrawIncomingShot::
    ld [hl], a
    ld c, a
    ldh a, [hMekemekeLaneY]
    ld b, a
    ld d, $72
    call DrawBank3MetaspriteNormal

Mekemeke_NextLaneOrCheckPlayerShot::
    pop hl
    ldh a, [hMekemekeSlotsRemaining]
    dec a
    ldh [hMekemekeSlotsRemaining], a
    jp nz, Mekemeke_UpdateNextEnemyLane

    ld a, [wMekemekePlayerShotLane]
    swap a
    srl a
    ld hl, wMekemekeEnemySlots
    rst $38
    inc hl
    inc hl
    ld b, [hl]
    ld a, [wMekemekePlayerShotX]
    cp b
    jr c, Mekemeke_CheckProjectileClash

    ld a, $52
    call PlaySound
    xor a
    ld [wMekemekePlayerShotX], a
    dec hl
    dec hl
    set 1, [hl]
    res 3, [hl]
    ld bc, $0005
    add hl, bc
    ld [hl], $00
    ld a, [wMekemekeUnusedHitByte] ; The score helper replaces A with C ($05) before adding points.
    ld bc, $0005
    ld hl, MekemekeRoundGoalTiles
    call Minigame_AddScoreAndCompareGoal
    jr c, Mekemeke_ArmBlastAfterShot

Mekemeke_BeginClearAnimation::
    ld a, $04
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79be
    ld a, [wMinigameRound]
    cp $0a
    jr nz, Mekemeke_StoreClearAnimation

    ld hl, SceneAnim_79d4

Mekemeke_StoreClearAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


Mekemeke_ArmBlastAfterShot::
    ld a, [wMekemekePlayerShotLane]
    ld b, a
    ld a, [wMekemekeBlastLaneFlags]
    cp b
    ret nz

    set 7, a
    ld [wMekemekeBlastLaneFlags], a
    ret


Mekemeke_CheckProjectileClash::
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    ret z

    ld b, a
    ld a, [wMekemekePlayerShotX]
    or a
    ret z

    cp b
    ret c

    xor a
    ld [hl], a
    ld [wMekemekePlayerShotX], a
    ret


Mekemeke_UpdateFailure::
    ld a, [wMekemekePlayerLane]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld b, $04
    ld hl, wMekemekeEnemySlotsEnd

Mekemeke_DrawNextFailedLane::
    push bc
    ld e, b
    ld bc, -MEKEMEKE_ENEMY_SIZE
    add hl, bc
    push hl
    ld d, $00
    bit 0, [hl]
    jr z, Mekemeke_ProjectFailedLane

    ld d, $02

Mekemeke_ProjectFailedLane::
    inc hl
    inc hl
    ld a, e
    dec a
    swap a
    add a
    or $17
    ld b, a
    ld a, [hl]
    ld c, a
    cp $90
    ld a, $00
    jr c, Mekemeke_SetFailedLanePriority

    ld a, $02

Mekemeke_SetFailedLanePriority::
    ldh [hSpriteFlags], a
    ld a, [wScreenFrameCounter]
    bit 4, a
    jr nz, Mekemeke_DrawFailedLaneFrame

    inc d

Mekemeke_DrawFailedLaneFrame::
    ld a, d
    ld hl, MekemekeFailureEnemyFrames
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteFar
    pop hl
    pop bc
    dec b
    jr nz, Mekemeke_DrawNextFailedLane

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $90
    ret c

    ld a, $01
    ld [wMinigameResultFlag], a
    ldh a, [hJoyPressed]
    bit 0, a
    jp nz, AdvanceMinigameRoundOrExit

    ld a, [wScreenFrameCounter]
    cp $ff
    ret nz

    ld a, $7f
    ld [wScreenFrameCounter], a
    ret


Mekemeke_UpdateClear::
    ld hl, wMekemekeEnemySlots + MEKEMEKE_ENEMY_OFS_SHOT_X
    xor a
    ld de, $0008
    ld b, $04

Mekemeke_ClearEnemyShotsAfterWin::
    ld [hl], a
    add hl, de
    dec b
    jr nz, Mekemeke_ClearEnemyShotsAfterWin

    call Mekemeke_UpdateEnemyLanes
    ld a, [wMekemekePlayerLane]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    or a
    ret z

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $40
    ret c

    ld a, $a0
    ld [wScreenFrameCounter], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld hl, wMinigameUnlockedRounds
    xor a
    ld [wMinigameResultFlag], a
    jp AdvanceMinigameRoundOrExit


Mekemeke_QueueLaneTileAnimation::
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    srl a
    srl a
    and $06
    ld hl, MekemekeLaneTilePairs
    rst $38
    ld e, l
    ld d, h
    ld hl, _SCRN0 + $023

Mekemeke_QueueNextLaneTilePair::
    push de
    push hl
    ld bc, $0102
    call QueueTilemapRect
    pop hl
    pop de
    ld bc, $0080
    add hl, bc
    ld a, h
    cp $9a
    jr nz, Mekemeke_QueueNextLaneTilePair

    ret



MekemekeRoundEnemyVelocities::
; Ten signed 8.8 velocities per variant.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $80, $ff, $79, $ff, $71, $ff, $69, $ff, $61, $ff, $5a, $ff, $52, $ff, $4a, $ff
    db $42, $ff, $3a, $ff, $40, $ff, $39, $ff, $31, $ff, $29, $ff, $21, $ff, $1a, $ff
    db $12, $ff, $0a, $ff, $02, $ff, $fa, $fe

MekemekeEnemyFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $69, $6a, $69, $6b, $6d, $6d

MekemekeVariantEnemyFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $6e, $6f, $6e, $70, $75, $71

MekemekeVariantChances::
; One threshold per round, compared with a random value 0 through 7.
    db $01, $01, $02, $02, $03, $03, $04, $04, $05, $05

MekemekeFailureEnemyFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $6c, $69, $73, $74

MekemekeLaneTilePairs::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $91, $a1, $a8, $a9, $aa, $ab, $a8, $a9

MekemekeHudTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $85, $86, $87, $ac, $ac, $ac, $ac, $ac, $80, $81, $ac, $ac, $ac, $ac, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

MekemekeRoundTimerDigits::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $03, $01, $00, $04, $01, $00, $05, $01, $00, $06, $01, $00, $07, $01, $00
    db $08, $01, $00, $09, $01, $01, $00, $01, $01, $01, $01, $01, $02, $01

MekemekeRoundGoalTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $04, $04, $05, $04, $04, $05, $09, $04, $06, $04, $04, $06, $09, $04, $07
    db $04, $04, $07, $09, $04, $08, $04, $04, $08, $09, $04, $09, $04, $04, $09, $09
    db $04
