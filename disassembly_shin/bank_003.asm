; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

; Text encoding notes (partial, verified from password screen and bank 3 messages):
;   $fe = line break / message row separator, $ff = terminator, $fd = dynamic value.
;   $fc = message control code handled by HandleMessageControlFC.
;   $43 + kana = handakuten, $45 + kana = dakuten.
;   $44 = Japanese fullwidth dot-like punctuation, $7d = ！, $7e = ー, $7f = ？.
;   $06/$07/$08 = fullwidth ２/３/４ in message text.
;   $0f = D-pad icon, $40 = A-button icon, $7b = B-button icon in tutorial text.


    db $03, $8d, $41, $ee, $41, $19, $4e, $99, $43, $a2, $43

    dec b
    ld b, [hl]
    add hl, bc
    ld b, h

rle_b03_400f_to_8900::
    db $2e, $00, $00, $25, $38, $25, $38, $25, $38, $22, $3c, $00, $22, $3c, $2b, $34
    db $2b, $34, $23, $3c, $00, $34, $0c, $34, $0c, $24, $1c, $2c, $14, $00, $2c, $14
    db $24, $1c, $04, $1c, $14, $0c, $00, $34, $0d, $35, $0e, $23, $18, $26, $19, $00
    db $22, $1d, $20, $1f, $17, $0f, $1e, $0e, $20, $00, $ff, $00, $22, $40, $9f, $40
    db $05, $07, $ff, $78, $f8, $80, $00, $a0, $ff, $00, $02, $00, $ff, $00, $5f, $ff
    db $00, $a0, $f8, $06, $0f, $01, $fe, $06, $5f, $f8, $00, $40, $7f, $00, $80, $7f
    db $80, $77, $88, $00, $66, $99, $55, $aa, $11, $cc, $62, $80, $50, $ff, $00, $ff
    db $00, $77, $88, $00, $66, $99, $55, $aa, $11, $cc, $22, $00, $40, $fe, $00, $01
    db $fe, $01, $76, $89, $00, $66, $99, $54, $ab, $12, $cd, $22, $01, $00, $44, $80
    db $48, $80, $55, $80, $62, $80, $00, $44, $80, $48, $80, $55, $80, $62, $80, $00
    db $44, $00, $88, $00, $55, $00, $22, $00, $00, $44, $00, $88, $00, $55, $00, $22
    db $00, $00, $46, $01, $8a, $01, $56, $01, $22, $01, $00, $46, $01, $8a, $01, $56
    db $01, $22, $01, $08, $ff, $7f, $ff, $80, $ff, $88, $ff, $00, $99, $ff, $aa, $ff
    db $dd, $ee, $b7, $c8, $68, $ff, $00, $ff, $88, $ff, $00, $99, $ff, $aa, $ff, $dd
    db $ee, $77, $88, $08, $ff, $fe, $ff, $01, $ff, $81, $ff, $00, $91, $ff, $b9, $ff
    db $e1, $ff, $c1, $7f, $00, $ae, $d1, $9d, $e2, $aa, $d5, $b7, $c8, $00, $ae, $d1
    db $9d, $e2, $aa, $d5, $b7, $c8, $00, $ee, $11, $dd, $22, $aa, $55, $77, $88, $00
    db $ee, $11, $dd, $22, $aa, $55, $77, $88, $00, $ed, $13, $dd, $23, $a9, $57, $75
    db $8b, $00, $ed, $13, $dd, $23, $a9, $57, $75, $8b, $00, $ae, $d1, $9d, $e2, $aa
    db $d5, $b7, $c8, $02, $ae, $d1, $9d, $e2, $80, $ff, $7f, $00, $ee, $11, $dd, $22
    db $aa, $55, $77, $88, $03, $ee, $11, $dd, $22, $00, $ff, $00, $f9, $7f, $c1, $7f
    db $a1, $7f, $51, $bf, $00, $f9, $7f, $c1, $7f, $a1, $7f, $51, $bf, $00, $f9, $7e
    db $c0, $7f, $a0, $7f, $58, $bf, $00, $e9, $1f, $da, $2f, $ad, $5e, $77, $88, $68
    db $ff, $01, $ff, $89, $ff, $00, $99, $ff, $aa, $ff, $dd, $ee, $77, $88

    ldh a, [hTileStreamWritePos]
    add a
    push af
    ld hl, $5f2f
    rst $20
    ld a, $01
    ld [$d96d], a
    ld a, l
    ld [$d96b], a
    ld a, h
    ld [$d96c], a
    pop af
    inc a
    ld hl, $5f2f
    rst $20
    ld a, l
    ld [$d969], a
    ld a, h
    ld [$d96a], a
    ld a, [$d970]
    and $f0
    jr nz, jr_003_41c3

    ld a, $45
    ld [$d96e], a
    ld a, $43
    ld [$d96f], a
    jr jr_003_41cf

jr_003_41c3::
    or $0a
    ld [$d96e], a
    and $f0
    or $0b
    ld [$d96f], a

jr_003_41cf::
    xor a
    ld [$d97f], a
    ld [$d980], a
    ld a, $01
    ld [$d982], a
    ld a, [$d970]
    bit 1, a
    ret z

jr_003_41e1::
    call Call_000_0719
    ld a, [$d96d]
    or a
    jr nz, jr_003_41e1

    xor a
    ldh a, [hVramQueuePos]
    ret


    xor a
    ldh [$ffcc], a
    ld a, [$d96d]
    or a
    ret z

    ld a, [$d970]
    ld c, a
    bit 0, c
    jr z, jr_003_425f

    ld a, [$d982]
    dec a
    ld [$d982], a
    or a
    ret nz

    bit 3, c
    jr nz, jr_003_4210

    ld a, $41
    call PlaySound

jr_003_4210::
    ld a, [$d981]
    ld [$d982], a
    ld a, [$d97f]
    ld b, a
    ld a, [$d980]
    cp b
    jr z, jr_003_425f

    ld de, $c820
    ld a, [$d97f]
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld hl, $d96b
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$d97f]
    rst $38
    ld bc, $ffc0
    add hl, bc
    ld a, [de]
    push hl
    call QueueTilemapByte
    pop hl
    ld de, wStageLayoutMap
    ld a, [$d97f]
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, [$d97f]
    inc a
    ld [$d97f], a
    ld a, [de]
    cp $ff
    ret z

    ld bc, $ffe0
    add hl, bc
    call QueueTilemapByte
    ret


jr_003_425f::
    ld a, [$d96d]
    cp $02
    jr nz, jr_003_426b

    xor a
    ld [$d96d], a
    ret


jr_003_426b::
    ld hl, $d96b
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    bit 0, c
    jr z, jr_003_4278

    ld hl, $c820

jr_003_4278::
    ld de, $ffe0
    add hl, de
    ld a, [$d969]
    ld e, a
    ld a, [$d96a]
    ld d, a
    ld b, $00

jr_003_4286::
    call ReadMessageTileWithControlCodes
    cp $ff
    jr z, jr_003_42c2

    cp $fe
    jr z, jr_003_42c2

    inc de
    cp $45
    jr z, jr_003_42a5

    cp $43
    jr z, jr_003_42aa

    bit 0, c
    jr z, jr_003_42a1

    ld a, $ff
    ld [hl], a

jr_003_42a1::
    inc b
    inc hl
    jr jr_003_4286

jr_003_42a5::
    ld a, [$d96e]
    jr jr_003_42ad

jr_003_42aa::
    ld a, [$d96f]

jr_003_42ad::
    bit 1, c
    jr z, jr_003_42b4

    ld [hl], a
    jr jr_003_4286

jr_003_42b4::
    bit 2, c
    jr z, jr_003_42b9

    xor a

jr_003_42b9::
    push hl
    push bc
    call QueueTilemapByte
    pop bc
    pop hl
    jr jr_003_4286

jr_003_42c2::
    xor a
    ld [$d97f], a
    ld a, b
    ld [$d980], a
    bit 0, c
    jr nz, jr_003_42da

    bit 1, c
    jr z, jr_003_42df

    ld hl, $d96b
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jr jr_003_42f4

jr_003_42da::
    ld hl, $c820
    jr jr_003_42f4

jr_003_42df::
    call GetVramQueueTail
    ld a, [$d96c]
    ld [hl+], a
    ld a, [$d96b]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    add $03
    ld b, a
    ldh a, [hVramQueuePos]
    add b
    ldh [hVramQueuePos], a

jr_003_42f4::
    ld a, [$d969]
    ld e, a
    ld a, [$d96a]
    ld d, a

jr_003_42fc::
    call ReadMessageTileWithControlCodes
    inc de
    cp $ff
    jr z, jr_003_4318

    cp $fe
    jr z, jr_003_431d

    cp $45
    jr z, jr_003_42fc

    cp $43
    jr z, jr_003_42fc

    bit 2, c
    jr z, jr_003_4315

    xor a

jr_003_4315::
    ld [hl+], a
    jr jr_003_42fc

jr_003_4318::
    ld a, $02
    ld [$d96d], a

jr_003_431d::
    ld a, $45
    ld [$d96e], a
    ld a, $43
    ld [$d96f], a
    ld a, e
    ld [$d969], a
    ld a, d
    ld [$d96a], a
    ld a, [$d970]
    bit 1, a
    jr nz, jr_003_4338

    ld [hl], $00

jr_003_4338::
    ld hl, $d96b
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $0040
    ld a, h
    add hl, bc
    and $fc
    ld b, a
    ld a, h
    and $fc
    cp b
    jr z, jr_003_4350

    ld bc, $fc00
    add hl, bc

jr_003_4350::
    ld a, l
    ld [$d96b], a
    ld a, h
    ld [$d96c], a
    ret


ReadMessageTileWithControlCodes::
    ld a, [de]
    cp $ff
    jr z, ReadMessageByte_HandleTerminatorOrResume

    cp $fc
    call z, HandleMessageControlFC
    cp $fd
    ret nz

    ld a, e
    ldh [hTileStreamCount], a
    ld a, d
    ldh [$ffcc], a
    push hl
    ld a, [$d971]
    ld hl, MessageDynamicCharTable_60db
    rst $20
    ld d, h
    ld e, l
    ld a, [de]
    pop hl
    ret


ReadMessageByte_HandleTerminatorOrResume::
    ldh a, [$ffcc]
    or a
    ld a, [de]
    ret z

    ldh a, [hTileStreamCount]
    ld e, a
    ldh a, [$ffcc]
    ld d, a
    xor a
    ldh [$ffcc], a
    inc de
    ld a, [de]
    ret

HandleMessageControlFC::
    push hl
    ld hl, $d972
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$d974]
    ld [hl], a
    pop hl
    inc de
    ld a, [de]
    ret

DrawBank3MetaspriteById::
    ld a, d
    ld hl, Bank3MetaspritePtrTable_4e19
    rst $20
    call jr_000_026c
    ret


    ld a, [wSgbEnabled]
    or a
    ret z

    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld de, $d985
    ld a, $51
    ld [de], a
    inc de
    ld a, [wScreenPaletteId]
    add a
    ld b, a
    add a
    add b
    ld hl, SgbScreenPaletteTable_4d5f
    rst $38
    ld b, $04

jr_003_43c2::
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    dec b
    jr nz, jr_003_43c2

    ld a, [hl+]
    ld b, a
    or a
    jr z, jr_003_43db

    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a

jr_003_43db::
    ld a, b
    set 7, a
    ld [de], a
    inc de
    ld b, $06
    xor a

jr_003_43e3::
    ld [de], a
    inc de
    dec b
    jr nz, jr_003_43e3

    call DelayFramesOrCycles
    ld hl, $d985
    call SendSgbPacket
    call DelayFramesOrCycles
    ld a, [wScreenPaletteId]
    cp $18
    jr z, jr_003_43fe

    cp $14
    ret nz

jr_003_43fe::
    xor a
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ret


    ld b, $00
    ld a, [$dffe]
    or a
    jr z, jr_003_4413

    ld b, $01

jr_003_4413::
    ld a, [$dffd]
    or a
    jr z, jr_003_441b

    ld b, $02

jr_003_441b::
    ld a, [$dffc]
    cp b
    ret z

    ld a, b
    ld [$dffc], a

Call_003_4424::
    ld de, wStageLayoutMap
    ld b, $03
    ld c, $01

jr_003_442b::
    ld hl, $450a
    ld a, [$dffc]
    swap a
    and $f0
    rst $38
    ld a, c
    dec a
    push de
    rst $20
    ld a, b
    rst $38
    pop de

jr_003_443d::
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, $10
    ld [de], a
    inc de
    ld a, [hl]
    cp $ff
    jr nz, jr_003_4459

    push de
    ld de, $fff9
    ld a, [$dffc]
    cp $02
    jr nz, jr_003_4457

    ld de, $fff8

jr_003_4457::
    add hl, de
    pop de

jr_003_4459::
    ld a, e
    and $3f
    jr nz, jr_003_443d

    dec c
    jr nz, jr_003_447b

    ld c, $07
    push de
    ld d, $07
    ld a, [$dffc]
    cp $02
    ld a, b
    jr nz, jr_003_4472

    ld d, $08
    add $02

jr_003_4472::
    add $04
    ld b, a
    cp d
    jr c, jr_003_447a

    sub d
    ld b, a

jr_003_447a::
    pop de

jr_003_447b::
    ld a, d
    cp $d0
    jr nz, jr_003_442b

    ld hl, _RAMBANK
    ld bc, $0080
    call bzero
    ld a, [$dffc]
    add a
    add a
    ld hl, $45e9
    rst $38
    ld de, $d004
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    ld hl, $c94c
    ld b, $12
    ld de, $0018
    xor a

jr_003_44a9::
    ld c, $14

jr_003_44ab::
    ld [hl+], a
    inc hl
    dec c
    jr nz, jr_003_44ab

    add hl, de
    dec b
    jr nz, jr_003_44a9

    ld de, $c90c
    ld hl, $cdcc
    ld b, $14

jr_003_44bc::
    ld a, $1d
    ld [hl+], a
    ld [de], a
    inc hl
    inc de
    inc de
    dec b
    jr nz, jr_003_44bc

    ld hl, $c94a
    ld a, $1c
    ld b, $12
    ld d, $00

jr_003_44cf::
    ld [hl], a
    ld e, $2a
    add hl, de
    ld [hl], a
    ld e, $16
    add hl, de
    dec b
    jr nz, jr_003_44cf

    ld a, $1e
    ld [$c90a], a
    ld a, $1e
    ld [$c934], a
    ld a, $50
    ld [$c935], a
    ld a, $1e
    ld [$cdca], a
    ld a, $90
    ld [$cdcb], a
    ld a, $1e
    ld [$cdf4], a
    ld a, $d0
    ld [$cdf5], a
    ld de, $45f5
    ld hl, wStageLayoutMap
    ld bc, $0880
    call Call_000_0490
    ret


    ld l, d
    ld b, l
    ld h, d
    ld b, l
    ld e, d
    ld b, l
    ld d, d
    ld b, l
    ld c, d
    ld b, l
    ld b, d
    ld b, l
    ld a, [hl-]
    ld b, l
    nop
    nop
    and d
    ld b, l
    sbc d
    ld b, l
    sub d
    ld b, l
    adc d
    ld b, l
    add d
    ld b, l
    ld a, d
    ld b, l
    ld [hl], d
    ld b, l
    nop
    nop
    ldh [rLYC], a
    rst $10
    ld b, l
    adc $45
    push bc
    ld b, l
    cp h
    ld b, l
    or e
    ld b, l
    xor d
    ld b, l
    nop
    nop
    ld bc, $0201
    ld bc, $0101
    ld bc, $01ff
    inc bc
    inc b
    dec b
    ld b, $01
    ld bc, $01ff
    rlca
    ld [$0a09], sp
    ld bc, rSB
    dec bc
    inc c
    dec c
    ld c, $0f
    db $10
    ld bc, $11ff
    ld [de], a
    inc de
    inc d
    dec d
    ld d, $01
    rst $38
    rla
    jr jr_003_457e

    ld a, [de]
    dec de
    ld bc, rSB
    ld bc, $0101
    ld bc, $0101
    ld bc, $1fff
    jr nz, jr_003_4596

    ld [hl+], a
    ld bc, $0101
    rst $38
    inc h
    dec h
    ld h, $27

jr_003_457e::
    ld bc, $2301
    rst $38
    add hl, hl
    ld a, [hl+]
    dec hl
    inc l
    dec l
    ld bc, $ff28
    ld l, $2f
    jr nc, jr_003_45bf

    ld bc, $0101
    rst $38
    ld [hl-], a
    inc sp
    inc [hl]
    dec [hl]

jr_003_4596::
    ld bc, $0101
    rst $38
    ld [hl], $37
    jr c, jr_003_45d7

    ld bc, $0101
    rst $38
    ld bc, $0101
    ld bc, $0101
    ld bc, $01ff
    ld c, e
    ld c, h
    ld c, l
    ld c, [hl]
    ld c, a
    ld d, b
    ld d, c
    rst $38
    ld bc, $5352
    ld d, h
    ld d, l
    ld bc, $0101
    rst $38
    ld bc, $5756

jr_003_45bf::
    ld e, b
    ld bc, $0101
    ld bc, $01ff
    ld bc, $0101
    ld bc, $0101
    ld a, [hl-]
    rst $38
    inc a
    dec a
    ld a, $01
    ld bc, $0101
    dec sp
    rst $38

jr_003_45d7::
    ld b, b
    ld b, c
    ld b, d
    ld bc, $0101
    ld bc, $ff3f
    ld c, b
    ld c, c
    ld c, d
    ld b, e
    ld b, h
    ld b, l
    ld b, [hl]
    ld b, a
    rst $38
    ld c, $7b
    rst $18
    ld a, a
    ld a, a
    ld [hl], $df
    ld a, a
    ld [hl], l
    ld c, a
    rst $18
    ld a, a
    and c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    di
    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld hl, $4744
    call SendSgbPacket
    call DelayFramesOrCycles
    ld hl, $4774
    ld b, $08

jr_003_461b::
    push hl
    push bc
    call SendSgbPacket
    call DelayFramesOrCycles
    pop bc
    pop hl
    ld de, $0010
    add hl, de
    dec b
    jr nz, jr_003_461b

    ld hl, wStageLayoutMap
    ld de, Bank0TrailingGraphicsData_3ca2
    ld b, $59

jr_003_4634::
    ld c, $08

jr_003_4636::
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, $ff
    ld [hl+], a
    dec c
    jr nz, jr_003_4636

    xor a
    ld c, $08

jr_003_4642::
    ld [hl+], a
    ld [hl+], a
    dec c
    jr nz, jr_003_4642

    dec b
    jr nz, jr_003_4634

    ld hl, wStageLayoutMap
    ld bc, $0020
    call bzero
    ld de, $4714
    ld hl, wStageLayoutMap
    ld bc, $0b20
    call Call_000_0490
    call Call_003_4424
    ld hl, $4b5f
    ld de, wStageLayoutMap
    ld bc, $0400
    call memcpy
    ld de, $4724
    ld hl, wStageLayoutMap
    ld bc, $1000
    call Call_000_0490
    ld a, $03
    ld hl, $47f4
    ld de, wStageLayoutMap
    call LoadMaskedGfx
    ld de, $4734
    ld hl, wStageLayoutMap
    ld bc, $05fa
    call Call_000_0490
    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld a, $81
    ldh [rLCDC], a
    ld hl, $4754
    call SendSgbPacket
    call DelayFramesOrCycles
    ret


    ld a, $1f
    ldh [hTileStreamWritePos], a

jr_003_46aa::
    push hl
    ld b, $10

jr_003_46ad::
    push bc
    call Call_003_46c5
    ld a, c
    ld [de], a
    inc de
    ld a, b
    ld [de], a
    inc de
    pop bc
    dec b
    jr nz, jr_003_46ad

    pop hl
    ldh a, [hTileStreamWritePos]
    sub $02
    ldh [hTileStreamWritePos], a
    jr nc, jr_003_46aa

    ret


Call_003_46c5::
    push de
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    push hl
    ld h, $03
    ld bc, $0000

jr_003_46d0::
    ld a, e
    and $1f
    push bc
    call Call_003_46f9
    pop bc
    or c
    ld c, a
    ld l, $05

jr_003_46dc::
    srl d
    rr e
    srl c
    rr b
    jr nc, jr_003_46e8

    set 7, c

jr_003_46e8::
    dec l
    jr nz, jr_003_46dc

    dec h
    jr nz, jr_003_46d0

    srl c
    rr b
    jr nc, jr_003_46f6

    set 7, c

jr_003_46f6::
    pop hl
    pop de
    ret


Call_003_46f9::
    push hl
    xor $1f
    ld c, a
    ldh a, [hTileStreamWritePos]
    call MultiplyBCByA8bit
    ld c, $ff

