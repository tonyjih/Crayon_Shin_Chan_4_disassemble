InitTitleOrPasswordScreen::
; Initialize game state 0. Substate 4 opens the scene-test menu.
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
    cp TITLE_SUBSTATE_SCENE_TEST
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
    dw PasswordScreen_FadeBackToMainMenu ; $03, cancel at password slot 0
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

    ld a, SECOND_ROUND_MODE_FLAG
    ld [wAlternateModeFlags], a

TitleMenu_StartNewGame::
    ld bc, MENU_REQUEST_STAGE_INTRO << 8
    ld de, MENU_REQUEST_STAGE_DIALOGUE << 8
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
