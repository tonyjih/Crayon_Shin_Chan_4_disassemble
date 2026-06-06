; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

    db $06

    db $d8, $01, $40, $03, $1d, $1f, $3e, $3f, $7f, $77

    db $00

    ld a, a
    ld h, e
    ccf
    ld l, $5f
    ld [hl], c
    or $8f

    db $48

    rst $38
    cp $ff
    rra
    rst $30
    dec sp

    db $00

    rst $28
    ld sp, $1eff
    db $fd
    inc hl
    or a
    ld a, b

    db $50

    add b
    ldh [rSVBK], a
    ldh a, [hBonusCounter]
    db $f8

    db $80

    cp b
    db $fc
    inc e
    db $fc
    inc e
    xor $92

    db $48

    ld bc, $0302
    ld [bc], a
    inc bc
    ld [bc], a

    db $95

    inc bc
    ld bc, $0100

    db $00

    ld a, e
    adc e
    rst $38
    rrca
    or $0f
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    cp a
    call nz, $ff7f

    db $00

    rst $18
    ld e, b
    rst $38
    ld a, b
    or a
    ld a, b
    rst $38
    nop

    db $00

    cp $01
    ei
    rlca
    sbc $3f
    db $e4
    rst $28

    db $00

    rst $38
    ld bc, $01ff
    ld a, [$bc06]
    ld a, h

    db $40

    ret nz

    ld h, b
    ldh [rNR10], a
    ldh a, [rNR10]
    db $f0

    db $00

    add h
    db $fc
    add e
    rst $38
    add h
    rst $30
    xor b
    rst $38

    db $00

    ld h, h
    ld [hl], a
    ld c, b
    ld a, a
    ld b, e
    ld a, a
    inc a
    ccf

    db $00

    call z, $38c7
    ccf
    pop bc
    db $fd
    ld [bc], a
    rst $38

    db $00

    ld bc, $02fd
    rst $38

jr_006_4094::
    add a
    rst $38
    ld a, b
    rst $38

    db $00

    ld [jr_000_08f8], sp
    ld hl, sp+$08
    ld hl, sp+$08
    db $f8

    db $03

    jr nc, jr_006_4094

    jr nz, @-$1e

    jr nz, @-$1e

    db $77

    db $01
    nop

    db $ff, $84

    rst $38
    inc bc
    rst $38
    db $fd
    ld a, b
    ld c, b

    db $55

    ld a, b
    ld c, b
    ld a, b
    db $f8

    db $04

    ld bc, $01ff
    rst $38
    cp $3c
    inc h

    db $54

    inc a
    inc h
    inc a
    ld a, $fe

    db $48

    ld bc, $0302
    ld [bc], a
    inc bc
    ld [bc], a

    db $97

    inc bc
    db $01
    nop

    db $00

    rst $18
    ld e, b
    rst $38
    ld a, b
    or a
    ld a, b
    rst $38
    nop

    db $00

    cp $01
    ei
    rlca
    sbc $3f
    ldh a, [c]
    rst $30

    db $00

    rst $38
    ld bc, $01ff
    ld a, [$bc06]
    ld a, h

    db $40

    ret nz

    ld h, b
    ldh [rNR10], a
    ldh a, [$ff08]
    db $f8

    db $00

    call z, $39c7
    dec a
    jp nz, $01ff

    db $fd

    db $00

    ld [bc], a
    rst $38
    rlca
    rst $38

jr_006_4102::
    sbc b
    rst $38
    ld h, b
    rst $38

    db $00

    ld [jr_000_08f8], sp
    ld hl, sp+$08
    ld hl, sp+$08
    db $f8

    db $0c

    jr nc, jr_006_4102

    jr nz, @-$1e

    jr nz, @-$1e

    db $05

    nop
    rst $38
    inc bc
    rst $38
    db $fc
    ld e, b

    db $55

    add sp, $78
    jr @+$02

    db $11

    ld bc, $feff
    inc a
    inc h
    inc a

    db $51

    inc h
    inc a
    ld a, $fe
    nop

    db $40

    inc bc
    dec e
    rra
    ld a, $3f
    ld a, a
    ld [hl], a

    db $00

    ld a, a
    ld h, e
    ccf
    jr nz, @+$61

    ld h, b
    rst $38
    sbc a

    db $48

    rst $38
    cp $ff
    rra
    rst $30
    dec sp

    db $00

    rst $28
    ld sp, $00ff
    rst $38
    nop
    rst $38
    ccf

    db $50

    add b
    ldh [rSVBK], a
    ldh a, [hBonusCounter]
    db $f8

    db $80

    cp b
    db $fc
    inc e
    db $fc
    inc e
    or $ba

    db $00

    dec bc
    inc c
    rla
    jr @+$21

    db $10
    rra
    db $10

    db $00

    rla
    jr jr_006_417b

    ld [$7e7d], sp
    ld [hl], e
    ld e, a

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $01

jr_006_417b::
    rst $38

jr_006_417c::
    nop
    cp a
    ld [hl], b

jr_006_417f::
    sbc $71

jr_006_4181::
    rst $38

    db $80

    ld bc, $01ff
    rst $38
    ld bc, $03fd

    db $00

    or $0f
    ret c

    ccf
    ldh a, [rIE]
    jr nz, jr_006_4212

    db $00

    ld hl, sp+$48
    ld hl, sp-$38
    jr nc, @-$0e

    jr nz, jr_006_417c

    db $01

    jr nz, jr_006_417f

    jr nz, jr_006_4181

    ld b, b
    ret nz

    add b

    db $00

    ldh [rIE], a
    db $10
    rra
    ld [DetectSgbOrInitSgb], sp
    rlca

    db $03

    inc b
    rlca
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $00

    sbc c
    sbc b
    ld h, a
    rst $20
    ld e, b
    ld a, a
    add b
    rst $38

    db $00

    jr nz, jr_006_417f

    ld b, b
    rst $38
    ld [hl], b
    rst $38
    adc a
    rst $38

    db $00

    add d
    cp $02
    cp $22
    cp [hl]
    ld b, d
    db $fe

    db $00

    ld de, $21df
    rst $38
    pop hl
    rst $38
    rra
    rst $38

    db $4d

    ld bc, $0302
    nop

    db $ff, $84

    rst $38
    inc bc
    rst $38
    db $fd
    ld hl, sp-$78

    db $14

    ld [hl], h
    ld d, h
    inc l
    inc a
    ld a, b
    ld a, [hl]

    db $05

    dec c
    ei
    rla
    push af
    ldh [c], a
    inc [hl]

    db $5f

    jr c, @+$02

    db $00

    dec bc
    inc c
    rla
    jr jr_006_421b

    db $10
    rra
    db $10

    db $00

    rla
    jr jr_006_4212

    ld [$1e1d], sp
    inc hl
    ccf

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    db $fd
    inc bc

    db $00

jr_006_4212::
    rst $30
    rrca
    ret c

    ccf
    ldh a, [rIE]
    jr nz, jr_006_4299

    db $01

jr_006_421b::
    ld hl, sp+$08
    ld hl, sp+$38
    ldh a, [$ff50]
    db $f0

    db $00

    ld d, b
    ld [hl], b
    adc b
    ld hl, sp+$08
    ld hl, sp+$08
    db $f8

    db $00

    ret nz

    rst $38
    ld hl, sp-$41
    call nz, Call_000_04c7
    rlca

    db $03

    inc b
    rlca
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $00

    add e
    rst $38
    ld [bc], a
    cp $22
    cp [hl]
    ld b, d
    db $fe

    db $00

    ld de, $21df
    rst $38
    db $fd
    rst $38
    ccf
    rst $20

    db $5f

    ret nz

    nop

    db $ff, $84

    rst $38
    inc bc
    rst $38
    db $fd
    ld a, h
    ld b, h

    db $14

    ld a, [hl-]
    ld a, [hl+]
    ld d, $1c
    jr c, jr_006_429e

    db $05

    cpl
    db $eb
    ld b, l
    rst $00
    xor $70

    db $7f

    nop

    db $00

    dec bc
    inc c
    rla
    jr @+$21

    db $10
    rra
    db $10

    db $05

    rla
    jr jr_006_4284

    ld [$0d07], sp

    db $00

    ld c, b
    ld a, a
    ld c, b
    ld a, a
    inc [hl]
    scf
    inc b
    rlca

    db $03

    inc b
    rlca

jr_006_4284::
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $00

    add e
    rst $38
    ld [bc], a
    cp $22
    cp [hl]
    ld b, d
    db $fe

    db $00

    ld de, $21df
    rst $38
    db $e3
    rst $38
    rra

jr_006_4299::
    db $fe

    db $5f

    ret nz

    nop

    db $f4

jr_006_429e::
    add b
    ret nz

    ld b, b

    db $05

    inc bc
    cp $03
    rst $38
    db $fc
    nop

    db $ff, $15

    ldh [$ff60], a
    and b
    ldh a, [rP1]

    db $ff, $55

    rlca
    rra
    ccf
    ld a, a

    db $df

    rst $38

    db $c0

    cp $ff
    db $fd
    ei
    rst $38
    di

    db $00

    rst $38
    di
    rst $38
    ldh a, [rIE]
    ldh a, [$ffef]
    db $11

    db $54

    nop
    ldh [$fff0], a
    ld hl, sp-$48

    db $00

    ld hl, sp+$18
    ldh a, [rNR10]
    add sp, $18
    db $fc
    db $f4

    db $7d

    rst $38
    ld a, a

    db $40

    ccf
    ld c, $0f
    add hl, bc
    rrca
    db $10
    rra

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    add b
    rst $38
    db $f0

    db $00

    cp a
    ret nz

    rst $38
    nop
    sub $ef
    ccf
    ld sp, hl

    db $00

    ld a, [$fd06]
    inc bc
    rst $38
    ld bc, $01ff

    db $01

    db $fd
    inc bc
    xor [hl]
    ld [hl], d
    call nc, $f87c

    db $00

    ld b, b
    ld a, a
    ld b, b
    ld a, a
    add d
    rst $38
    add c
    rst $38

    db $00

    nop
    rst $38
    nop
    rst $38
    db $c3
    db $ff
    db $3c


    rst $38

    db $00

    add hl, sp
    ld sp, hl
    ld c, l
    db $fd
    inc de
    rst $38
    db $31
    rst $30

    db $00

    jp z, $12fe

    or $ec
    db $fc
    db $dc
    db $fc

    db $01

    ld bc, $01ff
    rst $38
    add b
    rst $38
    ld a, a

    db $7f

    nop

    db $04

    db $e4
    inc a
    ldh [c], a
    ld a, $fe
    cp h
    and h

    db $14

    db $fc
    db $f4
    inc l
    jr c, jr_006_435c

    db $fc

    db $77

    nop
    db $01

    db $ff, $5f

    db $fc
    rst $38

    db $ff, $75

    nop
    ret nz

    db $e0

    db $75

    ldh a, [$fff8]
    db $f4

    db $05

    rrca
    dec bc
    rrca
    dec bc
    rlca
    inc bc

    db $40

    add hl, sp
    inc a
    inc l

jr_006_435c::
    scf
    ccf
    db $10
    rra

    db $7f

    rst $38

    db $80

    ccf
    rst $10
    rst $28
    jr c, @+$01

    nop
    rst $38

    db $ff, $c0

    ld e, l
    cp [hl]
    db $e3
    rst $38
    nop
    rst $38

    db $05

    db $fc
    db $f4
    db $fc
    db $f4
    ld hl, sp-$10

    db $00

    rst $20
    daa
    rst $00
    push bc
    dec hl
    rst $28
    ld [de], a
    db $fe

    db $01

    db $10
    rra
    ld [DetectSgbOrInitSgb], sp
    rlca
    inc bc

    db $50

    ld bc, DelayFramesOrCycles
    rlca
    ld b, $07

    db $00

    nop
    rst $38
    nop
    rst $38
    add b
    rst $38
    nop
    rst $38

    db $00

    nop
    rst $38
    ldh [rIE], a
    jr @+$01

    rlca
    rst $38

    db $00

    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

    db $01

    nop
    rst $38
    ld bc, $01ff
    rst $38
    db $fe

    db $00

    ld [bc], a
    cp $02
    cp $44
    db $fc
    ld a, b
    db $f8

    db $5f

    add b
    nop

    db $05

    rrca
    add hl, bc
    dec d
    rla
    ld e, $3c

    db $7f

    nop

    db $85

    rst $38
    ldh a, [rIE]
    rrca
    nop

    db $ff, $0c

    ld [bc], a
    cp $01
    rst $38
    ld a, h

jr_006_43d6::
    ld b, h

    db $14

    cp b
    xor b
    ret nc

    ld [hl], b
    jr c, jr_006_43d6

    db $05

    rrca
    dec bc
    rrca
    dec bc
    rlca
    inc bc

    db $55

    ld bc, $0100
    add hl, de

    db $04

    db $fc
    db $f4
    db $fc
    db $f4
    rst $38
    rst $30
    push af

    db $00

    rst $28
    cpl
    ldh a, [c]
    cp $02
    cp $02
    db $fe

    db $00

    ld e, $17
    jr jr_006_441f

    ld [DetectSgbOrInitSgb], sp
    rlca

    db $c0

    inc e
    rra
    cp h
    and a
    sbc $d3

    db $00

    nop
    rst $38
    nop
    rst $38
    ld b, b
    rst $38
    ld b, b
    rst $38

    db $00

    add b
    rst $38
    ld h, b
    rst $38
    jr @+$01

    rlca
    rst $38

    db $00

    inc b

jr_006_441f::
    db $fc
    jr c, @-$06

    ld b, b
    ret nz

    ld b, b
    ret nz

    db $5f

    add b
    nop

    db $57

    ld a, l
    jr nc, @+$02

    db $ff, $7f

    rst $38

    db $f8

    cp $ff
    db $fe

    db $55

    nop
    ret nz

    ldh [$fff0], a

    db $e0

    ld d, b
    add sp, -$48
    db $fc
    and h

    db $77

    rst $38
    ld a, a

    db $40

    ccf
    inc e
    rra
    db $10
    rra
    jr nc, jr_006_4489

    db $7e

    rst $38
    db $fe

    db $00

    rst $38
    db $fd
    ld [bc], a
    rst $38
    nop
    rst $38
    nop
    rst $38

    db $00

    ld a, [$fd56]
    di
    rst $38
    and c
    rst $38
    pop hl

    db $00

jr_006_4460::
    dec a
    db $e3
    ld a, $e2
    inc [hl]
    db $ec
    jr c, jr_006_4460

    db $00

    inc b
    rlca
    inc b
    rlca
    inc b
    rlca
    db $08
    rrca

    db $40

    rra
    jr nz, @+$41

    jr nz, jr_006_44b6

    jr nz, jr_006_44b8

    db $00

    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

    db $00

    ld hl, sp-$01
    rlca
    rst $38
    nop
    rst $38

jr_006_4489::
    nop
    rst $38

    db $00

    inc c
    db $fc
    db $10
    ldh a, [rNR10]
    ldh a, [rNR10]
    db $f0

    db $30

    db $10
    ldh a, [$ff08]
    ld hl, sp+$04
    db $fc

    db $10

    jr nz, @+$41

    rra
    rlca
    inc b
    inc bc
    ld [bc], a

    db $75

    ld bc, $0003

    db $11

    rra
    rst $38
    ldh a, [$ffc0]
    ld b, b
    and b

    db $51

    ld h, b
    ret nz

    add b
    ldh a, [rP1]

    db $45

    db $fc

jr_006_44b6::
    ld a, [hl-]
    ld a, [hl+]

jr_006_44b8::
    ld [de], a
    db $1e

    db $5f

    rrca
    nop

    db $fd

    db $01

    db $50

    rlca
    rrca
    dec e
    rra
    ccf
    dec a

    db $70

    nop
    ld a, h
    ld a, [hl]
    rst $18
    db $e3

    db $00

    rst $38
    ldh a, [rIE]
    ldh a, [rIE]
    pop bc
    rst $38
    add d

    db $74

    nop
    add b
    db $fc
    ld a, h

    db $00

    ld a, [$fd06]
    inc bc
    rst $38
    ld bc, $01ff

    db $7f

    nop

    db $fd

    ccf

    db $01

    ld a, a
    ld a, l
    ld a, a
    ld a, h
    rst $38
    cp $ff

    db $c0

    db $fd
    cp $ff
    db $fc
    rst $38
    db $fe

    db $00

    rst $38
    add h
    rst $38
    ld [$00ff], sp
    rst $38
    nop

    db $00

    rst $38
    add b
    rst $38
    nop
    rst $38

jr_006_4505::
    jr nz, jr_006_4505

    db $21

    db $00

    push af
    rrca
    ld a, [$fc0e]
    inc c
    add sp, $18

    db $17

    or b
    ld [hl], b
    ret nz

    add b

    db $00

    ld b, h
    ld a, a
    add h
    rst $38
    add h
    rst $38
    add d
    rst $38

    db $00

    add d
    rst $38
    add c
    rst $38
    ld b, b
    ld a, a
    ld b, b
    ld a, a

    db $80

    rst $38
    ccf
    rst $38
    rrca
    rst $38
    rlca
    rst $38

    db $00

    add hl, sp
    rst $38
    pop bc
    rst $38
    inc bc
    rst $38
    inc c
    db $fc

    db $00

    ei
    rst $00
    ld l, a
    sbc [hl]
    di
    rst $38
    add d
    db $fe

    db $01

    ld b, h
    db $fc
    ld hl, sp+$38
    ldh [$ff60], a
    sbc h

    db $0c

    jr nz, jr_006_458c

    jr nz, jr_006_458e

    ld e, $12

    db $14

    dec d
    dec e
    dec bc
    rlca
    ld c, $0f

    db $57

    ldh a, [_HRAM]
    nop

    db $ff, $57

    ld a, b
    jr nc, @+$02

    db $ff, $fd

    db $01

    db $40

jr_006_4565::
    rlca
    rrca
    ld c, $1d
    ld e, $3f
    db $38

    db $75

    nop
    ld a, [hl]
    db $fe

    db $00

    ld a, l
    cp e
    rst $38
    jr nc, jr_006_4565

    ld sp, $02ff

    db $74

    nop
    add b
    ld a, h
    db $fc

    db $00

    ld a, [$fd06]
    inc bc
    rst $38
    ld bc, $01ff

    db $40

    ld a, a
    ld a, [hl]
    ld a, a
    rst $18

jr_006_458c::
    ld hl, sp-$21

jr_006_458e::
    db $f8

    db $00

    rst $18
    ld hl, sp-$01
    pop hl
    rst $38
    ldh a, [$fff7]
    db $f8

    db $00

    rst $38
    inc b
    rst $38
    nop
    rst $38
    jr nz, @+$01

    ld b, b

    db $00

    rst $38
    add b
    rst $38
    nop
    rst $38
    nop
    cp $01

    db $00

    rst $38
    dec e
    ldh a, [c]
    ld e, $fc
    inc c
    add sp, $18

    db $17

    or b
    ld [hl], b
    ret nz

    add b

    db $00

    ld e, a
    ldh [$ff7f], a
    ret nz

    dec a
    db $e3
    rra
    rst $38

    db $00

    add hl, sp
    rst $38
    pop bc
    rst $38
    inc bc
    rst $38
    inc c
    db $fc

    db $00

    ei
    rlca
    rst $28
    ld e, $f3
    rst $38
    add d
    db $fe

    db $01

    ld b, h
    db $fc
    ld hl, sp+$38
    ldh [$ff60], a
    sbc h

    db $01

    rra
    db $10
    rra
    db $10
    rrca
    db $08

jr_006_45e2::
    rlca

    db $50

    nop
    ld bc, $0302

jr_006_45e8::
    inc b
    rlca

    db $00

    rst $38
    nop
    rst $38
    inc e
    rst $38
    inc d
    rst $38
    cp h

    db $00

    rst $08
    ld hl, sp+$1f
    ldh a, [$ff1f]
    rst $38

jr_006_45fa::
    inc h
    db $fc

    db $00

    ret nc

    jr nc, jr_006_45e8

    jr jr_006_45fa

    ld [jr_000_08f8], sp

    db $01

    add sp, $18
    ldh a, [rNR10]
    and b
    ld h, b
    ret nz

    db $04

    ld [bc], a
    inc bc
    ld [bc], a
    inc bc
    rlca
    db $08
    rrca

    db $01

    ld [$080f], sp
    rrca
    inc b
    rlca
    inc bc

    db $00

    db $10
    rst $38
    nop
    cp $01
    rst $38
    add c
    db $fd

    db $00

    ld h, d
    rst $38
    ld e, $ff
    add hl, de
    rst $38
    inc a
    rst $20

    db $50

    adc c
    or $0c
    db $fc
    inc b
    db $fc

    db $04

    ld [$10f8], sp
    ldh a, [$ffe0]
    db $10
    db $f0

    db $10

    db $fc
    rst $30
    cpl
    scf
    inc [hl]
    rra
    db $1e

    db $59

    dec c
    rlca
    ccf
    nop

    db $37

    db $10
    ldh a, [_HRAM]

    db $75

    nop
    add b
    nop

    db $fd

    ld a, b

    db $00

    db $fc
    add h
    rst $30
    ei
    rrca
    inc c
    rla
    dec de

    db $7f

    nop

    db $40

    rst $38
    ld a, a
    add b
    rst $38
    nop
    rst $38
    nop

    db $d0

    inc e

jr_006_466a::
    ld l, $32
    halt
    ld c, [hl]

    db $00

    cp b
    ret c

    ld h, b
    ldh [$fff8], a
    jr jr_006_466a

    ld l, h

    db $00

    rra
    inc d
    ccf
    jr nz, @+$41

    inc h
    ccf
    db $20

    db $05

    cpl
    jr nc, jr_006_469f

    inc e
    rlca

jr_006_4686::
    nop

    db $00

    rst $38
    add b
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $04

    db $ed
    ld e, $ff
    nop
    rst $38
    ld a, a
    ld e, [hl]

    db $00

    db $fc
    sub h
    cp $02
    cp $12

jr_006_469f::
    cp $02

    db $05

    ld a, [$ec06]
    inc e
    ldh a, [_HRAM]

    db $00

    dec b
    ld b, $07
    inc b
    rst $00
    call nz, $aceb

    db $01

    cp a
    ret nc

    ld a, l
    ld d, d
    ld e, c
    ld l, a
    ccf

    db $00

    ld a, [$fe06]
    ld [bc], a
    cp $02
    db $fd
    inc bc

    db $01

    rst $38
    ld bc, $55fb
    db $dd
    ld [hl], a
    db $fe

    db $7d

    nop
    db $30

    db $00

jr_006_46ce::
    ld l, b
    ld e, b
    ld a, b
    ld c, b
    inc a
    inc h
    dec de
    rla

    db $74

    nop
    jr @+$2e

    inc [hl]

    db $00

    inc a
    inc h
    ld e, b
    ld l, b
    or b
    ret nc

    ld h, b
    db $e0

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    add b
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    db $ed
    ld e, $ff
    nop

    db $00

    ld hl, sp+$18
    db $f4
    ld l, h
    db $fc
    sub h
    cp $02

    db $00

    cp $12
    cp $02
    ld a, [$ec06]
    inc e

    db $40

    scf
    ld [hl], b
    ld d, b
    ld [hl], c
    ld d, c
    ld e, d
    ld l, e

    db $01

    dec l
    ld [hl], $1f
    inc e
    inc b
    rlca
    inc bc

    db $40

    rst $38
    ld a, a
    ld e, [hl]
    rst $38
    add b
    rst $38
    nop

    db $01

    rst $38
    nop
    cp a
    ld c, d
    dec sp
    xor $ff

    db $50

    ldh a, [_HRAM]
    ret nz

    ld b, b
    and b
    ld h, b

    db $09

    ret nc

    jr nc, jr_006_47a3

    sub b
    ldh a, [$ffe0]

    db $7f

    nop

    db $f4

    ld a, [hl]
    xor e
    add c

    db $73

    ld bc, $0203

    db $00

    dec b
    inc b
    ld b, $04
    dec c
    ld [$080a], sp

    db $00

    ld d, l
    ld bc, $01ab
    ld d, l
    ld bc, $01ab

    db $00

    ld d, l
    ld bc, $01ab
    ld d, l
    ld bc, $01ab

    db $5f

    add b
    ret nz

    db $ff, $00

    dec d
    db $10
    ld a, [de]
    db $10
    dec [hl]
    jr nz, jr_006_4792

    db $21

    db $00

    ld d, l
    ld b, c
    ld l, e
    ld b, c
    push de
    add b
    xor d
    add b

    db $00

    ld d, l
    ld bc, $01ab
    push de
    add c
    xor e
    add c

    db $00

    push de
    add c
    xor e
    add c
    ld d, l
    nop
    xor d
    nop

    db $7f

    ret nz

    db $f4

    ld h, b
    ldh a, [rSVBK]

    db $01

    push de
    add b
    xor d
    add b
    push de
    add b
    ld a, a

    db $57

jr_006_4792::
    ccf
    rra
    nop

    db $00

    ld d, l
    nop
    xor d
    nop
    ld d, l
    nop
    xor e
    add c

    db $00

    push de
    add c
    xor e
    add c

