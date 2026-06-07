; DX / CGB support bank.
;
; This bank intentionally keeps non-critical CGB helper code and data out of
; bank 0. Bank 0 should only keep tiny far-call wrappers / hot-path hooks.

SECTION "ROM Bank $008", ROMX[$4000], BANK[$8]

; -----------------------------------------------------------------------------
; Bank 8 DX call table
; -----------------------------------------------------------------------------
; Compatible with FarCallFromBankTable in bank 0. That helper reads a pointer
; from bank:$4000 + L + 1, so byte $4000 is reserved as padding and the first
; callable entry begins at $4001.
;
; Bank 0/1 should call these with:
;   ld hl, DX8_CALL_* ; H=$08, L=table offset
;   call FarCallFromBankTable
;
DxBank8CallTablePadding::
    db $00

DxBank8CallTable::
    dw InitCgbGrayscalePalettes
    dw DxLoadCgbScreenPaletteFromSgbId_Preserve
    dw DxApplyCgbPalettesFromDmgShadow_Preserve
    dw DxLoadCgbStageTilePaletteAttrs_Preserve

DxLoadCgbScreenPaletteFromSgbId_Preserve::
    push bc
    push de
    push hl
    call LoadCgbScreenPaletteFromSgbId
    pop hl
    pop de
    pop bc
    ret

DxApplyCgbPalettesFromDmgShadow_Preserve::
    push bc
    push de
    push hl
    call ApplyCgbPalettesFromDmgShadow
    pop hl
    pop de
    pop bc
    ret

DxLoadCgbStageTilePaletteAttrs_Preserve::
    push bc
    push de
    push hl
    call LoadCgbStageTilePaletteAttrs
    pop hl
    pop de
    pop bc
    ret




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

    ; Static/menu palette loads should not leave the gameplay attr sync active.
    ; Stage redraw explicitly reloads the active table before it queues BG columns.
    xor a
    ld [wCgbStageAttrActive], a

    ; DX override path:
    ;   wScreenPaletteId -> CGB palette set id
    ;   set id -> 16 palette IDs: BG0-7, OBJ0-7
    ; If there is no override entry, fall back to the original SGB PAL_SET
    ; mirror path below.
    call TryLoadCgbPaletteIdSetOverride
    jr c, .paletteIdsLoaded

    ; SGB compatibility fallback. Mirror the first four SGB PAL_SET palette IDs
    ; into BG0-3 and OBJ0-3, then repeat palette 0 into slots 4-7.
    ld a, [wScreenPaletteId]
    ld e, a
    add a
    ld b, a
    add a
    add b ; a = wScreenPaletteId * 6
    ld hl, CgbSgbScreenPaletteTable
    rst $38

    ld de, wCgbBgPaletteIds
    ld b, $04
.copySgbBgFirstFour
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .copySgbBgFirstFour

    ld a, [wCgbBgPaletteIds]
    ld b, $04
.fillSgbBgRest
    ld [de], a
    inc de
    dec b
    jr nz, .fillSgbBgRest

    ; OBJ palette IDs mirror BG palette IDs in fallback mode.
    ld hl, wCgbBgPaletteIds
    ld de, wCgbObjPaletteIds
    ld b, $08
.copySgbObjIds
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .copySgbObjIds

.paletteIdsLoaded
    call InitCgbObjTilePaletteMap_Default

    ; Normal state-palette loads only activate gameplay 8x8 tile attrs when
    ; hGameState already says gameplay. RedrawVisibleBgMapColumns also calls
    ; the same loader directly, because initial stage redraw can happen before
    ; this state-level palette load.
    ldh a, [hGameState]
    cp $02
    jr nz, .skipStageAttrLoad
    call LoadCgbStageTilePaletteAttrs
.skipStageAttrLoad
    call ApplyCgbPalettesFromDmgShadow
    jp LoadCgbBgAttrsForScreenFromSgbId


