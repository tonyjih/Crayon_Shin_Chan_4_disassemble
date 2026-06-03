; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

    db $01, $bf, $44, $09, $40

    db $ed
    ld a, e
    adc e
    ld a, e

    ldh a, [$ff9f]
    add $1a
    ld [$d933], a
    xor a
    ldh [hNeedsReset], a
    call Call_000_0963
    ld a, [$c0a9]
    rst $00

    ; Gameplay init substate jump table.
    dw InitGameplaySubstateFreshStart
    dw InitGameplaySubstateResetStageFlags
    dw InitGameplaySubstateCommon
    dw InitGameplaySubstateCommon

InitGameplaySubstateFreshStart::
    xor a
    ldh [hPlayerForm], a
    ldh [hPlayerHealth], a
    ldh [hBonusCounter], a
    ld a, $02
    ldh [hPlayerLives], a

InitGameplaySubstateResetStageFlags::
    xor a
    ld [$c0a8], a
    ld [$c0b4], a

InitGameplaySubstateCommon::
    call Call_001_41a9
    call Call_001_417f
    call InitObjectSpawnList
    call Call_001_43c8
    xor a
    ld [wPendingVramUpdates], a
    jp Jump_000_0d8b


Call_001_4047::
    call Call_001_425e
    call Call_001_420f
    ld hl, StageCollisionAttrPtrs
    ldh a, [$ff9f]
    rst $20
    ld de, $c700
    ld bc, $0100
    ld a, $04
    call BankedMemcpy
    ld hl, StageMetatileQuadPtrs
    ldh a, [$ff9f]
    rst $20
    ld a, l
    ldh [$ffa2], a
    ld a, h
    ldh [$ffa3], a
    ld a, $48
    ld [$c408], a
    ld a, $58
    ld [$c409], a
    ld a, $40
    ld [$c40a], a
    ld a, $58
    ld [$c40b], a
    ld a, $02
    ld [$c40c], a
    ld a, $04
    ld [$c40d], a
    xor a
    ld [$c411], a
    ld a, $08
    ld [$c410], a
    xor a
    ld [$c413], a
    ld a, $04
    ld [$c412], a
    xor a
    ld [$c40e], a
    ld [$c40f], a
    ld hl, StageInitBlockPtrs
    ldh a, [$ff9f]
    rst $20
    ld de, $c414
    ld b, $4e
    jp jr_000_0362


StageCollisionAttrPtrs:: ; Bank4 collision attribute source windows selected by hStageIndex/$ff9f.
    dw Stage0CollisionAttrsWindow_Bank4
    dw Stage1CollisionAttrsWindow_Bank4
    dw Stage2CollisionAttrsWindow_Bank4
    dw Stage3CollisionAttrsWindow_Bank4
    dw Stage4CollisionAttrsWindow_Bank4

StageMetatileQuadPtrs:: ; Bank4 16x16 metatile quad tables selected by hStageIndex/$ff9f.
    dw Stage0MetatileQuads_Bank4
    dw Stage1MetatileQuads_Bank4
    dw Stage2MetatileQuads_Bank4
    dw Stage3MetatileQuads_Bank4
    dw Stage4MetatileQuads_Bank4

StageInitBlockPtrs:: ; Per-stage camera/layout init blocks copied to $c414.
    dw StageInitBlock_0_1_4
    dw StageInitBlock_0_1_4
    dw StageInitBlock_2
    dw StageInitBlock_3
    dw StageInitBlock_0_1_4

StageInitBlock_0_1_4::
    db $f8, $0d, $ff, $00, $60, $0d, $80, $00, $00, $01, $02, $03, $04, $05, $06, $07
    db $08, $09, $0a, $0b, $0c, $0d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00

StageInitBlock_2::
    db $00, $04, $00, $04, $60, $03, $80, $03, $0c, $0d, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $08, $09, $0a, $0b, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $05, $06, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $01, $02, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

StageInitBlock_3::
    db $f8, $09, $00, $05, $60, $09, $80, $04, $00, $00, $00, $10, $08, $09, $0a, $0b
    db $0c, $0d, $00, $00, $00, $00, $00, $00, $00, $10, $07, $10, $10, $10, $10, $10
    db $00, $00, $00, $00, $00, $00, $00, $10, $06, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $0e, $0e, $0e, $0f, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $02, $03, $04, $10, $00, $00, $00, $00, $00, $00, $00, $00

Call_001_417f::
    xor a
    ldh [hPlayerState], a
    ldh [hPlayerDirection], a
    ldh [hPlayerActionLock], a
    call Call_000_0dc0
    call Call_001_4047
    ld a, $8c
    ldh [hOamMaxY], a
    ld hl, wPaletteBGP
    ld a, $e4
    ld [hl+], a
    ld a, $d0
    ld [hl+], a
    ld a, $e4
    ld [hl+], a
    ld a, $e3
    ld [wLCDCShadow], a
    ld a, $01
    ld [$c0a0], a
    jp EnableInterruptsFromShadow


Call_001_41a9::
    ld a, $ff
    ld [wObjectSlots], a
    call UpdatePlayerJumpProfile
    ld a, $20
    ldh [hPlayerGravity], a
    ld hl, $00e0
    ld de, $0140
    ld a, [$dffd]
    or a
    jr z, jr_001_41c7

    ld hl, $01c0
    ld de, $0200

jr_001_41c7::
    ld a, l
    ld [$d996], a
    ld a, h
    ld [$d997], a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ld a, e
    ld [$d998], a
    ld a, d
    ld [$d999], a
    xor a
    ldh [hOamWritePos], a
    ldh [hVBlankBusy], a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    ldh [$ffc3], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [$ffbf], a
    ldh [hPlayerActionLock], a
    ldh [hPlayerAnimTimer], a
    ldh [$ffc1], a
    ld [$c0b0], a
    ldh [hCollisionFlag], a
    ldh [$ff97], a
    ldh [$ff98], a
    ld hl, $c0b1
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    inc hl
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [wStoredPlayerForm], a
    ret


Call_001_420f::
    call jr_001_4225
    ld a, [$c0a8]
    or a
    jr z, jr_001_4225

    ld hl, StageResumeLayoutPatchOffsets
    ldh a, [$ff9f]
    rst $20
    ld bc, $c800
    add hl, bc
    ld [hl], $05
    ret


jr_001_4225::
    ldh a, [$ff9f]
    cp $03
    jr z, jr_001_4250

    ld hl, StageLayoutRlePtrs
    ldh a, [$ff9f]
    rst $20
    ld de, $c800
    ld bc, $0e00
    ld a, $04
    jp BankedMemcpy_RLEFF


StageLayoutRlePtrs:: ; Bank4 RLEFF layout streams selected by hStageIndex/$ff9f.
    dw Stage0LayoutRle_Bank4
    dw Stage1LayoutRle_Bank4
    dw Stage2LayoutRle_Bank4
    dw Stage3LayoutRle_Bank4
    dw Stage4LayoutRle_Bank4

StageResumeLayoutPatchOffsets:: ; Offsets into $c800 patched to metatile $05 when resuming/after checkpoint.
    dw $0752
    dw $0772
    dw $056a
    dw $0841
    dw $0000

jr_001_4250::
    ld hl, Stage3LayoutRle_Bank4
    ld de, $c800
    ld bc, $1100
    ld a, $04
    jp BankedMemcpy_RLEFF


Call_001_425e::
    ld hl, $4001
    ld de, $8000
    ld bc, $0130
    ld a, $05
    call BankedMemcpy
    ld hl, $5701
    ld de, $8d00
    ld bc, $0300
    ld a, $05
    call BankedMemcpy
    call Call_001_42fd
    ld hl, $4286
    ldh a, [$ff9f]
    rst $20
    jp jr_000_06ea


    db $90, $42, $a6, $42, $bc, $42, $d9, $42

    reti


    ld b, d

    db $d1, $5a, $00, $87, $f0, $03, $05, $01, $5a, $00, $8b, $d0, $00, $05, $01, $40
    db $00, $90, $00, $08, $07, $ff, $c1, $5b, $00, $87, $00, $03, $05, $d1, $5e, $00
    db $8a, $a0, $02, $05, $e1, $46, $00, $90, $00, $08, $07, $ff, $61, $5d, $00, $87
    db $60, $01, $05, $d1, $5e, $60, $88, $e0, $01, $05, $71, $61, $40, $8a, $a0, $02
    db $05, $61, $53, $00, $90, $00, $08, $07, $ff, $c1, $5b, $00, $87, $a0, $01, $05
    db $d1, $5e, $a0, $88, $e0, $01, $05, $71, $61, $80, $8a, $c0, $01, $05, $e1, $64
    db $40, $8c, $80, $00, $05, $f1, $5a, $00, $90, $00, $08, $07, $ff

Call_001_42fd::
    ldh a, [hPlayerForm]
    rst $00

    ; Player form graphics loader table.
    dw LoadPlayerFormGfxNormal ; PLAYER_FORM_NORMAL
    dw LoadPlayerFormGfxFlyingSquirrel ; PLAYER_FORM_FLYING_SQUIRREL
    dw LoadPlayerFormGfxCockroach ; PLAYER_FORM_COCKROACH
    dw LoadPlayerFormGfxChicken ; PLAYER_FORM_CHICKEN
    dw LoadPlayerFormGfxActionKamen ; PLAYER_FORM_ACTION_KAMEN

LoadPlayerFormGfxNormal::
    ld hl, $4131
    ld de, $8130
    ld bc, $0470
    ld a, $05
    call BankedMemcpy
    ret


LoadPlayerFormGfxFlyingSquirrel::
    ld hl, $45a1
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call BankedMemcpy
    ret


LoadPlayerFormGfxCockroach::
    ld hl, $53a1
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call BankedMemcpy
    ret


LoadPlayerFormGfxChicken::
    ld hl, $4f41
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call BankedMemcpy
    ret


LoadPlayerFormGfxActionKamen::
    ld hl, $4ad1
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call BankedMemcpy
    ret


    db $18, $00, $f0, $00, $00, $00, $80, $00

    jr z, @+$09

    ld h, b
    nop
    ret c

    ld b, $10
    nop

    db $18, $00, $f0, $03, $00, $00, $80, $03

    xor b
    ld bc, $0270
    ld d, b
    ld bc, $0200

    db $18, $00, $f0, $04, $00, $00, $80, $04

    jr z, jr_001_4383

    ld d, b
    nop
    ret nc

    inc bc

jr_001_4383::
    nop
    nop
    jr jr_001_4387

jr_001_4387::
    ld b, b
    nop
    nop
    nop
    nop
    nop
    ld c, b
    dec b
    ldh a, [rP1]
    ldh a, [c]
    inc b
    add b
    nop

    db $55, $43

    ld a, a
    ld b, h

    db $65, $43, $75, $43

    add l
    ld b, e

    db $5d, $43

    or a
    ld b, h

    db $6d, $43, $7d, $43

    adc l
    ld b, e

jr_001_43a9::
    ld hl, $4395
    ldh a, [$ff9f]
    rst $20

jr_001_43af::
    ld a, [hl+]
    ldh [hPlayerX], a
    ld a, [hl+]
    ldh [hPlayerXHigh], a
    ld a, [hl+]
    ldh [hPlayerY], a
    ld a, [hl+]
    ldh [hPlayerYHigh], a
    ld a, [hl+]
    ldh [hSCX], a
    ld a, [hl+]
    ldh [hSCXHigh], a
    ld a, [hl+]
    ldh [hSCY], a
    ld a, [hl+]
    ldh [hSCYHigh], a
    ret


Call_001_43c8::
    ldh a, [$ff9f]
    cp $01
    jr z, jr_001_4408

    cp $02
    call z, Call_001_43e1
    ld hl, $439f
    ldh a, [$ff9f]
    rst $20
    ld a, [$c0a8]
    or a
    jr z, jr_001_43a9

    jr jr_001_43af

Call_001_43e1::
    ld a, [$c0a8]
    or a
    ret z

    ld hl, $3572
    ld de, $9450
    ld bc, $0390
    ld a, $04
    call BankedMemcpy
    ld hl, $6411
    ld de, $8c00
    ld bc, $00d0
    ld a, $05
    call BankedMemcpy
    ld a, $03
    ld [$c0b3], a
    ret


jr_001_4408::
    ld a, [$c0bc]
    or a
    jr nz, jr_001_4418

    ld a, [$c0a8]
    or a
    jr nz, jr_001_4475

    xor a
    ld [$c0b4], a

jr_001_4418::
    xor a
    ld [$c0bc], a
    ld hl, $447f
    ld a, [$c0b4]
    or a
    jr z, jr_001_443c

    ld hl, $448f
    dec a
    jr z, jr_001_443c

    ld hl, $4ee1
    ld de, $91a0
    ld bc, $0480
    ld a, $07
    call BankedMemcpy
    ld hl, $449f

jr_001_443c::
    ld a, [hl+]
    ld [$c40e], a
    ld a, [hl+]
    ld [$c40f], a
    ld a, [hl+]
    ld [$c418], a
    ld a, [hl+]
    ld [$c419], a
    ld a, [hl+]
    ld [$c410], a
    ld a, [hl+]
    ld [$c411], a
    ld a, [hl+]
    ld [$c414], a
    ld a, [hl+]
    ld [$c415], a
    ld a, [hl+]
    ldh [hPlayerX], a
    ld a, [hl+]
    ldh [hPlayerXHigh], a
    ld a, [hl+]
    ldh [hPlayerY], a
    ld a, [hl+]
    ldh [hPlayerYHigh], a
    ld a, [hl+]
    ldh [hSCX], a
    ld a, [hl+]
    ldh [hSCXHigh], a
    ld a, [hl+]
    ldh [hSCY], a
    ld a, [hl+]
    ldh [hSCYHigh], a
    ret


jr_001_4475::
    ld a, $01
    ld [$c0b4], a
    ld hl, $44af
    jr jr_001_443c

    db $00, $00, $60, $04, $08, $00, $00, $05, $18, $00, $70, $00, $00, $00, $18, $00
    db $00, $05, $60, $08, $08, $05, $00, $09, $18, $05, $c0, $00, $00, $05, $68, $00
    db $00, $09, $60, $0d, $08, $09, $f8, $0d, $18, $09, $f0, $00, $00, $09, $80, $00

    nop
    dec b
    ld h, b
    ld [$0508], sp
    nop
    add hl, bc
    jr z, @+$09

    add b
    nop
    db $d3
    ld b, $28
    nop

UpdateGameplayState:: ; Main gameplay frame update for hGameState=2.
    ldh a, [hJoyPressed]
    bit 3, a
    jr nz, jr_001_4532

    ld a, $ff
    ld [$c403], a
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
    jp nz, Jump_001_4516

    bit 2, a
    jp nz, Jump_001_44fe

    bit 1, a
    jp nz, Jump_000_0e6e

    bit 0, a
    jp nz, Jump_000_0e48

    ret


Jump_001_44fe::
    ld a, [wPendingVramUpdates]
    res 2, a
    ld [wPendingVramUpdates], a
    ld hl, $c404
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $452e
    ld bc, $0202
    call QueueTilemapRect
    ret


Jump_001_4516::
    ld a, [wPendingVramUpdates]
    res 3, a
    ld [wPendingVramUpdates], a
    ld hl, $c406
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $da00
    ld bc, $0202
    call QueueTilemapRect
    ret


    db $08, $09, $0a, $0b

jr_001_4532::
    ld a, $06
    ldh [hGameState], a
    ldh a, [hPrevOamPos]
    ldh [hOamWritePos], a
    xor a
    ld [$dd9f], a
    ld a, $5e
    call PlaySound_Queue1
    ret


jr_001_4544::
    ldh a, [hPlayerFlags]
    res 1, a
    ldh [hPlayerFlags], a
    ret


DrawPlayerSprite:: ; Draw player metasprite using hPlayerForm/hPlayerAnimId and screen position.
Call_001_454b:: ; Compatibility alias.
    ld hl, $c0ab
    ld a, [hl]
    or a
    jr z, jr_001_4558

    dec [hl]
    jr z, jr_001_4544

    bit 3, [hl]
    ret z

jr_001_4558::
    ldh a, [hPlayerDirection]
    and $01
    ld b, a
    ldh a, [$ffa9]
    and $fe
    or b
    ldh [$ffa9], a
    ldh [hSpriteFlags], a
    ld hl, $1a19
    ldh a, [hPlayerForm]
    rst $20
    ldh a, [hPlayerAnimId]
    rst $20
    ldh a, [hPlayerScreenX]
    ld c, a
    ldh a, [hPlayerScreenY]
    ld b, a
    jp jr_000_026c


UpdateSpecialActors:: ; Update short-lived gameplay actor slots/effects.
Call_001_4578:: ; Compatibility alias.
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
    jr z, jr_001_45a6

    jr c, jr_001_4599

    ret


jr_001_4599::
    ld a, [wStoredPlayerForm]
    ldh [hPlayerForm], a
    ld a, $04
    ld [wStoredPlayerForm], a
    jp EnterPlayerHurtState


jr_001_45a6::
    ld a, [wFormTimerLo]
    ld b, a
    and $0f
    ret z

    bit 4, b
    jp z, Jump_000_0e02

    ldh a, [hPlayerForm]
    push af
    xor a
    ldh [hPlayerForm], a
    call Jump_000_0e02
    pop af
    ldh [hPlayerForm], a
    ret


UpdatePlayerSpecialActor0:: ; Dispatch/update wPlayerSpecialActor0 by projectile type.
Call_001_45bf:: ; Compatibility alias.
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
Call_001_45cb:: ; Compatibility alias.
    ld a, [bc]
    or a
    ret z

    call AdvanceSpecialActorTimer
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_45f1

    call CheckSpecialActorTileCollision
    jr z, jr_001_45f1

    call SetSpecialActorHitbox4x4
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, $2e9b
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp jr_000_026c


jr_001_45f1::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    ret


AdvanceSpecialActorTimer:: ; Advance special actor Y/timer field before movement.
Call_001_45f9:: ; Compatibility alias.
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a

MoveSpecialActorX_0180:: ; Move a projectile horizontally at speed $0180.
Jump_001_4605:: ; Compatibility alias.
    ld de, $0180

MoveSpecialActorX:: ; Move a projectile horizontally by DE, honoring direction bit.
Jump_001_4608:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    bit 0, [hl]
    inc hl
    jp nz, jr_001_4bee

    jp Jump_001_4be3


CheckSpecialActorTileCollision:: ; Check projectile tile collision against the stage collision map.
Call_001_4614:: ; Compatibility alias.
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
    call Jump_000_0d36
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de
    ld b, c
    ld c, e
    call Call_001_4637
    pop bc
    ret


Call_001_4637::
    call CheckProjectileTilePassability
    jr c, jr_001_463f

    or $ff
    ret


jr_001_463f::
    xor a
    ret


SetSpecialActorHitbox4x4:: ; Store a 4x4 special actor hitbox at current projected screen position.
Call_001_4641:: ; Compatibility alias.
    ld a, $04
    ldh [hActionHitboxHalfWidth], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a
    ldh a, [$ffd3]
    ld [wPlayerActionHitbox1X], a
    ldh a, [$ffd4]
    ld [wPlayerActionHitbox1Y], a
    ret


UpdateFlyingSquirrelProjectile:: ; Special actor type 1: flying-squirrel projectile.
    call MoveSpecialActorX_0180
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_4677

    call CheckSpecialActorTileCollision
    jr z, jr_001_4677

    call SetChickenProjectileHitbox
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, $2e96
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp jr_000_026c


jr_001_4677::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    ret


SetChickenProjectileHitbox:: ; Set chicken projectile hitbox using common 4x4 screen position storage.
Call_001_467f:: ; Compatibility alias.
    jp SetProjectileHitbox4x4AtScreenPos


UpdateChickenProjectile:: ; Special actor type 2: chicken projectile.
    call UpdateChickenProjectileMotion
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_46a5

    call CheckSpecialActorTileCollision
    jr z, jr_001_46a5

    call SetProjectileHitbox4x4AtScreenPos
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, $30e2
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp jr_000_026c


jr_001_46a5::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    ret


UpdateChickenProjectileMotion:: ; Update chicken projectile motion; after startup it checks upcoming tiles.
Call_001_46ad:: ; Compatibility alias.
    ld hl, $c0c9
    ld a, [hl]
    cp $20
    jr nc, jr_001_46b9

    inc [hl]
    jp MoveSpecialActorX_0180


jr_001_46b9::
    call CheckChickenProjectileNextTile
    call nc, AdvanceChickenProjectileY
    jp MoveSpecialActorX_0180


AdvanceChickenProjectileY:: ; Advance chicken projectile Y position by one pixel/substep.
Call_001_46c2:: ; Compatibility alias.
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
Call_001_46cf:: ; Compatibility alias.
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
    call Jump_000_0d36
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de
    ld b, c
    ld c, e
    call CheckProjectileTilePassability
    pop bc
    ret


CheckProjectileTilePassability:: ; Dispatch tile-specific projectile passability logic.
Call_001_46f6:: ; Compatibility alias.
    and $3f
    rst $00

    ; rst $00 jump table (64 entries)
    dw jr_001_478a, label_001_478c, label_001_478e, label_001_4794
    dw jr_001_479a, jr_001_47a2, jr_001_478a, jr_001_479a
    dw jr_001_47a2, jr_001_478a, jr_001_479a, jr_001_478a
    dw label_001_47ae, label_001_47b4, jr_001_479a, jr_001_478a
    dw jr_001_478a, label_001_478c, label_001_478c, jr_001_478a
    dw label_001_478c, jr_001_479a, jr_001_478a, jr_001_479a
    dw jr_001_479a, jr_001_478a, jr_001_479a, label_001_4782
    dw jr_001_478a, jr_001_478a, label_001_4779, jr_001_478a
    dw label_001_478c, label_001_478c, label_001_478c, label_001_478c
    dw label_001_478c, jr_001_478a, jr_001_478a, jr_001_478a
    dw jr_001_478a, jr_001_478a, jr_001_478a, jr_001_478a
    dw jr_001_478a, jr_001_478a, jr_001_478a, jr_001_478a
    dw jr_001_478a, jr_001_478a, jr_001_478a, jr_001_478a
    dw jr_001_478a, jr_001_478a, jr_001_478a, jr_001_478a
    dw jr_001_478a, jr_001_478a, jr_001_478a, jr_001_478a
    dw jr_001_478a, jr_001_478a, jr_001_478a, jr_001_478a


label_001_4779::
    ld a, c
    and $0f
    cp $08
    ccf
    ret nc

    scf
    ret


label_001_4782::
    ld a, c
    and $0f
    cp $08
    ret nc

    scf
    ret