jr_006_47a3::
    push de
    add c
    xor e
    add c

    db $4d

    ld [hl], b
    ldh a, [rSVBK]
    db $f0

    db $df

    ret nz

    db $f5

    add b
    nop

    db $ff, $d5

    ld a, $63
    ld e, l

    db $55

    ld d, c
    ld e, l
    ld h, e
    db $3e

    db $7d

    nop
    db $01

    db $fd

    inc bc

    db $40

    ld hl, sp-$71
    rst $38
    add b
    rst $38
    nop
    rst $38

    db $00

    nop
    rst $38
    ld c, $ff
    rra
    rst $38
    rra
    rst $38

    db $50

    nop
    rst $08
    ccf
    ld hl, sp+$3f
    db $f8

    db $00

    rra
    ld hl, sp+$1f
    ld hl, sp+$1f
    ld hl, sp+$1f
    db $f8

    db $50

    nop
    add b
    ret nz

    ld b, b
    ldh [$ff60], a

    db $00

    ldh [$ff60], a
    ldh [$ff60], a
    ldh [$ff60], a
    ldh [$ff60], a

    db $50

    nop
    inc bc
    ld a, l
    ld a, h
    xor d
    add b

    db $01

    push de
    add b
    xor d
    add b
    ld d, a
    ld b, e
    ld a, a

    db $50

    nop
    ldh a, [$ff5c]
    inc c
    xor h
    inc b

    db $00

    ld d, a
    rlca
    xor e
    inc bc
    rst $10
    jp $e3eb


    db $74

    nop
    ld a, b
    sbc h
    db $fc

    db $00

    ld c, $fe
    rlca
    rst $38
    add e
    rst $38
    ld b, e
    ld a, a

    db $7f

    db $01

    db $f7

    add c

    db $42

    ret nz

    ld a, b
    cp b
    xor h
    ld e, h
    xor h

    db $aa

    ld e, h
    xor h
    ld e, h
    xor h

    db $40

    ret nz

    ld h, b
    ldh [_AUD3WAVERAM], a
    ldh a, [rSVBK]
    db $f0

    db $d5

    ldh [$ffc0], a
    nop

    db $40

    ld h, b
    ld a, h
    ld e, h
    ld a, [hl]
    ld b, [hl]
    ld a, [hl]
    ld b, [hl]

    db $00

    cp $86
    cp $8e
    db $fc
    adc h
    db $fc
    adc h

    db $40

    rlca
    ld b, $04
    dec b
    inc b
    ld b, $04

    db $00

    ld a, l
    ld a, h
    ld l, d
    ld b, b
    ld d, l
    ld b, b
    ld l, d
    ld b, b

    db $4c

    ret nz

    ldh [$ff60], a
    cp $7e

    db $01

    ld d, [hl]
    ld [bc], a
    xor e
    inc bc
    ld d, a
    inc bc
    rst $38

    db $7f

    nop

    db $f4

    di
    ei
    sbc d

    db $7f

    nop

    db $74

    ld bc, $e1c1
    ld h, c

    db $40

    ret nz

    cp b
    ld hl, sp-$74
    db $fc
    adc h

jr_006_487e::
    db $fc

    db $00

jr_006_4880::
    inc c
    db $fc
    inc e
    db $fc
    jr jr_006_487e

    jr jr_006_4880

    db $00

    ld [bc], a
    inc bc
    inc b
    rlca
    inc b
    rlca
    ld b, $07

    db $d7

    db $01
    nop

    db $00

    add hl, sp
    ld sp, hl
    ld sp, $71f1
    pop af
    ld h, d
    db $e3

    db $00

    ldh [c], a
    db $e3
    jp nz, Jump_000_04c3

    rlca
    inc b
    rlca

    db $00

    rra
    ld hl, sp+$1f
    ld hl, sp+$1f
    ld hl, sp+$3f
    db $f8

    db $00

    ccf
    ld hl, sp+$3f
    ld hl, sp+$7f
    ld hl, sp+$6f
    db $e8

    db $00

    ldh [$ff60], a
    ldh [$ff60], a
    ldh [$ff60], a
    ldh [c], a
    ld h, d

    db $00

    rst $20
    ld h, l
    rst $28
    ld l, b
    rst $38
    ld [hl], b
    rst $38
    ld h, b

    db $40

    ccf
    dec hl
    inc hl
    dec [hl]
    jr nz, @+$6c

    ld b, b

    db $00

    ld d, l
    ld b, b
    ei
    ld sp, hl
    rst $18
    ld e, a
    rst $20
    ld h, a

    db $00

    rst $30
    db $e3
    dec hl
    inc hl
    or a
    and e
    db $eb
    db $e3

    db $00

    rst $30
    db $e3
    db $eb

jr_006_48e8::
    db $e3
    or [hl]
    and e
    ld l, d
    ld b, e

    db $05

    daa
    ccf
    ld l, $3e
    inc e
    nop

    db $40

    ret nz

    jr nc, jr_006_48e8

    add hl, de
    ld sp, hl
    ld a, [de]
    ei

    db $7d

    db $01
    db $31

    db $00

    ld e, c
    ld a, c
    adc l
    db $fd
    rlca
    rst $38
    rrca
    rst $38

    db $2a

    xor h
    ld e, h
    xor h
    ld e, h
    xor h

    db $a0

    ld e, h
    xor h
    xor l
    ld e, l
    ld e, a
    xor [hl]

    db $7d

    db $01
    db $21

    db $00

    ld [hl], e
    ld d, d
    db $db
    cp d
    xor a
    ld e, [hl]
    ld d, a
    xor [hl]

    db $00

    db $fc
    inc e
    ld hl, sp+$18
    cp $1e
    rst $38
    inc hl

    db $00

    rst $38
    ld bc, $01ff
    rst $38
    ld bc, $11ff

    db $00

    dec a
    jr c, jr_006_4951

    jr jr_006_4946

    ld [$080a], sp

    db $00

    adc l
    adc b
    sbc d
    sub b
    sub l
    sub b
    ei
    pop af

    db $54

jr_006_4946::
    rst $38
    ret nz

    ld hl, sp-$52
    add [hl]

    db $00

    ld d, a
    inc bc
    xor e
    inc bc
    push af

jr_006_4951::
    pop hl
    ei
    pop af

    db $00

    ei
    sbc d
    rst $38
    adc [hl]
    ld a, a
    ld b, b
    ld a, a
    ld b, b

    db $00

    rst $38
    add b
    rst $38
    inc bc
    rst $38
    rlca
    rst $38
    daa

    db $00

    ldh [c], a
    ld h, e
    ldh [c], a
    ld h, e
    ldh a, [c]
    inc de

jr_006_496d::
    db $fa
    dec bc

    db $00

    db $fc
    rrca
    db $fc

jr_006_4973::
    adc a
    db $fc
    adc a
    ld hl, sp+$0f

    db $00

    jr c, jr_006_4973

    jr nc, jr_006_496d

    inc a
    db $fc
    ld b, [hl]
    db $fe

    db $00

    inc bc
    rst $38
    inc bc
    rst $38
    inc bc
    rst $38
    inc hl
    rst $38

    db $55

    ld a, a
    ccf
    rra
    nop

    db $ff, $00

    ld [$100f], sp
    rra
    ld de, $211f
    ccf

    db $05

    inc hl
    ccf
    scf
    ccf
    ld a, $1c

    db $00

    rst $28
    add sp, -$31
    ret z

    rst $08
    ret z

    adc a
    adc b

    db $05

    add a
    add h
    rlca
    inc b
    inc bc
    db $01

    db $00

    rst $38
    nop
    rst $38
    ld bc, $03ff
    rst $38
    rlca

    db $05

    cp $0e
    db $fc
    inc a
    ld hl, sp-$20

    db $40

    db $e3
    sbc $dc
    push af
    ldh [hPlayerState], a
    add b

    db $05

    push de
    add b
    xor a
    add a
    rst $38
    ld a, h

    db $00

    sub $c3
    xor $c7
    sub $87
    xor a
    add a

    db $05

    rst $10
    add a
    xor $e6
    cp $3c

    db $00

    inc e
    rst $38
    jr @+$01

    nop
    rst $38
    nop
    rst $38

    db $05

    ld bc, $83ff
    rst $38
    ld a, a
    ccf

    db $01

    rra
    rst $38
    dec a
    db $fd
    ld a, b
    ld hl, sp-$10

    db $55

    ldh [$ffc0], a
    add b
    nop

    db $0a

    and [hl]
    ld e, l
    ld d, l
    xor d
    push de
    xor d

    db $15

    ld l, e
    ld d, l
    ccf
    rrca
    nop

    db $00

    xor a
    ld e, h
    ld e, a

jr_006_4a0d::
    cp h
    cp a
    ld a, b
    ld a, a
    db $f8

    db $15

    rst $28
    db $ec
    rst $00
    inc bc
    nop

    db $00

    rst $38
    jr nc, @+$01

    jr nc, jr_006_4a0d

    ld l, b
    rst $28
    ld l, b

    db $15

    rst $20
    ld h, h
    rst $20
    db $c3
    nop

    db $00

    rst $38
    cp a
    rst $38
    rra
    ld hl, sp+$08
    ld hl, sp+$18

    db $15

    ld hl, sp+$38
    ldh a, [$ffe0]
    nop

    db $00

    sub l
    sub c
    dec de
    ld de, $2135
    dec hl
    inc hl

    db $05

    ld d, a
    ld b, e
    ld l, a
    ld h, a
    ld a, $1c

    db $00

    rst $38
    rst $20
    rst $38
    db $e3
    sbc a
    sub e
    sbc a
    sub e

    db $01

    rra
    ld de, $090f
    rrca
    dec bc
    rlca

    db $00

    ld hl, sp+$1f
    ld hl, sp-$01
    ld [hl], b
    ld a, a
    db $10
    rra

    db $15

    sbc b
    sbc a
    adc a
    add a
    add b

    db $00

    ld h, e
    rst $38
    ld h, c
    rst $38
    ret nc

    rst $18
    ret nc

    rst $18

    db $35

    ret z

    rst $08
    add a
    nop

    db $d7

    rlca
    inc bc

    db $7f

    db $01

    db $55

    nop
    ld l, [hl]
    ld e, e
    db $db

    db $7d

    sbc e
    adc [hl]

    db $55

    nop
    dec a
    ld l, l
    ld h, l

    db $55

    add hl, sp
    ld c, l
    ld l, l
    ld a, c

    db $57

    nop
    or a
    or e

    db $5d

    di
    or e
    or a

    db $57

    nop
    cp a
    inc c

    db $fd

    adc h

    db $57

    nop
    ld [hl], b
    ret c

    db $fd

    ld [hl], b

    db $5f

    nop
    db $36

    db $fd

    inc e

    db $55

    nop
    ld a, e
    db $db
    db $cb

    db $55

    ld [hl], e
    sbc e
    db $db
    pop af

    db $57

    nop
    ld l, a
    ld h, [hl]

    db $fd

    rst $08

    db $55

    nop
    dec c
    add hl, bc
    add hl, de

    db $55

    ld de, $2131
    ld h, c

    db $57

    nop
    db $fd
    adc l

    db $5d

    db $ed
    adc l
    add a

    db $55

    nop
    cp $98
    sbc c

    db $fd

    add hl, de

    db $55

    nop
    rst $20
    and [hl]
    or [hl]

    db $5d

    rst $30
    or [hl]
    or a

    db $55

    nop
    adc [hl]
    db $ca
    db $db

    db $5d

    sbc a
    db $db
    sbc e

    db $55

    nop
    dec a
    ld l, l
    ld h, l

    db $55

    add hl, sp
    ld c, l
    ld l, l
    ld a, c

    db $55

    nop
    or e
    or d
    or [hl]

    db $5f

    rst $30
    or [hl]

    db $5d

    nop
    add b
    ret nz

    db $ff, $7f

    nop

    db $77

    ld b, $00

    db $d5

    or d
    ld [hl-], a
    ld a, [hl-]

    db $dd

    ld [hl], $b2

    db $57

    nop
    ei
    pop bc

    db $5d

    pop af
    pop bc
    ei

    db $57

    nop
    ret nz

    add b

    db $75

    add [hl]
    add b
    ret nz

    db $57

    nop
    ld a, [hl]
    db $18

    db $ff, $5f

    nop
    ret c

    db $dd

    ld [hl], b
    db $20

    db $55

    nop
    ld [hl], c
    ld d, e
    db $db

    db $57

    ld sp, hl
    db $da
    db $db

    db $55

    nop
    rst $20
    ld h, l
    dec l

    db $5d

    rst $08
    ld l, l
    db $cd

    db $5d

    nop
    ld [hl], $b6

    db $5f

    cp [hl]
    or [hl]

    db $57

    nop
    ldh a, [$ff60]

    db $fd

    db $f0

    db $57

    nop
    rlca
    db $06

    db $5d

    rlca
    ld b, $07

    db $5d

    nop
    ld h, l
    ld [hl], l

    db $dd

    ld l, l
    ld h, l

    db $55

    nop
    db $e3
    or d
    or [hl]

    db $5d

    or a
    or [hl]
    db $e6

    db $55

    nop
    sbc [hl]
    adc h
    db $cc

    db $fd

    db $de

    db $5f

jr_006_4b5c::
    nop
    db $30

    db $fd

    db $3e

    db $57

    nop
    di
    ld h, [hl]

    db $fd

    di

    db $55

    nop
    sbc a
    ret c

    db $18

    db $55

    ld e, $18
    ret c

    sbc a

    db $55

    nop
    ld h, h

jr_006_4b73::
    ld h, l
    ld [hl], l

    db $5d

    ld [hl], h
    ld l, l
    ld h, l

    db $55

    nop
    rst $30
    or [hl]
    sub [hl]

    db $55

    rst $20
    ld [hl], $b6
    rst $20

    db $57

    nop
    sbc $1b

    db $5d

    sbc e
    dec de
    db $de

    db $57

    nop
    inc a
    db $36

    db $5d

    inc a
    ld [hl], $3c

    db $55

    nop
    db $ec
    ld l, b
    ld a, b

    db $7f

    db $30

    db $55

    nop
    set 1, c
    jp hl


    db $dd

    reti


    db $cb

    db $55

    nop
    reti


    sbc c
    sbc l

    db $dd

    sbc e
    reti


    db $57

    nop
    ei
    db $c3

    db $5d

    di
    db $c3
    ei

    db $55

    nop
    cpl
    dec l
    xor l

    db $dd

    ld l, l
    cpl

    db $57

    nop
    inc e
    or [hl]

    db $fd

    inc e

    db $00, $01, $7f, $00

    db $ff, $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $80

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

    db $00

    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

    db $ff, $ff, $55

    nop
    ld a, h
    add $ce

    db $55

jr_006_4bf0::
    sub $e6
    add $7c

    db $55

    nop
    jr jr_006_4c30

    db $18

    db $fd

    inc a

    db $57

    nop
    ld a, h
    db $c6

    db $55

Call_006_4c00::
    inc e
    ld [hl], b
    ret nz

    db $fe

    db $55

    nop
    ld a, h
    add $06

    db $55

    inc a
    ld b, $c6
    ld a, h

    db $55

jr_006_4c0f::
    nop
    inc c
    inc e
    inc l

    db $55

    ld c, h
    adc h
    cp $0c

    db $57

    nop
    cp $c0

    db $55

    db $fc
    ld b, $c6
    ld a, h

    db $55

    nop
    ld a, h
    add $c0

    db $5d

    db $fc
    add $7c

    db $55

    nop
    cp $0c
    db $18

    db $df

jr_006_4c30::
    db $30

    db $57

    nop
    ld a, h
    db $c6

    db $5d

    ld a, h
    add $7c

    db $57

    nop
    ld a, h
    db $c6

    db $55

    ld a, [hl]
    ld b, $c6
    ld a, h

    db $40

    ld c, $1f
    rla
    daa
    inc hl
    ld [hl], e
    ld b, c

    db $00

    xor e
    add d
    sbc a
    add h
    adc $48
    ld a, h
    db $30

    db $62

    inc a
    inc h
    rst $38
    rst $20
    sbc c

    db $83

    rst $20
    rst $38
    rst $20
    inc h
    inc a

    db $55

    nop
    jr nz, jr_006_4cd3

    inc h

    db $55

    inc a
    ld l, d
    or d
    db $d4

    db $75

    nop
    add b
    add h

    db $55

    add d
    and d
    ld b, b
    nop

    db $d5

    jr c, jr_006_4c79

    db $38

    db $55

    ld b, h

jr_006_4c78::
    inc b

jr_006_4c79::
    db $08
    db $30

    db $55

    nop
    ld b, b
    jr nc, jr_006_4c78

    db $55

    db $10
    jr nz, @+$52

    sbc h

    db $55

    nop
    inc h
    db $fa

jr_006_4c89::
    db $20

    db $5d

    ld a, h
    and d
    db $c4

    db $55

    nop
    jr z, jr_006_4cb6

    ldh a, [c]

    db $5d

    ld c, d
    ld c, b
    sub b

    db $55

    nop
    jr nz, jr_006_4d17

    db $10

    db $55

    ld a, [hl]
    inc b
    add b
    ld a, b

    db $55

    nop
    ld [$2010], sp

    db $55

    ld b, b
    jr nz, jr_006_4cba

    db $08

    db $55

    nop
    add h
    cp [hl]
    add h

    db $fd

    ld c, b

    db $55

    nop
    ld b, b
    inc a

jr_006_4cb6::
    db $08

    db $75

    add b
    ld b, b

jr_006_4cba::
    db $3e

    db $55

    nop
    jr nz, jr_006_4cd3

    ld a, b

    db $55

    inc b
    inc c
    ld b, b
    inc a

    db $5f

    nop
    ld b, b

    db $dd

    ld b, h
    db $38

    db $55

jr_006_4ccc::
    nop
    ld [$18fe], sp

    db $75

jr_006_4cd1::
    jr z, jr_006_4ceb

jr_006_4cd3::
    db $30

    db $55

    nop
    ld [$784e], sp

    db $55

    ret z

    ld c, b
    ld b, d
    inc a

    db $55

    nop
    inc b
    ld c, b
    ld d, [hl]

    db $55

    jr c, jr_006_4cb6

    db $10
    inc c

    db $55

    nop
    ld c, b

jr_006_4ceb::
    ldh a, [$ff4e]

    db $55

    ld d, h
    ld b, b
    sub d
    adc h

    db $55

    nop
    db $10
    cp $20

    db $55

    ld e, b
    db $e4
    inc b
    ld a, b

    db $75

    nop
    sbc h
    ld h, d

    db $55

    ld [bc], a
    inc b
    jr c, @+$02

    db $ff, $55

    ld c, h
    ld [hl-], a
    ld [bc], a
    inc e

    db $55

    nop
    ld a, [hl]
    db $08
    db $10

    db $f5

    db $08
    inc b

    db $55

    nop
    ld b, b
    ld b, h

jr_006_4d17::
    ld e, b

    db $5d

    ld h, b
    add b
    ld a, h

    db $55

    nop
    ld b, h
    db $f4
    ld b, d

    db $55

    ld b, h
    sbc h
    inc h
    ld a, [de]

    db $55

    nop
    ld b, b
    ld c, [hl]

jr_006_4d2a::
    sub h

    db $55

jr_006_4d2c::
    add b
    xor b
    db $ca
    ld b, [hl]

    db $55

    nop
    ld [$4abc], sp

    db $55

    pop de
    and l
    xor d
    ld c, l

    db $5d

    nop
    jr nz, jr_006_4d2c

    db $55

    ld [hl], c
    ld h, l
    xor d
    and l

    db $75

    nop
    jr c, @+$56

    db $75

    sub d
    and d
    ld b, h

    db $55

    nop
    ld b, h
    ld e, [hl]
    add h

    db $55

    and h
    call z, $5ad4

    db $55

    nop
    db $10
    ldh [rOBP0], a

    db $75

    adc b
    sub h
    ld h, b

    db $55

    nop
    ld a, b
    db $10
    db $20

    db $55

    inc d
    ld c, d
    adc d
    or d

    db $75

    nop
    jr nz, jr_006_4dbc

    db $55

    adc b
    inc b
    ld [bc], a
    nop

    db $d5

    ld e, [hl]
    ld b, h
    sbc [hl]

    db $55

    add h
    xor h
    db $d4
    ld c, d

    db $55

    nop
    ld h, b
    jr @+$72

    db $55

    jr jr_006_4df2

    sbc b
    ld h, h

    db $55

    nop
    ld b, b
    ld [hl-], a
    inc d

    db $55

    ld a, h
    sub [hl]
    and h
    ld c, b

    db $55

    nop
    inc h
    db $f4
    ld [hl+], a

    db $55

    ld h, b
    and h
    db $c4
    db $38

    db $55

    nop
    ld [$bc88], sp

    db $55

    ld d, d
    or d
    and d
    ld d, h

    db $55

    nop
    ld d, b
    jr c, @-$5e

    db $5d

    ld a, b
    ld [hl+], a
    inc e

    db $55

    nop
    db $10
    ld c, h
    ld b, b

    db $55

    cp b
    call nz, $3884

    db $55

    nop
    jr nz, jr_006_4e01

jr_006_4db9::
    ld b, h

    db $55

    ld h, h

jr_006_4dbc::
    ld b, h
    db $08
    db $10

    db $55

    nop
    ld a, h
    db $10
    inc a

    db $55

    ld b, d
    sbc d
    inc h
    db $18

    db $5d

    nop
    jr nz, jr_006_4db9

    db $55

    ld [hl], d
    ld h, h
    and h
    and d

    db $55

    nop
    ld a, b
    db $10
    db $20

    db $55

    ld a, b
    add h
    inc b
    db $38

    db $55

    nop
    jr nc, @-$72

    ld d, d

    db $55

    inc h
    ldh [rNR10], a
    db $08

    db $75

    nop
    db $10
    inc e

    db $55

    ld d, d
    inc h
    ld d, b

jr_006_4dee::
    db $08

    db $55

    nop
    adc b

jr_006_4df2::
    ld e, h
    ld l, d

    db $55

    ld c, d
    sbc h
    db $08
    db $10

    db $75

    nop
    db $08
    ld e, h

    db $55

    ld l, d
    ld c, d
    ld c, h

jr_006_4e01::
    db $10

    db $55

    nop
    jr nz, jr_006_4e1a

    db $18

    db $55

    db $10
    ld [hl], b
    sbc b
    ld h, h

    db $75

    nop
    db $10
    inc c

    db $55

    ld [$4838], sp
    inc [hl]

    db $5d

    nop
    jr nz, @-$12

    db $55

jr_006_4e1a::
    ld [hl], d
    ld h, d
    and d
    and h

    db $55

    nop
    jr c, jr_006_4e8e

jr_006_4e22::
    ld b, h

    db $57

    add $fe
    db $c6

    db $55

    nop
    inc h
    ld a, b
    ld [hl+], a

    db $55

jr_006_4e2d::
    ld a, h
    sub [hl]
    jr nz, jr_006_4e6f

    db $57

jr_006_4e32::
    nop
    db $10
    db $20

    db $75

    ld d, b
    sub d
    adc h

    db $7f

    nop

    db $5d

    ld [bc], a
    dec b
    ld [bc], a

    db $7d

    nop
    db $18

    db $df

    nop

    db $ff, $f7

    dec b

    db $55

    nop
    cp $02
    ld [de], a

    db $5d

    inc e
    db $10
    ld h, b

    db $75

    nop
    db $10
    db $38

    db $55

    inc d
    inc a
    ld e, d
    ld [hl], h

    db $5d

    nop
    inc b
    db $08

    db $57

    jr nc, @-$2e

    db $10

    db $77

    nop
    inc b

    db $57

    ld [$0434], sp

    db $55

    nop
    db $10
    cp $82

    db $75

    ld [bc], a

jr_006_4e6f::
    inc b
    db $38

    db $75

    nop
    db $08
    db $3e

    db $5d

Call_006_4e76::
    ld [hl+], a
    ld [bc], a
    inc e

    db $75

    nop
    db $fc
    db $10

    db $fd

    db $fe

    db $75

    nop
    jr nz, jr_006_4e93

    db $55

    ld a, b
    db $10
    jr z, jr_006_4ed4

    db $55

    nop
    ld [$18fe], sp

    db $d5

jr_006_4e8e::
    jr z, jr_006_4ed8

    adc b

    db $75

    nop

jr_006_4e93::
    inc b
    db $3e

    db $75

    inc c
    inc d
    inc h

    db $55

    nop
    db $10
    ld a, [hl]
    ld [de], a

    db $f5

    ld [hl+], a
    ld b, h

    db $55

    nop
    jr nz, jr_006_4edd

    db $e0

    db $55

    inc e
    ldh a, [rNR10]

jr_006_4eaa::
    db $08

    db $57

    nop
    ld a, h
    ld b, h

    db $5d

    add h
    db $08
    db $10

    db $55

    nop
    ld b, b
    ld a, [hl]
    ld c, b

    db $55

    adc b
    ld [$2010], sp

    db $75

    nop
    db $fc
    inc b

    db $f5

    db $fc
    nop

    db $d5

    inc h
    cp $24

    db $d5

    inc b
    db $08
    db $10

    db $55

    nop
    ld h, b
    ld [de], a
    db $c2

    db $55

    ld [hl+], a
    inc b

jr_006_4ed4::
    db $08
    ld [hl], b

    db $55

    nop

jr_006_4ed8::
    ld a, h
    inc b
    db $08

    db $55

    db $10

jr_006_4edd::
    jr z, jr_006_4f23

    add d

    db $55

    nop
    ld b, b
    cp $42

    db $5d

    ld b, h

jr_006_4ee7::
    ld b, b
    db $3e

    db $57

    nop
    add d
    ld b, d

    db $75

    inc b
    db $08
    db $30

    db $55

    nop
    ld a, $22
    ld [hl], d

    db $55

    adc h
    inc b
    jr jr_006_4f5b

    db $55

    nop
    inc b
    jr c, jr_006_4f08

    db $55

    cp $08
    db $10
    ld h, b

    db $55

    nop
    ld [hl+], a

