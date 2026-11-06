UpdateObjBouncingBall:: ; Object type $06: Stage 2 bouncing ball; hurts on contact, stompable.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld a, [bc]
    or $80
    ld [bc], a
    call UpdateBouncingBallState
    call CheckBouncingBallActionHitbox
    call CheckBouncingBallBodyCollision
    jp DrawCurrentStageObject


UpdateBouncingBallState:: ; Update state/animation for Stage 2 bouncing ball.
    xor a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    ; rst $00 jump table (4 entries)
    dw BouncingBall_WaitAndLaunchBounce, BouncingBall_ApplyThrownFall, BouncingBall_ApplyThrownFall, BouncingBall_UpdateBounceArc


BouncingBall_WaitAndLaunchBounce::
    ld a, $13
    ldh [hObjectAnimId], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    ld a, [hl]
    cp $08
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    ld de, -$02a0
    ld hl, $000a
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ldh a, [hObjectScreenX]
    ld hl, hPlayerScreenX
    sub [hl]
    rst $28
    cp $40
    ret nc

    ld de, $00b0
    ld a, [wAlternateModeFlags]
    or a
    jr z, BouncingBall_StoreHorizontalSpeed

    ld de, $0100

BouncingBall_StoreHorizontalSpeed::
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


BouncingBall_ApplyThrownFall::
    pop af
    ld a, $12
    ldh [hObjectAnimId], a
    ld hl, $0008
    add hl, bc
    xor a
    ld [hl+], a
    ld [hl], $01
    jp UpdateObjectThrownStateB


BouncingBall_UpdateBounceArc::
    ld a, $12
    ldh [hObjectAnimId], a
    call MoveObjectXBySpeed
    ld hl, $000a
    call AccelerateObjectYAtHL
    ld hl, $000a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, -$0280
    add hl, de
    ld a, h
    or l
    ret nz

    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


CheckBouncingBallActionHitbox::
    ld de, $0408
    jp CheckPlayerActionHitboxCollision


CheckBouncingBallBodyCollision::
    ld d, $05
    jp CheckPlayerBodyCollision


UpdateObjEnemyWalkingKid:: ; Object type $0a: walking kid enemy.
    call UpdateEnemyWalkerAState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerActionHitboxCollision_Default
    call CheckPlayerBodyCollisionDefault
    jp DrawCurrentStageObject


UpdateEnemyWalkerAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw WalkingKid_Patrol, WalkingKid_UpdateHitDelay, WalkingKid_UpdateThrownFall, WalkingKid_UpdateThrownFall


GetObjectStateAndDirectionFlags::
    xor a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    ld a, [hl+]
    rlca
    jr nc, ReadObjectStateLowBits

    ld a, $01
    ldh [hSpriteFlags], a

ReadObjectStateLowBits::
    ld a, [hl]
    and $03
    ret


WalkingKid_Patrol::
    ld hl, ObjectPatrolAnimIds
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed

UpdateObjectPatrolTurnTimer::
    ld hl, OBJECT_OFS_TIMER
    add hl, bc
    dec [hl]
    ret nz

    ld d, h
    ld e, l
    ld hl, OBJECT_OFS_TYPE_WORK_A
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor OBJECT_DIRECTION_MASK
    ld [bc], a
    ret


AnimateObjectFromTableFast::
    ld d, $08

AnimateObjectFromTable::
    push hl
    ld hl, OBJECT_OFS_ANIM_COUNTER
    add hl, bc
    ld e, $04
    call AdvanceObjectAnimCounter
    ld hl, OBJECT_OFS_ANIM_FRAME
    add hl, bc
    ld a, [hl]
    pop hl
    rst $38
    ld a, [hl]
    ldh [hObjectAnimId], a
    ret



ObjectPatrolAnimIds::
    db $00, $01, $00, $02

WalkingKid_UpdateHitDelay::
    pop af
    ld a, $03
    ldh [hObjectAnimId], a

UpdateObjectThrownStateA::
    call UpdateObjectThrownStateATimer
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jp DrawCurrentStageObject