; Attempts to load a DX-specific 16-byte CGB palette ID set.
;
; Input:
;   wScreenPaletteId = screen/state palette selector
; Output:
;   carry set   = override was loaded into wCgbBgPaletteIds/wCgbObjPaletteIds
;   carry clear = no override; caller should fall back to SGB PAL_SET mirror
; Clobbers af, bc, de, hl.
TryLoadCgbPaletteIdSetOverride::
    ld a, [wScreenPaletteId]
    ld hl, CgbPaletteOverrideTable
    rst $38
    ld a, [hl]
    or a
    ret z

    ; Override IDs are 1-based so $00 can mean PASS.
    dec a
    ld l, a
    ld h, $00
    add hl, hl ; *2
    add hl, hl ; *4
    add hl, hl ; *8
    add hl, hl ; *16
    ld de, CgbPaletteIdSetTable
    add hl, de

    ld de, wCgbBgPaletteIds
    ld b, $10
.copySetLoop
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .copySetLoop

    scf
    ret


; Input:
;   a  = CGB palette ID, $00-$ff
;   de = destination, 8 bytes
; Clobbers af, b, de, hl.
CopyCgbPaletteIdToDE::
    push de                 ; save destination

    ld l, a
    ld h, $00
    add hl, hl              ; *2
    add hl, hl              ; *4
    add hl, hl              ; *8

    ld de, CgbPaletteIdTable
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

    ld hl, wCgbBgPaletteIds
    ld b, $08
.bgLoop
    push bc
    ld e, [hl]
    inc hl
    push hl
    ld a, [wPaletteBGP]
    call WriteCgbPaletteIdFromDmgByteToBCPD
    pop hl
    pop bc
    dec b
    jr nz, .bgLoop

    ; OBJ palette RAM index 0, auto-increment enabled.
    ld a, $80
    ldh [rOCPS], a

    ld hl, wCgbObjPaletteIds

    ; OBJ0 follows DMG OBP0.
    ld e, [hl]
    inc hl
    push hl
    ld a, [wPaletteOBP0]
    call WriteCgbPaletteIdFromDmgByteToOCPD
    pop hl

    ; OBJ1 follows DMG OBP1.
    ld e, [hl]
    inc hl
    push hl
    ld a, [wPaletteOBP1]
    call WriteCgbPaletteIdFromDmgByteToOCPD
    pop hl

    ; OBJ2/OBJ3 currently follow OBP1 to preserve the title-screen Shin/Shiro
    ; behavior from the proof-of-concept builds.
    ld b, $02
.objObp1Loop
    push bc
    ld e, [hl]
    inc hl
    push hl
    ld a, [wPaletteOBP1]
    call WriteCgbPaletteIdFromDmgByteToOCPD
    pop hl
    pop bc
    dec b
    jr nz, .objObp1Loop

    ; OBJ4-OBJ7 fall back to OBP0 until we add per-OBJ shade-byte control.
    ld b, $04
.objObp0Loop
    push bc
    ld e, [hl]
    inc hl
    push hl
    ld a, [wPaletteOBP0]
    call WriteCgbPaletteIdFromDmgByteToOCPD
    pop hl
    pop bc
    dec b
    jr nz, .objObp0Loop

    ret


WriteCgbPaletteIdFromDmgByteToBCPD::
    ld c, LOW(rBCPD)
    jr WriteCgbPaletteIdFromDmgByte

WriteCgbPaletteIdFromDmgByteToOCPD::
    ld c, LOW(rOCPD)

; Input:
;   a = DMG palette byte
;   e = CGB palette ID, $00-$ff
;   c = LOW(rBCPD) or LOW(rOCPD)
; Clobbers af, b, c, de, hl.
WriteCgbPaletteIdFromDmgByte::
    push af
    ld a, e
    ld l, a
    ld h, $00
    add hl, hl ; *2
    add hl, hl ; *4
    add hl, hl ; *8
    ld de, CgbPaletteIdTable
    add hl, de
    ld d, h
    ld e, l
    pop af

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

    ; Mirror the SGB PAL_SET attr-file selection instead of keying directly on
    ; wScreenPaletteId. Bank 3 stores six-byte records:
    ;   pal0, pal1, pal2, pal3, attr_file, extra
    ; The SGB sender sets bit 7 before putting attr_file in the PAL_SET packet,
    ; so CGB only cares about the low 7 bits here.
    ;
    ; Important: gameplay/stage BG attrs are owned by the streaming path.
    ; RedrawVisibleBgMapColumns may already have written VRAM bank 1 attrs
    ; before this state-level palette loader runs. Do not clear the BG attr map
    ; after wCgbStageAttrActive is set, or the freshly streamed stage attrs get
    ; wiped back to palette 0.
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
    jr z, .title

    ; No static attr file for this screen. If stage streaming is active, leave
    ; VRAM bank 1 alone; otherwise clear stale attrs for conservative fallback.
    ld a, [wCgbStageAttrActive]
    or a
    ret nz

    jp ClearCgbBgAttrMap

