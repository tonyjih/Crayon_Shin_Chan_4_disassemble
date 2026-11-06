UpdateObjectSlotByType:: ; Dispatch an object slot behavior by type.
    ld b, h
    ld c, l
    and OBJECT_TYPE_MASK
    rst $00

    ; Object behavior dispatch table. rst $00 consumes these words as data.
    dw UpdateObjNone00 ; 00: OBJ_NONE
    dw UpdateObjStage0Boss ; 01: OBJ_STAGE0_BOSS
    dw UpdateObjStage1Boss ; 02: OBJ_STAGE1_BOSS
    dw UpdateObjStage2Boss ; 03: OBJ_STAGE2_BOSS
    dw UpdateObjStage3Boss ; 04: OBJ_STAGE3_BOSS
    dw UpdateObjStage0BossProjectile ; 05: OBJ_STAGE0_BOSS_PROJECTILE
    dw UpdateObjBouncingBall ; 06: OBJ_BOUNCING_BALL
    dw UpdateObjActionKamenHangingDoll ; 07: OBJ_ACTION_KAMEN_HANGING_DOLL
    dw UpdateObjFloatingBeachBall ; 08: OBJ_FLOATING_BEACH_BALL
    dw UpdateObjDropPlatformA ; 09: OBJ_PLATFORM_DROP_A_VARIANT
    dw UpdateObjEnemyWalkingKid ; 0a: OBJ_ENEMY_WALKING_KID
    dw UpdateObjEnemyPartyHornKid ; 0b: OBJ_ENEMY_PARTY_HORN_KID
    dw UpdateObjEnemyUmbrellaKid ; 0c: OBJ_ENEMY_UMBRELLA_KID
    dw UpdateObjEnemyPaperAirplaneKid ; 0d: OBJ_ENEMY_PAPER_AIRPLANE_KID
    dw UpdateObjEnemyPaperAirplane ; 0e: OBJ_ENEMY_PAPER_AIRPLANE
    dw UpdateObjEnemyToughKid ; 0f: OBJ_ENEMY_TOUGH_KID
    dw UpdateObjPickupChocobi ; 10: OBJ_PICKUP_CHOCOBI
    dw UpdateObjPickupHiddenChocobi ; 11: OBJ_PICKUP_HIDDEN_CHOCOBI
    dw UpdateObjPickupExtraLife ; 12: OBJ_PICKUP_EXTRA_LIFE
    dw UpdateObjPickupHiddenExtraLife ; 13: OBJ_PICKUP_HIDDEN_EXTRA_LIFE
    dw UpdateObjPickupHealth ; 14: OBJ_PICKUP_HEALTH
    dw UpdateObjPickupHiddenHealth ; 15: OBJ_PICKUP_HIDDEN_HEALTH
    dw UpdateObjFormFlyingSquirrel ; 16: OBJ_FORM_FLYING_SQUIRREL
    dw UpdateObjFormCockroach ; 17: OBJ_FORM_COCKROACH
    dw UpdateObjFormChicken ; 18: OBJ_FORM_CHICKEN
    dw UpdateObjFormActionKamen ; 19: OBJ_FORM_ACTION_KAMEN
    dw UpdateObjMovingPlatformVerticalA ; 1a: OBJ_PLATFORM_MOVING_VERTICAL_A
    dw UpdateObjMovingPlatformHorizontal ; 1b: OBJ_PLATFORM_MOVING_HORIZONTAL
    dw UpdateObjDropPlatformA ; 1c: OBJ_PLATFORM_DROP_A
    dw UpdateObjPlatformBouncePad ; 1d: OBJ_PLATFORM_BOUNCE_PAD
    dw UpdateObjDropPlatformB ; 1e: OBJ_PLATFORM_DROP_B
    dw UpdateObjStage2FallingProduct ; 1f: OBJ_STAGE2_FALLING_PRODUCT
    dw UpdateObjStage2SoccerBall ; 20: OBJ_STAGE2_SOCCER_BALL
    dw UpdateObjStage2BossProjectile ; 21: OBJ_STAGE2_BOSS_PROJECTILE
    dw UpdateObjStage2ShoppingCart ; 22: OBJ_STAGE2_SHOPPING_CART
    dw UpdateObjStage3FallingCoconut ; 23: OBJ_STAGE3_FALLING_COCONUT
    dw UpdateObjStage3BossProjectile ; 24: OBJ_STAGE3_BOSS_PROJECTILE
    dw UpdateObjNone00 ; 25: unused/fallback
    dw UpdateObjNone00 ; 26: unused/fallback
    dw UpdateObjNone00 ; 27: unused/fallback
