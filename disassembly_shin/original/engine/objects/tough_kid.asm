UpdateObjEnemyToughKid:: ; Object type $0f: tough kid enemy with higher HP.
    call UpdateEnemyToughKidState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckEnemyToughKidActionHitbox
    call CheckEnemyToughKidBodyCollision
    jp DrawCurrentStageObject


UpdateEnemyToughKidState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw EnemyToughKid_State00, EnemyToughKid_State01, EnemyToughKid_State02, EnemyToughKid_State02


EnemyToughKid_State00::
; UpdateEnemyToughKidState dispatch index $00; behavior name can be refined after tracing.
    ld hl, EnemyToughKidAnimIdsA
    ld d, $0f
    call AnimateObjectFromTable
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemyToughKidAnimIdsA::
    db $10, $11, $10, $12

EnemyToughKidAnimIdsB::
    db $13, $14, $13, $14

EnemyToughKid_State01::
; UpdateEnemyToughKidState dispatch index $01; behavior name can be refined after tracing.
    pop af
    ld hl, EnemyToughKidAnimIdsB

AnimateAndDrawStunnedObject::
; Animate with period 15 and return to patrol when the hit delay expires.
    ld d, $0f
    call AnimateObjectFromTable
    call TickObjectStunTimer
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jp DrawCurrentStageObject


TickObjectStunTimer::
; Clear the timer and decrement the state once it reaches 180.
    ld hl, $0002
    add hl, bc
    inc [hl]
    ld a, [hl]
    cp $b4
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ret


EnemyToughKid_State02::
; UpdateEnemyToughKidState dispatch index $02; behavior name can be refined after tracing.
    pop af
    ld hl, EnemyToughKidAnimIdsB
    call AnimateObjectFromTableFast
    jp UpdateObjectThrownStateB


CheckEnemyToughKidActionHitbox::
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckEnemyToughKidBodyCollision::
    ld d, $02
    jp CheckPlayerBodyCollision
