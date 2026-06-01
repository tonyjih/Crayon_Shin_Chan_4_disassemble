; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

    db $01, $bf, $44, $09, $40

    db $ed
    ld a, e
    adc e
    ld a, e

    ldh a, [$9f]
    add $1a
    ld [$d933], a
    xor a
    ldh [$8f], a
    call Call_000_0963
    ld a, [$c0a9]
    rst $00

    db $22, $40, $2d, $40, $34, $40

    inc [hl]
    ld b, b

    xor a
    ldh [$bb], a
    ldh [$b9], a
    ldh [$b8], a
    ld a, $02
    ldh [$ba], a
    xor a
    ld [$c0a8], a
    ld [$c0b4], a
    call Call_001_41a9
    call Call_001_417f
    call Call_001_4af5
    call Call_001_43c8
    xor a
    ld [$c402], a
    jp Jump_000_0d8b


Call_001_4047:
    call Call_001_425e
    call Call_001_420f
    ld hl, $40af
    ldh a, [$9f]
    rst $20
    ld de, $c700
    ld bc, $0100
    ld a, $04
    call LoadGameGfx
    ld hl, $40b9
    ldh a, [$9f]
    rst $20
    ld a, l
    ldh [$a2], a
    ld a, h
    ldh [$a3], a
    ld a, $48
    ld [$c408], a
    ld a, $58
    ld [$c409], a
    ld a, $40
    ld [$c40a], a
    ld a, $58
    ld [$c40b], a
    ld a, $02
    ld [$c40c], a
    ld a, $04
    ld [$c40d], a
    xor a
    ld [$c411], a
    ld a, $08
    ld [$c410], a
    xor a
    ld [$c413], a
    ld a, $04
    ld [$c412], a
    xor a
    ld [$c40e], a
    ld [$c40f], a
    ld hl, $40c3
    ldh a, [$9f]
    rst $20
    ld de, $c414
    ld b, $4e
    jp Jump_000_0362


    db $32, $76, $ea, $76, $ca, $77, $fa, $78

    cp d
    ld a, c

    db $01, $40, $e1, $42, $31, $46, $c9, $4a

    cp c
    ld c, l

    db $cd, $40, $cd, $40, $f1, $40, $31, $41

    db $cd
    ld b, b

    db $f8, $0d, $ff, $00, $60, $0d, $80, $00, $00, $01, $02, $03, $04, $05, $06, $07
    db $08, $09, $0a, $0b, $0c, $0d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $04, $00, $04, $60, $03, $80, $03, $0c, $0d, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $09, $0a, $0b, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $04, $05, $06, $07, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $f8, $09, $00, $05, $60, $09, $80, $04, $00, $00, $00, $10
    db $08, $09, $0a, $0b, $0c, $0d, $00, $00, $00, $00, $00, $00, $00, $10, $07, $10
    db $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $10, $06, $10, $00, $00
    db $00, $00, $00, $00, $00, $00, $0e, $0e, $0e, $0f, $05, $10, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $01, $02, $03, $04, $10, $00, $00, $00, $00, $00, $00
    db $00, $00

Call_001_417f:
    xor a
    ldh [$aa], a
    ldh [$ac], a
    ldh [$bc], a
    call Call_000_0dc0
    call Call_001_4047
    ld a, $8c
    ldh [$9a], a
    ld hl, $c0a3
    ld a, $e4
    ld [hl+], a
    ld a, $d0
    ld [hl+], a
    ld a, $e4
    ld [hl+], a
    ld a, $e3
    ld [$c0a2], a
    ld a, $01
    ld [$c0a0], a
    jp Jump_000_02ef


Call_001_41a9:
    ld a, $ff
    ld [$c180], a
    call Call_001_5e21
    ld a, $20
    ldh [$b7], a
    ld hl, $00e0
    ld de, $0140
    ld a, [$dffd]
    or a
    jr z, jr_001_41c7

    ld hl, $01c0
    ld de, $0200

jr_001_41c7:
    ld a, l
    ld [$d996], a
    ld a, h
    ld [$d997], a
    ld a, l
    ldh [$b5], a
    ld a, h
    ldh [$b6], a
    ld a, e
    ld [$d998], a
    ld a, d
    ld [$d999], a
    xor a
    ldh [$9b], a
    ldh [$8d], a
    ld [$c100], a
    ldh [$99], a
    ldh [$c3], a
    ldh [$b3], a
    ldh [$b4], a
    ldh [$bf], a
    ldh [$bc], a
    ldh [$bd], a
    ldh [$c1], a
    ld [$c0b0], a
    ldh [$96], a
    ldh [$97], a
    ldh [$98], a
    ld hl, $c0b1
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    inc hl
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [$c0be], a
    ret


Call_001_420f:
    call Call_001_4225
    ld a, [$c0a8]
    or a
    jr z, jr_001_4225

    ld hl, $4246
    ldh a, [$9f]
    rst $20
    ld bc, $c800
    add hl, bc
    ld [hl], $05
    ret


Call_001_4225:
jr_001_4225:
    ldh a, [$9f]
    cp $03
    jr z, jr_001_4250

    ld hl, $423c
    ldh a, [$9f]
    rst $20
    ld de, $c800
    ld bc, $0e00
    ld a, $04
    jp Jump_000_0387


    db $39, $4e, $4b, $58, $3a, $61

    ld [hl], a
    ld l, e
    db $d3
    ld [hl], l
    ld d, d
    rlca

    db $72, $07

    ld l, d
    dec b
    ld b, c
    ld [$0000], sp

jr_001_4250:
    ld hl, $6b77
    ld de, $c800
    ld bc, $1100
    ld a, $04
    jp Jump_000_0387


Call_001_425e:
    ld hl, $4001
    ld de, $8000
    ld bc, $0130
    ld a, $05
    call LoadGameGfx
    ld hl, $5701
    ld de, $8d00
    ld bc, $0300
    ld a, $05
    call LoadGameGfx
    call Call_001_42fd
    ld hl, $4286
    ldh a, [$9f]
    rst $20
    jp Jump_000_06ea


    db $90, $42, $a6, $42, $bc, $42, $d9, $42

    reti


    ld b, d

    db $d1, $5a, $00, $87, $f0, $03, $05, $01, $5a, $00, $8b, $d0, $00, $05, $01, $40
    db $00, $90, $00, $08, $07, $ff, $c1, $5b, $00, $87, $00, $03, $05, $d1, $5e, $00
    db $8a, $a0, $02, $05, $e1, $46, $00, $90, $00, $08, $07, $ff, $61, $5d, $00, $87
    db $60, $01, $05, $d1, $5e, $60, $88, $e0, $01, $05, $71, $61, $40, $8a, $a0, $02
    db $05, $61, $53, $00, $90, $00, $08, $07, $ff, $c1, $5b, $00, $87, $a0, $01, $05
    db $d1, $5e, $a0, $88, $e0, $01, $05, $71, $61, $80, $8a, $c0, $01, $05, $e1, $64
    db $40, $8c, $80, $00, $05, $f1, $5a, $00, $90, $00, $08, $07, $ff

Call_001_42fd:
    ldh a, [$bb]
    rst $00

    db $0a, $43, $19, $43, $28, $43

    scf
    ld b, e
    ld b, [hl]
    ld b, e

    ld hl, $4131
    ld de, $8130
    ld bc, $0470
    ld a, $05
    call LoadGameGfx
    ret


    ld hl, $45a1
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call LoadGameGfx
    ret


    ld hl, $53a1
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call LoadGameGfx
    ret


    ld hl, $4f41
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call LoadGameGfx
    ret


    ld hl, $4ad1
    ld de, $8130
    ld bc, $0530
    ld a, $05
    call LoadGameGfx
    ret


    db $18, $00, $f0, $00, $00, $00, $80, $00

    jr z, @+$09

    ld h, b
    nop
    ret c

    ld b, $10
    nop

    db $18, $00, $f0, $03, $00, $00, $80, $03

    xor b
    ld bc, $0270
    ld d, b
    ld bc, $0200

    db $18, $00, $f0, $04, $00, $00, $80, $04

    jr z, jr_001_4383

    ld d, b
    nop
    ret nc

    inc bc

jr_001_4383:
    nop
    nop
    jr jr_001_4387

jr_001_4387:
    ld b, b
    nop
    nop
    nop
    nop
    nop
    ld c, b
    dec b
    ldh a, [rP1]
    ld a, [c]
    inc b
    add b
    nop

    db $55, $43

    ld a, a
    ld b, h

    db $65, $43, $75, $43

    add l
    ld b, e

    db $5d, $43

    or a
    ld b, h

    db $6d, $43, $7d, $43

    adc l
    ld b, e

jr_001_43a9:
    ld hl, $4395
    ldh a, [$9f]
    rst $20

jr_001_43af:
    ld a, [hl+]
    ldh [$b1], a
    ld a, [hl+]
    ldh [$b2], a
    ld a, [hl+]
    ldh [$ae], a
    ld a, [hl+]
    ldh [$af], a
    ld a, [hl+]
    ldh [$92], a
    ld a, [hl+]
    ldh [$93], a
    ld a, [hl+]
    ldh [$90], a
    ld a, [hl+]
    ldh [$91], a
    ret


Call_001_43c8:
    ldh a, [$9f]
    cp $01
    jr z, jr_001_4408

    cp $02
    call z, Call_001_43e1
    ld hl, $439f
    ldh a, [$9f]
    rst $20
    ld a, [$c0a8]
    or a
    jr z, jr_001_43a9

    jr jr_001_43af

Call_001_43e1:
    ld a, [$c0a8]
    or a
    ret z

    ld hl, $3572
    ld de, $9450
    ld bc, $0390
    ld a, $04
    call LoadGameGfx
    ld hl, $6411
    ld de, $8c00
    ld bc, $00d0
    ld a, $05
    call LoadGameGfx
    ld a, $03
    ld [$c0b3], a
    ret


jr_001_4408:
    ld a, [$c0bc]
    or a
    jr nz, jr_001_4418

    ld a, [$c0a8]
    or a
    jr nz, jr_001_4475

    xor a
    ld [$c0b4], a

jr_001_4418:
    xor a
    ld [$c0bc], a
    ld hl, $447f
    ld a, [$c0b4]
    or a
    jr z, jr_001_443c

    ld hl, $448f
    dec a
    jr z, jr_001_443c

    ld hl, $4ee1
    ld de, $91a0
    ld bc, $0480
    ld a, $07
    call LoadGameGfx
    ld hl, $449f

jr_001_443c:
    ld a, [hl+]
    ld [$c40e], a
    ld a, [hl+]
    ld [$c40f], a
    ld a, [hl+]
    ld [$c418], a
    ld a, [hl+]
    ld [$c419], a
    ld a, [hl+]
    ld [$c410], a
    ld a, [hl+]
    ld [$c411], a
    ld a, [hl+]
    ld [$c414], a
    ld a, [hl+]
    ld [$c415], a
    ld a, [hl+]
    ldh [$b1], a
    ld a, [hl+]
    ldh [$b2], a
    ld a, [hl+]
    ldh [$ae], a
    ld a, [hl+]
    ldh [$af], a
    ld a, [hl+]
    ldh [$92], a
    ld a, [hl+]
    ldh [$93], a
    ld a, [hl+]
    ldh [$90], a
    ld a, [hl+]
    ldh [$91], a
    ret


jr_001_4475:
    ld a, $01
    ld [$c0b4], a
    ld hl, $44af
    jr jr_001_443c

    db $00, $00, $60, $04, $08, $00, $00, $05, $18, $00, $70, $00, $00, $00, $18, $00
    db $00, $05, $60, $08, $08, $05, $00, $09, $18, $05, $c0, $00, $00, $05, $68, $00
    db $00, $09, $60, $0d, $08, $09, $f8, $0d, $18, $09, $f0, $00, $00, $09, $80, $00

    nop
    dec b
    ld h, b
    ld [$0508], sp
    nop
    add hl, bc
    jr z, @+$09

    add b
    nop
    db $d3
    ld b, $28
    nop

    ldh a, [$8b]
    bit 3, a
    jr nz, jr_001_4532

    ld a, $ff
    ld [$c403], a
    call Call_000_0a16
    call Call_001_4578
    call Call_001_4868
    call Call_001_560e
    call Call_001_4f08
    call Call_001_454b
    ld a, [$c402]
    or a
    ret z

    ldh a, [$99]
    cp $20
    ret nc

    ld a, [$c402]
    bit 3, a
    jp nz, Jump_001_4516

    bit 2, a
    jp nz, Jump_001_44fe

    bit 1, a
    jp nz, Jump_000_0e6e

    bit 0, a
    jp nz, Jump_000_0e48

    ret


Jump_001_44fe:
    ld a, [$c402]
    res 2, a
    ld [$c402], a
    ld hl, $c404
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $452e
    ld bc, $0202
    call Call_000_061f
    ret


Jump_001_4516:
    ld a, [$c402]
    res 3, a
    ld [$c402], a
    ld hl, $c406
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $da00
    ld bc, $0202
    call Call_000_061f
    ret


    db $08, $09, $0a, $0b

jr_001_4532:
    ld a, $06
    ldh [$8e], a
    ldh a, [$9c]
    ldh [$9b], a
    xor a
    ld [$dd9f], a
    ld a, $5e
    call Call_000_0f38
    ret


jr_001_4544:
    ldh a, [$be]
    res 1, a
    ldh [$be], a
    ret


Call_001_454b:
    ld hl, $c0ab
    ld a, [hl]
    or a
    jr z, jr_001_4558

    dec [hl]
    jr z, jr_001_4544

    bit 3, [hl]
    ret z

jr_001_4558:
    ldh a, [$ac]
    and $01
    ld b, a
    ldh a, [$a9]
    and $fe
    or b
    ldh [$a9], a
    ldh [$9d], a
    ld hl, $1a19
    ldh a, [$bb]
    rst $20
    ldh a, [$a6]
    rst $20
    ldh a, [$a5]
    ld c, a
    ldh a, [$a4]
    ld b, a
    jp Jump_000_026c


Call_001_4578:
    ld bc, $c0bf
    call Call_001_45bf
    ld bc, $c0cb
    call Call_001_45cb
    ldh a, [$bb]
    cp $04
    ret nz

    ld hl, $c0a6
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr z, jr_001_45a6

    jr c, jr_001_4599

    ret


jr_001_4599:
    ld a, [$c0be]
    ldh [$bb], a
    ld a, $04
    ld [$c0be], a
    jp Jump_001_4dc7


jr_001_45a6:
    ld a, [$c0a6]
    ld b, a
    and $0f
    ret z

    bit 4, b
    jp z, Jump_000_0e02

    ldh a, [$bb]
    push af
    xor a
    ldh [$bb], a
    call Call_000_0e02
    pop af
    ldh [$bb], a
    ret


Call_001_45bf:
    ld a, [bc]
    or a
    ret z

    rst $00

    ld d, h
    ld b, [hl]

    db $54, $46, $82, $46, $cd, $47

Call_001_45cb:
    ld a, [bc]
    or a
    ret z

    call Call_001_45f9
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_45f1

    call Call_001_4614
    jr z, jr_001_45f1

    call Call_001_4641
    inc bc
    ld a, [bc]
    ldh [$9d], a
    ld hl, $2e9b
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_026c


jr_001_45f1:
    xor a
    ld [bc], a
    ld hl, $ffbc
    res 1, [hl]
    ret


Call_001_45f9:
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a

Call_001_4605:
Jump_001_4605:
    ld de, $0180

Jump_001_4608:
    ld h, b
    ld l, c
    inc hl
    bit 0, [hl]
    inc hl
    jp nz, Jump_001_4bee

    jp Jump_001_4be3


Call_001_4614:
    push bc
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld b, [hl]
    ld c, a
    push de
    call Call_000_0d36
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de
    ld b, c
    ld c, e
    call Call_001_4637
    pop bc
    ret


Call_001_4637:
    call Call_001_46f6
    jr c, jr_001_463f

    or $ff
    ret


jr_001_463f:
    xor a
    ret


Call_001_4641:
    ld a, $04
    ldh [$d1], a
    ld a, $04
    ldh [$d2], a
    ldh a, [$d3]
    ld [$c0d3], a
    ldh a, [$d4]
    ld [$c0d4], a
    ret


    call Call_001_4605
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_4677

    call Call_001_4614
    jr z, jr_001_4677

    call Call_001_467f
    inc bc
    ld a, [bc]
    ldh [$9d], a
    ld hl, $2e96
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_026c


jr_001_4677:
    xor a
    ld [bc], a
    ld hl, $ffbc
    res 0, [hl]
    ret


Call_001_467f:
    jp Jump_001_47ba


    call Call_001_46ad
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_46a5

    call Call_001_4614
    jr z, jr_001_46a5

    call Call_001_47ba
    inc bc
    ld a, [bc]
    ldh [$9d], a
    ld hl, $30e2
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_026c


jr_001_46a5:
    xor a
    ld [bc], a
    ld hl, $ffbc
    res 0, [hl]
    ret


Call_001_46ad:
    ld hl, $c0c9
    ld a, [hl]
    cp $20
    jr nc, jr_001_46b9

    inc [hl]
    jp Jump_001_4605


jr_001_46b9:
    call Call_001_46cf
    call nc, Call_001_46c2
    jp Jump_001_4605


Call_001_46c2:
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    ret


Call_001_46cf:
    push bc
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    inc de
    inc de
    inc de
    inc de
    push de
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld b, [hl]
    ld c, a
    call Call_000_0d36
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de
    ld b, c
    ld c, e
    call Call_001_46f6
    pop bc
    ret


Call_001_46f6:
    and $3f
    rst $00

    db $8a, $47, $8c, $47

    adc [hl]
    ld b, a
    sub h
    ld b, a

    db $9a, $47

    and d
    ld b, a

    db $8a, $47

    sbc d
    ld b, a
    and d
    ld b, a
    adc d
    ld b, a
    sbc d
    ld b, a
    adc d
    ld b, a
    xor [hl]
    ld b, a
    or h
    ld b, a
    sbc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc h
    ld b, a
    adc h
    ld b, a
    adc d
    ld b, a
    adc h
    ld b, a
    sbc d
    ld b, a
    adc d
    ld b, a
    sbc d
    ld b, a
    sbc d
    ld b, a
    adc d
    ld b, a
    sbc d
    ld b, a
    add d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a

    db $79, $47

    adc d
    ld b, a
    adc h
    ld b, a

    db $8c, $47

    adc h
    ld b, a
    adc h
    ld b, a
    adc h
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a
    adc d
    ld b, a

    ld a, c
    and $0f
    cp $08
    ccf
    ret nc

    scf
    ret


    ld a, c
    and $0f
    cp $08
    ret nc

    scf
    ret


jr_001_478a:
    sub a
    ret


    scf
    ret


    bit 3, b
    jr z, jr_001_478a

    jr jr_001_479a

    bit 3, b
    jr nz, jr_001_478a

    jr jr_001_479a

jr_001_479a:
    ld a, c
    and $0f
    cp $04
    ret nc

    scf
    ret


jr_001_47a2:
    ld a, c
    and $0f
    cp $08
    jr c, jr_001_478a

    cp $0c
    ret nc

    scf
    ret


    bit 3, b
    jr z, jr_001_478a

    jr jr_001_47a2

    bit 3, b
    jr nz, jr_001_478a

    jr jr_001_47a2

Call_001_47ba:
Jump_001_47ba:
    ld a, $04
    ldh [$d1], a
    ld a, $04
    ldh [$d2], a

Jump_001_47c2:
    ldh a, [$d3]
    ld [$c0c7], a
    ldh a, [$d4]
    ld [$c0c8], a
    ret


    call Call_001_480c
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_47f9

    call Call_001_4801
    inc bc
    ld a, [bc]
    ldh [$9d], a
    ld hl, $32d2
    ld a, [$c0c9]
    inc a
    ld [$c0c9], a
    bit 4, a
    jr nz, jr_001_47f0

    ld hl, $32e7

jr_001_47f0:
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_026c


jr_001_47f9:
    xor a
    ld [bc], a
    ld hl, $ffbc
    res 0, [hl]
    ret


Call_001_4801:
    ld a, $08
    ldh [$d1], a
    ld a, $08
    ldh [$d2], a
    jp Jump_001_47c2


Call_001_480c:
    ld de, $0300
    jp Jump_001_4608


Call_001_4812:
    ld b, h
    ld c, l
    and $3f
    rst $00

    ld h, a
    ld c, b

    db $2f, $67, $56, $68, $73, $69, $47, $6b, $50, $66, $de, $61, $22, $73, $c7, $73

    inc b
    ld [hl], b

    db $7e, $62, $e1, $63, $cf, $64, $24, $65, $f8, $65, $be, $66, $72, $5f, $b7, $5f
    db $42, $60, $68, $60, $a0, $60, $ca, $60, $03, $61, $3a, $61, $6e, $61, $a3, $61
    db $e1, $6e, $83, $6f, $04, $70, $2a, $6e, $81, $70, $1b, $72, $9a, $72, $f3, $6a
    db $ff, $70, $54, $74, $f5, $6d

    ld h, a
    ld c, b
    ld h, a
    ld c, b
    ld h, a
    ld c, b
    ret


