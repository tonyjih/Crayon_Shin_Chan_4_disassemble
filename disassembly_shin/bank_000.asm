; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $000", ROM0[$0]

RST_00::
    jr jr_000_0061

    rst $38

    db $ff

    rst $38
    rst $38
    rst $38
    rst $38

RST_08::
    ret


    rst $38
    rst $38
    rst $38
    rst $38
    rst $38

Call_000_000e:
    rst $38
    rst $38

RST_10::
    ret


    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38

RST_18::
    ret


    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38

RST_20::
    jr jr_000_006b

Call_000_0022:
Jump_000_0022:
jr_000_0022:
    ld [hl+], a
    dec b
    jr nz, jr_000_0022

    ret


Jump_000_0027:
    rst $38

RST_28::
    bit 7, a
    ret z

    cpl
    inc a
    ret


    rst $38
    rst $38

RST_30::
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ret


    rst $38

RST_38::
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ret


Call_000_003f:
    rst $38

VBlankInterrupt::
    call Call_000_01dd

Jump_000_0043:
    reti


    rst $38
    rst $38
    rst $38
    rst $38

LCDCInterrupt::
    call Call_000_024a
    reti


    rst $38
    rst $38
    rst $38
    rst $38

TimerOverflowInterrupt::
    reti


    rst $38
    rst $38
    rst $38
    rst $38

Call_000_0055:
Jump_000_0055:
    rst $38
    rst $38
    rst $38

SerialTransferCompleteInterrupt::
    reti


    rst $38
    rst $38
    rst $38
    rst $38

Call_000_005d:
    rst $38
    rst $38
    rst $38

JoypadTransitionInterrupt::
    reti


jr_000_0061:
    add a
    pop hl
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl


jr_000_006b:
    ld e, a
    ld d, $00
    add hl, de
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ret


bzero::
    xor a

Call_000_0075:
    ld [hl+], a
    dec bc
    ld a, c
    or b
    jr nz, bzero

    ret


    rst $38
    rst $38

Jump_000_007e:
    rst $38
    rst $38

Call_000_0080:
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    sub d
    ret nz

    ld a, l
    sub e
    ret


Call_000_0089:
Jump_000_0089:
    ld a, [$4000]
    push af
    ld a, h
    ld [$2100], a
    ld a, $01
    add l

Call_000_0094:
    ld l, a
    ld a, $40
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call Call_000_00a3
    pop af
    ld [$2100], a
    ret


Call_000_00a3:
    jp hl


Call_000_00a4:
    ld c, $80
    ld b, $0a
    ld hl, $00b2

jr_000_00ab:
    ld a, [hl+]
    ldh [c], a
    inc c
    dec b
    jr nz, jr_000_00ab

    ret


    db $3e, $c0, $e0, $46, $3e, $28, $3d, $20, $fd, $c9

Call_000_00bc:
    ld a, $20
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0f
    swap a
    ld b, a
    ld a, $10
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0f
    or b
    ld c, a
    ldh a, [$ff8c]
    xor c
    and c
    ldh [$ff8b], a
    ld a, c
    ldh [$ff8a], a
    ldh [$ff8c], a
    ld a, $30
    ldh [rP1], a
    ret


Call_000_00f7:
    ld a, [$c0a2]
    ldh [rLCDC], a
    ret


    rst $38
    rst $38

Jump_000_00ff:
    rst $38

Boot::
    nop
    jp Jump_000_0150


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
    db "GB KUREYON SHIN4"

HeaderNewLicenseeCode::
    db $42, $32

HeaderSGBFlag::
    db $03

HeaderCartridgeType::
    db $01

HeaderROMSize::
    db $02

HeaderRAMSize::
    db $00

HeaderDestinationCode::
    db $00

HeaderOldLicenseeCode::
    db $33

HeaderMaskROMVersion::
    db $00

HeaderComplementCheck::
    db $de

HeaderGlobalChecksum::
    db $fb, $dc

Jump_000_0150:
    ld sp, $dff0
    ld a, $01
    ld [$dff9], a
    ld [$dffa], a
    ld [$dffb], a
    xor a
    ld [$dffe], a
    ld [$dffd], a
    ld [$dffc], a
    xor a
    ld [$dff8], a
    call Call_000_040f
    jr nc, jr_000_017c

    ld a, $ff
    ld [$dff8], a
    ld hl, $030a
    call Call_000_0089

Jump_000_017c:
jr_000_017c:
    di
    xor a
    ldh [rIE], a
    ld sp, $dff0
    ld hl, $ff80
    ld bc, $007f
    call bzero
    call Call_000_02d6
    ld hl, $8000
    ld bc, $5f80
    call bzero
    call Call_000_00a4
    call Call_000_00bc
    call Call_000_0f0d

jr_000_01a1:
    di
    call Call_000_02d6
    xor a
    ld [$d933], a
    call Call_000_079b
    ld hl, $fe00
    ld bc, $00a0
    call bzero
    ld hl, $c000
    ld bc, $00a0
    call bzero
    call Call_000_0986
    xor a
    ldh [$ff9c], a
    call Call_000_00f7
    ldh a, [$ff8f]
    or a
    jr nz, jr_000_01a1

    call Call_000_05c8
    call Call_000_03fe
    call Call_000_079b
    ei

jr_000_01d6:
    ldh a, [$ff8f]
    or a
    jr z, jr_000_01d6

    jr jr_000_01a1

Call_000_01dd:
    push af
    push bc
    push de
    push hl
    ldh a, [$ff8d]
    and a
    jr nz, jr_000_0230

    inc a
    ldh [$ff8d], a
    call $ff80
    ld de, $c100
    call Call_000_0347
    call Call_000_05c8
    call Call_000_05ea
    xor a
    ld [$c100], a

Call_000_01fc:
    ldh [$ff99], a
    ldh [$ff9b], a
    ld a, [$4000]
    push af
    ld a, $07
    ld [$2100], a
    call Call_000_0f9d
    pop af
    ld [$2100], a
    ei
    call Call_000_04f2
    call Call_000_00bc
    call Call_000_090b
    ldh a, [$ff9b]
    ldh [$ff9c], a
    call Call_000_05d9
    ldh a, [$ff8a]
    cp $0f
    jp z, Jump_000_017c

    xor a
    ldh [$ff8d], a
    pop hl
    pop de
    pop bc
    pop af
    ret


jr_000_0230:
    ld a, [$4000]
    push af
    ld a, $07
    ld [$2100], a
    call Call_000_0f9d
    pop af
    ld [$2100], a
    ldh a, [$ff8d]
    dec a
    ldh [$ff8d], a
    pop hl
    pop de
    pop bc
    pop af
    ret


Call_000_024a:
    push af
    push bc
    push de
    push hl
    call Call_000_0256
    pop hl
    pop de
    pop bc
    pop af
    ret


Call_000_0256:
    ret


    ld a, $03
    ldh [$ff9d], a
    jr jr_000_026c

Jump_000_025d:
    ld a, $02
    ldh [$ff9d], a
    jr jr_000_026c

    ld a, $01
    ldh [$ff9d], a
    jr jr_000_026c

Call_000_0269:
Jump_000_0269:
    xor a
    ldh [$ff9d], a

Call_000_026c:
Jump_000_026c:
jr_000_026c:
    ld a, $10
    add b
    ld b, a
    ld a, $08
    add c
    ld c, a
    ldh a, [$ff9b]
    cp $a0
    ret z

    ld e, a
    ld d, $c0

jr_000_027c:
    ld a, [hl+]
    cp $80
    jr z, jr_000_029c

    add b
    ld [de], a
    push de
    ld d, a
    ldh a, [$ff9a]
    cp d
    pop de
    jr c, jr_000_02a0

    inc e
    call Call_000_02a5
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    call Call_000_02b7
    inc e
    ld a, e
    cp $a0
    jr nz, jr_000_027c

jr_000_029c:
    ld a, e
    ldh [$ff9b], a
    ret


jr_000_02a0:
    inc hl
    inc hl
    inc hl
    jr jr_000_027c

Call_000_02a5:
    ldh a, [$ff9d]
    bit 0, a
    jr nz, jr_000_02af

    ld a, [hl+]
    add c
    ld [de], a
    ret


jr_000_02af:
    ld a, [hl+]
    cpl
    inc a
    sub $08
    add c
    ld [de], a
    ret


Call_000_02b7:
    ldh a, [$ff9d]
    or a
    jr z, jr_000_02d3

    dec a
    jr z, jr_000_02ce

    dec a
    jr z, jr_000_02c9

    ld a, [hl+]
    xor $20
    set 7, a
    ld [de], a
    ret


jr_000_02c9:
    ld a, [hl+]
    set 7, a
    ld [de], a
    ret


jr_000_02ce:
    ld a, [hl+]
    xor $20
    ld [de], a
    ret


jr_000_02d3:
    ld a, [hl+]
    ld [de], a
    ret


Call_000_02d6:
    ld hl, $ff40
    bit 7, [hl]
    ret z

    ldh a, [rIE]
    push af
    res 0, a
    ldh [rIE], a

jr_000_02e3:
    ldh a, [rLY]
    cp $91
    jr nz, jr_000_02e3

    res 7, [hl]
    pop af
    ldh [rIE], a
    ret


Jump_000_02ef:
    xor a
    ldh [rIF], a
    ld a, [$c0a0]
    ldh [rIE], a
    ret


Call_000_02f8:
    ld hl, $9bff

jr_000_02fb:
    ld bc, $0400

jr_000_02fe:
    ld a, $00
    ld [hl-], a
    dec bc
    ld a, b
    or c
    jr nz, jr_000_02fe

    ret


Call_000_0307:
    ld hl, $9fff
    jr jr_000_02fb

    ld hl, $9bff
    ld bc, $0400

jr_000_0312:
    ldh a, [$ffc9]
    ld [hl-], a
    dec bc
    ld a, b
    or c
    jr nz, jr_000_0312

    ret


jr_000_031b:
    inc de
    ld h, a
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    inc de
    ld c, a
    and $3f
    ld b, a
    ld a, c
    rlca
    rlca
    and $03
    jr z, jr_000_0341

    dec a
    jr z, jr_000_034c

    dec a
    jr z, jr_000_0354

jr_000_0333:
    ld a, [de]
    ld [hl], a
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, jr_000_0333

    inc de
    jr jr_000_0347

jr_000_0341:
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_000_0341

Call_000_0347:
jr_000_0347:
    ld a, [de]
    or a
    jr nz, jr_000_031b

    ret


jr_000_034c:
    ld a, [de]
    inc de

jr_000_034e:
    ld [hl+], a
    dec b
    jr nz, jr_000_034e

    jr jr_000_0347

jr_000_0354:
    ld a, [de]
    ld [hl], a
    inc de
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, jr_000_0354

    jr jr_000_0347

Jump_000_0362:
jr_000_0362:
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_000_0362

    ret


memcpy::
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, memcpy

    ret


LoadGameGfx::
    push hl
    ld l, a
    ld a, [$4000]
    ld h, a
    ld a, l
    ld [$2100], a
    ld a, h
    pop hl
    push af
    call memcpy
    pop af
    ld [$2100], a
    ret


Call_000_0387:
Jump_000_0387:
    push hl
    ld l, a
    ld a, [$4000]
    ld h, a
    ld a, l
    push hl
    ld [$2100], a
    pop hl
    ld a, h
    pop hl
    push af
    call Call_000_039e
    pop af
    ld [$2100], a
    ret


Call_000_039e:
jr_000_039e:
    ld a, [hl+]
    cp $ff
    jr z, jr_000_03ab

    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, jr_000_039e

    ret


jr_000_03ab:
    ld a, [hl+]
    ldh [$ffc9], a
    ld a, [hl+]
    push hl
    ld h, a
    ldh a, [$ffc9]
    ld l, a

jr_000_03b4:
    ld a, h
    ld [de], a
    inc de
    dec l
    jr z, jr_000_03c1

    dec bc
    ld a, b
    or c
    jr nz, jr_000_03b4

    pop hl
    ret


jr_000_03c1:
    pop hl
    dec bc
    ld a, b
    or c
    jr nz, jr_000_039e

    ret


Call_000_03c8:
    ld a, [hl]
    and $07
    ret z

    ld b, a
    ld c, $00

jr_000_03cf:
    push bc
    ld a, $00
    ldh [c], a
    ld a, $30
    ldh [c], a
    ld b, $10

jr_000_03d8:
    ld e, $08
    ld a, [hl+]
    ld d, a

jr_000_03dc:
    bit 0, d
    ld a, $10
    jr nz, jr_000_03e4

    ld a, $20

jr_000_03e4:
    ldh [c], a
    ld a, $30
    ldh [c], a
    rr d
    dec e
    jr nz, jr_000_03dc

    dec b
    jr nz, jr_000_03d8

    ld a, $20
    ldh [c], a
    ld a, $30
    ldh [c], a
    pop bc
    dec b
    ret z

    call Call_000_0403
    jr jr_000_03cf

Call_000_03fe:
    ld a, [$dff8]
    or a
    ret z

Call_000_0403:
    ld de, $1b58

jr_000_0406:
    nop
    nop
    nop
    dec de
    ld a, d
    or e
    jr nz, jr_000_0406

    ret


Call_000_040f:
    ld hl, $0480
    call Call_000_03c8
    call Call_000_0403
    ldh a, [rP1]
    and $03
    cp $03
    jr nz, jr_000_0465

    ld a, $20
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    call Call_000_0403
    ld a, $30
    ldh [rP1], a
    call Call_000_0403
    ld a, $10
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    call Call_000_0403
    ld a, $30
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    call Call_000_0403
    ldh a, [rP1]
    and $03
    cp $03
    jr nz, jr_000_0465

    ld hl, $0470
    call Call_000_03c8
    call Call_000_0403
    sub a
    ret


jr_000_0465:
    ld hl, $0470
    call Call_000_03c8
    call Call_000_0403
    scf
    ret


    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Call_000_0490:
    push de
    push hl
    call Call_000_02d6
    pop hl
    ld a, $e4
    ldh [rBGP], a
    ld de, $8800
    call memcpy

jr_000_04a0:
    ld hl, $9800
    ld de, $000c
    ld a, $80
    ld c, $0d

jr_000_04aa:
    ld b, $14

jr_000_04ac:
    ld [hl+], a
    inc a
    dec b
    jr nz, jr_000_04ac

    add hl, de
    dec c
    jr nz, jr_000_04aa

    ld a, $81
    ldh [rLCDC], a
    call Call_000_0403
    pop hl
    call Call_000_03c8
    call Call_000_0403

Jump_000_04c3:
    ret


    ldh [$ffc9], a
    push de

Call_000_04c7:
    call Call_000_02d6
    ld a, $e4
    ldh [rBGP], a
    ld de, $8800
    ld bc, $1000
    ldh a, [$ffc9]
    call LoadGameGfx
    jr jr_000_04a0

    ld hl, $ffc9
    ld bc, $0014
    jp bzero


Call_000_04e4:
    ld hl, $c100
    ldh a, [$ff99]
    rst $38
    ret


Call_000_04eb:
    ld de, $c100
    ldh a, [$ff99]
    rst $30
    ret


Call_000_04f2:
    ldh a, [$ff9e]
    ld b, a
    add a
    add a
    add b
    add $11
    ldh [$ff9e], a

Call_000_04fc:
    ret


Call_000_04fd:
    set 7, e
    jr jr_000_0501

Call_000_0501:
Jump_000_0501:
jr_000_0501:
    call Call_000_04e4
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, e
    set 6, a
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ld [hl], $00
    ldh a, [$ff99]
    add $04
    ldh [$ff99], a
    ret


Call_000_0517:
Jump_000_0517:
    push de
    ld d, a
    ld e, $01
    ld b, h
    ld c, l
    call Call_000_0501
    pop de
    ret


Call_000_0522:
Jump_000_0522:
    ld a, [$4000]
    push af
    ld a, d
    ld [$2100], a
    call Call_000_055a
    pop af
    ld [$2100], a
    ret


Jump_000_0532:
    ld a, [$4000]
    push af
    ld a, d
    ld [$2100], a

Jump_000_053a:
    call Call_000_0542
    pop af
    ld [$2100], a
    ret


Call_000_0542:
    ld a, c
    ld b, h
    ld c, l
    ld h, $00
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, bc
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $9000
    jr jr_000_0570

Call_000_055a:
    ld a, c
    ld b, h
    ld c, l
    ld h, $00
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, bc
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $8000

jr_000_0570:
    add hl, de
    ld d, h
    ld e, l
    call Call_000_04e4
    ld a, d
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    pop de
    ld b, $10

jr_000_0580:
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_000_0580

    ld [hl], $00
    ldh a, [$ff99]
    add $13
    ldh [$ff99], a
    ret


    push de
    ld d, $10
    ld e, a
    xor a

jr_000_0594:
    add hl, hl
    rla
    jr c, jr_000_059b

    cp e
    jr c, jr_000_059d

jr_000_059b:
    sub e
    inc l

jr_000_059d:
    dec d
    jr nz, jr_000_0594

    pop de
    ret


Call_000_05a2:
    ld de, $0000

jr_000_05a5:
    ld e, a
    sub $0a
    jr c, jr_000_05ad

    inc d
    jr jr_000_05a5

jr_000_05ad:
    ld a, e
    ldh [$ffc9], a
    ld a, d
    ldh [$ffca], a
    ret


Call_000_05b4:
    push de
    ld hl, $0000
    ld b, l
    ld d, $08

jr_000_05bb:
    rrca
    jr nc, jr_000_05bf

    add hl, bc

jr_000_05bf:
    sla c
    rl b
    dec d
    jr nz, jr_000_05bb

    pop de
    ret


Call_000_05c8:
    ldh a, [$ff90]
    ldh [rSCY], a
    ldh a, [$ff92]
    ldh [rSCX], a
    ldh a, [$ff94]
    ldh [rWY], a
    ldh a, [$ff95]
    ldh [rWX], a
    ret


Call_000_05d9:
    ld h, $c0
    ldh a, [$ff9b]
    ld l, a
    sub $a0
    ret nc

    cpl
    inc a
    ld b, a
    xor a

jr_000_05e5:
    ld [hl+], a
    dec b
    jr nz, jr_000_05e5

    ret


Call_000_05ea:
    ld hl, $c0a3
    ld a, [hl+]
    ldh [rBGP], a
    ld a, [hl+]
    ldh [rOBP0], a
    ld a, [hl]
    ldh [rOBP1], a
    ret


Call_000_05f7:
Jump_000_05f7:
jr_000_05f7:
    call Call_000_05fe
    dec c
    jr nz, jr_000_05f7

    ret


Call_000_05fe:
    push bc
    push hl

jr_000_0600:
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, jr_000_0600

    pop hl
    ld bc, $0020
    add hl, bc
    pop bc
    ret


    push hl
    ld b, $10
    ld hl, $da80

jr_000_0613:
    ld [hl+], a
    inc a
    dec b
    jr nz, jr_000_0613

    pop hl
    ld de, $da80
    ld bc, $0404

Call_000_061f:
Jump_000_061f:
    ld a, l
    ldh [$ffc5], a
    ld a, h
    ldh [$ffc6], a
    call Call_000_04e4

jr_000_0628:
    ldh a, [$ffc6]
    ld [hl+], a
    ldh a, [$ffc5]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    push bc

jr_000_0631:
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, jr_000_0631

    pop bc
    ldh a, [$ff99]
    add b
    add $03
    ldh [$ff99], a
    ldh a, [$ffc5]
    add $20
    ldh [$ffc5], a
    ldh a, [$ffc6]
    adc $00
    ldh [$ffc6], a
    dec c
    jr nz, jr_000_0628

    ld [hl], $00
    ret


Call_000_0651:
    ld a, [$4000]
    push af
    ldh a, [$ffc9]
    ld [$2100], a
    call Call_000_05f7
    pop af
    ld [$2100], a
    ret


    ld a, [$4000]
    push af
    ldh a, [$ffc9]
    ld [$2100], a
    call Call_000_061f
    pop af
    ld [$2100], a
    ret


Call_000_0673:
jr_000_0673:
    ld a, [de]
    inc de
    cp $ff
    ret z

    cp $45
    jr z, jr_000_0683

    cp $43
    jr z, jr_000_0683

    ld [hl+], a
    jr jr_000_0673

jr_000_0683:
    ld bc, $ffe0
    add hl, bc
    ld [hl], a
    ld bc, $0020
    add hl, bc
    jr jr_000_0673

Jump_000_068e:
    push hl
    push de
    call Call_000_06bc
    pop de
    pop hl
    push hl
    call Call_000_04e4
    ld a, b
    pop bc
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    ld [hl+], a
    add $03
    ld b, a

jr_000_06a3:
    ld a, [de]
    cp $ff
    jr z, jr_000_06b4

    inc de
    cp $45
    jr z, jr_000_06a3

    cp $43
    jr z, jr_000_06a3

    ld [hl+], a
    jr jr_000_06a3

jr_000_06b4:
    ld [hl], $00
    ldh a, [$ff99]
    add b
    ldh [$ff99], a
    ret