jr_001_478a::
    sub a
    ret


label_001_478c::
    scf
    ret


label_001_478e::
    bit 3, b
    jr z, jr_001_478a

    jr jr_001_479a

label_001_4794::
    bit 3, b
    jr nz, jr_001_478a

    jr jr_001_479a

jr_001_479a::
    ld a, c
    and $0f
    cp $04
    ret nc

    scf
    ret


jr_001_47a2::
    ld a, c
    and $0f
    cp $08
    jr c, jr_001_478a

    cp $0c
    ret nc

    scf
    ret


label_001_47ae::
    bit 3, b
    jr z, jr_001_478a

    jr jr_001_47a2

label_001_47b4::
    bit 3, b
    jr nz, jr_001_478a

    jr jr_001_47a2

SetProjectileHitbox4x4AtScreenPos:: ; Use $ffd3/$ffd4 as a 4x4 projectile hitbox position.
Jump_001_47ba:: ; Compatibility alias.
    ld a, $04
    ldh [hActionHitboxHalfWidth], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a

StoreProjectileHitboxAtScreenPos:: ; Store projected projectile hitbox position from $ffd3/$ffd4.
Jump_001_47c2:: ; Compatibility alias.
    ldh a, [$ffd3]
    ld [wPlayerActionHitbox0X], a
    ldh a, [$ffd4]
    ld [wPlayerActionHitbox0Y], a
    ret


UpdateActionKamenProjectile:: ; Special actor type 3: Action Kamen projectile.
    call MoveActionKamenProjectile
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_47f9

    call SetActionKamenProjectileHitbox8x8
    inc bc
    ld a, [bc]
    ldh [hSpriteFlags], a
    ld hl, $32d2
    ld a, [$c0c9]
    inc a
    ld [$c0c9], a
    bit 4, a
    jr nz, jr_001_47f0

    ld hl, $32e7

jr_001_47f0::
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp jr_000_026c


jr_001_47f9::
    xor a
    ld [bc], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    ret


SetActionKamenProjectileHitbox8x8:: ; Use $ffd3/$ffd4 as an 8x8 Action Kamen projectile hitbox.
Call_001_4801:: ; Compatibility alias.
    ld a, $08
    ldh [hActionHitboxHalfWidth], a
    ld a, $08
    ldh [hActionHitboxHalfHeight], a
    jp StoreProjectileHitboxAtScreenPos


MoveActionKamenProjectile:: ; Move Action Kamen projectile horizontally at speed $0300.
Call_001_480c:: ; Compatibility alias.
    ld de, $0300
    jp MoveSpecialActorX


UpdateObjectSlotByType:: ; Dispatch an object slot behavior by type.
Call_001_4812:: ; Compatibility alias.
    ld b, h
    ld c, l
    and OBJECT_TYPE_MASK
    rst $00

    ; Object behavior dispatch table. rst $00 consumes these words as data.
    dw UpdateObjNone00 ; 00: OBJ_NONE
    dw UpdateObjStageEvent01 ; 01: OBJ_STAGE_EVENT_TYPE_01
    dw UpdateObjStageEvent02 ; 02: OBJ_STAGE_EVENT_TYPE_02
    dw UpdateObjStageEvent03 ; 03: OBJ_STAGE_EVENT_TYPE_03
    dw UpdateObjStageEvent04 ; 04: OBJ_STAGE_EVENT_TYPE_04
    dw UpdateObjStageEvent05 ; 05: OBJ_STAGE_EVENT_TYPE_05
    dw UpdateObjStageEventChildA ; 06: OBJ_STAGE_EVENT_CHILD_A
    dw UpdateObjStageEvent07 ; 07: OBJ_STAGE_EVENT_TYPE_07
    dw UpdateObjStageEvent08 ; 08: OBJ_STAGE_EVENT_TYPE_08
    dw UpdateObjDropPlatformA ; 09: OBJ_PLATFORM_DROP_A_VARIANT
    dw UpdateObjEnemyWalkingKid ; 0a: OBJ_ENEMY_WALKING_KID
    dw UpdateObjEnemyPartyHornKid ; 0b: OBJ_ENEMY_PARTY_HORN_KID
    dw UpdateObjEnemyUmbrellaKid ; 0c: OBJ_ENEMY_UMBRELLA_KID
    dw UpdateObjEnemyPaperAirplaneKid ; 0d: OBJ_ENEMY_PAPER_AIRPLANE_KID
    dw UpdateObjEnemyPaperAirplane ; 0e: OBJ_ENEMY_PAPER_AIRPLANE
    dw UpdateObjEnemyProjectileB ; 0f: OBJ_ENEMY_PROJECTILE_B
    dw UpdateObjPickupBonusCounter ; 10: OBJ_PICKUP_BONUS_COUNTER
    dw UpdateObjPickupBonusCounterAnim ; 11: OBJ_PICKUP_BONUS_COUNTER_ANIM
    dw UpdateObjPickupExtraLife ; 12: OBJ_PICKUP_EXTRA_LIFE
    dw UpdateObjPickupExtraLifeAnim ; 13: OBJ_PICKUP_EXTRA_LIFE_ANIM
    dw UpdateObjPickupHealth ; 14: OBJ_PICKUP_HEALTH
    dw UpdateObjPickupHealthAnim ; 15: OBJ_PICKUP_HEALTH_ANIM
    dw UpdateObjFormFlyingSquirrel ; 16: OBJ_FORM_FLYING_SQUIRREL
    dw UpdateObjFormCockroach ; 17: OBJ_FORM_COCKROACH
    dw UpdateObjFormChicken ; 18: OBJ_FORM_CHICKEN
    dw UpdateObjFormActionKamen ; 19: OBJ_FORM_ACTION_KAMEN
    dw UpdateObjMovingPlatformVerticalA ; 1a: OBJ_PLATFORM_MOVING_VERTICAL_A
    dw UpdateObjMovingPlatformVerticalB ; 1b: OBJ_PLATFORM_MOVING_VERTICAL_B
    dw UpdateObjDropPlatformA ; 1c: OBJ_PLATFORM_DROP_A
    dw UpdateObjPlatformBouncePad ; 1d: OBJ_PLATFORM_BOUNCE_PAD
    dw UpdateObjDropPlatformB ; 1e: OBJ_PLATFORM_DROP_B
    dw UpdateObjStageEventType1F ; 1f: platform/event, pending
    dw UpdateObjStageEventType20 ; 20: platform/event, pending
    dw UpdateObjStageEvent21 ; 21: OBJ_STAGE_EVENT_TYPE_21 (UpdateObjStageEvent21)
    dw UpdateObjMovingPlatformHorizontal ; 22: OBJ_PLATFORM_MOVING_HORIZONTAL
    dw UpdateObjStageEvent23 ; 23: OBJ_STAGE_EVENT_TYPE_23
    dw UpdateObjStageEventChild24 ; 24: OBJ_STAGE_EVENT_CHILD_24
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
Call_001_4868:: ; Compatibility alias.
    ld a, [$c0b5]
    or a
    jr z, jr_001_4871

    call Call_001_4d25

jr_001_4871::
    xor a
    ldh [$ffc4], a
    ld hl, wObjectSlots

jr_001_4877::
    ld a, [hl]
    or a
    jr z, jr_001_4884

    cp OBJECT_LIST_END
    jr z, jr_001_488a

    push hl
    call UpdateObjectSlotByType
    pop hl

jr_001_4884::
    ld bc, OBJECT_SLOT_SIZE
    add hl, bc
    jr jr_001_4877

jr_001_488a::
    call TrySpawnNextObject
    call TrySpawnNextObject
    call TrySpawnNextObject
    jr TrySpawnNextObject

ResetSpawnCursor::
jr_001_4895:: ; Compatibility alias.
    xor a
    ld [wSpawnCursor], a
    ret


TrySpawnNextObject:: ; Try to spawn the next eligible stage object near the camera.
jr_001_489a:: ; Compatibility alias.
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
    ldh a, [$ff9f]
    rst $20
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a
    ld a, [hl+]
    ldh [$ffc9], a
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
    jr z, jr_001_48e5

    ld a, l
    cpl
    add $01
    ld l, a
    ld a, h
    cpl
    adc $00
    ld h, a

jr_001_48e5::
    ld a, h
    ld e, l
    pop hl
    or a
    ret nz

    ldh a, [$ffc9]
    cp $10
    jr c, jr_001_48f6

    ld a, e
    cp $70
    ret nc

    jr jr_001_48fe

jr_001_48f6::
    ld a, e
    cp $b0
    ret nc

    cp $60
    jr c, jr_001_4915

jr_001_48fe::
    ld hl, wSpawnStateList
    add hl, bc
    ld [hl], SPAWN_STATE_BLOCKED

FindFreeObjectSlot:: ; Find an empty object slot, extending the list if needed.
Jump_001_4904:: ; Compatibility alias.
    ld hl, wObjectSlots

jr_001_4907::
    ld a, [hl]
    or a
    jr z, SpawnObjectIntoSlot

    cp $ff
    jr z, jr_001_492e

    ld de, OBJECT_SLOT_SIZE
    add hl, de
    jr jr_001_4907

jr_001_4915::
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
    jr nz, jr_001_48fe

    ld a, l
    cp $a0
    jr nc, jr_001_48fe

    ret


jr_001_492e::
    call SpawnObjectIntoSlot
    ld a, OBJECT_LIST_END
    ld hl, OBJECT_SLOT_SIZE
    add hl, bc
    ld [hl], a
    ret


SpawnObjectIntoSlot:: ; Copy a 5-byte spawn record into the selected object slot.
jr_001_4939:: ; Compatibility alias.
    ld d, h
    ld e, l
    ld a, c
    ld hl, $000f
    add hl, de
    ld [hl], a
    ld b, d
    ld c, e
    ld hl, $ffc5
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
    ldh [$ffc9], a
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
Call_001_49d9:: ; Compatibility alias.
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
    ldh a, [$ffc9]
    srl a
    ld a, [bc]
    res 7, a
    jr nc, jr_001_49f5

    set 7, a

jr_001_49f5::
    ld [bc], a
    ret


InitSpawnedObjectAnimParamFromTable:: ; Initialize object animation params from low spawn bits.
    ld a, [bc]
    and $7f
    ld [bc], a
    ldh a, [$ffc9]
    and $07
    ld hl, $4a11
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


    db $30

    db $40, $48, $50

    ld e, b

    db $60

    ld l, b
    ld [hl], b

InitSpawnedObjectSpawnParamLowBits:: ; Store low 3 spawn parameter bits in object param A.
    ldh a, [$ffc9]
    and $07
    ld hl, $000a
    add hl, bc
    ld [hl], a
    ret


InitSpawnedObjectPlatformParamFromTable:: ; Initialize platform param from low spawn bits.
    ldh a, [$ffc9]
    and $07
    ld hl, $4a37
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


    db $30, $3c, $48

    ld d, h
    ld h, b

    db $aa

InitSpawnedObjectMotionBlockA:: ; Initialize motion params from block A.
    ld de, $4a42
    jr jr_001_4a71

    db $80, $00, $01

    ld bc, $00c0
    ld [bc], a
    ld [bc], a

InitSpawnedObjectMotionBlockB:: ; Initialize motion params from block B.
    ld de, $4a4f
    jr jr_001_4a71

    db $c0, $00, $01

    ld bc, $0120
    ld [bc], a
    ld [bc], a

InitSpawnedObjectMotionBlockC:: ; Initialize motion params from block C.
    ld de, $4a5c
    jr jr_001_4a71

    db $80, $00, $01

    ld bc, $00c0
    ld [bc], a
    ld [bc], a

InitSpawnedObjectMotionBlockD:: ; Initialize motion params from block D.
    ld de, $4a69
    jr jr_001_4a71

    db $00, $01, $02

    ld [bc], a
    add b
    ld bc, $0303

jr_001_4a71::
    ld a, [$dffe]
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
    ld a, [$dffe]
    or a
    jr z, jr_001_4a95

    ld l, $08

jr_001_4a95::
    ldh a, [$ffc9]
    and $07
    add l
    ld hl, $4aac
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


    db $18, $30, $50, $70, $80, $a0, $c0

    ldh a, [rNR10]
    jr nz, @+$36

    ld c, d
    ld d, h
    ld l, d
    add b
    and b

InitSpawnedObjectParamBlockA:: ; Initialize params from block A.
    ld de, $4ac1
    jr jr_001_4a71

    db $00, $01, $03

    inc bc
    add b
    ld bc, $0606

InitSpawnedObjectParamBlockB:: ; Initialize params from block B.
    ld de, $4ace
    jr jr_001_4a71

    db $00, $01, $04

    inc b
    add b
    ld bc, $0808

InitSpawnedObjectParamBlockC:: ; Initialize params from block C.
    ld de, $4adb
    jr jr_001_4a71

    db $c0, $00, $03

    inc bc
    ld b, b
    ld bc, $0505

InitSpawnedObjectParamBlockD:: ; Initialize params from block D and clear event substate.
    xor a
    ld [$c0ba], a
    ld de, $4aed
    jp jr_001_4a71


    db $80, $01, $05

    dec b
    nop
    ld [bc], a
    db $08
    db $08

InitObjectSpawnList:: ; Initialize object slots and per-stage spawn list state.
Call_001_4af5:: ; Compatibility alias.
    xor a
    ld [wSpawnCursor], a
    call InitSpawnStateList
    ld a, $ff
    ld hl, wObjectSlots
    ld b, $00
    call jr_000_0022
    jp jr_000_0022


InitSpawnStateList:: ; Initialize one-byte state entries for stage spawn records.
Call_001_4b09:: ; Compatibility alias.
    ld hl, StageSpawnListPtrs
    ldh a, [$ff9f]
    rst $20
    ld d, h
    ld e, l
    ld hl, wSpawnStateList

jr_001_4b14::
    ld a, [de]
    cp $ff
    jr z, jr_001_4b21

    ld a, $01
    ld [hl+], a
    ld a, SPAWN_RECORD_SIZE
    rst $30
    jr jr_001_4b14

jr_001_4b21::
    ld [hl], $ff
    ret


StageSpawnListPtrs::
    dw Stage0SpawnList
    dw Stage1SpawnList
    dw Stage2SpawnList
    dw Stage3SpawnList
    dw Stage4SpawnList

ProjectObjectToScreenAndCull:: ; Convert object world position to screen position and set offscreen flag.
Call_001_4b2e:: ; Compatibility alias.
    xor a
    ldh [$ffd5], a
    ldh a, [hSCXHigh]
    ld d, a
    ldh a, [hSCX]
    ld e, a
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    sub e
    ld e, a
    ldh [$ffd3], a
    ld a, [hl+]
    sbc d
    ldh [$ffc9], a
    call Call_001_4b6c
    ldh a, [hSCYHigh]
    ld d, a
    ldh a, [hSCY]
    ld e, a
    inc hl
    ld a, [hl+]
    sub e
    ld e, a
    ldh [$ffd4], a
    ld a, [hl+]
    sbc d
    ldh [$ffca], a
    jr c, jr_001_4b62

    or a
    jr nz, jr_001_4b7f

    ld a, e
    cp $a0
    jr nc, jr_001_4b7f

    ret


jr_001_4b62::
    cp $ff
    jr nz, jr_001_4b7f

    ld a, e
    cp $f0
    ret nc

    jr jr_001_4b7f

Call_001_4b6c::
    jr c, jr_001_4b77

    or a
    jr nz, jr_001_4b7f

    ld a, e
    cp $b8
    jr nc, jr_001_4b7f

    ret


jr_001_4b77::
    cp $ff
    jr nz, jr_001_4b7f

    ld a, e
    cp $f0
    ret nc

jr_001_4b7f::
    ld a, $ff
    ldh [$ffd5], a
    ret


CullObjectAndReleaseSpawn:: ; Despawn object when far offscreen and mark its spawn record ready again.
Call_001_4b84:: ; Compatibility alias.
    call ProjectObjectToScreenAndCull
    ldh a, [$ffc9]
    ld d, a
    ldh a, [$ffd3]
    ld e, a
    ld hl, $00a0
    add hl, de
    bit 7, h
    jr nz, jr_001_4bbd

    bit 7, d
    jr nz, jr_001_4ba1

    ld hl, $fec0
    add hl, de
    bit 7, h
    jr z, jr_001_4bbd

jr_001_4ba1::
    ldh a, [$ffca]
    ld d, a
    ldh a, [$ffd4]
    ld e, a
    ld hl, $0090
    add hl, de
    bit 7, h
    jr nz, jr_001_4bbd

    bit 7, d
    jr nz, jr_001_4bbb

    ld hl, $ff00
    add hl, de
    bit 7, h
    jr z, jr_001_4bbd

jr_001_4bbb::
    xor a
    ret


jr_001_4bbd::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl-]
    bit 7, a
    ret nz

    ld [hl], $00
    ld hl, $000f
    add hl, bc
    ld a, [hl]
    ld de, wSpawnStateList
    rst $30
    ld a, SPAWN_STATE_READY
    ld [de], a
    or a
    ret


MoveObjectXBySpeed:: ; Load object speed from +8/+9, then apply signed X movement.
Jump_001_4bd4:: ; Compatibility alias.
    ld hl, $0008
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $0002
    add hl, bc

ApplyObjectXVelocity:: ; Apply DE as signed fixed-point X velocity based on object facing flag.
Call_001_4bdf:: ; Compatibility alias.
    ld a, [bc]
    rlca
    jr c, jr_001_4bee

Jump_001_4be3::
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


jr_001_4bee::
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
Call_001_4bf9:: ; Compatibility alias.
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


Jump_001_4c06::
    ld hl, $1b25
    ldh a, [$ff9f]
    rst $20
    ldh a, [$ffd6]
    rst $20
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp jr_000_026c


Call_001_4c18::
    ldh a, [hPlayerState]
    cp $01
    jr z, jr_001_4c26

    ldh a, [hPlayerForm]
    cp $02
    jr z, jr_001_4c26

    jr jr_001_4c2b

jr_001_4c26::
    ld hl, $4c71
    jr jr_001_4c2e

jr_001_4c2b::
    ld hl, $4c44

jr_001_4c2e::
    ld a, d
    add a
    add a
    add d
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ldh [$ffcb], a
    ld a, [hl+]
    ldh [$ffcc], a
    ld a, [hl+]
    ldh [$ffcd], a
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a
    ret


    db $0e, $14, $0e, $0e, $15, $12, $14, $18, $18, $1d, $0e, $14, $16, $16, $1b, $0a
    db $14, $05, $04, $08, $0e, $14, $04, $fc, $ff, $0e, $14, $10, $08, $10, $12, $14
    db $16, $16, $1b, $0a, $14, $05, $fc, $ff, $14, $14, $1c, $1c, $22, $0e, $0e, $0e
    db $0e, $15, $12, $0e, $18, $18, $1d, $0e, $0e, $16, $16, $1b, $0a, $0e, $05, $04
    db $08, $0e, $0e, $04, $fc, $ff, $0e, $0e, $10, $08, $10

    ld [de], a
    ld c, $16
    ld d, $1b

    db $0a, $0e, $05, $fc, $ff

    inc d
    ld c, $1c
    inc e
    ld [hl+], a

Call_001_4c9e::
    ldh a, [$ffcb]
    ld l, a
    ldh a, [hPlayerScreenX]
    ld h, a
    ldh a, [$ffd3]
    sub h
    bit 7, a
    jr z, jr_001_4cad

    cpl
    inc a

jr_001_4cad::
    cp l
    ret nc

    ldh a, [hPlayerState]
    cp $02
    jr nz, jr_001_4cce

    ldh a, [hPlayerVelYHigh]
    rlca
    jr c, jr_001_4cce

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [$ffd4]
    sub h
    jr c, jr_001_4cdf

    cp e
    jr nc, jr_001_4cc7

    cp d
    ccf

jr_001_4cc7::
    jr nc, jr_001_4cd6

    call Call_001_4dbb
    scf
    ret


jr_001_4cce::
    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [$ffd4]
    sub h
    jr c, jr_001_4cdf

jr_001_4cd6::
    ld l, a
    ldh a, [$ffcd]
    ld h, a
    ld a, l
    cp h
    ret nc

    jr jr_001_4ce8

jr_001_4cdf::
    cpl
    inc a
    ld l, a
    ldh a, [$ffcc]
    ld h, a
    ld a, l
    cp h
    ret nc

jr_001_4ce8::
    call Call_001_4d7c
    sub a
    ret


Call_001_4ced::
    ldh a, [$ffd3]
    sub [hl]
    bit 7, a
    jr z, jr_001_4cf6

    cpl
    inc a

jr_001_4cf6::
    cp d
    ret nc

    inc hl
    ldh a, [$ffc9]
    sub [hl]
    bit 7, a
    jr z, jr_001_4d02

    cpl
    inc a

jr_001_4d02::
    cp e
    ret


jr_001_4d04::
    ldh a, [$ff9f]
    cp $03
    jr z, jr_001_4d14

    ld hl, hSCY
    ld a, [$c41a]
    cp [hl]
    ret z

    inc [hl]
    ret


jr_001_4d14::
    ld hl, hSCY
    ld a, [hl]
    cp $80
    ret z

    jr nc, jr_001_4d21

    inc [hl]
    jp Jump_000_0a69


jr_001_4d21::
    dec [hl]
    jp Jump_000_0a69


Call_001_4d25::
    dec a
    ld [$c0b5], a
    jr z, jr_001_4d51

    ld b, a
    ld a, $bd
    sub b
    ld b, a
    cp $60
    jr nc, jr_001_4d04

    ld a, $01
    ld [$c0b6], a
    ld hl, $4d49
    ldh a, [$ff9f]
    rst $20
    ld c, b
    ld a, $70
    add b
    ld e, a
    ld d, $05
    jp Jump_000_0522


    db $61, $65, $21, $68, $f1, $6a, $81, $6e

jr_001_4d51::
    ld hl, $4d60
    ldh a, [$ff9f]
    rst $20
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a
    jp FindFreeObjectSlot


    db $68, $4d, $6d, $4d, $72, $4d, $77, $4d, $01, $08, $0e, $f0, $00, $02, $08, $0e
    db $c0, $00, $03, $08, $02, $c0, $00, $04, $08, $0a, $f0, $00

Call_001_4d7c::
    ldh a, [hPlayerFlags]
    or a
    ret nz

    ldh a, [hPlayerForm]
    or a
    jp nz, Jump_001_4da4

    ldh a, [hPlayerHealth]
    or a
    jp z, EnterPlayerDeathFallState

    ld a, $51
    call PlaySound
    ldh a, [hPlayerState]
    ld [wSavedPlayerState], a
    ld a, $0a
    ldh [hPlayerState], a
    ld hl, $ffbe
    set 3, [hl]
    ld a, $1e
    ldh [hPlayerAnimTimer], a
    ret


