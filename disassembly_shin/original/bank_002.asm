; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $002", ROMX[ROM_BANK_ID_ADDR], BANK[$2]

RomBankId_Bank2::
    db $02
Bank2FarCallTable::
    dw InitTitleOrPasswordScreen ; $00
    dw UpdateTitleOrPasswordScreen ; $02
    dw InitMinigameScreen ; $04
    dw UpdateMinigameScreen ; $06
    dw InitSceneTestMenu ; $08
    dw UpdateSceneTestMenu ; $0a
    dw InitStageTransitionScreens ; $0c
    dw UpdateStageTransitionScreens ; $0e
    dw InitEndingScreen ; $10
    dw UpdateEndingScreen ; $12

InitTitleOrPasswordScreen::
; Initialize state 1; substate 4 opens the scene-test menu.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld [wScreenFrameCounter], a
    ld [wScreenPhaseCounter], a
    ld a, $01
    ldh [rIE], a
    ld a, $a0
    ldh [hOamMaxY], a
    ld a, $03
    ld [wContinuesRemaining], a
    xor a
    ldh [hNeedsReset], a
    ld a, [wScreenSubstate]
    cp $04
    jp z, InitSceneTestMenu

    or a
    jp nz, InitPasswordScreen

    ld a, $83
    ld [wLCDCShadow], a
    ld a, BANK(GfxRle_b06_4001)
    ld hl, GfxRle_b06_4001
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_501e)
    ld hl, LayoutRle_b06_501e
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound

InitTitleMenuPresentation::
; Restore title music, palette, animation scripts and remembered menu selection.
    ld a, $28
    call PlaySound_Queue3
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $01
    ld [wScreenPaletteId], a
    ld hl, SceneAnim_TitleIntro
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    ld hl, SceneAnim_TitleSecondary
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wSceneAnim1Timer], a
    ld [wMessageState], a
    ldh [hPlayerHealth], a
    ldh [hStageIndex], a
    ld a, [wTitleMenuPhase]
    or a
    jr nz, InitTitleMenu_ResetMinigameStats

    ld [wMenuCursorRow], a

InitTitleMenu_ResetMinigameStats::
    ld a, $01
    ld hl, wBonusMinigameRounds
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld hl, wBonusInstructionPending
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld a, [wTitleMenuPhase]
    or a
    ret z

    ld hl, _SCRN0 + $1a0
    ld bc, $00a0
    call bzero
    ld a, $02
    ld [wMessageFlags], a
    ld a, [wTitleMenuPhase]
    add $0c
    call StartMessageFar
    ld hl, SceneAnim_TitleIdle
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, [wTitleMenuPhase]
    cp $01
    ld a, [wTitleSavedMainCursor]
    jr z, InitTitleMenu_RestoreCursor

    ld a, [wTitleSavedMinigameCursor]

InitTitleMenu_RestoreCursor::
    ld [wMenuCursorRow], a
    ret


UpdateTitleOrPasswordScreen::
; Dispatch on wScreenSubstate.
    ld a, [wScreenSubstate]
    rst $00

    ; Title/menu substate update table.
TitleMenuUpdateHandlers::
    dw TitleMenu_UpdateIntro ; $00
    dw PasswordScreen_UpdateInput ; $01
    dw PasswordScreen_ConfirmAcceptedCode ; $02
    dw PasswordScreen_FadeToSavedDestination ; $03
    dw UpdateSceneTestMenu ; $04

TitleMenu_UpdateIntro::
; Animate the title scene, then dispatch the menu phase after the message completes.
    ld c, $34
    ld b, $60
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld c, $68
    ld b, $60
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $03
    jr nz, TitleMenu_WaitForMessage

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $b4
    jr c, TitleMenu_WaitForMessage

    ld a, $c0
    ld [wScreenFrameCounter], a
    jr nz, TitleMenu_WaitForMessage

    ld hl, SceneAnim_TitleIdle
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

TitleMenu_WaitForMessage::
    call UpdateMenuMessageVramClear
    ld a, [wMessageState]
    or a
    ret nz

    ld a, [wTitleMenuPhase]
    rst $00

TitleMenuPhaseHandlers::
    dw TitleMenu_WaitForStart ; $00
    dw TitleMenu_HandleMainSelection ; $01
    dw TitleMenu_HandleMinigameSelection ; $02

TitleMenu_WaitForStart::
; A or START opens the main menu.
    ldh a, [hJoyPressed]
    and $09
    ret z

TitleMenu_OpenMainChoices::
    ld a, $01
    ld [wTitleMenuPhase], a
    call StartMenuMessage
    ld a, [wTitleSavedMainCursor]
    ld [wMenuCursorRow], a
    ret


TitleMenu_HandleMainSelection::
; Three choices: game, password, minigames.
    call UpdateMenuCursor
    ld a, [wMenuCursorRow]
    ld b, a
    ld [wTitleSavedMainCursor], a
    ldh a, [hJoyPressed]
    and $09
    ret z

    ld a, [wMenuCursorRow]
    or a
    jr nz, TitleMenu_CheckPasswordChoice

    ld a, [wSpecialModeFlags]
    or a
    jr z, TitleMenu_StartNewGame

    ld a, $04
    ld [wAlternateModeFlags], a

TitleMenu_StartNewGame::
    ld bc, $0600 ; constant, not a ROM0 CopyTilemapRowToVram_Loop pointer
    ld de, $0800
    jp RequestStateChange_Menu


TitleMenu_CheckPasswordChoice::
    dec a
    jr nz, TitleMenu_OpenMinigameChoices

    ld bc, $0500
    ld de, $0001
    jp RequestStateChange_Menu


TitleMenu_OpenMinigameChoices::
    ld a, $02
    ld [wTitleMenuPhase], a
    call StartMenuMessage
    ld a, [wTitleSavedMinigameCursor]
    ld [wMenuCursorRow], a
    ret


TitleMenu_HandleMinigameSelection::
; Choose one of three minigames and restore its highest unlocked round.
    call UpdateMenuCursor
    ld a, [wMenuCursorRow]
    ld [wTitleSavedMinigameCursor], a
    ldh a, [hJoyPressed]
    bit 1, a
    jr nz, TitleMenu_OpenMainChoices

    ldh a, [hJoyPressed]
    and $09
    ret z

    ld hl, wMinigameUnlockedRounds
    ld a, [wMenuCursorRow]
    rst $38
    ld a, [hl]
    ld [wMinigameRound], a
    ld b, $02
    ld a, [wMenuCursorRow]
    ld c, a
    ld de, $0002
    jp RequestStateChange_Menu


UpdateMenuCursor:: ; Move menu cursor using hJoyPressed, wrapping through options.
    ld a, $03
    ldh [hMenuCursorOptionCount], a
    ld hl, _SCRN0 + $1a5
    ld a, l
    ldh [hMenuCursorDestLo], a
    ld a, h
    ldh [hMenuCursorDestHi], a

UpdateMenuCursorAtCurrentPosition::
; Cursor base pointer is in $ffca/$ffcb; option count is in hMenuCursorOptionCount.
    ld a, [wMenuCursorRow]
    ld d, a
    ld hl, hMenuCursorDestLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    ld c, d
    ld b, $00
    swap c
    sla c
    rl b
    sla c
    rl b
    add hl, bc
    xor a
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    and $c4
    jr z, MenuCursor_DrawSelection

    ldh a, [hJoyPressed]
    bit 6, a
    jr nz, MenuCursor_MoveUp

    ld a, $40
    call PlaySound
    inc d
    ldh a, [hMenuCursorOptionCount]
    dec a
    cp d
    jr nc, MenuCursor_DrawSelection

    ld d, $00
    jr MenuCursor_DrawSelection

MenuCursor_MoveUp::
    ld a, $40
    call PlaySound
    dec d
    bit 7, d
    jr z, MenuCursor_DrawSelection

    ldh a, [hMenuCursorOptionCount]
    dec a
    ld d, a

MenuCursor_DrawSelection::
    pop hl
    ld a, d
    ld [wMenuCursorRow], a
    ld c, d
    ld b, $00
    swap c
    sla c
    rl b
    sla c
    rl b
    add hl, bc
    ld a, $0e
    call QueueTilemapByte
    ret


UpdateMenuMessageVramClear:: ; Clear/update queued title/menu message rows when $d96d is active.
    ld a, [wMessageState]
    or a
    ret z

    ld a, [wMessageDestLo]
    ld c, a
    ld a, [wMessageDestHi]
    ld b, a
    ld a, c
    and $e0
    ld c, a
    push bc
    ld d, $00
    ld e, $13
    call QueueVramFill
    ld a, $20
    pop hl
    ld bc, -$0020
    add hl, bc
    ld c, l
    ld b, h
    ld d, $00
    ld e, $13
    call QueueVramFill
    call UpdateMessageFar
    ret


StartMenuMessage:: ; Start a bank3 text/message sequence for the selected title-menu item.
    ld a, $00
    ld [wMessageFlags], a
    ld a, [wTitleMenuPhase]
    add $0c
    call StartMessageFar
    xor a
    ld [wMenuCursorRow], a
    ret


BuildMenuPatternBackground::
; Fill a 20x18 tilemap using three repeating row patterns.
    ld c, $00
    ld de, _SCRN0

MenuBackground_NextThreeRowGroup::
    ld b, $03

MenuBackground_SelectRowPattern::
    ld hl, MenuBackgroundPatternPtrs
    ld a, b
    dec a
    push de
    rst $20
    pop de
    ld a, c
    rst $38
    push bc
    ld c, $14

MenuBackground_ReadPatternTile::
    push bc
    ld a, [hl+]
    cp $ff
    jr nz, MenuBackground_ApplyTileBase

    ld bc, -$0007
    add hl, bc
    ld a, [hl+]

MenuBackground_ApplyTileBase::
    or a
    jr z, MenuBackground_StoreTile

    ld b, a
    ldh a, [hTileStreamWritePos]
    add b

MenuBackground_StoreTile::
    ld [de], a
    pop bc
    inc de
    dec c
    jr nz, MenuBackground_ReadPatternTile

    ld a, e
    and $e0
    add $20
    ld e, a
    ld a, d
    adc $00
    ld d, a
    pop bc
    dec b
    jr nz, MenuBackground_SelectRowPattern

    inc c
    ld a, c
    cp $06
    jr c, MenuBackground_NextThreeRowGroup

    ret


RequestStateChange_Menu:: ; Menu/screen transition helper. Sets hNeedsReset and dispatches next hGameState/substate.
    ld a, e
    ld [wStateChangeParamLo], a
    ld a, d
    ld [wStateChangeParamHi], a
    ld a, $01
    ldh [hNeedsReset], a
    xor a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    ld [wMessageState], a
    ld a, b
    rst $00

    ; RequestStateChange_Menu dispatch table. B selects one of these handlers.
    dw RequestState_ReturnToTitleMenu        ; 00
    dw RequestState_GotoScreenState3         ; 01
    dw RequestState_GotoScreenState3Submode  ; 02
    dw RequestState_StartSelectedMinigame ; 03
    dw RequestState_TitleSubstate4           ; 04
    dw RequestState_TitleSubstate1           ; 05
    dw RequestState_PasswordResultMenu       ; 06: password-derived destination.
    dw RequestState_GotoGameState4           ; 07
    dw RequestState_GotoGameState4Submode    ; 08
    dw RequestState_GotoGameState5           ; 09

RequestSavedMenuDestination::
; Resume the request selector and argument saved in wStateChangeParamLo/Hi.
    ld a, [wStateChangeParamLo]
    ld c, a
    ld a, [wStateChangeParamHi]
    ld b, a
    jr RequestStateChange_Menu

RequestState_ReturnToTitleMenu::
    xor a
    ldh [hGameState], a
    ld [wScreenSubstate], a
    ld a, c
    ld [wTitleMenuPhase], a
    ret


RequestState_GotoScreenState3::
    xor a
    ld [wMinigameMode], a
    ld a, c
    ld [wScreenSubstate], a
    ld a, $03
    ldh [hGameState], a
    ret


RequestState_GotoScreenState3Submode::
    xor a
    ld [wMinigameMode], a
    ld a, c
    ld [wBonusDestination], a
    ld a, $03
    ld [wScreenSubstate], a
    ldh [hGameState], a
    ld a, $3f
    ld [wFadeTransitionTimer], a
    ret


RequestState_StartSelectedMinigame::
    ld a, c
    inc a
    ld [wMinigameMode], a
    ld a, $03
    ldh [hGameState], a
    xor a
    ld [wSlideReuseLayout], a
    ret


RequestState_TitleSubstate4::
    ld a, $00
    ldh [hGameState], a
    ld a, $04
    ld [wScreenSubstate], a
    ret


RequestState_TitleSubstate1::
    ld a, $01
    ld [wScreenSubstate], a
    ret


RequestState_PasswordResultMenu::
IF DEF(DEBUG)
    ld a, $01
ELSE
    ld a, $04
ENDC
    ldh [hGameState], a
    ld a, c
    ld [wStageSceneIndex], a
    xor a
    ld [wScreenSubstate], a
    ret


RequestState_GotoGameState4::
    ld a, $04
    ldh [hGameState], a
    ld a, $01
    ld [wScreenSubstate], a
    ret


RequestState_GotoGameState4Submode::
    ld a, $04
    ldh [hGameState], a
    ld a, c
    and $07
    ld [wStageSceneIndex], a
    ld a, $03
    ld [wScreenSubstate], a
    ret


RequestState_GotoGameState5::
    ld a, $05
    ldh [hGameState], a
    ld a, c
    ld [wEndingMode], a
    ret



; Indexed screen data; scene-specific interpretation is documented at its consumer.

MenuBackgroundPatternPtrs::
    dw MenuBackgroundRowPattern_439a
    dw MenuBackgroundRowPattern_4393
    dw MenuBackgroundRowPattern_438c

MenuBackgroundRowPattern_438c::
    db $9e, $8e, $95, $96, $97, $98, $ff

MenuBackgroundRowPattern_4393::
    db $9d, $90, $93, $94, $00, $9c, $ff

MenuBackgroundRowPattern_439a::
    db $8f, $91, $92, $99, $9a, $9b, $ff

InitPasswordScreen::
; Initialize the kana grid and the two ten-byte password input rows.
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $900
    ld bc, $0260
    call BankedMemcpy
    ld a, BANK(LayoutRle_b01_7e7c)
    ld hl, LayoutRle_b01_7e7c
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound
    ld a, $1c
    call PlaySound_Queue3
    ld hl, SceneAnim_TitleIntro
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    ld hl, SceneAnim_TitleSecondary
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wSceneAnim1Timer], a
    ld [wVramQueue], a
    ld [wPasswordCursorCol], a
    ld [wPasswordInputIndex], a
    ld [wPasswordCursorRow], a
    ld [wPasswordErrorFlag], a
    ld [wPasswordRepeatHeld], a
    ld [wPasswordRepeatTimer], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $02
    ld [wScreenPaletteId], a
    xor a
    ld b, $14
    ld hl, wPasswordInputTopRow
    call FillBytesWithA
    ret


PasswordScreen_ConfirmAcceptedCode::
; Blink the accepted password while fading, then decode the matched entry into mode/stage flags.
    ld a, [wFadeTransitionTimer]
    or a
    jr z, PasswordAccepted_DispatchMatchedCode

    and $0f
    jr nz, PasswordAccepted_DrawCharactersAndFade

    ld a, [wFadeTransitionTimer]
    bit 4, a
    jr nz, PasswordAccepted_ClearBlinkRows

    ld de, wPasswordInputTopRow
    ld hl, _SCRN0 + $044
    ld bc, $0a02
    call QueueTilemapRect
    jr PasswordAccepted_DrawCharactersAndFade

PasswordAccepted_ClearBlinkRows::
    ld bc, _SCRN0 + $044
    ld d, $00
    ld e, $0a
    call QueueVramFill
    ld bc, _SCRN0 + $064
    ld d, $00
    ld e, $0a
    call QueueVramFill

PasswordAccepted_DrawCharactersAndFade::
    ld c, $0c
    ld b, $28
    ld d, $0c
    call DrawBank3MetaspriteNormal
    ld c, $8c
    ld b, $28
    ld d, $00
    call DrawBank3MetaspriteNormal
    call UpdateTransitionFade
    ret


PasswordAccepted_DispatchMatchedCode::
    ld a, [wPasswordMatchIndex]
    cp $0b
    jr nz, PasswordAccepted_CheckSpecialCodes

    ld bc, $0400
    ld de, $0000
    jp RequestStateChange_Menu


PasswordAccepted_CheckSpecialCodes::
    cp $07
    jr c, PasswordAccepted_SetAlternateStageFlags

    sub $07
    ld b, a
    ld a, $04
    ld [wAlternateModeFlags], a
    ld [wSpecialModeFlags], a
    ld a, b
    jr PasswordAccepted_RequestStageStart

PasswordAccepted_SetAlternateStageFlags::
    xor a
    ld [wSpecialModeFlags], a
    ld a, [wPasswordMatchIndex]
    inc a
    bit 2, a
    ld a, $04
    jr nz, PasswordAccepted_StoreAlternateFlags

    xor a

PasswordAccepted_StoreAlternateFlags::
    ld [wAlternateModeFlags], a
    ld a, [wPasswordMatchIndex]
    inc a
    and $03

PasswordAccepted_RequestStageStart::
    ld b, $06
    ld c, a
    ld d, $08
    ld a, c
    sla a
    ld e, a
    jp RequestStateChange_Menu


PasswordScreen_FadeToSavedDestination::
; Animate the password-screen characters until the fade finishes, then resume the saved request.
    ld c, $0c
    ld b, $28
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld c, $8c
    ld b, $28
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    jp z, RequestSavedMenuDestination

    ret


PasswordScreen_UpdateInput::
; Password grid input, cursor movement/repeat, selection, deletion and submission.
    ld c, $0c
    ld b, $28
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld c, $8c
    ld b, $28
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wPasswordErrorFlag]
    or a
    jr z, PasswordInput_DrawCursors

    call PasswordInput_DismissErrorMessage
    ret


PasswordInput_DrawCursors::
    ld hl, PasswordGridCursorMetasprite
    ld a, [wPasswordCursorCol]
    swap a
    rrca
    ld c, a
    ld a, [wPasswordCursorRow]
    swap a
    rrca
    ld b, a
    call DrawMetaspriteNormal
    ld hl, PasswordInputCursorMetasprite
    ld a, [wPasswordInputIndex]
    swap a
    rrca
    ld c, a
    ld b, $00
    call DrawMetaspriteNormal
    ldh a, [hJoyHeld]
    and $f0
    ld b, a
    ld a, [wPasswordRepeatHeld]
    and $f0
    cp b
    jr nz, PasswordInput_ResetRepeatDelay

    ld a, [wPasswordRepeatTimer]
    inc a
    jr nz, PasswordInput_TestRepeatDelay

    ld a, $30

PasswordInput_TestRepeatDelay::
    ld [wPasswordRepeatTimer], a
    cp $30
    jr c, PasswordInput_SuppressHeldMovement

    and $07
    jr z, PasswordInput_DecodeDpad

PasswordInput_SuppressHeldMovement::
    ld b, $00
    jr PasswordInput_DecodeDpad

PasswordInput_ResetRepeatDelay::
    xor a
    ld [wPasswordRepeatTimer], a

PasswordInput_DecodeDpad::
    ldh a, [hJoyHeld]
    ld [wPasswordRepeatHeld], a
    ld a, b
    ld b, $00
    ld c, $00
    bit 7, a
    jr z, PasswordInput_CheckUp

    ld c, $02

PasswordInput_CheckUp::
    bit 6, a
    jr z, PasswordInput_CheckLeft

    ld c, $fe

PasswordInput_CheckLeft::
    bit 5, a
    jr z, PasswordInput_CheckRight

    ld b, $ff

PasswordInput_CheckRight::
    bit 4, a
    jr z, PasswordInput_PlayCursorSound

    ld b, $01

PasswordInput_PlayCursorSound::
    ld a, b
    or c
    jr z, PasswordInput_AdvanceGridColumn

    ld a, $5d
    call PlaySound

PasswordInput_AdvanceGridColumn::
    ld a, [wPasswordCursorCol]
    add b
    bit 7, a
    jr z, PasswordInput_WrapGridColumnRight

    ld a, $10

PasswordInput_WrapGridColumnRight::
    cp $11
    jr c, PasswordInput_SkipColumnGap5

    xor a

PasswordInput_SkipColumnGap5::
    cp $05
    jr nz, PasswordInput_SkipColumnGap11

    add b

PasswordInput_SkipColumnGap11::
    cp $0b
    jr nz, PasswordInput_AdvanceGridRow

    add b

PasswordInput_AdvanceGridRow::
    ld [wPasswordCursorCol], a
    ld a, [wPasswordCursorRow]
    add c
    bit 7, a
    jr z, PasswordInput_WrapGridRowBottom

    ld a, $08

PasswordInput_WrapGridRowBottom::
    cp $09
    jr c, PasswordInput_StoreGridRowAndHandleButtons

    xor a

PasswordInput_StoreGridRowAndHandleButtons::
    ld [wPasswordCursorRow], a
    ldh a, [hJoyPressed]
    bit 0, a
    call nz, PasswordInput_SelectCell
    ldh a, [hJoyPressed]
    bit 1, a
    jr z, PasswordInput_CheckStartAndClampIndex

    ld a, [wPasswordInputIndex]
    dec a
    ld [wPasswordInputIndex], a

PasswordInput_CheckStartAndClampIndex::
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, SubmitPasswordCode
    ld a, [wPasswordInputIndex]
    bit 7, a
    jr z, PasswordInput_ClampIndexAtLastSlot

    ld a, $03
    ld [wScreenSubstate], a
    ld a, $48
    ld [wFadeTransitionTimer], a
    ret


PasswordInput_ClampIndexAtLastSlot::
    cp $0a
    jr c, PasswordInput_Return

    ld a, $09
    ld [wPasswordInputIndex], a

PasswordInput_Return::
    ret


PasswordInput_SelectCell:: ; Handle A press on the password grid and store selected kana/control.
    ld a, $40
    call PlaySound
    ld hl, wStageLayoutMap + $79
    ld a, [wPasswordCursorRow]
    inc a
    ld bc, $0014

PasswordSelect_FindGridRow::
    add hl, bc
    dec a
    jr nz, PasswordSelect_FindGridRow

    ld a, [wPasswordCursorCol]
    rst $38
    ld a, [hl]
    cp $b3
    jr nz, PasswordSelect_CheckAdvanceControl

    ld a, [wPasswordInputIndex]
    dec a
    ld [wPasswordInputIndex], a
    ret


