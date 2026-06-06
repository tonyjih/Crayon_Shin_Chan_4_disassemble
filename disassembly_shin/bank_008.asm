; DX / CGB support bank.
;
; This bank intentionally keeps non-critical CGB helper code and data out of
; bank 0. Bank 0 should only keep tiny far-call wrappers / hot-path hooks.

SECTION "ROM Bank $008", ROMX[$4000], BANK[$8]

; -----------------------------------------------------------------------------
; InitCgbGrayscalePalettes
; -----------------------------------------------------------------------------
; Initializes all CGB BG palettes and OBJ palettes to a DMG-like 4-color
; grayscale ramp.
;
; Safe to call on DMG/SGB too: it returns immediately unless wCgbEnabled != 0.
;
; Result:
;   BG palettes  0-7 = white, light gray, dark gray, black
;   OBJ palettes 0-7 = white, light gray, dark gray, black
;
; Call from bank 0 through a far-call wrapper after wCgbEnabled is initialized.
;
InitCgbGrayscalePalettes::
    ld a, [wCgbEnabled]
    or a
    ret z

    ; BG palette RAM index 0, auto-increment enabled.
    ld a, $80
    ldh [rBCPS], a
    ld c, LOW(rBCPD)
    call FillCgbGrayscalePaletteRam

    ; OBJ palette RAM index 0, auto-increment enabled.
    ld a, $80
    ldh [rOCPS], a
    ld c, LOW(rOCPD)
    jp FillCgbGrayscalePaletteRam


; Fill 64 bytes of CGB palette RAM through register c.
; Input:
;   c = LOW(rBCPD) or LOW(rOCPD)
; Clobbers:
;   af, b, c, e, hl
;
FillCgbGrayscalePaletteRam::
    ld b, $08

.paletteLoop
    ld hl, CgbPalette_Grayscale4
    ld e, $08

.colorLoop
    ld a, [hl+]
    ldh [c], a
    dec e
    jr nz, .colorLoop

    dec b
    jr nz, .paletteLoop

    ret


; DMG-like grayscale colors in CGB RGB555 / BGR555 format.
;
CgbPalette_Grayscale4::
    dw $7fff ; shade 0: white
    dw $56b5 ; shade 1: light gray
    dw $294a ; shade 2: dark gray
    dw $0000 ; shade 3: black


; -----------------------------------------------------------------------------
; LoadCgbScreenPaletteFromSgbId
; -----------------------------------------------------------------------------
; Uses the same 6-byte screen-palette records as the SGB PAL_SET sender in
; bank 3. The first four bytes are SGB palette IDs. We mirror those four IDs
; into four CGB base BG palettes and four CGB base OBJ palettes.
;
; The actual CGB palette RAM write still passes through
; ApplyCgbPalettesFromDmgShadow, so original DMG palette-byte effects still work.
;
LoadCgbScreenPaletteFromSgbId::
    ld a, [wCgbEnabled]
    or a
    ret z

    ld a, [wScreenPaletteId]
    ld e, a
    add a
    ld b, a
    add a
    add b ; a = wScreenPaletteId * 6
    ld hl, CgbSgbScreenPaletteTable
    rst $38

    ld de, wCgbBaseBgPalettes
    ld b, $04

.loadBgLoop
    ld a, [hl+]
    push hl
    push bc
    push de
    call CopyCgbSgbPaletteIdToDE
    pop de
    ld hl, $0008
    add hl, de
    ld d, h
    ld e, l
    pop bc
    pop hl
    dec b
    jr nz, .loadBgLoop

    ; For now OBJ base palettes mirror BG base palettes. This keeps the first
    ; CGB color pass close to the existing SGB palette selection. We can split
    ; BG/OBJ art direction later.
    ld hl, wCgbBaseBgPalettes
    ld de, wCgbBaseObjPalettes
    ld b, $20
.copyObjLoop
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .copyObjLoop

    call InitCgbObjTilePaletteMap_Default
    call ApplyCgbPalettesFromDmgShadow
    jp LoadCgbBgAttrsForScreenFromSgbId


