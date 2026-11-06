; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $002", ROMX[ROM_BANK_ID_ADDR], BANK[$2]

RomBankId_Bank2::
    db $02
Bank2FarCallTable::
    dw InitTitleOrPasswordScreen ; $00
    dw UpdateTitleOrPasswordScreen ; $02
    dw InitMinigameScreen ; $04
    dw UpdateMinigameScreen ; $06
    dw InitSceneTestMenu ; $08
    dw UpdateSceneTestMenu ; $0a
    dw InitStageTransitionScreens ; $0c
    dw UpdateStageTransitionScreens ; $0e
    dw InitEndingScreen ; $10
    dw UpdateEndingScreen ; $12

INCLUDE "engine/screens/title.asm"
INCLUDE "engine/screens/menu_background.asm"
INCLUDE "engine/screens/transitions.asm"
INCLUDE "data/menu_background.asm"
INCLUDE "engine/screens/password.asm"
INCLUDE "engine/screens/scene_test.asm"
INCLUDE "engine/minigames/common.asm"
INCLUDE "engine/minigames/bonus.asm"
INCLUDE "engine/minigames/slide_jump.asm"
INCLUDE "engine/minigames/mekemeke.asm"
INCLUDE "engine/minigames/bug_hunt.asm"
INCLUDE "engine/minigames/score.asm"
INCLUDE "engine/minigames/bug_hunt_result.asm"
INCLUDE "engine/minigames/bug_hunt_hazards.asm"
INCLUDE "data/bug_hunt.asm"
INCLUDE "engine/screens/stage_transition.asm"
INCLUDE "engine/screens/continue.asm"
INCLUDE "engine/screens/stage_dialogue.asm"
INCLUDE "data/stage_dialogue.asm"

INCLUDE "engine/ending.asm"

INCLUDE "data/ending.asm"
INCLUDE "data/scene_animations.asm"

GfxRle_b02_7b8e::
; Source: gfx/compressed/b02_7b8e.png (prevbyte, 1296 decoded bytes).
    INCBIN "../build/original/assets/b02_7b8e.bin"


GfxRle_b02_7fe0::
; Source: gfx/compressed/b02_7fe0.png (prevbyte, 16 decoded bytes).
    INCBIN "../build/original/assets/b02_7fe0.bin"


    ds $8000 - @, $ff
