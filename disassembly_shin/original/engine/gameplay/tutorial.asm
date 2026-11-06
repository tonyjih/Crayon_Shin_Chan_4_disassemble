InitTutorialDemo::
    ld hl, TutorialDemoInputScript
    ld a, l
    ld [wTutorialInputPtrLo], a
    ld a, h
    ld [wTutorialInputPtrHi], a
    xor a
    ld [wScreenFrameCounter], a
    ldh [hJoyHeld], a
    ld [wScreenPhaseCounter], a
    ld [wTutorialMessageIndex], a
    ld [wTutorialMessageDelay], a
    ld [wTutorialJoyHeld], a
    ld [wTutorialInputTimer], a
    ld a, $5c
    ldh [hOamMaxY], a
    ld a, $8f
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN1
    ld bc, $1206
    call DrawTilemapBox
    ld a, $50
    ldh [hWY], a
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $800
    ld bc, $0100
    call BankedMemcpy
    ld a, BANK(GfxRle_b03_400f)
    ld hl, GfxRle_b03_400f
    ld de, _VRAM + $900
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    call InitSound
    ld a, $20
    call PlaySound_Queue3
    ret

UpdateTutorialDemo::
    ld hl, $00e0
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ldh a, [hJoyHeld]
    and $0f
    cp $0f
    ret z

    ldh a, [hJoyHeld]
    and $08
    jr nz, TutorialDemo_ReturnToGameplay

    ldh a, [hPlayerXHigh]
    or a
    jr z, TutorialDemo_ReadInputAndUpdateCamera

TutorialDemo_ReturnToGameplay::
    xor a
    ld [wPlayerSpecialActor0], a
    ld [wPlayerSpecialActor1], a
    ldh [hStageIndex], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


TutorialDemo_ReadInputAndUpdateCamera::
    call ReadTutorialDemoInput
    ldh a, [hSCX]
    ld b, a
    ldh a, [hPlayerX]
    sub b
    cp $38
    jr nc, TutorialDemo_CheckRightCameraThreshold

    ldh a, [hPlayerX]
    sub $38
    jr nc, TutorialDemo_StoreLeftwardScroll

    xor a

TutorialDemo_StoreLeftwardScroll::
    ldh [hSCX], a
    ld b, a
    jr TutorialDemo_ProjectXAndUpdateCameraY

TutorialDemo_CheckRightCameraThreshold::
    cp $68
    jr c, TutorialDemo_ProjectXAndUpdateCameraY

    ldh a, [hPlayerX]
    sub $68
    cp $60
    jr c, TutorialDemo_StoreRightwardScroll

    ld a, $60

TutorialDemo_StoreRightwardScroll::
    ldh [hSCX], a
    ld b, a

TutorialDemo_ProjectXAndUpdateCameraY::
    ldh a, [hPlayerX]
    sub b
    ldh [hPlayerScreenX], a
    ldh a, [hSCY]
    ld c, a
    ldh a, [hPlayerY]
    sub c
    cp $18
    jr nc, TutorialDemo_CheckLowerCameraThreshold

    ldh a, [hPlayerY]
    sub $18
    jr nc, TutorialDemo_StoreUpwardScroll

    xor a

TutorialDemo_StoreUpwardScroll::
    ldh [hSCY], a
    ld c, a
    jr TutorialDemo_UpdateActorsAndDrawPlayer

TutorialDemo_CheckLowerCameraThreshold::
    cp $48
    jr c, TutorialDemo_UpdateActorsAndDrawPlayer

    ldh a, [hPlayerY]
    sub $48
    cp $b0
    jr c, TutorialDemo_StoreDownwardScroll

    ld a, $b0

TutorialDemo_StoreDownwardScroll::
    ldh [hSCY], a
    ld c, a

TutorialDemo_UpdateActorsAndDrawPlayer::
    ldh a, [hPlayerY]
    sub c
    ldh [hPlayerScreenY], a
    call UpdateSpecialActors
    call UpdateObjectsAndSpawnQueue
    call UpdatePlayerState
    call DrawPlayerSprite
    ld hl, wVramQueue

TutorialDemo_CheckNextVramCommand::
; Stop the gameplay queue at its first window tilemap command before updating the tutorial message.
    ld a, [hl]
    or a
    jp z, TutorialDemo_CommitQueueAndUpdateText

    and $fc
    cp $9c
    jr nz, TutorialDemo_SkipVramCommand

    xor a
    ld [hl], a
    jr TutorialDemo_CommitQueueAndUpdateText

TutorialDemo_SkipVramCommand::
    inc hl
    ld b, [hl]
    inc hl
    ld a, [hl+]
    inc hl
    and $3c
    rst $38
    jr TutorialDemo_CheckNextVramCommand

TutorialDemo_CommitQueueAndUpdateText::
    ld bc, $3f00 ; constant, not a ROM0 data pointer
    add hl, bc
    ld a, l
    ldh [hVramQueuePos], a
    call UpdateMessageFar
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $0f
    jr nz, TutorialDemo_TickMessageDelay

    ld a, [wTutorialMessageIndex]
    ld hl, TutorialMessageChangeTicks
    rst $38
    ld b, [hl]
    ld a, [wScreenFrameCounter]
    cp b
    jr nz, TutorialDemo_AdvanceMessageClock

    xor a
    ld [wTutorialMessageDelay], a
    ld a, $04
    ld [wMessageFlags], a
    ld a, [wTutorialMessageIndex]
    or a
    jr z, TutorialDemo_AdvanceMessageClock

    add $5c
    call StartMessageFar

TutorialDemo_AdvanceMessageClock::
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a

TutorialDemo_TickMessageDelay::
    ld a, [wTutorialMessageDelay]
    bit 7, a
    ret nz

    inc a
    ld [wTutorialMessageDelay], a
    cp $04
    ret nz

    xor a
    ld [wMessageFlags], a
    ld a, [wTutorialMessageIndex]
    add $5d
    call StartMessageFar
    ld a, [wTutorialMessageIndex]
    inc a
    ld [wTutorialMessageIndex], a
    ret


ReadTutorialDemoInput::
    ld a, [wTutorialJoyHeld]
    ldh [hJoyHeld], a
    xor a
    ldh [hJoyPressed], a
    ld a, [wTutorialInputTimer]
    dec a
    ld [wTutorialInputTimer], a
    cp $ff
    ret nz

    ld hl, wTutorialInputPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    and $f3
    ld [wTutorialJoyHeld], a
    ldh [hJoyPressed], a
    ld a, [hl+]
    ld [wTutorialInputTimer], a
    ld a, l
    ld [wTutorialInputPtrLo], a
    ld a, h
    ld [wTutorialInputPtrHi], a
    ret