UpdateObjNone00:: ; Object type $00 / fallback: no-op object behavior.
    ret


; Known object type groups:
;   $05-$08: stage-specific event/enemy-like actors.
;   $09: drop-platform variant sharing the type $1c routine.
;   $0a-$0f: enemy-like objects using player action/body collision.
;   $10-$15: pickup objects (bonus counter, extra life, health), including animated variants.
;   $16-$19: player form pickup objects.
;   $1a-$1e/$22: platform/stage-interaction objects; $21 is stage-specific event/controller.
;   $00-$04/$23-$24: stage-specific event/enemy/boss-like objects (exact names pending).
UpdateObjectsAndSpawnQueue:: ; Update active object slots and spawn queued objects near camera.
    ld a, [wStageBossCountdown]
    or a
    jr z, Objects_BeginFrameSlotScan

    call UpdateStageBossIntro

Objects_BeginFrameSlotScan::
    xor a
    ldh [hPlayerPlatformAttached], a
    ld hl, wObjectSlots

Objects_CheckNextSlot::
    ld a, [hl]
    or a
    jr z, Objects_AdvanceSlot

    cp OBJECT_LIST_END
    jr z, Objects_ProcessFourSpawnRecords

    push hl
    call UpdateObjectSlotByType
    pop hl

Objects_AdvanceSlot::
    ld bc, OBJECT_SLOT_SIZE
    add hl, bc
    jr Objects_CheckNextSlot

Objects_ProcessFourSpawnRecords::
    call TrySpawnNextObject
    call TrySpawnNextObject
    call TrySpawnNextObject
    jr TrySpawnNextObject

ResetSpawnCursor::
    xor a
    ld [wSpawnCursor], a
    ret


TrySpawnNextObject:: ; Try to spawn the next eligible stage object near the camera.
    ld hl, wSpawnCursor
    ld a, [hl]
    ld c, a
    ld b, $00
    inc [hl]
    ld hl, wSpawnStateList
    add hl, bc
    ld a, [hl]
    cp SPAWN_LIST_END
    jr z, ResetSpawnCursor

    cp SPAWN_STATE_READY
    ret nz

    ld hl, StageSpawnListPtrs
    ldh a, [hStageIndex]
    rst $20
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    ld a, l
    ldh [hSpawnRecordPtrLo], a
    ld a, h
    ldh [hSpawnRecordPtrHi], a
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld d, a
    push hl
    ld hl, hSCX
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ld de, $0050
    add hl, de
    bit 7, h
    jr z, Spawn_CheckHorizontalWindow

    ld a, l
    cpl
    add $01
    ld l, a
    ld a, h
    cpl
    adc $00
    ld h, a

Spawn_CheckHorizontalWindow::
; DE was the spawn X. HL is now the absolute distance from the camera center.
    ld a, h
    ld e, l
    pop hl
    or a
    ret nz

    ldh a, [hTileStreamWritePos]
    cp $10
    jr c, Spawn_CheckLowTypeWindow

    ld a, e
    cp $70
    ret nc

    jr Spawn_MarkRecordBlocked

Spawn_CheckLowTypeWindow::
    ld a, e
    cp $b0
    ret nc

    cp $60
    jr c, Spawn_CheckYInsideViewport

Spawn_MarkRecordBlocked::
    ld hl, wSpawnStateList
    add hl, bc
    ld [hl], SPAWN_STATE_BLOCKED

FindFreeObjectSlot:: ; Find an empty object slot, extending the list if needed.
    ld hl, wObjectSlots

Spawn_CheckNextFreeSlot::
    ld a, [hl]
    or a
    jr z, SpawnObjectIntoSlot

    cp $ff
    jr z, Spawn_AppendSlotBeforeTerminator

    ld de, OBJECT_SLOT_SIZE
    add hl, de
    jr Spawn_CheckNextFreeSlot

Spawn_CheckYInsideViewport::
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hSCY]
    ld e, a
    ldh a, [hSCYHigh]
    ld d, a
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ld a, h
    or a
    jr nz, Spawn_MarkRecordBlocked

    ld a, l
    cp $a0
    jr nc, Spawn_MarkRecordBlocked

    ret


Spawn_AppendSlotBeforeTerminator::
    call SpawnObjectIntoSlot
    ld a, OBJECT_LIST_END
    ld hl, OBJECT_SLOT_SIZE
    add hl, bc
    ld [hl], a
    ret


