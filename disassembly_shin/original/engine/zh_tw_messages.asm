; Each line contains two tilemap rows, their new tile bitmaps, and optional glyph updates.
SECTION "Traditional Chinese message work", WRAM0[$c466]
wZhTextBank: ds 1
wZhWidth: ds 1
wZhDisplayAddress: ds 2
wZhRowFlags: ds 1
wZhRevealPointer: ds 2
wZhRevealStep: ds 8
wZhMap: ds 40
ASSERT @ <= $c4c0

DEF FARCALL_ZH_INIT EQU $0900
DEF FARCALL_ZH_UPDATE EQU $0902
DEF FARCALL_ZH_PASSWORD EQU $0904
DEF FARCALL_ZH_PASSWORD_MAP EQU $0906
DEF FARCALL_ZH_TITLE EQU $0908
DEF FARCALL_ZH_BONUS EQU $090a

SECTION "Traditional Chinese text engine", ROMX[ROM_BANK_ID_ADDR], BANK[9]
    db BANK(@)
    dw ZhStartMessage, ZhUpdateMessage, ZhInitPassword, ZhInitPasswordMap, ZhInitTitle, ZhInitBonus

ZhStartMessage:
    ldh a, [hTileStreamWritePos]
    ld hl, ZhMessagePointers
    rst $20
    ld bc, ZhMessageDescriptors
    add hl, bc
    ld de, wMessageDestLo
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    ld a, [hl+]
    and a
    jr z, .entry
    ld a, [wMsgSubstitutionId]
    cp 14
    jr c, .valid
    xor a
.valid
    ld b, a
    add a
    add b
    rst $38
.entry
    ld a, [hl+]
    ld [wZhTextBank], a
    ld a, [hl+]
    ld [wMessageSourceLo], a
    ld a, [hl]
    ld [wMessageSourceHi], a
    xor a
    ld [wZhWidth], a
    ld [wMessageLineGlyphs], a
    ld [wMessagePrintedGlyphs], a
    inc a
    ld [wMessageState], a
    ld [wMessageCharDelay], a
    ld a, [wMessageFlags]
    bit 1, a
    ret z
.blocking
    call ZhUpdateMessage
    ld a, [wMessageState]
    and a
    jr nz, .blocking
    ret

ZhUpdateMessage:
    ld a, [wMessageState]
    and a
    ret z
    ld a, [wMessageFlags]
    bit 0, a
    jr z, .load
    bit 1, a
    jr nz, .load
    ld hl, wMessageCharDelay
    dec [hl]
    ret nz
    ld a, [wMessageCharPeriod]
    ld [hl], a
    ld a, [wMessagePrintedGlyphs]
    ld b, a
    ld a, [wMessageLineGlyphs]
    cp b
    jp nz, ZhPrintGlyph
.load
    ld a, [wMessageDestLo]
    ld [wZhDisplayAddress], a
    ld a, [wMessageDestHi]
    ld [wZhDisplayAddress + 1], a
    ld a, [wZhTextBank]
    ld h, a
    ld l, 0
    call FarCallFromBankTable
    ld a, [wMessageState]
    and a
    ret z
    ld hl, wMessageDestLo
    ld a, [hl]
    add $40
    ld [hl+], a
    jr nc, .advanced
    ld a, [hl]
    inc a
    ; Both maps are 1 KiB. Preserve the map selection when scrolling wraps.
    xor [hl]
    and $03
    xor [hl]
    ld [hl], a
.advanced
    xor a
    ld [wMessagePrintedGlyphs], a
    ld a, [wZhWidth]
    and a
    ret z
    ld a, [wMessageFlags]
    and 3
    cp 1
    ret z
    jr ZhPrintLine

ZhBottomAddress:
    ld hl, wZhDisplayAddress
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ret

ZhTopAddress:
    call ZhBottomAddress
    ld a, h
    ld bc, -32
    add hl, bc
    xor h
    and $fc
    xor h
    ld h, a
    ret

ZhPrintGlyph:
    ld a, [wMessageFlags]
    bit 3, a
    jr nz, .quiet
    ld a, $41
    call PlaySound
