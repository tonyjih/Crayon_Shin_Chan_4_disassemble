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
    dw InitGameplaySubstateFreshStart ; $00
    dw InitGameplaySubstateResetStageFlags ; $01
    dw InitGameplaySubstateCommon ; $02, resume with current stage flags
    dw InitGameplaySubstateCommon ; $03, DEBUG menu start

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
