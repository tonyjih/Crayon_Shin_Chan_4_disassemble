; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; Graphics/compressed data bank: opcode-looking bytes below are data.
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

    db $05

Gfx_b05_4001::
; Source: gfx/raw/b05_4001_common_sprites.png (raw, 304 decoded bytes).
    INCBIN "assets/b05_4001.bin"


Gfx_b05_4131::
; Source: gfx/raw/b05_4131_player_normal.png (raw, 1136 decoded bytes).
    INCBIN "assets/b05_4131.bin"

Gfx_b05_45a1::
; Source: gfx/raw/b05_45a1_player_flying_squirrel.png (raw, 1328 decoded bytes).
    INCBIN "assets/b05_45a1.bin"

Gfx_b05_4ad1::
; Source: gfx/raw/b05_4ad1_player_action_kamen_part.png (raw, 1136 decoded bytes).
    INCBIN "assets/b05_4ad1.bin"

Gfx_b05_4f41::
; Source: gfx/raw/b05_4f41_player_chicken_part.png (raw, 1120 decoded bytes).
    INCBIN "assets/b05_4f41.bin"

Gfx_b05_53a1::
; Source: gfx/raw/b05_53a1_player_cockroach_part.png (raw, 864 decoded bytes).
    INCBIN "assets/b05_53a1.bin"

Gfx_b05_5701::
; Source: gfx/raw/b05_5701_shared_hud_objects.png (raw, 480 decoded bytes).
    INCBIN "assets/b05_5701.bin"


Gfx_b05_58e1::
; Source: gfx/raw/b05_58e1_tiles_58e1.png (raw, 288 decoded bytes).
    INCBIN "assets/b05_58e1.bin"

Gfx_b05_5a01::
; Source: gfx/raw/b05_5a01_stage_tiles_5a01.png (raw, 208 decoded bytes).
    INCBIN "assets/b05_5a01.bin"

Gfx_b05_5ad1::
; Source: gfx/raw/b05_5ad1_stage0_objects.png (raw, 240 decoded bytes).
    INCBIN "assets/b05_5ad1.bin"

Gfx_b05_5bc1::
; Source: gfx/raw/b05_5bc1_stage1_objects.png (raw, 416 decoded bytes).
    INCBIN "assets/b05_5bc1.bin"

Gfx_b05_5d61::
; Source: gfx/raw/b05_5d61_stage2_objects.png (raw, 128 decoded bytes).
    INCBIN "assets/b05_5d61.bin"


Gfx_b05_5de1::
; Source: gfx/raw/b05_5de1_tiles_5de1.png (raw, 240 decoded bytes).
    INCBIN "assets/b05_5de1.bin"

Gfx_b05_5ed1::
; Source: gfx/raw/b05_5ed1_stage_shared_objects.png (raw, 672 decoded bytes).
    INCBIN "assets/b05_5ed1.bin"

Gfx_b05_6171::
; Source: gfx/raw/b05_6171_stage_shared_objects_6171.png (raw, 608 decoded bytes).
    INCBIN "assets/b05_6171.bin"


Gfx_b05_63d1::
; Source: gfx/raw/b05_63d1_tiles_63d1.png (raw, 64 decoded bytes).
    INCBIN "assets/b05_63d1.bin"


Gfx_b05_6411::
; Source: gfx/raw/b05_6411_stage2_overlay.png (raw, 208 decoded bytes).
    INCBIN "assets/b05_6411.bin"


Gfx_b05_64e1::
; Source: gfx/raw/b05_64e1_stage3_objects.png (raw, 4000 decoded bytes).
    INCBIN "assets/b05_64e1.bin"

GfxRle_b05_7481::
; Source: gfx/compressed/b05_7481.png (prevbyte, 3072 decoded bytes).
    INCBIN "assets/b05_7481.bin"

    ds $8000 - @, $ff