Jump_001_4da4::
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    xor a
    ldh [hPlayerForm], a
    ld hl, $d996
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    jp EnterPlayerHurtState


Call_001_4dbb::
    ld a, $01
    ld [$c0b0], a
    ld a, $20
    ldh [hPlayerGravity], a
    jp Jump_001_5eae


EnterPlayerHurtState:: ; Enter hurt/knockback-style player state; clears action actors and starts recovery timer.
Jump_001_4dc7:: ; Compatibility alias.
    ld a, $06
    ldh [hPlayerState], a
    xor a
    ldh [$ffc1], a
    ldh [$ffa7], a
    ldh [$ffa8], a
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
    call nz, Call_000_0963
    ld hl, $d996
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ld hl, $ffbe
    res 2, [hl]
    ret


Call_001_4e05::
    ldh a, [$ffbf]
    ld b, a
    xor a
    ldh [$ffbf], a
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


Call_001_4e30::
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
Jump_001_4e48:: ; Compatibility alias.
    ldh a, [hPlayerDirection]
    or a
    jr nz, jr_001_4e79

    ld hl, $ffb0
    ldh a, [hPlayerSpeedX]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerSpeedXHigh]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [$c414]
    ld e, a
    ld a, [$c415]
    ld d, a
    call Call_000_0080
    ret c

    ld a, [$c0b6]
    cp $ff
    ret z

    ld a, [$c415]
    ldh [hPlayerXHigh], a
    ld a, [$c414]
    ldh [hPlayerX], a
    ret


jr_001_4e79::
    ld hl, $ffb0
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
    ld a, [$c410]
    ld e, a
    ld a, [$c411]
    ld d, a
    call Call_000_0080
    ret nc

    ld a, [$c411]
    ldh [hPlayerXHigh], a
    ld a, [$c410]
    ldh [hPlayerX], a
    ret


ApplyPlayerYVelocity:: ; Apply player vertical velocity to world Y.
Call_001_4ea3:: ; Compatibility alias.
    ldh a, [hPlayerVelYHigh]
    bit 7, a
    jr nz, jr_001_4ef0

    ld hl, $ffad
    ldh a, [hPlayerVelY]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerVelYHigh]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [$c0b6]
    or a
    ret nz

    ld a, [$c416]
    ld e, a
    ld a, [$c417]
    ld d, a
    call Call_000_0080
    ret c

    ldh a, [hPlayerState]
    cp $0b
    ret z

EnterPlayerDeathFallState:: ; Enter fall-out/death bounce state and reset form/audio.
Jump_001_4ece:: ; Compatibility alias.
    xor a
    ldh [hPlayerForm], a
    call InitSound
    ld a, $55
    call PlaySound_Queue3
    ld a, $0b
    ldh [hPlayerState], a
    ld hl, $ffbe
    set 3, [hl]
    ld hl, $fc00
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ld a, $ff
    ldh [$ffc3], a
    ret


jr_001_4ef0::
    ld hl, $ffad
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


UpdateStageAnimatedTiles:: ; Update stage animated tiles when VRAM queue has room.
Call_001_4f08:: ; Compatibility alias.
    ldh a, [$ff9f]
    rst $00

    ; Stage animated-tile dispatcher table.
    dw UpdateStageAnimatedTiles_Set0
    dw UpdateStageAnimatedTiles_Set1
    dw UpdateStageAnimatedTiles_NoneA
    dw UpdateStageAnimatedTiles_Set2

UpdateStageAnimatedTiles_Set0::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [$c0b1]
    ld hl, $4f2e
    rst $38
    ld a, [hl]
    call Call_001_4f46
    ld hl, $c0b1
    inc [hl]
    ld a, [hl]
    cp $18
    ret c

    ld [hl], $00
    ret


    db $01, $04, $00, $06, $01, $00, $00, $05, $02, $00, $00, $00, $02, $04, $00, $00
    db $03, $00, $00, $05, $03, $07, $00, $00

Call_001_4f46::
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw StageAnimSub4F46_None ; 00
    dw StageAnimSub4F46_01 ; 01
    dw StageAnimSub4F46_02 ; 02
    dw StageAnimSub4F46_03 ; 03
    dw StageAnimSub4F46_04 ; 04
    dw StageAnimSub4F46_05 ; 05
    dw StageAnimSub4F46_06 ; 06
    dw StageAnimSub4F46_07 ; 07

StageAnimSub4F46_None::
    ret


StageAnimSub4F46_01::
    ld c, $39
    ld e, c
    call jr_001_4f9c
    ld c, $3a
    ld e, c
    call jr_001_4f9c
    ld c, $3b
    ld e, c
    jr jr_001_4f9c

StageAnimSub4F46_02::
    ld c, $3a
    ld e, $39
    call jr_001_4f9c
    ld c, $3b
    ld e, $3a
    call jr_001_4f9c
    ld c, $39
    ld e, $3b
    jr jr_001_4f9c

StageAnimSub4F46_03::
    ld c, $3b
    ld e, $39
    call jr_001_4f9c
    ld c, $39
    ld e, $3a
    call jr_001_4f9c
    ld c, $3a
    ld e, $3b
    jr jr_001_4f9c

StageAnimSub4F46_04::
    ld c, $3c
    ld e, $3c
    call jr_001_4f9c
    ld c, $3d
    ld e, $3d

jr_001_4f9c::
    ld d, $07
    ld hl, $4001
    jp Jump_000_0532


StageAnimSub4F46_05::
    ld c, $3c
    ld e, $3d
    call jr_001_4f9c
    ld c, $3d
    ld e, $3c
    jr jr_001_4f9c

StageAnimSub4F46_06::
    ld c, $2e
    ld e, $2e
    call jr_001_4f9c
    ld c, $2f
    ld e, $2f
    jr jr_001_4f9c

StageAnimSub4F46_07::
    ld c, $2e
    ld e, $2f
    call jr_001_4f9c
    ld c, $2f
    ld e, $2e
    jr jr_001_4f9c

UpdateStageAnimatedTiles_Set1::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [$c0b4]
    or a
    ret nz

    ld a, [$c0b1]
    ld hl, $4feb
    rst $38
    ld a, [hl]
    call Call_001_500b
    ld hl, $c0b1
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret


    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Call_001_500b::
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw StageAnimSub500B_None ; 00
    dw StageAnimSub500B_01 ; 01
    dw StageAnimSub500B_02 ; 02

StageAnimSub500B_None::
    ret


StageAnimSub500B_01::
    ld c, $29
    ld e, c
    call Jump_001_502a
    ld c, $2a
    ld e, c
    jp Jump_001_502a


StageAnimSub500B_02::
    ld c, $29
    ld e, $2a
    call Jump_001_502a
    ld c, $2a
    ld e, $29

Jump_001_502a::
    ld d, $07
    ld hl, $46e1
    jp Jump_000_0532


UpdateStageAnimatedTiles_NoneA::
    ret


UpdateStageAnimatedTiles_Set2::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [$c0b4]
    or a
    ret nz

    ld a, [$c0b1]
    ld hl, $5053
    rst $38
    ld a, [hl]
    call Call_001_5073
    ld hl, $c0b1
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret


    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Call_001_5073::
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw StageAnimSub5073_None ; 00
    dw StageAnimSub5073_01 ; 01
    dw StageAnimSub5073_02 ; 02

StageAnimSub5073_None::
    ret


StageAnimSub5073_01::
    ld c, $5e
    ld e, c
    call Jump_001_5092
    ld c, $5f
    ld e, c
    jp Jump_001_5092


StageAnimSub5073_02::
    ld c, $5e
    ld e, $5f
    call Jump_001_5092
    ld c, $5f
    ld e, $5e

Jump_001_5092::
    ld d, $07
    ld hl, $5af1
    jp Jump_000_0532


Call_001_509a::
    bit 7, d
    jp z, Jump_000_0d36

    xor a
    ret


CheckPlayerHeadCollision:: ; Player upward/head collision check.
Jump_001_50a1:: ; Compatibility alias.
    xor a
    ldh [$ffcd], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_50f4
    ldh a, [$ffcd]
    cp $01
    jr nz, jr_001_50ec

    ldh a, [hPrevPlayerState]
    cp $03
    ret z

    ld a, $03
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [$ffc1], a
    ld [$c0b0], a
    ldh a, [hPlayerForm]
    cp $02
    jr nz, jr_001_50e0

    xor a
    ldh [hPlayerActionLock], a

jr_001_50e0::
    xor a
    ldh [$ffbf], a
    ldh a, [hPlayerX]
    and $f8
    or $08
    ldh [hPlayerX], a
    ret


jr_001_50ec::
    ldh a, [hPrevPlayerState]
    cp $03
    ret nz

    jp Jump_001_5e0b


Call_001_50f4::
    cp $06
    jr z, jr_001_510d

    cp $08
    jr z, jr_001_5112

    cp $09
    jr z, jr_001_511e

    cp $0a
    jr z, jr_001_5128

    cp $1c
    jr z, jr_001_5132

    cp $1d
    jr z, jr_001_5158

    ret


jr_001_510d::
    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5112::
    ldh a, [hPlayerY]
    and $0f
    cp $08
    ret nc

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_511e::
    ldh a, [hPlayerY]
    and $0f
    ret z

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5128::
    ldh a, [hPlayerY]
    and $0f
    ret z

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5132::
    ldh a, [hPlayerY]
    and $0f
    cp $03
    jr c, jr_001_513f

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_513f::
    ld a, $01
    ld [$c0b4], a

jr_001_5144::
    ld a, $40
    ld [$d95c], a
    ld a, $07
    ldh [hGameState], a
    ld a, $02
    ld [$c0a9], a
    ld a, $ff
    ld [$c0bc], a
    ret


jr_001_5158::
    ldh a, [hPlayerY]
    and $0f
    cp $0b
    jr nc, jr_001_5165

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5165::
    ld a, $02
    ld [$c0b4], a
    jr jr_001_5144

Call_001_516c::
    xor a
    ldh [$ffc0], a
    ld hl, $ffb1
    ld a, [hl+]
    add $07
    ld c, a
    ld a, [hl]
    adc $00
    ld b, a

Jump_001_517a::
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    dec de
    push de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de
    call Call_001_51b2
    ld e, PLAYER_COLLISION_HEIGHT_NORMAL
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, jr_001_519b

    ld e, PLAYER_COLLISION_HEIGHT_COCKROACH

jr_001_519b::
    ld hl, $ffae
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    push de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de

Call_001_51b2::
    and $3f
    add a
    ld hl, $51c2
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl


    db $22, $52, $23, $52, $22, $52, $22, $52, $22, $52, $22, $52, $22, $52, $22, $52

    ld [hl+], a
    ld d, d

    db $22, $52

    ld [hl+], a
    ld d, d

    db $22, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    inc hl
    ld d, d
    inc hl
    ld d, d

    db $22, $52, $23, $52

    ld [hl+], a
    ld d, d

    db $22, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    db $2d, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    db $28, $52, $32, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    db $22, $52, $22, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    ret


jr_001_5223::
    ld a, $ff
    ldh [$ffc0], a
    ret


    bit 3, e
    ret z

    jr jr_001_5223

    bit 3, e
    ret nz

    jr jr_001_5223

    ld a, [$c0a8]
    or a
    ret nz

    jp Jump_001_5434


Call_001_523a::
    xor a
    ldh [$ffc0], a
    ld hl, $ffb1
    ld a, [hl+]
    sub $08
    ld c, a
    ld a, [hl]
    sbc $00
    ld b, a
    jp Jump_001_517a


Call_001_524b::
    xor a
    ldh [$ffc0], a
    ldh [$ffcd], a
    ld e, $12
    jr jr_001_526c

CheckPlayerGroundCollision:: ; Player downward/ground collision check.
Jump_001_5254:: ; Compatibility alias.
    ldh a, [hPlayerY]
    sub $20
    ldh a, [hPlayerYHigh]
    sbc $00
    ret c

    xor a
    ldh [$ffc0], a
    ldh [$ffcd], a
    ld e, PLAYER_COLLISION_HEIGHT_NORMAL
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, jr_001_526c

    ld e, PLAYER_COLLISION_HEIGHT_COCKROACH

jr_001_526c::
    ld hl, $ffae
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    ld a, e
    ldh [$ffca], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    dec bc
    dec bc
    push de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_52cc
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    inc bc
    inc bc
    pop de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_52cc
    ldh a, [$ffcd]
    cp $02
    ret nz

    ldh a, [hPlayerState]
    cp $04
    ret z

    ld a, $04
    ldh [hPlayerState], a
    xor a
    ldh [$ffc1], a
    ldh [$ffa8], a
    ldh a, [hPlayerForm]
    cp $02
    jr nz, jr_001_52c3

    xor a
    ldh [hPlayerActionLock], a

jr_001_52c3::
    ldh a, [hPlayerY]
    and $f0
    or $08
    ldh [hPlayerY], a
    ret


Call_001_52cc::
    and $3f
    rst $00


    ; Ground tile collision / interaction dispatch table.
    dw GroundTileCollisionNone ; 00
    dw GroundTileSolidOrFallState ; 01
    dw GroundTileCollisionNone ; 02
    dw GroundTileCollisionNone ; 03
    dw GroundTileCollisionNone ; 04
    dw GroundTileCollisionNone ; 05
    dw GroundTileCollisionNone ; 06
    dw GroundTileSolidIfNearTop ; 07
    dw GroundTileCollisionNone ; 08
    dw GroundTileCollisionNone ; 09
    dw GroundTileCollisionNone ; 0a
    dw GroundTileSolidOnlyWhenSnapState ; 0b
    dw GroundTileCollisionNone ; 0c
    dw GroundTileCollisionNone ; 0d
    dw GroundTileSolidOnlyWhenSnapState ; 0e
    dw GroundTileCollisionNone ; 0f
    dw GroundTileCollisionNone ; 10
    dw GroundTileSolidOrFallState ; 11
    dw GroundTileSolidOrFallState ; 12
    dw GroundTileCollisionNone ; 13
    dw GroundTileSolidOrFallState ; 14
    dw GroundTileCollisionNone ; 15
    dw GroundTileSolidIfNearTop ; 16
    dw GroundTileCollisionNone ; 17
    dw GroundTileCollisionNone ; 18
    dw GroundTileCollisionNone ; 19
    dw GroundTileCollisionNone ; 1a
    dw GroundTileSlopeRightIfUpperHalf ; 1b
    dw GroundTileCollisionNone ; 1c
    dw GroundTileCollisionNone ; 1d
    dw GroundTileSlopeLeftIfLowerHalf ; 1e
    dw GroundTileCollisionNone ; 1f
    dw GroundTileCollisionNone ; 20
    dw GroundTileCollisionNone ; 21
    dw GroundTileCollisionNone ; 22
    dw GroundTileEnterStageInteraction03 ; 23
    dw GroundTileEnterStageInteraction01 ; 24
    dw GroundTileCollisionNone ; 25
    dw GroundTileCollisionNone ; 26
    dw GroundTileCollisionNone ; 27
    dw GroundTileCollisionNone ; 28
    dw GroundTileCollisionNone ; 29
    dw GroundTileCollisionNone ; 2a
    dw GroundTileCollisionNone ; 2b
    dw GroundTileCollisionNone ; 2c
    dw GroundTileCollisionNone ; 2d
    dw GroundTileCollisionNone ; 2e
    dw GroundTileCollisionNone ; 2f

GroundTileEnterStageInteraction03::
    ldh a, [hPlayerState]
    cp $0c
    ret z

    ld a, $0c
    ldh [hPlayerState], a
    ld a, $03
    ld [$c0b1], a
    ret

GroundTileEnterStageInteraction01::
    ldh a, [hPlayerState]
    cp $0c
    ret z

    ld a, $0c
    ldh [hPlayerState], a
    xor a
    ld [$c0b2], a
    inc a
    ld [$c0b1], a
    ret

GroundTileCollisionNone::
    ret

GroundTileSlopeLeftIfLowerHalf::
    ldh a, [$ffca]
    bit 3, a
    ret z

    jr GroundTileSolidOrFallState

GroundTileSlopeRightIfUpperHalf::
    ldh a, [$ffca]
    bit 3, a
    ret nz

GroundTileSolidOrFallState::
    ldh a, [hPlayerState]
    cp $03
    jp nz, EnterPlayerFallState

    ld a, $ff
    ldh [$ffc0], a
    ret

GroundTileSolidIfNearTop::
    ldh a, [hPlayerY]
    sub $18
    and $0f
    cp $04
    ret nc

    ld hl, $ffcd
    inc [hl]
    ret

GroundTileSolidOnlyWhenSnapState::
    ldh a, [hPlayerState]
    cp $03
    ret nz

    ld a, $ff
    ldh [$ffc0], a
    ret


Call_001_5381::
    xor a
    ldh [$ffcd], a
    ld [$c0aa], a
    ldh [$ffa9], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    dec bc
    dec bc
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_53be
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    inc bc
    inc bc
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]


Call_001_53be::
    and $3f
    rst $00


    ; Player tile collision / interaction dispatch table.
    dw PlayerTileContactSolid ; 00
    dw PlayerTileSnapToTileTopClearEffect ; 01
    dw PlayerTileSlopeContactLeft ; 02
    dw PlayerTileSlopeContactRight ; 03
    dw PlayerTileSetEffect1IfNearTop ; 04
    dw PlayerTileSetEffect2IfMiddle ; 05
    dw PlayerTileContactSolid ; 06
    dw PlayerTileSetEffect1IfNearTop ; 07
    dw PlayerTileSetEffect2IfMiddle ; 08
    dw PlayerTileContactSolid ; 09
    dw PlayerTileSetEffect1IfNearTop ; 0a
    dw PlayerTileContactSolid ; 0b
    dw PlayerTileEffect2LeftHalf ; 0c
    dw PlayerTileEffect2RightHalf ; 0d
    dw PlayerTileSetEffect1IfNearTop ; 0e
    dw PlayerTileSetEdgeFlagLeft ; 0f
    dw PlayerTileSetEdgeFlagRight ; 10
    dw PlayerTileSnapAndSetEdgeFlagRight ; 11
    dw PlayerTileSnapAndSetEdgeFlagLeft ; 12
    dw PlayerTileSetEdgeFlagSolid ; 13
    dw PlayerTileSnapAndSetEdgeFlag ; 14
    dw PlayerTileEffect1AndEdgeFlag ; 15
    dw PlayerTileContactSolid ; 16
    dw PlayerTileEffect1EdgeRight ; 17
    dw PlayerTileEffect1EdgeLeft ; 18
    dw PlayerTileContactSolid ; 19
    dw PlayerTileSpawnDropPlatform ; 1a
    dw PlayerTileSnapHighHalf ; 1b
    dw PlayerTileContactSolid ; 1c
    dw PlayerTileStageTransitionIfLow ; 1d
    dw PlayerTileSnapLowHalf ; 1e
    dw PlayerTileTriggerCollectibleBlock ; 1f
    dw PlayerTileBounceLaunch ; 20
    dw PlayerTileSnapToTileTop ; 21
    dw PlayerTileDeathIfDeepContact ; 22
    dw PlayerTileSnapToTileTopClearEffect ; 23
    dw PlayerTileSnapToTileTopClearEffect ; 24
    dw PlayerTileContactSolid ; 25
    dw PlayerTileContactSolid ; 26
    dw PlayerTileContactSolid ; 27
    dw PlayerTileContactSolid ; 28
    dw PlayerTileContactSolid ; 29
    dw PlayerTileContactSolid ; 2a
    dw PlayerTileContactSolid ; 2b
    dw PlayerTileContactSolid ; 2c
    dw PlayerTileContactSolid ; 2d
    dw PlayerTileContactSolid ; 2e
    dw PlayerTileContactSolid ; 2f

PlayerTileTriggerCollectibleBlock::
    ld a, [$c0a8]
    or a
    jp nz, PlayerTileContactSolid

    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call Jump_001_5434
    jp PlayerTileContactSolid


Jump_001_5434::
    push de
    call Call_001_509a
    ld [hl], $05
    pop de
    call Call_001_5458
    ld a, l
    ld [$c404], a
    ld a, h
    ld [$c405], a
    ld a, [wPendingVramUpdates]
    set 2, a
    ld [wPendingVramUpdates], a
    ld a, $ff
    ld [$c0a8], a
    ld a, $5b
    jp PlaySound


Call_001_5458::
    ld a, e
    jp Jump_001_55fc

PlayerTileSnapToTileTop::
    jp PlayerTileSnapToTileTopClearEffect

PlayerTileDeathIfDeepContact::
    ldh a, [$ffc3]
    cp $ff
    ret z

    ldh a, [hPlayerY]
    and $0f
    cp $08
    jr c, PlayerTileContactSolid

    jp EnterPlayerDeathFallState

PlayerTileBounceLaunch::
    ld a, $5c
    call PlaySound
    ld a, $10
    ldh [hPlayerGravity], a
    ld a, $02
    ldh [hPlayerState], a
    ld [$c0b0], a
    call PlayerTileSnapToTileTopClearEffect
    ld hl, $fc70
    jp jr_001_5e9d

PlayerTileStageTransitionIfLow::
    ldh a, [hPlayerY]
    and $0f
    cp $0b
    jp nc, jr_001_5165

PlayerTileContactSolid::
    ld hl, $ffcd
    inc [hl]
    ret

PlayerTileSnapLowHalf::
    ldh a, [hPlayerY]
    bit 3, a
    jr z, PlayerTileContactSolid

    ld a, $ff
    ld [$c0aa], a
    xor a
    ldh [$ffbf], a
    ldh a, [hPlayerY]
    and $f0
    or $08
    ldh [hPlayerY], a
    ret

PlayerTileSnapHighHalf::
    ldh a, [hPlayerY]
    bit 3, a
    jr nz, PlayerTileContactSolid

PlayerTileSnapToTileTopClearEffect::
    ld a, $ff
    ld [$c0aa], a
    xor a
    ldh [$ffbf], a
    ldh a, [hPlayerY]
    and $f0
    ldh [hPlayerY], a
    ret

PlayerTileSlopeContactLeft::
    bit 3, c
    jr z, PlayerTileContactSolid

    jr PlayerTileSetEffect1IfNearTop

PlayerTileSlopeContactRight::
    bit 3, c
    jr nz, PlayerTileContactSolid

    jr PlayerTileSetEffect1IfNearTop