jr_003_4704::
    inc c
    ld a, l
    sub $1f
    ld l, a
    ld a, h
    sbc $00
    ld h, a
    jr nc, jr_003_4704

    ld a, c
    xor $1f
    pop hl
    ret


    sbc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    xor c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cp c
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cp c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret


    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, c
    dec de
    ld [$0b00], sp
    ld [$eaea], a
    ld [$a9ea], a
    ld bc, $4fcd
    inc c
    ret nc

    ld a, c
    ld h, $08
    nop
    dec bc
    add hl, sp
    call $0c48
    ret nc

    inc [hl]
    and l
    ret


    ret


    add b
    ret nc

    ld a, c
    ld sp, $0008
    dec bc
    inc c
    and l
    jp z, Jump_003_7ec9

    ret nc

    ld b, $a5
    set 1, c
    ld a, [hl]
    ld a, c
    inc a
    ld [$0b00], sp
    ldh a, [rNR12]
    and l
    ret


    ret


    ret z

    ret nc

    inc e
    and l
    jp z, $79c9

    ld b, a
    ld [$0b00], sp
    call nz, $16d0
    and l
    set 1, c
    dec b
    ret nc

    db $10
    and d
    jr z, @+$7b

    ld d, d
    ld [$0b00], sp
    xor c
    rst $20
    sbc a
    ld bc, $7ec0
    add sp, -$18
    add sp, -$18
    ldh [$ff79], a
    ld e, l
    ld [$0400], sp
    adc h
    ret nc

    db $f4
    ld h, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, c
    db $10
    ld [$0b00], sp
    ld c, h
    jr nz, @+$0a

    ld [$eaea], a
    ld [$60ea], a
    db $ea
    db $ea

    db $c0, $00, $7f, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $dc, $ff
    db $c0, $ff, $e7, $c0, $ff, $39, $c0, $ff, $c0, $aa, $cf, $80, $aa, $7f, $00, $f1
    db $05, $55, $00, $08, $2a, $05, $55, $00, $2a, $05, $55, $41, $00, $2a, $05, $55
    db $00, $aa, $ff, $ff, $ff, $f7, $00, $f8, $55, $a8, $ff, $84, $f0, $55, $a8, $ff
    db $f0, $55, $33, $a8, $00, $55, $00, $ff, $ff, $ff

jr_003_483e::
    db $ff, $ff, $ff, $ff, $fc, $0a, $aa, $c6, $a0, $08, $00, $20, $31, $08, $00, $20
    db $0a, $aa, $9f, $a0, $00, $ff, $ff, $ff, $f8, $03, $f0, $fc, $3e, $3f, $00, $55
    db $ff, $fd, $00, $ff, $79, $55, $50, $00, $8c, $05, $50, $00, $05, $55, $ff, $ff
    db $ff, $ff, $ff, $f9, $56, $55, $fe, $56, $7f, $55, $ff, $c0, $ab, $fa, $bf, $ab
    db $fa, $af, $67, $ff, $ea, $ff, $1c, $ef, $fb, $ff, $eb, $ff, $c6, $fe, $af, $ff
    db $ea, $30, $bf, $ff, $eb, $fa, $af, $aa, $00, $fa, $af, $ea, $fe, $af, $ea, $fe
    db $ab, $00, $fa, $bf, $ab, $fa, $af, $ea, $fe, $af, $00, $ea, $fe, $af, $ea, $fe
    db $57, $fa, $bf, $00, $ab, $59, $50, $aa, $fa, $af, $55, $54, $00, $af, $ea, $fe
    db $a5, $55, $bf, $ab, $fa, $00, $b0, $06, $fe, $af, $ea, $f0, $02, $ea, $00, $fe
    db $af, $e8, $03, $ab, $fa, $bf, $ab, $00, $fa, $af, $d5, $70, $03, $aa, $fe, $55
    db $06, $50, $02, $af, $f0, $00, $0f, $31, $e0, $00, $0e, $a0, $00, $8c, $0a, $b0
    db $00, $0b, $f0, $63, $00, $0f, $e0, $00, $18, $0e, $a0, $00, $0a, $a0, $00, $c6
    db $0a, $f0, $00, $0f, $31, $f0, $00, $0f

jr_003_4906::
    db $a0, $00, $8c, $0a, $a0, $00, $0a, $b0, $60, $00, $0b, $fe, $af, $ea, $fe, $01
    db $af, $ea, $fe, $af, $ea, $fe, $00, $e6, $3f, $ff, $fc, $31, $3f, $ff, $fc, $3f
    db $ff, $8c, $fc, $3f, $ff, $fc, $3f, $63, $ff, $fc

jr_003_4930::
    db $3f, $ff, $18, $fc, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc, $67, $00
    db $03, $00, $ff, $c0, $01, $40, $02, $a8, $00, $0a, $00, $40, $02, $a0, $00, $0a
    db $80, $02, $a0, $1f, $00, $02, $00, $f9, $3f, $ff, $8c, $fc, $3f, $ff, $fc, $3f
    db $63, $ff, $fc

jr_003_4963::
    db $3f, $ff, $18, $fc, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc, $31, $3f
    db $ff, $fc, $3f, $ff, $99, $fc, $00, $03, $00, $ff, $f0, $05, $40, $03, $f0, $00
    db $00, $0f, $c0, $03, $f0, $00, $0f, $c0, $07, $03, $f0, $00, $03, $00, $fe, $3f
    db $63, $ff, $fc

jr_003_4996::
    db $3f, $ff, $18, $fc, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc, $31, $3f
    db $ff, $fc, $3f, $ff, $8c, $fc, $3f, $ff, $fc, $3f, $66, $ff, $fc, $00, $03, $7f
    db $00, $ff, $00, $03, $f0, $00, $05, $00, $03, $f0, $00, $00, $0a, $c0, $03, $f0
    db $00, $0f, $c0, $00, $ff, $98, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc
    db $31, $3f, $ff, $fc, $3f, $ff, $8c, $fc, $3f, $ff, $fc, $3f, $63, $ff, $fc, $3f
    db $ff, $19, $fc, $3f, $ff, $fc, $00, $9c, $03, $00, $0a, $00, $e7, $06, $00, $00
    db $05, $40, $02, $a0, $00, $05, $40, $02, $00, $a0, $00, $05, $00, $02, $a0, $00
    db $0a, $3f, $80, $00, $e6, $3f, $ff, $fc, $31, $3f, $ff, $fc, $3f, $ff, $8c, $fc
    db $3f, $ff, $fc, $3f, $63, $ff, $fc

jr_003_4a1d::
    db $3f, $ff, $18, $fc, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc, $1f, $00
    db $c0, $00, $18, $05, $40, $00, $05, $40, $00

jr_003_4a36::
    db $c0, $05, $40, $02, $a0, $00, $05, $00, $40, $02, $a0, $00, $05, $40, $02, $a0
    db $7f, $00, $f9, $3f, $ff, $8c, $fc, $3f, $ff, $fc, $3f, $63, $ff, $fc

jr_003_4a54::
    db $3f, $ff, $18, $fc, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc, $31, $3f
    db $ff, $fc, $3f, $ff, $87, $fc, $00, $c0, $00, $8c, $28, $02, $00, $28, $06, $20
    db $40, $00, $2a, $05, $80

jr_003_4a79::
    db $0a, $a0, $00, $14, $05, $40, $02, $a0, $14, $05, $40, $03, $02, $a0, $14, $05
    db $40, $00, $fe, $3f, $63, $ff, $fc

jr_003_4a90::
    db $3f, $ff, $18, $fc, $3f, $ff, $fc, $3f, $ff, $c6, $fc, $3f, $ff, $fc, $31, $3f
    db $ff, $fc, $3f, $ff, $8c, $fc, $3f, $ff, $fc, $3f, $64, $ff, $fc, $00, $0c, $00
    db $e3, $28, $02, $00, $08, $28, $06, $40, $00, $2a, $05, $80, $42, $00, $14, $05
    db $40, $00, $14, $10, $05, $40, $00, $14, $05, $40, $00, $f3, $a9, $55, $18, $50
    db $ab, $55, $50, $ab, $55, $c6, $50, $a9, $55, $50, $31, $a9, $55, $50, $ab, $55
    db $8c, $50, $ab, $55, $50, $a9, $63, $55, $50, $a9, $55, $18, $50, $ab, $55, $50
    db $ab, $55, $c6, $50, $a9, $55, $50, $31, $a9, $55, $50, $ab, $55, $8c, $50, $ab
    db $55, $50, $a9, $67, $55, $50, $55, $fd, $00, $e6, $02, $aa, $80, $31, $02, $aa
    db $80, $02, $aa, $8c, $80, $02, $aa, $80, $02, $63, $aa, $80, $02, $aa, $18, $80

jr_003_4b20::
    db $02, $aa, $80, $02, $aa, $c6, $80, $02, $aa, $80, $31, $02, $aa, $80, $02, $aa
    db $8c, $80, $02, $aa, $80, $56, $62, $aa, $80, $56, $aa, $ab, $19

jr_003_4b3d::
    db $80, $56, $aa, $80, $00, $ff, $ff, $ff, $ff, $bf, $55, $ff, $fb, $aa, $de, $ff
    db $c0, $63, $00, $03, $c0, $00, $3f, $03, $ff, $ff, $ff, $c0, $cd, $21, $73, $03
    db $e9, $67

    sbc a
    ld h, a
    inc e
    ld d, $13
    dec c
    nop
    nop
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    ccf
    dec sp
    and b
    ld a, l
    nop
    nop
    rst $38
    ld a, a
    sub h
    ld d, d
    ld c, d
    add hl, hl
    nop
    nop
    ei
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    ret nz

    ld a, h
    ei
    ld a, a
    ccf
    ccf
    inc h
    ld l, l
    nop
    nop
    ei
    ld a, a
    rst $38
    ld a, a
    ld d, d
    ld [bc], a
    nop
    nop
    ei
    ld a, a
    ld a, a
    ld d, l
    rst $38
    inc bc
    ld c, e
    dec e
    rst $38
    ld c, e
    ld c, b
    ld a, l
    nop
    nop
    nop
    nop
    rst $38
    ld c, e
    ccf
    dec sp
    ld a, l
    inc l
    nop
    nop
    rst $38
    ld c, e
    ld hl, sp+$3f
    ld e, a
    jr z, jr_003_4bd6

    inc c
    rst $38
    ld c, e
    nop
    nop
    nop
    nop
    add b
    ld [bc], a
    ld [hl], a
    ld l, e
    ld [$a743], a
    dec c
    nop
    nop
    ld [hl], a
    ld l, e
    rst $38
    ld a, a
    db $e3
    ld a, l
    nop
    nop
    ld [hl], a
    ld l, e
    rst $38
    ld c, d
    rra
    inc de
    nop

jr_003_4bd6::
    nop
    ld [hl], a
    ld l, e
    ld a, a
    ld a, [bc]
    rra
    nop
    nop
    nop
    rst $38
    ld a, a
    rst $38
    inc bc
    inc sp
    ld [bc], a
    nop
    nop
    rst $38
    ld a, a
    rst $38
    ld [hl-], a
    inc [hl]
    ld h, $00
    nop
    rst $38
    ld a, a
    rst $20
    ld h, a
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    cp a
    ld de, $0000
    nop
    nop
    rst $38
    ld a, a
    inc e
    ld [bc], a
    rra
    nop
    nop
    nop
    rst $38
    ld a, a
    rst $38
    ld [hl-], a
    ld e, $05
    nop
    nop
    rst $38
    ld a, a
    rst $20
    ld h, a
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    cp a
    ld de, $0000
    nop
    nop
    rst $38
    ld a, a
    ld [hl], h
    ld a, [hl]
    rst $38
    ld a, a
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    add h
    inc bc
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    dec de
    add hl, bc
    nop
    nop
    rst $38
    ld a, a
    rst $38
    inc bc
    dec de
    add hl, bc
    nop
    nop
    rst $38
    ld a, a
    sbc a
    ld b, d
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    rst $38
    inc bc
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    ld [bc], a
    ld a, [hl]
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    dec de
    add hl, bc
    nop
    nop
    rst $38
    ld a, a
    ccf
    cpl
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    ld h, [hl]
    ld b, [hl]
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    dec de
    add hl, bc
    nop
    nop
    rst $38
    ld a, a
    db $e3
    ld a, a
    rra
    nop
    nop
    nop
    rst $38
    ld a, a
    jp hl


    cpl
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    rst $38
    ld l, e
	db $c2
	db $7E
	db $00

    nop
    rst $38
    ld a, a
    ccf
    dec sp
    rra
    ld e, d
    nop
    nop
    rst $38
    ld a, a
    rst $38
    inc bc
    rra
    nop
    nop
    nop
    db $fc
    dec sp
    ldh [rHDMA3], a
    sbc a
    nop
    nop
    nop
    db $fc
    dec sp
    db $db
    ld h, $24
    ld l, l
    nop
    nop
    db $fc
    dec sp
    rst $38
    ld a, a
    ld d, d
    ld [bc], a
    nop
    nop
    db $fc
    dec sp
    nop
    nop
    nop
    nop
    ld a, h
    nop
    cp l
    ld [hl], a
    pop af
    ld a, d
    adc d
    ld c, l
    nop
    nop
    cp l
    ld [hl], a
    ccf
    inc sp
    db $d3
    ld [hl], $00
    nop
    cp l
    ld [hl], a
    ld l, h
    ld a, l
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    cp [hl]
    dec l
    nop
    nop
    nop
    nop
    rst $38
    ld a, a
    ccf
    dec sp
    push de
    dec e
    nop
    nop
    rst $38
    ld a, a
    adc h
    ld d, c
    rst $20
    ld b, h
    nop
    nop
    rst $38
    ld a, a
    nop
    nop
    rra
    nop
    nop
    nop
    cp l
    ld [hl], a
    ld e, a
    ld e, d
    db $fd
    inc c
    nop
    nop
    cp h
    ld h, e
    rst $38
    add hl, hl
    halt
    ld sp, $0000
    cp l
    ld [hl], a
    sbc a
    ld e, a
    add hl, sp
    dec h
    nop
    nop
    rst $38
    ld a, a
    nop
    nop
    nop
    nop
    nop
    nop
    cp l
    ld [hl], a
    ld e, l
    dec sp
    db $cc
    db $0e
	nop
    nop
    cp l
    ld [hl], a
    sub b
    ld d, a
    ld [hl-], a
    ld a, [hl]
    nop
    nop
    cp l
    ld [hl], a
    db $dd
    ld e, d
    adc [hl]
    ld l, [hl]
    nop
    nop
    cp l
    ld [hl], a
    sbc h
    dec sp
    inc l
    inc sp
    nop
    nop
    cp l
    ld [hl], a
    xor $7e
    nop
    nop
    ret nz

    ld bc, $77bd
    ccf
    dec sp
    ld a, [hl]
    inc bc
    nop
    nop
    cp l
    ld [hl], a
    ld e, b
    ld [bc], a
    sub e
    ld bc, $0000
    cp l
    ld [hl], a
    nop
    ld a, h
    nop
    nop
    nop
    nop
SgbScreenPaletteTable_4d5f::
    ; 6-byte records indexed by wScreenPaletteId.	
    ; id  pal0 pal1 pal2 pal3 ctl  extra
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

Bank3MetaspritePtrTable_4e19::
    db $9f, $70, $d4, $70, $09, $71, $3e, $71, $77, $71, $b4, $71, $e1, $71, $1e, $72
    db $5b, $72, $8c, $72, $c1, $72, $f6, $72, $27, $73, $48, $73, $53, $6f, $74, $6f
    db $95, $6f, $b6, $6f, $d3, $6f, $f0, $6f, $09, $70, $22, $70, $3b, $70, $54, $70
    db $6d, $70, $86, $70, $05, $69, $32, $69, $5f, $69, $78, $69, $a1, $69, $ce, $69
    db $f7, $69, $24, $6a, $45, $6a, $72, $6a, $9f, $6a, $b8, $6a, $e5, $6a, $fe, $6a
    db $17, $6b, $30, $6b

    ld c, c
    ld l, e
    ld h, d
    ld l, e

    db $7b, $6b, $8c, $6b, $95, $6b, $9e, $6b, $a7, $6b, $b0, $6b, $b9, $6b, $c6, $6b
    db $d7, $6b, $e0, $6b, $f1, $6b, $02, $6c, $0f, $6c, $1c, $6c, $35, $6c, $46, $6c
    db $57, $6c, $68, $6c

    ld a, c
    ld l, h
    sub d
    ld l, h
    xor e
    ld l, h
    call nz, $d96c
    ld l, h
    ldh a, [c]
    ld l, h
    dec bc
    ld l, l
    inc e
    ld l, l
    dec l
    ld l, l
    ld b, [hl]
    ld l, l
    ld e, a
    ld l, l
    ld a, b
    ld l, l
    adc l
    ld l, l
    and [hl]
    ld l, l

    db $bf, $6d, $d0, $6d, $d9, $6d, $e2, $6d

    di
    ld l, l
    inc b
    ld l, [hl]
    dec d
    ld l, [hl]
    ld l, $6e
    ld b, a
    ld l, [hl]
    ld h, b
    ld l, [hl]
    ld [hl], l
    ld l, [hl]
    adc d
    ld l, [hl]
    and e
    ld l, [hl]
    cp h
    ld l, [hl]
    push de
    ld l, [hl]
    xor $6e
    rlca
    ld l, a
    jr nz, @+$71

    ld sp, $426f
    ld l, a

    db $06, $66, $2b, $66, $50, $66, $55, $66, $76, $66, $97, $66, $bc, $66

    jp hl


    ld h, [hl]
    ld c, $67

    db $2f, $67, $48, $67, $61, $67

    ld a, d
    ld h, a

    db $93, $67, $ac, $67, $c5, $67, $de, $67, $f7, $67

    db $10
    ld l, b
    dec d
    ld l, b
    ld l, $68

    db $47, $68, $60, $68

    ld [hl], c
    ld l, b
    sub d
    ld l, b
    or e
    ld l, b
    ret c

    ld l, b

    db $fb, $60

    inc d
    ld h, c
    dec l
    ld h, c

    db $46, $61, $5f, $61, $78, $61, $95, $61, $b2, $61, $cf, $61, $f0, $61, $11, $62
    db $2a, $62, $43, $62, $60, $62, $79, $62, $92, $62, $ab, $62, $c8, $62, $e1, $62
    db $fa, $62, $13, $63, $30, $63, $55, $63, $82, $63, $a3, $63, $c4, $63, $e5, $63
    db $06, $64, $3b, $64, $80, $64, $c5, $64, $06, $65, $3b, $65, $6d, $73, $a6, $73
    db $df, $73, $1c, $74, $4d, $74, $7e, $74, $af, $74, $f0, $74, $31, $75, $72, $75
    db $b3, $75, $d4, $75, $f9, $75, $1a, $76, $3b, $76

    ld e, h
    halt
    ld a, c
    halt

    db $92, $76, $a3, $76, $bc, $76

    db $cd
    halt

    db $0e, $77, $37, $77, $d4, $77, $e9, $77, $02, $78, $1b, $78, $34, $78, $4d, $78
    db $66, $78, $7f, $78, $98, $78, $b5, $78, $d6, $78, $f7, $78, $18, $79, $31, $79
    db $4a, $79, $63, $79, $7c, $79, $95, $79, $ae, $79, $c7, $79, $dc, $79, $f5, $79
    db $0e, $7a, $2b, $7a, $48, $7a, $65, $7a, $82, $7a, $9f, $7a, $bc, $7a, $dd, $7a
    db $fe, $7a

    cp $7a

    db $1f, $7b, $3c, $7b, $5d, $7b, $7e, $7b, $a7, $7b, $d0, $7b, $f9, $7b, $22, $7c
    db $4b, $7c, $74, $7c, $91, $7c, $ae, $7c, $cf, $7c, $f0, $7c, $09, $7d, $26, $7d
    db $43, $7d, $64, $7d, $85, $7d

    and [hl]
    ld a, l
    db $db
    ld a, l
    inc d
    ld a, [hl]
    ld c, c
    ld a, [hl]
    sub d
    ld a, [hl]
    db $db
    ld a, [hl]
    inc h
    ld a, a
    ld b, c
    ld a, a
    ld h, d
    ld a, a
    add a
    ld a, a
    adc h
    ld a, a
    sub l
    ld a, a
    rrca
    rst $38

    db $00, $00, $6d, $53, $6d, $53, $45, $1f, $11, $1a, $17, $1d, $42, $fe, $5b, $74
    db $54, $45, $66, $45, $15, $05, $09, $54, $33, $34, $13, $36, $45, $59, $7d, $ff
    db $00, $00, $00, $19, $42, $20, $3c, $12, $10, $21, $32, $fe, $2d, $42, $1b, $42
    db $58, $5d, $5f, $45, $15, $33, $34, $13, $36, $45, $59, $7d, $ff, $00, $00, $00
    db $14, $1c, $45, $2d, $35, $45, $56, $70, $7c, $43, $67, $fe, $1b, $42, $20, $3a
    db $42, $45, $15, $2b, $24, $35, $2c, $13, $36, $45, $59, $7d, $ff, $00, $00, $00
    db $00, $00, $45, $23, $45, $17, $20, $fe, $30, $45, $16, $41, $14, $1d, $45, $2a
    db $21, $45, $16, $29, $57, $5e, $7e, $45, $56, $45, $1f, $ff, $00, $00, $00, $00
    db $00, $39, $22, $1f, $7d, $fe, $5b, $74, $54, $45, $66, $41, $05, $09, $54, $33
    db $34, $22, $1f, $45, $59, $7d, $ff, $00, $00, $00, $00, $00, $39, $22, $1f, $7d
    db $fe, $fd, $58, $5d, $5f, $41, $33, $34, $22, $1f, $45, $59, $7d, $ff, $00, $00
    db $00, $00, $00, $39, $22, $1f, $7d, $fe, $1b, $42, $20, $3a, $42, $45, $15, $2b
    db $24, $35, $2c, $13, $1f, $45, $59, $7d, $ff, $00, $00, $1b, $22, $43, $2a, $11
    db $1b, $20, $3a, $22, $1f, $7d, $ff, $00, $6d, $53, $6d, $53, $45, $1f, $11, $1a
    db $17, $1d, $42, $fe, $0f, $51, $7e, $29, $00, $12, $13, $24, $1b, $1f, $45, $23
    db $fe, $1b, $42, $20, $3a, $42, $41, $00, $1e, $12, $1a, $1b, $23, $fe, $40, $45
    db $69, $5a, $7c, $45, $23, $00, $19, $12, $45, $18, $16, $7d, $fe, $52, $76, $46
    db $7e, $43, $69, $48, $7c, $5f, $41, $fe, $15, $1d, $11, $45, $23, $00, $46, $52
    db $56, $74, $7c, $fe, $57, $5f, $7e, $7c, $41, $00, $2f, $33, $38, $12, $7d, $ff
    db $00, $00, $19, $42, $20, $3c, $12, $10, $21, $32, $fe, $0f, $51, $7e, $45, $23
    db $00, $1b, $42, $20, $3a, $42, $41, $fe, $1e, $12, $1a, $1b, $23, $00, $40, $45
    db $69, $5a, $7c, $45, $23, $fe, $31, $1b, $41, $21, $15, $2f, $13, $3d, $12, $7d
    db $fe, $1d, $11, $45, $18, $42, $45, $1b, $15, $42, $25, $11, $26, $fe, $52, $76
    db $46, $7e, $43, $69, $48, $7c, $5f, $41, $fe, $15, $1d, $45, $17, $42, $45, $1f
    db $7d, $ff, $00, $00, $14, $1c, $45, $2d, $35, $45, $56, $70, $7c, $43, $67, $fe
    db $40, $45, $69, $5a, $7c, $45, $23, $00, $1b, $42, $20, $3a, $42, $41, $fe, $45
    db $56, $70, $7c, $43, $67, $1a, $1d, $23, $fe, $1b, $42, $20, $3a, $42, $26, $42
    db $45, $16, $3e, $12, $41, $fe, $51, $70, $5d, $5b, $1c, $36, $42, $45, $1f, $7d
    db $fe, $2f, $45, $1c, $2a, $00, $56, $79, $45, $15, $00, $14, $23, $2e, $42, $fe
    db $41, $00, $30, $1d, $23, $17, $37, $36, $3d, $7d, $ff, $00, $00, $00, $00, $00
    db $45, $1a, $42, $28, $42, $7d, $fe, $00, $00, $00, $57, $5a, $7c, $43, $67, $45
    db $15, $25, $11, $45, $59, $7d, $ff, $1b, $42, $20, $3a, $42, $24, $10, $1e, $45
    db $2c, $fe, $24, $20, $3c, $12, $15, $34, $10, $1e, $45, $2c, $fe, $6b, $61, $45
    db $53, $7e, $6c, $45, $23, $10, $1e, $45, $2c, $ff

    db $6d, $53, $6d, $53, $45, $1f, $11, $1a, $17, $1d, $42, $fe, $19, $42, $20, $3c

    db $12, $10, $21, $32, $fe, $14, $1c, $45, $2d, $35, $45, $56, $70, $7c, $43, $67
    db $ff, $15, $11, $3f, $00, $00, $00, $00, $05, $fe, $45, $5e, $6e, $00, $00, $00
    db $00, $00, $05, $fe, $4c, $7c, $45, $5e, $49, $7c, $45, $52, $00, $05, $fe, $58
    db $78, $52, $5f, $45, $5e, $6e, $00, $05, $ff

    db $57, $5a, $7e, $5f, $7d, $ff, $00, $05, $ff, $00, $06, $ff, $00, $07, $ff