Call_001_4868:
    ld a, [$c0b5]
    or a
    jr z, jr_001_4871

    call Call_001_4d25

jr_001_4871:
    xor a
    ldh [$c4], a
    ld hl, $c180

jr_001_4877:
    ld a, [hl]
    or a
    jr z, jr_001_4884

    cp $ff
    jr z, jr_001_488a

    push hl
    call Call_001_4812
    pop hl

jr_001_4884:
    ld bc, $0010
    add hl, bc
    jr jr_001_4877

jr_001_488a:
    call Call_001_489a
    call Call_001_489a
    call Call_001_489a
    jr jr_001_489a

jr_001_4895:
    xor a
    ld [$c380], a
    ret


Call_001_489a:
jr_001_489a:
    ld hl, $c380
    ld a, [hl]
    ld c, a
    ld b, $00
    inc [hl]
    ld hl, $c381
    add hl, bc
    ld a, [hl]
    cp $ff
    jr z, jr_001_4895

    cp $01
    ret nz

    ld hl, $4b24
    ldh a, [$9f]
    rst $20
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    ld a, l
    ldh [$c5], a
    ld a, h
    ldh [$c6], a
    ld a, [hl+]
    ldh [$c9], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld d, a
    push hl
    ld hl, $ff92
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ld de, $0050
    add hl, de
    bit 7, h
    jr z, jr_001_48e5

    ld a, l
    cpl
    add $01
    ld l, a
    ld a, h
    cpl
    adc $00
    ld h, a

jr_001_48e5:
    ld a, h
    ld e, l
    pop hl
    or a
    ret nz

    ldh a, [$c9]
    cp $10
    jr c, jr_001_48f6

    ld a, e
    cp $70
    ret nc

    jr jr_001_48fe

jr_001_48f6:
    ld a, e
    cp $b0
    ret nc

    cp $60
    jr c, jr_001_4915

jr_001_48fe:
    ld hl, $c381
    add hl, bc
    ld [hl], $02

Jump_001_4904:
    ld hl, $c180

jr_001_4907:
    ld a, [hl]
    or a
    jr z, jr_001_4939

    cp $ff
    jr z, jr_001_492e

    ld de, $0010
    add hl, de
    jr jr_001_4907

jr_001_4915:
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$90]
    ld e, a
    ldh a, [$91]
    ld d, a
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ld a, h
    or a
    jr nz, jr_001_48fe

    ld a, l
    cp $a0
    jr nc, jr_001_48fe

    ret


jr_001_492e:
    call Call_001_4939
    ld a, $ff
    ld hl, $0010
    add hl, bc
    ld [hl], a
    ret


Call_001_4939:
jr_001_4939:
    ld d, h
    ld e, l
    ld a, c
    ld hl, $000f
    add hl, de
    ld [hl], a
    ld b, d
    ld c, e
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    push af
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    ld a, [hl+]
    ldh [$c9], a
    and $f8
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de
    ld h, d
    ld l, e
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl], $01
    call Call_001_49d9
    pop af
    and $3f
    rst $00

    ret c

    ld c, c

    db $bc, $4a, $c9, $4a, $d6, $4a, $e3, $4a

    ret c

    ld c, c

    db $d8, $49, $f7, $49, $d8, $49

    ret c

    ld c, c

    db $3d, $4a, $3d, $4a, $4a, $4a, $57, $4a

    ret c

    ld c, c

    db $64, $4a, $d8, $49, $d8, $49, $d8, $49, $d8, $49, $d8, $49, $d8, $49, $d8, $49
    db $d8, $49, $d8, $49, $d8, $49, $23, $4a, $23, $4a

    ret c

    ld c, c

    db $19, $4a

    ret c

    ld c, c

    db $d8, $49, $ea, $49

    ret c

    ld c, c

    db $ea, $49, $d8, $49

    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c
    ret c

    ld c, c

    ret


Call_001_49d9:
    ld hl, $0003
    add hl, bc
    ldh a, [$b1]
    sub [hl]
    inc hl
    ldh a, [$b2]
    sbc [hl]
    ret nc

    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


    ldh a, [$c9]
    srl a
    ld a, [bc]
    res 7, a
    jr nc, jr_001_49f5

    set 7, a

jr_001_49f5:
    ld [bc], a
    ret


    ld a, [bc]
    and $7f
    ld [bc], a
    ldh a, [$c9]
    and $07
    ld hl, $4a11
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    srl a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


    db $30

    db $40, $48, $50

    ld e, b

    db $60

    ld l, b
    ld [hl], b

    ldh a, [$c9]
    and $07
    ld hl, $000a
    add hl, bc
    ld [hl], a
    ret


    ldh a, [$c9]
    and $07
    ld hl, $4a37
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


    db $30, $3c, $48

    ld d, h
    ld h, b

    db $aa

    ld de, $4a42
    jr jr_001_4a71

    db $80, $00, $01

    ld bc, $00c0
    ld [bc], a
    ld [bc], a

    ld de, $4a4f
    jr jr_001_4a71

    db $c0, $00, $01

    ld bc, $0120
    ld [bc], a
    ld [bc], a

    ld de, $4a5c
    jr jr_001_4a71

    db $80, $00, $01

    ld bc, $00c0
    ld [bc], a
    ld [bc], a

    ld de, $4a69
    jr jr_001_4a71

    db $00, $01, $02

    ld [bc], a
    add b
    ld bc, $0303

Jump_001_4a71:
jr_001_4a71:
    ld a, [$dffe]
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, [de]
    inc de
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl], a
    ld a, [de]
    ld hl, $000e
    add hl, bc
    ld [hl], a
    ld a, [de]
    ld l, $00
    ld a, [$dffe]
    or a
    jr z, jr_001_4a95

    ld l, $08

jr_001_4a95:
    ldh a, [$c9]
    and $07
    add l
    ld hl, $4aac
    rst $38
    ld a, [hl]
    ld hl, $000a
    add hl, bc
    ld [hl], a
    srl a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


    db $18, $30, $50, $70, $80, $a0, $c0

    ldh a, [rNR10]
    jr nz, @+$36

    ld c, d
    ld d, h
    ld l, d
    add b
    and b

    ld de, $4ac1
    jr jr_001_4a71

    db $00, $01, $03

    inc bc
    add b
    ld bc, $0606

    ld de, $4ace
    jr jr_001_4a71

    db $00, $01, $04

    inc b
    add b
    ld bc, $0808

    ld de, $4adb
    jr jr_001_4a71

    db $c0, $00, $03

    inc bc
    ld b, b
    ld bc, $0505

    xor a
    ld [$c0ba], a
    ld de, $4aed
    jp Jump_001_4a71


    db $80, $01, $05

    dec b
    nop
    ld [bc], a
    db $08
    db $08

Call_001_4af5:
    xor a
    ld [$c380], a
    call Call_001_4b09
    ld a, $ff
    ld hl, $c180
    ld b, $00
    call Call_000_0022
    jp Jump_000_0022


Call_001_4b09:
    ld hl, $4b24
    ldh a, [$9f]
    rst $20
    ld d, h
    ld e, l
    ld hl, $c381

jr_001_4b14:
    ld a, [de]
    cp $ff
    jr z, jr_001_4b21

    ld a, $01
    ld [hl+], a
    ld a, $05
    rst $30
    jr jr_001_4b14

jr_001_4b21:
    ld [hl], $ff
    ret


    db $b5, $74, $46, $76, $e6, $77, $c7, $79

    ld a, e
    ld a, e

Call_001_4b2e:
    xor a
    ldh [$d5], a
    ldh a, [$93]
    ld d, a
    ldh a, [$92]
    ld e, a
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    sub e
    ld e, a
    ldh [$d3], a
    ld a, [hl+]
    sbc d
    ldh [$c9], a
    call Call_001_4b6c
    ldh a, [$91]
    ld d, a
    ldh a, [$90]
    ld e, a
    inc hl
    ld a, [hl+]
    sub e
    ld e, a
    ldh [$d4], a
    ld a, [hl+]
    sbc d
    ldh [$ca], a
    jr c, jr_001_4b62

    or a
    jr nz, jr_001_4b7f

    ld a, e
    cp $a0
    jr nc, jr_001_4b7f

    ret


jr_001_4b62:
    cp $ff
    jr nz, jr_001_4b7f

    ld a, e
    cp $f0
    ret nc

    jr jr_001_4b7f

Call_001_4b6c:
    jr c, jr_001_4b77

    or a
    jr nz, jr_001_4b7f

    ld a, e
    cp $b8
    jr nc, jr_001_4b7f

    ret


jr_001_4b77:
    cp $ff
    jr nz, jr_001_4b7f

    ld a, e
    cp $f0
    ret nc

jr_001_4b7f:
    ld a, $ff
    ldh [$d5], a
    ret


Call_001_4b84:
    call Call_001_4b2e
    ldh a, [$c9]
    ld d, a
    ldh a, [$d3]
    ld e, a
    ld hl, $00a0
    add hl, de
    bit 7, h
    jr nz, jr_001_4bbd

    bit 7, d
    jr nz, jr_001_4ba1

    ld hl, $fec0
    add hl, de
    bit 7, h
    jr z, jr_001_4bbd

jr_001_4ba1:
    ldh a, [$ca]
    ld d, a
    ldh a, [$d4]
    ld e, a
    ld hl, $0090
    add hl, de
    bit 7, h
    jr nz, jr_001_4bbd

    bit 7, d
    jr nz, jr_001_4bbb

    ld hl, $ff00
    add hl, de
    bit 7, h
    jr z, jr_001_4bbd

jr_001_4bbb:
    xor a
    ret


Jump_001_4bbd:
jr_001_4bbd:
    ld h, b
    ld l, c
    inc hl
    ld a, [hl-]
    bit 7, a
    ret nz

    ld [hl], $00
    ld hl, $000f
    add hl, bc
    ld a, [hl]
    ld de, $c381
    rst $30
    ld a, $01
    ld [de], a
    or a
    ret


Call_001_4bd4:
Jump_001_4bd4:
    ld hl, $0008
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $0002
    add hl, bc

Call_001_4bdf:
    ld a, [bc]
    rlca
    jr c, jr_001_4bee

Call_001_4be3:
Jump_001_4be3:
    ld a, e
    add [hl]
    ld [hl+], a
    ld a, d
    adc [hl]
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    ret


Call_001_4bee:
Jump_001_4bee:
jr_001_4bee:
    ld a, [hl]
    sub e
    ld [hl+], a
    ld a, [hl]
    sbc d
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    ret


Call_001_4bf9:
    inc [hl]
    ld a, [hl]
    cp d
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ld a, [hl]
    cp e
    ret c

    ld [hl], $00
    ret


Jump_001_4c06:
    ld hl, $1b25
    ldh a, [$9f]
    rst $20
    ldh a, [$d6]
    rst $20
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_026c


Call_001_4c18:
    ldh a, [$aa]
    cp $01
    jr z, jr_001_4c26

    ldh a, [$bb]
    cp $02
    jr z, jr_001_4c26

    jr jr_001_4c2b

jr_001_4c26:
    ld hl, $4c71
    jr jr_001_4c2e

jr_001_4c2b:
    ld hl, $4c44

jr_001_4c2e:
    ld a, d
    add a
    add a
    add d
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ldh [$cb], a
    ld a, [hl+]
    ldh [$cc], a
    ld a, [hl+]
    ldh [$cd], a
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a
    ret


    db $0e, $14, $0e, $0e, $15, $12, $14, $18, $18, $1d, $0e, $14, $16, $16, $1b, $0a
    db $14, $05, $04, $08, $0e, $14, $04, $fc, $ff, $0e, $14, $10, $08, $10, $12, $14
    db $16, $16, $1b, $0a, $14, $05, $fc, $ff, $14, $14, $1c, $1c, $22, $0e, $0e, $0e
    db $0e, $15, $12, $0e, $18, $18, $1d, $0e, $0e, $16, $16, $1b, $0a, $0e, $05, $04
    db $08, $0e, $0e, $04, $fc, $ff, $0e, $0e, $10, $08, $10

    ld [de], a
    ld c, $16
    ld d, $1b

    db $0a, $0e, $05, $fc, $ff

    inc d
    ld c, $1c
    inc e
    ld [hl+], a

Call_001_4c9e:
    ldh a, [$cb]
    ld l, a
    ldh a, [$a5]
    ld h, a
    ldh a, [$d3]
    sub h
    bit 7, a
    jr z, jr_001_4cad

    cpl
    inc a

jr_001_4cad:
    cp l
    ret nc

    ldh a, [$aa]
    cp $02
    jr nz, jr_001_4cce

    ldh a, [$b4]
    rlca
    jr c, jr_001_4cce

    ldh a, [$a4]
    ld h, a
    ldh a, [$d4]
    sub h
    jr c, jr_001_4cdf

    cp e
    jr nc, jr_001_4cc7

    cp d
    ccf

jr_001_4cc7:
    jr nc, jr_001_4cd6

    call Call_001_4dbb
    scf
    ret


jr_001_4cce:
    ldh a, [$a4]
    ld h, a
    ldh a, [$d4]
    sub h
    jr c, jr_001_4cdf

jr_001_4cd6:
    ld l, a
    ldh a, [$cd]
    ld h, a
    ld a, l
    cp h
    ret nc

    jr jr_001_4ce8

jr_001_4cdf:
    cpl
    inc a
    ld l, a
    ldh a, [$cc]
    ld h, a
    ld a, l
    cp h
    ret nc

Jump_001_4ce8:
jr_001_4ce8:
    call Call_001_4d7c
    sub a
    ret


Call_001_4ced:
    ldh a, [$d3]
    sub [hl]
    bit 7, a
    jr z, jr_001_4cf6

    cpl
    inc a

jr_001_4cf6:
    cp d
    ret nc

    inc hl
    ldh a, [$c9]
    sub [hl]
    bit 7, a
    jr z, jr_001_4d02

    cpl
    inc a

jr_001_4d02:
    cp e
    ret


jr_001_4d04:
    ldh a, [$9f]
    cp $03
    jr z, jr_001_4d14

    ld hl, $ff90
    ld a, [$c41a]
    cp [hl]
    ret z

    inc [hl]
    ret


jr_001_4d14:
    ld hl, $ff90
    ld a, [hl]
    cp $80
    ret z

    jr nc, jr_001_4d21

    inc [hl]
    jp Jump_000_0a69


jr_001_4d21:
    dec [hl]
    jp Jump_000_0a69


Call_001_4d25:
    dec a
    ld [$c0b5], a
    jr z, jr_001_4d51

    ld b, a
    ld a, $bd
    sub b
    ld b, a
    cp $60
    jr nc, jr_001_4d04

    ld a, $01
    ld [$c0b6], a
    ld hl, $4d49
    ldh a, [$9f]
    rst $20
    ld c, b
    ld a, $70
    add b
    ld e, a
    ld d, $05
    jp Jump_000_0522


    db $61, $65, $21, $68, $f1, $6a, $81, $6e

jr_001_4d51:
    ld hl, $4d60
    ldh a, [$9f]
    rst $20
    ld a, l
    ldh [$c5], a
    ld a, h
    ldh [$c6], a
    jp Jump_001_4904


    db $68, $4d, $6d, $4d, $72, $4d, $77, $4d, $01, $08, $0e, $f0, $00, $02, $08, $0e
    db $c0, $00, $03, $08, $02, $c0, $00, $04, $08, $0a, $f0, $00

Call_001_4d7c:
    ldh a, [$be]
    or a
    ret nz

    ldh a, [$bb]
    or a
    jp nz, Jump_001_4da4

    ldh a, [$b9]
    or a
    jp z, Jump_001_4ece

    ld a, $51
    call Call_000_0f3b
    ldh a, [$aa]
    ld [$c0ac], a
    ld a, $0a
    ldh [$aa], a
    ld hl, $ffbe
    set 3, [hl]
    ld a, $1e
    ldh [$bd], a
    ret


Jump_001_4da4:
    ldh a, [$bb]
    ld [$c0be], a
    xor a
    ldh [$bb], a
    ld hl, $d996
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [$b5], a
    ld a, h
    ldh [$b6], a
    jp Jump_001_4dc7


Call_001_4dbb:
    ld a, $01
    ld [$c0b0], a
    ld a, $20
    ldh [$b7], a
    jp Jump_001_5eae


Jump_001_4dc7:
    ld a, $06
    ldh [$aa], a
    xor a
    ldh [$c1], a
    ldh [$a7], a
    ldh [$a8], a
    ldh [$bc], a
    ld [$c0bf], a
    ld [$c0cb], a
    ldh [$bc], a
    ld a, $f8
    ldh [$bd], a
    ldh a, [$be]
    set 4, a
    ldh [$be], a
    ld a, [$c0be]
    cp $04
    ret nz

    ldh a, [$96]
    cp $ff
    call nz, Call_000_0963
    ld hl, $d996
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [$b5], a
    ld a, h
    ldh [$b6], a
    ld hl, $ffbe
    res 2, [hl]
    ret


Call_001_4e05:
    ldh a, [$bf]
    ld b, a
    xor a
    ldh [$bf], a
    ld a, b
    and $07
    rst $00

    db $1f, $4e, $20, $4e, $27, $4e

    rra
    ld c, [hl]
    rra
    ld c, [hl]
    rra
    ld c, [hl]
    rra
    ld c, [hl]
    rra
    ld c, [hl]

    ret


    ldh a, [$ae]
    and $f0
    ldh [$ae], a
    ret


    ldh a, [$ae]
    and $f0
    or $08
    ldh [$ae], a
    ret


Call_001_4e30:
    ldh a, [$b4]
    ld d, a
    ldh a, [$b3]
    ld e, a
    push de
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    call Call_001_4ea3
    pop de
    ld a, d
    ldh [$b4], a
    ld a, e
    ldh [$b3], a
    ret


Call_001_4e48:
Jump_001_4e48:
    ldh a, [$ac]
    or a
    jr nz, jr_001_4e79

    ld hl, $ffb0
    ldh a, [$b5]
    add [hl]
    ld [hl+], a
    ldh a, [$b6]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [$c414]
    ld e, a
    ld a, [$c415]
    ld d, a
    call Call_000_0080
    ret c

    ld a, [$c0b6]
    cp $ff
    ret z

    ld a, [$c415]
    ldh [$b2], a
    ld a, [$c414]
    ldh [$b1], a
    ret


jr_001_4e79:
    ld hl, $ffb0
    ldh a, [$b5]
    ld d, a
    ld a, [hl]
    sub d
    ld [hl+], a
    ldh a, [$b6]
    ld d, a
    ld a, [hl]
    sbc d
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl-], a
    ld a, [$c410]
    ld e, a
    ld a, [$c411]
    ld d, a
    call Call_000_0080
    ret nc

    ld a, [$c411]
    ldh [$b2], a
    ld a, [$c410]
    ldh [$b1], a
    ret


Call_001_4ea3:
    ldh a, [$b4]
    bit 7, a
    jr nz, jr_001_4ef0

    ld hl, $ffad
    ldh a, [$b3]
    add [hl]
    ld [hl+], a
    ldh a, [$b4]
    adc [hl]
    ld [hl+], a
    ld a, $00
    adc [hl]
    ld [hl-], a
    ld a, [$c0b6]
    or a
    ret nz

    ld a, [$c416]
    ld e, a
    ld a, [$c417]
    ld d, a
    call Call_000_0080
    ret c

    ldh a, [$aa]
    cp $0b
    ret z

Jump_001_4ece:
    xor a
    ldh [$bb], a
    call Call_000_0f0d
    ld a, $55
    call Call_000_0f32
    ld a, $0b
    ldh [$aa], a
    ld hl, $ffbe
    set 3, [hl]
    ld hl, $fc00
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    ld a, $ff
    ldh [$c3], a
    ret


jr_001_4ef0:
    ld hl, $ffad
    ldh a, [$b3]
    add [hl]
    ld [hl+], a
    ldh a, [$b4]
    adc [hl]
    ld [hl+], a
    ld a, $ff
    adc [hl]
    ld [hl-], a
    cp $ff
    ret nz

    xor a
    ldh [$af], a
    ldh [$ae], a
    ret


Call_001_4f08:
    ldh a, [$9f]
    rst $00

    db $13, $4f, $cb, $4f, $32, $50, $33, $50

    ldh a, [$96]
    and $60
    ret nz

    ld a, [$c0b1]
    ld hl, $4f2e
    rst $38
    ld a, [hl]
    call Call_001_4f46
    ld hl, $c0b1
    inc [hl]
    ld a, [hl]
    cp $18
    ret c

    ld [hl], $00
    ret


    db $01, $04, $00, $06, $01, $00, $00, $05, $02, $00, $00, $00, $02, $04, $00, $00
    db $03, $00, $00, $05, $03, $07, $00, $00

