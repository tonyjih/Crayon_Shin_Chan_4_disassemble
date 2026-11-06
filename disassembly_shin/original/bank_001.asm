; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[ROM_BANK_ID_ADDR], BANK[$1]

RomBankId_Bank1::
    db $01

Bank1FarCallTable::
	dw UpdateGameplayState          ; FARCALL_BANK1_UPDATE_GAMEPLAY ($0100)
	dw Gameplay_InitEntry           ; FARCALL_BANK1_INIT_GAMEPLAY ($0102)
	dw UpdateTutorialDemo     ; FARCALL_BANK1_UPDATE_TUTORIAL ($0104)
    dw InitTutorialDemo       ; FARCALL_BANK1_INIT_TUTORIAL ($0106)

Bank1ShiftableStart::
Gameplay_InitEntry::
    ldh a, [hStageIndex]
    add $1a
    ld [wScreenPaletteId], a
    xor a
    ldh [hNeedsReset], a
    call SelectGameplayMusic
    ld a, [wGameplayInitSubstate]
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
    ld [wStageCheckpointActive], a
    ld [wStage1CameraProfileIndex], a

InitGameplaySubstateCommon::
    call InitGameplayObjectAndCameraWork
    call ResetPlayerStateForStage
    call InitObjectSpawnList
    call InitStageStartAndCheckpointState
    xor a
    ld [wPendingVramUpdates], a
    jp RedrawVisibleBgMapColumns


LoadStageResourcesAndCollision::
    call LoadStageGraphics
    call LoadStageLayoutForResume
    ld hl, StageCollisionAttrPtrs
    ldh a, [hStageIndex]
    rst $20
    ld de, wStageTileAttrTable
    ld bc, $0100
    ld a, $04
    call BankedMemcpy
    ld hl, StageMetatileQuadPtrs
    ldh a, [hStageIndex]
    rst $20
    ld a, l
    ldh [hStageMetatileTableLo], a
    ld a, h
    ldh [hStageMetatileTableHi], a
    ld a, $48
    ld [wCameraDeadzoneLeft], a
    ld a, $58
    ld [wCameraDeadzoneRight], a
    ld a, $40
    ld [wCameraDeadzoneTop], a
    ld a, $58
    ld [wCameraDeadzoneBottom], a
    ld a, $02
    ld [wCameraMaxStepX], a
    ld a, $04
    ld [wCameraMaxStepY], a
    xor a
    ld [wPlayerXMinHi], a
    ld a, $08
    ld [wPlayerXMinLo], a
    xor a
    ld [wUnconfirmedStageInitWordHi], a
    ld a, $04
    ld [wUnconfirmedStageInitWordLo], a
    xor a
    ld [wCameraScrollXMinLo], a
    ld [wCameraScrollXMinHi], a
    ld hl, StageInitBlockPtrs
    ldh a, [hStageIndex]
    rst $20
    ld de, wPlayerXMaxLo
    ld b, $4e
    jp CopyBytesWithBCount


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

StageInitBlockPtrs:: ; Per-stage camera/layout init blocks copied to wPlayerXMaxLo ($c414).
    dw StageInitBlock_0_1_4
    dw StageInitBlock_0_1_4
    dw StageInitBlock_2
    dw StageInitBlock_3
    dw StageInitBlock_0_1_4

DEF STAGE_INIT_BLOCK_COPY_SIZE EQU $4e
DEF STAGE_LAYOUT_PAGE_COLS EQU $0e

; Stage init blocks are copied to $c414 for STAGE_INIT_BLOCK_COPY_SIZE bytes.
; +00 word: player_x_max -> wPlayerXMax
; +02 word: player_y_fall_threshold -> $c416/$c417, used by ApplyPlayerYVelocity to enter death-fall
; +04 word: camera_x_max -> wCameraScrollXMax
; +06 word: camera_y_max -> wCameraScrollYMax
; +08 byte[]: virtual-to-physical layout page map copied to $c41c
;             indexed as row * STAGE_LAYOUT_PAGE_COLS + column.
;             Each value selects a physical decompressed layout page at $c800 + page*$100.
;
; Important original-game quirk:
;   The copy size is fixed at $4e bytes.  StageInitBlock_0_1_4 is shorter than
;   $4e on purpose in the original layout, so the copy continues into the next
;   bytes in ROM.  Do not insert unrelated data between these init blocks unless
;   every block is first made explicitly $4e bytes long.
StageInitBlock_0_1_4::
    dw $0df8 ; player_x_max
    dw $00ff ; player_y_fall_threshold
    dw $0d60 ; camera_x_max
    dw $0080 ; camera_y_max
    ; virtual page row 0 -> physical pages $00-$0d, followed by two fallback entries
    db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    ; trailing fallback/unused virtual page entries

StageInitBlock_2:: ; Stage 2 initial clamp/page data. Covers a $400x$400 multi-layer room.
    dw $0400 ; player_x_max
    dw $0400 ; player_y_fall_threshold
    dw $0360 ; camera_x_max
    dw $0380 ; camera_y_max
    ; virtual-to-physical layout page map, 14 columns per row
    db $0c, $0d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $09, $0a, $0b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $05, $06, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $02, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

StageInitBlock_3:: ; Stage 3 initial clamp/page data.
    dw $09f8 ; player_x_max
    dw $0500 ; player_y_fall_threshold
    dw $0960 ; camera_x_max
    dw $0480 ; camera_y_max
    ; virtual-to-physical layout page map, 14 columns per row
    db $00, $00, $00, $10, $08, $09, $0a, $0b, $0c, $0d, $00, $00, $00, $00
    db $00, $00, $00, $10, $07, $10, $10, $10, $10, $10, $00, $00, $00, $00
    db $00, $00, $00, $10, $06, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $0e, $0e, $0e, $0f, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $02, $03, $04, $10, $00, $00, $00, $00, $00, $00, $00, $00

ResetPlayerStateForStage::
    xor a
    ldh [hPlayerState], a
    ldh [hPlayerDirection], a
    ldh [hPlayerActionLock], a
    call InitGameplayHudAndWindow
    call LoadStageResourcesAndCollision
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
    ld [wInterruptEnableShadow], a
    jp EnableInterruptsFromShadow


InitGameplayObjectAndCameraWork::
    ld a, $ff
    ld [wObjectSlots], a
    call UpdatePlayerJumpProfile
    ld a, $20
    ldh [hPlayerGravity], a
    ld hl, $00e0
    ld de, $0140
    ld a, [wSpecialModeFlags]
    or a
    jr z, Gameplay_StoreMovementDefaults

    ld hl, $01c0
    ld de, $0200

Gameplay_StoreMovementDefaults::
    ld a, l
    ld [wPlayerNormalSpeedLo], a
    ld a, h
    ld [wPlayerNormalSpeedHi], a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ld a, e
    ld [wActionKamenMoveSpeedLo], a
    ld a, d
    ld [wActionKamenMoveSpeedHi], a
    xor a
    ldh [hOamWritePos], a
    ldh [hVBlankBusy], a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    ldh [hPlayerDeathCollisionDisabled], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [hPlayerTileEffect], a
    ldh [hPlayerActionLock], a
    ldh [hPlayerAnimTimer], a
    ldh [hPlayerStatePhase], a
    ld [wPlayerForcedJumpFlags], a
    ldh [hCollisionFlag], a
    ldh [hStreamedColumnX], a
    ldh [hStreamedRowY], a
    ld hl, wStageInteractionSubstate
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


LoadStageLayoutForResume::
    call DecodeStageLayout
    ld a, [wStageCheckpointActive]
    or a
    jr z, DecodeStageLayout

    ld hl, StageResumeLayoutPatchOffsets
    ldh a, [hStageIndex]
    rst $20
    ld bc, wStageLayoutMap
    add hl, bc
    ld [hl], $05
    ret


DecodeStageLayout::
    ldh a, [hStageIndex]
    cp $03
    jr z, DecodeStage3ExtendedLayout

    ld hl, StageLayoutRlePtrs
    ldh a, [hStageIndex]
    rst $20
    ld de, wStageLayoutMap
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

DecodeStage3ExtendedLayout::
    ld hl, LayoutRle_b04_6b77
    ld de, wStageLayoutMap
    ld bc, $1100
    ld a, BANK(LayoutRle_b04_6b77)
    jp BankedMemcpy_RLEFF


LoadStageGraphics::
    ld hl, Gfx_b05_4001
    ld de, _VRAM
    ld bc, $0130
    ld a, BANK(Gfx_b05_4001)
    call BankedMemcpy
    ld hl, Gfx_b05_5701
    ld de, _VRAM + $d00
    ld bc, $0300
    ld a, BANK(Gfx_b05_5701)
    call BankedMemcpy
    call LoadPlayerFormGfx
    ld hl, StageGfxListPointers
    ldh a, [hStageIndex]
    rst $20
    jp ExecuteBankedCopyScript

StageGfxListPointers::
    dw StageGfxLoadList_Stage0
    dw StageGfxLoadList_Stage1
	dw StageGfxLoadList_Stage2
	dw StageGfxLoadList_Stage3
	dw StageGfxLoadList_Stage3

StageGfxLoadList_Stage0::
	dw Gfx_b05_5ad1, _VRAM + $700, $03f0	;source offset, dest, size
	db BANK(Gfx_b05_5ad1)					;source bank

	dw Gfx_b05_5a01, _VRAM + $b00, $00d0
	db BANK(Gfx_b05_5a01)

	dw Gfx_b07_4001, _VRAM + $1000, $0800
	db BANK(Gfx_b07_4001)

	db $ff	;stop bit
StageGfxLoadList_Stage1::
	dw Gfx_b05_5bc1, _VRAM + $700, $0300
	db BANK(Gfx_b05_5bc1)

	dw Gfx_b05_5ed1, _VRAM + $a00, $02a0
	db BANK(Gfx_b05_5ed1)

	dw Gfx_b07_46e1, _VRAM + $1000, $0800
	db BANK(Gfx_b07_46e1)

	db $ff
StageGfxLoadList_Stage2::
	dw Gfx_b05_5d61, _VRAM + $700, $0160
	db BANK(Gfx_b05_5d61)

	dw Gfx_b05_5ed1, _VRAM + $860, $01e0
	db BANK(Gfx_b05_5ed1)

	dw Gfx_b05_6171, _VRAM + $a40, $02a0
	db BANK(Gfx_b05_6171)

	dw Gfx_b07_5361, _VRAM + $1000, $0800
	db BANK(Gfx_b07_5361)

	db $ff

StageGfxLoadList_Stage3::
	dw Gfx_b05_5bc1, _VRAM + $700, $01a0
	db BANK(Gfx_b05_5bc1)

	dw Gfx_b05_5ed1, _VRAM + $8a0, $01e0
	db BANK(Gfx_b05_5ed1)

	dw Gfx_b05_6171, _VRAM + $a80, $01c0
	db BANK(Gfx_b05_6171)

	dw Gfx_b05_64e1, _VRAM + $c40, $0080
	db BANK(Gfx_b05_64e1)

	dw Gfx_b07_5af1, _VRAM + $1000, $0800
	db BANK(Gfx_b07_5af1)

	db $ff

LoadPlayerFormGfx::
    ldh a, [hPlayerForm]
    rst $00

    ; Player form graphics loader table.
    dw LoadPlayerFormGfxNormal ; PLAYER_FORM_NORMAL
    dw LoadPlayerFormGfxFlyingSquirrel ; PLAYER_FORM_FLYING_SQUIRREL
    dw LoadPlayerFormGfxCockroach ; PLAYER_FORM_COCKROACH
    dw LoadPlayerFormGfxChicken ; PLAYER_FORM_CHICKEN
    dw LoadPlayerFormGfxActionKamen ; PLAYER_FORM_ACTION_KAMEN

LoadPlayerFormGfxNormal::
    ld hl, Gfx_b05_4131
    ld de, _VRAM + $130			;dest (VRAM)
    ld bc, $0470			;size
    ld a, BANK(Gfx_b05_4131)
    call BankedMemcpy
    ret


LoadPlayerFormGfxFlyingSquirrel::
    ld hl, Gfx_b05_45a1
    ld de, _VRAM + $130
    ld bc, $0530
    ld a, BANK(Gfx_b05_45a1)
    call BankedMemcpy
    ret


LoadPlayerFormGfxCockroach::
    ld hl, Gfx_b05_53a1
    ld de, _VRAM + $130
    ld bc, $0530
    ld a, BANK(Gfx_b05_53a1)
    call BankedMemcpy
    ret


LoadPlayerFormGfxChicken::
    ld hl, Gfx_b05_4f41
    ld de, _VRAM + $130
    ld bc, $0530
    ld a, BANK(Gfx_b05_4f41)
    call BankedMemcpy
    ret


LoadPlayerFormGfxActionKamen::
    ld hl, Gfx_b05_4ad1
    ld de, _VRAM + $130
    ld bc, $0530
    ld a, BANK(Gfx_b05_4ad1)
    call BankedMemcpy
    ret

; 8 bytes
; playerXLo, playerXHi
; playerYLo, playerYHi
; cameraXLo, cameraXHi
; cameraYLo, cameraYHi
PlayerStartCameraInit_Stage0::
    dw $0018 ; player X
    dw $00f0 ; player Y
    dw $0000 ; camera X
    dw $0080 ; camera Y
PlayerStartCameraInit_435d::
    dw $0728 ; player X
    dw $0060 ; player Y
    dw $06d8 ; camera X
    dw $0010 ; camera Y

PlayerStartCameraInit_4365::
    dw $0018 ; player X
    dw $03f0 ; player Y
    dw $0000 ; camera X
    dw $0380 ; camera Y

PlayerStartCameraInit_436d::
    dw $01a8 ; player X
    dw $0270 ; player Y
    dw $0150 ; camera X
    dw $0200 ; camera Y

PlayerStartCameraInit_4375::
    dw $0018 ; player X
    dw $04f0 ; player Y
    dw $0000 ; camera X
    dw $0480 ; camera Y

PlayerStartCameraInit_437d::
    dw $0428 ; player X
    dw $0050 ; player Y
    dw $03d0 ; camera X
    dw $0000 ; camera Y

PlayerStartCameraInit_4385::
	dw $0018
	dw $0040
	dw $0000
	dw $0000

PlayerStartCameraInit_438d::
	dw $0548
	dw $00F0
	dw $04F2
	dw $0080

PlayerStartCameraInit_Pointers::
    dw PlayerStartCameraInit_Stage0
	dw Stage1CameraProfile0
	dw PlayerStartCameraInit_4365
	dw PlayerStartCameraInit_4375
	dw PlayerStartCameraInit_4385

PlayerCheckpointStartCameraPointers::
    dw PlayerStartCameraInit_435d
    dw PlayerStartCameraInit_44b7 ; Stage 1 uses its camera/profile initialization record.
    dw PlayerStartCameraInit_436d
    dw PlayerStartCameraInit_437d
    dw PlayerStartCameraInit_438d

LoadNormalStageStartCamera::
    ld hl, PlayerStartCameraInit_Pointers
    ldh a, [hStageIndex]
    rst $20

ApplyPlayerStartAndCameraRecord::
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


InitStageStartAndCheckpointState:: ; Select player start/camera profile and replay stage-specific checkpoint graphics.
    ldh a, [hStageIndex]
    cp $01
    jr z, InitStage1CameraProfile

    cp $02
    call z, Stage2ApplyCheckpointGraphics
    ld hl, PlayerCheckpointStartCameraPointers
    ldh a, [hStageIndex]
    rst $20
    ld a, [wStageCheckpointActive]
    or a
    jr z, LoadNormalStageStartCamera

    jr ApplyPlayerStartAndCameraRecord

Stage2ApplyCheckpointGraphics:: ; If resuming Stage 2, replay checkpoint graphics and set transition step to 3.
    ld a, [wStageCheckpointActive]
    or a
    ret z

    ld hl, Gfx_b00_3572
    ld de, _VRAM + $1450
    ld bc, $0390
    ld a, $04
    call BankedMemcpy
    ld hl, Gfx_b05_6411
    ld de, _VRAM + $c00
    ld bc, $00d0
    ld a, BANK(Gfx_b05_6411)
    call BankedMemcpy
    ld a, $03
    ld [wStage2TransitionStep], a
    ret


InitStage1CameraProfile::
    ld a, [wStage1ResumeProfileFlag]
    or a
    jr nz, Stage1LoadSelectedCameraProfile

    ld a, [wStageCheckpointActive]
    or a
    jr nz, Stage1UseResumeCameraProfile

    xor a
    ld [wStage1CameraProfileIndex], a

Stage1LoadSelectedCameraProfile::
    xor a
    ld [wStage1ResumeProfileFlag], a
    ld hl, Stage1CameraProfile0
    ld a, [wStage1CameraProfileIndex]
    or a
    jr z, Stage1ApplyCameraProfile

    ld hl, Stage1CameraProfile1
    dec a
    jr z, Stage1ApplyCameraProfile

    ld hl, Gfx_b07_4ee1
    ld de, _VRAM + $11a0
    ld bc, $0480
    ld a, BANK(Gfx_b07_4ee1)
    call BankedMemcpy
    ld hl, Stage1CameraProfileAfterCheckpoint2

Stage1ApplyCameraProfile:: ; Copy a 16-byte Stage 1 camera/start profile into runtime camera/player registers.
    ld a, [hl+]
    ld [wCameraScrollXMinLo], a
    ld a, [hl+]
    ld [wCameraScrollXMinHi], a
    ld a, [hl+]
    ld [wCameraScrollXMaxLo], a
    ld a, [hl+]
    ld [wCameraScrollXMaxHi], a
    ld a, [hl+]
    ld [wPlayerXMinLo], a
    ld a, [hl+]
    ld [wPlayerXMinHi], a
    ld a, [hl+]
    ld [wPlayerXMaxLo], a
    ld a, [hl+]
    ld [wPlayerXMaxHi], a
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


Stage1UseResumeCameraProfile::
    ld a, $01
    ld [wStage1CameraProfileIndex], a
    ld hl, Stage1CameraProfileResume
    jr Stage1ApplyCameraProfile

; Stage 1 camera profiles are copied by Stage1ApplyCameraProfile.
; Each profile is 8 little-endian words:
;   camera_x_min, camera_x_max, player_x_min, player_x_max,
;   player_start_x, player_start_y, initial_scroll_x, initial_scroll_y
Stage1CameraProfile0::
    dw $0000 ; camera_x_min
    dw $0460 ; camera_x_max
    dw $0008 ; player_x_min
    dw $0500 ; player_x_max
    dw $0018 ; player_start_x
    dw $0070 ; player_start_y
    dw $0000 ; initial_scroll_x
    dw $0018 ; initial_scroll_y
Stage1CameraProfile1::
    dw $0500 ; camera_x_min
    dw $0860 ; camera_x_max
    dw $0508 ; player_x_min
    dw $0900 ; player_x_max
    dw $0518 ; player_start_x
    dw $00c0 ; player_start_y
    dw $0500 ; initial_scroll_x
    dw $0068 ; initial_scroll_y