.title
    ; Static title screen owns VRAM bank 1. Disable stage ownership, clear the
    ; map, then load the explicit title attr map.
    xor a
    ld [wCgbStageAttrActive], a
    call ClearCgbBgAttrMap
    call InitCgbObjTilePaletteMap_Title
    jp LoadCgbTitleScreenAttrMap


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



; -----------------------------------------------------------------------------
; CGB palette override tables
; -----------------------------------------------------------------------------
; CgbPaletteOverrideTable is indexed by wScreenPaletteId.
;   $00 = PASS: use original SGB PAL_SET palette IDs
;   $01+ = CGB palette ID set number, stored in CgbPaletteIdSetTable
;
; A CGB palette ID set is 16 bytes:
;   BG0, BG1, BG2, BG3, BG4, BG5, BG6, BG7,
;   OBJ0,OBJ1,OBJ2,OBJ3,OBJ4,OBJ5,OBJ6,OBJ7
;

; -----------------------------------------------------------------------------
; LoadCgbStageTilePaletteAttrs
; -----------------------------------------------------------------------------
; Copies the current stage's 8x8 tile ID -> BG palette attribute table into WRAM.
; Runtime column streaming reads this active table instead of doing ROM pointer
; lookups in the hot path.
;
; Destination:
;   wCgbStageTilePaletteAttrs = $dc00, 256 bytes
;
 ; This routine is deliberately not gated on hGameState. The initial stage
; redraw path can run before the outer state-level palette load, so callers
; use this routine to force-load the active table and enable attr sync.
; -----------------------------------------------------------------------------
LoadCgbStageTilePaletteAttrs::
    ld a, [wCgbEnabled]
    or a
    ret z

    ld hl, CgbStageTilePaletteAttrPtrs
    ldh a, [hStageIndex]
    add a
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a

    ld de, wCgbStageTilePaletteAttrs
    ld b, $00 ; 256 bytes
.copyLoop
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, .copyLoop

    ld a, $ff
    ld [wCgbStageAttrActive], a
    ret


; -----------------------------------------------------------------------------
; Gameplay 8x8 tile ID -> BG palette attribute tables
; -----------------------------------------------------------------------------
; Phase14 POC data. Each table has 256 bytes:
;   index = 8x8 tile ID
;   value = CGB BG palette attribute (low 3 bits)
;
; These are intentionally dummy-safe ($00 everywhere) so gameplay visuals do not
; change until entries are edited. To test quickly, change selected 8x8 tile IDs
; to $01/$02/$03 and reassemble.
;

CgbStageTilePaletteAttrPtrs::
    dw CgbStage0TilePaletteAttrs
    dw CgbStage1TilePaletteAttrs
    dw CgbStage2TilePaletteAttrs
    dw CgbStage3TilePaletteAttrs
    dw CgbStage4TilePaletteAttrs
    dw CgbStage0TilePaletteAttrs
    dw CgbStage0TilePaletteAttrs
    dw CgbStage0TilePaletteAttrs

CgbStage0TilePaletteAttrs::
      ;$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;10
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$07	;20
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$07,$07,$07,$07,$00,$00	;30
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;40
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;50
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$00,$00	;60
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;70
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;80
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;90
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;A0
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;B0
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;C0
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;D0
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;E0
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;F0

CgbStage1TilePaletteAttrs::
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

CgbStage2TilePaletteAttrs::
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