Call_001_4f46:
    rst $00

    db $57, $4f, $58, $4f, $69, $4f, $7d, $4f, $91, $4f, $a4, $4f, $b1, $4f, $be, $4f

    ret


    ld c, $39
    ld e, c
    call Call_001_4f9c
    ld c, $3a
    ld e, c
    call Call_001_4f9c
    ld c, $3b
    ld e, c
    jr jr_001_4f9c

    ld c, $3a
    ld e, $39
    call Call_001_4f9c
    ld c, $3b
    ld e, $3a
    call Call_001_4f9c
    ld c, $39
    ld e, $3b
    jr jr_001_4f9c

    ld c, $3b
    ld e, $39
    call Call_001_4f9c
    ld c, $39
    ld e, $3a
    call Call_001_4f9c
    ld c, $3a
    ld e, $3b
    jr jr_001_4f9c

    ld c, $3c
    ld e, $3c
    call Call_001_4f9c
    ld c, $3d
    ld e, $3d

Call_001_4f9c:
jr_001_4f9c:
    ld d, $07
    ld hl, $4001
    jp Jump_000_0532


    ld c, $3c
    ld e, $3d
    call Call_001_4f9c
    ld c, $3d
    ld e, $3c
    jr jr_001_4f9c

    ld c, $2e
    ld e, $2e
    call Call_001_4f9c
    ld c, $2f
    ld e, $2f
    jr jr_001_4f9c

    ld c, $2e
    ld e, $2f
    call Call_001_4f9c
    ld c, $2f
    ld e, $2e
    jr jr_001_4f9c

    ldh a, [$96]
    and $60
    ret nz

    ld a, [$c0b4]
    or a
    ret nz

    ld a, [$c0b1]
    ld hl, $4feb
    rst $38
    ld a, [hl]
    call Call_001_500b
    ld hl, $c0b1
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret


    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Call_001_500b:
    rst $00

    db $12, $50, $13, $50, $1f, $50

    ret


    ld c, $29
    ld e, c
    call Call_001_502a
    ld c, $2a
    ld e, c
    jp Jump_001_502a


    ld c, $29
    ld e, $2a
    call Call_001_502a
    ld c, $2a
    ld e, $29

Call_001_502a:
Jump_001_502a:
    ld d, $07
    ld hl, $46e1
    jp Jump_000_0532


    ret


    ldh a, [$96]
    and $60
    ret nz

    ld a, [$c0b4]
    or a
    ret nz

    ld a, [$c0b1]
    ld hl, $5053
    rst $38
    ld a, [hl]
    call Call_001_5073
    ld hl, $c0b1
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret


    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Call_001_5073:
    rst $00

    db $7a, $50, $7b, $50, $87, $50

    ret


    ld c, $5e
    ld e, c
    call Call_001_5092
    ld c, $5f
    ld e, c
    jp Jump_001_5092


    ld c, $5e
    ld e, $5f
    call Call_001_5092
    ld c, $5f
    ld e, $5e

Call_001_5092:
Jump_001_5092:
    ld d, $07
    ld hl, $5af1
    jp Jump_000_0532


Call_001_509a:
    bit 7, d
    jp z, Jump_000_0d36

    xor a
    ret


Call_001_50a1:
Jump_001_50a1:
    xor a
    ldh [$cd], a
    ldh a, [$b1]
    ld c, a
    ldh a, [$b2]
    ld b, a
    ldh a, [$ae]
    ld e, a
    ldh a, [$af]
    ld d, a
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_50f4
    ldh a, [$cd]
    cp $01
    jr nz, jr_001_50ec

    ldh a, [$ab]
    cp $03
    ret z

    ld a, $03
    ldh [$aa], a
    xor a
    ldh [$b3], a
    ldh [$b4], a
    ldh [$c1], a
    ld [$c0b0], a
    ldh a, [$bb]
    cp $02
    jr nz, jr_001_50e0

    xor a
    ldh [$bc], a

jr_001_50e0:
    xor a
    ldh [$bf], a
    ldh a, [$b1]
    and $f8
    or $08
    ldh [$b1], a
    ret


jr_001_50ec:
    ldh a, [$ab]
    cp $03
    ret nz

    jp Jump_001_5e0b


Call_001_50f4:
    cp $06
    jr z, jr_001_510d

    cp $08
    jr z, jr_001_5112

    cp $09
    jr z, jr_001_511e

    cp $0a
    jr z, jr_001_5128

    cp $1c
    jr z, jr_001_5132

    cp $1d
    jr z, jr_001_5158

    ret


jr_001_510d:
    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5112:
    ldh a, [$ae]
    and $0f
    cp $08
    ret nc

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_511e:
    ldh a, [$ae]
    and $0f
    ret z

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5128:
    ldh a, [$ae]
    and $0f
    ret z

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_5132:
    ldh a, [$ae]
    and $0f
    cp $03
    jr c, jr_001_513f

    ld hl, $ffcd
    inc [hl]
    ret


jr_001_513f:
    ld a, $01
    ld [$c0b4], a

jr_001_5144:
    ld a, $40
    ld [$d95c], a
    ld a, $07
    ldh [$8e], a
    ld a, $02
    ld [$c0a9], a
    ld a, $ff
    ld [$c0bc], a
    ret


jr_001_5158:
    ldh a, [$ae]
    and $0f
    cp $0b
    jr nc, jr_001_5165

    ld hl, $ffcd
    inc [hl]
    ret


Jump_001_5165:
jr_001_5165:
    ld a, $02
    ld [$c0b4], a
    jr jr_001_5144

Call_001_516c:
    xor a
    ldh [$c0], a
    ld hl, $ffb1
    ld a, [hl+]
    add $07
    ld c, a
    ld a, [hl]
    adc $00
    ld b, a

Jump_001_517a:
    ldh a, [$ae]
    ld e, a
    ldh a, [$af]
    ld d, a
    dec de
    push de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de
    call Call_001_51b2
    ld e, $16
    ldh a, [$bb]
    cp $02
    jr nz, jr_001_519b

    ld e, $0f

jr_001_519b:
    ld hl, $ffae
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    push de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    pop de

Call_001_51b2:
    and $3f
    add a
    ld hl, $51c2
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl


    db $22, $52, $23, $52, $22, $52, $22, $52, $22, $52, $22, $52, $22, $52, $22, $52

    ld [hl+], a
    ld d, d

    db $22, $52

    ld [hl+], a
    ld d, d

    db $22, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    inc hl
    ld d, d
    inc hl
    ld d, d

    db $22, $52, $23, $52

    ld [hl+], a
    ld d, d

    db $22, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    db $2d, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    db $28, $52, $32, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    db $22, $52, $22, $52

    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d
    ld [hl+], a
    ld d, d

    ret


jr_001_5223:
    ld a, $ff
    ldh [$c0], a
    ret


    bit 3, e
    ret z

    jr jr_001_5223

    bit 3, e
    ret nz

    jr jr_001_5223

    ld a, [$c0a8]
    or a
    ret nz

    jp Jump_001_5434


Call_001_523a:
    xor a
    ldh [$c0], a
    ld hl, $ffb1
    ld a, [hl+]
    sub $08
    ld c, a
    ld a, [hl]
    sbc $00
    ld b, a
    jp Jump_001_517a


Call_001_524b:
    xor a
    ldh [$c0], a
    ldh [$cd], a
    ld e, $12
    jr jr_001_526c

Call_001_5254:
Jump_001_5254:
    ldh a, [$ae]
    sub $20
    ldh a, [$af]
    sbc $00
    ret c

    xor a
    ldh [$c0], a
    ldh [$cd], a
    ld e, $16
    ldh a, [$bb]
    cp $02
    jr nz, jr_001_526c

    ld e, $0f

jr_001_526c:
    ld hl, $ffae
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    ld a, e
    ldh [$ca], a
    ldh a, [$b1]
    ld c, a
    ldh a, [$b2]
    ld b, a
    dec bc
    dec bc
    push de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_52cc
    ldh a, [$b1]
    ld c, a
    ldh a, [$b2]
    ld b, a
    inc bc
    inc bc
    pop de
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_52cc
    ldh a, [$cd]
    cp $02
    ret nz

    ldh a, [$aa]
    cp $04
    ret z

    ld a, $04
    ldh [$aa], a
    xor a
    ldh [$c1], a
    ldh [$a8], a
    ldh a, [$bb]
    cp $02
    jr nz, jr_001_52c3

    xor a
    ldh [$bc], a

jr_001_52c3:
    ldh a, [$ae]
    and $f0
    or $08
    ldh [$ae], a
    ret


Call_001_52cc:
    and $3f
    rst $00

    db $50, $53, $5d, $53, $50, $53, $50, $53, $50, $53, $50, $53, $50, $53, $69, $53

    ld d, b
    ld d, e

    db $50, $53, $50, $53, $77, $53

    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld [hl], a
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld e, l
    ld d, e
    ld e, l
    ld d, e

    db $50, $53

    ld e, l
    ld d, e
    ld d, b
    ld d, e

    db $69, $53

    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e

    db $50, $53, $58, $53, $50, $53

    ld d, b
    ld d, e
    ld d, c
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e

    db $2f, $53, $3e, $53

    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e
    ld d, b
    ld d, e

    ldh a, [$aa]
    cp $0c
    ret z

    ld a, $0c
    ldh [$aa], a
    ld a, $03
    ld [$c0b1], a
    ret


    ldh a, [$aa]
    cp $0c
    ret z

    ld a, $0c
    ldh [$aa], a
    xor a
    ld [$c0b2], a
    inc a
    ld [$c0b1], a
    ret


    ret


    ldh a, [$ca]
    bit 3, a
    ret z

    jr jr_001_535d

    ldh a, [$ca]
    bit 3, a
    ret nz

jr_001_535d:
    ldh a, [$aa]
    cp $03
    jp nz, Jump_001_5b06

    ld a, $ff
    ldh [$c0], a
    ret


    ldh a, [$ae]
    sub $18
    and $0f
    cp $04
    ret nc

    ld hl, $ffcd
    inc [hl]
    ret


    ldh a, [$aa]
    cp $03
    ret nz

    ld a, $ff
    ldh [$c0], a
    ret


Call_001_5381:
    xor a
    ldh [$cd], a
    ld [$c0aa], a
    ldh [$a9], a
    ldh a, [$b1]
    ld c, a
    ldh a, [$b2]
    ld b, a
    dec bc
    dec bc
    ldh a, [$ae]
    ld e, a
    ldh a, [$af]
    ld d, a
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]
    call Call_001_53be
    ldh a, [$b1]
    ld c, a
    ldh a, [$b2]
    ld b, a
    inc bc
    inc bc
    ldh a, [$ae]
    ld e, a
    ldh a, [$af]
    ld d, a
    call Call_001_509a
    ld e, a
    ld d, $00
    ld hl, $c700
    add hl, de
    ld a, [hl]

Call_001_53be:
    and $3f
    rst $00

    db $91, $54, $b3, $54, $c2, $54, $c8, $54, $ce, $54, $db, $54, $91, $54, $ce, $54

    db $db
    ld d, h

    db $91, $54, $ce, $54, $91, $54

    db $ec
    ld d, h
    ld a, [c]
    ld d, h
    adc $54
    ld hl, sp+$54
    inc bc
    ld d, l
    ld c, $55
    ld a, [de]
    ld d, l

    db $26, $55, $2e, $55

    ld [hl], $55

    db $91, $54

    ld a, $55
    ld c, d
    ld d, l
    sub c
    ld d, h

    db $56, $55

    xor l
    ld d, h
    sub c
    ld d, h
    adc b
    ld d, h

    db $96, $54

    db $21
    ld d, h

    db $6f, $54, $5c, $54, $5f, $54, $b3, $54

    or e
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    sub c
    ld d, h
    ld a, [$c0a8]
    or a
    jp nz, Jump_001_5491

    ldh a, [$ae]
    ld e, a
    ldh a, [$af]
    ld d, a
    call Call_001_5434
    jp Jump_001_5491


Call_001_5434:
Jump_001_5434:
    push de
    call Call_001_509a
    ld [hl], $05
    pop de
    call Call_001_5458
    ld a, l
    ld [$c404], a
    ld a, h
    ld [$c405], a
    ld a, [$c402]
    set 2, a
    ld [$c402], a
    ld a, $ff
    ld [$c0a8], a
    ld a, $5b
    jp Jump_000_0f3b


Call_001_5458:
    ld a, e
    jp Jump_001_55fc


    jp Jump_001_54b3


    ldh a, [$c3]
    cp $ff
    ret z

    ldh a, [$ae]
    and $0f
    cp $08
    jr c, jr_001_5491

    jp Jump_001_4ece


    ld a, $5c
    call Call_000_0f3b
    ld a, $10
    ldh [$b7], a
    ld a, $02
    ldh [$aa], a
    ld [$c0b0], a
    call Call_001_54b3
    ld hl, $fc70
    jp Jump_001_5e9d


    ldh a, [$ae]
    and $0f
    cp $0b
    jp nc, Jump_001_5165

Jump_001_5491:
jr_001_5491:
    ld hl, $ffcd
    inc [hl]
    ret


    ldh a, [$ae]
    bit 3, a
    jr z, jr_001_5491

    ld a, $ff
    ld [$c0aa], a
    xor a
    ldh [$bf], a
    ldh a, [$ae]
    and $f0
    or $08
    ldh [$ae], a
    ret


    ldh a, [$ae]
    bit 3, a
    jr nz, jr_001_5491

Call_001_54b3:
Jump_001_54b3:
    ld a, $ff
    ld [$c0aa], a
    xor a
    ldh [$bf], a
    ldh a, [$ae]
    and $f0
    ldh [$ae], a
    ret


    bit 3, c
    jr z, jr_001_5491

    jr jr_001_54ce

    bit 3, c
    jr nz, jr_001_5491

    jr jr_001_54ce

Call_001_54ce:
Jump_001_54ce:
jr_001_54ce:
    ldh a, [$ae]
    and $0f
    cp $04
    jr nc, jr_001_5491

    ld a, $01
    ldh [$bf], a
    ret


jr_001_54db:
    ldh a, [$ae]
    and $0f
    cp $08
    jr c, jr_001_5491

    cp $0c
    jr nc, jr_001_5491

    ld a, $02
    ldh [$bf], a
    ret


    bit 3, c
    jr z, jr_001_5491

    jr jr_001_54db

    bit 3, c
    jr nz, jr_001_5491

    jr jr_001_54db

    bit 3, c
    jr z, jr_001_5491

    ld hl, $ffa9
    set 1, [hl]
    jr jr_001_5491

    bit 3, c
    jr nz, jr_001_5491

    ld hl, $ffa9
    set 1, [hl]
    jr jr_001_5491

    call Call_001_54b3
    bit 3, c
    ret nz

    ld hl, $ffa9
    set 1, [hl]
    ret


    call Call_001_54b3
    bit 3, c
    ret z

    ld hl, $ffa9
    set 1, [hl]
    ret


    ld hl, $ffa9
    set 1, [hl]
    jp Jump_001_5491


    ld hl, $ffa9
    set 1, [hl]
    jp Jump_001_54b3


    ld hl, $ffa9
    set 1, [hl]
    jp Jump_001_54ce


    call Call_001_54ce
    bit 3, c
    ret nz

    ld hl, $ffa9
    set 1, [hl]
    ret


    call Call_001_54ce
    bit 3, c
    ret z

    ld hl, $ffa9
    set 1, [hl]
    ret


    ldh a, [$ae]
    and $0f
    cp $04
    jp nc, Jump_001_5491

    push bc
    call Call_001_55c0
    pop bc
    ld hl, $c180

jr_001_5567:
    ld a, [hl]
    or a
    jr z, jr_001_557b

    cp $ff
    jr z, jr_001_5575

    ld de, $0010
    add hl, de
    jr jr_001_5567

jr_001_5575:
    call Call_001_557b
    ld [hl], $ff
    ret


Call_001_557b:
jr_001_557b:
    push hl
    ldh a, [$9f]
    cp $01
    ld a, $1c
    jr nz, jr_001_5586

    ld a, $1e

jr_001_5586:
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld a, c
    and $f0
    or $08
    ld [hl+], a
    ld a, b
    ld [hl+], a
    xor a
    ld [hl+], a
    ldh a, [$ae]
    and $f0
    or $08
    ld [hl+], a
    ldh a, [$af]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld a, $40
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $20
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    pop bc
    push hl
    ldh a, [$9f]
    cp $01
    jr z, jr_001_55bb

    call Call_001_7004
    pop hl
    ret


jr_001_55bb:
    call Call_001_7081
    pop hl
    ret


Call_001_55c0:
    ldh a, [$ae]
    ld e, a
    ldh a, [$af]
    ld d, a
    call Call_001_509a
    ld [hl], $00
    call Call_001_55fa
    ldh a, [$9f]
    cp $01
    jr z, jr_001_55dc

    ld b, h
    ld c, l
    ld de, $0002
    jp Jump_000_0501


jr_001_55dc:
    ld a, [$c402]
    bit 3, a
    jr nz, jr_001_55f1

    set 3, a
    ld [$c402], a
    ld a, l
    ld [$c406], a
    ld a, h
    ld [$c407], a
    ret


jr_001_55f1:
    ld de, $da00
    ld bc, $0202
    jp Jump_000_061f


Call_001_55fa:
    ldh a, [$ae]

Jump_001_55fc:
    and $f0
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld d, $98
    ld a, c
    and $f0
    rrca
    rrca
    rrca
    ld e, a
    add hl, de
    ret


Call_001_560e:
    ldh a, [$aa]
    ldh [$ab], a
    rst $00

    db $1c, $5b, $7f, $58, $70, $5c, $11, $59, $f4, $57

    ld d, c
    ld e, b

    db $c7, $5e, $23, $5a, $aa, $59, $ad, $5a, $19, $57

    ld c, h
    ld d, a

    db $2f, $56, $ce, $57

    ld hl, $fe00
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    call Call_001_5c78
    ld a, [$c0b1]
    rst $00

    db $db, $56, $a9, $56, $81, $56, $47, $56

    xor a
    ld [$c0b1], a
    ld [$c0b2], a
    ld a, [$c0b3]
    cp $05
    ret nz

    ld hl, $01f8
    ld a, l
    ld [$c414], a
    ld a, h
    ld [$c415], a
    ld hl, $0160
    ld a, l
    ld [$c418], a
    ld a, h
    ld [$c419], a
    ld hl, $4a31
    ld a, l
    ldh [$a2], a
    ld a, h
    ldh [$a3], a
    ld hl, $78ca
    ld de, $c700
    ld bc, $0030
    ld a, $04
    jp LoadGameGfx


    call Call_001_569a
    ld a, [$c0b2]
    inc a
    ld [$c0b2], a
    cp $0d
    ret c

    ld a, [$c0b1]
    inc a
    ld [$c0b1], a
    xor a
    ld [$c0b2], a
    ret


Call_001_569a:
    ld hl, $6411
    ld a, [$c0b2]
    ld c, a
    add $c0
    ld e, a
    ld d, $05
    jp Jump_000_0522


    call Call_001_56c2
    ld a, [$c0b2]
    inc a
    ld [$c0b2], a
    cp $3b
    ret c

    ld a, [$c0b1]
    inc a
    ld [$c0b1], a
    xor a
    ld [$c0b2], a
    ret


Call_001_56c2:
    ld hl, $3572
    ld a, [$c0b3]
    cp $02
    jr z, jr_001_56cf

    ld hl, $3902

jr_001_56cf:
    ld a, [$c0b2]
    ld c, a
    add $45
    ld e, a
    ld d, $00
    jp Jump_000_0532


    call Call_001_5707
    ld hl, $ff90
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    call Call_000_0a69
    ld a, [$c0b2]
    inc a
    ld [$c0b2], a
    cp $80
    ret c

    ld a, $ff
    ld [$c0b0], a
    ld a, $02
    ldh [$aa], a
    ld a, [$c0b3]
    inc a
    ld [$c0b3], a
    ret


Call_001_5707:
    ld a, [$c0b2]
    cp $20
    ret nc

    ld hl, $ffae
    ld a, [hl]
    sub $01
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    ret


    call Call_001_5381
    ld a, $15
    ldh [$a6], a
    ld hl, $ffbd
    dec [hl]
    ld a, [hl]
    cp $16
    jr z, jr_001_573a

    or a
    ret nz

    ld a, $80
    ld [$c0ab], a
    ld hl, $ffbe
    res 3, [hl]
    set 1, [hl]
    jp Jump_001_5e0b


jr_001_573a:
    call Call_000_0eeb
    ld hl, $ffb0
    ld de, $0200
    ldh a, [$ac]
    or a
    jp z, Jump_001_4bee

    jp Jump_001_4be3


    ld hl, $ffb3
    ld a, [hl]
    add $14
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jr nz, jr_001_5764

    cp $04
    jr c, jr_001_5764

    ld a, $04
    ld [hl-], a
    ld [hl], $00