PasswordSelect_CheckAdvanceControl::
    cp $b4
    jr nz, PasswordSelect_CheckSubmitControl

    ld a, [wPasswordInputIndex]
    inc a
    ld [wPasswordInputIndex], a
    ret


PasswordSelect_CheckSubmitControl::
    cp $b5
    jr nz, PasswordSelect_ReadKanaAndDiacritic

    call SubmitPasswordCode
    ret


PasswordSelect_ReadKanaAndDiacritic::
    ld d, [hl]
    ld bc, -$0014
    add hl, bc
    ld e, $45
    ld a, [hl]
    or a
    jr nz, PasswordSelect_CheckEmptyDiacriticTile

    ld e, $00

PasswordSelect_CheckEmptyDiacriticTile::
    cp $92
    jr nz, PasswordSelect_StoreKanaPair

    ld e, $00

PasswordSelect_StoreKanaPair::
    ld a, [wPasswordInputIndex]
    ld c, a
    ld b, $00
    ld hl, wPasswordInputTopRow
    add hl, bc
    ld [hl], e
    ld hl, wPasswordInputBottomRow
    add hl, bc
    ld [hl], d
    ld a, [wPasswordInputIndex]
    inc a
    ld [wPasswordInputIndex], a
    ld de, wPasswordInputTopRow
    ld hl, _SCRN0 + $044
    ld bc, $0a02
    call QueueTilemapRect
    ret


SubmitPasswordCode:: ; Compare password input against PasswordCodeTable and dispatch on success.

    xor a
    ld [wPasswordMatchIndex], a
    ld hl, PasswordCodeTable

SubmitPassword_NextCandidate::
    ld de, wPasswordInputTopRow
    ld c, $00
    push hl

SubmitPassword_CompareNextByte::
    inc c
    ld a, c
    cp $15
    jr nc, SubmitPassword_AcceptMatch

    ld a, [de]
    ld b, [hl]
    inc de
    inc hl
    cp b
    jr z, SubmitPassword_CompareNextByte

    pop hl
    ld bc, $0014
    add hl, bc
    ld a, [wPasswordMatchIndex]
    inc a
    ld [wPasswordMatchIndex], a
    cp $0c
    jr nz, SubmitPassword_NextCandidate

    ld de, PasswordErrorTiles
    ld hl, _SCRN0 + $004
    ld bc, $0a02
    call QueueTilemapRect
    ld a, $01
    ld [wPasswordErrorFlag], a
    ld a, $53
    call PlaySound
    ret


SubmitPassword_AcceptMatch::
    pop hl
    ld de, PasswordAcceptedTiles
    ld hl, _SCRN0 + $004
    ld bc, $0a02
    call QueueTilemapRect
    ld a, $02
    ld [wScreenSubstate], a
    ld a, $c0
    ld [wFadeTransitionTimer], a
    ret


PasswordInput_DismissErrorMessage:: ; Clear the password error message when A is pressed.
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld de, PasswordPromptTiles
    ld hl, _SCRN0 + $004
    ld bc, $0a02
    call QueueTilemapRect
    xor a
    ld [wPasswordErrorFlag], a
    ret


    db $43, $65, $57, $7a, $7e, $45, $5f, $45, $15, $32, $13, $7e, $7e, $42, $ff

PasswordGridCursorMetasprite::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $41, $07, $b2, $10, $80

PasswordInputCursorMetasprite::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $20, $20, $b1, $10, $80

PasswordPromptTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $9b, $92, $92, $92, $9a, $92, $92, $92, $9a, $92, $65, $57, $7a, $7e, $5f, $11
    db $37, $37, $2a, $7f

PasswordAcceptedTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $92, $92, $9a, $92, $92, $92, $92, $92, $92, $92, $11, $17, $59, $7d, $00, $56
    db $79, $7d, $00, $00

PasswordErrorTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $92, $92, $9a, $92, $92, $92, $9a, $92, $92, $92, $20, $44

PasswordErrorTilesTail::
; Part of the error text row. The dialogue lookup starts one password record before PasswordCodeTable.
    db $15, $44, $12, $44, $59, $7e, $00, $00

PasswordCodeLengths::
    db $07, $08, $0a, $06, $08, $08, $08, $08, $08, $07, $09, $05

PasswordCodeTable::
PasswordCode_WagamamaDanaa::
    db $00, $45, $00, $00, $45, $00, $00, $00, $00, $00, $3f, $15, $2f, $2f, $1f, $25
    db $10, $00, $00, $00

PasswordCode_TamanegiTabereru::
    db $00, $00, $00, $45, $00, $45, $00, $00, $00, $00, $1f, $2f, $28, $16, $1f, $2d
    db $37, $36, $00, $00

PasswordCode_Wahahahaha::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $2a, $2a, $2a, $2a, $3f
    db $2a, $2a, $2a, $2a

PasswordCode_Obenkidene::
    db $00, $45, $00, $00, $45, $00, $00, $00, $00, $00, $14, $2d, $42, $16, $23, $28
    db $00, $00, $00, $00

PasswordCode_KetsudakeSeijin::
    db $00, $00, $45, $00, $00, $00, $45, $00, $00, $00, $18, $21, $1f, $18, $1d, $11
    db $1b, $42, $00, $00

PasswordCode_ActionBeam::
    db $00, $00, $00, $00, $00, $45, $00, $00, $00, $00, $10, $17, $1b, $3e, $42, $2b
    db $11, $31, $00, $00

PasswordCode_ZousanZousan::
    db $45, $00, $00, $00, $45, $00, $00, $00, $00, $00, $1e, $14, $1a, $42, $1e, $14
    db $1a, $42, $00, $00

PasswordCode_ShinchanTurbo::
    db $00, $00, $00, $00, $00, $00, $00, $45, $00, $00, $1b, $42, $20, $3a, $42, $1f
    db $10, $2e, $00, $00

PasswordCode_BuriburiZaemon::
    db $45, $00, $45, $00, $45, $00, $00, $00, $00, $00, $2c, $35, $2c, $35, $1a, $13
    db $33, $42, $00, $00

PasswordCode_NasuNoOshinko::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $25, $1c, $29, $14, $1b, $42
    db $19, $00, $00, $00

PasswordCode_ArigatoGozamasu::
    db $00, $00, $45, $00, $45, $45, $00, $00, $00, $00, $10, $35, $15, $24, $19, $1a
    db $2f, $1c, $12, $00

PasswordCode_Kamishibai::
    db $00, $00, $00, $45, $00, $00, $00, $00, $00, $00, $15, $30, $1b, $2a, $11, $00
    db $00, $00, $00, $00

InitSceneTestMenu::
; Four test selectors with 8, 4, 2 and 3 choices.
    xor a
    ldh [hNeedsReset], a
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld [hl+], a

SceneTest_InitScreenAfterValueReset::
    ld [hl], a
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    call ClearBgMap0
    ld a, $02
    ld [wMessageFlags], a
    ld a, $0f
    call StartMessageFar
    xor a
    ld [wMenuCursorRow], a
    ld [wVramQueue], a
    ld a, $04
    ld [wScreenPaletteId], a
    xor a
    ld b, $04
    ld hl, wSceneTestValues

SceneTest_ClearSelectorValues::
    xor a
    ld [hl+], a
    dec b
    jr nz, SceneTest_ClearSelectorValues

    ret


UpdateSceneTestMenu::
; Move between the four selectors; A or START invokes the selected request.
    ld hl, wSceneTestValues
    ld a, [wMenuCursorRow]
    rst $38
    ld a, [hl]
    ld d, a
    push hl
    ldh a, [hJoyPressed]
    bit 4, a
    jr z, SceneTest_CheckDecrement

    inc d

SceneTest_CheckDecrement::
    ldh a, [hJoyPressed]
    bit 5, a
    jr z, SceneTest_CheckConfirm

    dec d

SceneTest_CheckConfirm::
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, SceneTest_DispatchConfirmedRow

    ld a, [wMenuCursorRow]
    ld hl, SceneTestRowValueLimits
    rst $38
    ld b, [hl]
    bit 7, d
    jr z, SceneTest_WrapValueAboveLimit

    ld d, b
    dec d

SceneTest_WrapValueAboveLimit::
    ld a, d
    cp b
    jr c, SceneTest_StoreAndDrawValue

    ld d, $00

SceneTest_StoreAndDrawValue::
    pop hl
    ld [hl], d
    ld a, d
    ld [wSceneTestLastEditedValue], a
    ld hl, _SCRN0 + $0ad
    ld a, [wMenuCursorRow]
    swap a
    sla a
    sla a
    rst $38
    ld a, d
    add $05
    call QueueTilemapByte
    ld a, $04
    ldh [hMenuCursorOptionCount], a
    ld hl, _SCRN0 + $0a5
    ld a, l
    ldh [hMenuCursorDestLo], a
    ld a, h
    ldh [hMenuCursorDestHi], a
    call UpdateMenuCursorAtCurrentPosition
    ret


SceneTest_DispatchConfirmedRow::
    pop hl
    ld a, [wMenuCursorRow]
    rst $00
SceneTestConfirmHandlers::
    dw SceneTest_OpenStageScene ; $00
    dw SceneTest_OpenPasswordResult ; $01
    dw SceneTest_OpenEnding ; $02
    dw SceneTest_StartBonusWithHealth ; $03

SceneTest_OpenPasswordResult::
; Request selector 6: password/result menu with row 1 argument.
    ld b, $06
    ld a, [wSceneTestValues + 1]


    ld c, a
    ld de, $0400
    jp RequestStateChange_Menu


SceneTest_OpenStageScene::
; Request selector 8: state 4 submode from row 0.
    ld a, [wSceneTestValues]
    ld c, a
    ld b, $08
    ld de, $0400
    jp RequestStateChange_Menu


SceneTest_OpenEnding::
; Request selector 9: state 5 submode from row 2.
    ld b, $09
    ld a, [wSceneTestValues + 2]
    ld c, a
    ld de, $0400
    jp RequestStateChange_Menu


SceneTest_StartBonusWithHealth::
; Set health to row 3 + 1 and request state 3.
    ld a, [wSceneTestValues + 3]
    inc a
    ldh [hPlayerHealth], a
    ld bc, $0100
    ld de, $0400
    jp RequestStateChange_Menu



SceneTestRowValueLimits::
; Counts for the four scene-test selectors.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $08, $04, $02, $03

InitMinigameScreen::
; State 3: mode 0 is the bonus stage; modes 1-3 are the selectable minigames.
    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [wMinigamePaused], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld a, [wMinigameMode]
    rst $00

MinigameInitHandlers::
    dw InitBonusStage ; $00
    dw InitMinigame1 ; $01
    dw InitMinigame2 ; $02
    dw InitMinigame3 ; $03

UpdateMinigameScreen::
; Render frozen OAM while paused; otherwise dispatch on wMinigameMode.
    ld a, [wMinigamePaused]
    or a
    jr nz, Minigame_RenderPausedFrame

    ld a, [wMinigameMode]
    rst $00

MinigameUpdateHandlers::
    dw UpdateBonusStage ; $00
    dw UpdateMinigame1 ; $01
    dw UpdateMinigame2 ; $02
    dw UpdateMinigame3 ; $03

Minigame_RenderPausedFrame::
    ldh a, [hPrevOamPos]
    ldh [hOamWritePos], a
    xor a
    ld [wSoundPriorityFlags], a
    ld a, $f9
    ld [wPaletteBGP], a
    ld a, $f4
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

    xor a
    ld [wMinigamePaused], a
    ld a, $80
    ld [wSoundPriorityFlags], a
    ld a, $5e
    call PlaySound_Queue1
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ret


Minigame_WaitForStart::
; SELECT cycles unlocked rounds; START begins the selected round.
    call HandleMinigameRoundSelection
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

Minigame_StartRound::
; Enter substate 1; $ff marks the countdown/introduction as not yet initialized.
    ld a, $01
    ld [wScreenSubstate], a
    ld a, $ff
    ld [wMinigamePhaseCounter], a
    ld a, $02
    ld [wScreenFrameCounter], a
    ret


AdvanceScreenRandomByte::
; Rotate the previous byte right and add DIV; return and save the result.
    ld a, [wScreenRandomByte]
    rrc a
    ld b, a
    ldh a, [rDIV]
    add b
    ld [wScreenRandomByte], a
    ret


ChooseScreenRandomThird::
; Map the screen random byte to 0, 1 or 2 using $55/$aa thresholds.
    call AdvanceScreenRandomByte
    ld b, $00
    cp $55
    jr c, ChooseScreenRandomThird_Return

    inc b
    cp $aa
    jr c, ChooseScreenRandomThird_Return

    inc b

ChooseScreenRandomThird_Return::
    ld a, b
    ret


TickMinigameCountdown::
; Every 50 calls decrement three decimal digits; return A=0 when they underflow.
    ld a, [wMinigamePhaseCounter]
    dec a
    ld [wMinigamePhaseCounter], a
    or a
    ret nz

    ld a, $32
    ld [wMinigamePhaseCounter], a
    ld hl, wMinigameTimerOnes
    ld b, $03

MinigameCountdown_BorrowDecimalDigit::
    dec [hl]
    ld a, [hl]
    bit 7, a
    jr z, MinigameCountdown_BuildDigitTiles

    ld a, $09
    ld [hl-], a
    dec b
    jr nz, MinigameCountdown_BorrowDecimalDigit

    xor a
    ld a, $00
    ret


MinigameCountdown_BuildDigitTiles::
    ld hl, wMinigameTimerHundreds
    ld a, [hl+]
    add $04
    ldh [hMinigameTimerTiles], a
    ld a, [hl+]
    add $04
    ldh [hMinigameTimerTiles + 1], a
    ld a, [hl+]
    add $04
    ldh [hMinigameTimerTiles + 2], a
    ld hl, hMinigameTimerTiles
    ld a, [hl]
    cp $04
    jr nz, MinigameCountdown_QueueDigits

    xor a
    ld [hl+], a
    ld a, [hl]
    cp $04
    jr nz, MinigameCountdown_QueueDigits

    xor a
    ld [hl], a

MinigameCountdown_QueueDigits::
    ld de, hMinigameTimerTiles
    ld hl, _SCRN0 + $228
    ld bc, $0301
    call QueueTilemapRect
    ret


AdvanceMinigameRoundOrExit::
; Exit at round 10, a saved return request, or nonzero result; otherwise update the unlocked round at HL.
    xor a
    ld [wScreenPhaseCounter], a
    ld a, [wMinigameRound]
    cp $0a
    jp z, RequestSavedMenuDestination

    ld a, [wStateChangeParamHi]
    or a
    jp nz, RequestSavedMenuDestination

    ld a, [wMinigameResultFlag]
    or a
    jp nz, RequestSavedMenuDestination

    ld a, [wMinigameRound]
    inc a
    ld [wMinigameRound], a
    ld b, [hl]
    cp b
    jr c, MinigameRound_StartNext

    ld [hl], a

MinigameRound_StartNext::
    jp Minigame_StartRound


ClearSgbTilemapStencil16x7::
; SGB only: seven little-endian 16-bit masks; clear tiles selected by each mask, row stride 32.
    ld a, [wSgbEnabled]
    or a
    ret z

    ld b, $07

SgbTilemapStencil_NextMaskRow::
    push de
    ld a, [de]
    ld c, a
    inc de
    ld a, [de]
    ld e, c
    ld d, a
    ld c, $10

SgbTilemapStencil_NextBit::
    sla e
    rl d
    jr nc, SgbTilemapStencil_AdvanceTile

    ld [hl], $00

SgbTilemapStencil_AdvanceTile::
    inc hl
    dec c
    jr nz, SgbTilemapStencil_NextBit

    ld a, $10
    rst $38
    pop de
    inc de
    inc de
    dec b
    jr nz, SgbTilemapStencil_NextMaskRow

    ret


PauseMinigame::
; Latch pause and queue sound $5e.
    ld a, $01
    ld [wMinigamePaused], a
    ld a, $5e
    call PlaySound_Queue1
    ret


HandleMinigameRoundSelection::
; SELECT cycles from round 1 through the highest unlocked round, capped at 10.
    ldh a, [hJoyPressed]
    and $04
    ret z

    ld a, [wStateChangeParamHi]
    or a
    ret nz

    ld a, [wMinigameRound]
    ld b, a
    ldh a, [hJoyPressed]
    bit 2, a
    jr z, MinigameRoundSelection_CapAtTen

    inc b
    ld a, [wMinigameMode]
    dec a
    ld hl, wMinigameUnlockedRounds
    rst $38
    ld a, [hl]
    cp b
    jr nc, MinigameRoundSelection_CapAtTen

    ld b, $01

MinigameRoundSelection_CapAtTen::
    ld a, b
    cp $0b
    jr c, MinigameRoundSelection_SelectHudPosition

    ld b, $01

MinigameRoundSelection_SelectHudPosition::
    ld hl, _SCRN0 + $230
    ld a, [wMinigameMode]
    cp $03
    jr nz, MinigameRoundSelection_StoreAndDraw

    ld hl, _SCRN0 + $3f0

MinigameRoundSelection_StoreAndDraw::
    ld a, b
    ld [wMinigameRound], a
    add $04
    cp $0e
    jr nz, MinigameRoundSelection_QueueRoundTile

    ld a, $c5

MinigameRoundSelection_QueueRoundTile::
    call QueueTilemapByte
    ret


InitBonusStage::
; Mode 0 initialization.
    ld a, [wScreenSubstate]
    or a
    jr nz, Bonus_InitPaletteAndTiles

    xor a
    ld [wBonusDestination], a
    ld a, $01
    ld [wBonusWalkDeltaX], a
    ld a, $e8
    ld [wBonusActorX], a
    ld a, BANK(Gfx_b05_5701)
    ld hl, Gfx_b05_5701
    ld de, _VRAM + $d00
    ld bc, $0300
    call BankedMemcpy

Bonus_InitPaletteAndTiles::
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld a, $d0
    ld [hl+], a
    ld a, $e4
    ld [hl], a
    ld a, [wStateChangeParamHi]
    ld [wBonusReturnRequest], a
    call InitGameplayHudAndWindow
    ld a, BANK(GfxRle_b06_5334)
    ld hl, GfxRle_b06_5334
    ld de, _VRAM + $130
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_53ec)
    ld hl, GfxRle_b06_53ec
    ld de, _VRAM + $300
    call LoadMaskedGfx
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $800
    ld bc, $0200
    call BankedMemcpy
    ld a, BANK(GfxRle_b06_5556)
    ld hl, GfxRle_b06_5556
    ld de, _VRAM + $a00
    call LoadMaskedGfx
    ld a, [wScreenSubstate]
    cp $03
    jr z, Bonus_InitInstructionBackground

    ld a, $e3
    ld [wLCDCShadow], a
    ld hl, LayoutRle_b06_5787
    ld de, wStageLayoutMap
    ld bc, $0168
    ld a, BANK(LayoutRle_b06_5787)
    call BankedMemcpy_RLEFF
    ld hl, _SCRN0
    ld bc, $1412
    ld de, wStageLayoutMap
    call CopyTilemapRectToVram
    ld a, $03
    ld [wScreenPaletteId], a
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    jr Bonus_InitActorAndMessageState

Bonus_InitInstructionBackground::
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hTileStreamWritePos], a
    call BuildMenuPatternBackground
    ld a, $8f
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $023
    ld bc, $0c0d
    call DrawTilemapBox
    ld a, [wSgbEnabled]
    or a
    jr z, Bonus_SetInstructionPalette

    ld hl, wStageLayoutMap
    ld bc, $0010
    call bzero
    ld hl, _SCRN0 + $1a0
    ld bc, $0303
    ld de, wStageLayoutMap
    call CopyTilemapRectToVram

Bonus_SetInstructionPalette::
    ld a, $14
    ld [wScreenPaletteId], a

Bonus_InitActorAndMessageState::
    ld hl, SceneAnim_Scene3Mode0Primary
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wMessageState], a
    ld [wScreenFrameCounter], a
    ld [wScreenPhaseCounter], a
    ld [wBonusRewardChoiceDelay], a
    ld a, [wScreenSubstate]
    cp $03
    jr nz, Bonus_DrawInitialRoundNumbers

    ld a, $82
    ld [wMessageFlags], a
    ld a, [wBonusDestination]
    add $09
    cp $0c
    jr c, Bonus_PlayInstructionMusic

    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, [wBonusDestination]
    sub $03
    add $5a
    jr Bonus_StartInstructionMessage

Bonus_PlayInstructionMusic::
    push af
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    pop af

Bonus_StartInstructionMessage::
    call StartMessageFar
    ld hl, SceneAnim_Scene3Mode0State1
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    ld a, $40
    ld [wScreenFrameCounter], a
    ret


Bonus_DrawInitialRoundNumbers::
    call Bonus_DrawRoundNumbers
    ld a, [wScreenSubstate]
    cp $06
    ret z

Bonus_ShowNoHealthMessage::
    ldh a, [hPlayerHealth]
    or a
    ret nz

    ld a, $80
    ld [wMessageFlags], a
    ld a, $0c
    call StartMessageFar
    ld hl, SceneAnim_Scene3Mode0State2
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $01
    ld [wBonusWalkDeltaX], a
    xor a
    ld [wScreenSubstate], a
    ret


UpdateBonusStage::
; Mode 0 update, dispatched by wScreenSubstate.
    ld a, [wScreenSubstate]
    and $07
    rst $00

BonusStageStateHandlers::
    dw Bonus_WalkBetweenStations ; $00
    dw Bonus_WaitAtStation ; $01
    dw Bonus_EnterMinigameAfterAnimation ; $02
    dw Bonus_ShowInstructionsOrPasswordHint ; $03
    dw Bonus_LeaveAfterFade ; $04
    dw Bonus_LaunchAfterInstructionFade ; $05
    dw Bonus_ShowResultAndApplyReward ; $06
    dw Bonus_SelectRewardByRoundTier ; $07

Bonus_WalkBetweenStations::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wBonusWalkDeltaX]
    ld b, a
    ldh a, [hPlayerHealth]
    or a
    jr nz, Bonus_MoveActor

    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $03
    jr nz, Bonus_MoveActor

    ld b, $00

Bonus_MoveActor::
    ld a, [wBonusActorX]
    add b
    ld [wBonusActorX], a
    ld c, a
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld hl, BonusDestinationExitX
    ld b, $05

Bonus_CheckNextDestinationX::
; Scan the five destination positions in reverse order.
    ld a, [wBonusActorX]
    cp [hl]
    jr z, Bonus_HandleReachedDestination

    dec hl
    dec b
    jr nz, Bonus_CheckNextDestinationX

    ret


