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
