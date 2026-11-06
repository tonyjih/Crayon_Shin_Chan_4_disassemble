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
