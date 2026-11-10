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
    dw RequestState_EnterBonusSubstate      ; 01
    dw RequestState_OpenMinigameInstructions ; 02
    dw RequestState_StartSelectedMinigame ; 03
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


RequestState_EnterBonusSubstate::
; C is $00 from stage clear or the scene test, $06 from a saved minigame return.
    xor a
    ld [wMinigameMode], a
    ld a, c
    ld [wScreenSubstate], a
    ld a, $03
    ldh [hGameState], a
    ret


RequestState_OpenMinigameInstructions::
; C is the instruction destination. The shared screen always uses BONUS substate $03.
    xor a
    ld [wMinigameMode], a
    ld a, c
    ld [wBonusDestination], a
    ld a, $03
    ld [wScreenSubstate], a
    ldh [hGameState], a
    ld a, $3f
    ld [wFadeTransitionTimer], a
    ret


RequestState_StartSelectedMinigame::
; Stations 0-2 select modes 1-3. Each mode initializes its own substate.
    ld a, c
    inc a
    ld [wMinigameMode], a
    ld a, $03
    ldh [hGameState], a
    xor a
    ld [wSlideReuseLayout], a
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
    ld [wEndingMode], a
    ret



; Indexed screen data; scene-specific interpretation is documented at its consumer.
