ProjectObjectToScreenAndCull:: ; Convert object world position to screen position and set offscreen flag.
    xor a
    ldh [hObjectOffscreen], a
    ldh a, [hSCXHigh]
    ld d, a
    ldh a, [hSCX]
    ld e, a
    ld hl, OBJECT_OFS_X_LO
    add hl, bc
    ld a, [hl+]
    sub e
    ld e, a
    ldh [hObjectScreenX], a
    ld a, [hl+]
    sbc d
    ldh [hTileStreamWritePos], a
    call CheckObjectHorizontalVisibility
    ldh a, [hSCYHigh]
    ld d, a
    ldh a, [hSCY]
    ld e, a
    inc hl
    ld a, [hl+]
    sub e
    ld e, a
    ldh [hObjectScreenY], a
    ld a, [hl+]
    sbc d
    ldh [hObjectScreenYHi], a
    jr c, CheckObjectVerticalVisibility_AboveViewport

    or a
    jr nz, MarkCurrentObjectOffscreen

    ld a, e
    cp $a0
    jr nc, MarkCurrentObjectOffscreen

    ret


CheckObjectVerticalVisibility_AboveViewport::
    cp $ff
    jr nz, MarkCurrentObjectOffscreen

    ld a, e
    cp $f0
    ret nc

    jr MarkCurrentObjectOffscreen

CheckObjectHorizontalVisibility::
    jr c, CheckObjectHorizontalVisibility_LeftEdge

    or a
    jr nz, MarkCurrentObjectOffscreen

    ld a, e
    cp $b8
    jr nc, MarkCurrentObjectOffscreen

    ret


CheckObjectHorizontalVisibility_LeftEdge::
    cp $ff
    jr nz, MarkCurrentObjectOffscreen

    ld a, e
    cp $f0
    ret nc

MarkCurrentObjectOffscreen::
    ld a, $ff
    ldh [hObjectOffscreen], a
    ret


CullObjectAndReleaseSpawn:: ; Despawn object when far offscreen and mark its spawn record ready again.
    call ProjectObjectToScreenAndCull
    ldh a, [hTileStreamWritePos]
    ld d, a
    ldh a, [hObjectScreenX]
    ld e, a
    ld hl, $00a0
    add hl, de
    bit 7, h
    jr nz, CullObject_FreeSlotAndRearmSpawn

    bit 7, d
    jr nz, CullObject_CheckVerticalDistance

    ld hl, -$0140
    add hl, de
    bit 7, h
    jr z, CullObject_FreeSlotAndRearmSpawn

CullObject_CheckVerticalDistance::
    ldh a, [hObjectScreenYHi]
    ld d, a
    ldh a, [hObjectScreenY]
    ld e, a
    ld hl, $0090
    add hl, de
    bit 7, h
    jr nz, CullObject_FreeSlotAndRearmSpawn

    bit 7, d
    jr nz, CullObject_KeepSlot

    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    add hl, de
    bit 7, h
    jr z, CullObject_FreeSlotAndRearmSpawn

CullObject_KeepSlot::
    xor a
    ret


CullObject_FreeSlotAndRearmSpawn::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl-]
    bit 7, a
    ret nz

    ld [hl], $00
    ld hl, OBJECT_OFS_SPAWN_INDEX
    add hl, bc
    ld a, [hl]
    ld de, wSpawnStateList
    rst $30
    ld a, SPAWN_STATE_READY
    ld [de], a
    or a
    ret


MoveObjectXBySpeed:: ; Load object speed from +8/+9, then apply signed X movement.
    ld hl, OBJECT_OFS_SPEED_LO
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, OBJECT_OFS_X_SUBPIXEL
    add hl, bc

ApplyObjectXVelocity:: ; Apply DE as signed fixed-point X velocity based on object facing flag.
    ld a, [bc]
    rlca
    jr c, SubtractSignedVelocityFromPosition24

AddSignedVelocityToPosition24::
    ld a, e
    add [hl]
    ld [hl+], a
    ld a, d
    adc [hl]
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    ret


SubtractSignedVelocityFromPosition24::
    ld a, [hl]
    sub e
    ld [hl+], a
    ld a, [hl]
    sbc d
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    ret


AdvanceObjectAnimCounter:: ; Advance a two-byte animation/timer counter with D/E limits.
    inc [hl]
    ld a, [hl]
    cp d
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ld a, [hl]
    cp e
    ret c

    ld [hl], $00
    ret


