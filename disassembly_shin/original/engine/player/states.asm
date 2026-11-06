UpdatePlayerState:: ; Dispatch current player state machine.
    ldh a, [hPlayerState]
    ldh [hPrevPlayerState], a
    rst $00

    ; hPlayerState dispatch table. rst $00 consumes these words as data.
    dw PlayerState_UpdateNormalGround          ; 00
    dw PlayerState_UpdateDuck                  ; 01
    dw PlayerState_UpdateJumpFall              ; 02
    dw PlayerState_UpdateGroundedSnap          ; 03
    dw PlayerState_UpdateGroundedActionCheck   ; 04: grounded/action check state
    dw PlayerState_UpdateClimbOrVerticalMove   ; 05: climb/vertical move state
    dw PlayerState_UpdateHurtKnockback         ; 06
    dw PlayerState_UpdateFlyingSquirrelAction  ; 07
    dw PlayerState_UpdateChickenAction         ; 08
    dw PlayerState_UpdateActionKamenAction     ; 09
    dw PlayerState_UpdateDamageBounce          ; 0a: damage bounce state
    dw PlayerState_UpdateDeathFall             ; 0b
    dw PlayerState_UpdateStageTransition0C     ; 0c: scripted stage transition state
    dw PlayerState_UpdateStageInteraction0D    ; 0d: special/stage interaction state

PlayerState_UpdateStageTransition0C:: ; Scripted stage transition handler; Stage 2 uses it for layered vertical-room transitions.
    ld hl, -$0200 ; Signed 8.8 velocity, not an OAM pointer.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call UpdateAirbornePlayerAnimByForm
    ld a, [wStageInteractionSubstate]
    rst $00

    ; Stage transition substate dispatch table.
	dw StageTransitionScrollViewportUp       ; 00: scroll camera/player anchor up by one screen
	dw Stage2TransitionCopyBgTiles          ; 01: queue bank0:$3572/$3902 tiles into VRAM $9450-$97ff
	dw Stage2TransitionCopyExtraTiles       ; 02: queue bank5:$6411 tiles into VRAM $8c00+
	dw Stage2TransitionFinalize             ; 03: reset substate; at step 5 switch Stage 2 metatile/collision

Stage2TransitionFinalize::
    xor a
    ld [wStageInteractionSubstate], a
    ld [wStageInteractionCounter], a
    ld a, [wStage2TransitionStep]
    cp $05
    ret nz

    ld hl, $01f8
    ld a, l
    ld [wPlayerXMaxLo], a
    ld a, h
    ld [wPlayerXMaxHi], a
    ld hl, $0160
    ld a, l
    ld [wCameraScrollXMaxLo], a
    ld a, h
    ld [wCameraScrollXMaxHi], a
    ld hl, Stage2MetatileQuadsAfterSwitch_Bank4
    ld a, l
    ldh [hStageMetatileTableLo], a
    ld a, h
    ldh [hStageMetatileTableHi], a
    ld hl, CollisionAttributes + $298
    ld de, wStageTileAttrTable
    ld bc, $0030
    ld a, BANK(CollisionAttributes)
    jp BankedMemcpy

Stage2TransitionCopyExtraTiles::
    call Stage2QueueTransitionExtraTile
    ld a, [wStageInteractionCounter]
    inc a
    ld [wStageInteractionCounter], a
    cp $0d
    ret c

    ld a, [wStageInteractionSubstate]
    inc a
    ld [wStageInteractionSubstate], a
    xor a
    ld [wStageInteractionCounter], a
    ret


Stage2QueueTransitionExtraTile:: ; Queue one tile from bank5:$6411 into the Stage 2 transition overlay area.
    ld hl, Gfx_b05_6411
    ld a, [wStageInteractionCounter]
    ld c, a
    add $c0
    ld e, a
    ld d, $05
    jp QueueBankedVramTile8000

Stage2TransitionCopyBgTiles::
    call Stage2QueueTransitionBgTile
    ld a, [wStageInteractionCounter]
    inc a
    ld [wStageInteractionCounter], a
    cp $3b
    ret c

    ld a, [wStageInteractionSubstate]
    inc a
    ld [wStageInteractionSubstate], a
    xor a
    ld [wStageInteractionCounter], a
    ret


