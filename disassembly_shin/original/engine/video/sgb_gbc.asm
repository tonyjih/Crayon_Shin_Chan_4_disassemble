; The longest stage layout ends at $d900 and the sound slots begin at $dd00.
; Use a 32-tile stride so GDMA can copy complete attribute rows to VRAM.
SECTION "CGB screen attributes", WRAMX[$dac0], BANK[1]
wCgbAttrs:: ds 32 * 18
ASSERT @ == wSoundSlots

; Camera work ends at $c465 and collision attributes begin at $c700.
SECTION "CGB background attributes", WRAM0[$c4c0]
wCgbBgAttrs:: ds 32 * 18
ASSERT @ == wStageTileAttrTable

SECTION "CGB color buffers", WRAMX[$de00], BANK[1]
wCgbBaseColors:: ds 4 * 8
wCgbMappedColors:: ds 12 * 8 ; Four palettes each for BGP, OBP0 and OBP1.
wCgbPacket:: ds 16
wCgbLastShades:: ds 3
wCgbColorsDirty:: ds 1
wCgbPalettePending:: ds 1
wCgbDirtyTop:: ds 1
wCgbDirtyBottom:: ds 1

DEF FARCALL_CGB_PACKET        EQU $0800
DEF FARCALL_CGB_FINISH_SCREEN EQU $0802
DEF FARCALL_CGB_PREPARE_FRAME EQU $0804
DEF FARCALL_CGB_UPLOAD_FRAME  EQU $0806

SECTION "SGB colors on CGB", ROMX[ROM_BANK_ID_ADDR], BANK[8]
    db BANK(@)
    dw CgbHandlePacket, CgbFinishScreen, CgbPrepareFrame, CgbUploadFrame

CgbHandlePacket:
    ld hl, wCgbPacket
    ld a, [hl+]
    cp $51 ; PAL_SET
    jp z, CgbSetPalettes
    cp $01 ; PAL01 (continue pulse)
    jp z, CgbSetContinueColors
    cp $39 ; ATTR_CHR (dialogue speaker)
    jp z, CgbSetSpeakerAttrs
    cp $21 ; ATTR_BLK (dialogue actor)
    jp z, CgbSetActorAttrs
    ret

CgbSetPalettes:
    ld de, wCgbBaseColors
.copyPalette
    ld a, [hl+]
    inc hl ; All palette IDs in this ROM fit in the low byte.
    push hl
    ld l, a
    ld h, 0
    REPT 3
        add hl, hl
    ENDR
    ld bc, SgbPaletteTransferSource
    add hl, bc
    ld bc, 8
    ld a, BANK(SgbPaletteTransferSource)
    call BankedMemcpy
    pop hl
    ld a, e
    cp LOW(wCgbBaseColors + 32)
    jr nz, .copyPalette
    ld a, [hl]
    push af
    call CgbShareBackdrop
    pop af
    bit 7, a
    ret z
    and $3f
    ld c, 90
    call MultiplyBCByA8bit
    ld bc, CgbAttributeFiles
    add hl, bc
    ld de, wCgbAttrs
.row
    ld b, 5
    call CgbUnpackAttrGroups
    ; The main ending scrolls horizontally behind its window. Extend the row color.
    REPT 12
        ld [de], a
        inc de
    ENDR
    ld a, d
    cp HIGH(wCgbAttrs + 32 * 18)
    jr nz, .row
    ret

CgbSetContinueColors:
    ld de, wCgbBaseColors
    ld b, 8
    call CopyBytesWithBCount
    inc de
    inc de
    ld b, 6
    call CopyBytesWithBCount

CgbShareBackdrop:
    ld hl, wCgbBaseColors
    ld a, [hl+]
    ld [wCgbBaseColors + 8], a
    ld [wCgbBaseColors + 16], a
    ld [wCgbBaseColors + 24], a
    ld a, [hl]
    ld [wCgbBaseColors + 9], a
    ld [wCgbBaseColors + 17], a
    ld [wCgbBaseColors + 25], a
    ld a, 1
    ld [wCgbColorsDirty], a
    ret

CgbSetSpeakerAttrs:
    ; The game's ATTR_CHR packets always write 16 tiles at (0, 10).
    ld hl, wCgbPacket + 6
    ld de, wCgbAttrs + 32 * 10
    ld b, 4
    call CgbUnpackAttrGroups
    ld bc, $0a0b
    jr CgbMarkAttrRows

