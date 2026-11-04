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
    ld hl, wSharedWork + $161
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld hl, wSharedWork + $164
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
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $1a5
    ld a, l
    ldh [hSharedScratch + $0a], a
    ld a, h
    ldh [hTileStreamCount], a

UpdateMenuCursorAtCurrentPosition::
; Cursor base pointer is in $ffca/$ffcb; option count is in hTileStreamWritePos.
    ld a, [wMenuCursorRow]
    ld d, a
    ld hl, hSharedScratch + $0a
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
    ldh a, [hTileStreamWritePos]
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

    ldh a, [hTileStreamWritePos]
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
    dw RequestState_GotoScreenState3WithD81C ; 03
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
    ld [wSharedWork + $13b], a
    ld a, $03
    ld [wScreenSubstate], a
    ldh [hGameState], a
    ld a, $3f
    ld [wFadeTransitionTimer], a
    ret


RequestState_GotoScreenState3WithD81C::
    ld a, c
    inc a
    ld [wMinigameMode], a
    ld a, $03
    ldh [hGameState], a
    xor a
    ld [wSharedWork + $1c], a
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
    ld [wSharedWork + $f3], a
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

ScreenData_46f1::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $15, $44, $12, $44, $59, $7e, $00, $00

ScreenData_46f9::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
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
    ld hl, wSharedWork + $140

SceneTest_ClearSelectorValues::
    xor a
    ld [hl+], a
    dec b
    jr nz, SceneTest_ClearSelectorValues

    ret


UpdateSceneTestMenu::
; Move between the four selectors; A or START invokes the selected request.
    ld hl, wSharedWork + $140
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
    ld [wSharedWork + $13a], a
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
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN0 + $0a5
    ld a, l
    ldh [hSharedScratch + $0a], a
    ld a, h
    ldh [hTileStreamCount], a
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
    ld a, [wSharedWork + $141]


    ld c, a
    ld de, $0400
    jp RequestStateChange_Menu


SceneTest_OpenStageScene::
; Request selector 8: state 4 submode from row 0.
    ld a, [wSharedWork + $140]
    ld c, a
    ld b, $08
    ld de, $0400
    jp RequestStateChange_Menu


SceneTest_OpenEnding::
; Request selector 9: state 5 submode from row 2.
    ld b, $09
    ld a, [wSharedWork + $142]
    ld c, a
    ld de, $0400
    jp RequestStateChange_Menu


SceneTest_StartBonusWithHealth::
; Set health to row 3 + 1 and request state 3.
    ld a, [wSharedWork + $143]
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
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    add $04
    ldh [hSharedScratch + $0a], a
    ld a, [hl+]
    add $04
    ldh [hTileStreamCount], a
    ld hl, hTileStreamWritePos
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
    ld de, hTileStreamWritePos
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
    jr nz, jr_002_4a8f

    xor a
    ld [wSharedWork + $13b], a
    ld a, $01
    ld [wSharedWork + $167], a
    ld a, $e8
    ld [wSharedWork + $13a], a
    ld a, BANK(Gfx_b05_5701)
    ld hl, Gfx_b05_5701
    ld de, _VRAM + $d00
    ld bc, $0300
    call BankedMemcpy

jr_002_4a8f::
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld a, $d0
    ld [hl+], a
    ld a, $e4
    ld [hl], a
    ld a, [wStateChangeParamHi]
    ld [wSharedWork + $160], a
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
    jr z, jr_002_4b08

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
    jr jr_002_4b40

jr_002_4b08::
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
    jr z, jr_002_4b3b

    ld hl, wStageLayoutMap
    ld bc, $0010
    call bzero
    ld hl, _SCRN0 + $1a0
    ld bc, $0303
    ld de, wStageLayoutMap
    call CopyTilemapRectToVram

jr_002_4b3b::
    ld a, $14
    ld [wScreenPaletteId], a

jr_002_4b40::
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
    ld [wSharedWork + $156], a
    ld a, [wScreenSubstate]
    cp $03
    jr nz, jr_002_4ba2

    ld a, $82
    ld [wMessageFlags], a
    ld a, [wSharedWork + $13b]
    add $09
    cp $0c
    jr c, jr_002_4b84

    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, [wSharedWork + $13b]
    sub $03
    add $5a
    jr jr_002_4b8e

jr_002_4b84::
    push af
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    pop af

jr_002_4b8e::
    call StartMessageFar
    ld hl, SceneAnim_Scene3Mode0State1
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    ld a, $40
    ld [wScreenFrameCounter], a
    ret


jr_002_4ba2::
    call Call_002_4fb1
    ld a, [wScreenSubstate]
    cp $06
    ret z

Jump_002_4bab::
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
    ld [wSharedWork + $167], a
    xor a
    ld [wScreenSubstate], a
    ret


UpdateBonusStage::
; Mode 0 update, dispatched by wScreenSubstate.
    ld a, [wScreenSubstate]
    and $07
    rst $00

BonusStageStateHandlers::
    dw BonusStage_State00 ; $00
    dw BonusStage_State01 ; $01
    dw BonusStage_State02 ; $02
    dw BonusStage_State03 ; $03
    dw BonusStage_State04 ; $04
    dw BonusStage_State05 ; $05
    dw BonusStage_State06 ; $06
    dw BonusStage_State07 ; $07

BonusStage_State00::
; BonusStageStateHandlers index $00; detailed phase behavior remains to be named.
    call UpdateMessageFar
    call Call_002_4d91
    ld a, [wSharedWork + $167]
    ld b, a
    ldh a, [hPlayerHealth]
    or a
    jr nz, jr_002_4c04

    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $03
    jr nz, jr_002_4c04

    ld b, $00

jr_002_4c04::
    ld a, [wSharedWork + $13a]
    add b
    ld [wSharedWork + $13a], a
    ld c, a
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld hl, Scene3Mode0MetaspriteData
    ld b, $05

jr_002_4c19::
    ld a, [wSharedWork + $13a]
    cp [hl]
    jr z, jr_002_4c24

    dec hl
    dec b
    jr nz, jr_002_4c19

    ret


jr_002_4c24::
    dec b
    ld a, b
    cp $04
    jr z, jr_002_4c47

    ldh a, [hPlayerHealth]
    or a
    ret z

    ld a, b
    ld [wSharedWork + $13b], a
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


jr_002_4c47::
    ld a, $3f
    ld [wFadeTransitionTimer], a
    ld a, $04
    ld [wScreenSubstate], a
    ret


BonusStage_State04::
; BonusStageStateHandlers index $04; detailed phase behavior remains to be named.
    call Call_002_4d91
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0400
    ld de, $0000
    ld a, [wSharedWork + $160]
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


BonusStage_State01::
; BonusStageStateHandlers index $01; detailed phase behavior remains to be named.
    call UpdateMessageFar
    call Call_002_4d91
    ld a, [wSharedWork + $13a]
    ld c, a
    ld b, $7f
    ld d, $0e
    call DrawBank3MetaspriteNormal
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_4cc8

    ld a, [wMessageState]
    or a
    jr nz, jr_002_4cc8

    ld a, [wSharedWork + $13b]
    cp $03
    jr z, jr_002_4cc8

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


jr_002_4cc8::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    bit 7, a
    ret z

    xor a
    ld [wScreenFrameCounter], a
    ldh a, [hJoyHeld]
    bit 4, a
    call nz, Call_002_4d47
    ldh a, [hJoyHeld]
    bit 5, a
    call nz, Call_002_4d51
    ret


BonusStage_State02::
; BonusStageStateHandlers index $02; detailed phase behavior remains to be named.
    call UpdateMessageFar
    call Call_002_4d91
    ld a, [wSceneAnim0Timer]
    cp $01
    jr nz, jr_002_4d03

    ld hl, wSceneAnim0PtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    dec hl
    ld a, [hl]
    cp $12
    jr nz, jr_002_4d03

    ld a, $54
    call PlaySound

jr_002_4d03::
    ld a, [wSharedWork + $13a]
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

    ld hl, wSharedWork + $161
    ld a, [wSharedWork + $13b]
    rst $38
    ld a, [hl]
    ld [wMinigameRound], a
    ld hl, wSharedWork + $164
    ld a, [wSharedWork + $13b]
    rst $38
    ld b, $03
    ld a, [wSharedWork + $13b]
    ld c, a
    ld de, $0106
    ld a, [hl]
    or a
    jp z, RequestStateChange_Menu

    xor a
    ld [hl], a
    ld b, $02
    ld a, [wSharedWork + $13b]
    ld c, a
    ld de, $0106
    jp RequestStateChange_Menu


Call_002_4d47::
    ld a, $01
    ld [wSharedWork + $167], a
    ld hl, SceneAnim_Scene3Mode0Primary
    jr jr_002_4d5e

Call_002_4d51::
    ld a, [wSharedWork + $13b]
    or a
    ret z

    ld a, $ff
    ld [wSharedWork + $167], a
    ld hl, SceneAnim_Scene3Mode0Variant

jr_002_4d5e::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenSubstate], a
    call Call_002_4d71
    ret


Call_002_4d71::
    xor a
    ld [wMessageState], a
    ld d, $82
    ld bc, _SCRN0 + $083

jr_002_4d7a::
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
    jr nz, jr_002_4d7a

    ret


Call_002_4d91::
    ld a, [wSharedWork + $13c]
    inc a
    ld [wSharedWork + $13c], a
    ld c, $00
    and $10
    jr z, jr_002_4da0

    ld c, $08

jr_002_4da0::
    ld b, $00
    push bc
    ld hl, Scene3Mode0MetaspriteA
    call DrawMetaspriteNormal
    pop bc
    ld a, c
    xor $08
    ld c, a
    ld b, $18
    ld hl, Scene3Mode0MetaspriteA
    call DrawMetaspriteNormal
    ld a, [wSharedWork + $13c]
    ld b, $00
    and $10
    jr nz, jr_002_4dc1

    ld b, $08

jr_002_4dc1::
    ld c, $00
    push bc
    ld hl, Scene3Mode0MetaspriteB
    call DrawMetaspriteNormal
    pop bc
    ld a, b
    xor $08
    ld b, a
    ld c, $78
    ld hl, Scene3Mode0MetaspriteB
    call DrawMetaspriteNormal
    ret


BonusStage_State03::
; BonusStageStateHandlers index $03; detailed phase behavior remains to be named.
    ld c, $0c
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFadeWithLateSgbPalSet
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld a, [wSharedWork + $13b]
    cp $03
    jr nc, jr_002_4e23

    ld a, [wSharedWork + $13c]
    inc a
    ld [wSharedWork + $13c], a
    and $0f
    jr nz, jr_002_4e0c

    ld a, [wSharedWork + $13c]
    and $10
    ld a, $81
    jr nz, jr_002_4e06

    xor a

jr_002_4e06::
    ld hl, _SCRN0 + $1cf
    call QueueTilemapByte

jr_002_4e0c::
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


jr_002_4e23::
    ld a, [wSharedWork + $13b]
    cp $05
    ret z

    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    cp $d0
    ret c

    ld a, $e0
    ld [wScreenPhaseCounter], a
    jr jr_002_4e0c

BonusStage_State05::
; BonusStageStateHandlers index $05; detailed phase behavior remains to be named.
    ld c, $0c
    ld b, $7f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld b, $03
    ld a, [wSharedWork + $13b]
    cp $03
    jp nc, RequestSavedMenuDestination

    ld c, a
    ld a, [wStateChangeParamLo]
    ld e, a
    ld a, [wStateChangeParamHi]
    ld d, a
    jp RequestStateChange_Menu


BonusStage_State06::
; BonusStageStateHandlers index $06; detailed phase behavior remains to be named.
    call UpdateMessageFar
    call Call_002_4d91
    ld a, [wSharedWork + $13a]
    ld c, a
    ld b, $7f
    ld d, $14
    call DrawBank3MetaspriteNormal
    ld a, [wSharedWork + $13b]
    cp $01
    jp nz, jr_002_4efe

    ld a, [wMinigameResultFlag]
    or a
    jr nz, jr_002_4efe

    ld a, [wScreenFrameCounter]
    or a
    jr nz, jr_002_4efe

    ld a, [wSharedWork + $156]
    cp $01
    jr nz, jr_002_4e9a

    ld hl, _SCRN0 + $0a7
    ld bc, $0501 ; width/height constant, not a ROM0 QueueVramFill pointer
    ld de, Scene3Mode0StatusTiles
    call QueueTilemapRect

jr_002_4e9a::
    ld a, [wSharedWork + $156]
    inc a
    cp $40
    jr c, jr_002_4ea4

    ld a, $60

jr_002_4ea4::
    ld [wSharedWork + $156], a
    ld a, [wScreenPhaseCounter]
    bit 7, a
    jr nz, jr_002_4eee

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_4ec0

    ld a, [wSharedWork + $156]
    cp $60
    ret nz

    ld a, $80
    ld [wScreenPhaseCounter], a
    ret


jr_002_4ec0::
    ld a, [wScreenPhaseCounter]
    inc a
    cp $0c
    jr c, jr_002_4ec9

    xor a

jr_002_4ec9::
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


jr_002_4eee::
    inc a
    ld [wScreenPhaseCounter], a
    cp $e0
    ret nz

    ld bc, _SCRN0 + $0c6
    ld de, $0004
    call QueueVramFill

jr_002_4efe::
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $01
    jr nz, jr_002_4f3e

    ld a, $80
    ld [wMessageFlags], a
    ld a, [wMinigameResultFlag]
    or a
    ld a, $08
    jr nz, jr_002_4f2a

    ld a, [wSharedWork + $13b]
    ld hl, wSharedWork + $161
    rst $38
    inc [hl]
    ld a, [hl]
    cp $0b
    jr c, jr_002_4f25

    ld [hl], $0a

jr_002_4f25::
    ld a, [wSharedWork + $13b]
    add $05

jr_002_4f2a::
    call StartMessageFar
    ld a, [wSharedWork + $13b]
    cp $01
    ret nz

    ld a, [wMinigameResultFlag]
    or a
    ret nz

    ld a, $46
    call PlaySound_Queue1
    ret


jr_002_4f3e::
    ld a, [wScreenFrameCounter]
    cp $60
    jr nz, jr_002_4fa0

    ld a, [wMinigameResultFlag]
    or a
    jr nz, jr_002_4f6f

    ld a, [wSharedWork + $13b]
    or a
    jr nz, jr_002_4f58

    ld a, $0f
    call AddBonusCounter
    jr jr_002_4f6f

jr_002_4f58::
    dec a
    jr nz, jr_002_4f67

    ld a, [wMsgSubstitutionId]
    sub $0a
    ldh [hPlayerForm], a
    call QueuePlayerFormHudIcon
    jr jr_002_4f6f

jr_002_4f67::
    call AddExtraLife
    ld a, $46
    call PlaySound_Queue1

jr_002_4f6f::
    ld a, [wSharedWork + $13b]
    ld hl, wSharedWork + $161
    rst $38
    ld a, [wSharedWork + $13b]
    ld d, a
    ld a, [hl]
    cp $0a
    jr c, jr_002_4f81

    ld a, $c1

jr_002_4f81::
    add $04
    inc d
    ld bc, $0005
    ld hl, _SCRN0 + $160

jr_002_4f8a::
    add hl, bc
    dec d
    jr nz, jr_002_4f8a

    call QueueTilemapByte
    call Call_002_4d71
    ld a, $80
    ld [wMessageFlags], a
    ld a, [wSharedWork + $13b]
    inc a
    call StartMessageFar

jr_002_4fa0::
    ld a, [wScreenFrameCounter]
    cp $60
    ret c

    ld a, $01
    ld [wScreenSubstate], a
    ld [wScreenFrameCounter], a
    jp Jump_002_4bab


Call_002_4fb1::
    ld b, $03
    ld hl, _SCRN0 + $165
    ld de, wSharedWork + $161