UpdateObjectThrownStateATimer::
    ld hl, $0002
    add hl, bc
    dec [hl]
    ret nz

    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ld hl, $000e
    add hl, bc
    bit 6, [hl]
    jp nz, EnemyAttack_RestorePatrolAndFacing

    ret


WalkingKid_UpdateThrownFall::
    pop af
    ld a, $03
    ldh [hObjectAnimId], a

UpdateObjectThrownStateB::
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    xor a
    ld [bc], a
    ret


AccelerateObjectY::
    ld hl, $0008

AccelerateObjectYAtHL::
    add hl, bc
    ld a, [hl]
    add $20
    ld e, a
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld d, a
    ld [hl], a

ApplyObjectYVelocity::
    ld hl, OBJECT_OFS_Y_SUBPIXEL
    add hl, bc
    bit 7, d
    jp z, AddSignedVelocityToPosition24

    ld a, e
    add [hl]
    ld [hl+], a
    ld a, d
    adc [hl]
    ld [hl+], a
    ld a, [hl]
    adc $ff
    ld [hl], a
    ret


CheckPlayerActionHitboxCollision_Default::
    ld de, $040c

CheckPlayerActionHitboxCollision:: ; Check active player form/projectile hitboxes against current object.
    ldh a, [hPlayerActionLock]
    or a
    ret z

    rrca
    push af
    push de
    call c, CheckActionHitbox0Collision
    pop de
    pop af
    rrca
    jr c, CheckActionHitbox1Collision

    ret


CheckActionHitbox0Collision:: ; Check primary action/projectile hitbox at wPlayerActionHitbox0*.
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

    ld a, [bc]
    and $7f
    cp $05
    ldh a, [hPlayerForm]
    jr nc, ActionHitbox0_ResolveHitByForm

    cp PLAYER_FORM_ACTION_KAMEN
    jr z, ApplyObjectHitFromPlayerAction

ActionHitbox0_ResolveHitByForm::
    cp PLAYER_FORM_ACTION_KAMEN
    jr z, LaunchObjectFromActionKamenHit

    cp PLAYER_FORM_COCKROACH
    jr z, ApplyObjectHitFromPlayerAction

    xor a
    ld [wPlayerSpecialActor0], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    jr ApplyObjectHitFromPlayerAction

CheckActionHitbox1Collision:: ; Check secondary action/projectile hitbox at wPlayerActionHitbox1*.
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
    jr ApplyObjectHitFromPlayerAction

CheckPlayerBodyCollisionDefault::
; Use body collision probe 0.
    ld d, $00

CheckPlayerBodyCollision::
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ret nc

ApplyObjectHitFromPlayerAction:: ; Apply normal player form/projectile hit handling to current object.
    ld a, $52
    call PlaySound
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $1f
    jr z, LaunchObjectFromActionKamenHit

    dec [hl]
    ld a, [hl]
    and $1f
    jr nz, SetObjectActionHitStun

LaunchObjectFromActionKamenHit:: ; Strong Action Kamen projectile hit: launch/stagger the current object.
    ld h, b
    ld l, c
    inc hl
    ld [hl], $02
    ld de, -$0320
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


SetObjectActionHitStun:: ; Put object into short hit-stun after a non-launching form action hit.
    ld hl, $0002
    add hl, bc
    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $01
    ret


UpdateObjEnemyPartyHornKid:: ; Object type $0b: party-horn kid that reacts when the player approaches.
    xor a
    ldh [hPartyHornReachBonus], a
    call UpdateEnemyReactiveAState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckEnemyReactivePlayerProximity
    call CheckEnemyReactiveSpecialBodyCollision
    call CheckPlayerActionHitboxCollision_Default
    call CheckPlayerBodyCollisionDefault
    jp DrawCurrentStageObject


UpdateEnemyReactiveAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw PartyHornKid_Patrol, PartyHornKid_UpdateHitDelay, PartyHornKid_UpdateThrownFall, PartyHornKid_UpdateHornAttack