PlayerTileSetEffect1IfNearTop::
    ldh a, [hPlayerY]
    and $0f
    cp $04
    jr nc, PlayerTileContactSolid

    ld a, $01
    ldh [$ffbf], a
    ret

PlayerTileSetEffect2IfMiddle::
    ldh a, [hPlayerY]
    and $0f
    cp $08
    jr c, PlayerTileContactSolid

    cp $0c
    jr nc, PlayerTileContactSolid

    ld a, $02
    ldh [$ffbf], a
    ret

PlayerTileEffect2LeftHalf::
    bit 3, c
    jr z, PlayerTileContactSolid

    jr PlayerTileSetEffect2IfMiddle

PlayerTileEffect2RightHalf::
    bit 3, c
    jr nz, PlayerTileContactSolid

    jr PlayerTileSetEffect2IfMiddle

PlayerTileSetEdgeFlagLeft::
    bit 3, c
    jr z, PlayerTileContactSolid

    ld hl, $ffa9
    set 1, [hl]
    jr PlayerTileContactSolid

PlayerTileSetEdgeFlagRight::
    bit 3, c
    jr nz, PlayerTileContactSolid

    ld hl, $ffa9
    set 1, [hl]
    jr PlayerTileContactSolid

PlayerTileSnapAndSetEdgeFlagRight::
    call PlayerTileSnapToTileTopClearEffect
    bit 3, c
    ret nz

    ld hl, $ffa9
    set 1, [hl]
    ret

PlayerTileSnapAndSetEdgeFlagLeft::
    call PlayerTileSnapToTileTopClearEffect
    bit 3, c
    ret z


    ld hl, $ffa9
    set 1, [hl]
    ret

PlayerTileSetEdgeFlagSolid::
    ld hl, $ffa9
    set 1, [hl]
    jp PlayerTileContactSolid

PlayerTileSnapAndSetEdgeFlag::
    ld hl, $ffa9
    set 1, [hl]
    jp PlayerTileSnapToTileTopClearEffect

PlayerTileEffect1AndEdgeFlag::
    ld hl, $ffa9
    set 1, [hl]
    jp PlayerTileSetEffect1IfNearTop

PlayerTileEffect1EdgeRight::
    call PlayerTileSetEffect1IfNearTop
    bit 3, c
    ret nz

    ld hl, $ffa9
    set 1, [hl]
    ret

PlayerTileEffect1EdgeLeft::
    call PlayerTileSetEffect1IfNearTop
    bit 3, c
    ret z

    ld hl, $ffa9
    set 1, [hl]
    ret

PlayerTileSpawnDropPlatform::
    ldh a, [hPlayerY]
    and $0f
    cp $04
    jp nc, PlayerTileContactSolid

    push bc
    call Call_001_55c0
    pop bc
    ld hl, wObjectSlots

jr_001_5567::
    ld a, [hl]
    or a
    jr z, jr_001_557b

    cp $ff
    jr z, jr_001_5575

    ld de, $0010
    add hl, de
    jr jr_001_5567

jr_001_5575::
    call jr_001_557b
    ld [hl], $ff
    ret


jr_001_557b::
    push hl
    ldh a, [$ff9f]
    cp $01
    ld a, $1c
    jr nz, jr_001_5586

    ld a, $1e

jr_001_5586::
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld a, c
    and $f0
    or $08
    ld [hl+], a
    ld a, b
    ld [hl+], a
    xor a
    ld [hl+], a
    ldh a, [hPlayerY]
    and $f0
    or $08
    ld [hl+], a
    ldh a, [hPlayerYHigh]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld a, $40
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $20
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    pop bc
    push hl
    ldh a, [$ff9f]
    cp $01
    jr z, jr_001_55bb

    call Call_001_7004
    pop hl
    ret


jr_001_55bb::
    call Call_001_7081
    pop hl
    ret


Call_001_55c0::
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call Call_001_509a
    ld [hl], $00
    call Call_001_55fa
    ldh a, [$ff9f]
    cp $01
    jr z, jr_001_55dc

    ld b, h
    ld c, l
    ld de, $0002
    jp QueueVramFill


jr_001_55dc::
    ld a, [wPendingVramUpdates]
    bit 3, a
    jr nz, jr_001_55f1

    set 3, a
    ld [wPendingVramUpdates], a
    ld a, l
    ld [$c406], a
    ld a, h
    ld [$c407], a
    ret


jr_001_55f1::
    ld de, $da00
    ld bc, $0202
    jp QueueTilemapRect


Call_001_55fa::
    ldh a, [hPlayerY]

Jump_001_55fc::
    and $f0
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld d, $98
    ld a, c
    and $f0
    rrca
    rrca
    rrca
    ld e, a
    add hl, de
    ret


UpdatePlayerState:: ; Dispatch current player state machine.
Call_001_560e:: ; Compatibility alias.
    ldh a, [hPlayerState]
    ldh [hPrevPlayerState], a
    rst $00

    ; hPlayerState dispatch table. rst $00 consumes these words as data.
    dw PlayerState_NormalGround          ; 00
    dw PlayerState_Duck                  ; 01
    dw PlayerState_JumpFall              ; 02
    dw PlayerState_GroundedSnap          ; 03
    dw PlayerState_GroundedActionCheck   ; 04: grounded/action check state
    dw PlayerState_ClimbOrVerticalMove   ; 05: climb/vertical move state
    dw PlayerState_HurtKnockback         ; 06
    dw PlayerState_FlyingSquirrelAction  ; 07
    dw PlayerState_ChickenAction         ; 08
    dw PlayerState_ActionKamenAction     ; 09
    dw PlayerState_DamageBounce          ; 0a: damage bounce state
    dw PlayerState_DeathFall             ; 0b
    dw PlayerState_StageInteraction0C    ; 0c: special/stage interaction state
    dw PlayerState_StageInteraction0D    ; 0d: special/stage interaction state

PlayerState_StageInteraction0C::
    ld hl, $fe00
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call Call_001_5c78
    ld a, [$c0b1]
    rst $00

	dw label_001_56db
	dw label_001_56a9
	dw label_001_5681
	dw label_001_5647

label_001_5647::
    xor a
    ld [$c0b1], a
    ld [$c0b2], a
    ld a, [$c0b3]
    cp $05
    ret nz

    ld hl, $01f8
    ld a, l
    ld [$c414], a
    ld a, h
    ld [$c415], a
    ld hl, $0160
    ld a, l
    ld [$c418], a
    ld a, h
    ld [$c419], a
    ld hl, Stage2MetatileQuadsAfterSwitch_Bank4
    ld a, l
    ldh [$ffa2], a
    ld a, h
    ldh [$ffa3], a
    ld hl, Stage2CollisionPatch_Bank4
    ld de, $c700
    ld bc, $0030
    ld a, $04
    jp BankedMemcpy

label_001_5681::
    call Call_001_569a
    ld a, [$c0b2]
    inc a
    ld [$c0b2], a
    cp $0d
    ret c

    ld a, [$c0b1]
    inc a
    ld [$c0b1], a
    xor a
    ld [$c0b2], a
    ret


Call_001_569a::
    ld hl, $6411
    ld a, [$c0b2]
    ld c, a
    add $c0
    ld e, a
    ld d, $05
    jp Jump_000_0522

label_001_56a9::
    call Call_001_56c2
    ld a, [$c0b2]
    inc a
    ld [$c0b2], a
    cp $3b
    ret c

    ld a, [$c0b1]
    inc a
    ld [$c0b1], a
    xor a
    ld [$c0b2], a
    ret


Call_001_56c2::
    ld hl, $3572
    ld a, [$c0b3]
    cp $02
    jr z, jr_001_56cf

    ld hl, $3902

jr_001_56cf::
    ld a, [$c0b2]
    ld c, a
    add $45
    ld e, a
    ld d, $00
    jp Jump_000_0532

label_001_56db::
    call Call_001_5707
    ld hl, hSCY
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    call Jump_000_0a69
    ld a, [$c0b2]
    inc a
    ld [$c0b2], a
    cp $80
    ret c

    ld a, $ff
    ld [$c0b0], a
    ld a, $02
    ldh [hPlayerState], a
    ld a, [$c0b3]
    inc a
    ld [$c0b3], a
    ret


Call_001_5707::
    ld a, [$c0b2]
    cp $20
    ret nc

    ld hl, $ffae
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    ret


PlayerState_DamageBounce::
    call Call_001_5381
    ld a, $15
    ldh [hPlayerAnimId], a
    ld hl, $ffbd
    dec [hl]
    ld a, [hl]
    cp $16
    jr z, jr_001_573a

    or a
    ret nz

    ld a, $80
    ld [$c0ab], a
    ld hl, $ffbe
    res 3, [hl]
    set 1, [hl]
    jp Jump_001_5e0b


jr_001_573a::
    call Call_000_0eeb
    ld hl, $ffb0
    ld de, $0200
    ldh a, [hPlayerDirection]
    or a
    jp z, jr_001_4bee

    jp Jump_001_4be3



PlayerState_DeathFall:: ; State 0b: fall-out/death bounce, life decrement, and reset/game-over transition.
    ld hl, $ffb3
    ld a, [hl]
    add $14
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jr nz, jr_001_5764

    cp $04
    jr c, jr_001_5764

    ld a, $04
    ld [hl-], a
    ld [hl], $00

jr_001_5764::
    call ApplyPlayerYVelocity
    ld hl, $57b9
    ldh a, [hPlayerForm]
    rst $38
    ld a, [hl]

jr_001_576e::
    ldh [hPlayerAnimId], a
    ld a, $ff
    ldh [hCollisionFlag], a
    ld hl, $ffae
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
    ret c

    ldh a, [hPlayerScreenY]
    cp $b0
    ret c

    cp $f0
    ret nc

    xor a
    ldh [hPlayerForm], a
    xor a
    ldh [hPlayerFlags], a
    xor a
    ldh [hPlayerHealth], a
    ld hl, hPlayerLives
    ld a, [hl]
    or a
    jr z, @+$21

    dec [hl]
    call Jump_000_0e8c
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld a, $01
    ld [$c0a9], a
    ld a, [$c0a8]
    or a
    ret z

    ld a, $02
    ld [$c0a9], a
    ret


    dec d
    add hl, de
    dec e
    add hl, de
    jr jr_001_576e

    ld [$c0a9], a
    ld a, $04
    ldh [hGameState], a
    ld a, $01
    ld [$d93d], a
    ldh [hNeedsReset], a
    ret


PlayerState_StageInteraction0D::
    call HandlePlayerGroundInput
    ldh a, [$ffc4]
    or a
    call z, EnterPlayerFallState
    jr jr_001_57f7

Call_001_57d9::
    ldh a, [hPlayerForm]
    cp $02
    jr nz, jr_001_57e2

    xor a
    ldh [hPlayerActionLock], a

jr_001_57e2::
    ld a, $0d
    ldh [hPlayerState], a
    xor a
    ldh [$ffc1], a
    ldh [$ffa8], a
    ldh a, [hPlayerForm]
    cp $02
    ret z

    xor a
    ldh [hPlayerActionLock], a
    ret


PlayerState_GroundedActionCheck::
    call Call_001_5812

jr_001_57f7::
    ldh a, [$ffc1]
    or a
    ret z

    ld h, $0a
    ld l, $04
    ld e, $00
    call Call_001_5b7f
    ld hl, $580e
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


    db $12, $13, $12, $14

Call_001_5812::
    call CheckPlayerGroundCollision
    ldh a, [$ffcd]
    cp $02
    jp nz, EnterPlayerFallState

HandlePlayerGroundInput:: ; Handle normal ground input and transition to jump/crouch/move.
Call_001_581c:: ; Compatibility alias.
    ldh a, [hJoyPressed]
    rrca
    jp c, Jump_001_5e78

    ldh a, [hJoyHeld]
    or a
    jr z, jr_001_5834

    bit 4, a
    jr nz, jr_001_583c

    bit 5, a
    jr nz, jr_001_5846

    bit 7, a
    jp nz, EnterPlayerFallState

jr_001_5834::
    xor a
    ldh [$ffc1], a
    ld a, $12
    ldh [hPlayerAnimId], a
    ret


jr_001_583c::
    ld a, $01
    ldh [$ffc1], a
    xor a
    ldh [hPlayerDirection], a
    jp ApplyPlayerXVelocity


jr_001_5846::
    ld a, $01
    ldh [$ffc1], a
    ld a, $ff
    ldh [hPlayerDirection], a
    jp ApplyPlayerXVelocity


PlayerState_ClimbOrVerticalMove::
    ld hl, $ffbe
    set 0, [hl]
    ld h, $08
    ld l, $09
    ld e, $00
    call Call_001_5b7f
    ld hl, $586d
    ldh a, [$ffa8]
    cp $08
    jr nc, @+$10

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


    ld [$0a09], sp
    dec bc
    ld [$0a09], sp
    dec bc
    ld [$bef0], sp
    res 0, a
    ldh [hPlayerFlags], a
    jp Jump_001_5e0b



PlayerState_Duck:: ; State 01: down/duck pose and related transitions.
    call Jump_001_5afe
    ldh a, [hJoyHeld]
    cp $80
    jr z, jr_001_58d9

    ld a, $0c
    ldh [hPlayerAnimId], a
    ldh a, [hJoyHeld]
    bit 7, a
    jp z, Jump_001_5e0b

    bit 0, a
    jr nz, jr_001_58ae

    bit 5, a
    jr nz, jr_001_58a0

    bit 4, a
    jr nz, jr_001_58a8

    ret


jr_001_58a0::
    ld a, $ff
    ldh [hPlayerDirection], a
    xor a
    ldh [hPlayerAnimTimer], a
    ret


jr_001_58a8::
    xor a
    ldh [hPlayerDirection], a
    ldh [hPlayerAnimTimer], a
    ret


jr_001_58ae::
    call Call_001_5381
    ld a, [$c0aa]
    or a
    ret nz

    ld hl, $0100
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ApplyPlayerYVelocity
    call ApplyPlayerYVelocity
    call ApplyPlayerYVelocity
    call ApplyPlayerYVelocity
    ldh a, [hPlayerState]
    cp $0b
    ret z

    ld a, $02
    ldh [hPlayerState], a
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret


jr_001_58d9::
    call Call_001_58f5
    ld a, $0c
    ldh [hPlayerAnimId], a
    ldh a, [hPlayerForm]
    or a
    ret nz

    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    cp $80
    ret c

    ld a, $80
    ldh [hPlayerAnimTimer], a
    ld a, $0d
    ldh [hPlayerAnimId], a
    ret


Call_001_58f5::
    ld hl, $0100
    call Call_001_4e30
    call CheckPlayerHeadCollision
    ld hl, $ff00
    call Call_001_4e30
    ldh a, [hPlayerState]
    cp $03
    ret nz

    ld hl, $0100
    call Call_001_4e30
    pop af
    ret



PlayerState_GroundedSnap:: ; State 03: grounded snap/settle state after specific collision contact.
    call Call_001_5935
    ldh a, [$ffc1]
    rst $00

	dw label_001_591b
	dw label_001_5920

label_001_591b::
    ld a, $10
    ldh [hPlayerAnimId], a
    ret

label_001_5920::
    ld h, $0a
    ld l, $02
    ld e, $00
    call Call_001_5b7f
    ld hl, $5933
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


    db $10, $11

Call_001_5935::
    ldh a, [hJoyHeld]
    bit 6, a
    jr nz, jr_001_594c

    bit 7, a
    jr nz, jr_001_5965

    ldh a, [hJoyPressed]
    bit 0, a
    jp nz, StartPlayerJump

    xor a
    ldh [$ffc1], a
    jp CheckPlayerHeadCollision


jr_001_594c::
    ld a, $01
    ldh [$ffc1], a
    ld hl, $ff00
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call Call_001_524b
    ldh a, [$ffc0]
    or a
    call z, ApplyPlayerYVelocity
    jp CheckPlayerHeadCollision


jr_001_5965::
    ld a, $01
    ldh [$ffc1], a
    ld hl, $0100
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ApplyPlayerYVelocity
    jp CheckPlayerHeadCollision


UsePlayerFormAction:: ; Dispatch B-button ability for current hPlayerForm.
Jump_001_5978:: ; Compatibility alias.
    ldh a, [hPlayerActionLock]
    or a
    ret nz

    ldh a, [hPlayerForm]
    or a
    ret z

    cp PLAYER_FORM_FLYING_SQUIRREL
    jp z, StartFlyingSquirrelAction

    cp PLAYER_FORM_ACTION_KAMEN
    jp z, StartActionKamenAction

    cp PLAYER_FORM_CHICKEN
    jp z, StartChickenAction

    ; PLAYER_FORM_COCKROACH: start the form action in-place using hPlayerActionLock.
    ld a, $4e
    call PlaySound
    ld hl, wFormActionStep
    xor a
    ld [hl+], a
    ld [hl], a
    ld [wPlayerSpecialActor0], a
    ldh [$ffa8], a
    ldh [$ffa7], a
    inc a
    ldh [hPlayerActionLock], a
    ret


StartChickenAction:: ; Begin mother-hen form action; enters player state 08.
Jump_001_59a5:: ; Compatibility alias.
    ld de, $0a08
    jr StartTimedPlayerFormAction

PlayerState_ChickenAction:: ; State 08: mother-hen form action.
    call Call_001_5381
    ld e, $05
    call UpdatePlayerFormActionAnim
    ld hl, $ffbd
    dec [hl]
    ret nz

    ld a, $4f
    call PlaySound
    ld a, [wSavedPlayerState]
    ldh [hPlayerState], a
    ld a, SPECIAL_ACTOR_CHICKEN_PROJECTILE
    call InitPlayerSpecialActor
    ld b, $0a
    ld a, [wSavedPlayerState]
    or a
    jr nz, jr_001_59d0

    ld b, $04

jr_001_59d0::
    ld a, b
    call CalcSpecialActorY
    call StoreSpecialActorPos
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, [wSavedPlayerState]
    or a
    ret nz

    ld a, $20
    ld [$c0c9], a
    ret


StartFlyingSquirrelAction:: ; Begin flying-squirrel form action; enters player state 07.
Jump_001_59e7:: ; Compatibility alias.
    ld de, $0e07

StartTimedPlayerFormAction:: ; Save current state, set action timer/state, and clear form action work vars.
jr_001_59ea:: ; Compatibility alias.
    ldh a, [hPlayerState]
    ld [wSavedPlayerState], a
    ld a, d
    ldh [hPlayerAnimTimer], a
    ld a, e
    ldh [hPlayerState], a
    ld hl, wFormActionStep
    xor a
    ld [hl+], a
    ld [hl], a
    ret


UpdateFlyingSquirrelActionAnim::
Call_001_59fc:: ; Compatibility alias.
    ld e, $07

UpdatePlayerFormActionAnim:: ; Advance form-action animation once timer passes threshold E.
Call_001_59fe:: ; Compatibility alias.
    ld hl, wFormActionStep
    ld a, [hl]
    or a
    jr z, jr_001_5a14

    ldh a, [hPlayerAnimTimer]
    cp e
    ret nc

    inc hl
    ld a, [hl]
    or a
    ret nz

    inc [hl]
    ldh a, [hPlayerAnimId]
    inc a
    ldh [hPlayerAnimId], a
    ret


jr_001_5a14::
    inc [hl]
    ld a, $17
    ldh [hPlayerAnimId], a
    ld a, [wSavedPlayerState]
    or a
    ret z

    ld a, $15
    ldh [hPlayerAnimId], a
    ret


PlayerState_FlyingSquirrelAction:: ; State 07: flying-squirrel form action.
    call Call_001_5381
    call UpdateFlyingSquirrelActionAnim
    ld hl, $ffbd
    dec [hl]
    ret nz

    ld a, $4c
    call PlaySound
    ld a, [wSavedPlayerState]
    ldh [hPlayerState], a
    ld a, $03
    ldh [hPlayerActionLock], a
    ld hl, wPlayerSpecialActor0
    call InitPlayerSpecialActorAtHL
    ld hl, wPlayerSpecialActor1

InitPlayerSpecialActorAtHL:: ; Initialize a flying-squirrel projectile actor at HL.
Call_001_5a45:: ; Compatibility alias.
    ld a, SPECIAL_ACTOR_FLYING_SQUIRREL_PROJECTILE
    ld [hl+], a
    ldh a, [hPlayerDirection]
    and $01
    ld [hl+], a
    ld a, $0a
    call CalcSpecialActorX
    call StoreSpecialActorPos
    ld a, $0a
    call CalcSpecialActorY
    call StoreSpecialActorPos
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ret


CalcSpecialActorX:: ; BC = player X +/- A based on hPlayerDirection.
Call_001_5a63:: ; Compatibility alias.
    ld c, a
    ldh a, [hPlayerDirection]
    or a
    jr nz, jr_001_5a73

    ldh a, [hPlayerX]
    add c
    ld c, a
    ldh a, [hPlayerXHigh]
    adc $00
    ld b, a
    ret


jr_001_5a73::
    ldh a, [hPlayerX]
    sub c
    ld c, a
    ldh a, [hPlayerXHigh]
    sbc $00
    ld b, a
    ret


CalcSpecialActorY:: ; BC = player Y - A.
Call_001_5a7d:: ; Compatibility alias.
    ld c, a
    ldh a, [hPlayerY]
    sub c
    ld c, a
    ldh a, [hPlayerYHigh]
    sbc $00
    ld b, a
    ret


StartActionKamenAction:: ; Begin Action Kamen form action; only allowed from normal ground state.
Jump_001_5a88:: ; Compatibility alias.
    ldh a, [hPlayerState]
    or a
    ret nz

    ld de, $0009
    jp StartTimedPlayerFormAction


UpdateActionKamenActionAnim:: ; Select Action Kamen action animation by hPlayerAnimTimer.
Call_001_5a92:: ; Compatibility alias.
    ldh a, [hPlayerAnimTimer]
    cp $0a
    jr c, jr_001_5aa3

    cp $14
    jr z, jr_001_5ac1

    jr nc, jr_001_5aa8

    ld a, $16
    ldh [hPlayerAnimId], a
    ret


jr_001_5aa3::
    ld a, $15
    ldh [hPlayerAnimId], a
    ret


jr_001_5aa8::
    ld a, $17
    ldh [hPlayerAnimId], a
    ret


PlayerState_ActionKamenAction:: ; State 09: Action Kamen projectile/action sequence.
    call Call_001_5381
    call UpdateActionKamenActionAnim
    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    cp $32
    ret c

    ld a, [wSavedPlayerState]
    ldh [hPlayerState], a
    ret


