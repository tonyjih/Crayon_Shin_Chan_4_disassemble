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

IF DEF(ZH_TW)
Minigame_DrawStartPromptZh::
    ld a, $02
    ld [wMessageFlags], a
    ld a, $4b
    jp StartMessageFar
ENDC


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
IF DEF(SGB_GBC)
    rlca
    ret nc
ELSE
    or a
    ret z
ENDC

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