SpawnObjectIntoSlot:: ; Copy a 5-byte spawn record into the selected object slot.
    ld d, h
    ld e, l
    ld a, c
    ld hl, OBJECT_OFS_SPAWN_INDEX
    add hl, de
    ld [hl], a
    ld b, d
    ld c, e
    ld hl, hSpawnRecordPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    push af
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    and $f8
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld h, d
    ld l, e
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl], $01
    call SetObjectFacingPlayerOnSpawn

InitSpawnedObjectByType:: ; Run object-type-specific initialization after spawning.
    pop af
    and OBJECT_TYPE_MASK
    rst $00

    ; Spawned object initialization dispatch table. rst $00 consumes these words as data.
    dw InitSpawnedObjectNoInit ; 00
    dw InitSpawnedObjectParamBlockA ; 01
    dw InitSpawnedObjectParamBlockB ; 02
    dw InitSpawnedObjectParamBlockC ; 03
    dw InitSpawnedObjectParamBlockD ; 04
    dw InitSpawnedObjectNoInit ; 05
    dw InitSpawnedObjectNoInit ; 06
    dw InitSpawnedObjectAnimParamFromTable ; 07
    dw InitSpawnedObjectNoInit ; 08
    dw InitSpawnedObjectNoInit ; 09
    dw InitSpawnedObjectMotionBlockA ; 0a
    dw InitSpawnedObjectMotionBlockA ; 0b
    dw InitSpawnedObjectMotionBlockB ; 0c
    dw InitSpawnedObjectMotionBlockC ; 0d
    dw InitSpawnedObjectNoInit ; 0e
    dw InitSpawnedObjectMotionBlockD ; 0f
    dw InitSpawnedObjectNoInit ; 10
    dw InitSpawnedObjectNoInit ; 11
    dw InitSpawnedObjectNoInit ; 12
    dw InitSpawnedObjectNoInit ; 13
    dw InitSpawnedObjectNoInit ; 14
    dw InitSpawnedObjectNoInit ; 15
    dw InitSpawnedObjectNoInit ; 16
    dw InitSpawnedObjectNoInit ; 17
    dw InitSpawnedObjectNoInit ; 18
    dw InitSpawnedObjectNoInit ; 19
    dw InitSpawnedObjectPlatformParamFromTable ; 1a
    dw InitSpawnedObjectPlatformParamFromTable ; 1b
    dw InitSpawnedObjectNoInit ; 1c
    dw InitSpawnedObjectSpawnParamLowBits ; 1d
    dw InitSpawnedObjectNoInit ; 1e
    dw InitSpawnedObjectNoInit ; 1f
    dw InitSpawnedObjectFacingFromSpawnParam ; 20
    dw InitSpawnedObjectNoInit ; 21
    dw InitSpawnedObjectFacingFromSpawnParam ; 22
    dw InitSpawnedObjectNoInit ; 23
    dw InitSpawnedObjectNoInit ; 24
    dw InitSpawnedObjectNoInit ; 25
    dw InitSpawnedObjectNoInit ; 26
    dw InitSpawnedObjectNoInit ; 27
    dw InitSpawnedObjectNoInit ; 28
    dw InitSpawnedObjectNoInit ; 29
    dw InitSpawnedObjectNoInit ; 2a
    dw InitSpawnedObjectNoInit ; 2b
    dw InitSpawnedObjectNoInit ; 2c
    dw InitSpawnedObjectNoInit ; 2d
    dw InitSpawnedObjectNoInit ; 2e
    dw InitSpawnedObjectNoInit ; 2f

InitSpawnedObjectNoInit:: ; Default spawned-object init: no extra setup.
    ret


SetObjectFacingPlayerOnSpawn:: ; Set initial object facing flag based on player/object X position.
    ld hl, $0003
    add hl, bc
    ldh a, [hPlayerX]
    sub [hl]
    inc hl
    ldh a, [hPlayerXHigh]
    sbc [hl]
    ret nc

    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


InitSpawnedObjectFacingFromSpawnParam:: ; Use spawn param bit 0 to set object facing flag.
    ldh a, [hTileStreamWritePos]
    srl a
    ld a, [bc]
    res 7, a
    jr nc, Spawn_StoreFacingFlags

    set 7, a

Spawn_StoreFacingFlags::
    ld [bc], a
    ret


InitSpawnedObjectAnimParamFromTable:: ; Initialize object animation params from low spawn bits.
    ld a, [bc]
    and $7f
    ld [bc], a
    ldh a, [hTileStreamWritePos]
    and $07
    ld hl, SpawnAnimParamTable
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    srl a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret



SpawnAnimParamTable::
    db $30, $40, $48, $50, $58, $60, $68, $70

