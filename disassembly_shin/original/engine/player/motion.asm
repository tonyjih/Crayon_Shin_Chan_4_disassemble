DispatchPlayerTileAlignment::
    ldh a, [hPlayerTileEffect]
    ld b, a
    xor a
    ldh [hPlayerTileEffect], a
    ld a, b
    and $07
    rst $00

    ; Player tile-effect Y alignment dispatch table.
    dw PlayerTileEffectNoAlign ; 00
    dw PlayerTileEffectAlignYToTile ; 01
    dw PlayerTileEffectAlignYToTilePlus8 ; 02
    dw PlayerTileEffectNoAlign ; 03
    dw PlayerTileEffectNoAlign ; 04
    dw PlayerTileEffectNoAlign ; 05
    dw PlayerTileEffectNoAlign ; 06
    dw PlayerTileEffectNoAlign ; 07

PlayerTileEffectNoAlign::
    ret


PlayerTileEffectAlignYToTile::
    ldh a, [hPlayerY]
    and $f0
    ldh [hPlayerY], a
    ret


PlayerTileEffectAlignYToTilePlus8::
    ldh a, [hPlayerY]
    and $f0
    or $08
    ldh [hPlayerY], a
    ret


MovePlayerYBySignedHL::
; Apply a signed 8.8 Y displacement from HL using the normal movement/clamp routine, then restore velocity.
    ldh a, [hPlayerVelYHigh]
    ld d, a
    ldh a, [hPlayerVelY]
    ld e, a
    push de
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ApplyPlayerYVelocity
    pop de
    ld a, d
    ldh [hPlayerVelYHigh], a
    ld a, e
    ldh [hPlayerVelY], a
    ret


ApplyPlayerXVelocity:: ; Apply signed player horizontal step to world X with bounds checks.
    ldh a, [hPlayerDirection]
    or a
    jr nz, ApplyPlayerXVelocity_Left

    ld hl, hPlayerXSubpixel
    ldh a, [hPlayerSpeedX]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerSpeedXHigh]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [wPlayerXMaxLo]
    ld e, a
    ld a, [wPlayerXMaxHi]
    ld d, a
    call CompareU16AtHLToDE
    ret c

    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld a, [wPlayerXMaxHi]
    ldh [hPlayerXHigh], a
    ld a, [wPlayerXMaxLo]
    ldh [hPlayerX], a
    ret


ApplyPlayerXVelocity_Left::
    ld hl, hPlayerXSubpixel
    ldh a, [hPlayerSpeedX]
    ld d, a
    ld a, [hl]
    sub d
    ld [hl+], a
    ldh a, [hPlayerSpeedXHigh]
    ld d, a
    ld a, [hl]
    sbc d
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl-], a
    ld a, [wPlayerXMinLo]
    ld e, a
    ld a, [wPlayerXMinHi]
    ld d, a
    call CompareU16AtHLToDE
    ret nc

    ld a, [wPlayerXMinHi]
    ldh [hPlayerXHigh], a
    ld a, [wPlayerXMinLo]
    ldh [hPlayerX], a
    ret


ApplyPlayerYVelocity:: ; Apply player vertical velocity to world Y.
    ldh a, [hPlayerVelYHigh]
    bit 7, a
    jr nz, ApplyPlayerYVelocityUpward

    ld hl, hPlayerYSubpixel
    ldh a, [hPlayerVelY]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerVelYHigh]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [wStageBossStateFlag]
    or a
    ret nz

    ld a, [wPlayerYFallThresholdLo]
    ld e, a
    ld a, [wPlayerYFallThresholdHi]
    ld d, a
    call CompareU16AtHLToDE
    ret c

    ldh a, [hPlayerState]
    cp PlayerState_DeathFall
    ret z

EnterPlayerDeathFallState:: ; Enter fall-out/death bounce state and reset form/audio.
    xor a
    ldh [hPlayerForm], a
    call InitSound
    ld a, $55
    call PlaySound_Queue3
    ld a, $0b
    ldh [hPlayerState], a
    ld hl, hPlayerFlags
    set 3, [hl]
    ld hl, -$0400
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ld a, $ff
    ldh [hPlayerDeathCollisionDisabled], a
    ret


ApplyPlayerYVelocityUpward::
    ld hl, hPlayerYSubpixel
    ldh a, [hPlayerVelY]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerVelYHigh]
    adc [hl]
    ld [hl+], a
    ld a, $ff
    adc [hl]
    ld [hl-], a
    cp $ff
    ret nz

    xor a
    ldh [hPlayerYHigh], a
    ldh [hPlayerY], a
    ret
