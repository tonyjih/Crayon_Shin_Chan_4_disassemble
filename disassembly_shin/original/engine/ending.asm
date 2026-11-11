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
    ld a, [wEndingMode]
    and $01
    rst $00

EndingInitHandlers::
    dw Ending_InitMainPresentation ; $00
    dw Ending_InitScrollingPresentation ; $01

Ending_InitMainPresentation::
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
    ld [wEndingCueIndex], a
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
    ld [wEndingCreditMessageId], a
    ld de, wEndingActors
    ld hl, EndingInitialObjectX
    ld b, ENDING_ACTOR_COUNT

Ending_InitActorPositions::
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    dec b
    jr nz, Ending_InitActorPositions

    ld hl, wSceneAnim0PtrLo
    ld de, EndingInitialAnimationPointers
    ld b, ENDING_ACTOR_COUNT

Ending_InitActorAnimations::
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    xor a
    ld [hl+], a
    dec b
    jr nz, Ending_InitActorAnimations

    ld a, $ff
    ld [wFadeTransitionTimer], a
    ret


Ending_InitScrollingPresentation::
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
    ld [wEndingSecondaryOffset], a
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

EndingScroll_InitBgRows::
    ld c, $14
    ld de, EndingScrollBgRow

EndingScroll_CopyBgRow::
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, EndingScroll_CopyBgRow

    ld de, $000c
    add hl, de
    dec b
    jr nz, EndingScroll_InitBgRows

    ld hl, _VRAM + $1040
    ld b, $7c
    ld a, $ff

EndingScroll_InitFontTiles::
    ld c, $08

EndingScroll_FillFontRows::
    ld [hl+], a
    inc hl
    dec c
    jr nz, EndingScroll_FillFontRows

    dec b
    jr nz, EndingScroll_InitFontTiles

    ld b, ENDING_PARTICLE_COUNT
    ld hl, wEndingParticles
    ld de, EndingParticleSeeds

EndingScroll_InitParticles::
    ld a, $f0
    ld [hl+], a
    ld [hl+], a
    inc de
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, EndingScroll_InitParticles

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
    ld a, [wEndingMode]
    and $01
    rst $00

EndingUpdateHandlers::
    dw Ending_UpdateMainPresentation ; $00
    dw Ending_UpdateScrollingPresentation ; $01

Ending_UpdateMainPresentation::
    ld a, [wScreenPhaseCounter]
    inc a
    ld [wScreenPhaseCounter], a
    ld hl, wEndingActors
    ld de, wSceneAnim0PtrLo

Ending_DrawNextActor::
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
    cp LOW(wEndingCueIndex)
    jr nz, Ending_DrawNextActor

    ld a, [wEndingCueIndex]
    add a
    ld bc, wEndingActors
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, [wScreenSubstate]
    rst $00

EndingMainStateHandlers::
    dw Ending_MainScrollAndCredits ; $00
    dw Ending_MainMoveActorToEntryX ; $01
    dw Ending_MainWaitForFirstActorHold ; $02
    dw Ending_MainWaitForCurrentActorHold ; $03
    dw Ending_MainMoveActorToCueX ; $04
    dw Ending_MainMoveActorsOffscreen ; $05
    dw Ending_MainWaitBetweenCues ; $06

Ending_MainScrollAndCredits::
    call Ending_UpdateCreditMessages
    call Ending_LoadCueAtCreditBoundary
    ld a, [wScreenPhaseCounter]
    and $03
    ret z

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a
    ret


Ending_MainMoveActorToEntryX::
    ld a, [wScreenPhaseCounter]
    and $03
    jr z, Ending_CheckActorEntryTarget

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a
    ld a, [bc]
    inc a
    ld [bc], a

Ending_CheckActorEntryTarget::
    ld a, [wEndingCue + ENDING_CUE_OFS_ENTER_X]
    ld e, a
    ld a, [bc]
    cp e
    ret nz

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wEndingCue + ENDING_CUE_OFS_ANIMS1
    call Ending_SetFourObjectAnimations
    ret


Ending_MainWaitForFirstActorHold::
    ld a, [wEndingActors + ENDING_ACTOR_OFS_HELD]
    or a
    ret z

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wEndingCue + ENDING_CUE_OFS_ANIMS2
    call Ending_SetFourObjectAnimations
    ret


Ending_MainWaitForCurrentActorHold::
    inc bc
    ld a, [bc]
    or a
    ret z

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wEndingCue + ENDING_CUE_OFS_ANIMS3
    call Ending_SetFourObjectAnimations
    ret


