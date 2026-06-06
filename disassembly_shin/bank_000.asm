; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $000", ROM0[$0]

DEF wScreenPaletteId EQU $d933
DEF wFadeTransitionTimer EQU $d95c
DEF wMsgSubstitutionId     EQU $d971

DEF wCgbEnabled EQU $dff7
DEF wSgbEnabled EQU $dff8
; Hardware / memory aliases identified during cleanup pass 1.
; Keep these conservative: names below are based on direct register usage in bank 0.
DEF hJoyHeld       EQU $ff8a
DEF hJoyPressed    EQU $ff8b
DEF hJoyLast       EQU $ff8c
DEF hVBlankBusy    EQU $ff8d
DEF hGameState     EQU $ff8e
DEF hNeedsReset    EQU $ff8f

DEF hSCY           EQU $ff90
DEF hSCYHigh       EQU $ff91
DEF hSCX           EQU $ff92
DEF hSCXHigh       EQU $ff93
DEF hWY            EQU $ff94
DEF hWX            EQU $ff95
DEF hCollisionFlag EQU $ff96

DEF hVramQueuePos  EQU $ff99
DEF hOamMaxY       EQU $ff9a
DEF hOamWritePos   EQU $ff9b
DEF hPrevOamPos    EQU $ff9c
DEF hSpriteFlags   EQU $ff9d
DEF hStageIndex    EQU $ff9f ; Current gameplay stage/area index used by bank 1 stage tables.

; Gameplay aliases identified during cleanup pass 3.
; These are based on direct use in bank 1 gameplay update/player/object code.
DEF hPlayerScreenY      EQU $ffa4
DEF hPlayerScreenX      EQU $ffa5
DEF hPlayerAnimId       EQU $ffa6
DEF hPlayerAnimCounter  EQU $ffa7
DEF hPlayerAnimFrame    EQU $ffa8
DEF hPlayerObjectFlags  EQU $ffa9
DEF hPlayerState        EQU $ffaa
DEF hPrevPlayerState    EQU $ffab
DEF hPlayerDirection    EQU $ffac ; direction/facing, 0=right-ish, $ff=left-ish.
DEF hPlayerYSubpixel    EQU $ffad
DEF hPlayerY            EQU $ffae
DEF hPlayerYHigh        EQU $ffaf
DEF hPlayerXSubpixel    EQU $ffb0
DEF hPlayerX            EQU $ffb1
DEF hPlayerXHigh        EQU $ffb2
DEF hPlayerVelYLo       EQU $ffb3
DEF hPlayerVelY         EQU $ffb3 ; Compatibility alias.
DEF hPlayerVelYHi       EQU $ffb4
DEF hPlayerVelYHigh     EQU $ffb4 ; Compatibility alias.
DEF hPlayerMoveSpeedLo  EQU $ffb5
DEF hPlayerSpeedX       EQU $ffb5 ; Compatibility alias.
DEF hPlayerMoveSpeedHi  EQU $ffb6
DEF hPlayerSpeedXHigh   EQU $ffb6 ; Compatibility alias.
DEF hPlayerGravity      EQU $ffb7
DEF hBonusCounter       EQU $ffb8 ; reaches 30, then awards an extra life.
DEF hPlayerHealth       EQU $ffb9 ; max 3; decremented by damage.
DEF hPlayerLives        EQU $ffba
DEF hPlayerForm         EQU $ffbb
DEF hPlayerActionLock   EQU $ffbc
DEF hPlayerAnimTimer    EQU $ffbd ; Compatibility alias.
DEF hPlayerFlags        EQU $ffbe
DEF hPlayerTileEffect   EQU $ffbf
DEF hPlayerJumpProfile   EQU $ffc2

; Player form constants identified from gameplay testing.
DEF PLAYER_FORM_NORMAL          EQU $00 ; 普通小新
DEF PLAYER_FORM_FLYING_SQUIRREL EQU $01 ; 飛鼠小新
DEF PLAYER_FORM_COCKROACH       EQU $02 ; 蟑螂小新
DEF PLAYER_FORM_CHICKEN         EQU $03 ; 母雞小新
DEF PLAYER_FORM_ACTION_KAMEN    EQU $04 ; 動感超人

; Player jump profile constants. These index the jump velocity table in StartPlayerJump.
DEF PLAYER_JUMP_PROFILE_NORMAL  EQU $03
DEF PLAYER_JUMP_PROFILE_CHICKEN EQU $04

; Player collision height offsets. Cockroach Shin-chan uses a shorter vertical hitbox.
DEF PLAYER_COLLISION_HEIGHT_NORMAL    EQU $16
DEF PLAYER_COLLISION_HEIGHT_COCKROACH EQU $0f

DEF wOamBuffer     EQU $c000
DEF wVramQueue     EQU $c100
DEF wLCDCShadow    EQU $c0a2
DEF wPaletteBGP    EQU $c0a3
DEF wPaletteOBP0   EQU $c0a4
DEF wPaletteOBP1   EQU $c0a5

DEF wObjectSlots        EQU $c180
DEF wSpawnCursor        EQU $c380
DEF wSpawnStateList     EQU $c381
DEF wPendingVramUpdates EQU $c402

; Camera / stage runtime parameters. Stage init code seeds these, and
; UpdateCameraAndStreamMap consumes them every frame.
DEF wCameraScreenLeftThreshold   EQU $c408 ; Player screen X must stay >= this before camera scrolls left.
DEF wCameraScreenRightThreshold  EQU $c409 ; Player screen X must stay < this before camera scrolls right.
DEF wCameraScreenTopThreshold    EQU $c40a ; Player screen Y must stay >= this before camera scrolls up.
DEF wCameraScreenBottomThreshold EQU $c40b ; Player screen Y must stay < this before camera scrolls down.
DEF wCameraScrollStepX           EQU $c40c ; Max camera X scroll step per frame.
DEF wCameraScrollStepY           EQU $c40d ; Max camera Y scroll step per frame.
DEF wCameraScrollXMinLo          EQU $c40e
DEF wCameraScrollXMinHi          EQU $c40f
DEF wPlayerXMinLo                EQU $c410
DEF wPlayerXMinHi                EQU $c411
DEF wPlayerXMaxLo                EQU $c414
DEF wPlayerXMaxHi                EQU $c415
DEF wPlayerYFallThresholdLo      EQU $c416 ; Player/world Y threshold used by stage death-fall logic.
DEF wPlayerYFallThresholdHi      EQU $c417
DEF wCameraScrollXMaxLo          EQU $c418
DEF wCameraScrollXMaxHi          EQU $c419
DEF wCameraScrollYMaxLo          EQU $c41a
DEF wCameraScrollYMaxHi          EQU $c41b

; Scroll-streaming scratch in HRAM. These remember the last streamed tile row/column.
DEF hStreamedColumnX             EQU $ff97
DEF hStreamedRowY                EQU $ff98
DEF hTileStreamWritePos          EQU $ffc9
DEF hTileStreamCount             EQU $ffcb

; Stage layout/map runtime buffers.
DEF wStageTileAttrTable       EQU $c700 ; 256-byte tile/metatile collision/attribute lookup.
DEF wStageLayoutMap           EQU $c800 ; Decompressed stage metatile layout pages.
DEF wStageLayoutPageHighTable EQU $c41c ; Page high-byte table used by world->layout lookup.

; Stage metatile graphics table pointer in HRAM. Each metatile id maps to 4 BG tile bytes.
DEF hStageMetatileTableLo EQU $ffa2
DEF hStageMetatileTableHi EQU $ffa3

; Object system constants. Object type is stored in slot byte +0, masked by OBJECT_TYPE_MASK.
DEF OBJECT_SLOT_SIZE  EQU $10
DEF SPAWN_RECORD_SIZE EQU $05
DEF OBJECT_TYPE_MASK  EQU $3f
DEF OBJECT_LIST_END   EQU $ff
DEF OBJECT_SLOT_EMPTY EQU $00
DEF SPAWN_STATE_READY   EQU $01
DEF SPAWN_STATE_BLOCKED EQU $02
DEF SPAWN_LIST_END      EQU $ff


; Object type constants. Corrected in pass 12: the first dispatch-table entry is dw $4867.
DEF OBJ_NONE                       EQU $00
DEF OBJ_STAGE_EVENT_TYPE_01        EQU $01 ; Stage-specific event/object, exact role pending.
DEF OBJ_STAGE_EVENT_TYPE_02        EQU $02 ; Stage-specific event/object, exact role pending.
DEF OBJ_STAGE_EVENT_TYPE_03        EQU $03 ; Stage-specific event/object, exact role pending.
DEF OBJ_STAGE_EVENT_TYPE_04        EQU $04 ; Stage-specific event/object, exact role pending.
DEF OBJ_STAGE_EVENT_TYPE_05        EQU $05 ; Stage-specific object, exact role pending.
DEF OBJ_STAGE_EVENT_CHILD_A        EQU $06 ; Enemy-like child actor behavior, exact source pending.
DEF OBJ_STAGE_EVENT_TYPE_07        EQU $07 ; Stage-specific event/object, exact role pending.
DEF OBJ_STAGE_EVENT_TYPE_08        EQU $08 ; Stage-specific event/object, exact role pending.
DEF OBJ_PLATFORM_DROP_A_VARIANT    EQU $09 ; Shares UpdateObjDropPlatformA behavior.
DEF OBJ_ENEMY_WALKING_KID          EQU $0a
DEF OBJ_ENEMY_PARTY_HORN_KID       EQU $0b
DEF OBJ_ENEMY_UMBRELLA_KID         EQU $0c
DEF OBJ_ENEMY_PAPER_AIRPLANE_KID   EQU $0d
DEF OBJ_ENEMY_PAPER_AIRPLANE       EQU $0e
DEF OBJ_ENEMY_PROJECTILE_B         EQU $0f ; Enemy projectile / child object, exact source pending.

; Confirmed pickup/form object type constants.
DEF OBJ_PICKUP_BONUS_COUNTER      EQU $10 ; Adds hBonusCounter; 30 awards an extra life.
DEF OBJ_PICKUP_BONUS_COUNTER_ANIM EQU $11 ; Animated version of bonus-counter pickup.
DEF OBJ_PICKUP_EXTRA_LIFE         EQU $12
DEF OBJ_PICKUP_EXTRA_LIFE_ANIM    EQU $13 ; Animated version of extra-life pickup.
DEF OBJ_PICKUP_HEALTH             EQU $14 ; Adds hPlayerHealth, max 3.
DEF OBJ_PICKUP_HEALTH_ANIM        EQU $15 ; Animated version of health pickup.
DEF OBJ_FORM_FLYING_SQUIRREL      EQU $16
DEF OBJ_FORM_COCKROACH            EQU $17
DEF OBJ_FORM_CHICKEN              EQU $18
DEF OBJ_FORM_ACTION_KAMEN         EQU $19
DEF OBJ_PLATFORM_MOVING_VERTICAL_A   EQU $1a
DEF OBJ_PLATFORM_MOVING_VERTICAL_B   EQU $1b
DEF OBJ_PLATFORM_DROP_A              EQU $1c
DEF OBJ_PLATFORM_BOUNCE_PAD          EQU $1d
DEF OBJ_PLATFORM_DROP_B              EQU $1e
DEF OBJ_STAGE_EVENT_TYPE_21          EQU $21 ; Stage-specific event/controller, not a simple platform.
DEF OBJ_PLATFORM_MOVING_HORIZONTAL   EQU $22
DEF OBJ_STAGE_EVENT_TYPE_23          EQU $23 ; Stage-specific event/object, exact role pending.
DEF OBJ_STAGE_EVENT_CHILD_24         EQU $24 ; Child/effect actor spawned by stage event type $03.

; Player form/action work variables.
DEF wSavedPlayerState     EQU $c0ac
DEF wFormActionStep       EQU $c0ad
DEF wFormActionTimer      EQU $c0ae
DEF wPlayerActionMeter     EQU $c0af
DEF wFormActionTemp       EQU $c0af ; Compatibility alias.
DEF wStoredPlayerForm     EQU $c0be
DEF wPlayerSpecialActor0  EQU $c0bf
DEF wPlayerSpecialActor1  EQU $c0cb
DEF wFormTimerLo          EQU $c0a6
DEF wFormTimerHi          EQU $c0a7

; Player action/projectile hitboxes in screen coordinates.
DEF wPlayerActionHitbox0X EQU $c0c7
DEF wPlayerActionHitbox0Y EQU $c0c8
DEF wPlayerActionHitbox1X EQU $c0d3
DEF wPlayerActionHitbox1Y EQU $c0d4
DEF hActionHitboxHalfWidth  EQU $ffd1
DEF hActionHitboxHalfHeight EQU $ffd2

; Player special actor/projectile constants. These are stored at wPlayerSpecialActor* + 0.
DEF SPECIAL_ACTOR_NONE                       EQU $00
DEF SPECIAL_ACTOR_FLYING_SQUIRREL_PROJECTILE EQU $01
DEF SPECIAL_ACTOR_CHICKEN_PROJECTILE         EQU $02
DEF SPECIAL_ACTOR_ACTION_KAMEN_PROJECTILE    EQU $03


RST_00:: ; Jump table dispatch. A indexes word table after rst call, then jumps to target.
    jr jr_000_0061

    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_08::
    ret

    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_10::
    ret


    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_18::
    ret


    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_20:: ; Pointer table helper. HL points to word table, A selects entry, returns pointer in HL.
    jr jr_000_006b

jr_000_0022::
    ld [hl+], a
    dec b
    jr nz, jr_000_0022

    ret

    db $ff

RST_28:: ; abs(A).
    bit 7, a
    ret z

    cpl
    inc a
    ret


    db $ff
    db $ff

RST_30:: ; Add A to DE.
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ret


    db $ff

RST_38:: ; Add A to HL.
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ret

    db $ff

VBlankInterrupt::
    call VBlankHandler
    reti


    db $ff
    db $ff
    db $ff
    db $ff

LCDCInterrupt::
    call Call_000_024a
    reti

    db $ff
    db $ff
    db $ff
    db $ff

TimerOverflowInterrupt::
    reti

    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

SerialTransferCompleteInterrupt::
    reti


    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

JoypadTransitionInterrupt::
    reti


jr_000_0061::	;from rst $00
    add a
    pop hl
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl


jr_000_006b::	;from rst $20
    ld e, a
    ld d, $00
    add hl, de
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ret


bzero::
    xor a

Call_000_0075::
    ld [hl+], a
    dec bc
    ld a, c
    or b
    jr nz, bzero

    ret

    db $ff
    db $ff
    db $ff
    db $ff

CompareU16AtHLToDE::
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    sub d
    ret nz

    ld a, l
    sub e
    ret


FarCallFromBankTable:: ; Banked table call. H=bank, L=entry-ish index; calls pointer read from bank:$4000+L+1.
    ld a, [$4000]
    push af
    ld a, h
    ld [$2100], a
    ld a, $01
    add l

Call_000_0094::
    ld l, a
    ld a, $40
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call Call_000_00a3
    pop af
    ld [$2100], a
    ret


Call_000_00a3::
    jp hl


CopyDmaStubToHram::
    ld c, $80      ; HRAM destination = FF80
    ld b, $0a      ; copy 10 bytes
    ld hl, OamDmaStub

.copy
    ld a, [hl+]
    ldh [c], a
    inc c
    dec b
    jr nz, .copy
    ret

OamDmaStub::
    ld a, HIGH(wOamBuffer) ; $c0
    ldh [rDMA], a
    ld a, $28
.wait
    dec a
    jr nz, .wait
    ret

ReadJoypad:: ; Updates hJoyHeld, hJoyPressed, and hJoyLast from rP1.
    ld a, $20
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0f
    swap a
    ld b, a
    ld a, $10
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0f
    or b
    ld c, a
    ldh a, [hJoyLast]
    xor c
    and c
    ldh [hJoyPressed], a
    ld a, c
    ldh [hJoyHeld], a
    ldh [hJoyLast], a
    ld a, $30
    ldh [rP1], a
    ret


ApplyLCDC::
    ld a, [wLCDCShadow]
    ldh [rLCDC], a
    ret


    db $ff
    db $ff
    db $ff


Boot::
    nop
    jp Jump_000_0150


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

IF DEF(DX)
HeaderTitle::
    db "KUREYON SHIN4DX"
HeaderCGBFlag::
    db $80 ; Supports CGB functions, but still works on DMG/SGB.
ELSE
HeaderTitle::
    db "GB KUREYON SHIN4"

ENDC
HeaderNewLicenseeCode::
    db $42, $32

HeaderSGBFlag::
    db $03

HeaderCartridgeType::
    db $01

HeaderROMSize::
    db $02

HeaderRAMSize::
    db $00

HeaderDestinationCode::
    db $00

HeaderOldLicenseeCode::
    db $33

HeaderMaskROMVersion::
    db $00

HeaderComplementCheck::
    db $de

HeaderGlobalChecksum::
    db $fb, $dc

Jump_000_0150::
    ld sp, $dff0
    ld a, $01
    ld [$dff9], a
    ld [$dffa], a
    ld [$dffb], a
    xor a
    ld [$dffe], a
    ld [$dffd], a
    ld [$dffc], a
    xor a
    ld [wSgbEnabled], a
    call DetectSgbOrInitSgb
    jr nc, jr_000_017c

    ld a, $ff
    ld [wSgbEnabled], a
    ld hl, $030a
    call FarCallFromBankTable

jr_000_017c::
    di
    xor a
    ldh [rIE], a
    ld sp, $dff0
    ld hl, _HRAM
    ld bc, $007f
    call bzero
    call DisableLCD
    ld hl, $8000
    ld bc, $5f80
    call bzero
    call CopyDmaStubToHram
    call ReadJoypad
    call InitSound
	
ReinitCurrentState:: ; Rebuild current state with LCD off. Repeats if init sets hNeedsReset.
    di
    call DisableLCD
    xor a
    ld [wScreenPaletteId], a
    call Call_000_079b
    ld hl, _OAMRAM
    ld bc, $00a0
    call bzero
    ld hl, wOamBuffer
    ld bc, $00a0
    call bzero
    call InitCurrentGameState
    xor a
    ldh [hPrevOamPos], a
    call ApplyLCDC
    ldh a, [hNeedsReset]
    or a
    jr nz, ReinitCurrentState

    call ApplyScrollRegs
    call SgbDelayIfEnabled
    call Call_000_079b
    ei

MainWaitForStateReset:: ; Main thread idles here; VBlank update sets hNeedsReset to request a state rebuild.
    ldh a, [hNeedsReset]
    or a
    jr z, MainWaitForStateReset

    jr ReinitCurrentState

VBlankHandler:: ; Main VBlank handler: DMA/OAM, VRAM queue, palettes, joypad, sound.
    push af
    push bc
    push de
    push hl
    ldh a, [hVBlankBusy]
    and a
    jr nz, jr_000_0230

    inc a
    ldh [hVBlankBusy], a
    call _HRAM
    ld de, wVramQueue
    call jr_000_0347
    call ApplyScrollRegs
    call ApplyPalettes
    xor a
    ld [wVramQueue], a

Call_000_01fc::
    ldh [hVramQueuePos], a
    ldh [hOamWritePos], a
    ld a, [$4000]
    push af
    ld a, $07
    ld [$2100], a
    call UpdateSound
    pop af
    ld [$2100], a
    ei
    call Call_000_04f2
    call ReadJoypad
    call UpdateCurrentGameState
    ldh a, [hOamWritePos]
    ldh [hPrevOamPos], a
    call ClearUnusedOAM
    ldh a, [hJoyHeld]
    cp $0f
    jp z, jr_000_017c

    xor a
    ldh [hVBlankBusy], a
    pop hl
    pop de
    pop bc
    pop af
    ret


jr_000_0230::
    ld a, [$4000]
    push af
    ld a, $07
    ld [$2100], a
    call UpdateSound
    pop af
    ld [$2100], a
    ldh a, [hVBlankBusy]
    dec a
    ldh [hVBlankBusy], a
    pop hl
    pop de
    pop bc
    pop af
    ret


Call_000_024a::
    push af
    push bc
    push de
    push hl
    call Call_000_0256
    pop hl
    pop de
    pop bc
    pop af
    ret


Call_000_0256::
    ret


    ld a, $03
    ldh [hSpriteFlags], a
    jr jr_000_026c

Jump_000_025d::
    ld a, $02
    ldh [hSpriteFlags], a
    jr jr_000_026c

    ld a, $01
    ldh [hSpriteFlags], a
    jr jr_000_026c

Jump_000_0269::
    xor a
    ldh [hSpriteFlags], a

jr_000_026c::
    ld a, $10
    add b
    ld b, a
    ld a, $08
    add c
    ld c, a
    ldh a, [hOamWritePos]
    cp $a0
    ret z

    ld e, a
    ld d, $c0

jr_000_027c::
    ld a, [hl+]
    cp $80
    jr z, jr_000_029c

    add b
    ld [de], a
    push de
    ld d, a
    ldh a, [hOamMaxY]
    cp d
    pop de
    jr c, jr_000_02a0

    inc e
    call Call_000_02a5
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    call Call_000_02b7
    inc e
    ld a, e
    cp $a0
    jr nz, jr_000_027c

jr_000_029c::
    ld a, e
    ldh [hOamWritePos], a
    ret


jr_000_02a0::
    inc hl
    inc hl
    inc hl
    jr jr_000_027c

Call_000_02a5::
    ldh a, [hSpriteFlags]
    bit 0, a
    jr nz, jr_000_02af

    ld a, [hl+]
    add c
    ld [de], a
    ret


jr_000_02af::
    ld a, [hl+]
    cpl
    inc a
    sub $08
    add c
    ld [de], a
    ret


Call_000_02b7::
    ldh a, [hSpriteFlags]
    or a
    jr z, jr_000_02d3

    dec a
    jr z, jr_000_02ce

    dec a
    jr z, jr_000_02c9

    ld a, [hl+]
    xor $20
    set 7, a
    ld [de], a
    ret


jr_000_02c9::
    ld a, [hl+]
    set 7, a
    ld [de], a
    ret


jr_000_02ce::
    ld a, [hl+]
    xor $20
    ld [de], a
    ret


jr_000_02d3::
    ld a, [hl+]
    ld [de], a
    ret


DisableLCD::
    ld hl, rLCDC
    bit 7, [hl]
    ret z

    ldh a, [rIE]
    push af
    res 0, a
    ldh [rIE], a

jr_000_02e3::
    ldh a, [rLY]
    cp $91
    jr nz, jr_000_02e3

    res 7, [hl]
    pop af
    ldh [rIE], a
    ret


EnableInterruptsFromShadow::
    xor a
    ldh [rIF], a
    ld a, [$c0a0]
    ldh [rIE], a
    ret


Call_000_02f8::
    ld hl, $9bff

jr_000_02fb::
    ld bc, $0400

jr_000_02fe::
    ld a, $00
    ld [hl-], a
    dec bc
    ld a, b
    or c
    jr nz, jr_000_02fe

    ret


Call_000_0307::
    ld hl, $9fff
    jr jr_000_02fb

    ld hl, $9bff
    ld bc, $0400

jr_000_0312::
    ldh a, [hTileStreamWritePos]
    ld [hl-], a
    dec bc
    ld a, b
    or c
    jr nz, jr_000_0312

    ret


jr_000_031b::
    inc de
    ld h, a
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    inc de
    ld c, a
    and $3f
    ld b, a
    ld a, c
    rlca
    rlca
    and $03
    jr z, jr_000_0341

    dec a
    jr z, jr_000_034c

    dec a
    jr z, jr_000_0354

jr_000_0333::
    ld a, [de]
    ld [hl], a
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, jr_000_0333

    inc de
    jr jr_000_0347