CgbStage3TilePaletteAttrs::
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

CgbStage4TilePaletteAttrs::
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

CgbPaletteOverrideTable::
    db $00 ; $00: PASS
    db $01 ; $01: title uses explicit BG0-7/OBJ0-7 IDs
    db $00 ; $02: PASS
    db $00 ; $03: PASS
    db $00 ; $04: PASS
    db $00 ; $05: PASS
    db $00 ; $06: PASS
    db $00 ; $07: PASS
    db $00 ; $08: PASS
    db $00 ; $09: PASS
    db $00 ; $0a: PASS
    db $00 ; $0b: PASS
    db $00 ; $0c: PASS
    db $00 ; $0d: PASS
    db $00 ; $0e: PASS
    db $00 ; $0f: PASS
    db $00 ; $10: PASS
    db $00 ; $11: PASS
    db $00 ; $12: PASS
    db $00 ; $13: PASS
    db $00 ; $14: PASS
    db $00 ; $15: PASS
    db $00 ; $16: PASS
    db $00 ; $17: PASS
    db $00 ; $18: PASS
    db $00 ; $19: PASS
    db $1a ; $1a: Stage0
    db $1b ; $1b: Stage1
    db $1c ; $1c: Stage2
    db $1d ; $1d: Stage3
    db $00 ; $1e: PASS
    db $00 ; $1f: PASS/safety

CgbPaletteIdSetTable::
    ; Set $01: title screen.
    ; First four IDs match the SGB title PAL_SET ($04,$05,$06,$07).
    ; Slots 4-7 are explicit so the editor/debugger can use the full CGB range.
    db $04, $05, $06, $07, $04, $04, $04, $04 ; BG0-BG7
    db $04, $05, $06, $07, $04, $04, $04, $04 ; OBJ0-OBJ7

    ; Set $02: Stage0 / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $03: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $04: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $05: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $06: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $07: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $08: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $09: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $0a: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $0b: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $0c: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $0d: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $0e: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $0f: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $10: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $11: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $12: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $13: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $14: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $15: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $16: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $17: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $18: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $19: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $1a: Stage0
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $38, $38, $38, $38, $38, $38, $38, $3C ; BG0-BG7
    db $3D, $38, $38, $38, $38, $38, $38, $38 ; OBJ0-OBJ7

    ; Set $1b: Stage1
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $39, $39, $39, $39, $39, $39, $39, $39 ; BG0-BG7
    db $3D, $39, $39, $39, $39, $39, $39, $39 ; OBJ0-OBJ7

    ; Set $1c: Stage2
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $3a, $3a, $3a, $3a, $3a, $3a, $3a, $3a ; BG0-BG7
    db $3D, $3a, $3a, $3a, $3a, $3a, $3a, $3a ; OBJ0-OBJ7

    ; Set $1d: Stage3
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $3b, $3b, $3b, $3b, $3b, $3b, $3b, $3b ; BG0-BG7
    db $3D, $3b, $3b, $3b, $3b, $3b, $3b, $3b ; OBJ0-OBJ7

    ; Set $1e: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $1f: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7

    ; Set $20: DUMMY / reserved for future CGB palette override.
    ; Edit these 16 IDs as: BG0-BG7, then OBJ0-OBJ7.
    db $00, $01, $02, $03, $04, $05, $06, $07 ; BG0-BG7
    db $00, $01, $02, $03, $04, $05, $06, $07 ; OBJ0-OBJ7


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


