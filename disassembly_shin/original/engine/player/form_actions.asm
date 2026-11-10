UsePlayerFormAction:: ; Dispatch B-button ability for current hPlayerForm.
    ldh a, [hPlayerActionLock]
    or a
    ret nz

    ldh a, [hPlayerForm]
    or a
    ret z

    cp PLAYER_FORM_FLYING_SQUIRREL
    jp z, StartFlyingSquirrelAction

    cp PLAYER_FORM_ACTION_KAMEN
    jp z, StartActionKamenAction

    cp PLAYER_FORM_CHICKEN
    jp z, StartChickenAction

    ; PLAYER_FORM_COCKROACH: start the form action in-place using hPlayerActionLock.
    ld a, $4e
    call PlaySound
    ld hl, wFormActionStep
    xor a
    ld [hl+], a
    ld [hl], a
    ld [wPlayerSpecialActor0], a
    ldh [hPlayerAnimFrame], a
    ldh [hPlayerAnimCounter], a
    inc a
    ldh [hPlayerActionLock], a
    ret


StartChickenAction::
    ld de, ($0a << 8) | PlayerState_ChickenAction
    jr StartTimedPlayerFormAction

PlayerState_UpdateChickenAction:: ; State 08: mother-hen form action.
    call CheckPlayerFootTileContact
    ld e, $05
    call UpdatePlayerFormActionAnim
    ld hl, hPlayerAnimTimer
    dec [hl]
    ret nz

    ld a, $4f
    call PlaySound
    ld a, [wSavedPlayerState]
    ldh [hPlayerState], a
    ld a, SPECIAL_ACTOR_CHICKEN_PROJECTILE
    call InitPlayerSpecialActor
    ld b, $0a
    ld a, [wSavedPlayerState]
    or a
    jr nz, ChickenAction_StoreEggPosition

    ld b, $04

ChickenAction_StoreEggPosition::
    ld a, b
    call CalcSpecialActorY
    call StoreSpecialActorPos
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, [wSavedPlayerState]
    or a
    ret nz

    ld a, $20
    ld [wPlayerSpecialActor0Timer], a
    ret


StartFlyingSquirrelAction::
    ld de, ($0e << 8) | PlayerState_FlyingSquirrelAction

StartTimedPlayerFormAction:: ; D = initial timer, E = PlayerState_* action. Save the state to resume afterward.
    ldh a, [hPlayerState]
    ld [wSavedPlayerState], a
    ld a, d
    ldh [hPlayerAnimTimer], a
    ld a, e
    ldh [hPlayerState], a
    ld hl, wFormActionStep
    xor a
    ld [hl+], a
    ld [hl], a
    ret


UpdateFlyingSquirrelActionAnim::
    ld e, $07

UpdatePlayerFormActionAnim:: ; Advance form-action animation once timer passes threshold E.
    ld hl, wFormActionStep
    ld a, [hl]
    or a
    jr z, FormAction_InitPose

    ldh a, [hPlayerAnimTimer]
    cp e
    ret nc

    inc hl
    ld a, [hl]
    or a
    ret nz

    inc [hl]
    ldh a, [hPlayerAnimId]
    inc a
    ldh [hPlayerAnimId], a
    ret


FormAction_InitPose::
; Flying squirrel and chicken start at $17 on the ground and advance to $18. In air they start at $15.
    inc [hl]
    ld a, $17
    ldh [hPlayerAnimId], a
    ld a, [wSavedPlayerState]
    or a
    ret z

    ld a, $15
    ldh [hPlayerAnimId], a
    ret


PlayerState_UpdateFlyingSquirrelAction:: ; State 07: flying-squirrel form action.
    call CheckPlayerFootTileContact
    call UpdateFlyingSquirrelActionAnim
    ld hl, hPlayerAnimTimer
    dec [hl]
    ret nz

    ld a, $4c
    call PlaySound
    ld a, [wSavedPlayerState]
    ldh [hPlayerState], a
    ld a, $03
    ldh [hPlayerActionLock], a
    ld hl, wPlayerSpecialActor0
    call InitPlayerSpecialActorAtHL
    ld hl, wPlayerSpecialActor1