jr_000_0341::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_000_0341

jr_000_0347::
    ld a, [de]
    or a
    jr nz, jr_000_031b

    ret


jr_000_034c::
    ld a, [de]
    inc de

jr_000_034e::
    ld [hl+], a
    dec b
    jr nz, jr_000_034e

    jr jr_000_0347

jr_000_0354::
    ld a, [de]
    ld [hl], a
    inc de
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, jr_000_0354

    jr jr_000_0347

jr_000_0362::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_000_0362

    ret


memcpy::
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, memcpy

    ret


BankedMemcpy:: ; Copy BC bytes from A:HL to DE, preserving the current ROM bank.
    push hl
    ld l, a
    ld a, [$4000]
    ld h, a
    ld a, l
    ld [$2100], a
    ld a, h
    pop hl
    push af
    call memcpy
    pop af
    ld [$2100], a
    ret


BankedMemcpy_RLEFF:: ; Banked copy with $ff count/value RLE expansion.
    push hl
    ld l, a
    ld a, [$4000]
    ld h, a
    ld a, l
    push hl
    ld [$2100], a
    pop hl
    ld a, h
    pop hl
    push af
    call jr_000_039e
    pop af
    ld [$2100], a
    ret


jr_000_039e::
    ld a, [hl+]
    cp $ff
    jr z, jr_000_03ab

    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, jr_000_039e

    ret


jr_000_03ab::
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    push hl
    ld h, a
    ldh a, [hTileStreamWritePos]
    ld l, a

jr_000_03b4::
    ld a, h
    ld [de], a
    inc de
    dec l
    jr z, jr_000_03c1

    dec bc
    ld a, b
    or c
    jr nz, jr_000_03b4

    pop hl
    ret


jr_000_03c1::
    pop hl
    dec bc
    ld a, b
    or c
    jr nz, jr_000_039e

    ret


SendSgbPacket::
    ld a, [hl]
    and $07
    ret z

    ld b, a
    ld c, $00

jr_000_03cf::
    push bc
    ld a, $00
    ldh [c], a
    ld a, $30
    ldh [c], a
    ld b, $10

jr_000_03d8::
    ld e, $08
    ld a, [hl+]
    ld d, a

jr_000_03dc::
    bit 0, d
    ld a, $10
    jr nz, jr_000_03e4

    ld a, $20

jr_000_03e4::
    ldh [c], a
    ld a, $30
    ldh [c], a
    rr d
    dec e
    jr nz, jr_000_03dc

    dec b
    jr nz, jr_000_03d8

    ld a, $20
    ldh [c], a
    ld a, $30
    ldh [c], a
    pop bc
    dec b
    ret z

    call DelayFramesOrCycles
    jr jr_000_03cf

SgbDelayIfEnabled::
    ld a, [wSgbEnabled]
    or a
    ret z

DelayFramesOrCycles::
    ld de, $1b58

jr_000_0406::
    nop
    nop
    nop
    dec de
    ld a, d
    or e
    jr nz, jr_000_0406

    ret


DetectSgbOrInitSgb:: ; SGB detection/init handshake. Carry set means SGB path was detected.
    ld hl, SgbPacket_MltReq2P_0480
    call SendSgbPacket
    call DelayFramesOrCycles
    ldh a, [rP1]
    and $03
    cp $03
    jr nz, jr_000_0465

    ld a, $20
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    call DelayFramesOrCycles
    ld a, $30
    ldh [rP1], a
    call DelayFramesOrCycles
    ld a, $10
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    call DelayFramesOrCycles
    ld a, $30
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    call DelayFramesOrCycles
    ldh a, [rP1]
    and $03
    cp $03
    jr nz, jr_000_0465

    ld hl, SgbPacket_MltReq1P_0470
    call SendSgbPacket
    call DelayFramesOrCycles
    sub a
    ret


jr_000_0465::
    ld hl, SgbPacket_MltReq1P_0470
    call SendSgbPacket
    call DelayFramesOrCycles
    scf
    ret

SgbPacket_MltReq1P_0470::
    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
SgbPacket_MltReq2P_0480::
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Call_000_0490::
    push de
    push hl
    call DisableLCD
    pop hl
    ld a, $e4
    ldh [rBGP], a
    ld de, $8800
    call memcpy

jr_000_04a0::
    ld hl, $9800
    ld de, $000c
    ld a, $80
    ld c, $0d

jr_000_04aa::
    ld b, $14

jr_000_04ac::
    ld [hl+], a
    inc a
    dec b
    jr nz, jr_000_04ac

    add hl, de
    dec c
    jr nz, jr_000_04aa

    ld a, $81
    ldh [rLCDC], a
    call DelayFramesOrCycles
    pop hl
    call SendSgbPacket
    call DelayFramesOrCycles

Jump_000_04c3::
    ret


    ldh [hTileStreamWritePos], a
    push de

Call_000_04c7::
    call DisableLCD
    ld a, $e4
    ldh [rBGP], a
    ld de, $8800
    ld bc, $1000
    ldh a, [hTileStreamWritePos]
    call BankedMemcpy
    jr jr_000_04a0

    ld hl, hTileStreamWritePos
    ld bc, $0014
    jp bzero


GetVramQueueTail:: ; HL = wVramQueue + hVramQueuePos.
    ld hl, wVramQueue
    ldh a, [hVramQueuePos]
    rst $38
    ret


Call_000_04eb::
    ld de, wVramQueue
    ldh a, [hVramQueuePos]
    rst $30
    ret


Call_000_04f2::
    ldh a, [$ff9e]
    ld b, a
    add a
    add a
    add b
    add $11
    ldh [$ff9e], a

Call_000_04fc::
    ret


QueueVramFill_SetHighBit::
    set 7, e
    jr QueueVramFill

QueueVramFill:: ; Queue a VRAM fill/single-byte command at wVramQueue.
    call GetVramQueueTail
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, e
    set 6, a
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $04
    ldh [hVramQueuePos], a
    ret


QueueTilemapByte:: ; Queue one tile byte A at tilemap address HL.
    push de
    ld d, a
    ld e, $01
    ld b, h
    ld c, l
    call QueueVramFill
    pop de
    ret


QueueBankedVramTile8000:: ; Queue one 16-byte tile to VRAM $8000 + E*16. D=bank, HL=source base, C=source tile index.
    ld a, [$4000]
    push af
    ld a, d
    ld [$2100], a
    call QueueVramTile8000_FromCurrentBank
    pop af
    ld [$2100], a
    ret


QueueBankedVramTile9000:: ; Queue one 16-byte BG tile to VRAM $9000 + E*16. D=bank, HL=source base, C=source tile index.
    ld a, [$4000]
    push af
    ld a, d
    ld [$2100], a

Jump_000_053a::
    call QueueVramTile9000_FromCurrentBank
    pop af
    ld [$2100], a
    ret


QueueVramTile9000_FromCurrentBank:: ; Internal version of QueueBankedVramTile9000 after bank has been selected.
    ld a, c
    ld b, h
    ld c, l
    ld h, $00
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, bc
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $9000
    jr QueueOne16ByteVramCopy

QueueVramTile8000_FromCurrentBank:: ; Internal version of QueueBankedVramTile8000 after bank has been selected.
    ld a, c
    ld b, h
    ld c, l
    ld h, $00
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, bc
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $8000

QueueOne16ByteVramCopy:: ; Shared tail: append destination + 16 data bytes to the VRAM queue.
    add hl, de
    ld d, h
    ld e, l
    call GetVramQueueTail
    ld a, d
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    pop de
    ld b, $10

jr_000_0580::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_000_0580

    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $13
    ldh [hVramQueuePos], a
    ret


    push de
    ld d, $10
    ld e, a
    xor a

jr_000_0594::
    add hl, hl
    rla
    jr c, jr_000_059b

    cp e
    jr c, jr_000_059d

jr_000_059b::
    sub e
    inc l

jr_000_059d::
    dec d
    jr nz, jr_000_0594

    pop de
    ret


SplitDecimalTensOnes:: ; Convert A to decimal tens/ones in $ffca/hTileStreamWritePos for HUD drawing.
    ld de, $0000

jr_000_05a5::
    ld e, a
    sub $0a
    jr c, jr_000_05ad

    inc d
    jr jr_000_05a5

jr_000_05ad::
    ld a, e
    ldh [hTileStreamWritePos], a
    ld a, d
    ldh [$ffca], a
    ret


MultiplyBCByA8bit:: ; HL = BC * A, 8-bit shift/add multiply helper.
    push de
    ld hl, $0000
    ld b, l
    ld d, $08

jr_000_05bb::
    rrca
    jr nc, jr_000_05bf

    add hl, bc

jr_000_05bf::
    sla c
    rl b
    dec d
    jr nz, jr_000_05bb

    pop de
    ret


ApplyScrollRegs:: ; Copy scroll/window shadow values to hardware registers.
    ldh a, [hSCY]
    ldh [rSCY], a
    ldh a, [hSCX]
    ldh [rSCX], a
    ldh a, [hWY]
    ldh [rWY], a
    ldh a, [hWX]
    ldh [rWX], a
    ret


ClearUnusedOAM::
    ld h, $c0
    ldh a, [hOamWritePos]
    ld l, a
    sub $a0
    ret nc

    cpl
    inc a
    ld b, a
    xor a

jr_000_05e5::
    ld [hl+], a
    dec b
    jr nz, jr_000_05e5

    ret


ApplyPalettes:: ; Copy palette shadow bytes to BGP/OBP0/OBP1.
    ld hl, wPaletteBGP
    ld a, [hl+]
    ldh [rBGP], a
    ld a, [hl+]
    ldh [rOBP0], a
    ld a, [hl]
    ldh [rOBP1], a
    ret


jr_000_05f7::
    call Call_000_05fe
    dec c
    jr nz, jr_000_05f7

    ret


Call_000_05fe::
    push bc
    push hl

jr_000_0600::
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, jr_000_0600

    pop hl
    ld bc, $0020
    add hl, bc
    pop bc
    ret


    push hl
    ld b, $10
    ld hl, $da80

jr_000_0613::
    ld [hl+], a
    inc a
    dec b
    jr nz, jr_000_0613

    pop hl
    ld de, $da80
    ld bc, $0404

QueueTilemapRect:: ; Queue a rectangular tilemap upload. HL=dest, DE=src, B=width, C=height.
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a
    call GetVramQueueTail

jr_000_0628::
    ldh a, [$ffc6]
    ld [hl+], a
    ldh a, [$ffc5]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    push bc

jr_000_0631::
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, jr_000_0631

    pop bc
    ldh a, [hVramQueuePos]
    add b
    add $03
    ldh [hVramQueuePos], a
    ldh a, [$ffc5]
    add $20
    ldh [$ffc5], a
    ldh a, [$ffc6]
    adc $00
    ldh [$ffc6], a
    dec c
    jr nz, jr_000_0628

    ld [hl], $00
    ret


Call_000_0651::
    ld a, [$4000]
    push af
    ldh a, [hTileStreamWritePos]
    ld [$2100], a
    call jr_000_05f7
    pop af
    ld [$2100], a
    ret


    ld a, [$4000]
    push af
    ldh a, [hTileStreamWritePos]
    ld [$2100], a
    call QueueTilemapRect
    pop af
    ld [$2100], a
    ret


jr_000_0673::
    ld a, [de]
    inc de
    cp $ff
    ret z

    cp $45
    jr z, jr_000_0683

    cp $43
    jr z, jr_000_0683

    ld [hl+], a
    jr jr_000_0673

jr_000_0683::
    ld bc, $ffe0
    add hl, bc
    ld [hl], a
    ld bc, $0020
    add hl, bc
    jr jr_000_0673

Jump_000_068e::
    push hl
    push de
    call Call_000_06bc
    pop de
    pop hl
    push hl
    call GetVramQueueTail
    ld a, b
    pop bc
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    ld [hl+], a
    add $03
    ld b, a

jr_000_06a3::
    ld a, [de]
    cp $ff
    jr z, jr_000_06b4

    inc de
    cp $45
    jr z, jr_000_06a3

    cp $43
    jr z, jr_000_06a3

    ld [hl+], a
    jr jr_000_06a3

jr_000_06b4::
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add b
    ldh [hVramQueuePos], a
    ret


Call_000_06bc::
    ld bc, $ffe0
    add hl, bc
    ld b, $00

jr_000_06c2::
    ld a, [de]
    cp $ff
    ret z

    inc de
    cp $45
    jr z, jr_000_06d3

    cp $43
    jr z, jr_000_06d3

    inc b
    inc hl
    jr jr_000_06c2

jr_000_06d3::
    push hl
    push bc
    call QueueTilemapByte
    pop bc
    pop hl
    jr jr_000_06c2

    ld a, [$4000]
    push af
    ld a, b
    ld [$2100], a
    ld c, [hl]
    pop af
    ld [$2100], a
    ret


jr_000_06ea::
    ld a, [hl]
    cp $ff
    ret z

    push hl
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    push bc
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    push bc
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    ld a, [hl+]

Call_000_06fe::
    pop de
    pop hl
    call BankedMemcpy
    pop hl
    ld a, $07
    rst $38
    jr jr_000_06ea

Call_000_0709::
    ld hl, $030c
    call FarCallFromBankTable
    ret


Call_000_0710::
    ldh [hTileStreamWritePos], a
    ld hl, $0300
    call FarCallFromBankTable
    ret


Call_000_0719::
    ld hl, $0302
    call FarCallFromBankTable
    ret


Call_000_0720::
    ld a, [$4000]
    push af
    xor a
    ldh [$ffce], a
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    ld h, a
    inc de
    ld a, [de]
    and $7f
    jr nz, jr_000_074c

    ld a, [hl]
    cp $fe
    jr nz, jr_000_073d

    ld a, $01
    ldh [$ffce], a
    jr jr_000_0757

jr_000_073d::
    ld a, [hl+]
    cp $ff
    jr nz, jr_000_074a

    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    ld [de], a
    inc hl
    jr jr_000_074c

jr_000_074a::
    ld [de], a
    inc hl

jr_000_074c::
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

jr_000_0757::
    dec hl
    ld a, [de]
    bit 7, a
    ld a, $00
    jr z, jr_000_0761

    ld a, $01

jr_000_0761::
    ldh [hSpriteFlags], a
    push bc
    ld c, [hl]
    ld b, $00
    sla c
    rl b
    ld a, $03
    ld [$2100], a
    ld hl, $4005
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    pop bc
    call jr_000_026c
    pop af
    ld [$2100], a
    ldh a, [$ffce]
    ret


Call_000_0785::
    ld a, $02
    ldh [hSpriteFlags], a
    jr jr_000_0794

    ld a, $01
    ldh [hSpriteFlags], a
    jr jr_000_0794

Call_000_0791::
    xor a
    ldh [hSpriteFlags], a

jr_000_0794::
    ld hl, $0306
    call FarCallFromBankTable
    ret


Call_000_079b::
    ld hl, $0308
    call FarCallFromBankTable
    ret


LoadMaskedGfx:: ; Load custom bitmask-compressed graphics from A:HL to DE.
    push hl
    ld l, a
    ld a, [$4000]
    ld h, a
    ld a, l
    ld [$2100], a
    ld a, h
    pop hl
    push af
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    dec de

jr_000_07b4::
    push bc
    ld b, $08
    ld c, [hl]
    inc hl
    ld a, [de]

jr_000_07ba::
    sla c
    jr c, jr_000_07bf

    ld a, [hl+]

jr_000_07bf::
    inc de
    ld [de], a
    dec b
    jr nz, jr_000_07ba

    pop bc
    dec bc
    ld a, c
    or b
    jr nz, jr_000_07b4

    pop af
    ld [$2100], a
    ret


UpdateTransitionFadeWithLateSgbPalSet::
    ld a, [wFadeTransitionTimer]
    or a
    ret z

    ld b, a
    ld a, $40
    sub b
    ld b, a
    ld a, [wFadeTransitionTimer]
    cp $03
    jr nz, jr_000_0803

    ld hl, SgbPacket_PalSetState14_087d
    ld a, [wScreenPaletteId]
    cp $14
    jr z, jr_000_07f1

    cp $18
    jr nz, jr_000_0803

    ld hl, SgbPacket_PalSetState18_088d

jr_000_07f1::
    push bc
    call SendSgbPacket
    pop bc
    jr jr_000_0803

UpdateTransitionFade::
    ld a, [wFadeTransitionTimer]
    or a
    ret z

    cp $3e
    call z, SendSgbTransitionPalSet
    ld b, a

jr_000_0803::
    ld a, [wFadeTransitionTimer]
    dec a
    ld [wFadeTransitionTimer], a
    ld a, b
    cp $40
    ret nc

    ld a, [wSgbEnabled]
    or a
    jr nz, jr_000_0839

    ld a, b
    swap a
    and $0f
    ld hl, DmgFadePaletteTable_089d
    rst $38
    ld a, b
    and $0f
    cp $07
    jr c, jr_000_0829

    bit 0, a
    jr z, jr_000_0829

    inc hl

jr_000_0829::
    ld a, [hl]
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld bc, $0005
    add hl, bc
    ld a, [hl]
    ld [wPaletteOBP0], a
    ret


jr_000_0839::
    ld hl, SgbFadePaletteTable_08a7
    ld a, b
    srl a
    srl a
    srl a
    rst $38
    ld a, [hl]
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, [wScreenPaletteId]
    cp $18
    ret nz

    ld hl, SgbFadePaletteObp0State18_08af
    ld a, b

Call_000_0858::
    srl a
    srl a
    srl a
    rst $38
    ld a, [hl]
    ld [wPaletteOBP0], a
    ret


SendSgbTransitionPalSet::
    push af
    ld hl, SgbPacket_PalSetDefault_086d
    call SendSgbPacket
    pop af
    ret

SgbPacket_PalSetDefault_086d::
    db $51, $03, $00, $03, $00, $03, $00, $03
	db $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_PalSetState14_087d::
    db $51, $30, $00, $31, $00, $32, $00, $33 
	db $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_PalSetState18_088d::
    db $51, $39, $00, $39, $00, $39, $00, $39 
	db $00, $00, $00, $00, $00, $00, $00, $00
	
DmgFadePaletteTable_089d::
    db $00, $00, $40, $90, $e4 
	db $00, $00, $40, $90, $d0

SgbFadePaletteTable_08a7::
    db $00, $00, $40, $50, $94, $94, $e4, $e4

SgbFadePaletteObp0State18_08af::
    db $00, $00, $40, $40, $90, $90, $d0, $d0

Call_000_08b7::
    push bc
    push hl
    ldh a, [hTileStreamWritePos]
    ld e, a
    ld a, [TilemapBoxMaskTable_0902 + 0]
    and e
    ld [hl+], a
    ld a, [TilemapBoxMaskTable_0902 + 1]
    and e

jr_000_08c5::
    ld [hl+], a
    dec b
    jr nz, jr_000_08c5

    ld a, [TilemapBoxMaskTable_0902 + 2]
    and e
    ld [hl+], a
    pop hl
    ld a, $20
    rst $38
    pop bc
    ld d, b

jr_000_08d4::
    ld b, d
    push hl
    ld a, [TilemapBoxMaskTable_0902 + 3]
    and e
    ld [hl+], a
    ld a, [TilemapBoxMaskTable_0902 + 4]
    and e

jr_000_08df::
    ld [hl+], a
    dec b
    jr nz, jr_000_08df

    ld a, [TilemapBoxMaskTable_0902 + 5]
    and e
    ld [hl+], a
    pop hl
    ld a, $20
    rst $38
    dec c
    jr nz, jr_000_08d4

    ld a, [TilemapBoxMaskTable_0902 + 6]
    and e
    ld [hl+], a
    ld a, [TilemapBoxMaskTable_0902 + 7]
    and e

jr_000_08f8::
    ld [hl+], a
    dec d
    jr nz, jr_000_08f8

    ld a, [TilemapBoxMaskTable_0902 + 8]
    and e
    ld [hl+], a
    ret


TilemapBoxMaskTable_0902::
    db $f9, $f2, $f8, $f3, $00, $f4, $f7, $f5, $f6

UpdateCurrentGameState:: ; Per-frame state dispatcher, called from VBlank after input/sound.
; hGameState update map, current understanding:
;   0 -> bank 2 title/menu update
;   1 -> debug menu update
;   2 -> bank 1 gameplay update
;   3 -> bank 2 screen/update path
;   4 -> bank 2 screen/update path
;   5 -> bank 2 screen/update path
;   6 -> pause-ish handler: wait for START, then return to gameplay
    ldh a, [hGameState]
    rst $00

    ; hGameState update jump table. rst $00 consumes these words as data.
    dw UpdateGameState_TitleMenu ; 00: bank 2 title/menu update
    dw UpdateGameState_DebugMenu ; 01: debug menu update
    dw UpdateGameState_Gameplay ; 02: bank 1 gameplay update
    dw UpdateGameState_Bank2Screen0 ; 03: bank 2 screen/update path
    dw UpdateGameState_Bank2Screen1 ; 04: bank 2 screen/update path
    dw UpdateGameState_Bank2Screen2 ; 05: bank 2 screen/update path
    dw UpdateGameState_Pause ; 06: pause-ish handler
    dw UpdateGameState_FadeReturn ; 07: unused/variant update path
    dw UpdateGameState_TutorialMode ; 08: tutorial mode

UpdateGameState_TitleMenu::
	; hGameState == 00
    ld hl, $0202
    jp FarCallFromBankTable


UpdateGameState_DebugMenu::
	; hGameState == 01
    jp Jump_000_1716


UpdateGameState_Gameplay::
	; hGameState == 02
    ld hl, $0100
    jp FarCallFromBankTable


UpdateGameState_Bank2Screen0::
	; hGameState == 03
    ld hl, $0206
    jp FarCallFromBankTable


UpdateGameState_Bank2Screen1::
	; hGameState == 04
    ld hl, $020e
    jp FarCallFromBankTable


UpdateGameState_Bank2Screen2::
	; hGameState == 05
    ld hl, $0212
    jp FarCallFromBankTable


UpdateGameState_Pause::
	; hGameState == 06
    ld a, $93
    ld [wPaletteBGP], a
    ldh a, [hPrevOamPos]
    ldh [hOamWritePos], a
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

	; hGameState == 07
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $02
    ldh [hGameState], a
    ld a, $80
    ld [$dd9f], a
    ld a, $5e
    call PlaySound_Queue1
    ret


Call_000_0963::
    call InitSound
    ldh a, [hPlayerForm]
    cp $04
    ld a, $0c
    jp z, PlaySound_Queue3

    ldh a, [hStageIndex]
    cp $03
    ld a, $04
    jp c, PlaySound_Queue3

    ld a, $08
    jp PlaySound_Queue3


UpdateGameState_FadeReturn::
    jp Jump_000_09c9

UpdateGameState_TutorialMode::
	; hGameState == 08
    ld hl, HeaderLogo
    jp FarCallFromBankTable


InitCurrentGameState:: ; State init dispatcher, called with LCD off from ReinitCurrentState.
; hGameState init map, current understanding:
;   0 -> bank 2 title/menu init
;   1 -> debug menu init
;   2 -> bank 1 gameplay init
;   3 -> bank 2 screen init
;   4 -> bank 2 screen init
;   5 -> bank 2 screen init
;   6 -> no init
;   7 -> bank 1 gameplay init variant, then set wScreenPaletteId=$18
    ldh a, [hGameState]
    rst $00

    ; hGameState init jump table. rst $00 consumes these words as data.
    dw InitGameState_TitleMenu ; 00: bank 2 title/menu init
    dw InitGameState_DebugMenu ; 01: debug menu init
    dw InitGameState_Gameplay ; 02: bank 1 gameplay init
    dw InitGameState_Bank2Screen0 ; 03: bank 2 screen init
    dw InitGameState_Bank2Screen1 ; 04: bank 2 screen init
    dw InitGameState_Bank2Screen2 ; 05: bank 2 screen init
    dw InitGameState_NoInit ; 06: no init
    dw InitGameState_GameplayStage18Variant ; 07: bank 1 gameplay init variant
    dw InitGameState_UnusedStage4ThenBank1Init ; 08: unused/variant init path

