UpdateObjStage2Boss:: ; Object type $03: Stage 2 boss / stage-clear actor; can spawn OBJ_STAGE2_BOSS_PROJECTILE.
    call ProjectObjectToScreenAndCull
    call DispatchStage2BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage2Boss_TickHitFlash

    call CheckStage1BossActionHitbox
    call CheckStage1BossBodyCollision

Stage2Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage2Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage2Boss_Draw::
    jp DrawCurrentStageObject


CheckStage1BossActionHitbox::
; Half-width 7, half-height 16.
    ld de, HITBOX_STAGE1_BOSS
    jp CheckPlayerActionHitboxCollision


CheckStage1BossBodyCollision::
; Use body probe 6.
    ld d, $06
    jp CheckPlayerBodyCollision


DispatchStage2BossState::
; Object state selects one of five boss/clear handlers.
    ld a, $01
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw UpdateObjStage2BossScriptController, Stage2Boss_UpdateHitStun, Stage2Boss_FallAfterDefeat, Stage2Boss_HoldThrowPose
    dw BossClear_WalkPlayerOffscreen


Stage2Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage2BossAnimIds
    jp AnimateAndDrawStunnedObject



Stage2BossAnimIds::
    db $19, $1a, $19, $1a

Stage2Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage2BossAnimIds
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $03
    ld [hl+], a
    ld [hl], $04
    ret


UpdateObjStage2BossScriptController:: ; Stage 2 boss script/controller routine at $69e3.
    call SelectStage2BossAnimByYVelocity
    call MoveObjectXBySpeed
    call Stage2Boss_TrySpawnAtJumpApex
    call ApplyStage2BossVerticalAcceleration
    ret nz

    ld hl, -$0440
    ld a, l
    ld [wStage2BossBounceVelocityLo], a
    ld a, h
    ld [wStage2BossBounceVelocityHi], a
    ld a, [wStage2BossBouncePhase]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage2Boss_BounceFacingLeft, Stage2Boss_AdvanceLeftBounce, Stage2Boss_BounceFacingRight, Stage2Boss_AdvanceRightBounce
    dw Stage2Boss_RestartBounceCycle


SelectStage2BossAnimByYVelocity::
; Use frame $15 while moving upward, $16 otherwise.
    ld a, $15
    ldh [hObjectAnimId], a
    ld a, [wStage2BossBounceVelocityHi]
    bit 7, a
    ret nz

    ld a, $16
    ldh [hObjectAnimId], a
    ret


Stage2Boss_BounceFacingLeft::
    ld a, $01
    ld [wStage2BossBouncePhase], a
    ld a, [bc]
    or $80
    ld [bc], a
    ret


Stage2Boss_AdvanceLeftBounce::
    ld a, $02
    ld [wStage2BossBouncePhase], a
    ret


Stage2Boss_BounceFacingRight::
    ld a, $03
    ld [wStage2BossBouncePhase], a
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


Stage2Boss_AdvanceRightBounce::
    ld a, $04
    ld [wStage2BossBouncePhase], a
    ret


Stage2Boss_RestartBounceCycle::
    jp Stage2Boss_BounceFacingLeft


ApplyStage2BossVerticalAcceleration::
; Add $0040 to the shared boss Y velocity and move the object.
    ld hl, wStage2BossBounceVelocityLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0040
    add hl, de
    ld a, l
    ld [wStage2BossBounceVelocityLo], a
    ld a, h
    ld [wStage2BossBounceVelocityHi], a
    ld d, h
    ld e, l
    call ApplyObjectYVelocity
    ld hl, -$0400
    add hl, de
    ld a, h
    or l
    ret


Stage2Boss_HoldThrowPose::
    ld a, $17
    ldh [hObjectAnimId], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $20
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Stage2Boss_TrySpawnAtJumpApex::
; Only spawn when the bounce phase is active, Y velocity is zero, and no existing ball occupies a slot.
    ld a, [wStage2BossBouncePhase]
    or a
    ret z

    ld hl, wStage2BossBounceVelocityLo
    ld a, [hl+]
    or [hl]
    ret nz

    ld hl, wObjectSlots
    ld e, $20

Stage2Boss_CheckForExistingProjectile::
    ld a, [hl]
    and $7f
    cp OBJ_STAGE2_BOSS_PROJECTILE
    ret z

    ld a, $10
    rst $38
    dec e
    jr nz, Stage2Boss_CheckForExistingProjectile

    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ld hl, wObjectSlots

Stage2Boss_FindProjectileSlot::
    ld a, [hl]
    or a
    jr z, SpawnStage2BossProjectile

    cp $ff
    jr z, Stage2Boss_AppendProjectileBeforeTerminator

    ld de, $0010
    add hl, de
    jr Stage2Boss_FindProjectileSlot

Stage2Boss_AppendProjectileBeforeTerminator::
    call SpawnStage2BossProjectile
    ld [hl], $ff
    ret


SpawnStage2BossProjectile:: ; Spawn the Stage 2 boss small-ball projectile ($21).
    ld a, $80 | OBJ_STAGE2_BOSS_PROJECTILE
    ld [hl+], a
    xor a
    ld [hl+], a
    call Stage2BossProjectile_CopyXPlus8
    call Stage2BossProjectile_CopyYMinus32
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


Stage2BossProjectile_CopyXPlus8::
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
    ld de, $0800
    call AddSignedVelocityToPosition24
    inc hl
    ret


Stage2BossProjectile_CopyYMinus32::
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, -$0020
    add hl, de
    ld d, h
    ld e, l
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


UpdateObjStage2BossProjectile:: ; Object type $21: Stage 2 boss small-ball projectile.
    call DispatchStage2BossProjectileState
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStage2BossBall

    call CheckStage2BossProjectileBodyCollision
    jp DrawCurrentStageObject


ClearOffscreenStage2BossBall::
    xor a
    ld [bc], a
    ret


DispatchStage2BossProjectileState::
; Set projectile frame $1b; dispatch on the low state bit.
    ld a, $1b
    ldh [hObjectAnimId], a
    call GetObjectStateAndDirectionFlags
    and $01
    rst $00

    ; rst $00 jump table (2 entries)
    dw Stage2BossBall_FlyHorizontally, Stage2BossBall_FlyDownward


Stage2BossBall_FlyHorizontally::
    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call MoveObjectXBySpeed
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $18
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


Stage2BossBall_FlyDownward::
    call MoveObjectXBySpeed
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    jp AddSignedVelocityToPosition24


CheckStage2BossProjectileBodyCollision::
; Skip collision after boss clear; use body probe 7.
    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld d, $07
    jp CheckPlayerBodyCollision