jr_001_5764:
    call Call_001_4ea3
    ld hl, $57b9
    ldh a, [$bb]
    rst $38
    ld a, [hl]

jr_001_576e:
    ldh [$a6], a
    ld a, $ff
    ldh [$96], a
    ld hl, $ffae
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$90]
    ld e, a
    ldh a, [$91]
    ld d, a
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ret c

    ldh a, [$a4]
    cp $b0
    ret c

    cp $f0
    ret nc

    xor a
    ldh [$bb], a
    xor a
    ldh [$be], a
    xor a
    ldh [$b9], a
    ld hl, $ffba
    ld a, [hl]
    or a
    jr z, @+$21

    dec [hl]
    call Call_000_0e8c
    ld a, $02
    ldh [$8e], a
    ldh [$8f], a
    ld a, $01
    ld [$c0a9], a
    ld a, [$c0a8]
    or a
    ret z

    ld a, $02
    ld [$c0a9], a
    ret


    dec d
    add hl, de
    dec e
    add hl, de
    jr jr_001_576e

    ld [$c0a9], a
    ld a, $04
    ldh [$8e], a
    ld a, $01
    ld [$d93d], a
    ldh [$8f], a
    ret


    call Call_001_581c
    ldh a, [$c4]
    or a
    call z, Call_001_5b06
    jr jr_001_57f7

Call_001_57d9:
    ldh a, [$bb]
    cp $02
    jr nz, jr_001_57e2

    xor a
    ldh [$bc], a

jr_001_57e2:
    ld a, $0d
    ldh [$aa], a
    xor a
    ldh [$c1], a
    ldh [$a8], a
    ldh a, [$bb]
    cp $02
    ret z

    xor a
    ldh [$bc], a
    ret


    call Call_001_5812

jr_001_57f7:
    ldh a, [$c1]
    or a
    ret z

    ld h, $0a
    ld l, $04
    ld e, $00
    call Call_001_5b7f
    ld hl, $580e
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


    db $12, $13, $12, $14

Call_001_5812:
    call Call_001_5254
    ldh a, [$cd]
    cp $02
    jp nz, Jump_001_5b06

Call_001_581c:
    ldh a, [$8b]
    rrca
    jp c, Jump_001_5e78

    ldh a, [$8a]
    or a
    jr z, jr_001_5834

    bit 4, a
    jr nz, jr_001_583c

    bit 5, a
    jr nz, jr_001_5846

    bit 7, a
    jp nz, Jump_001_5b06

jr_001_5834:
    xor a
    ldh [$c1], a
    ld a, $12
    ldh [$a6], a
    ret


jr_001_583c:
    ld a, $01
    ldh [$c1], a
    xor a
    ldh [$ac], a
    jp Jump_001_4e48


jr_001_5846:
    ld a, $01
    ldh [$c1], a
    ld a, $ff
    ldh [$ac], a
    jp Jump_001_4e48


    ld hl, $ffbe
    set 0, [hl]
    ld h, $08
    ld l, $09
    ld e, $00
    call Call_001_5b7f
    ld hl, $586d
    ldh a, [$a8]
    cp $08
    jr nc, @+$10

    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


    ld [$0a09], sp
    dec bc
    ld [$0a09], sp
    dec bc
    ld [$bef0], sp
    res 0, a
    ldh [$be], a
    jp Jump_001_5e0b


    call Call_001_5afe
    ldh a, [$8a]
    cp $80
    jr z, jr_001_58d9

    ld a, $0c
    ldh [$a6], a
    ldh a, [$8a]
    bit 7, a
    jp z, Jump_001_5e0b

    bit 0, a
    jr nz, jr_001_58ae

    bit 5, a
    jr nz, jr_001_58a0

    bit 4, a
    jr nz, jr_001_58a8

    ret


jr_001_58a0:
    ld a, $ff
    ldh [$ac], a
    xor a
    ldh [$bd], a
    ret


jr_001_58a8:
    xor a
    ldh [$ac], a
    ldh [$bd], a
    ret


Jump_001_58ae:
jr_001_58ae:
    call Call_001_5381
    ld a, [$c0aa]
    or a
    ret nz

    ld hl, $0100
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    call Call_001_4ea3
    call Call_001_4ea3
    call Call_001_4ea3
    call Call_001_4ea3
    ldh a, [$aa]
    cp $0b
    ret z

    ld a, $02
    ldh [$aa], a
    ld a, $0f
    ldh [$a6], a
    ret


jr_001_58d9:
    call Call_001_58f5
    ld a, $0c
    ldh [$a6], a
    ldh a, [$bb]
    or a
    ret nz

    ldh a, [$bd]
    inc a
    ldh [$bd], a
    cp $80
    ret c

    ld a, $80
    ldh [$bd], a
    ld a, $0d
    ldh [$a6], a
    ret


Call_001_58f5:
    ld hl, $0100
    call Call_001_4e30
    call Call_001_50a1
    ld hl, $ff00
    call Call_001_4e30
    ldh a, [$aa]
    cp $03
    ret nz

    ld hl, $0100
    call Call_001_4e30
    pop af
    ret


    call Call_001_5935
    ldh a, [$c1]
    rst $00

    db $1b, $59, $20, $59

    ld a, $10
    ldh [$a6], a
    ret


    ld h, $0a
    ld l, $02
    ld e, $00
    call Call_001_5b7f
    ld hl, $5933
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


    db $10, $11

Call_001_5935:
    ldh a, [$8a]
    bit 6, a
    jr nz, jr_001_594c

    bit 7, a
    jr nz, jr_001_5965

    ldh a, [$8b]
    bit 0, a
    jp nz, Jump_001_5e78

    xor a
    ldh [$c1], a
    jp Jump_001_50a1


jr_001_594c:
    ld a, $01
    ldh [$c1], a
    ld hl, $ff00
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    call Call_001_524b
    ldh a, [$c0]
    or a
    call z, Call_001_4ea3
    jp Jump_001_50a1


jr_001_5965:
    ld a, $01
    ldh [$c1], a
    ld hl, $0100
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    call Call_001_4ea3
    jp Jump_001_50a1


Jump_001_5978:
    ldh a, [$bc]
    or a
    ret nz

    ldh a, [$bb]
    or a
    ret z

    cp $01
    jp z, Jump_001_59e7

    cp $04
    jp z, Jump_001_5a88

    cp $03
    jp z, Jump_001_59a5

    ld a, $4e
    call Call_000_0f3b
    ld hl, $c0ad
    xor a
    ld [hl+], a
    ld [hl], a
    ld [$c0bf], a
    ldh [$a8], a
    ldh [$a7], a
    inc a
    ldh [$bc], a
    ret


Jump_001_59a5:
    ld de, $0a08
    jr jr_001_59ea

    call Call_001_5381
    ld e, $05
    call Call_001_59fe
    ld hl, $ffbd
    dec [hl]
    ret nz

    ld a, $4f
    call Call_000_0f3b
    ld a, [$c0ac]
    ldh [$aa], a
    ld a, $02
    call Call_001_5aea
    ld b, $0a
    ld a, [$c0ac]
    or a
    jr nz, jr_001_59d0

    ld b, $04

jr_001_59d0:
    ld a, b
    call Call_001_5a7d
    call Call_001_5ae3
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, [$c0ac]
    or a
    ret nz

    ld a, $20
    ld [$c0c9], a
    ret


Jump_001_59e7:
    ld de, $0e07

Jump_001_59ea:
jr_001_59ea:
    ldh a, [$aa]
    ld [$c0ac], a
    ld a, d
    ldh [$bd], a
    ld a, e
    ldh [$aa], a
    ld hl, $c0ad
    xor a
    ld [hl+], a
    ld [hl], a
    ret


Call_001_59fc:
    ld e, $07

Call_001_59fe:
    ld hl, $c0ad
    ld a, [hl]
    or a
    jr z, jr_001_5a14

    ldh a, [$bd]
    cp e
    ret nc

    inc hl
    ld a, [hl]
    or a
    ret nz

    inc [hl]
    ldh a, [$a6]
    inc a
    ldh [$a6], a
    ret


jr_001_5a14:
    inc [hl]
    ld a, $17
    ldh [$a6], a
    ld a, [$c0ac]
    or a
    ret z

    ld a, $15
    ldh [$a6], a
    ret


    call Call_001_5381
    call Call_001_59fc
    ld hl, $ffbd
    dec [hl]
    ret nz

    ld a, $4c
    call Call_000_0f3b
    ld a, [$c0ac]
    ldh [$aa], a
    ld a, $03
    ldh [$bc], a
    ld hl, $c0bf
    call Call_001_5a45
    ld hl, $c0cb

Call_001_5a45:
    ld a, $01
    ld [hl+], a
    ldh a, [$ac]
    and $01
    ld [hl+], a
    ld a, $0a
    call Call_001_5a63
    call Call_001_5ae3
    ld a, $0a
    call Call_001_5a7d
    call Call_001_5ae3
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ret


Call_001_5a63:
    ld c, a
    ldh a, [$ac]
    or a
    jr nz, jr_001_5a73

    ldh a, [$b1]
    add c
    ld c, a
    ldh a, [$b2]
    adc $00
    ld b, a
    ret


jr_001_5a73:
    ldh a, [$b1]
    sub c
    ld c, a
    ldh a, [$b2]
    sbc $00
    ld b, a
    ret


Call_001_5a7d:
    ld c, a
    ldh a, [$ae]
    sub c
    ld c, a
    ldh a, [$af]
    sbc $00
    ld b, a
    ret


Jump_001_5a88:
    ldh a, [$aa]
    or a
    ret nz

    ld de, $0009
    jp Jump_001_59ea


Call_001_5a92:
    ldh a, [$bd]
    cp $0a
    jr c, jr_001_5aa3

    cp $14
    jr z, jr_001_5ac1

    jr nc, jr_001_5aa8

    ld a, $16
    ldh [$a6], a
    ret


jr_001_5aa3:
    ld a, $15
    ldh [$a6], a
    ret


jr_001_5aa8:
    ld a, $17
    ldh [$a6], a
    ret


    call Call_001_5381
    call Call_001_5a92
    ldh a, [$bd]
    inc a
    ldh [$bd], a
    cp $32
    ret c

    ld a, [$c0ac]
    ldh [$aa], a
    ret


jr_001_5ac1:
    ld a, $50
    call Call_000_0f3b
    ld a, $03
    call Call_001_5aea
    ld hl, $c0bf
    ld a, $03
    ld [hl+], a
    ldh a, [$ac]
    and $01
    ld [hl+], a
    ld a, $0a
    call Call_001_5a63
    call Call_001_5ae3
    ld a, $06
    call Call_001_5a7d

Call_001_5ae3:
jr_001_5ae3:
    xor a
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, b
    ld [hl+], a
    ret


Call_001_5aea:
    ld hl, $c0bf
    ld [hl+], a
    ldh a, [$ac]
    and $01
    ld [hl+], a
    ld a, $01
    ldh [$bc], a
    ld a, $0a
    call Call_001_5a63
    jr jr_001_5ae3

Call_001_5afe:
Jump_001_5afe:
    call Call_001_5381
    ldh a, [$cd]
    cp $02
    ret nz

Call_001_5b06:
Jump_001_5b06:
    ldh a, [$c4]
    or a
    ret nz

    ld a, $20
    ldh [$b7], a
    ld a, $02
    ldh [$aa], a
    xor a
    ldh [$b3], a
    ldh [$b4], a
    ld a, $0f
    ldh [$a6], a
    ret


    call Call_001_4e05
    call Call_001_5bc0
    ldh a, [$aa]
    or a
    ret nz

    ldh a, [$bb]
    cp $02
    jr nz, jr_001_5b31

    ldh a, [$bc]
    or a
    jr nz, jr_001_5b3a

jr_001_5b31:
    ldh a, [$c1]
    rst $00

    db $63, $5b, $68, $5b, $9c, $5b

jr_001_5b3a:
    ldh a, [$c1]
    or a
    jr nz, jr_001_5b51

    ld hl, $5b4b
    ld a, l
    ldh [$c5], a
    ld a, h
    ldh [$c6], a
    jp Jump_001_5cd3


    db $15, $16, $16, $16, $15, $15

jr_001_5b51:
    ld hl, $5b5d
    ld a, l
    ldh [$c5], a
    ld a, h
    ldh [$c6], a
    jp Jump_001_5cd3


    db $15, $16, $16, $17, $15, $1b

    ld a, $04
    ldh [$a6], a
    ret


    ld h, $0a
    ld l, $04
    ld e, $00
    call Call_001_5b7f
    ld hl, $5b7b
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


    db $04, $05, $04, $06

Call_001_5b7f:
    ldh a, [$a7]
    inc a
    ldh [$a7], a
    cp h
    jr c, jr_001_5b98

    xor a
    ldh [$a7], a
    ldh a, [$a8]
    inc a
    ldh [$a8], a

jr_001_5b8f:
    cp e
    jr c, jr_001_5b94

    cp l
    ret c

jr_001_5b94:
    ld a, e
    ldh [$a8], a
    ret


jr_001_5b98:
    ldh a, [$a8]
    jr jr_001_5b8f

    ld h, $0a
    ld l, $05
    ld e, $00
    call Call_001_5b7f
    ld hl, $5bbb
    ldh a, [$a8]
    cp $04
    jr nc, jr_001_5bb3

    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


jr_001_5bb3:
    xor a
    ldh [$c1], a
    ldh [$a8], a
    ldh [$bd], a
    ret


    db $04, $07, $04

    rlca
    inc b

Call_001_5bc0:
    ldh a, [$8a]
    bit 7, a
    jr nz, jr_001_5c1a

    ldh a, [$8b]
    rrca
    jr c, jr_001_5c17

    rrca
    jp c, Jump_001_5978

jr_001_5bcf:
    ldh a, [$8a]
    or a
    jr z, jr_001_5be0

    bit 4, a
    jr nz, jr_001_5c35

    bit 5, a
    jr nz, jr_001_5c59

    bit 6, a
    jr nz, jr_001_5bfb

jr_001_5be0:
    call Call_001_5afe
    xor a
    ldh [$c1], a
    ldh a, [$bb]
    or a
    ret nz

    ldh a, [$bd]
    inc a
    ldh [$bd], a
    cp $80
    ret c

    ld a, $80
    ldh [$bd], a
    ld a, $02
    ldh [$c1], a
    ret


jr_001_5bfb:
    ld hl, $ff00
    call Call_001_4e30
    call Call_001_50a1
    ld hl, $0100
    call Call_001_4e30
    ldh a, [$aa]
    cp $03
    jr nz, jr_001_5be0

    ld hl, $ff00
    call Call_001_4e30
    ret


jr_001_5c17:
    jp Jump_001_5e78


jr_001_5c1a:
    ldh a, [$bb]
    cp $02
    jr z, jr_001_5c2a

    ld a, $01
    ldh [$aa], a
    xor a
    ldh [$bd], a
    ldh [$c1], a
    ret


jr_001_5c2a:
    call Call_001_58f5
    ldh a, [$8a]
    rrca
    jp c, Jump_001_58ae

    jr jr_001_5bcf

jr_001_5c35:
    xor a
    ldh [$bd], a
    ld a, $01
    ldh [$c1], a
    xor a
    ldh [$ac], a
    ld a, [$c0b6]
    cp $ff
    jr nz, jr_001_5c4d

    ldh a, [$a5]
    cp $9c
    jp nc, Jump_001_4e48

jr_001_5c4d:
    call Call_001_516c
    ldh a, [$c0]
    or a
    call z, Call_001_4e48
    jp Jump_001_5afe


jr_001_5c59:
    xor a
    ldh [$bd], a
    ld a, $01
    ldh [$c1], a
    ld a, $ff
    ldh [$ac], a
    call Call_001_523a
    ldh a, [$c0]
    or a
    call z, Call_001_4e48
    jp Jump_001_5afe


    call Call_001_5d77
    ldh a, [$aa]
    cp $02
    ret nz

Call_001_5c78:
    ldh a, [$bb]
    rst $00

    db $85, $5c, $92, $5c, $c5, $5c, $b0, $5c, $85, $5c

    ld a, $0e
    ldh [$a6], a
    ldh a, [$b4]
    rlca
    ret c

    ld a, $0f
    ldh [$a6], a
    ret


    ldh a, [$aa]
    cp $02
    call z, Call_001_5e2f
    ldh a, [$b4]
    rlca
    jr nc, jr_001_5ca3

    ld a, $0e
    ldh [$a6], a
    ret


jr_001_5ca3:
    ld hl, $c0b0
    bit 7, [hl]
    ret nz

    set 7, [hl]
    ld a, $0f
    ldh [$a6], a
    ret


jr_001_5cb0:
    ld h, $0a
    ld l, $02
    ld e, $00
    call Call_001_5b7f
    ld hl, $5cc3
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


    db $0e, $0f

    ldh a, [$bc]
    or a
    jr z, jr_001_5cb0

    ld hl, $5d71
    ld a, l
    ldh [$c5], a
    ld a, h
    ldh [$c6], a

Jump_001_5cd3:
    call Call_001_5d04
    ldh a, [$a4]
    sub $0c
    ld [$c0c8], a
    ld a, $04
    ldh [$d2], a
    ld de, $1606
    ld a, [$c0ad]
    cp $01
    jr nz, jr_001_5cee

    ld de, $1c0c

jr_001_5cee:
    ld a, e
    ldh [$d1], a
    ldh a, [$ac]
    or a
    jr nz, jr_001_5cfd

    ldh a, [$a5]
    add d
    ld [$c0c7], a
    ret


jr_001_5cfd:
    ldh a, [$a5]
    sub d
    ld [$c0c7], a
    ret


Call_001_5d04:
    ld a, [$c0ad]
    rst $00

    db $0e, $5d, $2f, $5d, $50, $5d

    ld h, $08
    ld l, $03
    ld e, $00
    call Call_001_5b7f
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ld hl, $c0ae
    inc [hl]
    ld a, [hl]
    cp $10
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ret


    ld h, $08
    ld l, $04
    ld e, $02
    call Call_001_5b7f
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ld hl, $c0ae
    inc [hl]
    ld a, [hl]
    cp $b4
    ret c

    xor a
    ld [hl-], a
    inc [hl]
    ret


    ld h, $08
    ld l, $06
    ld e, $04
    call Call_001_5b7f
    ld hl, $ffc5
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ld hl, $c0ae
    inc [hl]
    ld a, [hl]
    cp $78
    ret c

    xor a
    ldh [$bc], a
    ret


    db $18, $19, $19, $1a, $18, $1c

Call_001_5d77:
    ldh a, [$8b]
    bit 1, a
    jp nz, Jump_001_5978

    ldh a, [$8a]
    rrca
    call nc, Call_001_5d96
    ldh a, [$8a]
    bit 6, a
    jr nz, jr_001_5db6

jr_001_5d8a:
    ldh a, [$8a]
    bit 4, a
    jr nz, jr_001_5dc0

    bit 5, a
    jr nz, jr_001_5dd0

    jr jr_001_5ddf

Call_001_5d96:
    ld a, [$c0b0]
    or a
    ret nz

    ldh a, [$b4]
    rlca
    ret nc

    ld hl, $ffb3
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0100
    add hl, de
    bit 7, h
    ret z

    ld hl, $ff00
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    ret


jr_001_5db6:
    call Call_001_50a1
    ldh a, [$aa]
    cp $03
    jr nz, jr_001_5d8a

    ret


jr_001_5dc0:
    xor a
    ldh [$ac], a
    call Call_001_516c
    ldh a, [$c0]
    or a
    jr nz, jr_001_5ddf

    call Call_001_4e48
    jr jr_001_5ddf

jr_001_5dd0:
    ld a, $ff
    ldh [$ac], a
    call Call_001_523a
    ldh a, [$c0]
    or a
    jr nz, jr_001_5ddf

    call Call_001_4e48

jr_001_5ddf:
    ldh a, [$b7]
    ld b, a
    ld hl, $ffb3
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    bit 7, a
    jp nz, Jump_001_5e72

    cp $04
    jr c, jr_001_5dfa

    ld a, $04
    ld [hl-], a
    ld [hl], $00

jr_001_5dfa:
    call Call_001_4ea3
    call Call_001_5381
    ld hl, $ffaa
    ld a, [hl+]
    cp [hl]
    ret nz

    ldh a, [$cd]
    cp $02
    ret z

Call_001_5e0b:
Jump_001_5e0b:
    call Call_001_4e05

Jump_001_5e0e:
    xor a
    ldh [$aa], a
    ldh [$b3], a
    ldh [$b4], a
    ldh [$bd], a
    ldh [$c1], a
    ldh [$a8], a
    ld [$c0af], a
    ld [$c0b0], a

Call_001_5e21:
    ld a, $03
    ldh [$c2], a
    ldh a, [$bb]
    cp $03
    ret nz

    ld a, $04
    ldh [$c2], a
    ret


