; B=screen Y, C=screen X; DE points to pointer lo/hi, then duration/facing.
; Script bytes stay in the caller's current bank. A=1 on HOLD, otherwise 0.
AnimateSceneMetasprite::
    ld a, [ROM_BANK_ID_ADDR]
    push af
    xor a
    ldh [hSceneAnimHeld], a
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    ld h, a
    inc de
    ld a, [de]
    and SCENE_ANIM_DURATION_MASK
    jr nz, AnimateSceneMetasprite_SavePosition

    ld a, [hl]
    cp SCENE_ANIM_HOLD
    jr nz, AnimateSceneMetasprite_AdvanceCommand

    ld a, $01
    ldh [hSceneAnimHeld], a
    ; HOLD keeps the cursor on $fe; drawing reads the preceding metasprite ID.
    jr AnimateSceneMetasprite_Draw

AnimateSceneMetasprite_AdvanceCommand::
    ld a, [hl+]
    cp SCENE_ANIM_LOOP
    jr nz, AnimateSceneMetasprite_SetDuration

    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ; A loop target must start with a frame pair, not another control command.
    ld a, [hl+]
    ld [de], a
    inc hl
    jr AnimateSceneMetasprite_SavePosition

AnimateSceneMetasprite_SetDuration::
    ld [de], a
    inc hl

AnimateSceneMetasprite_SavePosition::
    ; Store the next-command pointer; the previous byte is the displayed frame ID.
    dec de
    ld a, h
    ld [de], a
    dec de
    ld a, l
    ld [de], a
    inc de
    inc de
    ld a, [de]
    dec a
    ld [de], a

AnimateSceneMetasprite_Draw::
    dec hl
    ld a, [de]
    bit 7, a
    ld a, $00
    jr z, AnimateSceneMetasprite_SetFacing

    ld a, $01

AnimateSceneMetasprite_SetFacing::
    ldh [hSpriteFlags], a
    push bc
    ld c, [hl]
    ld b, $00
    sla c
    rl b
    ld a, BANK(Bank3MetaspritePtrTable)
    ld [rRomBankSelect], a
    ld hl, Bank3MetaspriteTableReference
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    pop bc
    call DrawMetasprite
    pop af
    ld [rRomBankSelect], a
    ldh a, [hSceneAnimHeld]
    ret