; -----------------------------------------------------------------------------
; Message $4C: level text
; レべル<VAR>
Message_4C_LevelText::
    db $78, $45, $2d, $77, $fd, $ff, $a0, $43, $66, $52, $61, $5d, $52, $2d, $11, $17
    db $45, $59, $a1, $ff, $a0, $3d, $12, $20, $13, $42, $45, $23, $10, $1e, $45, $2c
    db $45, $59, $a1, $ff, $00, $a0, $45, $5e, $43, $65, $7e, $5f, $2d, $11, $17, $45
    db $59, $a1, $ff, $a0, $45, $52, $46, $6c, $35, $3e, $19, $12, $45, $1f, $45, $59
    db $a1, $ff

    db $10, $24, $00, $fd, $15, $11, $45, $1f, $3d, $ff, $8e, $14, $45, $18, $42

    db $16, $8f, $ff, $8e, $45, $1f, $1b, $23, $7d, $8f, $ff


; -----------------------------------------------------------------------------
; Message $1C: Stage 1 intro / picnic
; きょうは しんちゃんが
; たのしみにしていたピクニック
; の ひ です
; ところが おやつのチョコビを
; タケシくんに とられてしまい
; ました！
Message_1C_Stage1Intro::
    db $16, $3e, $12, $2a, $00, $1b, $42, $20, $3a, $42, $45, $15, $fe, $1f, $29, $1b
    db $30, $26, $1b, $23, $11, $1f, $43, $66, $52, $61, $5d, $52, $fe

    db $29, $00, $2b, $00, $45, $23, $1c, $fe, $24, $19, $38, $45

    db $15, $00, $14, $39, $21, $29, $5b, $74, $54, $45, $66, $41, $fe, $5a

    db $53, $56, $17, $42, $26, $00, $24, $34, $37, $23, $1b, $2f, $11, $fe, $2f, $1b
    db $1f, $7d, $ff


; -----------------------------------------------------------------------------
; Message $1D: Stage 2 intro / kindergarten rivals
; しんちゃんが かよっている
; ひまわりぐみには ゆかいな
; おともだちが いっぱい！
; でも となりのバラぐみには
; かわむらくんのような
; ライバルばかり なんだ！
Message_1D_Stage2Intro::
    db $1b, $42, $20, $3a, $42, $45, $15, $00, $15, $3d, $22, $23, $11, $36, $fe, $2b
    db $2f, $3f, $35, $45, $17, $30, $26, $2a, $00, $3b, $15, $11, $25, $fe, $14, $24
    db $33, $45, $1f, $20, $45, $15, $00, $11, $22, $43, $2a, $11, $7d, $fe, $45, $23
    db $33, $00, $24, $25, $35, $29, $45, $65, $75, $45, $17, $30, $26, $2a, $fe, $15
    db $3f, $31, $34, $17, $42, $29, $3d, $12, $25, $fe, $75, $48, $45, $65, $77, $45
    db $2a, $15, $35, $00, $25, $42, $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $1E: Stage 3 intro / Action Department
; きょうの アクションデパート
; は すごい ひとだかり！
; なぜなら おくじょうで
; アクションかめんショーが
; おこなわれるからです！
Message_1E_Stage3Intro::
    db $16, $3e, $12, $29, $00, $46, $52, $56, $74, $7c, $45, $5e, $43, $65, $7e, $5f
    db $fe, $2a, $00, $1c, $45, $19, $11, $00, $2b, $24, $45, $1f, $15, $35, $7d, $fe
    db $25, $45, $1d, $25, $34, $00, $14, $17, $45, $1b, $3e, $12, $45, $23, $fe, $46
    db $52, $56, $74, $7c, $15, $32, $42, $56, $74, $7e, $45, $15, $fe, $14, $19, $25
    db $3f, $37, $36, $15, $34, $45, $23, $1c, $7d, $ff

; -----------------------------------------------------------------------------
; Message $1F: Stage 4 intro / Guam trip
; みさえが おうぼしたクイズで
; グアムりょこうが あたって
; しまった！
; さっそく かぞくみんなで
; グアムへ やってきたのですが
; ．．．？
Message_1F_Stage4Intro::
    db $30, $1a, $13, $45, $15, $00, $14, $12, $45, $2e, $1b, $1f, $52, $48, $45, $57
    db $45, $23, $fe, $45, $52, $46, $6c, $35, $3e, $19, $12, $45, $15, $00, $10, $1f
    db $22, $23, $fe, $1b, $2f, $22, $1f, $7d, $fe, $1a, $22, $1e, $17, $00, $15, $45
    db $1e, $17, $30, $42, $25, $45, $23, $fe, $45, $52, $46, $6c, $2d, $00, $39, $22
    db $23, $16, $1f, $29, $45, $23, $1c, $45, $15, $fe, $44, $44, $44, $7f, $ff


; -----------------------------------------------------------------------------
; Message $20: Takeshi steals Chocobi
; へっへっへっへー
; チョコビ いっただきー！
; ．．．おい！ なにニヤケてんだよ
; きもちワリーな！！
Message_20_TakeshiStealsChocobi::
    db $2d, $22, $2d, $22, $2d, $22, $2d, $7e, $fe, $5b, $74, $54, $45, $66, $00, $11
    db $22, $1f, $45, $1f, $16, $7e, $7d, $fe, $44, $44, $44, $14, $11, $7d, $00, $25
    db $26, $61, $6f, $53, $23, $42, $45, $1f, $3d, $fe, $16, $33, $20, $7a

    db $76, $7e, $25, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $21: Shin-chan meta intro
; いやー ゲームボーイにでるの
; ひさしぶりなもんで．．．
; どーも どーも しんのすけですう
; すきな おパンツのガラは．．
Message_21_ShinchanMetaIntro::
    db $11, $39, $7e, $00, $45, $53, $7e, $6c, $45, $69, $7e, $48, $26, $45, $23, $36
    db $29, $fe, $2b, $1a, $1b, $45, $2c, $35, $25, $33, $42, $45, $23, $44, $44, $44
    db $fe, $45, $24, $7e, $33, $00, $45, $24, $7e, $33, $00, $1b, $42, $29, $1c, $18
    db $45

    db $23, $1c, $12, $fe, $1c, $16, $25, $00, $14, $43, $65, $7c, $5c, $29, $45, $50
    db $75, $2a, $44, $44, $ff

; -----------------------------------------------------------------------------
; Message $22: Takeshi runs away
; ends with control $fc before $ff
; えーい なにブツブツいってんだ！
; こいつは いただいていくぜ
; あばよ！
Message_22_TakeshiRunsAway::
    db $13, $7e, $11, $00, $25, $26, $45, $67, $5c, $45, $67, $5c, $11, $22, $23, $42
    db $45, $1f, $7d, $fe, $19, $11, $21, $2a, $00, $11, $1f, $45, $1f, $11, $23, $11
    db $17, $45, $1d, $fe, $10, $45, $2a, $3d, $7d, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $23: Tutorial lead-in
; おおっ オラのチョコビ
; とりかえさなくっちゃ！
; [control $fc]
; でも そのまえに オラのうごかし
; かたを せつめいするゾ！
Message_23_TutorialLeadIn::
    db $14, $14

    db $22, $00

    db $4e, $75, $29, $5b, $74, $54, $45, $66, $fe, $24, $35, $15, $13, $1a, $25, $17
    db $22, $20, $3a

    db $7d, $fe, $fc, $45, $23, $33, $00, $1e, $29, $2f, $13, $26, $00, $4e, $75, $29
    db $12, $45, $19, $15, $1b, $fe, $15, $1f, $41, $00, $1d, $21, $32, $11, $1c, $36
    db $45, $59, $7d, $ff


; -----------------------------------------------------------------------------
; Message $24: Takeshi returns Chocobi
; ちっ しょうがないなあ
; チョコビ かえしてやるよ！
Message_24_TakeshiReturnsChocobi::
    db $20, $22, $00, $1b, $3e, $12, $45, $15, $25, $11, $25, $10, $fe, $5b, $74, $54
    db $45, $66, $00, $15, $13, $1b, $23, $39, $36, $3d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $25: Chocobi recovered
; ワーイ ワーイ
; チョコビだ チョコビだー！
Message_25_ChocobiRecovered::
    db $7a, $7e, $48, $00, $7a, $7e, $48, $fe, $5b, $74, $54, $45, $66, $45, $1f, $00
    db $5b, $74, $54, $45, $66, $45, $1f, $7e, $7d, $ff

; -----------------------------------------------------------------------------
; Message $26: sound effect text
; ザーッ
Message_26_DrinkSound::
    db $45, $55, $7e, $5d, $ff

; -----------------------------------------------------------------------------
; Message $27: drinking reaction
; す．すげえ
; いっきのみ してやがる．．．
Message_27_DrinkReaction::
    db $1c, $44, $1c, $45, $18, $13, $fe, $11, $22, $16, $29, $30, $00, $1b, $23, $39
    db $45, $15, $36, $44, $44, $44, $ff

; -----------------------------------------------------------------------------
; Message $28: Chocobi after a sweat
; いやー ひとあせ かいたあとの
; チョコビ！
; うまいんだな これが！！
Message_28_ChocobiAfterSweat::
    db $11, $39, $7e, $00, $2b, $24, $10, $1d, $00, $15, $11, $1f, $10, $24, $29, $fe
    db $5b, $74, $54, $45, $66, $7d, $fe, $12, $2f, $11, $42, $45, $1f, $25, $00, $19
    db $37, $45, $15, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $29: stage clear password prompt
;    ステージ<VAR> おしまい
;      パスワード
Message_29_StageClearPassword::
    db $00, $00, $00, $57, $5e, $7e, $45, $56, $fd, $00, $14, $1b, $2f, $11, $fe, $00
    db $00, $00, $00, $00, $43, $65, $57, $7a, $7e, $45, $5f, $ff

; -----------------------------------------------------------------------------
; Message $2A: Kawamura appears
; ふっふっふっふっ
; ひさしぶりだな しんのすけ！
Message_2A_KawamuraAppears::
    db $2c, $22, $2c, $22, $2c, $22, $2c, $22, $fe, $2b, $1a, $1b, $45, $2c, $35, $45
    db $1f, $25, $00, $1b, $42, $29, $1c, $18, $7d, $ff

; -----------------------------------------------------------------------------
; Message $2B: Who are you?
; あんた だれ？
Message_2B_WhoAreYou::
    db $10, $42, $1f, $00, $45, $1f, $37, $7f, $ff

; -----------------------------------------------------------------------------
; Message $2C: Kawamura / Cheetah introduction
; ようちえん バラぐみの チーター
; こと かわむらさまだ！！
; わすれるとは ぶれいなやつだ
Message_2C_KawamuraIntroducesHimself::
    db $3d, $12, $20, $13, $42, $00, $45, $65, $75, $45, $17, $30, $29, $00, $5b, $7e
    db $5a, $7e, $fe, $19, $24, $00, $15, $3f, $31, $34, $1a, $2f, $45, $1f, $7d, $7d
    db $fe, $3f, $1c, $37, $36, $24, $2a, $00, $45, $2c, $37, $11, $25, $39, $21, $45
    db $1f, $ff

; -----------------------------------------------------------------------------
; Message $2D: Shin-chan teases Kawamura
; ねえーん
; そんなに おこらないでよおーん
; ゆるしてえええーん
Message_2D_ShinchanTeasesKawamura::
    db $28, $13, $7e, $42, $fe, $1e, $42, $25, $26, $00, $14, $19, $34, $25, $11, $45
    db $23, $3d, $14, $7e, $42, $fe, $3b, $36, $1b, $23, $13, $13, $13, $7e, $42, $ff

; -----------------------------------------------------------------------------
; Message $2E: Kawamura challenge
; ends with control $fc before $ff
; だあーっ！ きもちわりーなー！！
; きょうは ひごろの うらみを
; はらすために しょうぶだ！
; ホールで まっているぞ！！
Message_2E_KawamuraChallenge::
    db $45, $1f, $10, $7e, $22, $7d, $00, $16, $33, $20, $3f, $35, $7e, $25, $7e, $7d
    db $7d, $fe, $16, $3e, $12, $2a, $00, $2b, $45, $19, $38, $29, $00, $12, $34, $30
    db $41, $fe, $2a, $34, $1c, $1f, $32, $26, $00, $1b, $3e, $12, $45, $2c, $45, $1f
    db $7d, $fe, $69, $7e, $77, $45, $23, $00, $2f, $22, $23, $11, $36, $45, $1e, $7d
    db $7d, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $2F: Shin-chan after Kawamura leaves
; ううーん オラだって わるぎが
; あったわけじゃないしー
; ううーん いやーん い．け．ずー
; [control $fc]
; ．．あれ？ いなくなっちゃった
Message_2F_ShinchanAfterKawamuraLeaves::
    db $12, $12, $7e, $42, $00, $4e, $75, $45, $1f, $22, $23, $00, $3f, $36, $45, $16
    db $45, $15, $fe, $10, $22, $1f, $3f, $18, $45, $1b, $3a, $25, $11, $1b, $7e, $fe
    db $12, $12, $7e, $42, $00, $11, $39, $7e, $42, $00, $11, $44, $18, $44, $45, $1c
    db $7e, $fe, $fc, $44, $44, $10, $37, $7f, $00, $11, $25, $17, $25, $22, $20, $3a
    db $22, $1f, $ff

; -----------------------------------------------------------------------------
; Message $30: Kawamura loses again
; $06=２, $07=３, $08=４; quote glyphs are shown here as 「」.
; うわーん！
; 「しんちゃん２」「３」に
; ひきつづいて 「４」でも
; また まけちまったあー！
Message_30_KawamuraLosesAgain::
    db $12, $3f, $7e, $42, $7d, $fe, $68, $1b, $42, $20, $3a, $42, $06, $71, $68, $07
    db $71, $26, $fe, $2b, $16, $21, $45, $21, $11, $23, $00, $68, $08, $71, $45, $23
    db $33, $fe, $2f, $1f, $00, $2f, $18, $20, $2f, $22, $1f, $10, $7e, $7d, $ff

; -----------------------------------------------------------------------------
; Message $31: Kawamura retry prompt
; つぎだ！ つぎこそ オレさまが
; かってみせるぞー！
; しんのすけ！
; ステージ<VAR> もういちど やれ！
Message_31_KawamuraRetry::
    db $21, $45, $16, $45, $1f, $7d, $00, $21, $45, $16, $19, $1e, $00, $4e, $78, $1a
    db $2f, $45, $15, $fe, $15, $22, $23, $30, $1d, $36, $45, $1e, $7e, $7d, $fe, $1b
    db $42, $29, $1c, $18, $7d, $fe, $57, $5e, $7e, $45, $56, $fd, $00, $33, $12, $11
    db $20, $45, $24, $00, $39, $37, $7d, $ff

; -----------------------------------------------------------------------------
; Message $32: password text
; わがままだなあ
Message_32_Password_WagamamaDanaa::
    db $3f, $45, $15, $2f, $2f, $45, $1f, $25, $10, $ff

; -----------------------------------------------------------------------------
; Message $33: stage number text
; ステージ<VAR>
Message_33_StageNumberText::
    db $57, $5e, $7e, $45, $56, $fd, $ff

; -----------------------------------------------------------------------------
; Message $34: Action Kamen show intro
; よかったわねー しんちゃん
; あこがれの アクションかめんに
; あえるわよ！
Message_34_ActionKamenShowIntro::
    db $3d, $15, $22, $1f, $3f, $28, $7e, $00, $1b, $42, $20, $3a, $42, $fe, $10, $19
    db $45, $15, $37, $29, $00, $46, $52, $56, $74, $7c, $15, $32, $42, $26, $fe, $10
    db $13, $36, $3f, $3d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $35: Hiroshi embarrassed
; はずかしいから はしゃぐなよ
; みさえ
Message_35_HiroshiEmbarrassed::
    db $2a, $45, $1c, $15, $1b, $11, $15, $34, $00, $2a, $1b, $3a, $45, $17, $25, $3d
    db $fe, $30, $1a, $13, $ff

