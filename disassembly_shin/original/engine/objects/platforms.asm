UpdateObjPlatformBouncePad:: ; Object type $1d: bounce pad / trampoline-style platform.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call UpdateBouncePadPlayerContact
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    ld hl, BouncePadSpriteIdle
    or a
    jr z, DrawBouncePadSelectedPose

    ld hl, BouncePadSpritePressed

DrawBouncePadSelectedPose::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


UpdateBouncePadPlayerContact::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, ApplyBouncePadJump

    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [hPlayerDeathCollisionDisabled]
    cp $ff
    ret z

    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $0e
    ret nc

    ldh a, [hObjectScreenY]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub h
    ret nc

    cpl
    inc a
    cp $12
    ret nc

    cp $0e
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ldh a, [hPlayerState]
    cp PlayerState_FormChange
    ret z

    call SetPlayerJumpVelocity0

AttachPlayerToObjectTop16:: ; Align player Y to object top - $10.
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, -$0010
    add hl, de
    ld a, l
    ldh [hPlayerY], a
    ld a, h
    ldh [hPlayerYHigh], a
    ret


ApplyBouncePadJump::
    ld hl, hPlayerYSubpixel
    ld de, $0100
    call AddSignedVelocityToPosition24
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $08
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ldh a, [hPlayerState]
    cp PlayerState_FormChange
    ret z

    ld a, $5c
    call PlaySound
    ld a, $10
    ldh [hPlayerGravity], a
    ld a, PlayerState_JumpFall
    ldh [hPlayerState], a
    ld [wPlayerForcedJumpFlags], a
    call AttachPlayerToObjectTop16
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    rst $00

    ; Bounce pad strength dispatch table.
    dw SetBouncePadJumpVelocity0 ; 00
    dw SetBouncePadJumpVelocity1 ; 01
    dw SetBouncePadJumpVelocity2 ; 02

SetBouncePadJumpVelocity0::
    ld hl, -$0390
    jp StorePlayerJumpVelocityHL


SetBouncePadJumpVelocity1::
    ld hl, -$0440
    jp StorePlayerJumpVelocityHL


SetBouncePadJumpVelocity2::
    ld hl, -$04c0
    jp StorePlayerJumpVelocityHL


UpdateObjMovingPlatformVerticalA:: ; Object type $1a: vertical moving platform variant A.
    call CullObjectAndReleaseSpawn
    ret nz

    call UpdateMovingPlatformVerticalA
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerStandingOnPlatform

DrawMovingPlatformMetasprite::
; Draw the fixed platform metasprite at the projected object position.
    ld hl, MovingPlatformVerticalSprite
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


UpdateMovingPlatformVerticalA::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    ; rst $00 jump table (4 entries)
    dw VerticalPlatform_MoveUp, TickPlatformWaitAndAdvanceState, VerticalPlatform_MoveDown, TickPlatformWaitAndAdvanceState


CheckPlayerStandingOnPlatform::
    ldh a, [hPlayerState]
    cp PlayerState_FormChange
    ret z

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld e, $12
    call CheckPlayerPlatformTopOverlap
    ret nc

AttachPlayerToPlatformTop::
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    call AttachPlayerToObjectTop16
    ldh a, [hPlayerState]
    cp PlayerState_JumpFall
    ret nz

    jp ResetPlayerToNormalState


CheckPlayerPlatformTopOverlap::
    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [hPlayerDeathCollisionDisabled]
    cp $ff
    ret z

    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp e
    ret nc

    ldh a, [hObjectScreenY]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub h
    ret nc

    cpl
    inc a
    cp $15
    ret nc

    cp $0f
    ccf
    ret


VerticalPlatform_MoveUp::
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24

MovingPlatform_TickTravelAndBeginWait::
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


TickPlatformWaitAndAdvanceState::
; Count object timer +$0d down, then advance the object state.
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


VerticalPlatform_MoveDown::
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call AddSignedVelocityToPosition24
    jr MovingPlatform_TickTravelAndBeginWait

UpdateObjMovingPlatformHorizontal:: ; Object type $1b: horizontal moving platform; carries the player along X.
    call CullObjectAndReleaseSpawn
    ret nz

    call UpdateMovingPlatformHorizontal
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jp DrawMovingPlatformMetasprite


UpdateMovingPlatformHorizontal::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    ; rst $00 jump table (4 entries)
    dw HorizontalPlatform_BeginLeftMove, HorizontalPlatform_WaitAtEndpoint, HorizontalPlatform_BeginRightMove, HorizontalPlatform_WaitAtEndpoint


HorizontalPlatform_BeginLeftMove::
; UpdateMovingPlatformHorizontal dispatch index $00; behavior name can be refined after tracing.
    ld hl, $0002
    add hl, bc
    ldh a, [hJoyHeld]
    and $30
    jr nz, HorizontalPlatform_MoveLeftAndCarry

    ld a, [hl]
    ldh [hPlayerXSubpixel], a