; Input:
;   a  = SGB palette ID, 0-$3f
;   de = destination, 8 bytes
; Clobbers af, b, de, hl.
CopyCgbSgbPaletteIdToDE::
    and $3f

    push de                 ; save destination

    ld l, a
    ld h, $00
    add hl, hl              ; *2
    add hl, hl              ; *4
    add hl, hl              ; *8

    ld de, CgbSgbPaletteIdTable
    add hl, de              ; HL = table + palette_id * 8

    pop de                  ; restore destination

    ld b, $08
.copyLoop
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .copyLoop
    ret


; -----------------------------------------------------------------------------
; InitCgbObjTilePaletteMap_Default
; -----------------------------------------------------------------------------
; Initializes the active 256-byte OBJ tile-id -> CGB OBJ palette map.
;
; Values:
;   $ff    = fallback to DMG OBP0/OBP1 conversion
;   $00-07 = force CGB OBJ palette number
;
; Default map is intentionally conservative: every OBJ tile uses fallback.
; Screen-specific loaders, such as InitCgbObjTilePaletteMap_Title, may override
; selected tile IDs after this default clear.
;
; This table lives in WRAM for easy debugger editing and future dynamic loading.
InitCgbObjTilePaletteMap_Default::
    ld hl, wCgbObjTilePaletteMap
    ld a, $ff
    ld b, $00 ; 256 bytes
.fillFallbackLoop
    ld [hl+], a
    dec b
    jr nz, .fillFallbackLoop
    ret


; -----------------------------------------------------------------------------
; InitCgbObjTilePaletteMap_Title
; -----------------------------------------------------------------------------
; Title-screen-specific OBJ tile palette overrides.
; This preserves the phase5 proof-of-concept behavior only for screens that use
; the title SGB attr file.
;
;   tile $00-$74 -> OBJ palette 1  ; Shin-chan title sprite tiles
;   tile $75-$83 -> OBJ palette 2  ; Shiro title sprite tiles
;
InitCgbObjTilePaletteMap_Title::
    ; tile $00-$74 -> OBJ palette 1
    ld hl, wCgbObjTilePaletteMap
    ld a, $01
    ld b, $75
.fillShinLoop
    ld [hl+], a
    dec b
    jr nz, .fillShinLoop

    ; tile $75-$83 -> OBJ palette 2
    ld a, $02
    ld b, $0f
.fillShiroLoop
    ld [hl+], a
    dec b
    jr nz, .fillShiroLoop
    ret


; -----------------------------------------------------------------------------
; ApplyCgbPalettesFromDmgShadow
; -----------------------------------------------------------------------------
; Converts existing DMG palette shadow bytes into CGB palette RAM, but uses the
; current CGB base palettes instead of a fixed grayscale ramp.
;
; BG palettes 0-3 all use wPaletteBGP over their own base palette. This makes
; future BG attribute palettes still respect fade/flash effects.
; OBJ palettes 0-3 use their own base palettes. Palette 0 follows OBP0,
; palette 1 follows OBP1, and palettes 2-3 follow OBP0 for DX-only OBJ
; assignments such as Shiro using OBJP2.
;
ApplyCgbPalettesFromDmgShadow::
    ; BG palette RAM index 0, auto-increment enabled.
    ld a, $80
    ldh [rBCPS], a

    ld hl, wCgbBaseBgPalettes
    ld a, [wPaletteBGP]
    call WriteCgbPaletteFromDmgByteWithBaseToBCPD
    ld hl, wCgbBaseBgPalettes + $08
    ld a, [wPaletteBGP]
    call WriteCgbPaletteFromDmgByteWithBaseToBCPD
    ld hl, wCgbBaseBgPalettes + $10
    ld a, [wPaletteBGP]
    call WriteCgbPaletteFromDmgByteWithBaseToBCPD
    ld hl, wCgbBaseBgPalettes + $18
    ld a, [wPaletteBGP]
    call WriteCgbPaletteFromDmgByteWithBaseToBCPD

    ; OBJ palette 0 from wPaletteOBP0.
    ld a, $80
    ldh [rOCPS], a
    ld hl, wCgbBaseObjPalettes
    ld a, [wPaletteOBP0]
    call WriteCgbPaletteFromDmgByteWithBaseToOCPD

    ; OBJ palette 1 from wPaletteOBP1.
    ld a, $88
    ldh [rOCPS], a
    ld hl, wCgbBaseObjPalettes + $08
    ld a, [wPaletteOBP1]
    call WriteCgbPaletteFromDmgByteWithBaseToOCPD

    ; OBJ palette 2 from wPaletteOBP0.
    ; Used by the title Shiro tile-id override ($75-$83 -> OBJP2).
    ld a, $90
    ldh [rOCPS], a
    ld hl, wCgbBaseObjPalettes + $10
    ld a, [wPaletteOBP1]
    call WriteCgbPaletteFromDmgByteWithBaseToOCPD

    ; OBJ palette 3 from wPaletteOBP0.
    ; Reserved for future DX-only OBJ palette assignments.
    ld a, $98
    ldh [rOCPS], a
    ld hl, wCgbBaseObjPalettes + $18
    ld a, [wPaletteOBP1]
    call WriteCgbPaletteFromDmgByteWithBaseToOCPD

    ret


