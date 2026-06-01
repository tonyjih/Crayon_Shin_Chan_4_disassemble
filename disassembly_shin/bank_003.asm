; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

    db $03, $8d, $41, $ee, $41, $19, $4e, $99, $43, $a2, $43

    dec b
    ld b, [hl]
    add hl, bc
    ld b, h
    ld l, $00
    nop
    dec h
    jr c, @+$27

    jr c, @+$27

    jr c, jr_003_403b

    inc a
    nop
    ld [hl+], a
    inc a
    dec hl
    inc [hl]
    dec hl
    inc [hl]
    inc hl
    inc a
    nop
    inc [hl]
    inc c
    inc [hl]
    inc c
    inc h
    inc e
    inc l
    inc d
    nop
    inc l
    inc d
    inc h
    inc e
    inc b
    inc e
    inc d
    inc c
    nop
    inc [hl]
    dec c
    dec [hl]
    ld c, $23

jr_003_403b:
    jr jr_003_4063

    add hl, de
    nop
    ld [hl+], a
    dec e
    jr nz, @+$21

    rla
    rrca
    ld e, $0e
    jr nz, jr_003_4049

jr_003_4049:
    rst $38
    nop
    ld [hl+], a
    ld b, b
    sbc a
    ld b, b
    dec b
    rlca
    rst $38
    ld a, b
    ld hl, sp-$80
    nop
    and b
    rst $38
    nop
    ld [bc], a
    nop
    rst $38
    nop
    ld e, a
    rst $38
    nop
    and b
    ld hl, sp+$06

jr_003_4063:
    rrca
    ld bc, $06fe
    ld e, a
    ld hl, sp+$00
    ld b, b
    ld a, a
    nop
    add b
    ld a, a
    add b
    ld [hl], a
    adc b
    nop
    ld h, [hl]
    sbc c
    ld d, l
    xor d
    ld de, $62cc
    add b
    ld d, b
    rst $38
    nop
    rst $38
    nop
    ld [hl], a
    adc b
    nop
    ld h, [hl]
    sbc c
    ld d, l
    xor d
    ld de, $22cc
    nop
    ld b, b
    cp $00
    ld bc, $01fe
    db $76
    adc c
    nop
    ld h, [hl]
    sbc c
    ld d, h
    xor e
    ld [de], a
    call $0122
    nop
    ld b, h
    add b
    ld c, b
    add b
    ld d, l
    add b
    ld h, d
    add b
    nop
    ld b, h
    add b
    ld c, b
    add b
    ld d, l
    add b
    ld h, d
    add b
    nop
    ld b, h
    nop
    adc b
    nop
    ld d, l
    nop
    ld [hl+], a
    nop
    nop
    ld b, h
    nop
    adc b
    nop
    ld d, l
    nop
    ld [hl+], a
    nop
    nop
    ld b, [hl]
    ld bc, $018a
    ld d, [hl]
    ld bc, $0122
    nop
    ld b, [hl]
    ld bc, $018a
    ld d, [hl]
    ld bc, $0122
    ld [$7fff], sp
    rst $38
    add b
    rst $38
    adc b
    rst $38
    nop
    sbc c
    rst $38
    xor d
    rst $38
    db $dd
    xor $b7
    ret z

    ld l, b
    rst $38
    nop
    rst $38
    adc b
    rst $38
    nop
    sbc c
    rst $38
    xor d
    rst $38
    db $dd
    xor $77
    adc b
    ld [$feff], sp
    rst $38
    ld bc, $81ff
    rst $38
    nop
    sub c
    rst $38
    cp c
    rst $38
    pop hl
    rst $38
    pop bc
    ld a, a
    nop
    xor [hl]
    pop de
    sbc l
    ld [c], a
    xor d
    push de
    or a
    ret z

    nop
    xor [hl]
    pop de
    sbc l
    ld [c], a
    xor d
    push de
    or a
    ret z

    nop
    xor $11
    db $dd
    ld [hl+], a
    xor d
    ld d, l
    ld [hl], a
    adc b
    nop
    xor $11
    db $dd
    ld [hl+], a
    xor d
    ld d, l
    ld [hl], a
    adc b
    nop
    db $ed
    inc de
    db $dd
    inc hl
    xor c
    ld d, a
    ld [hl], l
    adc e
    nop
    db $ed
    inc de
    db $dd
    inc hl
    xor c
    ld d, a
    ld [hl], l
    adc e
    nop
    xor [hl]
    pop de
    sbc l
    ld [c], a
    xor d
    push de
    or a
    ret z

    ld [bc], a
    xor [hl]
    pop de
    sbc l
    ld [c], a
    add b
    rst $38
    ld a, a
    nop
    xor $11
    db $dd
    ld [hl+], a
    xor d
    ld d, l
    ld [hl], a
    adc b
    inc bc
    xor $11
    db $dd
    ld [hl+], a
    nop
    rst $38
    nop
    ld sp, hl
    ld a, a
    pop bc
    ld a, a
    and c
    ld a, a
    ld d, c
    cp a
    nop
    ld sp, hl
    ld a, a
    pop bc
    ld a, a
    and c
    ld a, a
    ld d, c
    cp a
    nop
    ld sp, hl
    ld a, [hl]
    ret nz

    ld a, a
    and b
    ld a, a
    ld e, b
    cp a
    nop
    jp hl


    rra
    jp c, $ad2f

    ld e, [hl]
    ld [hl], a
    adc b
    ld l, b
    rst $38
    ld bc, $89ff
    rst $38
    nop
    sbc c
    rst $38
    xor d
    rst $38
    db $dd
    xor $77
    adc b

    ldh a, [$c9]
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

jr_003_41c3:
    or $0a
    ld [$d96e], a
    and $f0
    or $0b
    ld [$d96f], a

jr_003_41cf:
    xor a
    ld [$d97f], a
    ld [$d980], a
    ld a, $01
    ld [$d982], a
    ld a, [$d970]
    bit 1, a
    ret z

jr_003_41e1:
    call Call_000_0719
    ld a, [$d96d]
    or a
    jr nz, jr_003_41e1

    xor a
    ldh a, [$99]
    ret


    xor a
    ldh [$cc], a
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
    call Call_000_0f3b

jr_003_4210:
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
    call Call_000_0517
    pop hl
    ld de, $c800
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
    call Call_000_0517
    ret


jr_003_425f:
    ld a, [$d96d]
    cp $02
    jr nz, jr_003_426b

    xor a
    ld [$d96d], a
    ret


jr_003_426b:
    ld hl, $d96b
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    bit 0, c
    jr z, jr_003_4278

    ld hl, $c820

jr_003_4278:
    ld de, $ffe0
    add hl, de
    ld a, [$d969]
    ld e, a
    ld a, [$d96a]
    ld d, a
    ld b, $00

jr_003_4286:
    call Call_003_4359
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

jr_003_42a1:
    inc b
    inc hl
    jr jr_003_4286

jr_003_42a5:
    ld a, [$d96e]
    jr jr_003_42ad

jr_003_42aa:
    ld a, [$d96f]

jr_003_42ad:
    bit 1, c
    jr z, jr_003_42b4

    ld [hl], a
    jr jr_003_4286

jr_003_42b4:
    bit 2, c
    jr z, jr_003_42b9

    xor a

jr_003_42b9:
    push hl
    push bc
    call Call_000_0517
    pop bc
    pop hl
    jr jr_003_4286

jr_003_42c2:
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

jr_003_42da:
    ld hl, $c820
    jr jr_003_42f4

jr_003_42df:
    call Call_000_04e4
    ld a, [$d96c]
    ld [hl+], a
    ld a, [$d96b]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    add $03
    ld b, a
    ldh a, [$99]
    add b
    ldh [$99], a

jr_003_42f4:
    ld a, [$d969]
    ld e, a
    ld a, [$d96a]
    ld d, a

jr_003_42fc:
    call Call_003_4359
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

jr_003_4315:
    ld [hl+], a
    jr jr_003_42fc

jr_003_4318:
    ld a, $02
    ld [$d96d], a

jr_003_431d:
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

jr_003_4338:
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

jr_003_4350:
    ld a, l
    ld [$d96b], a
    ld a, h
    ld [$d96c], a
    ret


Call_003_4359:
    ld a, [de]
    cp $ff
    jr z, jr_003_4379

    cp $fc
    call z, Call_003_438a
    cp $fd
    ret nz

    ld a, e
    ldh [$cb], a
    ld a, d
    ldh [$cc], a
    push hl
    ld a, [$d971]
    ld hl, $60db
    rst $20
    ld d, h
    ld e, l
    ld a, [de]
    pop hl
    ret


jr_003_4379:
    ldh a, [$cc]
    or a
    ld a, [de]
    ret z

    ldh a, [$cb]
    ld e, a
    ldh a, [$cc]
    ld d, a
    xor a
    ldh [$cc], a
    inc de
    ld a, [de]
    ret


Call_003_438a:
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


    ld a, d
    ld hl, $4e19
    rst $20
    call Call_000_026c
    ret


    ld a, [$dff8]
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
    ld a, [$d933]
    add a
    ld b, a
    add a
    add b
    ld hl, $4d5f
    rst $38
    ld b, $04