InitGameState_TitleMenu::
    ld hl, $0200
    jp FarCallFromBankTable


InitGameState_DebugMenu::
    jp LoadDebugMenu


InitGameState_Gameplay::
    ld hl, $0102
    jp FarCallFromBankTable


InitGameState_Bank2Screen0::
    ld hl, $0204
    jp FarCallFromBankTable


InitGameState_Bank2Screen1::
    ld hl, $020c
    jp FarCallFromBankTable


InitGameState_Bank2Screen2::
    ld hl, $0210
    jp FarCallFromBankTable


InitGameState_NoInit::
    ret


InitGameState_GameplayStage18Variant::
    ld hl, $0102
    call FarCallFromBankTable
    ld a, $18
    ld [wScreenPaletteId], a
    ret


Jump_000_09c9::
    ld a, [$c0bd]
    or a
    jr z, jr_000_09e0

    call UpdateTransitionFadeWithLateSgbPalSet
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    xor a
    ld [$c0bd], a
    ld a, $02
    ldh [hGameState], a
    ret


jr_000_09e0::
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld a, $40
    ld [wFadeTransitionTimer], a
    ld a, $01
    ld [$c0bd], a
    ldh [hNeedsReset], a
    ret

InitGameState_UnusedStage4ThenBank1Init::
    ld a, $04
    ldh [hStageIndex], a
    ld hl, $0102
    call FarCallFromBankTable
    ld hl, $0106
    jp FarCallFromBankTable


jr_000_0a05::
    ldh a, [hSCX]
    ld b, a
    ldh a, [hSCY]
    ld c, a
    ldh a, [hPlayerX]
    sub b
    ldh [hPlayerScreenX], a
    ldh a, [hPlayerY]
    sub c
    ldh [hPlayerScreenY], a
    ret


UpdateCameraAndStreamMap:: ; Gameplay camera/scroll update and BG map streaming.
    ldh a, [hCollisionFlag]
    cp $ff
    jr z, jr_000_0a05

    xor a
    ldh [hCollisionFlag], a
    ldh a, [hPlayerScreenY]
    ld c, a
    ldh a, [hSCY]
    add c
    ld c, a
    ldh a, [hSCYHigh]
    adc $00
    ld b, a
    ld hl, hPlayerY
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call UpdateCameraScrollY
    ldh a, [hPlayerScreenX]
    ld c, a
    ldh a, [hSCX]
    add c
    ld c, a
    ldh a, [hSCXHigh]
    adc $00
    ld b, a
    ld hl, hPlayerX
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call UpdateCameraScrollX
    ldh a, [hCollisionFlag]
    rlca
    ret nc

    ld a, [$4000]
    push af
    ld a, $04
    ld [$2100], a
    ldh a, [hCollisionFlag]
    bit 6, a
    call nz, StreamBgColumnIfNeeded
    ldh a, [hCollisionFlag]
    bit 5, a
    call nz, StreamBgRowIfNeeded
    pop af
    ld [$2100], a
    ret


Jump_000_0a69::
    ld a, [$4000]
    push af
    ld a, $04
    ld [$2100], a
    ldh a, [hSCY]
    ld e, a
    ldh a, [hSCYHigh]
    ld d, a
    call QueueBgRowForWorldY
    pop af
    ld [$2100], a
    ret


UpdateCameraScrollX:: ; Adjust SCX toward player X, clamp to min/max, and request column streaming.
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc b
    ld h, a
    jp c, UpdateCameraScrollX_Left

    ld a, l
    or a
    ret z

    ld a, [wCameraScreenRightThreshold]
    ld b, a
    ld a, [wCameraScrollStepX]
    ld c, a
    ldh a, [hPlayerScreenX]
    add l
    ldh [hPlayerScreenX], a
    cp b
    ret c

    ret z

    ldh a, [hCollisionFlag]
    or $c0
    res 0, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, jr_000_0aa9

    ld a, c

jr_000_0aa9::
    ld b, a
    ld hl, wCameraScrollXMaxLo
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, hSCX
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    dec hl
    call CompareU16AtHLToDE
    jr nc, jr_000_0ac6

    ld a, [wCameraScreenRightThreshold]
    ldh [hPlayerScreenX], a
    ret


jr_000_0ac6::
    ld hl, wCameraScrollXMaxLo
    ld a, [hl+]
    ldh [hSCX], a
    ld a, [hl-]
    ldh [hSCXHigh], a
    ldh a, [hPlayerX]
    sub [hl]
    ldh [hPlayerScreenX], a
    ldh a, [hStageIndex]
    cp $02
    jr z, jr_000_0b07

    cp $01
    jr nz, jr_000_0ae4

    ld a, [wStage1CameraProfileIndex]
    cp $02
    ret nz

jr_000_0ae4::
    ldh a, [hPlayerState]
    or a
    ret nz

jr_000_0ae8::
    ldh a, [hCollisionFlag]
    cp $ff
    ret z

    ld a, $ff
    ldh [hCollisionFlag], a
    ld a, $ff
    ld [wStageBossCountdown], a
    ld hl, wPlayerXMinLo
    ldh a, [hSCX]
    ld [hl+], a
    ldh a, [hSCXHigh]
    ld [hl+], a
    call InitSound
    ld a, $60
    jp PlaySound_Queue3


jr_000_0b07::
    ld a, [wStage2TransitionStep]
    cp $06
    jr z, jr_000_0ae8

    ret


UpdateCameraScrollX_Left:: ; Camera/player moved left of deadzone; scroll toward wCameraScrollXMin.
    ld a, l
    cpl
    inc a
    ld l, a
    ret z

    ld a, [wCameraScreenLeftThreshold]
    ld b, a
    ld a, [wCameraScrollStepX]
    ld c, a
    ldh a, [hPlayerScreenX]
    sub l
    ldh [hPlayerScreenX], a
    cp b
    ret nc

    ldh a, [hCollisionFlag]
    or $c0
    set 0, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, jr_000_0b30

    ld a, c

jr_000_0b30::
    ld b, a
    ld hl, wCameraScrollXMinLo
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, hSCX
    ld a, [hl]
    sub b
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr c, jr_000_0b4f

    dec hl
    call CompareU16AtHLToDE
    jr c, jr_000_0b4f

    ld a, [wCameraScreenLeftThreshold]
    ldh [hPlayerScreenX], a
    ret


jr_000_0b4f::
    ld a, e
    ldh [hSCX], a
    ld a, d
    ldh [hSCXHigh], a
    ldh a, [hPlayerX]
    sub e
    ldh [hPlayerScreenX], a
    ret


UpdateCameraScrollY:: ; Adjust SCY toward player Y, clamp to 0/Y max, and request row streaming.
    ld a, l
    sub c
    ret z

    ld l, a
    ld a, h
    sbc b
    ld h, a
    jp c, UpdateCameraScrollY_Up

    ld a, [wCameraScreenBottomThreshold]
    ld b, a
    ld a, [wCameraScrollStepY]
    ld c, a
    ldh a, [hPlayerScreenY]
    add l
    ldh [hPlayerScreenY], a
    cp b
    ret c

    ret z

    ldh a, [hStageIndex]
    cp $02
    ret z

    ldh a, [hCollisionFlag]
    or $a0
    set 1, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, jr_000_0b87

    ld a, c

jr_000_0b87::
    ld b, a
    ld hl, wCameraScrollYMaxLo
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, hSCY
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    dec hl
    call CompareU16AtHLToDE
    jr nc, jr_000_0ba4

    ld a, [wCameraScreenBottomThreshold]
    ldh [hPlayerScreenY], a
    ret


jr_000_0ba4::
    ld hl, wCameraScrollYMaxLo
    ld a, [hl+]
    ldh [hSCY], a
    ld a, [hl-]
    ldh [hSCYHigh], a
    ldh a, [hPlayerY]
    sub [hl]
    ldh [hPlayerScreenY], a
    ret


UpdateCameraScrollY_Up:: ; Camera/player moved above deadzone; scroll upward unless stage 2 overrides Y scrolling.
    ld a, [wCameraScreenTopThreshold]
    ld b, a
    ld a, [wCameraScrollStepY]
    ld c, a
    ld a, l
    cpl
    inc a
    ld l, a
    ldh a, [hPlayerScreenY]
    sub l
    ldh [hPlayerScreenY], a
    cp b
    ret nc

    ldh a, [hStageIndex]
    cp $02
    ret z

    ldh a, [hCollisionFlag]
    or $a0
    res 0, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, jr_000_0bd8

    ld a, c

jr_000_0bd8::
    ld b, a
    ld hl, hSCY
    ld a, [hl]
    sub b
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr c, jr_000_0beb

    ld a, [wCameraScreenTopThreshold]
    ldh [hPlayerScreenY], a
    ret


jr_000_0beb::
    xor a
    ldh [hSCY], a
    ldh [hSCYHigh], a
    ldh a, [hPlayerY]
    ldh [hPlayerScreenY], a
    ret


jr_000_0bf5::
    ldh a, [hCollisionFlag]
    cp $ff
    ret z

    ld hl, hCollisionFlag
    res 5, [hl]
    ret


StreamBgRowIfNeeded:: ; If vertical scroll crossed an 8px boundary, queue one BG row update.
    call GetStreamRowWorldY
    ldh a, [hStreamedRowY]
    and $f8
    ld b, a
    ld a, e
    and $f8
    cp b
    jr z, jr_000_0bf5

    ldh [hStreamedRowY], a

QueueBgRowForWorldY:: ; Queue one 32-tile BG row for world Y in DE using current SCX.
    ld a, e
    and $f8
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld bc, $9800
    add hl, bc
    ld b, h
    ld c, l
    call GetVramQueueTail
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, $20
    ld [hl+], a
    push hl
    ld bc, $0020
    add hl, bc
    ld [hl], $00
    pop hl
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ldh a, [hSCX]
    srl a
    srl a
    srl a
    ld c, a
    ld b, $00
    add hl, bc
    ldh a, [hSCXHigh]
    ld b, a
    ldh a, [hSCX]
    and $f8
    ld c, a
    ld a, $20
    ldh [hTileStreamCount], a
    ld a, l
    ldh [hTileStreamWritePos], a

jr_000_0c51::
    push de
    call GetStageLayoutTileAtWorldPixel
    pop de

jr_000_0c56::
    ld a, [hl]
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    bit 3, c
    jr z, jr_000_0c63

    set 0, l

jr_000_0c63::
    bit 3, e
    jr z, jr_000_0c69

    set 1, l

jr_000_0c69::
    ldh a, [hStageMetatileTableLo]
    add l
    ld l, a
    ldh a, [hStageMetatileTableHi]
    adc h
    ld h, a
    ld a, [hl]
    ld hl, hTileStreamWritePos
    inc [hl]
    ld l, [hl]
    ld h, $c1
    dec hl
    ld [hl], a
    pop hl
    bit 3, c
    jr z, jr_000_0c81

    inc hl

jr_000_0c81::
    ldh a, [hTileStreamCount]
    dec a
    ldh [hTileStreamCount], a
    ret z

    ld a, $08
    add c
    ld c, a
    jr nc, jr_000_0c56

    inc b
    ldh a, [hTileStreamWritePos]
    sub $20
    ldh [hTileStreamWritePos], a
    jr jr_000_0c51

jr_000_0c96::
    ldh a, [hCollisionFlag]
    cp $ff
    ret z

    ld hl, hCollisionFlag
    res 6, [hl]
    ret


StreamBgColumnIfNeeded:: ; If horizontal scroll crossed an 8px boundary, queue one BG column update.
    call GetStreamColumnWorldX
    ldh a, [hStreamedColumnX]
    and $f8
    ld d, a
    ld a, c
    and $f8
    cp d
    jr z, jr_000_0c96

    ldh [hStreamedColumnX], a

QueueBgColumnForWorldX:: ; Queue one 32-tile BG column for world X in BC using current SCY.
    call GetVramQueueTail
    ld a, $98
    ld [hl+], a
    ld a, c
    and $f8
    rrca
    rrca
    rrca
    ld [hl+], a
    ld a, $a0
    ld [hl+], a
    push hl
    ld de, $0020
    add hl, de
    ld [hl], $00
    pop hl
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ldh a, [hSCY]
    srl a
    srl a
    srl a
    ld e, a
    ld d, $00
    add hl, de
    ldh a, [hSCYHigh]
    ld d, a
    ldh a, [hSCY]
    and $f8
    ld e, a
    ld a, $20
    ldh [hTileStreamCount], a
    ld a, l
    ldh [hTileStreamWritePos], a

jr_000_0cea::
    push de
    call GetStageLayoutTileAtWorldPixel
    pop de

jr_000_0cef::
    ld a, [hl]
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    bit 3, c
    jr z, jr_000_0cfc

    set 0, l

jr_000_0cfc::
    bit 3, e
    jr z, jr_000_0d02

    set 1, l

jr_000_0d02::
    ldh a, [hStageMetatileTableLo]
    add l
    ld l, a
    ldh a, [hStageMetatileTableHi]
    adc h
    ld h, a
    ld a, [hl]
    ld hl, hTileStreamWritePos
    inc [hl]
    ld l, [hl]
    ld h, $c1
    dec hl
    ld [hl], a
    pop hl
    bit 3, e
    jr z, jr_000_0d21

    ld a, $10
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a

jr_000_0d21::
    ldh a, [hTileStreamCount]
    dec a
    ldh [hTileStreamCount], a
    ret z

    ld a, e
    add $08
    ld e, a
    jr nc, jr_000_0cef

    inc d
    ldh a, [hTileStreamWritePos]
    sub $20
    ldh [hTileStreamWritePos], a
    jr jr_000_0cea

GetStageLayoutTileAtWorldPixel:: ; Return layout metatile id for world pixel coords BC=X, DE=Y.
                              ; Uses virtual page map at wStageLayoutPageHighTable: row*14+col -> physical page id.
    ld a, d
    or a
    jr z, jr_000_0d40

    xor a

jr_000_0d3b::
    add $0e
    dec d
    jr nz, jr_000_0d3b

jr_000_0d40::
    add b
    ld hl, wStageLayoutPageHighTable
    add l
    ld l, a
    ld a, h
    adc d
    ld h, a
    ld a, c
    and $f0
    swap a
    ld d, a
    ld a, e
    and $f0
    or d
    ld e, a
    ld d, [hl]
    ld hl, wStageLayoutMap
    add hl, de
    ld a, [hl]
    ret


GetStreamColumnWorldX:: ; Return world X in BC for the column to stream, based on hCollisionFlag direction.
    ldh a, [hCollisionFlag]
    bit 0, a
    jr nz, jr_000_0d6c

    ldh a, [hSCX]
    add $e8
    ld c, a
    ldh a, [hSCXHigh]
    adc $00
    ld b, a
    ret


jr_000_0d6c::
    ldh a, [hSCX]
    ld c, a
    ldh a, [hSCXHigh]
    ld b, a
    ret


GetStreamRowWorldY:: ; Return world Y in DE for the row to stream, based on hCollisionFlag direction.
    ldh a, [hCollisionFlag]
    bit 1, a
    jr z, jr_000_0d84

    ldh a, [hSCY]
    add $e8
    ld e, a
    ldh a, [hSCYHigh]
    adc $00
    ld d, a
    ret


jr_000_0d84::
    ldh a, [hSCY]
    ld e, a
    ldh a, [hSCYHigh]
    ld d, a
    ret


RedrawVisibleBgMapColumns:: ; Rebuild visible BG map columns from current SCX/SCY, used after scroll/init.
    ld a, [$4000]
    push af
    ld a, $04
    ld [$2100], a
    ld hl, hSCX
    ld a, [hl+]
    ld c, a
    ld b, [hl]
    xor a

jr_000_0d9b::
    push af
    push bc
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    call QueueBgColumnForWorldX
    ld de, wVramQueue
    call jr_000_0347
    xor a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    pop bc
    pop af
    add $08
    jr nz, jr_000_0d9b

    call ApplyScrollRegs
    pop af
    ld [$2100], a
    ret


InitGameplayHudAndWindow:: ; Initialize gameplay window/HUD; WY=$80 means bottom 16px is status area.
    call Call_000_0307
    ld a, $07
    ldh [hWX], a
    ldh [rWX], a
    ld a, $80
    ldh [hWY], a
    ldh [rWY], a
    call QueueInitialHealthHud
    ld a, $df
    ld [$9c0b], a
    ld a, $e0
    ld [$9c2b], a
    ld de, HucIconLife
    ld hl, $9c0f
    ld bc, $0202
    call jr_000_05f7
    call QueuePlayerFormHudIcon
    call QueueBonusCounterHudDigits
    call QueueLivesHudDigits
    ld de, wVramQueue
    call jr_000_0347
    xor a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    ret

HucIconLife:
    db $e5, $e6, $e7, $e8

QueuePlayerFormHudIcon:: ; Queue 2x2 HUD icon for current player form.
    ldh a, [hPlayerForm]
    add a
    add a
    ld de, HudIconTileID
    rst $30
    ld hl, $9c08
    ld bc, $0202
    jp QueueTilemapRect

HudIconTileID:
    db $fa, $fb, $fc, $fd ;Empty
	db $d0, $d1, $d2, $d3 ;Flying squirrel
	db $dc, $dd, $d2, $de ;Cockroach
	db $d8, $d9, $da, $db ;Chicken
    db $d4, $d5, $d6, $d7 ;Action Kamen

QueueInitialHealthHud:: ; Draw initial health hearts during HUD init.
    ldh a, [hPlayerHealth]
    ldh [hTileStreamWritePos], a
    or a
    ret z

jr_000_0e2d::
    call QueueOneHealthHeartHudTile
    ldh a, [hTileStreamWritePos]
    dec a
    ldh [hTileStreamWritePos], a
    jr nz, jr_000_0e2d

    ret


QueueOneHealthHeartHudTile:: ; Queue one 2x2 heart tile group at the HUD position for health index.
    ldh a, [hTileStreamWritePos]
    dec a
    ld hl, HudHealthIconPos
    rst $20
    ld de, HudIconHealth
    ld bc, $0202
    jp jr_000_05f7


QueueHealthHudAfterGain:: ; Clear pending health-gain flag and redraw gained heart.
    ld a, [wPendingVramUpdates]
    res 0, a
    ld [wPendingVramUpdates], a
    ldh a, [hPlayerHealth]
    dec a
    ld hl, HudHealthIconPos
    rst $20
    ld de, HudIconHealth
    ld bc, $0202
    jp QueueTilemapRect

HudHealthIconPos::
    dw $9c01, $9c03, $9c05
HudIconHealth::	
	db $e1, $e2, $e3, $e4
HudIconHealthEmpty::	
	db $00, $00, $00, $00

QueueHealthHudAfterDamage:: ; Clear pending health-loss flag and redraw current health heart state.
    ld a, [wPendingVramUpdates]
    res 1, a
    ld [wPendingVramUpdates], a

QueueCurrentHealthHudTile:: ; Queue current health heart tile group.
    ldh a, [hPlayerHealth]
    ld hl, HudHealthIconPos
    rst $20
    ld de, HudIconHealthEmpty
    ld bc, $0202
    jp QueueTilemapRect


QueueBonusCounterHudDigits:: ; Queue two-digit bonus counter at HUD $9c2c.
    ld bc, $9c2c
    ldh a, [hBonusCounter]
    jr jr_000_0e91

QueueLivesHudDigits:: ; Queue two-digit lives counter at HUD $9c31.
    ld bc, $9c31
    ldh a, [hPlayerLives]

jr_000_0e91::
    ld d, a
    call GetVramQueueTail
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, $02
    ld [hl+], a
    ld a, d
    push hl
    call SplitDecimalTensOnes
    pop hl
    ldh a, [$ffca]
    call HudDigitToTileId
    ld [hl+], a
    ldh a, [hTileStreamWritePos]
    call HudDigitToTileId
    ld [hl+], a
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $05
    ldh [hVramQueuePos], a
    ret


HudDigitToTileId:: ; Convert decimal digit 0-9 to HUD tile id $f0-$f9.
    add $f0
    ret


AddBonusCounter:: ; Add A to hBonusCounter; 30 bonus points awards an extra life.
    ld hl, hBonusCounter
    add [hl]
    cp $1e
    jr nc, jr_000_0ec7

jr_000_0ec2::
    ldh [hBonusCounter], a
    jp QueueBonusCounterHudDigits


jr_000_0ec7::
    sub $1e
    call jr_000_0ec2
    jr AddExtraLife

    ld b, a
    ldh a, [hBonusCounter]
    sub b
    jr nc, jr_000_0ec2

    xor a
    jr jr_000_0ec2

AddPlayerHealth:: ; Add A to hPlayerHealth, capped at 3.
    ld a, [wPendingVramUpdates]
    set 0, a
    ld [wPendingVramUpdates], a
    ldh a, [hPlayerHealth]
    inc a
    cp $04
    jr c, jr_000_0ee8

    ld a, $03

jr_000_0ee8::
    ldh [hPlayerHealth], a
    ret


SubtractPlayerHealthAndMarkHudDirty:: ; Decrement health and request health HUD redraw.
    ld a, [wPendingVramUpdates]
    set 1, a
    ld [wPendingVramUpdates], a
    ldh a, [hPlayerHealth]
    dec a
    ldh [hPlayerHealth], a
    ret


AddExtraLife:: ; Award one extra life and update the HUD.
    ld a, $46
    call PlaySound_Queue1

Call_000_0efe::
    ld hl, hPlayerLives
    inc [hl]
    ld a, [hl]
    cp $64
    jp c, QueueLivesHudDigits

    dec [hl]
    jp QueueLivesHudDigits


    ret


InitSound::
    ld a, $80
    ldh [rNR52], a
    ld [$dd9f], a
    xor a
    ldh [rNR51], a
    ld [$dd97], a
    ld a, $77
    ldh [rNR50], a
    ld hl, $dd00
    ld b, $06
    ld a, $ff

jr_000_0f25::
    ld [hl], a
    ld de, $0017
    add hl, de
    ld [hl], a
    ld de, $0002
    add hl, de
    dec b
    jr nz, jr_000_0f25

PlaySound_Queue3::
    call PlaySound

PlaySound_Queue2::
    call PlaySound

PlaySound_Queue1::
    call PlaySound

PlaySound::
    push bc
    push de
    push hl
    ld [$dd9e], a
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld de, $6201
    add hl, de
    push hl
    pop de
    ld a, [$4000]
    push af
    ld a, $07
    ld [$2100], a
    ld a, [de]
    inc de
    ld c, a
    ld b, $00
    ld hl, $dd00
    add hl, bc
    ld a, [hl]
    cp $ff
    jr z, jr_000_0f80

    inc hl
    ld a, [hl-]
    ld b, $ee
    and $03
    jr z, jr_000_0f79

    ld b, $dd
    cp $01
    jr z, jr_000_0f79

    ld b, $bb
    cp $02
    jr z, jr_000_0f79

    ld b, $77

jr_000_0f79::
    ld a, [$dd97]
    and b
    ld [$dd97], a

jr_000_0f80::
    xor a
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl], a
    ld de, $0014
    add hl, de
    xor a
    ld [hl], a
    pop af
    ld [$2100], a
    ld a, [$dd9e]
    inc a
    pop hl
    pop de
    pop bc
    ret