CgbUnpackAttrGroups:
.group
    ld c, [hl]
    inc hl
    REPT 4
        rlc c
        rlc c
        ld a, c
        and 3
        ld [de], a
        inc de
    ENDR
    dec b
    jr nz, .group
    ret

CgbSetActorAttrs:
    ; Each actor packet has one rectangle with the same color inside and on the edge.
    ld hl, wCgbPacket + 4
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld b, a
    push bc
    call CgbAttrRowAddress
    ld a, e
    or l
    ld l, a
    ld a, [wCgbPacket + 6]
    sub e
    inc a
    ld c, a
    ld a, [wCgbPacket + 7]
    sub b
    inc a
    ld b, a
    ld a, [wCgbPacket + 3]
    and 3
.row
    push hl
    push bc
.tile
    ld [hl+], a
    dec c
    jr nz, .tile
    pop bc
    pop hl
    ld de, 32
    add hl, de
    dec b
    jr nz, .row
    pop bc
    ld a, [wCgbPacket + 7]
    inc a
    ld c, a

CgbMarkAttrRows:
    ld a, [wCgbDirtyTop]
    cp b
    jr c, .keepTop
    ld a, b
    ld [wCgbDirtyTop], a
.keepTop
    ld a, [wCgbDirtyBottom]
    cp c
    ret nc
    ld a, c
    ld [wCgbDirtyBottom], a
    ret

CgbAttrRowAddress:
    ; HL = wCgbAttrs + A * 32. The rotation separates the page and row offsets.
    add LOW(wCgbAttrs) / 32
    swap a
    rlca
    ld l, a
    and 3
    add HIGH(wCgbAttrs)
    ld h, a
    ld a, l
    and $e0
    ld l, a
    ret

CgbFinishScreen:
    call CgbPrepareBgAttrs
    ld hl, wCgbBgAttrs
    ld de, _SCRN0
    ld b, 18
    call CgbCopyAttrRows
    ld a, [wLCDCShadow]
    bit 5, a
    jr z, .palette
    ; Every window in this game starts at X=0 and on an 8-pixel Y boundary.
    ldh a, [hWY]
    REPT 3
        srl a
    ENDR
    cp 18
    jr nc, .palette
    ld b, a
    call CgbAttrRowAddress
    ld de, wCgbBgAttrs - wCgbAttrs
    add hl, de
    ld a, 18
    sub b
    ld b, a
    ld de, _SCRN1
    call CgbCopyAttrRows
.palette
    call CgbClearDirtyRows
    call CgbPreparePalettes
    jp CgbUploadPalettes

CgbPrepareFrame:
    call CgbPreparePalettes
    ld a, [wCgbDirtyBottom]
    or a
    call nz, CgbPrepareBgAttrs
    ld de, wOamBuffer
.sprite
    ldh a, [hOamWritePos]
    cp e
    ret z
    ld a, [de]
    sub 12 ; Center of an 8x8 OBJ in screen coordinates.
    jr nc, .checkY
    xor a
.checkY
    cp 144
    jr c, .row
    ld a, 143
.row
    REPT 3
        srl a
    ENDR
    call CgbAttrRowAddress
    inc e
    ld a, [de]
    sub 4
    jr nc, .checkX
    xor a
.checkX
    cp 160
    jr c, .column
    ld a, 159
.column
    REPT 3
        srl a
    ENDR
    or l
    ld l, a
    ; The password cheek tile is opaque only in the next SGB column.
    ld a, l
    cp LOW(wCgbAttrs + 2 * 32 + 15)
    jr nz, .spritePalette
    ld a, h
    cp HIGH(wCgbAttrs + 2 * 32 + 15)
    jr nz, .spritePalette
    ld a, [wScreenPaletteId]
    cp $02
    jr nz, .spritePalette
    inc hl
.spritePalette
    inc e
    inc e
    ld a, [de]
    ld b, a
    and $10
    rrca
    rrca
    or [hl]
    ld c, a
    ld a, b
    and $f0
    or c
    ld [de], a
    inc e
    jr .sprite

CgbPrepareBgAttrs:
    ; Keep the SGB regions for OBJ colors and adjust the BG separately.
    ld hl, wCgbAttrs
    ld de, wCgbBgAttrs
    ld bc, 32 * 18
    call memcpy
    ld a, [wScreenPaletteId]
    cp $14
    jr z, .instructions
    ldh a, [hGameState]
    cp $04
    ret nz
    ld a, [wScreenSubstate]
    and a
    jr z, .stageIntro
    cp $03
    ret nz
    ld hl, wCgbBgAttrs + 32 * 11
    ld bc, 32 * 7
    jp bzero