jr_003_43c2:
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
    ld [$c0a3], a
    ld [$c0a4], a
    ld [$c0a5], a

jr_003_43db:
    ld a, b
    set 7, a
    ld [de], a
    inc de
    ld b, $06
    xor a

jr_003_43e3:
    ld [de], a
    inc de
    dec b
    jr nz, jr_003_43e3

    call Call_000_0403
    ld hl, $d985
    call Call_000_03c8
    call Call_000_0403
    ld a, [$d933]
    cp $18
    jr z, jr_003_43fe

    cp $14
    ret nz

jr_003_43fe:
    xor a
    ld [$c0a3], a
    ld [$c0a4], a
    ld [$c0a5], a
    ret


    ld b, $00
    ld a, [$dffe]
    or a
    jr z, jr_003_4413

    ld b, $01

jr_003_4413:
    ld a, [$dffd]
    or a
    jr z, jr_003_441b

    ld b, $02

jr_003_441b:
    ld a, [$dffc]
    cp b
    ret z

    ld a, b
    ld [$dffc], a

Call_003_4424:
    ld de, $c800
    ld b, $03
    ld c, $01

jr_003_442b:
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

jr_003_443d:
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

jr_003_4457:
    add hl, de
    pop de

jr_003_4459:
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

jr_003_4472:
    add $04
    ld b, a
    cp d
    jr c, jr_003_447a

    sub d
    ld b, a

jr_003_447a:
    pop de

jr_003_447b:
    ld a, d
    cp $d0
    jr nz, jr_003_442b

    ld hl, $d000
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

jr_003_44a9:
    ld c, $14

jr_003_44ab:
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

jr_003_44bc:
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

jr_003_44cf:
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
    ld hl, $c800
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
    ld bc, $ff01
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
    ld bc, $ff01
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

jr_003_457e:
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

jr_003_4596:
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

jr_003_45bf:
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

jr_003_45d7:
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
    call Call_000_03c8
    call Call_000_0403
    ld hl, $4774
    ld b, $08

jr_003_461b:
    push hl
    push bc
    call Call_000_03c8
    call Call_000_0403
    pop bc
    pop hl
    ld de, $0010
    add hl, de
    dec b
    jr nz, jr_003_461b

    ld hl, $c800
    ld de, $3ca2
    ld b, $59

jr_003_4634:
    ld c, $08

jr_003_4636:
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, $ff
    ld [hl+], a
    dec c
    jr nz, jr_003_4636

    xor a
    ld c, $08

jr_003_4642:
    ld [hl+], a
    ld [hl+], a
    dec c
    jr nz, jr_003_4642

    dec b
    jr nz, jr_003_4634

    ld hl, $c800
    ld bc, $0020
    call bzero
    ld de, $4714
    ld hl, $c800
    ld bc, $0b20
    call Call_000_0490
    call Call_003_4424
    ld hl, $4b5f
    ld de, $c800
    ld bc, $0400
    call memcpy
    ld de, $4724
    ld hl, $c800
    ld bc, $1000
    call Call_000_0490
    ld a, $03
    ld hl, $47f4
    ld de, $c800
    call LoadMainGfx
    ld de, $4734
    ld hl, $c800
    ld bc, $05fa
    call Call_000_0490
    xor a
    ldh [rBGP], a
    ldh [rOBP0], a
    ldh [rOBP1], a
    ld a, $81
    ldh [rLCDC], a
    ld hl, $4754
    call Call_000_03c8
    call Call_000_0403
    ret


    ld a, $1f
    ldh [$c9], a

jr_003_46aa:
    push hl
    ld b, $10

jr_003_46ad:
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
    ldh a, [$c9]
    sub $02
    ldh [$c9], a
    jr nc, jr_003_46aa

    ret


Call_003_46c5:
    push de
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    push hl
    ld h, $03
    ld bc, $0000

jr_003_46d0:
    ld a, e
    and $1f
    push bc
    call Call_003_46f9
    pop bc
    or c
    ld c, a
    ld l, $05

jr_003_46dc:
    srl d
    rr e
    srl c
    rr b
    jr nc, jr_003_46e8

    set 7, c

jr_003_46e8:
    dec l
    jr nz, jr_003_46dc

    dec h
    jr nz, jr_003_46d0

    srl c
    rr b
    jr nc, jr_003_46f6

    set 7, c

jr_003_46f6:
    pop hl
    pop de
    ret


Call_003_46f9:
    push hl
    xor $1f
    ld c, a
    ldh a, [$c9]
    call Call_000_05b4
    ld c, $ff

jr_003_4704:
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
    jr z, jr_003_483e

    ld d, d
    ld [$0b00], sp
    xor c
    rst $20
    sbc a
    ld bc, $7ec0
    add sp, -$18
    add sp, -$18
    ldh [$79], a
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
    ld [$c0ea], a
    nop
    ld a, a
    nop
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
    call c, $c0ff
    rst $38
    rst $20
    ret nz

    rst $38
    add hl, sp
    ret nz

    rst $38
    ret nz

    xor d
    rst $08
    add b
    xor d
    ld a, a
    nop
    pop af
    dec b
    ld d, l
    nop
    ld [$052a], sp
    ld d, l
    nop
    ld a, [hl+]
    dec b
    ld d, l
    ld b, c
    nop
    ld a, [hl+]
    dec b
    ld d, l
    nop
    xor d
    rst $38
    rst $38
    rst $38
    rst $30
    nop
    ld hl, sp+$55
    xor b
    rst $38
    add h
    ldh a, [rHDMA5]
    xor b
    rst $38
    ldh a, [rHDMA5]
    inc sp
    xor b
    nop
    ld d, l
    nop
    rst $38
    rst $38
    rst $38

jr_003_483e:
    rst $38
    rst $38
    rst $38
    rst $38
    db $fc
    ld a, [bc]
    xor d
    add $a0
    ld [$2000], sp
    ld sp, $0008
    jr nz, @+$0c

    xor d
    sbc a
    and b
    nop
    rst $38
    rst $38
    rst $38
    ld hl, sp+$03
    ldh a, [$fc]
    ld a, $3f
    nop
    ld d, l
    rst $38
    db $fd
    nop
    rst $38
    ld a, c
    ld d, l
    ld d, b
    nop
    adc h
    dec b
    ld d, b
    nop
    dec b
    ld d, l
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld sp, hl
    ld d, [hl]
    ld d, l
    cp $56
    ld a, a
    ld d, l
    rst $38
    ret nz

    xor e
    ld a, [$abbf]
    ld a, [$67af]
    rst $38
    ld [$1cff], a
    rst $28
    ei
    rst $38
    db $eb
    rst $38
    add $fe
    xor a
    rst $38
    ld [$bf30], a
    rst $38
    db $eb
    ld a, [$aaaf]
    nop
    ld a, [$eaaf]
    cp $af
    ld [$abfe], a
    nop
    ld a, [$abbf]
    ld a, [$eaaf]
    cp $af
    nop
    ld [$affe], a
    ld [$57fe], a
    ld a, [$00bf]
    xor e
    ld e, c
    ld d, b
    xor d
    ld a, [$55af]
    ld d, h
    nop
    xor a
    ld [$a5fe], a
    ld d, l
    cp a
    xor e
    ld a, [$b000]
    ld b, $fe
    xor a
    ld [$02f0], a
    ld [$fe00], a
    xor a
    add sp, $03
    xor e
    ld a, [$abbf]
    nop
    ld a, [$d5af]
    ld [hl], b
    inc bc
    xor d
    cp $55
    ld b, $50
    ld [bc], a
    xor a
    ldh a, [rP1]
    rrca
    ld sp, $00e0
    ld c, $a0
    nop
    adc h
    ld a, [bc]
    or b
    nop
    dec bc
    ldh a, [$63]
    nop
    rrca
    ldh [rP1], a
    jr jr_003_4906

    and b
    nop
    ld a, [bc]
    and b
    nop
    add $0a
    ldh a, [rP1]
    rrca
    ld sp, $00f0
    rrca

jr_003_4906:
    and b
    nop
    adc h
    ld a, [bc]
    and b
    nop
    ld a, [bc]
    or b
    ld h, b
    nop
    dec bc
    cp $af
    ld [$01fe], a
    xor a
    ld [$affe], a
    ld [$00fe], a
    and $3f
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, e
    rst $38
    db $fc

jr_003_4930:
    ccf
    rst $38
    jr jr_003_4930

    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    ld h, a
    nop
    inc bc
    nop
    rst $38
    ret nz

    ld bc, $0240
    xor b
    nop
    ld a, [bc]
    nop
    ld b, b
    ld [bc], a
    and b
    nop
    ld a, [bc]
    add b
    ld [bc], a
    and b
    rra
    nop
    ld [bc], a
    nop
    ld sp, hl
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, e
    rst $38
    db $fc

jr_003_4963:
    ccf
    rst $38
    jr jr_003_4963

    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    sbc c
    db $fc
    nop
    inc bc
    nop
    rst $38
    ldh a, [rTIMA]
    ld b, b
    inc bc
    ldh a, [rP1]
    nop
    rrca
    ret nz

    inc bc
    ldh a, [rP1]
    rrca
    ret nz

    rlca
    inc bc
    ldh a, [rP1]
    inc bc
    nop
    cp $3f
    ld h, e
    rst $38
    db $fc