; -----------------------------------------------------------------------------
; Message $36: Misae tells Shin-chan to go
; あんたが いきたいってゆーから
; きたんでしょーが！
; はやく いってきなさい！！
Message_36_MisaeTellsShinchanToGo::
    db $10, $42, $1f, $45, $15, $00, $11, $16, $1f, $11, $22, $23, $3b, $7e, $15, $34
    db $fe, $16, $1f, $42, $45, $23, $1b, $3e, $7e, $45, $15, $7d, $fe, $2a, $39, $17
    db $00, $11, $22, $23, $16, $25, $1a, $11, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $37: Ho-hoi
; ホッホーイ
Message_37_HoHoi::
    db $69, $5d, $69, $7e, $48, $ff

; -----------------------------------------------------------------------------
; Message $38: Action Kamen show already started
; おおっ もう はじまっているゾー
; がんばれ アクションかめーん！！
Message_38_ActionKamenShowAlreadyStarted::
    db $14, $14, $22, $00, $33, $12, $00, $2a, $45, $1b, $2f, $22, $23, $11, $36, $45
    db $59, $7e, $fe, $45, $15, $42, $45, $2a, $37, $00, $46, $52, $56, $74, $7c, $15
    db $32, $7e, $42, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $39: Action Great Beam
; ends with control $fc before $ff
; くらえ ブラックメケメケだん！
; アクション グレートビーム！！！
Message_39_ActionGreatBeam::
    db $17, $34, $13, $00, $45, $67, $75, $5d, $52, $6d, $53, $6d, $53, $45, $1f, $42
    db $7d, $fe, $46, $52, $56, $74, $7c, $00, $45, $52, $78, $7e, $5f, $45, $66, $7e
    db $6c, $7d, $7d, $7d, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $3A: Action Kamen victory
; みたか せいぎのちからを！
; わたしが いるかぎり
; ちきゅうは へいわで
; ありつづけるのだ！！
Message_3A_ActionKamenVictory::
    db $30, $1f, $15, $00, $1d, $11, $45, $16, $29, $20, $15, $34, $41, $7d, $fe, $3f
    db $1f, $1b, $45, $15, $00, $11, $36, $15, $45, $16, $35, $fe, $20, $16, $3c, $12
    db $2a, $00, $2d, $11, $3f, $45, $23, $fe, $10, $35, $21, $45, $21, $18, $36, $29
    db $45, $1f, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $3B: Action Kamen laugh
; ワーッハッハッハッハッハッ
; ワーッハッハッハッハッハッ！！！
Message_3B_ActionKamenLaugh::
    db $7a, $7e, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $fe, $7a, $7e
    db $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $7d, $7d, $7d, $ff


; -----------------------------------------------------------------------------
; Message $3C: turbo stage clear password prompt
;  ステージ<VAR>ターボ おしまい
;      パスワード
Message_3C_TurboStageClearPassword::
    db $00, $57, $5e, $7e, $45, $56, $fd, $5a, $7e, $45, $69, $00, $14, $1b, $2f, $11
    db $fe, $00, $00, $00, $00, $00, $43, $65, $57, $7a, $7e, $45, $5f, $ff


; -----------------------------------------------------------------------------
; Message $3D: Guam excitement
; ホッホーイ
; グアム グアムー
Message_3D_GuamExcitement::
    db $69, $5d, $69, $7e, $48, $fe, $45, $52, $46, $6c, $00, $45, $52, $46, $6c, $7e
    db $ff

; -----------------------------------------------------------------------------
; Message $3E: arrived after a long trip
; ふうーっ なんとか ついたぞ
; ながい みちのりだった．．．
Message_3E_ArrivedAfterLongTrip::
    db $2c, $12, $7e, $22, $00, $25, $42, $24, $15, $00, $21, $11, $1f, $45, $1e, $fe
    db $25, $45, $15, $11, $00, $30, $20, $29, $35, $45, $1f, $22, $1f, $44, $44, $44
    db $ff

; -----------------------------------------------------------------------------
; Message $3F: what is Guam?
; で グアムって なに？
; オラに かんけいあるもの？
Message_3F_WhatIsGuam::
    db $45, $23, $00, $45, $52, $46, $6c, $22, $23, $00, $25, $26, $7f, $fe, $4e, $75
    db $26, $00, $15, $42, $18, $11, $10, $36, $33, $29, $7f, $ff

; -----------------------------------------------------------------------------
; Message $40: Misae expected that
; やっぱり そんなことだろうと
; おもったわよ
Message_40_MisaeExpectedThat::
    db $39, $22, $43, $2a, $35, $00, $1e, $42, $25, $19, $24, $45, $1f, $38, $12, $24
    db $fe, $14, $33, $22, $1f, $3f, $3d, $ff

; -----------------------------------------------------------------------------
; Message $41: gals
; ends with control $fc before $ff
; お ギャル
Message_41_Gals::
    db $14, $00, $45, $51, $70, $77, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $42: Hiroshi calls Shin-chan
; お．おい しんのすけー！
Message_42_HiroshiCallsShinchan::
    db $14, $44, $14, $11, $00, $1b, $42, $29, $1c, $18, $7e, $7d, $ff

; -----------------------------------------------------------------------------
; Message $43: Misae expected trouble
; やっぱり こんなことに
; なるだろうと おもったわよ．．．
Message_43_MisaeExpectedTrouble::
    db $39, $22, $43, $2a, $35, $00, $19, $42, $25, $19, $24, $26, $fe, $25, $36, $45
    db $1f, $38, $12, $24, $00, $14, $33, $22, $1f, $3f, $3d, $44, $44, $44, $ff

; -----------------------------------------------------------------------------
; Message $44: Misae finds Shin-chan
; ends with control $fc before $ff
; あーっ いた いた！
; しんのすけ！
; あんた どこいってたのよ！？
Message_44_MisaeFindsShinchan::
    db $10, $7e, $22, $00, $11, $1f, $00, $11, $1f, $7d, $fe, $1b, $42, $29, $1c, $18
    db $7d, $fe, $10, $42, $1f, $00, $45, $24, $19, $11, $22, $23, $1f, $29, $3d, $7d
    db $7f, $fe, $fc, $ff

; -----------------------------------------------------------------------------
; Message $45: secret
; ないしょ
Message_45_Secret::
    db $25, $11, $1b, $3e, $ff

; -----------------------------------------------------------------------------
; Message $46: Misae angry at secret
; なにが ないしょ よ！
; ひとの き も しらないでーっ！
Message_46_MisaeAngrySecret::
    db $25, $26, $45, $15, $00, $25, $11, $1b, $3e, $00, $3d, $7d, $fe, $2b, $24, $29
    db $00, $16, $00, $33, $00, $1b, $34, $25, $11, $45, $23, $7e, $22, $7d, $ff

; -----------------------------------------------------------------------------
; Message $47: Hiroshi calms Misae
; まあ まあ
; しんのすけも グアムへ きて
; うれしかったんだよ
Message_47_HiroshiCalmsMisae::
    db $2f, $10, $00, $2f, $10, $fe, $1b, $42, $29, $1c, $18, $33, $00, $45, $52, $46
    db $6c, $2d, $00, $16, $23, $fe, $12, $37, $1b, $15, $22, $1f, $42, $45, $1f, $3d
    db $ff

; -----------------------------------------------------------------------------
; Message $48: time to go home
; [control $fc]
; さっ もう かえるじかんだ
; たのしかったか？ しんのすけ
Message_48_TimeToGoHome::
    db $fc, $1a, $22, $00, $33, $12, $00, $15, $13, $36, $45, $1b, $15, $42, $45, $1f
    db $fe, $1f, $29, $1b, $15, $22, $1f, $15, $7f, $00, $1b, $42, $29, $1c, $18, $ff

; -----------------------------------------------------------------------------
; Message $49: Shin-chan asks Misae
; うん たのしかった
; たのしかったか？ みさえ
Message_49_ShinchanAsksMisae::
    db $12, $42, $00, $1f, $29, $1b, $15, $22, $1f, $fe, $1f, $29, $1b, $15, $22, $1f
    db $15, $7f, $00, $30, $1a, $13, $ff

; -----------------------------------------------------------------------------
; Message $4A: stop imitating dad
; あーっ もお！
; パパの くちまねは
; やめなさーい！！
Message_4A_StopImitatingDad::
    db $10, $7e, $22, $00, $33, $14, $7d, $fe, $43, $65, $43, $65, $29, $00, $17, $20
    db $2f, $28, $2a, $fe, $39, $32, $25, $1a, $7e, $11, $7d, $7d, $ff

; -----------------------------------------------------------------------------
; Message $4B/$4D: press Start prompt
; スタートおせば？
Message_4B_PressStartPrompt::

; -----------------------------------------------------------------------------
; Message $4D aliases Message $4B
; スタートおせば？
Message_4D_PressStartPrompt_Alias::
    db $57, $5a, $7e, $5f, $14, $1d, $45, $2a, $7f, $ff

; -----------------------------------------------------------------------------
; Message $4E: title text
;    クレヨンしんちゃん４
;  ーオラのいたずらだいへんしんー
Message_4E_TitleText::
    db $00, $00, $00, $52, $78, $73, $7c, $1b, $42, $20, $3a, $42, $08, $fe, $00, $7e
    db $4e, $75, $29, $11, $1f, $45, $1c, $34, $45, $1f, $11, $2d, $42, $1b, $42, $7e
    db $ff

; -----------------------------------------------------------------------------
; Message $4F: credit original author
;   ゲンサク
; うすい よしと
Message_4F_CreditOriginalAuthor::
    db $00, $00, $45, $53, $7c, $55, $52, $fe, $12, $1c, $11, $00, $3d, $1b, $24, $ff

; -----------------------------------------------------------------------------
; Message $50: producer credit
; プロデューサー
; さとう つよし
Message_50_CreditProducer::
    db $43, $67, $79, $45, $5e, $72, $7e, $55, $7e, $fe, $1a, $24, $12, $00, $21, $3d
    db $1b, $ff

; -----------------------------------------------------------------------------
; Message $51: special thanks
; スペシャル サンクス
;  やすかわ たけし
;  いそがい たけお
Message_51_CreditSpecialThanks1::
    db $57, $43, $2d, $56, $70, $77, $00, $55, $7c, $52, $57, $fe, $00, $39, $1c, $15
    db $3f, $00, $1f, $18, $1b, $fe, $00, $11, $1e, $45, $15, $11, $00, $1f, $18, $14
    db $ff

; -----------------------------------------------------------------------------
; Message $52: special thanks
; スペシャル サンクス
;  まえはた ただたか
;   あらい まさゆき
Message_52_CreditSpecialThanks2::
    db $57, $43, $2d, $56, $70, $77, $00, $55, $7c, $52, $57, $fe, $00, $2f, $13, $2a
    db $1f, $00, $1f, $45, $1f, $1f, $15, $fe, $00, $00, $10, $34, $11, $00, $2f, $1a
    db $3b, $16, $ff

; -----------------------------------------------------------------------------
; Message $53: coordinator credit
; コーディネーター
;  しみちょん
Message_53_CreditCoordinator::
    db $54, $7e, $45, $5e, $49, $63, $7e, $5a, $7e, $fe, $00, $1b, $30, $20, $3e, $42
    db $ff

; -----------------------------------------------------------------------------
; Message $54: programmer credit
; プログラマー
;  はうあん
;  よしふみ
Message_54_CreditProgrammer::
    db $43, $67, $79, $45, $52, $75, $6a, $7e, $fe, $00, $2a, $12, $10, $42, $fe, $00
    db $3d, $1b, $2c, $30, $ff

; -----------------------------------------------------------------------------
; Message $55: designer credit
; デザイナー
;  かっけー
Message_55_CreditDesigner::
    db $45, $5e, $45, $55, $48, $60, $7e, $fe, $00, $15, $22, $18, $7e, $ff

; -----------------------------------------------------------------------------
; Message $56: composer credit
;    コンポーザー
; ブーイング ブー みずたに
Message_56_CreditComposer::
    db $00, $00, $00, $54, $7c, $43, $69, $7e, $45, $55, $7e, $fe, $45, $67, $7e, $48
    db $7c, $45, $52, $00, $45, $67, $7e, $00, $30, $45, $1c, $1f, $26, $ff

; -----------------------------------------------------------------------------
; Message $57: test players credit
; Some glyphs in this credit still use tentative mappings.
; テスト プレイヤーズ
;   オニキス
; ビッグメン  ばじ
Message_57_CreditTestPlayers::
    db $5e, $57, $5f, $00, $43, $67, $78, $48, $6f, $7e, $45, $57, $fe, $00, $00, $4e
    db $61, $51, $57, $fe, $4c, $5d, $45, $52, $6d, $7c, $00, $00, $45, $2a, $45, $1b
    db $ff

; -----------------------------------------------------------------------------
; Message $58: presents by
; プレゼンツ バイ
;   バンダイ
Message_58_CreditPresentsBy::
    db $43, $67, $78, $45, $58, $7c, $5c, $00, $45, $65, $48, $fe, $00, $00, $45, $65
    db $7c, $45, $5a, $48, $ff

; -----------------------------------------------------------------------------
; Message $59: ending text
; おしまい
Message_59_CreditEnd::
    db $14, $1b, $2f, $11, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff

; -----------------------------------------------------------------------------
; Message $5A: password / hard loop hint
; $06 is used here as ２.
;   「おべんきでね」
; パスワードがめんで
; うえの パスワードを
; にゅうりょくしてみよう！
; ちょっと むずかしい
; ２しゅうめ が
; はじまるゾ！
Message_5A_PasswordHardModeHint::
    db $00, $00, $68, $14, $45, $2d, $42, $16, $45, $23, $28, $71, $fe, $43, $65, $57
    db $7a, $7e, $45, $5f, $45, $15, $32, $42, $45, $23, $fe, $12, $13, $29, $00, $43
    db $65, $57, $7a, $7e, $45, $5f, $41, $fe, $26, $3c, $12, $35, $3e, $17, $1b, $23
    db $30, $3d, $12, $7d, $fe, $20, $3e, $22, $24, $00, $31, $45, $1c, $15, $1b, $11
    db $fe, $06, $1b, $3c, $12, $32, $00, $45, $15, $fe, $2a, $45, $1b, $2f, $36, $45
    db $59, $7d, $ff

    db $00, $68, $1b, $42, $20, $3a

    db $42, $1f, $10, $45, $2e, $71, $fe, $43, $65, $57, $7a, $7e, $45, $5f, $45, $15
    db $32, $42, $45, $23, $fe, $12, $13, $29, $00, $43, $65, $57, $7a, $7e, $45, $5f
    db $41, $fe, $26, $3c, $12, $35, $3e, $17, $1b, $23, $30, $3d

    db $12, $7d, $fe, $1c, $45, $19, $11, $00, $2a, $39, $1a, $29, $fe, $4e

    db $75, $45, $15, $00, $1f, $29, $1b, $32, $36, $45, $59, $7d, $ff

; -----------------------------------------------------------------------------
; Message $5D: clear congratulations
;  クリアーおめでとう！
; オラのぼうけん
; たのしんでもらえたかな？
; またオラと あそんでね！
; じゃ！
Message_5D_ClearCongratulations::
    db $00, $52, $76, $46, $7e, $14, $32, $45, $23, $24, $12, $7d, $fe, $4e, $75, $29
    db $45, $2e, $12, $18, $42

    db $fe, $1f, $29, $1b, $42, $45, $23, $33, $34, $13, $1f, $15, $25

    db $7f, $fe, $2f, $1f, $4e, $75, $24, $00, $10, $1e, $42, $45, $23, $28, $7d

    db $fe, $45, $1b, $3a, $7d, $ff

; -----------------------------------------------------------------------------
; Message $5E: tutorial move and jump
; $0F = D-pad icon, $40 = A button icon.
; {D-Pad}キーでオラを うごかして
; {A}ボタンで ジャンプ！
Message_5E_TutorialMoveAndJump::
    db $0f, $51, $7e, $45, $23, $4e, $75, $41, $00, $12, $45, $19, $15, $1b, $23, $fe
    db $40, $45, $69, $5a, $7c, $45, $23, $00, $45, $56, $70, $7c, $43, $67, $7d, $ff


; -----------------------------------------------------------------------------
; Message $5F: tutorial stomp enemies
; いじめっこたちは ふんづけて
; やっつけちゃえ！
Message_5F_TutorialStompEnemies::
    db $11, $45, $1b, $32, $22, $19, $1f, $20, $2a

    db $00, $2c, $42, $45, $21, $18, $23, $fe, $39, $22, $21, $18, $20, $3a, $13, $7d
    db $ff

; -----------------------------------------------------------------------------
; Message $60: tutorial transformation basics
; へんしんセットを とれば いろんな
; オラに へんしんするけど きほんてき
; な そうさは だいたい おなじ！
Message_60_TutorialTransformationBasics::
    db $2d, $42, $1b, $42, $58, $5d, $5f, $41, $00, $24, $37, $45, $2a, $00, $11, $38
    db $42, $25, $fe, $4e, $75, $26, $00, $2d, $42

    db $1b, $42, $1c, $36, $18, $45, $24, $00, $16, $2e, $42, $23, $16, $fe, $25, $00
    db $1e, $12, $1a, $2a, $00, $45, $1f, $11, $1f, $11, $00, $14, $25, $45, $1b, $7d
    db $ff

; -----------------------------------------------------------------------------
; Message $61: tutorial flying squirrel jump
;    「むささびしんちゃん」
; ジャンプして {A}ボタンを れんだ
; すれば そらをとべるゾ！
Message_61_TutorialFlyingSquirrelJump::
    db $00, $00, $00

    db $68, $31, $1a, $1a, $45, $2b, $1b, $42, $20, $3a

    db $42, $71, $fe, $45, $56, $70, $7c, $43, $67, $1b, $23, $00, $40, $45, $69, $5a
    db $7c, $41, $00, $37, $42, $45, $1f, $fe, $1c, $37, $45, $2a, $00, $1e, $34, $41
    db $24, $45, $2d, $36, $45, $59, $7d, $ff

; -----------------------------------------------------------------------------
; Message $62: tutorial flying squirrel attack
; $7B = B button icon.
;    「むささびしんちゃん」
; {B}ボタンで このは を なげて
; こうげきだ！
Message_62_TutorialFlyingSquirrelAttack::
    db $00, $00, $00, $68, $31, $1a, $1a, $45, $2b, $1b, $42, $20, $3a

    db $42, $71, $fe, $7b, $45

    db $69, $5a, $7c, $45, $23, $00, $19, $29, $2a, $00, $41, $00, $25, $45, $18, $23

    db $fe, $19, $12, $45, $18, $16

    db $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $63: tutorial chicken jump
;    「にわとりしんちゃん」
; いつもより たかくジャンプできるから
; たかい ばしょにも すぐとどくゾ！
Message_63_TutorialChickenJump::
    db $00, $00, $00, $68, $26, $3f, $24, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $11, $21, $33, $3d, $35, $00, $1f, $15, $17, $45

    db $56, $70

    db $7c, $43, $67, $45, $23, $16, $36, $15, $34, $fe, $1f, $15, $11, $00, $45, $2a
    db $1b, $3e, $26, $33, $00, $1c, $45, $17, $24, $45, $24, $17, $45, $59, $7d, $ff

; -----------------------------------------------------------------------------
; Message $64: tutorial chicken attack
;    「にわとりしんちゃん」
; {B}ボタンで たまごを ころがして
; こうげきだ！
Message_64_TutorialChickenAttack::
    db $00, $00, $00, $68, $26, $3f, $24, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $7b, $45, $69, $5a, $7c, $45, $23, $00, $1f, $2f, $45, $19, $41
    db $00, $19, $38, $45

    db $15, $1b, $23, $fe, $19, $12, $45, $18, $16

    db $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $65: tutorial cockroach narrow passage
;    「ごきぶりしんちゃん」
; せまくて とおれない ばしょも
; これなら だいじょうぶ！
Message_65_TutorialCockroachNarrowPassage::
    db $00, $00, $00, $68, $45, $19, $16, $45, $2c, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $1d

    db $2f, $17, $23, $00, $24, $14, $37

    db $25, $11, $00, $45, $2a, $1b, $3e, $33, $fe, $19, $37, $25, $34, $00, $45, $1f
    db $11, $45, $1b, $3e, $12, $45, $2c, $7d, $ff

; -----------------------------------------------------------------------------
; Message $66: tutorial cockroach attack
;    「ごきぶりしんちゃん」
; {B}ボタンで しょっかくを のばして
; こうげきだ！
Message_66_TutorialCockroachAttack::
    db $00, $00, $00, $68, $45, $19

    db $16, $45, $2c, $35, $1b, $42, $20, $3a

    db $42, $71, $fe, $7b, $45, $69, $5a, $7c

    db $45, $23, $00, $1b, $3e, $22, $15, $17, $41, $00, $29, $45, $2a, $1b, $23, $fe
    db $19, $12, $45, $18, $16

    db $45, $1f, $7d, $ff

