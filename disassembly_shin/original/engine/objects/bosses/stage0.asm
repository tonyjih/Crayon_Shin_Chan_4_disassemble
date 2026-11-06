UpdateObjStage0Boss:: ; Object type $01: Stage 0 boss / stage-clear actor.
    call ProjectObjectToScreenAndCull
    call DispatchStage0BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage0Boss_TickHitFlash

    call CheckStage0BossActionHitbox
    call CheckStage0BossBodyCollision

Stage0Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage0Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage0Boss_Draw::
    jp DrawCurrentStageObject


DispatchStage0BossState::
; Object state selects one of five boss/clear handlers.
    call GetObjectStateAndDirectionFlags
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage0Boss_Patrol, Stage0Boss_UpdateHitStun, Stage0Boss_FallAfterDefeat, Stage0Boss_UpdateThrowSequence
    dw BossClear_WalkPlayerOffscreen


Stage0Boss_UpdateThrowSequence::
    ld a, $10
    ldh [hObjectAnimId], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3f
    ret c

    jr z, Stage0Boss_BeginHatSlotSearch

    cp $a0
    ld a, $11
    ldh [hObjectAnimId], a
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Stage0Boss_BeginHatSlotSearch::
    ld hl, wObjectSlots

Stage0Boss_CheckNextHatSlot::
    ld a, [hl]
    or a
    jr z, Stage0Boss_InitHatProjectile

    cp $ff
    jr z, Stage0Boss_AppendHatBeforeTerminator

    ld de, $0010
    add hl, de
    jr Stage0Boss_CheckNextHatSlot

Stage0Boss_AppendHatBeforeTerminator::
    call Stage0Boss_InitHatProjectile
    ld [hl], $ff
    ret


Stage0Boss_InitHatProjectile::
    ld a, [bc]
    and $80
    or $05
    ld [hl+], a
    jp InitSpawnedChildObjectFromParent


BossClear_WalkPlayerOffscreen::
; Hold RIGHT until player screen X reaches $a8, then advance the stage flow.
    ld a, $10
    ldh [hJoyHeld], a
    ldh [hJoyPressed], a
    ldh a, [hPlayerScreenX]
    cp $a8
    ret c

    ld a, $01
    ld [wGameplayInitSubstate], a
    ld a, $03
    ld [wScreenSubstate], a
    ld a, $04
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ldh a, [hStageIndex]
    add a
    inc a
    ld [wStageSceneIndex], a
    ldh a, [hStageIndex]
    inc a
    ldh [hStageIndex], a
    cp $04
    ret c

    dec a
    ldh [hStageIndex], a
    xor a
    ld [wGameplayInitSubstate], a
    ret


Stage0Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage0BossAnimIdsA
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $01
    ld [hl+], a
    ld [hl], $04
    ret


Stage0Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage0BossAnimIdsA
    jp AnimateAndDrawStunnedObject



Stage0BossAnimIdsA::
    db $15, $16, $15, $16

Stage0Boss_Patrol::
    call CheckStage0BossHorizontalBounds
    ld hl, Stage0BossAnimIdsB
    call AnimateObjectFromTableFast
    jp MoveObjectXBySpeed



Stage0BossAnimIdsB::
    db $17, $18, $17, $19

CheckStage0BossHorizontalBounds::
; React at screen X $0c/$94.
    ldh a, [hObjectScreenX]
    and $fe
    cp $94
    jr z, Stage0Boss_BeginRightEdgeAttack

    jr nc, SetCurrentObjectFacingLeft

    cp $0c
    jr z, Stage0Boss_BeginLeftEdgeAttack

    jr c, SetCurrentObjectFacingRight

    ret


Stage0Boss_BeginRightEdgeAttack::
    ld a, $94
    ld hl, $0002
    add hl, bc
    ld [hl], $00
    inc hl
    ld a, $f4
    ld [hl], a
    call SetCurrentObjectFacingLeft

Stage0Boss_ResetThrowTimer::
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


SetCurrentObjectFacingLeft::
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


Stage0Boss_BeginLeftEdgeAttack::
    call SetCurrentObjectFacingRight
    jr Stage0Boss_ResetThrowTimer

SetCurrentObjectFacingRight::
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


CheckStage0BossActionHitbox::
; Half-width 4, half-height 16.
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckStage0BossBodyCollision::
; Use body probe 2.
    ld d, $02
    jp CheckPlayerBodyCollision
