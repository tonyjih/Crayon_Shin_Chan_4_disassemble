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