Call_000_06bc:
    ld bc, $ffe0
    add hl, bc
    ld b, $00

jr_000_06c2:
    ld a, [de]
    cp $ff
    ret z

    inc de
    cp $45
    jr z, jr_000_06d3

    cp $43
    jr z, jr_000_06d3

    inc b
    inc hl
    jr jr_000_06c2

jr_000_06d3:
    push hl
    push bc
    call Call_000_0517
    pop bc
    pop hl
    jr jr_000_06c2

    ld a, [$4000]
    push af
    ld a, b
    ld [$2100], a
    ld c, [hl]
    pop af
    ld [$2100], a
    ret


Jump_000_06ea:
jr_000_06ea:
    ld a, [hl]
    cp $ff
    ret z

    push hl
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    push bc
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    push bc
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    ld a, [hl+]

Call_000_06fe:
    pop de
    pop hl
    call LoadGameGfx
    pop hl
    ld a, $07
    rst $38
    jr jr_000_06ea

Call_000_0709:
    ld hl, $030c
    call Call_000_0089
    ret


Call_000_0710:
    ldh [$ffc9], a
    ld hl, $0300
    call Call_000_0089
    ret


Call_000_0719:
    ld hl, $0302
    call Call_000_0089
    ret


Call_000_0720:
    ld a, [$4000]
    push af
    xor a
    ldh [$ffce], a
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    ld h, a
    inc de
    ld a, [de]
    and $7f
    jr nz, jr_000_074c

    ld a, [hl]
    cp $fe
    jr nz, jr_000_073d

    ld a, $01
    ldh [$ffce], a
    jr jr_000_0757

jr_000_073d:
    ld a, [hl+]
    cp $ff
    jr nz, jr_000_074a

    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    ld [de], a
    inc hl
    jr jr_000_074c

jr_000_074a:
    ld [de], a
    inc hl

jr_000_074c:
    dec de
    ld a, h
    ld [de], a
    dec de
    ld a, l
    ld [de], a
    inc de
    inc de
    ld a, [de]
    dec a
    ld [de], a

jr_000_0757:
    dec hl
    ld a, [de]
    bit 7, a
    ld a, $00
    jr z, jr_000_0761

    ld a, $01

jr_000_0761:
    ldh [$ff9d], a
    push bc
    ld c, [hl]
    ld b, $00
    sla c
    rl b
    ld a, $03
    ld [$2100], a
    ld hl, $4005
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    pop bc
    call Call_000_026c
    pop af
    ld [$2100], a
    ldh a, [$ffce]
    ret


Call_000_0785:
    ld a, $02
    ldh [$ff9d], a
    jr jr_000_0794

    ld a, $01
    ldh [$ff9d], a
    jr jr_000_0794

Call_000_0791:
    xor a
    ldh [$ff9d], a

Call_000_0794:
jr_000_0794:
    ld hl, $0306
    call Call_000_0089
    ret


Call_000_079b:
    ld hl, $0308
    call Call_000_0089
    ret


LoadMainGfx::
    push hl
    ld l, a
    ld a, [$4000]
    ld h, a
    ld a, l
    ld [$2100], a
    ld a, h
    pop hl
    push af
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    dec de

jr_000_07b4:
    push bc
    ld b, $08
    ld c, [hl]
    inc hl
    ld a, [de]

jr_000_07ba:
    sla c
    jr c, jr_000_07bf

    ld a, [hl+]

jr_000_07bf:
    inc de
    ld [de], a
    dec b
    jr nz, jr_000_07ba

    pop bc
    dec bc
    ld a, c
    or b
    jr nz, jr_000_07b4

    pop af
    ld [$2100], a
    ret


Call_000_07cf:
    ld a, [$d95c]
    or a
    ret z

    ld b, a
    ld a, $40
    sub b
    ld b, a
    ld a, [$d95c]
    cp $03
    jr nz, jr_000_0803

    ld hl, $087d
    ld a, [$d933]
    cp $14
    jr z, jr_000_07f1

    cp $18
    jr nz, jr_000_0803

    ld hl, $088d

jr_000_07f1:
    push bc
    call Call_000_03c8
    pop bc
    jr jr_000_0803

Call_000_07f8:
    ld a, [$d95c]
    or a
    ret z

    cp $3e
    call z, Call_000_0864
    ld b, a

jr_000_0803:
    ld a, [$d95c]
    dec a
    ld [$d95c], a
    ld a, b
    cp $40
    ret nc

    ld a, [$dff8]
    or a
    jr nz, jr_000_0839

    ld a, b
    swap a
    and $0f
    ld hl, $089d
    rst $38
    ld a, b
    and $0f
    cp $07
    jr c, jr_000_0829

    bit 0, a
    jr z, jr_000_0829

    inc hl

jr_000_0829:
    ld a, [hl]
    ld [$c0a3], a
    ld [$c0a5], a
    ld bc, $0005
    add hl, bc
    ld a, [hl]
    ld [$c0a4], a
    ret


jr_000_0839:
    ld hl, $08a7
    ld a, b
    srl a
    srl a
    srl a
    rst $38
    ld a, [hl]
    ld [$c0a3], a
    ld [$c0a4], a
    ld [$c0a5], a
    ld a, [$d933]
    cp $18
    ret nz

    ld hl, $08af
    ld a, b

Call_000_0858:
    srl a
    srl a
    srl a
    rst $38
    ld a, [hl]
    ld [$c0a4], a
    ret


Call_000_0864:
    push af
    ld hl, $086d
    call Call_000_03c8
    pop af
    ret


    db $51, $03, $00, $03, $00, $03, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $51, $30, $00, $31, $00, $32, $00, $33, $00, $00, $00, $00, $00, $00, $00, $00
    db $51, $39, $00, $39, $00, $39, $00, $39, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $40, $90, $e4, $00, $00, $40, $90, $d0

    nop
    nop
    ld b, b
    ld d, b
    sub h
    sub h
    db $e4
    db $e4
    nop
    nop
    ld b, b
    ld b, b
    sub b
    sub b
    ret nc

    ret nc

Call_000_08b7:
    push bc
    push hl
    ldh a, [$ffc9]
    ld e, a
    ld a, [$0902]
    and e
    ld [hl+], a
    ld a, [$0903]
    and e

jr_000_08c5:
    ld [hl+], a
    dec b
    jr nz, jr_000_08c5

    ld a, [$0904]
    and e
    ld [hl+], a
    pop hl
    ld a, $20
    rst $38
    pop bc
    ld d, b

jr_000_08d4:
    ld b, d
    push hl
    ld a, [$0905]
    and e
    ld [hl+], a
    ld a, [$0906]
    and e

jr_000_08df:
    ld [hl+], a
    dec b
    jr nz, jr_000_08df

    ld a, [$0907]
    and e
    ld [hl+], a
    pop hl
    ld a, $20
    rst $38
    dec c
    jr nz, jr_000_08d4

    ld a, [$0908]
    and e
    ld [hl+], a
    ld a, [$0909]
    and e

jr_000_08f8:
    ld [hl+], a
    dec d
    jr nz, jr_000_08f8

    ld a, [$090a]
    and e
    ld [hl+], a
    ret


    db $f9, $f2, $f8, $f3, $00, $f4, $f7, $f5, $f6

Call_000_090b:
    ldh a, [$ff8e]
    rst $00

    db $20, $09

    ld h, $09

    db $29, $09, $2f, $09, $35, $09, $3b, $09, $41, $09, $7d, $09

    add b
    add hl, bc

    ld hl, $0202
    jp Jump_000_0089


    jp Jump_000_1716


    ld hl, $0100
    jp Jump_000_0089


    ld hl, $0206
    jp Jump_000_0089


    ld hl, $020e
    jp Jump_000_0089


    ld hl, $0212
    jp Jump_000_0089


    ld a, $93
    ld [$c0a3], a
    ldh a, [$ff9c]
    ldh [$ff9b], a
    ldh a, [$ff8b]
    bit 3, a
    ret z

    ld a, $e4
    ld [$c0a3], a
    ld a, $02
    ldh [$ff8e], a
    ld a, $80
    ld [$dd9f], a
    ld a, $5e
    call Call_000_0f38
    ret


Call_000_0963:
    call Call_000_0f0d
    ldh a, [$ffbb]
    cp $04
    ld a, $0c
    jp z, Jump_000_0f32

    ldh a, [$ff9f]
    cp $03
    ld a, $04
    jp c, Jump_000_0f32

    ld a, $08
    jp Jump_000_0f32


    jp Jump_000_09c9


    ld hl, HeaderLogo
    jp Jump_000_0089


Call_000_0986:
    ldh a, [$ff8e]
    rst $00

    db $9b, $09

    and c
    add hl, bc

    db $a4, $09, $aa, $09, $b0, $09, $b6, $09

    cp h
    add hl, bc

    db $bd, $09

    push af
    add hl, bc

    ld hl, $0200
    jp Jump_000_0089


    jp LoadDebugMenu


    ld hl, $0102
    jp Jump_000_0089


    ld hl, $0204
    jp Jump_000_0089


    ld hl, $020c
    jp Jump_000_0089


    ld hl, $0210
    jp Jump_000_0089


    ret


    ld hl, $0102
    call Call_000_0089
    ld a, $18
    ld [$d933], a
    ret


Jump_000_09c9:
    ld a, [$c0bd]
    or a
    jr z, jr_000_09e0

    call Call_000_07cf
    ld a, [$d95c]
    or a
    ret nz

    xor a
    ld [$c0bd], a
    ld a, $02
    ldh [$ff8e], a
    ret


jr_000_09e0:
    call Call_000_07f8
    ld a, [$d95c]
    or a
    ret nz

    ld a, $40
    ld [$d95c], a
    ld a, $01
    ld [$c0bd], a
    ldh [$ff8f], a
    ret


    ld a, $04
    ldh [$ff9f], a
    ld hl, $0102
    call Call_000_0089
    ld hl, $0106
    jp Jump_000_0089


jr_000_0a05:
    ldh a, [$ff92]
    ld b, a
    ldh a, [$ff90]
    ld c, a
    ldh a, [$ffb1]
    sub b
    ldh [$ffa5], a
    ldh a, [$ffae]
    sub c
    ldh [$ffa4], a
    ret


Call_000_0a16:
    ldh a, [$ff96]
    cp $ff
    jr z, jr_000_0a05

    xor a
    ldh [$ff96], a
    ldh a, [$ffa4]
    ld c, a
    ldh a, [$ff90]
    add c
    ld c, a
    ldh a, [$ff91]
    adc $00
    ld b, a
    ld hl, $ffae
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call Call_000_0b5b
    ldh a, [$ffa5]
    ld c, a
    ldh a, [$ff92]
    add c
    ld c, a
    ldh a, [$ff93]
    adc $00
    ld b, a
    ld hl, $ffb1
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call Call_000_0a80
    ldh a, [$ff96]
    rlca
    ret nc

    ld a, [$4000]
    push af
    ld a, $04
    ld [$2100], a
    ldh a, [$ff96]
    bit 6, a
    call nz, Call_000_0ca1
    ldh a, [$ff96]
    bit 5, a
    call nz, Call_000_0c00
    pop af
    ld [$2100], a
    ret


Call_000_0a69:
Jump_000_0a69:
    ld a, [$4000]
    push af
    ld a, $04
    ld [$2100], a
    ldh a, [$ff90]
    ld e, a
    ldh a, [$ff91]
    ld d, a
    call Call_000_0c10
    pop af
    ld [$2100], a
    ret


Call_000_0a80:
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc b
    ld h, a
    jp c, Jump_000_0b0f

    ld a, l
    or a
    ret z

    ld a, [$c409]
    ld b, a
    ld a, [$c40c]
    ld c, a
    ldh a, [$ffa5]
    add l
    ldh [$ffa5], a
    cp b
    ret c

    ret z

    ldh a, [$ff96]
    or $c0
    res 0, a
    ldh [$ff96], a
    ld a, l
    cp c
    jr c, jr_000_0aa9

    ld a, c

jr_000_0aa9:
    ld b, a
    ld hl, $c418
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $ff92
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    dec hl
    call Call_000_0080
    jr nc, jr_000_0ac6

    ld a, [$c409]
    ldh [$ffa5], a
    ret


jr_000_0ac6:
    ld hl, $c418
    ld a, [hl+]
    ldh [$ff92], a
    ld a, [hl-]
    ldh [$ff93], a
    ldh a, [$ffb1]
    sub [hl]
    ldh [$ffa5], a
    ldh a, [$ff9f]
    cp $02
    jr z, jr_000_0b07

    cp $01
    jr nz, jr_000_0ae4

    ld a, [$c0b4]
    cp $02
    ret nz

jr_000_0ae4:
    ldh a, [$ffaa]
    or a
    ret nz

jr_000_0ae8:
    ldh a, [$ff96]
    cp $ff
    ret z

    ld a, $ff
    ldh [$ff96], a
    ld a, $ff
    ld [$c0b5], a
    ld hl, $c410
    ldh a, [$ff92]
    ld [hl+], a
    ldh a, [$ff93]
    ld [hl+], a
    call Call_000_0f0d
    ld a, $60
    jp Jump_000_0f32


jr_000_0b07:
    ld a, [$c0b3]
    cp $06
    jr z, jr_000_0ae8

    ret


Jump_000_0b0f:
    ld a, l
    cpl
    inc a
    ld l, a
    ret z

    ld a, [$c408]
    ld b, a
    ld a, [$c40c]
    ld c, a
    ldh a, [$ffa5]
    sub l
    ldh [$ffa5], a
    cp b
    ret nc

    ldh a, [$ff96]
    or $c0
    set 0, a
    ldh [$ff96], a
    ld a, l
    cp c
    jr c, jr_000_0b30

    ld a, c

jr_000_0b30:
    ld b, a
    ld hl, $c40e
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $ff92
    ld a, [hl]
    sub b
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr c, jr_000_0b4f

    dec hl
    call Call_000_0080
    jr c, jr_000_0b4f

    ld a, [$c408]
    ldh [$ffa5], a
    ret


jr_000_0b4f:
    ld a, e
    ldh [$ff92], a
    ld a, d
    ldh [$ff93], a
    ldh a, [$ffb1]
    sub e
    ldh [$ffa5], a
    ret


Call_000_0b5b:
    ld a, l
    sub c
    ret z

    ld l, a
    ld a, h
    sbc b
    ld h, a
    jp c, Jump_000_0bb3

    ld a, [$c40b]
    ld b, a
    ld a, [$c40d]
    ld c, a
    ldh a, [$ffa4]
    add l
    ldh [$ffa4], a
    cp b
    ret c

    ret z

    ldh a, [$ff9f]
    cp $02
    ret z

    ldh a, [$ff96]
    or $a0
    set 1, a
    ldh [$ff96], a
    ld a, l
    cp c
    jr c, jr_000_0b87

    ld a, c

jr_000_0b87:
    ld b, a
    ld hl, $c41a
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, $ff90
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    dec hl
    call Call_000_0080
    jr nc, jr_000_0ba4

    ld a, [$c40b]
    ldh [$ffa4], a
    ret


jr_000_0ba4:
    ld hl, $c41a
    ld a, [hl+]
    ldh [$ff90], a
    ld a, [hl-]
    ldh [$ff91], a
    ldh a, [$ffae]
    sub [hl]
    ldh [$ffa4], a
    ret


Jump_000_0bb3:
    ld a, [$c40a]
    ld b, a
    ld a, [$c40d]
    ld c, a
    ld a, l
    cpl
    inc a
    ld l, a
    ldh a, [$ffa4]
    sub l
    ldh [$ffa4], a
    cp b
    ret nc

    ldh a, [$ff9f]
    cp $02
    ret z

    ldh a, [$ff96]
    or $a0
    res 0, a
    ldh [$ff96], a
    ld a, l
    cp c
    jr c, jr_000_0bd8

    ld a, c

jr_000_0bd8:
    ld b, a
    ld hl, $ff90
    ld a, [hl]
    sub b
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr c, jr_000_0beb

    ld a, [$c40a]
    ldh [$ffa4], a
    ret


jr_000_0beb:
    xor a
    ldh [$ff90], a
    ldh [$ff91], a
    ldh a, [$ffae]
    ldh [$ffa4], a
    ret


jr_000_0bf5:
    ldh a, [$ff96]
    cp $ff
    ret z

    ld hl, $ff96
    res 5, [hl]
    ret


Call_000_0c00:
    call Call_000_0d73
    ldh a, [$ff98]
    and $f8
    ld b, a
    ld a, e
    and $f8
    cp b
    jr z, jr_000_0bf5

    ldh [$ff98], a

Call_000_0c10:
    ld a, e
    and $f8
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld bc, $9800
    add hl, bc
    ld b, h
    ld c, l
    call Call_000_04e4
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, $20
    ld [hl+], a
    push hl
    ld bc, $0020
    add hl, bc
    ld [hl], $00
    pop hl
    ldh a, [$ff99]
    add $23
    ldh [$ff99], a
    ldh a, [$ff92]
    srl a
    srl a
    srl a
    ld c, a
    ld b, $00
    add hl, bc
    ldh a, [$ff93]
    ld b, a
    ldh a, [$ff92]
    and $f8
    ld c, a
    ld a, $20
    ldh [$ffcb], a
    ld a, l
    ldh [$ffc9], a

jr_000_0c51:
    push de
    call Call_000_0d36
    pop de

jr_000_0c56:
    ld a, [hl]
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    bit 3, c
    jr z, jr_000_0c63

    set 0, l

jr_000_0c63:
    bit 3, e
    jr z, jr_000_0c69

    set 1, l

jr_000_0c69:
    ldh a, [$ffa2]
    add l
    ld l, a
    ldh a, [$ffa3]
    adc h
    ld h, a
    ld a, [hl]
    ld hl, $ffc9
    inc [hl]
    ld l, [hl]
    ld h, $c1
    dec hl
    ld [hl], a
    pop hl
    bit 3, c
    jr z, jr_000_0c81

    inc hl

jr_000_0c81:
    ldh a, [$ffcb]
    dec a
    ldh [$ffcb], a
    ret z

    ld a, $08
    add c
    ld c, a
    jr nc, jr_000_0c56

    inc b
    ldh a, [$ffc9]
    sub $20
    ldh [$ffc9], a
    jr jr_000_0c51

jr_000_0c96:
    ldh a, [$ff96]
    cp $ff
    ret z

    ld hl, $ff96
    res 6, [hl]
    ret


Call_000_0ca1:
    call Call_000_0d5b
    ldh a, [$ff97]
    and $f8
    ld d, a
    ld a, c
    and $f8
    cp d
    jr z, jr_000_0c96

    ldh [$ff97], a

Call_000_0cb1:
    call Call_000_04e4
    ld a, $98
    ld [hl+], a
    ld a, c
    and $f8
    rrca
    rrca
    rrca
    ld [hl+], a
    ld a, $a0
    ld [hl+], a
    push hl
    ld de, $0020
    add hl, de
    ld [hl], $00
    pop hl
    ldh a, [$ff99]
    add $23
    ldh [$ff99], a
    ldh a, [$ff90]
    srl a
    srl a
    srl a
    ld e, a
    ld d, $00
    add hl, de
    ldh a, [$ff91]
    ld d, a
    ldh a, [$ff90]
    and $f8
    ld e, a
    ld a, $20
    ldh [$ffcb], a
    ld a, l
    ldh [$ffc9], a

jr_000_0cea:
    push de
    call Call_000_0d36
    pop de

jr_000_0cef:
    ld a, [hl]
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    bit 3, c
    jr z, jr_000_0cfc

    set 0, l

jr_000_0cfc:
    bit 3, e
    jr z, jr_000_0d02

    set 1, l

jr_000_0d02:
    ldh a, [$ffa2]
    add l
    ld l, a
    ldh a, [$ffa3]
    adc h
    ld h, a
    ld a, [hl]
    ld hl, $ffc9
    inc [hl]
    ld l, [hl]
    ld h, $c1
    dec hl
    ld [hl], a
    pop hl
    bit 3, e
    jr z, jr_000_0d21

    ld a, $10
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a

jr_000_0d21:
    ldh a, [$ffcb]
    dec a
    ldh [$ffcb], a
    ret z

    ld a, e
    add $08
    ld e, a
    jr nc, jr_000_0cef

    inc d
    ldh a, [$ffc9]
    sub $20
    ldh [$ffc9], a
    jr jr_000_0cea

Call_000_0d36:
Jump_000_0d36:
    ld a, d
    or a
    jr z, jr_000_0d40

    xor a

jr_000_0d3b:
    add $0e
    dec d
    jr nz, jr_000_0d3b

jr_000_0d40:
    add b
    ld hl, $c41c
    add l
    ld l, a
    ld a, h
    adc d
    ld h, a
    ld a, c
    and $f0
    swap a
    ld d, a
    ld a, e
    and $f0
    or d
    ld e, a
    ld d, [hl]
    ld hl, $c800
    add hl, de
    ld a, [hl]
    ret


Call_000_0d5b:
    ldh a, [$ff96]
    bit 0, a
    jr nz, jr_000_0d6c

    ldh a, [$ff92]
    add $e8
    ld c, a
    ldh a, [$ff93]
    adc $00
    ld b, a
    ret