WriteCgbPaletteFromDmgByteWithBaseToBCPD::
    ld c, LOW(rBCPD)
    jr WriteCgbPaletteFromDmgByteWithBase

WriteCgbPaletteFromDmgByteWithBaseToOCPD::
    ld c, LOW(rOCPD)

; Input:
;   a  = DMG palette byte
;   hl = 8-byte CGB base palette, shade 0..3
;   c  = LOW(rBCPD) or LOW(rOCPD)
; Clobbers af, b, c, de, hl.
WriteCgbPaletteFromDmgByteWithBase::
    ld d, h
    ld e, l
    ld b, $04

.colorLoop
    push af
    and $03
    add a
    ld l, a
    ld h, $00
    add hl, de
    ld a, [hl+]
    ldh [c], a
    ld a, [hl]
    ldh [c], a
    pop af
    srl a
    srl a
    dec b
    jr nz, .colorLoop
    ret



; -----------------------------------------------------------------------------
; LoadCgbBgAttrsForScreenFromSgbId
; -----------------------------------------------------------------------------
; Rebuilds CGB BG attribute map after each screen/state init.
;
; This is intentionally conservative for phase 1:
;   - every screen starts with BG palette 0 everywhere
;   - selected screens get coarse SGB-like attribute rectangles
;
; Call timing assumption:
;   Called from ReinitCurrentState after InitCurrentGameState while LCD is off.
;   Direct VRAM bank 1 writes are therefore safe.
;
LoadCgbBgAttrsForScreenFromSgbId::
    ld a, [wCgbEnabled]
    or a
    ret z

    call ClearCgbBgAttrMap

    ; Mirror the SGB PAL_SET attr-file selection instead of keying directly on
    ; wScreenPaletteId. Bank 3 stores six-byte records:
    ;   pal0, pal1, pal2, pal3, attr_file, extra
    ; The SGB sender sets bit 7 before putting attr_file in the PAL_SET packet,
    ; so CGB only cares about the low 7 bits here.
    ld a, [wScreenPaletteId]
    add a
    ld b, a
    add a
    add b ; a = wScreenPaletteId * 6
    add $04
    ld hl, CgbSgbScreenPaletteTable
    rst $38
    ld a, [hl]
    and $7f
    cp $01 ; SGB attr file 1 = title screen layout.
    jr nz, .notTitle

    call InitCgbObjTilePaletteMap_Title
    jp LoadCgbTitleScreenAttrMap

.notTitle
    ret


; Clears the full BG map attribute area ($9800-$9bff) to palette 0.
; Clobbers af, bc, hl.
;
ClearCgbBgAttrMap::
    ld a, $01
    ldh [rVBK], a

    ld hl, $9800
    ld bc, $0400
    ld d, $00