jr_002_4fb9::
    ld a, [de]
    inc de
    cp $0a
    jr c, jr_002_4fc1

    ld a, $c1

jr_002_4fc1::
    add $04
    ld [hl], a
    push bc
    ld bc, $0005
    add hl, bc
    pop bc
    dec b
    jr nz, jr_002_4fb9

    ret


BonusStage_State07::
; BonusStageStateHandlers index $07; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $162]
    ld c, $0b
    ld d, $02
    cp $04
    jr c, jr_002_4fe5

    ld c, $0c
    ld d, $03
    cp $07
    jr c, jr_002_4fe5

    ld c, $0d
    ld d, $01

jr_002_4fe5::
    ld a, d
    ldh [hSharedScratch + $0a], a
    ld a, c
    ld [wMsgSubstitutionId], a
    ret


    db $1e, $46, $6e, $8e

Scene3Mode0MetaspriteData::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $b0

Scene3Mode0MetaspriteA::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $10, $af, $10, $00, $20, $af, $10, $00, $30, $af, $10, $00, $40, $af, $10
    db $00, $50, $af, $10, $00, $60, $af, $10, $00, $70, $af, $10, $00, $80, $af, $10
    db $80

Scene3Mode0MetaspriteB::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $08, $10, $af, $10, $80

Scene3Mode0StatusTiles::
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
    ld [wSharedWork + $24], a
    ld [wSharedWork + $156], a
    ld a, $0c
    ld [wScreenPaletteId], a
    ld a, [wSharedWork + $1c]
    or a
    jr nz, jr_002_5065

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
    ld [wSharedWork + $1d], a

jr_002_5065::
    ld b, $1e
    ld a, [wSharedWork + $1d]
    or a
    jr z, jr_002_506f

    ld b, $20

jr_002_506f::
    ld hl, wStageLayoutMap
    ld de, _SCRN0

jr_002_5075::
    ld c, $20

jr_002_5077::
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, jr_002_5077

    ld a, $60
    rst $38
    dec b
    jr nz, jr_002_5075

    ld a, [wSharedWork + $1d]
    or a
    jr nz, jr_002_5091

    ld b, $40
    xor a

jr_002_508c::
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_508c

jr_002_5091::
    ld a, [wSharedWork + $1d]
    or a
    jp nz, Jump_002_5140

    ld a, [wSharedWork + $1c]
    or a
    jp nz, Jump_002_50f1

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
    jr c, jr_002_50d7

    ldh a, [hJoyPressed]
    bit 3, a
    jr z, jr_002_50d7

    ld a, [wSharedWork + $1d]
    or a
    jr nz, jr_002_50d4

    ld a, $01
    ld [wSharedWork + $1d], a
    ldh [hNeedsReset], a
    ld [wSharedWork + $1c], a
    ret


jr_002_50d4::
    call PauseMinigame

jr_002_50d7::
    ld a, [wScreenSubstate]
    rst $00

Minigame3StateHandlers::
    dw Minigame3_State00 ; $00
    dw Minigame3_State01 ; $01
    dw Minigame3_State02 ; $02
    dw Minigame3_State03 ; $03
    dw Minigame3_State04 ; $04
    dw Minigame3_State05 ; $05
    dw Minigame3_State06 ; $06

Minigame3_State00::
; Minigame3StateHandlers index $00; detailed phase behavior remains to be named.
    call HandleMinigameRoundSelection
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

Jump_002_50f1::
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


Minigame3_State01::
; Minigame3StateHandlers index $01; detailed phase behavior remains to be named.
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

Jump_002_5140::
    ld a, $02
    ld [wScreenSubstate], a
    xor a
    ld [wScreenFrameCounter], a
    ld hl, wSharedWork + $1e
    ld [hl], $00
    inc hl
    ld [hl], $28
    inc hl
    ld [hl], $00
    xor a
    ld hl, wSharedWork + $21
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


Minigame3_State02::
; Minigame3StateHandlers index $02; detailed phase behavior remains to be named.
    ld d, $9c
    ld a, [wSharedWork + $20]
    or a
    jp nz, Jump_002_5261

    ld a, [wSharedWork + $1f]
    cp $2a
    jp nc, Jump_002_51af

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $e0
    jr nc, jr_002_519a

    xor a
    ld [wSharedWork + $15], a
    ld [wSharedWork + $16], a
    ld [wSharedWork + $17], a
    ld [wSharedWork + $18], a
    jp jr_002_52f1


jr_002_519a::
    ld hl, $0080
    ld a, l
    ld [wSharedWork + $15], a
    ld a, h
    ld [wSharedWork + $16], a
    xor a
    ld [wSharedWork + $17], a
    ld [wSharedWork + $18], a
    jp jr_002_52f1


Jump_002_51af::
    ld d, $9e
    cp $80
    jr nc, jr_002_51d2

    ld hl, wSharedWork + $15
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $0003
    add hl, bc
    ld a, l
    ld [wSharedWork + $15], a
    ld a, h
    ld [wSharedWork + $16], a
    ld a, l
    ld [wSharedWork + $17], a
    ld a, h
    ld [wSharedWork + $18], a
    jp jr_002_52f1


jr_002_51d2::
    cp $b0
    jp nc, Jump_002_5261

    ld a, [wSharedWork + $24]
    or a
    jr nz, jr_002_5205

    ld hl, wSharedWork + $25
    ld a, $98
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $b0
    ld [hl+], a
    ld hl, SceneAnim_7a53
    ld a, [wSharedWork + $1d]
    or a
    jr z, jr_002_51f4

    ld hl, SceneAnim_7a58

jr_002_51f4::
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim1Timer], a
    ld a, $01
    ld [wSharedWork + $24], a

jr_002_5205::
    xor a
    ld [wSharedWork + $19], a
    ld [wSharedWork + $17], a
    ld [wSharedWork + $18], a
    ld a, $e4
    ld [wSharedWork + $22], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wSharedWork + $1d]
    and b
    jp z, jr_002_52f1

jr_002_521e::
    ld a, [wMinigameRound]
    dec a
    ld hl, Minigame3RoundObjectPointers
    rst $20
    ld a, l
    ld [wSharedWork + $1a], a
    ld a, h
    ld [wSharedWork + $1b], a
    ld a, $42
    call PlaySound
    ld a, $03
    ld [wScreenSubstate], a
    ld hl, $0180
    ld a, [wMinigameRound]
    dec a
    ld b, a
    ld a, [wSharedWork + $1d]
    or b
    jr nz, jr_002_5249

    ld hl, $01c0

jr_002_5249::
    ld a, l
    ld [wSharedWork + $15], a
    ld a, h
    ld [wSharedWork + $16], a
    ld hl, -$0280
    ld a, l
    ld [wSharedWork + $17], a
    ld a, h
    ld [wSharedWork + $18], a
    ld d, $9e
    jp jr_002_52f1


Jump_002_5261::
    ld a, [wSharedWork + $1d]
    or a
    jr z, jr_002_521e

    ld d, $9e
    ld a, [wSharedWork + $22]
    cp $f0
    jr c, jr_002_52e1

    ld d, $a0
    ld a, [wSharedWork + $156]
    inc a
    ld [wSharedWork + $156], a
    bit 3, a
    jr nz, jr_002_527f

    ld d, $a1

jr_002_527f::
    ld a, $f1
    ld [wSharedWork + $22], a
    xor a
    ld [wSharedWork + $17], a
    ld [wSharedWork + $18], a
    ld a, [wSharedWork + $16]
    bit 7, a
    jr nz, jr_002_52b9

    ld a, [wSharedWork + $15]
    sub $03
    ld [wSharedWork + $15], a
    ld a, [wSharedWork + $16]
    sbc $00
    ld [wSharedWork + $16], a
    jr nc, jr_002_52f1

    xor a
    ld [wSharedWork + $16], a
    ld a, $05
    ld [wScreenSubstate], a
    push de
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop de
    jr jr_002_52f1

jr_002_52b9::
    ld a, [wSharedWork + $15]
    add $03
    ld [wSharedWork + $15], a
    ld a, [wSharedWork + $16]
    adc $00
    ld [wSharedWork + $16], a
    jr nc, jr_002_52f1

    ld a, $ff
    ld [wSharedWork + $16], a
    ld a, $05
    ld [wScreenSubstate], a
    push de
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop de
    jr jr_002_52f1

jr_002_52e1::
    ld a, [wSharedWork + $17]
    add $04
    ld [wSharedWork + $17], a
    ld a, [wSharedWork + $18]
    adc $00
    ld [wSharedWork + $18], a

jr_002_52f1::
    ld a, d
    ldh [hTileStreamWritePos], a
    call Call_002_5419
    call Call_002_5658
    call Call_002_5521
    ret


Minigame3_State05::
; Minigame3StateHandlers index $05; detailed phase behavior remains to be named.
    ld a, $9f
    ldh [hTileStreamWritePos], a
    call Call_002_5419
    call Call_002_5521
    ld a, [wSharedWork + $19]
    inc a
    ld [wSharedWork + $19], a
    cp $90
    ret c

    ld a, $a0
    ld [wSharedWork + $19], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    jp RequestSavedMenuDestination


Minigame3_State03::
; Minigame3StateHandlers index $03; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $17]
    add $0a
    ld [wSharedWork + $17], a
    ld a, [wSharedWork + $18]
    adc $00
    ld [wSharedWork + $18], a
    ld d, $9e
    bit 7, a
    jr z, jr_002_5337

    ld d, $9d

jr_002_5337::
    ld a, d
    ldh [hTileStreamWritePos], a
    call Call_002_5419
    call Call_002_5658
    call Call_002_5521
    call Call_002_55ac
    ld a, [wSharedWork + $23]
    or a
    ret nz

    ld a, [wSharedWork + $22]
    cp $f0
    ret c

    ld a, [wSharedWork + $1d]
    or a
    jr z, jr_002_5363

    ld a, [wMinigameResultFlag]
    or a
    jr z, jr_002_5363

    ld a, $02
    ld [wScreenSubstate], a
    ret


jr_002_5363::
    ld a, $04
    ld [wScreenSubstate], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ld hl, ScreenData_7a36
    ld a, [wMinigameRound]
    cp $0a
    jr nz, jr_002_537d

    ld hl, ScreenData_7a61

jr_002_537d::
    ld a, [wSharedWork + $1d]
    or a
    jr nz, jr_002_538b

    ld a, $5b
    call PlaySound
    ld hl, SceneAnim_7a43

jr_002_538b::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wScreenFrameCounter], a
    ret


Minigame3_State06::
; Minigame3StateHandlers index $06; detailed phase behavior remains to be named.
    ld hl, wSharedWork + $17
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, -$0060
    add hl, bc
    ld a, l
    ld [wSharedWork + $17], a
    ld a, h
    ld [wSharedWork + $18], a
    ld a, $9c
    ldh [hTileStreamWritePos], a
    call Call_002_5419
    call Call_002_5658
    call Call_002_5521
    ld a, [wScreenPhaseCounter]
    cp $07
    jr c, jr_002_53d0

    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wSharedWork + $1d]
    and b
    jr z, jr_002_53d0

    ld a, [wScreenFrameCounter]
    ld [wScreenPhaseCounter], a

jr_002_53d0::
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $08
    ret nz

    ld a, $5c
    call PlaySound
    ld hl, wSharedWork + $1a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    inc hl
    ld d, [hl]
    inc hl
    ld a, l
    ld [wSharedWork + $1a], a
    ld a, h
    ld [wSharedWork + $1b], a
    ld hl, $007c
    bit 6, d
    jr z, jr_002_53fc

    ld hl, -$007c

jr_002_53fc::
    ld a, l
    ld [wSharedWork + $15], a
    ld a, h
    ld [wSharedWork + $16], a
    ld hl, Scene3Mode3MotionTable
    ld a, [wScreenPhaseCounter]
    rst $20
    ld a, l
    ld [wSharedWork + $17], a
    ld a, h
    ld [wSharedWork + $18], a
    ld a, $03
    ld [wScreenSubstate], a
    ret


Call_002_5419::
    ld a, [wScreenSubstate]
    cp $05
    jr z, jr_002_5456

    ld a, [wSharedWork + $16]
    ld b, $00
    bit 7, a
    jr z, jr_002_542b

    ld b, $ff

jr_002_542b::
    ld hl, wSharedWork + $1e
    ld a, [wSharedWork + $15]
    add [hl]
    ld [hl+], a
    ld a, [wSharedWork + $16]
    adc [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl+], a
    ld a, [wSharedWork + $18]
    ld b, $00
    bit 7, a
    jr z, jr_002_5446

    ld b, $ff

jr_002_5446::
    ld hl, wSharedWork + $21
    ld a, [wSharedWork + $17]
    add [hl]
    ld [hl+], a
    ld a, [wSharedWork + $18]
    adc [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a

jr_002_5456::
    ld hl, wSharedWork + $1f
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, hPlayerXSubpixel
    add hl, bc
    bit 7, h
    jr z, jr_002_5467

    ld hl, $0000

jr_002_5467::
    ld a, h
    cp $03
    jr c, jr_002_546f

    ld hl, $0300

jr_002_546f::
    ld a, l
    ld [wSharedWork + $12], a
    ld a, h
    ld [wSharedWork + $13], a
    ld hl, wSharedWork + $1f
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld l, $70
    ld a, [wScreenSubstate]
    cp $02
    jr z, jr_002_549f

    ld hl, wSharedWork + $22
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, hBonusCounter
    add hl, bc
    ld a, h
    or a
    jr z, jr_002_5498

    ld l, $00
    jr jr_002_549f

jr_002_5498::
    ld a, l
    cp $70
    jr c, jr_002_549f

    ld l, $70

jr_002_549f::
    ld a, l
    ld [wSharedWork + $14], a
    ld a, [wSharedWork + $12]
    ldh [hSCX], a
    ld a, [wSharedWork + $14]
    ldh [hSCY], a
    ld a, [wSharedWork + $12]
    ld c, a
    ld a, [wSharedWork + $1f]
    sub c
    ld c, a
    ld [wSharedWork + $17b], a
    ld a, [wSharedWork + $23]
    or a
    ret nz

    ld a, [wSharedWork + $14]
    ld b, a
    ld a, [wSharedWork + $22]
    sub b
    ld b, a
    ld e, $00
    ld a, [wSharedWork + $16]
    bit 7, a
    jr z, jr_002_54d2

    ld e, $01

jr_002_54d2::
    ld a, e
    ldh [hSpriteFlags], a
    ld a, [wSharedWork + $1d]
    or a
    jr nz, jr_002_54f1

    ldh a, [hTileStreamWritePos]
    cp $9c
    jr nz, jr_002_54e3

    ld a, $a8

jr_002_54e3::
    cp $9d
    jr nz, jr_002_54e9

    ld a, $a6

jr_002_54e9::
    cp $9e
    jr nz, jr_002_54ef

    ld a, $a7

jr_002_54ef::
    ldh [hTileStreamWritePos], a

jr_002_54f1::
    ldh a, [hTileStreamWritePos]
    ld d, a
    call DrawBank3MetaspriteFar
    ld a, [wSharedWork + $24]
    or a
    ret z

    ld hl, wSharedWork + $12
    ld a, [wSharedWork + $25]
    sub [hl]
    ld c, a
    inc hl
    ld a, [wSharedWork + $26]
    sbc [hl]
    or a
    ret nz

    ld a, [wSharedWork + $14]
    ld b, a
    ld a, [wSharedWork + $27]
    sub b
    ld b, a
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    or a
    ret z

    xor a
    ld [wSharedWork + $24], a
    ret


Call_002_5521::
    ld hl, wSharedWork + $1a
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
    ldh [hSharedScratch + $0a], a
    ld a, h
    ldh [hTileStreamCount], a
    ld a, [wMinigameRound]
    dec a
    ld hl, Minigame3RoundObjectPointers
    rst $20

jr_002_5547::
    ld d, $ab
    ld a, [wScreenSubstate]
    cp $06
    jr nz, jr_002_555c

    ldh a, [hSharedScratch + $0a]
    cp l
    jr nz, jr_002_555c

    ldh a, [hTileStreamCount]
    cp h
    jr nz, jr_002_555c

    ld d, $ac

jr_002_555c::
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
    jr z, jr_002_55a5

    ld a, [wSharedWork + $12]
    ld c, a
    ld a, l
    sub c
    ld l, a
    ld a, [wSharedWork + $13]
    ld c, a
    ld a, h
    sbc c
    ld h, a
    ld a, h
    or a
    jr nz, jr_002_55a5

    ld a, l
    cp $e8
    jr nc, jr_002_55a5

    sub $10
    ld c, a
    pop hl
    push hl
    ld a, [hl]
    cp $ff
    jr nz, jr_002_559f

    ld a, $ad
    ldh [hTileStreamWritePos], a
    ld a, [wMinigameResultFlag]
    or a
    jr z, jr_002_55a5

jr_002_559f::
    ldh a, [hTileStreamWritePos]
    ld d, a
    call DrawBank3MetaspriteNormal

jr_002_55a5::
    pop hl
    ld a, [hl]
    cp $ff
    jr nz, jr_002_5547

    ret


Call_002_55ac::
    ld a, [wSharedWork + $18]
    bit 7, a
    ret nz

    ld hl, wSharedWork + $1a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl]
    ld [wSharedWork + $25], a
    ld a, [wSharedWork + $1f]
    add $0c
    push af
    sub [hl]
    inc hl
    ld b, a
    ld a, [hl]
    ld [wSharedWork + $26], a
    ld a, [wSharedWork + $20]
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

    ld a, [wSharedWork + $23]
    or a
    ret nz

    ld a, [hl]
    add $18
    ld [wSharedWork + $27], a
    ld a, [wSharedWork + $22]
    add $18
    sub [hl]
    inc hl
    ld d, [hl]
    inc hl
    ld b, a
    ld c, $10
    ld a, [hl]
    cp $ff
    jr nz, jr_002_55f7

    ld c, $40

