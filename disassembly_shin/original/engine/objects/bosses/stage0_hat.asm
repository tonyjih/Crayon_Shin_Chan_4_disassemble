UpdateObjStage0BossProjectile:: ; Object type $05: Stage 0 boss hat projectile.
    call DispatchStage0BossProjectileState
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStage0BossHat

    call CheckStage0BossProjectileBodyCollision
    jp DrawCurrentStageObject


ClearOffscreenStage0BossHat::
    xor a
    ld [bc], a
    ret


DispatchStage0BossProjectileState::
; Two projectile states from GetObjectStateAndDirectionFlags.
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (2 entries)
    dw Stage0BossHat_FlyHorizontally, Stage0BossHat_FlyUpward


Stage0BossHat_FlyHorizontally::
    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call MoveStage0BossProjectileAndTickState

Stage0BossHat_AnimateSpin::
    ld d, $10
    ld hl, $000c
    add hl, bc
    ld e, $03
    call AdvanceObjectAnimCounter
    ld hl, $000b
    add hl, bc
    ld a, [hl]
    ld hl, Stage0BossProjectileAnimIds
    rst $38
    ld a, [hl]
    ldh [hObjectAnimId], a
    ret



Stage0BossProjectileAnimIds::
    db $12, $13, $14

MoveStage0BossProjectileAndTickState::
; Move in X and advance state after 60 timer counts.
    call MoveObjectXBySpeed
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


Stage0BossHat_FlyUpward::
    call MoveObjectXBySpeed
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24
    jr Stage0BossHat_AnimateSpin

CheckStage0BossProjectileBodyCollision::
; Skip collision after boss clear; use body probe 4.
    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld d, $04
    jp CheckPlayerBodyCollision