jr_000_0d6c:
    ldh a, [$ff92]
    ld c, a
    ldh a, [$ff93]
    ld b, a
    ret


Call_000_0d73:
    ldh a, [$ff96]
    bit 1, a
    jr z, jr_000_0d84

    ldh a, [$ff90]
    add $e8
    ld e, a
    ldh a, [$ff91]
    adc $00
    ld d, a
    ret


jr_000_0d84:
    ldh a, [$ff90]
    ld e, a
    ldh a, [$ff91]
    ld d, a
    ret


Jump_000_0d8b:
    ld a, [$4000]
    push af
    ld a, $04
    ld [$2100], a
    ld hl, $ff92
    ld a, [hl+]
    ld c, a
    ld b, [hl]
    xor a

jr_000_0d9b:
    push af
    push bc
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    call Call_000_0cb1
    ld de, $c100
    call Call_000_0347
    xor a
    ld [$c100], a
    ldh [$ff99], a
    pop bc
    pop af
    add $08
    jr nz, jr_000_0d9b

    call Call_000_05c8
    pop af
    ld [$2100], a
    ret


Call_000_0dc0:
    call Call_000_0307
    ld a, $07
    ldh [$ff95], a
    ldh [rWX], a
    ld a, $80
    ldh [$ff94], a
    ldh [rWY], a
    call Call_000_0e27
    ld a, $df
    ld [$9c0b], a
    ld a, $e0
    ld [$9c2b], a
    ld de, $0dfe
    ld hl, $9c0f
    ld bc, $0202
    call Call_000_05f7
    call Call_000_0e02
    call Call_000_0e85
    call Call_000_0e8c
    ld de, $c100
    call Call_000_0347
    xor a
    ld [$c100], a
    ldh [$ff99], a
    ret


    db $e5, $e6, $e7, $e8

Call_000_0e02:
Jump_000_0e02:
    ldh a, [$ffbb]
    add a
    add a
    ld de, $0e13
    rst $30
    ld hl, $9c08
    ld bc, $0202
    jp Jump_000_061f


    db $fa, $fb, $fc, $fd, $d0, $d1, $d2, $d3, $dc, $dd, $d2, $de, $d8, $d9, $da, $db
    db $d4, $d5, $d6, $d7

Call_000_0e27:
    ldh a, [$ffb9]
    ldh [$ffc9], a
    or a
    ret z

jr_000_0e2d:
    call Call_000_0e38
    ldh a, [$ffc9]
    dec a
    ldh [$ffc9], a
    jr nz, jr_000_0e2d

    ret


Call_000_0e38:
    ldh a, [$ffc9]
    dec a
    ld hl, $0e60
    rst $20
    ld de, $0e66
    ld bc, $0202
    jp Jump_000_05f7


Jump_000_0e48:
    ld a, [$c402]
    res 0, a
    ld [$c402], a
    ldh a, [$ffb9]
    dec a
    ld hl, $0e60
    rst $20
    ld de, $0e66
    ld bc, $0202
    jp Jump_000_061f


    db $01, $9c, $03, $9c, $05, $9c, $e1, $e2, $e3, $e4, $00, $00, $00, $00

Call_000_0e6e:
Jump_000_0e6e:
    ld a, [$c402]
    res 1, a
    ld [$c402], a

Call_000_0e76:
    ldh a, [$ffb9]
    ld hl, $0e60
    rst $20
    ld de, $0e6a
    ld bc, $0202
    jp Jump_000_061f


Call_000_0e85:
Jump_000_0e85:
    ld bc, $9c2c
    ldh a, [$ffb8]
    jr jr_000_0e91

Call_000_0e8c:
Jump_000_0e8c:
    ld bc, $9c31
    ldh a, [$ffba]

Jump_000_0e91:
jr_000_0e91:
    ld d, a
    call Call_000_04e4
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, $02
    ld [hl+], a
    ld a, d
    push hl
    call Call_000_05a2
    pop hl
    ldh a, [$ffca]
    call Call_000_0eb7
    ld [hl+], a
    ldh a, [$ffc9]
    call Call_000_0eb7
    ld [hl+], a
    ld [hl], $00
    ldh a, [$ff99]
    add $05
    ldh [$ff99], a
    ret


Call_000_0eb7:
    add $f0
    ret


Call_000_0eba:
Jump_000_0eba:
    ld hl, $ffb8
    add [hl]
    cp $1e
    jr nc, jr_000_0ec7

Call_000_0ec2:
jr_000_0ec2:
    ldh [$ffb8], a
    jp Jump_000_0e85


jr_000_0ec7:
    sub $1e
    call Call_000_0ec2
    jr jr_000_0ef9

    ld b, a
    ldh a, [$ffb8]
    sub b
    jr nc, jr_000_0ec2

    xor a
    jr jr_000_0ec2

Jump_000_0ed7:
    ld a, [$c402]
    set 0, a
    ld [$c402], a
    ldh a, [$ffb9]
    inc a
    cp $04
    jr c, jr_000_0ee8

    ld a, $03

jr_000_0ee8:
    ldh [$ffb9], a
    ret


Call_000_0eeb:
    ld a, [$c402]
    set 1, a
    ld [$c402], a
    ldh a, [$ffb9]
    dec a
    ldh [$ffb9], a
    ret


Call_000_0ef9:
Jump_000_0ef9:
jr_000_0ef9:
    ld a, $46
    call Call_000_0f38

Call_000_0efe:
    ld hl, $ffba
    inc [hl]
    ld a, [hl]
    cp $64
    jp c, Jump_000_0e8c

    dec [hl]
    jp Jump_000_0e8c


    ret


Call_000_0f0d:
    ld a, $80
    ldh [rNR52], a
    ld [$dd9f], a
    xor a
    ldh [rNR51], a
    ld [$dd97], a
    ld a, $77
    ldh [rNR50], a
    ld hl, $dd00
    ld b, $06
    ld a, $ff

jr_000_0f25:
    ld [hl], a
    ld de, $0017
    add hl, de
    ld [hl], a
    ld de, $0002
    add hl, de
    dec b
    jr nz, jr_000_0f25

Call_000_0f32:
Jump_000_0f32:
    call Call_000_0f3b

Jump_000_0f35:
    call Call_000_0f3b

Call_000_0f38:
Jump_000_0f38:
    call Call_000_0f3b

Call_000_0f3b:
Jump_000_0f3b:
    push bc
    push de
    push hl
    ld [$dd9e], a
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld de, $6201
    add hl, de
    push hl
    pop de
    ld a, [$4000]
    push af
    ld a, $07
    ld [$2100], a
    ld a, [de]
    inc de
    ld c, a
    ld b, $00
    ld hl, $dd00
    add hl, bc
    ld a, [hl]
    cp $ff
    jr z, jr_000_0f80

    inc hl
    ld a, [hl-]
    ld b, $ee
    and $03
    jr z, jr_000_0f79

    ld b, $dd
    cp $01
    jr z, jr_000_0f79

    ld b, $bb
    cp $02
    jr z, jr_000_0f79

    ld b, $77

jr_000_0f79:
    ld a, [$dd97]
    and b
    ld [$dd97], a

jr_000_0f80:
    xor a
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    inc de
    ld [hl], a
    ld de, $0014
    add hl, de
    xor a
    ld [hl], a
    pop af
    ld [$2100], a
    ld a, [$dd9e]
    inc a
    pop hl
    pop de
    pop bc
    ret


Call_000_0f9d:
    xor a
    ld [$dd9d], a
    ld [$dd96], a
    ld hl, $dd9c
    inc [hl]
    ld hl, $dd00

Jump_000_0fab:
    push hl
    ld de, $ffe6
    ld b, $19

jr_000_0fb1:
    ld a, [hl+]
    ld [de], a
    inc e
    dec b
    jr nz, jr_000_0fb1

    ldh a, [$ffe7]
    and $03
    ld [$dd98], a
    ld b, a
    add a
    add a
    add b
    ld [$dd9b], a
    inc b
    ld a, $88

jr_000_0fc8:
    rlca
    dec b
    jr nz, jr_000_0fc8

    ld [$dd99], a
    ld [$dd9a], a
    ld a, [$dd9f]
    bit 7, a
    jr nz, jr_000_0ff6

    ld a, [$dd9d]
    and $fe
    jr z, jr_000_0ff6

    ld a, [$dd99]
    ld b, a
    ld a, [$dd96]
    and b
    jr nz, jr_000_1056

    ld a, b
    cpl
    ld b, a
    ld a, [$dd97]
    and b
    ld [$dd97], a
    jr jr_000_1056

jr_000_0ff6:
    ldh a, [$ffe6]
    ld b, a
    ldh a, [$fffd]
    or b
    and a
    jr z, jr_000_106d

    ldh a, [$fffd]
    and b
    cp $ff
    jr z, jr_000_1056

    call Call_000_13a8
    call Call_000_140d
    ldh a, [$fff2]
    ld b, a
    ldh a, [$fff3]
    inc a
    cp b
    jr c, jr_000_1016

    ld a, b

jr_000_1016:
    ldh [$fff3], a
    ld hl, $ffeb
    dec [hl]
    ld a, [hl]
    bit 7, a
    jr z, jr_000_103e

    ldh a, [$ffea]
    and $0f
    ld [hl], a
    call Call_000_1369
    ldh a, [$fffc]
    and a
    jr z, jr_000_1031

    dec a
    ldh [$fffc], a

jr_000_1031:
    ld hl, $ffed
    dec [hl]
    jr nz, jr_000_103e

jr_000_1037:
    ldh a, [$fffb]
    ldh [$fffc], a
    call Call_000_1110

jr_000_103e:
    ld a, [$dd99]
    ld b, a
    ld a, [$dd96]
    or b
    ld [$dd96], a
    pop hl
    push hl
    ld de, $ffe6
    ld b, $19

jr_000_1050:
    ld a, [de]
    ld [hl+], a
    inc e
    dec b
    jr nz, jr_000_1050

jr_000_1056:
    pop hl
    ld de, $0019
    add hl, de
    ld a, [$dd9d]
    inc a
    ld [$dd9d], a
    cp $06
    jp c, Jump_000_0fab

    ld a, [$dd97]
    ldh [rNR51], a
    ret


jr_000_106d:
    ldh a, [$ffe8]
    ld l, a
    ldh a, [$ffe9]
    ld h, a
    ld a, [hl+]
    and $0f
    ldh [$ffeb], a
    ld d, a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_10ab

    ld a, [hl+]
    rrca
    rrca
    and $c0
    or d

jr_000_1086:
    ldh [$ffea], a
    ld a, [hl+]
    swap a
    ldh [$ffec], a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_10b1

    ld a, [hl+]
    ldh [$ffee], a

jr_000_1097:
    xor a
    ldh [$ffef], a
    ldh [$fff0], a
    ldh [$fff1], a
    ldh [$fff4], a
    ldh [$fffd], a
    dec a
    ldh [$fffa], a
    ld a, $02
    ldh [$ffe6], a
    jr jr_000_1037

jr_000_10ab:
    ld a, [hl+]
    ldh [$fff2], a
    ld a, d
    jr jr_000_1086

jr_000_10b1:
    xor a
    ldh [rNR30], a
    ld a, [hl]
    ld hl, $10d0
    and $03
    jr z, jr_000_10c3

    ld de, $0010

jr_000_10bf:
    add hl, de
    dec a
    jr nz, jr_000_10bf

jr_000_10c3:
    ld de, $ff30
    ld b, $10

jr_000_10c8:
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_000_10c8

    jr jr_000_1097

    db $00, $01, $12, $35, $8a, $cd, $ee, $ff, $ff, $fe, $ed, $ca, $85, $32, $11, $00

    ld bc, $4523
    ld h, a
    adc c
    xor e
    call $feef
    call c, $98ba
    halt
    ld d, h
    ld [hl-], a
    db $10

    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00

    rst $38
    xor $dd
    call z, $aabb
    sbc c
    adc b
    ld [hl], a
    ld h, [hl]
    ld d, l
    ld b, h
    inc sp
    ld [hl+], a
    db $11
    nop

Call_000_1110:
Jump_000_1110:
    ldh a, [$ffe6]
    ld l, a
    ldh a, [$fffd]
    ld h, a
    add hl, hl
    ldh a, [$ffe8]
    ld e, a
    ldh a, [$ffe9]
    ld d, a
    add hl, de

Jump_000_111e:
jr_000_111e:
    ldh a, [$ffe6]
    add $01
    ldh [$ffe6], a
    ldh a, [$fffd]
    adc $00
    ldh [$fffd], a
    ld a, [hl+]
    cp $d0
    jr nc, jr_000_1156

    cp $b0
    jr nc, jr_000_1194

    cp $a0
    jp nc, Jump_000_11d3

    jp Jump_000_1296


jr_000_113b:
    cp $fd
    jr nz, jr_000_114a

    ldh a, [$ffe6]
    ldh [$fff9], a
    ldh a, [$fffd]
    ldh [$fffe], a

jr_000_1147:
    inc hl
    jr jr_000_111e

jr_000_114a:
    cp $ff
    jr nz, jr_000_1147

    ldh [$ffe6], a
    ldh [$fffd], a
    call Call_000_14a8
    ret


jr_000_1156:
    cp $f0
    jr nc, jr_000_113b

    cp $e0
    jr nc, jr_000_1162

    and $0f
    jr jr_000_1166

jr_000_1162:
    and $0f
    cpl
    inc a

jr_000_1166:
    ld b, a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_1176

    ld a, b
    ldh [$fff4], a
    ld a, [hl]
    ldh [$fff5], a
    ldh [$fff6], a

jr_000_1176:
    inc hl
    jr jr_000_111e

jr_000_1179:
    and $0f
    ld b, a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_1191

    ldh a, [$ffec]
    and $0f
    jr nz, jr_000_1191

    ld a, [hl]
    ldh [$fff2], a
    ld a, b
    swap a
    ldh [$fff1], a

jr_000_1191:
    inc hl
    jr jr_000_111e

jr_000_1194:
    cp $c0
    jr nc, jr_000_1179

    and $0f
    jr z, jr_000_11bf

    ld e, a
    ld a, [hl]
    and a
    jr nz, jr_000_11b1

    ldh a, [$ffef]
    dec a
    ldh [$ffef], a
    jr z, jr_000_11d0

    bit 7, a
    jr z, jr_000_11bf

    ld a, e
    ldh [$ffef], a
    jr jr_000_11bf

jr_000_11b1:
    ldh a, [$fff0]
    dec a
    ldh [$fff0], a
    jr z, jr_000_11d0

    bit 7, a
    jr z, jr_000_11bf

    ld a, e
    ldh [$fff0], a

jr_000_11bf:
    ld a, [hl]
    and a
    jr nz, jr_000_11c5

    ldh a, [$fff9]

jr_000_11c5:
    ldh [$ffe6], a
    jr nz, jr_000_11cd

    ldh a, [$fffe]
    jr jr_000_11ce

jr_000_11cd:
    xor a

jr_000_11ce:
    ldh [$fffd], a

jr_000_11d0:
    jp Jump_000_1110


Jump_000_11d3:
    cp $a0
    jr nz, jr_000_11e2

    ld a, [hl+]
    swap a
    ldh [$ffec], a
    call Call_000_13df
    jp Jump_000_111e


jr_000_11e2:
    cp $a1
    jr nz, jr_000_11ec

    ld a, [hl+]
    ldh [$ffee], a
    jp Jump_000_111e


jr_000_11ec:
    cp $a2
    jr nz, jr_000_120d

    ld a, [$dd98]
    cp $02
    jr z, jr_000_1207

    ld a, [hl+]
    rrca
    rrca
    and $c0
    ld d, a
    ldh a, [$ffea]
    and $3f
    or d
    ldh [$ffea], a
    jp Jump_000_111e


jr_000_1207:
    ld a, [hl+]
    ldh [$fff2], a
    jp Jump_000_111e


jr_000_120d:
    cp $a3
    jr nz, jr_000_1234

    ld a, [hl+]
    bit 7, a
    jr nz, jr_000_122e

    ld b, a
    and $0f
    add a
    ldh [$fffb], a
    ldh [$fffc], a
    ld a, b
    and $70
    ld e, a
    ldh a, [$ffe7]
    and $0f
    or e
    or $80

jr_000_1229:
    ldh [$ffe7], a
    jp Jump_000_111e


jr_000_122e:
    ldh a, [$ffe7]
    and $0f
    jr jr_000_1229

jr_000_1234:
    cp $a5
    jr nz, jr_000_1246

    ld a, [hl+]
    cp $01
    jr nz, jr_000_1241

    ldh a, [$fffa]
    swap a

jr_000_1241:
    ldh [$fffa], a
    jp Jump_000_111e


jr_000_1246:
    cp $a6
    jr nz, jr_000_1250

    ld a, [hl+]
    ldh [rNR50], a
    jp Jump_000_111e


jr_000_1250:
    cp $a7
    jr nz, jr_000_125a

    ld a, [hl]
    ldh [$ffed], a
    jp Jump_000_1348


jr_000_125a:
    cp $ae
    jr nz, jr_000_126a

    ld a, [hl+]
    and $10
    ld b, a
    ldh a, [$ffea]
    or b
    ldh [$ffea], a
    jp Jump_000_111e


jr_000_126a:
    cp $af
    jr nz, jr_000_127e

    ld a, [hl+]
    and $0f
    ldh [$ffeb], a
    ld b, a
    ldh a, [$ffea]
    and $f0
    or b
    ldh [$ffea], a
    jp Jump_000_111e


jr_000_127e:
    inc hl
    jp Jump_000_111e


    nop
    db $01

    db $11, $12, $14, $23, $07, $15, $17, $32, $33, $60, $61

    ld b, l

    db $53, $62

jr_000_1292:
    call Call_000_14a8
    ret


Jump_000_1296:
    ld b, a
    ld a, [hl]
    ldh [$ffed], a
    ld a, [$dd98]
    cp $03
    jr nz, jr_000_12bd

    ld a, b
    cp $1f
    jr z, jr_000_1292

    cp $10
    jr nc, jr_000_12b8

    ld hl, $1282
    add l
    ld l, a
    ld a, h
    adc $00
    ld h, a
    ld l, [hl]
    ld h, $00
    jr jr_000_12f0

jr_000_12b8:
    ld l, a
    ld h, $00
    jr jr_000_12f0

jr_000_12bd:
    ld a, b
    and $0f
    cp $0c
    jr nc, jr_000_1292

    add a
    ld e, a
    ldh a, [$ffea]
    and $10
    jr z, jr_000_12d0

    ld a, e
    add $18
    ld e, a

jr_000_12d0:
    ld d, $00
    ld hl, $14c3
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, b
    swap a
    and $0f
    jr z, jr_000_12e8

    ld b, a

jr_000_12e1:
    srl h
    rr l
    dec b
    jr nz, jr_000_12e1

jr_000_12e8:
    ld a, $00
    sub l
    ld l, a
    ld a, $08
    sbc h
    ld h, a

jr_000_12f0:
    xor a
    ldh [$fff3], a
    call Call_000_14b8
    ld a, [$dd98]
    cp $02
    jr nz, jr_000_1301

    ld a, $80
    ldh [rNR30], a

jr_000_1301:
    push hl
    call Call_000_13d1
    pop hl
    ld a, [$dd98]
    and a
    ldh a, [$ffee]
    ld c, $10
    call z, Call_000_13ed
    ld a, l
    ld c, $13
    call Call_000_13ed
    ld a, l
    cp $02
    jr c, jr_000_1324

    cp $fe
    jr c, jr_000_1326

    ld a, $fd
    jr jr_000_1326

jr_000_1324:
    ld a, $02

jr_000_1326:
    ldh [$fff7], a
    ld a, [$dd98]
    cp $02
    jr z, jr_000_135b

    cp $02
    jr nc, jr_000_133c

    ldh a, [$ffea]
    and $c0
    ld c, $11
    call Call_000_13ed

jr_000_133c:
    ld a, h
    and $07
    or $80

jr_000_1341:
    ldh [$fff8], a
    ld c, $14
    call Call_000_13ed

Jump_000_1348:
    ld a, [$dd9a]
    ld b, a
    cpl
    ld c, a
    ldh a, [$fffa]
    and b
    ld b, a
    ld a, [$dd97]
    and c
    or b
    ld [$dd97], a
    ret


jr_000_135b:
    xor a
    ldh [rNR31], a
    ldh a, [rNR52]
    and $04
    jr z, jr_000_133c

    ld a, h
    and $07
    jr jr_000_1341

Call_000_1369:
    ld a, [$dd98]
    cp $02
    ret z

    ldh a, [$fff4]
    and a
    ret z

    ld hl, $fff6
    dec [hl]
    ret nz

    ldh a, [$ffec]
    swap a
    cp $10
    ret nc

    and $0f
    ld b, a
    ldh a, [$fff5]
    ldh [$fff6], a
    ld hl, $fff4
    ld a, [hl]
    bit 7, a
    jr nz, jr_000_139c

    dec [hl]
    ld a, b
    cp $0f
    ret z

    ldh a, [$ffec]
    add $10
    ldh [$ffec], a
    jp Jump_000_13df