jr_002_55f7::
    ld a, b
    cp c
    ret nc

    ld a, [hl]
    cp $ff
    jr z, jr_002_5649

    ld a, $06
    ld [wScreenSubstate], a
    ld a, [wSharedWork + $1d]
    or a
    ld a, $08
    jr nz, jr_002_560e

    ld a, $07

jr_002_560e::
    ld [wScreenPhaseCounter], a
    xor a
    ld [wScreenFrameCounter], a
    dec hl
    dec hl
    ld a, [hl]
    sub $18
    ld [wSharedWork + $22], a
    ld hl, $0300
    ld a, l
    ld [wSharedWork + $17], a
    ld a, h
    ld [wSharedWork + $18], a
    xor a
    bit 6, d
    jr z, jr_002_562e

    cpl

jr_002_562e::
    ld [wSharedWork + $15], a
    ld [wSharedWork + $16], a
    ld hl, SceneAnim_7a4e
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim1Timer], a
    ld a, $01
    ld [wSharedWork + $24], a
    ret


jr_002_5649::
    ld a, [wMinigameResultFlag]
    or a
    ret z

    ld a, $44
    call PlaySound
    xor a
    ld [wMinigameResultFlag], a
    ret


Call_002_5658::
    ld e, $14
    ld a, [wSharedWork + $16]
    bit 7, a
    jr z, jr_002_5663

    ld e, $fe

jr_002_5663::
    ld hl, wSharedWork + $12
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

jr_002_5694::
    ld a, [hl]
    ld [de], a
    inc de
    ld a, $80
    rst $38
    dec b
    jr nz, jr_002_5694

    xor a
    ld [de], a
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ret


Minigame3_State04::
; Minigame3StateHandlers index $04; detailed phase behavior remains to be named.
    call Call_002_5521
    ld de, wSceneAnim0PtrLo
    ld a, [wSharedWork + $17b]
    ld c, a
    ld b, $80
    call AnimateSceneMetasprite
    ld a, [wSharedWork + $19]
    inc a
    ld [wSharedWork + $19], a
    cp $90
    ret c

    ld a, [wSharedWork + $1d]
    or a
    jr z, jr_002_56f9

    ld a, $a0
    ld [wSharedWork + $19], a
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
    jr c, jr_002_56ed

    ld [hl], a

jr_002_56ed::
    xor a
    ld [wSharedWork + $1d], a
    ld a, $01
    ldh [hNeedsReset], a
    ld [wSharedWork + $1c], a
    ret


jr_002_56f9::
    ld a, $01
    ld [wSharedWork + $1d], a
    ldh [hNeedsReset], a
    ld [wSharedWork + $1c], a
    ret



; Indexed screen data; scene-specific interpretation is documented at its consumer.

Minigame3RoundObjectPointers::
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

Scene3Mode3MotionTable::
    db $00, $ff, $80, $fe, $00, $fd, $00, $fd, $00, $fd, $00, $fd, $00, $fd, $00, $fd
    db $80, $ff
InitMinigame1::
; Mode 1 initialization; the scene work area is shared with the other minigames.
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld [wSharedWork + $4d], a
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
    ld [wSharedWork + $4b], a
    ld a, $0d
    ld [wScreenPaletteId], a
    ret


UpdateMinigame1::
; Mode 1 update.
    ld a, [wSharedWork + $4d]
    or a
    jr z, jr_002_589d

    dec a
    ld [wSharedWork + $4d], a
    ld a, $1b
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    jr jr_002_58bd

jr_002_589d::
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, [wSgbEnabled]
    or a
    jr z, jr_002_58bd

    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a

jr_002_58bd::
    ld a, [wScreenSubstate]
    rst $00

Minigame1StateHandlers::
    dw Minigame_WaitForStart ; $00
    dw Minigame1_State01 ; $01
    dw Minigame1_State02 ; $02
    dw Minigame1_State03 ; $03
    dw Minigame1_State04 ; $04

Minigame1_State01::
; Minigame1StateHandlers index $01; detailed phase behavior remains to be named.
    xor a
    ld [wScreenPhaseCounter], a
    call Call_002_5e5a
    call UpdateMessageFar
    ld c, $0f
    ld b, $1c
    ld d, $60
    call DrawBank3MetaspriteNormal
    ld a, [wMinigamePhaseCounter]
    cp $ff
    jr nz, jr_002_590c

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


jr_002_590c::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ld b, a
    ld a, [wMinigamePhaseCounter]
    or b
    jp nz, Jump_002_59cd

    call InitSound
    ld a, $2c
    call PlaySound_Queue3
    ld bc, _SCRN0 + $128
    ld de, $0004
    call QueueVramFill
    ld bc, _SCRN0 + $148
    ld de, $0004
    call QueueVramFill
    ld de, Scene3Mode1StatusTiles
    ld hl, _SCRN0 + $201
    ld bc, $1102
    call QueueTilemapRect
    ld a, $02
    ld [wScreenSubstate], a
    xor a
    ld [wSharedWork + $176], a
    ld [wSharedWork + $29], a
    ld a, [wMinigameRound]
    ld b, a
    sla a
    add b
    ld hl, Scene3Mode1CommandTable
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, _SCRN0 + $22f
    ld a, [de]
    cp $04
    jr nz, jr_002_5968

    inc de
    inc hl
    dec b

jr_002_5968::
    call QueueTilemapRect
    ld a, [wMinigameRound]
    dec a
    ld b, a
    add a
    add b
    ld hl, Scene3Mode1SpritePositions
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
    ld [wSharedWork + $56], a
    ld [wSharedWork + $57], a
    ld [wSharedWork + $58], a
    ld hl, SceneAnim_79bb
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wSharedWork + $4c], a
    ld [wSharedWork + $50], a
    cpl
    ld [wSharedWork + $4f], a
    call AdvanceScreenRandomByte
    and $07
    add $0a
    ld [wSharedWork + $4e], a
    ld b, $04
    ld hl, wSharedWork + $2b

jr_002_59ba::
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
    jr nz, jr_002_59ba

    ret


Jump_002_59cd::
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
    jr nz, jr_002_5a02

    ld a, $5a

jr_002_5a02::
    call PlaySound
    ret


Minigame1_State02::
; Minigame1StateHandlers index $02; detailed phase behavior remains to be named.
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, PauseMinigame
    ld a, [wSharedWork + $176]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wMinigamePhaseCounter]
    cp $01
    jr nz, jr_002_5a2f

    ld a, [wSharedWork + $4e]
    or a
    jr z, jr_002_5a2f

    dec a
    ld [wSharedWork + $4e], a

jr_002_5a2f::
    ld a, [wSharedWork + $50]
    or a
    jp z, jr_002_5abe

    ld c, a
    ld a, [wSharedWork + $4f]
    bit 7, a
    jr z, jr_002_5a45

    ld a, [wSharedWork + $50]
    dec a
    ld [wSharedWork + $50], a

jr_002_5a45::
    ld a, [wSharedWork + $4f]
    and $7f
    swap a
    add a
    or $18
    ld b, a
    ld a, $00
    bit 7, c
    jr z, jr_002_5a58

    ld a, $02

jr_002_5a58::
    ldh [hSpriteFlags], a
    ld d, $76
    call DrawBank3MetaspriteFar
    ld a, [wSharedWork + $176]
    ld b, a
    ld a, [wSharedWork + $4f]
    bit 7, a
    jr z, jr_002_5abe

    and $7f
    cp b
    jr nz, jr_002_5abe

    ld a, [wSharedWork + $50]
    cp $18
    jr nc, jr_002_5abe

    ld a, $20
    ld [wSharedWork + $4d], a
    ld a, $49
    call PlaySound_Queue1
    xor a
    ld c, a
    ld [wSharedWork + $50], a
    ld hl, wSharedWork + $2b
    ld de, $0008
    ld b, $04

jr_002_5a8d::
    push hl
    ld a, [hl]
    res 3, [hl]
    set 1, [hl]
    inc hl
    inc hl
    bit 1, a
    jr nz, jr_002_5aa4

    ld a, [hl]
    cp $98
    inc hl
    inc hl
    inc hl
    ld [hl], $00
    jr nc, jr_002_5aa4

    inc c

jr_002_5aa4::
    pop hl
    add hl, de
    dec b
    jr nz, jr_002_5a8d

    ld a, c
    ld c, $00
    bit 0, a
    jr z, jr_002_5ab2

    ld c, $05

jr_002_5ab2::
    srl a
    ld b, a
    ld hl, Scene3Mode1CommandTable
    call Call_002_6509
    jp nc, Jump_002_5d58

jr_002_5abe::
    ldh a, [hJoyPressed]
    and $03
    jr z, jr_002_5aed

    ld a, [wSharedWork + $29]
    or a
    jr nz, jr_002_5aed

    ld a, [wSharedWork + $176]
    ld [wSharedWork + $2a], a
    ld a, $1a
    ld [wSharedWork + $29], a
    xor a
    ld [wSharedWork + $28], a
    ld a, $50
    call PlaySound
    ld hl, SceneAnim_79b7
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

jr_002_5aed::
    call Call_002_5b7f
    call TickMinigameCountdown
    or a
    jr nz, jr_002_5b16

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


jr_002_5b16::
    ld a, [wSharedWork + $4c]
    dec a
    ld [wSharedWork + $4c], a
    cp $ff
    jr z, jr_002_5b32

    or a
    ret nz

    ld hl, SceneAnim_79bb
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

jr_002_5b32::
    xor a
    ld [wSharedWork + $4c], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [wSharedWork + $176]
    bit 6, b
    jr z, jr_002_5b44

    or a
    jr z, jr_002_5b44

    dec a

jr_002_5b44::
    bit 7, b
    jr z, jr_002_5b4d

    cp $03
    jr nc, jr_002_5b4d

    inc a

jr_002_5b4d::
    ld [wSharedWork + $176], a
    ld hl, wSharedWork + $28
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    or a
    ret z

    ld bc, $0300
    add hl, bc
    ld a, l
    ld [wSharedWork + $28], a
    ld a, h
    ld [wSharedWork + $29], a
    ld a, h
    cp $98
    jr nc, jr_002_5b7a

    ld c, h
    ld a, [wSharedWork + $2a]
    swap a
    add a
    or $16
    ld b, a
    ld d, $62
    call DrawBank3MetaspriteNormal
    ret


jr_002_5b7a::
    xor a
    ld [wSharedWork + $29], a
    ret


Call_002_5b7f::
    call Call_002_5e5a
    ldh a, [hTileStreamCount]
    ldh [hSharedScratch + $0c], a
    xor a
    ldh [hTileStreamCount], a
    ld a, $04
    ldh [hSharedScratch + $0d], a
    ld hl, wSharedWork + $4b

Jump_002_5b90::
    ldh a, [hSharedScratch + $0d]
    dec a
    ldh [hSharedScratch + $0a], a
    swap a
    add a
    or $17
    ldh [hTileStreamWritePos], a
    ld bc, -$0008
    add hl, bc
    push hl
    ld a, [wScreenSubstate]
    cp $04
    jr nz, jr_002_5bac

    set 1, [hl]
    res 3, [hl]

jr_002_5bac::
    ld a, [hl+]
    ld d, a
    and $07
    cp $01
    jr nz, jr_002_5bb9

    ldh a, [hTileStreamCount]
    inc a
    ldh [hTileStreamCount], a

jr_002_5bb9::
    ld bc, $0200
    bit 1, d
    jr nz, jr_002_5bd4

    push hl
    push de
    ld a, [wMinigameRound]
    dec a
    ld hl, Scene3Mode1MetaspriteMotionData
    bit 0, d
    jr z, jr_002_5bcf

    add $0a

jr_002_5bcf::
    rst $20
    ld c, l
    ld b, h
    pop de
    pop hl

jr_002_5bd4::
    bit 3, d
    jr z, jr_002_5bdb

    ld bc, $0000

