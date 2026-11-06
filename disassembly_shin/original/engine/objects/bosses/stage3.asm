UpdateObjStage3Boss:: ; Object type $04: Stage 3 boss / stage-clear actor with custom action hitbox handling.
    call ProjectObjectToScreenAndCull
    call DispatchStage3BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage3Boss_TickHitFlash

    call CheckStage3BossActionHitboxes
    call CheckStage3BossBodyAndStomp

Stage3Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage3Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage3Boss_Draw::
    jp DrawCurrentStageObject


CheckStage3BossActionHitboxes::
; Test active player action hitboxes against a 7x18-half-size boss hitbox.
    ld de, $0712
    ldh a, [hPlayerActionLock]
    or a
    ret z

    rrca
    push af
    push de
    call c, CheckStage3BossPrimaryActionHitbox
    pop de
    pop af
    rrca
    jr c, CheckStage3BossSecondaryActionHitbox

    ret


CheckStage3BossPrimaryActionHitbox::
; Shared per-action-hitbox rectangle comparison.
    ld hl, wPlayerActionHitbox0X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [hObjectScreenY]
    sub e
    ldh [hTileStreamWritePos], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call CheckCurrentObjectAgainstPoint
    ret nc

    ldh a, [hPlayerForm]
    cp PLAYER_FORM_ACTION_KAMEN
    jp z, LaunchObjectFromActionKamenHit

    cp PLAYER_FORM_COCKROACH
    jr z, Stage3Boss_ApplyHitDuringReturn

    xor a
    ld [wPlayerSpecialActor0], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    jr Stage3Boss_ApplyHitDuringReturn

CheckStage3BossSecondaryActionHitbox::
    ld hl, wPlayerActionHitbox1X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [hObjectScreenY]
    sub e
    ldh [hTileStreamWritePos], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call CheckCurrentObjectAgainstPoint
    ret nc

    xor a
    ld [wPlayerSpecialActor1], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    jr Stage3Boss_ApplyHitDuringReturn

CheckStage3BossBodyAndStomp::
; Use body probe 8 before checking the boss reaction fields.
    ld d, $08
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ret nc

Stage3Boss_ApplyHitDuringReturn::
    ld a, [wStage3BossNormalHitEnabled]
    or a
    ret z

    jp ApplyObjectHitFromPlayerAction


DispatchStage3BossState::
; Object state selects one of five boss/clear handlers.
    call GetObjectStateAndDirectionFlags
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage3Boss_DispatchAttackPhase, Stage3Boss_UpdateHitStun, Stage3Boss_FallAfterDefeat, Stage3Boss_DispatchAttackPhase
    dw BossClear_WalkPlayerOffscreen


Stage3Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage3BossAnimIdsA
    jp AnimateAndDrawStunnedObject



Stage3BossAnimIdsA::
    db $18, $19, $18, $19

Stage3Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage3BossAnimIdsA
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $04
    ld [hl+], a
    ld [hl], $04
    ret


Stage3Boss_DispatchAttackPhase::
    ld a, [wStage3BossAttackPhase]
    rst $00

    ; rst $00 jump table (14 entries)
    dw Stage3Boss_WalkToClimbPoint, Stage3Boss_Climb, Stage3Boss_WalkToThrowX70, Stage3Boss_UpdateCoconutThrow
    dw Stage3Boss_WalkToThrowX58, Stage3Boss_UpdateCoconutThrow, Stage3Boss_WalkToThrowX38, Stage3Boss_UpdateCoconutThrow
    dw Stage3Boss_WalkToThrowX18, Stage3Boss_UpdateCoconutThrow, Stage3Boss_WalkToDropPoint, Stage3Boss_DropToGround
    dw Stage3Boss_UpdateCameraShake, Stage3Boss_WalkBackRight


Stage3Boss_WalkToClimbPoint::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $8d
    jp nc, MoveObjectXBySpeed

    ld a, $01
    ld [wStage3BossAttackPhase], a
    ret


AnimateStage3BossFramesB::
; Use the four-entry Stage3BossAnimIdsB table.
    ld hl, Stage3BossAnimIdsB
    jp AnimateObjectFromTableFast



Stage3BossAnimIdsB::
    db $15, $16, $15, $17

Stage3Boss_Climb::
    ldh a, [hObjectScreenY]
    cp $21
    jr c, Stage3Boss_BeginWalkToFirstThrow

    ld de, $0100
    call MoveStage3BossUpByDE
    ld hl, Stage3BossAnimIdsC
    jp AnimateObjectFromTableFast



Stage3BossAnimIdsC::
    db $1d, $1e, $1d, $1e

Stage3Boss_BeginWalkToFirstThrow::
    ld a, $02
    ld [wStage3BossAttackPhase], a
    ret


MoveStage3BossUpByDE::
; Subtract DE from the three-byte Y position.
    ld hl, $0005
    add hl, bc
    jp SubtractSignedVelocityFromPosition24


Stage3Boss_WalkToThrowX70::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $70
    jp nc, MoveObjectXBySpeed

    ld a, $03
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_FinishThrowAndFaceLeft::
    ld a, [bc]
    set 7, a
    ld [bc], a
    xor a
    ld [wStage3BossAttackTimer], a
    ld a, [wStage3BossAttackPhase]
    inc a
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_UpdateCoconutThrow::
    ld a, [bc]
    res 7, a
    ld [bc], a
    xor a
    ld [wStage3BossCoconutFallEnabled], a
    ld a, $1b
    ldh [hObjectAnimId], a
    ld a, [wStage3BossAttackTimer]
    inc a
    ld [wStage3BossAttackTimer], a
    cp $30
    jr nc, Stage3Boss_FinishThrowAndFaceLeft

    cp $10
    ret c

    cp $20
    ret nc

    cp $1f
    jr z, SpawnStage3BossProjectile

    ld a, $1c
    ldh [hObjectAnimId], a
    ret


