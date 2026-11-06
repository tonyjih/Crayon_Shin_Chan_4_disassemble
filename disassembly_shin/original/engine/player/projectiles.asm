UpdateSpecialActors:: ; Update short-lived gameplay actor slots/effects.
    ld bc, wPlayerSpecialActor0
    call UpdatePlayerSpecialActor0
    ld bc, wPlayerSpecialActor1
    call UpdatePlayerSpecialActor1
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_ACTION_KAMEN
    ret nz

    ld hl, wFormTimerLo
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr z, ActionKamenTimer_UpdateHudBlink

    jr c, ActionKamenTimer_RestorePreviousForm

    ret


ActionKamenTimer_RestorePreviousForm::
    ld a, [wStoredPlayerForm]
    ldh [hPlayerForm], a
    ld a, $04
    ld [wStoredPlayerForm], a
    jp EnterPlayerHurtState


ActionKamenTimer_UpdateHudBlink::
    ld a, [wFormTimerLo]
    ld b, a
    and $0f
    ret z

    bit 4, b
    jp z, QueuePlayerFormHudIcon

    ldh a, [hPlayerForm]
    push af
    xor a
    ldh [hPlayerForm], a
    call QueuePlayerFormHudIcon
    pop af
    ldh [hPlayerForm], a
    ret


UpdatePlayerSpecialActor0:: ; Dispatch/update wPlayerSpecialActor0 by projectile type.
    ld a, [bc]
    or a
    ret z

    rst $00

    ; wPlayerSpecialActor0 type jump table. Type 0 is unused because zero returns above.
    dw UpdateFlyingSquirrelProjectile ; 00/01: flying squirrel projectile slot 0
    dw UpdateFlyingSquirrelProjectile ; 01: flying squirrel projectile slot 0
    dw UpdateChickenProjectile ; 02: chicken projectile
    dw UpdateActionKamenProjectile ; 03: Action Kamen projectile

UpdatePlayerSpecialActor1:: ; Update wPlayerSpecialActor1, used by paired flying-squirrel projectiles.
    ld a, [bc]
    or a
    ret z

    call AdvanceSpecialActorTimer
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearSecondFlyingSquirrelProjectile

    call CheckSpecialActorTileCollision
    jr z, ClearSecondFlyingSquirrelProjectile

    call SetSpecialActorHitbox4x4
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, SpriteFrameData_2e9b
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


ClearSecondFlyingSquirrelProjectile::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    ret


AdvanceSpecialActorTimer:: ; Advance special actor Y/timer field before movement.
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a

MoveSpecialActorX_0180:: ; Move a projectile horizontally at speed $0180.
    ld de, $0180

MoveSpecialActorX:: ; Move a projectile horizontally by DE, honoring direction bit.
    ld h, b
    ld l, c
    inc hl
    bit 0, [hl]
    inc hl
    jp nz, SubtractSignedVelocityFromPosition24

    jp AddSignedVelocityToPosition24


CheckSpecialActorTileCollision:: ; Check projectile tile collision against the stage collision map.
    push bc
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld b, [hl]
    ld c, a
    push de
    call GetStageLayoutTileAtWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    pop de
    ld b, c
    ld c, e
    call IsProjectileTileBlocked
    pop bc
    ret


IsProjectileTileBlocked::
; Return A=0 for passable tiles, $ff otherwise.
    call CheckProjectileTilePassability
    jr c, ProjectileTile_ReturnPassable

    or $ff
    ret


ProjectileTile_ReturnPassable::
    xor a
    ret


SetSpecialActorHitbox4x4:: ; Store a 4x4 special actor hitbox at current projected screen position.
    ld a, $04
    ldh [hActionHitboxHalfWidth], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a
    ldh a, [hObjectScreenX]
    ld [wPlayerActionHitbox1X], a
    ldh a, [hObjectScreenY]
    ld [wPlayerActionHitbox1Y], a
    ret


UpdateFlyingSquirrelProjectile:: ; Special actor type 1: flying-squirrel projectile.
    call MoveSpecialActorX_0180
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearFirstFlyingSquirrelProjectile

    call CheckSpecialActorTileCollision
    jr z, ClearFirstFlyingSquirrelProjectile

    call SetChickenProjectileHitbox
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, SpriteFrameData_2e96
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


ClearFirstFlyingSquirrelProjectile::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    ret


SetChickenProjectileHitbox:: ; Set chicken projectile hitbox using common 4x4 screen position storage.
    jp SetProjectileHitbox4x4AtScreenPos


UpdateChickenProjectile:: ; Special actor type 2: chicken projectile.
    call UpdateChickenProjectileMotion
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearChickenProjectile

    call CheckSpecialActorTileCollision
    jr z, ClearChickenProjectile

    call SetProjectileHitbox4x4AtScreenPos
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, SpriteFrameData_30e2
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


ClearChickenProjectile::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    ret


UpdateChickenProjectileMotion:: ; Update chicken projectile motion; after startup it checks upcoming tiles.
    ld hl, wPlayerSpecialActor0Timer
    ld a, [hl]
    cp $20
    jr nc, ChickenProjectile_CheckForDrop

    inc [hl]
    jp MoveSpecialActorX_0180