jr_002_5bdb::
    ld a, c
    add [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a
    ld a, [hl-]
    dec hl
    cp $2a
    jr nc, jr_002_5c08

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

jr_002_5c08::
    inc hl
    inc hl
    ld a, [hl]
    bit 1, d
    jr z, jr_002_5c67

    cp $a8
    jr c, jr_002_5c67

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
    add $b8
    ld c, a
    ld a, $00
    adc $5e
    ld b, a
    ld a, [bc]
    ld c, a
    ldh a, [hSharedScratch + $0c]
    cp $03
    jr c, jr_002_5c3d

    ld c, $00

jr_002_5c3d::
    call AdvanceScreenRandomByte
    and $07
    cp c
    ld a, $00
    jr nc, jr_002_5c49

    ld a, $01

jr_002_5c49::
    ld [hl+], a
    inc hl
    ld a, [wSharedWork + $4e]
    or a
    jr nz, jr_002_5c67

    call AdvanceScreenRandomByte
    and $07
    add $0a
    ld [wSharedWork + $4e], a
    ld a, [wSharedWork + $50]
    or a
    jr nz, jr_002_5c67

    ldh a, [hSharedScratch + $0d]
    dec a
    ld [wSharedWork + $4f], a

jr_002_5c67::
    ld a, [wSharedWork + $4f]
    bit 7, a
    jr nz, jr_002_5c7e

    ld a, [wSharedWork + $4f]
    inc a
    ld b, a
    ldh a, [hSharedScratch + $0d]
    cp b
    jr nz, jr_002_5c7e

    ld a, [hl]
    sub $14
    ld [wSharedWork + $50], a

jr_002_5c7e::
    ld a, [hl+]
    ld c, a
    inc hl
    bit 3, d
    jr nz, jr_002_5c97

    bit 0, d
    jr z, jr_002_5ca5

    ld a, [hl]
    cp c
    jr c, jr_002_5ca5

    ld [hl], $30
    pop de
    push de
    ld a, [de]
    set 3, a
    ld [de], a
    jr jr_002_5ca5

jr_002_5c97::
    dec [hl]
    ld a, [hl]
    or a
    jr nz, jr_002_5ca5

    pop de
    push de
    ld a, [de]
    res 3, a
    ld [de], a
    inc hl
    ld a, c
    ld [hl-], a

jr_002_5ca5::
    dec hl
    push hl
    ldh a, [hTileStreamWritePos]
    ld b, a
    ld a, c
    srl a
    srl a
    srl a
    and $03
    bit 1, d
    jr z, jr_002_5cb9

    ld a, $04

jr_002_5cb9::
    bit 3, d
    jr z, jr_002_5cbf

    ld a, $05

jr_002_5cbf::
    ld hl, Scene3Mode1MotionTableA
    bit 0, d
    jr z, jr_002_5cc9

    ld hl, Scene3Mode1MotionTableB

jr_002_5cc9::
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteWithPriority
    pop hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    jr z, jr_002_5d18

    cp $20
    jr nc, jr_002_5d00

    cp $10
    jr c, jr_002_5d00

    ldh a, [hSharedScratch + $0a]
    ld b, a
    ld a, [wSharedWork + $176]
    cp b
    jr nz, jr_002_5d00

    ld bc, SceneAnim_79cd
    ld a, c
    ld [wSceneAnim0PtrLo], a
    ld a, b
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [hl], a
    ld a, $78
    ld [wSharedWork + $4c], a
    ld a, $51
    call PlaySound

jr_002_5d00::
    inc hl
    ld bc, -$0280
    ld a, [hl]
    add c
    ld [hl-], a
    ld a, [hl]
    adc b
    cp $f0
    jr c, jr_002_5d0e

    xor a

jr_002_5d0e::
    ld [hl], a
    ld c, a
    ldh a, [hTileStreamWritePos]
    ld b, a
    ld d, $72
    call DrawBank3MetaspriteNormal

jr_002_5d18::
    pop hl
    ldh a, [hSharedScratch + $0d]
    dec a
    ldh [hSharedScratch + $0d], a
    jp nz, Jump_002_5b90

    ld a, [wSharedWork + $2a]
    swap a
    srl a
    ld hl, wSharedWork + $2b
    rst $38
    inc hl
    inc hl
    ld b, [hl]
    ld a, [wSharedWork + $29]
    cp b
    jr c, jr_002_5d91

    ld a, $52
    call PlaySound
    xor a
    ld [wSharedWork + $29], a
    dec hl
    dec hl
    set 1, [hl]
    res 3, [hl]
    ld bc, $0005
    add hl, bc
    ld [hl], $00
    ld a, [wSharedWork + $df]
    ld bc, $0005
    ld hl, Scene3Mode1CommandTable
    call Call_002_6509
    jr c, jr_002_5d82

Jump_002_5d58::
    ld a, $04
    ld [wScreenSubstate], a
    ld hl, SceneAnim_79be
    ld a, [wMinigameRound]
    cp $0a
    jr nz, jr_002_5d6a

    ld hl, SceneAnim_79d4

jr_002_5d6a::
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


jr_002_5d82::
    ld a, [wSharedWork + $2a]
    ld b, a
    ld a, [wSharedWork + $4f]
    cp b
    ret nz

    set 7, a
    ld [wSharedWork + $4f], a
    ret


jr_002_5d91::
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    ret z

    ld b, a
    ld a, [wSharedWork + $29]
    or a
    ret z

    cp b
    ret c

    xor a
    ld [hl], a
    ld [wSharedWork + $29], a
    ret


Minigame1_State03::
; Minigame1StateHandlers index $03; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $176]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld b, $04
    ld hl, wSharedWork + $4b

jr_002_5dbb::
    push bc
    ld e, b
    ld bc, -$0008
    add hl, bc
    push hl
    ld d, $00
    bit 0, [hl]
    jr z, jr_002_5dca

    ld d, $02

jr_002_5dca::
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
    jr c, jr_002_5dde

    ld a, $02

jr_002_5dde::
    ldh [hSpriteFlags], a
    ld a, [wScreenFrameCounter]
    bit 4, a
    jr nz, jr_002_5de8

    inc d

jr_002_5de8::
    ld a, d
    ld hl, Scene3Mode1AnimationFramesA
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteFar
    pop hl
    pop bc
    dec b
    jr nz, jr_002_5dbb

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


Minigame1_State04::
; Minigame1StateHandlers index $04; detailed phase behavior remains to be named.
    ld hl, wSharedWork + $30
    xor a
    ld de, $0008
    ld b, $04

jr_002_5e21::
    ld [hl], a
    add hl, de
    dec b
    jr nz, jr_002_5e21

    call Call_002_5b7f
    ld a, [wSharedWork + $176]
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


Call_002_5e5a::
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    srl a
    srl a
    and $06
    ld hl, Scene3Mode1AnimationFramesB
    rst $38
    ld e, l
    ld d, h
    ld hl, _SCRN0 + $023

jr_002_5e70::
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
    jr nz, jr_002_5e70

    ret



Scene3Mode1MetaspriteMotionData::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $80, $ff, $79, $ff, $71, $ff, $69, $ff, $61, $ff, $5a, $ff, $52, $ff, $4a, $ff
    db $42, $ff, $3a, $ff, $40, $ff, $39, $ff, $31, $ff, $29, $ff, $21, $ff, $1a, $ff
    db $12, $ff, $0a, $ff, $02, $ff, $fa, $fe

Scene3Mode1MotionTableA::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $69, $6a, $69, $6b, $6d, $6d

Scene3Mode1MotionTableB::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $6e, $6f, $6e, $70, $75, $71, $01, $01, $02, $02, $03, $03, $04, $04, $05, $05

Scene3Mode1AnimationFramesA::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $6c, $69, $73, $74

Scene3Mode1AnimationFramesB::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $91, $a1, $a8, $a9, $aa, $ab, $a8, $a9

Scene3Mode1StatusTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $85, $86, $87, $ac, $ac, $ac, $ac, $ac, $80, $81, $ac, $ac, $ac, $ac, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

Scene3Mode1SpritePositions::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $03, $01, $00, $04, $01, $00, $05, $01, $00, $06, $01, $00, $07, $01, $00
    db $08, $01, $00, $09, $01, $01, $00, $01, $01, $01, $01, $01, $02, $01

Scene3Mode1CommandTable::
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
    dw Minigame2_State01 ; $01
    dw Minigame2_State02 ; $02

Minigame2_State01::
; Minigame2StateHandlers index $01; detailed phase behavior remains to be named.
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
    jr nz, jr_002_5fe1

    ld a, [wMinigameRound]
    ld [wMsgSubstitutionId], a
    xor a
    ld [wMessageFlags], a
    ld a, $14
    call StartMessageFar
    ld bc, _SCRN0 + $201
    ld de, _VRAM + $1111
    call QueueVramFill
    ld bc, _SCRN0 + $221
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [wMinigamePhaseCounter], a
    ret


jr_002_5fe1::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    ld b, a
    ld a, [wMinigamePhaseCounter]
    or b
    jp nz, Jump_002_60a2

    call InitSound
    ld a, $24
    call PlaySound_Queue3
    ld de, ScreenData_6706
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
    ld hl, ScreenData_6728
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, _SCRN0 + $22f
    ld a, [de]
    cp $04
    jr nz, jr_002_602f

    inc de
    inc hl
    dec b

jr_002_602f::
    call QueueTilemapRect
    xor a
    ld [wMinigameTimerHundreds], a
    ld a, $09
    ld [wMinigameTimerTens], a
    ld [wMinigameTimerOnes], a
    ld a, $04
    ld [wSharedWork + $56], a
    ld [wSharedWork + $57], a
    ld [wSharedWork + $58], a
    ld a, $32
    ld [wMinigamePhaseCounter], a
    ld a, $02
    ld [wScreenSubstate], a
    ld a, $a0
    ld [wSharedWork + $5a], a
    ld hl, SceneAnim_7913
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wSharedWork + $dd], a
    ld [wSharedWork + $156], a
    ld a, $50
    ld [wSharedWork + $175], a
    ld a, $40
    ld [wSharedWork + $176], a
    ld a, $02
    ld [wSharedWork + $177], a
    ld hl, ScreenData_6846
    ld de, wSharedWork + $e2
    ld b, $10

jr_002_6084::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_6084

    ld a, $80
    ld hl, wSharedWork + $5d
    ld bc, $0008
    ld d, $10

jr_002_6094::
    ld [hl], a
    add hl, bc
    dec d
    jr nz, jr_002_6094

    call AdvanceScreenRandomByte
    and $03
    ld [wSharedWork + $59], a
    ret


Jump_002_60a2::
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
    jr nz, jr_002_60d7

    ld a, $5a

jr_002_60d7::
    call PlaySound
    ret


Minigame2_State02::
; Minigame2StateHandlers index $02; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $157]
    inc a
    ld [wSharedWork + $157], a
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, PauseMinigame
    ld a, [wSharedWork + $175]
    ld c, a
    ld a, [wSharedWork + $176]
    ld b, a
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wSharedWork + $156]
    or a
    jr z, jr_002_6108

    dec a
    ld [wSharedWork + $156], a
    bit 3, a
    jr z, jr_002_6108

    xor a
    ldh [hOamWritePos], a

jr_002_6108::
    call Call_002_65b3
    call Call_002_64d9
    ld a, [wSharedWork + $5c]
    inc a
    ld [wSharedWork + $5c], a
    call TickMinigameCountdown
    or a
    jr nz, jr_002_6141

    ld a, $04
    ld [wSharedWork + $dd], a
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

jr_002_6141::
    ld a, [wSharedWork + $5a]
    dec a
    ld [wSharedWork + $5a], a
    cp $60
    jp nc, jr_002_6204

    and $0f
    jp nz, jr_002_6204

    ld a, [wSharedWork + $59]
    sla a
    sla a
    ld hl, ScreenData_6749
    rst $38
    ld a, [hl+]
    push hl
    ld h, [hl]
    ld l, a
    ld a, [wSharedWork + $5a]
    ld de, ScreenData_6759
    bit 4, a
    jr z, jr_002_6176

    ld a, [wSharedWork + $dd]
    cp $04
    jp z, jr_002_6176

    ld de, ScreenData_675c

jr_002_6176::
    ld bc, $0301
    call QueueTilemapRect
    pop hl
    ld a, [wSharedWork + $5a]
    or a
    jp nz, jr_002_6204

    ld a, [wSharedWork + $dd]
    cp $04
    jp z, jr_002_6204

    inc hl
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    ld a, [hl]
    ldh [hSharedScratch + $0a], a
    ld a, [wMinigameRound]
    dec a
    add a
    add a
    ld hl, ScreenData_676b
    rst $38
    call AdvanceScreenRandomByte
    and $07
    ld b, $00

jr_002_61a4::
    sub [hl]
    jr c, jr_002_61ab

    inc b
    inc hl
    jr jr_002_61a4

jr_002_61ab::
    ld a, b
    ldh [hTileStreamCount], a
    ld a, [wSharedWork + $59]
    ld b, a
    add a
    add b
    ld hl, ScreenData_675f
    rst $38
    ldh a, [hTileStreamCount]
    cp $03
    jr nz, jr_002_61c8

    call AdvanceScreenRandomByte
    bit 0, a
    jr z, jr_002_61cc

    inc hl
    jr jr_002_61cc

jr_002_61c8::
    call ChooseScreenRandomThird
    rst $38

jr_002_61cc::
    ld d, [hl]
    ld hl, wSharedWork + $5d
    ld b, $10

jr_002_61d2::
    ld a, [hl]
    bit 7, a
    jr nz, jr_002_61df

    ld a, $08
    rst $38
    dec b
    jr nz, jr_002_61d2

    jr jr_002_6204

jr_002_61df::
    ldh a, [hTileStreamCount]
    ld [hl+], a
    ld [hl], d
    inc hl
    ldh a, [hTileStreamWritePos]
    ld [hl+], a
    ldh a, [hSharedScratch + $0a]
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
    ld [wSharedWork + $5a], a
    call AdvanceScreenRandomByte
    and $03
    ld [wSharedWork + $59], a

jr_002_6204::
    ld b, $10
    ld hl, wSharedWork + $5d

Jump_002_6209::
    push bc
    push hl
    ld a, [hl]
    and $c0
    jp nz, jr_002_6290

    ld a, [hl]
    push hl
    cp $03
    call nc, Call_002_62a9
    pop hl
    ld a, [hl]
    sla a
    ld de, ScreenData_6793
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
    jr nz, jr_002_623c

    cpl
    inc a

jr_002_623c::
    bit 0, b
    jr nz, jr_002_6241

    inc hl

jr_002_6241::
    add [hl]
    ld [hl], a
    pop hl
    ld a, [hl]
    ld c, a
    bit 7, a
    jr z, jr_002_6255

    cp $a0
    jr c, jr_002_6255

    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr jr_002_6290

jr_002_6255::
    inc hl
    ld a, [hl]
    ld b, a
    bit 7, a
    jr z, jr_002_6268

    cp $80
    jr c, jr_002_6268

    dec hl
    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr jr_002_6290

jr_002_6268::
    dec hl
    dec hl
    ld a, [wSharedWork + $5c]
    and $10
    jr z, jr_002_6272

    scf

jr_002_6272::
    ld a, [hl-]
    rla
    ld d, a
    ld a, [hl]
    swap a
    srl a
    or d
    ld hl, ScreenData_67a5
    rst $38
    ld a, $01
    ld d, [hl]
    bit 7, d
    jr nz, jr_002_6287

    xor a

jr_002_6287::
    ldh [hSpriteFlags], a
    ld a, d
    and $7f
    ld d, a
    call DrawBank3MetaspriteFar

jr_002_6290::
    pop hl
    ld bc, $0008
    add hl, bc
    pop bc
    dec b
    jp nz, Jump_002_6209

    ld a, [wSharedWork + $dd]
    rst $00

Minigame2SecondaryStateHandlers::
    dw Minigame2_Secondary_State00 ; $00
    dw Minigame2_Secondary_State01 ; $01
    dw Minigame2_Secondary_State02 ; $02
    dw Minigame2_Secondary_State03 ; $03
    dw Minigame2_Secondary_State04 ; $04

Minigame2_Secondary_State03::
; Minigame2SecondaryStateHandlers index $03; detailed phase behavior remains to be named.
    ret


Call_002_62a9::
    ld a, [hl]
    and $01
    jr z, jr_002_62cd

    ld bc, $0005
    add hl, bc
    ld a, [hl]
    dec hl
    dec hl
    ld bc, ScreenData_6835
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


jr_002_62cd::
    ld bc, $0005
    add hl, bc
    dec [hl]
    ld a, [hl]
    cp $10
    jr nz, jr_002_6316

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
    jr nz, jr_002_6310

jr_002_62eb::
    ld a, d
    inc a
    cp $02
    jr nz, jr_002_62f3

    ld a, $ff

jr_002_62f3::
    ld d, a
    add [hl]
    ld b, a
    push hl
    ld c, $3c
    bit 1, b
    jr nz, jr_002_62ff

    ld c, $c4

jr_002_62ff::
    inc hl
    bit 0, b
    jr nz, jr_002_6305

    inc hl

jr_002_6305::
    ld a, c
    add [hl]
    pop hl
    cp $0c
    jr c, jr_002_62eb

    cp $88
    jr nc, jr_002_62eb

jr_002_6310::
    ld a, d
    add [hl]
    and $03
    ld [hl], a
    ret


jr_002_6316::
    ld a, [hl]
    or a
    ret nz

    ld [hl], $10
    ld bc, -$0005
    add hl, bc
    dec [hl]
    ret


Minigame2_Secondary_State00::
; Minigame2SecondaryStateHandlers index $00; detailed phase behavior remains to be named.
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_634c

    ld a, [wSharedWork + $177]
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
    ld [wSharedWork + $dd], a
    ld a, $11
    ld [wScreenFrameCounter], a
    ld a, $ff
    ld [wSharedWork + $de], a
    ret


