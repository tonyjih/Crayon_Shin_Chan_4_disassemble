UpdateObjPickupChocobi:: ; Object type $10: Chocobi pickup; 30 awards an extra life.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jp nz, CullObject_FreeSlotAndRearmSpawn

    call CheckPlayerPickupChocobi

DrawChocobiPickup::
    ld hl, SpriteFrameData_2c85
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupChocobi::
    ld e, $0a
    ld d, $11
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $45
    call PlaySound
    xor a
    ld [bc], a
    inc a
    jp AddBonusCounter


CheckPlayerPickupOverlap::
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
    sub $0c
    sub h
    rst $28
    cp d
    ret


UpdateObjPickupHiddenChocobi:: ; Object type $11: hidden Chocobi; appears/effects after collection.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, UpdateRevealedChocobi

    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jp nz, CullObject_FreeSlotAndRearmSpawn

    ld e, $0a
    ld d, $11
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $44
    call PlaySound
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


UpdateRevealedChocobi::
    call FinishHiddenChocobiPickup
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jr DrawChocobiPickup

FinishHiddenChocobiPickup::
    call UpdateAnimatedPickupMotion
    ret c

    xor a
    ld [bc], a
    inc a
    jp AddBonusCounter


UpdateAnimatedPickupMotion::
    ld hl, $0005
    add hl, bc
    ld de, $0100
    call SubtractSignedVelocityFromPosition24
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    push af
    ld hl, AnimatedPickupXSteps
    rst $38
    ld a, [hl]
    or a
    jr z, AnimatedPickup_CheckRiseTimer

    rlca
    jr c, AnimatedPickup_NudgeXLeft

    inc de
    jr AnimatedPickup_StoreNudgedX

AnimatedPickup_NudgeXLeft::
    dec de

AnimatedPickup_StoreNudgedX::
    ld hl, $0003
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d

AnimatedPickup_CheckRiseTimer::
    pop af
    cp $20
    ret



AnimatedPickupXSteps::
; Signed one-pixel offsets applied during the 32-frame rise.
    db $01, $01, $01, $00, $00, $00, $00, $00, $ff, $00, $00, $00, $01, $00, $00, $00
    db $ff, $00, $00, $00, $01, $00, $00, $00, $ff, $00, $00, $00, $01, $00, $00, $00
UpdateObjPickupExtraLife:: ; Object type $12: immediate extra-life pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jp nz, CullObject_FreeSlotAndRearmSpawn

    call CheckPlayerPickupExtraLife

DrawExtraLifePickup::
    ld hl, SpriteFrameData_2c9f
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupExtraLife::
    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    xor a
    ld [bc], a
    jp AddExtraLife


UpdateObjPickupHiddenExtraLife:: ; Object type $13: hidden extra-life pickup; appears/effects after collection.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, UpdateRevealedExtraLife

    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jp nz, CullObject_FreeSlotAndRearmSpawn

    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $44
    call PlaySound
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


UpdateRevealedExtraLife::
    call FinishAnimatedExtraLifePickup
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jr DrawExtraLifePickup

FinishAnimatedExtraLifePickup::
    call UpdateAnimatedPickupMotion
    ret c

    xor a
    ld [bc], a
    jp AddExtraLife


UpdateObjPickupHealth:: ; Object type $14: add hPlayerHealth by 1, max 3.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerPickupHealth

DrawHealthPickup::
    ld hl, SpriteFrameData_2c8e
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupHealth::
    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $45
    call PlaySound
    xor a
    ld [bc], a
    inc a
    jp AddPlayerHealth


UpdateObjPickupHiddenHealth:: ; Object type $15: hidden health pickup; appears/effects after collection.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, UpdateRevealedHealth

    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jp nz, CullObject_FreeSlotAndRearmSpawn

    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $44
    call PlaySound
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


UpdateRevealedHealth::
    call FinishAnimatedHealthPickup
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jr DrawHealthPickup

FinishAnimatedHealthPickup::
    call UpdateAnimatedPickupMotion
    ret c

    xor a
    ld [bc], a
    inc a
    jp AddPlayerHealth


UpdateObjFormFlyingSquirrel:: ; Object type $16: Flying Squirrel form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerPickupFormFlyingSquirrel
    ld hl, SpriteFrameData_2c41
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupFormFlyingSquirrel::
    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $45
    call PlaySound
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, hPlayerFlags
    res 2, [hl]
    ld a, PLAYER_FORM_FLYING_SQUIRREL
    ldh [hPlayerForm], a

ApplyPickedUpPlayerForm::
; Remove the pickup and start the existing form-change animation state.
    xor a
    ld [bc], a
    jp EnterPlayerHurtState


UpdateObjFormCockroach:: ; Object type $17: Cockroach form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerPickupFormCockroach
    ld hl, SpriteFrameData_2c74
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupFormCockroach::
    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $45
    call PlaySound
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, hPlayerFlags
    res 2, [hl]
    ld a, PLAYER_FORM_COCKROACH
    ldh [hPlayerForm], a
    jr ApplyPickedUpPlayerForm

UpdateObjFormChicken:: ; Object type $18: Chicken form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerPickupFormChicken
    ld hl, SpriteFrameData_2c63
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupFormChicken::
    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ld a, $45
    call PlaySound
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, hPlayerFlags
    res 2, [hl]
    ld a, PLAYER_FORM_CHICKEN
    ldh [hPlayerForm], a
    jp ApplyPickedUpPlayerForm


UpdateObjFormActionKamen:: ; Object type $19: timed Action Kamen form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerPickupFormActionKamen
    ld hl, SpriteFrameData_2c52
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


CheckPlayerPickupFormActionKamen::
    ld e, $0e
    ld d, $12
    call CheckPlayerPickupOverlap
    ret nc

    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, hPlayerFlags
    set 2, [hl]
    ld a, PLAYER_FORM_ACTION_KAMEN
    ldh [hPlayerForm], a
    ld hl, $0600 ; form timer constant, not a ROM0 CopyTilemapRowToVram_Loop pointer
    ld a, l
    ld [wFormTimerLo], a
    ld a, h
    ld [wFormTimerHi], a
    jp ApplyPickedUpPlayerForm
