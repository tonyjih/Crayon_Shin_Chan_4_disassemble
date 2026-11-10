EnterDebugMenu::
    ld a, [wAlternateModeFlags]
    and $04
    ld hl, hStageIndex
    add [hl]
    ld [wDebugStageSelection], a
    ld a, $01
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


UpdateDebugMenu::
    call HandleDebugMenuInput
    call DrawDebugMenuValues
    ret


DrawDebugMenuValues::
    call DrawDebugMenuCursor
    call DrawDebugStageNumber
    call DrawDebugCheckpointFlag
    call DrawDebugPlayerFlags
    call DrawDebugLives
    call DrawDebugPlayerForm
    call DrawDebugMusicIndex
    call DrawDebugSoundIndex
    ret


DrawDebugStageNumber::
    ld a, [wDebugStageSelection]
    add $f1
    ld hl, _SCRN0 + $06f
    jp QueueTilemapByte


DrawDebugCheckpointFlag::
    ld hl, _SCRN0 + $0ad
    ld de, DebugTextOff
    ld a, [wStageCheckpointActive]
    or a
    jp nz, QueueTextLine

    ld de, DebugTextOn
    jp QueueTextLine


DrawDebugPlayerFlags::
    ld hl, _SCRN0 + $0ed
    ld de, DebugTextOff
    ldh a, [hPlayerFlags]
    or a
    jp nz, QueueTextLine

    ld de, DebugTextOn
    jp QueueTextLine


DrawDebugLives::
    ld bc, _SCRN0 + $12e
    ldh a, [hPlayerLives]
    jp QueueHudTwoDecimalDigits


DrawDebugPlayerForm::
    ld bc, _SCRN0 + $14b
    ld de, $0005
    call QueueVramFill
    ld hl, DebugPlayerFormNameTable
    ldh a, [hPlayerForm]
    rst $20
    ld d, h
    ld e, l
    ld hl, _SCRN0 + $16b
    jp QueueTextLine


DebugPlayerFormNameTable::
    dw DebugTextFormNormal
    dw DebugTextFormFlyingSquirrel
    dw DebugTextFormCockroach
    dw DebugTextFormChicken
    dw DebugTextFormActionKamen

DrawDebugMusicIndex::
    ld bc, _SCRN0 + $1ae
    ld a, [wDebugMusicIndex]
    jp QueueHudTwoDecimalDigits


DrawDebugSoundIndex::
    ld bc, _SCRN0 + $1ee
    ld a, [wDebugSoundIndex]
    jp QueueHudTwoDecimalDigits


DrawDebugMenuCursor::
    ld bc, _SCRN0 + $063
    ld de, $000e
    call QueueVramFill_SetHighBit
    ld a, [wDebugCursorRow]
    ld c, $40
    call MultiplyBCByA8bit
    ld bc, _SCRN0 + $063
    add hl, bc
    ld a, $0e
    jp QueueTilemapByte


HandleDebugMenuInput::
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, DebugMenu_ResumeGameplay

    bit 3, a
    jr nz, DebugMenu_ResumeGameplay

    bit 7, a
    jr nz, DebugMenu_MoveCursorDown

    bit 6, a
    jr nz, DebugMenu_MoveCursorUp

    bit 5, a
    jr nz, DebugMenuLeftActionDispatch

    bit 4, a
    jp nz, DebugMenuRightActionDispatch

    ret


DebugMenu_MoveCursorDown::
    ld hl, wDebugCursorRow
    inc [hl]
    ld a, [hl]
    cp $07
    ret c

    ld [hl], $00
    ret


DebugMenu_MoveCursorUp::
    ld hl, wDebugCursorRow
    dec [hl]
    ld a, [hl]
    cp $ff
    ret nz

    ld [hl], $06
    ret


DebugMenu_ResumeGameplay::
    ld a, $03
    ld [wGameplayInitSubstate], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld hl, $0800
    ld a, l
    ld [wFormTimerLo], a
    ld a, h
    ld [wFormTimerHi], a
    xor a
    ld [wAlternateModeFlags], a
    ld a, [wDebugStageSelection]
    ld b, a
    and $03
    ldh [hStageIndex], a
    bit 2, b
    ret z

    ld a, $04
    ld [wAlternateModeFlags], a
    ret