UpdateSound::
    xor a
    ld [$dd9d], a
    ld [$dd96], a
    ld hl, $dd9c
    inc [hl]
    ld hl, $dd00

Jump_000_0fab::
    push hl
    ld de, $ffe6
    ld b, $19

jr_000_0fb1::
    ld a, [hl+]
    ld [de], a
    inc e
    dec b
    jr nz, jr_000_0fb1

    ldh a, [$ffe7]
    and $03
    ld [$dd98], a
    ld b, a
    add a
    add a
    add b
    ld [$dd9b], a
    inc b
    ld a, $88

jr_000_0fc8::
    rlca
    dec b
    jr nz, jr_000_0fc8

    ld [$dd99], a
    ld [$dd9a], a
    ld a, [$dd9f]
    bit 7, a
    jr nz, jr_000_0ff6

    ld a, [$dd9d]
    and $fe
    jr z, jr_000_0ff6

    ld a, [$dd99]
    ld b, a
    ld a, [$dd96]
    and b
    jr nz, jr_000_1056

    ld a, b
    cpl
    ld b, a
    ld a, [$dd97]
    and b
    ld [$dd97], a
    jr jr_000_1056

jr_000_0ff6::
    ldh a, [$ffe6]
    ld b, a
    ldh a, [$fffd]
    or b
    and a
    jr z, jr_000_106d

    ldh a, [$fffd]
    and b
    cp $ff
    jr z, jr_000_1056

    call Call_000_13a8
    call Call_000_140d
    ldh a, [$fff2]
    ld b, a
    ldh a, [$fff3]
    inc a
    cp b
    jr c, jr_000_1016

    ld a, b

jr_000_1016::
    ldh [$fff3], a
    ld hl, $ffeb
    dec [hl]
    ld a, [hl]
    bit 7, a
    jr z, jr_000_103e

    ldh a, [$ffea]
    and $0f
    ld [hl], a
    call Call_000_1369
    ldh a, [$fffc]
    and a
    jr z, jr_000_1031

    dec a
    ldh [$fffc], a

jr_000_1031::
    ld hl, $ffed
    dec [hl]
    jr nz, jr_000_103e

jr_000_1037::
    ldh a, [$fffb]
    ldh [$fffc], a
    call Jump_000_1110

jr_000_103e::
    ld a, [$dd99]
    ld b, a
    ld a, [$dd96]
    or b
    ld [$dd96], a
    pop hl
    push hl
    ld de, $ffe6
    ld b, $19

jr_000_1050::
    ld a, [de]
    ld [hl+], a
    inc e
    dec b
    jr nz, jr_000_1050

jr_000_1056::
    pop hl
    ld de, $0019
    add hl, de
    ld a, [$dd9d]
    inc a
    ld [$dd9d], a
    cp $06
    jp c, Jump_000_0fab

    ld a, [$dd97]
    ldh [rNR51], a
    ret


jr_000_106d::
    ldh a, [$ffe8]
    ld l, a
    ldh a, [$ffe9]
    ld h, a
    ld a, [hl+]
    and $0f
    ldh [$ffeb], a
    ld d, a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_10ab

    ld a, [hl+]
    rrca
    rrca
    and $c0
    or d

jr_000_1086::
    ldh [$ffea], a
    ld a, [hl+]
    swap a
    ldh [$ffec], a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_10b1

    ld a, [hl+]
    ldh [$ffee], a

jr_000_1097::
    xor a
    ldh [$ffef], a
    ldh [$fff0], a
    ldh [$fff1], a
    ldh [$fff4], a
    ldh [$fffd], a
    dec a
    ldh [$fffa], a
    ld a, $02
    ldh [$ffe6], a
    jr jr_000_1037

jr_000_10ab::
    ld a, [hl+]
    ldh [$fff2], a
    ld a, d
    jr jr_000_1086

jr_000_10b1::
    xor a
    ldh [rNR30], a
    ld a, [hl]
    ld hl, SoundWavePatterns_10d0
    and $03
    jr z, jr_000_10c3

    ld de, $0010

jr_000_10bf::
    add hl, de
    dec a
    jr nz, jr_000_10bf

jr_000_10c3::
    ld de, _AUD3WAVERAM
    ld b, $10

jr_000_10c8::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_000_10c8

    jr jr_000_1097

SoundWavePatterns_10d0:: ; 4 wave RAM patterns, 16 bytes each.
    db $00, $01, $12, $35, $8a, $cd, $ee, $ff, $ff, $fe, $ed, $ca, $85, $32, $11, $00
    db $01, $23, $45, $67, $89, $ab, $cd, $ef, $fe, $dc, $ba, $98, $76, $54, $32, $10
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ee, $dd, $cc, $bb, $aa, $99, $88, $77, $66, $55, $44, $33, $22, $11, $00

Jump_000_1110::
    ldh a, [$ffe6]
    ld l, a
    ldh a, [$fffd]
    ld h, a
    add hl, hl
    ldh a, [$ffe8]
    ld e, a
    ldh a, [$ffe9]
    ld d, a
    add hl, de

jr_000_111e::
    ldh a, [$ffe6]
    add $01
    ldh [$ffe6], a
    ldh a, [$fffd]
    adc $00
    ldh [$fffd], a
    ld a, [hl+]
    cp $d0
    jr nc, jr_000_1156

    cp $b0
    jr nc, jr_000_1194

    cp $a0
    jp nc, Jump_000_11d3

    jp Jump_000_1296


jr_000_113b::
    cp $fd
    jr nz, jr_000_114a

    ldh a, [$ffe6]
    ldh [$fff9], a
    ldh a, [$fffd]
    ldh [$fffe], a

jr_000_1147::
    inc hl
    jr jr_000_111e

jr_000_114a::
    cp $ff
    jr nz, jr_000_1147

    ldh [$ffe6], a
    ldh [$fffd], a
    call Call_000_14a8
    ret


jr_000_1156::
    cp $f0
    jr nc, jr_000_113b

    cp $e0
    jr nc, jr_000_1162

    and $0f
    jr jr_000_1166

jr_000_1162::
    and $0f
    cpl
    inc a

jr_000_1166::
    ld b, a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_1176

    ld a, b
    ldh [$fff4], a
    ld a, [hl]
    ldh [$fff5], a
    ldh [$fff6], a

jr_000_1176::
    inc hl
    jr jr_000_111e

jr_000_1179::
    and $0f
    ld b, a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_1191

    ldh a, [$ffec]
    and $0f
    jr nz, jr_000_1191

    ld a, [hl]
    ldh [$fff2], a
    ld a, b
    swap a
    ldh [$fff1], a

jr_000_1191::
    inc hl
    jr jr_000_111e

jr_000_1194::
    cp $c0
    jr nc, jr_000_1179

    and $0f
    jr z, jr_000_11bf

    ld e, a
    ld a, [hl]
    and a
    jr nz, jr_000_11b1

    ldh a, [$ffef]
    dec a
    ldh [$ffef], a
    jr z, jr_000_11d0

    bit 7, a
    jr z, jr_000_11bf

    ld a, e
    ldh [$ffef], a
    jr jr_000_11bf

jr_000_11b1::
    ldh a, [$fff0]
    dec a
    ldh [$fff0], a
    jr z, jr_000_11d0

    bit 7, a
    jr z, jr_000_11bf

    ld a, e
    ldh [$fff0], a

jr_000_11bf::
    ld a, [hl]
    and a
    jr nz, jr_000_11c5

    ldh a, [$fff9]

jr_000_11c5::
    ldh [$ffe6], a
    jr nz, jr_000_11cd

    ldh a, [$fffe]
    jr jr_000_11ce

jr_000_11cd::
    xor a

jr_000_11ce::
    ldh [$fffd], a

jr_000_11d0::
    jp Jump_000_1110


Jump_000_11d3::
    cp $a0
    jr nz, jr_000_11e2

    ld a, [hl+]
    swap a
    ldh [$ffec], a
    call jr_000_13df
    jp jr_000_111e


jr_000_11e2::
    cp $a1
    jr nz, jr_000_11ec

    ld a, [hl+]
    ldh [$ffee], a
    jp jr_000_111e


jr_000_11ec::
    cp $a2
    jr nz, jr_000_120d

    ld a, [$dd98]
    cp $02
    jr z, jr_000_1207

    ld a, [hl+]
    rrca
    rrca
    and $c0
    ld d, a
    ldh a, [$ffea]
    and $3f
    or d
    ldh [$ffea], a
    jp jr_000_111e


jr_000_1207::
    ld a, [hl+]
    ldh [$fff2], a
    jp jr_000_111e


jr_000_120d::
    cp $a3
    jr nz, jr_000_1234

    ld a, [hl+]
    bit 7, a
    jr nz, jr_000_122e

    ld b, a
    and $0f
    add a
    ldh [$fffb], a
    ldh [$fffc], a
    ld a, b
    and $70
    ld e, a
    ldh a, [$ffe7]
    and $0f
    or e
    or $80

jr_000_1229::
    ldh [$ffe7], a
    jp jr_000_111e


jr_000_122e::
    ldh a, [$ffe7]
    and $0f
    jr jr_000_1229

jr_000_1234::
    cp $a5
    jr nz, jr_000_1246

    ld a, [hl+]
    cp $01
    jr nz, jr_000_1241

    ldh a, [$fffa]
    swap a

jr_000_1241::
    ldh [$fffa], a
    jp jr_000_111e


jr_000_1246::
    cp $a6
    jr nz, jr_000_1250

    ld a, [hl+]
    ldh [rNR50], a
    jp jr_000_111e


jr_000_1250::
    cp $a7
    jr nz, jr_000_125a

    ld a, [hl]
    ldh [$ffed], a
    jp Jump_000_1348


jr_000_125a::
    cp $ae
    jr nz, jr_000_126a

    ld a, [hl+]
    and $10
    ld b, a
    ldh a, [$ffea]
    or b
    ldh [$ffea], a
    jp jr_000_111e


jr_000_126a::
    cp $af
    jr nz, jr_000_127e

    ld a, [hl+]
    and $0f
    ldh [$ffeb], a
    ld b, a
    ldh a, [$ffea]
    and $f0
    or b
    ldh [$ffea], a
    jp jr_000_111e


jr_000_127e::
    inc hl
    jp jr_000_111e


SoundNoiseNoteIndexTable_1282:: ; note index table used by channel 4/noise playback.
    db $00, $01, $11, $12, $14, $23, $07, $15, $17, $32, $33, $60, $61, $45, $53, $62

jr_000_1292::
    call Call_000_14a8
    ret


Jump_000_1296::
    ld b, a
    ld a, [hl]
    ldh [$ffed], a
    ld a, [$dd98]
    cp $03
    jr nz, jr_000_12bd

    ld a, b
    cp $1f
    jr z, jr_000_1292

    cp $10
    jr nc, jr_000_12b8

    ld hl, SoundNoiseNoteIndexTable_1282
    add l
    ld l, a
    ld a, h
    adc $00
    ld h, a
    ld l, [hl]
    ld h, $00
    jr jr_000_12f0

jr_000_12b8::
    ld l, a
    ld h, $00
    jr jr_000_12f0

jr_000_12bd::
    ld a, b
    and $0f
    cp $0c
    jr nc, jr_000_1292

    add a
    ld e, a
    ldh a, [$ffea]
    and $10
    jr z, jr_000_12d0

    ld a, e
    add $18
    ld e, a

jr_000_12d0::
    ld d, $00
    ld hl, SoundFrequencyTable_14c3
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, b
    swap a
    and $0f
    jr z, jr_000_12e8

    ld b, a

jr_000_12e1::
    srl h
    rr l
    dec b
    jr nz, jr_000_12e1

jr_000_12e8::
    ld a, $00
    sub l
    ld l, a
    ld a, $08
    sbc h
    ld h, a

jr_000_12f0::
    xor a
    ldh [$fff3], a
    call Call_000_14b8
    ld a, [$dd98]
    cp $02
    jr nz, jr_000_1301

    ld a, $80
    ldh [rNR30], a

jr_000_1301::
    push hl
    call Call_000_13d1
    pop hl
    ld a, [$dd98]
    and a
    ldh a, [$ffee]
    ld c, $10
    call z, jr_000_13ed
    ld a, l
    ld c, $13
    call jr_000_13ed
    ld a, l
    cp $02
    jr c, jr_000_1324

    cp $fe
    jr c, jr_000_1326

    ld a, $fd
    jr jr_000_1326

jr_000_1324::
    ld a, $02

jr_000_1326::
    ldh [$fff7], a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_135b

    cp $02
    jr nc, jr_000_133c

    ldh a, [$ffea]
    and $c0
    ld c, $11
    call jr_000_13ed

jr_000_133c::
    ld a, h
    and $07
    or $80

jr_000_1341::
    ldh [$fff8], a
    ld c, $14
    call jr_000_13ed

Jump_000_1348::
    ld a, [$dd9a]
    ld b, a
    cpl
    ld c, a
    ldh a, [$fffa]
    and b
    ld b, a
    ld a, [$dd97]
    and c
    or b
    ld [$dd97], a
    ret


jr_000_135b::
    xor a
    ldh [rNR31], a
    ldh a, [rNR52]
    and $04
    jr z, jr_000_133c

    ld a, h
    and $07
    jr jr_000_1341

Call_000_1369::
    ld a, [$dd98]
    cp $02
    ret z

    ldh a, [$fff4]
    and a
    ret z

    ld hl, $fff6
    dec [hl]
    ret nz

    ldh a, [$ffec]
    swap a
    cp $10
    ret nc

    and $0f
    ld b, a
    ldh a, [$fff5]
    ldh [$fff6], a
    ld hl, $fff4
    ld a, [hl]
    bit 7, a
    jr nz, jr_000_139c

    dec [hl]
    ld a, b
    cp $0f
    ret z

    ldh a, [$ffec]
    add $10
    ldh [$ffec], a
    jp jr_000_13df


jr_000_139c::
    inc [hl]
    ld a, b
    and a
    ret z

    ldh a, [$ffec]
    sub $10
    ldh [$ffec], a
    jr jr_000_13df

Call_000_13a8::
    call Call_000_14b8
    ld a, [$dd98]
    cp $03
    ret z

    ldh a, [$fffc]
    and a
    ret nz

    ldh a, [$ffe7]
    bit 7, a
    ret z

    and $70
    ld b, a
    ld a, [$dd9c]
    and $0f
    or b
    ld e, a
    ld d, $00
    ld hl, SoundVibratoOffsetTable_1683
    add hl, de
    ldh a, [$fff7]
    add [hl]
    ld c, $13
    jr jr_000_13ed

Call_000_13d1::
    ld a, [$dd98]
    cp $02
    jr z, jr_000_13f6

    ldh a, [$fff1]
    and a
    jr nz, jr_000_141b

    ldh a, [$ffec]

jr_000_13df::
    ld c, a
    call Call_000_14b8
    ld a, c
    ld c, $12
    call jr_000_13ed
    ldh a, [$fff8]
    ld c, $14

jr_000_13ed::
    ld b, a
    ld a, [$dd9b]
    add c
    ld c, a
    ld a, b
    ldh [c], a
    ret


jr_000_13f6::
    ldh a, [$ffec]
    ld c, $12
    jr jr_000_13ed

jr_000_13fc::
    ld a, e
    srl a
    add $02
    swap a
    ld hl, $ffec
    cp [hl]
    ret c

    and $60
    ldh [rNR32], a
    ret


Call_000_140d::
    call Call_000_14b8
    ld a, [$dd98]
    cp $02
    jr z, jr_000_141b

    ldh a, [$fff1]
    and a
    ret z

jr_000_141b::
    ldh a, [$fff2]
    and a
    ret z

    ld e, $00
    ld c, a
    ldh a, [$fff3]
    ld b, $04

jr_000_1426::
    add a
    cp c
    jr c, jr_000_142b

    sub c

jr_000_142b::
    ccf
    rl e
    dec b
    jr nz, jr_000_1426

    ld a, [$dd98]
    cp $02
    jr z, jr_000_13fc

    ldh a, [$fff1]
    or e
    ld e, a
    ld d, $00
    ld hl, SoundPitchEnvelopeTable_14e3
    add hl, de
    ldh a, [$ffec]
    swap a
    ld e, a
    ld a, [hl]
    ld h, a
    and $f0
    or e
    ld e, a
    bit 2, h
    jr nz, jr_000_1471

    inc b
    ld a, c
    swap a
    and $0f
    jr z, jr_000_1471

    ld b, a
    bit 3, e
    jr nz, jr_000_146a

    sla b
    bit 2, e
    jr nz, jr_000_146a

    sla b
    bit 1, e
    jr z, jr_000_146f

jr_000_146a::
    ld a, b
    cp $08
    jr c, jr_000_1471

jr_000_146f::
    ld b, $00

jr_000_1471::
    ld a, h
    and $08
    or b
    ld b, a
    bit 0, h
    jr z, jr_000_148f

    ld hl, SoundDutyEnvelopeTable_1583
    add hl, de
    ld a, [hl]
    or b
    ld b, a
    ld c, $12
    ld a, [$dd9b]
    add c
    ld c, a
    ldh a, [c]
    cp b
    ret z

    ld a, b
    jp jr_000_13df


jr_000_148f::
    ld c, $12
    ld a, [$dd9b]
    add c
    ld c, a
    ldh a, [c]
    and $08
    ld l, a
    ld a, h
    and $08
    cp l
    ret z

    ld hl, SoundDutyEnvelopeTable_1583
    add hl, de
    ld a, [hl]
    or b
    jp jr_000_13df


Call_000_14a8::
    call Call_000_14b8
    ld a, [$dd99]
    cpl
    ld b, a
    ld a, [$dd97]
    and b
    ld [$dd97], a
    ret


Call_000_14b8::
    ld a, [$dd99]
    ld b, a
    ld a, [$dd96]
    and b
    ret z

    pop af
    ret


SoundFrequencyTable_14c3:: ; base pitch period table / sound driver data anchor.
    db $d4, $07, $64, $07, $f9, $06, $95, $06, $37, $06, $dd, $05, $89, $05, $3a, $05
    db $f0, $04, $a8, $04, $65, $04, $26, $04, $9c, $07, $2e, $07, $c7, $06, $66, $06

SoundPitchEnvelopeTable_14e3:: ; pitch/envelope lookup data used by Call_000_140d.
    db $0a, $06, $b3, $05, $61, $05, $15, $05, $cc, $04, $86, $04, $45, $04, $08, $04
    db $f1, $e0, $d0, $c0, $b0, $a0, $90, $80, $70, $60, $50, $40, $30, $20, $10, $05
    db $09, $18, $28, $38, $48, $58, $68, $78, $88, $98, $a8, $b8, $c8, $d8, $e8, $f5
    db $f1, $e0, $d0, $c0, $b0, $a0, $90, $85, $89, $98, $a8, $b8, $c8, $d8, $e8, $f5
    db $89, $98, $a8, $b8, $c8, $d8, $e8, $f5, $f1, $e0, $d0, $c0, $b0, $a0, $90, $85
    db $f1, $d1, $b1, $91, $71, $51, $31, $11, $e1, $c1, $a1, $81, $61, $41, $21, $05
    db $f1, $e0, $d0, $c5, $c9, $d8, $e1, $d0, $c0, $a1, $81, $61, $41, $21, $10, $05
    db $f1, $d1, $b1, $90, $a9, $b1, $91, $71, $60, $50, $40, $30, $20, $15, $11, $05
    db $55, $54, $54, $54, $54, $54, $59, $65, $69, $78, $88, $a9, $c9, $f1, $b1, $85
    db $f5, $f1, $a1, $89, $f8, $f1, $a1, $81, $75, $74, $71, $65, $64, $61, $55, $55

SoundDutyEnvelopeTable_1583:: ; duty/volume envelope lookup data used by Call_000_140d.
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10
    db $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10, $20, $20, $20, $20
    db $00, $00, $00, $10, $10, $10, $10, $10, $20, $20, $20, $20, $20, $30, $30, $30
    db $00, $00, $10, $10, $10, $10, $20, $20, $20, $20, $30, $30, $30, $30, $40, $40
    db $00, $00, $10, $10, $10, $20, $20, $20, $30, $30, $30, $40, $40, $40, $50, $50
    db $00, $00, $10, $10, $20, $20, $20, $30, $30, $40, $40, $40, $50, $50, $60, $60
    db $00, $00, $10, $10, $20, $20, $30, $30, $40, $40, $50, $50, $60, $60, $70, $70
    db $00, $10, $10, $20, $20, $30, $30, $40, $40, $50, $50, $60, $60, $70, $70, $80
    db $00, $10, $10, $20, $20, $30, $40, $40, $50, $50, $60, $70, $70, $80, $80, $90
    db $00, $10, $10, $20, $30, $30, $40, $50, $50, $60, $70, $70, $80, $90, $90, $a0
    db $00, $10, $10, $20, $30, $40, $40, $50, $60, $70, $70, $80, $90, $a0, $a0, $b0
    db $00, $10, $20, $20, $30, $40, $50, $60, $60, $70, $80, $90, $a0, $a0, $b0, $c0
    db $00, $10, $20, $30, $30, $40, $50, $60, $70, $80, $90, $a0, $a0, $b0, $c0, $d0
    db $00, $10, $20, $30, $40, $50, $60, $70, $70, $80, $90, $a0, $b0, $c0, $d0, $e0
    db $00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $a0, $b0, $c0, $d0, $e0, $f0

SoundVibratoOffsetTable_1683:: ; vibrato / pitch offset lookup data used by Call_000_13a8.
    db $00, $00, $01, $01, $00, $00, $ff, $ff, $00, $00, $01, $01, $00, $00, $ff, $ff
    db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $01, $02, $01, $00, $ff, $fe, $ff, $00, $01, $02, $01, $00, $ff, $fe, $ff
    db $00, $00, $01, $01, $02, $02, $01, $01, $00, $00, $ff, $ff, $fe, $fe, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

Call_000_1703::
    ld a, [$dffe]
    and $04
    ld hl, hStageIndex
    add [hl]
    ld [$c0d7], a
    ld a, $01
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


Jump_000_1716::
    call Call_000_17bb
    call Call_000_171d
    ret


Call_000_171d::
    call Call_000_17a1
    call Call_000_1736
    call Call_000_1741
    call Call_000_1754
    call Call_000_1766
    call Call_000_176e
    call Call_000_178f
    call Call_000_1798
    ret


Call_000_1736::
    ld a, [$c0d7]
    add $f1
    ld hl, $986f
    jp QueueTilemapByte


Call_000_1741::
    ld hl, $98ad
    ld de, DebugTextOff
    ld a, [$c0a8]
    or a
    jp nz, Jump_000_068e

    ld de, DebugTextOn
    jp Jump_000_068e


Call_000_1754::
    ld hl, $98ed
    ld de, DebugTextOff
    ldh a, [hPlayerFlags]
    or a
    jp nz, Jump_000_068e

    ld de, DebugTextOn
    jp Jump_000_068e


Call_000_1766::
    ld bc, $992e
    ldh a, [hPlayerLives]
    jp jr_000_0e91


Call_000_176e::
    ld bc, $994b
    ld de, $0005
    call QueueVramFill
    ld hl, DebugPlayerFormNameTable
    ldh a, [hPlayerForm]
    rst $20
    ld d, h
    ld e, l
    ld hl, $996b
    jp Jump_000_068e


DebugPlayerFormNameTable::
    dw DebugTextFormNormal
    dw DebugTextFormFlyingSquirrel
    dw DebugTextFormCockroach
    dw DebugTextFormChicken
    dw DebugTextFormActionKamen

Call_000_178f::
    ld bc, $99ae
    ld a, [$c0d9]
    jp jr_000_0e91


Call_000_1798::
    ld bc, $99ee
    ld a, [$c0da]
    jp jr_000_0e91