jr_003_4996:
    ccf
    rst $38
    jr jr_003_4996

    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, [hl]
    rst $38
    db $fc
    nop
    inc bc
    ld a, a
    nop
    rst $38
    nop
    inc bc
    ldh a, [rP1]
    dec b
    nop
    inc bc
    ldh a, [rP1]
    nop
    ld a, [bc]
    ret nz

    inc bc
    ldh a, [rP1]
    rrca
    ret nz

    nop
    rst $38
    sbc b
    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, e
    rst $38
    db $fc
    ccf
    rst $38
    add hl, de
    db $fc
    ccf
    rst $38
    db $fc
    nop
    sbc h
    inc bc
    nop
    ld a, [bc]
    nop
    rst $20
    ld b, $00
    nop
    dec b
    ld b, b
    ld [bc], a
    and b
    nop
    dec b
    ld b, b
    ld [bc], a
    nop
    and b
    nop
    dec b
    nop
    ld [bc], a
    and b
    nop
    ld a, [bc]
    ccf
    add b
    nop
    and $3f
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, e
    rst $38
    db $fc

jr_003_4a1d:
    ccf
    rst $38
    jr jr_003_4a1d

    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    rra
    nop
    ret nz

    nop
    jr jr_003_4a36

    ld b, b
    nop
    dec b
    ld b, b
    nop

jr_003_4a36:
    ret nz

    dec b
    ld b, b
    ld [bc], a
    and b
    nop
    dec b
    nop
    ld b, b
    ld [bc], a
    and b
    nop
    dec b
    ld b, b
    ld [bc], a
    and b
    ld a, a
    nop
    ld sp, hl
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, e
    rst $38
    db $fc

jr_003_4a54:
    ccf
    rst $38
    jr jr_003_4a54

    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    add a
    db $fc
    nop
    ret nz

    nop
    adc h
    jr z, @+$04

    nop
    jr z, jr_003_4a79

    jr nz, @+$42

    nop
    ld a, [hl+]
    dec b
    add b

jr_003_4a79:
    ld a, [bc]
    and b
    nop
    inc d
    dec b
    ld b, b
    ld [bc], a
    and b
    inc d
    dec b
    ld b, b
    inc bc
    ld [bc], a
    and b
    inc d
    dec b
    ld b, b
    nop
    cp $3f
    ld h, e
    rst $38
    db $fc

jr_003_4a90:
    ccf
    rst $38
    jr jr_003_4a90

    ccf
    rst $38
    db $fc
    ccf
    rst $38
    add $fc
    ccf
    rst $38
    db $fc
    ld sp, $ff3f
    db $fc
    ccf
    rst $38
    adc h
    db $fc
    ccf
    rst $38
    db $fc
    ccf
    ld h, h
    rst $38
    db $fc
    nop
    inc c
    nop
    db $e3
    jr z, @+$04

    nop
    ld [$0628], sp
    ld b, b
    nop
    ld a, [hl+]
    dec b
    add b
    ld b, d
    nop
    inc d
    dec b
    ld b, b
    nop
    inc d
    db $10
    dec b
    ld b, b
    nop
    inc d
    dec b
    ld b, b
    nop
    di
    xor c
    ld d, l
    jr jr_003_4b20

    xor e
    ld d, l
    ld d, b
    xor e
    ld d, l
    add $50
    xor c
    ld d, l
    ld d, b
    ld sp, $55a9
    ld d, b
    xor e
    ld d, l
    adc h
    ld d, b
    xor e
    ld d, l
    ld d, b
    xor c
    ld h, e
    ld d, l
    ld d, b
    xor c
    ld d, l
    jr jr_003_4b3d

    xor e
    ld d, l
    ld d, b
    xor e
    ld d, l
    add $50
    xor c
    ld d, l
    ld d, b
    ld sp, $55a9
    ld d, b
    xor e
    ld d, l
    adc h
    ld d, b
    xor e
    ld d, l
    ld d, b
    xor c
    ld h, a
    ld d, l
    ld d, b
    ld d, l
    db $fd
    nop
    and $02
    xor d
    add b
    ld sp, $aa02
    add b
    ld [bc], a
    xor d
    adc h
    add b
    ld [bc], a
    xor d
    add b
    ld [bc], a
    ld h, e
    xor d
    add b
    ld [bc], a
    xor d
    jr @-$7e

jr_003_4b20:
    ld [bc], a
    xor d
    add b
    ld [bc], a
    xor d
    add $80
    ld [bc], a
    xor d
    add b
    ld sp, $aa02
    add b
    ld [bc], a
    xor d
    adc h
    add b
    ld [bc], a
    xor d
    add b
    ld d, [hl]
    ld h, d
    xor d
    add b
    ld d, [hl]
    xor d
    xor e
    add hl, de

jr_003_4b3d:
    add b
    ld d, [hl]
    xor d
    add b
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    cp a
    ld d, l
    rst $38
    ei
    xor d
    sbc $ff
    ret nz

    ld h, e
    nop
    inc bc
    ret nz

    nop
    ccf
    inc bc
    rst $38
    rst $38
    rst $38
    ret nz

    call $7321
    inc bc
    jp hl


    ld h, a
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

jr_003_4bd6:
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
    jp nz, Jump_000_007e

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
    db $76
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
    call z, Call_000_000e
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
    ld bc, $0101
    ld bc, $0000
    inc b
    dec b
    ld b, $07
    ld bc, $2801
    add hl, hl
    ld a, [hl+]
    dec hl
    ld [bc], a
    inc bc
    ld [$0a09], sp
    dec bc
    inc bc
    ld [$0000], sp
    nop
    nop
    nop
    nop
    db $10
    ld de, $1312
    dec b
    inc bc
    inc d
    dec d
    ld d, $17
    ld b, $03
    inc l
    dec l
    ld l, $00
    inc b
    inc bc
    jr jr_003_4daa

    ld a, [de]
    dec de
    rlca
    inc bc
    inc e
    dec e
    ld e, $1f
    ld [$2003], sp
    ld hl, $2322
    ld a, [bc]
    inc bc
    inc h
    dec h
    ld h, $27
    inc c
    inc bc
    inc [hl]
    inc [hl]
    inc [hl]

jr_003_4daa:
    inc [hl]
    nop
    ld [$0d0c], sp
    ld c, $0f
    ld c, $08
    dec [hl]
    dec [hl]
    dec [hl]
    dec [hl]
    nop
    ld [$0000], sp
    nop
    nop
    nop
    dec b
    jr jr_003_4dda

    ld a, [de]
    dec de
    rlca
    inc bc
    inc e
    dec e
    ld e, $1f
    add hl, bc
    inc bc
    jr nz, @+$23

    ld [hl+], a
    ld [bc], a
    dec bc
    inc bc
    inc h
    dec h
    ld h, $27
    dec c
    inc bc
    inc bc
    inc bc
    inc bc

jr_003_4dda:
    inc bc
    rrca
    ld [$0303], sp
    inc bc
    inc bc
    nop
    nop
    ld bc, $0101
    ld bc, $000f
    inc a
    dec a
    ld a, $3f
    ld c, $00
    inc bc
    inc bc
    inc bc
    inc bc
    nop
    rlca
    inc a
    dec a
    ld a, $3f
    db $10
    inc b
    jr c, @+$3a

    jr c, @+$3a

    nop
    add hl, bc
    add hl, sp
    add hl, sp
    add hl, sp
    add hl, sp
    nop
    rlca
    ld a, [hl-]
    ld a, [hl-]
    ld a, [hl-]
    ld a, [hl-]
    nop
    ld b, $3b
    dec sp
    dec sp
    dec sp
    nop
    ld a, [bc]
    nop
    nop
    nop
    nop
    nop
    ld [bc], a

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
    ld a, [c]
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
    db $76
    ld a, c
    db $76

    db $92, $76, $a3, $76, $bc, $76

    db $cd
    db $76

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

    ld l, l
    ld d, e
    ld l, l
    ld d, e
    ld b, l
    rra
    ld de, $171a
    dec e
    ld b, d
    cp $19
    ld b, d
    jr nz, @+$3e

    ld [de], a
    db $10
    ld hl, $fe32
    inc d
    inc e
    ld b, l
    dec l
    dec [hl]
    ld b, l
    ld d, [hl]
    ld [hl], b
    ld a, h
    ld b, e
    ld h, a
    rst $38
    dec d
    ld de, $003f
    nop
    nop
    nop
    dec b
    cp $45
    ld e, [hl]
    ld l, [hl]
    nop
    nop
    nop
    nop
    nop
    dec b
    cp $4c
    ld a, h
    ld b, l
    ld e, [hl]
    ld c, c
    ld a, h
    ld b, l
    ld d, d
    nop
    dec b
    cp $58
    ld a, b
    ld d, d
    ld e, a
    ld b, l
    ld e, [hl]
    ld l, [hl]
    nop
    dec b
    rst $38

    db $57, $5a, $7e, $5f, $7d, $ff, $00, $05, $ff, $00, $06, $ff, $00, $07, $ff, $78
    db $45, $2d, $77, $fd, $ff, $a0, $43, $66, $52, $61, $5d, $52, $2d, $11, $17, $45
    db $59, $a1, $ff, $a0, $3d, $12, $20, $13, $42, $45, $23, $10, $1e, $45, $2c, $45
    db $59, $a1, $ff, $00, $a0, $45, $5e, $43, $65, $7e, $5f, $2d, $11, $17, $45, $59
    db $a1, $ff, $a0, $45, $52, $46, $6c, $35, $3e, $19, $12, $45, $1f, $45, $59, $a1
    db $ff

    db $10
    inc h
    nop
    db $fd
    dec d
    ld de, $1f45
    dec a
    rst $38
    adc [hl]
    inc d
    ld b, l
    jr jr_003_5304

    ld d, $8f
    rst $38
    adc [hl]
    ld b, l
    rra
    dec de
    inc hl
    ld a, l
    adc a
    rst $38

    db $16, $3e, $12, $2a, $00, $1b, $42, $20, $3a, $42, $45, $15, $fe, $1f, $29, $1b
    db $30, $26, $1b, $23, $11, $1f, $43, $66, $52, $61, $5d, $52, $fe

    add hl, hl
    nop
    dec hl
    nop
    ld b, l
    inc hl
    inc e
    cp $24
    add hl, de
    jr c, @+$47

    dec d
    nop
    inc d
    add hl, sp
    ld hl, $5b29
    ld [hl], h
    ld d, h
    ld b, l
    ld h, [hl]
    ld b, c
    cp $5a