PartyHornKid_Patrol::
    ld hl, EnemyWalkerAnimIdsA
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemyWalkerAnimIdsA::
    db $06, $07, $06, $08

PartyHornKid_UpdateHitDelay::
    pop af
    ld a, $0b
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateA


PartyHornKid_UpdateThrownFall::
    pop af
    ld a, $0b
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateB


PartyHornKid_UpdateHornAttack::
    ld a, $09
    ldh [hObjectAnimId], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld d, a
    ld a, $0a
    ldh [hObjectAnimId], a
    ld a, $04
    ldh [hPartyHornReachBonus], a
    ld a, d
    cp $b4
    ret c

EnemyAttack_RestorePatrolAndFacing::
; Restore the saved facing bit and clear the attack latch in object byte +$0e.
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $80
    ld d, a
    ld a, [bc]
    and $7f
    or d
    ld [bc], a
    ld a, [hl]
    and $1f
    ld [hl], a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


CheckEnemyReactiveSpecialBodyCollision::
    ldh a, [hObjectScreenY]
    ld e, a
    ldh a, [hPlayerScreenY]
    sub e
    rst $28
    cp $04
    ret nc

    ld d, $0c
    ldh a, [hPartyHornReachBonus]
    add d
    ld d, a
    call GetObjectLeadingEdgeScreenX
    ld e, a
    ldh a, [hPlayerScreenX]
    sub e
    rst $28
    cp d
    ret nc

    jp PlayerObjectCollision_ApplyDamage


GetObjectLeadingEdgeScreenX::
; Apply the signed/facing-dependent horizontal offset D to object screen X.
    ld a, [bc]
    rlca
    jr c, ObjectLeadingEdge_OffsetLeft

    ldh a, [hObjectScreenX]
    add d
    ret


ObjectLeadingEdge_OffsetLeft::
    ldh a, [hObjectScreenX]
    sub d
    ret


EnemyProximity_TickAttackCooldown::
    dec [hl]
    ret


CheckEnemyReactivePlayerProximity::
    ld e, $24

CheckEnemyPlayerProximityWithRange::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    cp $03
    ret z

    ld hl, $0005
    add hl, bc
    ld a, [hl]
    or a
    jr nz, EnemyProximity_TickAttackCooldown

    ldh a, [hPlayerScreenY]
    ld d, a
    ldh a, [hObjectScreenY]
    sub d
    rst $28
    cp $0e
    ret nc

    ldh a, [hObjectScreenX]
    cp $f0
    ret nc

    ld d, a
    ldh a, [hPlayerScreenX]
    sub d
    rst $28
    cp e
    ret nc

    ld h, b
    ld l, c
    ld a, [hl]
    and $80
    ld e, a
    ld h, b
    ld l, c
    ldh a, [hPlayerScreenX]
    sub d
    ld a, $00
    jr nc, EnemyProximity_TriggerIfFacingPlayer

    set 7, a

EnemyProximity_TriggerIfFacingPlayer::
    cp e
    ret nz

    inc hl
    ld [hl], $03
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $3f
    or e
    set 6, a
    ld [hl], a
    ret


UpdateObjEnemyUmbrellaKid:: ; Object type $0c: umbrella kid; player bounces when landing on top.
    call UpdateEnemyWalkerBState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckEnemyWalkerBActionHitbox
    call CheckEnemyWalkerBSpecialBodyCollision
    jp DrawCurrentStageObject


UpdateEnemyWalkerBState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw UmbrellaKid_Patrol, UmbrellaKid_UpdateHitDelay, UmbrellaKid_UpdateThrownFall, UmbrellaKid_UpdateThrownFall


UmbrellaKid_Patrol::
    ld hl, EnemyWalkerAnimIdsB
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemyWalkerAnimIdsB::
    db $0c, $0d, $0c, $0e

UmbrellaKid_UpdateHitDelay::
    pop af
    ld a, $0f
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateA


UmbrellaKid_UpdateThrownFall::
    pop af
    ld a, $0f
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateB


CheckEnemyWalkerBActionHitbox::
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckEnemyWalkerBSpecialBodyCollision::
    ld d, $01
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ret nc

    ld a, $5c
    call PlaySound
    ret


UpdateObjEnemyPaperAirplaneKid:: ; Object type $0d: paper-airplane kid that spawns paper airplane projectiles.
    call UpdateEnemySpawnerAState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPaperAirplaneKidPlayerProximity
    call CheckPlayerActionHitboxCollision_Default
    call CheckPlayerBodyCollisionDefault
    jp DrawCurrentStageObject


UpdateEnemySpawnerAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw PaperAirplaneKid_Patrol, PaperAirplaneKid_UpdateHitDelay, PaperAirplaneKid_UpdateThrownFall, PaperAirplaneKid_UpdateThrowSequence


PaperAirplaneKid_Patrol::
    ld hl, EnemySpawnerAnimIds
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemySpawnerAnimIds::
    db $00, $01, $00, $02

PaperAirplaneKid_UpdateHitDelay::
    pop af
    ld a, $05
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateA


PaperAirplaneKid_UpdateThrownFall::
    pop af
    ld a, $05
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateB


PaperAirplaneKid_UpdateThrowSequence::
    ld a, $03
    ldh [hObjectAnimId], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    and $7f
    jr z, SpawnEnemyPaperAirplane

    cp $78
    ret c

    jp EnemyAttack_RestorePatrolAndFacing


SpawnEnemyPaperAirplane::
    ld hl, wObjectSlots

PaperAirplane_FindFreeSlot::
    ld a, [hl]
    or a
    jr z, PaperAirplane_InitChildSlot

    cp $ff
    jr z, PaperAirplane_AppendBeforeTerminator

    ld de, $0010
    add hl, de
    jr PaperAirplane_FindFreeSlot

PaperAirplane_AppendBeforeTerminator::
    call PaperAirplane_InitChildSlot
    ld [hl], $ff
    ret


PaperAirplane_InitChildSlot::
    ld a, [bc]
    and $80
    or OBJ_ENEMY_PAPER_AIRPLANE
    ld [hl+], a

InitSpawnedChildObjectFromParent::
    xor a
    ld [hl+], a
    call CopyParentProjectileXOffset
    call CopyParentProjectileYOffset
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


CopyParentProjectileSpeedPlus40::
    push hl
    ld hl, $0008
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    and $7f
    ld d, a
    ld hl, $0040
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


CopyParentProjectileXOffset::
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
    call ApplyObjectXVelocity
    inc hl
    ret


CopyParentProjectileYOffset::
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, -$0010
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


CheckPaperAirplaneKidPlayerProximity::
    ld e, $50
    jp CheckEnemyPlayerProximityWithRange


UpdateObjEnemyPaperAirplane:: ; Object type $0e: paper airplane projectile spawned by paper-airplane kid.
    call UpdateEnemyProjectileAState
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenPaperAirplane

    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $02
    jr nz, DrawEnemyPaperAirplane

    call CheckEnemyProjectileAActionHitbox
    call CheckEnemyProjectileABodyCollision

DrawEnemyPaperAirplane::
    ld a, $04
    ldh [hObjectAnimId], a
    jp DrawCurrentStageObject


ClearOffscreenPaperAirplane::
    xor a
    ld [bc], a
    ret


UpdateEnemyProjectileAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw PaperAirplane_FlyHorizontally, PaperAirplane_FlyAndDescend, PaperAirplane_Descend, PaperAirplane_Descend


PaperAirplane_FlyHorizontally::
    call MoveObjectXBySpeed
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $60
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


PaperAirplane_FlyAndDescend::
    call MoveObjectXBySpeed
PaperAirplane_Descend::
    ld de, $0100
    ld hl, $0005
    add hl, bc
    jp AddSignedVelocityToPosition24


CheckEnemyProjectileAActionHitbox::
    ld de, $0404
    jp CheckPlayerActionHitboxCollision


CheckEnemyProjectileABodyCollision::
    ld d, $03
    jp CheckPlayerBodyCollision