SpawnStage3BossProjectile:: ; Spawn Stage 3 boss coconut projectile/dropped hazard ($24).
    ld a, $1c
    ldh [hObjectAnimId], a
    ld hl, wObjectSlots

Stage3Boss_FindCoconutSlot::
    ld a, [hl]
    or a
    jr z, Stage3Boss_InitCoconutSlot

    cp $ff
    jr z, Stage3Boss_AppendCoconutBeforeTerminator

    ld de, $0010
    add hl, de
    jr Stage3Boss_FindCoconutSlot

Stage3Boss_AppendCoconutBeforeTerminator::
    call Stage3Boss_InitCoconutSlot
    ld [hl], $ff
    ret


Stage3Boss_InitCoconutSlot::
    ld a, OBJ_STAGE3_BOSS_PROJECTILE
    ld [hl+], a
    xor a
    ld [hl+], a
    call Stage3BossCoconut_CopyXPlus18
    call Stage3BossCoconut_CopyY
    call CopyParentProjectileSpeedPlus40
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


Stage3BossCoconut_CopyXPlus18::
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $1200
    call AddSignedVelocityToPosition24
    inc hl
    ret


Stage3BossCoconut_CopyY::
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


Stage3Boss_WalkToThrowX58::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $58
    jp nc, MoveObjectXBySpeed

    ld a, $05
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_WalkToThrowX38::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $38
    jp nc, MoveObjectXBySpeed

    ld a, $07
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_WalkToThrowX18::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $18
    jp nc, MoveObjectXBySpeed

    ld a, $09
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_WalkToDropPoint::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $14
    jp nc, MoveObjectXBySpeed

    ld a, $0b
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_DropToGround::
    ld a, [bc]
    res 7, a
    ld [bc], a
    ld a, $1a
    ldh [hObjectAnimId], a
    ldh a, [hObjectScreenY]
    cp $70
    jr nc, Stage3Boss_BeginCameraShake

    cp $6e
    call nc, PlayStage3BossAttackSound
    ld de, $0200
    ld hl, $0005
    add hl, bc
    jp AddSignedVelocityToPosition24


Stage3Boss_BeginCameraShake::
    ld a, $0c
    ld [wStage3BossAttackPhase], a
    ld hl, hSCY
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ld [wStage3BossSavedScrollYLo], a
    ld a, h
    ld [wStage3BossSavedScrollYHi], a
    ret


PlayStage3BossAttackSound::
; Queue sound $68.
    ld a, $68
    call PlaySound
    ret


Stage3Boss_UpdateCameraShake::
    ld a, $1a
    ldh [hObjectAnimId], a
    ld a, [wStage3BossAttackTimer]
    inc a
    ld [wStage3BossAttackTimer], a
    cp $40
    jr nc, Stage3Boss_EndShakeAndRestoreCamera

    and $07
    jr z, Stage3Boss_ShakeCameraUp

    cp $04
    jr z, Stage3Boss_ShakeCameraDown

    ret


Stage3Boss_ShakeCameraUp::
    ldh a, [hSCY]
    sub $01
    ldh [hSCY], a
    ldh a, [hSCYHigh]
    sbc $00
    ldh [hSCYHigh], a
    ret


Stage3Boss_ShakeCameraDown::
    ldh a, [hSCY]
    add $01
    ldh [hSCY], a
    ldh a, [hSCYHigh]
    adc $00
    ldh [hSCYHigh], a
    ret


Stage3Boss_EndShakeAndRestoreCamera::
    xor a
    ld [wStage3BossAttackTimer], a
    ld a, $0d
    ld [wStage3BossAttackPhase], a
    ld hl, wStage3BossSavedScrollYLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hSCY], a
    ld a, h
    ldh [hSCYHigh], a
    ret


Stage3Boss_WalkBackRight::
    ld a, $01
    ld [wStage3BossNormalHitEnabled], a
    ld a, $01
    ld [wStage3BossCoconutFallEnabled], a
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $8c
    jp c, MoveObjectXBySpeed

    xor a
    ld [wStage3BossNormalHitEnabled], a
    ld a, $01
    ld [wStage3BossAttackPhase], a
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


UpdateObjStage3BossProjectile:: ; Object type $24: Stage 3 boss coconut projectile/dropped hazard.
    call Stage3BossCoconut_UpdateFall
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStage3BossCoconut

    call CheckStage3BossProjectileBodyCollision
    xor a
    ldh [hSpriteFlags], a
    jp DrawCurrentStageObject


ClearOffscreenStage3BossCoconut::
    xor a
    ld [bc], a
    ret


Stage3BossCoconut_UpdateFall::
    ld a, $1f
    ldh [hObjectAnimId], a
    ld a, [wStage3BossCoconutFallEnabled]
    or a
    ret z

    ld hl, $0005
    add hl, bc
    ld de, $0180
    jp AddSignedVelocityToPosition24


CheckStage3BossProjectileBodyCollision::
; Skip collision after boss clear; use body probe 3.
    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld d, $03
    jp CheckPlayerBodyCollision