jr_003_5304:
    ld d, e
    ld d, [hl]
    rla
    ld b, d
    ld h, $00
    inc h
    inc [hl]
    scf
    inc hl
    dec de
    cpl
    ld de, $2ffe
    dec de
    rra
    ld a, l
    rst $38

    db $1b, $42, $20, $3a, $42, $45, $15, $00, $15, $3d, $22, $23, $11, $36, $fe, $2b
    db $2f, $3f, $35, $45, $17, $30, $26, $2a, $00, $3b, $15, $11, $25, $fe, $14, $24
    db $33, $45, $1f, $20, $45, $15, $00, $11, $22, $43, $2a, $11, $7d, $fe, $45, $23
    db $33, $00, $24, $25, $35, $29, $45, $65, $75, $45, $17, $30, $26, $2a, $fe, $15
    db $3f, $31, $34, $17, $42, $29, $3d, $12, $25, $fe, $75, $48, $45, $65, $77, $45
    db $2a, $15, $35, $00, $25, $42, $45, $1f, $7d, $ff, $16, $3e, $12, $29, $00, $46
    db $52, $56, $74, $7c, $45, $5e, $43, $65, $7e, $5f, $fe, $2a, $00, $1c, $45, $19
    db $11, $00, $2b, $24, $45, $1f, $15, $35, $7d, $fe, $25, $45, $1d, $25, $34, $00
    db $14, $17, $45, $1b, $3e, $12, $45, $23, $fe, $46, $52, $56, $74, $7c, $15, $32
    db $42, $56, $74, $7e, $45, $15, $fe, $14, $19, $25, $3f, $37, $36, $15, $34, $45
    db $23, $1c, $7d, $ff, $30, $1a, $13, $45, $15, $00, $14, $12, $45, $2e, $1b, $1f
    db $52, $48, $45, $57, $45, $23, $fe, $45, $52, $46, $6c, $35, $3e, $19, $12, $45
    db $15, $00, $10, $1f, $22, $23, $fe, $1b, $2f, $22, $1f, $7d, $fe, $1a, $22, $1e
    db $17, $00, $15, $45, $1e, $17, $30, $42, $25, $45, $23, $fe, $45, $52, $46, $6c
    db $2d, $00, $39, $22, $23, $16, $1f, $29, $45, $23, $1c, $45, $15, $fe, $44, $44
    db $44, $7f, $ff

    dec l
    ld [hl+], a
    dec l
    ld [hl+], a
    dec l
    ld [hl+], a
    dec l
    ld a, [hl]
    cp $5b
    ld [hl], h
    ld d, h
    ld b, l
    ld h, [hl]
    nop
    ld de, $1f22
    ld b, l
    rra
    ld d, $7e
    ld a, l
    cp $44
    ld b, h
    ld b, h
    inc d
    ld de, $007d
    dec h
    ld h, $61
    ld l, a
    ld d, e
    inc hl
    ld b, d
    ld b, l
    rra
    dec a
    cp $16
    inc sp
    jr nz, jr_003_54b2

    db $76
    ld a, [hl]
    dec h
    ld a, l
    ld a, l
    rst $38
    ld de, $7e39
    nop
    ld b, l
    ld d, e
    ld a, [hl]
    ld l, h
    ld b, l
    ld l, c
    ld a, [hl]
    ld c, b
    ld h, $45
    inc hl
    ld [hl], $29
    cp $2b
    ld a, [de]
    dec de
    ld b, l
    inc l
    dec [hl]
    dec h
    inc sp
    ld b, d
    ld b, l
    inc hl
    ld b, h
    ld b, h
    ld b, h
    cp $45
    inc h
    ld a, [hl]
    inc sp
    nop
    ld b, l
    inc h
    ld a, [hl]
    inc sp
    nop
    dec de
    ld b, d
    add hl, hl
    inc e
    jr jr_003_54b4

    inc hl
    inc e
    ld [de], a
    cp $1c
    ld d, $25
    nop
    inc d
    ld b, e
    ld h, l
    ld a, h
    ld e, h
    add hl, hl
    ld b, l
    ld d, b
    ld [hl], l
    ld a, [hl+]
    ld b, h
    ld b, h
    rst $38
    inc de
    ld a, [hl]
    ld de, $2500
    ld h, $45
    ld h, a
    ld e, h
    ld b, l
    ld h, a
    ld e, h
    ld de, $2322
    ld b, d
    ld b, l
    rra
    ld a, l
    cp $19
    ld de, $2a21
    nop
    ld de, $451f
    rra
    ld de, $1123
    rla
    ld b, l
    dec e
    cp $10
    ld b, l
    ld a, [hl+]
    dec a
    ld a, l
    cp $fc
    rst $38
    inc d
    inc d

jr_003_54b2:
    ld [hl+], a
    nop