jr_006_4f08::
    sub d
    ld d, d

    db $5d

    ld b, d
    inc b
    db $18

    db $7d

    nop
    ld a, [hl+]

    db $d5

    ld [bc], a
    inc b
    db $18

    db $55

    nop
    ld a, h
    nop
    db $fe

    db $75

    ld [$6010], sp

    db $5d

    nop
    ld b, b
    ld h, b

    db $57

jr_006_4f23::
    ld d, b
    ld c, b
    ld b, b

    db $55

    nop
    ld [$08fe], sp

    db $f5

    db $10
    ld h, b

    db $75

    nop
    db $fc
    nop

    db $fd

    db $fe

    db $55

    nop
    db $fc
    inc b
    ld h, h

    db $75

    jr @+$26

    db $c2

    db $55

    nop
    db $10
    ld a, h
    db $08

    db $55

    db $10
    inc [hl]
    db $d2
    db $10

    db $5d

    nop
    inc b
    db $08

    db $d5

    db $10
    ld h, b
    nop

    db $df

    db $28

    db $75

    ld b, h
    add d
    nop

    db $d5

    ld b, d
    ld c, h
    ld [hl], b

    db $7d

    ld b, b

jr_006_4f5b::
    db $3e

    db $57

    nop
    db $fc
    inc b

    db $f5

    db $08
    ld [hl], b

    db $57

    nop
    ld e, $10

    db $df

    nop

    db $d5

    db $10

jr_006_4f6b::
    cp $10

    db $77

    ld d, h
    sub d

    db $55

    nop
    cp $02
    inc b

    db $55

    jr z, jr_006_4f88

    db $08
    nop

    db $d5

    ld [hl], b
    db $08
    ld [hl], b

    db $55

    ld [$18e0], sp
    inc b

    db $5d

    nop
    db $10
    db $20

    db $55

jr_006_4f88::
    inc h
    ld b, h
    ld a, d
    db $c2

    db $55

    nop
    ld [bc], a
    ld h, d
    inc d

    db $55

    inc c
    ld [$c034], sp

    db $57

    nop
    db $fc
    db $20

    db $5d

    db $fc
    jr nz, @+$1e

    db $55

    nop
    ld b, b
    cp $22

    db $5f

    inc h
    db $10

    db $75

    nop
    jr nz, @+$80

    db $55

    ld [hl+], a
    inc d
    db $10
    db $08

    db $7f

    nop

    db $7d

    db $08
    ld a, b

    db $7d

    nop
    inc a

    db $7d

    inc b
    db $3e

    db $57

    nop
    ld a, h
    inc b

    db $5d

    ld a, h
    inc b
    ld a, h

    db $7d

    nop
    db $3e

    db $55

    ld [bc], a

jr_006_4fc7::
    ld a, $02
    db $3e

    db $55

    nop
    ld a, h
    nop
    db $fe

    db $55

    ld [bc], a
    inc b
    jr @+$62

    db $5f

    nop
    ld b, h

    db $d5

    inc b
    db $08
    db $30

    db $57

    nop

jr_006_4fdd::
    db $10
    ld d, b

    db $75

    ld d, d
    ld d, h
    sbc b

    db $5f

    nop
    ld b, b

    db $55

Call_006_4fe7::
    ld b, h
    ld c, b
    ld d, b
    ld h, b

    db $75

    nop
    db $fc
    add h

    db $f5

    db $fc
    add h

    db $57

    nop
    db $fc
    add h

    db $75

    inc b

jr_006_4ff8::
    db $08
    ld [hl], b

    db $57

    nop
    ld hl, sp-$3a

    db $5d

    db $fc
    add $fc

    db $55

    nop
    ret nz

    ld [hl-], a
    ld [bc], a

    db $d5

    inc b
    db $08
    db $f0

    db $77

    nop
    db $10

    db $f5

    nop
    db $10

    db $7f

    nop

    db $5f

    cp $00

    db $f5

    jr c, @+$46

    db $55

    ld [$0010], sp
    db $10

    db $ff, $12, $00, $84, $00, $90, $91, $92, $93, $94, $95, $96, $97, $98, $00, $9a
    db $9b, $9c, $9d, $9e, $9f, $00, $85, $86, $87, $a0, $a1, $a2, $a3, $a4, $a5, $a6
    db $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $00, $88, $89, $8a, $00, $b1, $b2
    db $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf, $99, $8b, $8c
    db $8d, $ff, $08, $00, $45, $00, $45, $ff, $07, $00, $b0, $8e, $00, $00, $7e, $4e
    db $75, $29, $11, $1f, $1c, $34, $1f, $11, $2d, $42, $1b, $42, $7e, $ff, $90, $00
    db $8f, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce
    db $cf, $d0, $ff, $04, $00, $d1, $c2, $c3, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9
    db $da, $ff, $06, $00, $8f, $db, $cd, $dc, $dd, $de, $00, $00, $05, $0d, $0d, $08
    db $ff, $09, $00, $df, $e0, $e1, $e2, $e3, $e4, $00, $e5, $e6, $00, $e7, $e8, $d5
    db $e9, $ea, $eb, $ff, $16, $00

    db $ee, $aa, $ee, $aa, $7c, $54, $7c, $54, $38, $28, $38, $28, $10, $10, $10, $10
    db $01, $ff, $01, $ff, $02, $7e, $04, $3c, $18, $18, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $a0, $e0, $a0, $e0, $a0, $e0, $a0, $e0, $a0, $e0, $a0, $e0, $a0, $e0, $a0
    db $07, $05, $07, $05, $07, $05, $07, $05, $07, $05, $07, $05, $07, $05, $07, $05
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $ff
    db $07, $05, $07, $05, $07, $05, $0f, $0d, $1f, $1b, $fe, $f2, $fc, $0c, $f8, $f8
    db $e0, $a0, $e0, $a0, $e0, $a0, $f0, $b0, $f8, $d8, $7f, $4f, $3f, $30, $1f, $1f
    db $f8, $f8, $fc, $0c, $fe, $f2, $1f, $1b, $0f, $0d, $07, $05, $07, $05, $07, $05
    db $1f, $1f, $3f, $30, $7f, $4f, $f8, $d8, $f0, $b0, $e0, $a0, $e0, $a0, $e0, $a0
    db $ff, $ff, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $05, $05, $05, $05
    db $ff, $ff, $ff, $00, $ff, $ff, $00, $00, $00, $00, $07, $02, $05, $05, $07, $02
    db $07, $04, $03, $03, $00, $00, $00, $00, $00, $00, $03, $03, $07, $04, $07, $05
    db $c0, $c0, $f0, $30, $fc, $cc, $3f, $33, $fc, $cc, $f0, $30, $c0, $c0, $00, $00
    db $c0, $00, $c2, $00, $63, $00, $73, $00, $bb, $00, $9e, $00, $ce, $00, $c0, $00
    db $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $07, $00, $06, $00, $00, $00
    db $c0, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0e, $00, $07, $00, $c0, $00, $e0, $00, $73, $00, $33, $00, $59, $00, $ed, $00
    db $6f, $00, $67, $00, $60, $00, $60, $00, $60, $00, $c0, $00, $c0, $00, $80, $00
    db $00, $00, $00, $00, $00, $00, $01, $00, $71, $00, $31, $00, $19, $00, $0d, $00
    db $db, $00, $fb, $00, $6f, $00, $66, $00, $b0, $00, $b0, $00, $80, $00, $80, $00
    db $cc, $00, $18, $00, $70, $00, $60, $00, $00, $00, $00, $00, $01, $00, $01, $00
    db $01, $00, $07, $00, $07, $00, $0f, $00, $0d, $00, $00, $00, $80, $00, $82, $00
    db $c3, $00, $87, $00, $3a, $00, $7c, $00, $ec, $00, $cc, $00, $d8, $00, $10, $00
    db $20, $00, $80, $00, $c0, $00, $60, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $00, $0e, $00, $87, $00
    db $30, $00, $30, $00, $1b, $00, $1f, $00, $8d, $00, $ec, $00, $f6, $00, $b6, $00
    db $07, $00, $40, $00, $60, $00, $60, $00, $e0, $00, $c0, $00, $00, $00, $00, $00
    db $0c, $00, $1e, $00, $1f, $00, $1b, $00, $19, $00, $18, $00, $1d, $00, $0f, $00
    db $00, $00, $00, $00, $00, $00, $b0, $00, $f0, $00, $e0, $00, $f0, $00, $b0, $00
    db $00, $00, $00, $00, $00, $00, $37, $00, $3f, $00, $1d, $00, $19, $00, $18, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $83, $83, $c7, $44, $c7, $45
    db $7e, $7e, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $ff
    db $7e, $7e, $7e, $7e, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $ff
    db $7e, $7e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $04, $0c, $04, $1c, $04, $3c, $24, $3c, $14, $1c, $0c, $0c, $00, $00
    db $00, $00, $00, $30, $00

jr_006_5309::
    db $38, $00

jr_006_530b::
    db $3c, $04, $3c, $08, $38, $30, $30, $00

jr_006_5313::
    db $00, $e0, $e0, $80, $80, $c0, $c0, $b1, $b1, $e9, $e9, $2b, $2b, $2d, $2d, $07
    db $07

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
    nop

    db $1c, $00, $54, $00, $0f, $1f, $3f, $37

    db $00

    ld a, a
    ld l, b
    ld a, a
    ld h, a
    ld a, [hl]
    ld l, c
    rst $18
    and c

    db $54

    nop
    ret nz

    ldh a, [$ff58]
    cp b

    db $00

    db $f4
    xor h
    db $fc
    inc e
    ld [$fdb6], a
    or e

    db $01

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca

    db $02

    rla
    jr jr_006_537d

    ld [de], a
    dec e
    ld e, $17

    db $01

    rst $38
    ld bc, $01ff
    cp $12
    db $fc

    db $02

    ld hl, sp+$08
    db $f4
    inc c
    db $f4
    inc c
    db $fc

    db $50

    rrca
    rlca
    inc bc
    ld [bc], a
    inc bc
    ld [bc], a

    db $5f

    inc bc

jr_006_537d::
    nop

    db $70

    ld hl, sp-$30
    ld [hl], b
    and b
    db $e0

    db $5f

    ldh a, [rP1]

    db $00

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    daa
    ccf

    db $01

    ld e, a
    ld h, b
    rst $28
    or b
    ei
    db $fc
    rrca

    db $01

    rst $38
    ld bc, $01ff
    xor $12
    db $fc

    db $01

    db $f4
    inc c
    ldh a, [c]
    ld c, $e7
    dec e
    rst $38

    db $41

    rrca
    inc b
    rlca
    dec bc
    rrca
    inc c

    db $7f

    nop

    db $41

    ld hl, sp-$50
    ret nc

    ld a, b
    ld e, b
    db $30

    db $7f

    nop

    db $01

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca

    db $01

    dec c
    dec bc
    rrca
    add hl, bc
    dec de
    ld d, $1f

    db $01

    rst $38
    ld bc, $01ff
    xor $12
    db $fc

    db $01

    add sp, $18
    ld hl, sp-$78
    add sp, -$68
    db $f0

    db $41

    rrca
    dec c
    dec bc
    ld e, $16
    inc e

    db $7f

    nop

    db $41

    ldh a, [$ffc8]
    ld hl, sp+$2c
    inc a
    db $38

    db $7f

    nop

    db $30, $00, $7f, $00

    db $d0

    inc bc
    dec b
    ld b, $0a
    rrca

    db $7f

    nop

    db $d0

    ldh [$ffd0], a
    jr nc, @-$56

    ld a, b

    db $00

    rrca
    dec c
    rrca
    ld [$1f1b], sp
    dec a
    db $36

    db $00

    ld a, a
    ld l, a
    ld a, a
    ld [hl], a
    ld a, [hl]
    ld a, l
    rst $38
    or l

    db $00

    ld hl, sp+$58
    ld hl, sp+$08
    add sp, -$08
    ret c

    db $38

    db $00

jr_006_541a::
    db $f4
    db $ec
    db $fc
    inc e
    ld [$fdb6], a
    or e

    db $00

    rst $28
    or h
    ld a, a
    ld h, h
    dec hl
    ld [hl], $1d
    inc de

    db $02

    rra
    db $10
    rla
    jr @+$0d

    inc c
    rrca

    db $00

    rst $38
    ld bc, $01ff

jr_006_5438::
    rst $38
    inc de
    db $fd
    rst $38

    db $02

    ld a, [$f40e]
    inc c
    db $f4
    inc c
    db $fc

    db $00

    rst $28
    or h
    ld a, a
    ld h, h
    dec hl
    ld [hl], $1d
    inc de

    db $01

    rra
    db $10
    rla
    jr @+$0d

    inc c
    rrca

    db $00

    rst $38
    ld bc, $01ff
    rst $38
    inc de
    db $fd
    rst $38

    db $01

    ld a, [$f40e]
    inc c
    db $f4
    inc c
    db $fc

    db $54

    nop
    ret nz

    ldh a, [$ff58]
    cp b

    db $00

    db $f4
    xor h
    db $fd
    dec e
    db $eb
    or a
    db $fd
    or e

    db $00

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    cpl
    scf

    db $00

    ld e, a
    ld h, b
    rst $38
    cp b
    db $eb
    db $ec
    inc c
    rrca

    db $00

    rst $38
    ld bc, $71af
    rst $18
    ld [hl], d
    db $fd
    rst $38

    db $00

    ld sp, hl
    rrca
    or $0e
    add sp, $18
    db $08
    db $f8

    db $f0

    ld e, b
    ld l, b
    jr c, jr_006_54c6

    db $5f

    inc a
    nop

    db $40

    ld a, h
    cp d
    add $55
    rst $28
    rst $38
    xor e

    db $01

    rst $38
    ld bc, $ff7d
    add d
    cp $fc

    db $42

    inc bc
    dec b
    ld b, $0a
    rrca
    dec c

    db $01

    rrca
    ld [$0f0b], sp
    inc b
    rlca
    inc bc

    db $55

    nop
    ldh [$fff8], a
    db $fc

    db $7c

jr_006_54c6::
    cp $ff
    db $fd

    db $00

    rst $38
    db $fd
    cp d
    ld a, [hl]
    call nc, $faec
    db $06

    db $00

    ld a, [$fa0e]
    ld c, $ec
    inc e
    db $08
    db $f8

    db $54

    nop
    ret nz

    ldh a, [$ff58]
    cp b

    db $00

    db $f4
    xor h
    db $fc
    inc e
    or $ae
    db $fd
    adc a

    db $00

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    daa
    scf

    db $02

    ld a, [hl+]
    jr nz, jr_006_552c

    jr z, jr_006_5533

    jr c, jr_006_552a

    db $01

    rst $38
    ld bc, $01ff
    cp $12
    db $fc

    db $02

    and d
    ld c, $52
    ld b, $ae
    ld c, $fa

    db $50

    nop
    rrca
    rra
    rla
    ccf
    db $38

    db $00

jr_006_5513::
    ld a, a
    ld h, a
    ld a, [hl]
    ld l, c
    ld a, a
    ld h, c
    ld a, a
    ld h, b

    db $50

    nop
    ret nz

    ldh a, [_AUD3WAVERAM]
    ld hl, sp-$58

    db $00

    db $fc
    inc e
    or $ae
    db $fd
    adc a
    rst $38

jr_006_552a::
    db $01

    db $00

jr_006_552c::
    rst $18
    and b
    rst $38
    add b
    ld a, e
    ld a, h
    daa

jr_006_5533::
    scf

    db $02

    ld a, [hl+]
    jr nz, jr_006_556d

Call_006_5538::
    jr z, @+$3c

    jr c, jr_006_556b

    db $01

    rst $38
    ld bc, $13fd
    ld a, [$fc06]

    db $02

    and d

Jump_006_5546::
    ld c, $52
    ld b, $ae

Call_006_554a::
    ld c, $fa

    db $50

    db $fc
    ld hl, sp+$58
    ld l, b
    jr c, jr_006_557b

    db $5f

    inc a
    nop

    db $56, $00, $76, $00, $3c, $24

    db $00

    ccf
    daa
    ccf
    jr nz, jr_006_55e1

    ld b, b
    ld a, a
    ld b, a

    db $50

    nop
    ld hl, sp-$04
    xor h
    db $fc

jr_006_556b::
    xor h

    db $40

jr_006_556d::
    db $fc
    cp $06
    cp $06
    cp $3e

    db $58

    nop
    rrca
    add hl, bc
    rrca
    add hl, bc

    db $00

jr_006_557b::
    rra
    inc de
    rra
    inc de
    ld e, $12
    ld a, $26

    db $61

    ld a, a
    ld b, b
    ld a, a
    ld b, b
    ld a, a

    db $5f

    ccf
    nop

    db $41

    cp $ff
    inc bc
    rst $38
    inc bc
    rst $38

    db $df

    nop

    db $f4

    cp $ff
    inc bc

    db $00

    rst $38
    inc bc
    rst $38
    di
    rst $38
    di
    rra
    inc de

    db $5d

    rst $38
    add b
    cp a

    db $f7

    add b

    db $40

    rst $38
    inc bc
    ld bc, $191b
    rst $38
    db $fd

    db $60

    rst $38
    db $fd
    dec de
    add hl, de
    inc bc
    db $01

    db $00

    add b
    rst $38
    sbc a
    rst $38
    cp a
    di
    cp a
    rst $28

    db $00

    cp a
    rst $28
    cp a
    rst $28
    cp a
    rst $28
    cp a
    rst $38

    db $00

    ld bc, $fbff
    db $fd
    rst $38
    db $fd
    rst $38
    db $fd

    db $00

    rst $38
    db $fd
    rst $38
    db $fd
    rst $38
    db $fd
    rst $38
    db $fd

    db $50

    ld bc, $4d7d
    ld b, l
    ld e, l

jr_006_55e1::
    ld d, l

    db $00

    ld e, l
    ld d, l
    ld e, l
    ld d, l
    ld e, l
    ld d, l
    ld e, l
    ld d, l

    db $50

    rst $38
    add b
    cp a
    add b
    cp a
    sbc a

    db $00

    cp a
    sbc a
    cp b
    sbc b
    cp e
    sbc b
    cp e
    sbc c

    db $40

    rst $38
    inc bc
    ld bc, $01fb
    ei
    ld sp, hl

    db $00

    ei
    ld sp, hl
    dec sp
    add hl, de
    cp e
    add hl, de
    cp e
    sbc c

    db $51

    rst $38
    nop
    rst $38
    nop
    rst $38

    db $d1

    nop
    rst $38
    nop
    rst $38

    db $00

    cp e
    sbc c
    cp e
    sbc c
    cp e
    sbc c
    cp e
    sbc c

    db $00

    cp e
    sbc c
    cp e
    sbc c
    cp e
    sbc c
    cp e
    sbc c

    db $50

    nop
    jr jr_006_5661

    inc l
    rst $20
    rst $38

    db $01

    pop bc
    cp a
    ld b, d
    ld a, [hl]
    ld e, d
    ld a, [hl]
    ld h, [hl]

    db $15

    rst $38
    adc a
    ld sp, hl
    ld [hl], c
    inc bc

    db $05

    rrca
    inc c
    rrca
    ld [$070f], sp

    db $00

    cp $3e
    ldh a, [_AUD3WAVERAM]
    ldh a, [_AUD3WAVERAM]
    ldh a, [_AUD3WAVERAM]

    db $15

    ldh a, [rSVBK]
    ldh [$ffc0], a
    add b

    db $00

    ld a, $26
    inc a
    inc h
    ld a, h
    ld c, h
    ld a, a
    ld c, a

    db $05

    ld a, a
    ld b, b
    ld a, a

jr_006_5661::
    ld b, b
    ld a, a
    ccf

    db $40

    ld a, b
    ld a, h
    ld c, h
    db $fc
    call z, Call_000_06fe

    db $05

    cp $06
    cp $66
    cp $9e

    db $76

    nop
    ccf
    db $20

    db $15

    ccf
    jr nz, jr_006_56ba

    rra
    nop

    db $00

    rra
    inc de
    rra
    inc de
    rst $38
    di
    rst $38
    inc bc

    db $1d

    rst $38
    inc bc
    rst $38
    nop

    db $55

    cp d

jr_006_568d::
    and d
    or c
    and d

    db $51

    cp d
    add b
    rst $38
    add b
    rst $38

    db $40

    xor a
    and a
    and l
    daa
    dec h
    and a
    and l

    db $01

    and a
    and l
    inc bc
    ld bc, $01ff
    rst $38

    db $05

    sbc a
    rst $38
    cp a
    ret nz

    rst $38
    sbc h

    db $00

    cp a
    sbc h
    cp a
    adc b
    cp a
    sbc h
    cp a
    add b

    db $25

    ei
    db $fd
    inc bc

jr_006_56ba::
    rst $38
    db $01

    db $00

    db $fd
    ld bc, $596d
    db $fd
    reti


    db $fd
    db $01

    db $00

    ld e, l
    ld d, l
    ld e, l
    ld d, l
    ld e, l
    ld d, l
    ld a, l
    ld b, l

    db $51

    ld a, l
    ld bc, $01ff
    rst $38

    db $55

    nop
    ld b, c
    ld b, h
    ld c, d

    db $55

    ld b, c
    ld d, b
    ld h, b
    nop

    db $d5

    ld [$28a8], sp

    db $55

    add hl, hl
    xor d
    inc c
    nop

    db $00

    cp e
    sbc c
    cp b
    sbc b
    cp a
    sbc b
    cp a
    sbc a

    db $11

    cp a
    sbc a
    add b
    rst $38
    add b
    rst $38

    db $00

    cp e
    sbc c
    dec sp
    add hl, de
    ei
    add hl, de
    ei
    ld sp, hl

    db $01

    ei
    ld sp, hl
    inc bc
    ld bc, $01ff
    rst $38

    db $55

    nop
    jr jr_006_5730

    rst $20

    db $55

    add c
    ld b, d
    ld e, d
    ld h, [hl]

    db $40

    rst $38
    add b
    rst $38
    add b
    rst $38
    add b
    rst $38

    db $03

    add b
    rst $38
    add b
    rst $38
    add b
    rst $38

    db $c0

    ld bc, $01ff
    rst $38
    db $01
    rst $38

    db $03

    ld bc, $01ff
    rst $38
    db $01
    rst $38

    db $77

jr_006_5730::
    nop
    db $01

    db $61

    ld a, a
    ld b, b
    ld a, a
    ld b, b
    ld a, a

    db $74

    nop
    ldh [$fff0], a
    db $30

    db $00

jr_006_573e::
    cp $3e
    rst $38
    inc bc
    rst $38
    inc bc
    rst $38
    ccf

    db $dc

    ld bc, $0607

    db $05

    rra
    jr @+$21

    ld de, $0f1f

    db $55

    nop
    ld h, [hl]
    db $eb
    ld l, e

    db $fd

    ld h, [hl]

    db $7f

    nop

    db $fd

    rst $38

    db $47

    nop
    ld a, d
    ld [hl], d
    ld c, d

    db $1c

    ld a, d
    ld [hl], d
    ld b, d
    ld b, e
    ld b, c

    db $45

    nop
    ld e, [hl]
    ld c, h
    ld d, d
    ld d, b

    db $54

    ld c, h
    ld b, d
    ld d, d
    sbc $8c

    db $5f

    nop
    sub b

    db $5f

    ldh a, [hSCY]

    db $05

    ld a, [hl]
    inc a
    jp $9942


    and l

    db $50

    cp l
    and l
    jp $7e42


    inc a

    db $00, $00, $ff, $10, $bf, $ff, $04, $00, $bf, $a0, $a1, $00, $00, $a2, $00, $b4
    db $a5, $00, $00, $c2, $c3, $00, $00, $bf, $ff, $04, $00, $bf, $b0, $b1, $a3, $a4
    db $b2, $b3, $b4, $b5, $a3, $a4, $c4, $b1, $a3, $a4, $bf, $ff, $04, $00, $ff, $10
    db $bf, $ff, $04, $00, $89, $ff, $0e, $82, $88, $ff, $04, $00, $83, $ff, $0e, $00
    db $84, $ff, $04, $00, $83, $ff, $0e, $00, $84, $ff, $04, $00, $83, $ff, $0e, $00
    db $84, $ff, $04, $00, $87, $ff, $0e, $85, $86, $ff, $18, $00, $ab, $ff, $03, $ad
    db $ac, $ab, $ff, $03, $ad, $ac, $ab, $ff, $03, $ad, $ac, $ff, $05, $00, $ae, $bb
    db $bc, $05, $ae, $ae, $bb, $bc, $05, $ae, $ae, $bb, $bc, $05, $ae, $ff, $05, $00
    db $bd, $ff, $03, $ad, $be, $bd, $ff, $03, $ad, $be, $bd, $ff, $03, $ad, $be, $ff
    db $06, $00, $a8, $a9, $aa, $00, $00, $a8, $a9, $aa, $00, $00, $a8, $a9, $aa, $ff
    db $07, $00, $b8, $b9, $ba, $00, $00, $b8, $b9, $ba, $00, $00, $b8, $b9, $ba, $00
    db $a6, $a7, $00, $ff, $03, $c6, $c0, $c1, $ff, $03, $c6, $c0, $c1, $ff, $03, $c6
    db $c0, $c1, $c6, $c6, $b6, $b7, $c6, $ff, $28, $00

    db $5e, $01, $40, $03, $04, $07, $08, $0f, $10, $1f

    db $00

    db $10
    rra
    daa
    ccf
    cpl
    jr c, jr_006_58a2

    db $30

    db $4c

    ldh [rNR41], a
    ldh [rNR10], a
    db $f0

    db $30

    ld [$ecf8], sp
    inc e
    db $f4
    inc c

    db $00

    ccf
    jr nz, @+$41

    jr nz, jr_006_58b6

    jr nz, @+$41

    db $20

    db $01

    ccf

