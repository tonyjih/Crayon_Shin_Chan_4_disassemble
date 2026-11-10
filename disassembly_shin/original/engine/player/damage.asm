HandlePlayerDamage::
; Ignore damage during flagged states; lose an active form, otherwise enter damage/death handling.
    ldh a, [hPlayerFlags]
    or a
    ret nz

    ldh a, [hPlayerForm]
    or a
    jp nz, LosePlayerFormAndBeginFormChange

    ldh a, [hPlayerHealth]
    or a
    jp z, EnterPlayerDeathFallState

    ld a, $51
    call PlaySound
    ldh a, [hPlayerState]
    ld [wSavedPlayerState], a
    ld a, PlayerState_DamageKnockback
    ldh [hPlayerState], a
    ld hl, hPlayerFlags
    set 3, [hl]
    ld a, $1e
    ldh [hPlayerAnimTimer], a
    ret


LosePlayerFormAndBeginFormChange::
; Restore the saved normal move speed before streaming the normal form tiles.
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    xor a
    ldh [hPlayerForm], a
    ld hl, wPlayerNormalSpeedLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    jp EnterPlayerFormChangeState


SetPlayerForcedBounceVelocity::
; Disable jump-height release control, set gravity $20, and use jump profile 3 velocity.
    ld a, $01
    ld [wPlayerForcedJumpFlags], a
    ld a, $20
    ldh [hPlayerGravity], a
    jp SetPlayerJumpVelocity3


EnterPlayerFormChangeState:: ; Clear action actors and start the form-change tile stream.
    ld a, PlayerState_FormChange
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimCounter], a
    ldh [hPlayerAnimFrame], a
    ldh [hPlayerActionLock], a
    ld [wPlayerSpecialActor0], a
    ld [wPlayerSpecialActor1], a
    ldh [hPlayerActionLock], a
    ld a, $f8
    ldh [hPlayerAnimTimer], a
    ldh a, [hPlayerFlags]
    set 4, a
    ldh [hPlayerFlags], a
    ld a, [wStoredPlayerForm]
    cp $04
    ret nz

    ldh a, [hCollisionFlag]
    cp $ff
    call nz, SelectGameplayMusic
    ld hl, wPlayerNormalSpeedLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ld hl, hPlayerFlags
    res 2, [hl]
    ret