CgbPaletteIdTable::
    ; RGB555 table keyed by unified CGB palette ID.
    ; $00-$3f currently mirror the dumped SGB palette IDs.
    ; $40-$ff are reserved for DX/CGB-only palettes and are initially dummy-filled.
    dw $679F, $161C, $0D13, $0000 ; $00
    dw $7FFF, $7FFF, $7FFF, $7FFF ; $01
    dw $7FFF, $3B3F, $7DA0, $0000 ; $02
    dw $7FFF, $5294, $294A, $0000 ; $03
    dw $7FFB, $7FFF, $7FFF, $7CC0 ; $04
    dw $7FFB, $3F3F, $6D24, $0000 ; $05
    dw $7FFB, $7FFF, $0252, $0000 ; $06
    dw $7FFB, $557F, $03FF, $1D4B ; $07
    dw $4BFF, $7D48, $0000, $0000 ; $08
    dw $4BFF, $3B3F, $2C7D, $0000 ; $09
    dw $4BFF, $3FF8, $285F, $0C20 ; $0A
    dw $4BFF, $0000, $0000, $0280 ; $0B
    dw $6B77, $43EA, $0DA7, $0000 ; $0C
    dw $6B77, $7FFF, $7DE3, $0000 ; $0D
    dw $6B77, $4AFF, $131F, $0000 ; $0E
    dw $6B77, $0A7F, $001F, $0000 ; $0F
    dw $7FFF, $03FF, $0233, $0000 ; $10
    dw $7FFF, $32FF, $2634, $0000 ; $11
    dw $7FFF, $67E7, $0000, $0000 ; $12
    dw $7FFF, $11BF, $0000, $0000 ; $13
    dw $7FFF, $021C, $001F, $0000 ; $14
    dw $7FFF, $32FF, $051E, $0000 ; $15
    dw $7FFF, $67E7, $0000, $0000 ; $16
    dw $7FFF, $11BF, $0000, $0000 ; $17
    dw $7FFF, $7E74, $7FFF, $0000 ; $18
    dw $7FFF, $3B3F, $0384, $0000 ; $19
    dw $7FFF, $3B3F, $091B, $0000 ; $1A
    dw $7FFF, $03FF, $091B, $0000 ; $1B
    dw $7FFF, $429F, $0000, $0000 ; $1C
    dw $7FFF, $3B3F, $03FF, $0000 ; $1D
    dw $7FFF, $3B3F, $7E02, $0000 ; $1E
    dw $7FFF, $3B3F, $091B, $0000 ; $1F
    dw $7FFF, $2F3F, $0000, $0000 ; $20
    dw $7FFF, $3B3F, $4666, $0000 ; $21
    dw $7FFF, $3B3F, $091B, $0000 ; $22
    dw $7FFF, $7FE3, $001F, $0000 ; $23
    dw $7FFF, $2FE9, $0000, $0000 ; $24
    dw $7FFF, $6BFF, $7EC2, $0000 ; $25
    dw $7FFF, $3B3F, $5A1F, $0000 ; $26
    dw $7FFF, $03FF, $001F, $0000 ; $27
    dw $3BFC, $53E0, $009F, $0000 ; $28
    dw $3BFC, $26DB, $6D24, $0000 ; $29
    dw $3BFC, $7FFF, $0252, $0000 ; $2A
    dw $3BFC, $0000, $0000, $007C ; $2B
    dw $77BD, $7AF1, $4D8A, $0000 ; $2C
    dw $77BD, $333F, $36D3, $0000 ; $2D
    dw $77BD, $7D6C, $0000, $0000 ; $2E
    dw $0000, $0000, $0000, $0000 ; $2F
    dw $7FFF, $2DBE, $0000, $0000 ; $30
    dw $7FFF, $3B3F, $1DD5, $0000 ; $31
    dw $7FFF, $518C, $44E7, $0000 ; $32
    dw $7FFF, $0000, $001F, $0000 ; $33
    dw $77BD, $5A5F, $0CFD, $0000 ; $34
    dw $63BC, $29FF, $3176, $0000 ; $35
    dw $77BD, $5F9F, $2539, $0000 ; $36
    dw $7FFF, $0000, $0000, $0000 ; $37
    dw $77BD, $3B5D, $0ECC, $0000 ; $38
    dw $77BD, $5790, $7E32, $0000 ; $39
    dw $77BD, $5ADD, $6E8E, $0000 ; $3A
    dw $77BD, $3B9C, $332C, $0000 ; $3B
    dw $77BD, $7EEE, $0000, $01C0 ; $3C
    dw $77BD, $3B3F, $037E, $0000 ; $3D
    dw $77BD, $0258, $0193, $0000 ; $3E
	dw $77BD, $7C00, $0000, $0000 ; $3F
