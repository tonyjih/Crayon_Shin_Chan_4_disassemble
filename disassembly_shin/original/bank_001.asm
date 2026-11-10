; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[ROM_BANK_ID_ADDR], BANK[$1]

RomBankId_Bank1::
    db $01

Bank1FarCallTable::
	dw UpdateGameplayState          ; FARCALL_BANK1_UPDATE_GAMEPLAY ($0100)
	dw Gameplay_InitEntry           ; FARCALL_BANK1_INIT_GAMEPLAY ($0102)
	dw UpdateTutorialDemo     ; FARCALL_BANK1_UPDATE_TUTORIAL ($0104)
    dw InitTutorialDemo       ; FARCALL_BANK1_INIT_TUTORIAL ($0106)

Bank1ShiftableStart::

INCLUDE "engine/gameplay/stage_init.asm"
INCLUDE "engine/gameplay/frame.asm"
INCLUDE "engine/player/projectiles.asm"
INCLUDE "engine/objects/spawn.asm"
INCLUDE "engine/objects/shared.asm"
INCLUDE "engine/gameplay/boss_intro.asm"
INCLUDE "engine/player/damage.asm"
INCLUDE "engine/player/motion.asm"
INCLUDE "engine/gameplay/animated_tiles.asm"
INCLUDE "engine/player/tile_collision.asm"
INCLUDE "engine/player/states.asm"
INCLUDE "engine/player/grounded_states.asm"
INCLUDE "engine/player/form_actions.asm"
INCLUDE "engine/player/ground_control.asm"
INCLUDE "engine/player/air_control.asm"
INCLUDE "engine/player/hurt_recovery.asm"
INCLUDE "engine/objects/pickups.asm"
INCLUDE "engine/objects/enemies.asm"
INCLUDE "engine/objects/bosses/stage0_hat.asm"
INCLUDE "engine/objects/tough_kid.asm"
INCLUDE "engine/objects/bosses/stage0.asm"
INCLUDE "engine/objects/bosses/stage1.asm"
INCLUDE "engine/objects/bosses/stage2.asm"
INCLUDE "engine/objects/bosses/stage3.asm"
INCLUDE "engine/objects/platforms.asm"
INCLUDE "engine/objects/stage2_props.asm"
INCLUDE "engine/objects/stage3_props.asm"
INCLUDE "data/stage_spawns.asm"
INCLUDE "engine/gameplay/tutorial.asm"
INCLUDE "data/tutorial_demo.asm"

PasswordScreenLayoutRle_Bank1::
LayoutRle_b01_7e7c::
; Source: maps/password.asm (assembled to 360 bytes, then compressed with RLEFF).
    INCBIN "assets/b01_7e7c.bin"


    ds $8000 - @, $ff