Bonus_HandleReachedDestination::
    dec b
    ld a, b
    cp $04
    jr z, Bonus_BeginExitFade

    ldh a, [hPlayerHealth]
    or a
    ret z

    ld a, b
    ld [wBonusDestination], a
    ld a, $01
    ld [wScreenSubstate], a
    ld a, $10
    ld [wScreenFrameCounter], a
    ld a, $80
    ld [wMessageFlags], a
    ld a, b
    inc a
    call StartMessageFar
    ret


Bonus_BeginExitFade::
    ld a, $3f
    ld [wFadeTransitionTimer], a
    ld a, $04
    ld [wScreenSubstate], a
    ret


Bonus_LeaveAfterFade::
    call Bonus_DrawMovingBorderSprites
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0400
    ld de, $0000
    ld a, [wBonusReturnRequest]
    cp $04
    jp z, RequestStateChange_Menu

    ld a, [wStageSceneIndex]
    ld e, a
    srl a
    ld c, a
    ld b, $06
    ld d, $08
    jp RequestStateChange_Menu


    ret


Bonus_WaitAtStation::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wBonusActorX]
    ld c, a
    ld b, $7f
    ld d, $0e
    call DrawBank3MetaspriteNormal
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, Bonus_CheckResumeWalking

    ld a, [wMessageState]
    or a
    jr nz, Bonus_CheckResumeWalking

    ld a, [wBonusDestination]
    cp $03
    jr z, Bonus_CheckResumeWalking

    ld hl, SceneAnim_Scene3Mode0Secondary
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wMessageState], a
    ld a, $40
    ld [wFadeTransitionTimer], a
    ld a, $02
    ld [wScreenSubstate], a
    ldh a, [hPlayerHealth]
    cp $04
    ret nc

    ldh a, [hPlayerHealth]
    dec a
    ldh [hPlayerHealth], a
    call QueueHealthHudAfterDamage
    ret


Bonus_CheckResumeWalking::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    bit 7, a
    ret z

    xor a
    ld [wScreenFrameCounter], a
    ldh a, [hJoyHeld]
    bit 4, a
    call nz, Bonus_StartWalkingRight
    ldh a, [hJoyHeld]
    bit 5, a
    call nz, Bonus_StartWalkingLeft
    ret


Bonus_EnterMinigameAfterAnimation::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wSceneAnim0Timer]
    cp $01
    jr nz, Bonus_PlayEntryAnimation

    ld hl, wSceneAnim0PtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    dec hl
    ld a, [hl]
    cp $12
    jr nz, Bonus_PlayEntryAnimation

    ld a, $54
    call PlaySound

Bonus_PlayEntryAnimation::
    ld a, [wBonusActorX]
    ld c, a
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    or a
    ret z

    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld hl, wBonusMinigameRounds
    ld a, [wBonusDestination]
    rst $38
    ld a, [hl]
    ld [wMinigameRound], a
    ld hl, wBonusInstructionPending
    ld a, [wBonusDestination]
    rst $38
    ld b, $03
    ld a, [wBonusDestination]
    ld c, a
    ld de, $0106
    ld a, [hl]
    or a
    jp z, RequestStateChange_Menu

    xor a
    ld [hl], a
    ld b, $02
    ld a, [wBonusDestination]
    ld c, a
    ld de, $0106
    jp RequestStateChange_Menu


Bonus_StartWalkingRight::
    ld a, $01
    ld [wBonusWalkDeltaX], a
    ld hl, SceneAnim_Scene3Mode0Primary
    jr Bonus_SetWalkingAnimation

Bonus_StartWalkingLeft::
    ld a, [wBonusDestination]
    or a
    ret z

    ld a, $ff
    ld [wBonusWalkDeltaX], a
    ld hl, SceneAnim_Scene3Mode0Variant

Bonus_SetWalkingAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenSubstate], a
    call Bonus_ClearMessageBox
    ret


Bonus_ClearMessageBox::
    xor a
    ld [wMessageState], a
    ld d, $82
    ld bc, _SCRN0 + $083

Bonus_ClearNextMessageRow::
    ld e, $0e
    push bc
    call QueueVramFill
    pop bc
    ld d, $00
    ld a, $20
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, c
    cp $03
    jr nz, Bonus_ClearNextMessageRow

    ret


Bonus_DrawMovingBorderSprites::
    ld a, [wBonusBlinkCounter]
    inc a
    ld [wBonusBlinkCounter], a
    ld c, $00
    and $10
    jr z, Bonus_DrawHorizontalBorderSprites

    ld c, $08

Bonus_DrawHorizontalBorderSprites::
    ld b, $00
    push bc
    ld hl, BonusHorizontalBorderMetasprite
    call DrawMetaspriteNormal
    pop bc
    ld a, c
    xor $08
    ld c, a
    ld b, $18
    ld hl, BonusHorizontalBorderMetasprite
    call DrawMetaspriteNormal
    ld a, [wBonusBlinkCounter]
    ld b, $00
    and $10
    jr nz, Bonus_DrawVerticalBorderSprites

    ld b, $08

Bonus_DrawVerticalBorderSprites::
    ld c, $00
    push bc
    ld hl, BonusVerticalBorderMetasprite
    call DrawMetaspriteNormal
    pop bc
    ld a, b
    xor $08
    ld b, a
    ld c, $78
    ld hl, BonusVerticalBorderMetasprite
    call DrawMetaspriteNormal
    ret


Bonus_ShowInstructionsOrPasswordHint::
    ld c, $0c
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFadeWithLateSgbPalSet
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld a, [wBonusDestination]
    cp $03
    jr nc, Bonus_WaitBeforePasswordHintConfirm

    ld a, [wBonusBlinkCounter]
    inc a
    ld [wBonusBlinkCounter], a
    and $0f
    jr nz, Bonus_CheckInstructionConfirm

    ld a, [wBonusBlinkCounter]
    and $10
    ld a, $81
    jr nz, Bonus_DrawInstructionAdvanceMarker

    xor a

Bonus_DrawInstructionAdvanceMarker::
    ld hl, _SCRN0 + $1cf
    call QueueTilemapByte

Bonus_CheckInstructionConfirm::
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld a, $3f
    ld [wFadeTransitionTimer], a
    ld a, $05
    ld [wScreenSubstate], a
    xor a
    ld hl, _SCRN0 + $1cf
    call QueueTilemapByte
    ret


Bonus_WaitBeforePasswordHintConfirm::
    ld a, [wBonusDestination]
    cp $05
    ret z

    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    cp $d0
    ret c

    ld a, $e0
    ld [wScreenPhaseCounter], a
    jr Bonus_CheckInstructionConfirm

Bonus_LaunchAfterInstructionFade::
    ld c, $0c
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld b, $03
    ld a, [wBonusDestination]
    cp $03
    jp nc, RequestSavedMenuDestination

    ld c, a
    ld a, [wStateChangeParamLo]
    ld e, a
    ld a, [wStateChangeParamHi]
    ld d, a
    jp RequestStateChange_Menu


Bonus_ShowResultAndApplyReward::
    call UpdateMessageFar
    call Bonus_DrawMovingBorderSprites
    ld a, [wBonusActorX]
    ld c, a
    ld b, $7f
    ld d, $14
    call DrawBank3MetaspriteNormal
    ld a, [wBonusDestination]
    cp $01
    jp nz, Bonus_UpdateResultMessageTimer

    ld a, [wMinigameResultFlag]
    or a
    jr nz, Bonus_UpdateResultMessageTimer

    ld a, [wScreenFrameCounter]
    or a
    jr nz, Bonus_UpdateResultMessageTimer

    ld a, [wBonusRewardChoiceDelay]
    cp $01
    jr nz, Bonus_IncrementRewardChoiceDelay

    ld hl, _SCRN0 + $0a7
    ld bc, $0501 ; width/height constant, not a ROM0 QueueVramFill pointer
    ld de, BonusFormRewardHeadingTiles
    call QueueTilemapRect

Bonus_IncrementRewardChoiceDelay::
    ld a, [wBonusRewardChoiceDelay]
    inc a
    cp $40
    jr c, Bonus_StoreRewardChoiceDelay

    ld a, $60

Bonus_StoreRewardChoiceDelay::
    ld [wBonusRewardChoiceDelay], a
    ld a, [wScreenPhaseCounter]
    bit 7, a
    jr nz, Bonus_WaitAfterFormRewardChoice

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, Bonus_CycleFormRewardPreview

    ld a, [wBonusRewardChoiceDelay]
    cp $60
    ret nz

    ld a, $80
    ld [wScreenPhaseCounter], a
    ret


Bonus_CycleFormRewardPreview::
    ld a, [wScreenPhaseCounter]
    inc a
    cp $0c
    jr c, Bonus_UpdateFormPreviewTilemap

    xor a

Bonus_UpdateFormPreviewTilemap::
    ld [wScreenPhaseCounter], a
    and $03
    ret nz

    ld a, [wScreenPhaseCounter]
    srl a
    srl a
    add $0b
    ld [wMsgSubstitutionId], a
    xor a
    ld a, [wMessageFlags]
    ld a, $68
    call StartMessageFar
    ld bc, _SCRN0 + $0c6
    ld de, $0004
    call QueueVramFill
    ret


Bonus_WaitAfterFormRewardChoice::
    inc a
    ld [wScreenPhaseCounter], a
    cp $e0
    ret nz

    ld bc, _SCRN0 + $0c6
    ld de, $0004
    call QueueVramFill

Bonus_UpdateResultMessageTimer::
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $01
    jr nz, Bonus_CheckRewardFrame

    ld a, $80
    ld [wMessageFlags], a
    ld a, [wMinigameResultFlag]
    or a
    ld a, $08
    jr nz, Bonus_StartResultMessage

    ld a, [wBonusDestination]
    ld hl, wBonusMinigameRounds
    rst $38
    inc [hl]
    ld a, [hl]
    cp $0b
    jr c, Bonus_SelectSuccessMessage

    ld [hl], $0a

Bonus_SelectSuccessMessage::
    ld a, [wBonusDestination]
    add $05

Bonus_StartResultMessage::
    call StartMessageFar
    ld a, [wBonusDestination]
    cp $01
    ret nz

    ld a, [wMinigameResultFlag]
    or a
    ret nz

    ld a, $46
    call PlaySound_Queue1
    ret


Bonus_CheckRewardFrame::
    ld a, [wScreenFrameCounter]
    cp $60
    jr nz, Bonus_ReturnToStationChoice

    ld a, [wMinigameResultFlag]
    or a
    jr nz, Bonus_QueueUpdatedRoundNumber

    ld a, [wBonusDestination]
    or a
    jr nz, Bonus_ApplyFormOrLifeReward

    ld a, $0f
    call AddBonusCounter
    jr Bonus_QueueUpdatedRoundNumber

Bonus_ApplyFormOrLifeReward::
    dec a
    jr nz, Bonus_ApplyExtraLifeReward

    ld a, [wMsgSubstitutionId]
    sub $0a
    ldh [hPlayerForm], a
    call QueuePlayerFormHudIcon
    jr Bonus_QueueUpdatedRoundNumber

Bonus_ApplyExtraLifeReward::
    call AddExtraLife
    ld a, $46
    call PlaySound_Queue1

Bonus_QueueUpdatedRoundNumber::
    ld a, [wBonusDestination]
    ld hl, wBonusMinigameRounds
    rst $38
    ld a, [wBonusDestination]
    ld d, a
    ld a, [hl]
    cp $0a
    jr c, Bonus_EncodeRoundNumberTile

    ld a, $c1

Bonus_EncodeRoundNumberTile::
    add $04
    inc d
    ld bc, $0005
    ld hl, _SCRN0 + $160

Bonus_AdvanceToRoundNumberColumn::
    add hl, bc
    dec d
    jr nz, Bonus_AdvanceToRoundNumberColumn

    call QueueTilemapByte
    call Bonus_ClearMessageBox
    ld a, $80
    ld [wMessageFlags], a
    ld a, [wBonusDestination]
    inc a
    call StartMessageFar

Bonus_ReturnToStationChoice::
    ld a, [wScreenFrameCounter]
    cp $60
    ret c

    ld a, $01
    ld [wScreenSubstate], a
    ld [wScreenFrameCounter], a
    jp Bonus_ShowNoHealthMessage


Bonus_DrawRoundNumbers::
    ld b, $03
    ld hl, _SCRN0 + $165
    ld de, wBonusMinigameRounds

Bonus_ReadNextRoundNumber::
    ld a, [de]
    inc de
    cp $0a
    jr c, Bonus_StoreRoundNumberTile

    ld a, $c1

Bonus_StoreRoundNumberTile::
    add $04
    ld [hl], a
    push bc
    ld bc, $0005
    add hl, bc
    pop bc
    dec b
    jr nz, Bonus_ReadNextRoundNumber

    ret


Bonus_SelectRewardByRoundTier::
    ld a, [wBonusMinigameRounds + 1]
    ld c, $0b
    ld d, $02
    cp $04
    jr c, Bonus_StoreRoundRewardSelection

    ld c, $0c
    ld d, $03
    cp $07
    jr c, Bonus_StoreRoundRewardSelection

    ld c, $0d
    ld d, $01

Bonus_StoreRoundRewardSelection::
; C selects the displayed form name. The downstream use of D saved to HRAM is unconfirmed.
    ld a, d
    ldh [hSharedScratch + $0a], a
    ld a, c
    ld [wMsgSubstitutionId], a
    ret


BonusDestinationXPositions::
; Three minigames, followed by the exit marker and right screen boundary.
    db $1e, $46, $6e, $8e

BonusDestinationExitX::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $b0

BonusHorizontalBorderMetasprite::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $10, $af, $10, $00, $20, $af, $10, $00, $30, $af, $10, $00, $40, $af, $10
    db $00, $50, $af, $10, $00, $60, $af, $10, $00, $70, $af, $10, $00, $80, $af, $10
    db $80

BonusVerticalBorderMetasprite::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $08, $10, $af, $10, $80

BonusFormRewardHeadingTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $c7, $c8, $c9, $ca, $7d

InitMinigame3::
; Mode 3 initialization.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ld a, $70
    ldh [hSCY], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    xor a
    ld [wSlideEffectActive], a
    ld [wSlideLandingFrame], a
    ld a, $0c
    ld [wScreenPaletteId], a
    ld a, [wSlideReuseLayout]
    or a
    jr nz, Slide_SelectInitialBgRowCount

    ld a, BANK(GfxRle_b05_7481)
    ld hl, GfxRle_b05_7481
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b04_79da)
    ld hl, LayoutRle_b04_79da
    ld de, wStageLayoutMap
    ld bc, $1000
    call BankedMemcpy_RLEFF
    xor a
    ld [wSlidePlayerControl], a

Slide_SelectInitialBgRowCount::
    ld b, $1e
    ld a, [wSlidePlayerControl]
    or a
    jr z, Slide_InitBgCopy

    ld b, $20

Slide_InitBgCopy::
    ld hl, wStageLayoutMap
    ld de, _SCRN0

Slide_CopyNextBgRow::
    ld c, $20

Slide_CopyBgRowByte::
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, Slide_CopyBgRowByte

    ld a, $60
    rst $38
    dec b
    jr nz, Slide_CopyNextBgRow

    ld a, [wSlidePlayerControl]
    or a
    jr nz, Slide_SelectInitialPhase

    ld b, $40
    xor a

Slide_ClearBottomBgRows::
    ld [de], a
    inc de
    dec b
    jr nz, Slide_ClearBottomBgRows

Slide_SelectInitialPhase::
    ld a, [wSlidePlayerControl]
    or a
    jp nz, Slide_InitApproachMotion

    ld a, [wSlideReuseLayout]
    or a
    jp nz, Slide_BeginRoundBanner

    ld a, $02
    ld [wMessageFlags], a
    ld a, $4d
    call StartMessageFar
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenSubstate], a
    ret


UpdateMinigame3::
; Mode 3 update.
    ld a, [wScreenSubstate]
    cp $02
    jr c, Slide_DispatchPhase

    ldh a, [hJoyPressed]
    bit 3, a
    jr z, Slide_DispatchPhase

    ld a, [wSlidePlayerControl]
    or a
    jr nz, Slide_PausePlayerRound

    ld a, $01
    ld [wSlidePlayerControl], a
    ldh [hNeedsReset], a
    ld [wSlideReuseLayout], a
    ret


Slide_PausePlayerRound::
    call PauseMinigame

Slide_DispatchPhase::
    ld a, [wScreenSubstate]
    rst $00

Minigame3StateHandlers::
    dw Slide_WaitForStart ; $00
    dw Slide_UpdateRoundBanner ; $01
    dw Slide_UpdateApproachOrLanding ; $02
    dw Slide_UpdateAirborne ; $03
    dw Slide_UpdateClearOrDemoResult ; $04
    dw Slide_WaitForMissExit ; $05
    dw Slide_UpdatePlatformBounce ; $06

Slide_WaitForStart::
    call HandleMinigameRoundSelection
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

Slide_BeginRoundBanner::
    ld a, $01
    ld [wScreenSubstate], a
    ld a, $60
    ld [wScreenFrameCounter], a
    ld bc, _SCRN0 + $3c0
    ld de, $0014
    call QueueVramFill
    ld bc, _SCRN0 + $3e0
    ld de, $0014
    call QueueVramFill
    ld a, [wMinigameRound]
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $4c
    call StartMessageFar
    ret


Slide_UpdateRoundBanner::
    call UpdateMessageFar
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ret nz

    ld de, wStageLayoutMap + $f00
    ld hl, _SCRN0 + $3c0
    ld bc, $2001
    call QueueTilemapRect
    ld de, wStageLayoutMap + $f80
    ld hl, _SCRN0 + $3e0
    ld bc, $2001
    call QueueTilemapRect

Slide_InitApproachMotion::
    ld a, $02
    ld [wScreenSubstate], a
    xor a
    ld [wScreenFrameCounter], a
    ld hl, wSlideWorldXSubpixel
    ld [hl], $00
    inc hl
    ld [hl], $28
    inc hl
    ld [hl], $00
    xor a
    ld hl, wSlideWorldYSubpixel
    ld [hl], $00
    inc hl
    ld [hl], $90
    inc hl
    ld [hl], $00
    ld a, $01
    ld [wMinigameResultFlag], a
    call InitSound
    ld a, $30
    call PlaySound_Queue3
    ret


Slide_UpdateApproachOrLanding::
    ld d, $9c
    ld a, [wSlideWorldXHi]
    or a
    jp nz, Slide_UpdateGroundArrival

    ld a, [wSlideWorldXLo]
    cp $2a
    jp nc, Slide_UpdateRampApproach

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $e0
    jr nc, Slide_StartApproachMotion

    xor a
    ld [wSlideVelocityXLo], a
    ld [wSlideVelocityXHi], a
    ld [wSlideVelocityYLo], a
    ld [wSlideVelocityYHi], a
    jp Slide_DrawApproachFrame


Slide_StartApproachMotion::
    ld hl, $0080
    ld a, l
    ld [wSlideVelocityXLo], a
    ld a, h
    ld [wSlideVelocityXHi], a
    xor a
    ld [wSlideVelocityYLo], a
    ld [wSlideVelocityYHi], a
    jp Slide_DrawApproachFrame


Slide_UpdateRampApproach::
    ld d, $9e
    cp $80
    jr nc, Slide_CheckRampEdge

    ld hl, wSlideVelocityXLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $0003
    add hl, bc
    ld a, l
    ld [wSlideVelocityXLo], a
    ld a, h
    ld [wSlideVelocityXHi], a
    ld a, l
    ld [wSlideVelocityYLo], a
    ld a, h
    ld [wSlideVelocityYHi], a
    jp Slide_DrawApproachFrame


Slide_CheckRampEdge::
    cp $b0
    jp nc, Slide_UpdateGroundArrival

    ld a, [wSlideEffectActive]
    or a
    jr nz, Slide_WaitForLaunchInput

    ld hl, wSlideEffectXLo
    ld a, $98
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $b0
    ld [hl+], a
    ld hl, SceneAnim_7a53
    ld a, [wSlidePlayerControl]
    or a
    jr z, Slide_StartRampEffect

    ld hl, SceneAnim_7a58

Slide_StartRampEffect::
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim1Timer], a
    ld a, $01
    ld [wSlideEffectActive], a

Slide_WaitForLaunchInput::
    xor a
    ld [wSlideResultDelay], a
    ld [wSlideVelocityYLo], a
    ld [wSlideVelocityYHi], a
    ld a, $e4
    ld [wSlideWorldYLo], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wSlidePlayerControl]
    and b
    jp z, Slide_DrawApproachFrame

Slide_LaunchFromRamp::
    ld a, [wMinigameRound]
    dec a
    ld hl, SlidePlatformRoundPointers
    rst $20
    ld a, l
    ld [wSlidePlatformPtrLo], a
    ld a, h
    ld [wSlidePlatformPtrHi], a
    ld a, $42
    call PlaySound
    ld a, $03
    ld [wScreenSubstate], a
    ld hl, $0180
    ld a, [wMinigameRound]
    dec a
    ld b, a
    ld a, [wSlidePlayerControl]
    or b
    jr nz, Slide_StoreLaunchVelocity

    ld hl, $01c0

Slide_StoreLaunchVelocity::
    ld a, l
    ld [wSlideVelocityXLo], a
    ld a, h
    ld [wSlideVelocityXHi], a
    ld hl, -$0280
    ld a, l
    ld [wSlideVelocityYLo], a
    ld a, h
    ld [wSlideVelocityYHi], a
    ld d, $9e
    jp Slide_DrawApproachFrame


Slide_UpdateGroundArrival::
    ld a, [wSlidePlayerControl]
    or a
    jr z, Slide_LaunchFromRamp

    ld d, $9e
    ld a, [wSlideWorldYLo]
    cp $f0
    jr c, Slide_AccelerateGroundFall

    ld d, $a0
    ld a, [wSlideLandingFrame]
    inc a
    ld [wSlideLandingFrame], a
    bit 3, a
    jr nz, Slide_BrakeAfterGroundArrival

    ld d, $a1

Slide_BrakeAfterGroundArrival::
    ld a, $f1
    ld [wSlideWorldYLo], a
    xor a
    ld [wSlideVelocityYLo], a
    ld [wSlideVelocityYHi], a
    ld a, [wSlideVelocityXHi]
    bit 7, a
    jr nz, Slide_BrakeLeftwardMotion

    ld a, [wSlideVelocityXLo]
    sub $03
    ld [wSlideVelocityXLo], a
    ld a, [wSlideVelocityXHi]
    sbc $00
    ld [wSlideVelocityXHi], a
    jr nc, Slide_DrawApproachFrame

    xor a
    ld [wSlideVelocityXHi], a
    ld a, $05
    ld [wScreenSubstate], a
    push de
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop de
    jr Slide_DrawApproachFrame