DrawCurrentStageObject::
    ld hl, SpriteStageAnimPointerTable_1b25
    ldh a, [hStageIndex]
    rst $20
    ldh a, [hObjectAnimId]
    rst $20
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


LoadPlayerObjectCollisionProbe::
    ldh a, [hPlayerState]
    cp $01
    jr z, PlayerProbe_SelectShortBodyTable

    ldh a, [hPlayerForm]
    cp $02
    jr z, PlayerProbe_SelectShortBodyTable

    jr PlayerProbe_SelectNormalBodyTable

PlayerProbe_SelectShortBodyTable::
    ld hl, PlayerCollisionProbeTableDuckOrCockroach
    jr PlayerProbe_LoadSelectedRecord

PlayerProbe_SelectNormalBodyTable::
    ld hl, PlayerCollisionProbeTableNormal

PlayerProbe_LoadSelectedRecord::
    ld a, d
    add a
    add a
    add d
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ldh [hPlayerObjectProbeRangeX], a
    ld a, [hl+]
    ldh [hPlayerObjectProbeAbove], a
    ld a, [hl+]
    ldh [hPlayerObjectProbeBelow], a
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a
    ret



PlayerCollisionProbeTableNormal::
    db $0e, $14, $0e, $0e, $15, $12, $14, $18, $18, $1d, $0e, $14, $16, $16, $1b, $0a
    db $14, $05, $04, $08, $0e, $14, $04, $fc, $ff, $0e, $14, $10, $08, $10, $12, $14
    db $16, $16, $1b, $0a, $14, $05, $fc, $ff, $14, $14, $1c, $1c, $22

PlayerCollisionProbeTableDuckOrCockroach::
    db $0e, $0e, $0e, $0e, $15, $12, $0e, $18, $18, $1d, $0e, $0e, $16, $16, $1b, $0a
    db $0e, $05, $04, $08, $0e, $0e, $04, $fc, $ff, $0e, $0e, $10, $08, $10, $12, $0e
    db $16, $16, $1b, $0a, $0e, $05, $fc, $ff, $14, $0e, $1c, $1c, $22

CheckPlayerAgainstCurrentObject::
    ldh a, [hPlayerObjectProbeRangeX]
    ld l, a
    ldh a, [hPlayerScreenX]
    ld h, a
    ldh a, [hObjectScreenX]
    sub h
    bit 7, a
    jr z, PlayerObjectCollision_CheckHorizontalRange

    cpl
    inc a

PlayerObjectCollision_CheckHorizontalRange::
    cp l
    ret nc

    ldh a, [hPlayerState]
    cp $02
    jr nz, PlayerObjectCollision_CheckBodyY

    ldh a, [hPlayerVelYHigh]
    rlca
    jr c, PlayerObjectCollision_CheckBodyY

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [hObjectScreenY]
    sub h
    jr c, PlayerObjectCollision_CheckAbove

    cp e
    jr nc, PlayerObjectCollision_ResolveStomp

    cp d
    ccf

PlayerObjectCollision_ResolveStomp::
    jr nc, PlayerObjectCollision_CheckBelow

    call SetPlayerForcedBounceVelocity
    scf
    ret


PlayerObjectCollision_CheckBodyY::
    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [hObjectScreenY]
    sub h
    jr c, PlayerObjectCollision_CheckAbove

PlayerObjectCollision_CheckBelow::
    ld l, a
    ldh a, [hPlayerObjectProbeBelow]
    ld h, a
    ld a, l
    cp h
    ret nc

    jr PlayerObjectCollision_ApplyDamage

PlayerObjectCollision_CheckAbove::
    cpl
    inc a
    ld l, a
    ldh a, [hPlayerObjectProbeAbove]
    ld h, a
    ld a, l
    cp h
    ret nc

PlayerObjectCollision_ApplyDamage::
    call HandlePlayerDamage
    sub a
    ret


CheckCurrentObjectAgainstPoint::
    ldh a, [hObjectScreenX]
    sub [hl]
    bit 7, a
    jr z, ObjectPointCollision_CheckXRange

    cpl
    inc a

ObjectPointCollision_CheckXRange::
    cp d
    ret nc

    inc hl
    ldh a, [hTileStreamWritePos]
    sub [hl]
    bit 7, a
    jr z, ObjectPointCollision_CheckYRange

    cpl
    inc a

ObjectPointCollision_CheckYRange::
    cp e
    ret