; -----------------------------------------------------------------------------
; Message $67: tutorial outro
; オラのうごかしかた わかったかな？
; それでは オラの ぼうけんの
; はじまり はじまりー！
Message_67_TutorialOutro::
    db $4e, $75, $29, $12, $45, $19, $15, $1b, $15, $1f, $00, $3f, $15, $22, $1f, $15
    db $25, $7f

    db $fe, $1e, $37, $45, $23, $2a, $00

    db $4e, $75, $29, $00, $45, $2e, $12, $18, $42

    db $29, $fe, $2a, $45, $1b, $2f, $35, $00, $2a, $45, $1b, $2f, $35, $7e, $7d, $ff
    db $52, $78, $73, $7c, $1b, $42, $20, $3a

    db $42, $08, $fe, $01, $01, $4e, $75, $29, $11, $1f, $45, $1c, $34, $fe, $fc, $01
    db $01, $45, $1f, $11, $2d, $42, $1b, $42, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01

    db $fe, $01, $01, $01, $45, $53, $7c, $55, $52, $fe, $01, $12, $1c, $11, $01, $3d

    db $1b, $24, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $43, $67, $79, $45
    db $5e, $72, $7e, $55, $7e, $fe, $01, $1a, $24, $12, $01, $21, $3d, $1b, $fe, $01
    db $fe, $01, $fe, $01, $fe, $57, $43, $2d, $56, $70, $77, $01, $55, $7c, $52, $57
    db $fe, $01, $39, $1c, $15, $3f, $01, $1f, $18, $1b, $fe, $01, $11, $1e, $45, $15
    db $11, $01, $1f, $18, $14

    db $fe, $01, $2f, $13, $2a, $1f, $01, $1f, $45, $1f, $1f, $15, $fe, $01, $01, $10
    db $34, $11, $01, $2f

    db $1a, $3b, $16, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $fc, $01, $fe, $01
    db $fe, $01, $fe, $01, $fe, $01, $54, $7e, $45, $5e, $49, $63, $7e, $5a, $7e, $fe
    db $01, $01, $1b, $30, $20, $3e

    db $42, $fe, $01, $fe, $01, $fe, $fc, $01, $fe, $01, $01, $43, $67, $79, $45, $52
    db $75, $6a, $7e, $fe, $01, $01, $01, $2a, $12, $10, $42, $fe, $01, $01, $01, $3d
    db $1b, $2c

    db $30, $fe

    db $01, $fe, $01, $fe, $01, $fe, $01, $01, $45, $5e, $45, $55, $48, $60, $7e, $fe
    db $01, $01, $01, $15, $22, $18, $7e

    db $fe, $01, $fe, $01, $fe, $01, $fe, $01, $01, $54, $7c, $43, $69, $7e, $45, $55
    db $7e, $fe, $01, $45, $67, $7e, $48, $7c, $45, $52, $01, $45, $67, $7e, $fe, $01
    db $01, $01, $30, $45, $1c, $1f, $26, $fe, $01, $fe, $01, $fe, $01, $fe, $5e, $57
    db $5f, $01, $43, $67, $78, $48, $6f, $7e, $45, $57, $fe, $01, $01, $4e, $61, $51
    db $57, $fe, $01, $01, $4c, $5d, $45, $52, $6d, $7c, $fe, $01, $01, $01, $45, $2a
    db $45, $1b, $fe, $01, $fe, $01, $fe, $01, $fe, $fc, $01, $fe, $01, $fe, $01, $fe
    db $01, $fe, $01, $fe, $01, $43, $67, $78, $45, $58, $7c, $5c, $01, $45, $65, $48
    db $fe, $01, $01, $01, $45, $65, $7c, $45, $5a, $48, $fe, $01, $fe, $01

    db $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $01, $01, $14, $1b, $2f, $11, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $fe, $01, $ff

    db $fd, $58, $5d, $5f, $ff

    db $21, $45, $21, $16, $39, $36, $7f, $ff, $4e, $75, $39, $36, $45, $1e, $fe, $16
    db $3e, $12, $2a, $39, $32, $24, $17, $ff, $04, $ff

    db $05, $ff, $06, $ff, $07, $ff, $08, $ff

    db $09, $ff, $0a, $ff, $0b, $ff, $0c, $ff, $0d, $ff, $c5, $ff

    db $31, $1a, $1a, $45, $2b, $ff, $45, $19, $16, $45, $2c, $35, $ff, $26, $3f, $24

; -----------------------------------------------------------------------------
; Message VRAM/text pointer table at $5F2F
; Each message id uses two consecutive word entries: VRAM destination and text pointer.
MessageVramTextPointerTable::
    db $35, $ff

    db $00, $98, $fd, $4f

    db $a3, $98, $ff, $4f, $a3, $98, $1f, $50, $a3, $98, $3c, $50, $a3, $98, $5c, $50
    db $a3, $98, $7b, $50, $a3, $98, $96, $50, $a3, $98, $ad, $50, $a3, $98, $c8, $50
    db $44, $98, $d6, $50, $44, $98, $2f, $51, $44, $98, $81, $51, $a3, $98, $da, $51
    db $a6, $99, $f6, $51

    db $a6, $99, $19, $52, $a6, $98, $3a, $52

    db $28, $9a, $62, $52, $28, $9a, $68, $52, $28, $9a, $6b, $52, $28, $9a, $6e, $52
    db $48, $99, $71, $52, $84, $98, $77, $52, $84, $98, $85, $52, $84, $98, $95, $52
    db $84, $98, $a4, $52

    db $2c, $9a, $b3, $52, $e7, $98, $bd, $52, $e7, $98, $c5, $52

    db $83, $98, $cd, $52, $83, $98, $17, $53, $83, $98, $71, $53, $83, $98, $bb, $53

    db $42, $98, $0a, $54, $42, $98, $3e, $54, $42, $98, $84, $54, $42, $98, $b0, $54

    db $42, $98, $eb, $54, $42, $98, $07, $55, $42, $98, $21, $55, $42, $98, $26, $55
    db $42, $98, $3d, $55, $42, $98, $63, $55, $42, $98, $7f, $55, $42, $98, $99, $55
    db $42, $98, $a2, $55, $42, $98, $d4, $55, $42, $98, $f4, $55, $42, $98, $38, $56
    db $42, $98, $7b, $56, $42, $98, $aa, $56, $42, $98, $e2, $56, $47, $98, $ec, $56
    db $42, $98, $f3, $56, $42, $98, $19, $57, $42, $98, $2e, $57, $42, $98, $59, $57
    db $42, $98, $5f, $57, $42, $98, $85, $57, $42, $98, $ac, $57, $42, $98, $e1, $57

    db $42, $98, $00, $58

    db $42, $98, $1e, $58, $42, $98, $2f, $58, $42, $98, $50, $58, $42, $98, $6c, $58
    db $42, $98, $84, $58, $42, $98, $8d, $58, $42, $98, $9a, $58, $42, $98, $b9, $58
    db $42, $98, $dd, $58, $42, $98, $e2, $58, $42, $98, $01, $59, $42, $98, $22, $59
    db $42, $98, $42, $59, $42, $98, $59, $59

    db $42, $98, $76, $59

    db $e8, $9b, $71, $52, $e6, $9b, $76, $59, $42, $9c, $80, $59, $46, $9c, $a1, $59
    db $46, $9c, $b1, $59, $45, $9c, $c3, $59, $45, $9c, $e4, $59, $46, $9c, $07, $5a
    db $47, $9c, $18, $5a, $47, $9c, $2d, $5a, $44, $9c, $3b, $5a, $45, $9c, $59, $5a
    db $46, $9c, $7a, $5a, $48, $9c, $8f, $5a, $44, $98, $a6, $5a

    db $44, $98, $f9, $5a, $44, $98, $46, $5b, $41, $9c, $7d, $5b, $41, $9c, $9d, $5b
    db $41, $9c, $b7, $5b, $41, $9c, $f1, $5b, $41, $9c, $26, $5c, $41, $9c, $52, $5c
    db $41, $9c, $8d, $5c, $41, $9c, $ba, $5c, $41, $9c, $ec, $5c, $41, $9c, $1b, $5d
    db $29, $9b, $4d, $5d

    db $e6, $98, $ea, $5e

    db $a7, $98, $ef, $5e, $88, $99, $f7, $5e
MessageDynamicCharTable_60db::	
    rlca
    ld e, a

    db $09, $5f, $0b, $5f, $0d, $5f, $0f, $5f

    ld de, $135f
    ld e, a
    dec d
    ld e, a
    rla
    ld e, a
    add hl, de
    ld e, a
    dec de
    ld e, a

    db $1d, $5f, $23, $5f, $2a, $5f

    cpl
    ld e, a
    cpl
    ld e, a

    db $e9, $f8, $00, $00, $e9, $00, $01, $00, $f1, $f8, $02, $00, $f1, $00, $03, $00
    db $f9, $f9, $04, $20, $f9, $00, $04, $00, $80

    jp hl


    ld hl, sp+$05
    nop
    jp hl


    nop
    ld b, $00
    pop af
    ld hl, sp+$07
    nop
    pop af
    nop
    ld [$f900], sp
    ld hl, sp+$09
    nop
    ld sp, hl
    nop
    ld a, [bc]
    nop
    add b
    jp hl


    ld hl, sp+$05
    nop
    jp hl


    nop
    ld b, $00
    pop af
    ld hl, sp+$0b
    nop
    pop af
    nop
    ld [$f900], sp
    ld hl, sp+$09
    nop
    ld sp, hl
    nop
    ld a, [bc]
    nop
    add b

    db $e9, $f8, $0c, $00, $e9, $00, $0d, $00, $f1, $f8, $0e, $00, $f1, $00, $0f, $00
    db $f9, $f9, $04, $20, $f9, $00, $04, $00, $80, $e9, $f8, $0d, $20, $e9, $00, $0c
    db $20, $f1, $f8, $0f, $20, $f1, $00, $0e, $20, $f9, $f9, $04, $20, $f9, $00, $04
    db $00, $80, $e9, $f6, $00, $00, $e9, $fe, $01, $00, $f1, $ee, $14, $20, $f1, $f6
    db $10, $00, $f1, $fe, $11, $00, $f9, $f8, $09, $00, $f9, $ff, $1b, $20, $80, $e9
    db $f8, $0c, $00, $e9, $00, $0d, $00, $f1, $f8, $12, $00, $f1, $00, $13, $00, $f1
    db $08, $14, $00, $f9, $f7, $15, $00, $f9, $ff, $16, $00, $80, $e9, $f8, $19, $00
    db $e9, $00, $1a, $00, $f1, $f8, $17, $00, $f1, $00, $18, $00, $f0, $08, $14, $00
    db $f9, $f7, $15, $00, $f9, $ff, $16, $00, $80, $ea, $f8, $05, $00, $ea, $00, $06
    db $00, $ea, $08, $1d, $00, $f2, $f8, $1e, $00, $f2, $00, $1f, $00, $f2, $08, $20
    db $00, $fa, $f8, $21, $00, $fa, $00, $22, $00, $80, $e9, $f8, $05, $00, $e9, $00
    db $23, $00, $e8, $08, $1d, $00, $f1, $f8, $25, $00, $f1, $00, $26, $00, $f0, $08
    db $24, $00, $f9, $f8, $1b, $00, $f9, $00, $1c, $00, $80, $e9, $f8, $27, $00, $e9
    db $00, $28, $00, $f1, $f9, $29, $20, $f1, $00, $29, $00, $f9, $f9, $16, $20, $f9
    db $00, $16, $00, $80, $e9, $f8, $27, $00, $e9, $00, $28, $00, $f1, $f9, $2a, $20
    db $f1, $00, $2a, $00, $f9, $f9, $16, $20, $f9, $00, $16, $00, $80, $e9, $f8, $00
    db $00, $e9, $00, $01, $00, $f1, $f8, $2b, $00, $f1, $00, $2c, $00, $f1, $08, $2d
    db $00, $f9, $f9, $04, $20, $f9, $00, $04, $00, $80, $e9, $f8, $00, $00, $e9, $00
    db $01, $00, $f1, $f8, $2e, $00, $f1, $00, $2f, $00, $f9, $f9, $04, $20, $f9, $00
    db $04, $00, $80, $e9, $f8, $05, $00, $e9, $00, $06, $00, $f1, $f9, $30, $00, $f1
    db $01, $31, $00, $f9, $f9, $16, $20, $f9, $00, $16, $00, $80, $ea, $f8, $05, $00
    db $ea, $00, $06, $00, $f2, $f9, $30, $00, $f2, $01, $31, $00, $f9, $f9, $16, $20
    db $f9, $00, $16, $00, $80, $ea, $f8, $05, $00, $ea, $00, $06, $00, $f1, $f0, $14
    db $20, $f2, $f8, $32, $00, $f2, $00, $33, $00, $f9, $f8, $34, $00, $f9, $00, $35
    db $00, $80, $e9, $f8, $05, $00, $e9, $00, $06, $00, $f1, $f8, $36, $00, $f1, $00
    db $33, $00, $f9, $f8, $37, $00, $f9, $00, $38, $00, $80, $e9, $f8, $05, $00, $e9
    db $00, $06, $00, $f1, $f8, $39, $00, $f1, $00, $33, $00, $f9, $f8, $37, $00, $f9
    db $00, $38, $00, $80, $e9, $f8, $06, $20, $e9, $00, $05, $20, $f1, $f8, $3f, $20
    db $f1, $00, $3e, $20, $f9, $f8, $04, $20, $f9, $ff, $04, $00, $80, $e8, $f0, $3a
    db $00, $e9, $f8, $06, $20, $e9, $00, $05, $20, $f1, $f8, $3f, $20, $f1, $00, $3e
    db $20, $f9, $f8, $04, $20, $f9, $ff, $04, $00, $80, $e2, $ee, $3b, $00, $ea, $ee
    db $3c, $00, $ea, $f6, $3d, $00, $e9, $f8, $06, $20, $e9, $00, $05, $20, $f1, $f8
    db $3f, $20, $f1, $00, $3e, $20, $f9, $f8, $04, $20, $f9, $ff, $04, $00, $80, $e0
    db $f8, $61, $20, $e0, $00, $60, $20, $e7, $f3, $1d, $00, $e8, $f8, $63, $20, $e8
    db $00, $62, $20, $ef, $f3, $24, $00, $ee, $f0, $14, $20, $f0, $f8, $65, $20, $f0
    db $00, $64, $20, $f8, $f8, $67, $20, $f8, $00, $66, $20, $80, $e0, $f8, $61, $20
    db $e0, $00, $60, $20, $e8, $f8, $69, $20, $e8, $00, $68, $20, $f0, $f8, $6b, $20
    db $f0, $00, $6a, $20, $f8, $f8, $67, $20, $f8, $ff, $67, $00, $80, $e0, $f8, $61
    db $20, $e0, $00, $60, $20, $e8, $f8, $63, $20, $e8, $00, $62, $20, $f0, $f8, $65
    db $20, $f0, $00, $64, $20, $f8, $f8, $66, $20, $f8, $ff, $66, $00, $80, $e8, $f4
    db $61, $20, $e8, $fc, $60, $20, $f0, $f4, $69, $20, $f0, $fc, $68, $20, $f0, $04
    db $67, $20, $f8, $f4, $6c, $20, $f8, $fc, $6b, $20, $f8, $04, $6a, $20, $80, $e8
    db $f4, $61, $20, $e8, $fc, $60, $20, $f0, $f4, $6e, $20, $f0, $fc, $6d, $20, $f0
    db $04, $67, $20, $f8, $f4, $6c, $20, $f8, $fc, $6b, $20, $f8, $04, $6a, $20, $80
    db $e2, $f0, $66, $20, $f8, $00, $6b, $20, $f8, $f8, $6c, $20, $f0, $00, $69, $20
    db $f0, $f8, $6a, $20, $e8, $00, $67, $20, $e8, $f8, $68, $20, $e0, $00, $64, $20
    db $e0, $f8, $65, $20, $d8, $00, $62, $20, $d8, $f8, $63, $20, $d0, $00, $60, $20
    db $d0, $f8, $61, $20, $80, $d0, $fa, $6e, $20, $d0, $02, $6d, $20, $d6, $ec, $72
    db $20, $d8, $f4, $71, $20, $d8, $fc, $70, $20, $d8, $04, $6f, $20, $e0, $f4, $75
    db $20, $e0, $fc, $74, $20, $e0, $04, $73, $20, $e8, $f8, $76, $00, $e8, $00, $77
    db $00, $f0, $f5, $78, $00, $f0, $fd, $79, $00, $f0, $04, $78, $20, $f8, $f5, $7a
    db $00, $f8, $fd, $7b, $00, $f8, $04, $7a, $20, $80, $e9, $00, $77, $00, $e1, $fc
    db $74, $20, $e1, $04, $73, $20, $e9, $f8, $76, $00, $d1, $fa, $6e, $20, $d1, $02
    db $6d, $20, $d7, $ec, $72, $20, $d9, $f4, $71, $20, $d9, $fc, $70, $20, $d9, $04
    db $6f, $20, $e1, $f4, $75, $20, $f0, $fd, $79, $00, $f0, $f5, $78, $00, $f0, $04
    db $78, $20, $f8, $f5, $7a, $00, $f8, $fd, $7b, $00, $f8, $04, $7a, $20, $80, $d8
    db $04, $7c, $20, $e0, $f5, $7f, $00, $e0, $04, $7f, $20, $e0, $fc, $80, $20, $d0
    db $fa, $6e, $20, $d0, $02, $6d, $20, $d8, $f4, $7e, $20, $d8, $fc, $7d, $20, $e8
    db $f8, $81, $00, $e8, $00, $82, $00, $f0, $f5, $78, $00, $f0, $fd, $79, $00, $f0
    db $04, $78, $20, $f8, $f5, $7a, $00, $f8, $fd, $7b, $00, $f8, $04, $7a, $20, $80
    db $e1, $f0, $66, $20, $f8, $00, $6b, $20, $f8, $f8, $6c, $20, $f0, $00, $69, $20
    db $f0, $f8, $6a, $20, $e8, $00, $67, $20, $e8, $f8, $68, $20, $e0, $00, $64, $20
    db $e0, $f8, $65, $20, $d8, $00, $62, $20, $d8, $f8, $63, $20, $d0, $00, $60, $20
    db $d0, $f8, $61, $20, $80, $d0, $fd, $6d, $20, $d0, $f5, $6e, $20, $d8, $05, $6f
    db $20, $d8, $fd, $70, $20, $d8, $f5, $71, $20, $e0, $05, $72, $20, $e0, $fd, $73
    db $20, $e0, $f5, $74, $20, $e8, $05, $75, $20, $e8, $fd, $76, $20, $e8, $f5, $77
    db $20, $f0, $03, $79, $00, $f0, $fb, $78, $00, $f0, $f4, $79, $20, $f8, $03, $7b
    db $00, $f8, $fb, $7a, $00, $f8, $f4, $7b, $20, $80

    pop de
    or $6e
    jr nz, @-$2d

    cp $6d
    jr nz, @-$27

    add sp, $72
    jr nz, @-$25

    ldh a, [$ff71]
    jr nz, @-$25

    ld hl, sp+$70
    jr nz, @-$25

    nop
    ld l, a
    jr nz, @-$1d

    nop
    ld [hl], e
    jr nz, @-$1d

    ld hl, sp+$74
    jr nz, @-$1d

jr_003_65a1::
    ldh a, [$ff75]
    jr nz, @-$15

    db $fc
    ld [hl], a
    nop
    jp hl


    db $f4
    halt
    nop
    ld hl, sp+$00
    ld a, d
    jr nz, jr_003_65a1

    nop
    ld a, b
    jr nz, @-$06

    pop af
    ld a, d
    nop
    ld hl, sp-$07
    ld a, e
    nop
    ldh a, [$fff1]

jr_003_65be::
    ld a, b
    nop
    ldh a, [$fff9]

