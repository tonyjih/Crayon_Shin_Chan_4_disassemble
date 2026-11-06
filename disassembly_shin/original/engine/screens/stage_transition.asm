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