.stageIntro
    ; The pattern repeats every six columns. Extend it across the SGB actor region.
    ld hl, wCgbBgAttrs + 32 * 11
.stageIntroRow
    ld d, h
    ld a, l
    add 12
    ld e, a
    ld b, 8
    call CopyBytesWithBCount
    ld bc, 32 - 8
    add hl, bc
    ld a, h
    cp HIGH(wCgbBgAttrs + 32 * 18)
    jr nz, .stageIntroRow
    ret
.instructions
    ; Instructions and ending hints share the actor at the lower left of the box.
    ld hl, wCgbBgAttrs + 32 * 13
    ld de, 32 - 3
    ld b, 3
    xor a
.row
    REPT 3
        ld [hl+], a
    ENDR
    add hl, de
    dec b
    jr nz, .row
    ret

CgbPreparePalettes:
    ld a, [wCgbColorsDirty]
    or a
    jr nz, .refresh
    ld hl, wPaletteBGP
    ld de, wCgbLastShades
    ld b, 3
.compare
    ld a, [de]
    cp [hl]
    jr nz, .refresh
    inc de
    inc hl
    dec b
    jr nz, .compare
    ret
.refresh
    xor a
    ld [wCgbColorsDirty], a
    inc a
    ld [wCgbPalettePending], a
    ld hl, wPaletteBGP
    ld de, wCgbLastShades
    ld b, 3
    call CopyBytesWithBCount
    ld de, wCgbMappedColors
    ld a, [wPaletteBGP]
    call CgbRemapFourPalettes
    ld a, [wPaletteOBP0]
    call CgbRemapFourPalettes
    ld a, [wPaletteOBP1]

CgbRemapFourPalettes:
    ld c, a
    ld hl, wCgbBaseColors
    ld b, 4
.palette
    push bc
    ld b, 4
.color
    ld a, c
    and 3
    add a
    or l
    ld l, a
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    inc de
    ld a, l
    and $f8
    ld l, a
    rrc c
    rrc c
    dec b
    jr nz, .color
    ld a, l
    add 8
    ld l, a
    pop bc
    dec b
    jr nz, .palette
    ret

CgbUploadFrame:
    call CgbUploadPalettes
    ld a, [wCgbDirtyBottom]
    or a
    ret z
    ld b, a
    ld a, [wCgbDirtyTop]
    call CgbAttrRowAddress
    ld a, [wCgbDirtyTop]
    ld c, a
    ld a, b
    sub c
    ld b, a
    ld de, wCgbBgAttrs - wCgbAttrs
    add hl, de
    push hl
    ld de, _SCRN0 - wCgbBgAttrs
    add hl, de
    ld d, h
    ld e, l
    pop hl
    call CgbCopyAttrRows

CgbClearDirtyRows:
    xor a
    ld [wCgbDirtyBottom], a
    ld a, 18
    ld [wCgbDirtyTop], a
    ret

CgbCopyAttrRows:
    ; HL = WRAM source, DE = VRAM destination, B = number of 32-byte rows.
    ld a, 1
    ldh [rVBK], a
    ld a, h
    ldh [rHDMA1], a
    ld a, l
    ldh [rHDMA2], a
    ld a, d
    ldh [rHDMA3], a
    ld a, e
    ldh [rHDMA4], a
    ld a, b
    add a
    dec a
    ldh [rHDMA5], a
    xor a
    ldh [rVBK], a
    ret

CgbUploadPalettes:
    ld a, [wCgbPalettePending]
    or a
    ret z
    xor a
    ld [wCgbPalettePending], a
    ld hl, wCgbMappedColors
    ld a, $80
    ldh [rBCPS], a
    ldh [rOCPS], a
    ld c, LOW(rBCPD)
    REPT 32
        ld a, [hl+]
        ldh [c], a
    ENDR
    ld c, LOW(rOCPD)
    REPT 64
        ld a, [hl+]
        ldh [c], a
    ENDR
    ret

CgbAttributeFiles:
    ; First 17 ATTR_TRN files, each with 20x18 packed two-bit palette indices.
IF DEF(ZH_TW)
    INCBIN "zh_sgb_attrs.bin", 0, 17 * 90

ZhSgbAttributeFilesRle::
    INCBIN "zh_sgb_attrs.rle"
ELSE
    INCBIN "sgb/border_tilemap.bin", 0, 17 * 90
ENDC