Stage1CameraProfileAfterCheckpoint2:: ; Also loads bank7:$4ee1->$91a0 before applying this profile.
    dw $0900 ; camera_x_min
    dw $0d60 ; camera_x_max
    dw $0908 ; player_x_min
    dw $0df8 ; player_x_max
    dw $0918 ; player_start_x
    dw $00f0 ; player_start_y
    dw $0900 ; initial_scroll_x
    dw $0080 ; initial_scroll_y
Stage1CameraProfileResume:: ; Raw profile at $44af.
    dw $0500 ; camera_x_min
    dw $0860 ; camera_x_max
    dw $0508 ; player_x_min
    dw $0900 ; player_x_max
PlayerStartCameraInit_44b7::
    dw $0728 ; player_start_x
    dw $0080 ; player_start_y
    dw $06d3 ; initial_scroll_x
    dw $0028 ; initial_scroll_y

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


BossIntro_AdjustCameraBeforeTiles::
    ldh a, [hStageIndex]
    cp $03
    jr z, BossIntro_ApproachStage3CameraY

    ld hl, hSCY
    ld a, [wCameraScrollYMaxLo]
    cp [hl]
    ret z

    inc [hl]
    ret


BossIntro_ApproachStage3CameraY::
    ld hl, hSCY
    ld a, [hl]
    cp $80
    ret z

    jr nc, BossIntro_ScrollStage3CameraUp

    inc [hl]
    jp QueueCurrentCameraBgRow


BossIntro_ScrollStage3CameraUp::
    dec [hl]
    jp QueueCurrentCameraBgRow


; Boss intro flow:
;   BANK0 camera clamp sets wStageBossCountdown=$ff when the player reaches the stage end.
;   While the countdown is nonzero, this handler adjusts boss-area camera position,
;   streams boss sprite graphics from bank 5, then spawns OBJ_STAGE0_BOSS-OBJ_STAGE3_BOSS.
UpdateStageBossIntro:: ; Boss intro/countdown handler. Loads boss tiles, then spawns the stage boss.
    dec a
    ld [wStageBossCountdown], a
    jr z, SpawnStageBossFromIntro

    ld b, a
    ld a, $bd
    sub b
    ld b, a
    cp $60
    jr nc, BossIntro_AdjustCameraBeforeTiles

    ld a, STAGE_BOSS_STATE_ACTIVE
    ld [wStageBossStateFlag], a
    ld hl, BossSpriteGfxSourceBaseTable
    ldh a, [hStageIndex]
    rst $20
    ld c, b
    ld a, $70
    add b
    ld e, a
    ld d, $05
    jp QueueBankedVramTile8000


BossSpriteGfxSourceBaseTable:: ; Bank 5 source bases for boss sprite graphics loaded during intro.
    dw Gfx_b05_64e1 + $80 ; Stage 0 boss graphics base in bank 5.
    dw Gfx_b05_64e1 + $340 ; Stage 1 boss graphics base in bank 5.
    dw Gfx_b05_64e1 + $610 ; Stage 2 boss graphics base in bank 5.
    dw Gfx_b05_64e1 + $9a0 ; Stage 3 boss graphics base in bank 5.

SpawnStageBossFromIntro::
    ld hl, BossSpawnRecordPtrs
    ldh a, [hStageIndex]
    rst $20
    ld a, l
    ldh [hSpawnRecordPtrLo], a
    ld a, h
    ldh [hSpawnRecordPtrHi], a
    jp FindFreeObjectSlot


BossSpawnRecordPtrs:: ; Bosses are spawned by the countdown flow, not normal stage spawn lists.
    dw BossSpawnRecord_Stage0
    dw BossSpawnRecord_Stage1
    dw BossSpawnRecord_Stage2
    dw BossSpawnRecord_Stage3

BossSpawnRecord_Stage0::
    db OBJ_STAGE0_BOSS, $08, $0e, $f0, $00 ; type, x_lo, x_hi, y_lo, y_hi
BossSpawnRecord_Stage1::
    db OBJ_STAGE1_BOSS, $08, $0e, $c0, $00
BossSpawnRecord_Stage2::
    db OBJ_STAGE2_BOSS, $08, $02, $c0, $00
BossSpawnRecord_Stage3::
    db OBJ_STAGE3_BOSS, $08, $0a, $f0, $00

HandlePlayerDamage::
; Ignore damage during flagged states; lose an active form, otherwise enter damage/death handling.
    ldh a, [hPlayerFlags]
    or a
    ret nz

    ldh a, [hPlayerForm]
    or a
    jp nz, LosePlayerFormAndEnterHurtState

    ldh a, [hPlayerHealth]
    or a
    jp z, EnterPlayerDeathFallState

    ld a, $51
    call PlaySound
    ldh a, [hPlayerState]
    ld [wSavedPlayerState], a
    ld a, $0a
    ldh [hPlayerState], a
    ld hl, hPlayerFlags
    set 3, [hl]
    ld a, $1e
    ldh [hPlayerAnimTimer], a
    ret


LosePlayerFormAndEnterHurtState::
; Restore the saved normal move speed before starting the hurt/form-change animation.
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
    jp EnterPlayerHurtState


SetPlayerForcedBounceVelocity::
; Disable jump-height release control, set gravity $20, and use jump profile 3 velocity.
    ld a, $01
    ld [wPlayerForcedJumpFlags], a
    ld a, $20
    ldh [hPlayerGravity], a
    jp SetPlayerJumpVelocity3


EnterPlayerHurtState:: ; Enter hurt/knockback-style player state; clears action actors and starts recovery timer.
    ld a, $06
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


DispatchPlayerTileAlignment::
    ldh a, [hPlayerTileEffect]
    ld b, a
    xor a
    ldh [hPlayerTileEffect], a
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


MovePlayerYBySignedHL::
; Apply a signed 8.8 Y displacement from HL using the normal movement/clamp routine, then restore velocity.
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
    ldh a, [hPlayerDirection]
    or a
    jr nz, ApplyPlayerXVelocity_Left

    ld hl, hPlayerXSubpixel
    ldh a, [hPlayerSpeedX]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerSpeedXHigh]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [wPlayerXMaxLo]
    ld e, a
    ld a, [wPlayerXMaxHi]
    ld d, a
    call CompareU16AtHLToDE
    ret c

    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld a, [wPlayerXMaxHi]
    ldh [hPlayerXHigh], a
    ld a, [wPlayerXMaxLo]
    ldh [hPlayerX], a
    ret


ApplyPlayerXVelocity_Left::
    ld hl, hPlayerXSubpixel
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
    ld a, [wPlayerXMinLo]
    ld e, a
    ld a, [wPlayerXMinHi]
    ld d, a
    call CompareU16AtHLToDE
    ret nc

    ld a, [wPlayerXMinHi]
    ldh [hPlayerXHigh], a
    ld a, [wPlayerXMinLo]
    ldh [hPlayerX], a
    ret


ApplyPlayerYVelocity:: ; Apply player vertical velocity to world Y.
    ldh a, [hPlayerVelYHigh]
    bit 7, a
    jr nz, ApplyPlayerYVelocityUpward

    ld hl, hPlayerYSubpixel
    ldh a, [hPlayerVelY]
    add [hl]
    ld [hl+], a
    ldh a, [hPlayerVelYHigh]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [wStageBossStateFlag]
    or a
    ret nz

    ld a, [wPlayerYFallThresholdLo]
    ld e, a
    ld a, [wPlayerYFallThresholdHi]
    ld d, a
    call CompareU16AtHLToDE
    ret c

    ldh a, [hPlayerState]
    cp PlayerState_DeathFall
    ret z

EnterPlayerDeathFallState:: ; Enter fall-out/death bounce state and reset form/audio.
    xor a
    ldh [hPlayerForm], a
    call InitSound
    ld a, $55
    call PlaySound_Queue3
    ld a, $0b
    ldh [hPlayerState], a
    ld hl, hPlayerFlags
    set 3, [hl]
    ld hl, -$0400
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ld a, $ff
    ldh [hPlayerDeathCollisionDisabled], a
    ret


ApplyPlayerYVelocityUpward::
    ld hl, hPlayerYSubpixel
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
    ldh a, [hStageIndex]
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

    ld a, [wStageInteractionSubstate]
    ld hl, StageAnimatedTileSequence0
    rst $38
    ld a, [hl]
    call DispatchStage0TileAnimationFrame
    ld hl, wStageInteractionSubstate
    inc [hl]
    ld a, [hl]
    cp $18
    ret c

    ld [hl], $00
    ret



StageAnimatedTileSequence0::
    db $01, $04, $00, $06, $01, $00, $00, $05, $02, $00, $00, $00, $02, $04, $00, $00
    db $03, $00, $00, $05, $03, $07, $00, $00

DispatchStage0TileAnimationFrame::
; A indexes the stage 0 tile-animation arrangement.
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw Stage0TileAnim_None ; 00
    dw Stage0TileAnim_01 ; 01
    dw Stage0TileAnim_02 ; 02
    dw Stage0TileAnim_03 ; 03
    dw Stage0TileAnim_04 ; 04
    dw Stage0TileAnim_05 ; 05
    dw Stage0TileAnim_06 ; 06
    dw Stage0TileAnim_07 ; 07

Stage0TileAnim_None::
    ret


Stage0TileAnim_01::
    ld c, $39
    ld e, c
    call QueueStage0AnimatedBgTile
    ld c, $3a
    ld e, c
    call QueueStage0AnimatedBgTile
    ld c, $3b
    ld e, c
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_02::
    ld c, $3a
    ld e, $39
    call QueueStage0AnimatedBgTile
    ld c, $3b
    ld e, $3a
    call QueueStage0AnimatedBgTile
    ld c, $39
    ld e, $3b
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_03::
    ld c, $3b
    ld e, $39
    call QueueStage0AnimatedBgTile
    ld c, $39
    ld e, $3a
    call QueueStage0AnimatedBgTile
    ld c, $3a
    ld e, $3b
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_04::
    ld c, $3c
    ld e, $3c
    call QueueStage0AnimatedBgTile
    ld c, $3d
    ld e, $3d

QueueStage0AnimatedBgTile::
; C=source tile, E=VRAM $9000 tile index.
    ld d, $07
    ld hl, Gfx_b07_4001
    jp QueueBankedVramTile9000


Stage0TileAnim_05::
    ld c, $3c
    ld e, $3d
    call QueueStage0AnimatedBgTile
    ld c, $3d
    ld e, $3c
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_06::
    ld c, $2e
    ld e, $2e
    call QueueStage0AnimatedBgTile
    ld c, $2f
    ld e, $2f
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_07::
    ld c, $2e
    ld e, $2f
    call QueueStage0AnimatedBgTile
    ld c, $2f
    ld e, $2e
    jr QueueStage0AnimatedBgTile

UpdateStageAnimatedTiles_Set1::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [wStage1CameraProfileIndex]
    or a
    ret nz

    ld a, [wStageInteractionSubstate]
    ld hl, StageAnimatedTileSequence1
    rst $38
    ld a, [hl]
    call DispatchStage1TileAnimationFrame
    ld hl, wStageInteractionSubstate
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret



StageAnimatedTileSequence1::
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DispatchStage1TileAnimationFrame::
; A indexes the stage 1 tile-animation arrangement.
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw Stage1TileAnim_None ; 00
    dw Stage1TileAnim_01 ; 01
    dw Stage1TileAnim_02 ; 02

Stage1TileAnim_None::
    ret


Stage1TileAnim_01::
    ld c, $29
    ld e, c
    call QueueStage1AnimatedBgTile
    ld c, $2a
    ld e, c
    jp QueueStage1AnimatedBgTile


Stage1TileAnim_02::
    ld c, $29
    ld e, $2a
    call QueueStage1AnimatedBgTile
    ld c, $2a
    ld e, $29

QueueStage1AnimatedBgTile::
; C=source tile, E=VRAM $9000 tile index.
    ld d, $07
    ld hl, Gfx_b07_46e1
    jp QueueBankedVramTile9000


UpdateStageAnimatedTiles_NoneA::
    ret


UpdateStageAnimatedTiles_Set2::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [wStage1CameraProfileIndex]
    or a
    ret nz

    ld a, [wStageInteractionSubstate]
    ld hl, StageAnimatedTileSequence2
    rst $38
    ld a, [hl]
    call DispatchStage2TileAnimationFrame
    ld hl, wStageInteractionSubstate
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret



StageAnimatedTileSequence2::
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DispatchStage2TileAnimationFrame::
; A indexes the stage 2 tile-animation arrangement.
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw Stage2TileAnim_None ; 00
    dw Stage2TileAnim_01 ; 01
    dw Stage2TileAnim_02 ; 02

Stage2TileAnim_None::
    ret


Stage2TileAnim_01::
    ld c, $5e
    ld e, c
    call QueueStage2AnimatedBgTile
    ld c, $5f
    ld e, c
    jp QueueStage2AnimatedBgTile


Stage2TileAnim_02::
    ld c, $5e
    ld e, $5f
    call QueueStage2AnimatedBgTile
    ld c, $5f
    ld e, $5e

QueueStage2AnimatedBgTile::
; C=source tile, E=VRAM $9000 tile index.
    ld d, $07
    ld hl, Gfx_b07_5af1
    jp QueueBankedVramTile9000


GetStageTileAtSignedWorldPixel::
    bit 7, d
    jp z, GetStageLayoutTileAtWorldPixel

    xor a
    ret


CheckPlayerHeadCollision:: ; Player upward/head collision check.
    xor a
    ldh [hPlayerTileProbeCount], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchPlayerHeadTileContact
    ldh a, [hPlayerTileProbeCount]
    cp $01
    jr nz, HeadCollision_CheckReleaseFromSnapState

    ldh a, [hPrevPlayerState]
    cp $03
    ret z

    ld a, $03
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [hPlayerStatePhase], a
    ld [wPlayerForcedJumpFlags], a
    ldh a, [hPlayerForm]
    cp $02
    jr nz, HeadCollision_SnapPlayerX

    xor a
    ldh [hPlayerActionLock], a

HeadCollision_SnapPlayerX::
    xor a
    ldh [hPlayerTileEffect], a
    ldh a, [hPlayerX]
    and $f8
    or $08
    ldh [hPlayerX], a
    ret


HeadCollision_CheckReleaseFromSnapState::
    ldh a, [hPrevPlayerState]
    cp $03
    ret nz

    jp AlignPlayerToTileAndResetState


DispatchPlayerHeadTileContact::
; Tile attribute in A selects head contact / Stage 1 transition handling.
    cp $06
    jr z, HeadTile_CountSolidProbe

    cp $08
    jr z, HeadTile_CountIfUpperHalf

    cp $09
    jr z, HeadTileAttr09_CountIfNonzeroY

    cp $0a
    jr z, HeadTileAttr0A_CountIfNonzeroY

    cp $1c
    jr z, HeadTile_CheckStage1Profile1Trigger

    cp $1d
    jr z, HeadTile_CheckStage1Profile2Trigger

    ret


HeadTile_CountSolidProbe::
    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_CountIfUpperHalf::
    ldh a, [hPlayerY]
    and $0f
    cp $08
    ret nc

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTileAttr09_CountIfNonzeroY::
    ldh a, [hPlayerY]
    and $0f
    ret z

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTileAttr0A_CountIfNonzeroY::
    ldh a, [hPlayerY]
    and $0f
    ret z

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_CheckStage1Profile1Trigger::
    ldh a, [hPlayerY]
    and $0f
    cp $03
    jr c, HeadTile_SelectStage1Profile1

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_SelectStage1Profile1::
    ld a, $01
    ld [wStage1CameraProfileIndex], a

HeadTile_BeginStage1Transition::
    ld a, $40
    ld [wFadeTransitionTimer], a
    ld a, $07
    ldh [hGameState], a
    ld a, $02
    ld [wGameplayInitSubstate], a
    ld a, $ff
    ld [wStage1ResumeProfileFlag], a
    ret


HeadTile_CheckStage1Profile2Trigger::
    ldh a, [hPlayerY]
    and $0f
    cp $0b
    jr nc, HeadTile_SelectStage1Profile2

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_SelectStage1Profile2::
    ld a, $02
    ld [wStage1CameraProfileIndex], a
    jr HeadTile_BeginStage1Transition

CheckPlayerRightTileCollision::
; Probe at player world X + 7.
    xor a
    ldh [hPlayerTileCollisionFlag], a
    ld hl, hPlayerX
    ld a, [hl+]
    add $07
    ld c, a
    ld a, [hl]
    adc $00
    ld b, a

CheckPlayerSideTileCollisionAtBC::
; BC=world X; probe the lower and upper edges of the player body.
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    dec de
    push de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    pop de
    call DispatchPlayerSideCollision
    ld e, PLAYER_COLLISION_HEIGHT_NORMAL
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, SideCollision_ProbeUpperBody

    ld e, PLAYER_COLLISION_HEIGHT_COCKROACH

SideCollision_ProbeUpperBody::
    ld hl, hPlayerY
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    push de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    pop de

DispatchPlayerSideCollision::
    and $3f
    add a
    ld hl, PlayerSideCollisionHandlerTable
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl

PlayerSideCollisionHandlerTable:: ; 48-entry tile attribute dispatch table used by DispatchPlayerSideCollision.
; Tile attributes are masked with $3f before indexing, but entries $30-$3f are unused by known maps.
; Original ROM overlaps the unused tail with handler code starting at PlayerSideCollisionNoHit.
    dw PlayerSideCollisionNoHit ; $00
    dw PlayerSideCollisionSolid ; $01
    dw PlayerSideCollisionNoHit ; $02
    dw PlayerSideCollisionNoHit ; $03
    dw PlayerSideCollisionNoHit ; $04
    dw PlayerSideCollisionNoHit ; $05
    dw PlayerSideCollisionNoHit ; $06
    dw PlayerSideCollisionNoHit ; $07
    dw PlayerSideCollisionNoHit ; $08
    dw PlayerSideCollisionNoHit ; $09
    dw PlayerSideCollisionNoHit ; $0a
    dw PlayerSideCollisionNoHit ; $0b
    dw PlayerSideCollisionNoHit ; $0c
    dw PlayerSideCollisionNoHit ; $0d
    dw PlayerSideCollisionNoHit ; $0e
    dw PlayerSideCollisionNoHit ; $0f
    dw PlayerSideCollisionNoHit ; $10
    dw PlayerSideCollisionSolid ; $11
    dw PlayerSideCollisionSolid ; $12
    dw PlayerSideCollisionNoHit ; $13
    dw PlayerSideCollisionSolid ; $14
    dw PlayerSideCollisionNoHit ; $15
    dw PlayerSideCollisionNoHit ; $16
    dw PlayerSideCollisionNoHit ; $17
    dw PlayerSideCollisionNoHit ; $18
    dw PlayerSideCollisionNoHit ; $19
    dw PlayerSideCollisionNoHit ; $1a
    dw PlayerSideCollisionSolidIfYLowBit3Clear ; $1b
    dw PlayerSideCollisionNoHit ; $1c
    dw PlayerSideCollisionNoHit ; $1d
    dw PlayerSideCollisionSolidIfYLowBit3Set ; $1e
    dw PlayerSideCollisionSpecialStageFlag ; $1f
    dw PlayerSideCollisionNoHit ; $20
    dw PlayerSideCollisionNoHit ; $21
    dw PlayerSideCollisionNoHit ; $22
    dw PlayerSideCollisionNoHit ; $23
    dw PlayerSideCollisionNoHit ; $24
    dw PlayerSideCollisionNoHit ; $25
    dw PlayerSideCollisionNoHit ; $26
    dw PlayerSideCollisionNoHit ; $27
    dw PlayerSideCollisionNoHit ; $28
    dw PlayerSideCollisionNoHit ; $29
    dw PlayerSideCollisionNoHit ; $2a
    dw PlayerSideCollisionNoHit ; $2b
    dw PlayerSideCollisionNoHit ; $2c
    dw PlayerSideCollisionNoHit ; $2d
    dw PlayerSideCollisionNoHit ; $2e
    dw PlayerSideCollisionNoHit ; $2f

