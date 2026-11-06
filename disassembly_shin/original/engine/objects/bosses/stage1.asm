UpdateObjStage1Boss:: ; Object type $02: Stage 1 boss / stage-clear actor.
    call ProjectObjectToScreenAndCull
    call DispatchStage1BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage1Boss_TickHitFlash

    call CheckStage0BossActionHitbox
    call CheckStage0BossBodyCollision

Stage1Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage1Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage1Boss_Draw::
    jp DrawCurrentStageObject


DispatchStage1BossState::
; Object state selects one of five boss/clear handlers.
    call GetObjectStateAndDirectionFlags
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage1Boss_DispatchAttackPhase, Stage1Boss_UpdateHitStun, Stage1Boss_FallAfterDefeat, Stage1Boss_DispatchAttackPhase
    dw BossClear_WalkPlayerOffscreen


Stage1Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage1BossAnimIdsA
    jp AnimateAndDrawStunnedObject



Stage1BossAnimIdsA::
    db $17, $18, $17, $18

Stage1Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage1BossAnimIdsA
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $02
    ld [hl+], a
    ld [hl], $04
    ret


Stage1Boss_DispatchAttackPhase::
    ld a, [wStage1BossAttackPhase]
    and $0f
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage1Boss_WalkAndAnimate, Stage1Boss_WalkAndAnimate, Stage1Boss_WindUpJump, Stage1Boss_MoveThroughJump
    dw Stage1Boss_ResumePatrol


CheckStage1BossHorizontalBounds::
; React outside screen X $0c..$93.
    ldh a, [hObjectScreenX]
    cp $94
    jr nc, Stage1Boss_TurnAtRightEdge

    cp $0c
    jr c, Stage1Boss_TurnAtLeftEdge

    ret


Stage1Boss_TurnAtRightEdge::
    ld a, [bc]
    bit 7, a
    ret nz

    call SetCurrentObjectFacingLeft
    jr Stage1Boss_AdvanceAttackPhase

Stage1Boss_TurnAtLeftEdge::
    ld a, [bc]
    bit 7, a
    ret z

    call SetCurrentObjectFacingRight
    jr Stage1Boss_AdvanceAttackPhase

Stage1Boss_WalkAndAnimate::
; Check bounds, animate with table B, then move in X.
    call CheckStage1BossHorizontalBounds
    ld hl, Stage1BossAnimIdsB
    call AnimateObjectFromTableFast
    jp MoveObjectXBySpeed



Stage1BossAnimIdsB::
    db $14, $15, $14, $16

Stage1Boss_WindUpJump::
    ld a, $19
    ldh [hObjectAnimId], a
    ld a, [wStage1BossWindupTimer]
    inc a
    ld [wStage1BossWindupTimer], a
    cp $30
    ret c

    ld hl, -$0200 ; Signed 8.8 velocity, not an OAM pointer.
    ld a, l
    ld [wStage1BossJumpVelocityLo], a
    ld a, h
    ld [wStage1BossJumpVelocityHi], a
    xor a
    ld [wStage1BossWindupTimer], a

Stage1Boss_AdvanceAttackPhase::
; Low nibble dispatches the attack. Bit 7 alternates the next walking phase.
    ld a, [wStage1BossAttackPhase]
    inc a
    ld [wStage1BossAttackPhase], a
    and $0f
    cp $05
    ret nz

    ld a, [wStage1BossAttackPhase]
    and $80
    xor $80
    jr z, Stage1Boss_StoreAlternatingWalkPhase

    inc a

Stage1Boss_StoreAlternatingWalkPhase::
    ld [wStage1BossAttackPhase], a
    ret


Stage1Boss_MoveThroughJump::
    call MoveObjectXBySpeed
    call Stage1Boss_UpdateJumpVelocity
    ld a, $1a
    ldh [hObjectAnimId], a
    ld a, [wStage1BossJumpVelocityHi]
    bit 7, a
    ret nz

    ld a, $1b
    ldh [hObjectAnimId], a
    ret


Stage1Boss_UpdateJumpVelocity::
    ld hl, wStage1BossJumpVelocityLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0008
    ld a, [wAlternateModeFlags]
    or a
    jr z, Stage1Boss_ApplyJumpAcceleration

    ld de, $000c

Stage1Boss_ApplyJumpAcceleration::
    add hl, de
    ld a, l
    ld [wStage1BossJumpVelocityLo], a
    ld a, h
    ld [wStage1BossJumpVelocityHi], a
    ld d, h
    ld e, l
    call ApplyObjectYVelocity
    ldh a, [hObjectScreenY]
    cp $41
    ret c

    ld hl, $0005
    add hl, bc
    xor a
    ld [hl+], a
    ld a, $c0
    ld [hl], a
    jr Stage1Boss_AdvanceAttackPhase

Stage1Boss_ResumePatrol::
    jp Stage1Boss_WalkAndAnimate