jr_006_587c::
    jr nz, jr_006_58ad

    jr nc, jr_006_5897

    jr jr_006_5891

    db $7f

    inc bc

    db $ff, $50

    rrca
    rra
    ccf
    scf
    ld a, a
    ld l, b

    db $00

    ld a, a
    ld h, a
    ld a, a
    ld l, b

jr_006_5891::
    rst $18
    and c
    rst $38
    add c

    db $50

    ret nz

jr_006_5897::
    ldh a, [$ff58]
    cp b
    db $f4
    xor h

    db $00

    db $fc
    inc e
    ld a, [$5da6]

jr_006_58a2::
    or e
    rst $38
    or c

    db $00

    ld l, a
    ld [hl], b
    ld e, e
    ld a, h
    ld e, a
    ld h, a
    cpl

jr_006_58ad::
    db $30

    db $0b

    rla
    jr jr_006_58c1

    db $08
    rrca

    db $04

    rst $38

jr_006_58b6::
    ld bc, $12fe
    cp $fa
    db $06

    db $0b

    db $f4
    inc c
    ld hl, sp+$08

jr_006_58c1::
    db $f8

    db $41

    rrca
    dec c
    dec bc
    ld c, $0a
    inc c

    db $7f

    nop

    db $45

    ld hl, sp+$50
    ld [hl], b
    jr nc, @+$02

    db $ff, $05

    ret c

    add sp, $38
    jr z, @+$1a

    nop

    db $ff, $00

    ld l, a
    ld [hl], b
    dec de
    inc e
    ccf
    daa
    inc a
    cpl

    db $00

    add hl, hl
    ld a, $11
    ld e, $11
    ld e, $11
    db $1e

    db $04

    rst $38
    ld bc, $12fe
    cp $3e
    ldh [c], a

    db $00

    ld a, [hl-]
    or $1c
    db $fc
    ld c, b
    cp b
    ld c, b
    cp b

    db $00

    jr nz, jr_006_593f

    cpl
    ccf
    scf
    jr c, @+$31

    db $30

    db $01

    ccf

jr_006_5908::
    jr nz, jr_006_5939

    jr nc, jr_006_5923

    jr @+$11

    db $00

    ld b, h
    cp h
    db $f4
    cp h
    db $ec
    inc e
    db $f4
    inc c

    db $01

    db $fc
    inc b
    db $f4
    inc c
    add sp, $18
    db $f0

    db $00

    ld l, a
    ld [hl], b
    dec de

jr_006_5923::
    inc e
    cpl
    scf
    ccf
    db $20

    db $00

jr_006_5929::
    cpl
    jr nc, jr_006_594a

    inc de
    dec bc
    dec c
    rrca
    db $0e

    db $06

    rst $38
    ld bc, $12fe
    cp $02

    db $01

jr_006_5939::
    jp c, $fc26

    ld l, h
    ld hl, sp-$28

jr_006_593f::
    db $f8

    db $41

    rrca
    dec c
    dec bc
    rrca
    dec bc
    dec c

    db $7f

    db $01

    db $41

jr_006_594a::
    ld hl, sp-$28
    add sp, -$48
    xor b
    sbc b

    db $7f

    add b

    db $40

    rlca
    dec bc
    inc c
    rla
    jr @+$31

    db $30

    db $00

jr_006_595b::
    ld e, a

jr_006_595c::
    ld h, b
    cp a
    ret nz

    cp [hl]
    pop bc
    ldh [rIE], a

    db $40

    ldh a, [$ffe8]
    jr jr_006_595c

    inc c
    db $fc
    inc b

    db $00

    db $fc
    inc b
    db $fc
    inc b
    inc a
    call nz, Call_000_04fc

    db $05

    jr nz, jr_006_59b6

    db $10
    rra
    rrca
    nop

    db $ff, $05

    db $f4
    inc c
    ld [$f0f8], sp
    nop

    db $ff, $ff, $f4

    ld bc, $0706

    db $7f

    nop

    db $d0

    ccf
    rst $18
    pop hl
    rst $38
    db $01

    db $00

    dec de
    inc e
    cpl
    jr nc, @+$51

    ld [hl], b
    add a
    db $f8

    db $05

    add b
    rst $38
    ld [hl], b
    ld a, a
    rrca
    nop

    db $00

    rst $38
    ld bc, $01ff
    rst $38
    ld bc, $01ff

    db $03

    ccf
    pop bc
    ld bc, $01ff
    rst $38

    db $7f

    ld h, b

    db $7f

    db $30

    db $7c

jr_006_59b6::
    ccf
    ld a, a
    ld l, [hl]

    db $00

    ld a, a
    ld a, [hl]
    ld [hl], l
    ld l, [hl]
    ld a, a
    ld h, h
    ld a, e
    ld h, [hl]

    db $50

    ret nz

    ldh a, [$fff8]
    ld a, b
    db $f4
    adc h

    db $00

    db $fc
    inc [hl]
    ld a, [$fd4e]
    dec bc
    rst $38
    db $01

    db $00

    ld l, $33
    dec e
    inc de
    rla
    jr jr_006_59e9

    db $08

    db $01

    rrca
    ld [$080f], sp
    dec c
    ld c, $07

    db $00

    rst $38
    ld bc, $c2be
    ld a, h

jr_006_59e9::
    db $fc
    db $f4
    inc c

    db $01

    db $fc
    inc b
    db $fc
    inc b
    db $f4
    inc c
    db $f8

    db $45

    rst $38
    ld l, $3a
    ld e, $00

    db $ff, $40

    ccf
    jr nz, @+$41

    daa
    jr c, @+$15

    inc e

    db $00

    ld [DetectSgbOrInitSgb], sp
    rlca
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $50

    nop
    ldh [$ffdc], a
    inc a
    ei
    rlca

    db $00

    cp $01
    ld l, a
    sub b
    scf
    ret z

    dec sp
    db $c4

    db $75

    ld bc, $1f07

    db $55

    ld a, h
    ldh a, [$ffc0]
    add b

    db $15

    dec e
    ldh [c], a
    rst $38
    ret nz

    nop

    db $ff, $f4

    add b
    ret nz

    ld b, b

    db $01

    and b

jr_006_5a32::
    ld h, b
    ldh [rNR41], a
    ldh [rNR41], a
    db $e0

    db $54

    rrca
    rra
    ccf
    ld a, a
    ld a, [hl]

    db $00

    ld a, a
    ld a, [hl]
    ld a, l
    ld a, d
    ld a, a
    ld a, b
    ld a, e
    ld a, h

    db $50

    ret nz

    ldh a, [$fff8]
    ld a, b
    db $f4
    adc h

    db $00

    db $fc
    inc [hl]
    ei
    ld c, a
    db $fd
    dec bc
    rst $38
    db $06

    db $10

    ccf
    ld a, $1f
    dec b
    ld b, $0b
    inc c

    db $07

    rrca
    ld [$0c0b], sp
    rrca

    db $00

    ei
    dec e
    db $ed
    di
    ld a, [$fc06]
    inc b

    db $07

    db $f4
    inc c
    add sp, $18
    db $f8

    db $10

    ccf
    ld a, $1f
    rlca
    inc b
    rrca
    db $08

    db $2c

    dec e
    ld e, $1f
    cpl
    inc a

    db $00

    rst $38
    ld bc, $e2de
    db $fc
    inc a
    db $f4
    inc c

    db $04

    ld a, [$df06]
    dec a
    rst $20
    ld h, e
    db $e3

    db $5f

    rst $28
    nop

    db $ff, $ff, $f7

    rst $38

    db $7d

    nop
    ld a, [hl]

    db $01

jr_006_5a9e::
    adc a
    pop af
    add e
    db $fc
    ld a, a
    add b
    rst $38

    db $7f

    nop

    db $41

    ret nz

    and b
    ld h, b
    ret nc

    jr nc, jr_006_5a9e

    db $55

    rrca
    rra
    ccf
    ld a, a

    db $fe

    ld a, l

    db $54

    ret nz

    ldh a, [$fff8]
    db $fc
    db $f4

    db $00

    db $fc
    db $ec
    ld a, [$fdee]
    ld [hl], a
    xor a
    db $fd

    db $00

    scf
    dec sp
    rra
    inc de
    dec de
    rla
    rra
    db $11

    db $03

    rra
    ld de, $1917
    add hl, bc
    rrca

    db $00

    rst $38
    sub c
    cp [hl]
    jp z, $ccf4

    cp h
    db $c4

    db $03

    db $fc
    add h
    db $f4
    adc h
    adc b
    db $f8

    db $41

    rrca
    dec c
    dec bc
    rrca
    dec bc
    dec c

    db $7f

    db $01

    db $45

    ld hl, sp-$30
    ldh a, [hPlayerXSubpixel]
    add b

    db $ff, $4d

    rrca
    dec b
    rlca
    db $01

    db $ff, $05

    ret c

    add sp, -$48
    xor b
    sbc b
    add b

    db $ff, $04

    scf
    dec sp
    rra
    inc de
    rra
    rla
    db $18

    db $00

jr_006_5b0b::
    cpl
    jr nc, jr_006_5b4d

    jr nz, @+$31

    jr nc, jr_006_5b49

    db $38

    db $00

jr_006_5b14::
    rst $38
    sub c
    cp [hl]
    jp z, $fcf4

    db $ec
    inc e

    db $00

    db $fc
    inc b
    db $fc
    inc b
    db $f4
    inc c
    db $ec
    inc e

    db $00

jr_006_5b26::
    cpl
    ccf
    jr nz, jr_006_5b69

    ld de, jr_000_111e
    db $1e

    db $01

    ld de, $091e
    ld c, $0c

jr_006_5b34::
    rrca
    rlca

    db $00

    db $f4
    cp h
    ld b, h

jr_006_5b3a::
    cp h
    ld c, b
    cp b
    ld c, b
    cp b

    db $03

    jr jr_006_5b3a

    jr nc, jr_006_5b34

    jr nz, jr_006_5b26

    db $55

    rrca
    rra

jr_006_5b49::
    ccf
    ld a, a

    db $ff, $54

jr_006_5b4d::
    ret nz

    ldh a, [$fff8]
    db $fc
    db $f4

    db $00

    db $fc
    db $ec
    ld a, [$fdee]
    rst $30
    rst $28
    db $fd

    db $50

    ccf
    rra
    rla
    jr jr_006_5b80

    db $10

    db $0b

    rla
    jr @+$11

    db $08
    rrca

    db $00

jr_006_5b69::
    rst $38
    pop hl
    cp $fa
    db $f4
    inc c
    db $fc
    inc b

    db $0b

    db $f4
    inc c
    ld hl, sp+$08
    db $f8

    db $c1

    ld e, b
    ld l, b
    jr c, jr_006_5ba4

    db $18

    db $7f

    nop

    db $50

jr_006_5b80::
    ret nz

    ldh a, [$fff8]
    ld a, b
    db $f4
    adc h

    db $00

    db $fc
    inc b
    ld a, [$fd7e]
    inc bc
    rst $38
    db $01

    db $10

    ld a, $3f
    rrca
    rlca
    inc b
    rrca
    db $08

    db $01

    rrca
    ld [$080f], sp
    dec c
    ld c, $0f

    db $00

    rst $38
    ld bc, $c2be

jr_006_5ba4::
    ld a, h
    db $fc
    db $fa
    db $06

    db $01

    ld a, [$fc06]
    inc c
    ld hl, sp+$08
    db $f8

    db $45

    rrca
    ld [bc], a
    inc bc
    db $01
    nop

    db $ff, $41

    ld hl, sp-$20
    ld h, b
    ret nz

    ld b, b
    ret nz

    db $7f

    nop

    db $50

    rrca
    rra
    ccf
    scf
    ld a, a
    ld l, b

    db $00

    ld a, a
    ld h, b
    ld a, a
    ld l, a
    rst $18
    and b
    rst $38
    add b

    db $50

    ret nz

    ldh a, [$ff58]
    cp b
    db $f4
    xor h

    db $00

    db $fc
    inc b
    ld a, [$fdbe]
    inc bc
    rst $38
    db $01

    db $50

    rrca
    rra
    dec a
    ccf
    ld a, a
    ld a, l

    db $7f

    ld a, a

    db $80

    ld l, a
    rst $18
    cp a
    rst $38
    sbc a
    rst $18
    and b

    db $0b

    ld e, a
    ld h, b
    ccf
    jr nz, @+$41

    db $04

    rst $38
    pop hl
    cp [hl]
    jp nz, $f4fc

    inc c

    db $09

    db $ec
    inc d
    db $fc
    inc e
    db $f4
    db $f8

    db $00

    ld e, a
    ld a, a
    ld l, a
    ld e, a
    ld [hl], a
    ld c, a
    ld e, a
    ld h, b

    db $0b

    ccf
    jr nz, jr_006_5c52

    jr nz, jr_006_5c54

    db $50

    rrca
    rra
    dec a
    ccf
    ld a, a
    ld a, l

    db $7e

    ld a, a
    ld l, a

    db $41

    ccf
    ld d, $1a
    ld c, $0a
    rrca

    db $7f

    nop

    db $55

    inc bc
    rlca
    rrca
    rra

    db $55

    rrca
    rra
    rrca
    rra

    db $57

    ret nz

    ldh [$fff0], a

    db $00

    ld a, b
    ld hl, sp+$70
    ldh a, [$ff78]
    ld hl, sp+$70
    db $f0

    db $11

    ld [$070f], sp
    ld [bc], a
    inc bc

jr_006_5c45::
    db $01

    db $d5

    inc bc
    ld b, $0c

    db $11

    jr jr_006_5c45

    ldh [rLCDC], a
    ret nz

    add b

    db $d5

jr_006_5c52::
    ret nz

    ld h, b

jr_006_5c54::
    db $30

    db $75

    nop
    ccf
    ld a, a

    db $7d

    rst $38
    ld a, [hl+]

    db $54

    ld sp, $8e1b
    ld l, h
    db $ec

    db $05

    ld a, h
    db $fc
    ld a, b
    ret c

    ld hl, sp-$60

    db $75

    nop
    ccf
    ld a, a

    db $7d

    rst $38
    ld d, l

    db $54

    ld sp, $8e1b
    ld l, h
    db $ec

    db $05

    ld a, h
    db $fc
    ld a, b
    ret c

    ld hl, sp+$50

    db $5d

    nop
    ld b, d
    ld h, [hl]

    db $50

    inc h
    inc a
    inc h
    inc a
    inc h
    inc a

    db $04

    inc h
    inc a
    inc h
    inc a
    ld a, [hl]
    inc h
    inc a

    db $5d

    jr @+$26

    nop

    db $7f

    inc h

    db $f4

    inc a
    inc h
    inc a

    db $03

    inc h
    inc a
    ld h, [hl]
    ld a, [hl]
    inc h
    inc a

    db $17

    inc h
    inc a
    jr jr_006_5cca

    db $75

    nop
    jr nc, jr_006_5ce2

    db $41

    cpl
    dec hl
    cpl
    inc h
    daa
    ld h, e

    db $54

    inc c
    ld [de], a
    inc e
    ld a, [hl+]
    ld a, [hl-]

    db $01

    ret z

    ld hl, sp-$28
    ld hl, sp+$30
    ldh a, [$ffd8]

    db $7d

    nop
    rrca

    db $05

    dec bc
    rrca
    inc e
    rra
    ld [hl], e
    ret nz

    db $50

jr_006_5cca::
    add hl, bc

jr_006_5ccb::
    ld e, $29
    add hl, sp
    ret z

    db $f8

    db $05

    ret c

    ld hl, sp+$10
    ldh a, [$ffe0]
    ld b, b

    db $7f

    nop

    db $fd

    db $06

    db $7d

    nop
    db $08

    db $55

    inc b
    ld [bc], a
    dec de

jr_006_5ce2::
    rlca

    db $55

    inc bc
    rlca
    ld a, [bc]
    inc d

    db $5f

    inc b
    nop

    db $55

    ld c, $1b
    cpl
    dec hl

    db $d7

    jr z, @+$02

    db $5d

    inc e
    jr nz, @-$22

    db $5d

    ldh [$ffc0], a
    ld b, b

    db $40

    ld bc, $0302
    ld [bc], a

jr_006_5d00::
    inc bc
    dec c
    rrca

    db $00

    dec d
    rla

jr_006_5d06::
    add hl, bc
    rrca
    add hl, de
    rra

jr_006_5d0a::
    add hl, hl
    cpl

    db $5c

    nop
    add b
    ld b, b

Jump_006_5d10::
    ret nz

    db $00

    ld b, b
    ret nz

    jr nc, jr_006_5d06

    jr z, jr_006_5d00

    jr nc, jr_006_5d0a

    db $00

    add hl, de
    rra
    dec d
    rla
    dec [hl]
    scf
    ld [hl+], a
    inc hl

    db $41

    daa
    rlca
    dec b
    ld [bc], a
    inc bc
    db $01

    db $01

    jr z, @-$16

    ld b, b
    ret nz

    ld h, b
    ldh [hPlayerXSubpixel], a

    db $65

    ret nc

    ld d, b
    sub b
    nop

    db $fd

    rrca

    db $45

    ccf
    ld b, b
    ld a, a
    rst $38
    ld a, [bc]

    db $00

    ld a, h
    ld d, h
    jr z, jr_006_5d7c

    ld e, e
    ld a, e
    sub [hl]
    db $f6

    db $07

    ld a, $fe
    ld l, h
    db $ec
    and b

    db $7f

    nop

    db $fd

    ld a, h

    db $7d

    nop
    rrca

    db $05

    ld a, $3f

jr_006_5d58::
    ld b, b
    ld a, a
    rst $38
    dec d

    db $00

    ld a, h
    ld d, h
    jr z, @+$3a

    ld e, a
    ld a, a
    sbc h
    db $fc

    db $15

    jr nc, jr_006_5d58

    sbc $4f
    ld b, c

    db $74

    nop
    ld e, $3f
    inc sp

    db $00

    ccf
    ld hl, $293f
    ccf
    add hl, sp
    rra
    add hl, de

    db $00

    ccf
    inc sp

jr_006_5d7c::
    ccf
    daa
    dec a
    dec h
    ccf
    daa

    db $17

    ccf
    ld hl, $003f

    db $f4

    ld hl, sp-$04
    adc h

    db $00

    db $fc
    inc b
    db $fc
    ld h, h
    db $fc
    ld h, h
    db $fc
    ld h, h

    db $74

    nop
    ld e, $3f
    inc sp

    db $00

    ccf
    inc hl
    ccf
    inc hl
    ccf
    inc sp
    rra
    inc de

    db $00

    rra
    inc de
    rra
    inc de
    rra
    inc de
    ccf
    inc sp

    db $17

    ccf
    ld hl, $003f

    db $f6

    db $fc
    inc b

    db $00

    db $fc
    inc a
    ldh [rNR41], a
    ld hl, sp+$38
    db $fc
    inc c

    db $00

    db $fc
    db $e4
    db $fc
    db $e4
    db $fc
    inc h
    db $fc
    inc h

    db $17

    db $fc
    adc h
    ld hl, sp+$00

    db $f6

    rra
    db $10

    db $00

Jump_006_5dce::
    rra
    inc de
    ld e, $12
    rra
    inc de
    rra
    db $10

    db $76

    nop
    ldh a, [rNR10]

    db $54

Jump_006_5ddb::
    ldh a, [rP1]
    ldh [$fff0], a
    db $30

    db $54

    rra
    nop
    ld e, $1f
    inc de

    db $17

    rra
    jr @+$11

    nop

    db $00

    ldh a, [hSCY]
    ldh a, [hSCY]
    ldh a, [hSCY]
    ldh a, [hSCY]

    db $17

    ldh a, [_AUD3WAVERAM]
    ldh [rP1], a

    db $00

    rst $28
    ldh a, [$fffb]
    cp h
    ld d, a
    ld l, a
    cpl
    db $30

    db $0b

    rla
    jr jr_006_5e15

    db $08
    rrca

    db $04

    rst $38
    ld bc, $12fe
    db $fc

jr_006_5e0e::
    db $fa
    db $2e

    db $03

    or $1a
    db $ec
    inc e

jr_006_5e15::
    db $08
    db $f8

    db $c1

    ld l, b
    ld e, b
    jr c, jr_006_5e44

    inc a

    db $7f

    nop

    db $40

    rrca
    db $10
    rra
    ld [hl+], a
    ccf
    ld b, d
    ld a, a

    db $00

    ld c, a
    ld a, b
    ld a, a
    ld [hl], a
    rst $28
    sub b
    cp a
    ret nz

    db $40

    ldh a, [$ff0c]
    db $fc
    and d

jr_006_5e35::
    cp $ea
    cp [hl]

    db $00

    db $fc
    inc b
    db $fc
    cp h
    cp $a2
    cp $02

    db $00

    ld [hl], a
    ld a, b

jr_006_5e44::
    ld e, $1f
    dec l
    inc sp
    ld h, a
    ld a, b

    db $03

    ld a, e
    ld e, h
    ld l, e
    ld l, h
    db $08
    rrca

    db $04

    cp $02
    db $fc
    inc h
    db $fc
    or $0a

    db $01

    ld [$fc1e], a
    inc d
    inc e
    db $fc
    db $f8

    db $00

    ld [hl], a
    ld a, b
    ld e, $1f
    dec l
    inc sp
    ccf
    db $20

    db $03

    dec hl
    inc a
    rra

jr_006_5e6e::
    inc d
    inc c
    rrca

    db $04

    cp $02
    db $fc
    inc h
    db $fc
    ldh a, [c]
    db $0e

    db $0b

    or $0e
    ld hl, sp+$08
    db $f8

    db $55

    rst $38
    nop
    db $ea
    ld c, e

    db $7f

    ld c, d

    db $55

    rst $38
    nop
    ld l, $68

    db $5d

    xor [hl]
    jr z, jr_006_5ebd

    db $55

    rst $38
    nop
    ld h, h
    sub h

    db $75

    add h
    sub h
    ld h, a

    db $55

    rst $38
    nop
    inc a
    db $21

    db $5d

    dec a
    db $21
    cp l

    db $55

    rst $38
    nop
    adc $29

    db $d7

    xor $29

    db $55

    rst $38
    nop
    ld h, e
    sub h

    db $55

    ld h, h
    inc d
    sub h
    ld h, e

    db $55

    rst $38
    nop

jr_006_5eb6::
    add hl, de
    and l

    db $75

    dec h
    and l
    add hl, de

    db $55

jr_006_5ebd::
    rst $38
    nop
    rst $08
    db $28

    db $55

    cpl
    ret z

    jr z, jr_006_5ef5

    db $75

    inc b
    ld b, $c6

    db $41

    halt
    ccf
    add hl, hl
    rra
    db $11
    db $0e

    db $70

    ld b, d
    rst $20
    and l
    rst $20
    and l

    db $01

    rst $38
    cp l
    rst $38
    nop
    rst $38
    jr z, jr_006_5eb6

    db $75

    jr nz, jr_006_5f42

    ld h, e

    db $41

    ld l, [hl]
    db $fc
    sub h
    ld hl, sp-$78
    ld [hl], b

    db $54

    rlca
    ld bc, $7c19
    ld [hl], h

    db $01

    rrca
    dec bc
    rst $30
    db $f4

jr_006_5ef5::
    ld a, a
    ld l, c
    db $1e

    db $50

    ld [bc], a
    add d
    rst $00
    ld b, l
    rst $20
    and l

    db $01

    rst $38
    cp h
    rst $38
    nop
    rst $38
    jr z, @-$27

    db $54

    ldh [_HRAM], a
    sbc b
    ld a, $2e

    db $01

    ldh a, [$ffd0]
    rst $28
    cpl
    cp $96
    ld a, b

    db $40

    nop

jr_006_5f17::
    add b
    nop
    jr jr_006_5f1b

jr_006_5f1b::
    dec h
    nop

    db $03

    halt
    nop
    jr c, jr_006_5f22

jr_006_5f22::
    ld b, d
    nop

    db $0c

    ld bc, $2000
    nop
    ld [bc], a
    nop

    db $03

    stop
    ld b, b
    nop
    db $08
    nop

    db $cf

    ld [bc], a
    nop

    db $cf

    db $08
    nop

    db $5f

    rst $38
    nop

    db $ff, $5f

    rst $38
    nop

    db $f7

    dec b

    db $00

jr_006_5f42::
    ld [hl], a
    ld a, b
    ld c, $0f
    dec c
    dec bc
    ld c, $09

    db $01

    dec bc
    inc c
    inc de
    rra
    rla
    jr jr_006_5f61

    db $04

    cp $02
    db $fc
    inc h
    ld hl, sp-$18
    cp b

    db $01

    ld hl, sp+$68
    cp b
    ret z

    ld hl, sp+$18

jr_006_5f61::
    db $f0

    db $40

    rrca
    db $10
    rra
    jr nz, @+$41

    ld b, b
    ld a, a

    db $00

    ld b, b
    ld a, a
    ld b, b
    ld a, a
    ld b, b
    ld a, a
    ld b, b
    ld a, a

    db $40

    ldh a, [$ff0c]
    db $fc
    ld [bc], a
    cp $0e
    db $fe

    db $00

    inc e
    db $f4
    inc e
    db $f4
    ld a, $f6
    ld a, [hl+]
    db $fe

    db $30

    jr nz, @+$41

    daa
    jr c, jr_006_5fb1

    db $38

    db $0b

    rra
    jr jr_006_5f9e

    db $08
    rrca

    db $00

    ld e, [hl]
    ldh [c], a
    ld a, [$f4fe]