.quiet
    ld hl, wZhRevealPointer
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, wZhRevealStep
    ld bc, 8
    ld a, [wZhTextBank]
    call BankedMemcpy
    ld a, l
    ld [wZhRevealPointer], a
    ld a, h
    ld [wZhRevealPointer + 1], a
    call ZhTopAddress
    ld a, [wZhRevealStep]
    rst $38
    ; Upload both halves of the complete glyph in the same VBlank.
    ld de, wZhRevealStep + 2
    ld a, [wZhRevealStep + 1]
    ld b, a
    ld c, 2
    call QueueTilemapRect
    ld hl, wMessagePrintedGlyphs
    inc [hl]
    ret

ZhPrintLine:
    call ZhTopAddress
    ld de, wZhMap
    call ZhPrintRow
    ld hl, wZhMap
    ld a, [wZhWidth]
    rst $38
    ld d, h
    ld e, l
    call ZhBottomAddress
    ; Fall through for the second row.

ZhPrintRow:
    ld a, [wZhWidth]
    ld b, a
    ld a, [wMessageFlags]
    bit 1, a
    jr nz, .direct
    ld c, 1
    jp QueueTilemapRect
.direct
    ld a, [de]
    inc de
    ld c, a
.wait
    ldh a, [rSTAT]
    and 2
    jr nz, .wait
    ld a, c
    ld [hl+], a
    dec b
    jr nz, .direct
    ret

ZhInitPassword:
    ; Reload the kana after the title menu reused the font tiles.
    ld hl, GfxRle_b06_4bc0
    ld a, BANK(GfxRle_b06_4bc0)
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    ld a, BANK(Gfx_b06_50c4)
    ld hl, Gfx_b06_50c4
    ld de, _VRAM + $900
    ld bc, $0260
    call BankedMemcpy
    ld hl, ZhPasswordTiles
    ld de, _VRAM + $1460
    ld bc, ZhPasswordTilesEnd - ZhPasswordTiles
    jp memcpy

ZhInitPasswordMap:
    ld de, wStageLayoutMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    ld de, ZhPasswordHeader
    ld hl, _SCRN0 + $004
    ld bc, $0a02
    jp CopyTilemapRectToVram

ZhInitTitle:
    ld hl, ZhTitleTiles
    ld de, _VRAM + $1500
    ld bc, ZhTitleTilesEnd - ZhTitleTiles
    call memcpy
    ld de, ZhTitleMap
    ld hl, _SCRN0
    ld bc, $1412
    call CopyTilemapRectToVram
    call IsCgbColorMode
    jr z, .cgb
    ; These signed BG slots are free on the title screen, including while menus are open.
    ld hl, ZhTitleGbLogoTiles
    ld de, _VRAM + $0900
    ld bc, $30 * 16
    call memcpy
    ld de, _VRAM + $0ec0
    ld bc, $14 * 16
    call memcpy
    ld de, _VRAM + $1670
    ld bc, $19 * 16
    jp memcpy
.cgb
    ld a, 1
    ldh [rVBK], a
    ld hl, ZhTitleCgbLogoTiles
    ld de, _VRAM + $1000
    ld bc, 20 * 5 * 16
    call memcpy
    ld hl, ZhTitleCgbObjTiles
    ld de, _VRAM
    ld bc, ZhTitleCgbObjTilesEnd - ZhTitleCgbObjTiles
    call memcpy
    xor a
    ldh [rVBK], a
    ld de, ZhTitleCgbMap
    ld hl, _SCRN0
    ld bc, $1405
    jp CopyTilemapRectToVram

ZhInitBonus:
    ld hl, ZhBonusTiles
    ld de, _VRAM + $1100
    ld bc, ZhBonusTilesEnd - ZhBonusTiles
    call memcpy
    ld de, ZhBonusMap
    ld hl, _SCRN0
    ld bc, $1412
    jp CopyTilemapRectToVram

ZhPasswordHeader:
    INCBIN "zh_password.tilemap", 0, PASSWORD_CODE_SIZE
ZhPasswordTiles:
    INCBIN "zh_password.2bpp"
ZhPasswordTilesEnd:
ZhTitleTiles:
    INCBIN "zh_title.2bpp"