Slide_BrakeLeftwardMotion::
    ld a, [wSlideVelocityXLo]
    add $03
    ld [wSlideVelocityXLo], a
    ld a, [wSlideVelocityXHi]
    adc $00
    ld [wSlideVelocityXHi], a
    jr nc, Slide_DrawApproachFrame

    ld a, $ff
    ld [wSlideVelocityXHi], a
    ld a, $05
    ld [wScreenSubstate], a
    push de
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop de
    jr Slide_DrawApproachFrame

Slide_AccelerateGroundFall::
    ld a, [wSlideVelocityYLo]
    add $04
    ld [wSlideVelocityYLo], a
    ld a, [wSlideVelocityYHi]
    adc $00
    ld [wSlideVelocityYHi], a

Slide_DrawApproachFrame::
    ld a, d
    ldh [hTileStreamWritePos], a
    call Slide_MoveAndDrawActor
    call Slide_QueueAheadBackgroundColumn
    call Slide_DrawRoundPlatforms
    ret


Slide_WaitForMissExit::
    ld a, $9f
    ldh [hTileStreamWritePos], a
    call Slide_MoveAndDrawActor
    call Slide_DrawRoundPlatforms
    ld a, [wSlideResultDelay]
    inc a
    ld [wSlideResultDelay], a
    cp $90
    ret c

    ld a, $a0
    ld [wSlideResultDelay], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    jp RequestSavedMenuDestination


Slide_UpdateAirborne::
    ld a, [wSlideVelocityYLo]
    add $0a
    ld [wSlideVelocityYLo], a
    ld a, [wSlideVelocityYHi]
    adc $00
    ld [wSlideVelocityYHi], a
    ld d, $9e
    bit 7, a
    jr z, Slide_DrawAirborneFrame

    ld d, $9d

Slide_DrawAirborneFrame::
    ld a, d
    ldh [hTileStreamWritePos], a
    call Slide_MoveAndDrawActor
    call Slide_QueueAheadBackgroundColumn
    call Slide_DrawRoundPlatforms
    call Slide_CheckPlatformLanding
    ld a, [wSlideWorldYHi]
    or a
    ret nz

    ld a, [wSlideWorldYLo]
    cp $f0
    ret c

    ld a, [wSlidePlayerControl]
    or a
    jr z, Slide_BeginClearOrDemoResult

    ld a, [wMinigameResultFlag]
    or a
    jr z, Slide_BeginClearOrDemoResult

    ld a, $02
    ld [wScreenSubstate], a
    ret


Slide_BeginClearOrDemoResult::
    ld a, $04
    ld [wScreenSubstate], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ld hl, SceneAnim_7a36
    ld a, [wMinigameRound]
    cp $0a
    jr nz, Slide_SelectDemoResultAnimation

    ld hl, SceneAnim_7a61

Slide_SelectDemoResultAnimation::
    ld a, [wSlidePlayerControl]
    or a
    jr nz, Slide_StartResultAnimation

    ld a, $5b
    call PlaySound
    ld hl, SceneAnim_7a43

Slide_StartResultAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    ret


Slide_UpdatePlatformBounce::
    ld hl, wSlideVelocityYLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, -$0060
    add hl, bc
    ld a, l
    ld [wSlideVelocityYLo], a
    ld a, h
    ld [wSlideVelocityYHi], a
    ld a, $9c
    ldh [hTileStreamWritePos], a
    call Slide_MoveAndDrawActor
    call Slide_QueueAheadBackgroundColumn
    call Slide_DrawRoundPlatforms
    ld a, [wScreenPhaseCounter]
    cp $07
    jr c, Slide_AdvancePlatformBounceFrame

    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wSlidePlayerControl]
    and b
    jr z, Slide_AdvancePlatformBounceFrame

    ld a, [wScreenFrameCounter]
    ld [wScreenPhaseCounter], a

Slide_AdvancePlatformBounceFrame::
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $08
    ret nz

    ld a, $5c
    call PlaySound
    ld hl, wSlidePlatformPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    inc hl
    ld d, [hl]
    inc hl
    ld a, l
    ld [wSlidePlatformPtrLo], a
    ld a, h
    ld [wSlidePlatformPtrHi], a
    ld hl, $007c
    bit 6, d
    jr z, Slide_SetPlatformLaunchVelocity

    ld hl, -$007c

Slide_SetPlatformLaunchVelocity::
    ld a, l
    ld [wSlideVelocityXLo], a
    ld a, h
    ld [wSlideVelocityXHi], a
    ld hl, SlidePlatformLaunchYVelocities
    ld a, [wScreenPhaseCounter]
    rst $20
    ld a, l
    ld [wSlideVelocityYLo], a
    ld a, h
    ld [wSlideVelocityYHi], a
    ld a, $03
    ld [wScreenSubstate], a
    ret


Slide_MoveAndDrawActor::
; hTileStreamWritePos holds the actor metasprite selector on entry.
    ld a, [wScreenSubstate]
    cp $05
    jr z, Slide_UpdateCamera

    ld a, [wSlideVelocityXHi]
    ld b, $00
    bit 7, a
    jr z, Slide_IntegrateWorldX

    ld b, $ff

Slide_IntegrateWorldX::
    ld hl, wSlideWorldXSubpixel
    ld a, [wSlideVelocityXLo]
    add [hl]
    ld [hl+], a
    ld a, [wSlideVelocityXHi]
    adc [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl+], a
    ld a, [wSlideVelocityYHi]
    ld b, $00
    bit 7, a
    jr z, Slide_IntegrateWorldY

    ld b, $ff

Slide_IntegrateWorldY::
    ld hl, wSlideWorldYSubpixel
    ld a, [wSlideVelocityYLo]
    add [hl]
    ld [hl+], a
    ld a, [wSlideVelocityYHi]
    adc [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a

Slide_UpdateCamera::
    ld hl, wSlideWorldXLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, -$0050 ; Center the camera 80 pixels left of the actor.
    add hl, bc
    bit 7, h
    jr z, Slide_ClampCameraXUpperBound

    ld hl, $0000

Slide_ClampCameraXUpperBound::
    ld a, h
    cp $03
    jr c, Slide_StoreCameraX

    ld hl, $0300

Slide_StoreCameraX::
    ld a, l
    ld [wSlideCameraXLo], a
    ld a, h
    ld [wSlideCameraXHi], a
    ld hl, wSlideWorldXLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld l, $70
    ld a, [wScreenSubstate]
    cp $02
    jr z, Slide_StoreScrollAndProjectActor

    ld hl, wSlideWorldYLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, -$0048 ; Keep the actor near screen Y 72 while airborne.
    add hl, bc
    ld a, h
    or a
    jr z, Slide_ClampCameraYUpperBound

    ld l, $00
    jr Slide_StoreScrollAndProjectActor

Slide_ClampCameraYUpperBound::
    ld a, l
    cp $70
    jr c, Slide_StoreScrollAndProjectActor

    ld l, $70

Slide_StoreScrollAndProjectActor::
    ld a, l
    ld [wSlideCameraY], a
    ld a, [wSlideCameraXLo]
    ldh [hSCX], a
    ld a, [wSlideCameraY]
    ldh [hSCY], a
    ld a, [wSlideCameraXLo]
    ld c, a
    ld a, [wSlideWorldXLo]
    sub c
    ld c, a
    ld [wSlideActorScreenX], a
    ld a, [wSlideWorldYHi]
    or a
    ret nz

    ld a, [wSlideCameraY]
    ld b, a
    ld a, [wSlideWorldYLo]
    sub b
    ld b, a
    ld e, $00
    ld a, [wSlideVelocityXHi]
    bit 7, a
    jr z, Slide_ApplyFacingAndSelectFrame

    ld e, $01

Slide_ApplyFacingAndSelectFrame::
    ld a, e
    ldh [hSpriteFlags], a
    ld a, [wSlidePlayerControl]
    or a
    jr nz, Slide_DrawActorAndEffect

    ldh a, [hTileStreamWritePos]
    cp $9c
    jr nz, Slide_MapDemoRisingFrame

    ld a, $a8

Slide_MapDemoRisingFrame::
    cp $9d
    jr nz, Slide_MapDemoFallingFrame

    ld a, $a6

Slide_MapDemoFallingFrame::
    cp $9e
    jr nz, Slide_StoreDemoFrame

    ld a, $a7

Slide_StoreDemoFrame::
    ldh [hTileStreamWritePos], a

Slide_DrawActorAndEffect::
    ldh a, [hTileStreamWritePos]
    ld d, a
    call DrawBank3MetaspriteFar
    ld a, [wSlideEffectActive]
    or a
    ret z

    ld hl, wSlideCameraXLo
    ld a, [wSlideEffectXLo]
    sub [hl]
    ld c, a
    inc hl
    ld a, [wSlideEffectXHi]
    sbc [hl]
    or a
    ret nz

    ld a, [wSlideCameraY]
    ld b, a
    ld a, [wSlideEffectY]
    sub b
    ld b, a
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    or a
    ret z

    xor a
    ld [wSlideEffectActive], a
    ret


Slide_DrawRoundPlatforms::
; Compare each record with the active platform's draw record during a bounce.
    ld hl, wSlidePlatformPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    inc hl
    ld a, [hl-]
    dec hl
    dec hl
    and $0f
    add a
    add a
    ld b, a
    ld a, l
    sub b
    ld l, a
    ld a, h
    sbc $00
    ld h, a
    ld a, l
    ldh [hSlidePlatformDrawPtrLo], a
    ld a, h
    ldh [hSlidePlatformDrawPtrHi], a
    ld a, [wMinigameRound]
    dec a
    ld hl, SlidePlatformRoundPointers
    rst $20

Slide_SelectNextPlatformFrame::
    ld d, $ab
    ld a, [wScreenSubstate]
    cp $06
    jr nz, Slide_ProjectPlatform

    ldh a, [hSlidePlatformDrawPtrLo]
    cp l
    jr nz, Slide_ProjectPlatform

    ldh a, [hSlidePlatformDrawPtrHi]
    cp h
    jr nz, Slide_ProjectPlatform

    ld d, $ac

Slide_ProjectPlatform::
    ld a, d
    ldh [hTileStreamWritePos], a
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    ldh a, [hSCY]
    ld b, a
    ld a, [hl+]
    sub b
    ld b, a
    ld c, [hl]
    inc hl
    push hl
    ld hl, $000c
    add hl, de
    bit 7, c
    jr z, Slide_AdvancePlatformRecord

    ld a, [wSlideCameraXLo]
    ld c, a
    ld a, l
    sub c
    ld l, a
    ld a, [wSlideCameraXHi]
    ld c, a
    ld a, h
    sbc c
    ld h, a
    ld a, h
    or a
    jr nz, Slide_AdvancePlatformRecord

    ld a, l
    cp $e8
    jr nc, Slide_AdvancePlatformRecord

    sub $10
    ld c, a
    pop hl
    push hl
    ld a, [hl]
    cp $ff
    jr nz, Slide_DrawVisiblePlatform

    ld a, $ad
    ldh [hTileStreamWritePos], a
    ld a, [wMinigameResultFlag]
    or a
    jr z, Slide_AdvancePlatformRecord

Slide_DrawVisiblePlatform::
    ldh a, [hTileStreamWritePos]
    ld d, a
    call DrawBank3MetaspriteNormal

Slide_AdvancePlatformRecord::
    pop hl
    ld a, [hl]
    cp $ff
    jr nz, Slide_SelectNextPlatformFrame

    ret


Slide_CheckPlatformLanding::
; Tests downward motion, X overlap, then Y range. The last platform uses the wider goal range.
    ld a, [wSlideVelocityYHi]
    bit 7, a
    ret nz

    ld hl, wSlidePlatformPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl]
    ld [wSlideEffectXLo], a
    ld a, [wSlideWorldXLo]
    add $0c
    push af
    sub [hl]
    inc hl
    ld b, a
    ld a, [hl]
    ld [wSlideEffectXHi], a
    ld a, [wSlideWorldXHi]
    sbc [hl]
    ld c, a
    pop af
    ld a, c
    adc $00
    inc hl
    or a
    ret nz

    ld a, b
    cp $18
    ret nc

    ld a, [wSlideWorldYHi]
    or a
    ret nz

    ld a, [hl]
    add $18
    ld [wSlideEffectY], a
    ld a, [wSlideWorldYLo]
    add $18
    sub [hl]
    inc hl
    ld d, [hl]
    inc hl
    ld b, a
    ld c, $10
    ld a, [hl]
    cp $ff
    jr nz, Slide_CheckLandingVerticalRange

    ld c, $40

Slide_CheckLandingVerticalRange::
    ld a, b
    cp c
    ret nc

    ld a, [hl]
    cp $ff
    jr z, Slide_RegisterGoalLanding

    ld a, $06
    ld [wScreenSubstate], a
    ld a, [wSlidePlayerControl]
    or a
    ld a, $08
    jr nz, Slide_BeginPlatformBounce

    ld a, $07

Slide_BeginPlatformBounce::
    ld [wScreenPhaseCounter], a
    xor a
    ld [wScreenFrameCounter], a
    dec hl
    dec hl
    ld a, [hl]
    sub $18
    ld [wSlideWorldYLo], a
    ld hl, $0300
    ld a, l
    ld [wSlideVelocityYLo], a
    ld a, h
    ld [wSlideVelocityYHi], a
    xor a
    bit 6, d
    jr z, Slide_StartPlatformBounceEffect

    cpl

Slide_StartPlatformBounceEffect::
    ld [wSlideVelocityXLo], a
    ld [wSlideVelocityXHi], a
    ld hl, SceneAnim_7a4e
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim1Timer], a
    ld a, $01
    ld [wSlideEffectActive], a
    ret


Slide_RegisterGoalLanding::
    ld a, [wMinigameResultFlag]
    or a
    ret z

    ld a, $44
    call PlaySound
    xor a
    ld [wMinigameResultFlag], a
    ret


Slide_QueueAheadBackgroundColumn::
    ld e, $14
    ld a, [wSlideVelocityXHi]
    bit 7, a
    jr z, Slide_SelectBackgroundColumn

    ld e, $fe

Slide_SelectBackgroundColumn::
    ld hl, wSlideCameraXLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    ld a, e
    add l
    ld b, a
    and $1f
    ld hl, _SCRN0
    rst $38
    call GetVramQueueTailDE
    ld a, h
    ld [de], a
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, $a0
    ld [de], a
    inc de
    ld a, b
    and $7f
    ld hl, wStageLayoutMap
    rst $38
    ld b, $20

Slide_CopyBackgroundColumnTiles::
    ld a, [hl]
    ld [de], a
    inc de
    ld a, $80
    rst $38
    dec b
    jr nz, Slide_CopyBackgroundColumnTiles

    xor a
    ld [de], a
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ret


Slide_UpdateClearOrDemoResult::
    call Slide_DrawRoundPlatforms
    ld de, wSceneAnim0PtrLo
    ld a, [wSlideActorScreenX]
    ld c, a
    ld b, $80
    call AnimateSceneMetasprite
    ld a, [wSlideResultDelay]
    inc a
    ld [wSlideResultDelay], a
    cp $90
    ret c

    ld a, [wSlidePlayerControl]
    or a
    jr z, Slide_ReloadWithPlayerControl

    ld a, $a0
    ld [wSlideResultDelay], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld a, [wMinigameRound]
    cp $0a
    jp z, RequestSavedMenuDestination

    ld a, [wStateChangeParamHi]
    or a
    jp nz, RequestSavedMenuDestination

    ld a, [wMinigameRound]
    inc a
    ld [wMinigameRound], a
    ld hl, wMinigameUnlockedRounds + 2
    ld b, [hl]
    cp b
    jr c, Slide_ReloadNextDemo

    ld [hl], a

Slide_ReloadNextDemo::
    xor a
    ld [wSlidePlayerControl], a
    ld a, $01
    ldh [hNeedsReset], a
    ld [wSlideReuseLayout], a
    ret


Slide_ReloadWithPlayerControl::
    ld a, $01
    ld [wSlidePlayerControl], a
    ldh [hNeedsReset], a
    ld [wSlideReuseLayout], a
    ret



; Indexed screen data; scene-specific interpretation is documented at its consumer.

SlidePlatformRoundPointers::
; Records are X word, Y byte, flags. $ff,$ff follows the final platform.
; Bit 7 draws the platform, bit 6 reverses launch X, and the low nibble backs up to its draw record.
    dw Minigame3RoundObjects_5718
    dw Minigame3RoundObjects_571e
    dw Minigame3RoundObjects_5728
    dw Minigame3RoundObjects_5736
    dw Minigame3RoundObjects_5748
    dw Minigame3RoundObjects_575e
    dw Minigame3RoundObjects_5778
    dw Minigame3RoundObjects_5796
    dw Minigame3RoundObjects_57b8
    dw Minigame3RoundObjects_57de

Minigame3RoundObjects_5718::
    db $60, $01, $a0, $80, $ff, $ff

Minigame3RoundObjects_571e::
    db $50, $01, $c8, $80, $70, $01, $30, $80, $ff, $ff

Minigame3RoundObjects_5728::
    db $50, $01, $c8, $80, $80, $01, $68, $80, $d0, $01, $80, $80, $ff, $ff

Minigame3RoundObjects_5736::
    db $40, $01, $b0, $80, $70, $01, $58, $80, $b0, $01, $30, $80, $00, $02, $58, $80
    db $ff, $ff

Minigame3RoundObjects_5748::
    db $40, $01, $b8, $c0, $08, $01, $58, $80, $48, $01, $40, $80, $a0, $01, $90, $80
    db $d0, $01, $30, $80, $ff, $ff

Minigame3RoundObjects_575e::
    db $40, $01, $b8, $80, $70, $01, $58, $80, $c0, $01, $c0, $80, $f8, $01, $60, $80
    db $38, $02, $40, $80, $88, $02, $a0, $80, $ff, $ff

Minigame3RoundObjects_5778::
    db $30, $01, $a8, $80, $60, $01, $48, $80, $b0, $01, $d8, $80, $e8, $01, $80, $80
    db $28, $02, $80, $c0, $e8, $01, $80, $42, $b8, $01, $20, $80, $ff, $ff

Minigame3RoundObjects_5796::
    db $48, $01, $b8, $c0, $08, $01, $58, $80, $58, $01, $40, $80, $b0, $01, $90, $80
    db $e0, $01, $40, $80, $40, $02, $d0, $80, $70, $02, $88, $80, $b0, $02, $40, $80
    db $ff, $ff

Minigame3RoundObjects_57b8::
    db $62, $01, $d0, $80, $88, $01, $70, $80, $d0, $01, $70, $c0, $88, $01, $70, $02
    db $d0, $01, $70, $42, $88, $01, $70, $04, $d0, $01, $70, $04, $24, $02, $d0, $80
    db $60, $02, $90, $80, $ff, $ff

Minigame3RoundObjects_57de::
    db $3c, $01, $b0, $80, $64, $01, $4a, $80, $b8, $01, $d0, $80, $f0, $01, $78, $80
    db $38, $02, $d0, $80, $78, $02, $70, $80, $c0, $02, $b8, $80, $f0, $02, $58, $80
    db $30, $03, $38, $80, $70, $03, $20, $80, $ff, $ff

SlidePlatformLaunchYVelocities::
; Signed 8.8 velocities indexed by the bounce timing.
    db $00, $ff, $80, $fe, $00, $fd, $00, $fd, $00, $fd, $00, $fd, $00, $fd, $00, $fd
    db $80, $ff
InitMinigame1::
; Mode 1 initialization; the scene work area is shared with the other minigames.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld [wMekemekePaletteFlashTimer], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, BANK(GfxRle_b06_5851)
    ld hl, GfxRle_b06_5851
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_6839)
    ld hl, GfxRle_b06_6839
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_6e44)
    ld hl, GfxRle_b06_6e44
    ld de, _VRAM + $900
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_6fe5)
    ld hl, LayoutRle_b06_6fe5
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenSubstate], a
    ld [wMekemekeEnemySlotsEnd], a
    ld a, $0d
    ld [wScreenPaletteId], a
    ret


UpdateMinigame1::
; Mode 1 update.
    ld a, [wMekemekePaletteFlashTimer]
    or a
    jr z, Mekemeke_RestoreNormalPalette

    dec a
    ld [wMekemekePaletteFlashTimer], a
    ld a, $1b
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    jr Mekemeke_DispatchPhase

Mekemeke_RestoreNormalPalette::
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, [wSgbEnabled]
    or a
    jr z, Mekemeke_DispatchPhase

    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a

Mekemeke_DispatchPhase::
    ld a, [wScreenSubstate]
    rst $00

Minigame1StateHandlers::
    dw Minigame_WaitForStart ; $00
    dw Mekemeke_UpdateRoundIntro ; $01
    dw Mekemeke_UpdateRound ; $02
    dw Mekemeke_UpdateFailure ; $03
    dw Mekemeke_UpdateClear ; $04

Mekemeke_UpdateRoundIntro::
    xor a
    ld [wScreenPhaseCounter], a
    call Mekemeke_QueueLaneTileAnimation
    call UpdateMessageFar
    ld c, $0f
    ld b, $1c
    ld d, $60
    call DrawBank3MetaspriteNormal
    ld a, [wMinigamePhaseCounter]
    cp $ff
    jr nz, Mekemeke_TickStartCountdown

    ld a, [wMinigameRound]
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $14
    call StartMessageFar
    ld bc, _SCRN0 + $201
    ld de, $ac11
    call QueueVramFill
    ld bc, _SCRN0 + $221
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [wMinigamePhaseCounter], a
    ret


Mekemeke_TickStartCountdown::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ld b, a
    ld a, [wMinigamePhaseCounter]
    or b
    jp nz, Mekemeke_ShowCountdownDigit

    call InitSound
    ld a, $2c
    call PlaySound_Queue3
    ld bc, _SCRN0 + $128
    ld de, $0004
    call QueueVramFill
    ld bc, _SCRN0 + $148
    ld de, $0004
    call QueueVramFill
    ld de, MekemekeHudTiles
    ld hl, _SCRN0 + $201
    ld bc, $1102
    call QueueTilemapRect
    ld a, $02
    ld [wScreenSubstate], a
    xor a
    ld [wMekemekePlayerLane], a
    ld [wMekemekePlayerShotX], a
    ld a, [wMinigameRound]
    ld b, a
    sla a
    add b
    ld hl, MekemekeRoundGoalTiles
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, _SCRN0 + $22f
    ld a, [de]
    cp $04
    jr nz, Mekemeke_DrawRoundGoal

    inc de
    inc hl
    dec b

