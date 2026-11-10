; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; Graphics/compressed data bank: opcode-looking bytes below are data.
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

    db $06


GfxRle_b06_4001::
; Source: gfx/compressed/b06_4001.png (prevbyte, 3776 decoded bytes).
    INCBIN "assets/b06_4001.bin"

GfxRle_b06_4bc0::
; Source: gfx/compressed/b06_4bc0.png (prevbyte, 2048 decoded bytes).
    INCBIN "assets/b06_4bc0.bin"


LayoutRle_b06_501e::
; Source: maps/title.bin (rleff, 360 decoded bytes).
    INCBIN "assets/b06_501e.bin"


Gfx_b06_50c4::
; Source: gfx/raw/b06_50c4_font_and_symbols.png (raw, 624 decoded bytes).
    INCBIN "assets/b06_50c4.bin"

; Source: gfx/compressed/b06_5334.png (prevbyte, 224 decoded bytes).
IF DEF(TEST_RELOCATE_BONUS_GFX)
    ASSERT @ == $5334
    ds $53ec - @, $ff ; Keep the following bank 6 assets at their original addresses.
ELSE
GfxRle_b06_5334::
    INCBIN "assets/b06_5334.bin"
ENDC

GfxRle_b06_53ec::
; Source: gfx/compressed/b06_53ec.png (prevbyte, 384 decoded bytes).
    INCBIN "assets/b06_53ec.bin"

GfxRle_b06_5556::
; Source: gfx/compressed/b06_5556.png (prevbyte, 688 decoded bytes).
    INCBIN "assets/b06_5556.bin"

LayoutRle_b06_5787::
; Source: maps/bonus.bin (rleff, 360 decoded bytes).
    INCBIN "assets/b06_5787.bin"


GfxRle_b06_5851::
; Source: gfx/compressed/b06_5851.png (prevbyte, 2800 decoded bytes).
    INCBIN "assets/b06_5851.bin"

LayoutRle_b06_60db::
; Source: maps/b06_60db.bin (rleff, 360 decoded bytes).
    INCBIN "assets/b06_60db.bin"


GfxRle_b06_6156::
; Source: gfx/compressed/b06_6156.png (prevbyte, 960 decoded bytes).
    INCBIN "assets/b06_6156.bin"

GfxRle_b06_641e::
; Source: gfx/compressed/b06_641e.png (prevbyte, 752 decoded bytes).
    INCBIN "assets/b06_641e.bin"


GfxRle_b06_663c::
; Source: gfx/compressed/b06_663c.png (prevbyte, 464 decoded bytes).
    INCBIN "assets/b06_663c.bin"


LayoutRle_b06_6801::
; Source: maps/b06_6801.bin (rleff, 360 decoded bytes).
    INCBIN "assets/b06_6801.bin"

GfxRle_b06_6839::
; Source: gfx/compressed/b06_6839.png (prevbyte, 1728 decoded bytes).
    INCBIN "assets/b06_6839.bin"

GfxRle_b06_6e44::
; Source: gfx/compressed/b06_6e44.png (prevbyte, 480 decoded bytes).
    INCBIN "assets/b06_6e44.bin"

LayoutRle_b06_6fe5::
; Source: maps/b06_6fe5.bin (rleff, 360 decoded bytes).
    INCBIN "assets/b06_6fe5.bin"


GfxRle_b06_7099::
; Source: gfx/compressed/b06_7099.png (prevbyte, 1488 decoded bytes).
    INCBIN "assets/b06_7099.bin"

GfxRle_b06_7581::
; Source: gfx/compressed/b06_7581.png (prevbyte, 160 decoded bytes).
    INCBIN "assets/b06_7581.bin"

LayoutRle_b06_75fe::
; Source: maps/b06_75fe.bin (rleff, 160 decoded bytes).
    INCBIN "assets/b06_75fe.bin"

LayoutRle_b06_762c::
; Source: maps/stage_intro.bin (rleff, 360 decoded bytes).
    INCBIN "assets/b06_762c.bin"


GfxRle_b06_7700::
; Source: gfx/compressed/b06_7700.png (prevbyte, 1024 decoded bytes).
    INCBIN "assets/b06_7700.bin"


GfxRle_b06_7a71::
; Source: gfx/compressed/b06_7a71.png (prevbyte, 192 decoded bytes).
    INCBIN "assets/b06_7a71.bin"


GfxRle_b06_7b22::
; Source: gfx/compressed/b06_7b22.png (prevbyte, 240 decoded bytes).
    INCBIN "assets/b06_7b22.bin"


GfxRle_b06_7c0e::
; Source: gfx/compressed/b06_7c0e.png (prevbyte, 560 decoded bytes).
    INCBIN "assets/b06_7c0e.bin"

GfxRle_b06_7e13::
; Source: gfx/compressed/b06_7e13.png (prevbyte, 448 decoded bytes).
    INCBIN "assets/b06_7e13.bin"

    ds $8000 - @, $ff