jr_000_139c:
    inc [hl]
    ld a, b
    and a
    ret z

    ldh a, [$ffec]
    sub $10
    ldh [$ffec], a
    jr jr_000_13df

Call_000_13a8:
    call Call_000_14b8
    ld a, [$dd98]
    cp $03
    ret z

    ldh a, [$fffc]
    and a
    ret nz

    ldh a, [$ffe7]
    bit 7, a
    ret z

    and $70
    ld b, a
    ld a, [$dd9c]
    and $0f
    or b
    ld e, a
    ld d, $00
    ld hl, $1683
    add hl, de
    ldh a, [$fff7]
    add [hl]
    ld c, $13
    jr jr_000_13ed

Call_000_13d1:
    ld a, [$dd98]
    cp $02
    jr z, jr_000_13f6

    ldh a, [$fff1]
    and a
    jr nz, jr_000_141b

    ldh a, [$ffec]

Call_000_13df:
Jump_000_13df:
jr_000_13df:
    ld c, a
    call Call_000_14b8
    ld a, c
    ld c, $12
    call Call_000_13ed
    ldh a, [$fff8]
    ld c, $14

Call_000_13ed:
jr_000_13ed:
    ld b, a
    ld a, [$dd9b]
    add c
    ld c, a
    ld a, b
    ldh [c], a
    ret


jr_000_13f6:
    ldh a, [$ffec]
    ld c, $12
    jr jr_000_13ed

jr_000_13fc:
    ld a, e
    srl a
    add $02
    swap a
    ld hl, $ffec
    cp [hl]
    ret c

    and $60
    ldh [rNR32], a
    ret


Call_000_140d:
    call Call_000_14b8
    ld a, [$dd98]
    cp $02
    jr z, jr_000_141b

    ldh a, [$fff1]
    and a
    ret z

jr_000_141b:
    ldh a, [$fff2]
    and a
    ret z

    ld e, $00
    ld c, a
    ldh a, [$fff3]
    ld b, $04

jr_000_1426:
    add a
    cp c
    jr c, jr_000_142b

    sub c

jr_000_142b:
    ccf
    rl e
    dec b
    jr nz, jr_000_1426

    ld a, [$dd98]
    cp $02
    jr z, jr_000_13fc

    ldh a, [$fff1]
    or e
    ld e, a
    ld d, $00
    ld hl, $14e3
    add hl, de
    ldh a, [$ffec]
    swap a
    ld e, a
    ld a, [hl]
    ld h, a
    and $f0
    or e
    ld e, a
    bit 2, h
    jr nz, jr_000_1471

    inc b
    ld a, c
    swap a
    and $0f
    jr z, jr_000_1471

    ld b, a
    bit 3, e
    jr nz, jr_000_146a

    sla b
    bit 2, e
    jr nz, jr_000_146a

    sla b
    bit 1, e
    jr z, jr_000_146f

jr_000_146a:
    ld a, b
    cp $08
    jr c, jr_000_1471

jr_000_146f:
    ld b, $00

jr_000_1471:
    ld a, h
    and $08
    or b
    ld b, a
    bit 0, h
    jr z, jr_000_148f

    ld hl, $1583
    add hl, de
    ld a, [hl]
    or b
    ld b, a
    ld c, $12
    ld a, [$dd9b]
    add c
    ld c, a
    ldh a, [c]
    cp b
    ret z

    ld a, b
    jp Jump_000_13df


jr_000_148f:
    ld c, $12
    ld a, [$dd9b]
    add c
    ld c, a
    ldh a, [c]
    and $08
    ld l, a
    ld a, h
    and $08
    cp l
    ret z

    ld hl, $1583
    add hl, de
    ld a, [hl]
    or b
    jp Jump_000_13df


Call_000_14a8:
    call Call_000_14b8
    ld a, [$dd99]
    cpl
    ld b, a
    ld a, [$dd97]
    and b
    ld [$dd97], a
    ret


Call_000_14b8:
    ld a, [$dd99]
    ld b, a
    ld a, [$dd96]
    and b
    ret z

    pop af
    ret


    db $d4, $07, $64, $07, $f9, $06, $95, $06, $37, $06, $dd, $05, $89, $05, $3a, $05
    db $f0, $04, $a8, $04, $65, $04, $26, $04

    sbc h
    rlca
    ld l, $07
    rst $00
    ld b, $66
    ld b, $0a
    ld b, $b3
    dec b
    ld h, c
    dec b
    dec d
    dec b
    call z, $8604
    inc b
    ld b, l
    inc b
    db $08
    inc b

    db $f1, $e0, $d0, $c0, $b0, $a0, $90, $80, $70, $60, $50, $40, $30, $20, $10, $05
    db $09, $18, $28, $38, $48, $58, $68, $78, $88, $98, $a8, $b8, $c8, $d8, $e8, $f5
    db $f1, $e0, $d0, $c0, $b0, $a0, $90, $85

    adc c
    sbc b
    xor b
    cp b
    ret z

    ret c

    add sp, -$0b

    db $89, $98, $a8, $b8, $c8, $d8, $e8, $f5, $f1, $e0, $d0, $c0, $b0, $a0, $90, $85

    pop af
    pop de
    or c
    sub c
    ld [hl], c
    ld d, c
    ld sp, $e111
    pop bc
    and c
    add c
    ld h, c
    ld b, c
    db $21
    dec b

    db $f1, $e0, $d0, $c5, $c9, $d8, $e1, $d0, $c0, $a1, $81, $61, $41, $21, $10, $05
    db $f1, $d1, $b1, $90, $a9, $b1, $91, $71, $60, $50, $40, $30, $20, $15, $11, $05

    ld d, l
    ld d, h
    ld d, h
    ld d, h
    ld d, h
    ld d, h
    ld e, c
    ld h, l
    ld l, c
    ld a, b
    adc b
    xor c
    ret


    pop af
    or c
    add l

    db $f5

    pop af

    db $a1

    adc c
    db $f8

    db $f1

    and c
    add c

    db $75

    ld [hl], h

    db $71

    ld h, l
    ld h, h

    db $61

    ld d, l

    db $55

    nop
    nop
    nop
    nop
    nop

    db $00, $00

    nop

    db $00, $00, $00, $00, $00, $00, $00, $00

    nop
    nop
    nop
    nop
    nop

    db $00

    nop
    nop
    db $10

    db $10

    db $10

    db $10, $10

    db $10
    db $10
    stop
    nop
    nop
    nop
    db $10
    db $10
    db $10
    db $10
    db $10

    db $10

    db $10
    db $10

    db $20

    jr nz, @+$22

    db $20

    nop
    nop
    nop
    db $10
    db $10
    db $10
    db $10
    db $10
    jr nz, @+$22

    jr nz, jr_000_15df

    jr nz, jr_000_15f1

    jr nc, jr_000_15f3

    nop
    nop
    db $10
    db $10
    db $10
    db $10
    jr nz, @+$22

    db $20

    db $20

    jr nc, jr_000_15ff

    db $30

    jr nc, @+$42

    db $40

    nop
    nop
    db $10
    db $10
    db $10
    jr nz, @+$22

    jr nz, @+$32

    jr nc, jr_000_160e

    db $40

jr_000_15df:
    ld b, b
    ld b, b
    ld d, b
    ld d, b
    nop
    nop
    db $10
    db $10
    jr nz, @+$22

    jr nz, @+$32

    db $30, $40, $40, $40

    ld d, b

    db $50

jr_000_15f1:
    ld h, b

    db $60

jr_000_15f3:
    nop
    nop
    db $10
    db $10
    db $20

    db $20

    jr nc, @+$32

    ld b, b
    ld b, b

    db $50, $50

jr_000_15ff:
    ld h, b
    ld h, b
    ld [hl], b
    ld [hl], b
    nop

    db $10

    db $10
    jr nz, @+$22

    db $30, $30

    ld b, b

    db $40, $50, $50

jr_000_160e:
    ld h, b

    db $60

    ld [hl], b

    db $70, $80

    nop
    db $10
    db $10
    jr nz, @+$22

    db $30

jr_000_1619:
    ld b, b
    ld b, b

    db $50, $50

    ld h, b

    db $70, $70

    add b
    add b
    sub b
    nop
    db $10
    db $10
    jr nz, @+$32

    db $30

    ld b, b
    ld d, b

    db $50, $60

    ld [hl], b

    db $70, $80, $90

    sub b

    db $a0

    nop
    db $10
    db $10
    jr nz, jr_000_1668

    db $40

    ld b, b
    ld d, b
    ld h, b

    db $70

    ld [hl], b

    db $80, $90

    and b
    and b
    or b
    nop
    db $10
    jr nz, jr_000_1667

    jr nc, jr_000_1689

    ld d, b
    ld h, b
    ld h, b

    db $70

    add b
    sub b

    db $a0

    and b
    or b

    db $c0

    nop
    db $10
    jr nz, @+$32

    db $30

    db $40

    ld d, b
    ld h, b
    ld [hl], b

    db $80

    sub b

    db $a0, $a0

    or b
    ret nz

    ret nc

    nop
    db $10
    jr nz, @+$32

jr_000_1667:
    ld b, b

jr_000_1668:
    ld d, b
    ld h, b
    ld [hl], b

    db $70, $80

    sub b
    and b

    db $b0

    ret nz

    ret nc

    db $e0

    nop

    db $10

    jr nz, @+$32

    ld b, b

    db $50, $60

    ld [hl], b

    db $80, $90, $a0, $b0, $c0, $d0, $e0, $f0

    nop
    nop
    ld bc, $0001
    nop

jr_000_1689:
    rst $38
    rst $38
    nop
    nop
    ld bc, $0001
    nop
    rst $38
    rst $38

    db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $01, $02, $01, $00, $ff, $fe, $ff, $00, $01, $02, $01, $00, $ff, $fe, $ff
    db $00, $00, $01, $01, $02, $02, $01, $01, $00, $00, $ff, $ff, $fe, $fe, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe

    ld bc, $0101
    ld bc, $0101
    ld bc, $0101
    ld bc, $0101
    ld bc, $0101
    ld bc, $0202
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld a, [$dffe]
    and $04
    ld hl, $ff9f
    add [hl]
    ld [$c0d7], a
    ld a, $01
    ldh [$ff8e], a
    ldh [$ff8f], a
    ret


Jump_000_1716:
    call Call_000_17bb
    call Call_000_171d
    ret


Call_000_171d:
    call Call_000_17a1
    call Call_000_1736
    call Call_000_1741
    call Call_000_1754
    call Call_000_1766
    call Call_000_176e
    call Call_000_178f
    call Call_000_1798
    ret


Call_000_1736:
    ld a, [$c0d7]
    add $f1
    ld hl, $986f
    jp Jump_000_0517


Call_000_1741:
    ld hl, $98ad
    ld de, $19ef
    ld a, [$c0a8]
    or a
    jp nz, Jump_000_068e

    ld de, $19f3
    jp Jump_000_068e


Call_000_1754:
    ld hl, $98ed
    ld de, $19ef
    ldh a, [$ffbe]
    or a
    jp nz, Jump_000_068e

    ld de, $19f3
    jp Jump_000_068e


Call_000_1766:
    ld bc, $992e
    ldh a, [$ffba]
    jp Jump_000_0e91


Call_000_176e:
    ld bc, $994b
    ld de, $0005
    call Call_000_0501
    ld hl, $1785
    ldh a, [$ffbb]
    rst $20
    ld d, h
    ld e, l
    ld hl, $996b
    jp Jump_000_068e


    rst $30
    add hl, de
    db $fd
    add hl, de
    inc b
    ld a, [de]
    inc c
    ld a, [de]
    ld [de], a
    ld a, [de]

Call_000_178f:
    ld bc, $99ae
    ld a, [$c0d9]
    jp Jump_000_0e91


Call_000_1798:
    ld bc, $99ee
    ld a, [$c0da]
    jp Jump_000_0e91


Call_000_17a1:
    ld bc, $9863
    ld de, $000e
    call Call_000_04fd
    ld a, [$c0d8]
    ld c, $40
    call Call_000_05b4
    ld bc, $9863
    add hl, bc
    ld a, $0e
    jp Jump_000_0517


Call_000_17bb:
    ldh a, [$ff8b]
    bit 0, a
    jr nz, jr_000_17ed

    bit 3, a
    jr nz, jr_000_17ed

    bit 7, a
    jr nz, jr_000_17d7

    bit 6, a
    jr nz, jr_000_17e2

    bit 5, a
    jr nz, jr_000_1818

    bit 4, a
    jp nz, Jump_000_188f

    ret


jr_000_17d7:
    ld hl, $c0d8
    inc [hl]
    ld a, [hl]
    cp $07
    ret c

    ld [hl], $00
    ret


jr_000_17e2:
    ld hl, $c0d8
    dec [hl]
    ld a, [hl]
    cp $ff
    ret nz

    ld [hl], $06
    ret


jr_000_17ed:
    ld a, $03
    ld [$c0a9], a
    ld a, $02
    ldh [$ff8e], a
    ldh [$ff8f], a
    ld hl, $0800
    ld a, l
    ld [$c0a6], a
    ld a, h
    ld [$c0a7], a
    xor a
    ld [$dffe], a
    ld a, [$c0d7]
    ld b, a
    and $03
    ldh [$ff9f], a
    bit 2, b
    ret z

    ld a, $04
    ld [$dffe], a
    ret


jr_000_1818:
    ld a, [$c0d8]
    rst $00
    ld a, [hl+]
    jr @+$36

    jr @+$3f

    jr jr_000_1867

    jr @+$52

jr_000_1825:
    jr jr_000_1883

    jr @+$7c

    jr jr_000_1825

    rst $10
    ret nz

    dec a
    and $07
    ld [$c0d7], a
    ret


    ld a, [$c0a8]
    xor $ff
    ld [$c0a8], a
    ret


    ldh a, [$ffbe]
    xor $ff
    ldh [$ffbe], a
    ret


    ldh a, [$ffba]
    sub $01
    ldh [$ffba], a
    ret nc

    ld a, $63
    ldh [$ffba], a
    ret


    ldh a, [$ffbb]
    sub $01
    ldh [$ffbb], a
    ret nc

    ld a, $04
    ldh [$ffbb], a
    ret


    call Call_000_0f0d
    call Call_000_186b
    ld hl, $18d5
    rst $38
    ld a, [hl]

jr_000_1867:
    call Call_000_0f32
    ret


Call_000_186b:
    ld a, [$c0d9]
    sub $01
    ld [$c0d9], a
    ret nc

    ld a, $14
    ld [$c0d9], a
    ret


    call Call_000_1880
    jp Jump_000_1907


Call_000_1880:
    ld a, [$c0da]

jr_000_1883:
    sub $01
    ld [$c0da], a
    ret nc

    ld a, $1e
    ld [$c0da], a
    ret


Jump_000_188f:
    ld a, [$c0d8]
    rst $00
    and c
    jr @+$36

    jr jr_000_18d5

    jr @-$53

    jr @-$47

    jr @-$3b

    jr jr_000_18a4

    add hl, de
    ld a, [$c0d7]

jr_000_18a4:
    inc a
    and $07
    ld [$c0d7], a
    ret


    ldh a, [$ffba]
    inc a
    ldh [$ffba], a
    cp $64
    ret c

    xor a
    ldh [$ffba], a
    ret


    ldh a, [$ffbb]
    inc a
    ldh [$ffbb], a
    cp $05
    ret c

    xor a
    ldh [$ffbb], a
    ret


    call Call_000_0f0d
    call Call_000_0f32
    call $18f5
    ld hl, $18d5
    rst $38
    ld a, [hl]
    call Call_000_0f32
    ret


jr_000_18d5:
    nop
    inc b
    ld [$100c], sp
    inc d
    inc e
    jr nz, @+$26

    jr z, @+$2e

    jr nc, @+$36

    jr c, @+$3e

    ld h, b
    ld h, h
    jr jr_000_1900

    jr @+$1a

    jr jr_000_1904

    jr @+$1a

    jr @+$1a

jr_000_18f0:
    jr jr_000_190a

    jr @+$1a

    jr jr_000_18f0

    reti


    ret nz

    inc a
    ld [$c0d9], a
    cp $15
    ret c

    xor a

jr_000_1900:
    ld [$c0d9], a
    ret


jr_000_1904:
    call Call_000_1956

Jump_000_1907:
    ld hl, $191e

jr_000_190a:
    ld a, [$c0da]
    rst $20
    ld a, l
    dec h
    jp z, Jump_000_0f3b

    dec h
    jp z, Jump_000_0f38

    dec h
    jp z, Jump_000_0f35

    jp Jump_000_0f32


    ld b, b
    ld bc, $0141
    ld b, d
    ld bc, $0143
    ld b, h
    ld bc, $0145
    ld b, [hl]
    ld [bc], a
    ld c, b
    ld bc, $0249
    ld c, e
    ld bc, HeaderMaskROMVersion
    ld c, l
    ld bc, HeaderGlobalChecksum
    ld c, a
    ld bc, $0150
    ld d, c
    ld bc, $0152
    ld d, e
    ld bc, $0154
    ld d, l
    inc b
    ld e, c
    ld bc, $015a
    ld e, e
    ld bc, $015c
    ld e, l
    ld bc, $025e
    ld b, b
    ld bc, $0140

Call_000_1956:
    ld a, [$c0da]
    inc a
    ld [$c0da], a
    cp $1f
    ret c

    xor a
    ld [$c0da], a
    ret


LoadDebugMenu::
    xor a
    call Call_000_3f6a
    xor a
    ldh [$ff90], a
    ldh [$ffbe], a
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMainGfx
    call Call_000_02f8
    ld hl, $9864
    ld de, $19c6
    call Call_000_0673
    ld hl, $98a4
    ld de, $19cc
    call Call_000_0673
    ld hl, $98e4
    ld de, $19d3
    call Call_000_0673
    ld hl, $9924
    ld de, $19d7
    call Call_000_0673
    ld hl, $9964
    ld de, $19dd
    call Call_000_0673
    ld hl, $99a4
    ld de, $19e2
    call Call_000_0673
    ld hl, $99e4
    ld de, $19e9
    call Call_000_0673
    ld hl, $c0a3
    ld [hl], $e4
    ld a, $83
    ld [$c0a2], a
    ret


    ld d, a
    ld e, [hl]
    ld a, [hl]
    ld b, l
    ld d, [hl]
    rst $38
    inc h
    jr nz, jr_000_1a0b

    ld [de], a
    dec d
    inc [hl]
    rst $38
    ld sp, $1623
    rst $38
    ld b, l
    ld a, [de]
    ld b, d
    inc e
    ld [de], a
    rst $38
    ld b, [hl]
    ld c, b
    ld e, [hl]
    ld l, h
    rst $38
    ld a, [hl+]
    ld de, $1118
    inc d
    ld b, d
    rst $38
    add hl, de
    ld [de], a
    dec d
    inc d
    ld b, d
    rst $38
    nop
    ld a, [hl+]
    ld de, $11ff
    ld de, $ff13
    nop
    nop
    nop
    dec h
    dec de
    rst $38
    nop
    ld sp, $1a1a
    ld b, l
    dec hl
    rst $38
    nop
    ld b, l
    add hl, de
    ld d, $45
    inc l
    dec [hl]

jr_000_1a0b:
    rst $38
    nop
    ld h, $3f
    inc h
    dec [hl]
    rst $38
    ld b, [hl]
    ld d, d
    ld d, [hl]
    ld [hl], h
    ld a, h
    cp $ff

    db $23, $1a, $4f, $1a, $83, $1a, $bf, $1a, $f3, $1a, $2b, $2a, $44, $2a

    ld e, l
    ld a, [hl+]

    db $72, $2a, $7f, $2a, $98, $2a, $b1, $2a, $ca, $2a

    db $e3
    ld a, [hl+]
    db $fc
    ld a, [hl+]
    dec e
    dec hl
    ld a, $2b

    db $5b, $2b

    ld l, h
    dec hl

    db $7d, $2b, $92, $2b, $af, $2b, $c8, $2b, $e1, $2b, $f6, $2b

    rrca
    inc l

    db $28, $2c, $2b, $2a, $44, $2a

    ld e, l
    ld a, [hl+]

    db $72, $2a, $b9, $2c, $d6, $2c, $f3, $2c

    db $10
    dec l
    db $10
    dec l
    dec l
    dec l
    ld d, d
    dec l
    ld [hl], a
    dec l

    db $98, $2d

    sbc b
    dec l

    db $a9, $2d, $c6, $2d, $e3, $2d, $fc, $2d, $15, $2e, $2e, $2e, $47, $2e, $60, $2e
    db $79, $2e, $a0, $2e, $bd, $2e

    jr z, @+$2e

    db $2b, $2a, $44, $2a

    ld e, l
    ld a, [hl+]

    db $72, $2a, $21, $33, $3a, $33, $3a, $33

    ld a, [hl-]
    inc sp
    ld d, e
    inc sp
    ld h, h
    inc sp
    ld a, l
    inc sp
    sub [hl]
    inc sp
    xor e
    inc sp
    xor e
    inc sp

    db $ab, $33, $c4, $33, $dd, $33, $f6, $33, $0f, $34, $28, $34, $41, $34, $5a, $34
    db $7b, $34, $a0, $34, $c5, $34, $e6, $34, $0b, $35, $30, $35, $51, $35

    jr z, @+$2e

    db $2b, $2a, $44, $2a

    ld e, l
    ld a, [hl+]

    db $72, $2a, $2e, $2f, $4b, $2f, $4b, $2f

    ld c, e
    cpl
    ld l, b
    cpl

