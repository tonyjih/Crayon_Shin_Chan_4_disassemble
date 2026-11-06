UpdateObjStage2ShoppingCart:: ; Object type $22: Stage 2 shopping cart platform; moves after Shin-chan stands on it.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jr z, ShoppingCart_UpdateRide

    ld hl, $0008
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ld hl, $0003
    add hl, bc
    ld de, $00b0
    ld a, [bc]
    sla a
    jr c, ShoppingCart_WrapWorldX

    ld de, -$0010

ShoppingCart_WrapWorldX::
    ldh a, [hSCX]
    add e
    ld [hl+], a
    ldh a, [hSCXHigh]
    adc d
    ld [hl], a

ShoppingCart_UpdateRide::
    call MovePlatformAndCarryPlayer
    call StopPlatformAtEndpoint
    ld a, [bc]
    sla a
    ld a, $00
    rl a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    ld hl, SpriteFrameData_21ce
    and $04
    jr z, ShoppingCart_DrawWheelFrame

    ld hl, SpriteFrameData_21ff

ShoppingCart_DrawWheelFrame::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


MovePlatformAndCarryPlayer::
    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $10
    ret nc

    ldh a, [hPlayerState]
    cp $0b
    ret z

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [hObjectScreenY]
    sub h
    ret c

    cp $20
    ret nc

    cp $1c
    jr nc, ShoppingCart_StartRideAndProbeWall

    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ldh [hPlayerX], a
    ld a, [hl+]
    ldh [hPlayerXHigh], a
    ld de, $0010
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    jr nc, ShoppingCart_PushPlayerToSide

    ld de, -$0010

ShoppingCart_PushPlayerToSide::
    ldh a, [hPlayerX]
    add e
    ldh [hPlayerX], a
    ldh a, [hPlayerXHigh]
    adc d
    ldh [hPlayerXHigh], a
    ld hl, $0008
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ldh a, [hPlayerScreenX]
    sub e
    ldh [hObjectScreenX], a
    ret


ShoppingCart_StartRideAndProbeWall::
    ldh a, [hPlayerVelYHigh]
    bit 7, a
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $c0
    call StopPlatformAtEndpoint
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    sub $1f
    ldh [hPlayerY], a
    push bc
    ld a, [bc]
    rlca
    jr nc, ShoppingCart_ProbeRightWall

    call CheckPlayerLeftTileCollision
    jr ShoppingCart_ApplyCarryIfClear

ShoppingCart_ProbeRightWall::
    call CheckPlayerRightTileCollision

ShoppingCart_ApplyCarryIfClear::
    ldh a, [hPlayerTileCollisionFlag]
    pop bc
    or a
    jr nz, ShoppingCart_CheckDropThroughInput

    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, hPlayerXSubpixel
    call ApplyObjectXVelocity

ShoppingCart_CheckDropThroughInput::
    ldh a, [hJoyHeld]
    and $81
    cp $81
    jr nz, ShoppingCart_MarkPlayerAttached

    ldh a, [hJoyHeld]
    res 0, a
    ldh [hJoyHeld], a

ShoppingCart_MarkPlayerAttached::
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


StopPlatformAtEndpoint::
    ld de, $0350
    ld a, [bc]
    sla a
    jr nc, ShoppingCart_CompareWorldXEndpoint

    ld de, $00b0

ShoppingCart_CompareWorldXEndpoint::
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    and $f8
    cp e
    ret nz

    ld a, [hl+]
    cp d
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $00
    ret


UpdateObjStage2FallingProduct:: ; Object type $1f: Stage 2 loose shelf product; falls when approached.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jr z, FallingProduct_UpdateVisibleObject

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, ClearOffscreenStageObject

    ret


FallingProduct_UpdateVisibleObject::
    call FallingProduct_UpdateMotionAndFramePair
    ld d, $03
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ld hl, $000a
    add hl, bc
    ldh a, [hTileStreamWritePos]
    ld d, [hl]
    bit 3, d
    jr z, FallingProduct_DrawSelectedFrame

    inc a

FallingProduct_DrawSelectedFrame::
    ld hl, FallingProductFramePointers
    rst $20
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


FallingProductFramePointers::
    dw SpriteFrameData_2230
    dw SpriteFrameData_2230
    dw SpriteFrameData_2230
    dw SpriteFrameData_223f
    dw SpriteFrameData_2235
    dw SpriteFrameData_223a

FallingProduct_UpdateMotionAndFramePair::
    xor a
    ldh [hTileStreamWritePos], a
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, FallingProduct_CheckWaitOrShake

    inc a
    and $0f
    or $40
    ld [hl], a
    ld a, $04
    ldh [hTileStreamWritePos], a
    ld hl, $0006
    add hl, bc

FallingProduct_AdvanceWorldY::
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl+], a
    ret