PlayerSideCollisionNoHit::
    ret

PlayerSideCollisionSolid::
    ld a, $ff
    ldh [hPlayerTileCollisionFlag], a
    ret


PlayerSideCollisionSolidIfYLowBit3Set::
    bit 3, e
    ret z

    jr PlayerSideCollisionSolid

PlayerSideCollisionSolidIfYLowBit3Clear::
    bit 3, e
    ret nz

    jr PlayerSideCollisionSolid

PlayerSideCollisionSpecialStageFlag::
    ld a, [wStageCheckpointActive]
    or a
    ret nz

    jp ReplacePlayerMetatileWith05AndQueue


CheckPlayerLeftTileCollision::
; Probe at player world X - 8.
    xor a
    ldh [hPlayerTileCollisionFlag], a
    ld hl, hPlayerX
    ld a, [hl+]
    sub $08
    ld c, a
    ld a, [hl]
    sbc $00
    ld b, a
    jp CheckPlayerSideTileCollisionAtBC


ProbePlayerGroundTilesAtHeight18::
; Use the shared two-foot tile probe at player Y - 18.
    xor a
    ldh [hPlayerTileCollisionFlag], a
    ldh [hPlayerTileProbeCount], a
    ld e, $12
    jr GroundCollision_ProbeBothFeet

CheckPlayerGroundCollision:: ; Player downward/ground collision check.
    ldh a, [hPlayerY]
    sub $20
    ldh a, [hPlayerYHigh]
    sbc $00
    ret c

    xor a
    ldh [hPlayerTileCollisionFlag], a
    ldh [hPlayerTileProbeCount], a
    ld e, PLAYER_COLLISION_HEIGHT_NORMAL
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, GroundCollision_ProbeBothFeet

    ld e, PLAYER_COLLISION_HEIGHT_COCKROACH

GroundCollision_ProbeBothFeet::
    ld hl, hPlayerY
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    ld a, e
    ldh [hPlayerGroundProbeY], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    dec bc
    dec bc
    push de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchGroundTileCollision
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    inc bc
    inc bc
    pop de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchGroundTileCollision
    ldh a, [hPlayerTileProbeCount]
    cp $02
    ret nz

    ldh a, [hPlayerState]
    cp $04
    ret z

    ld a, $04
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ldh a, [hPlayerForm]
    cp $02
    jr nz, GroundCollision_SnapPlayerY

    xor a
    ldh [hPlayerActionLock], a

GroundCollision_SnapPlayerY::
    ldh a, [hPlayerY]
    and $f0
    or $08
    ldh [hPlayerY], a
    ret


DispatchGroundTileCollision::
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
    ld [wStageInteractionSubstate], a
    ret

GroundTileEnterStageInteraction01::
    ldh a, [hPlayerState]
    cp $0c
    ret z

    ld a, $0c
    ldh [hPlayerState], a
    xor a
    ld [wStageInteractionCounter], a
    inc a
    ld [wStageInteractionSubstate], a
    ret

GroundTileCollisionNone::
    ret

GroundTileSlopeLeftIfLowerHalf::
    ldh a, [hPlayerGroundProbeY]
    bit 3, a
    ret z

    jr GroundTileSolidOrFallState

GroundTileSlopeRightIfUpperHalf::
    ldh a, [hPlayerGroundProbeY]
    bit 3, a
    ret nz

GroundTileSolidOrFallState::
    ldh a, [hPlayerState]
    cp $03
    jp nz, EnterPlayerFallState

    ld a, $ff
    ldh [hPlayerTileCollisionFlag], a
    ret

GroundTileSolidIfNearTop::
    ldh a, [hPlayerY]
    sub $18
    and $0f
    cp $04
    ret nc

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret

GroundTileSolidOnlyWhenSnapState::
    ldh a, [hPlayerState]
    cp $03
    ret nz

    ld a, $ff
    ldh [hPlayerTileCollisionFlag], a
    ret


CheckPlayerFootTileContact::
; Dispatch the metatile under each of the two feet; clear contact/alignment scratch first.
    xor a
    ldh [hPlayerTileProbeCount], a
    ld [wPlayerTileAligned], a
    ldh [hPlayerObjectFlags], a
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
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchPlayerTileContact
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
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]


DispatchPlayerTileContact::
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
    ld a, [wStageCheckpointActive]
    or a
    jp nz, PlayerTileContactSolid

    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call ReplacePlayerMetatileWith05AndQueue
    jp PlayerTileContactSolid


ReplacePlayerMetatileWith05AndQueue::
; Set metatile $05, compute its BG position, and mark the replacement for VRAM upload.
    push de
    call GetStageTileAtSignedWorldPixel
    ld [hl], $05
    pop de
    call GetWorldMetatileBgAddress
    ld a, l
    ld [wPendingMetatile05DestLo], a
    ld a, h
    ld [wPendingMetatile05DestHi], a
    ld a, [wPendingVramUpdates]
    set 2, a
    ld [wPendingVramUpdates], a
    ld a, $ff
    ld [wStageCheckpointActive], a
    ld a, $5b
    jp PlaySound


GetWorldMetatileBgAddress::
; World Y comes from E; horizontal tile coordinate comes from C.
    ld a, e
    jp GetMetatileBgAddressForYAndC

PlayerTileSnapToTileTop::
    jp PlayerTileSnapToTileTopClearEffect

PlayerTileDeathIfDeepContact::
    ldh a, [hPlayerDeathCollisionDisabled]
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
    ld [wPlayerForcedJumpFlags], a
    call PlayerTileSnapToTileTopClearEffect
    ld hl, -$0390
    jp StorePlayerJumpVelocityHL

PlayerTileStageTransitionIfLow::
    ldh a, [hPlayerY]
    and $0f
    cp $0b
    jp nc, HeadTile_SelectStage1Profile2

PlayerTileContactSolid::
    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret

PlayerTileSnapLowHalf::
    ldh a, [hPlayerY]
    bit 3, a
    jr z, PlayerTileContactSolid

    ld a, $ff
    ld [wPlayerTileAligned], a
    xor a
    ldh [hPlayerTileEffect], a
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
    ld [wPlayerTileAligned], a
    xor a
    ldh [hPlayerTileEffect], a
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
    ldh [hPlayerTileEffect], a
    ret

PlayerTileSetEffect2IfMiddle::
    ldh a, [hPlayerY]
    and $0f
    cp $08
    jr c, PlayerTileContactSolid

    cp $0c
    jr nc, PlayerTileContactSolid

    ld a, $02
    ldh [hPlayerTileEffect], a
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

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jr PlayerTileContactSolid

PlayerTileSetEdgeFlagRight::
    bit 3, c
    jr nz, PlayerTileContactSolid

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jr PlayerTileContactSolid

PlayerTileSnapAndSetEdgeFlagRight::
    call PlayerTileSnapToTileTopClearEffect
    bit 3, c
    ret nz

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileSnapAndSetEdgeFlagLeft::
    call PlayerTileSnapToTileTopClearEffect
    bit 3, c
    ret z


    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileSetEdgeFlagSolid::
    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jp PlayerTileContactSolid

PlayerTileSnapAndSetEdgeFlag::
    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jp PlayerTileSnapToTileTopClearEffect

PlayerTileEffect1AndEdgeFlag::
    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jp PlayerTileSetEffect1IfNearTop

PlayerTileEffect1EdgeRight::
    call PlayerTileSetEffect1IfNearTop
    bit 3, c
    ret nz

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileEffect1EdgeLeft::
    call PlayerTileSetEffect1IfNearTop
    bit 3, c
    ret z

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileSpawnDropPlatform::
    ldh a, [hPlayerY]
    and $0f
    cp $04
    jp nc, PlayerTileContactSolid

    push bc
    call ClearPlayerFootMetatileAndQueue
    pop bc
    ld hl, wObjectSlots

DropPlatformTile_FindFreeSlot::
    ld a, [hl]
    or a
    jr z, DropPlatformTile_SelectObjectType

    cp $ff
    jr z, DropPlatformTile_AppendBeforeTerminator

    ld de, $0010
    add hl, de
    jr DropPlatformTile_FindFreeSlot

DropPlatformTile_AppendBeforeTerminator::
    call DropPlatformTile_SelectObjectType
    ld [hl], $ff
    ret


DropPlatformTile_SelectObjectType::
    push hl
    ldh a, [hStageIndex]
    cp $01
    ld a, $1c
    jr nz, DropPlatformTile_InitObjectAndUpdate

    ld a, $1e

DropPlatformTile_InitObjectAndUpdate::
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
    ldh a, [hStageIndex]
    cp $01
    jr z, DropPlatformTile_UpdateStage1Variant

    call UpdateObjDropPlatformA
    pop hl
    ret


DropPlatformTile_UpdateStage1Variant::
    call UpdateObjDropPlatformB
    pop hl
    ret


ClearPlayerFootMetatileAndQueue::
; Set the contacted metatile to zero and queue its 2x2 BG replacement.
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call GetStageTileAtSignedWorldPixel
    ld [hl], $00
    call GetPlayerMetatileBgAddress
    ldh a, [hStageIndex]
    cp $01
    jr z, ClearFootTile_ScheduleStage1Patch

    ld b, h
    ld c, l
    ld de, $0002
    jp QueueVramFill


ClearFootTile_ScheduleStage1Patch::
    ld a, [wPendingVramUpdates]
    bit 3, a
    jr nz, ClearFootTile_QueueStage1PatchImmediately

    set 3, a
    ld [wPendingVramUpdates], a
    ld a, l
    ld [wPendingClearedMetatileDestLo], a
    ld a, h
    ld [wPendingClearedMetatileDestHi], a
    ret


ClearFootTile_QueueStage1PatchImmediately::
    ld de, wStage1ClearedMetatileTiles
    ld bc, $0202
    jp QueueTilemapRect


GetPlayerMetatileBgAddress::
; Use player Y and the world X coordinate in C.
    ldh a, [hPlayerY]

GetMetatileBgAddressForYAndC::
; Map A=world Y, C=world X to the top-left BG address of the 16x16 metatile.
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
    ldh a, [hPlayerState]
    ldh [hPrevPlayerState], a
    rst $00

    ; hPlayerState dispatch table. rst $00 consumes these words as data.
    dw PlayerState_UpdateNormalGround          ; 00
    dw PlayerState_UpdateDuck                  ; 01
    dw PlayerState_UpdateJumpFall              ; 02
    dw PlayerState_UpdateGroundedSnap          ; 03
    dw PlayerState_UpdateGroundedActionCheck   ; 04: grounded/action check state
    dw PlayerState_UpdateClimbOrVerticalMove   ; 05: climb/vertical move state
    dw PlayerState_UpdateHurtKnockback         ; 06
    dw PlayerState_UpdateFlyingSquirrelAction  ; 07
    dw PlayerState_UpdateChickenAction         ; 08
    dw PlayerState_UpdateActionKamenAction     ; 09
    dw PlayerState_UpdateDamageBounce          ; 0a: damage bounce state
    dw PlayerState_UpdateDeathFall             ; 0b
    dw PlayerState_UpdateStageTransition0C     ; 0c: scripted stage transition state
    dw PlayerState_UpdateStageInteraction0D    ; 0d: special/stage interaction state

PlayerState_UpdateStageTransition0C:: ; Scripted stage transition handler; Stage 2 uses it for layered vertical-room transitions.
    ld hl, -$0200 ; Signed 8.8 velocity, not an OAM pointer.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call UpdateAirbornePlayerAnimByForm
    ld a, [wStageInteractionSubstate]
    rst $00

    ; Stage transition substate dispatch table.
	dw StageTransitionScrollViewportUp       ; 00: scroll camera/player anchor up by one screen
	dw Stage2TransitionCopyBgTiles          ; 01: queue bank0:$3572/$3902 tiles into VRAM $9450-$97ff
	dw Stage2TransitionCopyExtraTiles       ; 02: queue bank5:$6411 tiles into VRAM $8c00+
	dw Stage2TransitionFinalize             ; 03: reset substate; at step 5 switch Stage 2 metatile/collision

Stage2TransitionFinalize::
    xor a
    ld [wStageInteractionSubstate], a
    ld [wStageInteractionCounter], a
    ld a, [wStage2TransitionStep]
    cp $05
    ret nz

    ld hl, $01f8
    ld a, l
    ld [wPlayerXMaxLo], a
    ld a, h
    ld [wPlayerXMaxHi], a
    ld hl, $0160
    ld a, l
    ld [wCameraScrollXMaxLo], a
    ld a, h
    ld [wCameraScrollXMaxHi], a
    ld hl, Stage2MetatileQuadsAfterSwitch_Bank4
    ld a, l
    ldh [hStageMetatileTableLo], a
    ld a, h
    ldh [hStageMetatileTableHi], a
    ld hl, CollisionAttributes + $298
    ld de, wStageTileAttrTable
    ld bc, $0030
    ld a, BANK(CollisionAttributes)
    jp BankedMemcpy

Stage2TransitionCopyExtraTiles::
    call Stage2QueueTransitionExtraTile
    ld a, [wStageInteractionCounter]
    inc a
    ld [wStageInteractionCounter], a
    cp $0d
    ret c

    ld a, [wStageInteractionSubstate]
    inc a
    ld [wStageInteractionSubstate], a
    xor a
    ld [wStageInteractionCounter], a
    ret


Stage2QueueTransitionExtraTile:: ; Queue one tile from bank5:$6411 into the Stage 2 transition overlay area.
    ld hl, Gfx_b05_6411
    ld a, [wStageInteractionCounter]
    ld c, a
    add $c0
    ld e, a
    ld d, $05
    jp QueueBankedVramTile8000

Stage2TransitionCopyBgTiles::
    call Stage2QueueTransitionBgTile
    ld a, [wStageInteractionCounter]
    inc a
    ld [wStageInteractionCounter], a
    cp $3b
    ret c

    ld a, [wStageInteractionSubstate]
    inc a
    ld [wStageInteractionSubstate], a
    xor a
    ld [wStageInteractionCounter], a
    ret


Stage2QueueTransitionBgTile:: ; Queue one 8x8 tile update for Stage 2 tile ids $45-$7f.
    ld hl, Bank0TrailingGraphicsData_3572
    ld a, [wStage2TransitionStep]
    cp $02
    jr z, Stage2Transition_QueueSelectedTile

    ld hl, Bank0TrailingGraphicsData_3902

Stage2Transition_QueueSelectedTile::
    ld a, [wStageInteractionCounter]
    ld c, a
    add $45
    ld e, a
    ld d, $00
    jp QueueBankedVramTile9000

StageTransitionScrollViewportUp::
    call StageTransitionMovePlayerAnchorUp
    ld hl, hSCY
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    call QueueCurrentCameraBgRow
    ld a, [wStageInteractionCounter]
    inc a
    ld [wStageInteractionCounter], a
    cp $80
    ret c

    ld a, $ff
    ld [wPlayerForcedJumpFlags], a
    ld a, $02
    ldh [hPlayerState], a
    ld a, [wStage2TransitionStep]
    inc a
    ld [wStage2TransitionStep], a
    ret


StageTransitionMovePlayerAnchorUp:: ; During the first $20 frames, keep the player/screen anchor moving with the camera scroll.
    ld a, [wStageInteractionCounter]
    cp $20
    ret nc

    ld hl, hPlayerY
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    ret


PlayerState_UpdateDamageBounce::
    call CheckPlayerFootTileContact
    ld a, $15
    ldh [hPlayerAnimId], a
    ld hl, hPlayerAnimTimer
    dec [hl]
    ld a, [hl]
    cp $16
    jr z, DamageBounce_ApplyHealthLossAndKnockback

    or a
    ret nz

    ld a, $80
    ld [wPlayerHurtBlinkTimer], a
    ld hl, hPlayerFlags
    res 3, [hl]
    set 1, [hl]
    jp AlignPlayerToTileAndResetState


DamageBounce_ApplyHealthLossAndKnockback::
    call SubtractPlayerHealthAndMarkHudDirty
    ld hl, hPlayerXSubpixel
    ld de, $0200
    ldh a, [hPlayerDirection]
    or a
    jp z, SubtractSignedVelocityFromPosition24

    jp AddSignedVelocityToPosition24



PlayerState_UpdateDeathFall:: ; State 0b: fall-out/death bounce, life decrement, and reset/game-over transition.
    ld hl, hPlayerVelYLo
    ld a, [hl]
    add $14
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jr nz, DeathFall_IntegrateYAndSelectFrame

    cp $04
    jr c, DeathFall_IntegrateYAndSelectFrame

    ld a, $04
    ld [hl-], a
    ld [hl], $00

DeathFall_IntegrateYAndSelectFrame::
    call ApplyPlayerYVelocity
    ld hl, PlayerDeathAnimByForm
    ldh a, [hPlayerForm]
    rst $38
    ld a, [hl]

DeathFall_CheckOffscreenAndRestart::
    ldh [hPlayerAnimId], a
    ld a, $ff
    ldh [hCollisionFlag], a
    ld hl, hPlayerY
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
    jr z, PlayerDeath_EnterGameOver

    dec [hl]
    call QueueLivesHudDigits
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld a, $01
    ld [wGameplayInitSubstate], a
    ld a, [wStageCheckpointActive]
    or a
    ret z

    ld a, $02
    ld [wGameplayInitSubstate], a
    ret



PlayerDeathAnimByForm::
    db $15, $19, $1d, $19, $18

PlayerDeath_EnterGameOver::
    xor a

    ld [wGameplayInitSubstate], a
    ld a, $04
    ldh [hGameState], a
    ld a, $01
    ld [wScreenSubstate], a
    ldh [hNeedsReset], a
    ret


PlayerState_UpdateStageInteraction0D::
    call HandlePlayerGroundInput
    ldh a, [hPlayerPlatformAttached]
    or a
    call z, EnterPlayerFallState
    jr GroundedAction_UpdateWalkingFrames

EnterPlayerAttachedGroundState::
; Used when the hanging doll supports the player. State $0d exits when the support flag clears.
    ldh a, [hPlayerForm]
    cp $02
    jr nz, AttachedGround_ResetAnimation

    xor a
    ldh [hPlayerActionLock], a

AttachedGround_ResetAnimation::
    ld a, $0d
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ldh a, [hPlayerForm]
    cp $02
    ret z

    xor a
    ldh [hPlayerActionLock], a
    ret


PlayerState_UpdateGroundedActionCheck::
    call GroundedAction_CheckSupportThenInput