jr_006_5f97::
    inc c
    db $fa
    db $06

    db $03

    rst $20
    dec e
    rst $28

jr_006_5f9e::
    rra
    db $08
    db $f8

    db $10

    jr nz, jr_006_5fe3

    rra
    scf
    jr c, jr_006_5fd7

    db $30

    db $03

    ld a, a
    ld d, b
    ld a, e

jr_006_5fad::
    ld a, h
    db $08
    rrca

    db $10

jr_006_5fb1::
    ld e, [hl]
    ldh [c], a
    cp $f2
    ld c, $f2
    db $0e

    db $03

    db $fc
    inc c
    add sp, $18
    db $08
    db $f8

    db $50

    rrca
    rra
    ccf
    jr nc, jr_006_6044

    ld l, a

    db $00

    ld a, a
    ld h, b
    ld a, a
    ld l, a
    rst $18
    and b
    rst $38
    add b

    db $50

    ret nz

    ldh a, [$fff8]
    xor b
    ld a, h
    sbc h

    db $00

jr_006_5fd7::
    db $fc
    inc b
    ld a, [$fdbe]
    inc bc
    rst $38
    db $01

    db $00

    rst $28
    ldh a, [$fffb]

jr_006_5fe3::
    cp h
    ld [hl], a
    ld l, a
    cpl
    db $30

    db $05

    rra
    db $10
    dec c
    dec bc
    rlca

jr_006_5fee::
    inc bc

    db $00

    rst $38
    ld [hl], c
    adc [hl]
    ld a, [$fdff]
    ei
    rlca

    db $01

    rst $30
    ld l, l
    db $fd
    sbc e
    cp $de
    db $fc

    db $00

    ld l, a
    ld [hl], b
    dec sp
    inc a
    ld d, a
    ld l, a
    rst $18
    db $e0

    db $05

    or $b9
    ret


    rst $08
    rlca
    inc bc

    db $00

    rst $38
    ld bc, $13ff
    db $fd
    rst $38
    rst $30
    cpl

    db $01

    db $ec
    db $fc
    cp $32
    cp $fa
    rst $38

    db $54

    rlca
    rrca
    ccf
    ld [hl], a
    ld a, a

    db $80

    ld a, b
    ld c, a
    ld [hl], a
    rst $38
    sub b
    rst $38
    add b

    db $54

    ldh a, [$fffc]
    cp $fc
    inc e

    db $00

    db $fc
    and h
    db $fc
    inc e
    cp $a2
    cp $02

    db $55

    rlca
    rrca
    ccf
    ld a, a

    db $f0

jr_006_6044::
    jr nz, jr_006_6085

    jr nz, jr_006_6087

    db $57

    ldh a, [$fffc]
    db $fe

    db $00

    db $fc
    db $f4
    db $fc
    db $f4
    ld e, $f6
    ld a, [hl+]
    db $fe

    db $30

    db $10
    rra
    daa
    jr c, jr_006_6082

    db $38

    db $0b

    rra
    jr jr_006_606f

    db $08
    rrca

    db $10

    db $10
    rra
    rrca
    scf
    jr c, @+$31

    db $30

    db $03

    ld a, a
    ld d, b
    ld a, e

jr_006_606e::
    ld a, h

jr_006_606f::
    db $08
    rrca

    db $50

    ret nz

    ldh a, [$fff8]
    ld a, b
    db $f4
    adc h

    db $00

    db $fc
    inc b
    ld a, [$fd7e]
    inc bc
    rst $38
    db $01

    db $74

jr_006_6082::
    nop
    rlca
    inc bc

jr_006_6085::
    ld [bc], a

    db $97

jr_006_6087::
    inc bc
    db $01
    nop

    db $00

    ld a, l
    ld e, [hl]
    ccf
    inc hl
    sub a
    sbc b
    ei
    db $fc

    db $01

    rst $30
    ld a, b
    rst $38
    ld hl, sp-$04
    rst $38
    ld a, a

    db $00

    rst $38
    ld bc, $c2be
    db $fc
    ld a, h
    ldh a, [rNR10]

    db $05

    ret nc

    jr nc, @-$5e

    ld h, b
    ret nz

    nop

    db $05

    ld e, $12
    ld c, $0a
    rrca
    nop

    db $ff, $54

    rrca
    rra
    ccf
    ld a, a
    ld a, [hl]

    db $00

    ld a, a
    ld a, [hl]
    ld a, l
    ld a, d
    ld a, a
    ld a, b
    ld a, e
    ld l, h

    db $00

    dec a
    ld h, $1f
    inc de
    sub a
    sbc b
    ei
    db $fc

    db $01

    ld [hl], a
    ld a, b
    rst $38
    ld hl, sp-$04
    rst $38
    ld a, a

    db $05

    ld e, $12
    ld c, $0a
    rlca
    nop

    db $ff, $ff, $12, $00, $90, $ff, $08, $00, $90, $8e, $ff, $0c, $00, $8e, $ff, $09
    db $00, $88, $89, $8a, $ff, $20, $00, $90, $8f, $ff, $08, $00, $8e, $90, $00, $00
    db $90, $00, $88, $89, $8a, $ff, $0d, $00, $90, $ff, $0c, $00, $8e, $ff, $04, $00
    db $8f, $ff, $20, $00, $90, $ff, $0e, $00, $8f, $ff, $0a, $00, $88, $89, $8a, $00
    db $90, $90, $ff, $16, $00, $8e, $ff, $03, $00, $8f, $ff, $04, $00, $90, $ff, $12
    db $00, $8e, $ff, $18, $00, $8e, $90, $ff, $03, $00, $8f, $ff, $03, $00, $88, $89
    db $8a, $00, $00, $8f, $ff, $1d, $00, $ff, $0c, $91, $92, $ff, $07, $91, $ff, $06
    db $00, $57, $5a, $7e, $5f, $14, $1d, $2a, $7f, $ff, $06, $00

    db $78, $00, $55, $3e, $22, $2e, $28

    db $5f

    jr c, @+$02

    db $fd

    inc e

    db $55

    inc d
    ld [hl], h
    ld b, h
    ld a, h

    db $05

    inc b
    dec b
    inc b
    dec b
    inc bc
    nop

    db $ff, $01

    rst $38
    ldh a, [rIE]
    ldh a, [hTileStreamCount]
    db $cc
    rlca

    db $7f

    nop

    db $ff, $ff, $ff, $f4

    ld [hl], b
    adc h
    db $fc

    db $7f

    nop

    db $ff, $00

    ld a, a
    cp b
    sbc $2f
    rst $38
    ld bc, $807f

    db $00

    cp a
    ret nz

    ld [hl], a
    ld a, b
    dec bc
    inc c
    dec b
    db $06

    db $00

    ld b, d
    ld a, [hl]
    ld [hl+], a
    ld a, $19
    rra
    inc b
    rlca

    db $57

    inc bc
    db $01
    nop

    db $01

    ld a, [bc]
    dec c
    rlca
    dec b
    ld [bc], a
    inc bc
    rst $08

    db $00

    cp $3d
    db $fd
    ld a, $de
    rst $38
    cpl
    add hl, sp

    db $00

    rst $38
    ldh [$ff3f], a
    ldh [$ffdf], a
    ldh [rIE], a
    nop

    db $00

    cp a
    ret nz

    ld l, a
    ldh a, [$ffdd]
    ld a, $3b
    rst $20

    db $00

    xor $1f
    rst $38
    rra
    ei
    dec de
    rst $38
    rra

    db $00

    xor $1f
    rst $38
    nop
    rst $38
    nop
    cp a
    ret nz

    db $00

    rst $38
    cpl
    rst $38
    inc hl
    rst $38
    inc hl
    ei
    daa

    db $00

    rst $38
    rlca
    rst $38
    rrca
    db $fd
    inc bc
    rst $38
    db $01

    db $05

    sub b
    ldh a, [$ffa0]
    ldh [$ffc0], a
    add b

    db $7f

    nop

    db $00

    cp $02
    ld [$fc16], a
    db $f4
    ld e, h
    and h

    db $00

    ld a, h
    add h
    ld a, [$fb06]
    rlca
    ei
    rlca

    db $7f

    nop

    db $f5

    add b
    ret nz

    db $40

    inc bc
    rlca
    inc b
    ld c, $09
    inc c
    dec bc

    db $00

    ld [$080f], sp
    rrca
    inc b
    rlca
    ld [bc], a
    inc bc

    db $40

    add b
    ret nz

    ld b, b
    jr nz, @-$1e

    db $10
    db $f0

    db $00

    ld [$04f8], sp
    db $fc
    inc b
    db $fc
    ld [bc], a
    db $fe

    db $75

    nop
    rrca
    ccf

    db $d5

    rrca
    inc bc
    nop

    db $ff, $ff, $ff, $5c

    ld bc, $7d03
    ld a, [hl]

    db $00

    add e
    rst $38
    add c
    rst $38
    ld [hl], b
    ld a, a
    inc c
    rrca

    db $30

    cp $ff
    ld e, e
    cp a
    rst $38
    add hl, de

    db $40

    ldh [$ffd8], a
    jr c, @-$08

    adc [hl]
    ld a, l
    db $c3

    db $00

    ccf
    ldh [hStageIndex], a
    ldh a, [$ffcf]
    ld hl, sp-$35
    db $fc

    db $7f

    nop

    db $40

    add b
    ret nz

    ld b, b
    ret nz

    ld b, b
    ldh [rNR41], a

    db $7f

    nop

    db $f5

    ld b, $05

    db $10

    rra
    add hl, de
    rrca
    dec bc
    rrca
    ld b, $07

    db $00

    ccf
    ld a, $6e
    ld [hl], e
    rst $38
    sub c
    rst $18
    db $30

    db $00

jr_006_627d::
    rst $38
    ldh [rIE], a

jr_006_6280::
    ldh [rIE], a
    ldh [$ffef], a
    db $f0

    db $00

    rst $18
    jr nc, jr_006_6280

    jr @+$01

    rrca
    rst $18
    ld h, b

    db $00

    ld a, d
    db $fd
    rst $30
    rrca
    ld a, [$fd06]
    inc bc

    db $00

    rst $38
    ld bc, $41bf
    ld a, l
    add e
    cp $02

    db $05

    db $fd
    inc bc
    ld a, d
    add [hl]
    db $fc
    nop

    db $ff, $57

    inc bc
    nop
    rst $38

    db $fd

    nop

    db $11

    ld l, a
    sbc h
    rst $38
    ld [bc], a
    inc bc
    di

    db $55

    rst $38
    cp $e0
    nop

    db $41

    ret nz

    ld b, b

jr_006_62bd::
    ret nz

    ld b, b
    ret nz

jr_006_62c0::
    add b

    db $7f

    nop

    db $5f

    db $01
    nop

    db $ff, $00

    ld bc, $c0ff
    rst $38
    jr nz, jr_006_630d

    db $10
    rra

    db $05

    ld [DetectSgbOrInitSgb], sp
    rlca
    inc bc
    nop

    db $d0

    add b
    ld b, b
    ret nz

    jr nz, jr_006_62bd

    db $00

    jr nz, jr_006_62c0

    db $10
    ldh a, [$ff08]
    ld hl, sp-$7c
    db $fc

    db $40

    ld bc, $0203
    rlca
    inc b
    rlca
    inc b

    db $00

    dec bc
    inc c
    rrca
    ld [$080f], sp
    rrca
    db $08

    db $00

    cp l
    db $c3
    db $ff
    db $00


    rst $38
    nop
    ei
    rlca

    db $00

    rst $38
    rlca
    cp $06
    rst $38
    rlca
    ei
    rlca

    db $00

    rst $38
    ret c

    rst $38

jr_006_630d::
    jr nz, @+$01

    db $10
    cp a
    ret nc

    db $00

    rst $38
    ret nc

    rst $38
    ldh [rIE], a
    rst $00
    or a
    ret z

    db $00

    ld h, a
    db $fc
    rst $30
    inc a
    db $fd
    ld e, $fe
    ld a, a

    db $00

    rst $38
    ld a, a
    rst $38
    rrca
    rst $38
    adc a
    rst $38
    ld c, a

    db $00

    ldh [rNR41], a
    ldh a, [rNR10]
    ldh a, [rNR10]
    ldh a, [rNR10]

    db $00

    ldh a, [rNR10]
    ret nc

    jr nc, jr_006_638c

    or b
    sub b
    db $f0

    db $75

    nop
    db $01
    inc bc

    db $50

    rlca
    rrca
    dec c
    rrca
    rra
    inc e

    db $50

    rra
    ld a, a
    ei
    db $fc
    rst $38
    db $fc

    db $00

    rst $38
    adc $ff
    add [hl]
    rst $38
    add b
    rst $38
    db $1e

    db $18

    ret nz

    ldh [rIE], a
    rrca
    rst $38
    dec e

    db $00

    rst $38
    jr @+$01

    rlca
    rst $38
    ld [$10ff], sp

    db $75

    nop
    add b
    ret nz

    db $c0

    and b
    ld h, b
    ret c

    cp b
    db $f4
    ld c, h

    db $00

    rra
    inc e
    ccf
    ld a, h
    ld e, e
    ld h, h
    cp a
    ret nz

    db $00

    rst $38
    add b
    rst $38
    add b
    rst $38
    add b
    cp l
    db $c2

    db $00

    rst $38
    ld hl, $40ff

jr_006_638c::
    rst $30
    ld c, a
    rst $38
    rrca

    db $00

    db $fd
    dec c
    rst $38
    rrca
    rst $30
    rrca
    rst $38
    nop

    db $00

    rst $38
    db $10
    xor $9f
    ld a, a
    sbc a
    ei
    sbc e

    db $00

    rst $38
    sbc a
    xor $9f
    ld a, a
    add b
    rst $38
    nop

    db $00

    ld a, [$fe06]
    ld [bc], a
    rst $38
    ld bc, $01ff

    db $00

    rst $38
    ld bc, $01ff
    db $fd
    inc bc
    cp $02

    db $44

    ld a, b
    call z, $8284
    ld a, e
    ld a, c

    db $45

    rrca
    jr @+$12

    daa
    ld c, b

    db $7d

    nop
    db $fe

    db $1d

    inc bc
    ld bc, $8000

    db $7f

    nop

    db $45

    ldh [$ff38], a
    jr jr_006_63df

    db $01

    db $7f

    nop

    db $d0

    ld a, $e3

jr_006_63df::
    pop bc
    add c
    db $01

    db $1d

    ret nc

    sub b
    add b
    adc b

    db $10

    ret nz

    add b
    ld b, b
    jr nc, jr_006_640d

    sbc h
    sbc b

    db $7f

    nop

    db $f0

    ld [hl], b
    jr nz, jr_006_6411

    db $18

    db $55

    nop
    ld c, $11
    nop

    db $f5

    inc b
    nop

    db $15

    ld sp, hl
    pop af
    ld c, [hl]
    ld b, b
    and b

    db $d0

    jr nz, @+$6e

    inc l
    ld e, d
    ld d, d

    db $7f

    nop

    db $f4

jr_006_640d::
    inc bc
    dec b
    inc b

    db $7f

jr_006_6411::
    nop

    db $ff, $ff, $ff, $41

    rrca
    rst $38
    ld hl, sp+$0f
    ld sp, hl
    rst $38

    db $7f

    nop

    db $5e, $00, $75, $00, $07, $0f, $00, $1f, $18, $3f, $33, $3f, $30, $6f, $53, $75
    db $00, $e0, $f8, $00, $fc, $54, $ae, $de, $fe, $02, $ff, $dd, $00, $ff, $80, $6f
    db $70, $3b, $3c, $4f, $67, $00, $d5, $80, $9a, $b8, $7d, $68, $30, $3f

jr_006_644c::
    db $00, $ff, $01, $ff, $01, $d7, $39, $ee, $3a, $42, $fc, $a0, $60, $30, $70, $d0
    db $70, $1f, $0f, $09, $06, $05, $5f, $03, $00, $50, $f0, $e0, $40, $c0, $a0, $e0
    db $5f, $c0, $00, $d4, $0f, $1f, $3f

jr_006_6473::
    db $30, $00

jr_006_6475::
    db $7f, $67, $7f, $60, $7f, $6f, $df, $a0, $54, $00, $c0, $f0, $f8, $a8, $00, $5c
    db $bc, $fc, $04, $fa, $be, $fd

jr_006_648b::
    db $03, $01, $ff, $80, $6f, $70, $1b, $1c, $0f, $00, $17, $1a, $19, $13, $15, $19

jr_006_649b::
    db $0e, $0f, $01, $ff, $01, $af, $71, $de, $72, $ff, $00, $cf, $9d, $ab, $9f, $4e
    db $1e, $18, $f8, $70, $ff, $7a, $4e, $2a, $3e, $5f, $3f, $00, $01, $ff, $80, $6f
    db $70, $1b, $1d, $0e, $04, $15, $18, $1a, $11, $0f, $04, $07, $00, $ff, $01, $ff
    db $c1, $ff, $53, $fd, $ff, $02, $59, $cf, $a6, $8e, $54, $0c, $fc, $70, $ff, $7a
    db $4e, $74

jr_006_64dd::
    db $5c, $5f, $7e, $00, $ff, $fd, $e7, $7f, $00, $fd, $80, $7f, $ff, $c1, $a5, $66
    db $c3, $42, $c3, $45, $fc, $ec, $f4, $f8, $e0, $dd, $80, $c0, $7f

jr_006_64fa::
    db $00, $fd, $e7, $7f, $00, $f4, $38, $f8, $e8, $7f, $ff, $d7, $81, $00, $1f, $d8
    db $f8, $e0, $c1, $d8, $b8, $70, $50, $20, $7f, $00, $fd, $80, $7f, $ff, $c1, $ba
    db $d6, $7c, $54, $fe, $51, $c0, $f0, $f8, $e8, $f8, $5f, $c0, $00, $d4, $0f, $1f
    db $3f, $37, $00, $7f, $60, $7f, $67, $7e, $69, $df, $a1, $54, $00, $c0, $f0, $f8
    db $18, $00

jr_006_653c::
    db $f4, $ac, $fc, $1c, $ea, $b6, $fd, $b3, $01, $ff, $80, $6f, $70, $1b, $1c, $0f
    db $22, $15, $18, $12, $1d, $1e, $17, $01, $ff, $01, $ff, $01, $fe, $12, $fc, $02
    db $58, $08, $a4, $0c, $54, $0c

jr_006_6562::
    db $fc, $50, $0f, $07, $03, $02, $03, $02, $5f, $03, $00, $70, $f8, $d0, $70, $a0
    db $e0, $5f, $f0, $00, $00, $ff, $80, $6f, $70, $3b, $3c, $4f, $67, $01, $e5, $b0
    db $fa, $f8, $09, $0c, $0f, $00, $ff, $01, $af, $71, $df, $73, $ff, $fd, $01, $4b
    db $1f, $ba, $0e, $4c, $1c, $f8, $45, $0f, $12, $1e, $1c, $10, $7f, $00, $41, $f8
    db $68, $58, $3c, $2c, $10, $7f, $00, $01, $ff, $80, $6f, $70, $1b, $1c, $0f, $23
    db $15, $19, $13, $0e, $0f, $01, $ff, $01, $af, $71, $de, $72, $fc

jr_006_65bf::
    db $01, $c8, $58, $a8, $88, $48, $18, $f8, $41, $0f, $16, $1a, $1c, $14, $18, $7f
    db $00, $41, $f8, $24, $3c, $16, $1e, $18, $7f, $00, $ff, $54, $06, $05, $27, $6a
    db $6e, $7f, $00, $54, $06, $fa, $0e, $95, $97, $41, $a9, $98, $bc, $64, $76, $23
    db $41, $20, $27, $37, $14, $1c, $0c, $41, $09, $01, $03, $42, $66, $fc, $41, $18
    db $98, $b8, $b0, $f0, $60, $41, $a9, $a8, $ac, $54, $76, $23, $51, $20, $4f, $54
    db $5c, $78, $41, $09, $01, $03, $42, $66, $fc, $05

jr_006_6619::
    db $12, $1e, $ce, $ee, $38, $00, $10, $6a, $6e, $a9, $98, $bc, $64, $76, $45, $23
    db $46, $4f, $79, $00, $10, $95, $97, $09, $01, $03, $42, $66, $41, $fc, $28, $38
    db $98, $d8, $78

    db $3a, $00, $40, $0f, $17, $18, $3f, $20, $7f, $40, $00, $bb, $c7, $f7, $8f, $fe
    db $8e, $fc

jr_006_664e::
    db $8c, $40, $e0, $f0

jr_006_6652::
    db $30, $f8, $18, $fc, $0c

jr_006_6657::
    db $05, $7c, $8c, $bc, $cc, $fc, $7c, $40, $07, $0b, $0c, $0f, $08, $17, $18, $00
    db $1f, $10, $1f, $10, $2f, $33, $3f, $23, $48, $c0

jr_006_6671::
    db $60, $e0, $60, $b0, $70

jr_006_6676::
    db $00, $f0, $30, $f0, $30, $d8, $38, $f8, $18, $40, $1c, $3e, $26, $3e, $26, $3b
    db $27, $00, $3f, $23, $5f, $63, $7d, $43, $7f, $40, $40, $38, $7c, $4c, $7c, $4c
    db $7c, $4c, $00, $bc, $cc, $f6, $8e, $7e, $86, $fe, $06, $40, $3f, $7f, $40, $7f
    db $40, $7f, $40, $00, $7f, $47, $7f, $47, $7f, $40, $7f, $40, $40, $fc, $fe, $06
    db $fe, $06, $fe, $06, $70, $fe, $f8, $08, $fc, $0c

jr_006_66c0::
    db $00, $ec, $1c, $7c

jr_006_66c4::
    db $8c, $f6, $8e, $be, $c6, $05, $7b, $47, $5f

jr_006_66cd::
    db $63, $3f, $1f, $40, $e0, $d0, $30, $f8, $08, $f4, $0c, $00, $be, $c6, $fe, $c6
    db $fe, $c6, $7e, $46, $40, $f8, $fc, $8c, $bc, $cc, $76, $4e, $00, $7e, $46, $5e
    db $66, $3b, $27, $3f, $23, $40, $3e, $3f, $23, $3b, $27, $5f, $67, $00, $7e, $46
    db $76, $4e, $bc, $cc, $fc, $8c, $40, $7f, $ff, $80, $ff, $80, $ff, $8f, $00, $ff
    db $8f, $ff

jr_006_670f::
    db $8f, $ff, $80, $ff, $80, $40, $f0, $fc, $0c, $fe, $06, $be, $c6, $00, $fe, $c6
    db $be, $c6, $fe, $0e, $fc, $1c, $55, $80, $40, $20, $10, $55, $08, $04, $02, $01
    db $d5, $02, $04, $08, $55, $10, $20, $40, $80, $00, $fd

jr_006_673a::
    db $8d, $fd, $8d, $f7, $8f, $bf, $c0, $05, $ff, $c0, $6e, $71, $3f, $1f, $40, $fc
    db $fe, $06, $fe, $06, $fe, $0e, $05, $fe, $0e, $fc, $8c, $fc, $7c, $00, $3f, $23
    db $5f, $60, $7f, $40, $77, $4f, $05, $bf, $cf, $fc, $8c, $fc, $7c, $00, $f8, $18
    db $ec, $1c, $fc, $0c, $bc, $cc, $05, $f6, $ce, $7e, $46, $7e, $3e, $00, $7f, $40
    db $bf, $c0, $eb, $9c, $ff, $9c, $05, $ff, $9c, $ff, $9f, $fb, $78, $00, $fe, $06
    db $fb, $07, $af, $73, $ff, $73, $05, $ff, $73, $ff, $f3, $df, $0f, $00, $7f, $40
    db $7f, $47, $7f, $47, $7f, $40, $05, $7f, $40, $7f, $40, $3f, $1f, $1e, $fc, $0c
    db $fc, $04, $07, $fe, $06, $fe, $06, $fe, $00, $fc, $8c, $fc, $8c, $f7, $8f, $bf
    db $c0, $05, $ff, $c0, $6f, $70, $3f, $1f, $00, $7e, $46, $fe, $c6, $7e, $86, $fe
    db $06, $05, $fc, $0c, $fc, $1c, $f8, $f0, $00, $2d, $33, $1f, $10, $1f, $10, $17
    db $18, $05, $0f, $08, $0b, $0c, $07