jr_000_1ad1:
    add l
    cpl
    and [hl]
    cpl
    rst $00
    cpl

    db $e4, $2f

    db $e4
    cpl

    db $12, $30, $f5, $2f, $2f, $30, $48, $30

    ld h, c
    jr nc, @+$78

    jr nc, @-$6f

    db $30

    db $e7, $30, $04, $31, $a8, $30, $c5, $30

    jr z, @+$2e

    db $2b, $2a, $44, $2a

    ld e, l
    ld a, [hl+]

    db $72, $2a, $21, $31, $3a, $31, $53, $31

    ld l, h
    ld sp, $316c
    add l
    ld sp, $31a6
    rst $00
    db $31

    db $e4, $31

    db $e4
    db $31

    db $f5, $31, $0a, $32

    daa
    ld [hl-], a
    ld b, b
    ld [hl-], a
    ld e, c
    ld [hl-], a
    ld l, [hl]
    ld [hl-], a
    add a
    ld [hl-], a

    db $a0, $32, $fc, $32, $b9, $32

    jr z, @+$2e

    db $2d, $1b, $61, $1b, $99, $1b, $d1, $1b, $11, $1c, $2a, $1c, $43, $1c, $5c, $1c

    ld de, $111c
    inc e

    db $75, $1c, $92, $1c, $af, $1c, $cc, $1c

    jp hl


    inc e

    db $0a, $1d, $23, $1d, $50, $1d, $7d, $1d, $aa, $1d, $97, $24, $bc, $24, $e1, $24
    db $ea, $24, $f3, $24, $fc, $24, $1d, $25, $3a, $25, $5b, $25, $7c, $25, $19, $1f
    db $3a, $1f, $5b, $1f, $7c, $1f, $99, $1f, $a2, $1f, $c7, $1d, $e4, $1d, $01, $1e

    ld e, $1e
    dec sp
    db $1e

    db $5c, $1e, $75, $1e, $a2, $1e, $cf, $1e, $fc, $1e, $bf, $1f, $d0, $1f, $e1, $1f
    db $f2, $1f, $9d, $25, $be, $25, $df, $25, $00, $26, $25, $26, $46, $26, $63, $26
    db $84, $26, $9f, $20, $c0, $20, $e1, $20, $02, $21, $1f, $21, $28, $21

    ei
    rra
    ei
    rra
    ei
    rra
    ei
    rra
    ei
    rra
    ei
    rra

    db $fb, $1f, $28, $20, $55, $20

    add d
    db $20

    db $45, $21, $5e, $21, $77, $21, $90, $21, $ad, $21, $a5, $26, $da, $26, $0f, $27
    db $40, $27, $71, $27, $aa, $27, $df, $27, $46, $23, $67, $23, $88, $23, $a9, $23
    db $c6, $23, $cf, $23, $98, $22, $b5, $22, $d2, $22, $ef, $22, $0c, $23, $2d, $23

    sbc b
    ld [hl+], a
    sbc b
    ld [hl+], a

    db $98, $22

    sbc b
    ld [hl+], a

    db $ec, $23, $05, $24, $1e, $24, $37, $24, $54, $24, $e4, $27, $21, $28, $5e, $28
    db $93, $28, $cc, $28, $09, $29, $3e, $29, $73, $29, $ac, $29, $e9, $29, $26, $2a
    db $eb, $f8, $70, $00, $eb, $00, $71, $00, $f3, $f8, $72, $00, $f3, $00, $73, $00
    db $fb, $f8, $7e, $00, $fb, $00, $7f, $00, $80, $ec, $f8, $70, $00, $ec, $00, $71
    db $00, $f4, $f8, $74, $00, $f4, $00, $75, $00, $fc, $f8, $80, $00, $fc, $00, $81
    db $00, $80, $ec, $f8, $70, $00, $ec, $00, $71, $00, $f4, $f8, $76, $00, $f4, $00
    db $77, $00, $fc, $f8, $82, $00, $fc, $00, $83, $00, $80, $ef, $f8, $78, $00, $ef
    db $00, $79, $00, $f7, $f8, $7a, $00, $f7, $00, $7b, $00, $f7, $08, $7c, $00, $ff
    db $ff, $7d, $00, $80, $eb, $f8, $84, $00, $eb, $00, $85, $00, $f3, $f8, $86, $00
    db $f3, $00, $87, $00, $f1, $08, $89, $00, $fb, $f7, $88, $00, $fb, $ff, $7f, $00
    db $80, $ec, $f8, $84, $00, $ec, $00, $85, $00, $f4, $f8, $8a, $00, $f4, $00, $8b
    db $00, $f2, $08, $89, $00, $fc, $f8, $80, $00, $fc, $00, $81, $00, $80, $ec, $f8
    db $84, $00, $ec, $00, $85, $00, $f4, $f8, $8c, $00, $f4, $00, $8d, $00, $f2, $08
    db $89, $00, $fc, $f8, $82, $00, $fc, $00, $83, $00, $80, $eb, $f8, $84, $00, $eb
    db $00, $85, $00, $f3, $f8, $86, $00, $f3, $00, $87, $00, $f1, $08, $89, $00, $fb
    db $f8, $8e, $00, $fb, $00, $8f, $00, $80

    db $eb
    ld sp, hl
    add h
    nop
    db $eb
    ld bc, $0085
    di
    ld sp, hl
    sub b
    nop
    di
    ld bc, $0087
    di
    add hl, bc
    sub c
    nop
    ldh a, [c]
    ld de, $0092

jr_000_1d01:
    ei
    ld sp, hl
    adc a
    jr nz, jr_000_1d01

    nop
    adc a
    nop
    add b

    db $ee, $f8, $93, $00, $ee, $00, $94, $00, $f6, $f8, $95, $00, $f6, $00, $96, $00
    db $fe, $f8, $97, $00, $fe, $00, $98, $00, $80, $e0, $f8, $99, $00, $e0, $00, $9a
    db $00, $e0, $08, $9b, $00, $e0, $10, $9c, $00, $e8, $f8, $9d, $00, $e8, $00, $9e
    db $00, $e8, $08, $9f, $00, $f0, $f8, $a0, $00, $f0, $00, $a1, $00, $f8, $f8, $a2
    db $00, $f8, $00, $a3, $00, $80, $e1, $f8, $99, $00, $e1, $00, $9a, $00, $e1, $08
    db $9b, $00, $e1, $10, $9c, $00, $e9, $f8, $9d, $00, $e9, $00, $9e, $00, $e9, $08
    db $9f, $00, $f1, $f8, $a0, $00, $f1, $00, $a1, $00, $f9, $f8, $a4, $00, $f9, $00
    db $a5, $00, $80, $e1, $f8, $99, $00, $e1, $00, $9a, $00, $e1, $08, $9b, $00, $e1
    db $10, $9c, $00, $e9, $f8, $9d, $00, $e9, $00, $9e, $00, $e9, $08, $9f, $00, $f1
    db $f8, $a0, $00, $f1, $00, $a1, $00, $f9, $f8, $a6, $00, $f9, $00, $a7, $00, $80
    db $e8, $f8, $a8, $00, $e8, $00, $a9, $00, $f0, $f7, $aa, $00, $f0, $ff, $ab, $00
    db $f8, $f8, $ac, $00, $f8, $00, $ad, $00, $f8, $08, $ae, $00, $80, $eb, $f8, $75
    db $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00, $f1, $08, $7a
    db $00, $fb, $f7, $79, $00, $fb, $ff, $70, $00, $80, $ec, $f8, $75, $00, $ec, $00
    db $76, $00, $f4, $f8, $7b, $00, $f4, $00, $7c, $00, $f2, $08, $7a, $00, $fc, $f8
    db $71, $00, $fc, $00, $72, $00, $80, $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4
    db $f8, $7d, $00, $f4, $00, $7e, $00, $f2, $08, $7a, $00, $fc, $f8, $73, $00, $fc
    db $00, $74, $00, $80

    db $eb
    ld hl, sp+$75
    nop
    db $eb
    nop
    halt
    nop
    di
    ld hl, sp+$77
    nop
    di
    nop
    ld a, b
    nop
    pop af
    ld [$007a], sp
    ei
    ld hl, sp+$7f
    nop
    ei
    nop
    add b
    nop
    add b
    db $eb
    ld sp, hl
    ld [hl], l
    nop
    db $eb
    ld bc, $0076
    di
    ld sp, hl
    add c
    nop
    di
    ld bc, $0078
    di
    add hl, bc
    add d
    nop
    ldh a, [c]
    ld de, $0083