Call_001_5e2f:
    ldh a, [$8b]
    rrca
    jr nc, jr_001_5e5e

    ld a, $4b
    call Call_000_0f3b
    ldh a, [$a6]
    cp $0e
    jr nz, jr_001_5e42

    inc a
    jr jr_001_5e44

jr_001_5e42:
    ld a, $0e

jr_001_5e44:
    ldh [$a6], a
    ld hl, $c0af
    ld a, [hl]
    add $1e
    cp $3d
    jr c, jr_001_5e52

    ld a, $3c

jr_001_5e52:
    ld [hl], a
    cp $1f
    ret c

jr_001_5e56:
    xor a
    ldh [$b7], a
    ldh [$b3], a
    ldh [$b4], a
    ret


jr_001_5e5e:
    ldh a, [$b4]
    rlca
    ret c

    ld a, $20
    ldh [$b7], a
    ld hl, $c0af
    ld a, [hl]
    or a
    ret z

    dec [hl]
    cp $37
    jr nc, jr_001_5e56

    ret


Jump_001_5e72:
    call Call_001_4ea3
    jp Jump_001_5254


Jump_001_5e78:
    ld a, $02
    ldh [$aa], a
    ld a, $42
    call Call_000_0f3b
    ld a, $20
    ldh [$b7], a
    ldh a, [$c2]
    and $07
    rst $00

    sbc d
    ld e, [hl]
    and h
    ld e, [hl]
    xor c
    ld e, [hl]

    db $ae, $5e, $b3, $5e

    cp b
    ld e, [hl]
    cp l
    ld e, [hl]
    db $c2
    ld e, [hl]

Call_001_5e9a:
    ld hl, $0000

Jump_001_5e9d:
jr_001_5e9d:
    ld a, l
    ldh [$b3], a
    ld a, h
    ldh [$b4], a
    ret


    ld hl, $ff00
    jr jr_001_5e9d

    ld hl, $fe00
    jr jr_001_5e9d

Jump_001_5eae:
    ld hl, $fd00
    jr jr_001_5e9d

    ld hl, $fc70
    jr jr_001_5e9d

    ld hl, $fc00
    jr jr_001_5e9d

    ld hl, $fb80
    jr jr_001_5e9d

    ld hl, $fb00
    jr jr_001_5e9d

    ldh a, [$c1]
    or a
    jr z, jr_001_5f1f

    ld h, $0c
    ld l, $03
    ld e, $00
    call Call_001_5b7f
    ld hl, $5ef1
    ldh a, [$a8]
    cp $02
    jr z, jr_001_5ef4

    rst $38
    ld a, [hl]
    ldh [$a6], a
    cp $03
    ret nz

    ld a, $04
    ldh [$a6], a
    call Call_001_454b
    ld a, $03
    ldh [$a6], a
    ret


    ld [bc], a

    db $03

    inc bc

jr_001_5ef4:
    ld a, $04
    ldh [$a6], a
    call Call_000_0e02
    ld a, $80
    ld [$c0ab], a
    ld hl, $ffbe
    set 1, [hl]
    res 4, [hl]
    call Call_001_5e0b
    ldh a, [$bb]
    cp $04
    ret nz

    call Call_000_0963
    ld hl, $d998
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [$b5], a
    ld a, h
    ldh [$b6], a
    ret


jr_001_5f1f:
    call Call_001_5f40
    ldh a, [$a7]
    cp $01
    ld a, $48
    call z, Call_000_0f3b
    ld h, $0c
    ld l, $02
    ld e, $00
    call Call_001_5b7f
    ld hl, $5f3e
    ldh a, [$a8]
    rst $38
    ld a, [hl]
    ldh [$a6], a
    ret


    db $00, $01

Call_001_5f40:
    call Call_001_5f4d
    rst $28
    cp $54
    ret c

    ldh a, [$c1]
    inc a
    ldh [$c1], a
    ret


Call_001_5f4d:
    ld hl, $5f68
    ldh a, [$bb]
    rst $20
    ldh a, [$bd]
    bit 7, a
    jr nz, jr_001_5f62

    ld c, a
    add $13
    ld e, a
    ld d, $05
    call Call_000_0522

jr_001_5f62:
    ldh a, [$bd]
    inc a
    ldh [$bd], a
    ret


    db $31, $41, $a1, $45, $a1, $53, $41, $4f, $d1, $4a

    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jp nz, Jump_001_4bbd

    call Call_001_5f8b

jr_001_5f7f:
    ld hl, $2c85
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_5f8b:
    ld e, $0a
    ld d, $11
    call Call_001_5f9e
    ret nc

    ld a, $45
    call Call_000_0f3b
    xor a
    ld [bc], a
    inc a
    jp Jump_000_0eba


Call_001_5f9e:
    ldh a, [$c3]
    cp $ff
    ret z

    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    rst $28
    cp e
    ret nc

    ldh a, [$d4]
    ld h, a
    ldh a, [$a4]
    sub $0c
    sub h
    rst $28
    cp d
    ret


    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_5fda

    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jp nz, Jump_001_4bbd

    ld e, $0a
    ld d, $11
    call Call_001_5f9e
    ret nc

    ld a, $44
    call Call_000_0f3b
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


jr_001_5fda:
    call Call_001_5fe6
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    ret nz

    jr jr_001_5f7f

Call_001_5fe6:
    call Call_001_5ff0
    ret c

    xor a
    ld [bc], a
    inc a
    jp Jump_000_0eba


Call_001_5ff0:
    ld hl, $0005
    add hl, bc
    ld de, $0100
    call Call_001_4bee
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    push af
    ld hl, $6022
    rst $38
    ld a, [hl]
    or a
    jr z, jr_001_601e

    rlca
    jr c, jr_001_6016

    inc de
    jr jr_001_6017

jr_001_6016:
    dec de

jr_001_6017:
    ld hl, $0003
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d

jr_001_601e:
    pop af
    cp $20
    ret


    db $01, $01, $01, $00, $00, $00, $00, $00, $ff, $00, $00, $00, $01, $00, $00, $00
    db $ff, $00, $00, $00, $01, $00, $00, $00, $ff, $00, $00, $00, $01, $00, $00, $00
    db $cd

    add h
    ld c, e

    ret nz

    ldh a, [$d5]
    or a
    jp nz, Jump_001_4bbd

    call Call_001_605b

jr_001_604f:
    ld hl, $2c9f
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_605b:
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    xor a
    ld [bc], a
    jp Jump_000_0ef9


    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_608b

    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jp nz, Jump_001_4bbd

    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $44
    call Call_000_0f3b
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


jr_001_608b:
    call Call_001_6097
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    ret nz

    jr jr_001_604f

Call_001_6097:
    call Call_001_5ff0
    ret c

    xor a
    ld [bc], a
    jp Jump_000_0ef9


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_60b7

jr_001_60ab:
    ld hl, $2c8e
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_60b7:
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call Call_000_0f3b
    xor a
    ld [bc], a
    inc a
    jp Jump_000_0ed7


    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_60ed

    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jp nz, Jump_001_4bbd

    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $44
    call Call_000_0f3b
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


jr_001_60ed:
    call Call_001_60f9
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    ret nz

    jr jr_001_60ab

Call_001_60f9:
    call Call_001_5ff0
    ret c

    xor a
    ld [bc], a
    inc a
    jp Jump_000_0ed7


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_611a
    ld hl, $2c41
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_611a:
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call Call_000_0f3b
    ldh a, [$bb]
    ld [$c0be], a
    ld hl, $ffbe
    res 2, [hl]
    ld a, $01
    ldh [$bb], a

Jump_001_6135:
jr_001_6135:
    xor a
    ld [bc], a
    jp Jump_001_4dc7


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6151
    ld hl, $2c74
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_6151:
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call Call_000_0f3b
    ldh a, [$bb]
    ld [$c0be], a
    ld hl, $ffbe
    res 2, [hl]
    ld a, $02
    ldh [$bb], a
    jr jr_001_6135

    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6185
    ld hl, $2c63
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_6185:
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ld a, $45
    call Call_000_0f3b
    ldh a, [$bb]
    ld [$c0be], a
    ld hl, $ffbe
    res 2, [hl]
    ld a, $03
    ldh [$bb], a
    jp Jump_001_6135


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_61ba
    ld hl, $2c52
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_61ba:
    ld e, $0e
    ld d, $12
    call Call_001_5f9e
    ret nc

    ldh a, [$bb]
    ld [$c0be], a
    ld hl, $ffbe
    set 2, [hl]
    ld a, $04
    ldh [$bb], a
    ld hl, $0600
    ld a, l
    ld [$c0a6], a
    ld a, h
    ld [$c0a7], a
    jp Jump_001_6135


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    ld a, [bc]
    or $80
    ld [bc], a
    call Call_001_61f6
    call Call_001_6273
    call Call_001_6279
    jp Jump_001_4c06


Call_001_61f6:
    xor a
    ldh [$9d], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    db $06, $62

    ld b, d
    ld h, d

    db $42, $62, $52, $62

    ld a, $13
    ldh [$d6], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    ld a, [hl]
    cp $08
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    ld de, $fd60
    ld hl, $000a
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ldh a, [$d3]
    ld hl, $ffa5
    sub [hl]
    rst $28
    cp $40
    ret nc

    ld de, $00b0
    ld a, [$dffe]
    or a
    jr z, jr_001_623a

    ld de, $0100

jr_001_623a:
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


    pop af
    ld a, $12
    ldh [$d6], a
    ld hl, $0008
    add hl, bc
    xor a
    ld [hl+], a
    ld [hl], $01
    jp Jump_001_6311


    ld a, $12
    ldh [$d6], a
    call Call_001_4bd4
    ld hl, $000a
    call Call_001_6323
    ld hl, $000a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $fd80
    add hl, de
    ld a, h
    or l
    ret nz

    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Call_001_6273:
    ld de, $0408
    jp Jump_001_6345


Call_001_6279:
    ld d, $05
    jp Jump_001_63aa


    call Call_001_6292
    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6342
    call Call_001_63a8
    jp Jump_001_4c06


Call_001_6292:
    call Call_001_629e
    rst $00

    db $af, $62

    and $62

    db $0c, $63

    inc c
    ld h, e

Call_001_629e:
    xor a
    ldh [$9d], a
    ld h, b
    ld l, c
    ld a, [hl+]
    rlca
    jr nc, jr_001_62ab

    ld a, $01
    ldh [$9d], a

jr_001_62ab:
    ld a, [hl]
    and $03
    ret


    ld hl, $62e2
    call Call_001_62cb
    call Call_001_4bd4

Jump_001_62b8:
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld d, h
    ld e, l
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor $80
    ld [bc], a
    ret


Call_001_62cb:
Jump_001_62cb:
    ld d, $08

Call_001_62cd:
    push hl
    ld hl, $000c
    add hl, bc
    ld e, $04
    call Call_001_4bf9
    ld hl, $000b
    add hl, bc
    ld a, [hl]
    pop hl
    rst $38
    ld a, [hl]
    ldh [$d6], a
    ret


    db $00, $01, $00, $02

    pop af
    ld a, $03
    ldh [$d6], a

Jump_001_62eb:
    call Call_001_62f8
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    ret nz

    jp Jump_001_4c06


Call_001_62f8:
    ld hl, $0002
    add hl, bc
    dec [hl]
    ret nz

    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ld hl, $000e
    add hl, bc
    bit 6, [hl]
    jp nz, Jump_001_6444

    ret


    pop af
    ld a, $03
    ldh [$d6], a

Jump_001_6311:
    call Call_001_6320
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jp z, Jump_001_4c06

    xor a
    ld [bc], a
    ret


Call_001_6320:
    ld hl, $0008

Call_001_6323:
    add hl, bc
    ld a, [hl]
    add $20
    ld e, a
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld d, a
    ld [hl], a

Call_001_632e:
    ld hl, $0005
    add hl, bc
    bit 7, d
    jp z, Jump_001_4be3

    ld a, e
    add [hl]
    ld [hl+], a
    ld a, d
    adc [hl]
    ld [hl+], a
    ld a, [hl]
    adc $ff
    ld [hl], a
    ret


Call_001_6342:
    ld de, $040c

Jump_001_6345:
    ldh a, [$bc]
    or a
    ret z

    rrca
    push af
    push de
    call c, Call_001_6355
    pop de
    pop af
    rrca
    jr c, jr_001_6389

    ret


Call_001_6355:
    ld hl, $c0c7
    ldh a, [$d1]
    add d
    ld d, a
    ldh a, [$d4]
    sub e
    ldh [$c9], a
    ldh a, [$d2]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    ld a, [bc]
    and $7f
    cp $05
    ldh a, [$bb]
    jr nc, jr_001_6376

    cp $04
    jr z, jr_001_63b1

jr_001_6376:
    cp $04
    jr z, jr_001_63c5

    cp $02
    jr z, jr_001_63b1

    xor a
    ld [$c0bf], a
    ld hl, $ffbc
    res 0, [hl]
    jr jr_001_63b1

jr_001_6389:
    ld hl, $c0d3
    ldh a, [$d1]
    add d
    ld d, a
    ldh a, [$d4]
    sub e
    ldh [$c9], a
    ldh a, [$d2]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    xor a
    ld [$c0cb], a
    ld hl, $ffbc
    res 1, [hl]
    jr jr_001_63b1

Call_001_63a8:
    ld d, $00

Jump_001_63aa:
    call Call_001_4c18
    call Call_001_4c9e
    ret nc

Jump_001_63b1:
jr_001_63b1:
    ld a, $52
    call Call_000_0f3b
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $1f
    jr z, jr_001_63c5

    dec [hl]
    ld a, [hl]
    and $1f
    jr nz, jr_001_63d5

Jump_001_63c5:
jr_001_63c5:
    ld h, b
    ld l, c
    inc hl
    ld [hl], $02
    ld de, $fce0
    ld hl, $0008
    add hl, bc
    ld a, e
    ld [hl+], a
    ld [hl], d
    ret


jr_001_63d5:
    ld hl, $0002
    add hl, bc
    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $01
    ret


    xor a
    ldh [$ce], a
    call Call_001_63fe
    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6486
    call Call_001_645b
    call Call_001_6342
    call Call_001_63a8
    jp Jump_001_4c06


Call_001_63fe:
    call Call_001_629e
    rst $00

    db $0a, $64

    ld a, [de]
    ld h, h

    db $22, $64, $2a, $64

    ld hl, $6416
    call Call_001_62cb
    call Call_001_4bd4
    jp Jump_001_62b8


    db $06, $07, $06, $08

    pop af
    ld a, $0b
    ldh [$d6], a
    jp Jump_001_62eb


    pop af
    ld a, $0b
    ldh [$d6], a
    jp Jump_001_6311


    ld a, $09
    ldh [$d6], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld d, a
    ld a, $0a
    ldh [$d6], a
    ld a, $04
    ldh [$ce], a
    ld a, d
    cp $b4
    ret c

Jump_001_6444:
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $80
    ld d, a
    ld a, [bc]
    and $7f
    or d
    ld [bc], a
    ld a, [hl]
    and $1f
    ld [hl], a
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Call_001_645b:
    ldh a, [$d4]
    ld e, a
    ldh a, [$a4]
    sub e
    rst $28
    cp $04
    ret nc

    ld d, $0c
    ldh a, [$ce]
    add d
    ld d, a
    call Call_001_6478
    ld e, a
    ldh a, [$a5]
    sub e
    rst $28
    cp d
    ret nc

    jp Jump_001_4ce8


Call_001_6478:
    ld a, [bc]
    rlca
    jr c, jr_001_6480

    ldh a, [$d3]
    add d
    ret


jr_001_6480:
    ldh a, [$d3]
    sub d
    ret


jr_001_6484:
    dec [hl]
    ret


Call_001_6486:
    ld e, $24

Jump_001_6488:
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    cp $03
    ret z

    ld hl, $0005
    add hl, bc
    ld a, [hl]
    or a
    jr nz, jr_001_6484

    ldh a, [$a4]
    ld d, a
    ldh a, [$d4]
    sub d
    rst $28
    cp $0e
    ret nc

    ldh a, [$d3]
    cp $f0
    ret nc

    ld d, a
    ldh a, [$a5]
    sub d
    rst $28
    cp e
    ret nc

    ld h, b
    ld l, c
    ld a, [hl]
    and $80
    ld e, a
    ld h, b
    ld l, c
    ldh a, [$a5]
    sub d
    ld a, $00
    jr nc, jr_001_64be

    set 7, a

jr_001_64be:
    cp e
    ret nz

    inc hl
    ld [hl], $03
    ld hl, $000e
    add hl, bc
    ld a, [hl]
    and $3f
    or e
    set 6, a
    ld [hl], a
    ret


    call Call_001_64e3
    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_650f
    call Call_001_6515
    jp Jump_001_4c06


Call_001_64e3:
    call Call_001_629e
    rst $00

    db $ef, $64

    rst $38
    ld h, h

    db $07, $65

    rlca
    ld h, l

    ld hl, $64fb
    call Call_001_62cb
    call Call_001_4bd4
    jp Jump_001_62b8


    db $0c, $0d, $0c, $0e

    pop af
    ld a, $0f
    ldh [$d6], a
    jp Jump_001_62eb


    pop af
    ld a, $0f
    ldh [$d6], a
    jp Jump_001_6311


Call_001_650f:
    ld de, $0410
    jp Jump_001_6345


Call_001_6515:
    ld d, $01
    call Call_001_4c18
    call Call_001_4c9e
    ret nc

    ld a, $5c
    call Call_000_0f3b
    ret


    call Call_001_653b
    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_65f3
    call Call_001_6342
    call Call_001_63a8
    jp Jump_001_4c06


Call_001_653b:
    call Call_001_629e
    rst $00

    db $47, $65

    ld d, a
    ld h, l

    db $5f, $65, $67, $65

    ld hl, $6553
    call Call_001_62cb
    call Call_001_4bd4
    jp Jump_001_62b8


    db $00, $01, $00, $02

    pop af
    ld a, $05
    ldh [$d6], a
    jp Jump_001_62eb


    pop af
    ld a, $05
    ldh [$d6], a
    jp Jump_001_6311


    ld a, $03
    ldh [$d6], a
    ld hl, $0005
    add hl, bc
    ld a, [hl]
    inc [hl]
    and $7f
    jr z, jr_001_657b

    cp $78
    ret c

    jp Jump_001_6444


jr_001_657b:
    ld hl, $c180

jr_001_657e:
    ld a, [hl]
    or a
    jr z, jr_001_6592

    cp $ff
    jr z, jr_001_658c

    ld de, $0010
    add hl, de
    jr jr_001_657e

jr_001_658c:
    call Call_001_6592
    ld [hl], $ff
    ret


Call_001_6592:
jr_001_6592:
    ld a, [bc]
    and $80
    or $0e
    ld [hl+], a

Jump_001_6598:
    xor a
    ld [hl+], a
    call Call_001_65c5
    call Call_001_65dd
    call Call_001_65ae
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


Call_001_65ae:
    push hl
    ld hl, $0008
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    and $7f
    ld d, a
    ld hl, $0040
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


Call_001_65c5:
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $0800
    call Call_001_4bdf
    inc hl
    ret


Call_001_65dd:
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $fff0
    add hl, de
    ld d, h
    ld e, l
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


Call_001_65f3:
    ld e, $50
    jp Jump_001_6488


    call Call_001_661b
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_6618

    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $02
    jr nz, jr_001_6611

    call Call_001_6645
    call Call_001_664b

jr_001_6611:
    ld a, $04
    ldh [$d6], a
    jp Jump_001_4c06


jr_001_6618:
    xor a
    ld [bc], a
    ret


Call_001_661b:
    call Call_001_629e
    rst $00

    db $27, $66, $38, $66, $3b, $66

    dec sp
    ld h, [hl]

    call Call_001_4bd4
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $60
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


    call Call_001_4bd4
    ld de, $0100
    ld hl, $0005
    add hl, bc
    jp Jump_001_4be3


Call_001_6645:
    ld de, $0404
    jp Jump_001_6345


Call_001_664b:
    ld d, $03
    jp Jump_001_63aa


    call Call_001_6664
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_6661

    call Call_001_66b3
    jp Jump_001_4c06


jr_001_6661:
    xor a
    ld [bc], a
    ret


Call_001_6664:
    call Call_001_629e
    rst $00

    db $6c, $66, $a4, $66

    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call Call_001_6693

jr_001_6678:
    ld d, $10
    ld hl, $000c
    add hl, bc
    ld e, $03
    call Call_001_4bf9
    ld hl, $000b
    add hl, bc
    ld a, [hl]
    ld hl, $6690
    rst $38
    ld a, [hl]
    ldh [$d6], a
    ret


    db $12, $13, $14

Call_001_6693:
    call Call_001_4bd4
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3c
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


    call Call_001_4bd4
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call Call_001_4bee
    jr jr_001_6678

Call_001_66b3:
    ld a, [$c0b6]
    cp $ff
    ret z

    ld d, $04
    jp Jump_001_63aa


    call Call_001_66d2
    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6724
    call Call_001_672a
    jp Jump_001_4c06