GroundedAction_UpdateWalkingFrames::
    ldh a, [hPlayerStatePhase]
    or a
    ret z

    ld h, $0a
    ld l, $04
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerGroundedActionAnimIds
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerGroundedActionAnimIds::
    db $12, $13, $12, $14

GroundedAction_CheckSupportThenInput::
    call CheckPlayerGroundCollision
    ldh a, [hPlayerTileProbeCount]
    cp $02
    jp nz, EnterPlayerFallState

HandlePlayerGroundInput:: ; Handle normal ground input and transition to jump/crouch/move.
    ldh a, [hJoyPressed]
    rrca
    jp c, StartPlayerJump

    ldh a, [hJoyHeld]
    or a
    jr z, GroundedAction_SelectIdlePose

    bit 4, a
    jr nz, GroundedAction_WalkRight

    bit 5, a
    jr nz, GroundedAction_WalkLeft

    bit 7, a
    jp nz, EnterPlayerFallState

GroundedAction_SelectIdlePose::
    xor a
    ldh [hPlayerStatePhase], a
    ld a, $12
    ldh [hPlayerAnimId], a
    ret


GroundedAction_WalkRight::
    ld a, $01
    ldh [hPlayerStatePhase], a
    xor a
    ldh [hPlayerDirection], a
    jp ApplyPlayerXVelocity


GroundedAction_WalkLeft::
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld a, $ff
    ldh [hPlayerDirection], a
    jp ApplyPlayerXVelocity


PlayerState_UpdateClimbOrVerticalMove::
    ld hl, hPlayerFlags
    set 0, [hl]
    ld h, $08
    ld l, $09
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerClimbAnimIds
    ldh a, [hPlayerAnimFrame]
    cp $08
    jr nc, PlayerClimb_FinishAnimation

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerClimbAnimIds::
    db $08, $09, $0a, $0b, $08, $09, $0a, $0b, $08

PlayerClimb_FinishAnimation::
    ldh a, [hPlayerFlags]
    res 0, a
    ldh [hPlayerFlags], a
    jp AlignPlayerToTileAndResetState



PlayerState_UpdateDuck:: ; State 01: down/duck pose and related transitions.
    call ProbePlayerFeetThenHandleFall
    ldh a, [hJoyHeld]
    cp $80
    jr z, Duck_UpdateHeldDownPose

    ld a, $0c
    ldh [hPlayerAnimId], a
    ldh a, [hJoyHeld]
    bit 7, a
    jp z, AlignPlayerToTileAndResetState

    bit 0, a
    jr nz, Duck_DropThroughGround

    bit 5, a
    jr nz, Duck_FaceLeft

    bit 4, a
    jr nz, Duck_FaceRight

    ret


Duck_FaceLeft::
    ld a, $ff
    ldh [hPlayerDirection], a
    xor a
    ldh [hPlayerAnimTimer], a
    ret


Duck_FaceRight::
    xor a
    ldh [hPlayerDirection], a
    ldh [hPlayerAnimTimer], a
    ret


Duck_DropThroughGround::
    call CheckPlayerFootTileContact
    ld a, [wPlayerTileAligned]
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


Duck_UpdateHeldDownPose::
    call ProbePlayerHeadOnePixelLower
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


ProbePlayerHeadOnePixelLower::
; Temporarily move player Y down one pixel for the head probe, then move back.
    ld hl, $0100
    call MovePlayerYBySignedHL
    call CheckPlayerHeadCollision
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    call MovePlayerYBySignedHL
    ldh a, [hPlayerState]
    cp $03
    ret nz

    ld hl, $0100
    call MovePlayerYBySignedHL
    pop af
    ret



PlayerState_UpdateGroundedSnap:: ; State 03: grounded snap/settle state after specific collision contact.
    call HandlePlayerVerticalInput
    ldh a, [hPlayerStatePhase]
    rst $00

	dw PlayerGroundedSnap_State00
	dw PlayerGroundedSnap_State01

PlayerGroundedSnap_State00::
; PlayerState_UpdateGroundedSnap dispatch index $00; behavior name can be refined after tracing.
    ld a, $10
    ldh [hPlayerAnimId], a
    ret

PlayerGroundedSnap_State01::
; PlayerState_UpdateGroundedSnap dispatch index $01; behavior name can be refined after tracing.
    ld h, $0a
    ld l, $02
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerDuckAnimIds
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerDuckAnimIds::
    db $10, $11

HandlePlayerVerticalInput::
; Handle UP/DOWN motion in the grounded-snap state.
    ldh a, [hJoyHeld]
    bit 6, a
    jr nz, SnapState_TryMoveUp

    bit 7, a
    jr nz, SnapState_MoveDown

    ldh a, [hJoyPressed]
    bit 0, a
    jp nz, StartPlayerJump

    xor a
    ldh [hPlayerStatePhase], a
    jp CheckPlayerHeadCollision


SnapState_TryMoveUp::
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ProbePlayerGroundTilesAtHeight18
    ldh a, [hPlayerTileCollisionFlag]
    or a
    call z, ApplyPlayerYVelocity
    jp CheckPlayerHeadCollision


SnapState_MoveDown::
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld hl, $0100
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    call ApplyPlayerYVelocity
    jp CheckPlayerHeadCollision


UsePlayerFormAction:: ; Dispatch B-button ability for current hPlayerForm.
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
    ldh [hPlayerAnimFrame], a
    ldh [hPlayerAnimCounter], a
    inc a
    ldh [hPlayerActionLock], a
    ret


StartChickenAction:: ; Begin mother-hen form action; enters player state 08.
    ld de, $0a08
    jr StartTimedPlayerFormAction

PlayerState_UpdateChickenAction:: ; State 08: mother-hen form action.
    call CheckPlayerFootTileContact
    ld e, $05
    call UpdatePlayerFormActionAnim
    ld hl, hPlayerAnimTimer
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
    jr nz, ChickenAction_StoreEggPosition

    ld b, $04

ChickenAction_StoreEggPosition::
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
    ld [wPlayerSpecialActor0Timer], a
    ret


StartFlyingSquirrelAction:: ; Begin flying-squirrel form action; enters player state 07.
    ld de, $0e07

StartTimedPlayerFormAction:: ; Save current state, set action timer/state, and clear form action work vars.
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
    ld e, $07

UpdatePlayerFormActionAnim:: ; Advance form-action animation once timer passes threshold E.
    ld hl, wFormActionStep
    ld a, [hl]
    or a
    jr z, FormAction_InitPose

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


FormAction_InitPose::
    inc [hl]
    ld a, $17
    ldh [hPlayerAnimId], a
    ld a, [wSavedPlayerState]
    or a
    ret z

    ld a, $15
    ldh [hPlayerAnimId], a
    ret


PlayerState_UpdateFlyingSquirrelAction:: ; State 07: flying-squirrel form action.
    call CheckPlayerFootTileContact
    call UpdateFlyingSquirrelActionAnim
    ld hl, hPlayerAnimTimer
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
    ld c, a
    ldh a, [hPlayerDirection]
    or a
    jr nz, SpecialActorX_OffsetLeft

    ldh a, [hPlayerX]
    add c
    ld c, a
    ldh a, [hPlayerXHigh]
    adc $00
    ld b, a
    ret


SpecialActorX_OffsetLeft::
    ldh a, [hPlayerX]
    sub c
    ld c, a
    ldh a, [hPlayerXHigh]
    sbc $00
    ld b, a
    ret


CalcSpecialActorY:: ; BC = player Y - A.
    ld c, a
    ldh a, [hPlayerY]
    sub c
    ld c, a
    ldh a, [hPlayerYHigh]
    sbc $00
    ld b, a
    ret


StartActionKamenAction:: ; Begin Action Kamen form action; only allowed from normal ground state.
    ldh a, [hPlayerState]
    or a
    ret nz

    ld de, $0009
    jp StartTimedPlayerFormAction


UpdateActionKamenActionAnim:: ; Select Action Kamen action animation by hPlayerAnimTimer.
    ldh a, [hPlayerAnimTimer]
    cp $0a
    jr c, ActionKamenAction_SelectStartupFrame

    cp $14
    jr z, SpawnActionKamenProjectile

    jr nc, ActionKamenAction_SelectRecoveryFrame

    ld a, $16
    ldh [hPlayerAnimId], a
    ret


ActionKamenAction_SelectStartupFrame::
    ld a, $15
    ldh [hPlayerAnimId], a
    ret


ActionKamenAction_SelectRecoveryFrame::
    ld a, $17
    ldh [hPlayerAnimId], a
    ret


PlayerState_UpdateActionKamenAction:: ; State 09: Action Kamen projectile/action sequence.
    call CheckPlayerFootTileContact
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
    xor a
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, b
    ld [hl+], a
    ret


InitPlayerSpecialActor:: ; Initialize wPlayerSpecialActor0 and set hPlayerActionLock.
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

ProbePlayerFeetThenHandleFall::
; Run the two-foot tile dispatch; take the fall-state path when its contact count equals 2.
    call CheckPlayerFootTileContact
    ldh a, [hPlayerTileProbeCount]
    cp $02
    ret nz

EnterPlayerFallState:: ; Switch to airborne/falling state when no ground is supporting the player.
    ldh a, [hPlayerPlatformAttached]
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



PlayerState_UpdateNormalGround:: ; State 00: normal grounded player control.
    call DispatchPlayerTileAlignment
    call HandleGroundInput
    ldh a, [hPlayerState]
    or a
    ret nz

    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, GroundedPlayer_DispatchAnimation

    ldh a, [hPlayerActionLock]
    or a
    jr nz, CockroachGroundAction_SelectFrameTable

GroundedPlayer_DispatchAnimation::
    ldh a, [hPlayerStatePhase]
    rst $00

	dw GroundedPlayer_IdlePose
	dw GroundedPlayer_WalkCycle
	dw GroundedPlayer_IdleFidget

CockroachGroundAction_SelectFrameTable::
    ldh a, [hPlayerStatePhase]
    or a
    jr nz, CockroachGroundAction_UseMovingFrames

    ld hl, CockroachGroundIdleActionFrames
    ld a, l
    ldh [hCockroachActionFramePtrLo], a
    ld a, h
    ldh [hCockroachActionFramePtrHi], a
    jp UpdateCockroachActionHitbox



CockroachGroundIdleActionFrames::
    db $15, $16, $16, $16, $15, $15

CockroachGroundAction_UseMovingFrames::
    ld hl, CockroachGroundMovingActionFrames
    ld a, l
    ldh [hCockroachActionFramePtrLo], a
    ld a, h
    ldh [hCockroachActionFramePtrHi], a
    jp UpdateCockroachActionHitbox



CockroachGroundMovingActionFrames::
    db $15, $16, $16, $17, $15, $1b

GroundedPlayer_IdlePose::
    ld a, $04
    ldh [hPlayerAnimId], a
    ret

GroundedPlayer_WalkCycle::
    ld h, $0a
    ld l, $04
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, CockroachAnimIdsA
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



CockroachAnimIdsA::
    db $04, $05, $04, $06

AdvancePlayerAnimWithinRange::
; H=frame period, E=first animation frame, L=exclusive last frame.
    ldh a, [hPlayerAnimCounter]
    inc a
    ldh [hPlayerAnimCounter], a
    cp h
    jr c, PlayerAnimation_CheckCurrentFrame

    xor a
    ldh [hPlayerAnimCounter], a
    ldh a, [hPlayerAnimFrame]
    inc a
    ldh [hPlayerAnimFrame], a

PlayerAnimation_CheckFrameRange::
    cp e
    jr c, PlayerAnimation_WrapToFirstFrame

    cp l
    ret c

PlayerAnimation_WrapToFirstFrame::
    ld a, e
    ldh [hPlayerAnimFrame], a
    ret


PlayerAnimation_CheckCurrentFrame::
    ldh a, [hPlayerAnimFrame]
    jr PlayerAnimation_CheckFrameRange

GroundedPlayer_IdleFidget::
    ld h, $0a
    ld l, $05
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, CockroachAnimIdsB
    ldh a, [hPlayerAnimFrame]
    cp $04
    jr nc, GroundedPlayer_EndIdleFidget

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret


GroundedPlayer_EndIdleFidget::
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ldh [hPlayerAnimTimer], a
    ret



CockroachAnimIdsB::
    db $04, $07, $04, $07, $04

HandleGroundInput:: ; Ground input router: duck, jump, form action, horizontal movement, idle timer.
    ldh a, [hJoyHeld]
    bit 7, a
    jr nz, GroundInput_CheckDuck

    ldh a, [hJoyPressed]
    rrca
    jr c, GroundInput_StartJump

    rrca
    jp c, UsePlayerFormAction

GroundInput_CheckDirectionalButtons::
    ldh a, [hJoyHeld]
    or a
    jr z, GroundInput_UpdateIdle

    bit 4, a
    jr nz, GroundInput_MoveRight

    bit 5, a
    jr nz, GroundInput_MoveLeft

    bit 6, a
    jr nz, GroundInput_TryEnterSnapState

GroundInput_UpdateIdle::
    call ProbePlayerFeetThenHandleFall
    xor a
    ldh [hPlayerStatePhase], a
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
    ldh [hPlayerStatePhase], a
    ret


GroundInput_TryEnterSnapState::
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    call MovePlayerYBySignedHL
    call CheckPlayerHeadCollision
    ld hl, $0100
    call MovePlayerYBySignedHL
    ldh a, [hPlayerState]
    cp $03
    jr nz, GroundInput_UpdateIdle

    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    call MovePlayerYBySignedHL
    ret


GroundInput_StartJump::
    jp StartPlayerJump


GroundInput_CheckDuck::
    ldh a, [hPlayerForm]
    cp $02
    jr z, GroundInput_CheckCockroachDrop

    ld a, $01
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerAnimTimer], a
    ldh [hPlayerStatePhase], a
    ret


GroundInput_CheckCockroachDrop::
    call ProbePlayerHeadOnePixelLower
    ldh a, [hJoyHeld]
    rrca
    jp c, Duck_DropThroughGround

    jr GroundInput_CheckDirectionalButtons

GroundInput_MoveRight::
    xor a
    ldh [hPlayerAnimTimer], a
    ld a, $01
    ldh [hPlayerStatePhase], a
    xor a
    ldh [hPlayerDirection], a
    ld a, [wStageBossStateFlag]
    cp $ff
    jr nz, GroundInput_ProbeRightBeforeMove

    ldh a, [hPlayerScreenX]
    cp $9c
    jp nc, ApplyPlayerXVelocity

GroundInput_ProbeRightBeforeMove::
    call CheckPlayerRightTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    call z, ApplyPlayerXVelocity
    jp ProbePlayerFeetThenHandleFall


GroundInput_MoveLeft::
    xor a
    ldh [hPlayerAnimTimer], a
    ld a, $01
    ldh [hPlayerStatePhase], a
    ld a, $ff
    ldh [hPlayerDirection], a
    call CheckPlayerLeftTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    call z, ApplyPlayerXVelocity
    jp ProbePlayerFeetThenHandleFall



PlayerState_UpdateJumpFall:: ; State 02: airborne control, gravity, and landing checks.
    call UpdateAirbornePlayerInput
    ldh a, [hPlayerState]
    cp $02
    ret nz

UpdateAirbornePlayerAnimByForm:: ; Select airborne player animation and form-specific air behavior.
    ldh a, [hPlayerForm]
    rst $00

	dw AirborneAnim_Normal
	dw AirborneAnim_FlyingSquirrel
	dw AirborneAnim_Cockroach
	dw AirborneAnim_Alternating
	dw AirborneAnim_Normal

AirborneAnim_Normal::
; Normal/Action Kamen airborne frame follows the sign of Y velocity.
    ld a, $0e
    ldh [hPlayerAnimId], a
    ldh a, [hPlayerVelYHigh]
    rlca
    ret c

    ld a, $0f
    ldh [hPlayerAnimId], a
    ret

AirborneAnim_FlyingSquirrel::
; Apply glide in jump state, then choose the ascent/descent frame.
    ldh a, [hPlayerState]
    cp $02
    call z, UpdateFlyingSquirrelGlide
    ldh a, [hPlayerVelYHigh]
    rlca
    jr nc, SquirrelAirborne_SelectDescentFrame

    ld a, $0e
    ldh [hPlayerAnimId], a
    ret


SquirrelAirborne_SelectDescentFrame::
    ld hl, wPlayerForcedJumpFlags
    bit 7, [hl]
    ret nz

    set 7, [hl]
    ld a, $0f
    ldh [hPlayerAnimId], a
    ret

AirborneAnim_Alternating::
; Two-frame airborne animation shared by chicken and inactive cockroach action.
    ld h, $0a
    ld l, $02
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, AirborneAlternatingAnimIds
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



AirborneAlternatingAnimIds::
; Shared two-frame table used by the chicken/cockroach airborne path.
    db $0e, $0f

AirborneAnim_Cockroach::
; Route active action animation through the cockroach hitbox updater.
    ldh a, [hPlayerActionLock]
    or a
    jr z, AirborneAnim_Alternating

    ld hl, CockroachAirActionFrames
    ld a, l
    ldh [hCockroachActionFramePtrLo], a
    ld a, h
    ldh [hCockroachActionFramePtrHi], a

UpdateCockroachActionHitbox:: ; Update cockroach action hitbox position while hPlayerActionLock is active.
    call UpdatePlayerActionAnimStep
    ldh a, [hPlayerScreenY]
    sub $0c
    ld [wPlayerActionHitbox0Y], a
    ld a, $04
    ldh [hActionHitboxHalfHeight], a
    ld de, $1606
    ld a, [wFormActionStep]
    cp $01
    jr nz, CockroachAction_SetHitboxWidthAndX

    ld de, $1c0c

CockroachAction_SetHitboxWidthAndX::
    ld a, e
    ldh [hActionHitboxHalfWidth], a
    ldh a, [hPlayerDirection]
    or a
    jr nz, CockroachAction_SetLeftHitboxX

    ldh a, [hPlayerScreenX]
    add d
    ld [wPlayerActionHitbox0X], a
    ret


CockroachAction_SetLeftHitboxX::
    ldh a, [hPlayerScreenX]
    sub d
    ld [wPlayerActionHitbox0X], a
    ret


UpdatePlayerActionAnimStep:: ; Advance multi-step player form action animation.
    ld a, [wFormActionStep]
    rst $00

    ; rst $00 jump table (3 entries)
    dw CockroachAction_Windup, CockroachAction_Extended, CockroachAction_Recover


CockroachAction_Windup::
    ld h, $08
    ld l, $03
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, hCockroachActionFramePtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hPlayerAnimFrame]
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


CockroachAction_Extended::
    ld h, $08
    ld l, $04
    ld e, $02
    call AdvancePlayerAnimWithinRange
    ld hl, hCockroachActionFramePtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hPlayerAnimFrame]
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


CockroachAction_Recover::
    ld h, $08
    ld l, $06
    ld e, $04
    call AdvancePlayerAnimWithinRange
    ld hl, hCockroachActionFramePtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [hPlayerAnimFrame]
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



CockroachAirActionFrames::
    db $18, $19, $19, $1a, $18, $1c