jr_000_1e53:
    ei
    ld sp, hl
    add b
    jr nz, jr_000_1e53

    nop
    add b
    nop
    add b

    db $ee, $f8, $84, $00, $ee, $00, $85, $00, $f6, $f8, $86, $00, $f6, $00, $87, $00
    db $fe, $f8, $88, $00, $fe, $00, $89, $00, $80, $e0, $f8, $8a, $00, $e0, $00, $8b
    db $00, $e0, $08, $8c, $00, $e0, $10, $8d, $00, $e8, $f8, $8e, $00, $e8, $00, $8f
    db $00, $e8, $08, $90, $00, $f0, $f8, $91, $00, $f0, $00, $92, $00, $f8, $f8, $93
    db $00, $f8, $00, $94, $00, $80, $e1, $f8, $8a, $00, $e1, $00, $8b, $00, $e1, $08
    db $8c, $00, $e1, $10, $8d, $00, $e9, $f8, $8e, $00, $e9, $00, $8f, $00, $e9, $08
    db $90, $00, $f1, $f8, $91, $00, $f1, $00, $92, $00, $f9, $f8, $95, $00, $f9, $00
    db $96, $00, $80, $e1, $f8, $8a, $00, $e1, $00, $8b, $00, $e1, $08, $8c, $00, $e1
    db $10, $8d, $00, $e9, $f8, $8e, $00, $e9, $00, $8f, $00, $e9, $08, $90, $00, $f1
    db $f8, $91, $00, $f1, $00, $92, $00, $f9, $f8, $97, $00, $f9, $00, $98, $00, $80
    db $e8, $f8, $99, $00, $e8, $00, $9a, $00, $f0, $f7, $9b, $00, $f0, $ff, $9c, $00
    db $f8, $f8, $9d, $00, $f8, $00, $9e, $00, $f8, $08, $9f, $00, $80, $e8, $f8, $ab
    db $00, $e8, $00, $ac, $00, $e8, $08, $ad, $00, $f0, $f8, $ae, $00, $f0, $00, $af
    db $00, $f0, $08, $b0, $00, $f8, $f8, $b1, $00, $f8, $00, $b2, $00, $80, $e9, $f8
    db $ab, $00, $e9, $00, $ac, $00, $e9, $08, $ad, $00, $f1, $f8, $b3, $00, $f1, $00
    db $af, $00, $f1, $08, $b0, $00, $f9, $f8, $b4, $00, $f9, $00, $b5, $00, $80, $e9
    db $f8, $ab, $00, $e9, $00, $ac, $00, $e9, $08, $ad, $00, $f1, $f8, $b6, $00, $f1
    db $00, $b7, $00, $f1, $08, $b0, $00, $f9, $f8, $b8, $00, $f9, $00, $b9, $00, $80
    db $e8, $fa, $ab, $00, $e8, $02, $ba, $00, $f0, $f9, $bb, $00, $f0, $01, $bc, $00
    db $f0, $09, $bd, $00, $f8, $f9, $a0, $00, $f8, $01, $a1, $00, $80, $f8, $f4, $a2
    db $00, $f8, $fc, $a3, $00, $80, $ec, $fc, $a4, $00, $ec, $04, $a5, $00, $f4, $f4
    db $a6, $00, $f4, $fc, $a7, $00, $f4, $04, $a8, $00, $fc, $fb, $a9, $00, $fc, $03
    db $aa, $00, $80, $f8, $f8, $be, $10, $f8, $00, $c4, $10, $00, $f8, $bf, $10, $00
    db $00, $c0, $10, $80, $f7, $f8, $c1, $10, $f7, $00, $c1, $30, $ff, $f8, $c2, $10
    db $ff, $00, $c3, $10, $80, $f0, $f8, $c5, $10, $f0, $00, $c6, $10, $f8, $f8, $c7
    db $10, $f8, $00, $c8, $10, $80, $f8, $f8, $c9, $10, $f8, $00, $c9, $30, $80, $e0
    db $f8, $70, $00, $e0, $00, $71, $00, $e0, $08, $72, $00, $e0, $10, $73, $00, $e8
    db $f8, $74, $00, $e8, $00, $75, $00, $e8, $08, $76, $00, $f0, $f8, $77, $00, $f0
    db $00, $78, $00, $f8, $f8, $79, $00, $f8, $00, $7a, $00, $80, $e1, $f8, $70, $00
    db $e1, $00, $71, $00, $e1, $08, $72, $00, $e1, $10, $73, $00, $e9, $f8, $74, $00
    db $e9, $00, $75, $00, $e9, $08, $76, $00, $f1, $f8, $77, $00, $f1, $00, $78, $00
    db $f9, $f8, $7b, $00, $f9, $00, $7c, $00, $80, $e1, $f8, $70, $00, $e1, $00, $71
    db $00, $e1, $08, $72, $00, $e1, $10, $73, $00, $e9, $f8, $74, $00, $e9, $00, $75
    db $00, $e9, $08, $76, $00, $f1, $f8, $77, $00, $f1, $00, $78, $00, $f9, $f8, $7d
    db $00, $f9, $00, $7e, $00, $80

    add sp, -$08
    ld a, a
    nop
    add sp, $00
    add b
    nop
    ldh a, [$fff7]
    add c
    nop
    ldh a, [rIE]
    add d
    nop
    ld hl, sp-$08
    add e
    nop
    ld hl, sp+$00
    add h
    nop
    ld hl, sp+$08
    add l
    nop
    add b

    db $e8, $f8, $91, $00, $e8, $00, $92, $00, $e8, $08, $93, $00, $f0, $f8, $94, $00
    db $f0, $00, $95, $00, $f0, $08, $96, $00, $f8, $f8, $97, $00, $f8, $00, $98, $00
    db $80, $e9, $f8, $91, $00, $e9, $00, $92, $00, $e9, $08, $93, $00, $f1, $f8, $99
    db $00, $f1, $00, $95, $00, $f1, $08, $96, $00, $f9, $f8, $9a, $00, $f9, $00, $9b
    db $00, $80, $e9, $f8, $91, $00, $e9, $00, $92, $00, $e9, $08, $93, $00, $f1, $f8
    db $9c, $00, $f1, $00, $9d, $00, $f1, $08, $96, $00, $f9, $f8, $9e, $00, $f9, $00
    db $9f, $00, $80, $e8, $fa, $91, $00, $e8, $02, $a0, $00, $f0, $f9, $a1, $00, $f0
    db $01, $a2, $00, $f0, $09, $a3, $00, $f8, $f9, $86, $00, $f8, $01, $87, $00, $80
    db $f8, $f4, $88, $00, $f8, $fc, $89, $00, $80, $ec, $fc, $8a, $00, $ec, $04, $8b
    db $00, $f4, $f4, $8c, $00, $f4, $fc, $8d, $00, $f4, $04, $8e, $00, $fc, $fb, $8f
    db $00, $fc, $03, $90, $00, $80, $e8, $f8, $af, $00, $e8, $00, $b0, $00, $f0, $f8
    db $b1, $00, $f0, $00, $b2, $00, $f8, $f8, $b3, $00, $f8, $00, $b4, $00, $80, $e9
    db $f8, $af, $00, $e9, $00, $b0, $00, $f1, $f8, $b5, $00, $f1, $00, $b6, $00, $f9
    db $f8, $b7, $00, $f9, $00, $b8, $00, $80, $e9, $f8, $af, $00, $e9, $00, $b0, $00
    db $f1, $f8, $b9, $00, $f1, $00, $ba, $00, $f9, $f8, $bb, $00, $f9, $00, $bc, $00
    db $80, $ed, $f8, $bd, $00, $ed, $00, $be, $00, $f5, $f8, $bf, $00, $f5, $00, $a4
    db $00, $f5, $08, $a5, $00, $fd, $f8, $a6, $00, $fd, $00, $a7, $00, $80, $ed, $f8
    db $bd, $00, $ed, $00, $a8, $00, $f5, $f8, $a9, $00, $f5, $00, $aa, $00, $f5, $08
    db $ab, $00, $fd, $f8, $ac, $00, $fd, $00, $ad, $00, $fd, $08, $ae, $00, $80, $d8
    db $ec, $c0, $00, $e0, $ec, $c1, $00, $e0, $f4, $c2, $00, $e0, $fc, $c3, $00, $e0
    db $04, $c4, $00, $e8, $f4, $c5, $00, $e8, $fc, $c6, $00, $e8, $04, $c7, $00, $f0
    db $f4, $cd, $00, $f8, $f4, $c8, $00, $f8, $fc, $c9, $00, $f8, $04, $ca, $00, $80
    db $d9, $ec, $c0, $00, $e1, $ec, $c1, $00, $e1, $f4, $c2, $00, $e1, $fc, $c3, $00
    db $e1, $04, $c4, $00, $e9, $f4, $c5, $00, $e9, $fc, $c6, $00, $e9, $04, $c7, $00
    db $f1, $f4, $cd, $00, $f9, $f4, $cb, $00, $f9, $fc, $c9, $00, $f9, $04, $cc, $00
    db $80, $f8, $fc, $c0, $10, $80, $f8, $fc, $c1, $10, $80, $f8, $fc, $c2, $10, $80
    db $f8, $fb, $c0, $10, $80, $f0, $f8, $c3, $00, $f0, $00, $c4, $00, $f8, $f8, $c5
    db $00, $f8, $00, $c6, $00, $80, $f0, $f8, $c4, $20, $f0, $00, $c3, $20, $f8, $f8
    db $c6, $20, $f8, $00, $c5, $20, $80, $f2, $f8, $c5, $40, $f2, $00, $c6, $40, $fa
    db $f8, $c3, $40, $fa, $00, $c4, $40, $80, $e8, $f4, $c7, $00, $e8, $fc, $c8, $00
    db $e8, $04, $c7, $20, $f0, $f4, $c9, $00, $f0, $fc, $ca, $00, $f0, $04, $c9, $20
    db $f8, $f8, $cb, $00, $f8, $00, $cc, $00, $80, $eb, $f8, $75, $00, $eb, $00, $76
    db $00, $f3, $f8, $77, $00, $f3, $00, $78, $00, $f1, $08, $7a, $00, $fb, $f7, $79
    db $00, $fb, $ff, $70, $00, $80, $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8
    db $7b, $00, $f4, $00, $7c, $00, $f2, $08, $7a, $00, $fc, $f8, $71, $00, $fc, $00
    db $72, $00, $80, $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7d, $00, $f4
    db $00, $7e, $00, $f2, $08, $7a, $00, $fc, $f8, $73, $00, $fc, $00, $74, $00, $80
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f8, $7f, $00, $fb, $00, $80, $00, $80, $eb, $f9, $75
    db $00, $eb, $01, $76, $00, $f3, $f9, $81, $00, $f3, $01, $78, $00, $f3, $09, $82
    db $00, $f2, $11, $83, $00, $fb, $f9, $80, $20, $fb, $00, $80, $00, $80, $ee, $f8
    db $84, $00, $ee, $00, $85, $00, $f6, $f8, $86, $00, $f6, $00, $87, $00, $fe, $f8
    db $88, $00, $fe, $00, $89, $00, $80, $e8, $f8, $95, $00, $e8, $00, $96, $00, $e8
    db $08, $97, $00, $f0, $f8, $98, $00, $f0, $00, $99, $00, $f0, $08, $9a, $00, $f8
    db $f8, $9b, $00, $f8, $00, $9c, $00, $80, $e9, $f8, $95, $00, $e9, $00, $96, $00
    db $e9, $08, $97, $00, $f1, $f8, $9d, $00, $f1, $00, $99, $00, $f1, $08, $9a, $00
    db $f9, $f8, $9e, $00, $f9, $00, $9f, $00, $80, $e9, $f8, $95, $00, $e9, $00, $96
    db $00, $e9, $08, $97, $00, $f1, $f8, $a0, $00, $f1, $00, $a1, $00, $f1, $08, $9a
    db $00, $f9, $f8, $a2, $00, $f9, $00, $a3, $00, $80, $e8, $fa, $95, $00, $e8, $02
    db $a4, $00, $f0, $f9, $a5, $00, $f0, $01, $a6, $00, $f0, $09, $a7, $00, $f8, $f9
    db $8a, $00, $f8, $01, $8b, $00, $80, $f8, $f4, $8c, $00, $f8, $fc, $8d, $00, $80
    db $ec, $fc, $8e, $00, $ec, $04, $8f, $00, $f4, $f4, $90, $00, $f4, $fc, $91, $00
    db $f4, $04, $92, $00, $fc, $fb, $93, $00, $fc, $03, $94, $00, $80, $e8, $f8, $b3
    db $00, $e8, $00, $b4, $00, $f0, $f8, $b5, $00, $f0, $00, $b6, $00, $f8, $f8, $b7
    db $00, $f8, $00, $b8, $00, $80, $e9, $f8, $b3, $00, $e9, $00, $b4, $00, $f1, $f8
    db $b9, $00, $f1, $00, $ba, $00, $f9, $f8, $bb, $00, $f9, $00, $bc, $00, $80, $e9
    db $f8, $b3, $00, $e9, $00, $b4, $00, $f1, $f8, $bd, $00, $f1, $00, $be, $00, $f9
    db $f8, $bf, $00, $f9, $00, $c0, $00, $80, $ed, $f8, $c1, $00, $ed, $00, $c2, $00
    db $f5, $f8, $c3, $00, $f5, $00, $a8, $00, $f5, $08, $a9, $00, $fd, $f8, $aa, $00
    db $fd, $00, $ab, $00, $80, $ed, $f8, $c1, $00, $ed, $00, $ac, $00, $f5, $f8, $ad
    db $00, $f5, $00, $ae, $00, $f5, $08, $af, $00, $fd, $f8, $b0, $00, $fd, $00, $b1
    db $00, $fd, $08, $b2, $00, $80, $f0, $f8, $c4, $00, $f0, $00, $c5, $00, $f8, $f8
    db $c6, $10, $f8, $00, $c7, $10, $80, $f0, $f8, $c8, $00, $f0, $00, $c9, $00, $f8
    db $f8, $ca, $00, $f8, $00, $cb, $00, $80, $e0, $f8, $70, $00, $e0, $00, $71, $00
    db $e8, $f8, $72, $00, $e8, $00, $73, $00, $f0, $f8, $74, $00, $f0, $00, $75, $00
    db $ed, $08, $78, $00, $f8, $f8, $76, $00, $f8, $00, $77, $00, $80, $e0, $f9, $70
    db $00, $e0, $01, $71, $00, $e8, $f9, $72, $00, $e8, $01, $79, $00, $f0, $f8, $7a
    db $00, $f0, $00, $7b, $00, $f0, $08, $7c, $00, $f8, $f8, $7d, $00, $f8, $00, $77
    db $00, $80, $f8, $f8, $7e, $00, $f8, $00, $7f, $00, $80, $f8, $f8, $81, $20, $f8
    db $00, $80, $20, $80, $f8, $f8, $83, $20, $f8, $00, $82, $20, $80, $e8, $fc, $84
    db $00, $e8, $04, $71, $00, $f0, $f4, $85, $00, $f0, $fc, $86, $00, $f0, $04, $87
    db $00, $f8, $f4, $88, $00, $f8, $fc, $89, $00, $f8, $04, $8a, $00, $80, $e8, $fc
    db $84, $00, $e8, $04, $71, $00, $f0, $fc, $8b, $00, $f0, $04, $8c, $00, $f8, $f4
    db $8d, $00, $f8, $fc, $8e, $00, $f8, $04, $8f, $00, $80, $e0, $f8, $70, $00, $e0
    db $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $79, $00, $f0, $f8, $90, $00, $f0
    db $00, $91, $00, $f8, $f8, $92, $00, $f8, $00, $93, $00, $80, $e1, $f8, $70, $00
    db $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $79, $00, $f1, $f8, $94, $00
    db $f1, $00, $95, $00, $f9, $f8, $96, $00, $f9, $00, $97, $00, $80, $e1, $f8, $70
    db $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $79, $00, $f1, $f8, $98
    db $00, $f1, $00, $99, $00, $f9, $f8, $9a, $00, $f9, $00, $9b, $00, $80, $e0, $f8
    db $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00, $f0, $f8
    db $74, $00, $f0, $00, $75, $00, $f8, $f8, $76, $00, $f8, $00, $77, $00, $80, $e1
    db $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $73, $00, $f1
    db $f8, $78, $00, $f1, $00, $79, $00, $f9, $f8, $7a, $00, $f9, $00, $7b, $00, $80
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $73, $00
    db $f1, $f8, $7c, $00, $f1, $00, $7d, $00, $f9, $f8, $7e, $00, $f9, $00, $7f, $00
    db $80, $e5, $f8, $70, $00, $e5, $00, $71, $00, $ed, $f8, $80, $00, $ed, $00, $81
    db $00, $f5, $f8, $82, $00, $f5, $00, $83, $00, $f5, $08, $84, $00, $fd, $f8, $85
    db $00, $fd, $00, $86, $00, $80, $e5, $f8, $70, $00, $e5, $00, $71, $00, $ed, $f9
    db $87, $00, $ed, $01, $88, $00, $f5, $f8, $89, $00, $f5, $00, $8a, $00, $fd, $f8
    db $85, $00, $fd, $00, $8b, $00, $80, $e8, $fc, $8c, $00, $e8, $04, $8d, $00, $f0
    db $fa, $8e, $00, $f0, $02, $8f, $00, $f8, $f4, $90, $00, $f8, $fc, $91, $00, $f8
    db $04, $92, $00, $80, $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $93, $00
    db $e8, $00, $94, $00, $f0, $f8, $95, $00, $f0, $00, $96, $00, $f8, $f8, $97, $00
    db $f8, $00, $98, $00, $80, $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72
    db $00, $e8, $00, $73, $00, $f0, $f8, $99, $00, $f0, $00, $9a, $00, $f8, $f8, $9b
    db $00, $f8, $00, $9c, $00, $80, $d9, $f3, $70, $00, $e0, $ee, $71, $10, $e0, $f6
    db $72, $10, $e0, $fe, $73, $10, $e8, $f1, $74, $00, $e8, $f9, $75, $00, $e8, $01
    db $76, $00, $f0, $f4, $77, $10, $f0, $fc, $78, $10, $f0, $04, $79, $10, $f8, $f3
    db $7a, $10, $f8, $fb, $7b, $10, $f8, $03, $7c, $10, $80, $d9, $f3, $70, $00, $e0
    db $ee, $71, $10, $e0, $f6, $72, $10, $e0, $fe, $73, $10, $e8, $f1, $7d, $00, $e8
    db $f9, $75, $00, $e8, $01, $76, $00, $f0, $f2, $7e, $10, $f0, $fa, $7f, $10, $f0
    db $02, $80, $10, $f8, $f2, $81, $10, $f8, $fa, $82, $10, $f8, $02, $83, $10, $80
    db $e0, $f4, $84, $10, $e0, $fc, $85, $10, $e0, $04, $86, $10, $e8, $f4, $87, $00
    db $e8, $fc, $88, $00, $e8, $04, $89, $00, $f0, $f4, $8a, $10, $f0, $fc, $8b, $10
    db $f0, $04, $8c, $10, $f8, $f3, $7a, $10, $f8, $fb, $7b, $10, $f8, $03, $7c, $10
    db $80, $e0

    db $f4
    add h
    db $10

    db $e0

    db $fc
    add l
    db $10

    db $e0

    inc b
    add [hl]
    db $10

    db $e8

    db $f4
    sub b
    nop

    db $e8

    db $fc
    adc b
    nop

    db $e8

    inc b
    adc c
    nop

    db $f0

    ldh a, [c]
    ld a, [hl]
    db $10

    db $f0

    ld a, [$1091]

    db $f0

    ld [bc], a
    sub d
    db $10

    db $f8

    ldh a, [c]
    add c
    db $10

    db $f8

    ld a, [$1082]

    db $f8

    ld [bc], a
    add e
    db $10

    db $80, $e5, $f4, $93, $10, $e5, $fc, $94, $10, $e5, $04, $95, $10, $ed, $ed, $96
    db $00, $ed, $f5, $97, $00, $ed, $fd, $98, $00, $ed, $05, $99, $00, $f5, $ed, $9a
    db $10, $f5, $f5, $9b, $10, $f5, $fd, $9c, $10, $f5, $05, $9d, $10, $fd, $f4, $9e
    db $10, $fd, $fc, $9f, $10, $fd, $04, $7c, $10, $80, $e5, $f4, $a0, $10, $e5, $fc
    db $a1, $10, $ea, $ec, $a2, $10, $ed, $f4, $a3, $10, $ed, $fc, $a4, $10, $ea, $04
    db $a5, $10, $f5, $f4, $a6, $10, $f5, $fc, $a7, $10, $f2, $04, $a8, $10, $f6, $0c
    db $8d, $10, $fd, $f4, $8e, $10, $fd, $fc, $9f, $10, $fa, $04, $8f, $10, $80, $f8
    db $fc, $70, $00, $80, $db, $f7, $70, $10, $db, $ff, $71, $10, $e3, $f0, $72, $00
    db $e3, $f8, $73, $00, $e3, $00, $74, $00, $e3, $08, $75, $00, $eb, $f0, $76, $00
    db $eb, $f8, $77, $00, $eb, $00, $78, $00, $eb, $08, $79, $00, $f3, $f4, $7a, $10
    db $f3, $fc, $7b, $10, $f3, $04, $b9, $10, $fb, $f9, $7c, $10, $fb, $00, $7c, $10
    db $80, $dc, $f7, $70, $10, $dc, $ff, $71, $10, $e4, $f0, $7e, $00, $e4, $f8, $73
    db $00, $e4, $00, $74, $00, $e4, $08, $7f, $00, $ec, $f0, $80, $00, $ec, $f8, $77
    db $00, $ec, $00, $78, $00, $ec, $08, $81, $00, $f4, $f1, $82, $10, $f4, $f9, $83
    db $10, $f4, $01, $84, $10, $fc, $f7, $85, $10, $fc, $ff, $86, $10, $80, $dc, $f7
    db $70, $10, $dc, $ff, $71, $10, $e4, $f2, $87, $00, $e4, $fa, $88, $00, $e4, $02
    db $89, $00, $ec, $f2, $8a, $00, $ec, $fa, $8b, $00, $ec, $02, $8c, $00, $f4, $f2
    db $8d, $10, $f4, $fa, $8e, $10, $f4, $02, $8f, $10, $fc, $f5, $90, $10, $fc, $02
    db $7d, $10, $80, $e0, $f0, $92, $10, $e0, $f8, $93, $10, $e0, $00, $94, $10, $e8
    db $f0, $95, $00, $e8, $f8, $96, $00, $e8, $00, $97, $00, $e8, $08, $98, $00, $f0
    db $f0, $99, $00, $f0, $f8, $9a, $00, $f0, $00, $9b, $00, $f0, $08, $9c, $00, $f8
    db $f8, $9d, $10, $f8, $00, $9e, $10, $f8, $08, $9f, $10, $80, $e0, $f7, $a0, $10
    db $e0, $ff, $a1, $10, $e0, $08, $a2, $10, $e8, $f0, $7e, $00, $e8, $f8, $73, $00
    db $e8, $00, $a3, $00, $e8, $08, $a4, $00, $f0, $f0, $80, $00, $f0, $f8, $a5, $00
    db $f0, $00, $a6, $00, $f0, $08, $a7, $00, $f8, $f6, $a8, $10, $f8, $fe, $a9, $10
    db $f8, $06, $aa, $10, $f8, $0e, $91, $10, $80, $e1, $f7, $a0, $10, $e1, $ff, $a1
    db $10, $e9, $f0, $ac, $00, $e9, $f8, $73, $00, $e9, $00, $74, $00, $e9, $08, $ad
    db $00, $f1, $f0, $ae, $00, $f1, $f8, $b1, $00, $f1, $00, $ab, $00, $f1, $08, $af
    db $00, $f9, $f6, $a8, $10, $f9, $fe, $a9, $10, $f9, $06, $b0, $10, $80, $db, $f7
    db $70, $10, $db, $ff, $71, $10, $e3, $f3, $b3, $00, $e3, $fb, $b4, $00, $e3, $03
    db $bf, $00, $eb, $f3, $b6, $00, $eb, $fb, $b7, $00, $eb, $03, $b8, $00, $f3, $f4
    db $7a, $10, $f3, $fc, $7b, $10, $f3, $04, $b9, $10, $fb, $f9, $7c, $10, $fb, $00
    db $7c, $10, $80, $e3, $fa, $c5, $10, $e3, $00, $70, $10, $e3, $08, $71, $10, $eb
    db $f4, $bc, $10, $eb, $fc, $bd, $00, $eb, $04, $b4, $00, $eb, $0c, $bf, $00, $f3
    db $f6, $b2, $10, $f3, $fe, $b5, $10, $f3, $06, $ba, $00, $f3, $0e, $bb, $00, $fb
    db $f9, $be, $10, $fb, $06, $7c, $10, $f8, $0e, $cf, $00, $80, $d9, $fa, $c5, $10
    db $e1, $f7, $c6, $00, $e1, $ff, $c7, $00, $e8, $ef, $c0, $00, $e8, $f7, $c1, $00
    db $e9, $ff, $ca, $00, $e8, $07, $c0, $20, $f0, $ef, $c2, $00, $f0, $f7, $cc, $00
    db $f0, $ff, $cc, $00, $f0, $07, $c2, $20, $f8, $ef, $c3, $10, $f8, $f7, $ce, $10
    db $f8, $ff, $c4, $10, $f8, $07, $c3, $30, $80, $d8, $fa, $c5, $10, $e0, $f7, $c6
    db $00, $e0, $ff, $c7, $00, $e8, $ef, $c8, $00, $e8, $f7, $c9, $00, $e8, $ff, $ca
    db $00, $e8, $07, $c8, $20, $f0, $ef, $cb, $00, $f0, $f7, $cc, $00, $f0, $ff, $cc
    db $00, $f0, $07, $cb, $20, $f8, $ef, $cd, $10, $f8, $f7, $ce, $10, $f8, $ff, $c4
    db $10, $f8, $07, $cd, $30, $80, $f8, $fc, $cf, $00, $80, $eb, $f8, $00, $01, $eb
    db $00, $01, $01, $f3, $f8, $02, $01, $f3, $00, $03, $01, $fb, $f8, $04, $01, $fb
    db $00, $05, $01, $80, $eb, $f8, $06, $01, $eb, $00, $07, $01, $f3, $f8, $08, $01
    db $f3, $00, $09, $01, $fb, $f8, $0a, $01, $fb, $00, $0b, $01, $80

    db $eb
    db $fc
    inc c
    ld bc, $f8f3
    dec c
    ld bc, $00f3
    ld c, $01
    ei
    ld hl, sp+$0f
    ld bc, $00fb
    db $10
    db $01
    add b

    db $eb, $00, $11, $01, $f3, $f7, $11, $21, $f3, $00, $12, $01, $80, $eb, $f8, $13
    db $01, $eb, $00, $14, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01, $fb, $f8, $17
    db $01, $fb, $00, $18, $01, $80, $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8
    db $19, $01, $f4, $00, $1a, $01, $fc, $f8, $1b, $01, $fc, $00, $1c, $01, $80, $ec
    db $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $1d, $01, $f4, $00, $1e, $01, $fc
    db $f8, $1f, $01, $fc, $00, $20, $01, $80, $eb, $f8, $21, $01, $eb, $00, $22, $01
    db $f3, $f8, $15, $01, $f3, $00, $16, $01, $fb, $f8, $17, $01, $fb, $00, $18, $01
    db $80

    db $ed
    ld hl, sp+$23
    ld bc, $00ed
    inc h
    ld bc, $f8f5
    dec h
    ld bc, $00f5
    ld h, $01
    db $fd
    ld hl, sp+$27
    ld bc, $00fd
    jr z, jr_000_2afc

    add b

jr_000_2afc:
    db $ec
    ld sp, hl
    inc hl
    ld bc, $01ec
    inc h
    ld bc, $f9f4
    add hl, hl
    ld bc, $01f4
    ld a, [hl+]
    ld bc, $09f4
    dec hl
    ld bc, $0df1
    dec l
    ld bc, $f7fc
    rra
    ld bc, $fffc
    inc l
    ld bc, $ec80
    ld sp, hl
    inc hl
    ld bc, $01ec
    inc h
    ld bc, $12ee
    ld l, $01
    db $f4
    ld sp, hl
    add hl, hl
    ld bc, $01f4
    ld a, [hl+]
    ld bc, $09f4
    dec hl
    ld bc, $f7fc
    rra
    ld bc, $fffc
    inc l
    ld bc, $ec80
    ld sp, hl
    inc hl
    ld bc, $01ec
    inc h
    ld bc, $f9f4
    add hl, hl
    ld bc, $01f4
    ld a, [hl+]
    ld bc, $09f4
    dec hl
    ld bc, $f7fc
    rra
    ld bc, $fffc
    inc l
    db $01
    add b

    db $f0, $f8, $2f, $01, $f0, $00, $30, $01, $f8, $f8, $31, $01, $f8, $00, $32, $01
    db $80

    ldh a, [$fff8]
    inc sp
    ld bc, $00f0
    inc [hl]
    ld bc, $f8f8
    dec [hl]
    ld bc, $00f8
    ld [hl-], a
    db $01
    add b

    db $eb, $f8, $36, $01, $eb, $00, $37, $01, $f3, $f8, $38, $01, $f3, $00, $39, $01
    db $fb, $fc, $3a, $01, $80, $ec, $f8, $3b, $01, $ec, $00, $3c, $01, $f4, $f1, $3d
    db $01, $f4, $f9, $3e, $01, $f4, $01, $3f, $01, $fc, $f8, $40, $01, $fc, $00, $41
    db $01, $80, $ef, $f8, $42, $01, $ef, $00, $43, $01, $f7, $f8, $47, $01, $f7, $00
    db $48, $01, $fe, $f8, $46, $01, $fe, $00, $46, $21, $80, $ee, $f8, $42, $01, $ee
    db $00, $43, $01, $f6, $f8, $44, $01, $f6, $00, $45, $01, $fe, $f8, $46, $01, $fe
    db $00, $46, $21, $80, $eb, $f8, $49, $01, $eb, $00, $4a, $01, $f3, $f8, $4b, $01
    db $f3, $00, $4c, $01, $fb, $fc, $3a, $01, $80, $eb, $f8, $4d, $01, $eb, $00, $4e
    db $01, $f3, $f8, $4f, $01, $f3, $00, $50, $01, $fa, $f8, $1f, $01, $fa, $00, $20
    db $01, $80

    db $eb
    ld hl, sp+$51
    ld bc, $00eb
    ld d, d
    ld bc, $f8f3
    ld d, e
    ld bc, $00f3
    ld d, h
    ld bc, $f8fa
    dec de
    ld bc, $00fa
    inc e
    db $01
    add b

    db $eb, $f8, $eb, $01, $eb, $00, $ec, $01, $f3, $f8, $ed, $01, $f3, $00, $ee, $01
    db $fb, $f9, $ef, $21, $fb, $00, $ef, $01, $80, $f8, $f8, $d0, $10, $f8, $00, $d1
    db $10, $00, $f8, $d2, $10, $00, $00, $d3, $10, $80, $f8, $f8, $d4, $10, $f8, $00
    db $d5, $10, $00, $f8, $d6, $10, $00, $00, $d7, $10, $80, $f8, $f8, $d8, $10, $f8
    db $00, $d9, $10, $00, $f8, $da, $10, $00, $00, $db, $10, $80, $f8, $f8, $dc, $10
    db $f8, $00, $dd, $10, $00, $f8, $d2, $10, $00, $00, $de, $10, $80, $f8, $fc, $df
    db $10, $00, $fc, $e0, $10, $80, $f8, $f8, $e1, $10, $f8, $00, $e2, $10, $00, $f8
    db $e3, $10, $00, $00, $e4, $10, $80, $f8, $f8, $e5, $10, $f8, $00, $e6, $10, $00
    db $f8, $e7, $10, $00, $00, $e8, $10, $80

    ldh a, [$fffc]
    jp hl


    db $10
    ld hl, sp-$04
    ld [$8010], a

    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f4, $f0, $19, $01, $f3, $f8, $15, $01
    db $f3, $00, $16, $01, $fb, $f8, $17, $01, $fb, $00, $18, $01, $80, $ec, $f8, $13
    db $01, $ec, $00, $14, $01, $f4, $f0, $1e, $01, $f4, $f8, $1a, $01, $f4, $00, $1b
    db $01, $fc, $f8, $1c, $01, $fc, $00, $1d, $01, $80, $ec, $f8, $13, $01, $ec, $00
    db $14, $01, $f4, $f0, $1e, $01, $f4, $f8, $1f, $01, $f4, $00, $20, $01, $fc, $f8
    db $21, $01, $fc, $00, $22, $01, $80

    db $ed
    ld hl, sp+$23
    ld bc, $00ed
    inc h
    ld bc, $f0f5
    add hl, hl
    ld bc, $f8f5
    dec h
    ld bc, $00f5
    ld h, $01
    db $fd
    ld hl, sp+$27
    ld bc, $00fd
    jr z, jr_000_2d2d

    add b

