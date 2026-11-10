DEF PASSWORD_INDEX_TURBO_FIRST EQU $07
DEF PASSWORD_INDEX_SCENE_TEST  EQU $0b

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
    ld b, PASSWORD_CODE_SIZE
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
    cp PASSWORD_INDEX_SCENE_TEST
    jr nz, PasswordAccepted_CheckTurboCode

    ; かみしばい goes straight to the scene-test menu without writing either mode flag.
    ld bc, MENU_REQUEST_SCENE_TEST << 8
    ld de, $0000
    jp RequestStateChange_Menu


PasswordAccepted_CheckTurboCode::
    cp PASSWORD_INDEX_TURBO_FIRST
    jr c, PasswordAccepted_SelectRoundStage

    sub PASSWORD_INDEX_TURBO_FIRST ; Four Turbo entries in stage order, from picnic to Guam.
    ld b, a
    ASSERT SECOND_ROUND_MODE_FLAG == TURBO_MODE_FLAG
    ld a, TURBO_MODE_FLAG ; Both fields receive the same $04.
    ld [wAlternateModeFlags], a
    ld [wSpecialModeFlags], a
    ld a, b
    jr PasswordAccepted_RequestStageIntro

PasswordAccepted_SelectRoundStage::
    ; Index + 1 packs the stage in bits 0-1 and the second-round flag in bit 2.
    xor a
    ld [wSpecialModeFlags], a
    ld a, [wPasswordMatchIndex]
    inc a
    bit SECOND_ROUND_MODE_BIT, a
    ld a, SECOND_ROUND_MODE_FLAG
    jr nz, PasswordAccepted_StoreRoundFlag

    xor a

PasswordAccepted_StoreRoundFlag::
    ld [wAlternateModeFlags], a
    ld a, [wPasswordMatchIndex]
    inc a
    and $03

PasswordAccepted_RequestStageIntro::
    ; C selects the title card. DE saves the opening dialogue request for after the story.
    ld b, MENU_REQUEST_STAGE_INTRO
    ld c, a
    ld d, MENU_REQUEST_STAGE_DIALOGUE
    ld a, c
    sla a
    ld e, a
    jp RequestStateChange_Menu


PasswordScreen_FadeBackToMainMenu::
; The title menu saved request $00 with argument $01 when it opened the password screen.
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

    ; B or the backspace cell at slot 0 underflows the index and cancels password entry.
    ld a, $03
    ld [wScreenSubstate], a
    ld a, $48
    ld [wFadeTransitionTimer], a
    ret


PasswordInput_ClampIndexAtLastSlot::
    cp PASSWORD_CODE_WIDTH
    jr c, PasswordInput_Return

    ld a, PASSWORD_CODE_WIDTH - 1
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
    ld e, TEXT_DAKUTEN
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
    cp PASSWORD_CODE_SIZE + 1
    jr nc, SubmitPassword_AcceptMatch

    ld a, [de]
    ld b, [hl]
    inc de
    inc hl
    cp b
    jr z, SubmitPassword_CompareNextByte

    pop hl
    ld bc, PASSWORD_CODE_SIZE
    add hl, bc
    ld a, [wPasswordMatchIndex]
    inc a
    ld [wPasswordMatchIndex], a
    cp PASSWORD_CODE_COUNT
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

; Preserve the original spellings and match order. Both tables use this list.
MACRO password_codes
    ; First round starts with the school code. Start from the main menu for first-round picnic.
    \1 PasswordCode_WagamamaDanaa,   "わがままだなあ"
    \1 PasswordCode_TamanegiTabereru, "たまねぎたべれる"
    \1 PasswordCode_Wahahahaha,      "わははははわはははは"
    ; Second round, ordered from picnic to Guam.
    \1 PasswordCode_Obenkidene,      "おべんきでね"
    \1 PasswordCode_KetsudakeSeijin, "けつだけせいじん"
    \1 PasswordCode_ActionBeam,     "あくしょんびいむ"
    \1 PasswordCode_ZousanZousan,    "ぞおさんぞおさん"
    ; Turbo uses the second-round stages plus the Turbo movement flag.
    \1 PasswordCode_ShinchanTurbo,  "しんちゃんたあぼ"
    \1 PasswordCode_BuriburiZaemon,  "ぶりぶりざえもん"
    \1 PasswordCode_NasuNoOshinko,   "なすのおしんこ"
    \1 PasswordCode_ArigatoGozamasu, "ありがとござますう"
    ; Scene-test menu.
    \1 PasswordCode_Kamishibai,     "かみしばい"
ENDM

PasswordCodeLengths::
    password_codes password_code_length
    ASSERT @ - PasswordCodeLengths == PASSWORD_CODE_COUNT

PasswordCodeTable::
    password_codes password_code
    ASSERT @ - PasswordCodeTable == PASSWORD_CODE_COUNT * PASSWORD_CODE_SIZE
    ASSERT PasswordCode_ShinchanTurbo - PasswordCodeTable == PASSWORD_INDEX_TURBO_FIRST * PASSWORD_CODE_SIZE
    ASSERT PasswordCode_Kamishibai - PasswordCodeTable == PASSWORD_INDEX_SCENE_TEST * PASSWORD_CODE_SIZE
PURGE password_codes
