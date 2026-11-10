PlayerState_UpdateJumpFall:: ; State 02: airborne control, gravity, and landing checks.
    call UpdateAirbornePlayerInput
    ldh a, [hPlayerState]
    cp PlayerState_JumpFall
    ret nz

UpdateAirbornePlayerAnimByForm:: ; Select airborne player animation and form-specific air behavior.
    ldh a, [hPlayerForm]
    rst $00

	dw AirborneAnim_Normal
	dw AirborneAnim_FlyingSquirrel
	dw AirborneAnim_Cockroach
	dw AirborneAnim_Alternating
	dw AirborneAnim_Normal

AirborneAnim_Normal::
; Normal/Action Kamen airborne frame follows the sign of Y velocity.
    ld a, $0e
    ldh [hPlayerAnimId], a
    ldh a, [hPlayerVelYHigh]
    rlca
    ret c

    ld a, $0f
    ldh [hPlayerAnimId], a
    ret

AirborneAnim_FlyingSquirrel::
; Apply glide in jump state, then choose the ascent/descent frame.
    ldh a, [hPlayerState]
    cp PlayerState_JumpFall
    call z, UpdateFlyingSquirrelGlide
    ldh a, [hPlayerVelYHigh]
    rlca
    jr nc, SquirrelAirborne_SelectDescentFrame

    ld a, $0e
    ldh [hPlayerAnimId], a
    ret


SquirrelAirborne_SelectDescentFrame::
    ld hl, wPlayerForcedJumpFlags
    bit 7, [hl]
    ret nz

    set 7, [hl]
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret

AirborneAnim_Alternating::
; Two-frame airborne animation shared by chicken and inactive cockroach action.
    ld h, $0a
    ld l, $02
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, AirborneAlternatingAnimIds
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



AirborneAlternatingAnimIds::
; Shared two-frame table used by the chicken/cockroach airborne path.
    db $0e, $0f

AirborneAnim_Cockroach::
; Route active action animation through the cockroach hitbox updater.
    ldh a, [hPlayerActionLock]
    or a
    jr z, AirborneAnim_Alternating

    ld hl, CockroachAirActionFrames
    ld a, l
    ldh [hCockroachActionFramePtrLo], a
    ld a, h
    ldh [hCockroachActionFramePtrHi], a

UpdateCockroachActionHitbox:: ; Update cockroach action hitbox position while hPlayerActionLock is active.
    call UpdatePlayerActionAnimStep
    ldh a, [hPlayerScreenY]
    sub $0c
    ld [wPlayerActionHitbox0Y], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a
    ld de, $1606
    ld a, [wFormActionStep]
    cp $01
    jr nz, CockroachAction_SetHitboxWidthAndX

    ld de, $1c0c

CockroachAction_SetHitboxWidthAndX::
    ld a, e
    ldh [hActionHitboxHalfWidth], a
    ldh a, [hPlayerDirection]
    or a
    jr nz, CockroachAction_SetLeftHitboxX

    ldh a, [hPlayerScreenX]
    add d
    ld [wPlayerActionHitbox0X], a
    ret


CockroachAction_SetLeftHitboxX::
    ldh a, [hPlayerScreenX]
    sub d
    ld [wPlayerActionHitbox0X], a
    ret


UpdatePlayerActionAnimStep:: ; Advance multi-step player form action animation.
    ld a, [wFormActionStep]
    rst $00

    ; rst $00 jump table (3 entries)
    dw CockroachAction_Windup, CockroachAction_Extended, CockroachAction_Recover


CockroachAction_Windup::
    ld h, $08
    ld l, $03
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, hCockroachActionFramePtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ld hl, wFormActionTimer
    inc [hl]
    ld a, [hl]
    cp $10
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ret


CockroachAction_Extended::
    ld h, $08
    ld l, $04
    ld e, $02
    call AdvancePlayerAnimWithinRange
    ld hl, hCockroachActionFramePtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ld hl, wFormActionTimer
    inc [hl]
    ld a, [hl]
    cp $b4
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ret


CockroachAction_Recover::
    ld h, $08
    ld l, $06
    ld e, $04
    call AdvancePlayerAnimWithinRange
    ld hl, hCockroachActionFramePtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ld hl, wFormActionTimer
    inc [hl]
    ld a, [hl]
    cp $78
    ret c

    xor a
    ldh [hPlayerActionLock], a
    ret



CockroachAirActionFrames::
    db $18, $19, $19, $1a, $18, $1c

UpdateAirbornePlayerInput:: ; Handle airborne B action, horizontal control, gravity, and landing checks.
    ldh a, [hJoyPressed]
    bit 1, a
    jp nz, UsePlayerFormAction

    ldh a, [hJoyHeld]
    rrca
    call nc, LimitUpwardVelocityOnARelease
    ldh a, [hJoyHeld]
    bit 6, a
    jr nz, AirborneInput_TryGrabLadder

AirborneInput_CheckHorizontalButtons::
    ldh a, [hJoyHeld]
    bit 4, a
    jr nz, AirborneInput_MoveRight

    bit 5, a
    jr nz, AirborneInput_MoveLeft

    jr AirborneInput_ApplyGravity

LimitUpwardVelocityOnARelease:: ; When A is released during upward motion, clamp upward velocity.
    ld a, [wPlayerForcedJumpFlags]
    or a
    ret nz

    ldh a, [hPlayerVelYHigh]
    rlca
    ret nc

    ld hl, hPlayerVelYLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0100
    add hl, de
    bit 7, h
    ret z

    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ret


AirborneInput_TryGrabLadder::
    call CheckPlayerHeadCollision
    ldh a, [hPlayerState]
    cp PlayerState_Ladder
    jr nz, AirborneInput_CheckHorizontalButtons

    ret


AirborneInput_MoveRight::
    xor a
    ldh [hPlayerDirection], a
    call CheckPlayerRightTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    jr nz, AirborneInput_ApplyGravity

    call ApplyPlayerXVelocity
    jr AirborneInput_ApplyGravity

AirborneInput_MoveLeft::
    ld a, $ff
    ldh [hPlayerDirection], a
    call CheckPlayerLeftTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    jr nz, AirborneInput_ApplyGravity

    call ApplyPlayerXVelocity

AirborneInput_ApplyGravity::
    ldh a, [hPlayerGravity]
    ld b, a
    ld hl, hPlayerVelYLo
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jp nz, ApplyPlayerYVelocityAndCheckGround

    cp $04
    jr c, AirborneInput_IntegrateFallAndCheckFeet

    ld a, $04
    ld [hl-], a
    ld [hl], $00

AirborneInput_IntegrateFallAndCheckFeet::
    call ApplyPlayerYVelocity
    call CheckPlayerFootTileContact
    ld hl, hPlayerState
    ld a, [hl+]
    cp [hl]
    ret nz

    ldh a, [hPlayerTileProbeCount]
    cp $02
    ret z

AlignPlayerToTileAndResetState::
; Apply tile-effect alignment before clearing motion/action state.
    call DispatchPlayerTileAlignment

ResetPlayerToNormalState:: ; Clear motion/action state and return to normal ground state.
    xor a ; PlayerState_NormalGround and cleared motion fields.
    ldh [hPlayerState], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [hPlayerAnimTimer], a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ld [wPlayerActionMeter], a
    ld [wPlayerForcedJumpFlags], a

UpdatePlayerJumpProfile:: ; Select jump profile. Chicken Shin-chan uses a stronger jump profile.
    ld a, PLAYER_JUMP_PROFILE_NORMAL
    ldh [hPlayerJumpProfile], a
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_CHICKEN
    ret nz

    ld a, PLAYER_JUMP_PROFILE_CHICKEN
    ldh [hPlayerJumpProfile], a
    ret


UpdateFlyingSquirrelGlide:: ; Flying squirrel: repeated A presses build glide meter and briefly cancel gravity/Y velocity.
    ldh a, [hJoyPressed]
    rrca
    jr nc, SquirrelGlide_DecayWhileDescending

    ld a, $4b
    call PlaySound
    ldh a, [hPlayerAnimId]
    cp $0e
    jr nz, SquirrelGlide_SelectAscentFrame

    inc a
    jr SquirrelGlide_UpdateMeter

SquirrelGlide_SelectAscentFrame::
    ld a, $0e

SquirrelGlide_UpdateMeter::
    ldh [hPlayerAnimId], a
    ld hl, wPlayerActionMeter
    ld a, [hl]
    add $1e
    cp $3d
    jr c, SquirrelGlide_StoreMeter

    ld a, $3c

SquirrelGlide_StoreMeter::
    ld [hl], a
    cp $1f
    ret c

SquirrelGlide_ClearVerticalMotion::
    xor a
    ldh [hPlayerGravity], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ret


SquirrelGlide_DecayWhileDescending::
    ldh a, [hPlayerVelYHigh]
    rlca
    ret c

    ld a, $20
    ldh [hPlayerGravity], a
    ld hl, wPlayerActionMeter
    ld a, [hl]
    or a
    ret z

    dec [hl]
    cp $37
    jr nc, SquirrelGlide_ClearVerticalMotion

    ret


ApplyPlayerYVelocityAndCheckGround::
; Shared motion + ground-probe tail.
    call ApplyPlayerYVelocity
    jp CheckPlayerGroundCollision


StartPlayerJump:: ; Enter jump state and initialize upward velocity/sound.
    ld a, PlayerState_JumpFall
    ldh [hPlayerState], a
    ld a, $42
    call PlaySound
    ld a, $20
    ldh [hPlayerGravity], a
    ldh a, [hPlayerJumpProfile]
    and $07
    rst $00

    ; rst $00 jump table (8 entries)
    dw SetPlayerJumpVelocity0, SetPlayerJumpVelocity1, SetPlayerJumpVelocity2, SetPlayerJumpVelocity3
    dw SetPlayerJumpVelocity4, SetPlayerJumpVelocity5, SetPlayerJumpVelocity6, SetPlayerJumpVelocity7


SetPlayerJumpVelocity0::
; Jump profile 0: Y velocity 0. ; Jump velocity table targets write initial signed Y velocity.
    ld hl, $0000

StorePlayerJumpVelocityHL::
; Store signed 8.8 Y velocity from HL.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ret


SetPlayerJumpVelocity1::
; Jump profile 1; velocity is signed 8.8 pixels/frame.
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity2::
; Jump profile 2; velocity is signed 8.8 pixels/frame.
    ld hl, -$0200 ; Signed 8.8 velocity, not an OAM pointer.
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity3::
; Jump profile 3; velocity is signed 8.8 pixels/frame.
    ld hl, -$0300
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity4::
; Jump profile 4; velocity is signed 8.8 pixels/frame.
    ld hl, -$0390
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity5::
; Jump profile 5; velocity is signed 8.8 pixels/frame.
    ld hl, -$0400
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity6::
; Jump profile 6; velocity is signed 8.8 pixels/frame.
    ld hl, -$0480
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity7::
; Jump profile 7; velocity is signed 8.8 pixels/frame.
    ld hl, -$0500
    jr StorePlayerJumpVelocityHL