.clearLoop
    ld a, d
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, .clearLoop

    xor a
    ldh [rVBK], a
    ret


; First-pass title attribute layout.
;
; This is deliberately coarse. It gives the title logo several BG palettes so
; the CGB path behaves more like the SGB title screen, where PAL_SET is combined
; with attribute data instead of using one palette for the whole tilemap.
;
; Attribute byte bits used here:
;   bits 0-2 = BG palette number
;
LoadCgbTitleScreenAttrMap::
    ld a, $01
    ldh [rVBK], a

    ld hl, CgbTitleAttrMap
    ld de, $9800
    ld c, $12 ; 18 visible rows

.rowLoop
    ld b, $14 ; 20 visible columns

.colLoop
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .colLoop

    ; Skip the hidden 12 columns in each 32-byte BG map row.
    ld a, e
    add $0c
    ld e, a
    ld a, d
    adc $00
    ld d, a

    dec c
    jr nz, .rowLoop

    xor a
    ldh [rVBK], a
    ret

; Fill a rectangle in the currently selected VRAM bank.
;
; Input:
;   hl = destination BG map address
;   b  = width in tiles
;   c  = height in tiles
;   a  = attribute byte to write
; Clobbers af, bc, de, hl.
;
FillCgbBgAttrRect::
    ld d, a

.rowLoop
    push hl
    push bc

.colLoop
    ld [hl], d
    inc hl
    dec b
    jr nz, .colLoop

    pop bc
    pop hl
    ld a, $20
    rst $38
    dec c
    jr nz, .rowLoop

    ret

CgbTitleAttrMap::
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00, $00 ; row 0
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00, $00 ; row 1
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00, $00 ; row 2
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00, $00 ; row 3
    db $03, $03, $03, $03, $03, $03, $03, $03, $02, $03, $02, $03, $03, $03, $03, $03, $03, $00, $00, $00 ; row 4
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 5
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 6
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 7
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 8
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 9
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 10
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 11
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 12
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 13
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 14
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 15
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 16
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; row 17


CgbSgbScreenPaletteTable::
    ; Mirrored from bank 3 SgbScreenPaletteTable_4d5f.
    ; id  pal0 pal1 pal2 pal3 ctl extra
    db $01, $01, $01, $01, $00, $00 ; $00
    db $04, $05, $06, $07, $01, $01 ; $01
    db $28, $29, $2a, $2b, $02, $03 ; $02
    db $08, $09, $0a, $0b, $03, $08 ; $03
    db $00, $00, $00, $00, $00, $00 ; $04
    db $10, $11, $12, $13, $05, $03 ; $05
    db $14, $15, $16, $17, $06, $03 ; $06
    db $2c, $2d, $2e, $00, $04, $03 ; $07
    db $18, $19, $1a, $1b, $07, $03 ; $08
    db $1c, $1d, $1e, $1f, $08, $03 ; $09
    db $20, $21, $22, $23, $0a, $03 ; $0a
    db $24, $25, $26, $27, $0c, $03 ; $0b
    db $34, $34, $34, $34, $00, $08 ; $0c
    db $0c, $0d, $0e, $0f, $0e, $08 ; $0d
    db $35, $35, $35, $35, $00, $08 ; $0e
    db $00, $00, $00, $00, $00, $05 ; $0f
    db $18, $19, $1a, $1b, $07, $03 ; $10
    db $1c, $1d, $1e, $1f, $09, $03 ; $11
    db $20, $21, $22, $02, $0b, $03 ; $12
    db $24, $25, $26, $27, $0d, $03 ; $13
    db $03, $03, $03, $03, $0f, $08 ; $14
    db $03, $03, $03, $03, $00, $00 ; $15
    db $01, $01, $01, $01, $0f, $00 ; $16
    db $3c, $3d, $3e, $3f, $0e, $00 ; $17
    db $03, $03, $03, $03, $00, $07 ; $18
    db $3c, $3d, $3e, $3f, $10, $04 ; $19
    db $38, $38, $38, $38, $00, $09 ; $1a
    db $39, $39, $39, $39, $00, $07 ; $1b
    db $3a, $3a, $3a, $3a, $00, $06 ; $1c
    db $3b, $3b, $3b, $3b, $00, $0a ; $1d
    db $00, $00, $00, $00, $00, $02 ; $1e