Ending_MainMoveActorToCueX::
    ld a, [wScreenPhaseCounter]
    and $01
    ret z

    ld a, [wEndingCue + ENDING_CUE_OFS_MOVE_X]
    ld e, a
    ld a, [bc]
    inc a
    ld [bc], a
    cp e
    ret c

    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wEndingCue + ENDING_CUE_OFS_ANIMS4
    call Ending_SetFourObjectAnimations
    ret


Ending_MainMoveActorsOffscreen::
    ld a, [wScreenPhaseCounter]
    and $01
    ret z

    ld hl, wEndingActors
    ld a, [wEndingCueIndex]
    ld b, a

Ending_MoveActorsLeft::
    dec [hl]
    inc hl
    inc hl
    dec b
    jr nz, Ending_MoveActorsLeft

    ld a, [wEndingCue + ENDING_CUE_OFS_EXIT_X]
    ld b, a
    ld a, [wEndingActors]
    cp b
    ret nc

    xor a
    ld [wEndingSceneDelay], a
    ld a, [wScreenSubstate]
    inc a
    ld [wScreenSubstate], a
    ld hl, wEndingCue + ENDING_CUE_OFS_ANIMS5
    call Ending_SetFourObjectAnimations
    ret


Ending_MainWaitBetweenCues::
    ld a, [wScreenPhaseCounter]
    and $03
    jr z, Ending_TickSceneDelay

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a

Ending_TickSceneDelay::
    ld a, [wEndingSceneDelay]
    inc a
    ld [wEndingSceneDelay], a
    cp $90
    ret c

    xor a
    ld [wScreenSubstate], a
    ret


Ending_SetFourObjectAnimations::
; HL=four animation selectors; $ff keeps the slot's existing animation.
    ld b, ENDING_ACTOR_COUNT
    ld de, wSceneAnim0PtrLo

Ending_SetNextActorAnimation::
    ld a, [hl+]
    cp $ff
    jr nz, Ending_StoreActorAnimation

    inc de
    inc de
    inc de
    jr Ending_AdvanceAnimationSlot

Ending_StoreActorAnimation::
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

Ending_AdvanceAnimationSlot::
    dec b
    jr nz, Ending_SetNextActorAnimation

    ret


Ending_LoadCueAtCreditBoundary::
; Load a 24-byte scene cue when the displayed credit reaches its message ID.
    ld a, [wScreenFrameCounter]
    cp $31
    ret nz

    ld a, [wEndingCueIndex]
    ld hl, EndingCueMessageIds
    rst $38
    ld b, [hl]
    ld a, [wEndingCreditMessageId]
    cp b
    ret nz

    ld a, [wEndingCueIndex]
    ld c, ENDING_CUE_SIZE
    call MultiplyBCByA8bit
    ld de, EndingCueRecords
    add hl, de
    ld de, wEndingCue
    ld b, ENDING_CUE_SIZE

Ending_CopyCueBytes::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, Ending_CopyCueBytes

    ld a, [wEndingCueIndex]
    inc a
    ld [wEndingCueIndex], a
    ld a, $01
    ld [wScreenSubstate], a
    ret


Ending_UpdateCreditMessages::
; Finished credits are redrawn blank before advancing to the next message.
    ld a, [wScreenFrameCounter]
    cp $31
    jr z, Ending_BeginNextCredit

    ld a, [wMessageState]
    or a
    jr z, Ending_CheckFinalCredit

    call UpdateMessageFar
    ret


Ending_BeginNextCredit::
    xor a
    ld [wScreenFrameCounter], a
    ld a, $09
    ld [wMessageFlags], a
    ld a, [wEndingCreditMessageId]
    inc a
    ld [wEndingCreditMessageId], a
    ld a, $10
    ld [wMessageCharPeriod], a

Ending_StartCurrentCredit::
    ld a, [wEndingCreditMessageId]
    call StartMessageFar
    ret


Ending_CheckFinalCredit::
    ld a, [wEndingCreditMessageId]
    cp $59
    jr nz, Ending_BlankCreditBeforeAdvance

    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0203
    ld de, $0000
    jp RequestStateChange_Menu


Ending_BlankCreditBeforeAdvance::
    ld a, $0d
    ld [wMessageFlags], a
    ld a, $0c
    ld [wMessageCharPeriod], a
    ld a, [wScreenFrameCounter]
    inc a
    ld [wScreenFrameCounter], a
    cp $30
    jr z, Ending_StartCurrentCredit

    ret


