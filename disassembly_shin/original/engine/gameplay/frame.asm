UpdateGameplayState:: ; Main gameplay frame update for hGameState=2.
    ldh a, [hJoyPressed]
    bit 3, a
    jr nz, EnterGameplayPause

    ld a, $ff
    ld [wDropPlatformMinXDistance], a
    call UpdateCameraAndStreamMap
    call UpdateSpecialActors
    call UpdateObjectsAndSpawnQueue
    call UpdatePlayerState
    call UpdateStageAnimatedTiles
    call DrawPlayerSprite
    ld a, [wPendingVramUpdates]
    or a
    ret z

    ldh a, [hVramQueuePos]
    cp $20
    ret nc

    ld a, [wPendingVramUpdates]
    bit 3, a
    jp nz, UploadPendingClearedMetatilePatch

    bit 2, a
    jp nz, UploadPendingMetatile05Patch

    bit 1, a
    jp nz, QueueHealthHudAfterDamage

    bit 0, a
    jp nz, QueueHealthHudAfterGain

    ret


UploadPendingMetatile05Patch::
    ld a, [wPendingVramUpdates]
    res 2, a
    ld [wPendingVramUpdates], a
    ld hl, wPendingMetatile05DestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, HudTilePatch
    ld bc, $0202
    call QueueTilemapRect
    ret


UploadPendingClearedMetatilePatch::
    ld a, [wPendingVramUpdates]
    res 3, a
    ld [wPendingVramUpdates], a
    ld hl, wPendingClearedMetatileDestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, wStage1ClearedMetatileTiles
    ld bc, $0202
    call QueueTilemapRect
    ret



HudTilePatch::
    db $08, $09, $0a, $0b

EnterGameplayPause::
    ld a, $06
    ldh [hGameState], a
    ldh a, [hPrevOamPos]
    ldh [hOamWritePos], a
    xor a
    ld [wSoundPriorityFlags], a
    ld a, $5e
    call PlaySound_Queue1
    ret


DrawPlayer_EndHurtBlink::
    ldh a, [hPlayerFlags]
    res 1, a
    ldh [hPlayerFlags], a
    ret


DrawPlayerSprite:: ; Draw player metasprite using hPlayerForm/hPlayerAnimId and screen position.
    ld hl, wPlayerHurtBlinkTimer
    ld a, [hl]
    or a
    jr z, DrawPlayer_SelectFormMetasprite

    dec [hl]
    jr z, DrawPlayer_EndHurtBlink

    bit 3, [hl]
    ret z

DrawPlayer_SelectFormMetasprite::
    ldh a, [hPlayerDirection]
    and $01
    ld b, a
    ldh a, [hPlayerObjectFlags]
    and $fe
    or b
    ldh [hPlayerObjectFlags], a
    ldh [hSpriteFlags], a
    ld hl, SpriteAnimPointerTable_1a19
    ldh a, [hPlayerForm]
    rst $20
    ldh a, [hPlayerAnimId]
    rst $20
    ldh a, [hPlayerScreenX]
    ld c, a
    ldh a, [hPlayerScreenY]
    ld b, a
    jp DrawMetasprite
