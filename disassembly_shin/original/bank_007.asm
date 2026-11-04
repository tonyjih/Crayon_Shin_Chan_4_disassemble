; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; Uncompressed stage tiles and native music/sound-effect data.
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

    db $07

Gfx_b07_4001::
; Source: gfx/raw/b07_4001_stage0.png (raw, 512 decoded bytes).
    INCBIN "../build/original/assets/b07_4001.bin"


Gfx_b07_4201::
; Source: gfx/raw/b07_4201_stage0_part2.png (raw, 256 decoded bytes).
    INCBIN "../build/original/assets/b07_4201.bin"


Gfx_b07_4301::
; Source: gfx/raw/b07_4301_stage0_part3.png (raw, 224 decoded bytes).
    INCBIN "../build/original/assets/b07_4301.bin"


Gfx_b07_43e1::
; Source: gfx/raw/b07_43e1_stage0_part4.png (raw, 768 decoded bytes).
    INCBIN "../build/original/assets/b07_43e1.bin"

Gfx_b07_46e1::
; Source: gfx/raw/b07_46e1_stage1.png (raw, 2048 decoded bytes).
    INCBIN "../build/original/assets/b07_46e1.bin"

Gfx_b07_4ee1::
; Source: gfx/raw/b07_4ee1_stage1_late.png (raw, 1152 decoded bytes).
    INCBIN "../build/original/assets/b07_4ee1.bin"

Gfx_b07_5361::
; Source: gfx/raw/b07_5361_stage2.png (raw, 1936 decoded bytes).
    INCBIN "../build/original/assets/b07_5361.bin"

Gfx_b07_5af1::
; Source: gfx/raw/b07_5af1_stage3.png (raw, 1264 decoded bytes).
    INCBIN "../build/original/assets/b07_5af1.bin"


Gfx_b07_5fe1::
; Source: gfx/raw/b07_5fe1_stage3_part2.png (raw, 272 decoded bytes).
    INCBIN "../build/original/assets/b07_5fe1.bin"


Gfx_b07_60f1::
; Source: gfx/raw/b07_60f1_stage3_part3.png (raw, 256 decoded bytes).
    INCBIN "../build/original/assets/b07_60f1.bin"


Gfx_b07_61f1::
; Source: gfx/raw/b07_61f1_stage3_part4.png (raw, 16 decoded bytes).
    INCBIN "../build/original/assets/b07_61f1.bin"


INCLUDE "audio/sound_data.asm"


    ds $8000 - @, $ff