UpdateAirbornePlayerInput:: ; Handle airborne B action, horizontal control, gravity, and landing checks.
    ldh a, [hJoyPressed]
    bit 1, a
    jp nz, UsePlayerFormAction

    ldh a, [hJoyHeld]
    rrca
    call nc, LimitUpwardVelocityOnARelease
    ldh a, [hJoyHeld]
    bit 6, a
    jr nz, AirborneInput_ProbeSnapContact

AirborneInput_CheckHorizontalButtons::
    ldh a, [hJoyHeld]
    bit 4, a
    jr nz, AirborneInput_MoveRight

    bit 5, a
    jr nz, AirborneInput_MoveLeft

    jr AirborneInput_ApplyGravity

LimitUpwardVelocityOnARelease:: ; When A is released during upward motion, clamp upward velocity.
    ld a, [wPlayerForcedJumpFlags]
    or a
    ret nz

    ldh a, [hPlayerVelYHigh]
    rlca
    ret nc

    ld hl, hPlayerVelYLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0100
    add hl, de
    bit 7, h
    ret z

    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ret


AirborneInput_ProbeSnapContact::
    call CheckPlayerHeadCollision
    ldh a, [hPlayerState]
    cp $03
    jr nz, AirborneInput_CheckHorizontalButtons

    ret


AirborneInput_MoveRight::
    xor a
    ldh [hPlayerDirection], a
    call CheckPlayerRightTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    jr nz, AirborneInput_ApplyGravity

    call ApplyPlayerXVelocity
    jr AirborneInput_ApplyGravity

AirborneInput_MoveLeft::
    ld a, $ff
    ldh [hPlayerDirection], a
    call CheckPlayerLeftTileCollision
    ldh a, [hPlayerTileCollisionFlag]
    or a
    jr nz, AirborneInput_ApplyGravity

    call ApplyPlayerXVelocity

AirborneInput_ApplyGravity::
    ldh a, [hPlayerGravity]
    ld b, a
    ld hl, hPlayerVelYLo
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jp nz, ApplyPlayerYVelocityAndCheckGround

    cp $04
    jr c, AirborneInput_IntegrateFallAndCheckFeet

    ld a, $04
    ld [hl-], a
    ld [hl], $00

AirborneInput_IntegrateFallAndCheckFeet::
    call ApplyPlayerYVelocity
    call CheckPlayerFootTileContact
    ld hl, hPlayerState
    ld a, [hl+]
    cp [hl]
    ret nz

    ldh a, [hPlayerTileProbeCount]
    cp $02
    ret z

AlignPlayerToTileAndResetState::
; Apply tile-effect alignment before clearing motion/action state.
    call DispatchPlayerTileAlignment

ResetPlayerToNormalState:: ; Clear motion/action state and return to normal ground state.
    xor a
    ldh [hPlayerState], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [hPlayerAnimTimer], a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ld [wPlayerActionMeter], a
    ld [wPlayerForcedJumpFlags], a

UpdatePlayerJumpProfile:: ; Select jump profile. Chicken Shin-chan uses a stronger jump profile.
    ld a, PLAYER_JUMP_PROFILE_NORMAL
    ldh [hPlayerJumpProfile], a
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_CHICKEN
    ret nz

    ld a, PLAYER_JUMP_PROFILE_CHICKEN
    ldh [hPlayerJumpProfile], a
    ret


UpdateFlyingSquirrelGlide:: ; Flying squirrel: repeated A presses build glide meter and briefly cancel gravity/Y velocity.
    ldh a, [hJoyPressed]
    rrca
    jr nc, SquirrelGlide_DecayWhileDescending

    ld a, $4b
    call PlaySound
    ldh a, [hPlayerAnimId]
    cp $0e
    jr nz, SquirrelGlide_SelectAscentFrame

    inc a
    jr SquirrelGlide_UpdateMeter

SquirrelGlide_SelectAscentFrame::
    ld a, $0e

SquirrelGlide_UpdateMeter::
    ldh [hPlayerAnimId], a
    ld hl, wPlayerActionMeter
    ld a, [hl]
    add $1e
    cp $3d
    jr c, SquirrelGlide_StoreMeter

    ld a, $3c

SquirrelGlide_StoreMeter::
    ld [hl], a
    cp $1f
    ret c

SquirrelGlide_ClearVerticalMotion::
    xor a
    ldh [hPlayerGravity], a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ret


SquirrelGlide_DecayWhileDescending::
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
    jr nc, SquirrelGlide_ClearVerticalMotion

    ret


ApplyPlayerYVelocityAndCheckGround::
; Shared motion + ground-probe tail.
    call ApplyPlayerYVelocity
    jp CheckPlayerGroundCollision


StartPlayerJump:: ; Enter jump state and initialize upward velocity/sound.
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
    dw SetPlayerJumpVelocity0, SetPlayerJumpVelocity1, SetPlayerJumpVelocity2, SetPlayerJumpVelocity3
    dw SetPlayerJumpVelocity4, SetPlayerJumpVelocity5, SetPlayerJumpVelocity6, SetPlayerJumpVelocity7


SetPlayerJumpVelocity0::
; Jump profile 0: Y velocity 0. ; Jump velocity table targets write initial signed Y velocity.
    ld hl, $0000

StorePlayerJumpVelocityHL::
; Store signed 8.8 Y velocity from HL.
    ld a, l
    ldh [hPlayerVelY], a
    ld a, h
    ldh [hPlayerVelYHigh], a
    ret


SetPlayerJumpVelocity1::
; Jump profile 1; velocity is signed 8.8 pixels/frame.
    ld hl, -$0100 ; Signed 16-bit delta; interpreted as pixels or 8.8 velocity by the caller.
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity2::
; Jump profile 2; velocity is signed 8.8 pixels/frame.
    ld hl, -$0200 ; Signed 8.8 velocity, not an OAM pointer.
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity3::
; Jump profile 3; velocity is signed 8.8 pixels/frame.
    ld hl, -$0300
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity4::
; Jump profile 4; velocity is signed 8.8 pixels/frame.
    ld hl, -$0390
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity5::
; Jump profile 5; velocity is signed 8.8 pixels/frame.
    ld hl, -$0400
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity6::
; Jump profile 6; velocity is signed 8.8 pixels/frame.
    ld hl, -$0480
    jr StorePlayerJumpVelocityHL

SetPlayerJumpVelocity7::
; Jump profile 7; velocity is signed 8.8 pixels/frame.
    ld hl, -$0500
    jr StorePlayerJumpVelocityHL


PlayerState_UpdateHurtKnockback:: ; State 06: recovery/knockback-style animation state.
    ldh a, [hPlayerStatePhase]
    or a
    jr z, HurtRecovery_StreamFormTilesAndAnimate

    ld h, $0c
    ld l, $03
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerRecoveryAnimIdsA
    ldh a, [hPlayerAnimFrame]
    cp $02
    jr z, HurtRecovery_RestoreNormalControl

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



PlayerRecoveryAnimIdsA::
    db $02, $03, $03

HurtRecovery_RestoreNormalControl::
    ld a, $04
    ldh [hPlayerAnimId], a
    call QueuePlayerFormHudIcon
    ld a, $80
    ld [wPlayerHurtBlinkTimer], a
    ld hl, hPlayerFlags
    set 1, [hl]
    res 4, [hl]
    call AlignPlayerToTileAndResetState
    ldh a, [hPlayerForm]
    cp $04
    ret nz

    call SelectGameplayMusic
    ld hl, wActionKamenMoveSpeedLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ret


HurtRecovery_StreamFormTilesAndAnimate::
    call StreamPlayerFormTilesUntilComplete
    ldh a, [hPlayerAnimCounter]
    cp $01
    ld a, $48
    call z, PlaySound
    ld h, $0c
    ld l, $02
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerRecoveryAnimIdsB
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerRecoveryAnimIdsB::
    db $00, $01

StreamPlayerFormTilesUntilComplete::
; Advance the recovery phase after the tile counter reaches magnitude $54.
    call StreamNextPlayerFormTile
    rst $28
    cp $54
    ret c

    ldh a, [hPlayerStatePhase]
    inc a
    ldh [hPlayerStatePhase], a
    ret


StreamNextPlayerFormTile::
; Queue one bank 5 tile on nonnegative animation-counter frames.
    ld hl, PlayerFormGfxTileBaseTable
    ldh a, [hPlayerForm]
    rst $20
    ldh a, [hPlayerAnimTimer]
    bit 7, a
    jr nz, FormTileStream_AdvanceCounter

    ld c, a
    add $13
    ld e, a
    ld d, $05
    call QueueBankedVramTile8000

FormTileStream_AdvanceCounter::
    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    ret



PlayerFormGfxTileBaseTable::
    dw Gfx_b05_4131 ; normal
    dw Gfx_b05_45a1 ; flying squirrel
    dw Gfx_b05_53a1 ; cockroach
    dw Gfx_b05_4f41 ; chicken
    dw Gfx_b05_4ad1 ; Action Kamen

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


UpdateObjBouncingBall:: ; Object type $06: Stage 2 bouncing ball; hurts on contact, stompable.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld a, [bc]
    or $80
    ld [bc], a
    call UpdateBouncingBallState
    call CheckBouncingBallActionHitbox
    call CheckBouncingBallBodyCollision
    jp DrawCurrentStageObject


UpdateBouncingBallState:: ; Update state/animation for Stage 2 bouncing ball.
    xor a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    ; rst $00 jump table (4 entries)
    dw BouncingBall_WaitAndLaunchBounce, BouncingBall_ApplyThrownFall, BouncingBall_ApplyThrownFall, BouncingBall_UpdateBounceArc


BouncingBall_WaitAndLaunchBounce::
    ld a, $13
    ldh [hObjectAnimId], a
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
    ld de, -$02a0
    ld hl, $000a
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ldh a, [hObjectScreenX]
    ld hl, hPlayerScreenX
    sub [hl]
    rst $28
    cp $40
    ret nc

    ld de, $00b0
    ld a, [wAlternateModeFlags]
    or a
    jr z, BouncingBall_StoreHorizontalSpeed

    ld de, $0100

BouncingBall_StoreHorizontalSpeed::
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


BouncingBall_ApplyThrownFall::
    pop af
    ld a, $12
    ldh [hObjectAnimId], a
    ld hl, $0008
    add hl, bc
    xor a
    ld [hl+], a
    ld [hl], $01
    jp UpdateObjectThrownStateB


BouncingBall_UpdateBounceArc::
    ld a, $12
    ldh [hObjectAnimId], a
    call MoveObjectXBySpeed
    ld hl, $000a
    call AccelerateObjectYAtHL
    ld hl, $000a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, -$0280
    add hl, de
    ld a, h
    or l
    ret nz

    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


CheckBouncingBallActionHitbox::
    ld de, $0408
    jp CheckPlayerActionHitboxCollision


CheckBouncingBallBodyCollision::
    ld d, $05
    jp CheckPlayerBodyCollision


UpdateObjEnemyWalkingKid:: ; Object type $0a: walking kid enemy.
    call UpdateEnemyWalkerAState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerActionHitboxCollision_Default
    call CheckPlayerBodyCollisionDefault
    jp DrawCurrentStageObject


UpdateEnemyWalkerAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw WalkingKid_Patrol, WalkingKid_UpdateHitDelay, WalkingKid_UpdateThrownFall, WalkingKid_UpdateThrownFall


GetObjectStateAndDirectionFlags::
    xor a
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    ld a, [hl+]
    rlca
    jr nc, ReadObjectStateLowBits

    ld a, $01
    ldh [hSpriteFlags], a

ReadObjectStateLowBits::
    ld a, [hl]
    and $03
    ret


WalkingKid_Patrol::
    ld hl, ObjectPatrolAnimIds
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed

UpdateObjectPatrolTurnTimer::
    ld hl, OBJECT_OFS_TIMER
    add hl, bc
    dec [hl]
    ret nz

    ld d, h
    ld e, l
    ld hl, OBJECT_OFS_TYPE_WORK_A
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor OBJECT_DIRECTION_MASK
    ld [bc], a
    ret


AnimateObjectFromTableFast::
    ld d, $08

AnimateObjectFromTable::
    push hl
    ld hl, OBJECT_OFS_ANIM_COUNTER
    add hl, bc
    ld e, $04
    call AdvanceObjectAnimCounter
    ld hl, OBJECT_OFS_ANIM_FRAME
    add hl, bc
    ld a, [hl]
    pop hl
    rst $38
    ld a, [hl]
    ldh [hObjectAnimId], a
    ret



ObjectPatrolAnimIds::
    db $00, $01, $00, $02

WalkingKid_UpdateHitDelay::
    pop af
    ld a, $03
    ldh [hObjectAnimId], a

UpdateObjectThrownStateA::
    call UpdateObjectThrownStateATimer
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jp DrawCurrentStageObject


UpdateObjectThrownStateATimer::
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
    jp nz, EnemyAttack_RestorePatrolAndFacing

    ret


WalkingKid_UpdateThrownFall::
    pop af
    ld a, $03
    ldh [hObjectAnimId], a

UpdateObjectThrownStateB::
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    xor a
    ld [bc], a
    ret


AccelerateObjectY::
    ld hl, $0008

AccelerateObjectYAtHL::
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
    ld hl, OBJECT_OFS_Y_SUBPIXEL
    add hl, bc
    bit 7, d
    jp z, AddSignedVelocityToPosition24

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
    ld de, $040c

CheckPlayerActionHitboxCollision:: ; Check active player form/projectile hitboxes against current object.
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
    ld hl, wPlayerActionHitbox0X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [hObjectScreenY]
    sub e
    ldh [hTileStreamWritePos], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call CheckCurrentObjectAgainstPoint
    ret nc

    ld a, [bc]
    and $7f
    cp $05
    ldh a, [hPlayerForm]
    jr nc, ActionHitbox0_ResolveHitByForm

    cp PLAYER_FORM_ACTION_KAMEN
    jr z, ApplyObjectHitFromPlayerAction

ActionHitbox0_ResolveHitByForm::
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
    ld hl, wPlayerActionHitbox1X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [hObjectScreenY]
    sub e
    ldh [hTileStreamWritePos], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call CheckCurrentObjectAgainstPoint
    ret nc

    xor a
    ld [wPlayerSpecialActor1], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    jr ApplyObjectHitFromPlayerAction

CheckPlayerBodyCollisionDefault::
; Use body collision probe 0.
    ld d, $00

CheckPlayerBodyCollision::
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ret nc

ApplyObjectHitFromPlayerAction:: ; Apply normal player form/projectile hit handling to current object.
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
    ld h, b
    ld l, c
    inc hl
    ld [hl], $02
    ld de, -$0320
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


SetObjectActionHitStun:: ; Put object into short hit-stun after a non-launching form action hit.
    ld hl, $0002
    add hl, bc
    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $01
    ret


UpdateObjEnemyPartyHornKid:: ; Object type $0b: party-horn kid that reacts when the player approaches.
    xor a
    ldh [hPartyHornReachBonus], a
    call UpdateEnemyReactiveAState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckEnemyReactivePlayerProximity
    call CheckEnemyReactiveSpecialBodyCollision
    call CheckPlayerActionHitboxCollision_Default
    call CheckPlayerBodyCollisionDefault
    jp DrawCurrentStageObject


UpdateEnemyReactiveAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw PartyHornKid_Patrol, PartyHornKid_UpdateHitDelay, PartyHornKid_UpdateThrownFall, PartyHornKid_UpdateHornAttack


PartyHornKid_Patrol::
    ld hl, EnemyWalkerAnimIdsA
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemyWalkerAnimIdsA::
    db $06, $07, $06, $08

PartyHornKid_UpdateHitDelay::
    pop af
    ld a, $0b
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateA


PartyHornKid_UpdateThrownFall::
    pop af
    ld a, $0b
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateB


PartyHornKid_UpdateHornAttack::
    ld a, $09
    ldh [hObjectAnimId], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld d, a
    ld a, $0a
    ldh [hObjectAnimId], a
    ld a, $04
    ldh [hPartyHornReachBonus], a
    ld a, d
    cp $b4
    ret c

EnemyAttack_RestorePatrolAndFacing::
; Restore the saved facing bit and clear the attack latch in object byte +$0e.
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
    ldh a, [hObjectScreenY]
    ld e, a
    ldh a, [hPlayerScreenY]
    sub e
    rst $28
    cp $04
    ret nc

    ld d, $0c
    ldh a, [hPartyHornReachBonus]
    add d
    ld d, a
    call GetObjectLeadingEdgeScreenX
    ld e, a
    ldh a, [hPlayerScreenX]
    sub e
    rst $28
    cp d
    ret nc

    jp PlayerObjectCollision_ApplyDamage


GetObjectLeadingEdgeScreenX::
; Apply the signed/facing-dependent horizontal offset D to object screen X.
    ld a, [bc]
    rlca
    jr c, ObjectLeadingEdge_OffsetLeft

    ldh a, [hObjectScreenX]
    add d
    ret


ObjectLeadingEdge_OffsetLeft::
    ldh a, [hObjectScreenX]
    sub d
    ret


EnemyProximity_TickAttackCooldown::
    dec [hl]
    ret


CheckEnemyReactivePlayerProximity::
    ld e, $24

CheckEnemyPlayerProximityWithRange::
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
    jr nz, EnemyProximity_TickAttackCooldown

    ldh a, [hPlayerScreenY]
    ld d, a
    ldh a, [hObjectScreenY]
    sub d
    rst $28
    cp $0e
    ret nc

    ldh a, [hObjectScreenX]
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
    jr nc, EnemyProximity_TriggerIfFacingPlayer

    set 7, a

EnemyProximity_TriggerIfFacingPlayer::
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
    call UpdateEnemyWalkerBState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckEnemyWalkerBActionHitbox
    call CheckEnemyWalkerBSpecialBodyCollision
    jp DrawCurrentStageObject


UpdateEnemyWalkerBState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw UmbrellaKid_Patrol, UmbrellaKid_UpdateHitDelay, UmbrellaKid_UpdateThrownFall, UmbrellaKid_UpdateThrownFall


UmbrellaKid_Patrol::
    ld hl, EnemyWalkerAnimIdsB
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemyWalkerAnimIdsB::
    db $0c, $0d, $0c, $0e

UmbrellaKid_UpdateHitDelay::
    pop af
    ld a, $0f
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateA


UmbrellaKid_UpdateThrownFall::
    pop af
    ld a, $0f
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateB


CheckEnemyWalkerBActionHitbox::
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckEnemyWalkerBSpecialBodyCollision::
    ld d, $01
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ret nc

    ld a, $5c
    call PlaySound
    ret


UpdateObjEnemyPaperAirplaneKid:: ; Object type $0d: paper-airplane kid that spawns paper airplane projectiles.
    call UpdateEnemySpawnerAState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPaperAirplaneKidPlayerProximity
    call CheckPlayerActionHitboxCollision_Default
    call CheckPlayerBodyCollisionDefault
    jp DrawCurrentStageObject


UpdateEnemySpawnerAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw PaperAirplaneKid_Patrol, PaperAirplaneKid_UpdateHitDelay, PaperAirplaneKid_UpdateThrownFall, PaperAirplaneKid_UpdateThrowSequence