jr_000_2d2d:
    db $ec
    ld sp, hl
    inc hl
    ld bc, $01ec
    inc h
    ld bc, $f1f4
    add hl, hl
    ld bc, $f9f4
    ld a, [hl+]
    ld bc, $01f4
    dec hl
    ld bc, $09f4
    inc l
    ld bc, $0df1
    cpl
    ld bc, $f9fc
    dec l
    ld bc, $01fc
    ld l, $01
    add b
    db $ec
    ld sp, hl
    inc hl
    ld bc, $01ec
    inc h
    ld bc, $12ee
    jr nc, jr_000_2d5f

    db $f4

jr_000_2d5f:
    pop af
    add hl, hl
    ld bc, $f9f4
    ld a, [hl+]
    ld bc, $01f4
    dec hl
    ld bc, $09f4
    inc l
    ld bc, $f9fc
    dec l
    ld bc, $01fc
    ld l, $01
    add b
    db $ec
    ld sp, hl
    inc hl
    ld bc, $01ec
    inc h
    ld bc, $f1f4
    add hl, hl
    ld bc, $f9f4
    ld a, [hl+]
    ld bc, $01f4
    dec hl
    ld bc, $09f4
    inc l
    ld bc, $f9fc
    dec l
    ld bc, $01fc
    ld l, $01
    add b

    db $f0, $f8, $31, $01, $f0, $00, $32, $01, $f8, $f8, $33, $01, $f8, $00, $34, $01
    db $80, $e8, $f8, $13, $01, $e8, $00, $14, $01, $f0, $f1, $35, $01, $f0, $f9, $36
    db $01, $f0, $01, $37, $01, $f8, $f5, $38, $01, $f8, $fd, $39, $01, $80, $e7, $f8
    db $13, $01, $e7, $00, $14, $01, $ef, $f0, $3a, $01, $ef, $f8, $3b, $01, $ef, $00
    db $3c, $01, $f7, $f5, $3d, $01, $f7, $fd, $3e, $01, $80, $ef, $f8, $3f, $01, $ef
    db $00, $40, $01, $f7, $f8, $44, $01, $f7, $00, $45, $01, $fe, $f8, $43, $01, $fe
    db $00, $43, $21, $80, $ee, $f8, $3f, $01, $ee, $00, $40, $01, $f6, $f8, $41, $01
    db $f6, $00, $42, $01, $fe, $f8, $43, $01, $fe, $00, $43, $21, $80, $eb, $f8, $46
    db $01, $eb, $00, $47, $01, $f3, $f8, $48, $01, $f3, $00, $49, $01, $fb, $f8, $4a
    db $01, $fb, $00, $4b, $01, $80, $eb, $f8, $4c, $01, $eb, $00, $4d, $01, $f3, $f8
    db $4e, $01, $f3, $00, $4f, $01, $fb, $f8, $50, $01, $fb, $00, $51, $01, $80, $eb
    db $f8, $52, $01, $eb, $00, $53, $01, $f3, $f8, $54, $01, $f3, $00, $55, $01, $fb
    db $f8, $56, $01, $fb, $00, $57, $01, $80, $e7, $f8, $58, $01, $e7, $00, $59, $01
    db $ef, $f8, $5a, $01, $ef, $00, $5b, $01, $f7, $f5, $5c, $01, $f7, $fd, $39, $01
    db $80, $e8, $f8, $58, $01, $e8, $00, $59, $01, $f0, $f1, $5d, $01, $f0, $f9, $5e
    db $01, $f0, $01, $5f, $01, $f8, $f2, $60, $01, $f8, $fa, $61, $01, $80, $fc, $fc
    db $62, $00, $80, $fc, $fc, $63, $00, $80, $ec, $f9, $13, $01, $ec, $01, $14, $01
    db $f4, $f2, $64, $01, $f4, $fa, $36, $01, $f4, $01, $3c, $01, $fc, $f9, $2d, $01
    db $fc, $01, $2e, $01, $80, $ec, $fb, $58, $01, $ec, $03, $59, $01, $f4, $f5, $65
    db $01, $f4, $fc, $5e, $01, $f4, $04, $5f, $01, $fc, $f9, $2d, $01, $fc, $01, $2e
    db $01, $80

    db $eb
    ld hl, sp+$00
    ld bc, $00eb
    ld bc, $f301
    ld hl, sp+$02
    ld bc, $00f3
    inc bc
    ld bc, $f8fb
    inc b
    ld bc, $00fb
    dec b
    ld bc, $eb80
    ld hl, sp+$06
    ld bc, $00eb
    rlca
    ld bc, $f8f3
    ld [$f301], sp
    nop
    add hl, bc
    ld bc, $f8fb
    ld a, [bc]
    ld bc, $00fb
    dec bc
    ld bc, $eb80
    db $fc
    inc c
    ld bc, $f8f3
    dec c
    ld bc, $00f3
    ld c, $01
    ei
    ld hl, sp+$0f
    ld bc, $00fb
    db $10
    ld bc, $eb80
    nop
    ld de, $f301
    rst $30
    ld de, $f321
    nop
    ld [de], a
    db $01
    add b

    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f0, $15, $01, $f3, $f8, $16, $01
    db $f3, $00, $17, $01, $fb, $f8, $18, $01, $fb, $00, $19, $01, $80, $ec, $f9, $13
    db $01, $ec, $01, $14, $01, $f4, $f1, $1a, $01, $f4, $f9, $1b, $01, $f4, $01, $1c
    db $01, $fc, $f8, $1d, $01, $fc, $00, $1e, $01, $80

    db $ed
    ld hl, sp+$1f
    ld bc, $00ed
    jr nz, jr_000_2f71

    push af

jr_000_2f71:
    ldh a, [rNR42]
    ld bc, $f8f5
    ld [hl+], a
    ld bc, $00f5
    inc hl
    ld bc, $f8fd
    inc h
    ld bc, $00fd
    dec h
    ld bc, $ec80
    ld sp, hl
    rra
    ld bc, $01ec
    jr nz, jr_000_2f8e

    db $f4

jr_000_2f8e:
    rst $30
    ld h, $01
    db $f4
    rst $38
    daa
    ld bc, $07f4
    jr z, jr_000_2f9a

    pop af

jr_000_2f9a:
    dec c
    dec hl
    ld bc, $f9fc
    add hl, hl
    ld bc, $01fc
    ld a, [hl+]
    ld bc, $ec80
    ld sp, hl
    rra
    ld bc, $01ec
    jr nz, @+$03

    xor $12
    inc l
    ld bc, $f7f4
    ld h, $01
    db $f4
    rst $38
    daa
    ld bc, $07f4
    jr z, jr_000_2fbf

    db $fc

jr_000_2fbf:
    ld sp, hl
    add hl, hl
    ld bc, $01fc
    ld a, [hl+]
    ld bc, $ec80
    ld sp, hl
    rra
    ld bc, $01ec
    jr nz, jr_000_2fd0

    db $f4

jr_000_2fd0:
    rst $30
    ld h, $01
    db $f4
    rst $38
    daa
    ld bc, $07f4
    jr z, jr_000_2fdc

    db $fc

jr_000_2fdc:
    ld sp, hl
    add hl, hl
    ld bc, $01fc
    ld a, [hl+]
    db $01
    add b

    db $f0, $f8, $2d, $01, $f0, $00, $2e, $01, $f8, $f8, $2f, $01, $f8, $00, $30, $01
    db $80, $eb, $f8, $31, $01, $eb, $00, $14, $01, $f3, $f0, $32, $01, $f3, $f8, $33
    db $01, $f3, $00, $34, $01, $fb, $f8, $35, $01, $fb, $00, $36, $01, $80, $ea, $f8
    db $13, $01, $ea, $00, $14, $01, $f2, $f0, $37, $01, $f2, $f8, $38, $01, $f2, $00
    db $39, $01, $fa, $f8, $35, $01, $fa, $00, $36, $01, $80, $ef, $f8, $3a, $01, $ef
    db $00, $3b, $01, $f7, $f8, $3f, $01, $f7, $00, $40, $01, $fe, $f8, $3e, $01, $fe
    db $00, $3e, $21, $80, $ee, $f8, $3a, $01, $ee, $00, $3b, $01, $f6, $f8, $3c, $01
    db $f6, $00, $3d, $01, $fe, $f8, $3e, $01, $fe, $00, $3e, $21, $80

    db $eb
    ld hl, sp+$41
    ld bc, $00eb
    ld b, d
    ld bc, $f8f3
    ld b, e
    ld bc, $00f3
    ld b, h
    ld bc, $fcfb
    ld b, l
    ld bc, $eb80
    ld hl, sp+$46
    ld bc, $00eb
    ld b, a
    ld bc, $f8f3
    ld c, b
    ld bc, $00f3
    ld c, c
    ld bc, $f8fb
    ld c, d
    ld bc, $00fb
    ld c, e
    ld bc, $eb80
    ld hl, sp+$4c
    ld bc, $00eb
    ld c, l
    ld bc, $f8f3
    ld c, [hl]
    ld bc, $00f3
    ld c, a
    ld bc, $f8fb
    ld d, b
    ld bc, $00fb
    ld d, c
    db $01
    add b

    db $ec, $f8, $31, $01, $ec, $00, $14, $01, $f4, $f0, $32, $01, $f4, $f8, $33, $01
    db $f4, $00, $17, $01, $fc, $f8, $1d, $01, $fc, $00, $1e, $01, $80, $ec, $f9, $52
    db $01, $ec, $01, $53, $01, $f4, $f2, $54, $01, $f4, $fa, $55, $01, $f4, $02, $56
    db $01, $fc, $f8, $57, $01, $fc, $00, $1e, $01, $80, $fc, $fc, $58, $01, $80, $eb
    db $f8, $52, $01, $eb, $00, $53, $01, $f3, $f1, $54, $01, $f3, $f9, $55, $01, $f3
    db $01, $56, $01, $fb, $f8, $35, $01, $fb, $00, $36, $01, $80, $ea, $f8, $52, $01
    db $ea, $00, $53, $01, $f2, $f1, $54, $01, $f2, $f9, $55, $01, $f2, $01, $56, $01
    db $fa, $f8, $35, $01, $fa, $00, $36, $01, $80, $eb, $f8, $13, $01, $eb, $00, $14
    db $01, $f3, $f8, $15, $01, $f3, $00, $16, $01, $fb, $f8, $17, $01, $fb, $00, $18
    db $01, $80, $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $19, $01, $f4, $00
    db $1a, $01, $fc, $f8, $1b, $01, $fc, $00, $1c, $01, $80, $ec, $f8, $13, $01, $ec
    db $00, $14, $01, $f4, $f8, $1d, $01, $f4, $00, $1e, $01, $fc, $f8, $1f, $01, $fc
    db $00, $20, $01, $80

    db $ed
    ld hl, sp+$21
    ld bc, $00ed
    ld [hl+], a
    ld bc, $f8f5
    inc hl
    ld bc, $00f5
    inc h
    ld bc, $f8fd
    dec h
    ld bc, $00fd
    ld h, $01
    add b
    db $ec
    ld sp, hl
    ld hl, $ec01
    ld bc, $0122
    db $f4
    ld sp, hl
    daa
    ld bc, $01f4
    jr z, jr_000_3196

    db $f4

jr_000_3196:
    add hl, bc
    add hl, hl
    ld bc, $0df1
    dec hl
    ld bc, $f7fc
    rra
    ld bc, $fffc
    ld a, [hl+]
    ld bc, $ec80
    ld sp, hl
    ld hl, $ec01
    ld bc, $0122
    xor $12
    inc l
    ld bc, $f9f4
    daa
    ld bc, $01f4
    jr z, jr_000_31bb

    db $f4

jr_000_31bb:
    add hl, bc
    add hl, hl
    ld bc, $f7fc
    rra
    ld bc, $fffc
    ld a, [hl+]
    ld bc, $ec80
    ld sp, hl
    ld hl, $ec01
    ld bc, $0122
    db $f4
    ld sp, hl
    daa
    ld bc, $01f4
    jr z, jr_000_31d8

    db $f4

jr_000_31d8:
    add hl, bc
    add hl, hl
    ld bc, $f7fc
    rra
    ld bc, $fffc
    ld a, [hl+]
    db $01
    add b

    db $f0, $f8, $2d, $01, $f0, $00, $2e, $01, $f8, $f8, $2f, $01, $f8, $00, $30, $01
    db $80, $eb, $f8, $31, $01, $eb, $00, $32, $01, $f3, $f8, $33, $01, $f3, $00, $34
    db $01, $fb, $fc, $35, $01, $80, $ec, $f8, $36, $01, $ec, $00, $37, $01, $f4, $f1
    db $38, $01, $f4, $f9, $39, $01, $f4, $01, $3a, $01, $fc, $f8, $3b, $01, $fc, $00
    db $3c, $01, $80

    rst $28
    ld hl, sp+$3d
    ld bc, $00ef
    ld a, $01
    rst $30
    ld hl, sp+$42
    ld bc, $00f7
    ld b, e
    ld bc, $f8fe
    ld b, h
    ld bc, $00fe
    ld b, h
    ld hl, $ee80
    ld hl, sp+$3d
    ld bc, $00ee
    ld a, $01
    or $f8
    ccf
    ld bc, $00f6
    ld b, b
    ld bc, $f8fe
    ld b, h
    ld bc, $00fe
    ld b, h
    ld hl, $eb80
    ld hl, sp+$45
    ld bc, $00eb
    ld b, [hl]
    ld bc, $f8f3
    ld b, a
    ld bc, $00f3
    ld c, b
    ld bc, $fcfb
    dec [hl]
    ld bc, $eb80
    ld hl, sp+$49
    ld bc, $00eb
    ld c, d
    ld bc, $f8f3
    ld c, e
    ld bc, $00f3
    ld c, h
    ld bc, $f8fa
    rra
    ld bc, $00fa
    jr nz, jr_000_3287

    add b