DebugMenuLeftActionDispatch::
    ld a, [wDebugCursorRow]
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
    ld a, [wDebugStageSelection]
    dec a
    and $07
    ld [wDebugStageSelection], a
    ret


DebugMenuActionToggleStageFlag::
    ld a, [wStageCheckpointActive]
    xor $ff
    ld [wStageCheckpointActive], a
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
    call DebugMenu_DecrementMusicIndex
    ld hl, DebugMenuMusicIdTable
    rst $38
    ld a, [hl]

DebugMenu_PlayMusicId::
    call PlaySound_Queue3
    ret


DebugMenu_DecrementMusicIndex::
    ld a, [wDebugMusicIndex]
    sub $01
    ld [wDebugMusicIndex], a
    ret nc

    ld a, $14
    ld [wDebugMusicIndex], a
    ret


DebugMenuActionDecSound::
    call DebugMenu_DecrementSoundIndex
    jp PlayDebugSelectedSound


DebugMenu_DecrementSoundIndex::
    ld a, [wDebugSoundIndex]

DebugMenu_DecrementSoundIndex_Apply::
    sub $01
    ld [wDebugSoundIndex], a
    ret nc

    ld a, $1e
    ld [wDebugSoundIndex], a
    ret


DebugMenuRightActionDispatch::
    ld a, [wDebugCursorRow]
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
    ld a, [wDebugStageSelection]
    inc a
    and $07
    ld [wDebugStageSelection], a
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
    db $00, $04, $08, $0c, $10, $14, $1c, $20
    db $24, $28, $2c, $30, $34, $38, $3c, $60
    db $64, $18, $18, $18, $18, $18, $18, $18
    db $18, $18, $18, $18, $18, $18, $18, $18

DebugMenuActionResetMusicId::
    ld a, [wDebugMusicIndex]
    inc a
    ld [wDebugMusicIndex], a
    cp $15
    ret c

    xor a

DebugMenu_StoreMusicIndex::
    ld [wDebugMusicIndex], a
    ret


DebugMenuActionIncSound::
    call DebugMenu_IncrementSoundIndex

PlayDebugSelectedSound::
    ld hl, DebugMenuSoundDispatchTable

PlayDebugSelectedSound_Dispatch::
    ld a, [wDebugSoundIndex]
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

DebugMenu_IncrementSoundIndex::
    ld a, [wDebugSoundIndex]
    inc a
    ld [wDebugSoundIndex], a
    cp $1f
    ret c

    xor a
    ld [wDebugSoundIndex], a
    ret


LoadDebugMenu::
    xor a
IF DEF(DEBUG)
    call DebugMenu_InitBackgroundGfx
    xor a
ELSE
    ldh [hNeedsReset], a
    ldh [hSCX], a
ENDC
    ldh [hSCY], a
    ldh [hPlayerFlags], a
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    call ClearBgMap0
    ld hl, _SCRN0 + $064
    ld de, DebugTextStage
    call CopyTextLineToVram
    ld hl, _SCRN0 + $0a4
    ld de, DebugTextFlagA
    call CopyTextLineToVram
    ld hl, _SCRN0 + $0e4
    ld de, DebugTextFlagB
    call CopyTextLineToVram
    ld hl, _SCRN0 + $124
    ld de, DebugTextLives
    call CopyTextLineToVram
    ld hl, _SCRN0 + $164
    ld de, DebugTextForm
    call CopyTextLineToVram
    ld hl, _SCRN0 + $1a4
    ld de, DebugTextMusic
    call CopyTextLineToVram
    ld hl, _SCRN0 + $1e4
    ld de, DebugTextSound
    call CopyTextLineToVram
    ld hl, wPaletteBGP
    ld [hl], $e4
    ld a, $83
    ld [wLCDCShadow], a
    ret