Mekemeke_DrawRoundGoal::
    call QueueTilemapRect
    ld a, [wMinigameRound]
    dec a
    ld b, a
    add a
    add b
    ld hl, MekemekeRoundTimerDigits
    rst $38
    ld a, [hl+]
    ld [wMinigameTimerHundreds], a
    ld a, [hl+]
    ld [wMinigameTimerTens], a
    ld a, [hl+]
    ld [wMinigameTimerOnes], a
    ld a, $01
    ld [wMinigamePhaseCounter], a
    ld a, $04
    ld [wMinigameScoreHundreds], a
    ld [wMinigameScoreTens], a
    ld [wMinigameScoreOnes], a
    ld hl, SceneAnim_79bb
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wMekemekeHitReactionTimer], a
    ld [wMekemekeBlastSpan], a
    cpl
    ld [wMekemekeBlastLaneFlags], a
    call AdvanceScreenRandomByte
    and $07
    add $0a
    ld [wMekemekeBlastPickCooldown], a
    ld b, $04
    ld hl, wMekemekeEnemySlots

Mekemeke_InitNextEnemySlot::
    xor a
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $9c
    ld [hl+], a
    ld a, $23
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    dec b
    jr nz, Mekemeke_InitNextEnemySlot

    ret


Mekemeke_ShowCountdownDigit::
    ld a, [wScreenFrameCounter]
    or a
    ret nz

    xor a
    ld [wMessageFlags], a
    ld a, [wMinigamePhaseCounter]
    dec a
    ld [wMinigamePhaseCounter], a
    add $10
    call StartMessageFar
    ld bc, _SCRN0 + $226
    ld de, $0008
    call QueueVramFill
    ld hl, _SCRN0 + $20c
    ld a, $ac
    call QueueTilemapByte
    ld a, $32
    ld [wScreenFrameCounter], a
    ld a, [wMinigamePhaseCounter]
    or a
    ld a, $59
    jr nz, Mekemeke_PlayCountdownCue

    ld a, $5a

Mekemeke_PlayCountdownCue::
    call PlaySound
    ret


Mekemeke_UpdateRound::
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, PauseMinigame
    ld a, [wMekemekePlayerLane]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wMinigamePhaseCounter]
    cp $01
    jr nz, Mekemeke_UpdateBlast

    ld a, [wMekemekeBlastPickCooldown]
    or a
    jr z, Mekemeke_UpdateBlast

    dec a
    ld [wMekemekeBlastPickCooldown], a

Mekemeke_UpdateBlast::
    ld a, [wMekemekeBlastSpan]
    or a
    jp z, Mekemeke_CheckAttackInput

    ld c, a
    ld a, [wMekemekeBlastLaneFlags]
    bit 7, a
    jr z, Mekemeke_ProjectBlast

    ld a, [wMekemekeBlastSpan]
    dec a
    ld [wMekemekeBlastSpan], a

Mekemeke_ProjectBlast::
    ld a, [wMekemekeBlastLaneFlags]
    and $7f
    swap a
    add a
    or $18
    ld b, a
    ld a, $00
    bit 7, c
    jr z, Mekemeke_DrawBlastAndCheckLane

    ld a, $02

Mekemeke_DrawBlastAndCheckLane::
    ldh [hSpriteFlags], a
    ld d, $76
    call DrawBank3MetaspriteFar
    ld a, [wMekemekePlayerLane]
    ld b, a
    ld a, [wMekemekeBlastLaneFlags]
    bit 7, a
    jr z, Mekemeke_CheckAttackInput

    and $7f
    cp b
    jr nz, Mekemeke_CheckAttackInput

    ld a, [wMekemekeBlastSpan]
    cp $18
    jr nc, Mekemeke_CheckAttackInput

    ld a, $20
    ld [wMekemekePaletteFlashTimer], a
    ld a, $49
    call PlaySound_Queue1
    xor a
    ld c, a
    ld [wMekemekeBlastSpan], a
    ld hl, wMekemekeEnemySlots
    ld de, $0008
    ld b, $04

Mekemeke_BlastNextEnemy::
    push hl
    ld a, [hl]
    res 3, [hl]
    set 1, [hl]
    inc hl
    inc hl
    bit 1, a
    jr nz, Mekemeke_AdvanceBlastSlot

    ld a, [hl]
    cp $98
    inc hl
    inc hl
    inc hl
    ld [hl], $00
    jr nc, Mekemeke_AdvanceBlastSlot

    inc c

Mekemeke_AdvanceBlastSlot::
    pop hl
    add hl, de
    dec b
    jr nz, Mekemeke_BlastNextEnemy

    ld a, c
    ld c, $00
    bit 0, a
    jr z, Mekemeke_AddBlastScore

    ld c, $05

Mekemeke_AddBlastScore::
    srl a
    ld b, a
    ld hl, MekemekeRoundGoalTiles
    call Minigame_AddScoreAndCompareGoal
    jp nc, Mekemeke_BeginClearAnimation

Mekemeke_CheckAttackInput::
    ldh a, [hJoyPressed]
    and $03
    jr z, Mekemeke_UpdateEnemiesAndCountdown

    ld a, [wMekemekePlayerShotX]
    or a
    jr nz, Mekemeke_UpdateEnemiesAndCountdown

    ld a, [wMekemekePlayerLane]
    ld [wMekemekePlayerShotLane], a
    ld a, $1a
    ld [wMekemekePlayerShotX], a
    xor a
    ld [wMekemekePlayerShotXSubpixel], a
    ld a, $50
    call PlaySound
    ld hl, SceneAnim_79b7
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

Mekemeke_UpdateEnemiesAndCountdown::
    call Mekemeke_UpdateEnemyLanes
    call TickMinigameCountdown
    or a
    jr nz, Mekemeke_TickHitReaction

    ld a, $03
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79cd
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    ret


Mekemeke_TickHitReaction::
    ld a, [wMekemekeHitReactionTimer]
    dec a
    ld [wMekemekeHitReactionTimer], a
    cp $ff
    jr z, Mekemeke_ReadLaneInput

    or a
    ret nz

    ld hl, SceneAnim_79bb
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

Mekemeke_ReadLaneInput::
    xor a
    ld [wMekemekeHitReactionTimer], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wMekemekePlayerLane]
    bit 6, b
    jr z, Mekemeke_CheckDownInput

    or a
    jr z, Mekemeke_CheckDownInput

    dec a

Mekemeke_CheckDownInput::
    bit 7, b
    jr z, Mekemeke_StoreLaneAndMoveShot

    cp $03
    jr nc, Mekemeke_StoreLaneAndMoveShot

    inc a

Mekemeke_StoreLaneAndMoveShot::
    ld [wMekemekePlayerLane], a
    ld hl, wMekemekePlayerShotXSubpixel
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    or a
    ret z

    ld bc, $0300
    add hl, bc
    ld a, l
    ld [wMekemekePlayerShotXSubpixel], a
    ld a, h
    ld [wMekemekePlayerShotX], a
    ld a, h
    cp $98
    jr nc, Mekemeke_ClearPlayerShot

    ld c, h
    ld a, [wMekemekePlayerShotLane]
    swap a
    add a
    or $16
    ld b, a
    ld d, $62
    call DrawBank3MetaspriteNormal
    ret


Mekemeke_ClearPlayerShot::
    xor a
    ld [wMekemekePlayerShotX], a
    ret


Mekemeke_UpdateEnemyLanes::
    call Mekemeke_QueueLaneTileAnimation
    ldh a, [hMekemekeVariantCount]
    ldh [hMekemekePrevVariantCount], a
    xor a
    ldh [hMekemekeVariantCount], a
    ld a, $04
    ldh [hMekemekeSlotsRemaining], a
    ld hl, wMekemekeEnemySlotsEnd

Mekemeke_UpdateNextEnemyLane::
    ldh a, [hMekemekeSlotsRemaining]
    dec a
    ldh [hMekemekeLaneIndex], a
    swap a
    add a
    or $17
    ldh [hMekemekeLaneY], a
    ld bc, -MEKEMEKE_ENEMY_SIZE
    add hl, bc
    push hl
    ld a, [wScreenSubstate]
    cp $04
    jr nz, Mekemeke_CountActiveVariant

    set 1, [hl]
    res 3, [hl]

Mekemeke_CountActiveVariant::
    ld a, [hl+]
    ld d, a
    and $07
    cp $01
    jr nz, Mekemeke_SelectEnemyVelocity

    ldh a, [hMekemekeVariantCount]
    inc a
    ldh [hMekemekeVariantCount], a

Mekemeke_SelectEnemyVelocity::
    ld bc, $0200
    bit 1, d
    jr nz, Mekemeke_CheckStationaryAttack

    push hl
    push de
    ld a, [wMinigameRound]
    dec a
    ld hl, MekemekeRoundEnemyVelocities
    bit 0, d
    jr z, Mekemeke_ReadRoundEnemyVelocity

    add $0a

Mekemeke_ReadRoundEnemyVelocity::
    rst $20
    ld c, l
    ld b, h
    pop de
    pop hl

Mekemeke_CheckStationaryAttack::
    bit 3, d
    jr z, Mekemeke_MoveEnemyAndCheckDefenseLine

    ld bc, $0000

Mekemeke_MoveEnemyAndCheckDefenseLine::
    ld a, c
    add [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a
    ld a, [hl-]
    dec hl
    cp $2a
    jr nc, Mekemeke_CheckEnemyRespawn

    push hl
    ld a, $03
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79cd
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop hl

Mekemeke_CheckEnemyRespawn::
    inc hl
    inc hl
    ld a, [hl]
    bit 1, d
    jr z, Mekemeke_UpdateBlastSpanFromEnemy

    cp $a8
    jr c, Mekemeke_UpdateBlastSpanFromEnemy

    inc hl
    inc hl
    call AdvanceScreenRandomByte
    and $3f
    add $38
    ld [hl-], a
    dec hl
    call AdvanceScreenRandomByte
    and $3f
    add $a8
    ld [hl-], a
    dec hl
    ld a, [wMinigameRound]
    dec a
    add LOW(MekemekeVariantChances)
    ld c, a
    ld a, $00
    adc HIGH(MekemekeVariantChances)
    ld b, a
    ld a, [bc]
    ld c, a
    ldh a, [hMekemekePrevVariantCount]
    cp $03
    jr c, Mekemeke_RollEnemyVariant

    ld c, $00

Mekemeke_RollEnemyVariant::
    call AdvanceScreenRandomByte
    and $07
    cp c
    ld a, $00
    jr nc, Mekemeke_StoreVariantAndPickBlastLane

    ld a, $01

Mekemeke_StoreVariantAndPickBlastLane::
    ld [hl+], a
    inc hl
    ld a, [wMekemekeBlastPickCooldown]
    or a
    jr nz, Mekemeke_UpdateBlastSpanFromEnemy

    call AdvanceScreenRandomByte
    and $07
    add $0a
    ld [wMekemekeBlastPickCooldown], a
    ld a, [wMekemekeBlastSpan]
    or a
    jr nz, Mekemeke_UpdateBlastSpanFromEnemy

    ldh a, [hMekemekeSlotsRemaining]
    dec a
    ld [wMekemekeBlastLaneFlags], a

Mekemeke_UpdateBlastSpanFromEnemy::
    ld a, [wMekemekeBlastLaneFlags]
    bit 7, a
    jr nz, Mekemeke_CheckEnemyAttackStart

    ld a, [wMekemekeBlastLaneFlags]
    inc a
    ld b, a
    ldh a, [hMekemekeSlotsRemaining]
    cp b
    jr nz, Mekemeke_CheckEnemyAttackStart

    ld a, [hl]
    sub $14
    ld [wMekemekeBlastSpan], a

Mekemeke_CheckEnemyAttackStart::
    ld a, [hl+]
    ld c, a
    inc hl
    bit 3, d
    jr nz, Mekemeke_TickEnemyAttackWindup

    bit 0, d
    jr z, Mekemeke_SelectEnemyFrame

    ld a, [hl]
    cp c
    jr c, Mekemeke_SelectEnemyFrame

    ld [hl], $30
    pop de
    push de
    ld a, [de]
    set 3, a
    ld [de], a
    jr Mekemeke_SelectEnemyFrame

Mekemeke_TickEnemyAttackWindup::
    dec [hl]
    ld a, [hl]
    or a
    jr nz, Mekemeke_SelectEnemyFrame

    pop de
    push de
    ld a, [de]
    res 3, a
    ld [de], a
    inc hl
    ld a, c
    ld [hl-], a

Mekemeke_SelectEnemyFrame::
    dec hl
    push hl
    ldh a, [hMekemekeLaneY]
    ld b, a
    ld a, c
    srl a
    srl a
    srl a
    and $03
    bit 1, d
    jr z, Mekemeke_SelectAttackFrame

    ld a, $04

Mekemeke_SelectAttackFrame::
    bit 3, d
    jr z, Mekemeke_SelectVariantFrameTable

    ld a, $05

Mekemeke_SelectVariantFrameTable::
    ld hl, MekemekeEnemyFrames
    bit 0, d
    jr z, Mekemeke_DrawEnemyAndCheckIncomingShot

    ld hl, MekemekeVariantEnemyFrames

Mekemeke_DrawEnemyAndCheckIncomingShot::
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteWithPriority
    pop hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    jr z, Mekemeke_NextLaneOrCheckPlayerShot

    cp $20
    jr nc, Mekemeke_MoveIncomingShot

    cp $10
    jr c, Mekemeke_MoveIncomingShot

    ldh a, [hMekemekeLaneIndex]
    ld b, a
    ld a, [wMekemekePlayerLane]
    cp b
    jr nz, Mekemeke_MoveIncomingShot

    ld bc, SceneAnim_79cd
    ld a, c
    ld [wSceneAnim0PtrLo], a
    ld a, b
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [hl], a
    ld a, $78
    ld [wMekemekeHitReactionTimer], a
    ld a, $51
    call PlaySound

Mekemeke_MoveIncomingShot::
    inc hl
    ld bc, -$0280
    ld a, [hl]
    add c
    ld [hl-], a
    ld a, [hl]
    adc b
    cp $f0
    jr c, Mekemeke_StoreAndDrawIncomingShot

    xor a

Mekemeke_StoreAndDrawIncomingShot::
    ld [hl], a
    ld c, a
    ldh a, [hMekemekeLaneY]
    ld b, a
    ld d, $72
    call DrawBank3MetaspriteNormal

Mekemeke_NextLaneOrCheckPlayerShot::
    pop hl
    ldh a, [hMekemekeSlotsRemaining]
    dec a
    ldh [hMekemekeSlotsRemaining], a
    jp nz, Mekemeke_UpdateNextEnemyLane

    ld a, [wMekemekePlayerShotLane]
    swap a
    srl a
    ld hl, wMekemekeEnemySlots
    rst $38
    inc hl
    inc hl
    ld b, [hl]
    ld a, [wMekemekePlayerShotX]
    cp b
    jr c, Mekemeke_CheckProjectileClash

    ld a, $52
    call PlaySound
    xor a
    ld [wMekemekePlayerShotX], a
    dec hl
    dec hl
    set 1, [hl]
    res 3, [hl]
    ld bc, $0005
    add hl, bc
    ld [hl], $00
    ld a, [wSharedWork + $df] ; The score helper overwrites A before using it.
    ld bc, $0005
    ld hl, MekemekeRoundGoalTiles
    call Minigame_AddScoreAndCompareGoal
    jr c, Mekemeke_ArmBlastAfterShot

Mekemeke_BeginClearAnimation::
    ld a, $04
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79be
    ld a, [wMinigameRound]
    cp $0a
    jr nz, Mekemeke_StoreClearAnimation

    ld hl, SceneAnim_79d4

Mekemeke_StoreClearAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


Mekemeke_ArmBlastAfterShot::
    ld a, [wMekemekePlayerShotLane]
    ld b, a
    ld a, [wMekemekeBlastLaneFlags]
    cp b
    ret nz

    set 7, a
    ld [wMekemekeBlastLaneFlags], a
    ret


Mekemeke_CheckProjectileClash::
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    ret z

    ld b, a
    ld a, [wMekemekePlayerShotX]
    or a
    ret z

    cp b
    ret c

    xor a
    ld [hl], a
    ld [wMekemekePlayerShotX], a
    ret


Mekemeke_UpdateFailure::
    ld a, [wMekemekePlayerLane]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld b, $04
    ld hl, wMekemekeEnemySlotsEnd

Mekemeke_DrawNextFailedLane::
    push bc
    ld e, b
    ld bc, -MEKEMEKE_ENEMY_SIZE
    add hl, bc
    push hl
    ld d, $00
    bit 0, [hl]
    jr z, Mekemeke_ProjectFailedLane

    ld d, $02

Mekemeke_ProjectFailedLane::
    inc hl
    inc hl
    ld a, e
    dec a
    swap a
    add a
    or $17
    ld b, a
    ld a, [hl]
    ld c, a
    cp $90
    ld a, $00
    jr c, Mekemeke_SetFailedLanePriority

    ld a, $02

Mekemeke_SetFailedLanePriority::
    ldh [hSpriteFlags], a
    ld a, [wScreenFrameCounter]
    bit 4, a
    jr nz, Mekemeke_DrawFailedLaneFrame

    inc d

Mekemeke_DrawFailedLaneFrame::
    ld a, d
    ld hl, MekemekeFailureEnemyFrames
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteFar
    pop hl
    pop bc
    dec b
    jr nz, Mekemeke_DrawNextFailedLane

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $90
    ret c

    ld a, $01
    ld [wMinigameResultFlag], a
    ldh a, [hJoyPressed]
    bit 0, a
    jp nz, AdvanceMinigameRoundOrExit

    ld a, [wScreenFrameCounter]
    cp $ff
    ret nz

    ld a, $7f
    ld [wScreenFrameCounter], a
    ret


Mekemeke_UpdateClear::
    ld hl, wMekemekeEnemySlots + MEKEMEKE_ENEMY_OFS_SHOT_X
    xor a
    ld de, $0008
    ld b, $04

Mekemeke_ClearEnemyShotsAfterWin::
    ld [hl], a
    add hl, de
    dec b
    jr nz, Mekemeke_ClearEnemyShotsAfterWin

    call Mekemeke_UpdateEnemyLanes
    ld a, [wMekemekePlayerLane]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    or a
    ret z

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $40
    ret c

    ld a, $a0
    ld [wScreenFrameCounter], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld hl, wMinigameUnlockedRounds
    xor a
    ld [wMinigameResultFlag], a
    jp AdvanceMinigameRoundOrExit


Mekemeke_QueueLaneTileAnimation::
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    srl a
    srl a
    and $06
    ld hl, MekemekeLaneTilePairs
    rst $38
    ld e, l
    ld d, h
    ld hl, _SCRN0 + $023

Mekemeke_QueueNextLaneTilePair::
    push de
    push hl
    ld bc, $0102
    call QueueTilemapRect
    pop hl
    pop de
    ld bc, $0080
    add hl, bc
    ld a, h
    cp $9a
    jr nz, Mekemeke_QueueNextLaneTilePair

    ret



MekemekeRoundEnemyVelocities::
; Ten signed 8.8 velocities per variant.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $80, $ff, $79, $ff, $71, $ff, $69, $ff, $61, $ff, $5a, $ff, $52, $ff, $4a, $ff
    db $42, $ff, $3a, $ff, $40, $ff, $39, $ff, $31, $ff, $29, $ff, $21, $ff, $1a, $ff
    db $12, $ff, $0a, $ff, $02, $ff, $fa, $fe

MekemekeEnemyFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $69, $6a, $69, $6b, $6d, $6d

MekemekeVariantEnemyFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $6e, $6f, $6e, $70, $75, $71

MekemekeVariantChances::
; One threshold per round, compared with a random value 0 through 7.
    db $01, $01, $02, $02, $03, $03, $04, $04, $05, $05

MekemekeFailureEnemyFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $6c, $69, $73, $74

MekemekeLaneTilePairs::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $91, $a1, $a8, $a9, $aa, $ab, $a8, $a9

MekemekeHudTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $85, $86, $87, $ac, $ac, $ac, $ac, $ac, $80, $81, $ac, $ac, $ac, $ac, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

MekemekeRoundTimerDigits::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $03, $01, $00, $04, $01, $00, $05, $01, $00, $06, $01, $00, $07, $01, $00
    db $08, $01, $00, $09, $01, $01, $00, $01, $01, $01, $01, $01, $02, $01

MekemekeRoundGoalTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $04, $04, $05, $04, $04, $05, $09, $04, $06, $04, $04, $06, $09, $04, $07
    db $04, $04, $07, $09, $04, $08, $04, $04, $08, $09, $04, $09, $04, $04, $09, $09
    db $04

InitMinigame2::
; Mode 2 initialization.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $8c
    ldh [hOamMaxY], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, BANK(GfxRle_b06_5851)
    ld hl, GfxRle_b06_5851
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_60db)
    ld hl, LayoutRle_b06_60db
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenSubstate], a
    ld [wScreenPhaseCounter], a
    ld a, $0e
    ld [wScreenPaletteId], a
    ret


UpdateMinigame2::
; Mode 2 update.
    ld a, [wScreenSubstate]
    rst $00

Minigame2StateHandlers::
    dw Minigame_WaitForStart ; $00
    dw BugHunt_UpdateRoundIntro ; $01
    dw BugHunt_UpdateRound ; $02

BugHunt_UpdateRoundIntro::
    call UpdateMessageFar
    ld bc, $4050
    ld d, $1a
    call DrawBank3MetaspriteNormal
    ld bc, $4920
    ld d, $3e
    ld a, [wMinigameRound]
    cp $04
    call nc, DrawBank3MetaspriteNormal
    ld bc, $4980
    ld d, $46
    ld a, [wMinigameRound]
    cp $07
    call nc, DrawBank3MetaspriteNormal
    ld a, [wMinigamePhaseCounter]
    cp $ff
    jr nz, BugHunt_TickStartCountdown

    ld a, [wMinigameRound]
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $14
    call StartMessageFar
    ld bc, _SCRN0 + $201
    ld de, $9111 ; Fill 17 columns with tile $91.
    call QueueVramFill
    ld bc, _SCRN0 + $221
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [wMinigamePhaseCounter], a
    ret