jr_003_54b4:
    ld c, [hl]
    ld [hl], l
    add hl, hl
    ld e, e
    ld [hl], h
    ld d, h
    ld b, l
    ld h, [hl]
    cp $24
    dec [hl]
    dec d
    inc de
    ld a, [de]
    dec h
    rla
    ld [hl+], a
    jr nz, @+$3c

    ld a, l
    cp $fc
    ld b, l
    inc hl
    inc sp
    nop
    ld e, $29
    cpl
    inc de
    ld h, $00
    ld c, [hl]
    ld [hl], l
    add hl, hl
    ld [de], a
    ld b, l
    add hl, de
    dec d
    dec de
    cp $15
    rra
    ld b, c
    nop
    dec e
    ld hl, $1132
    inc e
    ld [hl], $45
    ld e, c
    ld a, l
    rst $38

    db $20, $22, $00, $1b, $3e, $12, $45, $15, $25, $11, $25, $10, $fe, $5b, $74, $54
    db $45, $66, $00, $15, $13, $1b, $23, $39, $36, $3d, $7d, $ff, $7a, $7e, $48, $00
    db $7a, $7e, $48, $fe, $5b, $74, $54, $45, $66, $45, $1f, $00, $5b, $74, $54, $45
    db $66, $45, $1f, $7e, $7d, $ff, $45, $55, $7e, $5d, $ff, $1c, $44, $1c, $45, $18
    db $13, $fe, $11, $22, $16, $29, $30, $00, $1b, $23, $39, $45, $15, $36, $44, $44
    db $44, $ff, $11, $39, $7e, $00, $2b, $24, $10, $1d, $00, $15, $11, $1f, $10, $24
    db $29, $fe, $5b, $74, $54, $45, $66, $7d, $fe, $12, $2f, $11, $42, $45, $1f, $25
    db $00, $19, $37, $45, $15, $7d, $7d, $ff, $00, $00, $00, $57, $5e, $7e, $45, $56
    db $fd, $00, $14, $1b, $2f, $11, $fe, $00, $00, $00, $00, $00, $43, $65, $57, $7a
    db $7e, $45, $5f, $ff, $2c, $22, $2c, $22, $2c, $22, $2c, $22, $fe, $2b, $1a, $1b
    db $45, $2c, $35, $45, $1f, $25, $00, $1b, $42, $29, $1c, $18, $7d, $ff, $10, $42
    db $1f, $00, $45, $1f, $37, $7f, $ff, $3d, $12, $20, $13, $42, $00, $45, $65, $75
    db $45, $17, $30, $29, $00, $5b, $7e, $5a, $7e, $fe, $19, $24, $00, $15, $3f, $31
    db $34, $1a, $2f, $45, $1f, $7d, $7d, $fe, $3f, $1c, $37, $36, $24, $2a, $00, $45
    db $2c, $37, $11, $25, $39, $21, $45, $1f, $ff, $28, $13, $7e, $42, $fe, $1e, $42
    db $25, $26, $00, $14, $19, $34, $25, $11, $45, $23, $3d, $14, $7e, $42, $fe, $3b
    db $36, $1b, $23, $13, $13, $13, $7e, $42, $ff, $45, $1f, $10, $7e, $22, $7d, $00
    db $16, $33, $20, $3f, $35, $7e, $25, $7e, $7d, $7d, $fe, $16, $3e, $12, $2a, $00
    db $2b, $45, $19, $38, $29, $00, $12, $34, $30, $41, $fe, $2a, $34, $1c, $1f, $32
    db $26, $00, $1b, $3e, $12, $45, $2c, $45, $1f, $7d, $fe, $69, $7e, $77, $45, $23
    db $00, $2f, $22, $23, $11, $36, $45, $1e, $7d, $7d, $fe, $fc, $ff, $12, $12, $7e
    db $42, $00, $4e, $75, $45, $1f, $22, $23, $00, $3f, $36, $45, $16, $45, $15, $fe
    db $10, $22, $1f, $3f, $18, $45, $1b, $3a, $25, $11, $1b, $7e, $fe, $12, $12, $7e
    db $42, $00, $11, $39, $7e, $42, $00, $11, $44, $18, $44, $45, $1c, $7e, $fe, $fc
    db $44, $44, $10, $37, $7f, $00, $11, $25, $17, $25, $22, $20, $3a, $22, $1f, $ff
    db $12, $3f, $7e, $42, $7d, $fe, $68, $1b, $42, $20, $3a, $42, $06, $71, $68, $07
    db $71, $26, $fe, $2b, $16, $21, $45, $21, $11, $23, $00, $68, $08, $71, $45, $23
    db $33, $fe, $2f, $1f, $00, $2f, $18, $20, $2f, $22, $1f, $10, $7e, $7d, $ff, $21
    db $45, $16, $45, $1f, $7d, $00, $21, $45, $16, $19, $1e, $00, $4e, $78, $1a, $2f
    db $45, $15, $fe, $15, $22, $23, $30, $1d, $36, $45, $1e, $7e, $7d, $fe, $1b, $42
    db $29, $1c, $18, $7d, $fe, $57, $5e, $7e, $45, $56, $fd, $00, $33, $12, $11, $20
    db $45, $24, $00, $39, $37, $7d, $ff, $3f, $45, $15, $2f, $2f, $45, $1f, $25, $10
    db $ff, $57, $5e, $7e, $45, $56, $fd, $ff, $3d, $15, $22, $1f, $3f, $28, $7e, $00
    db $1b, $42, $20, $3a, $42, $fe, $10, $19, $45, $15, $37, $29, $00, $46, $52, $56
    db $74, $7c, $15, $32, $42, $26, $fe, $10, $13, $36, $3f, $3d, $7d, $ff, $2a, $45
    db $1c, $15, $1b, $11, $15, $34, $00, $2a, $1b, $3a, $45, $17, $25, $3d, $fe, $30
    db $1a, $13, $ff, $10, $42, $1f, $45, $15, $00, $11, $16, $1f, $11, $22, $23, $3b
    db $7e, $15, $34, $fe, $16, $1f, $42, $45, $23, $1b, $3e, $7e, $45, $15, $7d, $fe
    db $2a, $39, $17, $00, $11, $22, $23, $16, $25, $1a, $11, $7d, $7d, $ff, $69, $5d
    db $69, $7e, $48, $ff, $14, $14, $22, $00, $33, $12, $00, $2a, $45, $1b, $2f, $22
    db $23, $11, $36, $45, $59, $7e, $fe, $45, $15, $42, $45, $2a, $37, $00, $46, $52
    db $56, $74, $7c, $15, $32, $7e, $42, $7d, $7d, $ff, $17, $34, $13, $00, $45, $67
    db $75, $5d, $52, $6d, $53, $6d, $53, $45, $1f, $42, $7d, $fe, $46, $52, $56, $74
    db $7c, $00, $45, $52, $78, $7e, $5f, $45, $66, $7e, $6c, $7d, $7d, $7d, $fe, $fc
    db $ff, $30, $1f, $15, $00, $1d, $11, $45, $16, $29, $20, $15, $34, $41, $7d, $fe
    db $3f, $1f, $1b, $45, $15, $00, $11, $36, $15, $45, $16, $35, $fe, $20, $16, $3c
    db $12, $2a, $00, $2d, $11, $3f, $45, $23, $fe, $10, $35, $21, $45, $21, $18, $36
    db $29, $45, $1f, $7d, $7d, $ff, $7a, $7e, $5d, $65, $5d, $65, $5d, $65, $5d, $65
    db $5d, $65, $5d, $fe, $7a, $7e, $5d, $65, $5d, $65, $5d, $65, $5d, $65, $5d, $65
    db $5d, $7d, $7d, $7d, $ff

    nop
    ld d, a
    ld e, [hl]
    ld a, [hl]
    ld b, l
    ld d, [hl]
    db $fd
    ld e, d
    ld a, [hl]
    ld b, l
    ld l, c
    nop
    inc d
    dec de
    cpl
    ld de, $00fe
    nop
    nop
    nop
    nop
    ld b, e
    ld h, l
    ld d, a
    ld a, d
    ld a, [hl]
    ld b, l
    ld e, a
    rst $38

    db $69, $5d, $69, $7e, $48, $fe, $45, $52, $46, $6c, $00, $45, $52, $46, $6c, $7e
    db $ff, $2c, $12, $7e, $22, $00, $25, $42, $24, $15, $00, $21, $11, $1f, $45, $1e
    db $fe, $25, $45, $15, $11, $00, $30, $20, $29, $35, $45, $1f, $22, $1f, $44, $44
    db $44, $ff, $45, $23, $00, $45, $52, $46, $6c, $22, $23, $00, $25, $26, $7f, $fe
    db $4e, $75, $26, $00, $15, $42, $18, $11, $10, $36, $33, $29, $7f, $ff, $39, $22
    db $43, $2a, $35, $00, $1e, $42, $25, $19, $24, $45, $1f, $38, $12, $24, $fe, $14
    db $33, $22, $1f, $3f, $3d, $ff, $14, $00, $45, $51, $70, $77, $fe, $fc, $ff, $14
    db $44, $14, $11, $00, $1b, $42, $29, $1c, $18, $7e, $7d, $ff, $39, $22, $43, $2a
    db $35, $00, $19, $42, $25, $19, $24, $26, $fe, $25, $36, $45, $1f, $38, $12, $24
    db $00, $14, $33, $22, $1f, $3f, $3d, $44, $44, $44, $ff, $10, $7e, $22, $00, $11
    db $1f, $00, $11, $1f, $7d, $fe, $1b, $42, $29, $1c, $18, $7d, $fe, $10, $42, $1f
    db $00, $45, $24, $19, $11, $22, $23, $1f, $29, $3d, $7d, $7f, $fe, $fc, $ff, $25
    db $11, $1b, $3e, $ff, $25, $26, $45, $15, $00, $25, $11, $1b, $3e, $00, $3d, $7d
    db $fe, $2b, $24, $29, $00, $16, $00, $33, $00, $1b, $34, $25, $11, $45, $23, $7e
    db $22, $7d, $ff, $2f, $10, $00, $2f, $10, $fe, $1b, $42, $29, $1c, $18, $33, $00
    db $45, $52, $46, $6c, $2d, $00, $16, $23, $fe, $12, $37, $1b, $15, $22, $1f, $42
    db $45, $1f, $3d, $ff, $fc, $1a, $22, $00, $33, $12, $00, $15, $13, $36, $45, $1b
    db $15, $42, $45, $1f, $fe, $1f, $29, $1b, $15, $22, $1f, $15, $7f, $00, $1b, $42
    db $29, $1c, $18, $ff, $12, $42, $00, $1f, $29, $1b, $15, $22, $1f, $fe, $1f, $29
    db $1b, $15, $22, $1f, $15, $7f, $00, $30, $1a, $13, $ff, $10, $7e, $22, $00, $33
    db $14, $7d, $fe, $43, $65, $43, $65, $29, $00, $17, $20, $2f, $28, $2a, $fe, $39
    db $32, $25, $1a, $7e, $11, $7d, $7d, $ff, $57, $5a, $7e, $5f, $14, $1d, $45, $2a
    db $7f, $ff, $00, $00, $00, $52, $78, $73, $7c, $1b, $42, $20, $3a, $42, $08, $fe
    db $00, $7e, $4e, $75, $29, $11, $1f, $45, $1c, $34, $45, $1f, $11, $2d, $42, $1b
    db $42, $7e, $ff, $00, $00, $45, $53, $7c, $55, $52, $fe, $12, $1c, $11, $00, $3d
    db $1b, $24, $ff, $43, $67, $79, $45, $5e, $72, $7e, $55, $7e, $fe, $1a, $24, $12
    db $00, $21, $3d, $1b, $ff, $57, $43, $2d, $56, $70, $77, $00, $55, $7c, $52, $57
    db $fe, $00, $39, $1c, $15, $3f, $00, $1f, $18, $1b, $fe, $00, $11, $1e, $45, $15
    db $11, $00, $1f, $18, $14, $ff, $57, $43, $2d, $56, $70, $77, $00, $55, $7c, $52
    db $57, $fe, $00, $2f, $13, $2a, $1f, $00, $1f, $45, $1f, $1f, $15, $fe, $00, $00
    db $10, $34, $11, $00, $2f, $1a, $3b, $16, $ff, $54, $7e, $45, $5e, $49, $63, $7e
    db $5a, $7e, $fe, $00, $1b, $30, $20, $3e, $42, $ff, $43, $67, $79, $45, $52, $75
    db $6a, $7e, $fe, $00, $2a, $12, $10, $42, $fe, $00, $3d, $1b, $2c, $30, $ff, $45
    db $5e, $45, $55, $48, $60, $7e, $fe, $00, $15, $22, $18, $7e, $ff, $00, $00, $00
    db $54, $7c, $43, $69, $7e, $45, $55, $7e, $fe, $45, $67, $7e, $48, $7c, $45, $52
    db $00, $45, $67, $7e, $00, $30, $45, $1c, $1f, $26, $ff, $5e, $57, $5f, $00, $43
    db $67, $78, $48, $6f, $7e, $45, $57, $fe, $00, $00, $4e, $61, $51, $57, $fe, $4c
    db $5d, $45, $52, $6d, $7c, $00, $00, $45, $2a, $45, $1b, $ff, $43, $67, $78, $45
    db $58, $7c, $5c, $00, $45, $65, $48, $fe, $00, $00, $45, $65, $7c, $45, $5a, $48
    db $ff, $14, $1b, $2f, $11, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00
    db $00, $00, $00, $00, $00, $00, $00, $ff, $00, $00, $68, $14, $45, $2d, $42, $16
    db $45, $23, $28, $71, $fe, $43, $65, $57, $7a, $7e, $45, $5f, $45, $15, $32, $42
    db $45, $23, $fe, $12, $13, $29, $00, $43, $65, $57, $7a, $7e, $45, $5f, $41, $fe
    db $26, $3c, $12, $35, $3e, $17, $1b, $23, $30, $3d, $12, $7d, $fe, $20, $3e, $22
    db $24, $00, $31, $45, $1c, $15, $1b, $11, $fe, $06, $1b, $3c, $12, $32, $00, $45
    db $15, $fe, $2a, $45, $1b, $2f, $36, $45, $59, $7d, $ff

    nop
    ld l, b
    dec de
    ld b, d
    jr nz, jr_003_5b39

    ld b, d
    rra
    db $10
    ld b, l
    ld l, $71
    cp $43
    ld h, l
    ld d, a
    ld a, d
    ld a, [hl]
    ld b, l
    ld e, a
    ld b, l
    dec d
    ld [hl-], a
    ld b, d
    ld b, l
    inc hl
    cp $12
    inc de
    add hl, hl
    nop
    ld b, e
    ld h, l
    ld d, a
    ld a, d
    ld a, [hl]
    ld b, l
    ld e, a
    ld b, c
    cp $26
    inc a
    ld [de], a
    dec [hl]
    ld a, $17
    dec de
    inc hl
    jr nc, jr_003_5b68

    ld [de], a
    ld a, l
    cp $1c
    ld b, l
    add hl, de
    ld de, $2a00
    add hl, sp
    ld a, [de]
    add hl, hl
    cp $4e