InitSpawnedObjectSpawnParamLowBits:: ; Store low 3 spawn parameter bits in object param A.
    ldh a, [hTileStreamWritePos]
    and $07
    ld hl, $000a
    add hl, bc
    ld [hl], a
    ret


InitSpawnedObjectPlatformParamFromTable:: ; Initialize platform param from low spawn bits.
    ldh a, [hTileStreamWritePos]
    and $07
    ld hl, PlatformSpawnParamTable
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret



PlatformSpawnParamTable::
    db $30, $3c, $48, $54, $60, $aa

InitSpawnedObjectMotionBlockA:: ; Initialize motion params from block A.
    ld de, SpawnMotionBlockA
    jr Spawn_ApplyModeMotionBlock


SpawnMotionBlockA::
    db $80, $00, $01, $01, $c0, $00, $02, $02

InitSpawnedObjectMotionBlockB:: ; Initialize motion params from block B.
    ld de, SpawnMotionBlockB
    jr Spawn_ApplyModeMotionBlock


SpawnMotionBlockB::
    db $c0, $00, $01, $01, $20, $01, $02, $02

InitSpawnedObjectMotionBlockC:: ; Initialize motion params from block C.
    ld de, SpawnMotionBlockC
    jr Spawn_ApplyModeMotionBlock


SpawnMotionBlockC::
    db $80, $00, $01, $01, $c0, $00, $02, $02

InitSpawnedObjectMotionBlockD:: ; Initialize motion params from block D.
    ld de, SpawnMotionBlockD
    jr Spawn_ApplyModeMotionBlock


SpawnMotionBlockD::
    db $00, $01, $02, $02, $80, $01, $03, $03

Spawn_ApplyModeMotionBlock::
    ld a, [wAlternateModeFlags]
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, [de]
    inc de
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl], a
    ld a, [de]
    ld hl, $000e
    add hl, bc
    ld [hl], a
    ld a, [de]
    ld l, $00
    ld a, [wAlternateModeFlags]
    or a
    jr z, Spawn_LookUpAnimationParams

    ld l, $08

Spawn_LookUpAnimationParams::
    ldh a, [hTileStreamWritePos]
    and $07
    add l
    ld hl, SpawnAnimParamTableB
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    srl a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret



SpawnAnimParamTableB::
    db $18, $30, $50, $70, $80, $a0, $c0, $f0, $10, $20, $34, $4a, $54, $6a, $80, $a0
InitSpawnedObjectParamBlockA:: ; Initialize params from block A.
    ld de, SpawnParamBlockA
    jr Spawn_ApplyModeMotionBlock


SpawnParamBlockA::
    db $00, $01, $03, $03, $80, $01, $06, $06

InitSpawnedObjectParamBlockB:: ; Initialize params from block B.
    ld de, SpawnParamBlockB
    jr Spawn_ApplyModeMotionBlock


SpawnParamBlockB::
    db $00, $01, $04, $04, $80, $01, $08, $08

InitSpawnedObjectParamBlockC:: ; Initialize params from block C.
    ld de, SpawnParamBlockC
    jr Spawn_ApplyModeMotionBlock


SpawnParamBlockC::
    db $c0, $00, $03, $03, $40, $01, $05, $05

InitSpawnedObjectParamBlockD:: ; Initialize params from block D and clear event substate.
    xor a
    ld [wStage3BossNormalHitEnabled], a
    ld de, SpawnParamBlockD
    jp Spawn_ApplyModeMotionBlock



SpawnParamBlockD::
    db $80, $01, $05, $05, $00, $02, $08, $08

InitObjectSpawnList:: ; Initialize object slots and per-stage spawn list state.
    xor a
    ld [wSpawnCursor], a
    call InitSpawnStateList
    ld a, $ff
    ld hl, wObjectSlots
    ld b, $00
    call FillBytesWithA
    jp FillBytesWithA


InitSpawnStateList:: ; Initialize one-byte state entries for stage spawn records.
    ld hl, StageSpawnListPtrs
    ldh a, [hStageIndex]
    rst $20
    ld d, h
    ld e, l
    ld hl, wSpawnStateList

SpawnState_InitNextRecord::
    ld a, [de]
    cp $ff
    jr z, SpawnState_WriteTerminator

    ld a, $01
    ld [hl+], a
    ld a, SPAWN_RECORD_SIZE
    rst $30
    jr SpawnState_InitNextRecord

SpawnState_WriteTerminator::
    ld [hl], $ff
    ret


StageSpawnListPtrs::
    dw Stage0SpawnList
    dw Stage1SpawnList
    dw Stage2SpawnList
    dw Stage3SpawnList
    dw Stage4SpawnList