PaperAirplaneKid_Patrol::
    ld hl, EnemySpawnerAnimIds
    call AnimateObjectFromTableFast
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemySpawnerAnimIds::
    db $00, $01, $00, $02

PaperAirplaneKid_UpdateHitDelay::
    pop af
    ld a, $05
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateA


PaperAirplaneKid_UpdateThrownFall::
    pop af
    ld a, $05
    ldh [hObjectAnimId], a
    jp UpdateObjectThrownStateB


PaperAirplaneKid_UpdateThrowSequence::
    ld a, $03
    ldh [hObjectAnimId], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    and $7f
    jr z, SpawnEnemyPaperAirplane

    cp $78
    ret c

    jp EnemyAttack_RestorePatrolAndFacing


SpawnEnemyPaperAirplane::
    ld hl, wObjectSlots

PaperAirplane_FindFreeSlot::
    ld a, [hl]
    or a
    jr z, PaperAirplane_InitChildSlot

    cp $ff
    jr z, PaperAirplane_AppendBeforeTerminator

    ld de, $0010
    add hl, de
    jr PaperAirplane_FindFreeSlot

PaperAirplane_AppendBeforeTerminator::
    call PaperAirplane_InitChildSlot
    ld [hl], $ff
    ret


PaperAirplane_InitChildSlot::
    ld a, [bc]
    and $80
    or OBJ_ENEMY_PAPER_AIRPLANE
    ld [hl+], a

InitSpawnedChildObjectFromParent::
    xor a
    ld [hl+], a
    call CopyParentProjectileXOffset
    call CopyParentProjectileYOffset
    call CopyParentProjectileSpeedPlus40
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
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, -$0010
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
    ld e, $50
    jp CheckEnemyPlayerProximityWithRange


UpdateObjEnemyPaperAirplane:: ; Object type $0e: paper airplane projectile spawned by paper-airplane kid.
    call UpdateEnemyProjectileAState
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenPaperAirplane

    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $02
    jr nz, DrawEnemyPaperAirplane

    call CheckEnemyProjectileAActionHitbox
    call CheckEnemyProjectileABodyCollision

DrawEnemyPaperAirplane::
    ld a, $04
    ldh [hObjectAnimId], a
    jp DrawCurrentStageObject


ClearOffscreenPaperAirplane::
    xor a
    ld [bc], a
    ret


UpdateEnemyProjectileAState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw PaperAirplane_FlyHorizontally, PaperAirplane_FlyAndDescend, PaperAirplane_Descend, PaperAirplane_Descend


PaperAirplane_FlyHorizontally::
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


PaperAirplane_FlyAndDescend::
    call MoveObjectXBySpeed
PaperAirplane_Descend::
    ld de, $0100
    ld hl, $0005
    add hl, bc
    jp AddSignedVelocityToPosition24


CheckEnemyProjectileAActionHitbox::
    ld de, $0404
    jp CheckPlayerActionHitboxCollision


CheckEnemyProjectileABodyCollision::
    ld d, $03
    jp CheckPlayerBodyCollision


UpdateObjStage0BossProjectile:: ; Object type $05: Stage 0 boss hat projectile.
    call DispatchStage0BossProjectileState
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStage0BossHat

    call CheckStage0BossProjectileBodyCollision
    jp DrawCurrentStageObject


ClearOffscreenStage0BossHat::
    xor a
    ld [bc], a
    ret


DispatchStage0BossProjectileState::
; Two projectile states from GetObjectStateAndDirectionFlags.
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (2 entries)
    dw Stage0BossHat_FlyHorizontally, Stage0BossHat_FlyUpward


Stage0BossHat_FlyHorizontally::
    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call MoveStage0BossProjectileAndTickState

Stage0BossHat_AnimateSpin::
    ld d, $10
    ld hl, $000c
    add hl, bc
    ld e, $03
    call AdvanceObjectAnimCounter
    ld hl, $000b
    add hl, bc
    ld a, [hl]
    ld hl, Stage0BossProjectileAnimIds
    rst $38
    ld a, [hl]
    ldh [hObjectAnimId], a
    ret



Stage0BossProjectileAnimIds::
    db $12, $13, $14

MoveStage0BossProjectileAndTickState::
; Move in X and advance state after 60 timer counts.
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


Stage0BossHat_FlyUpward::
    call MoveObjectXBySpeed
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24
    jr Stage0BossHat_AnimateSpin

CheckStage0BossProjectileBodyCollision::
; Skip collision after boss clear; use body probe 4.
    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld d, $04
    jp CheckPlayerBodyCollision


UpdateObjEnemyToughKid:: ; Object type $0f: tough kid enemy with higher HP.
    call UpdateEnemyToughKidState
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckEnemyToughKidActionHitbox
    call CheckEnemyToughKidBodyCollision
    jp DrawCurrentStageObject


UpdateEnemyToughKidState::
    call GetObjectStateAndDirectionFlags
    rst $00

    ; rst $00 jump table (4 entries)
    dw EnemyToughKid_State00, EnemyToughKid_State01, EnemyToughKid_State02, EnemyToughKid_State02


EnemyToughKid_State00::
; UpdateEnemyToughKidState dispatch index $00; behavior name can be refined after tracing.
    ld hl, EnemyToughKidAnimIdsA
    ld d, $0f
    call AnimateObjectFromTable
    call MoveObjectXBySpeed
    jp UpdateObjectPatrolTurnTimer



EnemyToughKidAnimIdsA::
    db $10, $11, $10, $12

EnemyToughKidAnimIdsB::
    db $13, $14, $13, $14

EnemyToughKid_State01::
; UpdateEnemyToughKidState dispatch index $01; behavior name can be refined after tracing.
    pop af
    ld hl, EnemyToughKidAnimIdsB

AnimateAndDrawStunnedObject::
; Animate with period 15 and return to patrol when the hit delay expires.
    ld d, $0f
    call AnimateObjectFromTable
    call TickObjectStunTimer
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jp DrawCurrentStageObject


TickObjectStunTimer::
; Clear the timer and decrement the state once it reaches 180.
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


EnemyToughKid_State02::
; UpdateEnemyToughKidState dispatch index $02; behavior name can be refined after tracing.
    pop af
    ld hl, EnemyToughKidAnimIdsB
    call AnimateObjectFromTableFast
    jp UpdateObjectThrownStateB


CheckEnemyToughKidActionHitbox::
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckEnemyToughKidBodyCollision::
    ld d, $02
    jp CheckPlayerBodyCollision


UpdateObjStage0Boss:: ; Object type $01: Stage 0 boss / stage-clear actor.
    call ProjectObjectToScreenAndCull
    call DispatchStage0BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage0Boss_TickHitFlash

    call CheckStage0BossActionHitbox
    call CheckStage0BossBodyCollision

Stage0Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage0Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage0Boss_Draw::
    jp DrawCurrentStageObject


DispatchStage0BossState::
; Object state selects one of five boss/clear handlers.
    call GetObjectStateAndDirectionFlags
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage0Boss_Patrol, Stage0Boss_UpdateHitStun, Stage0Boss_FallAfterDefeat, Stage0Boss_UpdateThrowSequence
    dw BossClear_WalkPlayerOffscreen


Stage0Boss_UpdateThrowSequence::
    ld a, $10
    ldh [hObjectAnimId], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3f
    ret c

    jr z, Stage0Boss_BeginHatSlotSearch

    cp $a0
    ld a, $11
    ldh [hObjectAnimId], a
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Stage0Boss_BeginHatSlotSearch::
    ld hl, wObjectSlots

Stage0Boss_CheckNextHatSlot::
    ld a, [hl]
    or a
    jr z, Stage0Boss_InitHatProjectile

    cp $ff
    jr z, Stage0Boss_AppendHatBeforeTerminator

    ld de, $0010
    add hl, de
    jr Stage0Boss_CheckNextHatSlot

Stage0Boss_AppendHatBeforeTerminator::
    call Stage0Boss_InitHatProjectile
    ld [hl], $ff
    ret


Stage0Boss_InitHatProjectile::
    ld a, [bc]
    and $80
    or $05
    ld [hl+], a
    jp InitSpawnedChildObjectFromParent


BossClear_WalkPlayerOffscreen::
; Hold RIGHT until player screen X reaches $a8, then advance the stage flow.
    ld a, $10
    ldh [hJoyHeld], a
    ldh [hJoyPressed], a
    ldh a, [hPlayerScreenX]
    cp $a8
    ret c

    ld a, $01
    ld [wGameplayInitSubstate], a
    ld a, $03
    ld [wScreenSubstate], a
    ld a, $04
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ldh a, [hStageIndex]
    add a
    inc a
    ld [wStageSceneIndex], a
    ldh a, [hStageIndex]
    inc a
    ldh [hStageIndex], a
    cp $04
    ret c

    dec a
    ldh [hStageIndex], a
    xor a
    ld [wGameplayInitSubstate], a
    ret


Stage0Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage0BossAnimIdsA
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $01
    ld [hl+], a
    ld [hl], $04
    ret


Stage0Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage0BossAnimIdsA
    jp AnimateAndDrawStunnedObject



Stage0BossAnimIdsA::
    db $15, $16, $15, $16

Stage0Boss_Patrol::
    call CheckStage0BossHorizontalBounds
    ld hl, Stage0BossAnimIdsB
    call AnimateObjectFromTableFast
    jp MoveObjectXBySpeed



Stage0BossAnimIdsB::
    db $17, $18, $17, $19

CheckStage0BossHorizontalBounds::
; React at screen X $0c/$94.
    ldh a, [hObjectScreenX]
    and $fe
    cp $94
    jr z, Stage0Boss_BeginRightEdgeAttack

    jr nc, SetCurrentObjectFacingLeft

    cp $0c
    jr z, Stage0Boss_BeginLeftEdgeAttack

    jr c, SetCurrentObjectFacingRight

    ret


Stage0Boss_BeginRightEdgeAttack::
    ld a, $94
    ld hl, $0002
    add hl, bc
    ld [hl], $00
    inc hl
    ld a, $f4
    ld [hl], a
    call SetCurrentObjectFacingLeft

Stage0Boss_ResetThrowTimer::
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


SetCurrentObjectFacingLeft::
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


Stage0Boss_BeginLeftEdgeAttack::
    call SetCurrentObjectFacingRight
    jr Stage0Boss_ResetThrowTimer

SetCurrentObjectFacingRight::
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


CheckStage0BossActionHitbox::
; Half-width 4, half-height 16.
    ld de, $0410
    jp CheckPlayerActionHitboxCollision


CheckStage0BossBodyCollision::
; Use body probe 2.
    ld d, $02
    jp CheckPlayerBodyCollision


UpdateObjStage1Boss:: ; Object type $02: Stage 1 boss / stage-clear actor.
    call ProjectObjectToScreenAndCull
    call DispatchStage1BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage1Boss_TickHitFlash

    call CheckStage0BossActionHitbox
    call CheckStage0BossBodyCollision

Stage1Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage1Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage1Boss_Draw::
    jp DrawCurrentStageObject


DispatchStage1BossState::
; Object state selects one of five boss/clear handlers.
    call GetObjectStateAndDirectionFlags
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage1Boss_DispatchAttackPhase, Stage1Boss_UpdateHitStun, Stage1Boss_FallAfterDefeat, Stage1Boss_DispatchAttackPhase
    dw BossClear_WalkPlayerOffscreen


Stage1Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage1BossAnimIdsA
    jp AnimateAndDrawStunnedObject



Stage1BossAnimIdsA::
    db $17, $18, $17, $18

Stage1Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage1BossAnimIdsA
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $02
    ld [hl+], a
    ld [hl], $04
    ret


Stage1Boss_DispatchAttackPhase::
    ld a, [wStage1BossAttackPhase]
    and $0f
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage1Boss_WalkAndAnimate, Stage1Boss_WalkAndAnimate, Stage1Boss_WindUpJump, Stage1Boss_MoveThroughJump
    dw Stage1Boss_ResumePatrol


CheckStage1BossHorizontalBounds::
; React outside screen X $0c..$93.
    ldh a, [hObjectScreenX]
    cp $94
    jr nc, Stage1Boss_TurnAtRightEdge

    cp $0c
    jr c, Stage1Boss_TurnAtLeftEdge

    ret


Stage1Boss_TurnAtRightEdge::
    ld a, [bc]
    bit 7, a
    ret nz

    call SetCurrentObjectFacingLeft
    jr Stage1Boss_AdvanceAttackPhase

Stage1Boss_TurnAtLeftEdge::
    ld a, [bc]
    bit 7, a
    ret z

    call SetCurrentObjectFacingRight
    jr Stage1Boss_AdvanceAttackPhase

Stage1Boss_WalkAndAnimate::
; Check bounds, animate with table B, then move in X.
    call CheckStage1BossHorizontalBounds
    ld hl, Stage1BossAnimIdsB
    call AnimateObjectFromTableFast
    jp MoveObjectXBySpeed



Stage1BossAnimIdsB::
    db $14, $15, $14, $16

Stage1Boss_WindUpJump::
    ld a, $19
    ldh [hObjectAnimId], a
    ld a, [wStage1BossWindupTimer]
    inc a
    ld [wStage1BossWindupTimer], a
    cp $30
    ret c

    ld hl, -$0200 ; Signed 8.8 velocity, not an OAM pointer.
    ld a, l
    ld [wStage1BossJumpVelocityLo], a
    ld a, h
    ld [wStage1BossJumpVelocityHi], a
    xor a
    ld [wStage1BossWindupTimer], a

Stage1Boss_AdvanceAttackPhase::
; Low nibble dispatches the attack. Bit 7 alternates the next walking phase.
    ld a, [wStage1BossAttackPhase]
    inc a
    ld [wStage1BossAttackPhase], a
    and $0f
    cp $05
    ret nz

    ld a, [wStage1BossAttackPhase]
    and $80
    xor $80
    jr z, Stage1Boss_StoreAlternatingWalkPhase

    inc a

Stage1Boss_StoreAlternatingWalkPhase::
    ld [wStage1BossAttackPhase], a
    ret


Stage1Boss_MoveThroughJump::
    call MoveObjectXBySpeed
    call Stage1Boss_UpdateJumpVelocity
    ld a, $1a
    ldh [hObjectAnimId], a
    ld a, [wStage1BossJumpVelocityHi]
    bit 7, a
    ret nz

    ld a, $1b
    ldh [hObjectAnimId], a
    ret


Stage1Boss_UpdateJumpVelocity::
    ld hl, wStage1BossJumpVelocityLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0008
    ld a, [wAlternateModeFlags]
    or a
    jr z, Stage1Boss_ApplyJumpAcceleration

    ld de, $000c

Stage1Boss_ApplyJumpAcceleration::
    add hl, de
    ld a, l
    ld [wStage1BossJumpVelocityLo], a
    ld a, h
    ld [wStage1BossJumpVelocityHi], a
    ld d, h
    ld e, l
    call ApplyObjectYVelocity
    ldh a, [hObjectScreenY]
    cp $41
    ret c

    ld hl, $0005
    add hl, bc
    xor a
    ld [hl+], a
    ld a, $c0
    ld [hl], a
    jr Stage1Boss_AdvanceAttackPhase

Stage1Boss_ResumePatrol::
    jp Stage1Boss_WalkAndAnimate


UpdateObjStage2Boss:: ; Object type $03: Stage 2 boss / stage-clear actor; can spawn OBJ_STAGE2_BOSS_PROJECTILE.
    call ProjectObjectToScreenAndCull
    call DispatchStage2BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage2Boss_TickHitFlash

    call CheckStage1BossActionHitbox
    call CheckStage1BossBodyCollision

Stage2Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage2Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage2Boss_Draw::
    jp DrawCurrentStageObject


CheckStage1BossActionHitbox::
; Half-width 7, half-height 16.
    ld de, HITBOX_STAGE1_BOSS
    jp CheckPlayerActionHitboxCollision


CheckStage1BossBodyCollision::
; Use body probe 6.
    ld d, $06
    jp CheckPlayerBodyCollision


DispatchStage2BossState::
; Object state selects one of five boss/clear handlers.
    ld a, $01
    ldh [hSpriteFlags], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw UpdateObjStage2BossScriptController, Stage2Boss_UpdateHitStun, Stage2Boss_FallAfterDefeat, Stage2Boss_HoldThrowPose
    dw BossClear_WalkPlayerOffscreen


Stage2Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage2BossAnimIds
    jp AnimateAndDrawStunnedObject



Stage2BossAnimIds::
    db $19, $1a, $19, $1a

Stage2Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage2BossAnimIds
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $03
    ld [hl+], a
    ld [hl], $04
    ret


UpdateObjStage2BossScriptController:: ; Stage 2 boss script/controller routine at $69e3.
    call SelectStage2BossAnimByYVelocity
    call MoveObjectXBySpeed
    call Stage2Boss_TrySpawnAtJumpApex
    call ApplyStage2BossVerticalAcceleration
    ret nz

    ld hl, -$0440
    ld a, l
    ld [wStage2BossBounceVelocityLo], a
    ld a, h
    ld [wStage2BossBounceVelocityHi], a
    ld a, [wStage2BossBouncePhase]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage2Boss_BounceFacingLeft, Stage2Boss_AdvanceLeftBounce, Stage2Boss_BounceFacingRight, Stage2Boss_AdvanceRightBounce
    dw Stage2Boss_RestartBounceCycle


SelectStage2BossAnimByYVelocity::
; Use frame $15 while moving upward, $16 otherwise.
    ld a, $15
    ldh [hObjectAnimId], a
    ld a, [wStage2BossBounceVelocityHi]
    bit 7, a
    ret nz

    ld a, $16
    ldh [hObjectAnimId], a
    ret


Stage2Boss_BounceFacingLeft::
    ld a, $01
    ld [wStage2BossBouncePhase], a
    ld a, [bc]
    or $80
    ld [bc], a
    ret


Stage2Boss_AdvanceLeftBounce::
    ld a, $02
    ld [wStage2BossBouncePhase], a
    ret


Stage2Boss_BounceFacingRight::
    ld a, $03
    ld [wStage2BossBouncePhase], a
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


Stage2Boss_AdvanceRightBounce::
    ld a, $04
    ld [wStage2BossBouncePhase], a
    ret


Stage2Boss_RestartBounceCycle::
    jp Stage2Boss_BounceFacingLeft


ApplyStage2BossVerticalAcceleration::
; Add $0040 to the shared boss Y velocity and move the object.
    ld hl, wStage2BossBounceVelocityLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0040
    add hl, de
    ld a, l
    ld [wStage2BossBounceVelocityLo], a
    ld a, h
    ld [wStage2BossBounceVelocityHi], a
    ld d, h
    ld e, l
    call ApplyObjectYVelocity
    ld hl, -$0400
    add hl, de
    ld a, h
    or l
    ret


Stage2Boss_HoldThrowPose::
    ld a, $17
    ldh [hObjectAnimId], a
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


Stage2Boss_TrySpawnAtJumpApex::
; Only spawn when the bounce phase is active, Y velocity is zero, and no existing ball occupies a slot.
    ld a, [wStage2BossBouncePhase]
    or a
    ret z

    ld hl, wStage2BossBounceVelocityLo
    ld a, [hl+]
    or [hl]
    ret nz

    ld hl, wObjectSlots
    ld e, $20