jr_003_5b39:
    ld [hl], l
    ld b, l
    dec d
    nop
    rra
    add hl, hl
    dec de
    ld [hl-], a
    ld [hl], $45
    ld e, c
    ld a, l
    rst $38
    nop
    ld d, d
    db $76
    ld b, [hl]
    ld a, [hl]
    inc d
    ld [hl-], a
    ld b, l
    inc hl
    inc h
    ld [de], a
    ld a, l
    cp $4e
    ld [hl], l
    add hl, hl
    ld b, l
    ld l, $12
    jr jr_003_5b9d

    cp $1f
    add hl, hl
    dec de
    ld b, d
    ld b, l
    inc hl
    inc sp
    inc [hl]
    inc de
    rra
    dec d
    dec h

jr_003_5b68:
    ld a, a
    cp $2f
    rra
    ld c, [hl]
    ld [hl], l
    inc h
    nop
    db $10
    ld e, $42
    ld b, l
    inc hl
    jr z, jr_003_5bf4

    cp $45
    dec de
    ld a, [hl-]
    ld a, l
    rst $38
    rrca
    ld d, c
    ld a, [hl]
    ld b, l
    inc hl
    ld c, [hl]
    ld [hl], l
    ld b, c
    nop
    ld [de], a
    ld b, l
    add hl, de
    dec d
    dec de
    inc hl
    cp $40
    ld b, l
    ld l, c
    ld e, d
    ld a, h
    ld b, l
    inc hl
    nop
    ld b, l
    ld d, [hl]
    ld [hl], b
    ld a, h
    ld b, e
    ld h, a
    ld a, l
    rst $38

jr_003_5b9d:
    ld de, $1b45
    ld [hl-], a
    ld [hl+], a
    add hl, de
    rra
    jr nz, jr_003_5bd0

    nop
    inc l
    ld b, d
    ld b, l
    ld hl, $2318
    cp $39
    ld [hl+], a
    ld hl, $2018
    ld a, [hl-]
    inc de
    ld a, l
    rst $38
    dec l
    ld b, d
    dec de
    ld b, d
    ld e, b
    ld e, l
    ld e, a
    ld b, c
    nop
    inc h
    scf
    ld b, l
    ld a, [hl+]
    nop
    ld de, $4238
    dec h
    cp $4e
    ld [hl], l
    ld h, $00
    dec l
    ld b, d

jr_003_5bd0:
    dec de
    ld b, d
    inc e
    ld [hl], $18
    ld b, l
    inc h
    nop
    ld d, $2e
    ld b, d
    inc hl
    ld d, $fe
    dec h
    nop
    ld e, $12
    ld a, [de]
    ld a, [hl+]
    nop
    ld b, l
    rra
    ld de, $111f
    nop
    inc d
    dec h
    ld b, l
    dec de
    ld a, l
    rst $38
    nop
    nop
    nop

jr_003_5bf4:
    ld l, b
    ld sp, $1a1a
    ld b, l
    dec hl
    dec de
    ld b, d
    jr nz, jr_003_5c38

    ld b, d
    ld [hl], c
    cp $45
    ld d, [hl]
    ld [hl], b
    ld a, h
    ld b, e
    ld h, a
    dec de
    inc hl
    nop
    ld b, b
    ld b, l
    ld l, c
    ld e, d
    ld a, h
    ld b, c
    nop
    scf
    ld b, d
    ld b, l
    rra
    cp $1c
    scf
    ld b, l
    ld a, [hl+]
    nop
    ld e, $34
    ld b, c
    inc h
    ld b, l
    dec l
    ld [hl], $45
    ld e, c
    ld a, l
    rst $38
    nop
    nop
    nop
    ld l, b
    ld sp, $1a1a
    ld b, l
    dec hl
    dec de
    ld b, d
    jr nz, jr_003_5c6d

    ld b, d
    ld [hl], c
    cp $7b
    ld b, l

jr_003_5c38:
    ld l, c
    ld e, d
    ld a, h
    ld b, l
    inc hl
    nop
    add hl, de
    add hl, hl
    ld a, [hl+]
    nop
    ld b, c
    nop
    dec h
    ld b, l
    jr jr_003_5c6b

    cp $19
    ld [de], a
    ld b, l
    jr @+$18

    ld b, l
    rra
    ld a, l
    rst $38
    nop
    nop
    nop
    ld l, b
    ld h, $3f
    inc h
    dec [hl]
    dec de
    ld b, d
    jr nz, @+$3c

    ld b, d
    ld [hl], c
    cp $11
    ld hl, $3d33
    dec [hl]
    nop
    rra
    dec d
    rla
    ld b, l

jr_003_5c6b:
    ld d, [hl]
    ld [hl], b

jr_003_5c6d:
    ld a, h
    ld b, e
    ld h, a
    ld b, l
    inc hl
    ld d, $36
    dec d
    inc [hl]
    cp $1f
    dec d
    ld de, $4500
    ld a, [hl+]
    dec de
    ld a, $26
    inc sp
    nop
    inc e
    ld b, l
    rla
    inc h
    ld b, l
    inc h
    rla
    ld b, l
    ld e, c
    ld a, l
    rst $38
    nop
    nop
    nop
    ld l, b
    ld h, $3f
    inc h
    dec [hl]
    dec de
    ld b, d
    jr nz, jr_003_5cd3

    ld b, d
    ld [hl], c
    cp $7b
    ld b, l
    ld l, c
    ld e, d
    ld a, h
    ld b, l
    inc hl
    nop
    rra
    cpl
    ld b, l
    add hl, de
    ld b, c
    nop
    add hl, de
    jr c, jr_003_5cf2

    dec d
    dec de
    inc hl
    cp $19
    ld [de], a
    ld b, l
    jr jr_003_5ccc

    ld b, l
    rra
    ld a, l
    rst $38
    nop
    nop
    nop
    ld l, b
    ld b, l
    add hl, de
    ld d, $45
    inc l
    dec [hl]
    dec de
    ld b, d
    jr nz, jr_003_5d02

    ld b, d
    ld [hl], c
    cp $1d