CgbSgbPaletteIdTable::
    ; Initial RGB555 table keyed by SGB palette ID. This central table is the
    ; only place that needs refinement if we replace the approximated colors
    ; with exact SGB BIOS palette values later.
    dw $679F, $161C, $0D13, $0000
    dw $7FFF, $7FFF, $7FFF, $7FFF
    dw $7FFF, $3B3F, $7DA0, $0000
    dw $7FFF, $5294, $294A, $0000
    dw $7FFB, $7FFF, $7FFF, $7CC0
    dw $7FFB, $3F3F, $6D24, $0000
    dw $7FFB, $7FFF, $0252, $0000
    dw $7FFB, $557F, $03FF, $1D4B
    dw $4BFF, $7D48, $0000, $0000
    dw $4BFF, $3B3F, $2C7D, $0000
    dw $4BFF, $3FF8, $285F, $0C20
    dw $4BFF, $0000, $0000, $0280
    dw $6B77, $43EA, $0DA7, $0000
    dw $6B77, $7FFF, $7DE3, $0000
    dw $6B77, $4AFF, $131F, $0000
    dw $6B77, $0A7F, $001F, $0000
    dw $7FFF, $03FF, $0233, $0000
    dw $7FFF, $32FF, $2634, $0000
    dw $7FFF, $67E7, $0000, $0000
    dw $7FFF, $11BF, $0000, $0000
    dw $7FFF, $021C, $001F, $0000
    dw $7FFF, $32FF, $051E, $0000
    dw $7FFF, $67E7, $0000, $0000
    dw $7FFF, $11BF, $0000, $0000
    dw $7FFF, $7E74, $7FFF, $0000
    dw $7FFF, $3B3F, $0384, $0000
    dw $7FFF, $3B3F, $091B, $0000
    dw $7FFF, $03FF, $091B, $0000
    dw $7FFF, $429F, $0000, $0000
    dw $7FFF, $3B3F, $03FF, $0000
    dw $7FFF, $3B3F, $7E02, $0000
    dw $7FFF, $3B3F, $091B, $0000
    dw $7FFF, $2F3F, $0000, $0000
    dw $7FFF, $3B3F, $4666, $0000
    dw $7FFF, $3B3F, $091B, $0000
    dw $7FFF, $7FE3, $001F, $0000
    dw $7FFF, $2FE9, $0000, $0000
    dw $7FFF, $6BFF, $7EC2, $0000
    dw $7FFF, $3B3F, $5A1F, $0000
    dw $7FFF, $03FF, $001F, $0000
    dw $3BFC, $53E0, $009F, $0000
    dw $3BFC, $26DB, $6D24, $0000
    dw $3BFC, $7FFF, $0252, $0000
    dw $3BFC, $0000, $0000, $007C
    dw $77BD, $7AF1, $4D8A, $0000
    dw $77BD, $333F, $36D3, $0000
    dw $77BD, $7D6C, $0000, $0000
    dw $0000, $0000, $0000, $0000
    dw $7FFF, $2DBE, $0000, $0000
    dw $7FFF, $3B3F, $1DD5, $0000
    dw $7FFF, $518C, $44E7, $0000
    dw $7FFF, $0000, $001F, $0000
    dw $77BD, $5A5F, $0CFD, $0000
    dw $63BC, $29FF, $3176, $0000
    dw $77BD, $5F9F, $2539, $0000
    dw $7FFF, $0000, $0000, $0000
    dw $77BD, $3B5D, $0ECC, $0000
    dw $77BD, $5790, $7E32, $0000
    dw $77BD, $5ADD, $6E8E, $0000
    dw $77BD, $3B9C, $332C, $0000
    dw $77BD, $7EEE, $0000, $01C0
    dw $77BD, $3B3F, $037E, $0000
    dw $77BD, $0258, $0193, $0000