Stage2Boss_CheckForExistingProjectile::
    ld a, [hl]
    and $7f
    cp OBJ_STAGE2_BOSS_PROJECTILE
    ret z

    ld a, $10
    rst $38
    dec e
    jr nz, Stage2Boss_CheckForExistingProjectile

    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ld hl, wObjectSlots

Stage2Boss_FindProjectileSlot::
    ld a, [hl]
    or a
    jr z, SpawnStage2BossProjectile

    cp $ff
    jr z, Stage2Boss_AppendProjectileBeforeTerminator

    ld de, $0010
    add hl, de
    jr Stage2Boss_FindProjectileSlot

Stage2Boss_AppendProjectileBeforeTerminator::
    call SpawnStage2BossProjectile
    ld [hl], $ff
    ret


SpawnStage2BossProjectile:: ; Spawn the Stage 2 boss small-ball projectile ($21).
    ld a, $80 | OBJ_STAGE2_BOSS_PROJECTILE
    ld [hl+], a
    xor a
    ld [hl+], a
    call Stage2BossProjectile_CopyXPlus8
    call Stage2BossProjectile_CopyYMinus32
    call CopyParentProjectileSpeedPlus40
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


Stage2BossProjectile_CopyXPlus8::
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
    call AddSignedVelocityToPosition24
    inc hl
    ret


Stage2BossProjectile_CopyYMinus32::
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, -$0020
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


UpdateObjStage2BossProjectile:: ; Object type $21: Stage 2 boss small-ball projectile.
    call DispatchStage2BossProjectileState
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStage2BossBall

    call CheckStage2BossProjectileBodyCollision
    jp DrawCurrentStageObject


ClearOffscreenStage2BossBall::
    xor a
    ld [bc], a
    ret


DispatchStage2BossProjectileState::
; Set projectile frame $1b; dispatch on the low state bit.
    ld a, $1b
    ldh [hObjectAnimId], a
    call GetObjectStateAndDirectionFlags
    and $01
    rst $00

    ; rst $00 jump table (2 entries)
    dw Stage2BossBall_FlyHorizontally, Stage2BossBall_FlyDownward


Stage2BossBall_FlyHorizontally::
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


Stage2BossBall_FlyDownward::
    call MoveObjectXBySpeed
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    jp AddSignedVelocityToPosition24


CheckStage2BossProjectileBodyCollision::
; Skip collision after boss clear; use body probe 7.
    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld d, $07
    jp CheckPlayerBodyCollision


UpdateObjStage3Boss:: ; Object type $04: Stage 3 boss / stage-clear actor with custom action hitbox handling.
    call ProjectObjectToScreenAndCull
    call DispatchStage3BossState
    ld a, [wBossHitFlashTimer]
    or a
    jr nz, Stage3Boss_TickHitFlash

    call CheckStage3BossActionHitboxes
    call CheckStage3BossBodyAndStomp

Stage3Boss_TickHitFlash::
    ld a, [wBossHitFlashTimer]
    or a
    jr z, Stage3Boss_Draw

    dec a
    ld [wBossHitFlashTimer], a
    and $08
    ret nz

Stage3Boss_Draw::
    jp DrawCurrentStageObject


CheckStage3BossActionHitboxes::
; Test active player action hitboxes against a 7x18-half-size boss hitbox.
    ld de, $0712
    ldh a, [hPlayerActionLock]
    or a
    ret z

    rrca
    push af
    push de
    call c, CheckStage3BossPrimaryActionHitbox
    pop de
    pop af
    rrca
    jr c, CheckStage3BossSecondaryActionHitbox

    ret


CheckStage3BossPrimaryActionHitbox::
; Shared per-action-hitbox rectangle comparison.
    ld hl, wPlayerActionHitbox0X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [hObjectScreenY]
    sub e
    ldh [hTileStreamWritePos], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call CheckCurrentObjectAgainstPoint
    ret nc

    ldh a, [hPlayerForm]
    cp PLAYER_FORM_ACTION_KAMEN
    jp z, LaunchObjectFromActionKamenHit

    cp PLAYER_FORM_COCKROACH
    jr z, Stage3Boss_ApplyHitDuringReturn

    xor a
    ld [wPlayerSpecialActor0], a
    ld hl, hPlayerActionLock
    res 0, [hl]
    jr Stage3Boss_ApplyHitDuringReturn

CheckStage3BossSecondaryActionHitbox::
    ld hl, wPlayerActionHitbox1X
    ldh a, [hActionHitboxHalfWidth]
    add d
    ld d, a
    ldh a, [hObjectScreenY]
    sub e
    ldh [hTileStreamWritePos], a
    ldh a, [hActionHitboxHalfHeight]
    add e
    ld e, a
    call CheckCurrentObjectAgainstPoint
    ret nc

    xor a
    ld [wPlayerSpecialActor1], a
    ld hl, hPlayerActionLock
    res 1, [hl]
    jr Stage3Boss_ApplyHitDuringReturn

CheckStage3BossBodyAndStomp::
; Use body probe 8 before checking the boss reaction fields.
    ld d, $08
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ret nc

Stage3Boss_ApplyHitDuringReturn::
    ld a, [wStage3BossNormalHitEnabled]
    or a
    ret z

    jp ApplyObjectHitFromPlayerAction


DispatchStage3BossState::
; Object state selects one of five boss/clear handlers.
    call GetObjectStateAndDirectionFlags
    ld a, [hl]
    rst $00

    ; rst $00 jump table (5 entries)
    dw Stage3Boss_DispatchAttackPhase, Stage3Boss_UpdateHitStun, Stage3Boss_FallAfterDefeat, Stage3Boss_DispatchAttackPhase
    dw BossClear_WalkPlayerOffscreen


Stage3Boss_UpdateHitStun::
    pop af
    ld a, $84
    ld [wBossHitFlashTimer], a
    ld hl, Stage3BossAnimIdsA
    jp AnimateAndDrawStunnedObject



Stage3BossAnimIdsA::
    db $18, $19, $18, $19

Stage3Boss_FallAfterDefeat::
    pop af
    ld a, STAGE_BOSS_STATE_CLEAR
    ld [wStageBossStateFlag], a
    ld hl, Stage3BossAnimIdsA
    call AnimateObjectFromTableFast
    call AccelerateObjectY
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jp z, DrawCurrentStageObject

    ld h, b
    ld l, c
    ld a, $04
    ld [hl+], a
    ld [hl], $04
    ret


Stage3Boss_DispatchAttackPhase::
    ld a, [wStage3BossAttackPhase]
    rst $00

    ; rst $00 jump table (14 entries)
    dw Stage3Boss_WalkToClimbPoint, Stage3Boss_Climb, Stage3Boss_WalkToThrowX70, Stage3Boss_UpdateCoconutThrow
    dw Stage3Boss_WalkToThrowX58, Stage3Boss_UpdateCoconutThrow, Stage3Boss_WalkToThrowX38, Stage3Boss_UpdateCoconutThrow
    dw Stage3Boss_WalkToThrowX18, Stage3Boss_UpdateCoconutThrow, Stage3Boss_WalkToDropPoint, Stage3Boss_DropToGround
    dw Stage3Boss_UpdateCameraShake, Stage3Boss_WalkBackRight


Stage3Boss_WalkToClimbPoint::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $8d
    jp nc, MoveObjectXBySpeed

    ld a, $01
    ld [wStage3BossAttackPhase], a
    ret


AnimateStage3BossFramesB::
; Use the four-entry Stage3BossAnimIdsB table.
    ld hl, Stage3BossAnimIdsB
    jp AnimateObjectFromTableFast



Stage3BossAnimIdsB::
    db $15, $16, $15, $17

Stage3Boss_Climb::
    ldh a, [hObjectScreenY]
    cp $21
    jr c, Stage3Boss_BeginWalkToFirstThrow

    ld de, $0100
    call MoveStage3BossUpByDE
    ld hl, Stage3BossAnimIdsC
    jp AnimateObjectFromTableFast



Stage3BossAnimIdsC::
    db $1d, $1e, $1d, $1e

Stage3Boss_BeginWalkToFirstThrow::
    ld a, $02
    ld [wStage3BossAttackPhase], a
    ret


MoveStage3BossUpByDE::
; Subtract DE from the three-byte Y position.
    ld hl, $0005
    add hl, bc
    jp SubtractSignedVelocityFromPosition24


Stage3Boss_WalkToThrowX70::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $70
    jp nc, MoveObjectXBySpeed

    ld a, $03
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_FinishThrowAndFaceLeft::
    ld a, [bc]
    set 7, a
    ld [bc], a
    xor a
    ld [wStage3BossAttackTimer], a
    ld a, [wStage3BossAttackPhase]
    inc a
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_UpdateCoconutThrow::
    ld a, [bc]
    res 7, a
    ld [bc], a
    xor a
    ld [wStage3BossCoconutFallEnabled], a
    ld a, $1b
    ldh [hObjectAnimId], a
    ld a, [wStage3BossAttackTimer]
    inc a
    ld [wStage3BossAttackTimer], a
    cp $30
    jr nc, Stage3Boss_FinishThrowAndFaceLeft

    cp $10
    ret c

    cp $20
    ret nc

    cp $1f
    jr z, SpawnStage3BossProjectile

    ld a, $1c
    ldh [hObjectAnimId], a
    ret


SpawnStage3BossProjectile:: ; Spawn Stage 3 boss coconut projectile/dropped hazard ($24).
    ld a, $1c
    ldh [hObjectAnimId], a
    ld hl, wObjectSlots

Stage3Boss_FindCoconutSlot::
    ld a, [hl]
    or a
    jr z, Stage3Boss_InitCoconutSlot

    cp $ff
    jr z, Stage3Boss_AppendCoconutBeforeTerminator

    ld de, $0010
    add hl, de
    jr Stage3Boss_FindCoconutSlot

Stage3Boss_AppendCoconutBeforeTerminator::
    call Stage3Boss_InitCoconutSlot
    ld [hl], $ff
    ret


Stage3Boss_InitCoconutSlot::
    ld a, OBJ_STAGE3_BOSS_PROJECTILE
    ld [hl+], a
    xor a
    ld [hl+], a
    call Stage3BossCoconut_CopyXPlus18
    call Stage3BossCoconut_CopyY
    call CopyParentProjectileSpeedPlus40
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


Stage3BossCoconut_CopyXPlus18::
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
    call AddSignedVelocityToPosition24
    inc hl
    ret


Stage3BossCoconut_CopyY::
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


Stage3Boss_WalkToThrowX58::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $58
    jp nc, MoveObjectXBySpeed

    ld a, $05
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_WalkToThrowX38::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $38
    jp nc, MoveObjectXBySpeed

    ld a, $07
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_WalkToThrowX18::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $18
    jp nc, MoveObjectXBySpeed

    ld a, $09
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_WalkToDropPoint::
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $14
    jp nc, MoveObjectXBySpeed

    ld a, $0b
    ld [wStage3BossAttackPhase], a
    ret


Stage3Boss_DropToGround::
    ld a, [bc]
    res 7, a
    ld [bc], a
    ld a, $1a
    ldh [hObjectAnimId], a
    ldh a, [hObjectScreenY]
    cp $70
    jr nc, Stage3Boss_BeginCameraShake

    cp $6e
    call nc, PlayStage3BossAttackSound
    ld de, $0200
    ld hl, $0005
    add hl, bc
    jp AddSignedVelocityToPosition24


Stage3Boss_BeginCameraShake::
    ld a, $0c
    ld [wStage3BossAttackPhase], a
    ld hl, hSCY
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ld [wStage3BossSavedScrollYLo], a
    ld a, h
    ld [wStage3BossSavedScrollYHi], a
    ret


PlayStage3BossAttackSound::
; Queue sound $68.
    ld a, $68
    call PlaySound
    ret


Stage3Boss_UpdateCameraShake::
    ld a, $1a
    ldh [hObjectAnimId], a
    ld a, [wStage3BossAttackTimer]
    inc a
    ld [wStage3BossAttackTimer], a
    cp $40
    jr nc, Stage3Boss_EndShakeAndRestoreCamera

    and $07
    jr z, Stage3Boss_ShakeCameraUp

    cp $04
    jr z, Stage3Boss_ShakeCameraDown

    ret


Stage3Boss_ShakeCameraUp::
    ldh a, [hSCY]
    sub $01
    ldh [hSCY], a
    ldh a, [hSCYHigh]
    sbc $00
    ldh [hSCYHigh], a
    ret


Stage3Boss_ShakeCameraDown::
    ldh a, [hSCY]
    add $01
    ldh [hSCY], a
    ldh a, [hSCYHigh]
    adc $00
    ldh [hSCYHigh], a
    ret


Stage3Boss_EndShakeAndRestoreCamera::
    xor a
    ld [wStage3BossAttackTimer], a
    ld a, $0d
    ld [wStage3BossAttackPhase], a
    ld hl, wStage3BossSavedScrollYLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hSCY], a
    ld a, h
    ldh [hSCYHigh], a
    ret


Stage3Boss_WalkBackRight::
    ld a, $01
    ld [wStage3BossNormalHitEnabled], a
    ld a, $01
    ld [wStage3BossCoconutFallEnabled], a
    call AnimateStage3BossFramesB
    ldh a, [hObjectScreenX]
    cp $8c
    jp c, MoveObjectXBySpeed

    xor a
    ld [wStage3BossNormalHitEnabled], a
    ld a, $01
    ld [wStage3BossAttackPhase], a
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


UpdateObjStage3BossProjectile:: ; Object type $24: Stage 3 boss coconut projectile/dropped hazard.
    call Stage3BossCoconut_UpdateFall
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStage3BossCoconut

    call CheckStage3BossProjectileBodyCollision
    xor a
    ldh [hSpriteFlags], a
    jp DrawCurrentStageObject


ClearOffscreenStage3BossCoconut::
    xor a
    ld [bc], a
    ret


Stage3BossCoconut_UpdateFall::
    ld a, $1f
    ldh [hObjectAnimId], a
    ld a, [wStage3BossCoconutFallEnabled]
    or a
    ret z

    ld hl, $0005
    add hl, bc
    ld de, $0180
    jp AddSignedVelocityToPosition24


CheckStage3BossProjectileBodyCollision::
; Skip collision after boss clear; use body probe 3.
    ld a, [wStageBossStateFlag]
    cp STAGE_BOSS_STATE_CLEAR
    ret z

    ld d, $03
    jp CheckPlayerBodyCollision


UpdateObjPlatformBouncePad:: ; Object type $1d: bounce pad / trampoline-style platform.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call UpdateBouncePadPlayerContact
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    ld hl, BouncePadSpriteIdle
    or a
    jr z, DrawBouncePadSelectedPose

    ld hl, BouncePadSpritePressed

DrawBouncePadSelectedPose::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


UpdateBouncePadPlayerContact::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, ApplyBouncePadJump

    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [hPlayerDeathCollisionDisabled]
    cp $ff
    ret z

    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $0e
    ret nc

    ldh a, [hObjectScreenY]
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

    call SetPlayerJumpVelocity0

AttachPlayerToObjectTop16:: ; Align player Y to object top - $10.
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, -$0010
    add hl, de
    ld a, l
    ldh [hPlayerY], a
    ld a, h
    ldh [hPlayerYHigh], a
    ret


ApplyBouncePadJump::
    ld hl, hPlayerYSubpixel
    ld de, $0100
    call AddSignedVelocityToPosition24
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
    ld [wPlayerForcedJumpFlags], a
    call AttachPlayerToObjectTop16
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    rst $00

    ; Bounce pad strength dispatch table.
    dw SetBouncePadJumpVelocity0 ; 00
    dw SetBouncePadJumpVelocity1 ; 01
    dw SetBouncePadJumpVelocity2 ; 02

SetBouncePadJumpVelocity0::
    ld hl, -$0390
    jp StorePlayerJumpVelocityHL


SetBouncePadJumpVelocity1::
    ld hl, -$0440
    jp StorePlayerJumpVelocityHL


SetBouncePadJumpVelocity2::
    ld hl, -$04c0
    jp StorePlayerJumpVelocityHL


UpdateObjMovingPlatformVerticalA:: ; Object type $1a: vertical moving platform variant A.
    call CullObjectAndReleaseSpawn
    ret nz

    call UpdateMovingPlatformVerticalA
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    call CheckPlayerStandingOnPlatform

DrawMovingPlatformMetasprite::
; Draw the fixed platform metasprite at the projected object position.
    ld hl, MovingPlatformVerticalSprite
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


UpdateMovingPlatformVerticalA::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    ; rst $00 jump table (4 entries)
    dw VerticalPlatform_MoveUp, TickPlatformWaitAndAdvanceState, VerticalPlatform_MoveDown, TickPlatformWaitAndAdvanceState


CheckPlayerStandingOnPlatform::
    ldh a, [hPlayerState]
    cp $06
    ret z

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld e, $12
    call CheckPlayerPlatformTopOverlap
    ret nc

AttachPlayerToPlatformTop::
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    call AttachPlayerToObjectTop16
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


CheckPlayerPlatformTopOverlap::
    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

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
    sub h
    ret nc

    cpl
    inc a
    cp $15
    ret nc

    cp $0f
    ccf
    ret


VerticalPlatform_MoveUp::
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24

MovingPlatform_TickTravelAndBeginWait::
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


TickPlatformWaitAndAdvanceState::
; Count object timer +$0d down, then advance the object state.
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


VerticalPlatform_MoveDown::
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call AddSignedVelocityToPosition24
    jr MovingPlatform_TickTravelAndBeginWait

UpdateObjMovingPlatformHorizontal:: ; Object type $1b: horizontal moving platform; carries the player along X.
    call CullObjectAndReleaseSpawn
    ret nz

    call UpdateMovingPlatformHorizontal
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    jp DrawMovingPlatformMetasprite


UpdateMovingPlatformHorizontal::
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    ; rst $00 jump table (4 entries)
    dw HorizontalPlatform_BeginLeftMove, HorizontalPlatform_WaitAtEndpoint, HorizontalPlatform_BeginRightMove, HorizontalPlatform_WaitAtEndpoint


HorizontalPlatform_BeginLeftMove::
; UpdateMovingPlatformHorizontal dispatch index $00; behavior name can be refined after tracing.
    ld hl, $0002
    add hl, bc
    ldh a, [hJoyHeld]
    and $30
    jr nz, HorizontalPlatform_MoveLeftAndCarry

    ld a, [hl]
    ldh [hPlayerXSubpixel], a

HorizontalPlatform_MoveLeftAndCarry::
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24
    call MovingPlatform_TickTravelAndBeginWait
    ldh a, [hPlayerState]
    cp $06
    ret z

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld e, $12
    call CheckPlayerPlatformTopOverlap
    ret nc

    ld hl, hPlayerXSubpixel
    ld de, $00c0
    call SubtractSignedVelocityFromPosition24
    jp AttachPlayerToPlatformTop


HorizontalPlatform_WaitAtEndpoint::
; UpdateMovingPlatformHorizontal dispatch index $01; behavior name can be refined after tracing.
    call TickPlatformWaitAndAdvanceState
    jp CheckPlayerStandingOnPlatform