jr_003_5ccc:
    cpl
    rla
    inc hl
    nop
    inc h
    inc d
    scf

jr_003_5cd3:
    dec h
    ld de, $4500
    ld a, [hl+]
    dec de
    ld a, $33
    cp $19
    scf
    dec h
    inc [hl]
    nop
    ld b, l
    rra
    ld de, $1b45
    ld a, $12
    ld b, l
    inc l
    ld a, l
    rst $38
    nop
    nop
    nop
    ld l, b
    ld b, l
    add hl, de

jr_003_5cf2:
    ld d, $45
    inc l
    dec [hl]
    dec de
    ld b, d
    jr nz, jr_003_5d34

    ld b, d
    ld [hl], c
    cp $7b
    ld b, l
    ld l, c
    ld e, d
    ld a, h

jr_003_5d02:
    ld b, l
    inc hl
    nop
    dec de
    ld a, $22
    dec d
    rla
    ld b, c
    nop
    add hl, hl
    ld b, l
    ld a, [hl+]
    dec de
    inc hl
    cp $19
    ld [de], a
    ld b, l
    jr jr_003_5d2d

    ld b, l
    rra
    ld a, l
    rst $38
    ld c, [hl]
    ld [hl], l
    add hl, hl
    ld [de], a
    ld b, l
    add hl, de
    dec d
    dec de
    dec d
    rra
    nop
    ccf
    dec d
    ld [hl+], a
    rra
    dec d
    dec h
    ld a, a

jr_003_5d2d:
    cp $1e
    scf
    ld b, l
    inc hl
    ld a, [hl+]
    nop

jr_003_5d34:
    ld c, [hl]
    ld [hl], l
    add hl, hl
    nop
    ld b, l
    ld l, $12
    jr jr_003_5d7f

    add hl, hl
    cp $2a
    ld b, l
    dec de
    cpl
    dec [hl]
    nop
    ld a, [hl+]
    ld b, l
    dec de
    cpl
    dec [hl]
    ld a, [hl]
    ld a, l
    rst $38
    ld d, d
    ld a, b
    ld [hl], e
    ld a, h
    dec de
    ld b, d
    jr nz, jr_003_5d8f

    ld b, d
    ld [$01fe], sp
    ld bc, $754e
    add hl, hl
    ld de, $451f
    inc e
    inc [hl]
    cp $fc
    ld bc, $4501
    rra
    ld de, $422d
    dec de
    ld b, d
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01

jr_003_5d7f:
    cp $01
    ld bc, $4501
    ld d, e
    ld a, h
    ld d, l
    ld d, d
    cp $01
    ld [de], a
    inc e
    ld de, $3d01

jr_003_5d8f:
    dec de
    inc h
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    ld b, e
    ld h, a
    ld a, c
    ld b, l
    ld e, [hl]
    ld [hl], d
    ld a, [hl]
    ld d, l
    ld a, [hl]
    cp $01
    ld a, [de]
    inc h
    ld [de], a
    ld bc, $3d21
    dec de
    cp $01
    cp $01
    cp $01
    cp $57
    ld b, e
    dec l
    ld d, [hl]
    ld [hl], b
    ld [hl], a
    ld bc, $7c55
    ld d, d
    ld d, a
    cp $01
    add hl, sp
    inc e
    dec d
    ccf
    ld bc, $181f
    dec de
    cp $01
    ld de, $451e
    dec d
    ld de, $1f01
    jr jr_003_5de8

    cp $01
    cpl
    inc de
    ld a, [hl+]
    rra
    ld bc, $451f
    rra
    rra
    dec d
    cp $01
    ld bc, $3410
    ld de, $2f01

jr_003_5de8:
    ld a, [de]
    dec sp
    ld d, $fe
    ld bc, $01fe
    cp $01
    cp $01
    cp $fc
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    ld d, h
    ld a, [hl]
    ld b, l
    ld e, [hl]
    ld c, c
    ld h, e
    ld a, [hl]
    ld e, d
    ld a, [hl]
    cp $01
    ld bc, $301b
    jr nz, @+$40

    ld b, d
    cp $01
    cp $01
    cp $fc
    ld bc, $01fe
    ld bc, $6743
    ld a, c
    ld b, l
    ld d, d
    ld [hl], l
    ld l, d
    ld a, [hl]
    cp $01
    ld bc, $2a01
    ld [de], a
    db $10
    ld b, d
    cp $01
    ld bc, $3d01
    dec de
    inc l

jr_003_5e30:
    jr nc, jr_003_5e30

    ld bc, $01fe
    cp $01
    cp $01
    ld bc, $5e45
    ld b, l
    ld d, l
    ld c, b
    ld h, b
    ld a, [hl]
    cp $01
    ld bc, $1501
    ld [hl+], a
    jr jr_003_5ec7

    cp $01
    cp $01
    cp $01
    cp $01
    ld bc, $7c54
    ld b, e
    ld l, c
    ld a, [hl]
    ld b, l
    ld d, l
    ld a, [hl]
    cp $01
    ld b, l
    ld h, a
    ld a, [hl]
    ld c, b
    ld a, h
    ld b, l
    ld d, d
    ld bc, $6745
    ld a, [hl]
    cp $01
    ld bc, $3001
    ld b, l
    inc e
    rra
    ld h, $fe
    ld bc, $01fe
    cp $01
    cp $5e
    ld d, a
    ld e, a
    ld bc, $6743
    ld a, b
    ld c, b
    ld l, a
    ld a, [hl]
    ld b, l
    ld d, a
    cp $01
    ld bc, $614e
    ld d, c
    ld d, a
    cp $01
    ld bc, $5d4c
    ld b, l
    ld d, d
    ld l, l
    ld a, h
    cp $01
    ld bc, $4501
    ld a, [hl+]
    ld b, l
    dec de
    cp $01
    cp $01
    cp $01
    cp $fc
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    ld b, e
    ld h, a
    ld a, b
    ld b, l
    ld e, b
    ld a, h
    ld e, h
    ld bc, $6545
    ld c, b
    cp $01
    ld bc, $4501
    ld h, l
    ld a, h
    ld b, l
    ld e, d
    ld c, b
    cp $01
    cp $01

jr_003_5ec7:
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    ld bc, $1401
    dec de
    cpl
    ld de, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    rst $38

    db $fd, $58, $5d, $5f, $ff

    ld hl, $2145
    ld d, $39
    ld [hl], $7f
    rst $38
    ld c, [hl]
    ld [hl], l
    add hl, sp
    ld [hl], $45
    ld e, $fe
    ld d, $3e
    ld [de], a
    ld a, [hl+]
    add hl, sp
    ld [hl-], a
    inc h
    rla
    rst $38
    inc b
    rst $38

    db $05, $ff, $06, $ff, $07, $ff, $08, $ff

    add hl, bc
    rst $38
    ld a, [bc]
    rst $38
    dec bc
    rst $38
    inc c
    rst $38
    dec c
    rst $38
    push bc
    rst $38

    db $31, $1a, $1a, $45, $2b, $ff, $45, $19, $16, $45, $2c, $35, $ff, $26, $3f, $24
    db $35, $ff

    nop
    sbc b
    db $fd
    ld c, a

    db $a3, $98, $ff, $4f, $a3, $98, $1f, $50, $a3, $98, $3c, $50, $a3, $98, $5c, $50
    db $a3, $98, $7b, $50, $a3, $98, $96, $50, $a3, $98, $ad, $50, $a3, $98, $c8, $50
    db $44, $98, $d6, $50, $44, $98, $2f, $51, $44, $98, $81, $51, $a3, $98, $da, $51
    db $a6, $99, $f6, $51

    and [hl]
    sbc c
    add hl, de
    ld d, d
    and [hl]
    sbc b
    ld a, [hl-]
    ld d, d

    db $28, $9a, $62, $52, $28, $9a, $68, $52, $28, $9a, $6b, $52, $28, $9a, $6e, $52
    db $48, $99, $71, $52, $84, $98, $77, $52, $84, $98, $85, $52, $84, $98, $95, $52
    db $84, $98, $a4, $52

    inc l
    sbc d
    or e
    ld d, d
    rst $20
    sbc b
    cp l
    ld d, d
    rst $20
    sbc b
    push bc
    ld d, d

    db $83, $98, $cd, $52, $83, $98, $17, $53, $83, $98, $71, $53, $83, $98, $bb, $53

    ld b, d
    sbc b
    ld a, [bc]
    ld d, h
    ld b, d
    sbc b
    ld a, $54
    ld b, d
    sbc b
    add h
    ld d, h
    ld b, d
    sbc b
    or b
    ld d, h

    db $42, $98, $eb, $54, $42, $98, $07, $55, $42, $98, $21, $55, $42, $98, $26, $55
    db $42, $98, $3d, $55, $42, $98, $63, $55, $42, $98, $7f, $55, $42, $98, $99, $55
    db $42, $98, $a2, $55, $42, $98, $d4, $55, $42, $98, $f4, $55, $42, $98, $38, $56
    db $42, $98, $7b, $56, $42, $98, $aa, $56, $42, $98, $e2, $56, $47, $98, $ec, $56
    db $42, $98, $f3, $56, $42, $98, $19, $57, $42, $98, $2e, $57, $42, $98, $59, $57
    db $42, $98, $5f, $57, $42, $98, $85, $57, $42, $98, $ac, $57, $42, $98, $e1, $57

    ld b, d
    sbc b
    nop
    ld e, b

    db $42, $98, $1e, $58, $42, $98, $2f, $58, $42, $98, $50, $58, $42, $98, $6c, $58
    db $42, $98, $84, $58, $42, $98, $8d, $58, $42, $98, $9a, $58, $42, $98, $b9, $58
    db $42, $98, $dd, $58, $42, $98, $e2, $58, $42, $98, $01, $59, $42, $98, $22, $59
    db $42, $98, $42, $59, $42, $98, $59, $59

    ld b, d
    sbc b
    db $76
    ld e, c

    db $e8, $9b, $71, $52, $e6, $9b, $76, $59, $42, $9c, $80, $59, $46, $9c, $a1, $59
    db $46, $9c, $b1, $59, $45, $9c, $c3, $59, $45, $9c, $e4, $59, $46, $9c, $07, $5a
    db $47, $9c, $18, $5a, $47, $9c, $2d, $5a, $44, $9c, $3b, $5a, $45, $9c, $59, $5a
    db $46, $9c, $7a, $5a, $48, $9c, $8f, $5a, $44, $98, $a6, $5a

    ld b, h
    sbc b
    ld sp, hl
    ld e, d
    ld b, h
    sbc b
    ld b, [hl]
    ld e, e
    ld b, c
    sbc h
    ld a, l
    ld e, e
    ld b, c
    sbc h
    sbc l
    ld e, e
    ld b, c
    sbc h
    or a
    ld e, e
    ld b, c
    sbc h
    pop af
    ld e, e
    ld b, c
    sbc h
    ld h, $5c
    ld b, c
    sbc h
    ld d, d
    ld e, h
    ld b, c
    sbc h
    adc l
    ld e, h
    ld b, c
    sbc h
    cp d
    ld e, h
    ld b, c
    sbc h
    db $ec
    ld e, h
    ld b, c
    sbc h
    dec de
    ld e, l
    add hl, hl
    sbc e
    ld c, l
    ld e, l

    db $e6, $98, $ea, $5e

    and a
    sbc b
    rst $28
    ld e, [hl]
    adc b
    sbc c
    rst $30
    ld e, [hl]
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

    ldh a, [$71]
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