jr_003_65c2::
    ld a, c
    nop
    add b
    ldh a, [rP1]
    ld a, b
    jr nz, jr_003_65c2

    nop
    ld a, d
    jr nz, @-$06

    pop af
    ld a, d
    nop
    ld hl, sp-$07
    ld a, e
    nop
    ldh a, [$fff1]
    ld a, b
    nop
    ldh a, [$fff9]
    ld a, c
    nop
    add sp, -$0c
    add c
    nop
    add sp, -$04
    add d
    nop
    ldh [$fff1], a
    ld a, a
    nop
    ret nc

    cp $6d
    jr nz, jr_003_65be

    or $6e
    jr nz, @-$1e

    nop
    ld a, a
    jr nz, @-$1e

    ld hl, sp-$80
    jr nz, @-$26

    nop
    ld a, h
    jr nz, @-$26

    ld hl, sp+$7d
    jr nz, @-$26

    ldh a, [$ff7e]
    jr nz, @-$7e

    db $ee, $f0, $07, $00, $ea, $f8, $00, $00, $ea, $00, $01, $00, $f6, $f0, $08, $00
    db $f2, $f8, $02, $00, $f2, $00, $03, $00, $f2, $08, $04, $00, $fa, $f8, $05, $00
    db $fa, $00, $06, $00, $80, $ee, $f0, $07, $00, $ea, $f8, $00, $00, $ea, $00, $01
    db $00, $f6, $f0, $08, $00, $f2, $f8, $02, $00, $f2, $00, $03, $00, $f2, $07, $04
    db $00, $fa, $f8, $05, $00, $fa, $00, $06, $00, $80, $f8, $fc, $09, $10, $80, $ee
    db $f0, $07, $00, $ea, $f8, $00, $00, $ea, $00, $01, $00, $f6, $f0, $08, $00, $f2
    db $f8, $0b, $00, $f2, $00, $0c, $00, $fa, $f8, $0d, $00, $fa, $00, $06, $00, $80
    db $ee, $f0, $07, $00, $ea, $f8, $0a, $00, $ea, $00, $01, $00, $f6, $f0, $08, $00
    db $f2, $f8, $0e, $00, $f2, $00, $0c, $00, $fa, $f8, $05, $00, $fa, $00, $06, $00
    db $80, $ee, $f0, $07, $00, $ea, $f8, $0a, $00, $ea, $00, $01, $00, $ea, $08, $0f
    db $00, $f6, $f0, $08, $00, $f2, $f8, $0e, $00, $f2, $00, $0c, $00, $fa, $f8, $05
    db $00, $fa, $00, $06, $00, $80, $e4, $06, $10, $00, $ee, $f0, $07, $00, $ea, $f8
    db $0a, $00, $ea, $00, $01, $00, $ec, $06, $11, $00, $ec, $0e, $12, $00, $f6, $f0
    db $08, $00, $f2, $f8, $0e, $00, $f2, $00, $0c, $00, $fa, $f8, $05, $00, $fa, $00
    db $06, $00, $80

    db $ed
    ld hl, sp+$13
    nop
    db $ed
    nop
    inc d
    nop
    ldh a, [$fff0]
    rlca
    nop
    push af
    ld hl, sp+$15
    nop
    push af
    nop
    ld d, $00
    push af
    ld [$0017], sp
    ld hl, sp-$10
    ld [$fd00], sp
    ld hl, sp+$18
    nop
    db $fd
    nop
    add hl, de
    nop
    add b
    db $ed
    ld hl, sp+$13
    nop
    db $ed
    nop
    inc d
    nop
    ldh a, [$fff0]
    rlca
    nop
    push af
    ld hl, sp+$1a
    nop
    push af
    nop
    dec de
    nop
    ld hl, sp-$10
    ld [$fd00], sp
    ld hl, sp+$18
    nop
    db $fd
    nop
    inc e
    nop
    add b

    db $f0, $f4, $1f, $30, $f0, $fc, $1e, $30, $f0, $04, $1d, $30, $f8, $f4, $22, $30
    db $f8, $fc, $21, $30, $f8, $04, $20, $30, $80, $f0, $f4, $1f, $30, $f0, $fc, $24
    db $30, $f0, $04, $23, $30, $f8, $f4, $27, $30, $f8, $fc, $26, $30, $f8, $04, $25
    db $30, $80, $f0, $f4, $1f, $30, $f0, $fc, $29, $30, $f0, $04, $28, $30, $f8, $f5
    db $2c, $30, $f8, $fd, $2b, $30, $f8, $05, $2a, $30, $80

    add sp, -$05
    ld l, $30
    add sp, $03
    dec l
    jr nc, @-$0e

jr_003_6783::
    db $fc
    jr nc, @+$32

    ldh a, [rDIV]
    cpl
    jr nc, jr_003_6783

    db $fd
    ld [hl-], a
    jr nc, @-$06

    dec b
    ld sp, $8030

    db $f0, $f4, $34, $30, $f0, $fc, $33, $30, $f0, $04, $1d, $30, $f8, $f4, $36, $30
    db $f8, $fc, $35, $30, $f8, $04, $20, $30, $80, $f0, $f4, $43, $20, $f0, $fc, $42
    db $20, $f0, $04, $41, $20, $f8, $f3, $46, $20, $f8, $fb, $45, $20, $f8, $03, $44
    db $20, $80, $f0, $f4, $43, $20, $f0, $fc, $48, $20, $f0, $04, $47, $20, $f8, $f4
    db $4b, $20, $f8, $fc, $4a, $20, $f8, $04, $49, $20, $80, $f0, $f4, $43, $20, $f0
    db $fc, $4d, $20, $f0, $04, $4c, $20, $f8, $f4, $50, $20, $f8, $fc, $4f, $20, $f8
    db $04, $4e, $20, $80, $f0, $f4, $52, $20, $f0, $fc, $51, $20, $f0, $04, $41, $20
    db $f8, $f3, $54, $20, $f8, $fb, $53, $20, $f8, $03, $44, $20, $80

    ld hl, sp-$04

jr_003_6812::
    ld b, b
    jr nz, @-$7e

    add sp, -$07
    jr c, jr_003_6839

    add sp, $01
    scf
    jr nz, @-$0e

jr_003_681e::
    db $fc
    ld a, [hl-]
    jr nz, jr_003_6812

jr_003_6822::
    inc b
    add hl, sp
    jr nz, jr_003_681e

    db $fc

jr_003_6827::
    inc a
    jr nz, jr_003_6822

    inc b

jr_003_682b::
    dec sp
    jr nz, @-$7e

    add sp, -$07
    ld a, $20
    add sp, $01
    dec a
    jr nz, jr_003_6827

jr_003_6837::
    db $fc
    ccf

jr_003_6839::
    jr nz, jr_003_682b

jr_003_683b::
    inc b
    add hl, sp
    jr nz, jr_003_6837

    db $fc
    inc a
    jr nz, jr_003_683b

    inc b
    dec sp
    jr nz, @-$7e

    db $f0, $f3, $56, $20, $f0, $fb, $55, $20, $f0, $03, $5a, $20, $f8, $f4, $59, $20
    db $f8, $fc, $58, $20, $f8, $04, $57, $20, $80, $f0, $f8, $5b, $00, $f0, $00, $5c
    db $00, $f8, $f8, $5d, $00, $f8, $00, $5e, $00, $80

    db $ed
    ldh a, [rTAC]
    nop
    ld [$5ff8], a
    nop
    ld [$6000], a
    nop
    push af
    ldh a, [$ff08]
    nop
    ldh a, [c]
    ld hl, sp+$61
    nop
    ldh a, [c]
    nop
    ld h, d
    nop
    ld a, [$63f8]
    nop
    ld a, [$6400]
    nop
    add b
    ld [$67f8], a
    nop
    ld [$6800], a
    nop
    xor $f0
    ld h, l
    nop
    ldh a, [c]
    ld hl, sp+$69
    nop
    ldh a, [c]
    nop
    ld l, d
    nop
    or $f0
    ld h, [hl]
    nop
    ld a, [$6bf8]
    nop
    ld a, [$0600] ; data bytes, not a ROM0 jr_000_0600 pointer
    nop
    add b
    ld [$67f8], a
    nop
    ld [$6800], a
    nop
    ld [$0f08], a
    nop
    xor $f0
    ld h, l
    nop
    ldh a, [c]
    ld hl, sp+$69
    nop
    ldh a, [c]
    nop
    ld l, d
    nop
    or $f0
    ld h, [hl]
    nop
    ld a, [$6bf8]
    nop
    ld a, [$0600] ; data bytes, not a ROM0 jr_000_0600 pointer
    nop
    add b
    db $e4
    ld b, $10
    nop
    ld [$67f8], a
    nop
    ld [$6800], a
    nop
    db $ec
    ld b, $11
    nop
    db $ec
    ld c, $12
    nop
    xor $f0
    ld h, l
    nop
    ldh a, [c]
    ld hl, sp+$69
    nop
    ldh a, [c]
    nop
    ld l, d
    nop
    or $f0
    ld h, [hl]
    nop
    ld a, [$6bf8]
    nop
    ld a, [$0600] ; data bytes, not a ROM0 jr_000_0600 pointer
    nop
    add b

    db $dc, $00, $01, $00, $dc, $f8, $00, $00, $e4, $00, $02, $20, $e4, $f8, $02, $00
    db $ec, $f9, $03, $00, $f4, $00, $05, $00, $f4, $f8, $04, $00, $fc, $00, $07, $00
    db $fc, $f8, $06, $00, $04, $00, $09, $00, $04, $f8, $08, $00, $80, $dd, $00, $01
    db $00, $dd, $f8, $00, $00, $e5, $00, $02, $20, $e5, $f8, $02, $00, $ed, $f9, $03
    db $00, $f5, $00, $05, $00, $f5, $f8, $04, $00, $fd, $f8, $06, $00, $fd, $00, $07
    db $00, $05, $f9, $09, $20, $05, $00, $0a, $00, $80, $f4, $00, $05, $00, $f4, $f8
    db $04, $00, $fc, $00, $0c, $00, $fc, $f8, $0b, $00, $04, $f8, $0d, $00, $04, $00
    db $0e, $00, $80, $f4, $00, $05, $00, $f4, $f8, $04, $00, $fc, $00, $10, $00, $fc
    db $f8, $0f, $00, $04, $00, $12, $00, $04, $f8, $11, $00, $0c, $00, $14, $00, $0c
    db $f8, $13, $00, $14, $00, $16, $00, $14, $f8, $15, $00, $80, $dc, $eb, $17, $00
    db $e4, $eb, $19, $00, $dc, $f3, $18, $00, $e4, $f3, $1a, $00, $ec, $f8, $1b, $00
    db $f4, $00, $1d, $00, $f4, $f8, $1c, $00, $fc, $00, $1f, $00, $fc, $f8, $1e, $00
    db $04, $01, $08, $20, $04, $fd, $08, $20, $80, $dd, $f3, $18, $00, $dd, $eb, $17
    db $00, $e5, $eb, $19, $00, $e5, $f3, $1a, $00, $ed, $f8, $1b, $00, $f5, $00, $1d
    db $00, $f5, $f8, $1c, $00, $fd, $00, $1f, $00, $fd, $f8, $1e, $00, $05, $fd, $20
    db $00, $80, $ee, $18, $25, $00, $ec, $08, $21, $00, $ec, $10, $22, $00, $f4, $10
    db $24, $00, $f4, $08, $23, $00, $f5, $00, $27, $00, $f5, $f8, $26, $00, $fd, $f8
    db $28, $00, $fd, $00, $29, $00, $05, $fc, $0a, $00, $05, $00, $0a, $00, $80, $00
    db $18, $2f, $00, $00, $10, $2e, $00, $ff, $08, $2d, $00, $f7, $00, $1d, $00, $f7
    db $f8, $26, $00, $ff, $00, $2b, $00, $ff, $f8, $2a, $00, $07, $fa, $2c, $00, $80
    db $18, $00, $01, $40, $18, $f8, $00, $40, $10, $00, $02, $60, $10, $f8, $02, $40
    db $08, $f9, $03, $00, $f4, $00, $31, $00, $f4, $f8, $30, $00, $fc, $00, $33, $00
    db $fc, $f8, $32, $00, $04, $00, $35, $00, $04, $f8, $34, $00, $80, $f5, $00, $31
    db $00, $f5, $f8, $30, $00, $fd, $00, $33, $00, $fd, $f8, $32, $00, $19, $00, $01
    db $40, $19, $f8, $00, $40, $11, $00, $02, $60, $11, $f8, $02, $40, $09, $f9, $03
    db $00, $05, $f8, $36, $00, $05, $00, $37, $00, $80, $f4, $00, $31, $00, $f4, $f8
    db $30, $00, $fc, $00, $39, $00, $fc, $f8, $38, $00, $04, $00, $3b, $00, $04, $f8
    db $3a, $00, $80, $dc, $00, $15, $60, $dc, $f8, $16, $60, $e4, $00, $13, $60, $e4
    db $f8, $14, $60, $ec, $f9, $03, $00, $f4, $00, $3d, $00, $f4, $f8, $3c, $00, $fc
    db $00, $3f, $00, $fc, $f8, $3e, $00, $04, $00, $40, $00, $04, $f8, $08, $00, $80
    db $f4, $00, $41, $00, $f4, $f8, $26, $00, $fc, $00, $43, $00, $fc, $f8, $42, $00
    db $04, $f8, $44, $00, $04, $00, $45, $00, $80, $f4, $00, $3d, $00, $f4, $f8, $3c
    db $00, $fc, $00, $3f, $00, $fc, $f8, $3e, $00, $04, $00, $45, $00, $04, $f8, $44
    db $00, $80, $f4, $f9, $3d, $20, $f4, $01, $3c, $20, $fc, $f9, $3f, $20, $fc, $01
    db $3e, $20, $04, $f9, $45, $20, $04, $01, $44, $20, $80, $f4, $f9, $41, $20, $f4
    db $01, $26, $20, $fc, $f9, $43, $20, $fc, $01, $42, $20, $04, $f9, $45, $20, $04
    db $01, $44, $20, $80

    db $f4
    nop
    dec a
    nop
    db $f4
    ld hl, sp+$48
    nop
    db $fc
    nop
    ld c, d
    nop
    db $fc
    ld hl, sp+$49
    nop
    inc b
    db $fd
    ld c, l
    nop
    inc b
    ld hl, sp+$4d
    nop
    add b
    db $f4
    nop
    dec a
    nop
    db $f4
    ld hl, sp+$4c
    nop
    db $fc
    nop
    ld c, d
    nop
    db $fc
    ld hl, sp+$4b
    nop
    inc b
    db $fd
    ld c, l
    nop
    inc b
    ld hl, sp+$4d
    nop
    add b

    db $00, $00, $51, $00, $00, $f8, $50, $00, $f8, $00, $4f, $00, $f8, $f8, $4e, $00
    db $80, $fc, $00, $53, $00, $fc, $f8, $52, $00, $80, $fc, $00, $55, $00, $fc, $f8
    db $54, $00, $80, $00, $fc, $57, $00, $f8, $fc, $56, $00, $80, $00, $fc, $59, $00
    db $f8, $fc, $58, $00, $80, $fc, $00, $5b, $00, $fc, $f8, $5a, $00, $80, $fc, $00
    db $5d, $00, $f4, $00, $5e, $00, $fc, $f8, $5c, $00, $80, $f8, $00, $5f, $20, $00
    db $00, $60, $20, $00, $f8, $60, $00, $f8, $f8, $5f, $00, $80, $fa, $00, $62, $00
    db $fc, $f8, $61, $00, $80, $00, $00, $66, $00, $00, $f8, $65, $00, $f8, $00, $64
    db $00, $f8, $f8, $63, $00, $80, $f8, $ff, $63, $20, $f8, $f7, $64, $20, $00, $ff
    db $65, $20, $00, $f7, $66, $20, $80, $f8, $00, $69, $00, $00, $00, $68, $00, $00
    db $f8, $67, $00, $80, $f8, $00, $69, $00, $00, $00, $6b, $00, $00, $f8, $6a, $00
    db $80, $f4, $f8, $46, $00, $fc, $f8, $77, $00, $04, $f9, $79, $20, $f4, $00, $47
    db $00, $fc, $00, $78, $00, $04, $00, $79, $00, $80, $00, $00, $72, $00, $f8, $00
    db $71, $00, $00, $f8, $70, $00, $f8, $f8, $6f, $00, $80, $00, $00, $6e, $40, $f8
    db $00, $6e, $00, $00, $f8, $70, $00, $f8, $f8, $6f, $00, $80, $00, $00, $76, $00
    db $00, $f8, $75, $00, $f8, $00, $74, $00, $f8, $f8, $73, $00, $80, $00, $00, $6e
    db $40, $f8, $00, $6e, $00, $00, $f8, $6d, $00, $f8, $f8, $6c, $00, $80

    db $f4
    nop
    ld a, e
    nop
    db $f4
    ld hl, sp+$7a
    nop
    db $fc
    nop
    ld a, l
    nop
    db $fc
    ld hl, sp+$7c
    nop
    inc b
    ld hl, sp+$08
    nop
    inc b
    nop
    add hl, bc
    nop
    add b
    push af
    ld hl, sp+$7a
    nop
    dec b
    ld sp, hl

jr_003_6c98::
    add hl, bc
    jr nz, jr_003_6c98

    ld hl, sp+$7e
    nop
    push af
    nop
    ld a, e
    nop
    db $fd
    nop
    ld a, a
    nop
    dec b
    nop
    ld a, [bc]
    nop
    add b
    db $f4
    ld hl, sp+$7a
    nop
    db $fc
    ld hl, sp-$6d
    nop
    inc b
    db $fc
    ld [$f420], sp
    nop
    ld a, e
    nop
    db $fc
    nop
    sub h
    nop
    inc b
    nop
    ld [$8020], sp
    push af
    ld hl, sp+$7a
    nop
    push af
    nop
    ld a, e
    nop
    db $fd
    ld hl, sp+$7c
    nop
    db $fd
    nop
    ld a, a
    nop
    dec b
    db $fc
    jr nz, jr_003_6cd8

jr_003_6cd8::
    add b
    db $f4
    nop
    sub [hl]
    nop
    db $f4
    ld hl, sp-$6b
    nop
    db $fc
    nop
    sbc b
    nop
    db $fc
    ld hl, sp-$69
    nop
    inc b
    ld hl, sp+$08
    nop
    inc b
    nop
    add hl, bc
    nop
    add b
    push af
    ld hl, sp-$6b
    nop
    db $fd
    ld hl, sp-$67
    nop
    dec b
    ld sp, hl
    add hl, bc
    jr nz, @-$09

    nop
    sub [hl]
    nop
    db $fd
    nop
    sbc d
    nop
    dec b
    nop
    ld a, [bc]
    nop
    add b
    nop
    nop
    sbc [hl]
    nop
    nop
    ld hl, sp-$63
    nop
    ld hl, sp+$00
    sbc h
    nop
    ld hl, sp-$08
    sbc e
    nop
    add b
    nop
    nop
    and b
    nop
    nop
    ld hl, sp-$61
    nop
    ld hl, sp+$00
    sbc h
    nop
    ld hl, sp-$08
    sbc e
    nop
    add b
    db $f4
    nop
    and d
    nop
    db $f4
    ld hl, sp-$5f
    nop
    db $fc
    nop
    ld a, l
    nop
    db $fc
    ld hl, sp+$7c
    nop
    inc b
    nop
    add hl, bc
    nop
    inc b
    ld hl, sp+$08
    nop
    add b
    push af
    nop
    and d
    nop
    push af
    ld hl, sp-$5f
    nop
    db $fd
    ld hl, sp+$7e
    nop
    db $fd
    nop
    ld a, a
    nop
    dec b
    ld sp, hl
    add hl, bc
    jr nz, jr_003_6d60

    nop
    ld a, [bc]
    nop
    add b
    db $f4

jr_003_6d60::
    ld hl, sp-$5f
    nop
    db $f4
    nop
    and d
    nop
    db $fc
    ld hl, sp-$6d
    nop
    db $fc
    nop
    sub h
    nop
    inc b
    db $fc
    ld [$0420], sp
    nop
    ld [$8020], sp
    push af
    ld hl, sp-$5f
    nop
    push af
    nop
    and d
    nop
    db $fd
    ld hl, sp+$7c
    nop
    db $fd
    nop
    ld a, a
    nop
    dec b
    db $fc
    jr nz, jr_003_6d8c

jr_003_6d8c::
    add b
    db $f4
    nop
    and h
    nop
    db $f4
    ld hl, sp-$5d
    nop
    db $fc
    nop
    sbc b
    nop
    db $fc
    ld hl, sp-$5b
    nop
    inc b
    nop
    add hl, bc
    nop
    inc b
    ld hl, sp+$08
    nop
    add b
    push af
    ld hl, sp-$5d
    nop
    push af
    nop
    and h
    nop
    db $fd
    ld hl, sp-$5a
    nop
    db $fd
    nop
    sbc d
    nop
    dec b
    ld sp, hl
    add hl, bc
    jr nz, @+$07

    nop
    ld a, [bc]
    nop
    add b

    db $f8, $00, $51, $40, $f8, $f8, $50, $40, $00, $00, $4f, $40, $00, $f8, $4e, $40
    db $80, $f8, $fc, $57, $40, $00, $fc, $56, $40, $80, $f8, $fc, $59, $40, $00, $fc
    db $58, $40, $80, $00, $00, $5f, $60, $f8, $00, $60, $60, $f8, $f8, $60, $40, $00
    db $f8, $5f, $40, $80

    ld hl, sp+$00
    ld h, [hl]
    ld b, b
    ld hl, sp-$08
    ld h, l
    ld b, b
    nop
    nop
    ld h, h
    ld b, b
    nop
    ld hl, sp+$63
    ld b, b
    add b
    nop
    rst $38
    ld h, e
    ld h, b
    nop
    rst $30
    ld h, h
    ld h, b
    ld hl, sp-$01
    ld h, l
    ld h, b
    ld hl, sp-$09
    ld h, [hl]
    ld h, b
    add b
    db $fd
    di
    xor b
    nop
    push af
    ei
    ld h, $00
    push af
    inc bc
    and a
    nop
    db $fd
    inc bc
    xor d
    nop
    db $fd
    ei
    xor c
    nop
    dec b
    ei
    xor e
    nop
    add b
    db $fd
    db $f4
    xor b
    nop
    push af
    db $fc
    xor h
    nop
    push af
    inc b
    and a
    nop
    db $fd
    inc b
    xor d
    nop
    db $fd
    db $fc
    xor l
    nop
    dec b
    ei
    xor [hl]
    nop
    add b
    db $eb
    ld hl, sp+$00
    nop
    db $eb
    nop
    ld bc, $f300
    ld sp, hl
    ld [bc], a
    nop
    di
    ld bc, $0003
    ei
    ld hl, sp+$04
    nop
    ei
    nop
    dec b
    nop
    add b
    db $eb
    ld hl, sp+$06
    nop
    db $eb
    nop
    rlca
    nop
    di
    ld hl, sp+$08
    nop
    di
    nop