HorizontalPlatform_MoveLeftAndCarry::
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24
    call MovingPlatform_TickTravelAndBeginWait
    ldh a, [hPlayerState]
    cp PlayerState_FormChange
    ret z

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld e, $12
    call CheckPlayerPlatformTopOverlap
    ret nc

    ld hl, hPlayerXSubpixel
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24
    jp AttachPlayerToPlatformTop


HorizontalPlatform_WaitAtEndpoint::
; UpdateMovingPlatformHorizontal dispatch index $01; behavior name can be refined after tracing.
    call TickPlatformWaitAndAdvanceState
    jp CheckPlayerStandingOnPlatform


HorizontalPlatform_BeginRightMove::
; UpdateMovingPlatformHorizontal dispatch index $02; behavior name can be refined after tracing.
    ld hl, $0002
    add hl, bc
    ldh a, [hJoyHeld]
    and $30
    jr nz, HorizontalPlatform_MoveRightAndCarry

    ld a, [hl]
    ldh [hPlayerXSubpixel], a

HorizontalPlatform_MoveRightAndCarry::
    ld de, $00c0
    call AddSignedVelocityToPosition24
    call MovingPlatform_TickTravelAndBeginWait
    ldh a, [hPlayerState]
    cp PlayerState_FormChange
    ret z

    ld e, $12
    call CheckPlayerPlatformTopOverlap
    ret nc

    ld hl, hPlayerXSubpixel
    ld de, $00c0
    call AddSignedVelocityToPosition24
    jp AttachPlayerToPlatformTop


UpdateObjDropPlatformA:: ; Object type $09/$1c: drop/moving platform variant A.
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStageObject

    call UpdateDropPlatformMotionA
    call CheckPlayerStandingOnDropPlatform
    ld hl, DropPlatformSpriteA
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


ClearOffscreenStageObject::
    xor a
    ld [bc], a
    ret


CheckPlayerStandingOnDropPlatform::
    ldh a, [hPlayerState]
    cp PlayerState_FormChange
    ret z

    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [hPlayerDeathCollisionDisabled]
    cp $ff
    ret z

    ld a, [wDropPlatformMinXDistance]
    ld l, a
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $10
    ret nc

    cp l
    ret nc

    ld [wDropPlatformMinXDistance], a
    ldh a, [hObjectScreenY]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub h
    ret nc

    cpl
    inc a
    cp $0c
    ret nc

    cp $07
    ret c

    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, -$0008
    add hl, de
    ld a, l
    ldh [hPlayerY], a
    ld a, h
    ldh [hPlayerYHigh], a
    ldh a, [hPlayerState]
    cp PlayerState_JumpFall
    ret nz

    jp ResetPlayerToNormalState


UpdateDropPlatformMotionA::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, TickPlatformWaitAndAdvanceState

MoveDropPlatformDown::
    ld hl, $0005
    add hl, bc
    ld de, $0200
    jp AddSignedVelocityToPosition24


UpdateObjDropPlatformB:: ; Object type $1e: drop/moving platform variant B.
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStageObject

    call UpdateDropPlatformMotionB
    call CheckPlayerStandingOnDropPlatform
    jp DrawCurrentStageObject


    xor a
    ld [bc], a
    ret


UpdateDropPlatformMotionB::
    ld a, $02
    ldh [hSpriteFlags], a
    ld a, $10
    ldh [hObjectAnimId], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, TickPlatformWaitAndAdvanceState

    dec a
    jr z, DropPlatformB_BlinkBeforeFalling

    jp MoveDropPlatformDown


DropPlatformB_BlinkBeforeFalling::
    ld hl, $000d
    add hl, bc
    bit 3, [hl]
    jp z, TickPlatformWaitAndAdvanceState

    ld a, $11
    ldh [hObjectAnimId], a
    jp TickPlatformWaitAndAdvanceState



DropPlatformSpriteA::
    db $f8, $f8, $b0, $10, $f8, $00, $b0, $10, $80

BouncePadSpriteIdle::
    db $f0, $f8, $b1, $10, $f0, $00, $b2, $10, $f8, $f8, $b3, $10, $f8, $00, $b4, $10
    db $80

BouncePadSpritePressed::
    db $f8, $f8, $b5, $10, $f8, $00, $b6, $10, $80

MovingPlatformVerticalSprite::
    db $f0, $f0, $b7, $00, $f0, $f8, $b8, $00, $f0, $00, $b8, $00, $f0, $08, $b9, $00
    db $f8, $f0, $ba, $00, $f8, $f8, $bb, $00, $f8, $00, $bb, $00, $f8, $08, $bc, $00
    db $80
