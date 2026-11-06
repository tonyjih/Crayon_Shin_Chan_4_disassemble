UpdateObjFloatingBeachBall:: ; Object type $08: Stage 3 floating beach ball; sinks while stood on.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr z, BeachBall_ProjectSinkDepth

    dec [hl]

BeachBall_ProjectSinkDepth::
    srl a
    ld e, a
    ldh a, [hObjectScreenY]
    add e
    ldh [hObjectScreenY], a
    call BeachBall_CheckAndAttachPlayer
    ld e, $00
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr nz, DrawFloatingBeachBall

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    bit 4, a
    jr z, DrawFloatingBeachBall

    ld e, $02

DrawFloatingBeachBall::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    add e
    ld b, a
    ld hl, SpriteFrameData_2486
    jp DrawMetaspriteWithBgPriority


    ret


BeachBall_CheckAndAttachPlayer::
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $09
    ret nc

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [hObjectScreenY]
    sub h
    cp $08
    ret c

    cp $10
    ret nc

    ldh a, [hPlayerVelYHigh]
    bit 7, a
    ret nz

    ldh a, [hPlayerState]
    cp $0b
    ret z

    cp $06
    ret z

    ld hl, $0006
    add hl, bc
    ld a, [hl]
    sub $0e
    add e
    ldh [hPlayerY], a
    ldh a, [hJoyHeld]
    and $81
    cp $81
    jr nz, BeachBall_MarkPlayerAttachedAndSink

    ldh a, [hJoyHeld]
    res 0, a
    ldh [hJoyHeld], a

BeachBall_MarkPlayerAttachedAndSink::
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    inc [hl]
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


UpdateObjStage3FallingCoconut:: ; Object type $23: Stage 3 coconut; shakes, then falls when approached.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jr z, Coconut_UpdateVisibleObject

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, ClearOffscreenStageObject

    ret


Coconut_UpdateVisibleObject::
    call Coconut_UpdateFallOrShake
    ld d, $05
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ld hl, $000a
    add hl, bc
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    ld a, [hl]
    bit 3, a
    jr z, DrawFallingCoconut

    inc c

DrawFallingCoconut::
    ld hl, SpriteFrameData_2475
    jp DrawMetaspriteNormal


Coconut_UpdateFallOrShake::
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, Coconut_CheckWaitOrShake

    ld de, $0180
    ld hl, $0005
    add hl, bc
    call ApplyObjectXVelocity
    ret


Coconut_CheckWaitOrShake::
    or a
    jr z, Coconut_ArmWhenPlayerNear

    inc a
    ld [hl], a
    ret


Coconut_ArmWhenPlayerNear::
    ldh a, [hObjectScreenX]
    ld d, a
    ldh a, [hPlayerScreenX]
    sub d
    rst $28
    cp $48
    ret nc

    ld a, [bc]
    res 7, a
    ld [bc], a
    ld a, $01
    ld [hl], a
    ret