Ending_UpdateScrollingPresentation::
    call UpdateEndingAlternateSequence
    ld e, ENDING_PARTICLE_COUNT
    ld hl, wEndingParticles
    ld d, $01
    ld a, [wScreenFrameCounter]
    bit 0, a
    jr z, EndingScroll_UpdateNextParticle

    ld d, $02

EndingScroll_UpdateNextParticle::
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
    jr nz, EndingScroll_SelectParticleMetasprite

    dec hl
    dec hl
    dec hl
    ld a, e
    add a
    add e
    ld de, EndingParticleSeeds
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

EndingScroll_SelectParticleMetasprite::
    ld d, $f1
    ld a, [wScreenFrameCounter]
    bit 3, a
    jr z, EndingScroll_DrawParticle

    ld d, $f0

EndingScroll_DrawParticle::
    call DrawBank3MetaspriteNormal
    pop de
    pop hl
    dec e
    jr nz, EndingScroll_UpdateNextParticle

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
    jr nz, EndingScroll_ClearTrailingTextRow

    call UpdateMessageFar
    ret


EndingScroll_ClearTrailingTextRow::
; Clear the ten-column text window halfway through each 8-pixel scroll step.
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
IF DEF(ZH_TW)
    ld de, $010b
ELSE
    ld de, $010a
ENDC
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
    ld a, [wEndingSecondaryOffset]
    ld b, a
    ld a, $50
    sub b
    ld c, a
    ld de, wSceneAnim1PtrLo
    call AnimateSceneMetasprite
    ld a, [wScreenSubstate]
    rst $00
EndingAlternateStateHandlers::
    dw Ending_AlternateWaitForControl ; $00
    dw Ending_AlternateIncreasePrimaryOffset ; $01
    dw Ending_AlternateDecreasePrimaryOffset ; $02
    dw Ending_AlternateIncreasePrimaryOffsetAgain ; $03
    dw Ending_AlternateMoveSecondaryAndExit ; $04
Ending_AlternateWaitForControl::
    ret


Ending_AlternateIncreasePrimaryOffset::
    ld a, [wScreenFrameCounter]
    and $07
    jr nz, EndingAlternate_CheckFirstControl

    ld a, [wScreenPhaseCounter]
    inc a
    cp $30
    jr c, EndingAlternate_StoreFirstOffset

    ld a, $30

EndingAlternate_StoreFirstOffset::
    ld [wScreenPhaseCounter], a

EndingAlternate_CheckFirstControl::
    ld a, [wMessageControlValue]
    cp $01
    ret nz

    ld a, $02
    ld [wMessageControlValue], a
    ret


Ending_AlternateDecreasePrimaryOffset::
    ld a, [wScreenFrameCounter]
    and $07
    jr nz, EndingAlternate_CheckSecondControl

    ld a, [wScreenPhaseCounter]
    dec a
    bit 7, a
    jr z, EndingAlternate_StoreReturnOffset

    xor a

EndingAlternate_StoreReturnOffset::
    ld [wScreenPhaseCounter], a

EndingAlternate_CheckSecondControl::
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


Ending_AlternateIncreasePrimaryOffsetAgain::
    ld a, [wScreenFrameCounter]
    and $07
    jr nz, EndingAlternate_CheckThirdControl

    ld a, [wScreenPhaseCounter]
    inc a
    cp $30
    jr c, EndingAlternate_StoreSecondOffset

    ld a, $30

EndingAlternate_StoreSecondOffset::
    ld [wScreenPhaseCounter], a

EndingAlternate_CheckThirdControl::
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
    ld [wEndingExitDelay], a
    ld a, $04
    ld [wMessageControlValue], a
    ret


Ending_AlternateMoveSecondaryAndExit::
    ld a, [wEndingExitDelay]
    cp $20
    call nc, Ending_FadeAndReturnToMenu
    ld a, [wScreenFrameCounter]
    and $07
    ret nz

    ld a, [wEndingSecondaryOffset]
    inc a
    cp $30
    jr c, EndingAlternate_StoreSecondaryOffset

    ld a, $30

EndingAlternate_StoreSecondaryOffset::
    ld [wEndingSecondaryOffset], a
    ld a, [wMessageState]
    or a
    ret nz

    ld a, [wEndingExitDelay]
    inc a
    ld [wEndingExitDelay], a
    ret


Ending_FadeAndReturnToMenu::
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld bc, $0204
    ld a, [wSpecialModeFlags]
    or a
    jr z, Ending_ReturnToSelectedMenu

    ld bc, $0205

Ending_ReturnToSelectedMenu::
    ld de, $0000
    jp RequestStateChange_Menu