Call_001_66d2:
    call Call_001_629e
    rst $00

    db $de, $66, $f4, $66, $1a, $67

    ld a, [de]
    ld h, a

    ld hl, $66ec
    ld d, $0f
    call Call_001_62cd
    call Call_001_4bd4
    jp Jump_001_62b8


    db $10, $11, $10, $12, $13, $14, $13, $14

    pop af
    ld hl, $66f0

Jump_001_66f8:
    ld d, $0f
    call Call_001_62cd
    call Call_001_670a
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    ret nz

    jp Jump_001_4c06


Call_001_670a:
    ld hl, $0002
    add hl, bc
    inc [hl]
    ld a, [hl]
    cp $b4
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ret


    pop af
    ld hl, $66f0
    call Call_001_62cb
    jp Jump_001_6311


Call_001_6724:
    ld de, $0410
    jp Jump_001_6345


Call_001_672a:
    ld d, $02
    jp Jump_001_63aa


    call Call_001_4b2e
    call Call_001_6751
    ld a, [$d931]
    or a
    jr nz, jr_001_6741

    call Call_001_684b
    call Call_001_6851

jr_001_6741:
    ld a, [$d931]
    or a
    jr z, jr_001_674e

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_674e:
    jp Jump_001_4c06


Call_001_6751:
    call Call_001_629e
    ld a, [hl]
    rst $00

    db $00, $68, $f0, $67, $d0, $67, $60, $67, $9e, $67

    ld a, $10
    ldh [$d6], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $3f
    ret c

    jr z, jr_001_677e

    cp $a0
    ld a, $11
    ldh [$d6], a
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


jr_001_677e:
    ld hl, $c180

jr_001_6781:
    ld a, [hl]
    or a
    jr z, jr_001_6795

    cp $ff
    jr z, jr_001_678f

    ld de, $0010
    add hl, de
    jr jr_001_6781

jr_001_678f:
    call Call_001_6795
    ld [hl], $ff
    ret


Call_001_6795:
jr_001_6795:
    ld a, [bc]
    and $80
    or $05
    ld [hl+], a
    jp Jump_001_6598


    ld a, $10
    ldh [$8a], a
    ldh [$8b], a
    ldh a, [$a5]
    cp $a8
    ret c

    ld a, $01
    ld [$c0a9], a
    ld a, $03
    ld [$d93d], a
    ld a, $04
    ldh [$8e], a
    ldh [$8f], a
    ldh a, [$9f]
    add a
    inc a
    ld [$d979], a
    ldh a, [$9f]
    inc a
    ldh [$9f], a
    cp $04
    ret c

    dec a
    ldh [$9f], a
    xor a
    ld [$c0a9], a
    ret


    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $67fc
    call Call_001_62cb
    call Call_001_6320
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $01
    ld [hl+], a
    ld [hl], $04
    ret


    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $67fc
    jp Jump_001_66f8


    db $15, $16, $15, $16

    call Call_001_6810
    ld hl, $680c
    call Call_001_62cb
    jp Jump_001_4bd4


    db $17, $18, $17, $19

Call_001_6810:
    ldh a, [$d3]
    and $fe
    cp $94
    jr z, jr_001_6821

    jr nc, jr_001_683c

    cp $0c
    jr z, jr_001_6841

    jr c, jr_001_6846

    ret


jr_001_6821:
    ld a, $94
    ld hl, $0002
    add hl, bc
    ld [hl], $00
    inc hl
    ld a, $f4
    ld [hl], a
    call Call_001_683c

jr_001_6830:
    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


Call_001_683c:
jr_001_683c:
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


jr_001_6841:
    call Call_001_6846
    jr jr_001_6830

Call_001_6846:
jr_001_6846:
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


Call_001_684b:
    ld de, $0410
    jp Jump_001_6345


Call_001_6851:
    ld d, $02
    jp Jump_001_63aa


    call Call_001_4b2e
    call Call_001_6878
    ld a, [$d931]
    or a
    jr nz, jr_001_6868

    call Call_001_684b
    call Call_001_6851

jr_001_6868:
    ld a, [$d931]
    or a
    jr z, jr_001_6875

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_6875:
    jp Jump_001_4c06


Call_001_6878:
    call Call_001_629e
    ld a, [hl]
    rst $00

    db $b7, $68, $87, $68, $97, $68

    or a
    ld l, b

    db $9e, $67

    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $6893
    jp Jump_001_66f8


    db $17, $18, $17, $18

    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $6893
    call Call_001_62cb
    call Call_001_6320
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $02
    ld [hl+], a
    ld [hl], $04
    ret


    ld a, [$c0b7]
    and $0f
    rst $00

    db $e4, $68, $e4, $68, $f4, $68, $2b, $69, $70, $69

Call_001_68c7:
    ldh a, [$d3]
    cp $94
    jr nc, jr_001_68d2

    cp $0c
    jr c, jr_001_68db

    ret


jr_001_68d2:
    ld a, [bc]
    bit 7, a
    ret nz

    call Call_001_683c
    jr jr_001_6911

jr_001_68db:
    ld a, [bc]
    bit 7, a
    ret z

    call Call_001_6846
    jr jr_001_6911

Jump_001_68e4:
    call Call_001_68c7
    ld hl, $68f0
    call Call_001_62cb
    jp Jump_001_4bd4


    db $14, $15, $14, $16

    ld a, $19
    ldh [$d6], a
    ld a, [$c0b8]
    inc a
    ld [$c0b8], a
    cp $30
    ret c

    ld hl, $fe00
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    xor a
    ld [$c0b8], a

jr_001_6911:
    ld a, [$c0b7]
    inc a
    ld [$c0b7], a
    and $0f
    cp $05
    ret nz

    ld a, [$c0b7]
    and $80
    xor $80
    jr z, jr_001_6927

    inc a

jr_001_6927:
    ld [$c0b7], a
    ret


    call Call_001_4bd4
    call Call_001_6940
    ld a, $1a
    ldh [$d6], a
    ld a, [$c0ba]
    bit 7, a
    ret nz

    ld a, $1b
    ldh [$d6], a
    ret


Call_001_6940:
    ld hl, $c0b9
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0008
    ld a, [$dffe]
    or a
    jr z, jr_001_6952

    ld de, $000c

jr_001_6952:
    add hl, de
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    ld d, h
    ld e, l
    call Call_001_632e
    ldh a, [$d4]
    cp $41
    ret c

    ld hl, $0005
    add hl, bc
    xor a
    ld [hl+], a
    ld a, $c0
    ld [hl], a
    jr jr_001_6911

    jp Jump_001_68e4


    call Call_001_4b2e
    call Call_001_69a0
    ld a, [$d931]
    or a
    jr nz, jr_001_6985

    call Call_001_6995
    call Call_001_699b

jr_001_6985:
    ld a, [$d931]
    or a
    jr z, jr_001_6992

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_6992:
    jp Jump_001_4c06


Call_001_6995:
    ld de, $0710
    jp Jump_001_6345


Call_001_699b:
    ld d, $06
    jp Jump_001_63aa


Call_001_69a0:
    ld a, $01
    ldh [$9d], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    rst $00

    db $e3, $69, $b3, $69, $c3, $69, $59, $6a, $9e, $67

    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $69bf
    jp Jump_001_66f8


    db $19, $1a, $19, $1a

    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $69bf
    call Call_001_62cb
    call Call_001_6320
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $03
    ld [hl+], a
    ld [hl], $04
    ret


    call Call_001_6a09
    call Call_001_4bd4
    call Call_001_6a6e
    call Call_001_6a3b
    ret nz

    ld hl, $fbc0
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    ld a, [$c0b7]
    rst $00

    db $18, $6a, $22, $6a, $28, $6a, $32, $6a, $38, $6a

Call_001_6a09:
    ld a, $15
    ldh [$d6], a
    ld a, [$c0ba]
    bit 7, a
    ret nz

    ld a, $16
    ldh [$d6], a
    ret


Jump_001_6a18:
    ld a, $01
    ld [$c0b7], a
    ld a, [bc]
    or $80
    ld [bc], a
    ret


    ld a, $02
    ld [$c0b7], a
    ret


    ld a, $03
    ld [$c0b7], a
    ld a, [bc]
    res 7, a
    ld [bc], a
    ret


    ld a, $04
    ld [$c0b7], a
    ret


    jp Jump_001_6a18


Call_001_6a3b:
    ld hl, $c0b9
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $0040
    add hl, de
    ld a, l
    ld [$c0b9], a
    ld a, h
    ld [$c0ba], a
    ld d, h
    ld e, l
    call Call_001_632e
    ld hl, $fc00
    add hl, de
    ld a, h
    or l
    ret


    ld a, $17
    ldh [$d6], a
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $20
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    ld [hl], $00
    ret


Call_001_6a6e:
    ld a, [$c0b7]
    or a
    ret z

    ld hl, $c0b9
    ld a, [hl+]
    or [hl]
    ret nz

    ld hl, $c180
    ld e, $20

jr_001_6a7e:
    ld a, [hl]
    and $7f
    cp $21
    ret z

    ld a, $10
    rst $38
    dec e
    jr nz, jr_001_6a7e

    ld h, b
    ld l, c
    inc hl
    ld [hl], $03
    xor a
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ld hl, $c180

jr_001_6a98:
    ld a, [hl]
    or a
    jr z, jr_001_6aac

    cp $ff
    jr z, jr_001_6aa6

    ld de, $0010
    add hl, de
    jr jr_001_6a98

jr_001_6aa6:
    call Call_001_6aac
    ld [hl], $ff
    ret


Call_001_6aac:
jr_001_6aac:
    ld a, $a1
    ld [hl+], a
    xor a
    ld [hl+], a
    call Call_001_6ac5
    call Call_001_6add
    call Call_001_65ae
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


Call_001_6ac5:
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $0800
    call Call_001_4be3
    inc hl
    ret


Call_001_6add:
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $ffe0
    add hl, de
    ld d, h
    ld e, l
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


    call Call_001_6b07
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_6b04

    call Call_001_6b3c
    jp Jump_001_4c06


jr_001_6b04:
    xor a
    ld [bc], a
    ret


Call_001_6b07:
    ld a, $1b
    ldh [$d6], a
    call Call_001_629e
    and $01
    rst $00

    db $15, $6b, $2f, $6b

    ld a, $80
    ld hl, $0008
    add hl, bc
    ld [hl+], a
    ld [hl], $01
    call Call_001_4bd4
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $18
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


    call Call_001_4bd4
    ld hl, $0005
    add hl, bc
    ld de, $00c0
    jp Jump_001_4be3


Call_001_6b3c:
    ld a, [$c0b6]
    cp $ff
    ret z

    ld d, $07
    jp Jump_001_63aa


    call Call_001_4b2e
    call Call_001_6bd6
    ld a, [$d931]
    or a
    jr nz, jr_001_6b59

    call Call_001_6b69
    call Call_001_6bc5

jr_001_6b59:
    ld a, [$d931]
    or a
    jr z, jr_001_6b66

    dec a
    ld [$d931], a
    and $08
    ret nz

jr_001_6b66:
    jp Jump_001_4c06


Call_001_6b69:
    ld de, $0712
    ldh a, [$bc]
    or a
    ret z

    rrca
    push af
    push de
    call c, Call_001_6b7c
    pop de
    pop af
    rrca
    jr c, jr_001_6ba6

    ret


Call_001_6b7c:
    ld hl, $c0c7
    ldh a, [$d1]
    add d
    ld d, a
    ldh a, [$d4]
    sub e
    ldh [$c9], a
    ldh a, [$d2]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    ldh a, [$bb]
    cp $04
    jp z, Jump_001_63c5

    cp $02
    jr z, jr_001_6bce

    xor a
    ld [$c0bf], a
    ld hl, $ffbc
    res 0, [hl]
    jr jr_001_6bce

jr_001_6ba6:
    ld hl, $c0d3
    ldh a, [$d1]
    add d
    ld d, a
    ldh a, [$d4]
    sub e
    ldh [$c9], a
    ldh a, [$d2]
    add e
    ld e, a
    call Call_001_4ced
    ret nc

    xor a
    ld [$c0cb], a
    ld hl, $ffbc
    res 1, [hl]
    jr jr_001_6bce

Call_001_6bc5:
    ld d, $08
    call Call_001_4c18
    call Call_001_4c9e
    ret nc

jr_001_6bce:
    ld a, [$c0ba]
    or a
    ret z

    jp Jump_001_63b1


Call_001_6bd6:
    call Call_001_629e
    ld a, [hl]
    rst $00

    db $15, $6c, $e5, $6b, $f5, $6b

    dec d
    ld l, h

    db $9e, $67

    pop af
    ld a, $84
    ld [$d931], a
    ld hl, $6bf1
    jp Jump_001_66f8


    db $18, $19, $18, $19

    pop af
    ld a, $ff
    ld [$c0b6], a
    ld hl, $6bf1
    call Call_001_62cb
    call Call_001_6320
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jp z, Jump_001_4c06

    ld h, b
    ld l, c
    ld a, $04
    ld [hl+], a
    ld [hl], $04
    ret


    ld a, [$c0b7]
    rst $00

    db $35, $6c, $4f, $6c, $72, $6c, $92, $6c, $14, $6d, $92, $6c, $24, $6d, $92, $6c
    db $34, $6d, $92, $6c, $44, $6d, $54, $6d, $8b, $6d, $d3, $6d

    call Call_001_6c45
    ldh a, [$d3]
    cp $8d
    jp nc, Jump_001_4bd4

    ld a, $01
    ld [$c0b7], a
    ret


Call_001_6c45:
    ld hl, $6c4b
    jp Jump_001_62cb


    db $15, $16, $15, $17

    ldh a, [$d4]
    cp $21
    jr c, jr_001_6c65

    ld de, $0100
    call Call_001_6c6b
    ld hl, $6c61
    jp Jump_001_62cb


    db $1d, $1e, $1d, $1e

jr_001_6c65:
    ld a, $02
    ld [$c0b7], a
    ret


Call_001_6c6b:
    ld hl, $0005
    add hl, bc
    jp Jump_001_4bee


    call Call_001_6c45
    ldh a, [$d3]
    cp $70
    jp nc, Jump_001_4bd4

    ld a, $03
    ld [$c0b7], a
    ret


jr_001_6c82:
    ld a, [bc]
    set 7, a
    ld [bc], a
    xor a
    ld [$c0b8], a
    ld a, [$c0b7]
    inc a
    ld [$c0b7], a
    ret


    ld a, [bc]
    res 7, a
    ld [bc], a
    xor a
    ld [$c0b9], a
    ld a, $1b
    ldh [$d6], a
    ld a, [$c0b8]
    inc a
    ld [$c0b8], a
    cp $30
    jr nc, jr_001_6c82

    cp $10
    ret c

    cp $20
    ret nc

    cp $1f
    jr z, jr_001_6cb8

    ld a, $1c
    ldh [$d6], a
    ret


jr_001_6cb8:
    ld a, $1c
    ldh [$d6], a
    ld hl, $c180

jr_001_6cbf:
    ld a, [hl]
    or a
    jr z, jr_001_6cd3

    cp $ff
    jr z, jr_001_6ccd

    ld de, $0010
    add hl, de
    jr jr_001_6cbf

jr_001_6ccd:
    call Call_001_6cd3
    ld [hl], $ff
    ret


Call_001_6cd3:
jr_001_6cd3:
    ld a, $24
    ld [hl+], a
    xor a
    ld [hl+], a
    call Call_001_6cec
    call Call_001_6d04
    call Call_001_65ae
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    ret


Call_001_6cec:
    push hl
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl-], a
    dec hl
    ld de, $1200
    call Call_001_4be3
    inc hl
    ret


Call_001_6d04:
    push hl
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    pop hl
    xor a
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ret


    call Call_001_6c45
    ldh a, [$d3]
    cp $58
    jp nc, Jump_001_4bd4

    ld a, $05
    ld [$c0b7], a
    ret


    call Call_001_6c45
    ldh a, [$d3]
    cp $38
    jp nc, Jump_001_4bd4

    ld a, $07
    ld [$c0b7], a
    ret


    call Call_001_6c45
    ldh a, [$d3]
    cp $18
    jp nc, Jump_001_4bd4

    ld a, $09
    ld [$c0b7], a
    ret


    call Call_001_6c45
    ldh a, [$d3]
    cp $14
    jp nc, Jump_001_4bd4

    ld a, $0b
    ld [$c0b7], a
    ret


    ld a, [bc]
    res 7, a
    ld [bc], a
    ld a, $1a
    ldh [$d6], a
    ldh a, [$d4]
    cp $70
    jr nc, jr_001_6d71

    cp $6e
    call nc, Call_001_6d85
    ld de, $0200
    ld hl, $0005
    add hl, bc
    jp Jump_001_4be3


jr_001_6d71:
    ld a, $0c
    ld [$c0b7], a
    ld hl, $ff90
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ld [$c464], a
    ld a, h
    ld [$c465], a
    ret


Call_001_6d85:
    ld a, $68
    call Call_000_0f3b
    ret


    ld a, $1a
    ldh [$d6], a
    ld a, [$c0b8]
    inc a
    ld [$c0b8], a
    cp $40
    jr nc, jr_001_6dbd

    and $07
    jr z, jr_001_6da3

    cp $04
    jr z, jr_001_6db0

    ret


jr_001_6da3:
    ldh a, [$90]
    sub $01
    ldh [$90], a
    ldh a, [$91]
    sbc $00
    ldh [$91], a
    ret


jr_001_6db0:
    ldh a, [$90]
    add $01
    ldh [$90], a
    ldh a, [$91]
    adc $00
    ldh [$91], a
    ret


jr_001_6dbd:
    xor a
    ld [$c0b8], a
    ld a, $0d
    ld [$c0b7], a
    ld hl, $c464
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [$90], a
    ld a, h
    ldh [$91], a
    ret


    ld a, $01
    ld [$c0ba], a
    ld a, $01
    ld [$c0b9], a
    call Call_001_6c45
    ldh a, [$d3]
    cp $8c
    jp c, Jump_001_4bd4

    xor a
    ld [$c0ba], a
    ld a, $01
    ld [$c0b7], a
    ld a, [bc]
    set 7, a
    ld [bc], a
    ret


    call Call_001_6e0c
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_6e09

    call Call_001_6e1f
    xor a
    ldh [$9d], a
    jp Jump_001_4c06


jr_001_6e09:
    xor a
    ld [bc], a
    ret


Call_001_6e0c:
    ld a, $1f
    ldh [$d6], a
    ld a, [$c0b9]
    or a
    ret z

    ld hl, $0005
    add hl, bc
    ld de, $0180
    jp Jump_001_4be3


Call_001_6e1f:
    ld a, [$c0b6]
    cp $ff
    ret z

    ld d, $03
    jp Jump_001_63aa


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6e4b
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    ld hl, $70c4
    or a
    jr z, jr_001_6e42

    ld hl, $70d5

jr_001_6e42:
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_6e4b:
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jr nz, jr_001_6e93

    ldh a, [$b4]
    rlca
    ccf
    ret nc

    ldh a, [$c3]
    cp $ff
    ret z

    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    rst $28
    cp $0e
    ret nc

    ldh a, [$d4]
    ld h, a
    ldh a, [$a4]
    sub h
    ret nc

    cpl
    inc a
    cp $12
    ret nc

    cp $0e
    ret c

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ldh a, [$aa]
    cp $06
    ret z

    call Call_001_5e9a

Call_001_6e81:
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $fff0
    add hl, de
    ld a, l
    ldh [$ae], a
    ld a, h
    ldh [$af], a
    ret


jr_001_6e93:
    ld hl, $ffad
    ld de, $0100
    call Call_001_4be3
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    inc [hl]
    cp $08
    ret c

    ld [hl], $00
    ld h, b
    ld l, c
    inc hl
    dec [hl]
    ldh a, [$aa]
    cp $06
    ret z

    ld a, $5c
    call Call_000_0f3b
    ld a, $10
    ldh [$b7], a
    ld a, $02
    ldh [$aa], a
    ld [$c0b0], a
    call Call_001_6e81
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    rst $00

    db $cf, $6e, $d5, $6e

    db $db
    ld l, [hl]

    ld hl, $fc70
    jp Jump_001_5e9d


    ld hl, $fbc0
    jp Jump_001_5e9d


    ld hl, $fb40
    jp Jump_001_5e9d


    call Call_001_4b84
    ret nz

    call Call_001_6efb
    ldh a, [$d5]
    or a
    ret nz

    call Call_001_6f0a

Jump_001_6eef:
    ld hl, $70de
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_6efb:
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    db $4b, $6f, $62, $6f, $77, $6f, $62, $6f

Call_001_6f0a:
Jump_001_6f0a:
    ldh a, [$aa]
    cp $06
    ret z

    ldh a, [$d5]
    or a
    ret nz

    ld e, $12
    call Call_001_6f28
    ret nc