Call_000_17a1::
    ld bc, $9863
    ld de, $000e
    call QueueVramFill_SetHighBit
    ld a, [$c0d8]
    ld c, $40
    call MultiplyBCByA8bit
    ld bc, $9863
    add hl, bc
    ld a, $0e
    jp QueueTilemapByte


Call_000_17bb::
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, jr_000_17ed

    bit 3, a
    jr nz, jr_000_17ed

    bit 7, a
    jr nz, jr_000_17d7

    bit 6, a
    jr nz, jr_000_17e2

    bit 5, a
    jr nz, jr_000_1818

    bit 4, a
    jp nz, Jump_000_188f

    ret


jr_000_17d7::
    ld hl, $c0d8
    inc [hl]
    ld a, [hl]
    cp $07
    ret c

    ld [hl], $00
    ret


jr_000_17e2::
    ld hl, $c0d8
    dec [hl]
    ld a, [hl]
    cp $ff
    ret nz

    ld [hl], $06
    ret


jr_000_17ed::
    ld a, $03
    ld [$c0a9], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld hl, $0800
    ld a, l
    ld [wFormTimerLo], a
    ld a, h
    ld [wFormTimerHi], a
    xor a
    ld [$dffe], a
    ld a, [$c0d7]
    ld b, a
    and $03
    ldh [hStageIndex], a
    bit 2, b
    ret z

    ld a, $04
    ld [$dffe], a
    ret


DebugMenuLeftActionDispatch::
jr_000_1818:: ; Compatibility alias.
    ld a, [$c0d8]
    rst $00

DebugMenuLeftActionTable::
    dw DebugMenuActionDecStageIndex ; 00: stage index
    dw DebugMenuActionToggleStageFlag ; 01: $c0a8 toggle
    dw DebugMenuActionTogglePlayerFlags ; 02: hPlayerFlags toggle
    dw DebugMenuActionDecLives ; 03: player lives
    dw DebugMenuActionDecPlayerForm ; 04: player form
    dw DebugMenuActionDecMusic ; 05: music id
    dw DebugMenuActionDecSound ; 06: sound effect id

DebugMenuActionDecStageIndex::
    ld a, [$c0d7]
    dec a
    and $07
    ld [$c0d7], a
    ret


DebugMenuActionToggleStageFlag::
    ld a, [$c0a8]
    xor $ff
    ld [$c0a8], a
    ret


DebugMenuActionTogglePlayerFlags::
    ldh a, [hPlayerFlags]
    xor $ff
    ldh [hPlayerFlags], a
    ret


DebugMenuActionDecLives::
    ldh a, [hPlayerLives]
    sub $01
    ldh [hPlayerLives], a
    ret nc

    ld a, $63
    ldh [hPlayerLives], a
    ret


DebugMenuActionDecPlayerForm::
    ldh a, [hPlayerForm]
    sub $01
    ldh [hPlayerForm], a
    ret nc

    ld a, $04
    ldh [hPlayerForm], a
    ret


DebugMenuActionDecMusic::
    call InitSound
    call Call_000_186b
    ld hl, DebugMenuMusicIdTable
    rst $38
    ld a, [hl]

jr_000_1867::
    call PlaySound_Queue3
    ret


Call_000_186b::
    ld a, [$c0d9]
    sub $01
    ld [$c0d9], a
    ret nc

    ld a, $14
    ld [$c0d9], a
    ret


DebugMenuActionDecSound::
    call Call_000_1880
    jp Jump_000_1907


Call_000_1880::
    ld a, [$c0da]

jr_000_1883::
    sub $01
    ld [$c0da], a
    ret nc

    ld a, $1e
    ld [$c0da], a
    ret


DebugMenuRightActionDispatch::
Jump_000_188f:: ; Compatibility alias.
    ld a, [$c0d8]
    rst $00

DebugMenuRightActionTable::
    dw DebugMenuActionIncStageIndex ; 00: stage index
    dw DebugMenuActionToggleStageFlag ; 01: $c0a8 toggle
    dw DebugMenuActionTogglePlayerFlags ; 02: hPlayerFlags toggle
    dw DebugMenuActionIncLives ; 03: player lives
    dw DebugMenuActionIncPlayerForm ; 04: player form
    dw DebugMenuActionIncMusic ; 05: music id
    dw DebugMenuActionIncSound ; 06: sound effect id

DebugMenuActionIncStageIndex::
    ld a, [$c0d7]
    inc a
    and $07
    ld [$c0d7], a
    ret


DebugMenuActionIncLives::
    ldh a, [hPlayerLives]
    inc a
    ldh [hPlayerLives], a
    cp $64
    ret c

    xor a
    ldh [hPlayerLives], a
    ret


DebugMenuActionIncPlayerForm::
    ldh a, [hPlayerForm]
    inc a
    ldh [hPlayerForm], a
    cp $05
    ret c

    xor a
    ldh [hPlayerForm], a
    ret


DebugMenuActionIncMusic::
    call InitSound
    call PlaySound_Queue3
    call DebugMenuActionResetMusicId
    ld hl, DebugMenuMusicIdTable
    rst $38
    ld a, [hl]
    call PlaySound_Queue3
    ret


DebugMenuMusicIdTable::
jr_000_18d5:: ; Compatibility alias.
    db $00, $04, $08, $0c, $10, $14, $1c, $20
    db $24, $28, $2c, $30, $34, $38, $3c, $60
    db $64, $18, $18, $18, $18, $18, $18, $18
    db $18, $18, $18, $18, $18, $18, $18, $18

DebugMenuActionResetMusicId::
    ld a, [$c0d9]
    inc a
    ld [$c0d9], a
    cp $15
    ret c

    xor a

jr_000_1900::
    ld [$c0d9], a
    ret


DebugMenuActionIncSound::
jr_000_1904:: ; Compatibility alias.
    call Call_000_1956

Jump_000_1907::
    ld hl, DebugMenuSoundDispatchTable

jr_000_190a::
    ld a, [$c0da]
    rst $20
    ld a, l
    dec h
    jp z, PlaySound

    dec h
    jp z, PlaySound_Queue1

    dec h
    jp z, PlaySound_Queue2

    jp PlaySound_Queue3


DebugMenuSoundDispatchTable:: ; high byte selects PlaySound/queue helper; low byte is sound id.
    dw $0140, $0141, $0142, $0143, $0144, $0145, $0246, $0148
    dw $0249, $014b, $014c, $014d, $014e, $014f, $0150, $0151
    dw $0152, $0153, $0154, $0455, $0159, $015a, $015b, $015c
    dw $015d, $025e, $0140, $0140

Call_000_1956::
    ld a, [$c0da]
    inc a
    ld [$c0da], a
    cp $1f
    ret c

    xor a
    ld [$c0da], a
    ret


LoadDebugMenu::
    xor a
IF DEF(DEBUG)	
    call Call_000_3f6a
    xor a
ELSE
    ldh [hNeedsReset], a
    ldh [hSCX], a
ENDC
    ldh [hSCY], a
    ldh [hPlayerFlags], a
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    call Call_000_02f8
    ld hl, $9864
    ld de, DebugTextStage
    call jr_000_0673
    ld hl, $98a4
    ld de, DebugTextFlagA
    call jr_000_0673
    ld hl, $98e4
    ld de, DebugTextFlagB
    call jr_000_0673
    ld hl, $9924
    ld de, DebugTextLives
    call jr_000_0673
    ld hl, $9964
    ld de, DebugTextForm
    call jr_000_0673
    ld hl, $99a4
    ld de, DebugTextMusic
    call jr_000_0673
    ld hl, $99e4
    ld de, DebugTextSound
    call jr_000_0673
    ld hl, wPaletteBGP
    ld [hl], $e4
    ld a, $83
    ld [wLCDCShadow], a
    ret


DebugTextStage::
    db $57, $5e, $7e, $45, $56, $ff
DebugTextFlagA::
    db $24, $20, $3c, $12, $15, $34, $ff
DebugTextFlagB::
    db $31, $23, $16, $ff
DebugTextLives::
    db $45, $1a, $42, $1c, $12, $ff
DebugTextForm::
    db $46, $48, $5e, $6c, $ff
DebugTextMusic::
    db $2a, $11, $18, $11, $14, $42, $ff
DebugTextSound::
    db $19, $12, $15, $14, $42, $ff
DebugTextOff::
    db $00, $2a, $11, $ff
DebugTextOn::
    db $11, $11, $13, $ff
DebugTextFormNormal::
    db $00, $00, $00, $25, $1b, $ff
DebugTextFormFlyingSquirrel::
    db $00, $31, $1a, $1a, $45, $2b, $ff
DebugTextFormCockroach::
    db $00, $45, $19, $16, $45, $2c, $35, $ff
DebugTextFormChicken::
    db $00, $26, $3f, $24, $35, $ff
DebugTextFormActionKamen::
    db $46, $52, $56, $74, $7c, $fe, $ff

SpriteAnimPointerTable_1a19::
    ; Large animation pointer table. Entries point either to nested pointer tables or sprite frame data.
    dw SpriteAnimPointerTable_1a23, SpriteAnimPointerTable_1a4f, SpriteAnimPointerTable_1a83, SpriteAnimPointerTable_1abf, SpriteAnimPointerTable_1af3

SpriteAnimPointerTable_1a23::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_2a7f, SpriteFrameData_2a98, SpriteFrameData_2ab1, SpriteFrameData_2aca
    dw SpriteFrameData_2ae3, SpriteFrameData_2afc, SpriteFrameData_2b1d, SpriteFrameData_2b3e, SpriteFrameData_2b5b, SpriteFrameData_2b6c, SpriteFrameData_2b7d, SpriteFrameData_2b92
    dw SpriteFrameData_2baf, SpriteFrameData_2bc8, SpriteFrameData_2be1, SpriteFrameData_2bf6, SpriteFrameData_2c0f, SpriteFrameData_2c28

SpriteAnimPointerTable_1a4f::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_2cb9, SpriteFrameData_2cd6, SpriteFrameData_2cf3, SpriteFrameData_2d10
    dw SpriteFrameData_2d10, SpriteFrameData_2d2d, SpriteFrameData_2d52, SpriteFrameData_2d77, SpriteFrameData_2d98, SpriteFrameData_2d98, SpriteFrameData_2da9, SpriteFrameData_2dc6
    dw SpriteFrameData_2de3, SpriteFrameData_2dfc, SpriteFrameData_2e15, SpriteFrameData_2e2e, SpriteFrameData_2e47, SpriteFrameData_2e60, SpriteFrameData_2e79, SpriteFrameData_2ea0
    dw SpriteFrameData_2ebd, SpriteFrameData_2c28

SpriteAnimPointerTable_1a83::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_3321, SpriteFrameData_333a, SpriteFrameData_333a, SpriteFrameData_333a
    dw SpriteFrameData_3353, SpriteFrameData_3364, SpriteFrameData_337d, SpriteFrameData_3396, SpriteFrameData_33ab, SpriteFrameData_33ab, SpriteFrameData_33ab, SpriteFrameData_33c4
    dw SpriteFrameData_33dd, SpriteFrameData_33f6, SpriteFrameData_340f, SpriteFrameData_3428, SpriteFrameData_3441, SpriteFrameData_345a, SpriteFrameData_347b, SpriteFrameData_34a0
    dw SpriteFrameData_34c5, SpriteFrameData_34e6, SpriteFrameData_350b, SpriteFrameData_3530, SpriteFrameData_3551, SpriteFrameData_2c28

SpriteAnimPointerTable_1abf::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_2f2e, SpriteFrameData_2f4b, SpriteFrameData_2f4b, SpriteFrameData_2f4b
    dw SpriteFrameData_2f68, SpriteFrameData_2f85, SpriteFrameData_2fa6, SpriteFrameData_2fc7, SpriteFrameData_2fe4, SpriteFrameData_2fe4, SpriteFrameData_3012, SpriteFrameData_2ff5
    dw SpriteFrameData_302f, SpriteFrameData_3048, SpriteFrameData_3061, SpriteFrameData_3076, SpriteFrameData_308f, SpriteFrameData_30e7, SpriteFrameData_3104, SpriteFrameData_30a8
    dw SpriteFrameData_30c5, SpriteFrameData_2c28

SpriteAnimPointerTable_1af3::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_3121, SpriteFrameData_313a, SpriteFrameData_3153, SpriteFrameData_316c
    dw SpriteFrameData_316c, SpriteFrameData_3185, SpriteFrameData_31a6, SpriteFrameData_31c7, SpriteFrameData_31e4, SpriteFrameData_31e4, SpriteFrameData_31f5, SpriteFrameData_320a
    dw SpriteFrameData_3227, SpriteFrameData_3240, SpriteFrameData_3259, SpriteFrameData_326e, SpriteFrameData_3287, SpriteFrameData_32a0, SpriteFrameData_32fc, SpriteFrameData_32b9
    dw SpriteFrameData_2c28

SpriteStageAnimPointerTable_1b25:: ; Stage-indexed table used by bank 1 object sprite drawing.
    dw SpriteAnimPointerTable_1b2d, SpriteAnimPointerTable_1b61, SpriteAnimPointerTable_1b99, SpriteAnimPointerTable_1bd1

SpriteAnimPointerTable_1b2d::
    dw SpriteFrameData_1c11, SpriteFrameData_1c2a, SpriteFrameData_1c43, SpriteFrameData_1c5c, SpriteFrameData_1c11, SpriteFrameData_1c11, SpriteFrameData_1c75, SpriteFrameData_1c92
    dw SpriteFrameData_1caf, SpriteFrameData_1ccc, SpriteFrameData_1ce9, SpriteFrameData_1d0a, SpriteFrameData_1d23, SpriteFrameData_1d50, SpriteFrameData_1d7d, SpriteFrameData_1daa
    dw SpriteFrameData_2497, SpriteFrameData_24bc, SpriteFrameData_24e1, SpriteFrameData_24ea, SpriteFrameData_24f3, SpriteFrameData_24fc, SpriteFrameData_251d, SpriteFrameData_253a
    dw SpriteFrameData_255b, SpriteFrameData_257c

SpriteAnimPointerTable_1b61::
    dw SpriteFrameData_1f19, SpriteFrameData_1f3a, SpriteFrameData_1f5b, SpriteFrameData_1f7c, SpriteFrameData_1f99, SpriteFrameData_1fa2, SpriteFrameData_1dc7, SpriteFrameData_1de4
    dw SpriteFrameData_1e01, SpriteFrameData_1e1e, SpriteFrameData_1e3b, SpriteFrameData_1e5c, SpriteFrameData_1e75, SpriteFrameData_1ea2, SpriteFrameData_1ecf, SpriteFrameData_1efc
    dw SpriteFrameData_1fbf, SpriteFrameData_1fd0, SpriteFrameData_1fe1, SpriteFrameData_1ff2, SpriteFrameData_259d, SpriteFrameData_25be, SpriteFrameData_25df, SpriteFrameData_2600
    dw SpriteFrameData_2625, SpriteFrameData_2646, SpriteFrameData_2663, SpriteFrameData_2684

SpriteAnimPointerTable_1b99::
    dw SpriteFrameData_209f, SpriteFrameData_20c0, SpriteFrameData_20e1, SpriteFrameData_2102, SpriteFrameData_211f, SpriteFrameData_2128, SpriteFrameData_1ffb, SpriteFrameData_1ffb
    dw SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_2028, SpriteFrameData_2055, SpriteFrameData_2082
    dw SpriteFrameData_2145, SpriteFrameData_215e, SpriteFrameData_2177, SpriteFrameData_2190, SpriteFrameData_21ad, SpriteFrameData_26a5, SpriteFrameData_26da, SpriteFrameData_270f
    dw SpriteFrameData_2740, SpriteFrameData_2771, SpriteFrameData_27aa, SpriteFrameData_27df

SpriteAnimPointerTable_1bd1::
    dw SpriteFrameData_2346, SpriteFrameData_2367, SpriteFrameData_2388, SpriteFrameData_23a9, SpriteFrameData_23c6, SpriteFrameData_23cf, SpriteFrameData_2298, SpriteFrameData_22b5
    dw SpriteFrameData_22d2, SpriteFrameData_22ef, SpriteFrameData_230c, SpriteFrameData_232d, SpriteFrameData_2298, SpriteFrameData_2298, SpriteFrameData_2298, SpriteFrameData_2298
    dw SpriteFrameData_23ec, SpriteFrameData_2405, SpriteFrameData_241e, SpriteFrameData_2437, SpriteFrameData_2454, SpriteFrameData_27e4, SpriteFrameData_2821, SpriteFrameData_285e
    dw SpriteFrameData_2893, SpriteFrameData_28cc, SpriteFrameData_2909, SpriteFrameData_293e, SpriteFrameData_2973, SpriteFrameData_29ac, SpriteFrameData_29e9, SpriteFrameData_2a26

SpriteFrameData_1c11::
    db $eb, $f8, $70, $00, $eb, $00, $71, $00, $f3, $f8, $72, $00, $f3, $00, $73, $00
    db $fb, $f8, $7e, $00, $fb, $00, $7f, $00, $80

SpriteFrameData_1c2a::
    db $ec, $f8, $70, $00, $ec, $00, $71, $00, $f4, $f8, $74, $00, $f4, $00, $75, $00
    db $fc, $f8, $80, $00, $fc, $00, $81, $00, $80

SpriteFrameData_1c43::
    db $ec, $f8, $70, $00, $ec, $00, $71, $00, $f4, $f8, $76, $00, $f4, $00, $77, $00
    db $fc, $f8, $82, $00, $fc, $00, $83, $00, $80

SpriteFrameData_1c5c::
    db $ef, $f8, $78, $00, $ef, $00, $79, $00, $f7, $f8, $7a, $00, $f7, $00, $7b, $00
    db $f7, $08, $7c, $00, $ff, $ff, $7d, $00, $80

SpriteFrameData_1c75::
    db $eb, $f8, $84, $00, $eb, $00, $85, $00, $f3, $f8, $86, $00, $f3, $00, $87, $00
    db $f1, $08, $89, $00, $fb, $f7, $88, $00, $fb, $ff, $7f, $00, $80

SpriteFrameData_1c92::
    db $ec, $f8, $84, $00, $ec, $00, $85, $00, $f4, $f8, $8a, $00, $f4, $00, $8b, $00
    db $f2, $08, $89, $00, $fc, $f8, $80, $00, $fc, $00, $81, $00, $80

SpriteFrameData_1caf::
    db $ec, $f8, $84, $00, $ec, $00, $85, $00, $f4, $f8, $8c, $00, $f4, $00, $8d, $00
    db $f2, $08, $89, $00, $fc, $f8, $82, $00, $fc, $00, $83, $00, $80

SpriteFrameData_1ccc::
    db $eb, $f8, $84, $00, $eb, $00, $85, $00, $f3, $f8, $86, $00, $f3, $00, $87, $00
    db $f1, $08, $89, $00, $fb, $f8, $8e, $00, $fb, $00, $8f, $00, $80

SpriteFrameData_1ce9::
    db $eb, $f9, $84, $00, $eb, $01, $85, $00, $f3, $f9, $90, $00, $f3, $01, $87, $00
    db $f3, $09, $91, $00, $f2, $11, $92, $00, $fb, $f9, $8f, $20, $fb, $00, $8f, $00
    db $80

SpriteFrameData_1d0a::
    db $ee, $f8, $93, $00, $ee, $00, $94, $00, $f6, $f8, $95, $00, $f6, $00, $96, $00
    db $fe, $f8, $97, $00, $fe, $00, $98, $00, $80

SpriteFrameData_1d23::
    db $e0, $f8, $99, $00, $e0, $00, $9a, $00, $e0, $08, $9b, $00, $e0, $10, $9c, $00
    db $e8, $f8, $9d, $00, $e8, $00, $9e, $00, $e8, $08, $9f, $00, $f0, $f8, $a0, $00
    db $f0, $00, $a1, $00, $f8, $f8, $a2, $00, $f8, $00, $a3, $00, $80

SpriteFrameData_1d50::
    db $e1, $f8, $99, $00, $e1, $00, $9a, $00, $e1, $08, $9b, $00, $e1, $10, $9c, $00
    db $e9, $f8, $9d, $00, $e9, $00, $9e, $00, $e9, $08, $9f, $00, $f1, $f8, $a0, $00
    db $f1, $00, $a1, $00, $f9, $f8, $a4, $00, $f9, $00, $a5, $00, $80

SpriteFrameData_1d7d::
    db $e1, $f8, $99, $00, $e1, $00, $9a, $00, $e1, $08, $9b, $00, $e1, $10, $9c, $00
    db $e9, $f8, $9d, $00, $e9, $00, $9e, $00, $e9, $08, $9f, $00, $f1, $f8, $a0, $00
    db $f1, $00, $a1, $00, $f9, $f8, $a6, $00, $f9, $00, $a7, $00, $80

SpriteFrameData_1daa::
    db $e8, $f8, $a8, $00, $e8, $00, $a9, $00, $f0, $f7, $aa, $00, $f0, $ff, $ab, $00
    db $f8, $f8, $ac, $00, $f8, $00, $ad, $00, $f8, $08, $ae, $00, $80

SpriteFrameData_1dc7::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f7, $79, $00, $fb, $ff, $70, $00, $80

SpriteFrameData_1de4::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7b, $00, $f4, $00, $7c, $00
    db $f2, $08, $7a, $00, $fc, $f8, $71, $00, $fc, $00, $72, $00, $80

SpriteFrameData_1e01::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7d, $00, $f4, $00, $7e, $00
    db $f2, $08, $7a, $00, $fc, $f8, $73, $00, $fc, $00, $74, $00, $80

SpriteFrameData_1e1e::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f8, $7f, $00, $fb, $00, $80, $00, $80

SpriteFrameData_1e3b::
    db $eb, $f9, $75, $00, $eb, $01, $76, $00, $f3, $f9, $81, $00, $f3, $01, $78, $00
    db $f3, $09, $82, $00, $f2, $11, $83, $00, $fb, $f9, $80, $20, $fb, $00, $80, $00
    db $80

SpriteFrameData_1e5c::
    db $ee, $f8, $84, $00, $ee, $00, $85, $00, $f6, $f8, $86, $00, $f6, $00, $87, $00
    db $fe, $f8, $88, $00, $fe, $00, $89, $00, $80

SpriteFrameData_1e75::
    db $e0, $f8, $8a, $00, $e0, $00, $8b, $00, $e0, $08, $8c, $00, $e0, $10, $8d, $00
    db $e8, $f8, $8e, $00, $e8, $00, $8f, $00, $e8, $08, $90, $00, $f0, $f8, $91, $00
    db $f0, $00, $92, $00, $f8, $f8, $93, $00, $f8, $00, $94, $00, $80

SpriteFrameData_1ea2::
    db $e1, $f8, $8a, $00, $e1, $00, $8b, $00, $e1, $08, $8c, $00, $e1, $10, $8d, $00
    db $e9, $f8, $8e, $00, $e9, $00, $8f, $00, $e9, $08, $90, $00, $f1, $f8, $91, $00
    db $f1, $00, $92, $00, $f9, $f8, $95, $00, $f9, $00, $96, $00, $80

SpriteFrameData_1ecf::
    db $e1, $f8, $8a, $00, $e1, $00, $8b, $00, $e1, $08, $8c, $00, $e1, $10, $8d, $00
    db $e9, $f8, $8e, $00, $e9, $00, $8f, $00, $e9, $08, $90, $00, $f1, $f8, $91, $00
    db $f1, $00, $92, $00, $f9, $f8, $97, $00, $f9, $00, $98, $00, $80