SpawnActionKamenProjectile:: ; Spawn the Action Kamen projectile on animation frame $14.
jr_001_5ac1:: ; Compatibility alias.
    ld a, $50
    call PlaySound
    ld a, SPECIAL_ACTOR_ACTION_KAMEN_PROJECTILE
    call InitPlayerSpecialActor
    ld hl, wPlayerSpecialActor0
    ld a, SPECIAL_ACTOR_ACTION_KAMEN_PROJECTILE
    ld [hl+], a
    ldh a, [hPlayerDirection]
    and $01
    ld [hl+], a
    ld a, $0a
    call CalcSpecialActorX
    call StoreSpecialActorPos
    ld a, $06
    call CalcSpecialActorY

StoreSpecialActorPos:: ; Store BC as a 16-bit position field in the current special actor struct.
jr_001_5ae3:: ; Compatibility alias.
    xor a
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, b
    ld [hl+], a
    ret


InitPlayerSpecialActor:: ; Initialize wPlayerSpecialActor0 and set hPlayerActionLock.
Call_001_5aea:: ; Compatibility alias.
    ld hl, wPlayerSpecialActor0
    ld [hl+], a
    ldh a, [hPlayerDirection]
    and $01
    ld [hl+], a
    ld a, $01
    ldh [hPlayerActionLock], a
    ld a, $0a
    call CalcSpecialActorX
    jr StoreSpecialActorPos

Jump_001_5afe::
    call Call_001_5381
    ldh a, [$ffcd]
    cp $02
    ret nz

EnterPlayerFallState:: ; Switch to airborne/falling state when no ground is supporting the player.
Jump_001_5b06:: ; Compatibility alias.
    ldh a, [$ffc4]
    or a
    ret nz

    ld a, $20
    ldh [hPlayerGravity], a
    ld a, $02
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret



PlayerState_NormalGround:: ; State 00: normal grounded player control.
    call Call_001_4e05
    call HandleGroundInput
    ldh a, [hPlayerState]
    or a
    ret nz

    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, jr_001_5b31

    ldh a, [hPlayerActionLock]
    or a
    jr nz, jr_001_5b3a

jr_001_5b31::
    ldh a, [$ffc1]
    rst $00

	dw label_001_5b63
	dw label_001_5b68
	dw label_001_5b9c

jr_001_5b3a::
    ldh a, [$ffc1]
    or a
    jr nz, jr_001_5b51

    ld hl, $5b4b
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a
    jp Jump_001_5cd3


    db $15, $16, $16, $16, $15, $15

jr_001_5b51::
    ld hl, $5b5d
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a
    jp Jump_001_5cd3


    db $15, $16, $16, $17, $15, $1b

label_001_5b63::
    ld a, $04
    ldh [hPlayerAnimId], a
    ret

label_001_5b68::
    ld h, $0a
    ld l, $04
    ld e, $00
    call Call_001_5b7f
    ld hl, $5b7b
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


    db $04, $05, $04, $06

Call_001_5b7f::
    ldh a, [$ffa7]
    inc a
    ldh [$ffa7], a
    cp h
    jr c, jr_001_5b98

    xor a
    ldh [$ffa7], a
    ldh a, [$ffa8]
    inc a
    ldh [$ffa8], a

jr_001_5b8f::
    cp e
    jr c, jr_001_5b94

    cp l
    ret c

jr_001_5b94::
    ld a, e
    ldh [$ffa8], a
    ret


jr_001_5b98::
    ldh a, [$ffa8]
    jr jr_001_5b8f

label_001_5b9c::
    ld h, $0a
    ld l, $05
    ld e, $00
    call Call_001_5b7f
    ld hl, $5bbb
    ldh a, [$ffa8]
    cp $04
    jr nc, jr_001_5bb3

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


jr_001_5bb3::
    xor a
    ldh [$ffc1], a
    ldh [$ffa8], a
    ldh [hPlayerAnimTimer], a
    ret


    db $04, $07, $04

    rlca
    inc b

HandleGroundInput:: ; Ground input router: duck, jump, form action, horizontal movement, idle timer.
Call_001_5bc0:: ; Compatibility alias.
    ldh a, [hJoyHeld]
    bit 7, a
    jr nz, jr_001_5c1a

    ldh a, [hJoyPressed]
    rrca
    jr c, jr_001_5c17

    rrca
    jp c, UsePlayerFormAction

jr_001_5bcf::
    ldh a, [hJoyHeld]
    or a
    jr z, jr_001_5be0

    bit 4, a
    jr nz, jr_001_5c35

    bit 5, a
    jr nz, jr_001_5c59

    bit 6, a
    jr nz, jr_001_5bfb

jr_001_5be0::
    call Jump_001_5afe
    xor a
    ldh [$ffc1], a
    ldh a, [hPlayerForm]
    or a
    ret nz

    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    cp $80
    ret c

    ld a, $80
    ldh [hPlayerAnimTimer], a
    ld a, $02
    ldh [$ffc1], a
    ret


jr_001_5bfb::
    ld hl, $ff00
    call Call_001_4e30
    call CheckPlayerHeadCollision
    ld hl, $0100
    call Call_001_4e30
    ldh a, [hPlayerState]
    cp $03
    jr nz, jr_001_5be0

    ld hl, $ff00
    call Call_001_4e30
    ret


jr_001_5c17::
    jp StartPlayerJump


jr_001_5c1a::
    ldh a, [hPlayerForm]
    cp $02
    jr z, jr_001_5c2a

    ld a, $01
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerAnimTimer], a
    ldh [$ffc1], a
    ret


jr_001_5c2a::
    call Call_001_58f5
    ldh a, [hJoyHeld]
    rrca
    jp c, jr_001_58ae

    jr jr_001_5bcf

jr_001_5c35::
    xor a
    ldh [hPlayerAnimTimer], a
    ld a, $01
    ldh [$ffc1], a
    xor a
    ldh [hPlayerDirection], a
    ld a, [$c0b6]
    cp $ff
    jr nz, jr_001_5c4d

    ldh a, [hPlayerScreenX]
    cp $9c
    jp nc, ApplyPlayerXVelocity

jr_001_5c4d::
    call Call_001_516c
    ldh a, [$ffc0]
    or a
    call z, ApplyPlayerXVelocity
    jp Jump_001_5afe


jr_001_5c59::
    xor a
    ldh [hPlayerAnimTimer], a
    ld a, $01
    ldh [$ffc1], a
    ld a, $ff
    ldh [hPlayerDirection], a
    call Call_001_523a
    ldh a, [$ffc0]
    or a
    call z, ApplyPlayerXVelocity
    jp Jump_001_5afe



PlayerState_JumpFall:: ; State 02: airborne control, gravity, and landing checks.
    call UpdateAirbornePlayerInput
    ldh a, [hPlayerState]
    cp $02
    ret nz

UpdateAirbornePlayerAnimByForm:: ; Select airborne player animation and form-specific air behavior.
Call_001_5c78:: ; Compatibility alias.
    ldh a, [hPlayerForm]
    rst $00

	dw label_001_5c85
	dw label_001_5c92
	dw label_001_5cc5
	dw label_001_5cb0
	dw label_001_5c85

label_001_5c85::
    ld a, $0e
    ldh [hPlayerAnimId], a
    ldh a, [hPlayerVelYHigh]
    rlca
    ret c

    ld a, $0f
    ldh [hPlayerAnimId], a
    ret

label_001_5c92::
    ldh a, [hPlayerState]
    cp $02
    call z, UpdateFlyingSquirrelGlide
    ldh a, [hPlayerVelYHigh]
    rlca
    jr nc, jr_001_5ca3

    ld a, $0e
    ldh [hPlayerAnimId], a
    ret


jr_001_5ca3::
    ld hl, $c0b0
    bit 7, [hl]
    ret nz

    set 7, [hl]
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret

label_001_5cb0::
    ld h, $0a
    ld l, $02
    ld e, $00
    call Call_001_5b7f
    ld hl, $5cc3
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


    db $0e, $0f

label_001_5cc5::
    ldh a, [hPlayerActionLock]
    or a
    jr z, label_001_5cb0

    ld hl, $5d71
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a

UpdateCockroachActionHitbox:: ; Update cockroach action hitbox position while hPlayerActionLock is active.
Jump_001_5cd3:: ; Compatibility alias.
    call UpdatePlayerActionAnimStep
    ldh a, [hPlayerScreenY]
    sub $0c
    ld [wPlayerActionHitbox0Y], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a
    ld de, $1606
    ld a, [wFormActionStep]
    cp $01
    jr nz, jr_001_5cee

    ld de, $1c0c

jr_001_5cee::
    ld a, e
    ldh [hActionHitboxHalfWidth], a
    ldh a, [hPlayerDirection]
    or a
    jr nz, jr_001_5cfd

    ldh a, [hPlayerScreenX]
    add d
    ld [wPlayerActionHitbox0X], a
    ret


jr_001_5cfd::
    ldh a, [hPlayerScreenX]
    sub d
    ld [wPlayerActionHitbox0X], a
    ret


UpdatePlayerActionAnimStep:: ; Advance multi-step player form action animation.
Call_001_5d04:: ; Compatibility alias.
    ld a, [wFormActionStep]
    rst $00

    ; rst $00 jump table (3 entries)
    dw label_001_5d0e, label_001_5d2f, label_001_5d50


label_001_5d0e::
    ld h, $08
    ld l, $03
    ld e, $00
    call Call_001_5b7f
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ld hl, wFormActionTimer
    inc [hl]
    ld a, [hl]
    cp $10
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ret


label_001_5d2f::
    ld h, $08
    ld l, $04
    ld e, $02
    call Call_001_5b7f
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ld hl, wFormActionTimer
    inc [hl]
    ld a, [hl]
    cp $b4
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ret


label_001_5d50::
    ld h, $08
    ld l, $06
    ld e, $04
    call Call_001_5b7f
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ld hl, wFormActionTimer
    inc [hl]
    ld a, [hl]
    cp $78
    ret c

    xor a
    ldh [hPlayerActionLock], a
    ret


    db $18, $19, $19, $1a, $18, $1c

UpdateAirbornePlayerInput:: ; Handle airborne B action, horizontal control, gravity, and landing checks.
Call_001_5d77:: ; Compatibility alias.
    ldh a, [hJoyPressed]
    bit 1, a
    jp nz, UsePlayerFormAction

    ldh a, [hJoyHeld]
    rrca
    call nc, Call_001_5d96
    ldh a, [hJoyHeld]
    bit 6, a
    jr nz, jr_001_5db6

jr_001_5d8a::
    ldh a, [hJoyHeld]
    bit 4, a
    jr nz, jr_001_5dc0

    bit 5, a
    jr nz, jr_001_5dd0

    jr jr_001_5ddf

LimitUpwardVelocityOnARelease:: ; When A is released during upward motion, clamp upward velocity.
Call_001_5d96:: ; Compatibility alias.
    ld a, [$c0b0]
    or a
    ret nz

    ldh a, [hPlayerVelYHigh]
    rlca
    ret nc

    ld hl, $ffb3
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0100
    add hl, de
    bit 7, h
    ret z

    ld hl, $ff00
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ret


jr_001_5db6::
    call CheckPlayerHeadCollision
    ldh a, [hPlayerState]
    cp $03
    jr nz, jr_001_5d8a

    ret


jr_001_5dc0::
    xor a
    ldh [hPlayerDirection], a
    call Call_001_516c
    ldh a, [$ffc0]
    or a
    jr nz, jr_001_5ddf

    call ApplyPlayerXVelocity
    jr jr_001_5ddf

jr_001_5dd0::
    ld a, $ff
    ldh [hPlayerDirection], a
    call Call_001_523a
    ldh a, [$ffc0]
    or a
    jr nz, jr_001_5ddf

    call ApplyPlayerXVelocity

jr_001_5ddf::
    ldh a, [hPlayerGravity]
    ld b, a
    ld hl, $ffb3
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jp nz, Jump_001_5e72

    cp $04
    jr c, jr_001_5dfa

    ld a, $04
    ld [hl-], a
    ld [hl], $00

jr_001_5dfa::
    call ApplyPlayerYVelocity
    call Call_001_5381
    ld hl, $ffaa
    ld a, [hl+]
    cp [hl]
    ret nz

    ldh a, [$ffcd]
    cp $02
    ret z

Jump_001_5e0b::
    call Call_001_4e05

ResetPlayerToNormalState:: ; Clear motion/action state and return to normal ground state.
Jump_001_5e0e:: ; Compatibility alias.
    xor a
    ldh [hPlayerState], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [hPlayerAnimTimer], a
    ldh [$ffc1], a
    ldh [$ffa8], a
    ld [wPlayerActionMeter], a
    ld [$c0b0], a

UpdatePlayerJumpProfile:: ; Select jump profile. Chicken Shin-chan uses a stronger jump profile.
Call_001_5e21:: ; Compatibility alias.
    ld a, PLAYER_JUMP_PROFILE_NORMAL
    ldh [hPlayerJumpProfile], a
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_CHICKEN
    ret nz

    ld a, PLAYER_JUMP_PROFILE_CHICKEN
    ldh [hPlayerJumpProfile], a
    ret


UpdateFlyingSquirrelGlide:: ; Flying squirrel: repeated A presses build glide meter and briefly cancel gravity/Y velocity.
Call_001_5e2f:: ; Compatibility alias.
    ldh a, [hJoyPressed]
    rrca
    jr nc, jr_001_5e5e

    ld a, $4b
    call PlaySound
    ldh a, [hPlayerAnimId]
    cp $0e
    jr nz, jr_001_5e42

    inc a
    jr jr_001_5e44

jr_001_5e42::
    ld a, $0e

jr_001_5e44::
    ldh [hPlayerAnimId], a
    ld hl, wPlayerActionMeter
    ld a, [hl]
    add $1e
    cp $3d
    jr c, jr_001_5e52

    ld a, $3c

jr_001_5e52::
    ld [hl], a
    cp $1f
    ret c

jr_001_5e56::
    xor a
    ldh [hPlayerGravity], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ret


jr_001_5e5e::
    ldh a, [hPlayerVelYHigh]
    rlca
    ret c

    ld a, $20
    ldh [hPlayerGravity], a
    ld hl, wPlayerActionMeter
    ld a, [hl]
    or a
    ret z

    dec [hl]
    cp $37
    jr nc, jr_001_5e56

    ret


Jump_001_5e72::
    call ApplyPlayerYVelocity
    jp CheckPlayerGroundCollision


StartPlayerJump:: ; Enter jump state and initialize upward velocity/sound.
Jump_001_5e78:: ; Compatibility alias.
    ld a, $02
    ldh [hPlayerState], a
    ld a, $42
    call PlaySound
    ld a, $20
    ldh [hPlayerGravity], a
    ldh a, [hPlayerJumpProfile]
    and $07
    rst $00

    ; rst $00 jump table (8 entries)
    dw SetPlayerJumpVelocity, label_001_5ea4, label_001_5ea9, Jump_001_5eae
    dw label_001_5eb3, label_001_5eb8, label_001_5ebd, label_001_5ec2


SetPlayerJumpVelocity:: ; Jump velocity table targets write initial signed Y velocity.
Call_001_5e9a:: ; Compatibility alias.
    ld hl, $0000

jr_001_5e9d::
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ret


label_001_5ea4::
    ld hl, $ff00
    jr jr_001_5e9d

label_001_5ea9::
    ld hl, $fe00
    jr jr_001_5e9d

Jump_001_5eae::
    ld hl, $fd00
    jr jr_001_5e9d

label_001_5eb3::
    ld hl, $fc70
    jr jr_001_5e9d

label_001_5eb8::
    ld hl, $fc00
    jr jr_001_5e9d

label_001_5ebd::
    ld hl, $fb80
    jr jr_001_5e9d

label_001_5ec2::
    ld hl, $fb00
    jr jr_001_5e9d


PlayerState_HurtKnockback:: ; State 06: recovery/knockback-style animation state.
    ldh a, [$ffc1]
    or a
    jr z, jr_001_5f1f

    ld h, $0c
    ld l, $03
    ld e, $00
    call Call_001_5b7f
    ld hl, $5ef1
    ldh a, [$ffa8]
    cp $02
    jr z, jr_001_5ef4

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    cp $03
    ret nz

    ld a, $04
    ldh [hPlayerAnimId], a
    call DrawPlayerSprite
    ld a, $03
    ldh [hPlayerAnimId], a
    ret


    ld [bc], a

    db $03

    inc bc

jr_001_5ef4::
    ld a, $04
    ldh [hPlayerAnimId], a
    call Jump_000_0e02
    ld a, $80
    ld [$c0ab], a
    ld hl, $ffbe
    set 1, [hl]
    res 4, [hl]
    call Jump_001_5e0b
    ldh a, [hPlayerForm]
    cp $04
    ret nz

    call Call_000_0963
    ld hl, $d998
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ret


jr_001_5f1f::
    call Call_001_5f40
    ldh a, [$ffa7]
    cp $01
    ld a, $48
    call z, PlaySound
    ld h, $0c
    ld l, $02
    ld e, $00
    call Call_001_5b7f
    ld hl, $5f3e
    ldh a, [$ffa8]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


    db $00, $01

Call_001_5f40::
    call Call_001_5f4d
    rst $28
    cp $54
    ret c

    ldh a, [$ffc1]
    inc a
    ldh [$ffc1], a
    ret


Call_001_5f4d::
    ld hl, $5f68
    ldh a, [hPlayerForm]
    rst $20
    ldh a, [hPlayerAnimTimer]
    bit 7, a
    jr nz, jr_001_5f62

    ld c, a
    add $13
    ld e, a
    ld d, $05
    call Jump_000_0522

jr_001_5f62::
    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    ret


    db $31, $41, $a1, $45, $a1, $53, $41, $4f, $d1, $4a

UpdateObjPickupBonusCounter:: ; Object type $10: add hBonusCounter by 1; 30 awards an extra life.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jp nz, jr_001_4bbd

    call CheckPlayerPickupBonusCounter

jr_001_5f7f::
    ld hl, $2c85
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupBonusCounter::
Call_001_5f8b:: ; Compatibility alias.
    ld e, $0a
    ld d, $11
    call Call_001_5f9e
    ret nc

    ld a, $45
    call PlaySound
    xor a
    ld [bc], a
    inc a
    jp AddBonusCounter


CheckPlayerPickupOverlap::
Call_001_5f9e:: ; Compatibility alias.
    ldh a, [$ffc3]
    cp $ff
    ret z

    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp e
    ret nc

    ldh a, [$ffd4]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub $0c
    sub h
    rst $28
    cp d
    ret


UpdateObjPickupBonusCounterAnim:: ; Object type $11: animated bonus-counter pickup.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_5fda

    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jp nz, jr_001_4bbd

    ld e, $0a
    ld d, $11
    call Call_001_5f9e
    ret nc

    ld a, $44
    call PlaySound
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


jr_001_5fda::
    call Call_001_5fe6
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    ret nz

    jr jr_001_5f7f

FinishAnimatedBonusCounterPickup::
Call_001_5fe6:: ; Compatibility alias.
    call UpdateAnimatedPickupMotion
    ret c

    xor a
    ld [bc], a
    inc a
    jp AddBonusCounter


UpdateAnimatedPickupMotion::
Call_001_5ff0:: ; Compatibility alias.
    ld hl, $0005
    add hl, bc
    ld de, $0100
    call jr_001_4bee
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
    ld hl, $6022
    rst $38
    ld a, [hl]
    or a
    jr z, jr_001_601e

    rlca
    jr c, jr_001_6016

    inc de
    jr jr_001_6017

jr_001_6016::
    dec de

jr_001_6017::
    ld hl, $0003
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d

jr_001_601e::
    pop af
    cp $20
    ret


    db $01, $01, $01, $00, $00, $00, $00, $00, $ff, $00, $00, $00, $01, $00, $00, $00
    db $ff, $00, $00, $00, $01, $00, $00, $00, $ff, $00, $00, $00, $01, $00, $00, $00
UpdateObjPickupExtraLife:: ; Object type $12: immediate extra-life pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jp nz, jr_001_4bbd

    call CheckPlayerPickupExtraLife

jr_001_604f::
    ld hl, $2c9f
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupExtraLife::
Call_001_605b:: ; Compatibility alias.
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    xor a
    ld [bc], a
    jp AddExtraLife


UpdateObjPickupExtraLifeAnim:: ; Object type $13: animated extra-life pickup.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_608b

    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jp nz, jr_001_4bbd

    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $44
    call PlaySound
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


jr_001_608b::
    call Call_001_6097
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    ret nz

    jr jr_001_604f

FinishAnimatedExtraLifePickup::
Call_001_6097:: ; Compatibility alias.
    call UpdateAnimatedPickupMotion
    ret c

    xor a
    ld [bc], a
    jp AddExtraLife


UpdateObjPickupHealth:: ; Object type $14: add hPlayerHealth by 1, max 3.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call CheckPlayerPickupHealth

jr_001_60ab::
    ld hl, $2c8e
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupHealth::
Call_001_60b7:: ; Compatibility alias.
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call PlaySound
    xor a
    ld [bc], a
    inc a
    jp AddPlayerHealth


UpdateObjPickupHealthAnim:: ; Object type $15: animated health pickup.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_60ed

    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jp nz, jr_001_4bbd

    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $44
    call PlaySound
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


jr_001_60ed::
    call Call_001_60f9
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    ret nz

    jr jr_001_60ab

FinishAnimatedHealthPickup::
Call_001_60f9:: ; Compatibility alias.
    call UpdateAnimatedPickupMotion
    ret c

    xor a
    ld [bc], a
    inc a
    jp AddPlayerHealth


UpdateObjFormFlyingSquirrel:: ; Object type $16: Flying Squirrel form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call CheckPlayerPickupFormFlyingSquirrel
    ld hl, $2c41
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupFormFlyingSquirrel::
Call_001_611a:: ; Compatibility alias.
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call PlaySound
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, $ffbe
    res 2, [hl]
    ld a, PLAYER_FORM_FLYING_SQUIRREL
    ldh [hPlayerForm], a

jr_001_6135::
    xor a
    ld [bc], a
    jp EnterPlayerHurtState


UpdateObjFormCockroach:: ; Object type $17: Cockroach form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call CheckPlayerPickupFormCockroach
    ld hl, $2c74
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupFormCockroach::
Call_001_6151:: ; Compatibility alias.
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call PlaySound
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, $ffbe
    res 2, [hl]
    ld a, PLAYER_FORM_COCKROACH
    ldh [hPlayerForm], a
    jr jr_001_6135