jr_002_634c::
    ldh a, [hJoyHeld]
    and $f0
    jr nz, jr_002_635a

    ld a, [wSceneAnim0Timer]
    inc a
    ld [wSceneAnim0Timer], a
    ret


jr_002_635a::
    ld bc, $0180
    ld a, [wSharedWork + $5b]
    add c
    ld [wSharedWork + $5b], a
    ld a, $00
    adc b
    ld c, a
    ld d, $00
    ld e, d
    ldh a, [hJoyHeld]
    ld h, a
    ld b, $ff
    bit 6, h
    jr z, jr_002_637a

    ld b, $00
    ld a, $00
    sub c
    ld e, a

jr_002_637a::
    bit 5, h
    jr z, jr_002_6384

    ld b, $01
    ld a, $00
    sub c
    ld d, a

jr_002_6384::
    bit 7, h
    jr z, jr_002_638b

    ld b, $02
    ld e, c

jr_002_638b::
    bit 4, h
    jr z, jr_002_6392

    ld b, $03
    ld d, c

jr_002_6392::
    ld a, [wSharedWork + $175]
    add d
    ld [wSharedWork + $175], a
    ld a, [wSharedWork + $176]
    add e
    ld [wSharedWork + $176], a
    ld a, [wSharedWork + $177]
    ld hl, ScreenData_681d
    rst $38
    ld c, [hl]
    ldh a, [hJoyHeld]
    and c
    jr nz, jr_002_63c7

    ld a, b
    bit 7, a
    jr nz, jr_002_63c7

    ld [wSharedWork + $177], a
    and $03
    ld hl, Minigame2IdleAnimationPointers
    rst $20
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

jr_002_63c7::
    ld a, [wSharedWork + $175]
    cp $0a
    jr nc, jr_002_63d0

    ld a, $0a

jr_002_63d0::
    cp $95
    jr c, jr_002_63d6

    ld a, $95

jr_002_63d6::
    ld [wSharedWork + $175], a
    ld a, [wSharedWork + $176]
    cp $0a
    jr nc, jr_002_63e2

    ld a, $0a

jr_002_63e2::
    cp $75
    jr c, jr_002_63e8

    ld a, $75

jr_002_63e8::
    ld [wSharedWork + $176], a
    ret


Minigame2_Secondary_State01::
; Minigame2SecondaryStateHandlers index $01; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $de]
    bit 7, a
    jr z, jr_002_6464

    ld a, [wSharedWork + $177]
    add a
    add a
    ld b, a
    add a
    add b
    ld hl, ScreenData_67ed
    rst $38
    ld a, [wScreenFrameCounter]
    ld bc, $0004
    cp $06
    jr nc, jr_002_640a

    add hl, bc

jr_002_640a::
    cp $0c
    jr nc, jr_002_640f

    add hl, bc

jr_002_640f::
    ld a, [wSharedWork + $175]
    ld b, a
    ld a, [wSharedWork + $176]
    ld c, a
    ld a, [hl+]
    add b
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    add c
    ldh [hSharedScratch + $0a], a
    ld a, [hl+]
    add b
    ldh [hTileStreamCount], a
    ld a, [hl+]
    add c
    ldh [hSharedScratch + $0c], a
    ld b, $10
    ld hl, wSharedWork + $5d

jr_002_642c::
    push hl
    ld a, [hl+]
    bit 7, a
    jr nz, jr_002_645d

    inc hl
    ld c, [hl]
    ldh a, [hTileStreamWritePos]
    cp c
    jr nc, jr_002_645d

    ldh a, [hTileStreamCount]
    cp c
    jr c, jr_002_645d

    inc hl
    ld c, [hl]
    ldh a, [hSharedScratch + $0a]
    cp c
    jr nc, jr_002_645d

    ldh a, [hSharedScratch + $0c]
    cp c
    jr c, jr_002_645d

    dec hl
    dec hl
    dec hl
    ld a, [hl]
    cp $04
    jr nz, jr_002_6454

    ld a, $03

jr_002_6454::
    ld [wSharedWork + $de], a
    ld a, $80
    ld [hl], a
    pop hl
    jr jr_002_6464

jr_002_645d::
    pop hl
    ld a, $08
    rst $38
    dec b
    jr nz, jr_002_642c

jr_002_6464::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    xor a
    ld [wSharedWork + $dd], a
    ld a, [wSharedWork + $de]
    bit 7, a
    jr nz, jr_002_64c0

    ld [wSharedWork + $df], a
    ld a, $44
    call PlaySound
    ld a, [wSharedWork + $175]
    ld [wSharedWork + $e0], a
    ld a, [wSharedWork + $176]
    ld [wSharedWork + $e1], a
    ld a, $20
    ld [wScreenPhaseCounter], a
    ld a, [wSharedWork + $df]
    ld hl, ScreenData_679d
    rst $20
    ld b, l
    ld c, h
    ld hl, ScreenData_6728
    call Call_002_6509
    jr c, jr_002_64c0

    ld a, $04
    ld [wSharedWork + $dd], a
    xor a
    ld [wMinigameResultFlag], a
    ld a, $90
    ld [wScreenFrameCounter], a
    xor a
    ld [wSharedWork + $e6], a
    ld [wSharedWork + $ee], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


jr_002_64c0::
    ld a, [wSharedWork + $177]
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


Call_002_64d9::
    ld a, [wScreenPhaseCounter]
    or a
    ret z

    ld a, [wScreenPhaseCounter]
    dec a
    ld [wScreenPhaseCounter], a
    srl a
    ld hl, ScreenData_6821
    rst $38
    ld a, [wSharedWork + $e0]
    add [hl]
    ld c, a
    ld a, [wScreenPhaseCounter]
    srl a
    sub $18
    ld b, a
    ld a, [wSharedWork + $e1]
    add b
    ld b, a
    ld hl, ScreenData_6831
    ld a, [wSharedWork + $df]
    rst $38
    ld d, [hl]
    call DrawBank3MetaspriteNormal
    ret


Call_002_6509::
    push hl
    ld hl, wSharedWork + $58
    ld a, c
    add [hl]
    ld [hl-], a
    dec de
    ld a, b
    add [hl]
    ld [hl+], a
    ld a, [hl]
    cp $0e
    jr c, jr_002_651e

    sub $0a
    ld [hl-], a
    inc [hl]
    inc hl

jr_002_651e::
    dec hl
    ld a, [hl]
    cp $0e
    jr c, jr_002_6528

    sub $0a
    ld [hl-], a
    inc [hl]

jr_002_6528::
    ld de, wSharedWork + $56
    ld hl, _SCRN0 + $221
    ld b, $03

jr_002_6530::
    ld a, [de]
    cp $04
    jr nz, jr_002_653a

    inc hl
    inc de
    dec b
    jr nz, jr_002_6530

jr_002_653a::
    ld c, $01
    call QueueTilemapRect
    ld a, [wMinigameRound]
    ld b, a
    add a
    add b
    pop hl
    rst $38
    ld de, wSharedWork + $56
    ld b, $03

jr_002_654c::
    ld a, [de]
    sub [hl]
    ret c

    jr nz, jr_002_6556

    inc de
    inc hl
    dec b
    jr nz, jr_002_654c

jr_002_6556::
    or a
    ret


Minigame2_Secondary_State04::
; Minigame2SecondaryStateHandlers index $04; detailed phase behavior remains to be named.
    ld a, [wScreenFrameCounter]
    cp $60
    jr nz, jr_002_657e

    ld a, [wMinigameResultFlag]
    or a
    jr nz, jr_002_657e

    ld hl, SceneAnim_794b
    ld a, [wMinigameRound]
    cp $0a
    jr nz, jr_002_6572

    ld hl, SceneAnim_796e

jr_002_6572::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

jr_002_657e::
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


Minigame2_Secondary_State02::
; Minigame2SecondaryStateHandlers index $02; detailed phase behavior remains to be named.
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    xor a
    ld [wSharedWork + $dd], a
    ld a, $c0
    ld [wSharedWork + $156], a
    jp jr_002_64c0


Call_002_65b3::
    ld hl, wSharedWork + $e2
    ld de, ScreenData_67cd
    ld a, [wMinigameRound]
    cp $04
    call nc, Call_002_65d0
    ld hl, wSharedWork + $ea
    ld de, ScreenData_67d1
    ld a, [wMinigameRound]
    cp $07
    call nc, Call_002_65d0
    ret


Call_002_65d0::
    ld a, [hl+]
    or a
    jp nz, Jump_002_66d7

    push de
    ld c, $00
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [wSharedWork + $175]
    add $08
    sub b
    jr nc, jr_002_65e8

    cpl
    inc a
    set 0, c

jr_002_65e8::
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [wSharedWork + $176]
    add $08
    sub b
    jr nc, jr_002_65fa

    cpl
    inc a
    set 1, c

jr_002_65fa::
    ldh [hSharedScratch + $0a], a
    push hl
    inc hl
    ld a, [hl]
    or a
    jr z, jr_002_660d

    dec a
    ld [hl+], a
    ldh a, [hTileStreamWritePos]
    ld [hl+], a
    ldh a, [hSharedScratch + $0a]
    ld [hl+], a
    ld [hl], c
    jr jr_002_6615

jr_002_660d::
    inc hl
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    ldh [hSharedScratch + $0a], a
    ld c, [hl]

jr_002_6615::
    pop hl
    ldh a, [hTileStreamWritePos]
    ld b, a
    ldh a, [hSharedScratch + $0a]
    cp b
    jr c, jr_002_6628

    ld b, $00
    bit 1, c
    jr nz, jr_002_6630

    ld b, $02
    jr jr_002_6630

jr_002_6628::
    ld b, $01
    bit 0, c
    jr nz, jr_002_6630

    ld b, $03

jr_002_6630::
    ld a, b
    cp $01
    jr z, jr_002_6636

    xor a

jr_002_6636::
    ldh [hSpriteFlags], a
    pop de
    ld a, b
    rst $30
    ld a, [de]
    ldh [hTileStreamCount], a
    ld d, $00
    ld e, d
    ld a, [hl]
    ld b, a
    ldh a, [hSharedScratch + $0a]
    cp b
    jr c, jr_002_6656

    ldh a, [hTileStreamWritePos]
    add b
    ld [hl], a
    ld e, $01
    bit 1, c
    jr z, jr_002_6664

    ld e, $ff
    jr jr_002_6664

jr_002_6656::
    ldh a, [hSharedScratch + $0a]
    ld b, a
    ld a, [hl]
    sub b
    ld [hl], a
    ld d, $01
    bit 0, c
    jr z, jr_002_6664

    ld d, $ff

jr_002_6664::
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
    jr nc, jr_002_667c

    ld a, b
    add $08
    cp $f0
    jr c, jr_002_6685

jr_002_667c::
    call AdvanceScreenRandomByte
    and $03
    add $03
    ld [hl+], a
    ld [hl-], a

jr_002_6685::
    pop bc
    push bc
    ld a, [wSharedWork + $175]
    add $0e
    sub c
    cp $1c
    jr nc, jr_002_66c7

    ld a, [wSharedWork + $176]
    add $0e
    sub b
    cp $1c
    jr nc, jr_002_66c7

    ld bc, $0004
    add hl, bc
    xor a
    ld [hl], a
    ld a, [wSharedWork + $dd]
    cp $02
    jr nc, jr_002_66c7

    ld a, [wSharedWork + $156]
    or a
    jr nz, jr_002_66c7

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
    ld [wSharedWork + $dd], a

jr_002_66c7::
    pop bc
    ldh a, [hTileStreamCount]
    ld d, a
    ld a, [wSharedWork + $157]
    bit 3, a
    jr nz, jr_002_66d3

    inc d

jr_002_66d3::
    call DrawBank3MetaspriteFar
    ret


Jump_002_66d7::
    ld a, [wSharedWork + $f2]
    ld b, a
    call ChooseScreenRandomThird
    add [hl]
    cp b
    jr z, jr_002_66e3

    inc b

jr_002_66e3::
    cp $0c
    jr c, jr_002_66e9

    sub $0c

jr_002_66e9::
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
    ld de, ScreenData_6856
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



ScreenData_6706::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $85, $86, $87, $91, $91, $91, $91, $91, $80, $81, $91, $91, $91, $91, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

ScreenData_6728::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $04, $04, $04, $0c, $04, $05, $05, $04, $05, $08, $04, $05, $0b, $04, $06
    db $04, $04, $06, $07, $04, $06, $0a, $04, $06, $0d, $04, $07, $06, $04, $07, $09
    db $04

ScreenData_6749::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $4b, $98, $64, $14, $a2, $98, $1c, $2c, $2f, $99, $84, $4c, $c5, $99, $34, $74

ScreenData_6759::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $88, $89, $8a

ScreenData_675c::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $8b, $8c, $8d

ScreenData_675f::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $01, $02, $03, $02, $03, $00, $00, $01, $02, $00, $03, $01

ScreenData_676b::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $02, $01, $01, $04, $02, $01, $01, $03, $02, $02, $01, $03, $02, $02, $01
    db $02, $03, $02, $01, $02, $03, $02, $01, $02, $02, $03, $01, $02, $02, $03, $01
    db $01, $02, $03, $02, $01, $02, $02, $03

ScreenData_6793::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $60, $00, $b0, $00, $00, $01, $e0, $01, $00, $00

ScreenData_679d::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $05, $01, $00, $01, $05, $02, $00

ScreenData_67a5::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $33, $4f, $34, $b4, $33, $4f, $34, $b4, $50, $51, $b7, $b8, $35, $36, $37, $38
    db $4c, $cc, $ad, $ae, $2c, $ac, $2d, $2e, $ce, $ce, $b2, $b2, $30, $30, $32, $32
    db $cd, $cd, $b1, $b1, $2f, $2f, $31, $31

ScreenData_67cd::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $42, $40, $3e, $40

ScreenData_67d1::
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

ScreenData_67ed::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $f6, $0c, $0a, $1e, $f6, $f4, $0a, $0c, $f6, $e0, $0a, $f4, $00, $dc, $14, $f0
    db $e4, $e8, $00, $fd, $e4, $fd, $f8, $08, $f6, $dd, $0a, $f4, $f6, $f4, $0a, $0c
    db $f6, $0c, $0a, $1b, $ec, $dc, $00, $f0, $00, $e8, $1c, $fd, $08, $fd, $1c, $08

ScreenData_681d::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $40, $20, $80, $10

ScreenData_6821::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $03, $02, $02, $01, $00, $ff, $fe, $fe, $fe, $fe, $fe, $ff, $00, $01, $02, $02

ScreenData_6831::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $3c, $3b, $3a, $3d

ScreenData_6835::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $03, $03, $02, $03, $02, $01, $01, $00, $00, $ff, $ff, $fe, $fd, $fe, $fd
    db $fd

ScreenData_6846::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $20, $48, $00, $00, $01, $00, $01, $00, $80, $48, $00, $00, $01, $00, $00

ScreenData_6856::
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
    jr z, jr_002_68ae

    call DelayFramesOrCycles
    ld hl, ScreenData_6947
    call SendSgbPacket
    call DelayFramesOrCycles
    call UpdateSgbBorderColorModeFar
    xor a
    ldh [rBGP], a
    call DisableLCD

jr_002_68ae::
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
    ld de, ScreenData_6a13
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
    ld hl, ScreenData_6957
    call SendSgbPacket
    call DelayFramesOrCycles
    ret



ScreenData_6947::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $b9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

ScreenData_6957::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
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
    jr z, jr_002_69ca

    ld a, $02
    ld [wMessageCharPeriod], a

jr_002_69ca::
    ld a, [wMessageState]
    or a
    ret nz

    ld hl, _SCRN0 + $1d0
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    bit 4, a
    ld a, $00
    jr z, jr_002_69e1

    ld a, $81

jr_002_69e1::
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
    jr z, jr_002_6a04

    ldh a, [hJoyPressed]
    bit 0, a
    ret z