FallingProduct_CheckWaitOrShake::
    or a
    jr z, FallingProduct_ArmWhenPlayerNear

    inc a
    ld [hl], a
    ld a, $02
    ldh [hTileStreamWritePos], a
    ret


FallingProduct_ArmWhenPlayerNear::
    ldh a, [hObjectScreenX]
    ld d, a
    ldh a, [hPlayerScreenX]
    sub d
    rst $28
    cp $48
    ret nc

    ld a, $01
    ld [hl], a
    ret


UpdateObjStage2SoccerBall:: ; Object type $20: Stage 2 soccer ball; rolls toward Shin-chan and can be stomp-bounced.
    call CullObjectAndReleaseSpawn
    ret nz

    call SoccerBall_TryMoveNearPlayer
    ldh a, [hTileStreamWritePos]
    or a
    jr nz, SoccerBall_CheckCollisionAndAnimate

    ld hl, $000a
    add hl, bc
    bit 7, [hl]
    jp nz, ClearOffscreenStageObject

    ret


SoccerBall_CheckCollisionAndAnimate::
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld d, $05
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ld hl, $000a
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    inc a
    ld [de], a
    ld hl, SpriteFrameData_2244
    and $78
    cp $08
    jr nz, SoccerBall_CheckThirdRollFrame

    ld hl, SpriteFrameData_2255

SoccerBall_CheckThirdRollFrame::
    cp $10
    jr nz, SoccerBall_CheckDespawnThreshold

    ld hl, SpriteFrameData_2266

SoccerBall_CheckDespawnThreshold::
    cp $18
    jr c, DrawSoccerBall

    ld a, $80
    ld [de], a

DrawSoccerBall::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


SoccerBall_TryMoveNearPlayer::
    xor a
    ldh [hTileStreamWritePos], a
    ld hl, $0003
    add hl, bc
    ld e, [hl]
    inc hl
    ldh a, [hPlayerX]
    sub e
    ld e, a
    ld d, [hl]
    inc hl
    ldh a, [hPlayerXHigh]
    sbc d
    jr z, SoccerBall_CheckProximityAndRoll

    cp $ff
    ret nz

SoccerBall_CheckProximityAndRoll::
    xor e
    cp $60
    ret nc

    inc hl
    ld a, [hl+]
    and $80
    ld e, a
    ldh a, [hPlayerY]
    and $80
    cp e
    ret nz

    ld e, [hl]
    ldh a, [hPlayerYHigh]
    cp e
    ret nz

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ld a, $01
    ldh [hTileStreamWritePos], a
    ret


UpdateObjActionKamenHangingDoll:: ; Object type $07: Stage 2 hanging Action Kamen doll; Shin-chan can grab/ride it.
    call CullObjectAndReleaseSpawn
    ret nz

    call HangingDoll_UpdateAttachmentAndMotion
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld hl, SpriteFrameData_2277
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


HangingDoll_UpdateAttachmentAndMotion::
    xor a
    ldh [hTileStreamWritePos], a
    ldh a, [hObjectScreenX]
    ld e, a
    ldh a, [hPlayerScreenX]
    sub e
    rst $28
    cp $08
    jr nc, HangingDoll_TickTravel

    ldh a, [hObjectScreenY]
    ld e, a
    ldh a, [hPlayerScreenY]
    sub e
    cp $06
    jr c, HangingDoll_TickTravel

    cp $10
    jr nc, HangingDoll_CheckLowerContactBound

    ldh a, [hPlayerVelYHigh]
    bit 7, a
    jr nz, HangingDoll_TickTravel

HangingDoll_CheckLowerContactBound::
    cp $14
    jr nc, HangingDoll_TickTravel

    ldh a, [hPlayerState]
    cp $0b
    jr z, HangingDoll_TickTravel

    cp $06
    jr z, HangingDoll_TickTravel

    ldh a, [hObjectOffscreen]
    or a
    jr nz, HangingDoll_TickTravel

    ldh a, [hJoyPressed]
    ld e, $13
    bit 7, a
    jr z, HangingDoll_CheckJumpOffset

    inc e

HangingDoll_CheckJumpOffset::
    bit 0, a
    jr z, HangingDoll_AttachPlayer

    ld e, $0f

HangingDoll_AttachPlayer::
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add e
    ldh [hPlayerY], a
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ldh a, [hPlayerState]
    cp $0d
    call nz, EnterPlayerAttachedGroundState
    ld a, $01
    ldh [hTileStreamWritePos], a

HangingDoll_TickTravel::
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    dec a
    ld [hl], a
    cp $d0
    jr z, HangingDoll_ReloadTimerAndReverse

    sla a
    ret c

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ldh a, [hTileStreamWritePos]
    or a
    ret z

    ld de, $0100
    ld hl, hPlayerXSubpixel
    call ApplyObjectXVelocity
    ret


HangingDoll_ReloadTimerAndReverse::
    ld d, h
    ld e, l
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor $80
    ld [bc], a
    ret