jr_003_6e6e::
    add hl, bc
    nop
    ei
    db $fc
    ld a, [bc]
    nop
    add b
    db $eb
    ld hl, sp+$06
    nop
    db $eb
    nop
    rlca
    nop
    di
    ld hl, sp+$0b
    nop
    di
    nop
    inc c
    nop
    ei
    db $fd
    dec c
    nop
    add b
    ldh a, [$fff4]
    rrca
    jr nz, @-$0e

    db $fc
    ld c, $00
    ldh a, [rDIV]
    rrca
    nop
    ld hl, sp-$0c

jr_003_6e98::
    ld de, $f820
    db $fc
    stop
    ld hl, sp+$04

jr_003_6ea0::
    ld de, $8000
    ldh a, [$fff4]
    inc de
    jr nz, jr_003_6e98

    db $fc
    ld [de], a
    nop
    ldh a, [rDIV]
    inc de
    nop
    ld hl, sp-$0c

jr_003_6eb1::
    dec d
    jr nz, @-$06

    db $fc
    inc d
    nop
    ld hl, sp+$04
    dec d
    nop
    add b
    ldh a, [$fff4]
    ld d, $20
    ldh a, [$fffc]

jr_003_6ec2::
    ld c, $00
    ldh a, [rDIV]
    ld d, $00
    ld hl, sp-$0c
    jr jr_003_6eec

    ld hl, sp-$04
    rla
    nop
    ld hl, sp+$04
    jr jr_003_6ed4

jr_003_6ed4::
    add b

jr_003_6ed5::
    db $eb
    ld hl, sp+$1a
    jr nz, @-$13

    nop
    add hl, de
    jr nz, @-$0b

    ld hl, sp+$1c
    jr nz, jr_003_6ed5

    nop
    dec de
    jr nz, @-$03

    ld hl, sp+$1e
    jr nz, @-$03

    nop

jr_003_6eeb::
    dec e

jr_003_6eec::
    jr nz, jr_003_6e6e

    db $ec

jr_003_6eef::
    ld hl, sp+$1a
    jr nz, @-$12

    nop
    add hl, de
    jr nz, jr_003_6eeb

    ld hl, sp+$20
    jr nz, jr_003_6eef

jr_003_6efb::
    nop
    rra
    jr nz, jr_003_6efb

jr_003_6eff::
    ld hl, sp+$22
    jr nz, jr_003_6eff

    nop

jr_003_6f04::
    ld hl, $8020
    db $ec

jr_003_6f08::
    ld hl, sp+$1a
    jr nz, @-$12

    nop
    add hl, de
    jr nz, jr_003_6f04

    ld hl, sp+$24
    jr nz, jr_003_6f08

jr_003_6f14::
    nop
    inc hl
    jr nz, jr_003_6f14

jr_003_6f18::
    ld hl, sp+$26
    jr nz, jr_003_6f18

    nop
    dec h
    jr nz, jr_003_6ea0

    ldh a, [$fff8]
    jr z, @+$22

    ldh a, [rP1]
    daa
    jr nz, @-$06

    ld hl, sp+$2a
    jr nz, @-$06

    nop
    add hl, hl
    jr nz, jr_003_6eb1

    ldh a, [$fff8]
    jr z, @+$22

    ldh a, [rP1]
    daa

jr_003_6f38::
    jr nz, @-$06

    ld hl, sp+$2c
    jr nz, @-$06

    nop
    dec hl
    jr nz, jr_003_6ec2

    pop af

jr_003_6f43::
    ld hl, sp+$28
    jr nz, jr_003_6f38

jr_003_6f47::
    nop
    daa
    jr nz, jr_003_6f43

    ld hl, sp+$2e
    jr nz, jr_003_6f47

    nop
    dec l
    jr nz, @-$7e

    db $e3, $f8, $30, $00, $e3, $00, $31, $00, $eb, $f8, $32, $00, $eb, $00, $33, $00
    db $f3, $f8, $34, $00, $f3, $00, $35, $00, $fb, $f8, $17, $00, $fb, $00, $18, $00
    db $80, $e4, $f8, $30, $00, $e4, $00, $31, $00, $ec, $f8, $32, $00, $ec, $00, $33
    db $00, $f4, $f8, $36, $00, $f4, $00, $37, $00, $fc, $f8, $1b, $00, $fc, $00, $1c
    db $00, $80, $e4, $f8, $30, $00, $e4, $00, $31, $00, $ec, $f8, $32, $00, $ec, $00
    db $33, $00, $f4, $f8, $36, $00, $f4, $00, $37, $00, $fc, $f8, $1f, $00, $fc, $00
    db $20, $00, $80, $eb, $f8, $13, $00, $eb, $00, $38, $00, $f3, $f8, $39, $00, $f3
    db $00, $3a, $00, $ee, $08, $3c, $00, $fb, $f9, $3b, $20, $fb, $00, $3b, $00, $80
    db $eb, $f8, $13, $00, $eb, $00, $14, $00, $ec, $05, $3d, $00, $f3, $f8, $39, $00
    db $f3, $00, $3a, $00, $fb, $f9, $3b, $20, $fb, $00, $3b, $00, $80, $eb, $f8, $13
    db $00, $eb, $00, $14, $00, $f3, $f8, $39, $00, $f3, $00, $3a, $00, $fb, $f9, $3b
    db $20, $fb, $00, $3b, $00, $80, $eb, $f8, $3e, $20, $eb, $00, $3e, $00, $f3, $f8
    db $3f, $20, $f3, $00, $3f, $00, $fb, $f8, $3b, $20, $fb, $00, $3b, $00, $80, $ec
    db $f8, $13, $00, $ec, $00, $40, $00, $f4, $f8, $41, $00, $f4, $00, $42, $00, $fc
    db $f9, $47, $20, $fc, $00, $47, $00, $80, $ec, $f8, $43, $00, $ec, $00, $44, $00
    db $f4, $f8, $45, $00, $f4, $00, $46, $00, $fc, $f9, $47, $20, $fc, $00, $47, $00
    db $80, $eb, $f8, $13, $00, $eb, $00, $14, $00, $f3, $f8, $15, $00, $f3, $00, $16
    db $00, $fb, $f8, $17, $00, $fb, $00, $18, $00, $80, $ec, $f8, $13, $00, $ec, $00
    db $14, $00, $f4, $f8, $19, $00, $f4, $00, $1a, $00, $fc, $f8, $1b, $00, $fc, $00
    db $1c, $00, $80, $ec, $f8, $13, $00, $ec, $00, $14, $00, $f4, $f8, $1d, $00, $f4
    db $00, $1e, $00, $fc, $f8, $1f, $00, $fc, $00, $20, $00, $80, $e0, $f8, $00, $00
    db $e0, $00, $01, $00, $e0, $08, $02, $00, $e8, $f0, $03, $00, $e8, $f8, $04, $00
    db $e8, $00, $05, $00, $e8, $08, $06, $00, $f0, $f7, $07, $00, $f0, $ff, $08, $00
    db $f0, $07, $09, $00, $f8, $f2, $0a, $00, $f8, $fa, $0b, $00, $f8, $02, $0c, $00
    db $80, $e1, $f7, $00, $00, $e1, $ff, $01, $00, $e1, $07, $02, $00, $e9, $ef, $0d
    db $00, $e9, $f7, $04, $00, $e9, $ff, $0e, $00, $e9, $07, $0f, $00, $f1, $f7, $07
    db $00, $f1, $ff, $10, $00, $f1, $07, $11, $00, $f9, $f2, $0a, $00, $f9, $fa, $12
    db $00, $f9, $02, $13, $00, $80, $e0, $f5, $14, $00, $e0, $fd, $15, $00, $e0, $05
    db $16, $00, $e8, $f0, $17, $00, $e8, $f8, $18, $00, $e8, $00, $19, $00, $e8, $08
    db $1a, $00, $f0, $f2, $1b, $00, $f0, $fa, $1c, $00, $f0, $02, $1d, $00, $f8, $f1
    db $1e, $00, $f8, $f9, $1f, $00, $f8, $01, $20, $00, $80, $e0, $f4, $14, $00, $e0
    db $fc, $15, $00, $e0, $04, $02, $00, $e8, $ef, $21, $00, $e8, $f7, $18, $00, $e8
    db $ff, $22, $00, $e8, $07, $23, $00, $f0, $f1, $24, $00, $f0, $f9, $1c, $00, $f0
    db $01, $25, $00, $f0, $09, $26, $00, $f8, $f0, $1e, $00, $f8, $f8, $27, $00, $f8
    db $00, $28, $00, $80, $e0, $f4, $14, $00, $e0, $fc, $15, $00, $e0, $04, $02, $00
    db $e8, $ef, $29, $00, $e8, $f7, $18, $00, $e8, $ff, $22, $00, $e8, $07, $23, $00
    db $f0, $f1, $2a, $00, $f0, $f9, $1c, $00, $f0, $01, $2b, $00, $f0, $09, $2c, $00
    db $f8, $f0, $1e, $00, $f8, $f8, $27, $00, $f8, $00, $2d, $00, $f8, $08, $2e, $00
    db $80, $e0, $f6, $2f, $00, $e0, $fe, $30, $00, $e0, $06, $31, $00, $e8, $f6, $32
    db $00, $e8, $fe, $33, $00, $e8, $06, $34, $00, $f2, $f0, $39, $00, $f0, $f8, $35
    db $00, $f0, $00, $36, $00, $f8, $f8, $37, $00, $f8, $00, $38, $00, $80, $e0, $f3
    db $3b, $20, $e0, $fb, $3a, $20, $e0, $01, $3a, $00, $e0, $09, $3b, $00, $e8, $f1
    db $3c, $00, $e8, $f9, $3d, $00, $e8, $01, $3e, $00, $e8, $09, $3f, $00, $f0, $f1
    db $40, $00, $f0, $f9, $41, $00, $f0, $01, $42, $00, $f0, $09, $43, $00, $f8, $f1
    db $44, $00, $f8, $f9, $45, $00, $f8, $01, $46, $00, $80, $e0, $f3, $3b, $20, $e0
    db $fb, $3a, $20, $e0, $01, $3a, $00, $e0, $09, $3b, $00, $e8, $f1, $47, $00, $e8
    db $f9, $3d, $00, $e8, $01, $3e, $00, $e8, $09, $48, $00, $f0, $f1, $49, $00, $f0
    db $f9, $4a, $00, $f0, $01, $42, $00, $f0, $09, $4b, $00, $f8, $f1, $4c, $00, $f8
    db $f9, $45, $00, $f8, $01, $46, $00, $80, $e1, $f2, $2f, $00, $e1, $fa, $4d, $00
    db $e1, $02, $4e, $00, $e9, $f2, $4f, $00, $e9, $fa, $50, $00, $e9, $02, $51, $00
    db $f1, $ee, $52, $00, $f1, $f6, $53, $00, $f1, $fe, $54, $00, $f9, $ee, $55, $00
    db $f9, $f6, $56, $00, $f9, $fe, $57, $00, $80, $e0, $f8, $58, $00, $e0, $00, $59
    db $00, $e2, $08, $5a, $00, $e8, $f0, $5b, $00, $e8, $f8, $5c, $00, $e8, $00, $5d
    db $00, $ea, $08, $5e, $00, $f0, $f0, $5f, $00, $f0, $f8, $60, $00, $f0, $00, $61
    db $00, $f8, $f0, $62, $00, $f8, $f8, $63, $00, $f8, $00, $64, $00, $80, $e0, $f8
    db $65, $00, $e0, $00, $66, $00, $e2, $08, $67, $00, $e8, $f0, $5b, $00, $e8, $f8
    db $68, $00, $e8, $00, $69, $00, $ea, $08, $6a, $00, $f0, $f0, $5f, $00, $f0, $f8
    db $6b, $00, $f0, $00, $6c, $00, $f8, $f0, $62, $00, $f8, $f8, $63, $00, $f8, $00
    db $64, $00, $80, $e1, $f8, $02, $20, $e1, $00, $15, $20, $e1, $08, $14, $20, $e9
    db $f5, $6d, $00, $e9, $fd, $6e, $00, $e9, $05, $18, $20, $e9, $0d, $6f, $00, $f1
    db $f3, $70, $00, $f1, $fb, $71, $00, $f1, $03, $72, $00, $f9, $fb, $73, $00, $f9
    db $03, $74, $00, $80, $e8, $f4, $75, $00, $e8, $fc, $76, $00, $e8, $04, $77, $00
    db $f0, $f4, $78, $00, $f0, $fc, $79, $00, $f0, $04, $7a, $00, $f8, $f7, $7b, $00
    db $f8, $ff, $7c, $00, $80, $e8, $f4, $7d, $00, $ea, $fc, $76, $00, $e8, $04, $7e
    db $00, $f0, $f5, $80, $20, $f0, $fc, $7f, $00, $f0, $04, $80, $00, $f8, $f4, $81
    db $00, $f8, $fc, $82, $00, $f8, $04, $83, $00, $80, $e0, $f0, $00, $00, $e0, $f8
    db $01, $00, $e0, $00, $02, $00, $e0, $08, $03, $00, $e8, $f0, $04, $00, $e8, $f8
    db $05, $00, $e8, $00, $06, $00, $e8, $08, $07, $00, $f0, $f5, $08, $00, $f0, $fd
    db $09, $00, $f0, $05, $0a, $00, $f8, $f7, $0b, $00, $f8, $ff, $0c, $00, $f8, $07
    db $0d, $00, $80, $e0, $f0, $00, $00, $e0, $f8, $01, $00, $e0, $00, $02, $00, $e0
    db $08, $03, $00, $e8, $f0, $0e, $00, $e8, $f8, $0f, $00, $e8, $00, $06, $00, $e8
    db $08, $07, $00, $f0, $f5, $10, $00, $f0, $fd, $11, $00, $f0, $05, $12, $00, $f8
    db $f1, $13, $00, $f8, $f9, $14, $00, $f8, $01, $15, $00, $80, $e0, $f0, $00, $00
    db $e0, $f8, $01, $00, $e0, $00, $02, $00, $e0, $08, $03, $00, $e8, $f0, $17, $00
    db $e8, $f8, $05, $00, $e8, $00, $18, $00, $e8, $08, $07, $00, $f0, $f0, $19, $00
    db $f0, $f8, $1a, $00, $f0, $00, $1b, $00, $f0, $08, $1c, $00, $f8, $f8, $1d, $00
    db $f8, $00, $1e, $00, $f8, $08, $1f, $00, $80, $e8, $fc, $20, $00, $e8, $04, $21
    db $00, $f0, $ec, $22, $00, $f0, $f4, $23, $00, $f0, $fc, $24, $00, $f0, $04, $25
    db $00, $f0, $0c, $26, $00, $f8, $ec, $27, $00, $f8, $f4, $28, $00, $f8, $fc, $29
    db $00, $f8, $04, $2a, $00, $f8, $0c, $2b, $00, $80, $e8, $fc, $20, $00, $e8, $04
    db $21, $00, $f0, $ec, $22, $00, $f0, $f4, $23, $00, $f0, $fc, $24, $00, $f0, $04
    db $25, $00, $f0, $0c, $26, $00, $f8, $ec, $27, $00, $f8, $f4, $2c, $00, $f8, $fc
    db $2d, $00, $f8, $04, $2e, $00, $f8, $0c, $2f, $00, $80, $e8, $fc, $20, $00, $e8
    db $04, $21, $00, $f0, $ec, $22, $00, $f0, $f4, $23, $00, $f0, $fc, $24, $00, $f0
    db $04, $25, $00, $f0, $0c, $26, $00, $f8, $ec, $27, $00, $f8, $f4, $30, $00, $f8
    db $fc, $31, $00, $f8, $04, $32, $00, $f8, $0c, $33, $00, $80, $e0, $f3, $34, $00
    db $e0, $fb, $35, $00, $e0, $03, $36, $00, $e0, $0b, $37, $00, $e8, $f3, $38, $00
    db $e8, $fb, $39, $00, $e8, $03, $3a, $00, $e8, $0b, $3b, $00, $e8, $13, $3c, $00
    db $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $3f, $00, $f0, $0f, $40, $00
    db $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80, $e0, $f3, $34
    db $00, $e0, $fb, $35, $00, $e0, $03, $36, $00, $e0, $0b, $37, $00, $e8, $f3, $38
    db $00, $e8, $fb, $39, $00, $e8, $03, $3a, $00, $e8, $0b, $43, $00, $e8, $13, $3c
    db $00, $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $3f, $00, $f0, $0f, $40
    db $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80, $e0, $f3
    db $34, $00, $e0, $fb, $35, $00, $e0, $03, $36, $00, $e0, $0b, $37, $00, $e8, $f3
    db $38, $00, $e8, $fb, $39, $00, $e8, $03, $44, $00, $e8, $0b, $45, $00, $e8, $13
    db $3c, $00, $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $3f, $00, $f0, $0f
    db $40, $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80, $e1
    db $f3, $34, $00, $e1, $fb, $35, $00, $e1, $03, $36, $00, $e1, $0b, $37, $00, $e9
    db $f3, $38, $00, $e9, $fb, $39, $00, $e8, $03, $46, $00, $e8, $0b, $47, $00, $e8
    db $13, $3c, $00, $f0, $f7, $3d, $00, $f0, $ff, $3e, $00, $f0, $07, $48, $00, $f0
    db $0f, $40, $00, $f8, $f7, $0b, $00, $f8, $ff, $41, $00, $f8, $07, $42, $00, $80
    db $e8, $f4, $49, $00, $e8, $fc, $4a, $00, $e8, $04, $4b, $00, $f0, $f4, $4c, $00
    db $f0, $fc, $4d, $00, $f0, $04, $4e, $00, $f8, $f6, $4f, $00, $f8, $fe, $50, $00
    db $80, $e8, $f4, $51, $00, $e8, $03, $52, $00, $f0, $ec, $53, $00, $f0, $f4, $54
    db $00, $f0, $fc, $55, $00, $f0, $04, $56, $00, $f8, $f4, $57, $00, $f8, $fc, $58
    db $00, $f8, $04, $59, $00, $80, $e8, $f4, $5a, $00, $e8, $fc, $5b, $00, $e8, $04
    db $5c, $00, $f0, $f4, $69, $00, $f0, $fc, $5d, $00, $f0, $04, $5e, $00, $f8, $f7
    db $5f, $00, $f8, $ff, $60, $00, $80, $e8, $f5, $61, $00, $e8, $fd, $62, $00, $e8
    db $05, $63, $00, $f0, $f5, $64, $00, $f0, $fd, $65, $00, $f0, $05, $66, $00, $f8
    db $f7, $67, $00, $f8, $ff, $68, $00, $80, $e8, $f5, $63, $20, $e8, $fd, $62, $20
    db $e8, $05, $61, $20, $f0, $f5, $66, $20, $f0, $fd, $65, $20, $f0, $05, $64, $20
    db $f8, $f7, $67, $00, $f8, $ff, $68, $00, $80

    add sp, -$0c
    ld l, d
    nop
    add sp, -$04
    ld l, e
    nop
    add sp, $04
    ld l, h
    nop
    ldh a, [$fffc]
    ld l, l
    nop
    ld hl, sp-$0c
    ld l, h
    ld h, b
    ld hl, sp-$04
    ld l, e
    ld h, b
    ld hl, sp+$04
    ld l, d
    ld h, b
    add b
    ldh a, [$fff4]
    ld [hl], b
    nop
    ldh a, [$fffc]
    ld [hl], c
    nop
    ldh a, [rDIV]
    ld [hl], d
    nop
    ld hl, sp-$0c
    ld [hl], d
    ld h, b
    ld hl, sp-$04
    ld [hl], c
    ld h, b
    ld hl, sp+$04
    ld [hl], b
    ld h, b
    add b

    db $f0, $f8, $73, $00, $f0, $00, $74, $00, $f8, $f8, $75, $00, $f8, $00, $76, $00
    db $80, $e5, $f8, $77, $20, $e5, $00, $77, $00, $ed, $f8, $78, $20, $ed, $00, $78
    db $00, $f8, $f8, $79, $20, $f8, $00, $79, $00, $80, $f0, $f8, $6e, $20, $f0, $00
    db $6e, $00, $f8, $f8, $6f, $20, $f8, $00, $6f, $00, $80

    ldh [$fff0], a
    nop
    nop
    ldh [$fff8], a
    ld bc, $e000
    nop
    ld [bc], a
    nop
    ldh [$ff08], a
    inc bc
    nop
    add sp, -$15
    ld a, d
    nop
    add sp, -$0d
    ld a, e
    nop
    add sp, -$05
    ld a, h
    nop
    add sp, $03
    ld a, l
    nop
    add sp, $0b
    ld a, [hl]
    nop
    ldh a, [$fff3]
    ld a, a
    nop
    ldh a, [$fffb]
    cp h
    nop
    ldh a, [$ff03]
    cp l
    nop
    ldh a, [$ff0b]
    cp [hl]
    nop
    ld hl, sp-$09
    dec bc
    nop
    ld hl, sp-$01
    ld b, c
    nop
    ld hl, sp+$07
    cp a
    nop
    add b

    db $ff, $10, $db, $20, $ff, $e8, $db, $00, $f8, $08, $cf, $00, $f8, $00, $ce, $00
    db $f8, $f8, $cd, $00, $f8, $f0, $cc, $00, $f0, $08, $cb, $00, $f0, $00, $ca, $00
    db $f0, $f8, $c9, $00, $f0, $f0, $c8, $00, $80, $d0, $f8, $b3, $00, $d0, $e8, $b1
    db $00, $d0, $e0, $b0, $00, $c8, $10, $a6, $00, $c8, $08, $a5, $00, $c8, $00, $a4
    db $00, $d0, $18, $b7, $00, $d0, $10, $b6, $00, $d0, $08, $b5, $00, $d0, $00, $b4
    db $00, $d0, $f8, $b3, $00, $d8, $18, $c7, $00, $d8, $10, $c6, $00, $d8, $08, $c5
    db $00, $d8, $00, $c4, $00, $d8, $f8, $c3, $00, $d8, $f0, $c2, $00, $d8, $e8, $c1
    db $00, $d8, $e0, $c0, $00, $e0, $18, $ad, $00, $e0, $10, $ac, $00, $e0, $08, $ab
    db $00, $e0, $00, $aa, $00, $e0, $f8, $a9, $00, $e0, $f0, $a8, $00, $e8, $10, $bc
    db $00, $e8, $08, $bb, $00, $e8, $00, $ba, $00, $e8, $f8, $b9, $00, $e8, $f0, $b8
    db $00, $f0, $f8, $a3, $00, $f0, $f0, $a2, $00, $f0, $00, $a7, $00, $f0, $10, $af
    db $00, $f0, $08, $ae, $00, $f8, $10, $bf, $00, $f8, $08, $be, $00, $f8, $00, $bd
    db $00, $f8, $f8, $b2, $00, $80, $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8
    db $03, $20, $f4, $00, $02, $20, $fc, $fb, $04, $20, $80, $ed, $f8, $01, $20, $ed
    db $00, $00, $20, $f5, $f8, $06, $20, $f5, $00, $05, $20, $fd, $f8, $08, $20, $fd
    db $00, $07, $20, $80, $ed, $f8, $01, $20, $ed, $00, $00, $20, $f5, $f8, $0a, $20
    db $f5, $00, $09, $20, $fd, $f8, $0c, $20, $fd, $00, $0b, $20, $80, $ec, $f8, $01
    db $20, $ec, $00, $00, $20, $f4, $f8, $11, $20, $f4, $00, $10, $20, $fc, $f8, $0f
    db $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8
    db $0e, $20, $f4, $00, $10, $20, $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80, $ec
    db $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8, $0e, $20, $f4, $00, $0d, $20, $fc
    db $f8, $0f, $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $01, $20, $ec, $00, $00, $20
    db $f4, $f8, $11, $20, $f4, $00, $0d, $20, $fc, $f8, $0f, $20, $fc, $ff, $0f, $00
    db $80, $ec, $f8, $13, $20, $ec, $00, $12, $20, $f4, $f8, $15, $20, $f4, $00, $14
    db $20, $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $13, $20, $ec, $00
    db $12, $20, $f4, $f0, $17, $20, $f4, $f8, $16, $20, $f4, $00, $14, $20, $fc, $f8
    db $18, $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4
    db $f0, $1a, $20, $f4, $f8, $19, $20, $f4, $00, $10, $20, $fc, $f0, $1b, $20, $fc
    db $f8, $0f, $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $01, $20, $ec, $00, $00, $20
    db $f4, $f0, $1a, $20, $f4, $f8, $1d, $20, $f4, $00, $1c, $20, $fc, $f0, $1b, $20
    db $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $01, $20, $ec, $00, $00
    db $20, $f4, $f0, $1a, $20, $f4, $f8, $19, $20, $f4, $00, $1c, $20, $fc, $f0, $1b
    db $20, $fc, $f8, $0f, $20, $fc, $ff, $0f, $00, $80, $ec, $f8, $01, $20, $ec, $00
    db $00, $20, $f4, $f8, $1f, $20, $f4, $00, $1e, $20, $fc, $f8, $21, $20, $fc, $00
    db $20, $20, $80, $ed, $f8, $01, $20, $ed, $00, $00, $20, $f5, $f8, $1f, $20, $f5
    db $00, $1e, $20, $fd, $f8, $22, $20, $fd, $00, $07, $20, $80, $ed, $f8, $01, $20
    db $ed, $00, $00, $20, $f5, $f8, $1f, $20, $f5, $00, $1e, $20, $fd, $f8, $23, $20
    db $fd, $00, $0b, $20, $80, $ec, $f8, $01, $20, $ec, $00, $00, $20, $f4, $f8, $43
    db $20, $f4, $00, $42, $20, $fc, $f8, $21, $20, $fc, $00, $20, $20, $80, $ec, $f8
    db $01, $20, $ec, $00, $00, $20, $f4, $f8, $2c, $20, $f4, $00, $42, $20, $fc, $f8
    db $21, $20, $fc, $00, $20, $20, $80, $ec, $f8, $24, $00, $ec, $00, $25, $00, $f4
    db $f8, $10, $00, $f4, $00, $11, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80
    db $ec, $f8, $2d, $00, $ec, $00, $2e, $00, $f4, $f8, $2f, $00, $f4, $00, $30, $00
    db $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80, $ec, $f8, $24, $00, $ec, $00, $25
    db $00, $f4, $f8, $02, $00, $f4, $00, $03, $00, $fc, $fd, $04, $00, $80, $ed, $f8
    db $24, $00, $ed, $00, $25, $00, $f5, $f8, $05, $00, $f5, $00, $06, $00, $fd, $f8
    db $07, $00, $fd, $00, $08, $00, $80, $ed, $f8, $24, $00, $ed, $00, $25, $00, $f5
    db $f8, $09, $00, $f5, $00, $0a, $00, $fd, $f8, $0b, $00, $fd, $00, $0c, $00, $80
    db $ec, $f8, $25, $20, $ec, $00, $24, $20, $f4, $f8, $27, $20, $f4, $00, $26, $20
    db $fa, $f0, $28, $40, $fc, $f8, $21, $20, $fc, $00, $29, $20, $80, $ed, $f8, $25
    db $20, $ed, $00, $24, $20, $f5, $f8, $27, $20, $f5, $00, $26, $20, $fb, $f0, $28
    db $40, $fd, $f8, $22, $20, $fd, $00, $2a, $20, $80, $ed, $f8, $25, $20, $ed, $00
    db $24, $20, $f5, $f8, $27, $20, $f5, $00, $26, $20, $fb, $f0, $28, $40, $fd, $f8
    db $23, $20, $fd, $00, $2b, $20, $80, $ec, $f8, $25, $20, $ec, $00, $24, $20, $f4
    db $f8, $27, $20, $f4, $00, $1e, $20, $fa, $f0, $28, $40, $fc, $f8, $21, $20, $fc
    db $00, $20, $20, $80, $ed, $f8, $25, $20, $ed, $00, $24, $20, $f5, $f8, $27, $20
    db $f5, $00, $1e, $20, $fb, $f0, $28, $40, $fd, $f8, $22, $20, $fd, $00, $07, $20
    db $80, $ed, $f8, $25, $20, $ed, $00, $24, $20, $f5, $f8, $27, $20, $f5, $00, $1e
    db $20, $fb, $f0, $28, $40, $fd, $f8, $23, $20, $fd, $00, $0b, $20, $80, $e4, $f8
    db $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00, $f4, $f8
    db $35, $00, $f4, $00, $36, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80, $e4
    db $f8, $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00, $f4
    db $f8, $37, $00, $f4, $00, $36, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80
    db $e4, $f8, $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34, $00
    db $f4, $f8, $38, $00, $f4, $00, $36, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00
    db $80, $e4, $f8, $31, $00, $e4, $00, $32, $00, $ec, $f8, $33, $00, $ec, $00, $34
    db $00, $f4, $f8, $39, $00, $f4, $00, $3a, $00, $fc, $fc, $04, $00, $80, $e5, $f8
    db $31, $00, $e5, $00, $32, $00, $ed, $f8, $33, $00, $ed, $00, $34, $00, $f5, $f8
    db $3b, $00, $f5, $00, $3c, $00, $fd, $f8, $07, $00, $fd, $00, $08, $00, $80, $e5
    db $f8, $31, $00, $e5, $00, $32, $00, $ed, $f8, $33, $00, $ed, $00, $34, $00, $f5
    db $f8, $3d, $00, $f5, $00, $3e, $00, $fd, $f8, $0b, $00, $fd, $00, $0c, $00, $80
    db $e4, $f8, $32, $20, $e4, $00, $31, $20, $ec, $f8, $34, $20, $ec, $00, $33, $20
    db $f2, $f0, $5c, $00, $f4, $f8, $40, $20, $f4, $00, $3f, $20, $fc, $f0, $5c, $40
    db $fc, $f8, $21, $20, $fc, $00, $29, $20, $80, $e5, $f8, $32, $20, $e5, $00, $31
    db $20, $ed, $f8, $34, $20, $ed, $00, $33, $20, $f3, $f0, $5c, $00, $f5, $f8, $40
    db $20, $f5, $00, $3f, $20, $fd, $f0, $5c, $40, $fd, $f8, $22, $20, $fd, $00, $2a
    db $20, $80, $e5, $f8, $32, $20, $e5, $00, $31, $20, $ed, $f8, $34, $20, $ed, $00
    db $33, $20, $f3, $f0, $5c, $00, $f5, $f8, $40, $20, $f5, $00, $3f, $20, $fd, $f0
    db $5c, $40, $fd, $f8, $23, $20, $fd, $00, $2b, $20, $80, $e4, $f8, $32, $20, $e4
    db $00, $31, $20, $ec, $f8, $34, $20, $ec, $00, $33, $20, $f2, $f0, $5c, $00, $f4
    db $f8, $40, $20, $f4, $00, $41, $20, $fc, $f0, $5c, $40, $fc, $f8, $21, $20, $fc
    db $00, $20, $20, $80, $e5, $f8, $32, $20, $e5, $00, $31, $20, $ed, $f8, $34, $20
    db $ed, $00, $33, $20, $f3, $f0, $5c, $00, $f5, $f8, $40, $20, $f5, $00, $41, $20
    db $fd, $f0, $5c, $40, $fd, $f8, $22, $20, $fd, $00, $07, $20, $80, $e5, $f8, $32
    db $20, $e5, $00, $31, $20, $ed, $f8, $34, $20, $ed, $00, $33, $20, $f3, $f0, $5c
    db $00, $f5, $f8, $40, $20, $f5, $00, $41, $20, $fd, $f0, $5c, $40, $fd, $f8, $23
    db $20, $fd, $00, $0b, $20, $80, $e4, $fb, $44, $00, $ec, $f8, $45, $00, $ec, $00
    db $46, $00, $f4, $f8, $47, $00, $f4, $00, $48, $00, $fc, $f9, $0f, $20, $fc, $00
    db $0f, $00, $80, $e4, $fb, $44, $00, $ec, $f8, $49, $00, $ec, $00, $4a, $00, $f4
    db $f8, $4b, $00, $f4, $00, $4c, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00, $80
    db $e4, $fe, $53, $00, $ec, $f8, $4d, $00, $ec, $00, $4e, $00, $f4, $f8, $47, $00
    db $f4, $00, $4f, $00, $f2, $08, $50, $00, $fc, $f9, $0f, $20, $fc, $00, $0f, $00
    db $80, $e4, $fb, $44, $00, $ec, $f8, $51, $00, $ec, $00, $52, $00, $f4, $f8, $47
    db $00, $f4, $00, $4f, $00, $f2, $08, $50, $00, $fc, $f9, $0f, $20, $fc, $00, $0f
    db $00, $80, $e4, $fb, $44, $00, $ec, $f8, $45, $00, $ec, $00, $46, $00, $f4, $f8
    db $54, $00, $f4, $00, $55, $00, $fc, $fc, $04, $00, $80, $e5, $fb, $44, $00, $ed
    db $f8, $45, $00, $ed, $00, $46, $00, $f5, $f8, $56, $00, $f5, $00, $57, $00, $fd
    db $f8, $07, $00, $fd, $00, $08, $00, $80, $e5, $fb, $44, $00, $ed, $f8, $45, $00
    db $ed, $00, $46, $00, $f5, $f8, $58, $00, $f5, $00, $59, $00, $fd, $f8, $0b, $00
    db $fd, $00, $0c, $00, $80, $e4, $fb, $44, $00, $ec, $f8, $46, $20, $ec, $00, $45
    db $20, $f4, $f0, $28, $00, $f4, $f8, $5b, $20, $f4, $00, $5a, $20, $fc, $f8, $21
    db $20, $fc, $00, $29, $20, $80, $e5, $fb, $44, $00, $ed, $f8, $46, $20, $ed, $00
    db $45, $20, $f5, $f0, $28, $00, $f5, $f8, $5b, $20, $f5, $00, $5a, $20, $fd, $f8
    db $22, $20, $fd, $00, $2a, $20, $80, $e5, $fb, $44, $00, $ed, $f8, $46, $20, $ed
    db $00, $45, $20, $f5, $f0, $28, $00, $f5, $f8, $5b, $20, $f5, $00, $5a, $20, $fd
    db $f8, $23, $20, $fd, $00, $2b, $20, $80

    ldh [$fff5], a
    nop
    add b
    ldh [$fffd], a
    ld bc, $e080
    dec b
    ld [bc], a
    add b
    add sp, -$10
    inc bc
    add b
    add sp, -$08
    inc b
    add b
    add sp, $00
    dec b
    add b
    add sp, $08
    ld b, $80
    ldh a, [$fff1]
    rlca
    add b
    ldh a, [$fff9]