BugHunt_TickStartCountdown::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ld b, a
    ld a, [wMinigamePhaseCounter]
    or b
    jp nz, BugHunt_ShowCountdownDigit

    call InitSound
    ld a, $24
    call PlaySound_Queue3
    ld de, BugHuntHudTiles
    ld hl, _SCRN0 + $201
    ld bc, $1102
    call QueueTilemapRect
    ld bc, _SCRN0 + $148
    ld de, $0004
    call QueueVramFill
    ld hl, _SCRN0 + $129
    xor a
    call QueueTilemapByte
    ld a, [wMinigameRound]
    ld b, a
    sla a
    add b
    ld hl, BugHuntRoundGoalTiles
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, _SCRN0 + $22f
    ld a, [de]
    cp $04
    jr nz, BugHunt_DrawRoundGoal

    inc de
    inc hl
    dec b

BugHunt_DrawRoundGoal::
    call QueueTilemapRect
    xor a
    ld [wMinigameTimerHundreds], a
    ld a, $09
    ld [wMinigameTimerTens], a
    ld [wMinigameTimerOnes], a
    ld a, $04
    ld [wMinigameScoreHundreds], a
    ld [wMinigameScoreTens], a
    ld [wMinigameScoreOnes], a
    ld a, $32
    ld [wMinigamePhaseCounter], a
    ld a, $02
    ld [wScreenSubstate], a
    ld a, $a0
    ld [wBugSpawnDelay], a
    ld hl, SceneAnim_7913
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wBugPhase], a
    ld [wBugPlayerBlinkTimer], a
    ld a, $50
    ld [wBugPlayerX], a
    ld a, $40
    ld [wBugPlayerY], a
    ld a, $02
    ld [wBugPlayerFacing], a
    ld hl, BugHuntInitialHazardRecords
    ld de, wBugHazardSlots
    ld b, $10

BugHunt_CopyHazardInitialState::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, BugHunt_CopyHazardInitialState

    ld a, $80
    ld hl, wBugSlots
    ld bc, $0008
    ld d, $10

BugHunt_ClearNextBugSlot::
    ld [hl], a
    add hl, bc
    dec d
    jr nz, BugHunt_ClearNextBugSlot

    call AdvanceScreenRandomByte
    and $03
    ld [wBugSpawnGate], a
    ret


BugHunt_ShowCountdownDigit::
    ld a, [wScreenFrameCounter]
    or a
    ret nz

    xor a
    ld [wMessageFlags], a
    ld a, [wMinigamePhaseCounter]
    dec a
    ld [wMinigamePhaseCounter], a
    add $10
    call StartMessageFar
    ld bc, _SCRN0 + $226
    ld de, $0008
    call QueueVramFill
    ld hl, _SCRN0 + $20c
    ld a, $91
    call QueueTilemapByte
    ld a, $32
    ld [wScreenFrameCounter], a
    ld a, [wMinigamePhaseCounter]
    or a
    ld a, $59
    jr nz, BugHunt_PlayCountdownCue

    ld a, $5a

BugHunt_PlayCountdownCue::
    call PlaySound
    ret


BugHunt_UpdateRound::
    ld a, [wBugHazardFrameCounter]
    inc a
    ld [wBugHazardFrameCounter], a
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, PauseMinigame
    ld a, [wBugPlayerX]
    ld c, a
    ld a, [wBugPlayerY]
    ld b, a
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wBugPlayerBlinkTimer]
    or a
    jr z, BugHunt_UpdateHazardsAndTimer

    dec a
    ld [wBugPlayerBlinkTimer], a
    bit 3, a
    jr z, BugHunt_UpdateHazardsAndTimer

    xor a
    ldh [hOamWritePos], a

BugHunt_UpdateHazardsAndTimer::
    call BugHunt_UpdateRoundHazards
    call BugHunt_DrawCaughtBugPopup
    ld a, [wBugWingFrameCounter]
    inc a
    ld [wBugWingFrameCounter], a
    call TickMinigameCountdown
    or a
    jr nz, BugHunt_TickSpawnGate

    ld a, $04
    ld [wBugPhase], a
    ld hl, SceneAnim_7960
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $01
    ld [wMinigameResultFlag], a
    ld a, $90
    ld [wScreenFrameCounter], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3

BugHunt_TickSpawnGate::
    ld a, [wBugSpawnDelay]
    dec a
    ld [wBugSpawnDelay], a
    cp $60
    jp nc, BugHunt_UpdateBugSlots

    and $0f
    jp nz, BugHunt_UpdateBugSlots

    ld a, [wBugSpawnGate]
    sla a
    sla a
    ld hl, BugHuntSpawnGates
    rst $38
    ld a, [hl+]
    push hl
    ld h, [hl]
    ld l, a
    ld a, [wBugSpawnDelay]
    ld de, BugHuntGateBaseTiles
    bit 4, a
    jr z, BugHunt_DrawSpawnGate

    ld a, [wBugPhase]
    cp $04
    jp z, BugHunt_DrawSpawnGate

    ld de, BugHuntGateBlinkTiles

BugHunt_DrawSpawnGate::
    ld bc, $0301
    call QueueTilemapRect
    pop hl
    ld a, [wBugSpawnDelay]
    or a
    jp nz, BugHunt_UpdateBugSlots

    ld a, [wBugPhase]
    cp $04
    jp z, BugHunt_UpdateBugSlots

    inc hl
    ld a, [hl+]
    ldh [hBugSpawnX], a
    ld a, [hl]
    ldh [hBugSpawnY], a
    ld a, [wMinigameRound]
    dec a
    add a
    add a
    ld hl, BugHuntRoundSpawnWeights
    rst $38
    call AdvanceScreenRandomByte
    and $07
    ld b, $00

BugHunt_SelectWeightedBugType::
    sub [hl]
    jr c, BugHunt_SelectSpawnDirection

    inc b
    inc hl
    jr BugHunt_SelectWeightedBugType

BugHunt_SelectSpawnDirection::
    ld a, b
    ldh [hBugSpawnType], a
    ld a, [wBugSpawnGate]
    ld b, a
    add a
    add b
    ld hl, BugHuntGateDirectionChoices
    rst $38
    ldh a, [hBugSpawnType]
    cp $03
    jr nz, BugHunt_PickOrdinaryBugDirection

    call AdvanceScreenRandomByte
    bit 0, a
    jr z, BugHunt_FindFreeBugSlot

    inc hl
    jr BugHunt_FindFreeBugSlot

BugHunt_PickOrdinaryBugDirection::
    call ChooseScreenRandomThird
    rst $38

BugHunt_FindFreeBugSlot::
    ld d, [hl]
    ld hl, wBugSlots
    ld b, $10

BugHunt_CheckNextBugSlot::
    ld a, [hl]
    bit 7, a
    jr nz, BugHunt_WriteSpawnedBug

    ld a, $08
    rst $38
    dec b
    jr nz, BugHunt_CheckNextBugSlot

    jr BugHunt_UpdateBugSlots

BugHunt_WriteSpawnedBug::
    ldh a, [hBugSpawnType]
    ld [hl+], a
    ld [hl], d
    inc hl
    ldh a, [hBugSpawnX]
    ld [hl+], a
    ldh a, [hBugSpawnY]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl], a
    call AdvanceScreenRandomByte
    and $7f
    add $40
    ld [wBugSpawnDelay], a
    call AdvanceScreenRandomByte
    and $03
    ld [wBugSpawnGate], a

BugHunt_UpdateBugSlots::
    ld b, $10
    ld hl, wBugSlots

BugHunt_UpdateNextBug::
    push bc
    push hl
    ld a, [hl]
    and $c0
    jp nz, BugHunt_AdvanceBugSlot

    ld a, [hl]
    push hl
    cp $03
    call nc, BugHunt_UpdateSpecialBugMotion
    pop hl
    ld a, [hl]
    sla a
    ld de, BugHuntMotionSteps
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld bc, $0004
    add hl, bc
    ld a, [de]
    inc de
    add [hl]
    ld [hl], a
    ld a, [de]
    adc $00
    dec hl
    dec hl
    dec hl
    ld b, [hl]
    inc hl
    push hl
    bit 1, b
    jr nz, BugHunt_SelectMotionAxis

    cpl
    inc a

BugHunt_SelectMotionAxis::
    bit 0, b
    jr nz, BugHunt_MoveBugAndCheckX

    inc hl

BugHunt_MoveBugAndCheckX::
    add [hl]
    ld [hl], a
    pop hl
    ld a, [hl]
    ld c, a
    bit 7, a
    jr z, BugHunt_CheckBugY

    cp $a0
    jr c, BugHunt_CheckBugY

    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr BugHunt_AdvanceBugSlot

BugHunt_CheckBugY::
    inc hl
    ld a, [hl]
    ld b, a
    bit 7, a
    jr z, BugHunt_SelectBugAnimationPhase

    cp $80
    jr c, BugHunt_SelectBugAnimationPhase

    dec hl
    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr BugHunt_AdvanceBugSlot

BugHunt_SelectBugAnimationPhase::
    dec hl
    dec hl
    ld a, [wBugWingFrameCounter]
    and $10
    jr z, BugHunt_SelectBugMetasprite

    scf

BugHunt_SelectBugMetasprite::
    ld a, [hl-]
    rla
    ld d, a
    ld a, [hl]
    swap a
    srl a
    or d
    ld hl, BugHuntBugFrames
    rst $38
    ld a, $01
    ld d, [hl]
    bit 7, d
    jr nz, BugHunt_DrawBug

    xor a

BugHunt_DrawBug::
    ldh [hSpriteFlags], a
    ld a, d
    and $7f
    ld d, a
    call DrawBank3MetaspriteFar

BugHunt_AdvanceBugSlot::
    pop hl
    ld bc, $0008
    add hl, bc
    pop bc
    dec b
    jp nz, BugHunt_UpdateNextBug

    ld a, [wBugPhase]
    rst $00

Minigame2SecondaryStateHandlers::
    dw BugHunt_UpdatePlayerInput ; $00
    dw BugHunt_UpdateCatch ; $01
    dw BugHunt_UpdateHitReaction ; $02
    dw BugHunt_EmptyPhase ; $03
    dw BugHunt_UpdateResult ; $04

BugHunt_EmptyPhase::
    ret


BugHunt_UpdateSpecialBugMotion::
; Types 3 and 4 alternate timed phases. Type 3 also reads the signed Y wobble table.
    ld a, [hl]
    and $01
    jr z, BugHunt_TickSpecialBugDirectionPhase

    ld bc, $0005
    add hl, bc
    ld a, [hl]
    dec hl
    dec hl
    ld bc, BugHuntSpecialBugYOffsets
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, [bc]
    add [hl]
    ld [hl], a
    inc hl
    inc hl
    dec [hl]
    ret nz

    ld [hl], $20
    ld bc, -$0005
    add hl, bc
    inc [hl]
    ret


BugHunt_TickSpecialBugDirectionPhase::
    ld bc, $0005
    add hl, bc
    dec [hl]
    ld a, [hl]
    cp $10
    jr nz, BugHunt_WaitOrSwitchSpecialBugPhase

    inc hl
    inc [hl]
    ld e, [hl]
    bit 0, e
    ret nz

    ld bc, -$0005
    add hl, bc
    call ChooseScreenRandomThird
    dec a
    ld d, a
    ld a, e
    and $fc
    jr nz, BugHunt_StoreSpecialBugDirection

BugHunt_TryNextSpecialBugDirection::
    ld a, d
    inc a
    cp $02
    jr nz, BugHunt_SetDirectionProbeDelta

    ld a, $ff

BugHunt_SetDirectionProbeDelta::
    ld d, a
    add [hl]
    ld b, a
    push hl
    ld c, $3c
    bit 1, b
    jr nz, BugHunt_SelectDirectionProbeAxis

    ld c, $c4

BugHunt_SelectDirectionProbeAxis::
    inc hl
    bit 0, b
    jr nz, BugHunt_CheckDirectionProbeBounds

    inc hl

BugHunt_CheckDirectionProbeBounds::
    ld a, c
    add [hl]
    pop hl
    cp $0c
    jr c, BugHunt_TryNextSpecialBugDirection

    cp $88
    jr nc, BugHunt_TryNextSpecialBugDirection

BugHunt_StoreSpecialBugDirection::
    ld a, d
    add [hl]
    and $03
    ld [hl], a
    ret


BugHunt_WaitOrSwitchSpecialBugPhase::
    ld a, [hl]
    or a
    ret nz

    ld [hl], $10
    ld bc, -$0005
    add hl, bc
    dec [hl]
    ret


BugHunt_UpdatePlayerInput::
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, BugHunt_CheckMovementInput

    ld a, [wBugPlayerFacing]
    and $03
    ld hl, Minigame2ActionAnimationPointers
    rst $20
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $01
    ld [wBugPhase], a
    ld a, $11
    ld [wScreenFrameCounter], a
    ld a, $ff
    ld [wBugCatchType], a
    ret


BugHunt_CheckMovementInput::
    ldh a, [hJoyHeld]
    and $f0
    jr nz, BugHunt_ComputePlayerStep

    ld a, [wSceneAnim0Timer]
    inc a
    ld [wSceneAnim0Timer], a
    ret


BugHunt_ComputePlayerStep::
    ld bc, $0180
    ld a, [wBugPlayerStepFraction]
    add c
    ld [wBugPlayerStepFraction], a
    ld a, $00
    adc b
    ld c, a
    ld d, $00
    ld e, d
    ldh a, [hJoyHeld]
    ld h, a
    ld b, $ff
    bit 6, h
    jr z, BugHunt_CheckLeftInput

    ld b, $00
    ld a, $00
    sub c
    ld e, a

BugHunt_CheckLeftInput::
    bit 5, h
    jr z, BugHunt_CheckDownInput

    ld b, $01
    ld a, $00
    sub c
    ld d, a

BugHunt_CheckDownInput::
    bit 7, h
    jr z, BugHunt_CheckRightInput

    ld b, $02
    ld e, c

BugHunt_CheckRightInput::
    bit 4, h
    jr z, BugHunt_MovePlayerAndSetFacing

    ld b, $03
    ld d, c

BugHunt_MovePlayerAndSetFacing::
    ld a, [wBugPlayerX]
    add d
    ld [wBugPlayerX], a
    ld a, [wBugPlayerY]
    add e
    ld [wBugPlayerY], a
    ld a, [wBugPlayerFacing]
    ld hl, BugHuntFacingJoyMasks
    rst $38
    ld c, [hl]
    ldh a, [hJoyHeld]
    and c
    jr nz, BugHunt_ClampPlayerMinX

    ld a, b
    bit 7, a
    jr nz, BugHunt_ClampPlayerMinX

    ld [wBugPlayerFacing], a
    and $03
    ld hl, Minigame2IdleAnimationPointers
    rst $20
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

BugHunt_ClampPlayerMinX::
    ld a, [wBugPlayerX]
    cp $0a
    jr nc, BugHunt_ClampPlayerMaxX

    ld a, $0a

BugHunt_ClampPlayerMaxX::
    cp $95
    jr c, BugHunt_StoreXAndClampMinY

    ld a, $95

BugHunt_StoreXAndClampMinY::
    ld [wBugPlayerX], a
    ld a, [wBugPlayerY]
    cp $0a
    jr nc, BugHunt_ClampPlayerMaxY

    ld a, $0a

BugHunt_ClampPlayerMaxY::
    cp $75
    jr c, BugHunt_StorePlayerY

    ld a, $75

BugHunt_StorePlayerY::
    ld [wBugPlayerY], a
    ret


BugHunt_UpdateCatch::
    ld a, [wBugCatchType]
    bit 7, a
    jr z, BugHunt_TickCatchAnimation

    ld a, [wBugPlayerFacing]
    add a
    add a
    ld b, a
    add a
    add b
    ld hl, BugHuntCatchBounds
    rst $38
    ld a, [wScreenFrameCounter]
    ld bc, $0004
    cp $06
    jr nc, BugHunt_CheckLateCatchFrame

    add hl, bc

BugHunt_CheckLateCatchFrame::
    cp $0c
    jr nc, BugHunt_BuildCatchBounds

    add hl, bc

BugHunt_BuildCatchBounds::
    ld a, [wBugPlayerX]
    ld b, a
    ld a, [wBugPlayerY]
    ld c, a
    ld a, [hl+]
    add b
    ldh [hBugCatchMinX], a
    ld a, [hl+]
    add c
    ldh [hBugCatchMinY], a
    ld a, [hl+]
    add b
    ldh [hBugCatchMaxX], a
    ld a, [hl+]
    add c
    ldh [hBugCatchMaxY], a
    ld b, $10
    ld hl, wBugSlots

BugHunt_TestNextBugAgainstCatchBounds::
    push hl
    ld a, [hl+]
    bit 7, a
    jr nz, BugHunt_AdvanceCatchTestSlot

    inc hl
    ld c, [hl]
    ldh a, [hBugCatchMinX]
    cp c
    jr nc, BugHunt_AdvanceCatchTestSlot

    ldh a, [hBugCatchMaxX]
    cp c
    jr c, BugHunt_AdvanceCatchTestSlot

    inc hl
    ld c, [hl]
    ldh a, [hBugCatchMinY]
    cp c
    jr nc, BugHunt_AdvanceCatchTestSlot

    ldh a, [hBugCatchMaxY]
    cp c
    jr c, BugHunt_AdvanceCatchTestSlot

    dec hl
    dec hl
    dec hl
    ld a, [hl]
    cp $04
    jr nz, BugHunt_StoreCaughtType

    ld a, $03

BugHunt_StoreCaughtType::
    ld [wBugCatchType], a
    ld a, $80
    ld [hl], a
    pop hl
    jr BugHunt_TickCatchAnimation

BugHunt_AdvanceCatchTestSlot::
    pop hl
    ld a, $08
    rst $38
    dec b
    jr nz, BugHunt_TestNextBugAgainstCatchBounds

BugHunt_TickCatchAnimation::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    xor a
    ld [wBugPhase], a
    ld a, [wBugCatchType]
    bit 7, a
    jr nz, BugHunt_RestoreFacingAnimation

    ld [wBugLastCaughtType], a
    ld a, $44
    call PlaySound
    ld a, [wBugPlayerX]
    ld [wBugPopupX], a
    ld a, [wBugPlayerY]
    ld [wBugPopupY], a
    ld a, $20
    ld [wScreenPhaseCounter], a
    ld a, [wBugLastCaughtType]
    ld hl, BugHuntTypeScoreDigits
    rst $20
    ld b, l
    ld c, h
    ld hl, BugHuntRoundGoalTiles
    call Minigame_AddScoreAndCompareGoal
    jr c, BugHunt_RestoreFacingAnimation

    ld a, $04
    ld [wBugPhase], a
    xor a
    ld [wMinigameResultFlag], a
    ld a, $90
    ld [wScreenFrameCounter], a
    xor a
    ld [wBugHazardSlots + BUG_HAZARD_OFS_AIM_REFRESH], a
    ld [wBugHazardSlots + BUG_HAZARD_SIZE + BUG_HAZARD_OFS_AIM_REFRESH], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


BugHunt_RestoreFacingAnimation::
    ld a, [wBugPlayerFacing]
    and $03
    ld hl, Minigame2IdleAnimationPointers
    rst $20
    ld a, $04
    rst $38
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ret


BugHunt_DrawCaughtBugPopup::
    ld a, [wScreenPhaseCounter]
    or a
    ret z

    ld a, [wScreenPhaseCounter]
    dec a
    ld [wScreenPhaseCounter], a
    srl a
    ld hl, BugHuntCaughtPopupXOffsets
    rst $38
    ld a, [wBugPopupX]
    add [hl]
    ld c, a
    ld a, [wScreenPhaseCounter]
    srl a
    sub $18
    ld b, a
    ld a, [wBugPopupY]
    add b
    ld b, a
    ld hl, BugHuntCaughtPopupFrames
    ld a, [wBugLastCaughtType]
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteNormal
    ret


Minigame_AddScoreAndCompareGoal::
; B=tens and C=ones to add. HL points to goal tiles by round. Returns carry if the score is below the goal.
    push hl
    ld hl, wMinigameScoreOnes
    ld a, c
    add [hl]
    ld [hl-], a
    dec de
    ld a, b
    add [hl]
    ld [hl+], a
    ld a, [hl]
    cp $0e
    jr c, Minigame_CarryScoreTens

    sub $0a
    ld [hl-], a
    inc [hl]
    inc hl

Minigame_CarryScoreTens::
    dec hl
    ld a, [hl]
    cp $0e
    jr c, Minigame_SelectScoreHudDigits

    sub $0a
    ld [hl-], a
    inc [hl]

Minigame_SelectScoreHudDigits::
    ld de, wMinigameScoreHundreds
    ld hl, _SCRN0 + $221
    ld b, $03

Minigame_SkipLeadingScoreZeros::
    ld a, [de]
    cp $04
    jr nz, Minigame_DrawScoreAndLoadGoal

    inc hl
    inc de
    dec b
    jr nz, Minigame_SkipLeadingScoreZeros

Minigame_DrawScoreAndLoadGoal::
    ld c, $01
    call QueueTilemapRect
    ld a, [wMinigameRound]
    ld b, a
    add a
    add b
    pop hl
    rst $38
    ld de, wMinigameScoreHundreds
    ld b, $03

Minigame_CompareNextScoreDigit::
    ld a, [de]
    sub [hl]
    ret c

    jr nz, Minigame_ScoreAtLeastGoal

    inc de
    inc hl
    dec b
    jr nz, Minigame_CompareNextScoreDigit

Minigame_ScoreAtLeastGoal::
    or a
    ret


BugHunt_UpdateResult::
    ld a, [wScreenFrameCounter]
    cp $60
    jr nz, BugHunt_WaitForResultConfirm

    ld a, [wMinigameResultFlag]
    or a
    jr nz, BugHunt_WaitForResultConfirm

    ld hl, SceneAnim_794b
    ld a, [wMinigameRound]
    cp $0a
    jr nz, BugHunt_StartWinAnimation

    ld hl, SceneAnim_796e

BugHunt_StartWinAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

BugHunt_WaitForResultConfirm::
    ld a, [wMinigamePhaseCounter]
    inc a
    ld [wMinigamePhaseCounter], a
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    ld a, $01
    ld [wScreenFrameCounter], a
    ldh a, [hJoyHeld]
    bit 0, a
    ret z

    ld hl, wMinigameUnlockedRounds + 1
    jp AdvanceMinigameRoundOrExit


BugHunt_UpdateHitReaction::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    xor a
    ld [wBugPhase], a
    ld a, $c0
    ld [wBugPlayerBlinkTimer], a
    jp BugHunt_RestoreFacingAnimation