Jump_001_6f19:
    ld a, $ff
    ldh [$c4], a
    call Call_001_6e81
    ldh a, [$aa]
    cp $02
    ret nz

    jp Jump_001_5e0e


Call_001_6f28:
    ldh a, [$b4]
    rlca
    ccf
    ret nc

    ldh a, [$c3]
    cp $ff
    ret z

    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    rst $28
    cp e
    ret nc

    ldh a, [$d4]
    ld h, a
    ldh a, [$a4]
    sub h
    ret nc

    cpl
    inc a
    cp $15
    ret nc

    cp $0f
    ccf
    ret


    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call Call_001_4bee

Call_001_6f55:
jr_001_6f55:
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld [hl], $5a
    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ret


Call_001_6f62:
Jump_001_6f62:
    ld hl, $000d
    add hl, bc
    dec [hl]
    ret nz

    ld h, b
    ld l, c
    inc hl
    inc [hl]
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld hl, $000d
    add hl, bc
    ld [hl], a
    ret


    ld hl, $0005
    add hl, bc
    ld de, $00c0
    call Call_001_4be3
    jr jr_001_6f55

    call Call_001_4b84
    ret nz

    call Call_001_6f91
    ldh a, [$d5]
    or a
    ret nz

    jp Jump_001_6eef


Call_001_6f91:
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    and $03
    rst $00

    db $a0, $6f, $d1, $6f, $d7, $6f, $d1, $6f

    ld hl, $0002
    add hl, bc
    ldh a, [$8a]
    and $30
    jr nz, jr_001_6fad

    ld a, [hl]
    ldh [$b0], a

jr_001_6fad:
    ld de, $00c0
    call Call_001_4bee
    call Call_001_6f55
    ldh a, [$aa]
    cp $06
    ret z

    ldh a, [$d5]
    or a
    ret nz

    ld e, $12
    call Call_001_6f28
    ret nc

    ld hl, $ffb0
    ld de, $00c0
    call Call_001_4bee
    jp Jump_001_6f19


    call Call_001_6f62
    jp Jump_001_6f0a


    ld hl, $0002
    add hl, bc
    ldh a, [$8a]
    and $30
    jr nz, jr_001_6fe4

    ld a, [hl]
    ldh [$b0], a

jr_001_6fe4:
    ld de, $00c0
    call Call_001_4be3
    call Call_001_6f55
    ldh a, [$aa]
    cp $06
    ret z

    ld e, $12
    call Call_001_6f28
    ret nc

    ld hl, $ffb0
    ld de, $00c0
    call Call_001_4be3
    jp Jump_001_6f19


Call_001_7004:
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_701e

    call Call_001_706f
    call Call_001_7021
    ld hl, $70bb
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Jump_001_701e:
jr_001_701e:
    xor a
    ld [bc], a
    ret


Call_001_7021:
    ldh a, [$aa]
    cp $06
    ret z

    ldh a, [$b4]
    rlca
    ccf
    ret nc

    ldh a, [$c3]
    cp $ff
    ret z

    ld a, [$c403]
    ld l, a
    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    rst $28
    cp $10
    ret nc

    cp l
    ret nc

    ld [$c403], a
    ldh a, [$d4]
    ld h, a
    ldh a, [$a4]
    sub h
    ret nc

    cpl
    inc a
    cp $0c
    ret nc

    cp $07
    ret c

    ld a, $ff
    ldh [$c4], a
    ld hl, $0006
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $fff8
    add hl, de
    ld a, l
    ldh [$ae], a
    ld a, h
    ldh [$af], a
    ldh a, [$aa]
    cp $02
    ret nz

    jp Jump_001_5e0e


Call_001_706f:
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, Jump_001_6f62

Jump_001_7077:
    ld hl, $0005
    add hl, bc
    ld de, $0200
    jp Jump_001_4be3


Call_001_7081:
    call Call_001_4b2e
    ldh a, [$d5]
    or a
    jr nz, jr_001_701e

    call Call_001_7095
    call Call_001_7021
    jp Jump_001_4c06


    xor a
    ld [bc], a
    ret


Call_001_7095:
    ld a, $02
    ldh [$9d], a
    ld a, $10
    ldh [$d6], a
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    or a
    jp z, Jump_001_6f62

    dec a
    jr z, jr_001_70ab

    jp Jump_001_7077


jr_001_70ab:
    ld hl, $000d
    add hl, bc
    bit 3, [hl]
    jp z, Jump_001_6f62

    ld a, $11
    ldh [$d6], a
    jp Jump_001_6f62


    db $f8, $f8, $b0, $10, $f8, $00, $b0, $10, $80, $f0, $f8, $b1, $10, $f0, $00, $b2
    db $10, $f8, $f8, $b3, $10, $f8, $00, $b4, $10, $80, $f8, $f8, $b5, $10, $f8, $00
    db $b6, $10, $80, $f0, $f0, $b7, $00, $f0, $f8, $b8, $00, $f0, $00, $b8, $00, $f0
    db $08, $b9, $00, $f8, $f0, $ba, $00, $f8, $f8, $bb, $00, $f8, $00, $bb, $00, $f8
    db $08, $bc, $00, $80

    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jr z, jr_001_7126

    ld hl, $0008
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ld hl, $0003
    add hl, bc
    ld de, $00b0
    ld a, [bc]
    sla a
    jr c, jr_001_711e

    ld de, $fff0

jr_001_711e:
    ldh a, [$92]
    add e
    ld [hl+], a
    ldh a, [$93]
    adc d
    ld [hl], a

jr_001_7126:
    call Call_001_714e
    call Call_001_71fd
    ld a, [bc]
    sla a
    ld a, $00
    rl a
    ldh [$9d], a
    ld h, b
    ld l, c
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    ld hl, $21ce
    and $04
    jr z, jr_001_7145

    ld hl, $21ff

jr_001_7145:
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_026c


Call_001_714e:
    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, $0002
    add hl, bc
    call Call_001_4bdf
    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    rst $28
    cp $10
    ret nc

    ldh a, [$aa]
    cp $0b
    ret z

    ldh a, [$d5]
    or a
    ret nz

    ldh a, [$a4]
    ld h, a
    ldh a, [$d4]
    sub h
    ret c

    cp $20
    ret nc

    cp $1c
    jr nc, jr_001_71ac

    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    ldh [$b1], a
    ld a, [hl+]
    ldh [$b2], a
    ld de, $0010
    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    jr nc, jr_001_7195

    ld de, $fff0

jr_001_7195:
    ldh a, [$b1]
    add e
    ldh [$b1], a
    ldh a, [$b2]
    adc d
    ldh [$b2], a
    ld hl, $0008
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ldh a, [$a5]
    sub e
    ldh [$d3], a
    ret


jr_001_71ac:
    ldh a, [$b4]
    bit 7, a
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $c0
    call Call_001_71fd
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    sub $1f
    ldh [$ae], a
    push bc
    ld a, [bc]
    rlca
    jr nc, jr_001_71cd

    call Call_001_523a
    jr jr_001_71d0

jr_001_71cd:
    call Call_001_516c

jr_001_71d0:
    ldh a, [$c0]
    pop bc
    or a
    jr nz, jr_001_71e3

    ld hl, $0008
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, $ffb0
    call Call_001_4bdf

jr_001_71e3:
    ldh a, [$8a]
    and $81
    cp $81
    jr nz, jr_001_71f1

    ldh a, [$8a]
    res 0, a
    ldh [$8a], a

jr_001_71f1:
    ld a, $ff
    ldh [$c4], a
    ldh a, [$aa]
    cp $02
    ret nz

    jp Jump_001_5e0e


Call_001_71fd:
    ld de, $0350
    ld a, [bc]
    sla a
    jr nc, jr_001_7208

    ld de, $00b0

jr_001_7208:
    ld hl, $0003
    add hl, bc
    ld a, [hl+]
    and $f8
    cp e
    ret nz

    ld a, [hl+]
    cp d
    ret nz

    ld hl, $0008
    add hl, bc
    ld [hl], $00
    ret


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jr z, jr_001_722f

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, Jump_001_701e

    ret


jr_001_722f:
    call Call_001_725f
    ld d, $03
    call Call_001_4c18
    call Call_001_4c9e
    ld hl, $000a
    add hl, bc
    ldh a, [$c9]
    ld d, [hl]
    bit 3, d
    jr z, jr_001_7246

    inc a

jr_001_7246:
    ld hl, $7253
    rst $20
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


    db $30, $22

    jr nc, jr_001_7279

    db $30, $22, $3f, $22, $35, $22, $3a, $22

Call_001_725f:
    xor a
    ldh [$c9], a
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, jr_001_7282

    inc a
    and $0f
    or $40
    ld [hl], a
    ld a, $04
    ldh [$c9], a
    ld hl, $0006
    add hl, bc

jr_001_7279:
    ld a, [hl]
    add $01
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl+], a
    ret


jr_001_7282:
    or a
    jr z, jr_001_728c

    inc a
    ld [hl], a
    ld a, $02
    ldh [$c9], a
    ret


jr_001_728c:
    ldh a, [$d3]
    ld d, a
    ldh a, [$a5]
    sub d
    rst $28
    cp $48
    ret nc

    ld a, $01
    ld [hl], a
    ret


    call Call_001_4b84
    ret nz

    call Call_001_72e8
    ldh a, [$c9]
    or a
    jr nz, jr_001_72b0

    ld hl, $000a
    add hl, bc
    bit 7, [hl]
    jp nz, Jump_001_701e

    ret


jr_001_72b0:
    ldh a, [$d5]
    or a
    ret nz

    ld d, $05
    call Call_001_4c18
    call Call_001_4c9e
    ld hl, $000a
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    inc a
    ld [de], a
    ld hl, $2244
    and $78
    cp $08
    jr nz, jr_001_72d1

    ld hl, $2255

jr_001_72d1:
    cp $10
    jr nz, jr_001_72d8

    ld hl, $2266

jr_001_72d8:
    cp $18
    jr c, jr_001_72df

    ld a, $80
    ld [de], a

jr_001_72df:
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_72e8:
    xor a
    ldh [$c9], a
    ld hl, $0003
    add hl, bc
    ld e, [hl]
    inc hl
    ldh a, [$b1]
    sub e
    ld e, a
    ld d, [hl]
    inc hl
    ldh a, [$b2]
    sbc d
    jr z, jr_001_72ff

    cp $ff
    ret nz

jr_001_72ff:
    xor e
    cp $60
    ret nc

    inc hl
    ld a, [hl+]
    and $80
    ld e, a
    ldh a, [$ae]
    and $80
    cp e
    ret nz

    ld e, [hl]
    ldh a, [$af]
    cp e
    ret nz

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call Call_001_4bdf
    ld a, $01
    ldh [$c9], a
    ret


    call Call_001_4b84
    ret nz

    call Call_001_7339
    ldh a, [$d5]
    or a
    ret nz

    ld hl, $2277
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    jp Jump_000_0269


Call_001_7339:
    xor a
    ldh [$c9], a
    ldh a, [$d3]
    ld e, a
    ldh a, [$a5]
    sub e
    rst $28
    cp $08
    jr nc, jr_001_7394

    ldh a, [$d4]
    ld e, a
    ldh a, [$a4]
    sub e
    cp $06
    jr c, jr_001_7394

    cp $10
    jr nc, jr_001_735b

    ldh a, [$b4]
    bit 7, a
    jr nz, jr_001_7394

jr_001_735b:
    cp $14
    jr nc, jr_001_7394

    ldh a, [$aa]
    cp $0b
    jr z, jr_001_7394

    cp $06
    jr z, jr_001_7394

    ldh a, [$d5]
    or a
    jr nz, jr_001_7394

    ldh a, [$8b]
    ld e, $13
    bit 7, a
    jr z, jr_001_7377

    inc e

jr_001_7377:
    bit 0, a
    jr z, jr_001_737d

    ld e, $0f

jr_001_737d:
    ld hl, $0006
    add hl, bc
    ld a, [hl]
    add e
    ldh [$ae], a
    ld a, $ff
    ldh [$c4], a
    ldh a, [$aa]
    cp $0d
    call nz, Call_001_57d9
    ld a, $01
    ldh [$c9], a

jr_001_7394:
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    dec a
    ld [hl], a
    cp $d0
    jr z, jr_001_73ba

    sla a
    ret c

    ld de, $0100
    ld hl, $0002
    add hl, bc
    call Call_001_4bdf
    ldh a, [$c9]
    or a
    ret z

    ld de, $0100
    ld hl, $ffb0
    call Call_001_4bdf
    ret


jr_001_73ba:
    ld d, h
    ld e, l
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    ld [de], a
    ld a, [bc]
    xor $80
    ld [bc], a
    ret


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    ret nz

    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr z, jr_001_73d8

    dec [hl]

jr_001_73d8:
    srl a
    ld e, a
    ldh a, [$d4]
    add e
    ldh [$d4], a
    call Call_001_7407
    ld e, $00
    ld hl, $000d
    add hl, bc
    ld a, [hl]
    or a
    jr nz, jr_001_73f9

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    inc [hl]
    bit 4, a
    jr z, jr_001_73f9

    ld e, $02

jr_001_73f9:
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    add e
    ld b, a
    ld hl, $2486
    jp Jump_000_025d


    ret


Call_001_7407:
    ldh a, [$d3]
    ld h, a
    ldh a, [$a5]
    sub h
    rst $28
    cp $09
    ret nc

    ldh a, [$a4]
    ld h, a
    ldh a, [$d4]
    sub h
    cp $08
    ret c

    cp $10
    ret nc

    ldh a, [$b4]
    bit 7, a
    ret nz

    ldh a, [$aa]
    cp $0b
    ret z

    cp $06
    ret z

    ld hl, $0006
    add hl, bc
    ld a, [hl]
    sub $0e
    add e
    ldh [$ae], a
    ldh a, [$8a]
    and $81
    cp $81
    jr nz, jr_001_7442

    ldh a, [$8a]
    res 0, a
    ldh [$8a], a

jr_001_7442:
    ld a, $ff
    ldh [$c4], a
    ld hl, $000d
    add hl, bc
    inc [hl]
    inc [hl]
    ldh a, [$aa]
    cp $02
    ret nz

    jp Jump_001_5e0e


    call Call_001_4b84
    ret nz

    ldh a, [$d5]
    or a
    jr z, jr_001_7468

    ld hl, $000a
    add hl, bc
    ld a, [hl]
    and $40
    jp nz, Jump_001_701e

    ret


jr_001_7468:
    call Call_001_7489
    ld d, $05
    call Call_001_4c18
    call Call_001_4c9e
    ld hl, $000a
    add hl, bc
    ldh a, [$d3]
    ld c, a
    ldh a, [$d4]
    ld b, a
    ld a, [hl]
    bit 3, a
    jr z, jr_001_7483

    inc c

jr_001_7483:
    ld hl, $2475
    jp Jump_000_0269


Call_001_7489:
    ld hl, $000a
    add hl, bc
    ld a, [hl]
    cp $30
    jr c, jr_001_749d

    ld de, $0180
    ld hl, $0005
    add hl, bc
    call Call_001_4bdf
    ret


jr_001_749d:
    or a
    jr z, jr_001_74a3

    inc a
    ld [hl], a
    ret