UpdateObjFormChicken:: ; Object type $18: Chicken form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call CheckPlayerPickupFormChicken
    ld hl, $2c63
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupFormChicken::
Call_001_6185:: ; Compatibility alias.
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call PlaySound
    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, $ffbe
    res 2, [hl]
    ld a, PLAYER_FORM_CHICKEN
    ldh [hPlayerForm], a
    jp jr_001_6135


UpdateObjFormActionKamen:: ; Object type $19: timed Action Kamen form pickup.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call CheckPlayerPickupFormActionKamen
    ld hl, $2c52
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


CheckPlayerPickupFormActionKamen::
Call_001_61ba:: ; Compatibility alias.
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ldh a, [hPlayerForm]
    ld [wStoredPlayerForm], a
    ld hl, $ffbe
    set 2, [hl]
    ld a, PLAYER_FORM_ACTION_KAMEN
    ldh [hPlayerForm], a
    ld hl, jr_000_0600
    ld a, l
    ld [wFormTimerLo], a
    ld a, h
    ld [wFormTimerHi], a
    jp jr_001_6135


UpdateObjStageEventChildA:: ; Object type $06: stage/event child actor with enemy-like collision.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    ld a, [bc]
    or $80
    ld [bc], a
    call Call_001_61f6
    call Call_001_6273
    call Call_001_6279
    jp Jump_001_4c06


UpdateStageEventChildAState::
Call_001_61f6:: ; Compatibility alias.
    xor a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_6206, label_001_6242, label_001_6242, label_001_6252


label_001_6206::
    ld a, $13
    ldh [$ffd6], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    ld a, [hl]
    cp $08
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    ld de, $fd60
    ld hl, $000a
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ldh a, [$ffd3]
    ld hl, $ffa5
    sub [hl]
    rst $28
    cp $40
    ret nc

    ld de, $00b0
    ld a, [$dffe]
    or a
    jr z, jr_001_623a

    ld de, $0100

jr_001_623a::
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


label_001_6242::
    pop af
    ld a, $12
    ldh [$ffd6], a
    ld hl, $0008
    add hl, bc
    xor a
    ld [hl+], a
    ld [hl], $01
    jp Jump_001_6311


label_001_6252::
    ld a, $12
    ldh [$ffd6], a
    call MoveObjectXBySpeed
    ld hl, $000a
    call Call_001_6323
    ld hl, $000a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $fd80
    add hl, de
    ld a, h
    or l
    ret nz

    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


CheckStageEventChildAActionHitbox::
Call_001_6273:: ; Compatibility alias.
    ld de, $0408
    jp CheckPlayerActionHitboxCollision


CheckStageEventChildABodyCollision::
Call_001_6279:: ; Compatibility alias.
    ld d, $05
    jp CheckPlayerBodyCollision


UpdateObjEnemyWalkingKid:: ; Object type $0a: walking kid enemy.
UpdateObjEnemyWalkerA:: ; Compatibility alias from pass 11.
    call Call_001_6292
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call CheckPlayerActionHitboxCollision_Default
    call Call_001_63a8
    jp Jump_001_4c06


UpdateEnemyWalkerAState::
Call_001_6292:: ; Compatibility alias.
    call Call_001_629e
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_62af, label_001_62e6, label_001_630c, label_001_630c


GetObjectStateAndDirectionFlags::
Call_001_629e:: ; Compatibility alias.
    xor a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    ld a, [hl+]
    rlca
    jr nc, jr_001_62ab

    ld a, $01
    ldh [hSpriteFlags], a

jr_001_62ab::
    ld a, [hl]
    and $03
    ret


label_001_62af::
    ld hl, $62e2
    call Jump_001_62cb
    call MoveObjectXBySpeed

Jump_001_62b8::
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld d, h
    ld e, l
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor $80
    ld [bc], a
    ret


AnimateObjectFromTableFast::
Jump_001_62cb:: ; Compatibility alias.
    ld d, $08

Call_001_62cd::
    push hl
    ld hl, $000c
    add hl, bc
    ld e, $04
    call AdvanceObjectAnimCounter
    ld hl, $000b
    add hl, bc
    ld a, [hl]
    pop hl
    rst $38
    ld a, [hl]
    ldh [$ffd6], a
    ret


    db $00, $01, $00, $02

label_001_62e6::
    pop af
    ld a, $03
    ldh [$ffd6], a

UpdateObjectThrownStateA::
Jump_001_62eb:: ; Compatibility alias.
    call Call_001_62f8
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    ret nz

    jp Jump_001_4c06


UpdateObjectThrownStateATimer::
Call_001_62f8:: ; Compatibility alias.
    ld hl, $0002
    add hl, bc
    dec [hl]
    ret nz

    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ld hl, $000e
    add hl, bc
    bit 6, [hl]
    jp nz, Jump_001_6444

    ret


label_001_630c::
    pop af
    ld a, $03
    ldh [$ffd6], a

UpdateObjectThrownStateB::
Jump_001_6311:: ; Compatibility alias.
    call Call_001_6320
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jp z, Jump_001_4c06

    xor a
    ld [bc], a
    ret


AccelerateObjectY::
Call_001_6320:: ; Compatibility alias.
    ld hl, $0008

AccelerateObjectYAtHL::
Call_001_6323:: ; Compatibility alias.
    add hl, bc
    ld a, [hl]
    add $20
    ld e, a
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld d, a
    ld [hl], a

ApplyObjectYVelocity::
Call_001_632e:: ; Compatibility alias.
    ld hl, $0005
    add hl, bc
    bit 7, d
    jp z, Jump_001_4be3

    ld a, e
    add [hl]
    ld [hl+], a
    ld a, d
    adc [hl]
    ld [hl+], a
    ld a, [hl]
    adc $ff
    ld [hl], a
    ret


CheckPlayerActionHitboxCollision_Default::
Call_001_6342:: ; Compatibility alias.
    ld de, $040c

CheckPlayerActionHitboxCollision:: ; Check active player form/projectile hitboxes against current object.
Jump_001_6345:: ; Compatibility alias.
    ldh a, [hPlayerActionLock]
    or a
    ret z

    rrca
    push af
    push de
    call c, CheckActionHitbox0Collision
    pop de
    pop af
    rrca
    jr c, CheckActionHitbox1Collision

    ret


CheckActionHitbox0Collision:: ; Check primary action/projectile hitbox at wPlayerActionHitbox0*.
Call_001_6355:: ; Compatibility alias.
    ld hl, wPlayerActionHitbox0X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [$ffd4]
    sub e
    ldh [$ffc9], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    ld a, [bc]
    and $7f
    cp $05
    ldh a, [hPlayerForm]
    jr nc, jr_001_6376

    cp PLAYER_FORM_ACTION_KAMEN
    jr z, ApplyObjectHitFromPlayerAction

jr_001_6376::
    cp PLAYER_FORM_ACTION_KAMEN
    jr z, LaunchObjectFromActionKamenHit

    cp PLAYER_FORM_COCKROACH
    jr z, ApplyObjectHitFromPlayerAction

    xor a
    ld [wPlayerSpecialActor0], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    jr ApplyObjectHitFromPlayerAction

CheckActionHitbox1Collision:: ; Check secondary action/projectile hitbox at wPlayerActionHitbox1*.
jr_001_6389:: ; Compatibility alias.
    ld hl, wPlayerActionHitbox1X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [$ffd4]
    sub e
    ldh [$ffc9], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    xor a
    ld [wPlayerSpecialActor1], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    jr ApplyObjectHitFromPlayerAction

Call_001_63a8::
    ld d, $00

CheckPlayerBodyCollision::
Jump_001_63aa:: ; Compatibility alias.
    call Call_001_4c18
    call Call_001_4c9e
    ret nc

ApplyObjectHitFromPlayerAction:: ; Apply normal player form/projectile hit handling to current object.
jr_001_63b1:: ; Compatibility alias.
    ld a, $52
    call PlaySound
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $1f
    jr z, LaunchObjectFromActionKamenHit

    dec [hl]
    ld a, [hl]
    and $1f
    jr nz, SetObjectActionHitStun

LaunchObjectFromActionKamenHit:: ; Strong Action Kamen projectile hit: launch/stagger the current object.
jr_001_63c5:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    ld [hl], $02
    ld de, $fce0
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


SetObjectActionHitStun:: ; Put object into short hit-stun after a non-launching form action hit.
jr_001_63d5:: ; Compatibility alias.
    ld hl, $0002
    add hl, bc
    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $01
    ret


UpdateObjEnemyPartyHornKid:: ; Object type $0b: party-horn kid that reacts when the player approaches.
UpdateObjEnemyReactiveA:: ; Compatibility alias from pass 11.
    xor a
    ldh [$ffce], a
    call Call_001_63fe
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call Call_001_6486
    call Call_001_645b
    call CheckPlayerActionHitboxCollision_Default
    call Call_001_63a8
    jp Jump_001_4c06


UpdateEnemyReactiveAState::
Call_001_63fe:: ; Compatibility alias.
    call Call_001_629e
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_640a, label_001_641a, label_001_6422, label_001_642a


label_001_640a::
    ld hl, $6416
    call Jump_001_62cb
    call MoveObjectXBySpeed
    jp Jump_001_62b8


    db $06, $07, $06, $08

label_001_641a::
    pop af
    ld a, $0b
    ldh [$ffd6], a
    jp Jump_001_62eb


label_001_6422::
    pop af
    ld a, $0b
    ldh [$ffd6], a
    jp Jump_001_6311


label_001_642a::
    ld a, $09
    ldh [$ffd6], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld d, a
    ld a, $0a
    ldh [$ffd6], a
    ld a, $04
    ldh [$ffce], a
    ld a, d
    cp $b4
    ret c

Jump_001_6444::
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $80
    ld d, a
    ld a, [bc]
    and $7f
    or d
    ld [bc], a
    ld a, [hl]
    and $1f
    ld [hl], a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


CheckEnemyReactiveSpecialBodyCollision::
Call_001_645b:: ; Compatibility alias.
    ldh a, [$ffd4]
    ld e, a
    ldh a, [hPlayerScreenY]
    sub e
    rst $28
    cp $04
    ret nc

    ld d, $0c
    ldh a, [$ffce]
    add d
    ld d, a
    call Call_001_6478
    ld e, a
    ldh a, [hPlayerScreenX]
    sub e
    rst $28
    cp d
    ret nc

    jp jr_001_4ce8


Call_001_6478::
    ld a, [bc]
    rlca
    jr c, jr_001_6480

    ldh a, [$ffd3]
    add d
    ret


jr_001_6480::
    ldh a, [$ffd3]
    sub d
    ret


jr_001_6484::
    dec [hl]
    ret


CheckEnemyReactivePlayerProximity::
Call_001_6486:: ; Compatibility alias.
    ld e, $24

CheckEnemyPlayerProximityWithRange::
Jump_001_6488:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    cp $03
    ret z

    ld hl, $0005
    add hl, bc
    ld a, [hl]
    or a
    jr nz, jr_001_6484

    ldh a, [hPlayerScreenY]
    ld d, a
    ldh a, [$ffd4]
    sub d
    rst $28
    cp $0e
    ret nc

    ldh a, [$ffd3]
    cp $f0
    ret nc

    ld d, a
    ldh a, [hPlayerScreenX]
    sub d
    rst $28
    cp e
    ret nc

    ld h, b
    ld l, c
    ld a, [hl]
    and $80
    ld e, a
    ld h, b
    ld l, c
    ldh a, [hPlayerScreenX]
    sub d
    ld a, $00
    jr nc, jr_001_64be

    set 7, a

jr_001_64be::
    cp e
    ret nz

    inc hl
    ld [hl], $03
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $3f
    or e
    set 6, a
    ld [hl], a
    ret


UpdateObjEnemyUmbrellaKid:: ; Object type $0c: umbrella kid; player bounces when landing on top.
UpdateObjEnemyWalkerB:: ; Compatibility alias from pass 11.
    call Call_001_64e3
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call Call_001_650f
    call Call_001_6515
    jp Jump_001_4c06


UpdateEnemyWalkerBState::
Call_001_64e3:: ; Compatibility alias.
    call Call_001_629e
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_64ef, label_001_64ff, label_001_6507, label_001_6507


label_001_64ef::
    ld hl, $64fb
    call Jump_001_62cb
    call MoveObjectXBySpeed
    jp Jump_001_62b8


    db $0c, $0d, $0c, $0e

label_001_64ff::
    pop af
    ld a, $0f
    ldh [$ffd6], a
    jp Jump_001_62eb


label_001_6507::
    pop af
    ld a, $0f
    ldh [$ffd6], a
    jp Jump_001_6311


CheckEnemyWalkerBActionHitbox::
Call_001_650f:: ; Compatibility alias.
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckEnemyWalkerBSpecialBodyCollision::
Call_001_6515:: ; Compatibility alias.
    ld d, $01
    call Call_001_4c18
    call Call_001_4c9e
    ret nc

    ld a, $5c
    call PlaySound
    ret


UpdateObjEnemyPaperAirplaneKid:: ; Object type $0d: paper-airplane kid that spawns paper airplane projectiles.
UpdateObjEnemySpawnerA:: ; Compatibility alias from pass 11.
    call Call_001_653b
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call Call_001_65f3
    call CheckPlayerActionHitboxCollision_Default
    call Call_001_63a8
    jp Jump_001_4c06


UpdateEnemySpawnerAState::
Call_001_653b:: ; Compatibility alias.
    call Call_001_629e
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_6547, label_001_6557, label_001_655f, label_001_6567


label_001_6547::
    ld hl, $6553
    call Jump_001_62cb
    call MoveObjectXBySpeed
    jp Jump_001_62b8


    db $00, $01, $00, $02

label_001_6557::
    pop af
    ld a, $05
    ldh [$ffd6], a
    jp Jump_001_62eb


label_001_655f::
    pop af
    ld a, $05
    ldh [$ffd6], a
    jp Jump_001_6311


label_001_6567::
    ld a, $03
    ldh [$ffd6], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    and $7f
    jr z, jr_001_657b

    cp $78
    ret c

    jp Jump_001_6444


SpawnEnemyProjectileB::
jr_001_657b:: ; Compatibility alias.
    ld hl, wObjectSlots

jr_001_657e::
    ld a, [hl]
    or a
    jr z, jr_001_6592

    cp $ff
    jr z, jr_001_658c

    ld de, $0010
    add hl, de
    jr jr_001_657e

jr_001_658c::
    call jr_001_6592
    ld [hl], $ff
    ret


jr_001_6592::
    ld a, [bc]
    and $80
    or OBJ_ENEMY_PAPER_AIRPLANE
    ld [hl+], a

InitSpawnedEnemyProjectileB::
Jump_001_6598:: ; Compatibility alias.
    xor a
    ld [hl+], a
    call Call_001_65c5
    call Call_001_65dd
    call Call_001_65ae
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


CopyParentProjectileSpeedPlus40::
Call_001_65ae:: ; Compatibility alias.
    push hl
    ld hl, $0008
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    and $7f
    ld d, a
    ld hl, $0040
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


CopyParentProjectileXOffset::
Call_001_65c5:: ; Compatibility alias.
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $0800
    call ApplyObjectXVelocity
    inc hl
    ret


CopyParentProjectileYOffset::
Call_001_65dd:: ; Compatibility alias.
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $fff0
    add hl, de
    ld d, h
    ld e, l
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


CheckPaperAirplaneKidPlayerProximity::
CheckEnemySpawnerAPlayerProximity:: ; Compatibility alias.
Call_001_65f3:: ; Compatibility alias.
    ld e, $50
    jp Jump_001_6488


UpdateObjEnemyPaperAirplane:: ; Object type $0e: paper airplane projectile spawned by paper-airplane kid.
UpdateObjEnemyProjectileA:: ; Compatibility alias from pass 11.
    call Call_001_661b
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_6618

    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $02
    jr nz, jr_001_6611

    call Call_001_6645
    call Call_001_664b

jr_001_6611::
    ld a, $04
    ldh [$ffd6], a
    jp Jump_001_4c06


jr_001_6618::
    xor a
    ld [bc], a
    ret


UpdateEnemyProjectileAState::
Call_001_661b:: ; Compatibility alias.
    call Call_001_629e
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_6627, label_001_6638, label_001_663b, label_001_663b


label_001_6627::
    call MoveObjectXBySpeed
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $60
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


label_001_6638::
    call MoveObjectXBySpeed
label_001_663b::
    ld de, $0100
    ld hl, $0005
    add hl, bc
    jp Jump_001_4be3


CheckEnemyProjectileAActionHitbox::
Call_001_6645:: ; Compatibility alias.
    ld de, $0404
    jp CheckPlayerActionHitboxCollision


CheckEnemyProjectileABodyCollision::
Call_001_664b:: ; Compatibility alias.
    ld d, $03
    jp CheckPlayerBodyCollision


UpdateObjStageEvent05:: ; Object type $05: stage-specific object, exact role pending.
    call Call_001_6664
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_6661

    call Call_001_66b3
    jp Jump_001_4c06


jr_001_6661::
    xor a
    ld [bc], a
    ret


Call_001_6664::
    call Call_001_629e
    rst $00

    ; rst $00 jump table (2 entries)
    dw label_001_666c, label_001_66a4


label_001_666c::
    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call Call_001_6693

jr_001_6678::
    ld d, $10
    ld hl, $000c
    add hl, bc
    ld e, $03
    call AdvanceObjectAnimCounter
    ld hl, $000b
    add hl, bc
    ld a, [hl]
    ld hl, $6690
    rst $38
    ld a, [hl]
    ldh [$ffd6], a
    ret


    db $12, $13, $14

Call_001_6693::
    call MoveObjectXBySpeed
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


label_001_66a4::
    call MoveObjectXBySpeed
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call jr_001_4bee
    jr jr_001_6678

Call_001_66b3::
    ld a, [$c0b6]
    cp $ff
    ret z

    ld d, $04
    jp CheckPlayerBodyCollision


UpdateObjEnemyProjectileB:: ; Object type $0f: enemy projectile / child object, exact source pending.
    call Call_001_66d2
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call Call_001_6724
    call Call_001_672a
    jp Jump_001_4c06


UpdateEnemyProjectileBState::
Call_001_66d2:: ; Compatibility alias.
    call Call_001_629e
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_66de, label_001_66f4, label_001_671a, label_001_671a


label_001_66de::
    ld hl, $66ec
    ld d, $0f
    call Call_001_62cd
    call MoveObjectXBySpeed
    jp Jump_001_62b8


    db $10, $11, $10, $12, $13, $14, $13, $14

label_001_66f4::
    pop af
    ld hl, $66f0

Jump_001_66f8::
    ld d, $0f
    call Call_001_62cd
    call Call_001_670a
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    ret nz

    jp Jump_001_4c06


Call_001_670a::
    ld hl, $0002
    add hl, bc
    inc [hl]
    ld a, [hl]
    cp $b4
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ret


label_001_671a::
    pop af
    ld hl, $66f0
    call Jump_001_62cb
    jp Jump_001_6311


CheckEnemyProjectileBActionHitbox::
Call_001_6724:: ; Compatibility alias.
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckEnemyProjectileBBodyCollision::
Call_001_672a:: ; Compatibility alias.
    ld d, $02
    jp CheckPlayerBodyCollision


UpdateObjStageEvent01:: ; Object type $01: stage-specific event/object, exact role pending.
    call ProjectObjectToScreenAndCull
    call Call_001_6751
    ld a, [$d931]
    or a
    jr nz, jr_001_6741

    call Call_001_684b
    call Call_001_6851

jr_001_6741::
    ld a, [$d931]
    or a
    jr z, jr_001_674e

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_674e::
    jp Jump_001_4c06


Call_001_6751::
    call Call_001_629e
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw label_001_6800, label_001_67f0, label_001_67d0, label_001_6760
    dw label_001_679e


label_001_6760::
    ld a, $10
    ldh [$ffd6], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3f
    ret c

    jr z, jr_001_677e

    cp $a0
    ld a, $11
    ldh [$ffd6], a
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


jr_001_677e::
    ld hl, wObjectSlots

jr_001_6781::
    ld a, [hl]
    or a
    jr z, jr_001_6795

    cp $ff
    jr z, jr_001_678f

    ld de, $0010
    add hl, de
    jr jr_001_6781

jr_001_678f::
    call jr_001_6795
    ld [hl], $ff
    ret


jr_001_6795::
    ld a, [bc]
    and $80
    or $05
    ld [hl+], a
    jp Jump_001_6598


label_001_679e::
    ld a, $10
    ldh [hJoyHeld], a
    ldh [hJoyPressed], a
    ldh a, [hPlayerScreenX]
    cp $a8
    ret c

    ld a, $01
    ld [$c0a9], a
    ld a, $03
    ld [$d93d], a
    ld a, $04
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ldh a, [$ff9f]
    add a
    inc a
    ld [$d979], a
    ldh a, [$ff9f]
    inc a
    ldh [$ff9f], a
    cp $04
    ret c

    dec a
    ldh [$ff9f], a
    xor a
    ld [$c0a9], a
    ret


label_001_67d0::
    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $67fc
    call Jump_001_62cb
    call Call_001_6320
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $01
    ld [hl+], a
    ld [hl], $04
    ret


label_001_67f0::
    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $67fc
    jp Jump_001_66f8


    db $15, $16, $15, $16

label_001_6800::
    call Call_001_6810
    ld hl, $680c
    call Jump_001_62cb
    jp MoveObjectXBySpeed


    db $17, $18, $17, $19

Call_001_6810::
    ldh a, [$ffd3]
    and $fe
    cp $94
    jr z, jr_001_6821

    jr nc, jr_001_683c

    cp $0c
    jr z, jr_001_6841

    jr c, jr_001_6846

    ret


jr_001_6821::
    ld a, $94
    ld hl, $0002
    add hl, bc
    ld [hl], $00
    inc hl
    ld a, $f4
    ld [hl], a
    call jr_001_683c

jr_001_6830::
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


jr_001_683c::
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


jr_001_6841::
    call jr_001_6846
    jr jr_001_6830

jr_001_6846::
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


Call_001_684b::
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


Call_001_6851::
    ld d, $02
    jp CheckPlayerBodyCollision


UpdateObjStageEvent02:: ; Object type $02: stage-specific event/object, exact role pending.
    call ProjectObjectToScreenAndCull
    call Call_001_6878
    ld a, [$d931]
    or a
    jr nz, jr_001_6868

    call Call_001_684b
    call Call_001_6851

jr_001_6868::
    ld a, [$d931]
    or a
    jr z, jr_001_6875

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_6875::
    jp Jump_001_4c06


Call_001_6878::
    call Call_001_629e
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw label_001_68b7, label_001_6887, label_001_6897, label_001_68b7
    dw label_001_679e