BugHunt_UpdateRoundHazards::
    ld hl, wBugHazardSlots
    ld de, BugHuntFirstHazardFrames
    ld a, [wMinigameRound]
    cp $04
    call nc, BugHunt_UpdateHazard
    ld hl, wBugHazardSlots + BUG_HAZARD_SIZE
    ld de, BugHuntSecondHazardFrames
    ld a, [wMinigameRound]
    cp $07
    call nc, BugHunt_UpdateHazard
    ret


BugHunt_UpdateHazard::
; HL points to an eight-byte hazard record. DE points to its directional metasprite IDs.
    ld a, [hl+]
    or a
    jp nz, BugHunt_UpdateHazardRespawn

    push de
    ld c, $00
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [wBugPlayerX]
    add $08
    sub b
    jr nc, BugHunt_SaveHazardAbsXDelta

    cpl
    inc a
    set 0, c

BugHunt_SaveHazardAbsXDelta::
    ldh [hBugHazardAimAbsX], a
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [wBugPlayerY]
    add $08
    sub b
    jr nc, BugHunt_CheckHazardAimRefresh

    cpl
    inc a
    set 1, c

BugHunt_CheckHazardAimRefresh::
    ldh [hBugHazardAimAbsY], a
    push hl
    inc hl
    ld a, [hl]
    or a
    jr z, BugHunt_LoadCachedHazardAim

    dec a
    ld [hl+], a
    ldh a, [hBugHazardAimAbsX]
    ld [hl+], a
    ldh a, [hBugHazardAimAbsY]
    ld [hl+], a
    ld [hl], c
    jr BugHunt_SelectHazardMotionDirection

BugHunt_LoadCachedHazardAim::
    inc hl
    ld a, [hl+]
    ldh [hBugHazardAimAbsX], a
    ld a, [hl+]
    ldh [hBugHazardAimAbsY], a
    ld c, [hl]

BugHunt_SelectHazardMotionDirection::
    pop hl
    ldh a, [hBugHazardAimAbsX]
    ld b, a
    ldh a, [hBugHazardAimAbsY]
    cp b
    jr c, BugHunt_SelectHorizontalHazardFacing

    ld b, $00
    bit 1, c
    jr nz, BugHunt_SelectHazardFlip

    ld b, $02
    jr BugHunt_SelectHazardFlip

BugHunt_SelectHorizontalHazardFacing::
    ld b, $01
    bit 0, c
    jr nz, BugHunt_SelectHazardFlip

    ld b, $03

BugHunt_SelectHazardFlip::
    ld a, b
    cp $01
    jr z, BugHunt_SelectHazardFrameAndStep

    xor a

BugHunt_SelectHazardFrameAndStep::
    ldh [hSpriteFlags], a
    pop de
    ld a, b
    rst $30
    ld a, [de]
    ldh [hBugHazardMetasprite], a
    ld d, $00
    ld e, d
    ld a, [hl]
    ld b, a
    ldh a, [hBugHazardAimAbsY]
    cp b
    jr c, BugHunt_StepHazardHorizontally

    ldh a, [hBugHazardAimAbsX]
    add b
    ld [hl], a
    ld e, $01
    bit 1, c
    jr z, BugHunt_ApplyHazardPositionDelta

    ld e, $ff
    jr BugHunt_ApplyHazardPositionDelta

BugHunt_StepHazardHorizontally::
    ldh a, [hBugHazardAimAbsY]
    ld b, a
    ld a, [hl]
    sub b
    ld [hl], a
    ld d, $01
    bit 0, c
    jr z, BugHunt_ApplyHazardPositionDelta

    ld d, $ff

BugHunt_ApplyHazardPositionDelta::
    dec hl
    ld a, [hl]
    add e
    ld b, a
    ld [hl-], a
    ld a, [hl]
    add d
    ld c, a
    ld [hl-], a
    push bc
    ld a, c
    add $08
    cp $f0
    jr nc, BugHunt_StartHazardRespawnTimer

    ld a, b
    add $08
    cp $f0
    jr c, BugHunt_TestHazardPlayerOverlap

BugHunt_StartHazardRespawnTimer::
    call AdvanceScreenRandomByte
    and $03
    add $03
    ld [hl+], a
    ld [hl-], a

BugHunt_TestHazardPlayerOverlap::
    pop bc
    push bc
    ld a, [wBugPlayerX]
    add $0e
    sub c
    cp $1c
    jr nc, BugHunt_SelectHazardWingFrame

    ld a, [wBugPlayerY]
    add $0e
    sub b
    cp $1c
    jr nc, BugHunt_SelectHazardWingFrame

    ld bc, $0004
    add hl, bc
    xor a
    ld [hl], a
    ld a, [wBugPhase]
    cp $02
    jr nc, BugHunt_SelectHazardWingFrame

    ld a, [wBugPlayerBlinkTimer]
    or a
    jr nz, BugHunt_SelectHazardWingFrame

    ld hl, SceneAnim_7967
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $c0
    ld [wScreenFrameCounter], a
    ld a, $02
    ld [wBugPhase], a

BugHunt_SelectHazardWingFrame::
    pop bc
    ldh a, [hBugHazardMetasprite]
    ld d, a
    ld a, [wBugHazardFrameCounter]
    bit 3, a
    jr nz, BugHunt_DrawHazard

    inc d

BugHunt_DrawHazard::
    call DrawBank3MetaspriteFar
    ret


BugHunt_UpdateHazardRespawn::
    ld a, [wSharedWork + $f2] ; The resulting comparison only updates B. No caller uses that result.
    ld b, a
    call ChooseScreenRandomThird
    add [hl]
    cp b
    jr z, BugHunt_WrapHazardSpawnIndex

    inc b

BugHunt_WrapHazardSpawnIndex::
    cp $0c
    jr c, BugHunt_TickHazardRespawnTimer

    sub $0c

BugHunt_TickHazardRespawnTimer::
    ld [hl], a
    ld a, [wMinigamePhaseCounter]
    cp $01
    ret nz

    dec hl
    dec [hl]
    ret nz

    xor a
    ld [hl+], a
    ld a, [hl]
    add a
    ld de, BugHuntHazardRespawnPositions
    rst $30
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $80
    ld [hl+], a
    ret



BugHuntHudTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $85, $86, $87, $91, $91, $91, $91, $91, $80, $81, $91, $91, $91, $91, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

BugHuntRoundGoalTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $04, $04, $04, $0c, $04, $05, $05, $04, $05, $08, $04, $05, $0b, $04, $06
    db $04, $04, $06, $07, $04, $06, $0a, $04, $06, $0d, $04, $07, $06, $04, $07, $09
    db $04

BugHuntSpawnGates::
; VRAM address, then X and Y for the spawned bug.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    dw _SCRN0 + $04b
    db $64, $14
    dw _SCRN0 + $0a2
    db $1c, $2c
    dw _SCRN0 + $12f
    db $84, $4c
    dw _SCRN0 + $1c5
    db $34, $74

BugHuntGateBaseTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $88, $89, $8a

BugHuntGateBlinkTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $8b, $8c, $8d

BugHuntGateDirectionChoices::
; Three movement axis/sign combinations per gate.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $01, $02, $03, $02, $03, $00, $00, $01, $02, $00, $03, $01

BugHuntRoundSpawnWeights::
; Four weights per round with a total of eight.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $02, $01, $01, $04, $02, $01, $01, $03, $02, $02, $01, $03, $02, $02, $01
    db $02, $03, $02, $01, $02, $03, $02, $01, $02, $02, $03, $01, $02, $02, $03, $01
    db $01, $02, $03, $02, $01, $02, $02, $03

BugHuntMotionSteps::
; Signed-axis motion uses these unsigned 8.8 magnitudes.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $60, $00, $b0, $00, $00, $01, $e0, $01, $00, $00

BugHuntTypeScoreDigits::
; Tens and ones score increments per caught type.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $05, $01, $00, $01, $05, $02, $00

BugHuntBugFrames::
; Eight frame selectors per type. Bit 7 flips the metasprite.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $33, $4f, $34, $b4, $33, $4f, $34, $b4, $50, $51, $b7, $b8, $35, $36, $37, $38
    db $4c, $cc, $ad, $ae, $2c, $ac, $2d, $2e, $ce, $ce, $b2, $b2, $30, $30, $32, $32
    db $cd, $cd, $b1, $b1, $2f, $2f, $31, $31

BugHuntFirstHazardFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $42, $40, $3e, $40

BugHuntSecondHazardFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $4a, $48, $46, $48

; Indexed screen data; scene-specific interpretation is documented at its consumer.

Minigame2IdleAnimationPointers::
    dw SceneAnim_793d
    dw SceneAnim_792f
    dw SceneAnim_7913
    dw SceneAnim_7921

Minigame2ActionAnimationPointers::
    dw SceneAnim_7944
    dw SceneAnim_7936
    dw SceneAnim_791a
    dw SceneAnim_7928

Minigame2ActionOffsets::
    db $00, $ee, $ee, $00, $00, $12, $12, $00

BugHuntCatchBounds::
; Four directions, three animation phases, four signed offsets per rectangle.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $f6, $0c, $0a, $1e, $f6, $f4, $0a, $0c, $f6, $e0, $0a, $f4, $00, $dc, $14, $f0
    db $e4, $e8, $00, $fd, $e4, $fd, $f8, $08, $f6, $dd, $0a, $f4, $f6, $f4, $0a, $0c
    db $f6, $0c, $0a, $1b, $ec, $dc, $00, $f0, $00, $e8, $1c, $fd, $08, $fd, $1c, $08

BugHuntFacingJoyMasks::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $40, $20, $80, $10

BugHuntCaughtPopupXOffsets::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $03, $02, $02, $01, $00, $ff, $fe, $fe, $fe, $fe, $fe, $ff, $00, $01, $02, $02

BugHuntCaughtPopupFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $3c, $3b, $3a, $3d

BugHuntSpecialBugYOffsets::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $03, $03, $02, $03, $02, $01, $01, $00, $00, $ff, $ff, $fe, $fd, $fe, $fd
    db $fd

BugHuntInitialHazardRecords::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $20, $48, $00, $00, $01, $00, $01, $00, $80, $48, $00, $00, $01, $00, $00

BugHuntHazardRespawnPositions::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $f8, $74, $f8, $48, $f8, $1c, $1c, $f8, $48, $f8, $74, $f8, $a8, $1c, $a8, $48
    db $a8, $74, $74, $a8, $48, $a8, $1c, $a8

InitStageTransitionScreens::
; State 4: stage intro, continue/game-over, story, or stage dialogue.
    xor a
    ldh [hNeedsReset], a
    ld a, $83
    ld [wLCDCShadow], a
    ld a, $a0
    ldh [hOamMaxY], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, [wScreenSubstate]
    rst $00

StageSceneInitHandlers::
    dw InitStageIntroScreen ; $00
    dw InitContinueScreen ; $01
    dw InitStoryScreen ; $02
    dw InitStageDialogueScreen ; $03

InitStageIntroScreen::
; State 4, substate 0.
    call InitSound
    ld a, $14
    call PlaySound_Queue3
    ld a, [wSgbEnabled]
    or a
    jr z, StageIntro_LoadScreenGraphics

    call DelayFramesOrCycles
    ld hl, SgbPacket_StageIntroSetAttributeFile
    call SendSgbPacket
    call DelayFramesOrCycles
    call UpdateSgbBorderColorModeFar
    xor a
    ldh [rBGP], a
    call DisableLCD

StageIntro_LoadScreenGraphics::
    ld a, $83
    ld [wLCDCShadow], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $800
    ld bc, $0200
    call BankedMemcpy
    ld a, BANK(GfxRle_b06_6156)
    ld hl, GfxRle_b06_6156
    ld de, _VRAM + $a00
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    xor a
    ldh [hTileStreamWritePos], a
    call BuildMenuPatternBackground
    ld a, $8f
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $023
    ld bc, $0c04
    call DrawTilemapBox
    ld de, StageIntroBackgroundStencil
    ld hl, _SCRN0 + $164
    call ClearSgbTilemapStencil16x7
    xor a
    ld [wScreenFrameCounter], a
    ld [wScreenPhaseCounter], a
    ld a, $82
    ld [wMessageFlags], a
    ld a, [wAlternateModeFlags]
    ld b, a
    ld a, [wStageSceneIndex]
    add b
    inc a
    ld [wMsgSubstitutionId], a
    ld a, $33
    call StartMessageFar
    ld a, $02
    ld [wMessageFlags], a
    ld a, [wStageSceneIndex]
    add $15
    call StartMessageFar
    ld a, $05
    ld [wScreenPaletteId], a
    ld a, [wSgbEnabled]
    or a
    ret z

    call ApplyLCDC
    call DelayFramesOrCycles
    call DisableLCD
    ld hl, SgbPacket_StageIntroResetAttributeFile
    call SendSgbPacket
    call DelayFramesOrCycles
    ret



SgbPacket_StageIntroSetAttributeFile::
    db $b9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_StageIntroResetAttributeFile::
    db $b9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

InitStoryScreen::
; State 4, substate 2.
    ld a, BANK(LayoutRle_b06_762c)
    ld hl, LayoutRle_b06_762c
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound
    ld a, $20
    call PlaySound_Queue3
    ld a, $81
    ld [wMessageFlags], a
    ld a, [wStageSceneIndex]
    add $1c
    call StartMessageFar
    ld a, $08
    ld [wMessageCharPeriod], a
    ld a, $06
    ld [wScreenPaletteId], a
    ret


UpdateStageTransitionScreens::
; State 4 update.
    ld a, [wScreenSubstate]
    rst $00

StageSceneUpdateHandlers::
    dw UpdateStageIntroScreen ; $00
    dw UpdateContinueScreen ; $01
    dw UpdateStoryScreen ; $02
    dw UpdateStageDialogueScreen ; $03

UpdateStoryScreen::
; State 4, substate 2.
    ld bc, $1838
    ld d, $b1
    call DrawBank3MetaspriteNormal
    call UpdateMessageFar
    ldh a, [hJoyPressed]
    bit 3, a
    jp nz, StageScene_DoubleIndexAndAdvance

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, Story_WaitForMessageCompletion

    ld a, $02
    ld [wMessageCharPeriod], a

Story_WaitForMessageCompletion::
    ld a, [wMessageState]
    or a
    ret nz

    ld hl, _SCRN0 + $1d0
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    bit 4, a
    ld a, $00
    jr z, Story_DrawBlinkingContinueMarker

    ld a, $81

Story_DrawBlinkingContinueMarker::
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    jp RequestSavedMenuDestination


UpdateStageIntroScreen::
; State 4, substate 0.
    ld bc, _VRAM + $1080
    ld d, $b2
    call DrawBank3MetaspriteNormal
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    cp $ff
    jr z, StageIntro_RequestStoryScreen

    ldh a, [hJoyPressed]
    bit 0, a
    ret z

StageIntro_RequestStoryScreen::
    xor a
    ld [wMessageState], a
    ld [wVramQueue], a
    ld a, $02
    ld [wScreenSubstate], a
    ldh [hNeedsReset], a
    ret



StageIntroBackgroundStencil::
    db $0e, $00, $df, $00, $ff, $00, $3f, $00, $3e, $00, $3e, $00, $1e, $00
InitContinueScreen::
; State 4, substate 1; game over when no continues remain.
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $07
    ld [wScreenPaletteId], a
    ld a, BANK(GfxRle_b06_641e)
    ld hl, GfxRle_b06_641e
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_663c)
    ld hl, GfxRle_b06_663c
    ld de, _VRAM + $800
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_6801)
    ld hl, LayoutRle_b06_6801
    ld de, wStageLayoutMap
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call InitSound
    ld a, $10
    call PlaySound_Queue3
    ld a, [wContinuesRemaining]
    or a
    jr z, Continue_InitRemainingCount

    ld a, $02
    ld [wMessageFlags], a
    ld a, $69
    call StartMessageFar
    ld a, $02
    ld [wMessageFlags], a
    ld a, $6a
    call StartMessageFar

Continue_InitRemainingCount::
    ld a, [wContinuesRemaining]
    ld [wMsgSubstitutionId], a
    ld a, $02
    ld [wMessageFlags], a
    ld a, $19
    call StartMessageFar
    ld hl, SceneAnim_ContinueIdle
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wContinueChoice], a
    ld [wContinuePhase], a
    ld [wScreenPhaseCounter], a
    ld [wContinueGameOverDelay], a
    cpl
    ld [wContinueFacingCache], a
    ld a, $50
    ld [wContinueActorX], a
    ret


UpdateContinueScreen::
; State 4, substate 1; animate SGB palettes and dispatch the continue-menu phase.
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $0f
    jr nz, Continue_DrawActorAndDispatchPhase

    ld a, [wSgbEnabled]
    or a
    jr z, Continue_DrawActorAndDispatchPhase

    ld hl, wSgbPalSetPacket
    ld de, ContinuePalettePacketTemplate
    ld b, $10

Continue_CopyPalettePacket::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, Continue_CopyPalettePacket

    ld a, [wScreenPhaseCounter]
    swap a
    and $03
    add a
    add a
    ld hl, ContinuePaletteColorPairs
    rst $38
    ld a, [hl+]
    ld [wSgbPalSetPacket + 3], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 4], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 5], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 6], a
    ld hl, wSgbPalSetPacket
    call SendSgbPacket

Continue_DrawActorAndDispatchPhase::
    ld a, [wContinueActorX]
    ld c, a
    ld b, $58
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateMessageFar
    ld a, [wContinuePhase]
    rst $00
ContinueMenuPhaseHandlers::
    dw ContinueMenu_WaitForChoice ; $00
    dw ContinueMenu_UpdateAcceptedMotion ; $01
    dw ContinueMenu_UpdateExitMotion ; $02
ContinueMenu_WaitForChoice::
    ld a, [wContinuesRemaining]
    or a
    jr nz, Continue_CheckChoiceConfirm

    ld a, [wContinueGameOverDelay]
    inc a
    ld [wContinueGameOverDelay], a
    cp $a0
    jr z, Continue_BeginExitAnimation

    jp ContinueMenu_UpdateFacingIndicator


Continue_CheckChoiceConfirm::
    ldh a, [hJoyPressed]
    and $09
    jr z, Continue_UpdateChoiceCursor

    ld a, [wContinueChoice]
    bit 0, a
    jr nz, Continue_BeginExitAnimation

    ld a, $01
    ld [wContinuePhase], a
    ld hl, SceneAnim_ContinueAccepted
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld hl, $00e0
    ld a, l
    ld [wContinueAcceptedVelocityLo], a
    ld a, h
    ld [wContinueAcceptedVelocityHi], a
    ld hl, ContinueAcceptedMotionScript
    ld a, [hl+]
    ld [wScreenFrameCounter], a
    ld a, l
    ld [wContinueMotionPtrLo], a
    ld a, h
    ld [wContinueMotionPtrHi], a
    ld a, [wContinuesRemaining]
    dec a
    ld [wContinuesRemaining], a
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $19
    call StartMessageFar

ContinueMenu_ClearChoiceText::
    ld bc, _SCRN0 + $0c7
    ld de, $0006
    call QueueVramFill
    ld bc, _SCRN0 + $0e7
    ld de, $0006
    call QueueVramFill
    ret


Continue_BeginExitAnimation::
    ld a, $02
    ld [wContinuePhase], a
    xor a
    ld [wSceneAnim1Timer], a
    ld [wContinueExitActorXSubpixel], a
    ld a, $b0
    ld [wContinueExitActorX], a
    ld hl, SceneAnim_ContinueExit
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    ret


Continue_UpdateChoiceCursor::
    ld a, [wContinueChoice]
    ld hl, _SCRN0 + $187
    bit 0, a
    jr z, Continue_ErasePreviousCursor

    ld hl, _SCRN0 + $1c7

Continue_ErasePreviousCursor::
    xor a
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    and $c4
    jr z, Continue_SelectCursorDestination

    ld a, [wContinueChoice]
    cpl
    ld [wContinueChoice], a
    ld a, $40
    call PlaySound

Continue_SelectCursorDestination::
    ld a, [wContinueChoice]
    ld hl, _SCRN0 + $187
    bit 0, a
    jr z, Continue_DrawChoiceCursor

    ld hl, _SCRN0 + $1c7

Continue_DrawChoiceCursor::
    ld a, $0e
    call QueueTilemapByte

ContinueMenu_UpdateFacingIndicator::
    ld a, [wContinueFacingCache]
    and $80
    ld b, a
    ld a, [wSceneAnim0Timer]
    and $80
    cp b
    jr z, Continue_FacingUnchanged

    xor a
    ld [wMessageFlags], a
    ld a, [wSceneAnim0Timer]
    ld [wContinueFacingCache], a
    bit 7, a
    ld a, $1a
    jr z, Continue_ShowFacingMessage

    ld a, $1b

Continue_ShowFacingMessage::
    call StartMessageFar
    ld bc, _SCRN0 + $0c7
    ld de, $0006
    call QueueVramFill

Continue_FacingUnchanged::
    ret


ContinueMenu_UpdateAcceptedMotion::
    ld hl, wContinueMotionPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wContinueAcceptedVelocityLo]
    ld c, a
    ld a, [wContinueAcceptedVelocityHi]
    ld b, a
    ld e, [hl]
    ld d, $00
    bit 7, e
    jr z, Continue_AccumulateAcceptedVelocity

    ld d, $ff

Continue_AccumulateAcceptedVelocity::
    ld a, c
    add e
    ld c, a
    ld a, b
    adc d
    ld b, a
    ld a, c
    ld [wContinueAcceptedVelocityLo], a
    ld a, b
    ld [wContinueAcceptedVelocityHi], a
    call ContinueMenu_AddSignedMotionDelta
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    inc hl
    ld a, [hl+]
    ld [wScreenFrameCounter], a
    cp $ff
    jr z, Continue_RequestGameplay

    ld a, l
    ld [wContinueMotionPtrLo], a
    ld a, h
    ld [wContinueMotionPtrHi], a
    ret


Continue_RequestGameplay::
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


ContinueMenu_AddSignedMotionDelta::
    ld a, [wContinueActorXSubpixel]
    add c
    ld [wContinueActorXSubpixel], a
    ld a, [wContinueActorX]
    adc b
    ld [wContinueActorX], a
    ret


ContinueMenu_UpdateExitMotion::
    ld a, [wContinueExitActorX]
    and $1f
    cp $01
    jr nz, Continue_MoveExitActor

    ld a, $5b
    call PlaySound

