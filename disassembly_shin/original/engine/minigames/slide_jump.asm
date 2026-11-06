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