label_001_6887::
    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $6893
    jp Jump_001_66f8


    db $17, $18, $17, $18

label_001_6897::
    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $6893
    call Jump_001_62cb
    call Call_001_6320
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $02
    ld [hl+], a
    ld [hl], $04
    ret


label_001_68b7::
    ld a, [$c0b7]
    and $0f
    rst $00

    ; rst $00 jump table (5 entries)
    dw Jump_001_68e4, Jump_001_68e4, label_001_68f4, label_001_692b
    dw label_001_6970


Call_001_68c7::
    ldh a, [$ffd3]
    cp $94
    jr nc, jr_001_68d2

    cp $0c
    jr c, jr_001_68db

    ret


jr_001_68d2::
    ld a, [bc]
    bit 7, a
    ret nz

    call jr_001_683c
    jr jr_001_6911

jr_001_68db::
    ld a, [bc]
    bit 7, a
    ret z

    call jr_001_6846
    jr jr_001_6911

Jump_001_68e4::
    call Call_001_68c7
    ld hl, $68f0
    call Jump_001_62cb
    jp MoveObjectXBySpeed


    db $14, $15, $14, $16

label_001_68f4::
    ld a, $19
    ldh [$ffd6], a
    ld a, [$c0b8]
    inc a
    ld [$c0b8], a
    cp $30
    ret c

    ld hl, $fe00
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    xor a
    ld [$c0b8], a

jr_001_6911::
    ld a, [$c0b7]
    inc a
    ld [$c0b7], a
    and $0f
    cp $05
    ret nz

    ld a, [$c0b7]
    and $80
    xor $80
    jr z, jr_001_6927

    inc a

jr_001_6927::
    ld [$c0b7], a
    ret


label_001_692b::
    call MoveObjectXBySpeed
    call Call_001_6940
    ld a, $1a
    ldh [$ffd6], a
    ld a, [$c0ba]
    bit 7, a
    ret nz

    ld a, $1b
    ldh [$ffd6], a
    ret


Call_001_6940::
    ld hl, $c0b9
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0008
    ld a, [$dffe]
    or a
    jr z, jr_001_6952

    ld de, $000c

jr_001_6952::
    add hl, de
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    ld d, h
    ld e, l
    call Call_001_632e
    ldh a, [$ffd4]
    cp $41
    ret c

    ld hl, $0005
    add hl, bc
    xor a
    ld [hl+], a
    ld a, $c0
    ld [hl], a
    jr jr_001_6911

label_001_6970::
    jp Jump_001_68e4


UpdateObjStageEvent03:: ; Object type $03: scripted stage event that can spawn OBJ_STAGE_EVENT_CHILD_24.
    call ProjectObjectToScreenAndCull
    call Call_001_69a0
    ld a, [$d931]
    or a
    jr nz, jr_001_6985

    call Call_001_6995
    call Call_001_699b

jr_001_6985::
    ld a, [$d931]
    or a
    jr z, jr_001_6992

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_6992::
    jp Jump_001_4c06


Call_001_6995::
    ld de, Call_000_0710
    jp CheckPlayerActionHitboxCollision


Call_001_699b::
    ld d, $06
    jp CheckPlayerBodyCollision


Call_001_69a0::
    ld a, $01
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw UpdateObjStageEvent03ScriptController, label_001_69b3, label_001_69c3, label_001_6a59
    dw label_001_679e


label_001_69b3::
    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $69bf
    jp Jump_001_66f8


    db $19, $1a, $19, $1a

label_001_69c3::
    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $69bf
    call Jump_001_62cb
    call Call_001_6320
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $03
    ld [hl+], a
    ld [hl], $04
    ret


UpdateObjStageEvent03ScriptController:: ; Stage event 03 script/controller routine at $69e3.
UpdateObjStageEvent20:: ; Compatibility alias from pass 10.
    call Call_001_6a09
    call MoveObjectXBySpeed
    call Call_001_6a6e
    call Call_001_6a3b
    ret nz

    ld hl, $fbc0
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    ld a, [$c0b7]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Jump_001_6a18, label_001_6a22, label_001_6a28, label_001_6a32
    dw label_001_6a38


Call_001_6a09::
    ld a, $15
    ldh [$ffd6], a
    ld a, [$c0ba]
    bit 7, a
    ret nz

    ld a, $16
    ldh [$ffd6], a
    ret


Jump_001_6a18::
    ld a, $01
    ld [$c0b7], a
    ld a, [bc]
    or $80
    ld [bc], a
    ret


label_001_6a22::
    ld a, $02
    ld [$c0b7], a
    ret


label_001_6a28::
    ld a, $03
    ld [$c0b7], a
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


label_001_6a32::
    ld a, $04
    ld [$c0b7], a
    ret


label_001_6a38::
    jp Jump_001_6a18


Call_001_6a3b::
    ld hl, $c0b9
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0040
    add hl, de
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    ld d, h
    ld e, l
    call Call_001_632e
    ld hl, $fc00
    add hl, de
    ld a, h
    or l
    ret


label_001_6a59::
    ld a, $17
    ldh [$ffd6], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $20
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Call_001_6a6e::
    ld a, [$c0b7]
    or a
    ret z

    ld hl, $c0b9
    ld a, [hl+]
    or [hl]
    ret nz

    ld hl, wObjectSlots
    ld e, $20

jr_001_6a7e::
    ld a, [hl]
    and $7f
    cp OBJ_STAGE_EVENT_TYPE_21
    ret z

    ld a, $10
    rst $38
    dec e
    jr nz, jr_001_6a7e

    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ld hl, wObjectSlots

jr_001_6a98::
    ld a, [hl]
    or a
    jr z, jr_001_6aac

    cp $ff
    jr z, jr_001_6aa6

    ld de, $0010
    add hl, de
    jr jr_001_6a98

jr_001_6aa6::
    call jr_001_6aac
    ld [hl], $ff
    ret


SpawnStageEvent21Child::
jr_001_6aac:: ; Compatibility alias.
    ld a, $80 | OBJ_STAGE_EVENT_TYPE_21
    ld [hl+], a
    xor a
    ld [hl+], a
    call Call_001_6ac5
    call Call_001_6add
    call Call_001_65ae
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


Call_001_6ac5::
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $0800
    call Jump_001_4be3
    inc hl
    ret


Call_001_6add::
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $ffe0
    add hl, de
    ld d, h
    ld e, l
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


UpdateObjStageEvent21:: ; Object type $21: stage-specific event/controller target at $6af3.
    call Call_001_6b07
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_6b04

    call Call_001_6b3c
    jp Jump_001_4c06


jr_001_6b04::
    xor a
    ld [bc], a
    ret


Call_001_6b07::
    ld a, $1b
    ldh [$ffd6], a
    call Call_001_629e
    and $01
    rst $00

    ; rst $00 jump table (2 entries)
    dw label_001_6b15, label_001_6b2f


label_001_6b15::
    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call MoveObjectXBySpeed
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $18
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


label_001_6b2f::
    call MoveObjectXBySpeed
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    jp Jump_001_4be3


Call_001_6b3c::
    ld a, [$c0b6]
    cp $ff
    ret z

    ld d, $07
    jp CheckPlayerBodyCollision


UpdateObjStageEvent04:: ; Object type $04: stage-specific event/object with custom action hitbox handling.
    call ProjectObjectToScreenAndCull
    call Call_001_6bd6
    ld a, [$d931]
    or a
    jr nz, jr_001_6b59

    call Call_001_6b69
    call Call_001_6bc5

jr_001_6b59::
    ld a, [$d931]
    or a
    jr z, jr_001_6b66

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_6b66::
    jp Jump_001_4c06


Call_001_6b69::
    ld de, $0712
    ldh a, [hPlayerActionLock]
    or a
    ret z

    rrca
    push af
    push de
    call c, Call_001_6b7c
    pop de
    pop af
    rrca
    jr c, jr_001_6ba6

    ret


Call_001_6b7c::
    ld hl, wPlayerActionHitbox0X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [$ffd4]
    sub e
    ldh [$ffc9], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    ldh a, [hPlayerForm]
    cp PLAYER_FORM_ACTION_KAMEN
    jp z, LaunchObjectFromActionKamenHit

    cp PLAYER_FORM_COCKROACH
    jr z, jr_001_6bce

    xor a
    ld [wPlayerSpecialActor0], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    jr jr_001_6bce

jr_001_6ba6::
    ld hl, wPlayerActionHitbox1X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [$ffd4]
    sub e
    ldh [$ffc9], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    xor a
    ld [wPlayerSpecialActor1], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    jr jr_001_6bce

Call_001_6bc5::
    ld d, $08
    call Call_001_4c18
    call Call_001_4c9e
    ret nc

jr_001_6bce::
    ld a, [$c0ba]
    or a
    ret z

    jp ApplyObjectHitFromPlayerAction


Call_001_6bd6::
    call Call_001_629e
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw label_001_6c15, label_001_6be5, label_001_6bf5, label_001_6c15
    dw label_001_679e


label_001_6be5::
    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $6bf1
    jp Jump_001_66f8


    db $18, $19, $18, $19

label_001_6bf5::
    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $6bf1
    call Jump_001_62cb
    call Call_001_6320
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $04
    ld [hl+], a
    ld [hl], $04
    ret


label_001_6c15::
    ld a, [$c0b7]
    rst $00

    ; rst $00 jump table (14 entries)
    dw label_001_6c35, label_001_6c4f, label_001_6c72, label_001_6c92
    dw label_001_6d14, label_001_6c92, label_001_6d24, label_001_6c92
    dw label_001_6d34, label_001_6c92, label_001_6d44, label_001_6d54
    dw label_001_6d8b, label_001_6dd3


label_001_6c35::
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $8d
    jp nc, MoveObjectXBySpeed

    ld a, $01
    ld [$c0b7], a
    ret


Call_001_6c45::
    ld hl, $6c4b
    jp Jump_001_62cb


    db $15, $16, $15, $17

label_001_6c4f::
    ldh a, [$ffd4]
    cp $21
    jr c, jr_001_6c65

    ld de, $0100
    call Call_001_6c6b
    ld hl, $6c61
    jp Jump_001_62cb


    db $1d, $1e, $1d, $1e

jr_001_6c65::
    ld a, $02
    ld [$c0b7], a
    ret


Call_001_6c6b::
    ld hl, $0005
    add hl, bc
    jp jr_001_4bee


label_001_6c72::
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $70
    jp nc, MoveObjectXBySpeed

    ld a, $03
    ld [$c0b7], a
    ret


jr_001_6c82::
    ld a, [bc]
    set 7, a
    ld [bc], a
    xor a
    ld [$c0b8], a
    ld a, [$c0b7]
    inc a
    ld [$c0b7], a
    ret


label_001_6c92::
    ld a, [bc]
    res 7, a
    ld [bc], a
    xor a
    ld [$c0b9], a
    ld a, $1b
    ldh [$ffd6], a
    ld a, [$c0b8]
    inc a
    ld [$c0b8], a
    cp $30
    jr nc, jr_001_6c82

    cp $10
    ret c

    cp $20
    ret nc

    cp $1f
    jr z, jr_001_6cb8

    ld a, $1c
    ldh [$ffd6], a
    ret


SpawnStageEventChild24::
jr_001_6cb8:: ; Compatibility alias.
    ld a, $1c
    ldh [$ffd6], a
    ld hl, wObjectSlots

jr_001_6cbf::
    ld a, [hl]
    or a
    jr z, jr_001_6cd3

    cp $ff
    jr z, jr_001_6ccd

    ld de, $0010
    add hl, de
    jr jr_001_6cbf

jr_001_6ccd::
    call jr_001_6cd3
    ld [hl], $ff
    ret


jr_001_6cd3::
    ld a, OBJ_STAGE_EVENT_CHILD_24
    ld [hl+], a
    xor a
    ld [hl+], a
    call Call_001_6cec
    call Call_001_6d04
    call Call_001_65ae
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


Call_001_6cec::
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $1200
    call Jump_001_4be3
    inc hl
    ret


Call_001_6d04::
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


label_001_6d14::
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $58
    jp nc, MoveObjectXBySpeed

    ld a, $05
    ld [$c0b7], a
    ret


label_001_6d24::
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $38
    jp nc, MoveObjectXBySpeed

    ld a, $07
    ld [$c0b7], a
    ret


label_001_6d34::
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $18
    jp nc, MoveObjectXBySpeed

    ld a, $09
    ld [$c0b7], a
    ret


label_001_6d44::
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $14
    jp nc, MoveObjectXBySpeed

    ld a, $0b
    ld [$c0b7], a
    ret


label_001_6d54::
    ld a, [bc]
    res 7, a
    ld [bc], a
    ld a, $1a
    ldh [$ffd6], a
    ldh a, [$ffd4]
    cp $70
    jr nc, jr_001_6d71

    cp $6e
    call nc, Call_001_6d85
    ld de, $0200
    ld hl, $0005
    add hl, bc
    jp Jump_001_4be3


jr_001_6d71::
    ld a, $0c
    ld [$c0b7], a
    ld hl, hSCY
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ld [$c464], a
    ld a, h
    ld [$c465], a
    ret


Call_001_6d85::
    ld a, $68
    call PlaySound
    ret


label_001_6d8b::
    ld a, $1a
    ldh [$ffd6], a
    ld a, [$c0b8]
    inc a
    ld [$c0b8], a
    cp $40
    jr nc, jr_001_6dbd

    and $07
    jr z, jr_001_6da3

    cp $04
    jr z, jr_001_6db0

    ret


jr_001_6da3::
    ldh a, [hSCY]
    sub $01
    ldh [hSCY], a
    ldh a, [hSCYHigh]
    sbc $00
    ldh [hSCYHigh], a
    ret


jr_001_6db0::
    ldh a, [hSCY]
    add $01
    ldh [hSCY], a
    ldh a, [hSCYHigh]
    adc $00
    ldh [hSCYHigh], a
    ret


jr_001_6dbd::
    xor a
    ld [$c0b8], a
    ld a, $0d
    ld [$c0b7], a
    ld hl, $c464
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hSCY], a
    ld a, h
    ldh [hSCYHigh], a
    ret


label_001_6dd3::
    ld a, $01
    ld [$c0ba], a
    ld a, $01
    ld [$c0b9], a
    call Call_001_6c45
    ldh a, [$ffd3]
    cp $8c
    jp c, MoveObjectXBySpeed

    xor a
    ld [$c0ba], a
    ld a, $01
    ld [$c0b7], a
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


UpdateObjStageEventChild24:: ; Object type $24: stage event child/effect actor spawned by OBJ_STAGE_EVENT_TYPE_03.
    call Call_001_6e0c
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_6e09

    call Call_001_6e1f
    xor a
    ldh [hSpriteFlags], a
    jp Jump_001_4c06


jr_001_6e09::
    xor a
    ld [bc], a
    ret


Call_001_6e0c::
    ld a, $1f
    ldh [$ffd6], a
    ld a, [$c0b9]
    or a
    ret z

    ld hl, $0005
    add hl, bc
    ld de, $0180
    jp Jump_001_4be3


Call_001_6e1f::
    ld a, [$c0b6]
    cp $ff
    ret z

    ld d, $03
    jp CheckPlayerBodyCollision


UpdateObjPlatformBouncePad:: ; Object type $1d: bounce pad / trampoline-style platform.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    call UpdateBouncePadPlayerContact
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    ld hl, $70c4
    or a
    jr z, jr_001_6e42

    ld hl, $70d5

jr_001_6e42::
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


UpdateBouncePadPlayerContact::
Call_001_6e4b:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_6e93

    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [$ffc3]
    cp $ff
    ret z

    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $0e
    ret nc

    ldh a, [$ffd4]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub h
    ret nc

    cpl
    inc a
    cp $12
    ret nc

    cp $0e
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ldh a, [hPlayerState]
    cp $06
    ret z

    call SetPlayerJumpVelocity

AttachPlayerToObjectTop16:: ; Align player Y to object top - $10.
Call_001_6e81:: ; Compatibility alias.
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $fff0
    add hl, de
    ld a, l
    ldh [hPlayerY], a
    ld a, h
    ldh [hPlayerYHigh], a
    ret


ApplyBouncePadJump::
jr_001_6e93:: ; Compatibility alias.
    ld hl, $ffad
    ld de, $0100
    call Jump_001_4be3
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $08
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ldh a, [hPlayerState]
    cp $06
    ret z

    ld a, $5c
    call PlaySound
    ld a, $10
    ldh [hPlayerGravity], a
    ld a, $02
    ldh [hPlayerState], a
    ld [$c0b0], a
    call Call_001_6e81
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    rst $00

    ; Bounce pad strength dispatch table.
    dw SetBouncePadJumpVelocity0 ; 00
    dw SetBouncePadJumpVelocity1 ; 01
    dw SetBouncePadJumpVelocity2 ; 02

SetBouncePadJumpVelocity0::
    ld hl, $fc70
    jp jr_001_5e9d


SetBouncePadJumpVelocity1::
    ld hl, $fbc0
    jp jr_001_5e9d


SetBouncePadJumpVelocity2::
    ld hl, $fb40
    jp jr_001_5e9d


UpdateObjMovingPlatformVerticalA:: ; Object type $1a: vertical moving platform variant A.
    call CullObjectAndReleaseSpawn
    ret nz

    call UpdateMovingPlatformVerticalA
    ldh a, [$ffd5]
    or a
    ret nz

    call Jump_001_6f0a

Jump_001_6eef::
    ld hl, $70de
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


UpdateMovingPlatformVerticalA::
Call_001_6efb:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_6f4b, Jump_001_6f62, label_001_6f77, Jump_001_6f62


CheckPlayerStandingOnPlatform::
Jump_001_6f0a:: ; Compatibility alias.
    ldh a, [hPlayerState]
    cp $06
    ret z

    ldh a, [$ffd5]
    or a
    ret nz

    ld e, $12
    call Call_001_6f28
    ret nc

AttachPlayerToPlatformTop::
Jump_001_6f19:: ; Compatibility alias.
    ld a, $ff
    ldh [$ffc4], a
    call Call_001_6e81
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


CheckPlayerPlatformTopOverlap::
Call_001_6f28:: ; Compatibility alias.
    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [$ffc3]
    cp $ff
    ret z

    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp e
    ret nc

    ldh a, [$ffd4]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub h
    ret nc

    cpl
    inc a
    cp $15
    ret nc

    cp $0f
    ccf
    ret


label_001_6f4b::
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call jr_001_4bee

jr_001_6f55::
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


Jump_001_6f62::
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


label_001_6f77::
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call Jump_001_4be3
    jr jr_001_6f55

UpdateObjMovingPlatformVerticalB:: ; Object type $1b: vertical moving platform variant B; can carry player X.
    call CullObjectAndReleaseSpawn
    ret nz

    call UpdateMovingPlatformVerticalB
    ldh a, [$ffd5]
    or a
    ret nz

    jp Jump_001_6eef


UpdateMovingPlatformVerticalB::
Call_001_6f91:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    ; rst $00 jump table (4 entries)
    dw label_001_6fa0, label_001_6fd1, label_001_6fd7, label_001_6fd1


label_001_6fa0::
    ld hl, $0002
    add hl, bc
    ldh a, [hJoyHeld]
    and $30
    jr nz, jr_001_6fad

    ld a, [hl]
    ldh [hPlayerXSubpixel], a

jr_001_6fad::
    ld de, $00c0
    call jr_001_4bee
    call jr_001_6f55
    ldh a, [hPlayerState]
    cp $06
    ret z

    ldh a, [$ffd5]
    or a
    ret nz

    ld e, $12
    call Call_001_6f28
    ret nc

    ld hl, $ffb0
    ld de, $00c0
    call jr_001_4bee
    jp Jump_001_6f19


label_001_6fd1::
    call Jump_001_6f62
    jp Jump_001_6f0a


label_001_6fd7::
    ld hl, $0002
    add hl, bc
    ldh a, [hJoyHeld]
    and $30
    jr nz, jr_001_6fe4

    ld a, [hl]
    ldh [hPlayerXSubpixel], a

jr_001_6fe4::
    ld de, $00c0
    call Jump_001_4be3
    call jr_001_6f55
    ldh a, [hPlayerState]
    cp $06
    ret z

    ld e, $12
    call Call_001_6f28
    ret nc

    ld hl, $ffb0
    ld de, $00c0
    call Jump_001_4be3
    jp Jump_001_6f19


UpdateObjDropPlatformA:: ; Object type $09/$1c: drop/moving platform variant A.
Call_001_7004:: ; Compatibility alias.
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_701e

    call Call_001_706f
    call Call_001_7021
    ld hl, $70bb
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


jr_001_701e::
    xor a
    ld [bc], a
    ret


CheckPlayerStandingOnDropPlatform::
Call_001_7021:: ; Compatibility alias.
    ldh a, [hPlayerState]
    cp $06
    ret z

    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [$ffc3]
    cp $ff
    ret z

    ld a, [$c403]
    ld l, a
    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $10
    ret nc

    cp l
    ret nc

    ld [$c403], a
    ldh a, [$ffd4]
    ld h, a
    ldh a, [hPlayerScreenY]
    sub h
    ret nc

    cpl
    inc a
    cp $0c
    ret nc

    cp $07
    ret c

    ld a, $ff
    ldh [$ffc4], a
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $fff8
    add hl, de
    ld a, l
    ldh [hPlayerY], a
    ld a, h
    ldh [hPlayerYHigh], a
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


UpdateDropPlatformMotionA::
Call_001_706f:: ; Compatibility alias.
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, Jump_001_6f62

MoveDropPlatformDown::
Jump_001_7077:: ; Compatibility alias.
    ld hl, $0005
    add hl, bc
    ld de, $0200
    jp Jump_001_4be3


UpdateObjDropPlatformB:: ; Object type $1e: drop/moving platform variant B.
Call_001_7081:: ; Compatibility alias.
    call ProjectObjectToScreenAndCull
    ldh a, [$ffd5]
    or a
    jr nz, jr_001_701e

    call Call_001_7095
    call Call_001_7021
    jp Jump_001_4c06


    xor a
    ld [bc], a
    ret


UpdateDropPlatformMotionB::
Call_001_7095:: ; Compatibility alias.
    ld a, $02
    ldh [hSpriteFlags], a
    ld a, $10
    ldh [$ffd6], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, Jump_001_6f62

    dec a
    jr z, jr_001_70ab

    jp Jump_001_7077