jr_002_6a04::
    xor a
    ld [wMessageState], a
    ld [wVramQueue], a
    ld a, $02
    ld [wScreenSubstate], a
    ldh [hNeedsReset], a
    ret



ScreenData_6a13::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
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
    jr z, jr_002_6a90

    ld a, $02
    ld [wMessageFlags], a
    ld a, $69
    call StartMessageFar
    ld a, $02
    ld [wMessageFlags], a
    ld a, $6a
    call StartMessageFar

jr_002_6a90::
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
    ld [wSharedWork + $13c], a
    ld [wSharedWork + $13f], a
    ld [wScreenPhaseCounter], a
    ld [wSharedWork + $156], a
    cpl
    ld [wSharedWork + $13b], a
    ld a, $50
    ld [wSharedWork + $13a], a
    ret


UpdateContinueScreen::
; State 4, substate 1; animate SGB palettes and dispatch the continue-menu phase.
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    and $0f
    jr nz, jr_002_6b07

    ld a, [wSgbEnabled]
    or a
    jr z, jr_002_6b07

    ld hl, wSgbPalSetPacket
    ld de, ScreenData_6cd8
    ld b, $10

jr_002_6ade::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_002_6ade

    ld a, [wScreenPhaseCounter]
    swap a
    and $03
    add a
    add a
    ld hl, ScreenData_6ce8
    rst $38
    ld a, [hl+]
    ld [wSharedWork + $188], a
    ld a, [hl+]
    ld [wSharedWork + $189], a
    ld a, [hl+]
    ld [wSharedWork + $18a], a
    ld a, [hl+]
    ld [wSharedWork + $18b], a
    ld hl, wSgbPalSetPacket
    call SendSgbPacket

jr_002_6b07::
    ld a, [wSharedWork + $13a]
    ld c, a
    ld b, $58
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    call UpdateMessageFar
    ld a, [wSharedWork + $13f]
    rst $00
ContinueMenuPhaseHandlers::
    dw ContinueMenu_State00 ; $00
    dw ContinueMenu_State01 ; $01
    dw ContinueMenu_State02 ; $02
ContinueMenu_State00::
; ContinueMenuPhaseHandlers index $00; detailed phase behavior remains to be named.
    ld a, [wContinuesRemaining]
    or a
    jr nz, jr_002_6b34

    ld a, [wSharedWork + $156]
    inc a
    ld [wSharedWork + $156], a
    cp $a0
    jr z, jr_002_6b95

    jp ContinueMenu_UpdateFacingIndicator


jr_002_6b34::
    ldh a, [hJoyPressed]
    and $09
    jr z, jr_002_6bb2

    ld a, [wSharedWork + $13c]
    bit 0, a
    jr nz, jr_002_6b95

    ld a, $01
    ld [wSharedWork + $13f], a
    ld hl, SceneAnim_ContinueAccepted
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld hl, $00e0
    ld a, l
    ld [wSharedWork + $167], a
    ld a, h
    ld [wSharedWork + $168], a
    ld hl, ScreenData_6ccd
    ld a, [hl+]
    ld [wScreenFrameCounter], a
    ld a, l
    ld [wSharedWork + $17d], a
    ld a, h
    ld [wSharedWork + $17e], a
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


jr_002_6b95::
    ld a, $02
    ld [wSharedWork + $13f], a
    xor a
    ld [wSceneAnim1Timer], a
    ld [wSharedWork + $17c], a
    ld a, $b0
    ld [wSharedWork + $17b], a
    ld hl, SceneAnim_ContinueExit
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    ret


jr_002_6bb2::
    ld a, [wSharedWork + $13c]
    ld hl, _SCRN0 + $187
    bit 0, a
    jr z, jr_002_6bbf

    ld hl, _SCRN0 + $1c7

jr_002_6bbf::
    xor a
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    and $c4
    jr z, jr_002_6bd5

    ld a, [wSharedWork + $13c]
    cpl
    ld [wSharedWork + $13c], a
    ld a, $40
    call PlaySound

jr_002_6bd5::
    ld a, [wSharedWork + $13c]
    ld hl, _SCRN0 + $187
    bit 0, a
    jr z, jr_002_6be2

    ld hl, _SCRN0 + $1c7

jr_002_6be2::
    ld a, $0e
    call QueueTilemapByte

ContinueMenu_UpdateFacingIndicator::
    ld a, [wSharedWork + $13b]
    and $80
    ld b, a
    ld a, [wSceneAnim0Timer]
    and $80
    cp b
    jr z, jr_002_6c13

    xor a
    ld [wMessageFlags], a
    ld a, [wSceneAnim0Timer]
    ld [wSharedWork + $13b], a
    bit 7, a
    ld a, $1a
    jr z, jr_002_6c07

    ld a, $1b

jr_002_6c07::
    call StartMessageFar
    ld bc, _SCRN0 + $0c7
    ld de, $0006
    call QueueVramFill

jr_002_6c13::
    ret


ContinueMenu_State01::
; ContinueMenuPhaseHandlers index $01; detailed phase behavior remains to be named.
    ld hl, wSharedWork + $17d
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wSharedWork + $167]
    ld c, a
    ld a, [wSharedWork + $168]
    ld b, a
    ld e, [hl]
    ld d, $00
    bit 7, e
    jr z, jr_002_6c2b

    ld d, $ff

jr_002_6c2b::
    ld a, c
    add e
    ld c, a
    ld a, b
    adc d
    ld b, a
    ld a, c
    ld [wSharedWork + $167], a
    ld a, b
    ld [wSharedWork + $168], a
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
    jr z, jr_002_6c57

    ld a, l
    ld [wSharedWork + $17d], a
    ld a, h
    ld [wSharedWork + $17e], a
    ret


jr_002_6c57::
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


ContinueMenu_AddSignedMotionDelta::
    ld a, [wSharedWork + $13b]
    add c
    ld [wSharedWork + $13b], a
    ld a, [wSharedWork + $13a]
    adc b
    ld [wSharedWork + $13a], a
    ret


ContinueMenu_State02::
; ContinueMenuPhaseHandlers index $02; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $17b]
    and $1f
    cp $01
    jr nz, jr_002_6c7b

    ld a, $5b
    call PlaySound

jr_002_6c7b::
    ld bc, -$00e0 ; Signed scene motion delta, not a hardware register.
    ld a, [wSharedWork + $17c]
    add c
    ld [wSharedWork + $17c], a
    ld a, [wSharedWork + $17b]
    or a
    ; Original zero-count path enters the high byte of the JP operand below.
    jr z, jr_002_6cb4 + 2

    adc b
    ld [wSharedWork + $17b], a
    ld a, [wSharedWork + $17b]
    ld c, a
    ld b, $58
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld a, [wSharedWork + $17b]
    cp $40
    jr nz, jr_002_6cb4

    ld hl, SceneAnim_ContinueExitReaction
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    jp ContinueMenu_ClearChoiceText


jr_002_6cb4::
    jp nc, ContinueMenu_UpdateFacingIndicator

    ld bc, -$00e0 ; Signed scene motion delta, not a hardware register.
    call ContinueMenu_AddSignedMotionDelta
    ld a, [wSharedWork + $13a]
    cp $b0
    ret nz

    ld bc, $0001
    ld de, $0001
    jp RequestStateChange_Menu


    ret



ScreenData_6ccd::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $30, $00, $1a, $f0, $30, $00, $2a, $10, $47, $00, $ff

ScreenData_6cd8::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $01, $bd, $77, $f1, $7a, $8a, $4d, $00, $00, $3f, $33, $d3, $36, $00, $00, $00

ScreenData_6ce8::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
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
    ld [wSharedWork + $156], a
    ld a, [wStageSceneIndex]
    bit 0, a
    jr z, jr_002_6d1b

    call InitSound
    ld a, $20
    call PlaySound_Queue3

jr_002_6d1b::
    ld a, BANK(GfxRle_b06_7700)
    ld hl, GfxRle_b06_7700
    ld de, _VRAM
    call LoadMaskedGfx
    ld hl, EndingGfxPointers
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
    ld bc, ScreenData_729c
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
    jr nc, jr_002_6dae

    add $08

jr_002_6dae::
    add $08
    ld [wScreenPaletteId], a
    ret


UpdateStageDialogueScreen::
; State 4, substate 3.
    call UpdateStageDialogueHighlights
    ld a, [wStageSceneIndex]
    cp $07
    jr z, jr_002_6dc5

    ldh a, [hJoyPressed]
    bit 3, a
    jp nz, StageScene_AdvanceOrResumeGameplay

jr_002_6dc5::
    ld de, wStageDialogueAnimSelectors
    ld b, $03

jr_002_6dca::
    push bc
    ld a, b
    dec a
    ld hl, ScreenData_71d6
    rst $38
    ld c, [hl]
    ld a, [de]
    inc de
    push de
    cp $40
    jr c, jr_002_6de5

    cp $7f
    jr z, jr_002_6df9

    ld d, a
    ld b, $88
    call DrawBank3MetaspriteNormal
    jr jr_002_6df9

jr_002_6de5::
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

jr_002_6df9::
    pop de
    pop bc
    dec b
    jr nz, jr_002_6dca

    ld a, [wScreenPhaseCounter]
    cp $ff
    jr nz, jr_002_6e11

    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [wScreenPhaseCounter], a

jr_002_6e11::
    ld a, [wScreenPhaseCounter]
    cp $30
    jr nz, jr_002_6e1d

    ld a, $49
    call PlaySound_Queue1

jr_002_6e1d::
    ld a, [wScreenPhaseCounter]
    or a
    jr z, jr_002_6e38

    ld a, [wScreenPhaseCounter]
    bit 3, a
    ld a, $e4
    jr z, jr_002_6e2d

    cpl

jr_002_6e2d::
    ld [wPaletteBGP], a
    ld a, [wScreenPhaseCounter]
    dec a
    ld [wScreenPhaseCounter], a
    ret


jr_002_6e38::
    call UpdateMessageFar
    ld hl, _SCRN0 + $111
    ld a, [wScreenFrameCounter]
    bit 4, a
    ld a, $00
    jr z, jr_002_6e49

    ld a, $e1

jr_002_6e49::
    call QueueTilemapByte
    ld a, [wStageSceneIndex]
    cp $07
    jr z, jr_002_6e5e

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_6e5e

    ld a, $02
    ld [wMessageCharPeriod], a

jr_002_6e5e::
    ld a, [wMessageState]
    or a
    ret nz

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, jr_002_6e75

    ld a, [wSharedWork + $13c]
    or a
    ret z

jr_002_6e75::
    ld a, [wSharedWork + $13c]
    inc a
    ld [wSharedWork + $13c], a
    ldh [hTileStreamCount], a
    cp $05
    jp z, StartNextStageDialogueMessage

    jr c, jr_002_6e86

    ret


jr_002_6e86::
    dec a
    add a
    ld h, a
    ld l, $02

jr_002_6e8b::
    ld bc, _SCRN0 + $022
    ld de, $e210
    ld a, h
    or a
    jr z, jr_002_6e97

    ld d, $00

jr_002_6e97::
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
    jr nz, jr_002_6e8b

    xor a
    ret


UpdateStageDialogueHighlights::
    ld a, [wSgbEnabled]
    or a
    ret z

    ld a, [wSharedWork + $156]
    or a
    ret nz

    ld a, [wStageSceneIndex]
    cp $07
    jr nz, jr_002_6ee5

    ld a, [wStageDialogueAnimSelectors]
    cp $7f
    jr z, jr_002_6ee5

    ld hl, ScreenData_727c
    call SendSgbPacket
    ld hl, ScreenData_724f
    call GetVramQueueTailDE
    ld b, $0d

jr_002_6ed3::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_6ed3

    ldh a, [hVramQueuePos]
    add $0c
    ldh [hVramQueuePos], a
    ld a, $01
    ld [wSharedWork + $156], a
    ret


jr_002_6ee5::
    ld hl, ScreenData_720c
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

jr_002_6f0d::
    ld a, [hl+]
    ld [de], a
    inc de
    inc b
    or a
    jr nz, jr_002_6f0d

    dec b
    ld a, b
    ldh [hVramQueuePos], a
    ld a, $01
    ld [wSharedWork + $156], a
    ret


StartNextStageDialogueMessage::
; Consume one five-byte dialogue record and optional FE control-write descriptor.
    xor a
    ld [wSharedWork + $13c], a
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
    jr nz, jr_002_6fa2

    ld a, [wSpecialModeFlags]
    or a
    jr z, jr_002_6f57

    ld b, $3c

jr_002_6f57::
    ld a, $e0
    ld [wMessageFlags], a
    ld hl, ScreenData_46f1
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
    jr z, jr_002_6f75

    ld a, $04

jr_002_6f75::
    add d
    ld de, $0014

jr_002_6f79::
    add hl, de
    dec a
    jr nz, jr_002_6f79

    push bc
    ld e, l
    ld d, h
    ld hl, ScreenData_46f9
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

jr_002_6fa2::
    ld a, b
    call StartMessageFar
    pop hl
    ld a, [hl+]
    ldh [hSharedScratch + $0a], a
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

    ld hl, ScreenData_728c
    ld de, wSgbPalSetPacket
    ld b, $10

StageDialogue_CopyPalettePacketTemplate::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, StageDialogue_CopyPalettePacketTemplate

    ldh a, [hSharedScratch + $0a]
    ld b, a
    add a
    add b
    ld hl, ScreenData_71f7
    rst $38
    ld a, [hl+]
    ld [wSharedWork + $18c], a
    ld a, [hl+]
    ld [wSharedWork + $18d], a
    ld a, [hl+]
    ld [wSharedWork + $18e], a
    ld hl, wSgbPalSetPacket
    call SendSgbPacket

StageDialogue_BuildActorHighlightBoxes::
    ld b, $03
    ld hl, _SCRN0 + $124
    ldh a, [hSharedScratch + $0a]
    ld c, a

StageDialogue_NextActorHighlightBox::
    ld de, ScreenData_71ce
    rr c
    jr c, jr_002_703d

    ld a, b
    add a
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a

jr_002_703d::
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
    jr nz, jr_002_705a

    dec hl

jr_002_705a::
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
    jr nz, jr_002_709c

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


jr_002_709c::
    inc a
    ld [wStageSceneIndex], a
    cp $08
    jr z, jr_002_70ad

    ld e, a
    ld d, $08
    ld bc, $0100
    jp RequestStateChange_Menu


jr_002_70ad::
    ld b, $09
    ld a, [wAlternateModeFlags]
    ld c, $00
    or a
    jr z, jr_002_70b9

    ld c, $01

jr_002_70b9::
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

ScreenData_71ce::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $ff, $e0, $e5, $fd, $e5, $f0, $e5, $f0

ScreenData_71d6::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
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

EndingGfxPointers::
    dw GfxRle_b06_7a71
    dw GfxRle_b06_7b22
    dw GfxRle_b06_7c0e
    dw GfxRle_b06_7e13

ScreenData_71f7::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $00, $00, $c0, $00, $00, $00, $0c, $00, $c0, $0c, $00, $00, $00, $03, $c0
    db $00, $03, $00, $0c, $03

ScreenData_720c::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
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

ScreenData_724f::
    db $99, $c3, $43, $00, $99, $e3, $43, $00, $9a, $03, $43, $00, $00

SgbPacket_DialogueHighlight_00::
    db $21, $02, $03, $00, $02, $0e, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueHighlight_01::
    db $21, $02, $03, $00, $0e, $0d, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00

ScreenData_727c::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $21, $02, $03, $0a, $03, $0e, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00

ScreenData_728c::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $39, $00, $0a, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