ZhTitleTilesEnd:
ZhTitleGbLogoTiles:
    INCBIN "zh_title_logo_gb.2bpp"
ZhTitleCgbLogoTiles:
    INCBIN "zh_title_logo_cgb.2bpp"
ZhTitleCgbObjTiles:
    INCBIN "zh_title_logo_obj.2bpp"
ZhTitleCgbObjTilesEnd:
ZhTitleCgbMap:
    FOR Tile, 20 * 5
        db Tile
    ENDR
ZhTitleMap:
    INCBIN "zh_title.tilemap"
ZhBonusTiles:
    INCBIN "zh_bonus.2bpp"
ZhBonusTilesEnd:
ZhBonusMap:
    INCBIN "zh_bonus.tilemap"

ZhMessagePointers:
    INCBIN "zh_descriptors.bin", 0, $6b * 2
ZhMessageDescriptors:
    INCBIN "zh_descriptors.bin", $6b * 2

MACRO zh_text_bank
SECTION "Traditional Chinese rows \1", ROMX[ROM_BANK_ID_ADDR], BANK[\1]
    db BANK(@)
    dw ZhReadLine_\1
ZhReadLine_\1:
    ld hl, wMessageSourceLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    cp $ff
    jr nz, .read
    xor a
    ld [wMessageState], a
    ret
.read
    ld b, a
    bit 7, b
    jr z, .noControl
    push hl
    ld hl, wMessageControlPtrLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [wMessageControlValue]
    ld [hl], a
    pop hl
.noControl
    ld a, b
    and $60
    ld [wZhRowFlags], a
    xor a
    ld [wMessageLineGlyphs], a
    ld a, b
    and $1f
    ld [wZhWidth], a
    add a
    ld b, a
    and a
    jr z, .tiles
    ld a, [wMessageFlags]
    bit 2, a
    ld de, wZhMap
    jr z, .copyMap
    ld a, [wZhRowFlags]
    cp $40
    ld a, 0
    jr nz, .clearMap
    ld a, 1
.clearMap
    ld [de], a
    inc de
    inc hl
    dec b
    jr nz, .clearMap
    jr .tiles
.copyMap
    call CopyBytesWithBCount
.tiles
    ld a, [hl+]
    ld b, a
    and a
    jr z, .done
.tile
    push bc
    ld a, [hl+]
    ld d, a
    swap a
    and $f0
    ld e, a
    ld a, d
    swap a
    and $0f
    xor $08
    add $88
    ld d, a
    ld b, 8
.row
    ld a, [hl+]
    ld c, a
.wait
    ldh a, [rSTAT]
    and 2
    jr nz, .wait
    ld a, [wZhRowFlags]
    cp $40
    ld a, c
    jr nz, .ink
    ld a, $ff
.ink
    ld [de], a
    inc e
    ld a, c
    ld [de], a
    inc e
    dec b
    jr nz, .row
    pop bc
    dec b
    jr nz, .tile
.done
    ld a, [wZhRowFlags]
    bit 5, a
    jr z, .nextLine
    ld a, [hl+]
    ld [wMessageLineGlyphs], a
    add a
    add a
    add a
    ld c, a
    ; Credits have a second set of glyph updates for erasing left to right.
    ld a, [wZhRowFlags]
    bit 6, a
    jr z, .setPointer
    ld a, [wMessageFlags]
    bit 2, a
    ld a, c
    jr nz, .useErase
    add a
    ld c, a
    jr .setPointer
.useErase
    rst $38
.setPointer
    ld a, l
    ld [wZhRevealPointer], a
    ld a, h
    ld [wZhRevealPointer + 1], a
    ld a, c
    rst $38
.nextLine
    ld a, l
    ld [wMessageSourceLo], a
    ld a, h
    ld [wMessageSourceHi], a
    ret
    ; The generated descriptors address each bank's data from $4100.
    ds $4100 - @, $ff
ZhData_\1:
    INCBIN "zh_data_\1.bin"
ENDM

    zh_text_bank 10
    zh_text_bank 11
    zh_text_bank 12
    zh_text_bank 13
    zh_text_bank 14
    zh_text_bank 15