jr_006_67e1::
    db $03, $00, $6c, $9c, $f8, $18, $f8, $18, $d8, $38, $07, $f0, $30, $b0, $70, $e0
    db $00, $fe, $8f, $ff, $8f, $fc, $8c, $fc, $8c, $05, $fc, $8c, $fc, $8c, $7c, $3c

    rst $38
    ld d, $00
    add b
    add c
    add d
    add e
    add h
    add l
    add [hl]
    add a
    add b
    adc c
    adc d
    adc e
    add [hl]
    add a
    adc h
    adc l
    rst $38
    inc b
    nop
    sub b
    sub c
    sub d
    sub e
    sub h
    sub l
    sub [hl]
    sub a
    sbc b
    sbc c
    sbc d
    sbc e
    sub [hl]
    sub a
    sbc h
    adc b
    rst $38
    ei
    nop
    rst $38
    dec e
    nop
    ld b, l
    rst $38
    dec c
    nop
    db $10
    inc h
    nop
    nop
    dec d
    ld de, $3d1f

    db $d8, $00, $40, $0f, $33, $3f, $41, $63, $90, $c1

    db $00

    xor a
    sbc a
    sub a
    sbc a
    sbc b
    sbc h
    rst $30
    rst $38

    db $40

    ldh [$ffd8], a
    ld a, b
    db $e4
    call z, $c6e2

    db $00

    ld a, [$befe]
    cp $44
    ld h, h
    cp d
    db $fe

    db $00

    rst $38
    ret nc

    cp a
    cp $ef
    ldh a, [$ffdb]
    db $fc

    db $01

    rst $08
    rst $38
    adc b
    db $fc
    ld hl, sp-$07
    db $f0

    db $00

    db $fd
    inc bc
    rst $38
    ld bc, $73ad
    rst $18
    ld a, a

    db $08

    ei
    cp $1f
    ccf
    dec hl
    cp $fa

    db $7d

    nop
    db $e0

    db $17

    ld e, b
    cp b
    ldh [rP1], a

    db $10

    sbc b
    rst $38
    rst $28
    ld c, a
    rst $08
    set 1, l

    db $17

    ld c, $0a
    ld e, $00

    db $1c

    ld c, $fe
    ld hl, sp+$68
    ld e, b

    db $17

    jr c, jr_006_68c5

    inc a
    nop

    db $41

    ld c, $13
    dec e
    ld de, $0e1f

    db $04

    ld a, [bc]
    ld c, $0a
    ld c, $0f
    ld b, $07

    db $5f

    inc bc
    nop

    db $73

    ld bc, $0302

    db $40

    nop
    dec b
    dec c
    ld h, $7f
    nop
    rst $38

    db $a0

    nop
    rst $38
    ld d, h
    rst $38
    db $11
    inc sp

    db $40

jr_006_68c5::
    rrca
    inc sp
    ccf
    ld b, c
    ld h, e
    sub b
    pop bc

    db $01

    xor a
    sbc a
    sub a
    sbc a
    sbc b
    sbc h
    rst $38

    db $80

    ret nc

    cp a
    cp $ef
    ldh a, [$ffdb]
    db $fc

    db $00

    rst $20
    rst $30
    ret z

    ldh [$ffdd], a
    ld hl, sp-$06
    db $e8

    db $00

    db $fd
    inc bc
    rst $38
    ld bc, $03fd
    cp $12

    db $40

    db $fc
    ld [bc], a
    ld c, $5d
    rrca
    xor a
    dec bc

    db $30

    cp b
    rst $38
    ld c, a
    rst $08
    set 1, l

    db $17

    ld c, $0a
    ld e, $00

    db $00

    rst $38
    xor b
    rst $18
    cp $df
    ret nc

    db $eb
    db $cc

    db $00

    rst $00
    rst $20
    xor b
    ldh a, [$fff5]
    ld hl, sp-$06
    db $f8

    db $70

    db $10
    jr c, jr_006_6940

    cp $c6

    db $1d

    jr c, @+$2a

    stop

    db $fd

    inc b

    db $fc

    ld c, $0a

    db $00

    rra
    ld de, $e0ff
    rra
    ld de, $0a0e

    db $7f

    inc b

    db $57

    nop
    ldh [rP1], a

    db $ff, $40

    rrca
    inc sp
    ccf
    ld b, c
    ld h, e
    sub b
    pop bc

    db $00

    xor [hl]
    sbc a
    sub a

jr_006_6940::
    sbc a
    sbc b
    sbc h
    rst $30
    rst $38

    db $40

    ldh [$ffd8], a
    ld a, b
    db $e4
    call z, $c6e2

    db $00

    or $fe
    cp [hl]
    cp $44
    ld h, h
    cp d
    db $fe

    db $00

    rst $38
    ret nc

    cp a
    cp $ef
    ldh a, [$ffdb]
    db $fc

    db $00

    rst $10
    rst $38
    ldh [$fff0], a
    push af
    ret c

    db $fc
    db $fe

    db $00

    db $fd
    inc bc
    rst $38
    ld bc, $f36d
    sbc a
    di

    db $00

    rst $38
    cp $21
    cpl
    halt
    ld h, [hl]
    db $ec
    xor h

    db $7d

    nop
    add b

    db $df

    nop

    db $45

    rst $20
    ld b, a
    rst $00
    db $c3
    nop

    db $ff, $05

    sub $7a
    rst $38
    ei
    db $fc
    nop

    db $ff, $00

    rst $38
    ret nc

    cp a
    cp $ef
    ldh a, [$fffb]
    cp h

    db $00

    rst $10
    rst $20
    add sp, -$10
    pop af
    db $fc
    sbc d
    db $fc

    db $00

    db $fd
    inc bc
    rst $38
    ld bc, $03fd
    sub $3a

    db $40

    cp $03
    rrca
    ld d, a
    dec b
    rst $28
    ret


    db $05

    ld a, d
    cp [hl]
    cp $9e
    db $fc
    nop

    db $ff, $ff, $40

    rlca
    add hl, bc
    rrca
    ld de, $111f
    rra

    db $77

    nop
    db $01

    db $40

    db $fd
    jp $81ff


    rst $38
    add c
    rst $38

    db $50

    nop
    ldh a, [$ff08]
    ld hl, sp+$3c
    db $c4

    db $00

    ld c, h
    or h
    inc a
    call nz, $b44c
    ld a, h
    add h

    db $00

    ld de, $081f
    rrca
    ld [DetectSgbOrInitSgb], sp
    rlca

    db $01

    inc b
    rlca
    inc a
    dec sp
    ld a, b
    ld b, a
    ld a, a

    db $00

    add b
    rst $38
    ret nz

    rst $38
    ldh a, [c]
    rst $38
    xor $ef

    db $21

    ldh [c], a
    db $e3
    ldh [c], a
    and c
    pop hl
    pop bc

    db $00

    add h
    db $fc
    ld a, b
    ld hl, sp+$50
    ldh a, [$ff50]
    db $f0

    db $81

    ld d, b
    ldh a, [$ff50]
    ld hl, sp+$38
    db $f8

    db $7f

    nop

    db $50

    ld bc, $0807
    rrca
    db $10
    rra

    db $77

    nop
    db $01

    db $40

    db $fd
    add e
    rst $38
    pop bc
    rst $38
    pop bc
    rst $38

    db $00

    db $10
    rra
    db $10
    rra
    ld [$0c0f], sp
    rrca

    db $41

    ld a, a
    adc a
    cp $bf
    ld hl, sp-$31

    db $00

    ret nz

    rst $38
    ld b, h
    rst $38
    jr z, @+$01

    db $11
    rst $38

    db $01

    sbc d
    or $9e
    ld [hl], d
    rrca
    ld sp, hl
    rst $30

    db $00

    add h
    db $fc
    ld a, b
    ld hl, sp+$08
    ld hl, sp-$3c
    db $fc

    db $01

    inc l
    inc [hl]
    ld e, $12
    rrca
    add hl, bc
    rlca

    db $7f

    nop

    db $d0

    rlca
    add hl, bc
    rrca
    db $11
    rra

    db $77

    nop
    db $01

    db $40

    db $fd
    jp $81ff


    rst $38
    add c
    rst $38

    db $00

    ld [$080f], sp
    rrca
    ld [$080f], sp
    rrca

    db $01

    ld a, h
    ld a, e
    db $fc
    add e
    rst $38
    cp a
    db $e3

    db $03

    ret nz

    rst $38
    ret nz

    rst $38
    ldh [rIE], a

    db $43

    db $fd
    cp [hl]
    cp a
    adc $ff

    db $00

    ld b, d
    cp $3c
    db $fc
    ld [$c4f8], sp
    db $fc

    db $01

    db $ec
    db $f4
    ld e, [hl]
    jp nc, $898f

    rrca

    db $40

    ld [hl], a
    ld hl, sp-$61
    jp hl


    xor [hl]
    db $ea
    xor l

    db $00

    jp hl


    xor [hl]
    xor d
    db $ed
    sbc e
    db $fc
    add h
    rst $38

    db $40

    add [hl]
    ld c, a
    ret


    rst $28
    dec hl
    ld l, [hl]
    xor d

    db $00

    xor $2a
    ld l, d
    xor [hl]
    ld [$322e], a
    db $fe

    db $00

    ld hl, $183f
    rra
    ld [DetectSgbOrInitSgb], sp
    rlca

    db $00

    ld [$0c0f], sp
    rrca
    rla
    rra
    db $11
    rra

    db $00

    pop hl
    rst $38
    ld a, [bc]
    cp $0c
    db $fc
    db $08
    db $f8

    db $01

    ld [$10f8], sp
    ldh a, [rNR10]
    ldh a, [$ffe0]

    db $00

    ld [$080f], sp

jr_006_6adf::
    rrca
    ld [$080f], sp
    rrca

    db $01

    ld a, h
    ld a, e
    db $fc
    add e
    rst $38
    cp a
    db $e3

    db $00

    jr nc, jr_006_6adf

    adc b
    ld hl, sp-$7c
    db $fc
    db $c4
    db $fc

    db $01

    or d
    cp [hl]
    ldh [c], a
    cp $c2
    ld a, $fc

    db $7f

    nop

    db $40

    ldh [$ffdf], a
    rst $38
    add c
    rst $38
    add c
    rst $38

    db $7f

    nop

    db $f4

    cp $ef
    add hl, sp

    db $00

    add e
    cp $83
    cp $d3
    cp $f2
    rst $38

    db $01

    ldh a, [rIE]
    add sp, -$11
    and h
    rst $20
    db $c3

    db $00

    rst $38
    ld b, l
    rst $08
    ld [hl], l
    rst $38
    ld b, l
    rst $08
    ld [hl], l

    db $01

    ld a, l
    rst $00
    ld b, l
    rst $38
    ld sp, hl
    rst $38
    db $0e

    db $c0

    rra
    ld de, $2a3f
    ld a, a
    ld e, e

    db $00

    ld [hl], l
    ld e, e
    ld a, a
    ld b, [hl]
    dec a
    dec sp
    db $ea
    push af

    db $74

    nop
    add b
    ret nz

    ld b, b

    db $04

    ret nz

    ld b, b
    ret nz

    ld b, b
    ld hl, sp-$30
    db $f0

    db $00

    inc sp
    ccf
    ld a, b
    ld c, a
    add sp, -$61
    rst $30
    sub a

    db $00

    or a
    call nc, $4c7f
    daa
    ccf
    add hl, de
    rra

    db $00

    xor $fe
    ld c, e
    db $fd
    rst $08
    ld sp, hl
    db $fd
    dec sp

    db $03

    xor $1e
    add sp, $18
    db $10
    db $f0

    db $00

    ld c, $0f
    dec bc
    dec c
    ld c, $09
    ld c, $09

    db $01

    ld a, a
    ld a, c
    db $dd
    and e
    cp $bf
    db $e3

    db $00

    db $10
    ldh a, [$ff38]
    add sp, -$0c
    call z, $e4dc

    db $01

    ld a, $22
    sbc $f2
    cp d
    ld b, [hl]
    db $fc

    db $40

    ld c, $1f
    ld de, $2a3f
    ld a, a
    ld e, e

    db $00

    ld [hl], l
    ld e, e
    ld a, a
    ld b, [hl]
    dec a
    dec sp
    db $ea
    push af

    db $40

    nop
    ld bc, $8100
    add b
    db $c3
    ld b, b

    db $01

    jp $c240


    ld b, b
    add d
    add b
    db $fe

    db $00

    push hl
    rst $38
    ld b, a
    rst $38
    set 7, l
    rst $38
    add hl, sp

    db $03

    db $ed
    dec de
    xor $1e
    db $10
    db $f0

    db $54

    nop
    ldh a, [$ff7c]
    cp d
    db $c6

    db $05

    rst $38
    pop af
    cp d
    add $7c
    db $f0

    db $7f

    nop

    db $40

    rlca
    add hl, bc
    rrca
    ld de, $191f
    rra

    db $7d

    nop
    db $01

    db $00

    rst $38
    cp $fb
    adc $fb
    adc [hl]
    push af
    adc a

    db $50

    nop
    ld [hl], b
    ld hl, sp-$78
    db $fc
    ld d, h

    db $00

    cp $da
    xor [hl]
    jp c, $32fe

    db $ec
    db $dc

    db $00

    ccf
    cpl
    dec e
    inc de
    rla
    add hl, de
    rrca
    add hl, bc

    db $01

    rrca
    add hl, bc
    ld [hl], a
    ld a, c
    db $ed
    sub e
    rst $38

    db $00

    ld a, [$bd0f]
    rst $00
    ld l, [hl]
    push af
    ld e, a
    db $dc

    db $01

    ld b, a
    push bc
    ld b, a
    push bc
    ld b, h
    rst $00
    add e

    db $10

    xor b
    ld e, b
    ldh a, [$ffa0]
    ldh [$ffa0], a
    db $e0

    db $77

    ld hl, sp-$20

    db $7f

    nop

    db $50

    ld bc, $0807
    rrca
    ld e, $1f

    db $7d

    nop
    db $01

    db $00

    rst $38
    cp $bb
    adc $fb
    adc $f5
    rst $08

    db $00

    rla
    add hl, de
    rra
    db $10
    rrca
    ld [$0e0d], sp

    db $01

    ld [hl], e
    ld a, a
    add [hl]
    rst $38
    cp [hl]
    ld sp, hl
    rst $08

    db $00

    db $fd
    rst $00
    ld e, [hl]
    db $e3
    rst $28
    add hl, sp
    push af
    dec de

    db $01

    sbc a
    di
    rst $38
    inc de
    ld sp, hl
    rrca
    rst $30

    db $10

    ld d, h
    xor h
    ld hl, sp+$28
    ld hl, sp-$34
    db $f4

    db $01

    db $fc
    db $f4
    cp $f2
    adc c
    adc a
    add a

    db $7f

    nop

    db $d0

    rlca
    add hl, bc
    rrca
    db $11
    rra

    db $7d

    nop
    db $01

    db $00

    ld a, a
    ld a, [hl]
    db $db
    xor $bb
    adc $fd
    add a

    db $02

    ld de, $191f
    rra
    rla
    rra
    db $11

    db $01

    ld a, a
    ld [hl], c
    db $dd
    and e
    rst $38
    cp a
    rst $20

    db $00

    rst $38
    add e
    cp [hl]
    pop bc
    rst $18
    ldh [hPlayerTileEffect], a
    rst $38

    db $01

    adc d
    ei
    ld c, h
    ld a, a
    adc c
    rst $38
    db $fe

    db $10

    ld d, h
    xor h
    ld hl, sp-$20
    jr nz, jr_006_6d14

    sub b

    db $21

    cp a
    rst $18
    rst $38
    inc l
    inc a
    inc e

    db $7f

    nop

    db $40

    ldh [$ffdf], a
    rst $38
    cp e
    adc $ff
    adc [hl]

    db $7d

    nop
    ld [hl], b

    db $00

    ld hl, sp-$78
    db $fc
    ld d, h
    cp $da
    xor [hl]
    db $da

    db $00

    rst $30
    inc c
    ld a, e
    add a
    cp [hl]
    db $d3
    ld e, a
    di

    db $01

    ld a, e
    or $57
    ret c

    ld c, a
    ret


    add [hl]

    db $00

    rst $38
    ld a, a
    rst $38
    cp a
    ld hl, sp+$78
    sub h
    db $fc

    db $81

    ld a, h
    ret z

    ld hl, sp+$48
    ld a, b
    db $30

    db $50

    nop
    jr @+$1e

    inc d
    dec d
    dec e

    db $00

    rra
    ld d, $17
    ld a, [de]
    rrca
    add hl, bc
    dec bc
    dec c

    db $50

    nop
    ld [hl], e
    db $fd
    adc a
    db $fd
    ld d, a

    db $00

    rst $38
    db $db
    xor a
    db $db
    rst $38
    inc sp
    db $ed
    rst $18

    db $00

    ld a, h
    ld c, a
    ld a, e
    ld b, a
    ld e, a
    ld h, c
    ccf
    db $21

    db $05

    rla
    add hl, de
    ld c, $0d
    inc bc
    nop

    db $00

jr_006_6d14::
    di
    ldh a, [c]
    sbc a
    cp $37
    ld hl, sp+$3f
    db $f0

    db $01

    ccf
    ldh a, [hPlayerTileEffect]
    ldh a, [hPlayerXSubpixel]
    rst $38
    ld a, a

    db $00

    db $eb
    ld d, a
    cp l
    rst $38
    add [hl]
    cp $44
    db $fc

    db $01

    ld hl, sp+$38
    ret nc

    jr nc, @+$62

    ldh [_HRAM], a

    db $50

    nop
    ldh [$fff0], a
    or b
    cp b
    db $f8

    db $00

    ret c

    cp b
    ld hl, sp-$68
    ld hl, sp-$68
    or $9e

    db $60

    rst $38
    add e
    rst $38
    and a
    db $eb
    cp a

    db $00

    ldh a, [c]
    cp a
    ld hl, sp-$41
    db $fc
    and a
    rst $28
    or e

    db $60

    rst $38
    pop bc
    rst $28
    di
    rla
    rst $38

    db $00

    dec bc
    rst $38
    ld h, e
    rst $38
    push af
    sbc a
    rst $10
    dec a

    db $00

    db $fc
    cp a
    rst $38
    sub e
    rst $38
    sub b
    rst $38
    sub b

    db $01

    rst $38
    sub e
    rst $38
    adc b
    rst $38
    add a
    rst $38

    db $00

    rst $20
    db $fd
    rst $38
    dec e
    rst $38
    add hl, bc
    rst $28
    ld e, c

    db $01

    rst $38
    sub c
    rst $38
    ld hl, $c1ff
    rst $38

    db $74

    nop
    rlca
    jr jr_006_6dab

    db $00

    ld hl, $4a3c
    ld [hl], b
    push af
    ldh [$ffea], a
    and b

    db $74

    nop
    ldh [rNR23], a
    db $f8

    db $00

    ld b, h
    inc e
    xor d
    ld b, $55
    inc bc
    xor c
    inc bc

    db $00

    push af
    ldh [$fffa], a
    ret nc

    push af
    pop af
    db $eb

jr_006_6dab::
    db $dd

    db $00

    rst $10
    rst $08
    ret z

    ldh [$ffe5], a
    ldh a, [hOamMaxY]
    db $f8

    db $00

    ld d, e
    rlca
    xor a
    dec b
    ld [hl], a
    daa
    xor e
    xor l

    db $00

    push af
    ld sp, hl
    ld a, [bc]
    ld [bc], a
    ld d, h
    inc b
    xor b
    db $08

    db $0c

    ld hl, sp-$01
    ld c, a
    rst $08
    dec bc
    dec c

    db $17

    ld c, $0a
    ld e, $00

    db $3c

    ld [$68f8], sp
    ld e, b

    db $17

    jr c, jr_006_6e03

    inc a
    nop

    db $41

    ld c, $13
    dec e
    ld de, $0e1f

    db $04

    ld a, [bc]
    ld c, $0a
    ld c, $0f
    inc b
    db $06

    db $00

    add hl, bc
    inc c
    ld a, [bc]
    ld [$080d], sp
    ld a, [bc]
    inc c

    db $13

    inc b
    rlca
    inc bc
    ld [bc], a
    inc bc

    db $75

    nop
    rrca
    rra

    db $00

    ccf
    scf
    ld a, a

jr_006_6e03::
    ld l, b
    ld a, a
    ld h, a
    ld a, [hl]
    ld l, c

    db $75

    nop
    ret nz

    db $f0

    db $00

    ld e, b
    cp b
    db $f4
    xor h
    db $fc
    inc e
    db $ea
    or [hl]

    db $00

    rst $18
    and c
    rst $38
    db $fc
    ld d, e
    add a
    xor d
    db $01

    db $00

    ld d, h
    nop
    xor e
    ld bc, $0f5f
    xor a
    dec c

    db $00

    db $fd
    or e
    rst $38
    ld bc, $43fd
    cp $d2

    db $00

    ld a, h
    db $fc
    jp nz, Jump_006_5dce

    rrca
    xor a
    dec bc

    db $b0

    rst $38
    ld c, a
    rst $08
    set 1, l

    db $17

    ld c, $0a
    ld e, $00

    db $3c, $00, $00, $07, $03, $06, $02, $06, $02, $06, $02

    db $00

    ld b, $02
    rlca
    inc bc
    rlca
    inc bc
    rlca
    inc bc

    db $5d

    rst $38
    db $01
    ld a, c

    db $00

    add l
    sbc l
    rra
    ld a, a
    rrca
    rst $38
    ld c, a
    rst $38

    db $01

    ld e, $19
    rlca
    inc b
    inc bc
    ld [bc], a
    db $01

    db $df

    nop

    db $00

    rst $38
    add b
    ld a, a
    ret nz

    cp a
    ld h, b
    cp a
    ld h, b

    db $00

    ld e, a
    or b
    rst $18
    or b
    rst $18
    or b
    rst $18
    or b

    db $00

    rst $18
    or b
    rst $18
    or b
    rst $18
    or b
    rst $18
    or b

    db $00

    rst $18
    or b
    rst $08
    cp h
    di
    adc [hl]
    db $ed
    di

    db $20

    db $ed
    di
    adc [hl]
    rst $08
    cp h
    rst $18
    or b

    db $00

    rst $18
    or b
    rst $18
    or b
    rst $18
    or b
    rst $38
    db $f8

    db $00

    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103

    db $00

    inc bc
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc
    ld bc, $0103

    db $7d

    nop
    db $e0

    db $40

    db $10
    cp b
    db $10
    cp b
    sub b
    cp b
    sub b

    db $00

    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b

    db $00

    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b

    db $00

    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103

    db $00

    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103

    db $00

    inc bc
    ld bc, $0203
    inc bc
    ld [bc], a
    inc bc
    db $01

    db $00

    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103

    db $51

    rst $38
    nop
    rst $38
    nop
    rst $38

    db $bf

    nop

    db $50

    ldh [rNR10], a
    cp b
    db $10
    cp a
    sbc a

    db $04

    or b
    add b
    cp a
    add b
    ld a, a
    ccf
    nop

    db $fd

    rst $38

    db $46

    nop
    rst $38
    nop
    rst $38
    nop

    db $f4

    jr c, @-$2f

    rst $00

    db $06

    jr nc, jr_006_6f25

    rst $08
    jr c, @+$01

    db $38

    db $00

jr_006_6f22::
    rst $18
    or b
    rst $18