ScreenData_729c::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $00, $00, $00, $06, $00, $0e, $78, $0e, $70, $04, $70, $00, $00, $00, $00
    db $00, $00, $06, $00, $0e, $78, $0e, $70, $04, $70, $00, $00, $00, $00, $00, $00
    db $0e, $00, $0e, $70, $0e, $70, $04, $70, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $70, $0e, $70, $0e, $70, $00, $00, $0c, $00, $0c, $00, $0c, $00, $0e, $70
    db $0c, $70, $0e, $70, $00, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $70, $0e, $70
    db $00, $70, $00, $00, $84, $01, $8e, $01, $ce, $01, $8e, $f1, $8e, $71, $8e, $71
    db $00, $00, $84, $01, $8e, $01, $ce, $01, $8e, $01, $8e, $01, $8e, $01, $00, $00
InitEndingScreen::
; State 5 initialization.
    ld a, $01
    ldh [rIE], a
    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [wScreenSubstate], a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $a0
    ldh [hOamMaxY], a
    call InitSound
    ld a, $3c
    call PlaySound_Queue3
    ld a, [wSharedWork + $f3]
    and $01
    rst $00

EndingInitHandlers::
    dw Ending_Init_State00 ; $00
    dw Ending_Init_State01 ; $01

Ending_Init_State00::
; EndingInitHandlers index $00; detailed phase behavior remains to be named.
    ld a, $e3
    ld [wLCDCShadow], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $07
    ldh [hWX], a
    ld a, $50
    ldh [hWY], a
    xor a
    ld [wSharedWork + $fc], a
    ld a, $31
    ld [wScreenFrameCounter], a
    ld a, BANK(GfxRle_b06_7099)
    ld hl, GfxRle_b06_7099
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_7581)
    ld hl, GfxRle_b06_7581
    ld de, _VRAM + $900
    call LoadMaskedGfx
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $800
    ld bc, $0100
    call BankedMemcpy
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, BANK(LayoutRle_b06_75fe)
    ld hl, LayoutRle_b06_75fe
    ld de, wStageLayoutMap
    ld bc, $00a0
    call BankedMemcpy_RLEFF
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $100a
    call CopyBankedTilemapRectToVram
    ld de, wStageLayoutMap
    ld hl, _SCRN0 + $010
    ld bc, $100a
    call CopyBankedTilemapRectToVram
    ld a, $8f
    ldh [hTileStreamWritePos], a
    ld hl, _SCRN1
    ld bc, $1206
    call DrawTilemapBox
    ld a, $19
    ld [wScreenPaletteId], a
    ld a, $4d
    ld [wSharedWork + $139], a
    ld de, wSharedWork + $f4
    ld hl, EndingInitialObjectX
    ld b, $04

jr_002_73ca::
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_73ca

    ld hl, wSceneAnim0PtrLo
    ld de, EndingInitialAnimationPointers
    ld b, $04

jr_002_73db::
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    xor a
    ld [hl+], a
    dec b
    jr nz, jr_002_73db

    ld a, $ff
    ld [wFadeTransitionTimer], a
    ret


Ending_Init_State01::
; EndingInitHandlers index $01; detailed phase behavior remains to be named.
    ld a, $83
    ld [wLCDCShadow], a
    ld a, $e1
    ld [wPaletteBGP], a
    ldh [rBGP], a
    ld a, $e0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, $0f
    ld [wScreenPaletteId], a
    xor a
    ld [wScreenPhaseCounter], a
    ld [wSharedWork + $156], a
    ld a, BANK(GfxRle_b02_7b8e)
    ld hl, GfxRle_b02_7b8e
    ld de, _VRAM
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b02_7fe0)
    ld hl, GfxRle_b02_7fe0
    ld de, _VRAM + $800
    call LoadMaskedGfx
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld hl, _SCRN0
    ld b, $20

jr_002_7432::
    ld c, $14
    ld de, ScreenData_7875

jr_002_7437::
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, jr_002_7437

    ld de, $000c
    add hl, de
    dec b
    jr nz, jr_002_7432

    ld hl, _VRAM + $1040
    ld b, $7c
    ld a, $ff

jr_002_744b::
    ld c, $08

jr_002_744d::
    ld [hl+], a
    inc hl
    dec c
    jr nz, jr_002_744d

    dec b
    jr nz, jr_002_744b

    ld b, $08
    ld hl, wSharedWork + $115
    ld de, ScreenData_7889

jr_002_745d::
    ld a, $f0
    ld [hl+], a
    ld [hl+], a
    inc de
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_002_745d

    xor a
    ld [wMessageFlags], a
    ld [wScreenSubstate], a
    inc a
    ld [wMessageControlValue], a
    ld hl, wScreenSubstate
    ld a, l
    ld [wMessageControlPtrLo], a
    ld a, h
    ld [wMessageControlPtrHi], a
    ld a, $67
    call StartMessageFar
    ld hl, SceneAnim_7b5a
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld hl, SceneAnim_7b85
    ld a, l
    ld [wSceneAnim1PtrLo], a
    ld a, h
    ld [wSceneAnim1PtrHi], a
    xor a
    ld [wSceneAnim1Timer], a
    ld a, $40
    ld [wFadeTransitionTimer], a
    ret


UpdateEndingScreen::
; State 5 update.
    ld a, [wSharedWork + $f3]
    and $01
    rst $00

EndingUpdateHandlers::
    dw Ending_Update_State00 ; $00
    dw Ending_Update_State01 ; $01

Ending_Update_State00::
; EndingUpdateHandlers index $00; detailed phase behavior remains to be named.
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    ld hl, wSharedWork + $f4
    ld de, wSceneAnim0PtrLo

jr_002_74bf::
    ld b, $48
    ld c, [hl]
    inc hl
    push hl
    push de
    call AnimateSceneMetasprite
    pop de
    pop hl
    ld [hl+], a
    inc de
    inc de
    inc de
    ld a, l
    cp $fc
    jr nz, jr_002_74bf

    ld a, [wSharedWork + $fc]
    add a
    ld bc, wSharedWork + $f4
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, [wScreenSubstate]
    rst $00

EndingMainStateHandlers::
    dw Ending_Main_State00 ; $00
    dw Ending_Main_State01 ; $01
    dw Ending_Main_State02 ; $02
    dw Ending_Main_State03 ; $03
    dw Ending_Main_State04 ; $04
    dw Ending_Main_State05 ; $05
    dw Ending_Main_State06 ; $06

Ending_Main_State00::
; EndingMainStateHandlers index $00; detailed phase behavior remains to be named.
    call Call_002_760e
    call Call_002_75d7
    ld a, [wScreenPhaseCounter]
    and $03
    ret z

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a
    ret


Ending_Main_State01::
; EndingMainStateHandlers index $01; detailed phase behavior remains to be named.
    ld a, [wScreenPhaseCounter]
    and $03
    jr z, jr_002_7513

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a
    ld a, [bc]
    inc a
    ld [bc], a

jr_002_7513::
    ld a, [wSharedWork + $fd]
    ld e, a
    ld a, [bc]
    cp e
    ret nz

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wSharedWork + $101
    call Ending_SetFourObjectAnimations
    ret


Ending_Main_State02::
; EndingMainStateHandlers index $02; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $f5]
    or a
    ret z

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wSharedWork + $105
    call Ending_SetFourObjectAnimations
    ret


Ending_Main_State03::
; EndingMainStateHandlers index $03; detailed phase behavior remains to be named.
    inc bc
    ld a, [bc]
    or a
    ret z

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wSharedWork + $109
    call Ending_SetFourObjectAnimations
    ret


Ending_Main_State04::
; EndingMainStateHandlers index $04; detailed phase behavior remains to be named.
    ld a, [wScreenPhaseCounter]
    and $01
    ret z

    ld a, [wSharedWork + $fe]
    ld e, a
    ld a, [bc]
    inc a
    ld [bc], a
    cp e
    ret c

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wSharedWork + $10d
    call Ending_SetFourObjectAnimations
    ret


Ending_Main_State05::
; EndingMainStateHandlers index $05; detailed phase behavior remains to be named.
    ld a, [wScreenPhaseCounter]
    and $01
    ret z

    ld hl, wSharedWork + $f4
    ld a, [wSharedWork + $fc]
    ld b, a

jr_002_7577::
    dec [hl]
    inc hl
    inc hl
    dec b
    jr nz, jr_002_7577

    ld a, [wSharedWork + $ff]
    ld b, a
    ld a, [wSharedWork + $f4]
    cp b
    ret nc

    xor a
    ld [wSharedWork + $156], a
    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wSharedWork + $111
    call Ending_SetFourObjectAnimations
    ret


Ending_Main_State06::
; EndingMainStateHandlers index $06; detailed phase behavior remains to be named.
    ld a, [wScreenPhaseCounter]
    and $03
    jr z, jr_002_75a4

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a

jr_002_75a4::
    ld a, [wSharedWork + $156]
    inc a
    ld [wSharedWork + $156], a
    cp $90
    ret c

    xor a
    ld [wScreenSubstate], a
    ret


Ending_SetFourObjectAnimations::
    ld b, $04
    ld de, wSceneAnim0PtrLo

jr_002_75b8::
    ld a, [hl+]
    cp $ff
    jr nz, jr_002_75c2

    inc de
    inc de
    inc de
    jr jr_002_75d3

jr_002_75c2::
    push hl
    ld hl, EndingAnimationPointers
    push de
    rst $20
    pop de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    pop hl

jr_002_75d3::
    dec b
    jr nz, jr_002_75b8

    ret


Call_002_75d7::
    ld a, [wScreenFrameCounter]
    cp $31
    ret nz

    ld a, [wSharedWork + $fc]
    ld hl, ScreenData_77fd
    rst $38
    ld b, [hl]
    ld a, [wSharedWork + $139]
    cp b
    ret nz

    ld a, [wSharedWork + $fc]
    ld c, $18
    call MultiplyBCByA8bit
    ld de, ScreenData_7801
    add hl, de
    ld de, wSharedWork + $fd
    ld b, $18

jr_002_75fb::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_75fb

    ld a, [wSharedWork + $fc]
    inc a
    ld [wSharedWork + $fc], a
    ld a, $01
    ld [wScreenSubstate], a
    ret


Call_002_760e::
    ld a, [wScreenFrameCounter]
    cp $31
    jr z, jr_002_761f

    ld a, [wMessageState]
    or a
    jr z, jr_002_763b

    call UpdateMessageFar
    ret


jr_002_761f::
    xor a
    ld [wScreenFrameCounter], a
    ld a, $09
    ld [wMessageFlags], a
    ld a, [wSharedWork + $139]
    inc a
    ld [wSharedWork + $139], a
    ld a, $10
    ld [wMessageCharPeriod], a

jr_002_7634::
    ld a, [wSharedWork + $139]
    call StartMessageFar
    ret


jr_002_763b::
    ld a, [wSharedWork + $139]
    cp $59
    jr nz, jr_002_7653

    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0203
    ld de, $0000
    jp RequestStateChange_Menu


jr_002_7653::
    ld a, $0d
    ld [wMessageFlags], a
    ld a, $0c
    ld [wMessageCharPeriod], a
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $30
    jr z, jr_002_7634

    ret


Ending_Update_State01::
; EndingUpdateHandlers index $01; detailed phase behavior remains to be named.
    call UpdateEndingAlternateSequence
    ld e, $08
    ld hl, wSharedWork + $115
    ld d, $01
    ld a, [wScreenFrameCounter]
    bit 0, a
    jr z, jr_002_767c

    ld d, $02

jr_002_767c::
    ld a, [hl]
    add d
    ld c, a
    ld [hl+], a
    ld a, [hl]
    sub d
    ld b, a
    ld [hl+], a
    ld a, [hl]
    inc a
    ld [hl+], a
    push hl
    push de
    cp $50
    jr nz, jr_002_76a3

    dec hl
    dec hl
    dec hl
    ld a, e
    add a
    add e
    ld de, ScreenData_7889
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl+], a
    xor a
    ld [hl+], a

jr_002_76a3::
    ld d, $f1
    ld a, [wScreenFrameCounter]
    bit 3, a
    jr z, jr_002_76ae

    ld d, $f0

jr_002_76ae::
    call DrawBank3MetaspriteNormal
    pop de
    pop hl
    dec e
    jr nz, jr_002_767c

    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    ld a, [wMessageState]
    or a
    ret z

    ld a, [wScreenFrameCounter]
    and $03
    ret nz

    ldh a, [hSCY]
    inc a
    ldh [hSCY], a
    and $0f
    jr nz, jr_002_76d5

    call UpdateMessageFar
    ret


jr_002_76d5::
    ldh a, [hSCY]
    and $07
    cp $04
    ret nz

    ldh a, [hSCY]
    and $f8
    ld l, a
    ld h, $00
    sla l
    rl h
    sla l
    rl h
    ld bc, $03e9
    add hl, bc
    ld a, h
    and $03
    ld h, a
    ld bc, _SCRN0
    add hl, bc
    ld c, l
    ld b, h
    ld de, $010a
    call QueueVramFill
    ret


UpdateEndingAlternateSequence::
; Animate two scene objects and dispatch the alternate ending substate.
    ld a, [wScreenPhaseCounter]
    ld d, a
    ld a, $38
    add d
    ld b, a
    ld a, $50
    sub d
    ld c, a
    ld de, wSceneAnim0PtrLo
    call AnimateSceneMetasprite
    ld a, [wSharedWork + $156]
    ld b, a
    ld a, $50
    sub b
    ld c, a
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld a, [wScreenSubstate]
    rst $00
EndingAlternateStateHandlers::
    dw Ending_Alternate_State00 ; $00
    dw Ending_Alternate_State01 ; $01
    dw Ending_Alternate_State02 ; $02
    dw Ending_Alternate_State03 ; $03
    dw Ending_Alternate_State04 ; $04
Ending_Alternate_State00::
; EndingAlternateStateHandlers index $00; detailed phase behavior remains to be named.
    ret


Ending_Alternate_State01::
; EndingAlternateStateHandlers index $01; detailed phase behavior remains to be named.
    ld a, [wScreenFrameCounter]
    and $07
    jr nz, jr_002_7743

    ld a, [wScreenPhaseCounter]
    inc a
    cp $30
    jr c, jr_002_7740

    ld a, $30

jr_002_7740::
    ld [wScreenPhaseCounter], a

jr_002_7743::
    ld a, [wMessageControlValue]
    cp $01
    ret nz

    ld a, $02
    ld [wMessageControlValue], a
    ret


Ending_Alternate_State02::
; EndingAlternateStateHandlers index $02; detailed phase behavior remains to be named.
    ld a, [wScreenFrameCounter]
    and $07
    jr nz, jr_002_7762

    ld a, [wScreenPhaseCounter]
    dec a
    bit 7, a
    jr z, jr_002_775f

    xor a

jr_002_775f::
    ld [wScreenPhaseCounter], a

jr_002_7762::
    ld a, [wMessageControlValue]
    cp $02
    ret nz

    ld hl, SceneAnim_7b65
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $03
    ld [wMessageControlValue], a
    ret


Ending_Alternate_State03::
; EndingAlternateStateHandlers index $03; detailed phase behavior remains to be named.
    ld a, [wScreenFrameCounter]
    and $07
    jr nz, jr_002_7791

    ld a, [wScreenPhaseCounter]
    inc a
    cp $30
    jr c, jr_002_778e

    ld a, $30

jr_002_778e::
    ld [wScreenPhaseCounter], a

jr_002_7791::
    ld a, [wMessageControlValue]
    cp $03
    ret nz

    ld hl, SceneAnim_7b70
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld [wSharedWork + $157], a
    ld a, $04
    ld [wMessageControlValue], a
    ret


Ending_Alternate_State04::
; EndingAlternateStateHandlers index $04; detailed phase behavior remains to be named.
    ld a, [wSharedWork + $157]
    cp $20
    call nc, Ending_FadeAndReturnToMenu
    ld a, [wScreenFrameCounter]
    and $07
    ret nz

    ld a, [wSharedWork + $156]
    inc a
    cp $30
    jr c, jr_002_77c7

    ld a, $30