jr_001_74a3:
    ldh a, [$d3]
    ld d, a
    ldh a, [$a5]
    sub d
    rst $28
    cp $48
    ret nc

    ld a, [bc]
    res 7, a
    ld [bc], a
    ld a, $01
    ld [hl], a
    ret


    db $12, $18, $00, $58, $00, $10, $d4, $00, $b8, $00, $10, $e0, $00, $b8, $00, $14
    db $68, $00, $c8, $00, $0a, $b0, $00, $f2, $00, $18, $28, $01, $a8, $00, $0a, $cc
    db $01, $d1, $00, $10, $70, $01, $68, $00, $10, $98, $01, $b0, $00, $10, $b0, $01
    db $48, $00, $1a, $50, $02, $91, $00, $0b, $24, $02, $a2, $00, $0a, $b0, $02, $82
    db $00, $14, $60, $02, $20, $00, $10, $a0, $02, $20, $00, $10, $e0, $02, $20, $00
    db $11, $68, $02, $b8, $00, $11, $c4, $02, $d8, $00, $11, $ec, $02, $d8, $00, $0c
    db $d8, $02, $e3, $00, $10, $20, $03, $28, $00, $1d, $68, $03, $c0, $00, $0a, $a8
    db $03, $61, $00, $16, $c0, $03, $30, $00, $1d, $18, $04, $b0, $00, $1d, $48, $04
    db $e1, $00, $14, $a8, $04, $c0, $00, $17, $08, $05, $78, $00, $0b, $18, $05, $e1
    db $00, $0b, $b8, $05, $81, $00, $10, $a0, $05, $c8, $00, $10, $e0, $05, $c8, $00
    db $1b, $10, $06, $32, $00, $1a, $40, $06, $50, $00, $1b, $a0, $06, $51, $00, $12
    db $c8, $06, $38, $00, $10, $84, $06, $70, $00, $10, $94, $06, $70, $00, $10, $78
    db $06, $d0, $00, $0c, $f0, $06, $e3, $00, $14, $18, $06, $d0, $00, $1d, $38, $07
    db $e0, $00, $1d, $50, $07, $90, $00, $0a, $b0, $07, $35, $00, $10, $78, $07, $80
    db $00, $10, $a8, $07, $80, $00, $10, $c8, $07, $98, $00, $10, $c8, $07, $b8, $00
    db $10, $c8, $07, $d8, $00, $11, $04, $08, $e8, $00, $11, $24, $08, $e8, $00, $1d
    db $58, $08, $f0, $00, $10, $38, $08, $78, $00, $10, $38, $08, $98, $00, $10, $38
    db $08, $b8, $00, $14, $80, $08, $28, $00, $0b, $dc, $08, $91, $00, $10, $38, $09
    db $78, $00, $10, $80, $09, $78, $00, $10, $c8, $09, $50, $00, $0c, $04, $0a, $70
    db $00, $1a, $28, $0a, $e5, $00, $17, $28, $0a, $e8, $00, $0a, $68, $0a, $51, $00
    db $16, $88, $0b, $48, $00, $14, $88, $0b, $88, $00, $10, $a0, $0b, $c8, $00, $10
    db $e0, $0b, $c8, $00, $0a, $e0, $0b, $9c, $00, $1d, $a8, $0b, $98, $00, $10, $c0
    db $0b, $70, $00, $0b, $08, $0c, $55, $00, $18, $50, $0c, $28, $00, $10, $78, $0c
    db $58, $00, $10, $88, $0c, $68, $00, $10, $78, $0c, $78, $00, $10, $88, $0c, $88
    db $00, $10, $78, $0c, $98, $00, $12, $f8, $0c, $08, $00, $19, $18, $0c, $c0, $00
    db $ff, $13, $10, $00, $a0, $00, $14, $58, $00, $b0, $00, $10, $b0, $00, $b0, $00
    db $10, $f0, $00, $b0, $00, $10, $fc, $00, $30, $00, $10, $58, $00, $28, $00, $10
    db $68, $00, $28, $00, $10, $0c, $01, $30, $00, $10, $30, $01, $b8, $00, $0b, $68
    db $01, $76, $00, $0c, $d0, $01, $f6, $00, $18, $48, $02, $20, $00, $16, $78, $02
    db $20, $00, $11, $38, $02, $a8, $00, $10, $38, $02, $c8, $00, $11, $58, $02, $a8
    db $00, $10, $58, $02, $c8, $00, $11, $78, $02, $a8, $00, $10, $78, $02, $c8, $00
    db $10, $c0, $02, $a8, $00, $10, $d0, $02, $a8, $00, $0b, $20, $03, $75, $00, $0d
    db $d0, $03, $c4, $00, $0b, $48, $03, $c3, $00, $10, $3c, $03, $e0, $00, $10, $4c
    db $03, $e0, $00, $14, $e8, $03, $e0, $00, $10, $30, $04, $90, $00, $10, $40, $04
    db $90, $00, $10, $dc, $04, $28, $00, $10, $ec, $04, $28, $00, $17, $e0, $04, $c8
    db $00, $0d, $10, $04, $50, $00, $0c, $90, $04, $50, $00, $10, $34, $05, $58, $00
    db $10, $44, $05, $58, $00, $13, $18, $05, $20, $00, $0d, $00, $06, $61, $00, $0b
    db $c8, $06, $60, $00, $10, $10, $06, $b8, $00, $10, $50, $06, $b8, $00, $10, $90
    db $06, $b8, $00, $10, $fc, $06, $98, $00, $12, $38, $06, $18, $00, $14, $f0, $06
    db $78, $00, $10, $0c, $07, $98, $00, $0d, $90, $07, $62, $00, $14, $c0, $07, $98
    db $00, $10, $40, $07, $b8, $00, $10, $70, $07, $b8, $00, $10, $a0, $07, $b8, $00
    db $0c, $38, $08, $54, $00, $0b, $b0, $08, $54, $00, $10, $d8, $08, $20, $00, $10
    db $e8, $08, $20, $00, $10, $14, $09, $38, $00, $10, $24, $09, $38, $00, $19, $38
    db $09, $18, $00, $0b, $98, $09, $41, $00, $10, $e0, $09, $28, $00, $10, $f0, $09
    db $28, $00, $10, $a0, $0a, $10, $00, $10, $b0, $0a, $10, $00, $06, $80, $0a, $f0
    db $00, $15, $e8, $0a, $58, $00, $15, $e8, $0a, $e8, $00, $0c, $30, $0b, $40, $00
    db $10, $68, $0b, $18, $00, $10, $7c, $0b, $18, $00, $10, $b8, $0b, $18, $00, $10
    db $f8, $0b, $18, $00, $06, $18, $0b, $f0, $00, $06, $e0, $0b, $f0, $00, $10, $5c
    db $0b, $b0, $00, $10, $6c, $0b, $b0, $00, $18, $30, $0b, $a8, $00, $16, $e8, $0b
    db $58, $00, $10, $7c, $0c, $38, $00, $10, $90, $0c, $50, $00, $10, $9a, $0c, $70
    db $00, $15, $a0, $0c, $90, $00, $0d, $20, $0c, $62, $00, $0b, $18, $0c, $d2, $00
    db $ff, $22, $60, $00, $f0, $03, $10, $b8, $00, $b0, $03, $10, $c8, $00, $b0, $03
    db $10, $68, $01, $c0, $03, $10, $78, $01, $c0, $03, $10, $c8, $01, $c0, $03, $10
    db $d8, $01, $c0, $03, $10, $28, $02, $c0, $03, $10, $38, $02, $c0, $03, $10, $b0
    db $02, $c0, $03, $10, $f0, $02, $90, $03, $22, $b0, $03, $71, $03, $10, $38, $03
    db $20, $03, $11, $38, $03, $40, $03, $10, $08, $03, $20, $03, $11, $08, $03, $40
    db $03, $10, $d8, $02, $20, $03, $11, $d8, $02, $40, $03, $0d, $08, $02, $3c, $03
    db $10, $58, $01, $10, $03, $10, $38, $01, $10, $03, $10, $18, $01, $10, $03, $15
    db $f8, $00, $18, $03, $22, $60, $00, $f0, $02, $0f, $e0, $00, $b9, $02, $11, $18
    db $01, $b0, $02, $11, $38, $01, $b0, $02, $11, $58, $01, $b0, $02, $11, $78, $01
    db $b0, $02, $10, $e0, $01, $90, $02, $10, $10, $02, $90, $02, $10, $a0, $02, $90
    db $02, $10, $d8, $02, $90, $02, $11, $98, $02, $b8, $02, $14, $e8, $02, $b8, $02
    db $1f, $a4, $00, $50, $02, $1f, $bc, $00, $50, $02, $11, $b0, $00, $18, $02, $11
    db $10, $01, $18, $02, $0d, $d8, $00, $76, $02, $1f, $f4, $00, $50, $02, $1f, $14
    db $01, $50, $02, $10, $34, $01, $48, $02, $10, $44, $01, $48, $02, $14, $78, $01
    db $68, $02, $0d, $e8, $01, $70, $02, $11, $e0, $01, $60, $02, $11, $f0, $01, $60
    db $02, $1f, $64, $02, $40, $02, $1f, $8c, $02, $48, $02, $10, $74, $02, $18, $02
    db $10, $dc, $02, $18, $02, $1f, $c4, $02, $50, $02, $1f, $e4, $02, $40, $02, $1f
    db $4c, $03, $40, $02, $1f, $24, $03, $40, $02, $18, $58, $03, $10, $02, $0f, $88
    db $03, $73, $02, $14, $68, $00, $a0, $01, $10, $9c, $00, $a0, $01, $10, $bc, $00
    db $a0, $01, $20, $a8, $00, $f1, $01, $20, $e0, $00, $f1, $01, $10, $1c, $01, $a0
    db $01, $10, $2c, $01, $a0, $01, $0d, $60, $01, $cd, $01, $11, $a8, $01, $e8, $01
    db $11, $c0, $01, $e8, $01, $10, $2c, $02, $e0, $01, $10, $3c, $02, $e0, $01, $0d
    db $65, $02, $c2, $01, $20, $70, $02, $f1, $01, $10, $cc, $02, $e0, $01, $10, $dc
    db $02, $e0, $01, $20, $08, $03, $f1, $01, $17, $30, $03, $90, $01, $16, $b8, $00
    db $18, $01, $07, $10, $01, $2d, $01, $0f, $48, $01, $73, $01, $07, $88, $01, $29
    db $01, $07, $f4, $01, $2b, $01, $0c, $58, $02, $41, $01, $12, $48, $02, $60, $01
    db $20, $b8, $02, $70, $01, $07, $d4, $02, $2a, $01, $14, $d0, $02, $28, $01, $20
    db $e8, $02, $70, $01, $10, $14, $03, $58, $01, $10, $24, $03, $58, $01, $07, $50
    db $03, $2d, $01, $14, $08, $00, $e8, $00, $0f, $90, $00, $f4, $00, $10, $94, $00
    db $c0, $00, $10, $a4, $00, $c0, $00, $10, $04, $01, $d0, $00, $10, $20, $01, $b0
    db $00, $ff, $10, $94, $00, $c0, $04, $10, $a4, $00, $c0, $04, $23, $e8, $00, $b0
    db $04, $10, $04, $01, $c0, $04, $23, $28, $01, $b0, $04, $10, $4c, $01, $c0, $04
    db $23, $68, $01, $b0, $04, $0b, $78, $01, $f4, $04, $23, $a8, $01, $b0, $04, $10
    db $10, $02, $70, $04, $11, $04, $02, $a0, $04, $10, $10, $02, $d0, $04, $11, $1c
    db $02, $a0, $04, $10, $60, $02, $68, $04, $10, $60, $02, $c0, $04, $10, $90, $02
    db $48, $04, $10, $90, $02, $a8, $04, $18, $b8, $02, $dc, $04, $10, $e8, $02, $ac
    db $04, $10, $f8, $02, $ac, $04, $0d, $08, $03, $82, $04, $14, $70, $03, $40, $04
    db $08, $80, $03, $d8, $04, $10, $94, $03, $98, $04, $08, $a8, $03, $d8, $04, $10
    db $bc, $03, $98, $04, $08, $d0, $03, $d8, $04, $10, $e4, $03, $98, $04, $08, $f8
    db $03, $d8, $04, $10, $d0, $03, $10, $04, $10, $1c, $04, $a8, $03, $10, $2c, $04
    db $a8, $03, $10, $3c, $04, $a8, $03, $14, $1c, $04, $58, $03, $10, $2c, $04, $58
    db $03, $10, $3c, $04, $58, $03, $0b, $48, $04, $d4, $03, $0d, $48, $04, $84, $03
    db $0f, $38, $04, $31, $03, $17, $18, $04, $68, $01, $18, $e8, $04, $68, $01, $10
    db $80, $04, $80, $01, $10, $40, $04, $10, $01, $11, $e8, $04, $f8, $01, $0f, $c8
    db $04, $51, $04, $16, $e8, $04, $a8, $04, $08, $a0, $04, $d8, $04, $08, $c8, $04
    db $d8, $04, $0b, $d8, $04, $9a, $02, $0d, $60, $04, $50, $02, $0b, $30, $04, $30
    db $02, $12, $d8, $04, $20, $02, $10, $18, $04, $48, $02, $14, $18, $04, $68, $02
    db $10, $18, $04, $88, $02, $10, $20, $04, $f8, $00, $10, $40, $04, $c8, $00, $10
    db $30, $04, $80, $00, $11, $08, $04, $88, $00, $0f, $b0, $04, $60, $00, $14, $b0
    db $04, $a8, $00, $0d, $10, $05, $60, $00, $0b, $10, $05, $f2, $00, $0f, $b0, $05
    db $90, $00, $15, $a8, $05, $e8, $00, $08, $e0, $05, $b8, $00, $12, $08, $06, $38
    db $00, $0d, $48, $06, $52, $00, $08, $08, $06, $b8, $00, $08, $60, $06, $b8, $00
    db $08, $b0, $06, $b8, $00, $10, $88, $07, $58, $00, $10, $88, $07, $88, $00, $10
    db $88, $07, $b8, $00, $10, $a8, $07, $58, $00, $10, $a8, $07, $88, $00, $10, $a8
    db $07, $b8, $00, $10, $c8, $07, $58, $00, $10, $c8, $07, $88, $00, $10, $c8, $07
    db $b8, $00, $15, $e8, $07, $90, $00, $0d, $c8, $08, $91, $00, $16, $08, $08, $88
    db $00, $17, $08, $08, $b8, $00, $18, $08, $08, $e8, $00, $15, $e8, $08, $e8, $00
    db $14, $18, $09, $98, $00, $ff

    ld d, $d8
    nop
    ld h, b
    nop
    jr @+$52

    nop
    ld [hl], b
    nop
    rla
    jr nc, jr_001_7b88

jr_001_7b88:
    ret z

    nop
    rst $38
    ld hl, $7d32
    ld a, l
    ld [$d92f], a
    ld a, h
    ld [$d930], a
    xor a
    ld [$d954], a
    ldh [$8a], a
    ld [$d955], a
    ld [$d956], a
    ld [$d957], a
    ld [$d92d], a
    ld [$d92e], a
    ld a, $5c
    ldh [$9a], a
    ld a, $8f
    ldh [$c9], a
    ld hl, $9c00
    ld bc, $1206
    call Call_000_08b7
    ld a, $50
    ldh [$94], a
    ld a, $06
    ld hl, $50c4
    ld de, $8800
    ld bc, $0100
    call LoadGameGfx
    ld a, $03
    ld hl, $400f
    ld de, $8900
    call LoadMainGfx
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMainGfx
    call Call_000_0f0d
    ld a, $20
    call Call_000_0f32
    ret


    ld hl, $00e0
    ld a, l
    ldh [$b5], a
    ld a, h
    ldh [$b6], a
    ldh a, [$8a]
    and $0f
    cp $0f
    ret z

    ldh a, [$8a]
    and $08
    jr nz, jr_001_7c08

    ldh a, [$b2]
    or a
    jr z, jr_001_7c18

jr_001_7c08:
    xor a
    ld [$c0bf], a
    ld [$c0cb], a
    ldh [$9f], a
    ld a, $02
    ldh [$8e], a
    ldh [$8f], a
    ret


jr_001_7c18:
    call Call_001_7cfa
    ldh a, [$92]
    ld b, a
    ldh a, [$b1]
    sub b
    cp $38
    jr nc, jr_001_7c31

    ldh a, [$b1]
    sub $38
    jr nc, jr_001_7c2c

    xor a

jr_001_7c2c:
    ldh [$92], a
    ld b, a
    jr jr_001_7c42

jr_001_7c31:
    cp $68
    jr c, jr_001_7c42

    ldh a, [$b1]
    sub $68
    cp $60
    jr c, jr_001_7c3f

    ld a, $60

jr_001_7c3f:
    ldh [$92], a
    ld b, a

jr_001_7c42:
    ldh a, [$b1]
    sub b
    ldh [$a5], a
    ldh a, [$90]
    ld c, a
    ldh a, [$ae]
    sub c
    cp $18
    jr nc, jr_001_7c5d

    ldh a, [$ae]
    sub $18
    jr nc, jr_001_7c58

    xor a

jr_001_7c58:
    ldh [$90], a
    ld c, a
    jr jr_001_7c6e

jr_001_7c5d:
    cp $48
    jr c, jr_001_7c6e

    ldh a, [$ae]
    sub $48
    cp $b0
    jr c, jr_001_7c6b

    ld a, $b0

jr_001_7c6b:
    ldh [$90], a
    ld c, a

jr_001_7c6e:
    ldh a, [$ae]
    sub c
    ldh [$a4], a
    call Call_001_4578
    call Call_001_4868
    call Call_001_560e
    call Call_001_454b
    ld hl, $c100

jr_001_7c82:
    ld a, [hl]
    or a
    jp z, Jump_001_7c9b

    and $fc
    cp $9c
    jr nz, jr_001_7c91

    xor a
    ld [hl], a
    jr jr_001_7c9b

jr_001_7c91:
    inc hl
    ld b, [hl]
    inc hl
    ld a, [hl+]
    inc hl
    and $3c
    rst $38
    jr jr_001_7c82

Jump_001_7c9b:
jr_001_7c9b:
    ld bc, $3f00
    add hl, bc
    ld a, l
    ldh [$99], a
    call Call_000_0719
    ld a, [$d955]
    inc a
    ld [$d955], a
    and $0f
    jr nz, jr_001_7cd9

    ld a, [$d956]
    ld hl, $7d27
    rst $38
    ld b, [hl]
    ld a, [$d954]
    cp b
    jr nz, jr_001_7cd2

    xor a
    ld [$d957], a
    ld a, $04
    ld [$d970], a
    ld a, [$d956]
    or a
    jr z, jr_001_7cd2

    add $5c
    call Call_000_0710

jr_001_7cd2:
    ld a, [$d954]
    inc a
    ld [$d954], a

jr_001_7cd9:
    ld a, [$d957]
    bit 7, a
    ret nz

    inc a
    ld [$d957], a
    cp $04
    ret nz

    xor a
    ld [$d970], a
    ld a, [$d956]
    add $5d
    call Call_000_0710
    ld a, [$d956]
    inc a
    ld [$d956], a
    ret


Call_001_7cfa:
    ld a, [$d92d]
    ldh [$8a], a
    xor a
    ldh [$8b], a
    ld a, [$d92e]
    dec a
    ld [$d92e], a
    cp $ff
    ret nz

    ld hl, $d92f
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    and $f3
    ld [$d92d], a
    ldh [$8b], a
    ld a, [hl+]
    ld [$d92e], a
    ld a, l
    ld [$d92f], a
    ld a, h
    ld [$d930], a
    ret


    ld bc, $2b18
    ld c, c
    ld e, h
    ld [hl], h
    add [hl]
    xor c
    cp [hl]
    jp z, Jump_000_00ff

    ld c, h
    db $10
    ld [$1e11], sp
    db $10
    ld e, $00
    db $10
    db $10
    inc b
    nop
    inc bc
    ld b, b
    ld [hl-], a
    nop
    add hl, de
    add b
    ld [hl], $00
    dec d
    db $10
    ld d, $00
    inc c
    ld bc, $0011
    inc h
    db $10
    ld e, $00
    ld e, $20
    ld [hl+], a
    nop
    ld c, $10
    inc b
    nop
    ld a, [bc]
    ld bc, $001e
    jr jr_001_7d71

    ld hl, $1e11
    db $10
    add hl, de
    nop
    ld a, [de]
    add b
    jr @-$7d

    ld b, $80
    dec b
    nop
    inc l
    db $10

jr_001_7d71:
    dec sp
    nop
    dec b
    jr nz, jr_001_7d79

    nop
    inc de
    add b

jr_001_7d79:
    dec e
    add c
    ld a, [bc]
    add b
    add hl, bc
    nop
    inc l
    jr nz, @+$1a

    nop
    dec hl
    ld bc, $001d
    sbc a
    ld bc, $0013
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld bc, $0501
    nop
    ld bc, $0401
    nop
    ld [bc], a
    ld bc, $0004
    ld [bc], a
    ld bc, $0004
    ld bc, $0401
    nop
    inc bc
    ld bc, $2101
    ld [bc], a
    jr nz, @+$04

    ld hl, $2004
    ld [bc], a
    ld hl, $0102
    ld [bc], a
    nop
    nop
    jr nz, jr_001_7dc2

jr_001_7dc2:
    nop
    nop
    ld bc, $0003
    inc bc
    ld bc, $0004
    ld [bc], a
    jr nz, jr_001_7dce

jr_001_7dce:
    ld hl, $2003
    inc bc
    ld hl, $2004
    ld [bc], a
    ld hl, $2004
    inc bc
    ld hl, $2003
    inc bc
    ld hl, $2004
    inc bc
    ld bc, $0004
    inc bc
    ld bc, $0004
    inc bc
    ld bc, $2103
    ld bc, $0220
    ld hl, $2005
    ld bc, $0521
    jr nz, jr_001_7dfb

    ld hl, $2005

jr_001_7dfb:
    ld [bc], a
    ld bc, $2004
    inc bc
    ld hl, $2005
    ld [bc], a
    ld hl, $2005
    ld bc, $0000
    ld bc, $0005
    inc bc
    ld bc, $0003
    inc b
    ld bc, $0004
    inc b
    ld bc, $0007
    ld [bc], a
    ld bc, $0005
    ld bc, $0601
    nop
    ld [$0c02], sp
    nop
    ld c, d
    jr nz, jr_001_7e52

    nop
    jr nc, jr_001_7e2c

    add hl, de

jr_001_7e2c:
    nop
    add b
    ld bc, $0020
    ld l, $20
    ld c, b
    nop
    rrca
    db $10
    dec b
    nop
    ld sp, $0e80
    add c
    rlca
    add b
    ld [bc], a
    nop
    ld b, b
    ld [bc], a
    dec bc
    nop
    adc d
    add b
    ld a, [bc]
    add c
    dec bc
    add b
    ld bc, $2700
    add b
    ld c, $81
    db $10

jr_001_7e52:
    add b
    nop
    nop
    jr nc, jr_001_7e67

    jr nz, jr_001_7e59

jr_001_7e59:
    dec l
    ld bc, $0013
    sub h
    db $10
    ld h, h
    nop
    inc h
    jr nz, jr_001_7eb2

    nop
    inc c
    db $10

jr_001_7e67:
    rlca
    nop
    dec hl
    ld bc, $1114
    dec bc
    db $10
    add hl, bc
    nop
    ld l, $02
    dec bc
    nop
    ld a, [hl+]
    db $10
    ld d, [hl]
    nop
    ld h, d
    db $10
    add b
    rst $38
    inc bc
    nop
    sbc c
    sbc e
    rst $38
    inc bc
    sub d
    sbc d
    rst $38
    inc bc
    sub d
    sbc d
    sub d
    sbc b
    rst $38
    ld [$9300], sp
    ld a, [hl+]
    inc e
    ccf
    ld a, [hl]
    inc h
    ld de, $3737
    ld a, [hl+]
    ld a, a
    sub h
    rst $38
    ld [$9300], sp
    rst $38
    ld a, [bc]
    nop
    sbc h
    sbc l
    rst $38
    rlca
    nop
    sub e
    rst $38
    ld a, [bc]
    nop
    sub h
    rst $38
    ld [$9700], sp
    rst $38
    ld a, [bc]
    or b

jr_001_7eb2:
    sub [hl]
    rst $38
    add hl, de
    nop
    sbc c
    rst $38
    inc c
    sub d
    rst $38
    dec b
    sbc d
    sub d
    sbc b
    sub e
    db $10
    ld de, $1312
    inc d
    nop
    ld a, [hl+]
    dec hl
    inc l
    dec l
    ld l, $00
    dec d
    ld d, $17
    jr jr_001_7eea

    nop
    sub h
    sub e
    rst $38
    inc c
    nop
    rst $38
    dec b
    ld b, l
    nop
    sub h
    sub e
    dec d
    ld d, $17
    jr jr_001_7efb

    nop
    cpl
    jr nc, jr_001_7f17

    ld [hl-], a
    inc sp
    nop
    ld a, [de]

jr_001_7eea:
    dec de
    inc e
    dec e
    ld e, $00
    sub h
    sub e
    rst $38
    inc c
    nop
    rst $38
    dec b
    ld b, l
    nop
    sub h
    sub e
    ld a, [de]

jr_001_7efb:
    dec de
    inc e
    dec e
    ld e, $00
    inc [hl]
    dec [hl]
    ld [hl], $37
    jr c, jr_001_7f06

jr_001_7f06:
    rra
    jr nz, jr_001_7f2a

    inc hl
    inc h
    nop
    sub h
    sub e
    rst $38
    inc c
    nop
    rst $38
    dec b
    ld b, l
    nop
    sub h
    sub e

jr_001_7f17:
    rra
    jr nz, jr_001_7f3b

    inc hl
    inc h
    nop
    add hl, sp
    ld a, [hl-]
    dec sp
    inc a
    dec a
    nop
    ld a, [hl+]
    dec hl
    inc l
    dec l
    ld l, $00
    sub h

jr_001_7f2a:
    sub e
    rst $38
    ld [de], a
    nop
    sub h
    sub e
    dec h
    ld h, $27
    jr z, jr_001_7f5e

    nop
    ld a, $3f
    ld b, c
    ld b, d
    rst $38

jr_001_7f3b:
    inc b
    nop
    or e
    or h
    or l
    nop
    sub h
    sub e
    rst $38
    ld [de], a
    nop
    sub h
    sub a
    rst $38
    ld [de], a
    sub l
    sub [hl]
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

jr_001_7f5e:
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