SpriteFrameData_1efc::
    db $e8, $f8, $99, $00, $e8, $00, $9a, $00, $f0, $f7, $9b, $00, $f0, $ff, $9c, $00
    db $f8, $f8, $9d, $00, $f8, $00, $9e, $00, $f8, $08, $9f, $00, $80

SpriteFrameData_1f19::
    db $e8, $f8, $ab, $00, $e8, $00, $ac, $00, $e8, $08, $ad, $00, $f0, $f8, $ae, $00
    db $f0, $00, $af, $00, $f0, $08, $b0, $00, $f8, $f8, $b1, $00, $f8, $00, $b2, $00
    db $80

SpriteFrameData_1f3a::
    db $e9, $f8, $ab, $00, $e9, $00, $ac, $00, $e9, $08, $ad, $00, $f1, $f8, $b3, $00
    db $f1, $00, $af, $00, $f1, $08, $b0, $00, $f9, $f8, $b4, $00, $f9, $00, $b5, $00
    db $80

SpriteFrameData_1f5b::
    db $e9, $f8, $ab, $00, $e9, $00, $ac, $00, $e9, $08, $ad, $00, $f1, $f8, $b6, $00
    db $f1, $00, $b7, $00, $f1, $08, $b0, $00, $f9, $f8, $b8, $00, $f9, $00, $b9, $00
    db $80

SpriteFrameData_1f7c::
    db $e8, $fa, $ab, $00, $e8, $02, $ba, $00, $f0, $f9, $bb, $00, $f0, $01, $bc, $00
    db $f0, $09, $bd, $00, $f8, $f9, $a0, $00, $f8, $01, $a1, $00, $80

SpriteFrameData_1f99::
    db $f8, $f4, $a2, $00, $f8, $fc, $a3, $00, $80

SpriteFrameData_1fa2::
    db $ec, $fc, $a4, $00, $ec, $04, $a5, $00, $f4, $f4, $a6, $00, $f4, $fc, $a7, $00
    db $f4, $04, $a8, $00, $fc, $fb, $a9, $00, $fc, $03, $aa, $00, $80

SpriteFrameData_1fbf::
    db $f8, $f8, $be, $10, $f8, $00, $c4, $10, $00, $f8, $bf, $10, $00, $00, $c0, $10
    db $80

SpriteFrameData_1fd0::
    db $f7, $f8, $c1, $10, $f7, $00, $c1, $30, $ff, $f8, $c2, $10, $ff, $00, $c3, $10
    db $80

SpriteFrameData_1fe1::
    db $f0, $f8, $c5, $10, $f0, $00, $c6, $10, $f8, $f8, $c7, $10, $f8, $00, $c8, $10
    db $80

SpriteFrameData_1ff2::
    db $f8, $f8, $c9, $10, $f8, $00, $c9, $30, $80

SpriteFrameData_1ffb::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e0, $08, $72, $00, $e0, $10, $73, $00
    db $e8, $f8, $74, $00, $e8, $00, $75, $00, $e8, $08, $76, $00, $f0, $f8, $77, $00
    db $f0, $00, $78, $00, $f8, $f8, $79, $00, $f8, $00, $7a, $00, $80

SpriteFrameData_2028::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e1, $08, $72, $00, $e1, $10, $73, $00
    db $e9, $f8, $74, $00, $e9, $00, $75, $00, $e9, $08, $76, $00, $f1, $f8, $77, $00
    db $f1, $00, $78, $00, $f9, $f8, $7b, $00, $f9, $00, $7c, $00, $80

SpriteFrameData_2055::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e1, $08, $72, $00, $e1, $10, $73, $00
    db $e9, $f8, $74, $00, $e9, $00, $75, $00, $e9, $08, $76, $00, $f1, $f8, $77, $00
    db $f1, $00, $78, $00, $f9, $f8, $7d, $00, $f9, $00, $7e, $00, $80

SpriteFrameData_2082::
    db $e8, $f8, $7f, $00, $e8, $00, $80, $00, $f0, $f7, $81, $00, $f0, $ff, $82, $00
    db $f8, $f8, $83, $00, $f8, $00, $84, $00, $f8, $08, $85, $00, $80

SpriteFrameData_209f::
    db $e8, $f8, $91, $00, $e8, $00, $92, $00, $e8, $08, $93, $00, $f0, $f8, $94, $00
    db $f0, $00, $95, $00, $f0, $08, $96, $00, $f8, $f8, $97, $00, $f8, $00, $98, $00
    db $80

SpriteFrameData_20c0::
    db $e9, $f8, $91, $00, $e9, $00, $92, $00, $e9, $08, $93, $00, $f1, $f8, $99, $00
    db $f1, $00, $95, $00, $f1, $08, $96, $00, $f9, $f8, $9a, $00, $f9, $00, $9b, $00
    db $80

SpriteFrameData_20e1::
    db $e9, $f8, $91, $00, $e9, $00, $92, $00, $e9, $08, $93, $00, $f1, $f8, $9c, $00
    db $f1, $00, $9d, $00, $f1, $08, $96, $00, $f9, $f8, $9e, $00, $f9, $00, $9f, $00
    db $80

SpriteFrameData_2102::
    db $e8, $fa, $91, $00, $e8, $02, $a0, $00, $f0, $f9, $a1, $00, $f0, $01, $a2, $00
    db $f0, $09, $a3, $00, $f8, $f9, $86, $00, $f8, $01, $87, $00, $80

SpriteFrameData_211f::
    db $f8, $f4, $88, $00, $f8, $fc, $89, $00, $80

SpriteFrameData_2128::
    db $ec, $fc, $8a, $00, $ec, $04, $8b, $00, $f4, $f4, $8c, $00, $f4, $fc, $8d, $00
    db $f4, $04, $8e, $00, $fc, $fb, $8f, $00, $fc, $03, $90, $00, $80

SpriteFrameData_2145::
    db $e8, $f8, $af, $00, $e8, $00, $b0, $00, $f0, $f8, $b1, $00, $f0, $00, $b2, $00
    db $f8, $f8, $b3, $00, $f8, $00, $b4, $00, $80

SpriteFrameData_215e::
    db $e9, $f8, $af, $00, $e9, $00, $b0, $00, $f1, $f8, $b5, $00, $f1, $00, $b6, $00
    db $f9, $f8, $b7, $00, $f9, $00, $b8, $00, $80

SpriteFrameData_2177::
    db $e9, $f8, $af, $00, $e9, $00, $b0, $00, $f1, $f8, $b9, $00, $f1, $00, $ba, $00
    db $f9, $f8, $bb, $00, $f9, $00, $bc, $00, $80

SpriteFrameData_2190::
    db $ed, $f8, $bd, $00, $ed, $00, $be, $00, $f5, $f8, $bf, $00, $f5, $00, $a4, $00
    db $f5, $08, $a5, $00, $fd, $f8, $a6, $00, $fd, $00, $a7, $00, $80

SpriteFrameData_21ad::
    db $ed, $f8, $bd, $00, $ed, $00, $a8, $00, $f5, $f8, $a9, $00, $f5, $00, $aa, $00
    db $f5, $08, $ab, $00, $fd, $f8, $ac, $00, $fd, $00, $ad, $00, $fd, $08, $ae, $00
    db $80

SpriteFrameData_21ce:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $d8, $ec, $c0, $00, $e0, $ec, $c1, $00, $e0, $f4, $c2, $00, $e0, $fc, $c3
    db $00, $e0, $04, $c4, $00, $e8, $f4, $c5, $00, $e8, $fc, $c6, $00, $e8, $04, $c7
    db $00, $f0, $f4, $cd, $00, $f8, $f4, $c8, $00, $f8, $fc, $c9, $00, $f8, $04, $ca
    db $00, $80

SpriteFrameData_21ff:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $d9, $ec, $c0, $00, $e1, $ec, $c1, $00, $e1, $f4, $c2, $00, $e1, $fc
    db $c3, $00, $e1, $04, $c4, $00, $e9, $f4, $c5, $00, $e9, $fc, $c6, $00, $e9, $04
    db $c7, $00, $f1, $f4, $cd, $00, $f9, $f4, $cb, $00, $f9, $fc, $c9, $00, $f9, $04
    db $cc, $00, $80

SpriteFrameData_2230:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fc, $c0, $10, $80

SpriteFrameData_2235:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fc, $c1, $10, $80

SpriteFrameData_223a:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fc, $c2, $10, $80

SpriteFrameData_223f:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fb, $c0, $10, $80

SpriteFrameData_2244:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c3, $00, $f0, $00, $c4, $00, $f8
    db $f8, $c5, $00, $f8, $00, $c6, $00, $80

SpriteFrameData_2255:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c4, $20, $f0, $00, $c3, $20
    db $f8, $f8, $c6, $20, $f8, $00, $c5, $20, $80

SpriteFrameData_2266:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f2, $f8, $c5, $40, $f2, $00, $c6
    db $40, $fa, $f8, $c3, $40, $fa, $00, $c4, $40, $80

SpriteFrameData_2277:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $e8, $f4, $c7, $00, $e8, $fc
    db $c8, $00, $e8, $04, $c7, $20, $f0, $f4, $c9, $00, $f0, $fc, $ca, $00, $f0, $04
    db $c9, $20, $f8, $f8, $cb, $00, $f8, $00, $cc, $00, $80

SpriteFrameData_2298::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f7, $79, $00, $fb, $ff, $70, $00, $80

SpriteFrameData_22b5::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7b, $00, $f4, $00, $7c, $00
    db $f2, $08, $7a, $00, $fc, $f8, $71, $00, $fc, $00, $72, $00, $80

SpriteFrameData_22d2::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7d, $00, $f4, $00, $7e, $00
    db $f2, $08, $7a, $00, $fc, $f8, $73, $00, $fc, $00, $74, $00, $80

SpriteFrameData_22ef::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f8, $7f, $00, $fb, $00, $80, $00, $80

SpriteFrameData_230c::
    db $eb, $f9, $75, $00, $eb, $01, $76, $00, $f3, $f9, $81, $00, $f3, $01, $78, $00
    db $f3, $09, $82, $00, $f2, $11, $83, $00, $fb, $f9, $80, $20, $fb, $00, $80, $00
    db $80

SpriteFrameData_232d::
    db $ee, $f8, $84, $00, $ee, $00, $85, $00, $f6, $f8, $86, $00, $f6, $00, $87, $00
    db $fe, $f8, $88, $00, $fe, $00, $89, $00, $80

SpriteFrameData_2346::
    db $e8, $f8, $95, $00, $e8, $00, $96, $00, $e8, $08, $97, $00, $f0, $f8, $98, $00
    db $f0, $00, $99, $00, $f0, $08, $9a, $00, $f8, $f8, $9b, $00, $f8, $00, $9c, $00
    db $80

SpriteFrameData_2367::
    db $e9, $f8, $95, $00, $e9, $00, $96, $00, $e9, $08, $97, $00, $f1, $f8, $9d, $00
    db $f1, $00, $99, $00, $f1, $08, $9a, $00, $f9, $f8, $9e, $00, $f9, $00, $9f, $00
    db $80

SpriteFrameData_2388::
    db $e9, $f8, $95, $00, $e9, $00, $96, $00, $e9, $08, $97, $00, $f1, $f8, $a0, $00
    db $f1, $00, $a1, $00, $f1, $08, $9a, $00, $f9, $f8, $a2, $00, $f9, $00, $a3, $00
    db $80

SpriteFrameData_23a9::
    db $e8, $fa, $95, $00, $e8, $02, $a4, $00, $f0, $f9, $a5, $00, $f0, $01, $a6, $00
    db $f0, $09, $a7, $00, $f8, $f9, $8a, $00, $f8, $01, $8b, $00, $80

SpriteFrameData_23c6::
    db $f8, $f4, $8c, $00, $f8, $fc, $8d, $00, $80

SpriteFrameData_23cf::
    db $ec, $fc, $8e, $00, $ec, $04, $8f, $00, $f4, $f4, $90, $00, $f4, $fc, $91, $00
    db $f4, $04, $92, $00, $fc, $fb, $93, $00, $fc, $03, $94, $00, $80

SpriteFrameData_23ec::
    db $e8, $f8, $b3, $00, $e8, $00, $b4, $00, $f0, $f8, $b5, $00, $f0, $00, $b6, $00
    db $f8, $f8, $b7, $00, $f8, $00, $b8, $00, $80

SpriteFrameData_2405::
    db $e9, $f8, $b3, $00, $e9, $00, $b4, $00, $f1, $f8, $b9, $00, $f1, $00, $ba, $00
    db $f9, $f8, $bb, $00, $f9, $00, $bc, $00, $80

SpriteFrameData_241e::
    db $e9, $f8, $b3, $00, $e9, $00, $b4, $00, $f1, $f8, $bd, $00, $f1, $00, $be, $00
    db $f9, $f8, $bf, $00, $f9, $00, $c0, $00, $80

SpriteFrameData_2437::
    db $ed, $f8, $c1, $00, $ed, $00, $c2, $00, $f5, $f8, $c3, $00, $f5, $00, $a8, $00
    db $f5, $08, $a9, $00, $fd, $f8, $aa, $00, $fd, $00, $ab, $00, $80

SpriteFrameData_2454::
    db $ed, $f8, $c1, $00, $ed, $00, $ac, $00, $f5, $f8, $ad, $00, $f5, $00, $ae, $00
    db $f5, $08, $af, $00, $fd, $f8, $b0, $00, $fd, $00, $b1, $00, $fd, $08, $b2, $00
    db $80

SpriteFrameData_2475:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c4, $00, $f0, $00, $c5, $00, $f8, $f8, $c6, $10, $f8, $00, $c7
    db $10, $80

SpriteFrameData_2486:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c8, $00, $f0, $00, $c9, $00, $f8, $f8, $ca, $00, $f8, $00
    db $cb, $00, $80

SpriteFrameData_2497::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00
    db $f0, $f8, $74, $00, $f0, $00, $75, $00, $ed, $08, $78, $00, $f8, $f8, $76, $00
    db $f8, $00, $77, $00, $80

SpriteFrameData_24bc::
    db $e0, $f9, $70, $00, $e0, $01, $71, $00, $e8, $f9, $72, $00, $e8, $01, $79, $00
    db $f0, $f8, $7a, $00, $f0, $00, $7b, $00, $f0, $08, $7c, $00, $f8, $f8, $7d, $00
    db $f8, $00, $77, $00, $80

SpriteFrameData_24e1::
    db $f8, $f8, $7e, $00, $f8, $00, $7f, $00, $80

SpriteFrameData_24ea::
    db $f8, $f8, $81, $20, $f8, $00, $80, $20, $80

SpriteFrameData_24f3::
    db $f8, $f8, $83, $20, $f8, $00, $82, $20, $80

SpriteFrameData_24fc::
    db $e8, $fc, $84, $00, $e8, $04, $71, $00, $f0, $f4, $85, $00, $f0, $fc, $86, $00
    db $f0, $04, $87, $00, $f8, $f4, $88, $00, $f8, $fc, $89, $00, $f8, $04, $8a, $00
    db $80

SpriteFrameData_251d::
    db $e8, $fc, $84, $00, $e8, $04, $71, $00, $f0, $fc, $8b, $00, $f0, $04, $8c, $00
    db $f8, $f4, $8d, $00, $f8, $fc, $8e, $00, $f8, $04, $8f, $00, $80

SpriteFrameData_253a::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $79, $00
    db $f0, $f8, $90, $00, $f0, $00, $91, $00, $f8, $f8, $92, $00, $f8, $00, $93, $00
    db $80

SpriteFrameData_255b::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $79, $00
    db $f1, $f8, $94, $00, $f1, $00, $95, $00, $f9, $f8, $96, $00, $f9, $00, $97, $00
    db $80

SpriteFrameData_257c::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $79, $00
    db $f1, $f8, $98, $00, $f1, $00, $99, $00, $f9, $f8, $9a, $00, $f9, $00, $9b, $00
    db $80

SpriteFrameData_259d::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00
    db $f0, $f8, $74, $00, $f0, $00, $75, $00, $f8, $f8, $76, $00, $f8, $00, $77, $00
    db $80

SpriteFrameData_25be::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $73, $00
    db $f1, $f8, $78, $00, $f1, $00, $79, $00, $f9, $f8, $7a, $00, $f9, $00, $7b, $00
    db $80

SpriteFrameData_25df::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $73, $00
    db $f1, $f8, $7c, $00, $f1, $00, $7d, $00, $f9, $f8, $7e, $00, $f9, $00, $7f, $00
    db $80

SpriteFrameData_2600::
    db $e5, $f8, $70, $00, $e5, $00, $71, $00, $ed, $f8, $80, $00, $ed, $00, $81, $00
    db $f5, $f8, $82, $00, $f5, $00, $83, $00, $f5, $08, $84, $00, $fd, $f8, $85, $00
    db $fd, $00, $86, $00, $80

SpriteFrameData_2625::
    db $e5, $f8, $70, $00, $e5, $00, $71, $00, $ed, $f9, $87, $00, $ed, $01, $88, $00
    db $f5, $f8, $89, $00, $f5, $00, $8a, $00, $fd, $f8, $85, $00, $fd, $00, $8b, $00
    db $80

SpriteFrameData_2646::
    db $e8, $fc, $8c, $00, $e8, $04, $8d, $00, $f0, $fa, $8e, $00, $f0, $02, $8f, $00
    db $f8, $f4, $90, $00, $f8, $fc, $91, $00, $f8, $04, $92, $00, $80

SpriteFrameData_2663::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $93, $00, $e8, $00, $94, $00
    db $f0, $f8, $95, $00, $f0, $00, $96, $00, $f8, $f8, $97, $00, $f8, $00, $98, $00
    db $80

SpriteFrameData_2684::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00
    db $f0, $f8, $99, $00, $f0, $00, $9a, $00, $f8, $f8, $9b, $00, $f8, $00, $9c, $00
    db $80

SpriteFrameData_26a5::
    db $d9, $f3, $70, $00, $e0, $ee, $71, $10, $e0, $f6, $72, $10, $e0, $fe, $73, $10
    db $e8, $f1, $74, $00, $e8, $f9, $75, $00, $e8, $01, $76, $00, $f0, $f4, $77, $10
    db $f0, $fc, $78, $10, $f0, $04, $79, $10, $f8, $f3, $7a, $10, $f8, $fb, $7b, $10
    db $f8, $03, $7c, $10, $80

SpriteFrameData_26da::
    db $d9, $f3, $70, $00, $e0, $ee, $71, $10, $e0, $f6, $72, $10, $e0, $fe, $73, $10
    db $e8, $f1, $7d, $00, $e8, $f9, $75, $00, $e8, $01, $76, $00, $f0, $f2, $7e, $10
    db $f0, $fa, $7f, $10, $f0, $02, $80, $10, $f8, $f2, $81, $10, $f8, $fa, $82, $10
    db $f8, $02, $83, $10, $80

SpriteFrameData_270f::
    db $e0, $f4, $84, $10, $e0, $fc, $85, $10, $e0, $04, $86, $10, $e8, $f4, $87, $00
    db $e8, $fc, $88, $00, $e8, $04, $89, $00, $f0, $f4, $8a, $10, $f0, $fc, $8b, $10
    db $f0, $04, $8c, $10, $f8, $f3, $7a, $10, $f8, $fb, $7b, $10, $f8, $03, $7c, $10
    db $80

SpriteFrameData_2740::
    db $e0, $f4, $84, $10, $e0, $fc, $85, $10, $e0, $04, $86, $10, $e8, $f4, $90, $00
    db $e8, $fc, $88, $00, $e8, $04, $89, $00, $f0, $f2, $7e, $10, $f0, $fa, $91, $10
    db $f0, $02, $92, $10, $f8, $f2, $81, $10, $f8, $fa, $82, $10, $f8, $02, $83, $10
    db $80

SpriteFrameData_2771::
    db $e5, $f4, $93, $10, $e5, $fc, $94, $10, $e5, $04, $95, $10, $ed, $ed, $96, $00
    db $ed, $f5, $97, $00, $ed, $fd, $98, $00, $ed, $05, $99, $00, $f5, $ed, $9a, $10
    db $f5, $f5, $9b, $10, $f5, $fd, $9c, $10, $f5, $05, $9d, $10, $fd, $f4, $9e, $10
    db $fd, $fc, $9f, $10, $fd, $04, $7c, $10, $80

SpriteFrameData_27aa::
    db $e5, $f4, $a0, $10, $e5, $fc, $a1, $10, $ea, $ec, $a2, $10, $ed, $f4, $a3, $10
    db $ed, $fc, $a4, $10, $ea, $04, $a5, $10, $f5, $f4, $a6, $10, $f5, $fc, $a7, $10
    db $f2, $04, $a8, $10, $f6, $0c, $8d, $10, $fd, $f4, $8e, $10, $fd, $fc, $9f, $10
    db $fa, $04, $8f, $10, $80

SpriteFrameData_27df::
    db $f8, $fc, $70, $00, $80

SpriteFrameData_27e4::
    db $db, $f7, $70, $10, $db, $ff, $71, $10, $e3, $f0, $72, $00, $e3, $f8, $73, $00
    db $e3, $00, $74, $00, $e3, $08, $75, $00, $eb, $f0, $76, $00, $eb, $f8, $77, $00
    db $eb, $00, $78, $00, $eb, $08, $79, $00, $f3, $f4, $7a, $10, $f3, $fc, $7b, $10
    db $f3, $04, $b9, $10, $fb, $f9, $7c, $10, $fb, $00, $7c, $10, $80

SpriteFrameData_2821::
    db $dc, $f7, $70, $10, $dc, $ff, $71, $10, $e4, $f0, $7e, $00, $e4, $f8, $73, $00
    db $e4, $00, $74, $00, $e4, $08, $7f, $00, $ec, $f0, $80, $00, $ec, $f8, $77, $00
    db $ec, $00, $78, $00, $ec, $08, $81, $00, $f4, $f1, $82, $10, $f4, $f9, $83, $10
    db $f4, $01, $84, $10, $fc, $f7, $85, $10, $fc, $ff, $86, $10, $80

SpriteFrameData_285e::
    db $dc, $f7, $70, $10, $dc, $ff, $71, $10, $e4, $f2, $87, $00, $e4, $fa, $88, $00
    db $e4, $02, $89, $00, $ec, $f2, $8a, $00, $ec, $fa, $8b, $00, $ec, $02, $8c, $00
    db $f4, $f2, $8d, $10, $f4, $fa, $8e, $10, $f4, $02, $8f, $10, $fc, $f5, $90, $10
    db $fc, $02, $7d, $10, $80

SpriteFrameData_2893::
    db $e0, $f0, $92, $10, $e0, $f8, $93, $10, $e0, $00, $94, $10, $e8, $f0, $95, $00
    db $e8, $f8, $96, $00, $e8, $00, $97, $00, $e8, $08, $98, $00, $f0, $f0, $99, $00
    db $f0, $f8, $9a, $00, $f0, $00, $9b, $00, $f0, $08, $9c, $00, $f8, $f8, $9d, $10
    db $f8, $00, $9e, $10, $f8, $08, $9f, $10, $80

SpriteFrameData_28cc::
    db $e0, $f7, $a0, $10, $e0, $ff, $a1, $10, $e0, $08, $a2, $10, $e8, $f0, $7e, $00
    db $e8, $f8, $73, $00, $e8, $00, $a3, $00, $e8, $08, $a4, $00, $f0, $f0, $80, $00
    db $f0, $f8, $a5, $00, $f0, $00, $a6, $00, $f0, $08, $a7, $00, $f8, $f6, $a8, $10
    db $f8, $fe, $a9, $10, $f8, $06, $aa, $10, $f8, $0e, $91, $10, $80