Stage2QueueTransitionBgTile:: ; Queue one 8x8 tile update for Stage 2 tile ids $45-$7f.
    ld hl, Bank0TrailingGraphicsData_3572
    ld a, [wStage2TransitionStep]
    cp $02
    jr z, Stage2Transition_QueueSelectedTile

    ld hl, Bank0TrailingGraphicsData_3902

Stage2Transition_QueueSelectedTile::
    ld a, [wStageInteractionCounter]
    ld c, a
    add $45
    ld e, a
    ld d, $00
    jp QueueBankedVramTile9000

StageTransitionScrollViewportUp::
    call StageTransitionMovePlayerAnchorUp
    ld hl, hSCY
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    call QueueCurrentCameraBgRow
    ld a, [wStageInteractionCounter]
    inc a
    ld [wStageInteractionCounter], a
    cp $80
    ret c

    ld a, $ff
    ld [wPlayerForcedJumpFlags], a
    ld a, $02
    ldh [hPlayerState], a
    ld a, [wStage2TransitionStep]
    inc a
    ld [wStage2TransitionStep], a
    ret


StageTransitionMovePlayerAnchorUp:: ; During the first $20 frames, keep the player/screen anchor moving with the camera scroll.
    ld a, [wStageInteractionCounter]
    cp $20
    ret nc

    ld hl, hPlayerY
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    ret


PlayerState_UpdateDamageBounce::
    call CheckPlayerFootTileContact
    ld a, $15
    ldh [hPlayerAnimId], a
    ld hl, hPlayerAnimTimer
    dec [hl]
    ld a, [hl]
    cp $16
    jr z, DamageBounce_ApplyHealthLossAndKnockback

    or a
    ret nz

    ld a, $80
    ld [wPlayerHurtBlinkTimer], a
    ld hl, hPlayerFlags
    res 3, [hl]
    set 1, [hl]
    jp AlignPlayerToTileAndResetState


DamageBounce_ApplyHealthLossAndKnockback::
    call SubtractPlayerHealthAndMarkHudDirty
    ld hl, hPlayerXSubpixel
    ld de, $0200
    ldh a, [hPlayerDirection]
    or a
    jp z, SubtractSignedVelocityFromPosition24

    jp AddSignedVelocityToPosition24



PlayerState_UpdateDeathFall:: ; State 0b: fall-out/death bounce, life decrement, and reset/game-over transition.
    ld hl, hPlayerVelYLo
    ld a, [hl]
    add $14
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jr nz, DeathFall_IntegrateYAndSelectFrame

    cp $04
    jr c, DeathFall_IntegrateYAndSelectFrame

    ld a, $04
    ld [hl-], a
    ld [hl], $00

DeathFall_IntegrateYAndSelectFrame::
    call ApplyPlayerYVelocity
    ld hl, PlayerDeathAnimByForm
    ldh a, [hPlayerForm]
    rst $38
    ld a, [hl]

DeathFall_CheckOffscreenAndRestart::
    ldh [hPlayerAnimId], a
    ld a, $ff
    ldh [hCollisionFlag], a
    ld hl, hPlayerY
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hSCY]
    ld e, a
    ldh a, [hSCYHigh]
    ld d, a
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ret c

    ldh a, [hPlayerScreenY]
    cp $b0
    ret c

    cp $f0
    ret nc

    xor a
    ldh [hPlayerForm], a
    xor a
    ldh [hPlayerFlags], a
    xor a
    ldh [hPlayerHealth], a
    ld hl, hPlayerLives
    ld a, [hl]
    or a
    jr z, PlayerDeath_EnterGameOver

    dec [hl]
    call QueueLivesHudDigits
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld a, $01
    ld [wGameplayInitSubstate], a
    ld a, [wStageCheckpointActive]
    or a
    ret z

    ld a, $02
    ld [wGameplayInitSubstate], a
    ret



PlayerDeathAnimByForm::
    db $15, $19, $1d, $19, $18

PlayerDeath_EnterGameOver::
    xor a

    ld [wGameplayInitSubstate], a
    ld a, $04
    ldh [hGameState], a
    ld a, $01
    ld [wScreenSubstate], a
    ldh [hNeedsReset], a
    ret
