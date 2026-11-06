; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was originally produced by mgbdis, then cleaned up as data-only.

SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

; =========================
; Bank 4 level data
; =========================
; Bank1 stage resource tables reference the data blocks below.
; This file is annotation/data cleanup only: no bytes are moved,
; Tile tables, layouts and collision attributes are editable assets in levels/.

Bank4DataStart::
Bank4Padding4000:: ; $4000, byte before first referenced metatile table.
    db $04

; =========================
; Stage metatile quad tables
; =========================
; 4 bytes per 16x16 metatile: top-left, top-right, bottom-left, bottom-right
; 8x8 BG tile IDs. These IDs are interpreted through the current VRAM/profile.

Stage0MetatileQuads_Bank4::
Metatiles_stage0::
; Source: levels/stage0/metatiles.bin (raw, 736 decoded bytes).
    INCBIN "assets/b04_4001.bin"


Stage1MetatileQuads_Bank4::
Metatiles_stage1::
; Source: levels/stage1/metatiles.bin (raw, 848 decoded bytes).
    INCBIN "assets/b04_42e1.bin"


Stage2MetatileQuads_Bank4::
Metatiles_stage2::
; Source: levels/stage2/metatiles.bin (raw, 1024 decoded bytes).
    INCBIN "assets/b04_4631.bin"


Stage2MetatileQuadsAfterSwitch_Bank4::
Metatiles_stage2_after_switch::
; Source: levels/stage2_after_switch/metatiles.bin (raw, 152 decoded bytes).
    INCBIN "assets/b04_4a31.bin"


Stage3MetatileQuads_Bank4::
Metatiles_stage3::
; Source: levels/stage3/metatiles.bin (raw, 752 decoded bytes).
    INCBIN "assets/b04_4ac9.bin"


Stage4MetatileQuads_Bank4::
Metatiles_stage4::
; Source: levels/stage4/metatiles.bin (raw, 128 decoded bytes).
    INCBIN "assets/b04_4db9.bin"

; =========================
; Stage layout RLEFF streams
; =========================
; RLEFF format: literal byte != $ff outputs itself; $ff,count,value outputs
; value repeated count times. Streams decode to wStageLayoutMap ($c800).

Stage0LayoutRle_Bank4::
LayoutRle_b04_4e39::
; Source: levels/stage0/layout.bin (rleff, 3584 decoded bytes).
    INCBIN "assets/b04_4e39.bin"


Stage1LayoutRle_Bank4::
LayoutRle_b04_584b::
; Source: levels/stage1/layout.bin (rleff, 3584 decoded bytes).
    INCBIN "assets/b04_584b.bin"


Stage2LayoutRle_Bank4::
LayoutRle_b04_613a::
; Source: levels/stage2/layout.bin (rleff, 3584 decoded bytes).
    INCBIN "assets/b04_613a.bin"


Stage3LayoutRle_Bank4::
LayoutRle_b04_6b77::
; Source: levels/stage3/layout.bin (rleff, 4352 decoded bytes).
    INCBIN "assets/b04_6b77.bin"


Stage4LayoutRle_Bank4::
LayoutRle_b04_75d3::
; Source: levels/stage4/layout.bin (rleff, 256 decoded bytes).
    INCBIN "assets/b04_75d3.bin"


StageCollisionAttrsBlob_Bank4::
Stage0CollisionAttrsWindow_Bank4::
CollisionAttributes::
; Source: levels/shared/collision_attrs.bin (raw, 936 decoded bytes).
    INCBIN "assets/b04_7632.bin", $0, $b8

Stage1CollisionAttrsWindow_Bank4::
    INCBIN "assets/b04_7632.bin", $b8, $e0

Stage2CollisionAttrsWindow_Bank4::
    INCBIN "assets/b04_7632.bin", $198, $100

Stage2CollisionPatch_Bank4::
    INCBIN "assets/b04_7632.bin", $298, $30

Stage3CollisionAttrsWindow_Bank4::
    INCBIN "assets/b04_7632.bin", $2c8, $c0

Stage4CollisionAttrsWindow_Bank4::
    INCBIN "assets/b04_7632.bin", $388, $20

LayoutRle_b04_79da::
; Source: maps/waterfall.bin (rleff, 4096 decoded bytes).
    INCBIN "assets/b04_79da.bin", $0, $e0

Bank4PostCollisionData_Bank4::
    INCBIN "assets/b04_79da.bin", $e0, $416

    ds $8000 - @, $ff

Bank4DataEnd::
