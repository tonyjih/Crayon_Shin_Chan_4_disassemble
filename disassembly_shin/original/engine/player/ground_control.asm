PlayerState_UpdateNormalGround:: ; State 00: normal grounded player control.
    call DispatchPlayerTileAlignment
    call HandleGroundInput
    ldh a, [hPlayerState]
    or a
    ret nz

    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, GroundedPlayer_DispatchAnimation

    ldh a, [hPlayerActionLock]
    or a
    jr nz, CockroachGroundAction_SelectFrameTable

GroundedPlayer_DispatchAnimation::
    ldh a, [hPlayerStatePhase]
    rst $00

	dw GroundedPlayer_IdlePose
	dw GroundedPlayer_WalkCycle
	dw GroundedPlayer_IdleFidget

CockroachGroundAction_SelectFrameTable::
    ldh a, [hPlayerStatePhase]
    or a
    jr nz, CockroachGroundAction_UseMovingFrames

    ld hl, CockroachGroundIdleActionFrames
    ld a, l
    ldh [hCockroachActionFramePtrLo], a
    ld a, h
    ldh [hCockroachActionFramePtrHi], a
    jp UpdateCockroachActionHitbox



CockroachGroundIdleActionFrames::
    db $15, $16, $16, $16, $15, $15

CockroachGroundAction_UseMovingFrames::
    ld hl, CockroachGroundMovingActionFrames
    ld a, l
    ldh [hCockroachActionFramePtrLo], a
    ld a, h
    ldh [hCockroachActionFramePtrHi], a
    jp UpdateCockroachActionHitbox



CockroachGroundMovingActionFrames::
    db $15, $16, $16, $17, $15, $1b

GroundedPlayer_IdlePose::
    ld a, $04
    ldh [hPlayerAnimId], a
    ret

GroundedPlayer_WalkCycle::
    ld h, $0a
    ld l, $04
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, CockroachAnimIdsA
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



CockroachAnimIdsA::
    db $04, $05, $04, $06

AdvancePlayerAnimWithinRange::
; H=frame period, E=first animation frame, L=exclusive last frame.
    ldh a, [hPlayerAnimCounter]
    inc a
    ldh [hPlayerAnimCounter], a
    cp h
    jr c, PlayerAnimation_CheckCurrentFrame

    xor a
    ldh [hPlayerAnimCounter], a
    ldh a, [hPlayerAnimFrame]
    inc a
    ldh [hPlayerAnimFrame], a

PlayerAnimation_CheckFrameRange::
    cp e
    jr c, PlayerAnimation_WrapToFirstFrame

    cp l
    ret c

PlayerAnimation_WrapToFirstFrame::
    ld a, e
    ldh [hPlayerAnimFrame], a
    ret


PlayerAnimation_CheckCurrentFrame::
    ldh a, [hPlayerAnimFrame]
    jr PlayerAnimation_CheckFrameRange

GroundedPlayer_IdleFidget::
    ld h, $0a
    ld l, $05
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerIdleFidgetAnimIds
    ldh a, [hPlayerAnimFrame]
    cp $04
    jr nc, GroundedPlayer_EndIdleFidget

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


GroundedPlayer_EndIdleFidget::
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ldh [hPlayerAnimTimer], a
    ret



PlayerIdleFidgetAnimIds::
; Only normal Shin-chan can enter the idle-fidget phase, so transformed tables never select $07 here.
    db $04, $07, $04, $07, $04

HandleGroundInput:: ; Ground input router: duck, jump, form action, horizontal movement, idle timer.
    ldh a, [hJoyHeld]
    bit 7, a
    jr nz, GroundInput_CheckDuck

    ldh a, [hJoyPressed]
    rrca
    jr c, GroundInput_StartJump

    rrca
    jp c, UsePlayerFormAction

GroundInput_CheckDirectionalButtons::
    ldh a, [hJoyHeld]
    or a
    jr z, GroundInput_UpdateIdle

    bit 4, a
    jr nz, GroundInput_MoveRight

    bit 5, a
    jr nz, GroundInput_MoveLeft

    bit 6, a
    jr nz, GroundInput_TryGrabLadder

GroundInput_UpdateIdle::
    call ProbePlayerFeetThenHandleFall
    xor a
    ldh [hPlayerStatePhase], a
    ldh a, [hPlayerForm]
    or a
    ret nz

    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    cp $80
    ret c

    ld a, $80
    ldh [hPlayerAnimTimer], a
    ld a, $02
    ldh [hPlayerStatePhase], a
    ret


GroundInput_TryGrabLadder::
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    call MovePlayerYBySignedHL
    call CheckPlayerHeadCollision
    ld hl, $0100
    call MovePlayerYBySignedHL
    ldh a, [hPlayerState]
    cp PlayerState_Ladder
    jr nz, GroundInput_UpdateIdle

    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    call MovePlayerYBySignedHL
    ret


GroundInput_StartJump::
    jp StartPlayerJump


GroundInput_CheckDuck::
    ldh a, [hPlayerForm]
    cp $02
    jr z, GroundInput_CheckCockroachDrop

    ld a, PlayerState_Duck
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerAnimTimer], a
    ldh [hPlayerStatePhase], a
    ret


GroundInput_CheckCockroachDrop::
; The cockroach bypasses duck state $01. Its $0c and $0d both share the airborne $0e pose.
    call ProbePlayerHeadOnePixelLower
    ldh a, [hJoyHeld]
    rrca
    jp c, Duck_DropThroughGround

    jr GroundInput_CheckDirectionalButtons

GroundInput_MoveRight::
    xor a
    ldh [hPlayerAnimTimer], a
    ld a, $01
    ldh [hPlayerStatePhase], a
    xor a
    ldh [hPlayerDirection], a
    ld a, [wStageBossStateFlag]
    cp $ff
    jr nz, GroundInput_ProbeRightBeforeMove

    ldh a, [hPlayerScreenX]
    cp $9c
    jp nc, ApplyPlayerXVelocity

GroundInput_ProbeRightBeforeMove::
    call CheckPlayerRightTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    call z, ApplyPlayerXVelocity
    jp ProbePlayerFeetThenHandleFall


GroundInput_MoveLeft::
    xor a
    ldh [hPlayerAnimTimer], a
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld a, $ff
    ldh [hPlayerDirection], a
    call CheckPlayerLeftTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    call z, ApplyPlayerXVelocity
    jp ProbePlayerFeetThenHandleFall