SpriteFrameData_2909::
    db $e1, $f7, $a0, $10, $e1, $ff, $a1, $10, $e9, $f0, $ac, $00, $e9, $f8, $73, $00
    db $e9, $00, $74, $00, $e9, $08, $ad, $00, $f1, $f0, $ae, $00, $f1, $f8, $b1, $00
    db $f1, $00, $ab, $00, $f1, $08, $af, $00, $f9, $f6, $a8, $10, $f9, $fe, $a9, $10
    db $f9, $06, $b0, $10, $80

SpriteFrameData_293e::
    db $db, $f7, $70, $10, $db, $ff, $71, $10, $e3, $f3, $b3, $00, $e3, $fb, $b4, $00
    db $e3, $03, $bf, $00, $eb, $f3, $b6, $00, $eb, $fb, $b7, $00, $eb, $03, $b8, $00
    db $f3, $f4, $7a, $10, $f3, $fc, $7b, $10, $f3, $04, $b9, $10, $fb, $f9, $7c, $10
    db $fb, $00, $7c, $10, $80

SpriteFrameData_2973::
    db $e3, $fa, $c5, $10, $e3, $00, $70, $10, $e3, $08, $71, $10, $eb, $f4, $bc, $10
    db $eb, $fc, $bd, $00, $eb, $04, $b4, $00, $eb, $0c, $bf, $00, $f3, $f6, $b2, $10
    db $f3, $fe, $b5, $10, $f3, $06, $ba, $00, $f3, $0e, $bb, $00, $fb, $f9, $be, $10
    db $fb, $06, $7c, $10, $f8, $0e, $cf, $00, $80

SpriteFrameData_29ac::
    db $d9, $fa, $c5, $10, $e1, $f7, $c6, $00, $e1, $ff, $c7, $00, $e8, $ef, $c0, $00
    db $e8, $f7, $c1, $00, $e9, $ff, $ca, $00, $e8, $07, $c0, $20, $f0, $ef, $c2, $00
    db $f0, $f7, $cc, $00, $f0, $ff, $cc, $00, $f0, $07, $c2, $20, $f8, $ef, $c3, $10
    db $f8, $f7, $ce, $10, $f8, $ff, $c4, $10, $f8, $07, $c3, $30, $80

SpriteFrameData_29e9::
    db $d8, $fa, $c5, $10, $e0, $f7, $c6, $00, $e0, $ff, $c7, $00, $e8, $ef, $c8, $00
    db $e8, $f7, $c9, $00, $e8, $ff, $ca, $00, $e8, $07, $c8, $20, $f0, $ef, $cb, $00
    db $f0, $f7, $cc, $00, $f0, $ff, $cc, $00, $f0, $07, $cb, $20, $f8, $ef, $cd, $10
    db $f8, $f7, $ce, $10, $f8, $ff, $c4, $10, $f8, $07, $cd, $30, $80

SpriteFrameData_2a26::
    db $f8, $fc, $cf, $00, $80

SpriteFrameData_2a2b::
    db $eb, $f8, $00, $01, $eb, $00, $01, $01, $f3, $f8, $02, $01, $f3, $00, $03, $01
    db $fb, $f8, $04, $01, $fb, $00, $05, $01, $80

SpriteFrameData_2a44::
    db $eb, $f8, $06, $01, $eb, $00, $07, $01, $f3, $f8, $08, $01, $f3, $00, $09, $01
    db $fb, $f8, $0a, $01, $fb, $00, $0b, $01, $80

SpriteFrameData_2a5d::
    db $eb, $fc, $0c, $01, $f3, $f8, $0d, $01, $f3, $00, $0e, $01, $fb, $f8, $0f, $01
    db $fb, $00, $10, $01, $80

SpriteFrameData_2a72::
    db $eb, $00, $11, $01, $f3, $f7, $11, $21, $f3, $00, $12, $01, $80

SpriteFrameData_2a7f::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01
    db $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_2a98::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $19, $01, $f4, $00, $1a, $01
    db $fc, $f8, $1b, $01, $fc, $00, $1c, $01, $80

SpriteFrameData_2ab1::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $1d, $01, $f4, $00, $1e, $01
    db $fc, $f8, $1f, $01, $fc, $00, $20, $01, $80

SpriteFrameData_2aca::
    db $eb, $f8, $21, $01, $eb, $00, $22, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01
    db $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_2ae3::
    db $ed, $f8, $23, $01, $ed, $00, $24, $01, $f5, $f8, $25, $01, $f5, $00, $26, $01
    db $fd, $f8, $27, $01, $fd, $00, $28, $01, $80

SpriteFrameData_2afc::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f9, $29, $01, $f4, $01, $2a, $01
    db $f4, $09, $2b, $01, $f1, $0d, $2d, $01, $fc, $f7, $1f, $01, $fc, $ff, $2c, $01
    db $80

SpriteFrameData_2b1d::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $ee, $12, $2e, $01, $f4, $f9, $29, $01
    db $f4, $01, $2a, $01, $f4, $09, $2b, $01, $fc, $f7, $1f, $01, $fc, $ff, $2c, $01
    db $80

SpriteFrameData_2b3e::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f9, $29, $01, $f4, $01, $2a, $01
    db $f4, $09, $2b, $01, $fc, $f7, $1f, $01, $fc, $ff, $2c, $01, $80

SpriteFrameData_2b5b::
    db $f0, $f8, $2f, $01, $f0, $00, $30, $01, $f8, $f8, $31, $01, $f8, $00, $32, $01
    db $80

SpriteFrameData_2b6c::
    db $f0, $f8, $33, $01, $f0, $00, $34, $01, $f8, $f8, $35, $01, $f8, $00, $32, $01
    db $80

SpriteFrameData_2b7d::
    db $eb, $f8, $36, $01, $eb, $00, $37, $01, $f3, $f8, $38, $01, $f3, $00, $39, $01
    db $fb, $fc, $3a, $01, $80

SpriteFrameData_2b92::
    db $ec, $f8, $3b, $01, $ec, $00, $3c, $01, $f4, $f1, $3d, $01, $f4, $f9, $3e, $01
    db $f4, $01, $3f, $01, $fc, $f8, $40, $01, $fc, $00, $41, $01, $80

SpriteFrameData_2baf::
    db $ef, $f8, $42, $01, $ef, $00, $43, $01, $f7, $f8, $47, $01, $f7, $00, $48, $01
    db $fe, $f8, $46, $01, $fe, $00, $46, $21, $80

SpriteFrameData_2bc8::
    db $ee, $f8, $42, $01, $ee, $00, $43, $01, $f6, $f8, $44, $01, $f6, $00, $45, $01
    db $fe, $f8, $46, $01, $fe, $00, $46, $21, $80

SpriteFrameData_2be1::
    db $eb, $f8, $49, $01, $eb, $00, $4a, $01, $f3, $f8, $4b, $01, $f3, $00, $4c, $01
    db $fb, $fc, $3a, $01, $80

SpriteFrameData_2bf6::
    db $eb, $f8, $4d, $01, $eb, $00, $4e, $01, $f3, $f8, $4f, $01, $f3, $00, $50, $01
    db $fa, $f8, $1f, $01, $fa, $00, $20, $01, $80

SpriteFrameData_2c0f::
    db $eb, $f8, $51, $01, $eb, $00, $52, $01, $f3, $f8, $53, $01, $f3, $00, $54, $01
    db $fa, $f8, $1b, $01, $fa, $00, $1c, $01, $80

SpriteFrameData_2c28::
    db $eb, $f8, $eb, $01, $eb, $00, $ec, $01, $f3, $f8, $ed, $01, $f3, $00, $ee, $01
    db $fb, $f9, $ef, $21, $fb, $00, $ef, $01, $80

SpriteFrameData_2c41:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $d0, $10, $f8, $00, $d1
    db $10, $00, $f8, $d2, $10, $00, $00, $d3, $10, $80

SpriteFrameData_2c52:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $d4, $10, $f8, $00
    db $d5, $10, $00, $f8, $d6, $10, $00, $00, $d7, $10, $80

SpriteFrameData_2c63:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $d8, $10, $f8
    db $00, $d9, $10, $00, $f8, $da, $10, $00, $00, $db, $10, $80

SpriteFrameData_2c74:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $dc, $10
    db $f8, $00, $dd, $10, $00, $f8, $d2, $10, $00, $00, $de, $10, $80

SpriteFrameData_2c85:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $fc, $df
    db $10, $00, $fc, $e0, $10, $80

SpriteFrameData_2c8e:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $e1, $10, $f8, $00, $e2, $10, $00, $f8
    db $e3, $10, $00, $00, $e4, $10, $80

SpriteFrameData_2c9f:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $e5, $10, $f8, $00, $e6, $10, $00
    db $f8, $e7, $10, $00, $00, $e8, $10, $80, $f0, $fc, $e9, $10, $f8, $fc, $ea, $10
    db $80

SpriteFrameData_2cb9::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f4, $f0, $19, $01, $f3, $f8, $15, $01
    db $f3, $00, $16, $01, $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_2cd6::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f0, $1e, $01, $f4, $f8, $1a, $01
    db $f4, $00, $1b, $01, $fc, $f8, $1c, $01, $fc, $00, $1d, $01, $80

SpriteFrameData_2cf3::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f0, $1e, $01, $f4, $f8, $1f, $01
    db $f4, $00, $20, $01, $fc, $f8, $21, $01, $fc, $00, $22, $01, $80

SpriteFrameData_2d10::
    db $ed, $f8, $23, $01, $ed, $00, $24, $01, $f5, $f0, $29, $01, $f5, $f8, $25, $01
    db $f5, $00, $26, $01, $fd, $f8, $27, $01, $fd, $00, $28, $01, $80

SpriteFrameData_2d2d::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f1, $29, $01, $f4, $f9, $2a, $01
    db $f4, $01, $2b, $01, $f4, $09, $2c, $01, $f1, $0d, $2f, $01, $fc, $f9, $2d, $01
    db $fc, $01, $2e, $01, $80

SpriteFrameData_2d52::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $ee, $12, $30, $01, $f4, $f1, $29, $01
    db $f4, $f9, $2a, $01, $f4, $01, $2b, $01, $f4, $09, $2c, $01, $fc, $f9, $2d, $01
    db $fc, $01, $2e, $01, $80

SpriteFrameData_2d77::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f1, $29, $01, $f4, $f9, $2a, $01
    db $f4, $01, $2b, $01, $f4, $09, $2c, $01, $fc, $f9, $2d, $01, $fc, $01, $2e, $01
    db $80

SpriteFrameData_2d98::
    db $f0, $f8, $31, $01, $f0, $00, $32, $01, $f8, $f8, $33, $01, $f8, $00, $34, $01
    db $80

SpriteFrameData_2da9::
    db $e8, $f8, $13, $01, $e8, $00, $14, $01, $f0, $f1, $35, $01, $f0, $f9, $36, $01
    db $f0, $01, $37, $01, $f8, $f5, $38, $01, $f8, $fd, $39, $01, $80

SpriteFrameData_2dc6::
    db $e7, $f8, $13, $01, $e7, $00, $14, $01, $ef, $f0, $3a, $01, $ef, $f8, $3b, $01
    db $ef, $00, $3c, $01, $f7, $f5, $3d, $01, $f7, $fd, $3e, $01, $80

SpriteFrameData_2de3::
    db $ef, $f8, $3f, $01, $ef, $00, $40, $01, $f7, $f8, $44, $01, $f7, $00, $45, $01
    db $fe, $f8, $43, $01, $fe, $00, $43, $21, $80

SpriteFrameData_2dfc::
    db $ee, $f8, $3f, $01, $ee, $00, $40, $01, $f6, $f8, $41, $01, $f6, $00, $42, $01
    db $fe, $f8, $43, $01, $fe, $00, $43, $21, $80

SpriteFrameData_2e15::
    db $eb, $f8, $46, $01, $eb, $00, $47, $01, $f3, $f8, $48, $01, $f3, $00, $49, $01
    db $fb, $f8, $4a, $01, $fb, $00, $4b, $01, $80

SpriteFrameData_2e2e::
    db $eb, $f8, $4c, $01, $eb, $00, $4d, $01, $f3, $f8, $4e, $01, $f3, $00, $4f, $01
    db $fb, $f8, $50, $01, $fb, $00, $51, $01, $80

SpriteFrameData_2e47::
    db $eb, $f8, $52, $01, $eb, $00, $53, $01, $f3, $f8, $54, $01, $f3, $00, $55, $01
    db $fb, $f8, $56, $01, $fb, $00, $57, $01, $80

SpriteFrameData_2e60::
    db $e7, $f8, $58, $01, $e7, $00, $59, $01, $ef, $f8, $5a, $01, $ef, $00, $5b, $01
    db $f7, $f5, $5c, $01, $f7, $fd, $39, $01, $80

SpriteFrameData_2e79::
    db $e8, $f8, $58, $01, $e8, $00, $59, $01, $f0, $f1, $5d, $01, $f0, $f9, $5e, $01
    db $f0, $01, $5f, $01, $f8, $f2, $60, $01, $f8, $fa, $61, $01, $80

SpriteFrameData_2e96:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $fc, $fc, $62
    db $00, $80

SpriteFrameData_2e9b:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $fc, $fc, $63, $00, $80

SpriteFrameData_2ea0::
    db $ec, $f9, $13, $01, $ec, $01, $14, $01, $f4, $f2, $64, $01, $f4, $fa, $36, $01
    db $f4, $01, $3c, $01, $fc, $f9, $2d, $01, $fc, $01, $2e, $01, $80

SpriteFrameData_2ebd::
    db $ec, $fb, $58, $01, $ec, $03, $59, $01, $f4, $f5, $65, $01, $f4, $fc, $5e, $01
    db $f4, $04, $5f, $01, $fc, $f9, $2d, $01, $fc, $01, $2e, $01, $80, $eb, $f8, $00
    db $01, $eb, $00, $01, $01, $f3, $f8, $02, $01, $f3, $00, $03, $01, $fb, $f8, $04
    db $01, $fb, $00, $05, $01, $80, $eb, $f8, $06, $01, $eb, $00, $07, $01, $f3, $f8
    db $08, $01, $f3, $00, $09, $01, $fb, $f8, $0a, $01, $fb, $00, $0b, $01, $80, $eb
    db $fc, $0c, $01, $f3, $f8, $0d, $01, $f3, $00, $0e, $01, $fb, $f8, $0f, $01, $fb
    db $00, $10, $01, $80, $eb, $00, $11, $01, $f3, $f7, $11, $21, $f3, $00, $12, $01
    db $80

SpriteFrameData_2f2e::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f0, $15, $01, $f3, $f8, $16, $01
    db $f3, $00, $17, $01, $fb, $f8, $18, $01, $fb, $00, $19, $01, $80

SpriteFrameData_2f4b::
    db $ec, $f9, $13, $01, $ec, $01, $14, $01, $f4, $f1, $1a, $01, $f4, $f9, $1b, $01
    db $f4, $01, $1c, $01, $fc, $f8, $1d, $01, $fc, $00, $1e, $01, $80

SpriteFrameData_2f68::
    db $ed, $f8, $1f, $01, $ed, $00, $20, $01, $f5, $f0, $21, $01, $f5, $f8, $22, $01
    db $f5, $00, $23, $01, $fd, $f8, $24, $01, $fd, $00, $25, $01, $80

SpriteFrameData_2f85::
    db $ec, $f9, $1f, $01, $ec, $01, $20, $01, $f4, $f7, $26, $01, $f4, $ff, $27, $01
    db $f4, $07, $28, $01, $f1, $0d, $2b, $01, $fc, $f9, $29, $01, $fc, $01, $2a, $01
    db $80

SpriteFrameData_2fa6::
    db $ec, $f9, $1f, $01, $ec, $01, $20, $01, $ee, $12, $2c, $01, $f4, $f7, $26, $01
    db $f4, $ff, $27, $01, $f4, $07, $28, $01, $fc, $f9, $29, $01, $fc, $01, $2a, $01
    db $80

SpriteFrameData_2fc7::
    db $ec, $f9, $1f, $01, $ec, $01, $20, $01, $f4, $f7, $26, $01, $f4, $ff, $27, $01
    db $f4, $07, $28, $01, $fc, $f9, $29, $01, $fc, $01, $2a, $01, $80

SpriteFrameData_2fe4::
    db $f0, $f8, $2d, $01, $f0, $00, $2e, $01, $f8, $f8, $2f, $01, $f8, $00, $30, $01
    db $80

SpriteFrameData_2ff5::
    db $eb, $f8, $31, $01, $eb, $00, $14, $01, $f3, $f0, $32, $01, $f3, $f8, $33, $01
    db $f3, $00, $34, $01, $fb, $f8, $35, $01, $fb, $00, $36, $01, $80

SpriteFrameData_3012::
    db $ea, $f8, $13, $01, $ea, $00, $14, $01, $f2, $f0, $37, $01, $f2, $f8, $38, $01
    db $f2, $00, $39, $01, $fa, $f8, $35, $01, $fa, $00, $36, $01, $80

SpriteFrameData_302f::
    db $ef, $f8, $3a, $01, $ef, $00, $3b, $01, $f7, $f8, $3f, $01, $f7, $00, $40, $01
    db $fe, $f8, $3e, $01, $fe, $00, $3e, $21, $80

SpriteFrameData_3048::
    db $ee, $f8, $3a, $01, $ee, $00, $3b, $01, $f6, $f8, $3c, $01, $f6, $00, $3d, $01
    db $fe, $f8, $3e, $01, $fe, $00, $3e, $21, $80

SpriteFrameData_3061::
    db $eb, $f8, $41, $01, $eb, $00, $42, $01, $f3, $f8, $43, $01, $f3, $00, $44, $01
    db $fb, $fc, $45, $01, $80

SpriteFrameData_3076::
    db $eb, $f8, $46, $01, $eb, $00, $47, $01, $f3, $f8, $48, $01, $f3, $00, $49, $01
    db $fb, $f8, $4a, $01, $fb, $00, $4b, $01, $80

SpriteFrameData_308f::
    db $eb, $f8, $4c, $01, $eb, $00, $4d, $01, $f3, $f8, $4e, $01, $f3, $00, $4f, $01
    db $fb, $f8, $50, $01, $fb, $00, $51, $01, $80

SpriteFrameData_30a8::
    db $ec, $f8, $31, $01, $ec, $00, $14, $01, $f4, $f0, $32, $01, $f4, $f8, $33, $01
    db $f4, $00, $17, $01, $fc, $f8, $1d, $01, $fc, $00, $1e, $01, $80

SpriteFrameData_30c5::
    db $ec, $f9, $52, $01, $ec, $01, $53, $01, $f4, $f2, $54, $01, $f4, $fa, $55, $01
    db $f4, $02, $56, $01, $fc, $f8, $57, $01, $fc, $00, $1e, $01, $80

SpriteFrameData_30e2:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $fc, $fc, $58
    db $01, $80

SpriteFrameData_30e7::
    db $eb, $f8, $52, $01, $eb, $00, $53, $01, $f3, $f1, $54, $01, $f3, $f9, $55, $01
    db $f3, $01, $56, $01, $fb, $f8, $35, $01, $fb, $00, $36, $01, $80

SpriteFrameData_3104::
    db $ea, $f8, $52, $01, $ea, $00, $53, $01, $f2, $f1, $54, $01, $f2, $f9, $55, $01
    db $f2, $01, $56, $01, $fa, $f8, $35, $01, $fa, $00, $36, $01, $80

SpriteFrameData_3121::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01
    db $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_313a::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $19, $01, $f4, $00, $1a, $01
    db $fc, $f8, $1b, $01, $fc, $00, $1c, $01, $80

SpriteFrameData_3153::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $1d, $01, $f4, $00, $1e, $01
    db $fc, $f8, $1f, $01, $fc, $00, $20, $01, $80

SpriteFrameData_316c::
    db $ed, $f8, $21, $01, $ed, $00, $22, $01, $f5, $f8, $23, $01, $f5, $00, $24, $01
    db $fd, $f8, $25, $01, $fd, $00, $26, $01, $80

SpriteFrameData_3185::
    db $ec, $f9, $21, $01, $ec, $01, $22, $01, $f4, $f9, $27, $01, $f4, $01, $28, $01
    db $f4, $09, $29, $01, $f1, $0d, $2b, $01, $fc, $f7, $1f, $01, $fc, $ff, $2a, $01
    db $80

SpriteFrameData_31a6::
    db $ec, $f9, $21, $01, $ec, $01, $22, $01, $ee, $12, $2c, $01, $f4, $f9, $27, $01
    db $f4, $01, $28, $01, $f4, $09, $29, $01, $fc, $f7, $1f, $01, $fc, $ff, $2a, $01
    db $80

SpriteFrameData_31c7::
    db $ec, $f9, $21, $01, $ec, $01, $22, $01, $f4, $f9, $27, $01, $f4, $01, $28, $01
    db $f4, $09, $29, $01, $fc, $f7, $1f, $01, $fc, $ff, $2a, $01, $80

SpriteFrameData_31e4::
    db $f0, $f8, $2d, $01, $f0, $00, $2e, $01, $f8, $f8, $2f, $01, $f8, $00, $30, $01
    db $80

SpriteFrameData_31f5::
    db $eb, $f8, $31, $01, $eb, $00, $32, $01, $f3, $f8, $33, $01, $f3, $00, $34, $01
    db $fb, $fc, $35, $01, $80

SpriteFrameData_320a::
    db $ec, $f8, $36, $01, $ec, $00, $37, $01, $f4, $f1, $38, $01, $f4, $f9, $39, $01
    db $f4, $01, $3a, $01, $fc, $f8, $3b, $01, $fc, $00, $3c, $01, $80

SpriteFrameData_3227::
    db $ef, $f8, $3d, $01, $ef, $00, $3e, $01, $f7, $f8, $42, $01, $f7, $00, $43, $01
    db $fe, $f8, $44, $01, $fe, $00, $44, $21, $80

SpriteFrameData_3240::
    db $ee, $f8, $3d, $01, $ee, $00, $3e, $01, $f6, $f8, $3f, $01, $f6, $00, $40, $01
    db $fe, $f8, $44, $01, $fe, $00, $44, $21, $80

SpriteFrameData_3259::
    db $eb, $f8, $45, $01, $eb, $00, $46, $01, $f3, $f8, $47, $01, $f3, $00, $48, $01
    db $fb, $fc, $35, $01, $80

SpriteFrameData_326e::
    db $eb, $f8, $49, $01, $eb, $00, $4a, $01, $f3, $f8, $4b, $01, $f3, $00, $4c, $01
    db $fa, $f8, $1f, $01, $fa, $00, $20, $01, $80

SpriteFrameData_3287::
    db $eb, $f8, $4d, $01, $eb, $00, $4e, $01, $f3, $f8, $4f, $01, $f3, $00, $50, $01
    db $fa, $f8, $1b, $01, $fa, $00, $1c, $01, $80

SpriteFrameData_32a0::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $51, $01, $f3, $00, $52, $01
    db $fb, $f9, $53, $21, $fb, $00, $53, $01, $80

SpriteFrameData_32b9::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $54, $01, $f4, $00, $55, $01
    db $fc, $f9, $56, $21, $fc, $00, $56, $01, $80

SpriteFrameData_32d2:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $57, $01, $f8, $00, $58
    db $01, $fb, $08, $59, $01, $00, $f8, $57, $41, $00, $00, $58, $41, $80

SpriteFrameData_32e7:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f7, $f8
    db $57, $01, $f7, $00, $58, $01, $fa, $08, $59, $01, $ff, $f8, $57, $41, $ff, $00
    db $58, $41, $80

SpriteFrameData_32fc::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $54, $01, $f4, $00, $55, $01
    db $f0, $08, $58, $01, $f3, $10, $59, $01, $fc, $f9, $56, $21, $fc, $00, $56, $01
    db $f8, $08, $58, $41, $80