jr_001_70ab::
    ld hl, $000d
    add hl, bc
    bit 3, [hl]
    jp z, Jump_001_6f62

    ld a, $11
    ldh [$ffd6], a
    jp Jump_001_6f62


    db $f8, $f8, $b0, $10, $f8, $00, $b0, $10, $80, $f0, $f8, $b1, $10, $f0, $00, $b2
    db $10, $f8, $f8, $b3, $10, $f8, $00, $b4, $10, $80, $f8, $f8, $b5, $10, $f8, $00
    db $b6, $10, $80, $f0, $f0, $b7, $00, $f0, $f8, $b8, $00, $f0, $00, $b8, $00, $f0
    db $08, $b9, $00, $f8, $f0, $ba, $00, $f8, $f8, $bb, $00, $f8, $00, $bb, $00, $f8
    db $08, $bc, $00, $80

UpdateObjMovingPlatformHorizontal:: ; Object type $22: horizontal moving platform / carrier.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jr z, jr_001_7126

    ld hl, $0008
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ld hl, $0003
    add hl, bc
    ld de, $00b0
    ld a, [bc]
    sla a
    jr c, jr_001_711e

    ld de, $fff0

jr_001_711e::
    ldh a, [hSCX]
    add e
    ld [hl+], a
    ldh a, [hSCXHigh]
    adc d
    ld [hl], a

jr_001_7126::
    call Call_001_714e
    call Call_001_71fd
    ld a, [bc]
    sla a
    ld a, $00
    rl a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    ld hl, $21ce
    and $04
    jr z, jr_001_7145

    ld hl, $21ff

jr_001_7145::
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp jr_000_026c


MovePlatformAndCarryPlayer::
Call_001_714e:: ; Compatibility alias.
    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $10
    ret nc

    ldh a, [hPlayerState]
    cp $0b
    ret z

    ldh a, [$ffd5]
    or a
    ret nz

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [$ffd4]
    sub h
    ret c

    cp $20
    ret nc

    cp $1c
    jr nc, jr_001_71ac

    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ldh [hPlayerX], a
    ld a, [hl+]
    ldh [hPlayerXHigh], a
    ld de, $0010
    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    jr nc, jr_001_7195

    ld de, $fff0

jr_001_7195::
    ldh a, [hPlayerX]
    add e
    ldh [hPlayerX], a
    ldh a, [hPlayerXHigh]
    adc d
    ldh [hPlayerXHigh], a
    ld hl, $0008
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ldh a, [hPlayerScreenX]
    sub e
    ldh [$ffd3], a
    ret


jr_001_71ac::
    ldh a, [hPlayerVelYHigh]
    bit 7, a
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $c0
    call Call_001_71fd
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    sub $1f
    ldh [hPlayerY], a
    push bc
    ld a, [bc]
    rlca
    jr nc, jr_001_71cd

    call Call_001_523a
    jr jr_001_71d0

jr_001_71cd::
    call Call_001_516c

jr_001_71d0::
    ldh a, [$ffc0]
    pop bc
    or a
    jr nz, jr_001_71e3

    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, $ffb0
    call ApplyObjectXVelocity

jr_001_71e3::
    ldh a, [hJoyHeld]
    and $81
    cp $81
    jr nz, jr_001_71f1

    ldh a, [hJoyHeld]
    res 0, a
    ldh [hJoyHeld], a

jr_001_71f1::
    ld a, $ff
    ldh [$ffc4], a
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


StopPlatformAtEndpoint::
Call_001_71fd:: ; Compatibility alias.
    ld de, $0350
    ld a, [bc]
    sla a
    jr nc, jr_001_7208

    ld de, $00b0

jr_001_7208::
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    and $f8
    cp e
    ret nz

    ld a, [hl+]
    cp d
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $00
    ret


UpdateObjStageEventType1F:: ; Object type $1f: platform/event behavior, exact role pending.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jr z, jr_001_722f

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, jr_001_701e

    ret


jr_001_722f::
    call Call_001_725f
    ld d, $03
    call Call_001_4c18
    call Call_001_4c9e
    ld hl, $000a
    add hl, bc
    ldh a, [$ffc9]
    ld d, [hl]
    bit 3, d
    jr z, jr_001_7246

    inc a

jr_001_7246::
    ld hl, $7253
    rst $20
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


    db $30, $22

    jr nc, jr_001_7279

    db $30, $22, $3f, $22, $35, $22, $3a, $22

Call_001_725f::
    xor a
    ldh [$ffc9], a
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, jr_001_7282

    inc a
    and $0f
    or $40
    ld [hl], a
    ld a, $04
    ldh [$ffc9], a
    ld hl, $0006
    add hl, bc

jr_001_7279::
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl+], a
    ret


jr_001_7282::
    or a
    jr z, jr_001_728c

    inc a
    ld [hl], a
    ld a, $02
    ldh [$ffc9], a
    ret


jr_001_728c::
    ldh a, [$ffd3]
    ld d, a
    ldh a, [hPlayerScreenX]
    sub d
    rst $28
    cp $48
    ret nc

    ld a, $01
    ld [hl], a
    ret


UpdateObjStageEventType20:: ; Object type $20: platform/event behavior, exact role pending.
    call CullObjectAndReleaseSpawn
    ret nz

    call Call_001_72e8
    ldh a, [$ffc9]
    or a
    jr nz, jr_001_72b0

    ld hl, $000a
    add hl, bc
    bit 7, [hl]
    jp nz, jr_001_701e

    ret


jr_001_72b0::
    ldh a, [$ffd5]
    or a
    ret nz

    ld d, $05
    call Call_001_4c18
    call Call_001_4c9e
    ld hl, $000a
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    inc a
    ld [de], a
    ld hl, $2244
    and $78
    cp $08
    jr nz, jr_001_72d1

    ld hl, $2255

jr_001_72d1::
    cp $10
    jr nz, jr_001_72d8

    ld hl, $2266

jr_001_72d8::
    cp $18
    jr c, jr_001_72df

    ld a, $80
    ld [de], a

jr_001_72df::
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


Call_001_72e8::
    xor a
    ldh [$ffc9], a
    ld hl, $0003
    add hl, bc
    ld e, [hl]
    inc hl
    ldh a, [hPlayerX]
    sub e
    ld e, a
    ld d, [hl]
    inc hl
    ldh a, [hPlayerXHigh]
    sbc d
    jr z, jr_001_72ff

    cp $ff
    ret nz

jr_001_72ff::
    xor e
    cp $60
    ret nc

    inc hl
    ld a, [hl+]
    and $80
    ld e, a
    ldh a, [hPlayerY]
    and $80
    cp e
    ret nz

    ld e, [hl]
    ldh a, [hPlayerYHigh]
    cp e
    ret nz

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ld a, $01
    ldh [$ffc9], a
    ret


UpdateObjStageEvent07:: ; Object type $07: stage-specific object, exact role pending.
    call CullObjectAndReleaseSpawn
    ret nz

    call Call_001_7339
    ldh a, [$ffd5]
    or a
    ret nz

    ld hl, $2277
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    jp Jump_000_0269


Call_001_7339::
    xor a
    ldh [$ffc9], a
    ldh a, [$ffd3]
    ld e, a
    ldh a, [hPlayerScreenX]
    sub e
    rst $28
    cp $08
    jr nc, jr_001_7394

    ldh a, [$ffd4]
    ld e, a
    ldh a, [hPlayerScreenY]
    sub e
    cp $06
    jr c, jr_001_7394

    cp $10
    jr nc, jr_001_735b

    ldh a, [hPlayerVelYHigh]
    bit 7, a
    jr nz, jr_001_7394

jr_001_735b::
    cp $14
    jr nc, jr_001_7394

    ldh a, [hPlayerState]
    cp $0b
    jr z, jr_001_7394

    cp $06
    jr z, jr_001_7394

    ldh a, [$ffd5]
    or a
    jr nz, jr_001_7394

    ldh a, [hJoyPressed]
    ld e, $13
    bit 7, a
    jr z, jr_001_7377

    inc e

jr_001_7377::
    bit 0, a
    jr z, jr_001_737d

    ld e, $0f

jr_001_737d::
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add e
    ldh [hPlayerY], a
    ld a, $ff
    ldh [$ffc4], a
    ldh a, [hPlayerState]
    cp $0d
    call nz, Call_001_57d9
    ld a, $01
    ldh [$ffc9], a

jr_001_7394::
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    dec a
    ld [hl], a
    cp $d0
    jr z, jr_001_73ba

    sla a
    ret c

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ldh a, [$ffc9]
    or a
    ret z

    ld de, $0100
    ld hl, $ffb0
    call ApplyObjectXVelocity
    ret


jr_001_73ba::
    ld d, h
    ld e, l
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor $80
    ld [bc], a
    ret


UpdateObjStageEvent08:: ; Object type $08: stage-specific object, exact role pending.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    ret nz

    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr z, jr_001_73d8

    dec [hl]

jr_001_73d8::
    srl a
    ld e, a
    ldh a, [$ffd4]
    add e
    ldh [$ffd4], a
    call Call_001_7407
    ld e, $00
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr nz, jr_001_73f9

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    bit 4, a
    jr z, jr_001_73f9

    ld e, $02

jr_001_73f9::
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    add e
    ld b, a
    ld hl, $2486
    jp Jump_000_025d


    ret


Call_001_7407::
    ldh a, [$ffd3]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $09
    ret nc

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [$ffd4]
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
    jr nz, jr_001_7442

    ldh a, [hJoyHeld]
    res 0, a
    ldh [hJoyHeld], a

jr_001_7442::
    ld a, $ff
    ldh [$ffc4], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    inc [hl]
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


UpdateObjStageEvent23:: ; Object type $23: stage-specific event/object, exact role pending.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [$ffd5]
    or a
    jr z, jr_001_7468

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, jr_001_701e

    ret


jr_001_7468::
    call Call_001_7489
    ld d, $05
    call Call_001_4c18
    call Call_001_4c9e
    ld hl, $000a
    add hl, bc
    ldh a, [$ffd3]
    ld c, a
    ldh a, [$ffd4]
    ld b, a
    ld a, [hl]
    bit 3, a
    jr z, jr_001_7483

    inc c

jr_001_7483::
    ld hl, $2475
    jp Jump_000_0269


Call_001_7489::
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, jr_001_749d

    ld de, $0180
    ld hl, $0005
    add hl, bc
    call ApplyObjectXVelocity
    ret


jr_001_749d::
    or a
    jr z, jr_001_74a3

    inc a
    ld [hl], a
    ret


jr_001_74a3::
    ldh a, [$ffd3]
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


Stage0SpawnList:: ; $74b5-$7645
    INCBIN "assets/levels/stage0/spawns.bin"

Stage1SpawnList:: ; $7646-$77e5
    INCBIN "assets/levels/stage1/spawns.bin"

Stage2SpawnList:: ; $77e6-$79c6
    INCBIN "assets/levels/stage2/spawns.bin"

Stage3SpawnList:: ; $79c7-$7b7a
    INCBIN "assets/levels/stage3/spawns.bin"

Stage4SpawnList:: ; $7b7b-$7b8a
    INCBIN "assets/levels/stage4/spawns.bin"

    ld hl, $7d32
    ld a, l
    ld [$d92f], a
    ld a, h
    ld [$d930], a
    xor a
    ld [$d954], a
    ldh [hJoyHeld], a
    ld [$d955], a
    ld [$d956], a
    ld [$d957], a
    ld [$d92d], a
    ld [$d92e], a
    ld a, $5c
    ldh [hOamMaxY], a
    ld a, $8f
    ldh [$ffc9], a
    ld hl, $9c00
    ld bc, $1206
    call Call_000_08b7
    ld a, $50
    ldh [hWY], a
    ld a, $06
    ld hl, $50c4
    ld de, $8800
    ld bc, $0100
    call BankedMemcpy
    ld a, $03
    ld hl, $400f
    ld de, $8900
    call LoadMaskedGfx
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    call InitSound
    ld a, $20
    call PlaySound_Queue3
    ret


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
    jr nz, jr_001_7c08

    ldh a, [hPlayerXHigh]
    or a
    jr z, jr_001_7c18

jr_001_7c08::
    xor a
    ld [wPlayerSpecialActor0], a
    ld [wPlayerSpecialActor1], a
    ldh [$ff9f], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


jr_001_7c18::
    call Call_001_7cfa
    ldh a, [hSCX]
    ld b, a
    ldh a, [hPlayerX]
    sub b
    cp $38
    jr nc, jr_001_7c31

    ldh a, [hPlayerX]
    sub $38
    jr nc, jr_001_7c2c

    xor a

jr_001_7c2c::
    ldh [hSCX], a
    ld b, a
    jr jr_001_7c42

jr_001_7c31::
    cp $68
    jr c, jr_001_7c42

    ldh a, [hPlayerX]
    sub $68
    cp $60
    jr c, jr_001_7c3f

    ld a, $60

jr_001_7c3f::
    ldh [hSCX], a
    ld b, a

jr_001_7c42::
    ldh a, [hPlayerX]
    sub b
    ldh [hPlayerScreenX], a
    ldh a, [hSCY]
    ld c, a
    ldh a, [hPlayerY]
    sub c
    cp $18
    jr nc, jr_001_7c5d

    ldh a, [hPlayerY]
    sub $18
    jr nc, jr_001_7c58

    xor a

jr_001_7c58::
    ldh [hSCY], a
    ld c, a
    jr jr_001_7c6e

jr_001_7c5d::
    cp $48
    jr c, jr_001_7c6e

    ldh a, [hPlayerY]
    sub $48
    cp $b0
    jr c, jr_001_7c6b

    ld a, $b0

jr_001_7c6b::
    ldh [hSCY], a
    ld c, a

jr_001_7c6e::
    ldh a, [hPlayerY]
    sub c
    ldh [hPlayerScreenY], a
    call UpdateSpecialActors
    call UpdateObjectsAndSpawnQueue
    call UpdatePlayerState
    call DrawPlayerSprite
    ld hl, wVramQueue

jr_001_7c82::
    ld a, [hl]
    or a
    jp z, jr_001_7c9b

    and $fc
    cp $9c
    jr nz, jr_001_7c91

    xor a
    ld [hl], a
    jr jr_001_7c9b

jr_001_7c91::
    inc hl
    ld b, [hl]
    inc hl
    ld a, [hl+]
    inc hl
    and $3c
    rst $38
    jr jr_001_7c82

jr_001_7c9b::
    ld bc, Jump_000_3f00
    add hl, bc
    ld a, l
    ldh [hVramQueuePos], a
    call Call_000_0719
    ld a, [$d955]
    inc a
    ld [$d955], a
    and $0f
    jr nz, jr_001_7cd9

    ld a, [$d956]
    ld hl, $7d27
    rst $38
    ld b, [hl]
    ld a, [$d954]
    cp b
    jr nz, jr_001_7cd2

    xor a
    ld [$d957], a
    ld a, $04
    ld [$d970], a
    ld a, [$d956]
    or a
    jr z, jr_001_7cd2

    add $5c
    call Call_000_0710

jr_001_7cd2::
    ld a, [$d954]
    inc a
    ld [$d954], a

jr_001_7cd9::
    ld a, [$d957]
    bit 7, a
    ret nz

    inc a
    ld [$d957], a
    cp $04
    ret nz

    xor a
    ld [$d970], a
    ld a, [$d956]
    add $5d
    call Call_000_0710
    ld a, [$d956]
    inc a
    ld [$d956], a
    ret


Call_001_7cfa::
    ld a, [$d92d]
    ldh [hJoyHeld], a
    xor a
    ldh [hJoyPressed], a
    ld a, [$d92e]
    dec a
    ld [$d92e], a
    cp $ff
    ret nz

    ld hl, $d92f
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    and $f3
    ld [$d92d], a
    ldh [hJoyPressed], a
    ld a, [hl+]
    ld [$d92e], a
    ld a, l
    ld [$d92f], a
    ld a, h
    ld [$d930], a
    ret


    ld bc, $2b18
    ld c, c
    ld e, h
    ld [hl], h
    add [hl]
    xor c
    cp [hl]
    jp z, Jump_000_00ff

    ld c, h
    db $10
    ld [$1e11], sp
    db $10
    ld e, $00
    db $10
    db $10
    inc b
    nop
    inc bc
    ld b, b
    ld [hl-], a
    nop
    add hl, de
    add b
    ld [hl], $00
    dec d
    db $10
    ld d, $00
    inc c
    ld bc, $0011
    inc h
    db $10
    ld e, $00
    ld e, $20
    ld [hl+], a
    nop
    ld c, $10
    inc b
    nop
    ld a, [bc]
    ld bc, $001e
    jr jr_001_7d71

    ld hl, $1e11
    db $10
    add hl, de
    nop
    ld a, [de]
    add b
    jr @-$7d

    ld b, $80
    dec b
    nop
    inc l
    db $10

jr_001_7d71::
    dec sp
    nop
    dec b
    jr nz, jr_001_7d79

    nop
    inc de
    add b

jr_001_7d79::
    dec e
    add c
    ld a, [bc]
    add b
    add hl, bc
    nop
    inc l
    jr nz, @+$1a

    nop
    dec hl
    ld bc, $001d
    sbc a
    ld bc, $0013
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld bc, QueueVramFill
    nop
    ld bc, $0401
    nop
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld bc, $0401
    nop
    inc bc
    ld bc, $2101
    ld [bc], a
    jr nz, @+$04

    ld hl, $2004
    ld [bc], a
    ld hl, $0102
    ld [bc], a
    nop
    nop
    jr nz, jr_001_7dc2

jr_001_7dc2::
    nop
    nop
    ld bc, $0003
    inc bc
    ld bc, $0004
    ld [bc], a
    jr nz, jr_001_7dce

jr_001_7dce::
    ld hl, $2003
    inc bc
    ld hl, $2004
    ld [bc], a
    ld hl, $2004
    inc bc
    ld hl, $2003
    inc bc
    ld hl, $2004
    inc bc
    ld bc, $0004
    inc bc
    ld bc, $0004
    inc bc
    ld bc, $2103
    ld bc, $0220
    ld hl, $2005
    ld bc, $0521
    jr nz, jr_001_7dfb

    ld hl, $2005

jr_001_7dfb::
    ld [bc], a
    ld bc, $2004
    inc bc
    ld hl, $2005
    ld [bc], a
    ld hl, $2005
    ld bc, $0000
    ld bc, $0005
    inc bc
    ld bc, $0003
    inc b
    ld bc, $0004
    inc b
    ld bc, $0007
    ld [bc], a
    ld bc, $0005
    ld bc, $0601
    nop
    ld [$0c02], sp
    nop
    ld c, d
    jr nz, jr_001_7e52

    nop
    jr nc, jr_001_7e2c

    add hl, de

jr_001_7e2c::
    nop
    add b
    ld bc, $0020
    ld l, $20
    ld c, b
    nop
    rrca
    db $10
    dec b
    nop
    ld sp, $0e80
    add c
    rlca
    add b
    ld [bc], a
    nop
    ld b, b
    ld [bc], a
    dec bc
    nop
    adc d
    add b
    ld a, [bc]
    add c
    dec bc
    add b
    ld bc, $2700
    add b
    ld c, $81
    db $10

jr_001_7e52::
    add b
    nop
    nop
    jr nc, jr_001_7e67

    jr nz, jr_001_7e59

jr_001_7e59::
    dec l
    ld bc, $0013
    sub h
    db $10
    ld h, h
    nop
    inc h
    jr nz, jr_001_7eb2

    nop
    inc c
    db $10

jr_001_7e67::
    rlca
    nop
    dec hl
    ld bc, $1114
    dec bc
    db $10
    add hl, bc
    nop
    ld l, $02
    dec bc
    nop
    ld a, [hl+]
    db $10
    ld d, [hl]
    nop
    ld h, d
    db $10
    add b
    rst $38
    inc bc
    nop
    sbc c
    sbc e
    rst $38
    inc bc
    sub d
    sbc d
    rst $38
    inc bc
    sub d
    sbc d
    sub d
    sbc b
    rst $38
    ld [$9300], sp
    ld a, [hl+]
    inc e
    ccf
    ld a, [hl]
    inc h
    ld de, $3737
    ld a, [hl+]
    ld a, a
    sub h
    rst $38
    ld [$9300], sp
    rst $38
    ld a, [bc]
    nop
    sbc h
    sbc l
    rst $38
    rlca
    nop
    sub e
    rst $38
    ld a, [bc]
    nop
    sub h
    rst $38
    ld [$9700], sp
    rst $38
    ld a, [bc]
    or b

jr_001_7eb2::
    sub [hl]
    rst $38
    add hl, de
    nop
    sbc c
    rst $38
    inc c
    sub d
    rst $38
    dec b
    sbc d
    sub d
    sbc b
    sub e
    db $10
    ld de, $1312
    inc d
    nop
    ld a, [hl+]
    dec hl
    inc l
    dec l
    ld l, $00
    dec d
    ld d, $17
    jr jr_001_7eea

    nop
    sub h
    sub e
    rst $38
    inc c
    nop
    rst $38
    dec b
    ld b, l
    nop
    sub h
    sub e
    dec d
    ld d, $17
    jr jr_001_7efb

    nop
    cpl
    jr nc, jr_001_7f17

    ld [hl-], a
    inc sp
    nop
    ld a, [de]

jr_001_7eea::
    dec de
    inc e
    dec e
    ld e, $00
    sub h
    sub e
    rst $38
    inc c
    nop
    rst $38
    dec b
    ld b, l
    nop
    sub h
    sub e
    ld a, [de]

jr_001_7efb::
    dec de
    inc e
    dec e
    ld e, $00
    inc [hl]
    dec [hl]
    ld [hl], $37
    jr c, jr_001_7f06

jr_001_7f06::
    rra
    jr nz, jr_001_7f2a

    inc hl
    inc h
    nop
    sub h
    sub e
    rst $38
    inc c
    nop
    rst $38
    dec b
    ld b, l
    nop
    sub h
    sub e

jr_001_7f17::
    rra
    jr nz, jr_001_7f3b

    inc hl
    inc h
    nop
    add hl, sp
    ld a, [hl-]
    dec sp
    inc a
    dec a
    nop
    ld a, [hl+]
    dec hl
    inc l
    dec l
    ld l, $00
    sub h

jr_001_7f2a::
    sub e
    rst $38
    ld [de], a
    nop
    sub h
    sub e
    dec h
    ld h, $27
	db $28
	db $29

    nop
    ld a, $3f
    ld b, c
    ld b, d
    rst $38

jr_001_7f3b::
    inc b
    nop
    or e
    or h
    or l
    nop
    sub h
    sub e
    rst $38
    ld [de], a
    nop
    sub h
    sub a
    rst $38
    ld [de], a
    sub l
    sub [hl]
    ds $8000 - @, $FF