jr_003_7dc8::
    ld [$f080], sp
    ld bc, $8009
    ld hl, sp-$10
    ld a, [bc]
    add b
    ld hl, sp-$08
    dec bc
    add b
    ld hl, sp+$00
    inc c
    add b
    add b
    pop hl
    push af
    nop
    add b
    pop hl
    db $fd
    ld bc, $e180
    dec b
    ld [bc], a
    add b
    jp hl


    ldh a, [$ff03]
    add b
    jp hl


    ld hl, sp+$04
    add b
    jp hl


    nop
    dec b
    add b
    jp hl


    ld [$8006], sp
    pop af
    pop af
    dec c
    add b
    pop af
    ld sp, hl
    ld [$f180], sp
    ld bc, $800e
    pop af
    add hl, bc
    rrca
    add b
    ld sp, hl
    rst $30
    db $10
    add b
    ld sp, hl
    rst $38
    ld de, $f980
    rlca
    ld [de], a
    add b
    add b
    pop hl
    push af
    nop
    add b
    pop hl
    db $fd
    ld bc, $e180
    dec b
    ld [bc], a
    add b
    jp hl


    ldh a, [$ff03]
    add b
    jp hl


    ld hl, sp+$04
    add b
    jp hl


    nop
    dec b
    add b
    jp hl


    ld [$8006], sp
    pop af
    ldh a, [rNR13]
    add b
    pop af
    ld hl, sp+$14
    add b
    pop af
    nop
    dec d
    add b
    ld sp, hl
    ldh a, [rNR21]
    add b
    ld sp, hl
    ld hl, sp+$17
    add b
    ld sp, hl
    nop
    jr jr_003_7dc8

    add b
    call c, $00f5
    add b
    call c, $01fd
    add b
    call c, $0205
    add b
    db $e4
    ldh a, [$ff03]
    add b
    db $e4
    ld hl, sp+$04
    add b
    db $e4
    nop
    dec b
    add b
    db $e4
    ld [$8006], sp
    db $ec
    ldh a, [rNR24]
    add b
    db $ec
    ld hl, sp+$1a
    add b
    db $ec
    nop
    dec de
    add b
    db $ec
    ld [$801c], sp
    db $f4
    ldh a, [rNR33]
    add b
    db $f4
    ld hl, sp+$1e
    add b
    db $f4
    nop
    rra
    add b
    db $f4
    ld [$8020], sp
    db $fc
    pop af
    ld hl, $fc80
    ld sp, hl
    ld [hl+], a
    add b
    db $fc
    ld bc, $8023
    add b
    db $db
    push af
    nop
    add b
    db $db
    db $fd
    ld bc, $db80
    dec b
    ld [bc], a
    add b
    db $e3
    ldh a, [$ff03]
    add b
    db $e3
    ld hl, sp+$04
    add b
    db $e3
    nop

jr_003_7ea8::
    dec b
    add b
    db $e3
    ld [$8006], sp
    db $eb
    ldh a, [rNR50]
    add b
    db $eb
    ld hl, sp+$25
    add b
    db $eb
    nop
    ld h, $80
    db $eb
    ld [$8027], sp
    di
    ldh a, [$ff28]
    add b
    di
    ld hl, sp+$29
    add b
    di
    nop
    ld a, [hl+]

Jump_003_7ec9::
    add b
    di
    ld [$802b], sp
    ei
    di
    inc l
    add b
    ei
    ei
    dec l
    add b
    ei
    inc bc
    ld l, $80
    add b
    jp c, $00f5

    add b
    jp c, $01fd

    add b
    jp c, $0205

    add b
    ldh [c], a
    ldh a, [$ff03]
    add b
    ldh [c], a
    ld hl, sp+$04
    add b
    ldh [c], a
    nop
    dec b
    add b
    ldh [c], a
    ld [$8006], sp
    ld [$24f0], a
    add b
    ld [$25f8], a
    add b
    ld [$2600], a
    add b
    ld [$2708], a
    add b
    ldh a, [c]
    ldh a, [$ff28]
    add b
    ldh a, [c]
    ld hl, sp+$29
    add b
    ldh a, [c]
    nop
    cpl
    add b
    ldh a, [c]
    ld [$8030], sp
    ld a, [$31f3]
    add b
    ld a, [$32fb]
    add b
    ld a, [$3303]
    add b
    add b
    jp hl


    inc b
    jr c, jr_003_7ea8

    db $ed
    db $f4
    inc [hl]
    add b
    xor $fc
    dec [hl]
    add b
    pop af
    inc b
    add hl, sp
    add b
    push af
    db $f4
    ld [hl], $80
    or $fc
    scf
    add b
    ld sp, hl
    inc b
    ld a, [hl-]
    add b
    add b
    add sp, -$04
    dec a
    add b
    add sp, $04
    ld b, b
    add b
    rst $28
    db $f4
    dec sp
    add b
    ldh a, [$fffc]
    ld a, $80
    ldh a, [rDIV]
    ld b, c
    add b
    rst $30
    db $f4
    inc a
    add b
    ld hl, sp-$04
    ccf
    add b
    ld hl, sp+$04
    ld b, d
    add b
    add b
    add sp, -$04
    ld b, l
    add b
    add sp, $04
    ld c, b
    add b
    xor $f4
    ld b, e
    add b
    ldh a, [$fffc]
    ld b, [hl]
    add b
    ldh a, [rDIV]
    ld c, c
    add b
    rst $28
    inc c
    ld c, e
    add b
    or $f4
    ld b, h
    add b
    ld hl, sp-$04
    ld b, a
    add b
    ld hl, sp+$04
    ld c, d
    add b
    add b
    ld hl, sp-$04
    ld c, h
    add b
    add b
    ld hl, sp-$04
    ld c, l
    add b
    ld hl, sp+$04
    ld c, [hl]
    add b
    add b
    ld hl, sp-$04
    ld c, a
    add b
    ld hl, sp+$04
    ld d, b
    add b
    add b
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