SpriteFrameData_3321::
    db $f8, $04, $18, $01, $f8, $fc, $17, $01, $f8, $f4, $16, $01, $f0, $04, $15, $01
    db $f0, $fc, $14, $01, $f0, $f4, $13, $01, $80

SpriteFrameData_333a::
    db $f9, $04, $1b, $01, $f9, $fc, $1a, $01, $f9, $f4, $19, $01, $f1, $04, $15, $01
    db $f1, $fc, $14, $01, $f1, $f4, $13, $01, $80

SpriteFrameData_3353::
    db $f8, $00, $1f, $01, $f8, $f8, $1e, $01, $f0, $00, $1d, $01, $f0, $f8, $1c, $01
    db $80

SpriteFrameData_3364::
    db $f5, $0c, $23, $01, $f0, $f9, $1c, $01, $f0, $01, $1d, $01, $f8, $08, $22, $01
    db $f8, $00, $21, $01, $f8, $f8, $20, $01, $80

SpriteFrameData_337d::
    db $f2, $11, $24, $01, $f0, $f9, $1c, $01, $f0, $01, $1d, $01, $f8, $08, $22, $01
    db $f8, $00, $21, $01, $f8, $f8, $20, $01, $80

SpriteFrameData_3396::
    db $f0, $f9, $1c, $01, $f0, $01, $1d, $01, $f8, $08, $22, $01, $f8, $00, $21, $01
    db $f8, $f8, $20, $01, $80

SpriteFrameData_33ab::
    db $f8, $04, $18, $01, $f0, $04, $15, $01, $f8, $fc, $17, $01, $f0, $fc, $26, $01
    db $f8, $f4, $27, $01, $f0, $f4, $25, $01, $80

SpriteFrameData_33c4::
    db $f8, $04, $18, $01, $f8, $fc, $17, $01, $f8, $f4, $29, $01, $f0, $04, $15, $01
    db $f0, $fc, $26, $01, $f0, $f4, $28, $01, $80

SpriteFrameData_33dd::
    db $ef, $00, $2b, $01, $ef, $f8, $2a, $01, $f7, $00, $31, $01, $f7, $f8, $30, $01
    db $ff, $f8, $32, $01, $ff, $00, $33, $01, $80

SpriteFrameData_33f6::
    db $fe, $00, $2f, $01, $fe, $f8, $2e, $01, $f6, $00, $2d, $01, $f6, $f8, $2c, $01
    db $ee, $00, $2b, $01, $ee, $f8, $2a, $01, $80

SpriteFrameData_340f::
    db $eb, $00, $35, $01, $eb, $f8, $34, $01, $f3, $00, $37, $01, $f3, $f8, $36, $01
    db $fb, $00, $39, $01, $fb, $f8, $38, $01, $80

SpriteFrameData_3428::
    db $eb, $00, $3b, $01, $eb, $f8, $3a, $01, $f3, $00, $3d, $01, $f3, $f8, $3c, $01
    db $fb, $00, $3f, $01, $fb, $f8, $3e, $01, $80

SpriteFrameData_3441::
    db $eb, $00, $41, $01, $eb, $f8, $40, $01, $f3, $00, $43, $01, $f3, $f8, $42, $01
    db $fb, $00, $45, $01, $fb, $f8, $44, $01, $80

SpriteFrameData_345a::
    db $f0, $08, $47, $01, $f0, $10, $48, $01, $f0, $04, $46, $01, $f8, $04, $18, $01
    db $f8, $fc, $17, $01, $f0, $fc, $14, $01, $f0, $f4, $13, $01, $f8, $f4, $16, $01
    db $80

SpriteFrameData_347b::
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $14, $01, $f8, $fc, $17, $01, $f0, $f4, $13, $01
    db $f8, $f4, $16, $01, $80

SpriteFrameData_34a0::
    db $f1, $1c, $48, $01, $f1, $14, $47, $01, $f1, $0c, $47, $01, $f1, $04, $46, $01
    db $f9, $04, $1b, $01, $f1, $fc, $14, $01, $f9, $fc, $1a, $01, $f1, $f4, $13, $01
    db $f9, $f4, $19, $01, $80

SpriteFrameData_34c5::
    db $f0, $08, $47, $01, $f0, $10, $48, $01, $f0, $04, $46, $01, $f8, $04, $18, $01
    db $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $25, $01, $f8, $f4, $27, $01
    db $80

SpriteFrameData_34e6::
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $25, $01
    db $f8, $f4, $27, $01, $80

SpriteFrameData_350b::
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $28, $01
    db $f8, $f4, $29, $01, $80

SpriteFrameData_3530::
    db $f1, $10, $48, $01, $f1, $08, $47, $01, $f1, $04, $46, $01, $f1, $fc, $14, $01
    db $f1, $f4, $13, $01, $f9, $04, $1b, $01, $f9, $fc, $1a, $01, $f9, $f4, $19, $01
    db $80

SpriteFrameData_3551::
    db $F0, $10, $48, $01, $F0, $08, $47, $01, $F0, $04, $46, $01, $F8, $04, $18, $01
    db $F0, $FC, $26, $01, $F8, $FC, $17, $01, $F0, $F4, $28, $01, $F8, $F4, $29, $01
    db $80

Bank0TrailingGraphicsData_3572:: ; tile/graphics data after the final sprite frame terminator.
    db $00, $FF, $7E, $81, $7E, $81, $7E, $81, $7E, $81, $7E, $81, $7E, $81, $00
    db $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FF, $FE, $01, $FE, $01, $FE
    db $01, $AA, $01, $D6, $01, $AA, $01, $D6, $01, $AA, $01, $D6, $01, $AA, $01, $D6
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00, $80, $00, $FF, $00, $80
    db $00, $02, $05, $02, $05, $02, $05, $02, $05, $FF, $00, $01, $00, $FF, $00, $01
    db $00, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F
    db $80, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE
    db $01, $00, $C0, $C0, $20, $20, $D0, $D0, $28, $A8, $14, $D4, $0A, $AA, $05, $D4
    db $03, $FF, $FF, $7F, $80, $00, $FF, $7F, $80, $7F, $80, $7F, $80, $7F, $80, $7F
    db $80, $FF, $FF, $FE, $01, $00, $FF, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $FF, $FF, $FF, $7F, $80, $00, $FF, $40, $A0, $40, $A0, $40, $A0, $40, $A0, $40
    db $A0, $FF, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $FF, $7E, $81, $7E
    db $81, $FF, $FF, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $0F, $07, $08, $07
    db $08, $FF, $FF, $FE, $01, $00, $FF, $02, $05, $02, $05, $02, $F5, $E2, $15, $E2
    db $15, $40, $AF, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $40
    db $BF, $1E, $E1, $9E, $21, $DE, $21, $DE, $21, $DE, $21, $DE, $21, $DE, $21, $00
    db $FF, $00, $7F, $38, $41, $38, $41, $3E, $41, $3E, $41, $3E, $41, $3E, $41, $00
    db $FF, $E2, $15, $E2, $15, $E2, $15, $E2, $15, $E2, $15, $E2, $15, $E2, $15, $02
    db $FD, $40, $A0, $40, $A0, $40, $A0, $40, $AF, $47, $A8, $47, $A8, $47, $A8, $47
    db $A8, $00, $00, $00, $00, $00, $00, $00, $FE, $FC, $02, $FC, $02, $80, $7F, $BE
    db $41, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $04, $03, $04, $03
    db $04, $02, $05, $02, $05, $02, $05, $02, $05, $02, $F5, $E2, $15, $E2, $15, $E2
    db $15, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $47, $A8, $40
    db $BF, $00, $00, $00, $00, $00, $00, $08, $00, $08, $00, $08, $00, $38, $00, $F8
    db $00, $3C, $00, $3F, $00, $3F, $00, $3F, $00, $1F, $00, $0F, $00, $0F, $00, $0F
    db $00, $3C, $00, $FC, $00, $FC, $00, $FC, $00, $F8, $00, $F0, $00, $F0, $00, $F0
    db $00, $1F, $00, $1F, $00, $1F, $00, $0F, $00, $07, $00, $03, $00, $01, $00, $00
    db $00, $F8, $00, $F8, $00, $F8, $00, $F0, $00, $E0, $00, $C0, $00, $80, $00, $00
    db $00, $00, $00, $18, $00, $24, $00, $44, $00, $5C, $00, $60, $00, $60, $00, $60
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00, $FF
    db $FF, $01, $00, $02, $00, $02, $00, $02, $00, $05, $00, $05, $00, $05, $00, $0A
    db $00, $00, $00, $80, $00, $80, $00, $80, $00, $40, $00, $40, $00, $40, $00, $A0
    db $00, $0A, $00, $0A, $00, $15, $00, $15, $00, $17, $00, $2E, $00, $3A, $00, $2A
    db $00, $A0, $00, $A0, $00, $50, $00, $50, $00, $D0, $00, $E8, $00, $B8, $00, $A8
    db $00, $55, $00, $55, $00, $55, $00, $2A, $00, $2A, $00, $15, $00, $0D, $00, $03
    db $00, $54, $00, $54, $00, $54, $00, $A8, $00, $A8, $00, $50, $00, $60, $00, $80
    db $00, $00, $00, $00, $00, $01, $00, $02, $00, $04, $00, $04, $00, $04, $00, $04
    db $00, $7C, $00, $82, $00, $01, $00, $01, $00, $01, $00, $01, $00, $03, $00, $06
    db $00, $04, $00, $0F, $00, $1C, $00, $38, $00, $70, $00, $E0, $00, $C0, $00, $00
    db $00, $1C, $00, $F0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $FF, $00, $80, $00, $FF, $00, $80, $00, $FF, $00, $80, $00, $FF, $00, $80
    db $00, $FE, $00, $02, $00, $FE, $00, $02, $00, $FE, $00, $02, $00, $FE, $00, $02
    db $00, $00, $80, $19, $80, $00, $80, $00, $80, $00, $80, $1C, $80, $1C, $80, $14
    db $80, $00, $00, $CE, $00, $00, $00, $00, $00, $00, $00, $EE, $00, $EC, $00, $CC
    db $00, $00, $01, $B0, $01, $00, $01, $00, $01, $00, $01, $CC, $01, $EC, $01, $E8
    db $01, $0F, $B0, $1F, $A0, $1F, $A0, $1F, $A0, $1F, $A0, $1F, $A0, $00, $FF, $00
    db $80, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00
    db $00, $F0, $0D, $F8, $05, $F8, $05, $F8, $05, $F8, $05, $F8, $05, $00, $FF, $00
    db $01, $60, $00, $60, $00, $60, $00, $60, $00, $60, $00, $60, $00, $60, $00, $60
    db $00, $00, $00, $00, $00, $00, $00, $10, $00, $10, $00, $10, $00, $1C, $00, $1F
    db $00, $FF, $FF, $0F, $80, $3F, $80, $3F, $80, $7F, $80, $7F, $80, $00, $FF, $FF
    db $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $FF
    db $FF, $FF, $FF, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $00, $FF, $FF
    db $FF, $00, $80, $00, $80, $7F, $80, $FF, $FF, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $FF, $00, $FF, $FF, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $01, $00, $01, $FE, $01, $FF, $FF, $00, $00, $00, $00, $00, $00, $00
    db $00

Bank0TrailingGraphicsData_3902:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f7, $00, $0f, $00, $ff, $00, $e3, $00, $dd, $00, $36, $00, $3e, $00, $1c
    db $00, $00, $00, $01, $00, $7F, $00, $07, $00, $1F, $00, $3F, $00, $3F, $00, $1F
    db $00, $00, $00, $C0, $00, $F0, $00, $F0, $00, $FC, $00, $FE, $00, $FE, $00, $FC
    db $00, $FF, $00, $80, $00, $9B, $00, $80, $00, $FF, $00, $80, $00, $BC, $00, $BC
    db $00, $FF, $00, $01, $00, $01, $00, $01, $00, $FF, $00, $01, $00, $69, $00, $01
    db $00, $AF, $50, $AF, $50, $AF, $50, $AF, $50, $AF, $50, $AF, $50, $AF, $50, $AF
    db $50, $20, $5F, $20, $50, $20, $50, $00, $70, $30, $88, $70, $88, $70, $88, $00
    db $70, $04, $FA, $04, $0A, $04, $0A, $00, $0E, $06, $11, $0E, $11, $0E, $11, $00
    db $0E, $F5, $0A, $F5, $0A, $F5, $0A, $F5, $0A, $F5, $0A, $F5, $0A, $F5, $0A, $F5
    db $0A, $00, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $20, $50, $20, $50, $20, $50, $20, $50, $20, $50, $20, $50, $20, $50, $20
    db $50, $04, $0A, $04, $0A, $04, $0A, $04, $0A, $04, $0A, $04, $0A, $04, $0A, $04
    db $0A, $7F, $00, $80, $00, $80, $00, $8F, $00, $9F, $00, $9E, $00, $9E, $00, $9E
    db $00, $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $00, $00, $00
    db $00, $FE, $00, $01, $00, $01, $00, $F1, $00, $F9, $00, $79, $00, $79, $00, $79
    db $00, $9E, $00, $9E, $00, $9E, $00, $9F, $00, $8F, $00, $80, $00, $80, $00, $96
    db $00, $00, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $7C, $00, $7F
    db $00, $79, $00, $79, $00, $79, $00, $F1, $00, $E1, $00, $01, $00, $C1, $00, $41
    db $00, $80, $00, $80, $00, $86, $00, $86, $00, $9F, $00, $9F, $00, $86, $19, $86
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $00, $03, $80, $07
    db $00, $01, $00, $01, $00, $01, $00, $01, $00, $19, $00, $3D, $00, $3D, $00, $99
    db $24, $80, $06, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $7F, $80, $00
    db $7F, $07, $00, $03, $04, $00, $03, $00, $00, $00, $00, $00, $00, $FF, $00, $00
    db $FF, $81, $18, $01, $80, $01, $00, $01, $00, $01, $00, $01, $00, $FE, $01, $00
    db $FE, $00, $FF, $7E, $81, $42, $81, $42, $81, $42, $81, $42, $81, $42, $81, $42
    db $81, $FF, $00, $FF, $00, $FF, $00, $C0, $00, $C0, $00, $C0, $00, $C0, $00, $C0
    db $00, $FF, $00, $FF, $00, $FF, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03
    db $00, $C0, $00, $C0, $00, $C0, $00, $C0, $00, $C0, $00, $FF, $00, $FF, $00, $FF
    db $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $FF, $00, $FF, $00, $FF
    db $00, $00, $00, $7E, $00, $7E, $00, $42, $00, $7E, $00, $7E, $00, $7E, $00, $7E
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $00, $66, $00, $18, $00, $7E
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0F
    db $00, $7D, $00, $BE, $00, $FF, $00, $E3, $00, $DD, $00, $36, $00, $3E, $00, $1C
    db $00, $AA, $00, $55, $00, $AA, $00, $55, $00, $AA, $00, $55, $00, $AA, $00, $55
    db $00, $FF, $00, $FF, $00, $A9, $00, $55, $00, $A9, $00, $55, $00, $A9, $00, $55
    db $00, $A9, $00, $55, $00, $A9, $00, $55, $00, $A9, $00, $55, $00, $A9, $00, $55
    db $00, $FF, $FF, $0F, $80, $3F, $80, $3F, $80, $7F, $80, $7F, $80, $00, $FF, $FF
    db $FF, $FF, $FF, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $FE, $01, $00, $FF, $FF
    db $FF, $FF, $00, $00, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00, $00, $00, $00
    db $00, $FF, $00, $F0, $00, $C0, $00, $83, $00, $8F, $00, $8F, $00, $C7, $00, $E0
    db $00, $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $BE
    db $00, $FF, $00, $0F, $00, $01, $00, $C0, $00, $F0, $00, $F8, $00, $F1, $00, $83
    db $00, $FF, $00, $FF, $00, $EF, $08, $FF, $98, $7F, $47, $38, $38, $60, $60, $FF
    db $C0, $FF, $00, $FF, $00, $FF, $00, $FF, $7F, $F0, $80, $18, $00, $0C, $00, $FF
    db $00, $FF, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
    db $00, $FF, $01, $FE, $02, $FD, $04, $FB, $08, $F7, $10, $F0, $20, $FF, $40, $FF
    db $7F, $FF, $01, $FE, $02, $FD, $04, $FB, $08, $F7, $10, $EF, $20, $DF, $40, $BF
    db $80, $7F, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
    db $00, $7F, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00, $FF
    db $FF, $E0, $80, $E0, $80, $E0, $80, $E0, $80, $E0, $80, $E0, $80, $E0, $80, $E0
    db $80, $07, $01, $07, $01, $07, $01, $07, $01, $07, $01, $07, $01, $07, $01, $07
    db $01, $E0, $80, $E0, $80, $E0, $80, $E0, $80, $E0, $80, $FF, $80, $FF, $80, $7F
    db $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00, $FF, $00, $FF
    db $FF, $07, $01, $07, $01, $07, $01, $07, $01, $07, $01, $FF, $01, $FF, $01, $FE
    db $FE, $FF, $00, $FF, $00, $AA, $00, $55, $00, $AA, $00, $55, $00, $22, $00, $00
    db $00, $FF, $00, $FF, $00, $AA, $00, $55, $00, $AA, $00, $55, $00, $AA, $00, $55
    db $00, $6A, $00, $55, $00, $6A, $00, $55, $00, $6A, $00, $55, $00, $6A, $00, $55
    db $00, $FF, $00, $FF, $00, $6A, $00, $55, $00, $6A, $00, $55, $00, $6A, $00, $55
    db $00

Bank0TrailingGraphicsData_3ca2:: ; SGB border source data used by bank 3 border upload path.
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $06, $09, $11, $12, $14, $14, $3F, $00, $01, $02, $02, $02, $02, $01
    db $00, $D8, $04, $04, $40, $00, $00, $00, $80, $E0, $1C, $02, $01, $00, $01, $00
    db $00, $00, $0E, $11, $A1, $4E, $B0, $60, $50, $00, $00, $00, $00, $00, $3C, $7F
    db $66, $46, $33, $0C, $13, $10, $20, $E9, $FA, $00, $81, $00, $C0, $3F, $88, $08
    db $44, $50, $10, $10, $20, $C0, $00, $60, $50, $00, $00, $00, $03, $0C, $10, $20
    db $20, $46, $86, $B8, $04, $04, $30, $48, $48, $3E, $0F, $00, $0F, $0F, $01, $71
    db $89, $84, $02, $83, $40, $A0, $A0, $AC, $B2, $50, $93, $27, $C9, $B2, $8C, $84
    db $83, $00, $80, $00, $00, $0E, $1C, $24, $C4, $40, $40, $40, $40, $26, $29, $19
    db $0E, $30, $01, $02, $02, $01, $00, $00, $00, $04, $82, $42, $42, $80, $00, $00
    db $02, $71, $70, $70, $10, $08, $08, $08, $10, $C1, $21, $10, $10, $08, $0B, $0C
    db $10, $08, $10, $E0, $80, $80, $00, $00, $00, $0D, $12, $13, $0C, $00, $00, $00
    db $00, $C0, $3F, $C0, $01, $02, $02, $01, $00, $0D, $F0, $80, $80, $4F, $70, $80
    db $00, $E0, $00, $03, $1C, $E0, $00, $00, $00, $20, $C0, $00, $00, $00, $00, $00
    db $00, $99, $99, $99, $99, $99, $99, $99, $99, $FF, $00, $00, $FF, $FF, $00, $00
    db $FF, $0F, $30, $40, $47, $8F, $9E, $9C, $98, $00, $00, $03, $1F, $3F, $71, $70
    db $67, $1F, $FF, $C1, $03, $87, $86, $01, $82, $F0, $FE, $FF, $FB, $1D, $0C, $F0
    db $08, $00, $00, $80, $C0, $E0, $F0, $F0, $78, $00, $00, $00, $00, $01, $01, $02
    db $02, $28, $20, $41, $83, $03, $03, $01, $00, $44, $20, $C0, $E0, $60, $E0, $C0
    db $00, $04, $70, $F8, $D8, $F8, $71, $02, $1C, $04, $02, $02, $02, $02, $C4, $38
    db $20, $02, $02, $01, $00, $00, $00, $00, $00, $00, $00, $01, $82, $62, $5F, $80
    db $80, $00, $03, $9E, $61, $41, $88, $80, $80, $20, $FF, $0E, $01, $00, $00, $00
    db $00, $20, $C0, $40, $E0, $31, $0A, $04, $05, $00, $00, $00, $00, $F0, $08, $08
    db $F0, $80, $80, $40, $20, $38, $27, $20, $20, $40, $A0, $78, $16, $13, $FD, $09
    db $10, $00, $00, $C0, $30, $80, $70, $3F, $C2, $3A, $05, $05, $01, $11, $01, $06
    db $F8, $20, $47, $78, $20, $20, $20, $1F, $08, $10, $15, $E3, $20, $20, $20, $E0
    db $93, $02, $03, $52, $64, $04, $07, $04, $0E, $80, $80, $80, $80, $40, $C0, $20
    db $20, $08, $04, $02, $01, $03, $00, $00, $00, $94, $58, $40, $40, $C0, $00, $00
    db $00, $89, $48, $28, $18, $00, $00, $00, $00, $20, $A0, $F0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $1C, $23, $20, $1E, $03, $04, $0B, $14, $10
    db $12, $80, $7F, $80, $00, $00, $80, $00, $00, $00, $E3, $1C, $03, $0D, $12, $01
    db $01, $00, $E0, $10, $88, $48, $B0, $40, $40, $10, $10, $08, $07, $00, $00, $00
    db $01, $00, $00, $1E, $00, $FF, $40, $80, $A0, $04, $00, $00, $0F, $F0, $20, $10
    db $10, $40, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $06, $00, $78, $FF, $CD, $8C, $0C, $70, $08, $07, $38, $C7, $F0, $7C, $1E, $01
    db $1E, $80, $70, $08, $84, $42, $21, $11, $88, $01, $01, $01, $03, $03, $07, $06
    db $8E, $64, $D8, $E1, $5E, $40, $20, $20, $20, $12, $13, $12, $0C, $09, $0E, $08
    db $08, $00, $00, $80, $80, $00, $00, $00, $00, $18, $20, $40, $40, $80, $80, 

Bank0TrailingGraphicsData_3f00::
Jump_000_3f00:: ; Compatibility alias: this is data, not executable code.
    db $80
    db $87, $08, $60, $90, $91, $60, $03, $04, $04, $1F, $03, $E3, $13, $08, $04, $84
    db $84, $48, $44, $44, $65, $FF, $FF, $E9, $31, $9C, $B8, $F0, $E0, $80, $00, $00
    db $00, $47, $48, $50, $50, $60, $00, $00, $00, $08, $90, $50, $50, $60, $00, $00
    db $00, $48, $50, $30, $18, $26, $21, $1C, $0B, $83, $40, $40, $40, $80, $FF, $48
    db $8F, $00, $00, $00, $04, $1B, $E2, $04, $F8, $1E, $12, $12, $32, $CD, $05, $06
    db $00, $09, $0A, $12, $1C, $00, $00, $00, $00, $02, $02, $02, $02, $04, $07, $00
    db $00, $40, $40, $40, $80, $80, $00, $00, $00

IF DEF(DEBUG)
Call_000_3f6a::
    ldh [hNeedsReset], a
    ldh [hSCX], a
    ld hl, $5701
    ld de, $8d00
    ld bc, $0300
    ld a, $05
    call BankedMemcpy
    ld a, $04
    ld [wScreenPaletteId], a
    ret
ENDC
    ds $4000 - @, $FF