jr_006_6f25::
    or b
    rst $38
    ld hl, sp-$09
    adc h

    db $00

    adc a
    add h
    rst $30
    adc h
    adc a
    cp $fd
    ei

    db $00

    rlca
    inc bc
    ld b, $02
    ld b, $02
    ld b, $02

    db $00

    rlca
    inc bc
    rlca
    inc bc
    rlca
    inc bc
    rlca
    inc bc

    db $15

    ld a, a
    rst $38
    db $fd
    ld a, c
    db $01

    db $41

    rst $38
    ld c, e
    add a
    ld c, e
    add a
    rst $38

    db $7d

    nop
    db $01

    db $c0

    inc bc
    ld [bc], a
    rlca
    inc b
    ld e, $19

    db $00

    rst $18
    or b
    rst $18
    or b
    rst $18
    or b
    ld e, a
    or b

    db $00

    cp a
    ld h, b
    cp a
    ld h, b
    ld a, a
    ret nz

    rst $38
    add b

    db $20

    db $ed
    di
    adc [hl]
    rst $08
    cp h
    rst $18
    or b

    db $00

    rst $18
    or b
    rst $18
    or b
    rst $18
    or b
    rst $18
    or b

    db $00

    rst $30
    adc h
    adc a
    add h
    rst $30
    adc h
    adc a
    db $fc

    db $00

    rst $38
    ld hl, sp-$11
    sbc b
    rst $30
    adc [hl]
    jp hl


    rst $30

    db $20

    db $ed
    di
    adc [hl]
    rst $38
    db $fc
    rst $30
    adc h

    db $00

    adc a
    add h
    rst $30
    adc h
    adc a
    db $fc
    rst $38
    db $f8

    db $01

    cp a
    sbc a
    and b
    add b
    cp a
    add b
    ld a, a

    db $3f

    ccf
    nop

    db $5d

    rst $38
    db $01
    ld a, c

    db $00

    sbc l
    add l
    ld a, a
    rra
    rst $38
    rrca
    rst $38
    ld c, a

    db $15

    rst $38
    ld a, a
    db $fd
    ld a, c
    db $01

    db $41

    rst $38
    ld c, e
    add a
    ld c, e
    add a
    rst $38

    db $dd

    db $01
    ld a, c

    db $0f

    push hl
    add l
    add e
    inc bc

    db $05

    rlca
    inc bc
    db $fd
    add l
    ld a, c
    db $01

    db $41

    rst $38
    ld c, e
    add a
    ld c, e
    add a
    rst $38

    db $df

    nop

    db $ff, $5f

    rst $38
    nop

    db $f7

    dec b

    db $98, $00, $99, $ff, $0f, $00, $94, $01, $98, $00, $90, $91, $ff, $0e, $00, $92
    db $93, $98, $00, $a0, $a1, $ff, $0e, $00, $a2, $a3, $98, $00, $9a, $ff, $07, $9b
    db $9c, $ff, $03, $9d, $9e, $ff, $03, $9d, $a6, $01, $98, $00, $99, $ff, $0f, $00
    db $94, $01, $98, $00, $90, $91, $ff, $0e, $00, $92, $93, $98, $00, $a0, $a1, $ff
    db $0e, $00, $a2, $a3, $98, $00, $96, $9d, $9d, $9e, $9d, $9d, $97, $ff, $09, $00
    db $95, $01, $98, $00, $99, $ff, $05, $00, $a7, $ff, $09, $9b, $a5, $01, $98, $00
    db $90, $91, $ff, $0e, $00, $92, $93, $98, $00, $a0, $a1, $ff, $0e, $00, $a2, $a3
    db $98, $00, $99, $ff, $0f, $00, $a4, $01, $98, $00, $9a, $ff, $08, $9b, $9c, $9e
    db $ff, $05, $9d, $9f, $01, $98, $00, $90, $91, $ff, $0e, $00, $92, $93, $98, $00
    db $a0, $a1, $ff, $0e, $00, $a2, $a3, $98, $00, $99, $ff, $0f, $00, $a4, $01, $ff
    db $0c, $ac, $ad, $ff, $07, $ac, $ff, $06, $00, $57, $5a, $7e, $5f, $14, $1d, $2a
    db $7f, $ff, $06, $00

    db $ba, $00, $50, $0f, $1f, $3f, $37, $7f, $68

    db $00

    ld a, a
    ld h, a
    ld a, [hl]
    ld l, c
    rst $18
    and c
    rst $38
    add b

    db $50

    ret nz

    ldh a, [$ff58]
    cp b
    db $f4
    xor h

    db $00

    db $fc
    inc e
    ld [$fdb6], a
    or e
    rst $38
    db $01

    db $04

    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca
    db $10
    rra

    db $01

    ld [de], a
    rra
    inc e
    rra
    inc e
    rla
    rrca

    db $04

    rst $38
    ld bc, $12fe
    db $fc
    db $08
    db $f8

    db $01

    inc b
    db $fc
    inc b
    db $fc
    inc c
    db $fc
    db $f8

    db $41

    rst $38
    ld a, d
    ld c, [hl]
    ld [hl], h
    ld e, h
    ld a, [hl]

    db $7f

    nop

    db $00

    ld l, a
    ld [hl], b
    dec de
    inc e
    daa
    ccf
    ld b, b
    ld a, a

    db $07

    ldh [hPlayerTileEffect], a
    ld hl, sp-$01
    rrca

    db $04

    rst $38
    ld bc, $12fe
    db $fc
    inc b
    db $fc

    db $05

    ld [bc], a
    cp $07
    db $fd
    rst $38
    db $f8

    db $05

    inc b
    rlca
    dec bc
    rrca
    inc c
    nop

    db $ff, $05

    or b
    ret nc

    ld a, b
    ld e, b
    jr nc, @+$02

    db $ff, $04

    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca
    add hl, bc
    rrca

    db $05

    add hl, bc
    rrca
    inc de
    ld e, $1f
    rrca

    db $04

    rst $38
    ld bc, $12fe
    db $fc
    db $08
    db $f8

    db $07

    adc b
    ld hl, sp-$78
    ld hl, sp-$10

    db $05

    dec c
    dec bc
    ld e, $16
    inc e
    nop

    db $ff, $05

    ret z

    ld hl, sp+$2c
    inc a
    jr c, @+$02

    db $ff, $00

    ld l, a
    ld [hl], b
    dec de
    inc e
    ld h, a
    ld a, a
    ldh [hPlayerTileEffect], a

    db $03

    ret z

    rst $38
    jr c, jr_006_718c

    inc c
    rrca

    db $04

    xor a
    ld [hl], c
    sbc $72
    db $fc
    ld [bc], a
    db $fe

    db $01

    ld a, [bc]
    cp $0e
    cp $0e
    db $fa
    db $fc

    db $41

    ld hl, sp+$58
    ld l, b
    jr c, jr_006_718d

    inc a

    db $7f

    nop

    db $00

    ld l, a
    ld [hl], b
    dec de
    inc e
    daa
    ccf
    jr nz, jr_006_71b0

    db $01

    jr z, jr_006_71b3

    jr c, @+$41

    inc a
    cpl
    rra

    db $04

    rst $38
    ld bc, $12fe
    db $fc
    ld [bc], a
    db $fe

    db $01

    ld a, [bc]
    cp $0e
    cp $0e
    db $fa
    db $fc

    db $50

    rrca
    rra

jr_006_718c::
    ccf

jr_006_718d::
    scf
    ld a, a
    ld l, b

    db $00

    ld a, a
    ld h, b
    ld a, a
    ld h, a
    rst $18
    and b
    rst $38
    add b

    db $50

    ret nz

    ldh a, [$ff58]
    cp b
    db $f4
    xor h

    db $00

    db $fc
    inc b
    ld a, [$fdbe]
    inc bc
    rst $38
    db $01

    db $04

    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca
    db $10

jr_006_71b0::
    rra

    db $03

    db $10

jr_006_71b3::
    rra
    ld de, $081f
    rrca

    db $04

    rst $38
    ld bc, $12fe
    db $fc
    add d
    db $fe

    db $01

    ld c, d
    cp $6a
    cp $fc
    or h
    db $fc

    db $00

    rst $38
    ld bc, $13ff
    db $fc
    rst $38
    add [hl]
    rst $38

    db $01

    ld b, a
    db $fd
    ld l, a
    rst $38
    jp hl


    cp c
    ld sp, hl

    db $77

    nop
    add b

    db $df

    nop

    db $41

    cp $58
    ld l, b
    jr c, @+$2a

    inc a

    db $7f

    nop

    db $00

    rst $38
    ld bc, $13ff
    db $fc
    rst $38
    db $01
    rst $38

    db $03

    rlca
    rst $38
    ld [jr_000_08f8], sp
    db $f8

    db $76

    nop
    ret nz

    ld b, b

    db $7f

    and b

    db $d5

    cp h
    add d
    ld a, [hl]

    db $7f

    nop

    db $00

    ld l, a
    ld [hl], b
    dec de
    inc e
    daa
    ccf
    ld b, b
    ld a, a

    db $03

    ld hl, sp-$41
    add sp, -$11
    inc c
    rrca

    db $00

    rst $10
    add hl, sp
    rst $28
    dec sp
    db $fc
    rst $38
    db $01
    rst $38

    db $03

    rlca
    rst $38
    ld [jr_000_08f8], sp
    db $f8

    db $04

    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca
    db $10
    rra

    db $05

    ld [de], a
    rra
    rst $38
    db $fd
    rrca
    rst $38

    db $84

    ld bc, $12fe
    db $fc
    db $08
    db $f8

    db $01

    inc b
    db $fc
    adc [hl]
    ld a, [$fe4e]
    ld sp, hl

    db $41

    rlca
    inc bc
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $7f

    nop

    db $41

    rst $38
    ret nc

    ld [hl], b
    and b
    ldh [$fff0], a

    db $7f

    nop

    db $05

    cp a
    rst $18
    ld a, b
    ld e, b
    jr nc, @+$02

    db $ff, $05

    rst $18
    rst $38
    inc l
    inc a
    jr c, @+$02

    db $ff, $40

    rlca
    add hl, de
    rra
    daa
    jr c, jr_006_72c9

    ld [hl], e

    db $00

    ld c, a
    ld [hl], b
    ld l, a
    ld [hl], e
    rst $28
    sub b
    rst $38
    add b

    db $40

    ldh [$ff38], a
    ld hl, sp-$04
    ld d, h
    cp $8e

    db $00

    db $fd
    inc bc
    xor a
    db $dd
    rst $38
    ld d, c
    rst $38
    db $01

    db $04

    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca
    db $10
    rra

    db $25

    ld [de], a
    rra
    dec e
    cpl
    ld e, a

    db $04

    rst $38
    ld bc, $12fe
    db $fc
    db $08
    db $f8

    db $01

    inc b
    db $fc
    adc a
    ei
    ld c, [hl]
    cp $f8

    db $7f

    nop

    db $d5

    rst $38
    nop
    rst $38

    db $41

    ld h, a
    inc bc
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $7f

    nop

    db $05

    ld h, h
    ld h, a
    dec bc
    rrca
    inc c
    nop

    db $ff, $05

    ld l, l
    ld l, e
    ld e, $16
    inc e
    nop

    db $ff, $04

    rst $10
    add hl, sp
    xor $3a
    db $fc
    db $08

jr_006_72c9::
    db $f8

    db $01

    inc b
    db $fc
    ld c, $fa
    ld c, $fe
    ld sp, hl

    db $40

    rlca
    jr jr_006_72f5

    add hl, hl
    ccf
    ld b, a
    ld a, b

    db $00

    ld e, a
    ld [hl], e
    ld l, a
    ld [hl], b
    rst $28
    sub e
    rst $38
    add b

    db $40

    ldh [$ff58], a
    ld hl, sp+$04
    db $fc
    cp $52

    db $00

    rst $38
    adc a
    rst $38
    ld bc, $ddaf
    rst $38
    ld d, c

    db $00

jr_006_72f5::
    ld l, a
    ld [hl], b
    dec de
    inc e
    ld h, $3f
    db $21
    ccf

    db $01

    jr z, @+$41

    jr c, @+$41

    inc a
    cpl
    rra

    db $00

    rst $38
    ld bc, $03fd
    ld h, $fe
    db $fa
    db $fe

    db $01

    ld a, [bc]
    cp $0e
    cp $0e
    db $fa
    db $fc

    db $7f

    nop

    db $d4

    inc bc
    rlca
    rrca
    db $0e

    db $7f

    nop

    db $d4

    ldh [$fff0], a
    ld hl, sp-$58

    db $00

    rra
    add hl, de
    rra
    ld a, [de]
    ccf
    jr nc, jr_006_739b

    ld d, b

    db $00

    ld a, a
    ld b, b
    ld a, a
    ld b, b
    ccf
    jr nc, @+$19

    db $18

    db $00

jr_006_7337::
    db $fc
    or h
    db $fc
    inc c
    ld a, [$fe06]
    and d

    db $00

    cp $02
    sbc $22
    sbc $22
    cp $02

    db $00

    rrca
    ld [$0c0f], sp
    inc de
    rra
    jr nz, jr_006_7390

    db $01

    jr z, jr_006_7393

    jr c, jr_006_7395

    jr c, @+$31

    rra

    db $04

    ld e, d
    and $b4
    db $ec
    db $fc
    ld [bc], a
    db $fe

    db $01

    ld a, [bc]
    cp $0e
    cp $0e
    db $fa
    db $fc

    db $00

    cpl
    jr c, @+$31

    inc a
    inc hl
    ccf
    db $10
    rra

    db $03

    ld [$080f], sp
    rrca
    db $08
    rrca

    db $00

    rra
    jr @+$31

    inc a
    inc hl
    ccf
    jr nz, jr_006_73c1

    db $03

    jr jr_006_73a4

    ld [$080f], sp
    rrca

    db $80

    ld [$0c0f], sp
    inc de
    rra
    db $10

jr_006_7390::
    rra

    db $01

    inc d

jr_006_7393::
    rra
    inc e

jr_006_7395::
    rra
    inc e
    rla
    rrca

    db $04

    ld e, d

jr_006_739b::
    and $b4
    db $ec
    ld hl, sp+$04
    db $fc

    db $01

    inc b
    db $fc

jr_006_73a4::
    inc b
    db $fc
    inc c
    db $fc
    db $f8

    db $00

    rrca
    ld [$1c1f], sp
    inc hl
    ccf
    ld h, b
    ld a, a

    db $07

    and b
    cp a
    ld hl, sp-$01
    rrca

    db $04

    ld e, d
    and $b4
    db $ec
    ld hl, sp+$04
    db $fc

    db $05

jr_006_73c1::
    ld [bc], a
    cp $05
    db $fd
    rst $38
    db $f8

    db $00

    rrca
    ld [$0407], sp
    dec bc
    rrca
    add hl, bc
    rrca

    db $05

    add hl, bc
    rrca
    inc de
    ld e, $1f
    rrca

    db $04

    ld e, d
    and $b4
    db $ec
    ld hl, sp+$04
    db $fc

    db $07

    add h
    db $fc
    add h
    db $fc
    db $f8

    db $00

    rrca
    ld [$0c0f], sp
    inc de
    rra
    db $10
    rra

    db $25

    ld [de], a
    rra
    dec e
    cpl
    ld e, a

    db $04

    ld e, d
    and $b4
    db $ec
    ld hl, sp+$04
    db $fc

    db $01

    inc b
    db $fc
    adc a
    ei
    ld c, [hl]
    cp $f8

    db $00

    rrca
    ld [$0c0f], sp
    inc de
    rra
    db $10
    rra

    db $05

    ld [de], a
    rra
    rst $38
    db $fd
    rrca
    rst $38

    db $00

    ld l, a
    ld [hl], b
    dec de
    inc e
    daa
    ccf
    ld b, b
    ld a, a

    db $01

    ld hl, sp-$41
    add sp, -$11
    inc e
    rra
    rst $38

    db $84

    ld bc, $12fe
    db $fc
    db $08
    db $f8

    db $01

    inc b
    db $fc
    ld c, $fa
    ld c, $fe
    ld sp, hl

    db $7f

    nop

    db $fd

    rra

    db $70

    rrca
    ccf
    dec a
    ld a, a
    ld a, b

    db $00

    ld a, a
    ld [hl], e
    xor $95
    rst $38
    add c
    ld a, a
    ld h, b

    db $56

    db $f4
    db $fd
    rst $38
    ld a, a

    db $00

    cp $1e
    db $ec
    or h
    db $fc
    or h
    cp $02

    db $00

    rla
    jr @+$0f

    ld c, $13
    rra
    jr nz, jr_006_749d

    db $01

    jr z, jr_006_74a0

    jr c, jr_006_74a2

    inc a
    cpl
    rra

    db $04

    cp $02
    db $fc
    inc h
    db $fc
    ld [bc], a
    db $fe

    db $01

    ld a, [bc]
    cp $0e
    cp $0e
    db $fa
    db $fc

    db $75

    rrca
    ccf
    ld a, a

    db $80

    ld a, l
    cp $f9
    rst $28
    sub b
    rst $38
    add b

    db $57

    db $f4
    db $fd
    rst $38

    db $f0

    ld a, $fa
    db $cd
    ccf

    db $00

    ld [hl], a
    ld a, b
    dec c
    ld c, $13
    rra
    jr nz, jr_006_74d3

    db $01

    jr z, @+$41

    jr c, jr_006_74d8

    inc a
    cpl
    rra

    db $00

jr_006_749d::
    db $fd
    rlca
    ld sp, hl

jr_006_74a0::
    rrca
    pop af

jr_006_74a2::
    rst $38
    ld [bc], a
    db $fe

    db $03

    inc c
    db $fc
    ld [jr_000_08f8], sp
    db $f8

    db $70

    rrca
    ccf
    inc a
    ld a, a
    ld a, b

    db $00

    ld a, a
    ld [hl], b
    rst $28
    sub b
    rst $38
    add a
    ld a, a
    ld h, b

    db $5c

    ld sp, hl
    rst $38
    cp $3e

    db $00

    db $fc
    inc e
    db $ec
    inc [hl]
    db $fc
    or h
    rst $38
    inc bc

    db $00

    cp $03
    db $fc
    daa
    ld sp, hl
    rst $38
    ld [bc], a
    db $fe

    db $03

jr_006_74d3::
    inc c
    db $fc
    ld [jr_000_08f8], sp

jr_006_74d8::
    db $f8

    db $65

    ret nz

    ld b, b
    ret nz

    add b

    db $7f

    nop

    db $70

    rrca
    ccf
    dec a
    ld a, a
    ld a, b

    db $00

    ld a, a
    ld [hl], b
    rst $28
    sub b
    rst $38
    add a
    ld a, a
    ld h, b

    db $56

    db $f4
    db $fd
    rst $38
    ld a, a

    db $00

    cp $1e
    db $ec
    inc [hl]
    db $fc
    or h
    rst $38
    inc bc

    db $7f

    nop

    db $fd

    db $fa

    db $00

    rla
    jr @+$0f

    ld c, $13
    rra
    db $10
    rra

    db $01

    ld [de], a
    rra
    inc e
    rra
    inc e
    rla
    rrca

    db $04

    cp $02
    db $fc
    inc h
    ld hl, sp+$08
    db $f8

    db $01

    inc b
    db $fc
    inc b
    db $fc
    inc c
    db $fc
    db $f8

    db $00

    rla
    jr @+$1f

    ld e, $23
    ccf
    ld b, b
    ld a, a

    db $07

    ldh [hPlayerTileEffect], a
    ld hl, sp-$01
    rrca

    db $04

    cp $02
    db $fc
    inc h
    ld hl, sp+$04
    db $fc

    db $05

    ld [bc], a
    cp $07
    db $fd
    rst $38
    db $f8

    db $00

    rla
    jr jr_006_7551

    ld c, $0b
    rrca
    add hl, bc
    rrca

    db $05

    add hl, bc
    rrca
    inc de
    ld e, $1f
    rrca

    db $04

jr_006_7551::
    cp $02
    db $fc
    inc h
    ld hl, sp+$08
    db $f8

    db $07

    adc b
    ld hl, sp-$78
    ld hl, sp-$10

    db $00

    rla
    jr @+$0f

    ld c, $13
    rra
    db $10
    rra

    db $25

    ld [de], a
    rra
    dec e
    cpl
    ld e, a

    db $04

    cp $02
    db $fc
    inc d
    ld hl, sp+$08
    db $f8

    db $01

    inc b
    db $fc
    adc a
    ei
    ld c, [hl]
    cp $f8

    db $7f

    nop

    db $fd

    rst $38

    db $14, $00, $06, $0f, $00, $0f, $00, $0f, $00

    db $53

    rrca
    nop
    rrca
    nop

    db $f5

    ldh a, [rP1]

    db $5f

    ldh a, [rP1]

    db $c1

    rrca
    nop
    rrca
    nop
    rrca

    db $94

    nop
    rrca
    nop
    rrca
    nop

    db $fd

    db $f0

    db $57

    nop
    ldh a, [rP1]

    db $6c

    rst $38
    nop
    rst $38
    nop

    db $80

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

    db $83

    nop
    rst $38
    nop
    rst $38
    nop

    db $0c

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $03

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $30

    adc a
    nop
    rst $38
    nop
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

    db $03

    rst $38
    nop
    rst $00
    nop
    add c
    nop

    db $6c

    rst $38
    nop
    rst $38
    nop

    db $80

    rst $38
    ld h, b
    cp a
    ld h, b
    rst $38
    nop
    rst $38

    db $ff, $09, $01, $97, $ff, $09, $01, $98, $ff, $03, $01, $97, $ff, $05, $01, $98
    db $ff, $03, $01, $97, $ff, $08, $01, $98, $ff, $05, $01, $ff, $10, $96, $ff, $10
    db $95, $ff, $40, $00, $94, $94, $99, $ff, $09, $94, $99, $99, $94, $94, $9e, $8e
    db $95, $96, $97, $98, $9e, $8e, $95, $96, $97, $98, $9e, $8e, $95, $96, $97, $98
    db $9e, $8e, $9d, $90, $93, $94, $ff, $05, $00, $94, $00, $d0, $d1, $d2, $d3, $94
    db $00, $9c, $9d, $90, $8f, $91, $92, $99, $ff, $06, $00, $d8, $d4, $d5, $d6, $d7
    db $99, $9a, $9b, $8f, $91, $8e, $95, $89, $ff, $0e, $82, $88, $8e, $95, $90, $93
    db $83, $ff, $0e, $00, $84, $90, $93, $91, $92, $83, $ff, $0e, $00, $84, $91, $92
    db $95, $96, $83, $ff, $0e, $00, $84, $95, $96, $93, $94, $83, $ff, $0e, $00, $84
    db $93, $94, $92, $99, $83, $ff, $0e, $00, $84, $92, $99, $96, $97, $83, $ff, $0e
    db $00, $84, $96, $97, $94, $00, $83, $ff, $0e, $00, $84, $94, $00, $99, $9a, $83
    db $ff, $0e, $00, $84, $99, $9a, $97, $98, $83, $ff, $0e, $00, $84, $97, $98, $00
    db $9c, $83, $ff, $0e, $00, $84, $00, $9c, $9a, $9b, $83, $ff, $0e, $00, $84, $9a
    db $9b, $98, $9e, $87, $ff, $0e, $85, $86, $98, $9e, $9c, $9d, $90, $93, $94, $00
    db $9c, $9d, $90, $93, $94, $00, $9c, $9d, $90, $93, $94, $00, $9c, $9d, $9b, $8f
    db $91, $92, $99, $9a, $9b, $8f, $91, $92, $99, $9a, $9b, $8f, $91, $92, $99, $9a
    db $9b, $8f

    db $80, $00, $54, $00, $0f, $1f, $3f, $37

    db $00

    ld a, a
    ld l, b
    ld a, a
    ld h, a
    ld a, [hl]
    ld l, c
    rst $18
    and c

    db $54

    nop
    ret nz

    ldh a, [$ff58]
    cp b

    db $00

    db $f4
    xor h
    db $fc
    inc e
    or $ae
    db $fd
    adc a

    db $00

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    cpl
    scf

    db $02

    dec [hl]
    jr nz, jr_006_774f

    jr z, jr_006_776c

    jr c, jr_006_7760

    db $01

    rst $38
    ld bc, $01ff
    cp $12
    db $fc

    db $02

    ld d, d
    ld c, $aa
    ld b, $5e
    ld c, $fa

    db $50

    db $fc
    ld hl, sp+$58
    ld l, b
    jr c, @+$2a

    db $55

    inc a
    cp $f8
    nop

    db $d5

    rrca

jr_006_774f::
    rra
    ccf

    db $7f

    ld a, a

    db $55

    nop
    ret nz

    ldh a, [$fff8]

    db $00

    db $fc
    db $f4
    db $fc
    db $ec
    ld a, [$fdee]

jr_006_7760::
    rst $30

    db $60

    ld a, a
    ld l, a
    sbc a
    cp a
    rst $18
    sbc a

    db $02

    sub l
    and b
    ld c, d

jr_006_776c::
    ld h, b
    dec [hl]
    jr nz, jr_006_77af

    db $01

    rst $28
    db $fd
    ei
    rst $28
    cp [hl]
    add $fc

    db $02

    ld d, h
    inc c
    xor h
    inc d
    ld e, h
    inc e
    db $f4

    db $70

    ccf
    ld d, $1a
    ld c, $0a

    db $55

    rrca
    ccf
    rrca
    nop

    db $50

    ld hl, sp-$10
    or b
    ret nc

    ld [hl], b
    ld d, b

    db $55

    ld a, b
    db $fc
    ldh a, [rP1]

    db $00

    ld a, a
    ld l, a
    ld e, a
    ld a, a
    ld c, a
    ld e, a
    ld h, a
    ld c, a

    db $02

    ld d, l
    ld h, b
    ld a, [hl+]
    jr nz, @+$37

    jr nz, @+$41

    db $54

    nop
    rrca
    rra
    ccf
    db $30

    db $00

jr_006_77af::
    ld a, a
    ld l, a
    ld a, a
    ld h, b
    ld a, a
    ld h, a
    rst $18
    and b

    db $54

    nop
    ret nz

    ldh a, [$fff8]
    xor b

    db $00

    ld e, h
    cp h
    db $fc
    inc b
    cp $ba
    db $fd
    inc bc

    db $00

    rst $38
    add b
    ld l, a
    ld [hl], b
    dec de
    inc e
    ld l, a
    ld [hl], a

    db $00

    push af
    and b
    ld [$55d0], a
    ld a, b
    jr c, jr_006_7817

    db $01

    rst $38
    ld bc, $39d7
    xor $3a
    db $fe

    db $00

    ld d, a
    dec c
    xor e
    rlca
    ld e, d
    ld c, $0c
    db $fc

    db $00

    rst $38
    add b
    ld l, a
    ld [hl], b
    sbc e
    call c, Call_006_4fe7

    db $00

    push hl
    ldh a, [rNR30]
    db $10
    dec d
    jr jr_006_7802

    rrca

    db $00

    rst $38
    ld bc, $39d7
    xor $3a

jr_006_7802::
    db $fd
    rst $38

    db $00

    ld d, a
    rrca
    xor b
    ld [$1e4e], sp
    dec sp
    db $fd

    db $01

    ld hl, sp-$79
    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca

    db $04

    dec d

jr_006_7817::
    db $10
    ld a, [de]
    db $10
    rla
    jr nz, jr_006_785c

    db $01

    di
    dec c
    rst $38
    ld bc, $12fe
    rst $38

    db $00

    ld [hl], e
    ld e, [hl]
    ld h, a
    rst $28
    ret c

    adc b
    db $08
    db $f8

    db $7d

    nop
    add b

    db $df

    nop

    db $58

    rra
    rrca
    add hl, bc
    ld e, $16

    db $55

    inc e
    ccf
    rrca
    nop

    db $70

    ld hl, sp+$58
    ld l, b
    jr c, jr_006_786c

    db $55

    inc a
    cp $f8
    nop

    db $01

    db $fc
    add e
    ld l, a
    ld [hl], b
    dec de
    inc e
    rrca

    db $00

    dec d
    db $10
    ld a, [de]
    ld de, $1317
    jr nz, jr_006_7899

    db $00

    ld a, c

jr_006_785c::
    add a
    rst $38
    ld bc, $7bff
    rst $38
    db $de

    db $02

    inc sp
    ld l, a
    db $e4
    call z, Call_000_0858
    db $f8

    db $54

jr_006_786c::
    nop
    rrca
    rra
    ccf
    db $38

    db $00

jr_006_7872::
    ld a, a
    ld [hl], a
    ld a, a
    ld [hl], b
    ld a, a
    ld [hl], e
    rst $28
    sub b

    db $54

    nop
    ret nz

    ldh a, [$fff8]
    ld e, b

    db $00

    xor h
    call c, Call_000_04fc
    cp $de
    rst $38
    db $01

    db $17

    ld a, a
    ld e, a
    rst $30
    nop

    db $d5

    ld a, a
    rra
    nop

    db $70

    ld hl, sp+$68
    ld e, b
    ld [hl], b
    ld d, b

    db $55