HorizontalPlatform_BeginRightMove::
; UpdateMovingPlatformHorizontal dispatch index $02; behavior name can be refined after tracing.
    ld hl, $0002
    add hl, bc
    ldh a, [hJoyHeld]
    and $30
    jr nz, HorizontalPlatform_MoveRightAndCarry

    ld a, [hl]
    ldh [hPlayerXSubpixel], a

HorizontalPlatform_MoveRightAndCarry::
    ld de, $00c0
    call AddSignedVelocityToPosition24
    call MovingPlatform_TickTravelAndBeginWait
    ldh a, [hPlayerState]
    cp $06
    ret z

    ld e, $12
    call CheckPlayerPlatformTopOverlap
    ret nc

    ld hl, hPlayerXSubpixel
    ld de, $00c0
    call AddSignedVelocityToPosition24
    jp AttachPlayerToPlatformTop


UpdateObjDropPlatformA:: ; Object type $09/$1c: drop/moving platform variant A.
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStageObject

    call UpdateDropPlatformMotionA
    call CheckPlayerStandingOnDropPlatform
    ld hl, DropPlatformSpriteA
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


ClearOffscreenStageObject::
    xor a
    ld [bc], a
    ret


CheckPlayerStandingOnDropPlatform::
    ldh a, [hPlayerState]
    cp $06
    ret z

    ldh a, [hPlayerVelYHigh]
    rlca
    ccf
    ret nc

    ldh a, [hPlayerDeathCollisionDisabled]
    cp $ff
    ret z

    ld a, [wDropPlatformMinXDistance]
    ld l, a
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $10
    ret nc

    cp l
    ret nc

    ld [wDropPlatformMinXDistance], a
    ldh a, [hObjectScreenY]
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
    ldh [hPlayerPlatformAttached], a
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, -$0008
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
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, TickPlatformWaitAndAdvanceState

MoveDropPlatformDown::
    ld hl, $0005
    add hl, bc
    ld de, $0200
    jp AddSignedVelocityToPosition24


UpdateObjDropPlatformB:: ; Object type $1e: drop/moving platform variant B.
    call ProjectObjectToScreenAndCull
    ldh a, [hObjectOffscreen]
    or a
    jr nz, ClearOffscreenStageObject

    call UpdateDropPlatformMotionB
    call CheckPlayerStandingOnDropPlatform
    jp DrawCurrentStageObject


    xor a
    ld [bc], a
    ret


UpdateDropPlatformMotionB::
    ld a, $02
    ldh [hSpriteFlags], a
    ld a, $10
    ldh [hObjectAnimId], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, TickPlatformWaitAndAdvanceState

    dec a
    jr z, DropPlatformB_BlinkBeforeFalling

    jp MoveDropPlatformDown


DropPlatformB_BlinkBeforeFalling::
    ld hl, $000d
    add hl, bc
    bit 3, [hl]
    jp z, TickPlatformWaitAndAdvanceState

    ld a, $11
    ldh [hObjectAnimId], a
    jp TickPlatformWaitAndAdvanceState



DropPlatformSpriteA::
    db $f8, $f8, $b0, $10, $f8, $00, $b0, $10, $80

BouncePadSpriteIdle::
    db $f0, $f8, $b1, $10, $f0, $00, $b2, $10, $f8, $f8, $b3, $10, $f8, $00, $b4, $10
    db $80

BouncePadSpritePressed::
    db $f8, $f8, $b5, $10, $f8, $00, $b6, $10, $80

MovingPlatformVerticalSprite::
    db $f0, $f0, $b7, $00, $f0, $f8, $b8, $00, $f0, $00, $b8, $00, $f0, $08, $b9, $00
    db $f8, $f0, $ba, $00, $f8, $f8, $bb, $00, $f8, $00, $bb, $00, $f8, $08, $bc, $00
    db $80

UpdateObjStage2ShoppingCart:: ; Object type $22: Stage 2 shopping cart platform; moves after Shin-chan stands on it.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jr z, ShoppingCart_UpdateRide

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
    jr c, ShoppingCart_WrapWorldX

    ld de, -$0010

ShoppingCart_WrapWorldX::
    ldh a, [hSCX]
    add e
    ld [hl+], a
    ldh a, [hSCXHigh]
    adc d
    ld [hl], a

ShoppingCart_UpdateRide::
    call MovePlatformAndCarryPlayer
    call StopPlatformAtEndpoint
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
    ld hl, SpriteFrameData_21ce
    and $04
    jr z, ShoppingCart_DrawWheelFrame

    ld hl, SpriteFrameData_21ff

ShoppingCart_DrawWheelFrame::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetasprite


MovePlatformAndCarryPlayer::
    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $10
    ret nc

    ldh a, [hPlayerState]
    cp $0b
    ret z

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [hObjectScreenY]
    sub h
    ret c

    cp $20
    ret nc

    cp $1c
    jr nc, ShoppingCart_StartRideAndProbeWall

    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ldh [hPlayerX], a
    ld a, [hl+]
    ldh [hPlayerXHigh], a
    ld de, $0010
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    jr nc, ShoppingCart_PushPlayerToSide

    ld de, -$0010

ShoppingCart_PushPlayerToSide::
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
    ldh [hObjectScreenX], a
    ret


ShoppingCart_StartRideAndProbeWall::
    ldh a, [hPlayerVelYHigh]
    bit 7, a
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $c0
    call StopPlatformAtEndpoint
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    sub $1f
    ldh [hPlayerY], a
    push bc
    ld a, [bc]
    rlca
    jr nc, ShoppingCart_ProbeRightWall

    call CheckPlayerLeftTileCollision
    jr ShoppingCart_ApplyCarryIfClear

ShoppingCart_ProbeRightWall::
    call CheckPlayerRightTileCollision

ShoppingCart_ApplyCarryIfClear::
    ldh a, [hPlayerTileCollisionFlag]
    pop bc
    or a
    jr nz, ShoppingCart_CheckDropThroughInput

    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, hPlayerXSubpixel
    call ApplyObjectXVelocity

ShoppingCart_CheckDropThroughInput::
    ldh a, [hJoyHeld]
    and $81
    cp $81
    jr nz, ShoppingCart_MarkPlayerAttached

    ldh a, [hJoyHeld]
    res 0, a
    ldh [hJoyHeld], a

ShoppingCart_MarkPlayerAttached::
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


StopPlatformAtEndpoint::
    ld de, $0350
    ld a, [bc]
    sla a
    jr nc, ShoppingCart_CompareWorldXEndpoint

    ld de, $00b0

ShoppingCart_CompareWorldXEndpoint::
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


UpdateObjStage2FallingProduct:: ; Object type $1f: Stage 2 loose shelf product; falls when approached.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jr z, FallingProduct_UpdateVisibleObject

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, ClearOffscreenStageObject

    ret


FallingProduct_UpdateVisibleObject::
    call FallingProduct_UpdateMotionAndFramePair
    ld d, $03
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ld hl, $000a
    add hl, bc
    ldh a, [hTileStreamWritePos]
    ld d, [hl]
    bit 3, d
    jr z, FallingProduct_DrawSelectedFrame

    inc a

FallingProduct_DrawSelectedFrame::
    ld hl, FallingProductFramePointers
    rst $20
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


FallingProductFramePointers::
    dw SpriteFrameData_2230
    dw SpriteFrameData_2230
    dw SpriteFrameData_2230
    dw SpriteFrameData_223f
    dw SpriteFrameData_2235
    dw SpriteFrameData_223a

FallingProduct_UpdateMotionAndFramePair::
    xor a
    ldh [hTileStreamWritePos], a
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, FallingProduct_CheckWaitOrShake

    inc a
    and $0f
    or $40
    ld [hl], a
    ld a, $04
    ldh [hTileStreamWritePos], a
    ld hl, $0006
    add hl, bc

FallingProduct_AdvanceWorldY::
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl+], a
    ret


FallingProduct_CheckWaitOrShake::
    or a
    jr z, FallingProduct_ArmWhenPlayerNear

    inc a
    ld [hl], a
    ld a, $02
    ldh [hTileStreamWritePos], a
    ret


FallingProduct_ArmWhenPlayerNear::
    ldh a, [hObjectScreenX]
    ld d, a
    ldh a, [hPlayerScreenX]
    sub d
    rst $28
    cp $48
    ret nc

    ld a, $01
    ld [hl], a
    ret


UpdateObjStage2SoccerBall:: ; Object type $20: Stage 2 soccer ball; rolls toward Shin-chan and can be stomp-bounced.
    call CullObjectAndReleaseSpawn
    ret nz

    call SoccerBall_TryMoveNearPlayer
    ldh a, [hTileStreamWritePos]
    or a
    jr nz, SoccerBall_CheckCollisionAndAnimate

    ld hl, $000a
    add hl, bc
    bit 7, [hl]
    jp nz, ClearOffscreenStageObject

    ret


SoccerBall_CheckCollisionAndAnimate::
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld d, $05
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ld hl, $000a
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    inc a
    ld [de], a
    ld hl, SpriteFrameData_2244
    and $78
    cp $08
    jr nz, SoccerBall_CheckThirdRollFrame

    ld hl, SpriteFrameData_2255

SoccerBall_CheckThirdRollFrame::
    cp $10
    jr nz, SoccerBall_CheckDespawnThreshold

    ld hl, SpriteFrameData_2266

SoccerBall_CheckDespawnThreshold::
    cp $18
    jr c, DrawSoccerBall

    ld a, $80
    ld [de], a

DrawSoccerBall::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


SoccerBall_TryMoveNearPlayer::
    xor a
    ldh [hTileStreamWritePos], a
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
    jr z, SoccerBall_CheckProximityAndRoll

    cp $ff
    ret nz

SoccerBall_CheckProximityAndRoll::
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
    ldh [hTileStreamWritePos], a
    ret


UpdateObjActionKamenHangingDoll:: ; Object type $07: Stage 2 hanging Action Kamen doll; Shin-chan can grab/ride it.
    call CullObjectAndReleaseSpawn
    ret nz

    call HangingDoll_UpdateAttachmentAndMotion
    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld hl, SpriteFrameData_2277
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    jp DrawMetaspriteNormal


HangingDoll_UpdateAttachmentAndMotion::
    xor a
    ldh [hTileStreamWritePos], a
    ldh a, [hObjectScreenX]
    ld e, a
    ldh a, [hPlayerScreenX]
    sub e
    rst $28
    cp $08
    jr nc, HangingDoll_TickTravel

    ldh a, [hObjectScreenY]
    ld e, a
    ldh a, [hPlayerScreenY]
    sub e
    cp $06
    jr c, HangingDoll_TickTravel

    cp $10
    jr nc, HangingDoll_CheckLowerContactBound

    ldh a, [hPlayerVelYHigh]
    bit 7, a
    jr nz, HangingDoll_TickTravel

HangingDoll_CheckLowerContactBound::
    cp $14
    jr nc, HangingDoll_TickTravel

    ldh a, [hPlayerState]
    cp $0b
    jr z, HangingDoll_TickTravel

    cp $06
    jr z, HangingDoll_TickTravel

    ldh a, [hObjectOffscreen]
    or a
    jr nz, HangingDoll_TickTravel

    ldh a, [hJoyPressed]
    ld e, $13
    bit 7, a
    jr z, HangingDoll_CheckJumpOffset

    inc e

HangingDoll_CheckJumpOffset::
    bit 0, a
    jr z, HangingDoll_AttachPlayer

    ld e, $0f

HangingDoll_AttachPlayer::
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add e
    ldh [hPlayerY], a
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ldh a, [hPlayerState]
    cp $0d
    call nz, EnterPlayerAttachedGroundState
    ld a, $01
    ldh [hTileStreamWritePos], a

HangingDoll_TickTravel::
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    dec a
    ld [hl], a
    cp $d0
    jr z, HangingDoll_ReloadTimerAndReverse

    sla a
    ret c

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call ApplyObjectXVelocity
    ldh a, [hTileStreamWritePos]
    or a
    ret z

    ld de, $0100
    ld hl, hPlayerXSubpixel
    call ApplyObjectXVelocity
    ret


HangingDoll_ReloadTimerAndReverse::
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


UpdateObjFloatingBeachBall:: ; Object type $08: Stage 3 floating beach ball; sinks while stood on.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    ret nz

    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr z, BeachBall_ProjectSinkDepth

    dec [hl]

BeachBall_ProjectSinkDepth::
    srl a
    ld e, a
    ldh a, [hObjectScreenY]
    add e
    ldh [hObjectScreenY], a
    call BeachBall_CheckAndAttachPlayer
    ld e, $00
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr nz, DrawFloatingBeachBall

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    bit 4, a
    jr z, DrawFloatingBeachBall

    ld e, $02

DrawFloatingBeachBall::
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    add e
    ld b, a
    ld hl, SpriteFrameData_2486
    jp DrawMetaspriteWithBgPriority


    ret


BeachBall_CheckAndAttachPlayer::
    ldh a, [hObjectScreenX]
    ld h, a
    ldh a, [hPlayerScreenX]
    sub h
    rst $28
    cp $09
    ret nc

    ldh a, [hPlayerScreenY]
    ld h, a
    ldh a, [hObjectScreenY]
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
    jr nz, BeachBall_MarkPlayerAttachedAndSink

    ldh a, [hJoyHeld]
    res 0, a
    ldh [hJoyHeld], a

BeachBall_MarkPlayerAttachedAndSink::
    ld a, $ff
    ldh [hPlayerPlatformAttached], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    inc [hl]
    ldh a, [hPlayerState]
    cp $02
    ret nz

    jp ResetPlayerToNormalState


UpdateObjStage3FallingCoconut:: ; Object type $23: Stage 3 coconut; shakes, then falls when approached.
    call CullObjectAndReleaseSpawn
    ret nz

    ldh a, [hObjectOffscreen]
    or a
    jr z, Coconut_UpdateVisibleObject

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, ClearOffscreenStageObject

    ret


Coconut_UpdateVisibleObject::
    call Coconut_UpdateFallOrShake
    ld d, $05
    call LoadPlayerObjectCollisionProbe
    call CheckPlayerAgainstCurrentObject
    ld hl, $000a
    add hl, bc
    ldh a, [hObjectScreenX]
    ld c, a
    ldh a, [hObjectScreenY]
    ld b, a
    ld a, [hl]
    bit 3, a
    jr z, DrawFallingCoconut

    inc c

DrawFallingCoconut::
    ld hl, SpriteFrameData_2475
    jp DrawMetaspriteNormal


Coconut_UpdateFallOrShake::
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, Coconut_CheckWaitOrShake

    ld de, $0180
    ld hl, $0005
    add hl, bc
    call ApplyObjectXVelocity
    ret


Coconut_CheckWaitOrShake::
    or a
    jr z, Coconut_ArmWhenPlayerNear

    inc a
    ld [hl], a
    ret


Coconut_ArmWhenPlayerNear::
    ldh a, [hObjectScreenX]
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



Stage0SpawnList::
SpawnRecords_Stage0::
; Source: levels/stage0/spawns.csv (spawns, 401 decoded bytes).
    INCBIN "../build/original/assets/b01_74b5.bin"


Stage1SpawnList::
SpawnRecords_Stage1::
; Source: levels/stage1/spawns.csv (spawns, 416 decoded bytes).
    INCBIN "../build/original/assets/b01_7646.bin"


Stage2SpawnList::
SpawnRecords_Stage2::
; Source: levels/stage2/spawns.csv (spawns, 481 decoded bytes).
    INCBIN "../build/original/assets/b01_77e6.bin"


Stage3SpawnList::
SpawnRecords_Stage3::
; Source: levels/stage3/spawns.csv (spawns, 436 decoded bytes).
    INCBIN "../build/original/assets/b01_79c7.bin"


Stage4SpawnList::
SpawnRecords_Stage4::
; Source: levels/stage4/spawns.csv (spawns, 16 decoded bytes).
    INCBIN "../build/original/assets/b01_7b7b.bin"

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



TutorialMessageChangeTicks::
; Absolute ticks in units of 16 frames. The index follows the tutorial message sequence.
    db $01, $18, $2b, $49, $5c, $74, $86, $a9, $be, $ca, $ff


TutorialDemoInputScript::
; Input mask and hold duration pairs for the stage-4 tutorial.
    db $00, $4c, $10, $08, $11, $1e, $10, $1e, $00, $10, $10, $04, $00, $03, $40, $32
    db $00, $19, $80, $36, $00, $15, $10, $16, $00, $0c, $01, $11, $00, $24, $10, $1e
    db $00, $1e, $20, $22, $00, $0e, $10, $04, $00, $0a, $01, $1e, $00, $18, $10, $21
    db $11, $1e, $10, $19, $00, $1a, $80, $18, $81, $06, $80, $05, $00, $2c, $10, $3b
    db $00, $05, $20, $03, $00, $13, $80, $1d, $81, $0a, $80, $09, $00, $2c, $20, $18
    db $00, $2b, $01, $1d, $00, $9f, $01, $13, $00, $02, $01, $04, $00, $02, $01, $04
    db $00, $02, $01, $04, $00, $02, $01, $04, $00, $01, $01, $05, $00, $01, $01, $04
    db $00, $02, $01, $04, $00, $02, $01, $04, $00, $01, $01, $04, $00, $03, $01, $01
    db $21, $02, $20, $02, $21, $04, $20, $02, $21, $02, $01, $02, $00, $00, $20, $00
    db $00, $00, $01, $03, $00, $03, $01, $04, $00, $02, $20, $00, $21, $03, $20, $03
    db $21, $04, $20, $02, $21, $04, $20, $03, $21, $03, $20, $03, $21, $04, $20, $03
    db $01, $04, $00, $03, $01, $04, $00, $03, $01, $03, $21, $01, $20, $02, $21, $05
    db $20, $01, $21, $05, $20, $03, $21, $05, $20, $02, $01, $04, $20, $03, $21, $05
    db $20, $02, $21, $05, $20, $01, $00, $00, $01, $05, $00, $03, $01, $03, $00, $04
    db $01, $04, $00, $04, $01, $07, $00, $02, $01, $05, $00, $01, $01, $06, $00, $08
    db $02, $0c, $00, $4a, $20, $2a, $00, $30, $01, $19, $00, $80, $01, $20, $00, $2e
    db $20, $48, $00, $0f, $10, $05, $00, $31, $80, $0e, $81, $07, $80, $02, $00, $40
    db $02, $0b, $00, $8a, $80, $0a, $81, $0b, $80, $01, $00, $27, $80, $0e, $81, $10
    db $80, $00, $00, $30, $10, $20, $00, $2d, $01, $13, $00, $94, $10, $64, $00, $24
    db $20, $4e, $00, $0c, $10, $07, $00, $2b, $01, $14, $11, $0b, $10, $09, $00, $2e
    db $02, $0b, $00, $2a, $10, $56, $00, $62, $10, $80


PasswordScreenLayoutRle_Bank1::
LayoutRle_b01_7e7c::
; Source: maps/password.bin (rleff, 360 decoded bytes).
    INCBIN "../build/original/assets/b01_7e7c.bin"


    ds $8000 - @, $ff