jr_002_77c7::
    ld [wSharedWork + $156], a
    ld a, [wMessageState]
    or a
    ret nz

    ld a, [wSharedWork + $157]
    inc a
    ld [wSharedWork + $157], a
    ret


Ending_FadeAndReturnToMenu::
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0204
    ld a, [wSpecialModeFlags]
    or a
    jr z, jr_002_77eb

    ld bc, $0205

jr_002_77eb::
    ld de, $0000
    jp RequestStateChange_Menu



; Indexed screen data; scene-specific interpretation is documented at its consumer.

EndingInitialObjectX::
    db $50, $f0, $f0, $f0

EndingInitialAnimationPointers::
    dw SceneAnim_7a97
    dw SceneAnim_7a7c
    dw SceneAnim_7a88
    dw SceneAnim_7a91

ScreenData_77fd::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $50, $53, $56, $8e

ScreenData_7801::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $30, $5c, $45, $00, $01, $0f, $ff, $ff, $ff, $04, $ff, $ff, $ff, $05, $ff, $ff
    db $00, $10, $ff, $ff, $02, $06, $ff, $ff, $24, $68, $39, $00, $03, $11, $ff, $ff
    db $ff, $ff, $08, $ff, $ff, $ff, $09, $ff, $02, $12, $13, $ff, $02, $07, $0a, $ff
    db $18, $74, $2d, $00, $03, $12, $13, $ff, $ff, $ff, $ff, $0c, $ff, $ff, $ff, $0d
    db $02, $12, $14, $15, $02, $07, $0b, $0e

; Indexed screen data; scene-specific interpretation is documented at its consumer.

EndingAnimationPointers::
    dw SceneAnim_7a97
    dw SceneAnim_7aa2
    dw SceneAnim_7acb
    dw SceneAnim_7ad6
    dw SceneAnim_7ae5
    dw SceneAnim_7aee
    dw SceneAnim_7af9
    dw SceneAnim_7b04
    dw SceneAnim_7b0f
    dw SceneAnim_7b1c
    dw SceneAnim_7b27
    dw SceneAnim_7b32
    dw SceneAnim_7b3d
    dw SceneAnim_7b44
    dw SceneAnim_7b4f
    dw SceneAnim_7a7c
    dw SceneAnim_7a7f
    dw SceneAnim_7a82
    dw SceneAnim_7a85
    dw SceneAnim_7a8b
    dw SceneAnim_7a8e
    dw SceneAnim_7a94

ScreenData_7875::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $00, $00, $00, $00, $00, $00, $00, $80, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01

ScreenData_7889::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $f8, $10, $20, $f8, $20, $18, $f8, $30, $00, $f8, $60, $30, $08, $98, $08, $20
    db $98, $40, $30, $98, $10, $00, $00, $28

; Indexed screen data; scene-specific interpretation is documented at its consumer.

SceneAnim_TitleIntro::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $01
    db $0c, $00
    db $ff ; Loop.
    dw SceneAnim_TitleIntro

SceneAnim_TitleIdle::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $02
    db $0c, $03
    db $0c, $04
    db $0c, $02
    db $0c, $03
    db $0c, $04
    db $8c, $02
    db $8c, $03
    db $8c, $04
    db $8c, $02
    db $8c, $03
    db $8c, $04
    db $09, $05
    db $0c, $06
    db $0c, $07
    db $0c, $06
    db $0c, $07
    db $09, $08
    db $0c, $09
    db $0c, $0a
    db $0c, $09
    db $0c, $0a
    db $09, $0b
    db $ff ; Loop.
    dw SceneAnim_TitleIdle

SceneAnim_TitleSecondary::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $0c
    db $0c, $0d
    db $ff ; Loop.
    dw SceneAnim_TitleSecondary

SceneAnim_Scene3Mode0Primary::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $0e
    db $08, $0f
    db $08, $0e
    db $08, $10
    db $ff ; Loop.
    dw SceneAnim_Scene3Mode0Primary

SceneAnim_Scene3Mode0Variant::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $88, $0e
    db $88, $0f
    db $88, $0e
    db $88, $10
    db $ff ; Loop.
    dw SceneAnim_Scene3Mode0Variant

SceneAnim_Scene3Mode0Secondary::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $18, $11
    db $18, $12
    db $18, $13
    db $30, $14
    db $fe ; Hold the previous metasprite.
    dw SceneAnim_Scene3Mode0Secondary ; Unused legacy target after HOLD; the decoder never reads this word.

SceneAnim_Scene3Mode0State1::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $18, $16
    db $18, $15
    db $ff ; Loop.
    dw SceneAnim_Scene3Mode0State1

SceneAnim_Scene3Mode0State2::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $17
    db $08, $18
    db $08, $17
    db $08, $19
    db $ff ; Loop.
    dw SceneAnim_Scene3Mode0State2

SceneAnim_7913::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $1a
    db $0c, $1b
    db $ff ; Loop.
    dw SceneAnim_7913

SceneAnim_791a::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $06, $1a
    db $06, $1c
    db $7f, $1d
    db $fe ; Hold the previous metasprite.

SceneAnim_7921::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $1e
    db $0c, $1f
    db $ff ; Loop.
    dw SceneAnim_7921

SceneAnim_7928::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $06, $1e
    db $06, $20
    db $7f, $21
    db $fe ; Hold the previous metasprite.

SceneAnim_792f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $8c, $1e
    db $8c, $1f
    db $ff ; Loop.
    dw SceneAnim_792f

SceneAnim_7936::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $86, $1e
    db $86, $20
    db $f0, $21
    db $fe ; Hold the previous metasprite.

SceneAnim_793d::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $22
    db $0c, $23
    db $ff ; Loop.
    dw SceneAnim_793d

SceneAnim_7944::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $06, $22
    db $06, $24
    db $7f, $25
    db $fe ; Hold the previous metasprite.

SceneAnim_794b::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $04, $26
    db $04, $27
    db $04, $28
    db $04, $29
    db $04, $26
    db $04, $27
    db $04, $28
    db $04, $29
    db $04, $39
    db $fe ; Hold the previous metasprite.
    dw SceneAnim_794b ; Unused legacy target after HOLD; the decoder never reads this word.

SceneAnim_7960::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0f, $2a
    db $0f, $2b
    db $ff ; Loop.
    dw SceneAnim_7960

SceneAnim_7967::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0f, $44
    db $0f, $45
    db $ff ; Loop.
    dw SceneAnim_7967

SceneAnim_796e::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $04, $26
    db $04, $27
    db $04, $28
    db $04, $29
    db $04, $26
    db $04, $27
    db $04, $28
    db $04, $29
    db $40, $52
    db $10, $53

SceneAnim_7982::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $52
    db $10, $53
    db $ff ; Loop.
    dw SceneAnim_7982

SceneAnim_ContinueIdle::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $18, $56
    db $0e, $55
    db $0e, $54
    db $98, $56
    db $8e, $55
    db $8e, $54
    db $ff ; Loop.
    dw SceneAnim_ContinueIdle

SceneAnim_ContinueAccepted::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $06, $57
    db $06, $58
    db $06, $57
    db $06, $59
    db $ff ; Loop.
    dw SceneAnim_ContinueAccepted

SceneAnim_ContinueExitReaction::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $5a
    db $08, $5b
    db $08, $5a
    db $08, $5c
    db $ff ; Loop.
    dw SceneAnim_ContinueExitReaction

SceneAnim_ContinueExit::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $5d
    db $08, $5e
    db $08, $5f
    db $ff ; Loop.
    dw SceneAnim_ContinueExit

SceneAnim_79b7::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $60
    db $0d, $61

SceneAnim_79bb::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $60
    db $fe ; Hold the previous metasprite.

SceneAnim_79be::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $40, $60
    db $08, $63
    db $20, $64
    db $08, $65
    db $08, $66
    db $08, $65
    db $02, $64
    db $fe ; Hold the previous metasprite.

SceneAnim_79cd::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0f, $67
    db $0f, $68
    db $ff ; Loop.
    dw SceneAnim_79cd

SceneAnim_79d4::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $40, $60
    db $08, $63
    db $0f, $77
    db $08, $78
    db $08, $79
    db $08, $7a
    db $08, $79
    db $08, $78
    db $fe ; Hold the previous metasprite.

SceneAnim_79e5::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $7d
    db $10, $7c
    db $ff ; Loop.
    dw SceneAnim_79e5

SceneAnim_79ec::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $7e
    db $10, $7f
    db $ff ; Loop.
    dw SceneAnim_79ec

SceneAnim_79f3::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $81
    db $10, $82
    db $ff ; Loop.
    dw SceneAnim_79f3

SceneAnim_79fa::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $83
    db $10, $84
    db $ff ; Loop.
    dw SceneAnim_79fa

SceneAnim_7a01::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $85
    db $10, $86
    db $ff ; Loop.
    dw SceneAnim_7a01

SceneAnim_7a08::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $87
    db $10, $88
    db $ff ; Loop.
    dw SceneAnim_7a08

SceneAnim_7a0f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $89
    db $08, $8a
    db $ff ; Loop.
    dw SceneAnim_7a0f

SceneAnim_7a16::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $8b
    db $10, $8c
    db $10, $8d
    db $ff ; Loop.
    dw SceneAnim_7a16

SceneAnim_7a1f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $8f
    db $08, $90
    db $08, $8f
    db $7f, $8e
    db $fe ; Hold the previous metasprite.

SceneAnim_7a28::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $10, $94
    db $10, $95
    db $ff ; Loop.
    dw SceneAnim_7a28

SceneAnim_7a2f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $97
    db $08, $98
    db $ff ; Loop.
    dw SceneAnim_7a2f

ScreenData_7a36::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $a2
    db $0f, $a3
    db $08, $a4

SceneAnim_7a3c::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $a5
    db $08, $a4
    db $ff ; Loop.
    dw SceneAnim_7a3c

SceneAnim_7a43::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $a8
    db $08, $a9
    db $08, $a8
    db $08, $aa
    db $ff ; Loop.
    dw SceneAnim_7a43

SceneAnim_7a4e::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $08, $ae
    db $08, $af
    db $fe ; Hold the previous metasprite.

SceneAnim_7a53::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $1f, $ae
    db $1f, $af
    db $fe ; Hold the previous metasprite.

SceneAnim_7a58::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0f, $ae
    db $0f, $af
    db $0f, $ae
    db $0f, $af
    db $fe ; Hold the previous metasprite.

ScreenData_7a61::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $a2
    db $0f, $a3
    db $08, $a4
    db $08, $a5
    db $08, $a4
    db $08, $a5
    db $08, $a4
    db $08, $a5
    db $08, $a4
    db $08, $a5
    db $08, $a4
    db $08, $a5
    db $08, $b0
    db $fe ; Hold the previous metasprite.

SceneAnim_7a7c::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $c4
    db $fe ; Hold the previous metasprite.

SceneAnim_7a7f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $8f, $c4
    db $fe ; Hold the previous metasprite.

SceneAnim_7a82::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $c9
    db $fe ; Hold the previous metasprite.

SceneAnim_7a85::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $cc
    db $fe ; Hold the previous metasprite.

SceneAnim_7a88::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $cf
    db $fe ; Hold the previous metasprite.

SceneAnim_7a8b::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $d6
    db $fe ; Hold the previous metasprite.

SceneAnim_7a8e::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $d9
    db $fe ; Hold the previous metasprite.

SceneAnim_7a91::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $dc
    db $fe ; Hold the previous metasprite.

SceneAnim_7a94::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $3f, $e3
    db $fe ; Hold the previous metasprite.

SceneAnim_7a97::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $b3
    db $0c, $b4
    db $0c, $b3
    db $0c, $b5
    db $ff ; Loop.
    dw SceneAnim_7a97

SceneAnim_7aa2::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $20, $b3
    db $0f, $b6
    db $0f, $b7
    db $0f, $b6
    db $0f, $b7
    db $0f, $b6
    db $0f, $b7
    db $0f, $b9
    db $0f, $b8
    db $0f, $b9
    db $0f, $b8
    db $13, $ba
    db $13, $bb
    db $13, $bc
    db $13, $bd
    db $13, $be
    db $13, $bd
    db $13, $be
    db $13, $bd
    db $13, $be
    db $fe ; Hold the previous metasprite.

SceneAnim_7acb::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $bf
    db $0c, $c0
    db $0c, $bf
    db $0c, $c1
    db $ff ; Loop.
    dw SceneAnim_7acb

SceneAnim_7ad6::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $20, $bf
    db $0f, $c2
    db $0f, $c3
    db $0f, $c2
    db $0f, $c3
    db $0f, $c2
    db $0f, $c3
    db $fe ; Hold the previous metasprite.

SceneAnim_7ae5::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $13, $c4
    db $13, $c5
    db $13, $c4
    db $13, $c5
    db $fe ; Hold the previous metasprite.

SceneAnim_7aee::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $c6
    db $0c, $c7
    db $0c, $c6
    db $0c, $c8
    db $ff ; Loop.
    dw SceneAnim_7aee

SceneAnim_7af9::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $c9
    db $0c, $ca
    db $0c, $c9
    db $0c, $cb
    db $ff ; Loop.
    dw SceneAnim_7af9

SceneAnim_7b04::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $cc
    db $0c, $cd
    db $0c, $cc
    db $0c, $ce
    db $ff ; Loop.
    dw SceneAnim_7b04

SceneAnim_7b0f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $d0
    db $0c, $d1
    db $0c, $d0
    db $0c, $d1
    db $0c, $d0
    db $0c, $d1
    db $fe ; Hold the previous metasprite.

SceneAnim_7b1c::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $d3
    db $0c, $d4
    db $0c, $d3
    db $0c, $d5
    db $ff ; Loop.
    dw SceneAnim_7b1c

SceneAnim_7b27::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $d6
    db $0c, $d7
    db $0c, $d6
    db $0c, $d8
    db $ff ; Loop.
    dw SceneAnim_7b27

SceneAnim_7b32::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $d9
    db $0c, $da
    db $0c, $d9
    db $0c, $db
    db $ff ; Loop.
    dw SceneAnim_7b32

SceneAnim_7b3d::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $1c, $dd
    db $0f, $de
    db $0f, $df
    db $fe ; Hold the previous metasprite.

SceneAnim_7b44::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $e0
    db $0c, $e1
    db $0c, $e0
    db $0c, $e2
    db $ff ; Loop.
    dw SceneAnim_7b44

SceneAnim_7b4f::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0c, $e3
    db $0c, $e4
    db $0c, $e3
    db $0c, $e5
    db $ff ; Loop.
    dw SceneAnim_7b4f

SceneAnim_7b5a::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0a, $e6
    db $0a, $e7
    db $0a, $e6
    db $0a, $e8
    db $ff ; Loop.
    dw SceneAnim_7b5a

SceneAnim_7b65::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0f, $e6
    db $0f, $e7
    db $0f, $e6
    db $0f, $e8
    db $ff ; Loop.
    dw SceneAnim_7b65

SceneAnim_7b70::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0a, $e9
    db $08, $ea
    db $08, $eb
    db $08, $ea
    db $08, $eb
    db $08, $ea
    db $08, $eb
    db $08, $ea
    db $08, $eb
    db $ff ; Loop.
    dw SceneAnim_7b70

SceneAnim_7b85::
; Pairs: duration/facing byte (bit 7 = facing), metasprite ID; $ff + word loops, $fe holds.
    db $0a, $ec
    db $0a, $ed
    db $0a, $ee
    db $ff ; Loop.
    dw SceneAnim_7b85

GfxRle_b02_7b8e::
; Source: gfx/compressed/b02_7b8e.png (prevbyte, 1296 decoded bytes).
    INCBIN "../build/original/assets/b02_7b8e.bin"


GfxRle_b02_7fe0::
; Source: gfx/compressed/b02_7fe0.png (prevbyte, 16 decoded bytes).
    INCBIN "../build/original/assets/b02_7fe0.bin"


    ds $8000 - @, $ff