jr_006_7899::
    ld a, b
    db $fc
    ldh a, [rP1]

    db $d0

    db $fc
    add h
    db $fc
    db $f4
    adc h

    db $00

    add h
    db $fc
    call nz, $e4bc
    sbc h
    or h
    db $cc

    db $60

    rst $38
    cp a
    ld l, a
    ld e, a
    ld c, e
    ld h, b

    db $00

    dec h
    jr nc, jr_006_78d1

    db $10
    dec d
    jr @+$0a

    rrca

    db $00

    rst $28
    db $fd
    ei
    rst $28
    cp a
    add $79
    rst $38

    db $00

    ld d, l
    inc bc
    xor [hl]
    ld b, $4c
    inc e
    halt
    db $fa

    db $17

    sbc h
    db $e4

jr_006_78d1::
    db $fc
    add b

    db $7f

    nop

    db $41

    rrca
    dec bc
    dec c
    rlca
    dec b
    rrca

    db $57

    rra
    rlca
    nop

    db $17

    cp $fa
    rst $28
    nop

    db $57

    cp $f8
    nop

    db $d5

    ret nz

    ldh a, [$fff8]

    db $00

    db $fc
    db $f4
    db $fc
    db $ec
    ei
    rst $28
    rst $38
    db $f6

    db $17

    sbc h
    db $e4
    db $fc
    nop

    db $ff, $54

    ld a, a
    ccf
    rst $18
    db $ea
    or b

    db $00

    push de
    ret nz

    ld c, d
    ld h, b
    dec [hl]
    jr nc, jr_006_7972

    ld e, a

    db $24

    rst $28
    rst $38
    push hl
    ld sp, hl
    xor c
    inc bc

    db $02

    ld d, [hl]
    ld [bc], a
    and h
    inc c
    ld c, b
    jr @-$06

    db $40

    inc bc
    rlca
    inc b
    dec c
    ld c, $1c
    rla

    db $00

    ld a, $35
    dec a
    ld [hl], $6f
    ld d, a
    ld a, a
    ld b, l

    db $40

    ldh [$fff0], a
    db $10
    ret c

    jr c, jr_006_794e

    db $f4

    db $00

    ld e, $f6
    cp $16
    ld a, e
    push af
    rst $38
    pop de

    db $00

    ei
    ld l, l
    and $2e
    call nc, $8ce4
    inc h

    db $02

    ld d, h
    inc b
    xor h
    inc b
    ld d, h
    inc c
    db $fc

    db $00

jr_006_794e::
    ei
    ld l, l
    and $2e
    inc [hl]
    db $e4
    db $cc
    db $e4

    db $02

    ld d, h
    inc b
    xor h
    inc b
    ld d, h
    inc c
    db $fc

    db $00

    rst $38
    add b
    ld a, a
    ld h, b
    cpl
    jr nc, jr_006_79a1

    inc a

    db $02

    daa
    scf
    ld [hl+], a
    jr z, jr_006_79aa

    jr c, jr_006_799e

    db $00

    rst $38
    nop

jr_006_7972::
    ld a, a
    add b
    cp a
    ld [hl], b
    xor l
    ld e, e

    db $42

    cp $aa
    ld b, $5e
    ld c, $fa

    db $7d

    add b
    nop

    db $ff, $00

    rst $38
    add b
    ld a, a
    ld h, b
    ccf

jr_006_7989::
    jr nc, @+$2f

    db $2e

    db $02

    daa
    inc sp
    ld [hl+], a
    jr z, jr_006_79cf

    jr c, jr_006_79c3

    db $00

    rst $38
    ld bc, $01ff
    db $fd
    inc de
    halt
    db $fa

    db $02

jr_006_799e::
    sbc $8e
    xor d

jr_006_79a1::
    ld b, $5e
    ld c, $fa

    db $54

    rst $38
    ld a, a
    ccf
    ld c, d

jr_006_79aa::
    ld h, b

    db $02

    ld b, l
    ld [hl], b
    ld a, [hl-]
    jr nc, jr_006_79c6

    db $10
    rra

    db $00

    rst $18
    ei
    rst $38
    call $fbf7
    xor d
    db $06

    db $02

    ld d, h
    inc b
    xor b
    ld [jr_000_1050], sp

jr_006_79c3::
    db $f0

    db $50

    ld a, a

jr_006_79c6::
    ccf
    call nc, $eaf9
    ld h, b

    db $00

    sub l
    ret nz

    ld l, d

jr_006_79cf::
    ld [hl], b
    dec e
    jr jr_006_79db

    rrca

    db $00

    rst $28
    db $fd
    ei
    rst $28
    cp $e6

jr_006_79db::
    sbc h
    inc a

    db $02

    ld c, b
    jr jr_006_7989

    ld [Call_000_0858], sp
    db $f8

    db $70

    rrca
    dec bc
    dec c
    rlca
    db $06

    db $55

    inc bc
    ccf
    rrca
    nop

    db $50

    ld hl, sp-$10
    ld h, b
    and b
    ldh a, [$ffd0]

    db $55

    ld h, b
    cp $f8
    nop

    db $50

    ld a, a
    ccf
    inc d
    add hl, de
    ld a, [hl+]
    db $20

    db $00

jr_006_7a04::
    ld d, l
    ld l, b
    ld [$fdb8], a
    ld hl, sp+$08
    rrca

    db $f0

    dec b
    ld b, $03
    ld [bc], a

    db $55

    rlca
    rra
    rlca
    nop

    db $70

    ld hl, sp-$50
    ret nc

    ldh a, [$ffd0]

    db $55

    ld h, b
    db $fc
    ldh a, [rP1]

    db $40

    ld a, a
    ld sp, $243f
    ld sp, $604a

    db $02

    push af
    cp b
    ld [$0de8], a
    db $08
    rrca

    db $70

    db $10
    jr c, jr_006_7a5d

    cp $c6

    db $1d

    jr c, jr_006_7a62

    stop

    db $fd

    inc b

    db $fc

    ld c, $0a

    db $00

    rra
    ld de, $e0ff
    rra
    ld de, $0a0e

    db $7f

    inc b

    db $57

    nop
    ldh [rP1], a

    db $ff, $54

    ld a, a
    ccf
    rra
    ld [de], a
    db $18

    db $00

jr_006_7a58::
    dec h
    jr nc, @+$2c

    jr nc, @+$37

jr_006_7a5d::
    jr c, jr_006_7a8f

    ccf

    db $00

    rst $28

jr_006_7a62::
    db $fd
    rst $38
    pop hl
    or $fa
    xor h
    inc c

    db $02

    ld d, h
    inc b
    xor h
    inc d
    ld c, h
    inc e
    db $f4

    db $18, $00, $7f

    nop

    db $40

    rlca
    inc e
    rra
    inc h
    ccf
    ld b, a
    ld a, a

    db $7f

    nop

    db $41

    add b
    ld [hl], b
    ldh a, [rOBP0]
    ld hl, sp-$04

    db $30

    ld e, b
    ld a, a
    ei
    db $f4
    ld l, a
    ld d, e

    db $00

    rst $38

jr_006_7a8f::
    ret nz

    ccf
    jr nc, jr_006_7b12

    ld a, c
    dec bc
    dec c

    db $30

    ld [bc], a
    cp $54
    xor h
    inc e
    db $fc

    db $80

    and h
    db $fc
    inc b
    cp h
    call nz, $7cf4

    db $00

    dec d
    ld e, $2b
    inc hl
    dec [hl]
    jr nz, jr_006_7ad7

    inc h

    db $02

    dec [hl]
    inc l
    ld a, [hl+]
    inc l
    jr c, jr_006_7af4

    cpl

    db $00

    db $db
    xor e
    rst $30
    cp $55
    dec bc
    xor e
    db $01

    db $03

    ld d, [hl]
    ld c, $a8
    jr @+$0a

    db $f8

    db $50

    rra
    rrca
    dec c
    dec bc
    ld c, $0a

    db $15

    ld c, $0a
    ld e, $7f
    rra

    db $70

    ld hl, sp+$58
    ld l, b

jr_006_7ad7::
    jr c, jr_006_7b01

    db $15

    jr c, jr_006_7b04

    inc a
    rst $38
    db $fc

    db $30

    ld e, b
    ld a, a
    ei
    db $f4
    ld l, a
    ld d, e

    db $00

    rst $38
    ret nz

    ccf
    jr nc, @+$81

    ld a, b
    dec bc
    inc c

    db $30

    ld [bc], a
    cp $54
    xor h

jr_006_7af4::
    inc e
    db $fc

    db $80

    and h
    db $fc
    inc b
    db $fc
    inc b
    db $f4
    db $ec

    db $00

    dec d
    rra

jr_006_7b01::
    dec hl
    inc hl
    dec [hl]

jr_006_7b04::
    jr nz, jr_006_7b30

    db $20

    db $00

jr_006_7b08::
    dec a
    jr z, jr_006_7b35

    jr z, jr_006_7b31

    scf
    rra
    rla

    db $00

    ld e, h

jr_006_7b12::
    cp h
    ldh a, [c]
    ld a, [Call_000_0256]
    and d
    ld a, [bc]

    db $00

    ld d, [hl]
    ld a, [bc]
    xor d
    ld a, [de]
    ld [de], a
    or $fc
    db $f4

    db $1e, $00, $74

    nop
    dec b
    dec d
    rla

    db $00

    db $10
    rra
    ld h, $3f
    daa
    dec a

jr_006_7b30::
    cpl

jr_006_7b31::
    db $38

    db $74

    nop
    ld d, b

jr_006_7b35::
    ld d, h
    db $f4

    db $08

    inc b
    db $fc
    inc c
    db $fc
    db $f4
    db $fc
    inc b

    db $20

    cpl
    ccf
    jr nc, jr_006_7bb3

    ld d, a
    ld e, a
    ld h, b

    db $00

    ccf
    jr nc, jr_006_7b5a

    ld [$0d0b], sp
    dec d
    db $1e

    db $00

    db $fc
    inc e
    db $fc
    and h
    db $fc
    inc e
    db $fc
    and h

    db $00

jr_006_7b5a::
    db $fc
    inc b
    db $fc
    inc b
    db $fc
    inc b
    db $f4
    db $ec

    db $00

    cpl
    ld a, [hl-]
    add hl, hl
    inc hl
    dec [hl]
    inc l
    ld [de], a
    add hl, de

    db $40

    rra
    ld e, $14
    dec d
    db $10
    db $11
    rra

    db $00

    ld [$fa1e], a
    ldh a, [c]
    ld a, [hl-]
    ld l, [hl]
    db $e4
    db $cc

    db $40

    db $fc
    xor h
    add h
    ld d, h
    inc d
    inc b
    db $fc

    db $d0

    ld hl, sp+$58
    ld l, b
    jr c, jr_006_7bb2

    db $15

    jr c, jr_006_7bb5

    inc a
    rst $38
    db $fc

    db $7d

    nop
    rrca

    db $00

    ld e, $1f
    inc a
    ld a, $3d
    ld a, $3c
    db $3e

    db $00

    cpl
    jr c, @+$41

    scf
    ld l, a
    ld d, b
    rst $18
    rst $20

    db $00

    ld a, h

jr_006_7ba7::
    inc sp
    xor c
    adc [hl]
    ld e, c
    ld c, $ad
    and [hl]

    db $00

    db $fc
    and h
    db $fc

jr_006_7bb2::
    inc e

jr_006_7bb3::
    db $fc
    inc b

jr_006_7bb5::
    db $fc
    cp h

    db $00

    db $e4
    inc e
    db $e4
    inc e
    db $f4
    inc c
    ld [hl], h
    db $ec

    db $18

    ld a, $3f
    rra
    inc de
    ld a, [hl]
    ld [hl], e

    db $05

    ld a, e
    ld h, a
    ld e, [hl]
    ld a, [hl]
    rst $38
    ccf

    db $00

    ld d, a
    ld [bc], a
    rst $30
    db $fd
    db $ed
    jp hl


    dec h
    rst $20

    db $17

    daa
    and $c3
    rst $38

    db $20

    sbc b
    ld hl, sp-$18
    ld e, b
    ld l, b
    jr z, jr_006_7c1c

    db $15

    cp h
    or h
    sbc h
    cp $f8

    db $00

    cpl
    jr c, jr_006_7c2d

    scf
    ld l, a
    ld d, b
    rst $18
    rst $20

    db $00

    ld a, h
    inc sp
    xor h
    adc e
    ld e, c
    ld c, $ad
    and [hl]

    db $00

    db $fc
    and h
    db $fc

Call_006_7c00::
    inc e
    db $fc
    inc b
    db $fc
    cp h

    db $00

    db $ec
    inc d
    db $e4
    inc e
    db $e4
    inc e
    ld [hl], h
    db $ec

    db $46, $00, $75

    nop
    inc bc
    rlca

    db $58

    ld l, a
    ld a, a
    ld a, [hl]
    ld a, $3d

    db $75

    nop

jr_006_7c1c::
    ldh [$fffe], a

    db $42

    rst $38
    rst $28
    rst $38
    or $ae
    db $de

    db $21

    ld a, l
    ld a, a
    ld a, [hl]
    ccf
    ld a, $0f

    db $54

jr_006_7c2d::
    rlca
    ld bc, $170f
    dec e

    db $00

    db $fc
    ld d, h
    db $fc
    inc b
    db $ec
    inc d
    db $fc
    ld h, h

    db $00

    ret c

    add sp, -$10
    ld [hl], b
    cp $9e
    ld [hl], c
    rst $38

    db $00

    dec h
    ccf
    daa
    ccf
    ld b, a
    ld a, l
    ld c, a
    ld a, l

    db $08

    ld b, a
    ld a, a
    dec h
    ccf
    dec a
    ld a, a
    ld b, a

    db $00

    ld [hl], l
    rst $18
    ld [hl], l
    rst $18
    ld [hl], d
    rst $18
    ld [hl], d
    rst $18

    db $01

    ld [hl], d
    rst $18
    cp $8f
    or $0f
    db $fd

    db $7c

    add b
    ld b, b
    ret nz

    db $01

    ld b, b
    ret nz

    ld b, b
    ret nz

    ldh [$ffa0], a
    db $e0

    db $00

    ld a, [hl]
    ld b, a
    ld a, d
    ld a, a
    inc a
    ccf
    db $08
    rrca

    db $00

    ld [$080f], sp
    rrca
    ld [$100f], sp
    rra

    db $00

    inc b
    db $fc
    ld [bc], a
    cp $02
    cp $02
    db $fe

    db $00

    ld [bc], a
    cp $02
    cp $02
    cp $01
    rst $38

    db $0c

    db $10
    rra
    db $10
    rra
    rlca
    inc b

    db $00

    ld a, [bc]
    dec c
    rrca
    add hl, bc
    dec c
    dec bc
    ld e, $12

    db $0c

    ld bc, $01ff
    rst $38
    cp h
    and h

    db $00

    cp h
    and h
    inc a
    inc h
    inc a
    inc h
    inc a
    inc h

    db $00

    ld a, [de]
    ld d, $1c
    inc d
    inc [hl]
    inc l
    jr c, jr_006_7ce7

    db $07

    jr c, jr_006_7cea

    ld [hl], b
    ld d, b
    rst $38

    db $00

    inc l
    inc [hl]
    inc e
    inc d
    inc e
    inc d
    inc e
    inc d

    db $07

    inc e
    inc d
    inc e
    inc d
    db $fe

    db $50

    nop
    dec de
    inc d
    rra
    dec de
    rra

    db $00

    rrca
    inc c
    rrca
    ld c, $0b
    rrca
    dec bc
    db $0e

    db $50

    ldh [$fffb], a

jr_006_7ce7::
    dec h
    rst $38
    adc [hl]

jr_006_7cea::
    db $fe

    db $00

    sbc $72
    ld a, [$de26]
    cp $fc
    inc h

    db $54

    inc bc
    ld bc, $1f18
    rla

    db $00

    inc e

Call_006_7cfc::
    rla
    inc [hl]
    ccf
    jr z, jr_006_7d40

    jr z, jr_006_7d42

    db $00

    rst $38
    add c
    cp a
    db $fd
    push hl
    rst $38
    cp a
    rst $38

    db $00

    cp d
    rst $00
    ld a, h
    rst $38
    db $10
    rst $38
    ld [hl], b
    rst $38

    db $40

jr_006_7d16::
    ld bc, $0607
    ld a, e
    ld a, [hl]
    db $d3
    cp [hl]

    db $00

    ld [hl], e
    rst $18
    ld [hl], h
    call c, $f838
    jr nc, jr_006_7d16

    db $55

    inc e
    ld a, h
    ld hl, sp-$10

    db $57

    ret nz

    add b
    nop

    db $00

    ld c, b
    ld a, a
    ld c, a
    ld a, a

jr_006_7d34::
    ld b, a
    ld a, a

jr_006_7d36::
    ld b, a
    ld a, a

    db $0c

    ld a, $3f
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc

    db $00

jr_006_7d40::
    ld [hl], b
    rst $38

jr_006_7d42::
    ldh a, [rIE]
    ld hl, sp-$01
    rst $00
    rst $38

    db $00

    nop
    rst $38
    jr c, @+$01

    rst $28
    rst $10
    sub $6d

    db $01

    jr nz, jr_006_7d34

    jr nz, jr_006_7d36

    ld b, b
    ret nz

    add b

    db $ff, $3c

    ld e, $1f
    daa
    ccf

    db $00

    ld hl, $203f
    ccf
    ld hl, $413f
    ld a, a

    db $1c

    cp h
    ld a, h
    db $fc
    ldh a, [c]
    db $fe

    db $00

    jp nz, $82fe

    cp $42
    ld a, [hl]
    ld b, c
    ld a, a

    db $00

    ld [$080f], sp
    rrca
    ld [$180f], sp
    rra

    db $01

    inc e
    rla
    rra
    dec de
    rra
    dec e
    rra

    db $00

    ld b, h
    rst $00
    ld b, h
    rst $00
    ld b, h
    rst $00
    add d
    add e

    db $1f

    add d
    add e
    db $01

    db $5f

    rra
    db $3e

    db $57

    inc a
    ld a, h
    rst $38

    db $5f

    db $01
    nop

    db $f7

    rst $38

    db $50

    inc bc
    add hl, de
    inc d
    inc e
    rra
    rla

    db $00

    inc e
    rla
    inc [hl]
    ccf
    jr z, jr_006_7dee

    ld c, b
    ld a, a

    db $08

    rst $38
    and c
    cp a
    db $dd
    db $e3
    cp a
    rst $38

    db $00

    cp d
    rst $00
    ld a, h
    rst $38
    db $10
    rst $38
    db $10
    rst $38

    db $50

    nop
    jr nc, jr_006_7e16

    ld [hl], b
    ldh a, [$ffd0]

    db $00

    ld [hl], b
    ret nc

    ld e, b
    ld hl, sp+$28
    ld hl, sp+$24
    db $fc

    db $00

    adc b
    rst $38
    sbc b
    rst $38
    sub h
    rst $30
    cp a
    rst $28

    db $04

    ld a, [hl]
    ld l, a
    ld e, $1f
    rrca
    ld c, $0f

    db $00

    db $10
    rst $38
    db $10
    rst $38
    jr c, @+$01

    rst $00
    rst $38

    db $00

    nop

jr_006_7dee::
    rst $38
    jr c, @+$01

    rst $28
    rst $10
    sub $6d

    db $1c

    ld a, $3f
    rra
    daa
    ccf

    db $00

    ld hl, $203f
    ccf
    ld hl, $413f
    ld a, a

    db $1c

    cp [hl]
    ld a, [hl]
    db $fc
    ldh a, [c]
    db $fe

    db $00

    jp nz, $82fe

    cp $42
    ld a, [hl]
    ld b, c
    ld a, a

    db $38, $00, $75

jr_006_7e16::
    nop
    inc bc
    rlca

    db $58

    ld l, a
    ld a, a
    ld a, [hl]
    ccf
    inc a

    db $75

    nop
    ldh [$fffe], a

    db $40

    rst $38
    rst $28
    rst $38
    or $ae
    halt
    db $de

    db $01

    ld a, l
    ld a, [hl]
    ld a, a
    ld a, [hl]
    ccf
    ld a, $0f

    db $54

    rlca
    ld bc, $1a0f
    dec d

    db $00

    db $fc
    call c, Call_000_04fc
    db $ec
    inc d
    db $fc
    inc b

    db $00

    ld hl, sp-$58
    ldh a, [rSVBK]
    db $fc
    inc e
    db $ea
    db $f6

    db $02

    add hl, hl
    ld [hl], $34
    dec hl
    ccf
    inc a
    daa

    db $00

    ccf
    inc h
    inc [hl]
    cpl
    dec a
    ld l, $3b
    dec hl

    db $00

    pop af
    rrca
    rlca
    db $fd
    ei
    rlca
    inc bc
    rst $38

    db $01

    ei
    rlca
    inc b
    rst $38
    rst $30
    ld c, $f9

    db $7f

    nop

    db $41

    add b
    ret nz

    ld b, b
    ldh [$ffa0], a
    db $e0

    db $00

    ld [hl], a
    ld d, h
    ld l, a
    ld l, b
    rrca
    ld [$080f], sp

    db $00

    rrca
    ld [$0c0b], sp
    rlca
    inc b
    dec b
    db $06

    db $00

    db $f4
    inc c
    db $fc
    inc b
    ld a, [$be06]
    ld b, d

    db $00

    sbc $62
    cp $22
    ld [$fa36], a
    db $16

    db $27

    inc bc
    ld [bc], a
    inc bc
    db $01

    db $f0

    inc bc
    ld [bc], a
    inc bc
    ld [bc], a

    db $00

    ldh a, [c]
    ld e, $fc
    inc c
    db $fc
    inc c
    inc a
    db $cc

    db $00

    ld a, h
    adc h
    call nc, $943c
    ld a, h
    xor h
    ld [hl], h

    db $01

    rlca
    inc b
    ld b, $05
    ld b, $05
    rlca

    db $87

    dec b
    dec c
    dec bc
    rra

    db $01

    ld a, h
    db $e4
    ld a, h
    db $e4
    cp h
    and h
    cp h

    db $27

jr_006_7ecc::
    jr z, @+$3a

    jr z, jr_006_7ecc

    db $50

    ccf
    ld a, a
    jp c, $fffd

    push hl

    db $00

    ld [$ffdd], a
    push de
    rst $38
    add d
    rst $38
    add d

    db $5c

    ret nz

    ldh [$ffc0], a
    ld b, b

    db $60

    ret nz

    ld b, b
    ret nz

    ld b, b
    ret nz

    ld b, b

    db $7d

    nop
    rlca

    db $00

    rrca
    ld [$1f10], sp
    scf
    jr c, jr_006_7f32

    inc l

    db $00

    ld a, e
    ld h, [hl]
    cpl
    jr nc, jr_006_7f34

    dec sp
    rst $18
    rst $38

    db $00

    ld a, a
    pop de
    ld a, a
    jp z, $ff3b

    ld [hl], a
    adc h

    db $24

    ret nz

    ld b, b
    ret nz

    add b
    ld [hl], b
    db $f0

    db $00

    add sp, $58
    call nz, $b27c
    adc $76
    adc d

    db $00

    ld a, a
    ld b, h
    cp $8f
    di
    sub d
    ei
    adc d

    db $00

    ld e, [hl]
    ld h, a
    ccf
    ld sp, $0d0b
    ld b, $07

    db $00

    ld [hl], a
    adc b
    nop
    rst $38
    ld [hl], a

jr_006_7f32::
    adc b
    ld [hl], a

jr_006_7f34::
    adc b

    db $00

    nop
    rst $38
    ld [hl], a
    adc b
    ld [hl], a
    adc b
    nop
    rst $38

    db $00

    ld h, [hl]
    sbc d
    ld e, $fe
    ld a, h
    sub h
    ld a, h
    sub h

    db $00

    inc e
    db $f4
    ld a, h
    sub h
    ld a, h
    sub h
    inc e
    db $f4

    db $05

    dec b
    ld b, $05
    rlca
    inc bc
    db $01

    db $f2

    ld [bc], a
    inc bc
    ld [bc], a

    db $02

    ld [hl], a
    adc b
    xor a
    rst $18
    ld [hl], b
    rst $38
    nop

    db $00

    rst $38
    nop
    rst $38
    nop
    ei
    inc b
    push af
    db $0e

    db $04

    ld a, [hl]
    sub d
    ld d, [hl]
    cp d
    db $fc
    ret nc

    db $30

    db $00

jr_006_7f75::
    ldh a, [rNR10]
    ldh a, [rNR10]
    add sp, $18
    ld hl, sp+$08

    db $00

    rst $30
    inc d
    rst $30
    inc d
    rst $30
    inc d
    push de
    db $36

    db $00

    db $e3
    ld [hl+], a
    db $e3
    ld [hl+], a
    and d
    ld h, e
    pop bc
    ld b, c

    db $00

    ldh a, [rNR10]
    ldh a, [rNR10]
    ldh a, [rNR10]
    ldh a, [rNR10]

    db $00

    ldh a, [rNR10]
    add sp, $18
    ld hl, sp+$08
    ld hl, sp+$08

    db $09

    pop bc
    ld b, c
    pop bc
    ld b, c
    pop bc
    add b

    db $f7

    rst $38

    db $00

    ld hl, sp+$08
    ld hl, sp+$08
    ld a, b
    adc b
    db $f4
    adc h

    db $17

    db $fc
    add h
    db $fc
    cp $ff
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