Continue_MoveExitActor::
    ld bc, -$00e0 ; Signed scene motion delta, not a hardware register.
    ld a, [wContinueExitActorXSubpixel]
    add c
    ld [wContinueExitActorXSubpixel], a
    ld a, [wContinueExitActorX]
    or a
    ; Original zero-count path enters the high byte of the JP operand below.
    jr z, Continue_CheckExitActorPassed + 2

    adc b
    ld [wContinueExitActorX], a
    ld a, [wContinueExitActorX]
    ld c, a
    ld b, $58
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld a, [wContinueExitActorX]
    cp $40
    jr nz, Continue_CheckExitActorPassed

    ld hl, SceneAnim_ContinueExitReaction
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    jp ContinueMenu_ClearChoiceText


Continue_CheckExitActorPassed::
; Entry + 2 is the original jump into the JP operand when the exit actor X is zero.
    jp nc, ContinueMenu_UpdateFacingIndicator

    ld bc, -$00e0 ; Signed scene motion delta, not a hardware register.
    call ContinueMenu_AddSignedMotionDelta
    ld a, [wContinueActorX]
    cp $b0
    ret nz

    ld bc, $0001
    ld de, $0001
    jp RequestStateChange_Menu


    ret



ContinueAcceptedMotionScript::
; Duration and signed velocity delta pairs. The last duration is $ff.
    db $30, $00, $1a, $f0, $30, $00, $2a, $10, $47, $00, $ff

ContinuePalettePacketTemplate::
    db $01, $bd, $77, $f1, $7a, $8a, $4d, $00, $00, $3f, $33, $d3, $36, $00, $00, $00

ContinuePaletteColorPairs::
; Four pairs of little-endian colors copied to bytes 3 through 6 of the packet.
    db $f1, $7a, $4d, $8a, $bf, $5a, $3f, $01, $f3, $4f, $a1, $21, $bf, $5a, $3f, $01

InitStageDialogueScreen::
; State 4, substate 3; scene index / 2 selects the stage picture.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [wScreenFrameCounter], a
    ld [wScreenPhaseCounter], a
    ld [wStageDialogueHighlightApplied], a
    ld a, [wStageSceneIndex]
    bit 0, a
    jr z, StageDialogue_LoadSceneGraphics

    call InitSound
    ld a, $20
    call PlaySound_Queue3

StageDialogue_LoadSceneGraphics::
    ld a, BANK(GfxRle_b06_7700)
    ld hl, GfxRle_b06_7700
    ld de, _VRAM
    call LoadMaskedGfx
    ld hl, StageDialogueSceneGfxPointers
    ld a, [wStageSceneIndex]
    srl a
    rst $20
    ld de, _VRAM + $600
    ld a, $06
    call LoadMaskedGfx
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $e00
    ld bc, $0200
    call BankedMemcpy
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, $60
    ldh [hTileStreamWritePos], a
    call BuildMenuPatternBackground
    ld a, $ef
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $021
    ld bc, $1007
    call DrawTilemapBox
    ld a, [wStageSceneIndex]
    ld c, $0e
    call MultiplyBCByA8bit
    ld bc, StageDialogueBackgroundStencils
    add hl, bc
    ld d, h
    ld e, l
    ld hl, _SCRN0 + $162
    call ClearSgbTilemapStencil16x7
    ld a, [wStageSceneIndex]
    ld hl, StageDialogueScriptPointers
    rst $20
    ld a, l
    ld [wStageDialogueScriptPtrLo], a
    ld a, h
    ld [wStageDialogueScriptPtrHi], a
    ld a, $ff
    ld [wStageDialogueAnimSelectors], a
    ld [wStageDialogueAnimSelectors + 1], a
    ld [wStageDialogueAnimSelectors + 2], a
    xor a
    ldh [hTileStreamCount], a
    call StartNextStageDialogueMessage
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, [wStageSceneIndex]
    srl a
    jr nc, StageDialogue_StoreScenePalette

    add $08

StageDialogue_StoreScenePalette::
    add $08
    ld [wScreenPaletteId], a
    ret


UpdateStageDialogueScreen::
; State 4, substate 3.
    call UpdateStageDialogueHighlights
    ld a, [wStageSceneIndex]
    cp $07
    jr z, StageDialogue_DrawActors

    ldh a, [hJoyPressed]
    bit 3, a
    jp nz, StageScene_AdvanceOrResumeGameplay

StageDialogue_DrawActors::
    ld de, wStageDialogueAnimSelectors
    ld b, $03

StageDialogue_DrawNextActor::
    push bc
    ld a, b
    dec a
    ld hl, StageDialogueActorXPositions
    rst $38
    ld c, [hl]
    ld a, [de]
    inc de
    push de
    cp $40
    jr c, StageDialogue_DrawAnimatedActor

    cp $7f
    jr z, StageDialogue_AdvanceDrawSlot

    ld d, a
    ld b, $88
    call DrawBank3MetaspriteNormal
    jr StageDialogue_AdvanceDrawSlot

StageDialogue_DrawAnimatedActor::
    ld de, wSceneAnim0PtrLo
    ld a, b
    sla a
    add b
    sub $03
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld b, $88
    call AnimateSceneMetasprite

StageDialogue_AdvanceDrawSlot::
    pop de
    pop bc
    dec b
    jr nz, StageDialogue_DrawNextActor

    ld a, [wScreenPhaseCounter]
    cp $ff
    jr nz, StageDialogue_CheckFlashSound

    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenPhaseCounter], a

StageDialogue_CheckFlashSound::
    ld a, [wScreenPhaseCounter]
    cp $30
    jr nz, StageDialogue_CheckPaletteFlash

    ld a, $49
    call PlaySound_Queue1

StageDialogue_CheckPaletteFlash::
    ld a, [wScreenPhaseCounter]
    or a
    jr z, StageDialogue_UpdateMessage

    ld a, [wScreenPhaseCounter]
    bit 3, a
    ld a, $e4
    jr z, StageDialogue_ApplyPaletteFlash

    cpl

StageDialogue_ApplyPaletteFlash::
    ld [wPaletteBGP], a
    ld a, [wScreenPhaseCounter]
    dec a
    ld [wScreenPhaseCounter], a
    ret


StageDialogue_UpdateMessage::
    call UpdateMessageFar
    ld hl, _SCRN0 + $111
    ld a, [wScreenFrameCounter]
    bit 4, a
    ld a, $00
    jr z, StageDialogue_DrawAdvanceMarker

    ld a, $e1

StageDialogue_DrawAdvanceMarker::
    call QueueTilemapByte
    ld a, [wStageSceneIndex]
    cp $07
    jr z, StageDialogue_WaitForMessageEnd

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, StageDialogue_WaitForMessageEnd

    ld a, $02
    ld [wMessageCharPeriod], a

StageDialogue_WaitForMessageEnd::
    ld a, [wMessageState]
    or a
    ret nz

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, StageDialogue_AdvanceAfterInput

    ld a, [wStageDialogueAdvanceStep]
    or a
    ret z

StageDialogue_AdvanceAfterInput::
    ld a, [wStageDialogueAdvanceStep]
    inc a
    ld [wStageDialogueAdvanceStep], a
    ldh [hTileStreamCount], a
    cp $05
    jp z, StartNextStageDialogueMessage

    jr c, StageDialogue_PrepareTextEraseRows

    ret


StageDialogue_PrepareTextEraseRows::
    dec a
    add a
    ld h, a
    ld l, $02

StageDialogue_EraseNextTextRow::
    ld bc, _SCRN0 + $022
    ld de, $e210
    ld a, h
    or a
    jr z, StageDialogue_QueueTextEraseRow

    ld d, $00

StageDialogue_QueueTextEraseRow::
    swap a
    and $f0
    add a
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    push hl
    call QueueVramFill
    pop hl
    inc h
    dec l
    jr nz, StageDialogue_EraseNextTextRow

    xor a
    ret


UpdateStageDialogueHighlights::
    ld a, [wSgbEnabled]
    or a
    ret z

    ld a, [wStageDialogueHighlightApplied]
    or a
    ret nz

    ld a, [wStageSceneIndex]
    cp $07
    jr nz, StageDialogue_CheckHiddenActorHighlight

    ld a, [wStageDialogueAnimSelectors]
    cp $7f
    jr z, StageDialogue_CheckHiddenActorHighlight

    ld hl, SgbPacket_DialogueFinalSceneHighlight
    call SendSgbPacket
    ld hl, StageDialogueFinalSceneVramQueue
    call GetVramQueueTailDE
    ld b, $0d

StageDialogue_CopyFinalSceneQueue::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, StageDialogue_CopyFinalSceneQueue

    ldh a, [hVramQueuePos]
    add $0c
    ldh [hVramQueuePos], a
    ld a, $01
    ld [wStageDialogueHighlightApplied], a
    ret


StageDialogue_CheckHiddenActorHighlight::
    ld hl, StageDialogueHiddenActorSlots
    ld a, [wStageSceneIndex]
    rst $38
    ld a, [hl]
    bit 7, a
    ret nz

    ld b, a
    ld hl, wStageDialogueAnimSelectors
    rst $38
    ld a, [hl]
    cp $7f
    ret nz

    ld a, b
    push af
    ld hl, StageDialogueSgbPacketPointers
    rst $20
    call SendSgbPacket
    pop af
    ld hl, StageDialogueVramQueuePointers
    rst $20
    call GetVramQueueTailDE
    ldh a, [hVramQueuePos]
    ld b, a

StageDialogue_CopyActorHighlightQueue::
    ld a, [hl+]
    ld [de], a
    inc de
    inc b
    or a
    jr nz, StageDialogue_CopyActorHighlightQueue

    dec b
    ld a, b
    ldh [hVramQueuePos], a
    ld a, $01
    ld [wStageDialogueHighlightApplied], a
    ret


StartNextStageDialogueMessage::
; Consume one five-byte dialogue record and optional FE control-write descriptor.
    xor a
    ld [wStageDialogueAdvanceStep], a
    ld [wScreenFrameCounter], a
    ld a, $08
    ld [wMessageCharPeriod], a
    ld hl, wStageDialogueScriptPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wStageSceneIndex]
    srl a
    inc a
    ld d, a
    ld a, [wAlternateModeFlags]
    add d
    ld [wMsgSubstitutionId], a
    ld a, $e1
    ld [wMessageFlags], a
    ld a, [hl+]
    cp $ff
    jp z, StageScene_AdvanceOrResumeGameplay

    ld b, a
    push hl
    cp $29
    jr nz, StageDialogue_StartSelectedMessage

    ld a, [wSpecialModeFlags]
    or a
    jr z, StageDialogue_PreparePasswordLine

    ld b, $3c

StageDialogue_PreparePasswordLine::
    ld a, $e0
    ld [wMessageFlags], a
    ld hl, PasswordCodeTable - $14
    ld a, [wStageSceneIndex]
    srl a
    inc a
    ld d, a
    ld a, [wAlternateModeFlags]
    add d
    ld d, a
    ld a, [wSpecialModeFlags]
    or a
    ld a, $00
    jr z, StageDialogue_ApplyPasswordGroupOffset

    ld a, $04

StageDialogue_ApplyPasswordGroupOffset::
    add d
    ld de, $0014

StageDialogue_AdvancePasswordRecord::
    add hl, de
    dec a
    jr nz, StageDialogue_AdvancePasswordRecord

    push bc
    ld e, l
    ld d, h
    ld hl, PasswordCodeLengths
    ld a, [wStageSceneIndex]
    srl a
    rst $38
    ld b, [hl]
    inc b
    srl b
    ld hl, _SCRN0 + $0ca
    ld a, l
    sub b
    ld l, a
    ld bc, $0a02
    call QueueTilemapRect
    call InitSound
    ld a, $64
    call PlaySound_Queue3
    pop bc

StageDialogue_StartSelectedMessage::
    ld a, b
    call StartMessageFar
    pop hl
    ld a, [hl+]
    ldh [hStageDialogueSpeakerMask], a
    ld b, $03
    ld de, wStageDialogueAnimSelectors

StageDialogue_UpdateActorSelector::
    ld a, [de]
    ld c, a
    ld a, [hl+]
    cp c
    jr z, StageDialogue_NextActorSlot

    ld [de], a
    cp $40
    jr nc, StageDialogue_NextActorSlot

    push hl
    push de
    ld hl, StageDialogueAnimationPointers
    rst $20
    ld a, b
    sla a
    add b
    sub $03
    ld de, wSceneAnim0PtrLo
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    inc de
    xor a
    ld [de], a
    pop de
    pop hl

StageDialogue_NextActorSlot::
    inc de
    dec b
    jr nz, StageDialogue_UpdateActorSelector

    ld a, [hl]
    cp $fe
    jr nz, StageDialogue_SaveScriptPointer

    inc hl
    ld a, [hl+]
    ld [wMessageControlValue], a
    ld a, [hl+]
    ld [wMessageControlPtrLo], a
    ld a, [hl+]
    ld [wMessageControlPtrHi], a

StageDialogue_SaveScriptPointer::
    ld a, l
    ld [wStageDialogueScriptPtrLo], a
    ld a, h
    ld [wStageDialogueScriptPtrHi], a
    ld a, [wSgbEnabled]
    or a
    jr z, StageDialogue_BuildActorHighlightBoxes

    ld hl, SgbPacket_DialogueSpeakerTemplate
    ld de, wSgbPalSetPacket
    ld b, $10

StageDialogue_CopyPalettePacketTemplate::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, StageDialogue_CopyPalettePacketTemplate

    ldh a, [hStageDialogueSpeakerMask]
    ld b, a
    add a
    add b
    ld hl, StageDialogueSpeakerAttributes
    rst $38
    ld a, [hl+]
    ld [wSgbPalSetPacket + 7], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 8], a
    ld a, [hl+]
    ld [wSgbPalSetPacket + 9], a
    ld hl, wSgbPalSetPacket
    call SendSgbPacket

StageDialogue_BuildActorHighlightBoxes::
    ld b, $03
    ld hl, _SCRN0 + $124
    ldh a, [hStageDialogueSpeakerMask]
    ld c, a

StageDialogue_NextActorHighlightBox::
    ld de, StageDialogueSpeakerMarkerTiles
    rr c
    jr c, StageDialogue_WriteSpeakerMarker

    ld a, b
    add a
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a

StageDialogue_WriteSpeakerMarker::
    push bc
    push hl
    ld bc, $0102
    ldh a, [hTileStreamCount]
    or a
    call z, CopyTilemapRectToVram
    ldh a, [hTileStreamCount]
    or a
    call nz, QueueTilemapRect
    pop hl
    pop bc
    ld de, $0006
    add hl, de
    ld a, b
    cp $02
    jr nz, StageDialogue_AdvanceSpeakerMarker

    dec hl

StageDialogue_AdvanceSpeakerMarker::
    dec b
    jr nz, StageDialogue_NextActorHighlightBox

    ret


StageScene_DoubleIndexAndAdvance::
    ld a, [wStageSceneIndex]
    sla a
    ld [wStageSceneIndex], a

StageScene_AdvanceOrResumeGameplay::
    xor a
    ld [wMessageState], a
    ld [wVramQueue], a
    ld a, [wStateChangeParamHi]
    cp $04
    jp z, RequestSavedMenuDestination

    ld a, [wStageSceneIndex]
    bit 0, a
    jr nz, StageScene_AdvanceAfterStageClear

    srl a
    ldh [hStageIndex], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld a, [wStageSceneIndex]
    inc a
    ld [wStageSceneIndex], a
    cp $01
    ret nz

    ldh a, [hJoyHeld]
    and $08
    ret nz

    ld a, $08
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


StageScene_AdvanceAfterStageClear::
    inc a
    ld [wStageSceneIndex], a
    cp $08
    jr z, StageScene_SelectEndingMode

    ld e, a
    ld d, $08
    ld bc, $0100
    jp RequestStateChange_Menu


StageScene_SelectEndingMode::
    ld b, $09
    ld a, [wAlternateModeFlags]
    ld c, $00
    or a
    jr z, StageScene_RequestEnding

    ld c, $01

StageScene_RequestEnding::
    ld de, $0400
    jp RequestStateChange_Menu



; Indexed screen data; scene-specific interpretation is documented at its consumer.

StageDialogueScriptPointers::
    dw StageDialogue_Stage0Intro
    dw StageDialogue_Stage0Clear
    dw StageDialogue_Stage1Intro
    dw StageDialogue_Stage1Clear
    dw StageDialogue_Stage2Intro
    dw StageDialogue_Stage2Clear
    dw StageDialogue_Stage3Intro
    dw StageDialogue_Stage3Clear

StageDialogue_Stage0Intro::
    db $20, $04, $00, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $21, $01, $00, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $22, $04, $00, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $fe, $7f ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors + 2
    db $23, $01, $80, $7f, $7f ; message, palette mask, actor selectors 0-2
    db $fe, $7b ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $ff ; End dialogue script.

StageDialogue_Stage0Clear::
    db $24, $04, $7b, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $25, $01, $03, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $26, $01, $04, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $27, $04, $04, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $28, $01, $05, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $29, $00, $05, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage1Intro::
    db $2a, $04, $7b, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2b, $01, $7b, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2c, $04, $7b, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2d, $01, $02, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2e, $04, $02, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $fe, $7f ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors + 2
    db $2f, $01, $02, $7f, $7f ; message, palette mask, actor selectors 0-2
    db $fe, $7b ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $ff ; End dialogue script.

StageDialogue_Stage1Clear::
    db $30, $04, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $31, $04, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $32, $01, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $29, $00, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage2Intro::
    db $34, $04, $7b, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $35, $01, $01, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $36, $04, $01, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $37, $01, $7b, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage2Clear::
    db $38, $01, $80, $7f, $99 ; message, palette mask, actor selectors 0-2
    db $39, $04, $80, $7f, $99 ; message, palette mask, actor selectors 0-2
    db $fe, $30 ; FC message-control value and destination.
    dw wScreenPhaseCounter
    db $3a, $04, $80, $7f, $99 ; message, palette mask, actor selectors 0-2
    db $3b, $05, $06, $7f, $0a ; message, palette mask, actor selectors 0-2
    db $29, $00, $06, $7f, $0a ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage3Intro::
    db $3d, $01, $07, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $3e, $04, $07, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $3f, $01, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $40, $02, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $41, $01, $08, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $fe, $7f ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $42, $04, $7f, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $43, $02, $7f, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage3Clear::
    db $44, $02, $7f, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $fe, $7b ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $45, $01, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $46, $02, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $47, $04, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $48, $04, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $fe, $ff ; FC message-control value and destination.
    dw wScreenPhaseCounter
    db $49, $01, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $4a, $02, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogueSpeakerMarkerTiles::
; Two vertical tiles per marker. The first pair is used for the speaking actor.
    db $ff, $e0, $e5, $fd, $e5, $f0, $e5, $f0

StageDialogueActorXPositions::
    db $7c, $54, $24

; Indexed screen data; scene-specific interpretation is documented at its consumer.

StageDialogueAnimationPointers::
    dw SceneAnim_79e5
    dw SceneAnim_79ec
    dw SceneAnim_79f3
    dw SceneAnim_79fa
    dw SceneAnim_7a01
    dw SceneAnim_7a08
    dw SceneAnim_7a0f
    dw SceneAnim_7a16
    dw SceneAnim_7a1f
    dw SceneAnim_7a28
    dw SceneAnim_7a2f

StageDialogueSceneGfxPointers::
    dw GfxRle_b06_7a71
    dw GfxRle_b06_7b22
    dw GfxRle_b06_7c0e
    dw GfxRle_b06_7e13

StageDialogueSpeakerAttributes::
; Three ATTR_CHR data bytes per speaker mask used by the scripts.
    db $00, $00, $00, $c0, $00, $00, $00, $0c, $00, $c0, $0c, $00, $00, $00, $03, $c0
    db $00, $03, $00, $0c, $03

StageDialogueHiddenActorSlots::
; Eight scene-indexed actor selectors, with $ff disabling the highlight. Three trailing bytes are preserved.
    db $02, $ff, $02, $ff, $ff, $ff, $00, $ff, $c0, $0c, $03

; Indexed screen data; scene-specific interpretation is documented at its consumer.

StageDialogueVramQueuePointers::
    dw StageDialogueVramQueue_00
    dw StageDialogueVramQueue_01
    dw StageDialogueVramQueue_01

StageDialogueSgbPacketPointers::
    dw SgbPacket_DialogueHighlight_00
    dw SgbPacket_DialogueHighlight_01
    dw SgbPacket_DialogueHighlight_01

StageDialogueVramQueue_00::
    db $99, $c2, $04, $ef, $f1, $f2, $f9, $99, $e3, $03, $f5, $f6, $f7, $9a, $03, $02
    db $f3, $f4, $00

StageDialogueVramQueue_01::
    db $99, $ae, $03, $fd, $f0, $f3, $99, $ce, $03, $ef, $f1, $f2, $99, $ee, $03, $ee
    db $f5, $f6, $9a, $0e, $03, $f0, $f3, $f4, $00

StageDialogueFinalSceneVramQueue::
    db $99, $c3, $43, $00, $99, $e3, $43, $00, $9a, $03, $43, $00, $00

SgbPacket_DialogueHighlight_00::
    db $21, $02, $03, $00, $02, $0e, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueHighlight_01::
    db $21, $02, $03, $00, $0e, $0d, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueFinalSceneHighlight::
    db $21, $02, $03, $0a, $03, $0e, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueSpeakerTemplate::
    db $39, $00, $0a, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

StageDialogueBackgroundStencils::
; Seven 16-bit masks per scene.
    db $00, $00, $00, $00, $06, $00, $0e, $78, $0e, $70, $04, $70, $00, $00, $00, $00
    db $00, $00, $06, $00, $0e, $78, $0e, $70, $04, $70, $00, $00, $00, $00, $00, $00
    db $0e, $00, $0e, $70, $0e, $70, $04, $70, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $70, $0e, $70, $0e, $70, $00, $00, $0c, $00, $0c, $00, $0c, $00, $0e, $70
    db $0c, $70, $0e, $70, $00, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $70, $0e, $70
    db $00, $70, $00, $00, $84, $01, $8e, $01, $ce, $01, $8e, $f1, $8e, $71, $8e, $71
    db $00, $00, $84, $01, $8e, $01, $ce, $01, $8e, $01, $8e, $01, $8e, $01, $00, $00
INCLUDE "engine/ending.asm"

INCLUDE "data/ending.asm"
INCLUDE "data/scene_animations.asm"

GfxRle_b02_7b8e::
; Source: gfx/compressed/b02_7b8e.png (prevbyte, 1296 decoded bytes).
    INCBIN "../build/original/assets/b02_7b8e.bin"


GfxRle_b02_7fe0::
; Source: gfx/compressed/b02_7fe0.png (prevbyte, 16 decoded bytes).
    INCBIN "../build/original/assets/b02_7fe0.bin"


    ds $8000 - @, $ff