ChickenProjectile_CheckForDrop::
    call CheckChickenProjectileNextTile
    call nc, AdvanceChickenProjectileY
    jp MoveSpecialActorX_0180


AdvanceChickenProjectileY:: ; Advance chicken projectile Y position by one pixel/substep.
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    ret


CheckChickenProjectileNextTile:: ; Check passability ahead of the chicken projectile.
    push bc
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    inc de
    inc de
    inc de
    inc de
    push de
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld b, [hl]
    ld c, a
    call GetStageLayoutTileAtWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    pop de
    ld b, c
    ld c, e
    call CheckProjectileTilePassability
    pop bc
    ret


CheckProjectileTilePassability:: ; Dispatch tile-specific projectile passability logic.
    and $3f
    rst $00

    ; rst $00 jump table (64 entries)
    dw ProjectileTile_Blocked, ProjectileTile_Passable, ProjectileTile_PassTopQuarterOnRight, ProjectileTile_PassTopQuarterOnLeft
    dw ProjectileTile_PassTopQuarter, ProjectileTile_PassThirdQuarter, ProjectileTile_Blocked, ProjectileTile_PassTopQuarter
    dw ProjectileTile_PassThirdQuarter, ProjectileTile_Blocked, ProjectileTile_PassTopQuarter, ProjectileTile_Blocked
    dw ProjectileTile_PassThirdQuarterOnRight, ProjectileTile_PassThirdQuarterOnLeft, ProjectileTile_PassTopQuarter, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Passable, ProjectileTile_Passable, ProjectileTile_Blocked
    dw ProjectileTile_Passable, ProjectileTile_PassTopQuarter, ProjectileTile_Blocked, ProjectileTile_PassTopQuarter
    dw ProjectileTile_PassTopQuarter, ProjectileTile_Blocked, ProjectileTile_PassTopQuarter, ProjectileTile_PassUpperHalf
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_PassLowerHalf, ProjectileTile_Blocked
    dw ProjectileTile_Passable, ProjectileTile_Passable, ProjectileTile_Passable, ProjectileTile_Passable
    dw ProjectileTile_Passable, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked
    dw ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked, ProjectileTile_Blocked


ProjectileTile_PassLowerHalf::
    ld a, c
    and $0f
    cp $08
    ccf
    ret nc

    scf
    ret


ProjectileTile_PassUpperHalf::
    ld a, c
    and $0f
    cp $08
    ret nc

    scf
    ret


ProjectileTile_Blocked::
    sub a
    ret


ProjectileTile_Passable::
    scf
    ret


ProjectileTile_PassTopQuarterOnRight::
    bit 3, b
    jr z, ProjectileTile_Blocked

    jr ProjectileTile_PassTopQuarter

ProjectileTile_PassTopQuarterOnLeft::
    bit 3, b
    jr nz, ProjectileTile_Blocked

    jr ProjectileTile_PassTopQuarter

ProjectileTile_PassTopQuarter::
    ld a, c
    and $0f
    cp $04
    ret nc

    scf
    ret


ProjectileTile_PassThirdQuarter::
    ld a, c
    and $0f
    cp $08
    jr c, ProjectileTile_Blocked

    cp $0c
    ret nc

    scf
    ret


ProjectileTile_PassThirdQuarterOnRight::
    bit 3, b
    jr z, ProjectileTile_Blocked

    jr ProjectileTile_PassThirdQuarter

ProjectileTile_PassThirdQuarterOnLeft::
    bit 3, b
    jr nz, ProjectileTile_Blocked

    jr ProjectileTile_PassThirdQuarter

SetProjectileHitbox4x4AtScreenPos:: ; Use $ffd3/$ffd4 as a 4x4 projectile hitbox position.
    ld a, $04
    ldh [hActionHitboxHalfWidth], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a

StoreProjectileHitboxAtScreenPos:: ; Store projected projectile hitbox position from $ffd3/$ffd4.
    ldh a, [hObjectScreenX]
    ld [wPlayerActionHitbox0X], a
    ldh a, [hObjectScreenY]
    ld [wPlayerActionHitbox0Y], a
    ret


UpdateActionKamenProjectile:: ; Special actor type 3: Action Kamen projectile.
    call MoveActionKamenProjectile
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearActionKamenProjectile

    call SetActionKamenProjectileHitbox8x8
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, SpriteFrameData_32d2
    ld a, [wPlayerSpecialActor0Timer]
    inc a
    ld [wPlayerSpecialActor0Timer], a
    bit 4, a
    jr nz, ActionKamenProjectile_DrawSelectedFrame

    ld hl, SpriteFrameData_32e7

ActionKamenProjectile_DrawSelectedFrame::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


ClearActionKamenProjectile::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    ret


SetActionKamenProjectileHitbox8x8:: ; Use $ffd3/$ffd4 as an 8x8 Action Kamen projectile hitbox.
    ld a, $08
    ldh [hActionHitboxHalfWidth], a
    ld a, $08
    ldh [hActionHitboxHalfHeight], a
    jp StoreProjectileHitboxAtScreenPos


MoveActionKamenProjectile:: ; Move Action Kamen projectile horizontally at speed $0300.
    ld de, $0300
    jp MoveSpecialActorX