jr_003_65a1:
    ldh a, [$75]
    jr nz, @-$15

    db $fc
    ld [hl], a
    nop
    jp hl


    db $f4
    halt
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
    ldh a, [$f1]

jr_003_65be:
    ld a, b
    nop
    ldh a, [$f9]

jr_003_65c2:
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
    ldh a, [$f1]
    ld a, b
    nop
    ldh a, [$f9]
    ld a, c
    nop
    add sp, -$0c
    add c
    nop
    add sp, -$04
    add d
    nop
    ldh [$f1], a
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

    ldh a, [$7e]
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
    ldh a, [$f0]
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
    ldh a, [$f0]
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

jr_003_6783:
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

jr_003_6812:
    ld b, b
    jr nz, @-$7e

    add sp, -$07
    jr c, jr_003_6839

    add sp, $01
    scf
    jr nz, @-$0e

jr_003_681e:
    db $fc
    ld a, [hl-]
    jr nz, jr_003_6812

jr_003_6822:
    inc b
    add hl, sp
    jr nz, jr_003_681e

    db $fc

jr_003_6827:
    inc a
    jr nz, jr_003_6822

    inc b

jr_003_682b:
    dec sp
    jr nz, @-$7e

    add sp, -$07
    ld a, $20
    add sp, $01
    dec a
    jr nz, jr_003_6827

jr_003_6837:
    db $fc
    ccf

jr_003_6839:
    jr nz, jr_003_682b

jr_003_683b:
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
    ldh a, [$08]
    nop
    ld a, [c]
    ld hl, sp+$61
    nop
    ld a, [c]
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
    ld a, [c]
    ld hl, sp+$69
    nop
    ld a, [c]
    nop
    ld l, d
    nop
    or $f0
    ld h, [hl]
    nop
    ld a, [$6bf8]
    nop
    ld a, [$0600]
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
    ld a, [c]
    ld hl, sp+$69
    nop
    ld a, [c]
    nop
    ld l, d
    nop
    or $f0
    ld h, [hl]
    nop
    ld a, [$6bf8]
    nop
    ld a, [$0600]
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
    ld a, [c]
    ld hl, sp+$69
    nop
    ld a, [c]
    nop
    ld l, d
    nop
    or $f0
    ld h, [hl]
    nop
    ld a, [$6bf8]
    nop
    ld a, [$0600]
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

jr_003_6c98:
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

jr_003_6cd8:
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

jr_003_6d60:
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

jr_003_6d8c:
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

jr_003_6e6e:
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
    ldh a, [$f4]
    rrca
    jr nz, @-$0e

    db $fc
    ld c, $00
    ldh a, [rDIV]
    rrca
    nop
    ld hl, sp-$0c

jr_003_6e98:
    ld de, $f820
    db $fc
    stop
    ld hl, sp+$04

jr_003_6ea0:
    ld de, $8000
    ldh a, [$f4]
    inc de
    jr nz, jr_003_6e98

    db $fc
    ld [de], a
    nop
    ldh a, [rDIV]
    inc de
    nop
    ld hl, sp-$0c

jr_003_6eb1:
    dec d
    jr nz, @-$06

    db $fc
    inc d
    nop
    ld hl, sp+$04
    dec d
    nop
    add b
    ldh a, [$f4]
    ld d, $20
    ldh a, [$fc]

jr_003_6ec2:
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

jr_003_6ed4:
    add b

jr_003_6ed5:
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

jr_003_6eeb:
    dec e

jr_003_6eec:
    jr nz, jr_003_6e6e

    db $ec

jr_003_6eef:
    ld hl, sp+$1a
    jr nz, @-$12

    nop
    add hl, de
    jr nz, jr_003_6eeb

    ld hl, sp+$20
    jr nz, jr_003_6eef

jr_003_6efb:
    nop
    rra
    jr nz, jr_003_6efb

jr_003_6eff:
    ld hl, sp+$22
    jr nz, jr_003_6eff

    nop

jr_003_6f04:
    ld hl, $8020
    db $ec

jr_003_6f08:
    ld hl, sp+$1a
    jr nz, @-$12

    nop
    add hl, de
    jr nz, jr_003_6f04

    ld hl, sp+$24
    jr nz, jr_003_6f08

jr_003_6f14:
    nop
    inc hl
    jr nz, jr_003_6f14

jr_003_6f18:
    ld hl, sp+$26
    jr nz, jr_003_6f18

    nop
    dec h
    jr nz, jr_003_6ea0

    ldh a, [$f8]
    jr z, @+$22

    ldh a, [rP1]
    daa
    jr nz, @-$06

    ld hl, sp+$2a
    jr nz, @-$06

    nop
    add hl, hl
    jr nz, jr_003_6eb1

    ldh a, [$f8]
    jr z, @+$22

    ldh a, [rP1]
    daa

jr_003_6f38:
    jr nz, @-$06

    ld hl, sp+$2c
    jr nz, @-$06

    nop
    dec hl
    jr nz, jr_003_6ec2

    pop af

jr_003_6f43:
    ld hl, sp+$28
    jr nz, jr_003_6f38

jr_003_6f47:
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
    ldh a, [$fc]
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
    ldh a, [$f4]
    ld [hl], b
    nop
    ldh a, [$fc]
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

    ldh [$f0], a
    nop
    nop
    ldh [$f8], a
    ld bc, $e000
    nop
    ld [bc], a
    nop
    ldh [$08], a
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
    ldh a, [$f3]
    ld a, a
    nop
    ldh a, [$fb]
    cp h
    nop
    ldh a, [$03]
    cp l
    nop
    ldh a, [$0b]
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

    ldh [$f5], a
    nop
    add b
    ldh [$fd], a
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
    ldh a, [$f1]
    rlca
    add b
    ldh a, [$f9]

jr_003_7dc8:
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


    ldh a, [$03]
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


    ldh a, [$03]
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
    ldh a, [$03]
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
    ldh a, [$03]
    add b
    db $e3
    ld hl, sp+$04
    add b
    db $e3
    nop

jr_003_7ea8:
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
    ldh a, [$28]
    add b
    di
    ld hl, sp+$29
    add b
    di
    nop
    ld a, [hl+]

Jump_003_7ec9:
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
    ld [c], a
    ldh a, [$03]
    add b
    ld [c], a
    ld hl, sp+$04
    add b
    ld [c], a
    nop
    dec b
    add b
    ld [c], a
    ld [$8006], sp
    ld [$24f0], a
    add b
    ld [$25f8], a
    add b
    ld [$2600], a
    add b
    ld [$2708], a
    add b
    ld a, [c]
    ldh a, [$28]
    add b
    ld a, [c]
    ld hl, sp+$29
    add b
    ld a, [c]
    nop
    cpl
    add b
    ld a, [c]
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
    ldh a, [$fc]
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
    ldh a, [$fc]
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