jr_000_3287:
    db $eb
    ld hl, sp+$4d
    ld bc, $00eb
    ld c, [hl]
    ld bc, $f8f3
    ld c, a
    ld bc, $00f3
    ld d, b
    ld bc, $f8fa
    dec de
    ld bc, $00fa
    inc e
    db $01
    add b

    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $51, $01, $f3, $00, $52, $01
    db $fb, $f9, $53, $21, $fb, $00, $53, $01, $80, $ec, $f8, $13, $01, $ec, $00, $14
    db $01, $f4, $f8, $54, $01, $f4, $00, $55, $01, $fc, $f9, $56, $21, $fc, $00, $56
    db $01, $80, $f8, $f8, $57, $01, $f8, $00, $58, $01, $fb, $08, $59, $01, $00, $f8
    db $57, $41, $00, $00, $58, $41, $80, $f7, $f8, $57, $01, $f7, $00, $58, $01, $fa
    db $08, $59, $01, $ff, $f8, $57, $41, $ff, $00, $58, $41, $80, $ec, $f8, $13, $01
    db $ec, $00, $14, $01, $f4, $f8, $54, $01, $f4, $00, $55, $01, $f0, $08, $58, $01
    db $f3, $10, $59, $01, $fc, $f9, $56, $21, $fc, $00, $56, $01, $f8, $08, $58, $41
    db $80, $f8, $04, $18, $01, $f8, $fc, $17, $01, $f8, $f4, $16, $01, $f0, $04, $15
    db $01, $f0, $fc, $14, $01, $f0, $f4, $13, $01, $80, $f9, $04, $1b, $01, $f9, $fc
    db $1a, $01, $f9, $f4, $19, $01, $f1, $04, $15, $01, $f1, $fc, $14, $01, $f1, $f4
    db $13, $01, $80

    ld hl, sp+$00
    rra
    ld bc, $f8f8
    ld e, $01
    ldh a, [rP1]
    dec e
    ld bc, $f8f0
    inc e
    ld bc, $f580
    inc c
    inc hl
    ld bc, $f9f0
    inc e
    ld bc, $01f0
    dec e
    ld bc, $08f8
    ld [hl+], a
    ld bc, $00f8
    ld hl, $f801
    ld hl, sp+$20
    ld bc, $f280
    ld de, $0124
    ldh a, [$fff9]
    inc e
    ld bc, $01f0
    dec e
    ld bc, $08f8
    ld [hl+], a
    ld bc, $00f8
    ld hl, $f801
    ld hl, sp+$20
    ld bc, $f080
    ld sp, hl
    inc e
    ld bc, $01f0
    dec e
    ld bc, $08f8
    ld [hl+], a
    ld bc, $00f8
    ld hl, $f801
    ld hl, sp+$20
    db $01
    add b

    db $f8, $04, $18, $01, $f0, $04, $15, $01, $f8, $fc, $17, $01, $f0, $fc, $26, $01
    db $f8, $f4, $27, $01, $f0, $f4, $25, $01, $80, $f8, $04, $18, $01, $f8, $fc, $17
    db $01, $f8, $f4, $29, $01, $f0, $04, $15, $01, $f0, $fc, $26, $01, $f0, $f4, $28
    db $01, $80, $ef, $00, $2b, $01, $ef, $f8, $2a, $01, $f7, $00, $31, $01, $f7, $f8
    db $30, $01, $ff, $f8, $32, $01, $ff, $00, $33, $01, $80, $fe, $00, $2f, $01, $fe
    db $f8, $2e, $01, $f6, $00, $2d, $01, $f6, $f8, $2c, $01, $ee, $00, $2b, $01, $ee
    db $f8, $2a, $01, $80, $eb, $00, $35, $01, $eb, $f8, $34, $01, $f3, $00, $37, $01
    db $f3, $f8, $36, $01, $fb, $00, $39, $01, $fb, $f8, $38, $01, $80, $eb, $00, $3b
    db $01, $eb, $f8, $3a, $01, $f3, $00, $3d, $01, $f3, $f8, $3c, $01, $fb, $00, $3f
    db $01, $fb, $f8, $3e, $01, $80, $eb, $00, $41, $01, $eb, $f8, $40, $01, $f3, $00
    db $43, $01, $f3, $f8, $42, $01, $fb, $00, $45, $01, $fb, $f8, $44, $01, $80, $f0
    db $08, $47, $01, $f0, $10, $48, $01, $f0, $04, $46, $01, $f8, $04, $18, $01, $f8
    db $fc, $17, $01, $f0, $fc, $14, $01, $f0, $f4, $13, $01, $f8, $f4, $16, $01, $80
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $14, $01, $f8, $fc, $17, $01, $f0, $f4, $13, $01
    db $f8, $f4, $16, $01, $80, $f1, $1c, $48, $01, $f1, $14, $47, $01, $f1, $0c, $47
    db $01, $f1, $04, $46, $01, $f9, $04, $1b, $01, $f1, $fc, $14, $01, $f9, $fc, $1a
    db $01, $f1, $f4, $13, $01, $f9, $f4, $19, $01, $80, $f0, $08, $47, $01, $f0, $10
    db $48, $01, $f0, $04, $46, $01, $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc
    db $17, $01, $f0, $f4, $25, $01, $f8, $f4, $27, $01, $80, $f0, $1c, $48, $01, $f0
    db $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01, $f8, $04, $18, $01, $f0
    db $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $25, $01, $f8, $f4, $27, $01, $80
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $28, $01
    db $f8, $f4, $29, $01, $80, $f1, $10, $48, $01, $f1, $08, $47, $01, $f1, $04, $46
    db $01, $f1, $fc, $14, $01, $f1, $f4, $13, $01, $f9, $04, $1b, $01, $f9, $fc, $1a
    db $01, $f9, $f4, $19, $01, $80, $f0, $10, $48, $01, $f0, $08, $47, $01, $f0, $04
    db $46, $01, $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4
    db $28, $01, $f8, $f4, $29, $01, $80, $00, $ff, $7e, $81, $7e, $81, $7e, $81, $7e
    db $81, $7e, $81, $7e, $81, $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $fe, $01, $fe, $01, $fe, $01, $aa, $01, $d6, $01, $aa, $01, $d6, $01, $aa
    db $01, $d6, $01, $aa, $01, $d6, $01, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $00, $80, $00, $ff, $00, $80, $00, $02, $05, $02, $05, $02, $05, $02, $05, $ff
    db $00, $01, $00, $ff, $00, $01, $00, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f
    db $80, $7f, $80, $7f, $80, $7f, $80, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe
    db $01, $fe, $01, $fe, $01, $fe, $01, $00, $c0, $c0, $20, $20, $d0, $d0, $28, $a8
    db $14, $d4, $0a, $aa, $05, $d4, $03, $ff, $ff, $7f, $80, $00, $ff, $7f, $80, $7f
    db $80, $7f, $80, $7f, $80, $7f, $80, $ff, $ff, $fe, $01, $00, $ff, $fe, $01, $fe
    db $01, $fe, $01, $fe, $01, $fe, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $7f, $80, $00, $ff, $40, $a0, $40
    db $a0, $40, $a0, $40, $a0, $40, $a0, $ff, $ff, $ff, $00, $00, $ff, $00, $00, $00
    db $00, $00, $ff, $7e, $81, $7e, $81, $ff, $ff, $ff, $00, $00, $ff, $00, $00, $00
    db $00, $00, $0f, $07, $08, $07, $08, $ff, $ff, $fe, $01, $00, $ff, $02, $05, $02
    db $05, $02, $f5, $e2, $15, $e2, $15, $40, $af, $47, $a8, $47, $a8, $47, $a8, $47
    db $a8, $47, $a8, $47, $a8, $40, $bf, $1e, $e1, $9e, $21, $de, $21, $de, $21, $de
    db $21, $de, $21, $de, $21, $00, $ff, $00, $7f, $38, $41, $38, $41, $3e, $41, $3e
    db $41, $3e, $41, $3e, $41, $00, $ff, $e2, $15, $e2, $15, $e2, $15, $e2, $15, $e2
    db $15, $e2, $15, $e2, $15, $02, $fd, $40, $a0, $40, $a0, $40, $a0, $40, $af, $47
    db $a8, $47, $a8, $47, $a8, $47, $a8, $00, $00, $00, $00, $00, $00, $00, $fe, $fc
    db $02, $fc, $02, $80, $7f, $be, $41, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $04, $03, $04, $03, $04, $02, $05, $02, $05, $02, $05, $02, $05, $02
    db $f5, $e2, $15, $e2, $15, $e2, $15, $47, $a8, $47, $a8, $47, $a8, $47, $a8, $47
    db $a8, $47, $a8, $47, $a8, $40, $bf, $00, $00, $00, $00, $00, $00, $08, $00, $08
    db $00, $08, $00, $38, $00, $f8, $00, $3c, $00, $3f, $00, $3f, $00, $3f, $00, $1f
    db $00, $0f, $00, $0f, $00, $0f, $00, $3c, $00, $fc, $00, $fc, $00, $fc, $00, $f8
    db $00, $f0, $00, $f0, $00, $f0, $00, $1f, $00, $1f, $00, $1f, $00, $0f, $00, $07
    db $00, $03, $00, $01, $00, $00, $00, $f8, $00, $f8, $00, $f8, $00, $f0, $00, $e0
    db $00, $c0, $00, $80, $00, $00, $00, $00, $00, $18, $00, $24, $00, $44, $00, $5c
    db $00, $60, $00, $60, $00, $60, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $ff, $00, $ff, $ff, $01, $00, $02, $00, $02, $00, $02, $00, $05
    db $00, $05, $00, $05, $00, $0a, $00, $00, $00, $80, $00, $80, $00, $80, $00, $40
    db $00, $40, $00, $40, $00, $a0, $00, $0a, $00, $0a, $00, $15, $00, $15, $00, $17
    db $00, $2e, $00, $3a, $00, $2a, $00, $a0, $00, $a0, $00, $50, $00, $50, $00, $d0
    db $00, $e8, $00, $b8, $00, $a8, $00, $55, $00, $55, $00, $55, $00, $2a, $00, $2a
    db $00, $15, $00, $0d, $00, $03, $00, $54, $00, $54, $00, $54, $00, $a8, $00, $a8
    db $00, $50, $00, $60, $00, $80, $00, $00, $00, $00, $00, $01, $00, $02, $00, $04
    db $00, $04, $00, $04, $00, $04, $00, $7c, $00, $82, $00, $01, $00, $01, $00, $01
    db $00, $01, $00, $03, $00, $06, $00, $04, $00, $0f, $00, $1c, $00, $38, $00, $70
    db $00, $e0, $00, $c0, $00, $00, $00, $1c, $00, $f0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $ff, $00, $80, $00, $ff, $00, $80, $00, $ff
    db $00, $80, $00, $ff, $00, $80, $00, $fe, $00, $02, $00, $fe, $00, $02, $00, $fe
    db $00, $02, $00, $fe, $00, $02, $00, $00, $80, $19, $80, $00, $80, $00, $80, $00
    db $80, $1c, $80, $1c, $80, $14, $80, $00, $00, $ce, $00, $00, $00, $00, $00, $00
    db $00, $ee, $00, $ec, $00, $cc, $00, $00, $01, $b0, $01, $00, $01, $00, $01, $00
    db $01, $cc, $01, $ec, $01, $e8, $01, $0f, $b0, $1f, $a0, $1f, $a0, $1f, $a0, $1f
    db $a0, $1f, $a0, $00, $ff, $00, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $00, $ff, $00, $00, $f0, $0d, $f8, $05, $f8, $05, $f8, $05, $f8
    db $05, $f8, $05, $00, $ff, $00, $01, $60, $00, $60, $00, $60, $00, $60, $00, $60
    db $00, $60, $00, $60, $00, $60, $00, $00, $00, $00, $00, $00, $00, $10, $00, $10
    db $00, $10, $00, $1c, $00, $1f, $00, $ff, $ff, $0f, $80, $3f, $80, $3f, $80, $7f
    db $80, $7f, $80, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $00, $ff, $ff, $ff, $ff, $ff, $fe, $01, $fe, $01, $fe, $01, $fe
    db $01, $fe, $01, $00, $ff, $ff, $ff, $00, $80, $00, $80, $7f, $80, $ff, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00, $ff, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $fe, $01, $ff, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $f7, $00, $0f, $00, $ff, $00, $e3, $00, $dd
    db $00, $36, $00, $3e, $00, $1c, $00, $00, $00, $01, $00, $7f, $00, $07, $00, $1f
    db $00, $3f, $00, $3f, $00, $1f, $00, $00, $00, $c0, $00, $f0, $00, $f0, $00, $fc
    db $00, $fe, $00, $fe, $00, $fc, $00, $ff, $00, $80, $00, $9b, $00, $80, $00, $ff
    db $00, $80, $00, $bc, $00, $bc, $00, $ff, $00, $01, $00, $01, $00, $01, $00, $ff
    db $00, $01, $00, $69, $00, $01, $00, $af, $50, $af, $50, $af, $50, $af, $50, $af
    db $50, $af, $50, $af, $50, $af, $50, $20, $5f, $20, $50, $20, $50, $00, $70, $30
    db $88, $70, $88, $70, $88, $00, $70, $04, $fa, $04, $0a, $04, $0a, $00, $0e, $06
    db $11, $0e, $11, $0e, $11, $00, $0e, $f5, $0a, $f5, $0a, $f5, $0a, $f5, $0a, $f5
    db $0a, $f5, $0a, $f5, $0a, $f5, $0a, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $20, $50, $20, $50, $20, $50, $20, $50, $20
    db $50, $20, $50, $20, $50, $20, $50, $04, $0a, $04, $0a, $04, $0a, $04, $0a, $04
    db $0a, $04, $0a, $04, $0a, $04, $0a, $7f, $00, $80, $00, $80, $00, $8f, $00, $9f
    db $00, $9e, $00, $9e, $00, $9e, $00, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff
    db $00, $00, $00, $00, $00, $00, $00, $fe, $00, $01, $00, $01, $00, $f1, $00, $f9
    db $00, $79, $00, $79, $00, $79, $00, $9e, $00, $9e, $00, $9e, $00, $9f, $00, $8f
    db $00, $80, $00, $80, $00, $96, $00, $00, $00, $00, $00, $00, $00, $ff, $00, $ff
    db $00, $00, $00, $7c, $00, $7f, $00, $79, $00, $79, $00, $79, $00, $f1, $00, $e1
    db $00, $01, $00, $c1, $00, $41, $00, $80, $00, $80, $00, $86, $00, $86, $00, $9f
    db $00, $9f, $00, $86, $19, $86, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
    db $00, $80, $00, $03, $80, $07, $00, $01, $00, $01, $00, $01, $00, $01, $00, $19
    db $00, $3d, $00, $3d, $00, $99, $24, $80, $06, $80, $00, $80, $00, $80, $00, $80
    db $00, $80, $00, $7f, $80, $00, $7f, $07, $00, $03, $04, $00, $03, $00, $00, $00
    db $00, $00, $00, $ff, $00, $00, $ff, $81, $18, $01, $80, $01, $00, $01, $00, $01
    db $00, $01, $00, $fe, $01, $00, $fe, $00, $ff, $7e, $81, $42, $81, $42, $81, $42
    db $81, $42, $81, $42, $81, $42, $81, $ff, $00, $ff, $00, $ff, $00, $c0, $00, $c0
    db $00, $c0, $00, $c0, $00, $c0, $00, $ff, $00, $ff, $00, $ff, $00, $03, $00, $03
    db $00, $03, $00, $03, $00, $03, $00, $c0, $00, $c0, $00, $c0, $00, $c0, $00, $c0
    db $00, $ff, $00, $ff, $00, $ff, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03
    db $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $7e, $00, $7e, $00, $42, $00, $7e
    db $00, $7e, $00, $7e, $00, $7e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7e
    db $00, $66, $00, $18, $00, $7e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $0f, $00, $7d, $00, $be, $00, $ff, $00, $e3, $00, $dd
    db $00, $36, $00, $3e, $00, $1c, $00, $aa, $00, $55, $00, $aa, $00, $55, $00, $aa
    db $00, $55, $00, $aa, $00, $55, $00, $ff, $00, $ff, $00, $a9, $00, $55, $00, $a9
    db $00, $55, $00, $a9, $00, $55, $00, $a9, $00, $55, $00, $a9, $00, $55, $00, $a9
    db $00, $55, $00, $a9, $00, $55, $00, $ff, $ff, $0f, $80, $3f, $80, $3f, $80, $7f
    db $80, $7f, $80, $00, $ff, $ff, $ff, $ff, $ff, $fe, $01, $fe, $01, $fe, $01, $fe
    db $01, $fe, $01, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $ff, $00, $ff, $00, $00
    db $00, $ff, $00, $00, $00, $00, $00, $ff, $00, $f0, $00, $c0, $00, $83, $00, $8f
    db $00, $8f, $00, $c7, $00, $e0, $00, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $be, $00, $ff, $00, $0f, $00, $01, $00, $c0, $00, $f0
    db $00, $f8, $00, $f1, $00, $83, $00, $ff, $00, $ff, $00, $ef, $08, $ff, $98, $7f
    db $47, $38, $38, $60, $60, $ff, $c0, $ff, $00, $ff, $00, $ff, $00, $ff, $7f, $f0
    db $80, $18, $00, $0c, $00, $ff, $00, $ff, $ff, $00, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $02, $fd, $04, $fb, $08, $f7
    db $10, $f0, $20, $ff, $40, $ff, $7f, $ff, $01, $fe, $02, $fd, $04, $fb, $08, $f7
    db $10, $ef, $20, $df, $40, $bf, $80, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $00, $00, $ff, $00, $ff, $ff, $e0, $80, $e0, $80, $e0, $80, $e0, $80, $e0
    db $80, $e0, $80, $e0, $80, $e0, $80, $07, $01, $07, $01, $07, $01, $07, $01, $07
    db $01, $07, $01, $07, $01, $07, $01, $e0, $80, $e0, $80, $e0, $80, $e0, $80, $e0
    db $80, $ff, $80, $ff, $80, $7f, $7f, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $ff, $07, $01, $07, $01, $07, $01, $07, $01, $07
    db $01, $ff, $01, $ff, $01, $fe, $fe, $ff, $00, $ff, $00, $aa, $00, $55, $00, $aa
    db $00, $55, $00, $22, $00, $00, $00, $ff, $00, $ff, $00, $aa, $00, $55, $00, $aa
    db $00, $55, $00, $aa, $00, $55, $00, $6a, $00, $55, $00, $6a, $00, $55, $00, $6a
    db $00, $55, $00, $6a, $00, $55, $00, $ff, $00, $ff, $00, $6a, $00, $55, $00, $6a
    db $00, $55, $00, $6a, $00, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00

    nop
    ld b, $09
    ld de, $1412
    inc d
    ccf
    nop
    ld bc, $0202
    ld [bc], a
    ld [bc], a
    ld bc, $d800
    inc b
    inc b
    ld b, b
    nop
    nop
    nop
    add b
    ldh [rNR32], a
    ld [bc], a
    ld bc, $0100
    nop
    nop

jr_000_3cd2:
    nop
    ld c, $11
    and c
    ld c, [hl]
    or b
    ld h, b
    ld d, b
    nop
    nop
    nop
    nop
    nop
    inc a
    ld a, a
    ld h, [hl]
    ld b, [hl]
    inc sp
    inc c
    inc de
    db $10
    jr nz, jr_000_3cd2

    ld a, [$8100]
    nop
    ret nz

    ccf
    adc b
    ld [$5044], sp
    db $10
    db $10
    jr nz, @-$3e

    nop
    ld h, b
    ld d, b
    nop
    nop
    nop
    inc bc
    inc c

Jump_000_3cff:
    db $10
    jr nz, jr_000_3d22

    ld b, [hl]
    add [hl]
    cp b
    inc b
    inc b
    jr nc, jr_000_3d51

    ld c, b
    ld a, $0f
    nop
    rrca
    rrca
    ld bc, $8971
    add h
    ld [bc], a
    add e
    ld b, b
    and b
    and b
    xor h
    or d
    ld d, b
    sub e
    daa
    ret


    or d
    adc h
    add h
    add e

jr_000_3d22:
    nop
    add b
    nop
    nop
    ld c, $1c
    inc h
    call nz, $4040
    ld b, b
    ld b, b
    ld h, $29
    add hl, de
    ld c, $30
    ld bc, $0202
    ld bc, $0000
    nop
    inc b
    add d

jr_000_3d3c:
    ld b, d
    ld b, d
    add b
    nop
    nop
    ld [bc], a
    ld [hl], c
    ld [hl], b
    ld [hl], b
    db $10
    ld [$0808], sp
    db $10
    pop bc
    ld hl, $1010
    ld [$0c0b], sp

jr_000_3d51:
    db $10
    ld [$e010], sp
    add b
    add b
    nop
    nop
    nop
    dec c
    ld [de], a
    inc de
    inc c
    nop
    nop
    nop
    nop
    ret nz

    ccf
    ret nz

    ld bc, $0202
    ld bc, $0d00
    ldh a, [$ff80]
    add b
    ld c, a
    ld [hl], b
    add b
    nop
    ldh [rP1], a
    inc bc
    inc e
    ldh [rP1], a
    nop
    nop
    jr nz, jr_000_3d3c

    nop
    nop
    nop
    nop
    nop
    nop
    sbc c
    sbc c
    sbc c
    sbc c
    sbc c
    sbc c
    sbc c
    sbc c
    rst $38
    nop
    nop

jr_000_3d8d:
    rst $38
    rst $38
    nop
    nop
    rst $38
    rrca
    jr nc, @+$42

    ld b, a
    adc a
    sbc [hl]
    sbc h
    sbc b
    nop
    nop
    inc bc
    rra
    ccf
    ld [hl], c
    ld [hl], b
    ld h, a
    rra
    rst $38
    pop bc
    inc bc
    add a

jr_000_3da7:
    add [hl]
    ld bc, $f082
    cp $ff
    ei
    dec e
    inc c
    ldh a, [$ff08]
    nop
    nop
    add b
    ret nz

    ldh [$fff0], a
    ldh a, [$ff78]
    nop
    nop
    nop
    nop
    ld bc, $0201
    ld [bc], a
    jr z, jr_000_3de4

jr_000_3dc4:
    ld b, c
    add e
    inc bc
    inc bc
    ld bc, $4400
    jr nz, jr_000_3d8d

    ldh [$ff60], a
    ldh [$ffc0], a
    nop
    inc b
    ld [hl], b
    ld hl, sp-$28
    ld hl, sp+$71
    ld [bc], a
    inc e
    inc b
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    call nz, $2038
    ld [bc], a
    ld [bc], a

jr_000_3de4:
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    ld bc, $6282
    ld e, a
    add b
    add b
    nop
    inc bc
    sbc [hl]
    ld h, c
    ld b, c
    adc b
    add b
    add b
    jr nz, @+$01

    ld c, $01
    nop
    nop
    nop
    nop
    jr nz, jr_000_3dc4

    ld b, b
    ldh [$ff31], a
    ld a, [bc]
    inc b
    dec b
    nop
    nop

jr_000_3e0c:
    nop
    nop
    ldh a, [$ff08]
    ld [$80f0], sp
    add b
    ld b, b
    jr nz, jr_000_3e4f

    daa
    jr nz, @+$22

    ld b, b
    and b
    ld a, b
    ld d, $13
    db $fd
    add hl, bc

jr_000_3e21:
    stop
    nop
    ret nz

    jr nc, jr_000_3da7

    ld [hl], b
    ccf
    jp nz, Jump_000_053a

    dec b
    ld bc, $0111
    ld b, $f8
    jr nz, @+$49

    ld a, b
    jr nz, @+$22

    jr nz, jr_000_3e58

    ld [$1510], sp
    db $e3
    jr nz, jr_000_3e5f

    jr nz, jr_000_3e21

    sub e
    ld [bc], a
    inc bc
    ld d, d
    ld h, h
    inc b
    rlca
    inc b
    ld c, $80
    add b
    add b
    add b
    ld b, b

jr_000_3e4f:
    ret nz

    jr nz, jr_000_3e72

    ld [$0204], sp
    ld bc, $0003

jr_000_3e58:
    nop
    nop
    sub h
    ld e, b
    ld b, b
    ld b, b
    ret nz

jr_000_3e5f:
    nop
    nop
    nop
    adc c
    ld c, b
    jr z, jr_000_3e7e

    nop
    nop
    nop
    nop
    jr nz, jr_000_3e0c

    ldh a, [rP1]
    nop
    nop
    nop
    nop

jr_000_3e72:
    nop
    nop
    nop
    nop
    nop
    nop
    inc e
    inc hl
    jr nz, jr_000_3e9a

    inc bc
    inc b

jr_000_3e7e:
    dec bc
    inc d
    db $10
    ld [de], a
    add b
    ld a, a
    add b
    nop
    nop
    add b
    nop
    nop
    nop
    db $e3
    inc e
    inc bc
    dec c
    ld [de], a
    ld bc, $0001
    ldh [rNR10], a
    adc b
    ld c, b
    or b
    ld b, b
    ld b, b

jr_000_3e9a:
    db $10
    db $10
    ld [$0007], sp
    nop
    nop
    ld bc, $0000
    ld e, $00
    rst $38
    ld b, b
    add b
    and b
    inc b
    nop
    nop
    rrca
    ldh a, [rNR41]
    db $10
    db $10
    ld b, b
    ld b, b
    add b
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
    ld bc, $0601
    nop
    ld a, b
    rst $38
    call $0c8c
    ld [hl], b
    ld [$3807], sp
    rst $00
    ldh a, [$ff7c]
    ld e, $01
    ld e, $80
    ld [hl], b
    ld [$4284], sp
    ld hl, $8811
    ld bc, $0101
    inc bc
    inc bc
    rlca
    ld b, $8e
    ld h, h
    ret c

    pop hl
    ld e, [hl]
    ld b, b
    jr nz, jr_000_3f09

    jr nz, jr_000_3efd

    inc de
    ld [de], a
    inc c
    add hl, bc
    ld c, $08
    ld [$0000], sp
    add b
    add b
    nop
    nop
    nop
    nop
    jr jr_000_3f1c

    ld b, b

jr_000_3efd:
    ld b, b
    add b
    add b

Call_000_3f00:
Jump_000_3f00:
    add b
    add a
    ld [$9060], sp
    sub c
    ld h, b
    inc bc
    inc b

jr_000_3f09:
    inc b
    rra
    inc bc
    db $e3
    inc de
    ld [$8404], sp
    add h
    ld c, b
    ld b, h
    ld b, h
    ld h, l
    rst $38
    rst $38
    jp hl


    ld sp, $b89c

jr_000_3f1c:
    ldh a, [$ffe0]
    add b
    nop
    nop
    nop
    ld b, a
    ld c, b
    ld d, b
    ld d, b
    ld h, b
    nop
    nop
    nop
    ld [$5090], sp
    ld d, b
    ld h, b
    nop
    nop
    nop
    ld c, b
    ld d, b
    jr nc, jr_000_3f4e

    ld h, $21
    inc e
    dec bc
    add e
    ld b, b
    ld b, b
    ld b, b
    add b
    rst $38
    ld c, b
    adc a
    nop
    nop
    nop
    inc b
    dec de
    ldh [c], a
    inc b
    ld hl, sp+$1e
    ld [de], a
    ld [de], a
    ld [hl-], a

jr_000_3f4e:
    call $0605
    nop
    add hl, bc
    ld a, [bc]
    ld [de], a
    inc e
    nop
    nop
    nop
    nop
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    rlca
    nop
    nop
    ld b, b
    ld b, b
    ld b, b
    add b
    add b
    nop
    nop
    nop

Call_000_3f6a:
    ldh [$ff8f], a
    ldh [$ff92], a
    ld hl, $5701
    ld de, $8d00
    ld bc, $0300
    ld a, $05
    call LoadGameGfx
    ld a, $04
    ld [$d933], a
    ret


    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