InitPlayerSpecialActorAtHL:: ; Initialize a flying-squirrel projectile actor at HL.
    ld a, SPECIAL_ACTOR_FLYING_SQUIRREL_PROJECTILE
    ld [hl+], a
    ldh a, [hPlayerDirection]
    and $01
    ld [hl+], a
    ld a, $0a
    call CalcSpecialActorX
    call StoreSpecialActorPos
    ld a, $0a
    call CalcSpecialActorY
    call StoreSpecialActorPos
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ret


CalcSpecialActorX:: ; BC = player X +/- A based on hPlayerDirection.
    ld c, a
    ldh a, [hPlayerDirection]
    or a
    jr nz, SpecialActorX_OffsetLeft

    ldh a, [hPlayerX]
    add c
    ld c, a
    ldh a, [hPlayerXHigh]
    adc $00
    ld b, a
    ret


SpecialActorX_OffsetLeft::
    ldh a, [hPlayerX]
    sub c
    ld c, a
    ldh a, [hPlayerXHigh]
    sbc $00
    ld b, a
    ret


CalcSpecialActorY:: ; BC = player Y - A.
    ld c, a
    ldh a, [hPlayerY]
    sub c
    ld c, a
    ldh a, [hPlayerYHigh]
    sbc $00
    ld b, a
    ret


StartActionKamenAction:: ; Begin Action Kamen form action; only allowed from normal ground state.
    ldh a, [hPlayerState]
    or a
    ret nz

    ld de, PlayerState_ActionKamenAction ; D = 0, the timer counts up for this action.
    jp StartTimedPlayerFormAction


UpdateActionKamenActionAnim:: ; Select Action Kamen action animation by hPlayerAnimTimer.
    ldh a, [hPlayerAnimTimer]
    cp $0a
    jr c, ActionKamenAction_SelectStartupFrame

    cp $14
    jr z, SpawnActionKamenProjectile

    jr nc, ActionKamenAction_SelectRecoveryFrame

    ld a, $16
    ldh [hPlayerAnimId], a
    ret


ActionKamenAction_SelectStartupFrame::
    ld a, $15
    ldh [hPlayerAnimId], a
    ret


ActionKamenAction_SelectRecoveryFrame::
    ld a, $17
    ldh [hPlayerAnimId], a
    ret


PlayerState_UpdateActionKamenAction:: ; State 09: Action Kamen projectile/action sequence.
    call CheckPlayerFootTileContact
    call UpdateActionKamenActionAnim
    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    cp $32
    ret c

    ld a, [wSavedPlayerState]
    ldh [hPlayerState], a
    ret


SpawnActionKamenProjectile:: ; Spawn the Action Kamen projectile on animation frame $14.
    ld a, $50
    call PlaySound
    ld a, SPECIAL_ACTOR_ACTION_KAMEN_PROJECTILE
    call InitPlayerSpecialActor
    ld hl, wPlayerSpecialActor0
    ld a, SPECIAL_ACTOR_ACTION_KAMEN_PROJECTILE
    ld [hl+], a
    ldh a, [hPlayerDirection]
    and $01
    ld [hl+], a
    ld a, $0a
    call CalcSpecialActorX
    call StoreSpecialActorPos
    ld a, $06
    call CalcSpecialActorY

StoreSpecialActorPos:: ; Store BC as a 16-bit position field in the current special actor struct.
    xor a
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, b
    ld [hl+], a
    ret


InitPlayerSpecialActor:: ; Initialize wPlayerSpecialActor0 and set hPlayerActionLock.
    ld hl, wPlayerSpecialActor0
    ld [hl+], a
    ldh a, [hPlayerDirection]
    and $01
    ld [hl+], a
    ld a, $01
    ldh [hPlayerActionLock], a
    ld a, $0a
    call CalcSpecialActorX
    jr StoreSpecialActorPos

ProbePlayerFeetThenHandleFall::
; Run the two-foot tile dispatch; take the fall-state path when its contact count equals 2.
    call CheckPlayerFootTileContact
    ldh a, [hPlayerTileProbeCount]
    cp $02
    ret nz

EnterPlayerFallState:: ; Switch to airborne/falling state when no ground is supporting the player.
    ldh a, [hPlayerPlatformAttached]
    or a
    ret nz

    ld a, $20
    ldh [hPlayerGravity], a
    ld a, PlayerState_JumpFall
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret
