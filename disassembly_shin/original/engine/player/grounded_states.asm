PlayerState_UpdateStageInteraction0D::
    call HandlePlayerGroundInput
    ldh a, [hPlayerPlatformAttached]
    or a
    call z, EnterPlayerFallState
    jr GroundedAction_UpdateWalkingFrames

EnterPlayerAttachedGroundState::
; Used when the hanging doll supports the player. State $0d exits when the support flag clears.
    ldh a, [hPlayerForm]
    cp $02
    jr nz, AttachedGround_ResetAnimation

    xor a
    ldh [hPlayerActionLock], a

AttachedGround_ResetAnimation::
    ld a, $0d
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ldh a, [hPlayerForm]
    cp $02
    ret z

    xor a
    ldh [hPlayerActionLock], a
    ret


PlayerState_UpdateGroundedActionCheck::
    call GroundedAction_CheckSupportThenInput

GroundedAction_UpdateWalkingFrames::
    ldh a, [hPlayerStatePhase]
    or a
    ret z

    ld h, $0a
    ld l, $04
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerGroundedActionAnimIds
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerGroundedActionAnimIds::
    db $12, $13, $12, $14

GroundedAction_CheckSupportThenInput::
    call CheckPlayerGroundCollision
    ldh a, [hPlayerTileProbeCount]
    cp $02
    jp nz, EnterPlayerFallState

HandlePlayerGroundInput:: ; Handle normal ground input and transition to jump/crouch/move.
    ldh a, [hJoyPressed]
    rrca
    jp c, StartPlayerJump

    ldh a, [hJoyHeld]
    or a
    jr z, GroundedAction_SelectIdlePose

    bit 4, a
    jr nz, GroundedAction_WalkRight

    bit 5, a
    jr nz, GroundedAction_WalkLeft

    bit 7, a
    jp nz, EnterPlayerFallState

GroundedAction_SelectIdlePose::
    xor a
    ldh [hPlayerStatePhase], a
    ld a, $12
    ldh [hPlayerAnimId], a
    ret


GroundedAction_WalkRight::
    ld a, $01
    ldh [hPlayerStatePhase], a
    xor a
    ldh [hPlayerDirection], a
    jp ApplyPlayerXVelocity


GroundedAction_WalkLeft::
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld a, $ff
    ldh [hPlayerDirection], a
    jp ApplyPlayerXVelocity


PlayerState_UpdateUnusedMove05::
    ld hl, hPlayerFlags
    set 0, [hl]
    ld h, $08
    ld l, $09
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerUnusedMove05AnimIds
    ldh a, [hPlayerAnimFrame]
    cp $08
    jr nc, PlayerUnusedMove05_FinishAnimation

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerUnusedMove05AnimIds::
    db $08, $09, $0a, $0b, $08, $09, $0a, $0b, $08

PlayerUnusedMove05_FinishAnimation::
    ldh a, [hPlayerFlags]
    res 0, a
    ldh [hPlayerFlags], a
    jp AlignPlayerToTileAndResetState



PlayerState_UpdateDuck:: ; State 01: down/duck pose and related transitions.
    call ProbePlayerFeetThenHandleFall
    ldh a, [hJoyHeld]
    cp $80
    jr z, Duck_UpdateHeldDownPose

    ld a, $0c
    ldh [hPlayerAnimId], a
    ldh a, [hJoyHeld]
    bit 7, a
    jp z, AlignPlayerToTileAndResetState

    bit 0, a
    jr nz, Duck_DropThroughGround

    bit 5, a
    jr nz, Duck_FaceLeft

    bit 4, a
    jr nz, Duck_FaceRight

    ret


Duck_FaceLeft::
    ld a, $ff
    ldh [hPlayerDirection], a
    xor a
    ldh [hPlayerAnimTimer], a
    ret


Duck_FaceRight::
    xor a
    ldh [hPlayerDirection], a
    ldh [hPlayerAnimTimer], a
    ret


Duck_DropThroughGround::
    call CheckPlayerFootTileContact
    ld a, [wPlayerTileAligned]
    or a
    ret nz

    ld hl, $0100
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ApplyPlayerYVelocity
    call ApplyPlayerYVelocity
    call ApplyPlayerYVelocity
    call ApplyPlayerYVelocity
    ldh a, [hPlayerState]
    cp $0b
    ret z

    ld a, $02
    ldh [hPlayerState], a
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret


Duck_UpdateHeldDownPose::
    call ProbePlayerHeadOnePixelLower
    ld a, $0c
    ldh [hPlayerAnimId], a
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
    ld a, $0d
    ldh [hPlayerAnimId], a
    ret


ProbePlayerHeadOnePixelLower::
; Temporarily move player Y down one pixel for the head probe, then move back.
    ld hl, $0100
    call MovePlayerYBySignedHL
    call CheckPlayerHeadCollision
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    call MovePlayerYBySignedHL
    ldh a, [hPlayerState]
    cp $03
    ret nz

    ld hl, $0100
    call MovePlayerYBySignedHL
    pop af
    ret



PlayerState_UpdateGroundedSnap:: ; State 03: grounded snap/settle state after specific collision contact.
    call HandlePlayerVerticalInput
    ldh a, [hPlayerStatePhase]
    rst $00

	dw PlayerGroundedSnap_State00
	dw PlayerGroundedSnap_State01

PlayerGroundedSnap_State00::
; PlayerState_UpdateGroundedSnap dispatch index $00; behavior name can be refined after tracing.
    ld a, $10
    ldh [hPlayerAnimId], a
    ret

PlayerGroundedSnap_State01::
; PlayerState_UpdateGroundedSnap dispatch index $01; behavior name can be refined after tracing.
    ld h, $0a
    ld l, $02
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerDuckAnimIds
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerDuckAnimIds::
    db $10, $11

HandlePlayerVerticalInput::
; Handle UP/DOWN motion in the grounded-snap state.
    ldh a, [hJoyHeld]
    bit 6, a
    jr nz, SnapState_TryMoveUp

    bit 7, a
    jr nz, SnapState_MoveDown

    ldh a, [hJoyPressed]
    bit 0, a
    jp nz, StartPlayerJump

    xor a
    ldh [hPlayerStatePhase], a
    jp CheckPlayerHeadCollision


SnapState_TryMoveUp::
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ProbePlayerGroundTilesAtHeight18
    ldh a, [hPlayerTileCollisionFlag]
    or a
    call z, ApplyPlayerYVelocity
    jp CheckPlayerHeadCollision


SnapState_MoveDown::
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld hl, $0100
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ApplyPlayerYVelocity
    jp CheckPlayerHeadCollision
