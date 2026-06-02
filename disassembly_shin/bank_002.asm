; Disassembly of "shin_debug.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

    db $02, $15, $40, $06, $41, $d7, $48, $f9, $48

    push af
    ld b, a
    scf
    ld c, b

    db $6e, $68, $a1, $69, $0c, $73, $a8, $74

    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld [$d954], a
    ld [$d955], a
    ld a, $01
    ldh [rIE], a
    ld a, $a0
    ldh [hOamMaxY], a
    ld a, $03
    ld [$d97a], a
    xor a
    ldh [hNeedsReset], a
    ld a, [$d93d]
    cp $04
    jp z, Jump_002_47f5

    or a
    jp nz, Jump_002_43a1

    ld a, $83
    ld [wLCDCShadow], a
    ld a, $06
    ld hl, $4001
    ld de, $8000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $501e
    ld de, $c800
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $1412
    call jr_000_05f7
    call InitSound

Call_002_4079::
    ld a, $28
    call PlaySound_Queue3
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $01
    ld [$d933], a
    ld hl, $78a1
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    ld hl, $78d9
    ld a, l
    ld [$d803], a
    ld a, h
    ld [$d804], a
    xor a
    ld [$d802], a
    ld [$d805], a
    ld [$d96d], a
    ldh [$ffb9], a
    ldh [$ff9f], a
    ld a, [$d934]
    or a
    jr nz, jr_002_40bd

    ld [$d93c], a

jr_002_40bd::
    ld a, $01
    ld hl, $d961
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld hl, $d964
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld a, [$d934]
    or a
    ret z

    ld hl, $99a0
    ld bc, $00a0
    call bzero
    ld a, $02
    ld [$d970], a
    ld a, [$d934]
    add $0c
    call Call_000_0710
    ld hl, $78a8
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld a, [$d934]
    cp $01
    ld a, [$d983]
    jr z, jr_002_4102

    ld a, [$d984]

jr_002_4102::
    ld [$d93c], a
    ret


    ld a, [$d93d]
    rst $00

    db $14, $41

    call $1f44
    ld b, h
    xor [hl]
    ld b, h
    scf
    ld c, b

    ld c, $34
    ld b, $60
    ld de, $d803
    call Call_000_0720
    ld c, $68
    ld b, $60
    ld de, $d800
    call Call_000_0720
    ld a, [$d955]
    inc a
    ld [$d955], a
    and $03
    jr nz, jr_002_4154

    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $b4
    jr c, jr_002_4154

    ld a, $c0
    ld [$d954], a
    jr nz, jr_002_4154

    ld hl, $78a8
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a

jr_002_4154::
    call UpdateMenuMessageVramClear
    ld a, [$d96d]
    or a
    ret nz

    ld a, [$d934]
    rst $00

    db $66, $41, $7a, $41

    cp [hl]
    ld b, c

    ldh a, [hJoyPressed]
    and $09
    ret z

jr_002_416b::
    ld a, $01
    ld [$d934], a
    call StartMenuMessage
    ld a, [$d983]
    ld [$d93c], a
    ret


    call UpdateMenuCursor
    ld a, [$d93c]
    ld b, a
    ld [$d983], a
    ldh a, [hJoyPressed]
    and $09
    ret z

    ld a, [$d93c]
    or a
    jr nz, jr_002_41a3

    ld a, [$dffd]
    or a
    jr z, jr_002_419a

    ld a, $04
    ld [$dffe], a

jr_002_419a::
    ld bc, jr_000_0600
    ld de, $0800
    jp RequestStateChange_Menu


jr_002_41a3::
    dec a
    jr nz, jr_002_41af

    ld bc, $0500
    ld de, $0001
    jp RequestStateChange_Menu


jr_002_41af::
    ld a, $02
    ld [$d934], a
    call StartMenuMessage
    ld a, [$d984]
    ld [$d93c], a
    ret


    call UpdateMenuCursor
    ld a, [$d93c]
    ld [$d984], a
    ldh a, [hJoyPressed]
    bit 1, a
    jr nz, jr_002_416b

    ldh a, [hJoyPressed]
    and $09
    ret z

    ld hl, $dff9
    ld a, [$d93c]
    rst $38
    ld a, [hl]
    ld [$d811], a
    ld b, $02
    ld a, [$d93c]
    ld c, a
    ld de, $0002
    jp RequestStateChange_Menu


UpdateMenuCursor:: ; Move menu cursor using hJoyPressed, wrapping through options.
Call_002_41e9:: ; Compatibility alias.
    ld a, $03
    ldh [$ffc9], a
    ld hl, $99a5
    ld a, l
    ldh [$ffca], a
    ld a, h
    ldh [$ffcb], a

Call_002_41f6::
    ld a, [$d93c]
    ld d, a
    ld hl, $ffca
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    ld c, d
    ld b, $00
    swap c
    sla c
    rl b
    sla c
    rl b
    add hl, bc
    xor a
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    and $c4
    jr z, jr_002_423d

    ldh a, [hJoyPressed]
    bit 6, a
    jr nz, jr_002_422f

    ld a, $40
    call PlaySound
    inc d
    ldh a, [$ffc9]
    dec a
    cp d
    jr nc, jr_002_423d

    ld d, $00
    jr jr_002_423d

jr_002_422f::
    ld a, $40
    call PlaySound
    dec d
    bit 7, d
    jr z, jr_002_423d

    ldh a, [$ffc9]
    dec a
    ld d, a

jr_002_423d::
    pop hl
    ld a, d
    ld [$d93c], a
    ld c, d
    ld b, $00
    swap c
    sla c
    rl b
    sla c
    rl b
    add hl, bc
    ld a, $0e
    call QueueTilemapByte
    ret


UpdateMenuMessageVramClear:: ; Clear/update queued title/menu message rows when $d96d is active.
Call_002_4256:: ; Compatibility alias.
    ld a, [$d96d]
    or a
    ret z

    ld a, [$d96b]
    ld c, a
    ld a, [$d96c]
    ld b, a
    ld a, c
    and $e0
    ld c, a
    push bc
    ld d, $00
    ld e, $13
    call QueueVramFill
    ld a, $20
    pop hl
    ld bc, $ffe0
    add hl, bc
    ld c, l
    ld b, h
    ld d, $00
    ld e, $13
    call QueueVramFill
    call Call_000_0719
    ret


StartMenuMessage:: ; Start a bank3 text/message sequence for the selected title-menu item.
Call_002_4283:: ; Compatibility alias.
    ld a, $00
    ld [$d970], a
    ld a, [$d934]
    add $0c
    call Call_000_0710
    xor a
    ld [$d93c], a
    ret


Call_002_4295::
    ld c, $00
    ld de, $9800

jr_002_429a::
    ld b, $03

jr_002_429c::
    ld hl, $4386
    ld a, b
    dec a
    push de
    rst $20
    pop de
    ld a, c
    rst $38
    push bc
    ld c, $14

jr_002_42a9::
    push bc
    ld a, [hl+]
    cp $ff
    jr nz, jr_002_42b4

    ld bc, $fff9
    add hl, bc
    ld a, [hl+]

jr_002_42b4::
    or a
    jr z, jr_002_42bb

    ld b, a
    ldh a, [$ffc9]
    add b

jr_002_42bb::
    ld [de], a
    pop bc
    inc de
    dec c
    jr nz, jr_002_42a9

    ld a, e
    and $e0
    add $20
    ld e, a
    ld a, d
    adc $00
    ld d, a
    pop bc
    dec b
    jr nz, jr_002_429c

    inc c
    ld a, c
    cp $06
    jr c, jr_002_429a

    ret


RequestStateChange_Menu:: ; Menu/screen transition helper. Sets hNeedsReset and dispatches next hGameState/substate.
jr_002_42d6:: ; Compatibility alias.
    ld a, e
    ld [$d95e], a
    ld a, d
    ld [$d95f], a
    ld a, $01
    ldh [hNeedsReset], a
    xor a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    ld [$d96d], a
    ld a, b
    rst $00

    db $0b, $43, $16, $43, $23, $43, $38, $43

    ld b, [hl]
    ld b, e
    ld d, b
    ld b, e

    db $56, $43

    ld h, e
    ld b, e

    db $6d, $43, $7d, $43

Jump_002_4301::
    ld a, [$d95e]
    ld c, a
    ld a, [$d95f]
    ld b, a
    jr RequestStateChange_Menu

    xor a
    ldh [hGameState], a
    ld [$d93d], a
    ld a, c
    ld [$d934], a
    ret


    xor a
    ld [$d93e], a
    ld a, c
    ld [$d93d], a
    ld a, $03
    ldh [hGameState], a
    ret


    xor a
    ld [$d93e], a
    ld a, c
    ld [$d93b], a
    ld a, $03
    ld [$d93d], a
    ldh [hGameState], a
    ld a, $3f
    ld [$d95c], a
    ret


    ld a, c
    inc a
    ld [$d93e], a
    ld a, $03
    ldh [hGameState], a
    xor a
    ld [$d81c], a
    ret


    ld a, $00
    ldh [hGameState], a
    ld a, $04
    ld [$d93d], a
    ret


    ld a, $01
    ld [$d93d], a
    ret


    ld a, $01
    ldh [hGameState], a
    ld a, c
    ld [$d979], a
    xor a
    ld [$d93d], a
    ret


    ld a, $04
    ldh [hGameState], a
    ld a, $01
    ld [$d93d], a
    ret


    ld a, $04
    ldh [hGameState], a
    ld a, c
    and $07
    ld [$d979], a
    ld a, $03
    ld [$d93d], a
    ret


    ld a, $05
    ldh [hGameState], a
    ld a, c
    ld [$d8f3], a
    ret


    db $9a, $43, $93, $43, $8c, $43, $9e, $8e, $95, $96, $97, $98, $ff, $9d, $90, $93
    db $94, $00, $9c, $ff, $8f, $91, $92, $99, $9a, $9b, $ff

Jump_002_43a1::
    ld a, $06
    ld hl, $50c4
    ld de, $8900
    ld bc, $0260
    call BankedMemcpy
    ld a, $01
    ld hl, $7e7c
    ld de, $c800
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $1412
    call jr_000_05f7
    call InitSound
    ld a, $1c
    call PlaySound_Queue3
    ld hl, $78a1
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    ld hl, $78d9
    ld a, l
    ld [$d803], a
    ld a, h
    ld [$d804], a
    xor a
    ld [$d802], a
    ld [$d805], a
    ld [wVramQueue], a
    ld [$d93a], a
    ld [$d93b], a
    ld [$d93c], a
    ld [$d958], a
    ld [$d95a], a
    ld [$d95b], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $02
    ld [$d933], a
    xor a
    ld b, $14
    ld hl, $d940
    call jr_000_0022
    ret


    ld a, [$d95c]
    or a
    jr z, jr_002_4468

    and $0f
    jr nz, jr_002_4452

    ld a, [$d95c]
    bit 4, a
    jr nz, jr_002_443e

    ld de, $d940
    ld hl, $9844
    ld bc, $0a02
    call QueueTilemapRect
    jr jr_002_4452

jr_002_443e::
    ld bc, $9844
    ld d, $00
    ld e, $0a
    call QueueVramFill
    ld bc, $9864
    ld d, $00
    ld e, $0a
    call QueueVramFill

jr_002_4452::
    ld c, $0c
    ld b, $28
    ld d, $0c
    call Call_000_0791
    ld c, $8c
    ld b, $28
    ld d, $00
    call Call_000_0791
    call Call_000_07f8
    ret


jr_002_4468::
    ld a, [$d959]
    cp $0b
    jr nz, jr_002_4478

    ld bc, $0400
    ld de, $0000
    jp RequestStateChange_Menu


jr_002_4478::
    cp $07
    jr c, jr_002_448a

    sub $07
    ld b, a
    ld a, $04
    ld [$dffe], a
    ld [$dffd], a
    ld a, b
    jr jr_002_44a2

jr_002_448a::
    xor a
    ld [$dffd], a
    ld a, [$d959]
    inc a
    bit 2, a
    ld a, $04
    jr nz, jr_002_4499

    xor a

jr_002_4499::
    ld [$dffe], a
    ld a, [$d959]
    inc a
    and $03

jr_002_44a2::
    ld b, $06
    ld c, a
    ld d, $08
    ld a, c
    sla a
    ld e, a
    jp RequestStateChange_Menu


    ld c, $0c
    ld b, $28
    ld de, $d803
    call Call_000_0720
    ld c, $8c
    ld b, $28
    ld de, $d800
    call Call_000_0720
    call Call_000_07f8
    ld a, [$d95c]
    or a
    jp z, Jump_002_4301

    ret


    ld c, $0c
    ld b, $28
    ld de, $d803
    call Call_000_0720
    ld c, $8c
    ld b, $28
    ld de, $d800
    call Call_000_0720
    ld a, [$d958]
    or a
    jr z, jr_002_44eb

    call Call_002_468e
    ret


jr_002_44eb::
    ld hl, $46b3
    ld a, [$d93a]
    swap a
    rrca
    ld c, a
    ld a, [$d93c]
    swap a
    rrca
    ld b, a
    call Jump_000_0269
    ld hl, $46b8
    ld a, [$d93b]
    swap a
    rrca
    ld c, a
    ld b, $00
    call Jump_000_0269
    ldh a, [hJoyHeld]
    and $f0
    ld b, a
    ld a, [$d95a]
    and $f0
    cp b
    jr nz, jr_002_4532

    ld a, [$d95b]
    inc a
    jr nz, jr_002_4523

    ld a, $30

jr_002_4523::
    ld [$d95b], a
    cp $30
    jr c, jr_002_452e

    and $07
    jr z, jr_002_4536

jr_002_452e::
    ld b, $00
    jr jr_002_4536

jr_002_4532::
    xor a
    ld [$d95b], a

jr_002_4536::
    ldh a, [hJoyHeld]
    ld [$d95a], a
    ld a, b
    ld b, $00
    ld c, $00
    bit 7, a
    jr z, jr_002_4546

    ld c, $02

jr_002_4546::
    bit 6, a
    jr z, jr_002_454c

    ld c, $fe

jr_002_454c::
    bit 5, a
    jr z, jr_002_4552

    ld b, $ff

jr_002_4552::
    bit 4, a
    jr z, jr_002_4558

    ld b, $01

jr_002_4558::
    ld a, b
    or c
    jr z, jr_002_4561

    ld a, $5d
    call PlaySound

jr_002_4561::
    ld a, [$d93a]
    add b
    bit 7, a
    jr z, jr_002_456b

    ld a, $10

jr_002_456b::
    cp $11
    jr c, jr_002_4570

    xor a

jr_002_4570::
    cp $05
    jr nz, jr_002_4575

    add b

jr_002_4575::
    cp $0b
    jr nz, jr_002_457a

    add b

jr_002_457a::
    ld [$d93a], a
    ld a, [$d93c]
    add c
    bit 7, a
    jr z, jr_002_4587

    ld a, $08

jr_002_4587::
    cp $09
    jr c, jr_002_458c

    xor a

jr_002_458c::
    ld [$d93c], a
    ldh a, [hJoyPressed]
    bit 0, a
    call nz, Call_002_45c6
    ldh a, [hJoyPressed]
    bit 1, a
    jr z, jr_002_45a3

    ld a, [$d93b]
    dec a
    ld [$d93b], a

jr_002_45a3::
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, Call_002_4635
    ld a, [$d93b]
    bit 7, a
    jr z, jr_002_45bc

    ld a, $03
    ld [$d93d], a
    ld a, $48
    ld [$d95c], a
    ret


jr_002_45bc::
    cp $0a
    jr c, jr_002_45c5

    ld a, $09
    ld [$d93b], a

jr_002_45c5::
    ret


Call_002_45c6::
    ld a, $40
    call PlaySound
    ld hl, $c879
    ld a, [$d93c]
    inc a
    ld bc, $0014

jr_002_45d5::
    add hl, bc
    dec a
    jr nz, jr_002_45d5

    ld a, [$d93a]
    rst $38
    ld a, [hl]
    cp $b3
    jr nz, jr_002_45ea

    ld a, [$d93b]
    dec a
    ld [$d93b], a
    ret


jr_002_45ea::
    cp $b4
    jr nz, jr_002_45f6

    ld a, [$d93b]
    inc a
    ld [$d93b], a
    ret


jr_002_45f6::
    cp $b5
    jr nz, jr_002_45fe

    call Call_002_4635
    ret


jr_002_45fe::
    ld d, [hl]
    ld bc, $ffec
    add hl, bc
    ld e, $45
    ld a, [hl]
    or a
    jr nz, jr_002_460b

    ld e, $00

jr_002_460b::
    cp $92
    jr nz, jr_002_4611

    ld e, $00

jr_002_4611::
    ld a, [$d93b]
    ld c, a
    ld b, $00
    ld hl, $d940
    add hl, bc
    ld [hl], e
    ld hl, $d94a
    add hl, bc
    ld [hl], d
    ld a, [$d93b]
    inc a
    ld [$d93b], a
    ld de, $d940
    ld hl, $9844
    ld bc, $0a02
    call QueueTilemapRect
    ret


Call_002_4635::
    xor a
    ld [$d959], a
    ld hl, $4705

jr_002_463c::
    ld de, $d940
    ld c, $00
    push hl

jr_002_4642::
    inc c
    ld a, c
    cp $15
    jr nc, jr_002_4676

    ld a, [de]
    ld b, [hl]
    inc de
    inc hl
    cp b
    jr z, jr_002_4642

    pop hl
    ld bc, $0014
    add hl, bc
    ld a, [$d959]
    inc a
    ld [$d959], a
    cp $0c
    jr nz, jr_002_463c

    ld de, $46e5
    ld hl, $9804
    ld bc, $0a02
    call QueueTilemapRect
    ld a, $01
    ld [$d958], a
    ld a, $53
    call PlaySound
    ret


jr_002_4676::
    pop hl
    ld de, $46d1
    ld hl, $9804
    ld bc, $0a02
    call QueueTilemapRect
    ld a, $02
    ld [$d93d], a
    ld a, $c0
    ld [$d95c], a
    ret


Call_002_468e::
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld de, $46bd
    ld hl, $9804
    ld bc, $0a02
    call QueueTilemapRect
    xor a
    ld [$d958], a
    ret


    ld b, e
    ld h, l
    ld d, a
    ld a, d
    ld a, [hl]
    ld b, l
    ld e, a
    ld b, l
    dec d
    ld [hl-], a
    inc de
    ld a, [hl]
    ld a, [hl]
    ld b, d
    rst $38
    ld b, c
    rlca
    or d
    db $10
    add b
    jr nz, jr_002_46da

    or c
    db $10
    add b
    sbc e
    sub d
    sub d
    sub d
    sbc d
    sub d
    sub d
    sub d
    sbc d
    sub d
    ld h, l
    ld d, a
    ld a, d
    ld a, [hl]
    ld e, a
    ld de, $3737
    ld a, [hl+]
    ld a, a
    sub d
    sub d
    sbc d
    sub d
    sub d
    sub d
    sub d
    sub d
    sub d

jr_002_46da::
    sub d
    ld de, $5917
    ld a, l
    nop
    ld d, [hl]
    ld a, c
    ld a, l
    nop
    nop
    sub d
    sub d
    sbc d
    sub d
    sub d
    sub d
    sbc d
    sub d
    sub d
    sub d
    jr nz, @+$46

    dec d
    ld b, h
    ld [de], a
    ld b, h
    ld e, c
    ld a, [hl]
    nop
    nop

    db $07, $08, $0a

    ld b, $08
    ld [$0808], sp
    ld [$0907], sp
    dec b

    db $00, $45, $00, $00, $45, $00, $00, $00, $00, $00, $3f, $15, $2f, $2f, $1f, $25
    db $10, $00, $00, $00, $00, $00, $00, $45, $00, $45, $00, $00, $00, $00, $1f, $2f
    db $28, $16, $1f, $2d, $37, $36, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $3f, $2a, $2a, $2a, $2a, $3f, $2a, $2a, $2a, $2a

    nop
    ld b, l
    nop
    nop
    ld b, l
    nop
    nop
    nop
    nop
    nop
    inc d
    dec l
    ld b, d
    ld d, $23
    jr z, jr_002_4752

jr_002_4752::
    nop
    nop
    nop
    nop
    nop
    ld b, l
    nop
    nop
    nop
    ld b, l
    nop
    nop
    nop
    jr jr_002_4782

    rra
    jr jr_002_4781

    ld de, $421b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, l
    nop
    nop
    nop
    nop
    db $10
    rla
    dec de
    ld a, $42
    dec hl
    ld de, $0031
    nop
    ld b, l
    nop
    nop
    nop

jr_002_4781::
    ld b, l

jr_002_4782::
    nop
    nop
    nop
    nop
    nop
    ld e, $14
    ld a, [de]
    ld b, d
    ld e, $14
    ld a, [de]
    ld b, d
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, l
    nop
    nop
    dec de
    ld b, d
    jr nz, jr_002_47d9

    ld b, d
    rra
    db $10
    ld l, $00
    nop
    ld b, l
    nop
    ld b, l
    nop
    ld b, l
    nop
    nop
    nop
    nop
    nop
    inc l
    dec [hl]
    inc l
    dec [hl]
    ld a, [de]
    inc de
    inc sp
    ld b, d
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
    dec h
    inc e
    add hl, hl
    inc d
    dec de
    ld b, d
    add hl, de
    nop
    nop
    nop
    nop
    nop
    ld b, l
    nop
    ld b, l
    ld b, l
    nop
    nop
    nop
    nop
    db $10
    dec [hl]

jr_002_47d9::
    dec d
    inc h
    add hl, de
    ld a, [de]
    cpl
    inc e
    ld [de], a
    nop
    nop
    nop
    nop
    ld b, l
    nop
    nop
    nop
    nop
    nop
    nop
    dec d
    jr nc, jr_002_4809

    ld a, [hl+]
    ld de, $0000
    nop
    nop
    nop

Jump_002_47f5::
    xor a
    ldh [hNeedsReset], a
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld [hl+], a

jr_002_4809::
    ld [hl], a
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    call Call_000_02f8
    ld a, $02
    ld [$d970], a
    ld a, $0f
    call Call_000_0710
    xor a
    ld [$d93c], a
    ld [wVramQueue], a
    ld a, $04
    ld [$d933], a
    xor a
    ld b, $04
    ld hl, $d940

jr_002_4831::
    xor a
    ld [hl+], a
    dec b
    jr nz, jr_002_4831

    ret


    ld hl, $d940
    ld a, [$d93c]
    rst $38
    ld a, [hl]
    ld d, a
    push hl
    ldh a, [hJoyPressed]
    bit 4, a
    jr z, jr_002_4848

    inc d

jr_002_4848::
    ldh a, [hJoyPressed]
    bit 5, a
    jr z, jr_002_484f

    dec d

jr_002_484f::
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, jr_002_4893

    ld a, [$d93c]
    ld hl, $48d3
    rst $38
    ld b, [hl]
    bit 7, d
    jr z, jr_002_4863

    ld d, b
    dec d

jr_002_4863::
    ld a, d
    cp b
    jr c, jr_002_4869

    ld d, $00

jr_002_4869::
    pop hl
    ld [hl], d
    ld a, d
    ld [$d93a], a
    ld hl, $98ad
    ld a, [$d93c]
    swap a
    sla a
    sla a
    rst $38
    ld a, d
    add $05
    call QueueTilemapByte
    ld a, $04
    ldh [$ffc9], a
    ld hl, $98a5
    ld a, l
    ldh [$ffca], a
    ld a, h
    ldh [$ffcb], a
    call Call_002_41f6
    ret


jr_002_4893::
    pop hl
    ld a, [$d93c]
    rst $00
    xor h
    ld c, b
    and b
    ld c, b
    cp b
    ld c, b
    call nz, $0648
    ld b, $fa
    ld b, c
    reti


    ld c, a
    ld de, $0400
    jp RequestStateChange_Menu


    ld a, [$d940]
    ld c, a
    ld b, $08
    ld de, $0400
    jp RequestStateChange_Menu


    ld b, $09
    ld a, [$d942]
    ld c, a
    ld de, $0400
    jp RequestStateChange_Menu


    ld a, [$d943]
    inc a
    ldh [$ffb9], a
    ld bc, $0100
    ld de, $0400
    jp RequestStateChange_Menu


    ld [$0204], sp
    inc bc

    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [$d932], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld a, [$d93e]
    rst $00

    db $6d, $4a, $1a, $58, $2f, $5f, $1d, $50

    ld a, [$d932]
    or a
    jr nz, jr_002_490b

    ld a, [$d93e]
    rst $00

    db $d2, $4b, $86, $58, $84, $5f, $b6, $50

jr_002_490b::
    ldh a, [hPrevOamPos]
    ldh [hOamWritePos], a
    xor a
    ld [$dd9f], a
    ld a, $f9
    ld [wPaletteBGP], a
    ld a, $f4
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

    xor a
    ld [$d932], a
    ld a, $80
    ld [$dd9f], a
    ld a, $5e
    call PlaySound_Queue1
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ret


    call Call_002_4a26
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

Jump_002_494b::
    ld a, $01
    ld [$d93d], a
    ld a, $ff
    ld [$d852], a
    ld a, $02
    ld [$d954], a
    ret


Call_002_495b::
    ld a, [$d978]
    rrc a
    ld b, a
    ldh a, [rDIV]
    add b
    ld [$d978], a
    ret


Call_002_4968::
    call Call_002_495b
    ld b, $00
    cp $55
    jr c, jr_002_4977

    inc b
    cp $aa
    jr c, jr_002_4977

    inc b

jr_002_4977::
    ld a, b
    ret


Call_002_4979::
    ld a, [$d852]
    dec a
    ld [$d852], a
    or a
    ret nz

    ld a, $32
    ld [$d852], a
    ld hl, $d855
    ld b, $03

jr_002_498c::
    dec [hl]
    ld a, [hl]
    bit 7, a
    jr z, jr_002_499c

    ld a, $09
    ld [hl-], a
    dec b
    jr nz, jr_002_498c

    xor a
    ld a, $00
    ret


jr_002_499c::
    ld hl, $d853
    ld a, [hl+]
    add $04
    ldh [$ffc9], a
    ld a, [hl+]
    add $04
    ldh [$ffca], a
    ld a, [hl+]
    add $04
    ldh [$ffcb], a
    ld hl, $ffc9
    ld a, [hl]
    cp $04
    jr nz, jr_002_49bf

    xor a
    ld [hl+], a
    ld a, [hl]
    cp $04
    jr nz, jr_002_49bf

    xor a
    ld [hl], a

jr_002_49bf::
    ld de, $ffc9
    ld hl, $9a28
    ld bc, $0301
    call QueueTilemapRect
    ret


Jump_002_49cc::
    xor a
    ld [$d955], a
    ld a, [$d811]
    cp $0a
    jp z, Jump_002_4301

    ld a, [$d95f]
    or a
    jp nz, Jump_002_4301

    ld a, [$d95d]
    or a
    jp nz, Jump_002_4301

    ld a, [$d811]
    inc a
    ld [$d811], a
    ld b, [hl]
    cp b
    jr c, jr_002_49f2

    ld [hl], a

jr_002_49f2::
    jp Jump_002_494b


Call_002_49f5::
    ld a, [$dff8]
    or a
    ret z

    ld b, $07

jr_002_49fc::
    push de
    ld a, [de]
    ld c, a
    inc de
    ld a, [de]
    ld e, c
    ld d, a
    ld c, $10

jr_002_4a05::
    sla e
    rl d
    jr nc, jr_002_4a0d

    ld [hl], $00

jr_002_4a0d::
    inc hl
    dec c
    jr nz, jr_002_4a05

    ld a, $10
    rst $38
    pop de
    inc de
    inc de
    dec b
    jr nz, jr_002_49fc

    ret


Call_002_4a1b::
    ld a, $01
    ld [$d932], a
    ld a, $5e
    call PlaySound_Queue1
    ret


Call_002_4a26::
    ldh a, [hJoyPressed]
    and $04
    ret z

    ld a, [$d95f]
    or a
    ret nz

    ld a, [$d811]
    ld b, a
    ldh a, [hJoyPressed]
    bit 2, a
    jr z, jr_002_4a49

    inc b
    ld a, [$d93e]
    dec a
    ld hl, $dff9
    rst $38
    ld a, [hl]
    cp b
    jr nc, jr_002_4a49

    ld b, $01

jr_002_4a49::
    ld a, b
    cp $0b
    jr c, jr_002_4a50

    ld b, $01

jr_002_4a50::
    ld hl, $9a30
    ld a, [$d93e]
    cp $03
    jr nz, jr_002_4a5d

    ld hl, $9bf0

jr_002_4a5d::
    ld a, b
    ld [$d811], a
    add $04
    cp $0e
    jr nz, jr_002_4a69

    ld a, $c5

jr_002_4a69::
    call QueueTilemapByte
    ret


    ld a, [$d93d]
    or a
    jr nz, jr_002_4a8f

    xor a
    ld [$d93b], a
    ld a, $01
    ld [$d967], a
    ld a, $e8
    ld [$d93a], a
    ld a, $05
    ld hl, $5701
    ld de, $8d00
    ld bc, $0300
    call BankedMemcpy

jr_002_4a8f::
    ld a, $e4
    ld hl, wPaletteBGP
    ld [hl+], a
    ld a, $d0
    ld [hl+], a
    ld a, $e4
    ld [hl], a
    ld a, [$d95f]
    ld [$d960], a
    call Call_000_0dc0
    ld a, $06
    ld hl, $5334
    ld de, $8130
    call LoadMaskedGfx
    ld a, $06
    ld hl, $53ec
    ld de, $8300
    call LoadMaskedGfx
    ld a, $06
    ld hl, $50c4
    ld de, $8800
    ld bc, $0200
    call BankedMemcpy
    ld a, $06
    ld hl, $5556
    ld de, $8a00
    call LoadMaskedGfx
    ld a, [$d93d]
    cp $03
    jr z, jr_002_4b08

    ld a, $e3
    ld [wLCDCShadow], a
    ld hl, $5787
    ld de, $c800
    ld bc, $0168
    ld a, $06
    call BankedMemcpy_RLEFF
    ld hl, $9800
    ld bc, $1412
    ld de, $c800
    call jr_000_05f7
    ld a, $03
    ld [$d933], a
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    jr jr_002_4b40

jr_002_4b08::
    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [$ffc9], a
    call Call_002_4295
    ld a, $8f
    ldh [$ffc9], a
    ld hl, $9823
    ld bc, $0c0d
    call Call_000_08b7
    ld a, [$dff8]
    or a
    jr z, jr_002_4b3b

    ld hl, $c800
    ld bc, $0010
    call bzero
    ld hl, $99a0
    ld bc, $0303
    ld de, $c800
    call jr_000_05f7

jr_002_4b3b::
    ld a, $14
    ld [$d933], a

jr_002_4b40::
    ld hl, $78e0
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d96d], a
    ld [$d954], a
    ld [$d955], a
    ld [$d956], a
    ld a, [$d93d]
    cp $03
    jr nz, jr_002_4ba2

    ld a, $82
    ld [$d970], a
    ld a, [$d93b]
    add $09
    cp $0c
    jr c, jr_002_4b84

    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    ld a, [$d93b]
    sub $03
    add $5a
    jr jr_002_4b8e

jr_002_4b84::
    push af
    call InitSound
    ld a, $00
    call PlaySound_Queue3
    pop af

jr_002_4b8e::
    call Call_000_0710
    ld hl, $7901
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    ld a, $40
    ld [$d954], a
    ret


jr_002_4ba2::
    call Call_002_4fb1
    ld a, [$d93d]
    cp $06
    ret z

Jump_002_4bab::
    ldh a, [$ffb9]
    or a
    ret nz

    ld a, $80
    ld [$d970], a
    ld a, $0c
    call Call_000_0710
    ld hl, $7908
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld a, $01
    ld [$d967], a
    xor a
    ld [$d93d], a
    ret


    ld a, [$d93d]
    and $07
    rst $00

    db $e8, $4b, $7a, $4c, $e5, $4c, $d8, $4d, $52, $4c, $3a, $4e, $62, $4e

    adc $4f

    call Call_000_0719
    call Call_002_4d91
    ld a, [$d967]
    ld b, a
    ldh a, [$ffb9]
    or a
    jr nz, jr_002_4c04

    ld a, [$d955]
    inc a
    ld [$d955], a
    and $03
    jr nz, jr_002_4c04

    ld b, $00

jr_002_4c04::
    ld a, [$d93a]
    add b
    ld [$d93a], a
    ld c, a
    ld b, $7f
    ld de, $d800
    call Call_000_0720
    ld hl, $4ff1
    ld b, $05

jr_002_4c19::
    ld a, [$d93a]
    cp [hl]
    jr z, jr_002_4c24

    dec hl
    dec b
    jr nz, jr_002_4c19

    ret


jr_002_4c24::
    dec b
    ld a, b
    cp $04
    jr z, jr_002_4c47

    ldh a, [$ffb9]
    or a
    ret z

    ld a, b
    ld [$d93b], a
    ld a, $01
    ld [$d93d], a
    ld a, $10
    ld [$d954], a
    ld a, $80
    ld [$d970], a
    ld a, b
    inc a
    call Call_000_0710
    ret


jr_002_4c47::
    ld a, $3f
    ld [$d95c], a
    ld a, $04
    ld [$d93d], a
    ret


    call Call_002_4d91
    call Call_000_07f8
    ld a, [$d95c]
    or a
    ret nz

    ld bc, $0400
    ld de, $0000
    ld a, [$d960]
    cp $04
    jp z, RequestStateChange_Menu

    ld a, [$d979]
    ld e, a
    srl a
    ld c, a
    ld b, $06
    ld d, $08
    jp RequestStateChange_Menu


    ret


    call Call_000_0719
    call Call_002_4d91
    ld a, [$d93a]
    ld c, a
    ld b, $7f
    ld d, $0e
    call Call_000_0791
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_4cc8

    ld a, [$d96d]
    or a
    jr nz, jr_002_4cc8

    ld a, [$d93b]
    cp $03
    jr z, jr_002_4cc8

    ld hl, $78f6
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d96d], a
    ld a, $40
    ld [$d95c], a
    ld a, $02
    ld [$d93d], a
    ldh a, [$ffb9]
    cp $04
    ret nc

    ldh a, [$ffb9]
    dec a
    ldh [$ffb9], a
    call Jump_000_0e6e
    ret


jr_002_4cc8::
    ld a, [$d954]
    dec a
    ld [$d954], a
    bit 7, a
    ret z

    xor a
    ld [$d954], a
    ldh a, [hJoyHeld]
    bit 4, a
    call nz, Call_002_4d47
    ldh a, [hJoyHeld]
    bit 5, a
    call nz, Call_002_4d51
    ret


    call Call_000_0719
    call Call_002_4d91
    ld a, [$d802]
    cp $01
    jr nz, jr_002_4d03

    ld hl, $d800
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    dec hl
    ld a, [hl]
    cp $12
    jr nz, jr_002_4d03

    ld a, $54
    call PlaySound

jr_002_4d03::
    ld a, [$d93a]
    ld c, a
    ld b, $7f
    ld de, $d800
    call Call_000_0720
    or a
    ret z

    call Call_000_07f8
    ld a, [$d95c]
    or a
    ret nz

    ld hl, $d961
    ld a, [$d93b]
    rst $38
    ld a, [hl]
    ld [$d811], a
    ld hl, $d964
    ld a, [$d93b]
    rst $38
    ld b, $03
    ld a, [$d93b]
    ld c, a
    ld de, $0106
    ld a, [hl]
    or a
    jp z, RequestStateChange_Menu

    xor a
    ld [hl], a
    ld b, $02
    ld a, [$d93b]
    ld c, a
    ld de, $0106
    jp RequestStateChange_Menu


Call_002_4d47::
    ld a, $01
    ld [$d967], a
    ld hl, $78e0
    jr jr_002_4d5e

Call_002_4d51::
    ld a, [$d93b]
    or a
    ret z

    ld a, $ff
    ld [$d967], a
    ld hl, $78eb

jr_002_4d5e::
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d93d], a
    call Call_002_4d71
    ret


Call_002_4d71::
    xor a
    ld [$d96d], a
    ld d, $82
    ld bc, $9883

jr_002_4d7a::
    ld e, $0e
    push bc
    call QueueVramFill
    pop bc
    ld d, $00
    ld a, $20
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, c
    cp $03
    jr nz, jr_002_4d7a

    ret


Call_002_4d91::
    ld a, [$d93c]
    inc a
    ld [$d93c], a
    ld c, $00
    and $10
    jr z, jr_002_4da0

    ld c, $08

jr_002_4da0::
    ld b, $00
    push bc
    ld hl, $4ff2
    call Jump_000_0269
    pop bc
    ld a, c
    xor $08
    ld c, a
    ld b, $18
    ld hl, $4ff2
    call Jump_000_0269
    ld a, [$d93c]
    ld b, $00
    and $10
    jr nz, jr_002_4dc1

    ld b, $08

jr_002_4dc1::
    ld c, $00
    push bc
    ld hl, $5013
    call Jump_000_0269
    pop bc
    ld a, b
    xor $08
    ld b, a
    ld c, $78
    ld hl, $5013
    call Jump_000_0269
    ret


    ld c, $0c
    ld b, $7f
    ld de, $d800
    call Call_000_0720
    call Call_000_07cf
    ld a, [$d95c]
    or a
    ret nz

    ld a, [$d93b]
    cp $03
    jr nc, jr_002_4e23

    ld a, [$d93c]
    inc a
    ld [$d93c], a
    and $0f
    jr nz, jr_002_4e0c

    ld a, [$d93c]
    and $10
    ld a, $81
    jr nz, jr_002_4e06

    xor a

jr_002_4e06::
    ld hl, $99cf
    call QueueTilemapByte

jr_002_4e0c::
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld a, $3f
    ld [$d95c], a
    ld a, $05
    ld [$d93d], a
    xor a
    ld hl, $99cf
    call QueueTilemapByte
    ret


jr_002_4e23::
    ld a, [$d93b]
    cp $05
    ret z

    ld a, [$d955]
    inc a
    ld [$d955], a
    cp $d0
    ret c

    ld a, $e0
    ld [$d955], a
    jr jr_002_4e0c

    ld c, $0c
    ld b, $7f
    ld de, $d800
    call Call_000_0720
    call Call_000_07f8
    ld a, [$d95c]
    or a
    ret nz

    ld b, $03
    ld a, [$d93b]
    cp $03
    jp nc, Jump_002_4301

    ld c, a
    ld a, [$d95e]
    ld e, a
    ld a, [$d95f]
    ld d, a
    jp RequestStateChange_Menu


    call Call_000_0719
    call Call_002_4d91
    ld a, [$d93a]
    ld c, a
    ld b, $7f
    ld d, $14
    call Call_000_0791
    ld a, [$d93b]
    cp $01
    jp nz, jr_002_4efe

    ld a, [$d95d]
    or a
    jr nz, jr_002_4efe

    ld a, [$d954]
    or a
    jr nz, jr_002_4efe

    ld a, [$d956]
    cp $01
    jr nz, jr_002_4e9a

    ld hl, $98a7
    ld bc, QueueVramFill
    ld de, $5018
    call QueueTilemapRect

jr_002_4e9a::
    ld a, [$d956]
    inc a
    cp $40
    jr c, jr_002_4ea4

    ld a, $60

jr_002_4ea4::
    ld [$d956], a
    ld a, [$d955]
    bit 7, a
    jr nz, jr_002_4eee

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_4ec0

    ld a, [$d956]
    cp $60
    ret nz

    ld a, $80
    ld [$d955], a
    ret


jr_002_4ec0::
    ld a, [$d955]
    inc a
    cp $0c
    jr c, jr_002_4ec9

    xor a

jr_002_4ec9::
    ld [$d955], a
    and $03
    ret nz

    ld a, [$d955]
    srl a
    srl a
    add $0b
    ld [$d971], a
    xor a
    ld a, [$d970]
    ld a, $68
    call Call_000_0710
    ld bc, $98c6
    ld de, $0004
    call QueueVramFill
    ret


jr_002_4eee::
    inc a
    ld [$d955], a
    cp $e0
    ret nz

    ld bc, $98c6
    ld de, $0004
    call QueueVramFill

jr_002_4efe::
    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $01
    jr nz, jr_002_4f3e

    ld a, $80
    ld [$d970], a
    ld a, [$d95d]
    or a
    ld a, $08
    jr nz, jr_002_4f2a

    ld a, [$d93b]
    ld hl, $d961
    rst $38
    inc [hl]
    ld a, [hl]
    cp $0b
    jr c, jr_002_4f25

    ld [hl], $0a

jr_002_4f25::
    ld a, [$d93b]
    add $05

jr_002_4f2a::
    call Call_000_0710
    ld a, [$d93b]
    cp $01
    ret nz

    ld a, [$d95d]
    or a
    ret nz

    ld a, $46
    call PlaySound_Queue1
    ret


jr_002_4f3e::
    ld a, [$d954]
    cp $60
    jr nz, jr_002_4fa0

    ld a, [$d95d]
    or a
    jr nz, jr_002_4f6f

    ld a, [$d93b]
    or a
    jr nz, jr_002_4f58

    ld a, $0f
    call AddBonusCounter
    jr jr_002_4f6f

jr_002_4f58::
    dec a
    jr nz, jr_002_4f67

    ld a, [$d971]
    sub $0a
    ldh [$ffbb], a
    call Jump_000_0e02
    jr jr_002_4f6f

jr_002_4f67::
    call AddExtraLife
    ld a, $46
    call PlaySound_Queue1

jr_002_4f6f::
    ld a, [$d93b]
    ld hl, $d961
    rst $38
    ld a, [$d93b]
    ld d, a
    ld a, [hl]
    cp $0a
    jr c, jr_002_4f81

    ld a, $c1

jr_002_4f81::
    add $04
    inc d
    ld bc, $0005
    ld hl, $9960

jr_002_4f8a::
    add hl, bc
    dec d
    jr nz, jr_002_4f8a

    call QueueTilemapByte
    call Call_002_4d71
    ld a, $80
    ld [$d970], a
    ld a, [$d93b]
    inc a
    call Call_000_0710

jr_002_4fa0::
    ld a, [$d954]
    cp $60
    ret c

    ld a, $01
    ld [$d93d], a
    ld [$d954], a
    jp Jump_002_4bab


Call_002_4fb1::
    ld b, $03
    ld hl, $9965
    ld de, $d961

jr_002_4fb9::
    ld a, [de]
    inc de
    cp $0a
    jr c, jr_002_4fc1

    ld a, $c1

jr_002_4fc1::
    add $04
    ld [hl], a
    push bc
    ld bc, $0005
    add hl, bc
    pop bc
    dec b
    jr nz, jr_002_4fb9

    ret


    ld a, [$d962]
    ld c, $0b
    ld d, $02
    cp $04
    jr c, jr_002_4fe5

    ld c, $0c
    ld d, $03
    cp $07
    jr c, jr_002_4fe5

    ld c, $0d
    ld d, $01

jr_002_4fe5::
    ld a, d
    ldh [$ffca], a
    ld a, c
    ld [$d971], a
    ret


    db $1e, $46, $6e, $8e, $b0, $00, $10, $af, $10, $00, $20, $af, $10, $00, $30, $af
    db $10, $00, $40, $af, $10, $00, $50, $af, $10, $00, $60, $af, $10, $00, $70, $af
    db $10, $00, $80, $af, $10, $80, $08, $10, $af, $10, $80, $c7, $c8, $c9, $ca, $7d

    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ld a, $70
    ldh [hSCY], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    xor a
    ld [$d824], a
    ld [$d956], a
    ld a, $0c
    ld [$d933], a
    ld a, [$d81c]
    or a
    jr nz, jr_002_5065

    ld a, $05
    ld hl, $7481
    ld de, $8000
    call LoadMaskedGfx
    ld a, $04
    ld hl, $79da
    ld de, $c800
    ld bc, $1000
    call BankedMemcpy_RLEFF
    xor a
    ld [$d81d], a

jr_002_5065::
    ld b, $1e
    ld a, [$d81d]
    or a
    jr z, jr_002_506f

    ld b, $20

jr_002_506f::
    ld hl, $c800
    ld de, $9800

jr_002_5075::
    ld c, $20

jr_002_5077::
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, jr_002_5077

    ld a, $60
    rst $38
    dec b
    jr nz, jr_002_5075

    ld a, [$d81d]
    or a
    jr nz, jr_002_5091

    ld b, $40
    xor a

jr_002_508c::
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_508c

jr_002_5091::
    ld a, [$d81d]
    or a
    jp nz, Jump_002_5140

    ld a, [$d81c]
    or a
    jp nz, Jump_002_50f1

    ld a, $02
    ld [$d970], a
    ld a, $4d
    call Call_000_0710
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [$d93d], a
    ret


    ld a, [$d93d]
    cp $02
    jr c, jr_002_50d7

    ldh a, [hJoyPressed]
    bit 3, a
    jr z, jr_002_50d7

    ld a, [$d81d]
    or a
    jr nz, jr_002_50d4

    ld a, $01
    ld [$d81d], a
    ldh [hNeedsReset], a
    ld [$d81c], a
    ret


jr_002_50d4::
    call Call_002_4a1b

jr_002_50d7::
    ld a, [$d93d]
    rst $00

    db $e9, $50, $1d, $51, $6e, $51, $1f, $53, $a6, $56, $fe, $52

    sbc e
    ld d, e

    call Call_002_4a26
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

Jump_002_50f1::
    ld a, $01
    ld [$d93d], a
    ld a, $60
    ld [$d954], a
    ld bc, $9bc0
    ld de, $0014
    call QueueVramFill
    ld bc, $9be0
    ld de, $0014
    call QueueVramFill
    ld a, [$d811]
    ld [$d971], a
    xor a
    ld [$d970], a
    ld a, $4c
    call Call_000_0710
    ret


    call Call_000_0719
    ld a, [$d954]
    dec a
    ld [$d954], a
    ret nz

    ld de, $d700
    ld hl, $9bc0
    ld bc, $2001
    call QueueTilemapRect
    ld de, $d780
    ld hl, $9be0
    ld bc, $2001
    call QueueTilemapRect

Jump_002_5140::
    ld a, $02
    ld [$d93d], a
    xor a
    ld [$d954], a
    ld hl, $d81e
    ld [hl], $00
    inc hl
    ld [hl], $28
    inc hl
    ld [hl], $00
    xor a
    ld hl, $d821
    ld [hl], $00
    inc hl
    ld [hl], $90
    inc hl
    ld [hl], $00
    ld a, $01
    ld [$d95d], a
    call InitSound
    ld a, $30
    call PlaySound_Queue3
    ret


    ld d, $9c
    ld a, [$d820]
    or a
    jp nz, Jump_002_5261

    ld a, [$d81f]
    cp $2a
    jp nc, Jump_002_51af

    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $e0
    jr nc, jr_002_519a

    xor a
    ld [$d815], a
    ld [$d816], a
    ld [$d817], a
    ld [$d818], a
    jp jr_002_52f1


jr_002_519a::
    ld hl, $0080
    ld a, l
    ld [$d815], a
    ld a, h
    ld [$d816], a
    xor a
    ld [$d817], a
    ld [$d818], a
    jp jr_002_52f1


Jump_002_51af::
    ld d, $9e
    cp $80
    jr nc, jr_002_51d2

    ld hl, $d815
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $0003
    add hl, bc
    ld a, l
    ld [$d815], a
    ld a, h
    ld [$d816], a
    ld a, l
    ld [$d817], a
    ld a, h
    ld [$d818], a
    jp jr_002_52f1


jr_002_51d2::
    cp $b0
    jp nc, Jump_002_5261

    ld a, [$d824]
    or a
    jr nz, jr_002_5205

    ld hl, $d825
    ld a, $98
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $b0
    ld [hl+], a
    ld hl, $7a53
    ld a, [$d81d]
    or a
    jr z, jr_002_51f4

    ld hl, $7a58

jr_002_51f4::
    ld a, l
    ld [$d803], a
    ld a, h
    ld [$d804], a
    xor a
    ld [$d805], a
    ld a, $01
    ld [$d824], a

jr_002_5205::
    xor a
    ld [$d819], a
    ld [$d817], a
    ld [$d818], a
    ld a, $e4
    ld [$d822], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [$d81d]
    and b
    jp z, jr_002_52f1

jr_002_521e::
    ld a, [$d811]
    dec a
    ld hl, $5704
    rst $20
    ld a, l
    ld [$d81a], a
    ld a, h
    ld [$d81b], a
    ld a, $42
    call PlaySound
    ld a, $03
    ld [$d93d], a
    ld hl, $0180
    ld a, [$d811]
    dec a
    ld b, a
    ld a, [$d81d]
    or b
    jr nz, jr_002_5249

    ld hl, $01c0

jr_002_5249::
    ld a, l
    ld [$d815], a
    ld a, h
    ld [$d816], a
    ld hl, $fd80
    ld a, l
    ld [$d817], a
    ld a, h
    ld [$d818], a
    ld d, $9e
    jp jr_002_52f1


Jump_002_5261::
    ld a, [$d81d]
    or a
    jr z, jr_002_521e

    ld d, $9e
    ld a, [$d822]
    cp $f0
    jr c, jr_002_52e1

    ld d, $a0
    ld a, [$d956]
    inc a
    ld [$d956], a
    bit 3, a
    jr nz, jr_002_527f

    ld d, $a1

jr_002_527f::
    ld a, $f1
    ld [$d822], a
    xor a
    ld [$d817], a
    ld [$d818], a
    ld a, [$d816]
    bit 7, a
    jr nz, jr_002_52b9

    ld a, [$d815]
    sub $03
    ld [$d815], a
    ld a, [$d816]
    sbc $00
    ld [$d816], a
    jr nc, jr_002_52f1

    xor a
    ld [$d816], a
    ld a, $05
    ld [$d93d], a
    push de
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop de
    jr jr_002_52f1

jr_002_52b9::
    ld a, [$d815]
    add $03
    ld [$d815], a
    ld a, [$d816]
    adc $00
    ld [$d816], a
    jr nc, jr_002_52f1

    ld a, $ff
    ld [$d816], a
    ld a, $05
    ld [$d93d], a
    push de
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop de
    jr jr_002_52f1

jr_002_52e1::
    ld a, [$d817]
    add $04
    ld [$d817], a
    ld a, [$d818]
    adc $00
    ld [$d818], a

jr_002_52f1::
    ld a, d
    ldh [$ffc9], a
    call Call_002_5419
    call Call_002_5658
    call Call_002_5521
    ret


    ld a, $9f
    ldh [$ffc9], a
    call Call_002_5419
    call Call_002_5521
    ld a, [$d819]
    inc a
    ld [$d819], a
    cp $90
    ret c

    ld a, $a0
    ld [$d819], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    jp Jump_002_4301


    ld a, [$d817]
    add $0a
    ld [$d817], a
    ld a, [$d818]
    adc $00
    ld [$d818], a
    ld d, $9e
    bit 7, a
    jr z, jr_002_5337

    ld d, $9d

jr_002_5337::
    ld a, d
    ldh [$ffc9], a
    call Call_002_5419
    call Call_002_5658
    call Call_002_5521
    call Call_002_55ac
    ld a, [$d823]
    or a
    ret nz

    ld a, [$d822]
    cp $f0
    ret c

    ld a, [$d81d]
    or a
    jr z, jr_002_5363

    ld a, [$d95d]
    or a
    jr z, jr_002_5363

    ld a, $02
    ld [$d93d], a
    ret


jr_002_5363::
    ld a, $04
    ld [$d93d], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ld hl, $7a36
    ld a, [$d811]
    cp $0a
    jr nz, jr_002_537d

    ld hl, $7a61

jr_002_537d::
    ld a, [$d81d]
    or a
    jr nz, jr_002_538b

    ld a, $5b
    call PlaySound
    ld hl, $7a43

jr_002_538b::
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d954], a
    ret


    ld hl, $d817
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $ffa0
    add hl, bc
    ld a, l
    ld [$d817], a
    ld a, h
    ld [$d818], a
    ld a, $9c
    ldh [$ffc9], a
    call Call_002_5419
    call Call_002_5658
    call Call_002_5521
    ld a, [$d955]
    cp $07
    jr c, jr_002_53d0

    ldh a, [hJoyPressed]
    ld b, a
    ld a, [$d81d]
    and b
    jr z, jr_002_53d0

    ld a, [$d954]
    ld [$d955], a

jr_002_53d0::
    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $08
    ret nz

    ld a, $5c
    call PlaySound
    ld hl, $d81a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    inc hl
    ld d, [hl]
    inc hl
    ld a, l
    ld [$d81a], a
    ld a, h
    ld [$d81b], a
    ld hl, $007c
    bit 6, d
    jr z, jr_002_53fc

    ld hl, $ff84

jr_002_53fc::
    ld a, l
    ld [$d815], a
    ld a, h
    ld [$d816], a
    ld hl, $5808
    ld a, [$d955]
    rst $20
    ld a, l
    ld [$d817], a
    ld a, h
    ld [$d818], a
    ld a, $03
    ld [$d93d], a
    ret


Call_002_5419::
    ld a, [$d93d]
    cp $05
    jr z, jr_002_5456

    ld a, [$d816]
    ld b, $00
    bit 7, a
    jr z, jr_002_542b

    ld b, $ff

jr_002_542b::
    ld hl, $d81e
    ld a, [$d815]
    add [hl]
    ld [hl+], a
    ld a, [$d816]
    adc [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl+], a
    ld a, [$d818]
    ld b, $00
    bit 7, a
    jr z, jr_002_5446

    ld b, $ff

jr_002_5446::
    ld hl, $d821
    ld a, [$d817]
    add [hl]
    ld [hl+], a
    ld a, [$d818]
    adc [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a

jr_002_5456::
    ld hl, $d81f
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $ffb0
    add hl, bc
    bit 7, h
    jr z, jr_002_5467

    ld hl, $0000

jr_002_5467::
    ld a, h
    cp $03
    jr c, jr_002_546f

    ld hl, $0300

jr_002_546f::
    ld a, l
    ld [$d812], a
    ld a, h
    ld [$d813], a
    ld hl, $d81f
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld l, $70
    ld a, [$d93d]
    cp $02
    jr z, jr_002_549f

    ld hl, $d822
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $ffb8
    add hl, bc
    ld a, h
    or a
    jr z, jr_002_5498

    ld l, $00
    jr jr_002_549f

jr_002_5498::
    ld a, l
    cp $70
    jr c, jr_002_549f

    ld l, $70

jr_002_549f::
    ld a, l
    ld [$d814], a
    ld a, [$d812]
    ldh [hSCX], a
    ld a, [$d814]
    ldh [hSCY], a
    ld a, [$d812]
    ld c, a
    ld a, [$d81f]
    sub c
    ld c, a
    ld [$d97b], a
    ld a, [$d823]
    or a
    ret nz

    ld a, [$d814]
    ld b, a
    ld a, [$d822]
    sub b
    ld b, a
    ld e, $00
    ld a, [$d816]
    bit 7, a
    jr z, jr_002_54d2

    ld e, $01

jr_002_54d2::
    ld a, e
    ldh [hSpriteFlags], a
    ld a, [$d81d]
    or a
    jr nz, jr_002_54f1

    ldh a, [$ffc9]
    cp $9c
    jr nz, jr_002_54e3

    ld a, $a8

jr_002_54e3::
    cp $9d
    jr nz, jr_002_54e9

    ld a, $a6

jr_002_54e9::
    cp $9e
    jr nz, jr_002_54ef

    ld a, $a7

jr_002_54ef::
    ldh [$ffc9], a

jr_002_54f1::
    ldh a, [$ffc9]
    ld d, a
    call jr_000_0794
    ld a, [$d824]
    or a
    ret z

    ld hl, $d812
    ld a, [$d825]
    sub [hl]
    ld c, a
    inc hl
    ld a, [$d826]
    sbc [hl]
    or a
    ret nz

    ld a, [$d814]
    ld b, a
    ld a, [$d827]
    sub b
    ld b, a
    ld de, $d803
    call Call_000_0720
    or a
    ret z

    xor a
    ld [$d824], a
    ret


Call_002_5521::
    ld hl, $d81a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    inc hl
    ld a, [hl-]
    dec hl
    dec hl
    and $0f
    add a
    add a
    ld b, a
    ld a, l
    sub b
    ld l, a
    ld a, h
    sbc $00
    ld h, a
    ld a, l
    ldh [$ffca], a
    ld a, h
    ldh [$ffcb], a
    ld a, [$d811]
    dec a
    ld hl, $5704
    rst $20

jr_002_5547::
    ld d, $ab
    ld a, [$d93d]
    cp $06
    jr nz, jr_002_555c

    ldh a, [$ffca]
    cp l
    jr nz, jr_002_555c

    ldh a, [$ffcb]
    cp h
    jr nz, jr_002_555c

    ld d, $ac

jr_002_555c::
    ld a, d
    ldh [$ffc9], a
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    ldh a, [hSCY]
    ld b, a
    ld a, [hl+]
    sub b
    ld b, a
    ld c, [hl]
    inc hl
    push hl
    ld hl, $000c
    add hl, de
    bit 7, c
    jr z, jr_002_55a5

    ld a, [$d812]
    ld c, a
    ld a, l
    sub c
    ld l, a
    ld a, [$d813]
    ld c, a
    ld a, h
    sbc c
    ld h, a
    ld a, h
    or a
    jr nz, jr_002_55a5

    ld a, l
    cp $e8
    jr nc, jr_002_55a5

    sub $10
    ld c, a
    pop hl
    push hl
    ld a, [hl]
    cp $ff
    jr nz, jr_002_559f

    ld a, $ad
    ldh [$ffc9], a
    ld a, [$d95d]
    or a
    jr z, jr_002_55a5

jr_002_559f::
    ldh a, [$ffc9]
    ld d, a
    call Call_000_0791

jr_002_55a5::
    pop hl
    ld a, [hl]
    cp $ff
    jr nz, jr_002_5547

    ret


Call_002_55ac::
    ld a, [$d818]
    bit 7, a
    ret nz

    ld hl, $d81a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl]
    ld [$d825], a
    ld a, [$d81f]
    add $0c
    push af
    sub [hl]
    inc hl
    ld b, a
    ld a, [hl]
    ld [$d826], a
    ld a, [$d820]
    sbc [hl]
    ld c, a
    pop af
    ld a, c
    adc $00
    inc hl
    or a
    ret nz

    ld a, b
    cp $18
    ret nc

    ld a, [$d823]
    or a
    ret nz

    ld a, [hl]
    add $18
    ld [$d827], a
    ld a, [$d822]
    add $18
    sub [hl]
    inc hl
    ld d, [hl]
    inc hl
    ld b, a
    ld c, $10
    ld a, [hl]
    cp $ff
    jr nz, jr_002_55f7

    ld c, $40

jr_002_55f7::
    ld a, b
    cp c
    ret nc

    ld a, [hl]
    cp $ff
    jr z, jr_002_5649

    ld a, $06
    ld [$d93d], a
    ld a, [$d81d]
    or a
    ld a, $08
    jr nz, jr_002_560e

    ld a, $07

jr_002_560e::
    ld [$d955], a
    xor a
    ld [$d954], a
    dec hl
    dec hl
    ld a, [hl]
    sub $18
    ld [$d822], a
    ld hl, $0300
    ld a, l
    ld [$d817], a
    ld a, h
    ld [$d818], a
    xor a
    bit 6, d
    jr z, jr_002_562e

    cpl

jr_002_562e::
    ld [$d815], a
    ld [$d816], a
    ld hl, $7a4e
    ld a, l
    ld [$d803], a
    ld a, h
    ld [$d804], a
    xor a
    ld [$d805], a
    ld a, $01
    ld [$d824], a
    ret


jr_002_5649::
    ld a, [$d95d]
    or a
    ret z

    ld a, $44
    call PlaySound
    xor a
    ld [$d95d], a
    ret


Call_002_5658::
    ld e, $14
    ld a, [$d816]
    bit 7, a
    jr z, jr_002_5663

    ld e, $fe

jr_002_5663::
    ld hl, $d812
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    ld a, e
    add l
    ld b, a
    and $1f
    ld hl, $9800
    rst $38
    call Call_000_04eb
    ld a, h
    ld [de], a
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, $a0
    ld [de], a
    inc de
    ld a, b
    and $7f
    ld hl, $c800
    rst $38
    ld b, $20

jr_002_5694::
    ld a, [hl]
    ld [de], a
    inc de
    ld a, $80
    rst $38
    dec b
    jr nz, jr_002_5694

    xor a
    ld [de], a
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ret


    call Call_002_5521
    ld de, $d800
    ld a, [$d97b]
    ld c, a
    ld b, $80
    call Call_000_0720
    ld a, [$d819]
    inc a
    ld [$d819], a
    cp $90
    ret c

    ld a, [$d81d]
    or a
    jr z, jr_002_56f9

    ld a, $a0
    ld [$d819], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld a, [$d811]
    cp $0a
    jp z, Jump_002_4301

    ld a, [$d95f]
    or a
    jp nz, Jump_002_4301

    ld a, [$d811]
    inc a
    ld [$d811], a
    ld hl, $dffb
    ld b, [hl]
    cp b
    jr c, jr_002_56ed

    ld [hl], a

jr_002_56ed::
    xor a
    ld [$d81d], a
    ld a, $01
    ldh [hNeedsReset], a
    ld [$d81c], a
    ret


jr_002_56f9::
    ld a, $01
    ld [$d81d], a
    ldh [hNeedsReset], a
    ld [$d81c], a
    ret


    db $18, $57

    ld e, $57
    jr z, @+$59

    ld [hl], $57
    ld c, b
    ld d, a
    ld e, [hl]
    ld d, a
    ld a, b
    ld d, a
    sub [hl]
    ld d, a
    cp b
    ld d, a
    sbc $57

    db $60, $01, $a0, $80, $ff

    rst $38
    ld d, b
    ld bc, $80c8
    ld [hl], b
    ld bc, $8030
    rst $38
    rst $38
    ld d, b
    ld bc, $80c8
    add b
    ld bc, $8068
    ret nc

    ld bc, $8080
    rst $38
    rst $38
    ld b, b
    ld bc, $80b0
    ld [hl], b
    ld bc, $8058
    or b
    ld bc, $8030
    nop
    ld [bc], a
    ld e, b
    add b
    rst $38
    rst $38
    ld b, b
    ld bc, $c0b8
    ld [$5801], sp
    add b
    ld c, b
    ld bc, $8040
    and b
    ld bc, $8090
    ret nc

    ld bc, $8030
    rst $38
    rst $38
    ld b, b
    ld bc, $80b8
    ld [hl], b
    ld bc, $8058
    ret nz

    ld bc, $80c0
    ld hl, sp+$01
    ld h, b
    add b
    jr c, jr_002_5772

    ld b, b
    add b

jr_002_5772::
    adc b
    ld [bc], a
    and b
    add b
    rst $38
    rst $38
    jr nc, jr_002_577b

    xor b

jr_002_577b::
    add b
    ld h, b
    ld bc, $8048
    or b
    ld bc, $80d8
    add sp, $01

jr_002_5786::
    add b
    add b
    jr z, jr_002_578c

    add b
    ret nz

jr_002_578c::
    add sp, $01
    add b
    ld b, d
    cp b
    ld bc, $8020
    rst $38
    rst $38
    ld c, b
    ld bc, $c0b8
    ld [$5801], sp
    add b
    ld e, b
    ld bc, $8040
    or b
    ld bc, $8090
    ldh [rSB], a
    ld b, b
    add b
    ld b, b
    ld [bc], a
    ret nc

    add b
    ld [hl], b
    ld [bc], a
    adc b
    add b
    or b
    ld [bc], a
    ld b, b
    add b
    rst $38
    rst $38
    ld h, d
    ld bc, $80d0
    adc b
    ld bc, $8070
    ret nc

    ld bc, $c070
    adc b
    ld bc, $0270
    ret nc

    ld bc, $4270
    adc b
    ld bc, $0470
    ret nc

    ld bc, $0470
    inc h
    ld [bc], a
    ret nc

    add b
    ld h, b
    ld [bc], a
    sub b
    add b
    rst $38
    rst $38
    inc a
    ld bc, $80b0
    ld h, h
    ld bc, $804a
    cp b
    ld bc, $80d0
    ldh a, [rSB]
    ld a, b
    add b
    jr c, jr_002_57f2

    ret nc

    add b

jr_002_57f2::
    ld a, b
    ld [bc], a
    ld [hl], b
    add b
    ret nz

    ld [bc], a
    cp b
    add b
    ldh a, [rSC]
    ld e, b
    add b
    jr nc, jr_002_5803

    jr c, @-$7e

    ld [hl], b

jr_002_5803::
    inc bc
    jr nz, jr_002_5786

    rst $38
    rst $38
    nop
    rst $38
    add b
    cp $00
    db $fd
    nop
    db $fd
    nop
    db $fd
    nop
    db $fd
    nop
    db $fd
    nop
    db $fd
    add b
    rst $38

    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld [$d84d], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, $06
    ld hl, $5851
    ld de, $8000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $6839
    ld de, $8000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $6e44
    ld de, $8900
    call LoadMaskedGfx
    ld a, $06
    ld hl, $6fe5
    ld de, $c800
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $1412
    call jr_000_05f7
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [$d93d], a
    ld [$d84b], a
    ld a, $0d
    ld [$d933], a
    ret


    ld a, [$d84d]
    or a
    jr z, jr_002_589d

    dec a
    ld [$d84d], a
    ld a, $1b
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    jr jr_002_58bd

jr_002_589d::
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $e0
    ld [wPaletteOBP1], a
    ld a, [$dff8]
    or a
    jr z, jr_002_58bd

    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a

jr_002_58bd::
    ld a, [$d93d]
    rst $00

    db $43, $49, $cb, $58, $06, $5a

    and l
    ld e, l

    db $18, $5e

    xor a
    ld [$d955], a
    call Call_002_5e5a
    call Call_000_0719
    ld c, $0f
    ld b, $1c
    ld d, $60
    call Call_000_0791
    ld a, [$d852]
    cp $ff
    jr nz, jr_002_590c

    ld a, [$d811]
    ld [$d971], a
    xor a
    ld [$d970], a
    ld a, $14
    call Call_000_0710
    ld bc, $9a01
    ld de, $ac11
    call QueueVramFill
    ld bc, $9a21
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [$d852], a
    ret


jr_002_590c::
    ld a, [$d954]
    dec a
    ld [$d954], a
    ld b, a
    ld a, [$d852]
    or b
    jp nz, Jump_002_59cd

    call InitSound
    ld a, $2c
    call PlaySound_Queue3
    ld bc, $9928
    ld de, $0004
    call QueueVramFill
    ld bc, $9948
    ld de, $0004
    call QueueVramFill
    ld de, $5ece
    ld hl, $9a01
    ld bc, $1102
    call QueueTilemapRect
    ld a, $02
    ld [$d93d], a
    xor a
    ld [$d976], a
    ld [$d829], a
    ld a, [$d811]
    ld b, a
    sla a
    add b
    ld hl, $5f0e
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, $9a2f
    ld a, [de]
    cp $04
    jr nz, jr_002_5968

    inc de
    inc hl
    dec b

jr_002_5968::
    call QueueTilemapRect
    ld a, [$d811]
    dec a
    ld b, a
    add a
    add b
    ld hl, $5ef0
    rst $38
    ld a, [hl+]
    ld [$d853], a
    ld a, [hl+]
    ld [$d854], a
    ld a, [hl+]
    ld [$d855], a
    ld a, $01
    ld [$d852], a
    ld a, $04
    ld [$d856], a
    ld [$d857], a
    ld [$d858], a
    ld hl, $79bb
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d84c], a
    ld [$d850], a
    cpl
    ld [$d84f], a
    call Call_002_495b
    and $07
    add $0a
    ld [$d84e], a
    ld b, $04
    ld hl, $d82b

jr_002_59ba::
    xor a
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $9c
    ld [hl+], a
    ld a, $23
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    dec b
    jr nz, jr_002_59ba

    ret


Jump_002_59cd::
    ld a, [$d954]
    or a
    ret nz

    xor a
    ld [$d970], a
    ld a, [$d852]
    dec a
    ld [$d852], a
    add $10
    call Call_000_0710
    ld bc, $9a26
    ld de, $0008
    call QueueVramFill
    ld hl, $9a0c
    ld a, $ac
    call QueueTilemapByte
    ld a, $32
    ld [$d954], a
    ld a, [$d852]
    or a
    ld a, $59
    jr nz, jr_002_5a02

    ld a, $5a

jr_002_5a02::
    call PlaySound
    ret


    ldh a, [hJoyPressed]
    bit 3, a
    call nz, Call_002_4a1b
    ld a, [$d976]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, $d800
    call Call_000_0720
    ld a, [$d852]
    cp $01
    jr nz, jr_002_5a2f

    ld a, [$d84e]
    or a
    jr z, jr_002_5a2f

    dec a
    ld [$d84e], a

jr_002_5a2f::
    ld a, [$d850]
    or a
    jp z, jr_002_5abe

    ld c, a
    ld a, [$d84f]
    bit 7, a
    jr z, jr_002_5a45

    ld a, [$d850]
    dec a
    ld [$d850], a

jr_002_5a45::
    ld a, [$d84f]
    and $7f
    swap a
    add a
    or $18
    ld b, a
    ld a, $00
    bit 7, c
    jr z, jr_002_5a58

    ld a, $02

jr_002_5a58::
    ldh [hSpriteFlags], a
    ld d, $76
    call jr_000_0794
    ld a, [$d976]
    ld b, a
    ld a, [$d84f]
    bit 7, a
    jr z, jr_002_5abe

    and $7f
    cp b
    jr nz, jr_002_5abe

    ld a, [$d850]
    cp $18
    jr nc, jr_002_5abe

    ld a, $20
    ld [$d84d], a
    ld a, $49
    call PlaySound_Queue1
    xor a
    ld c, a
    ld [$d850], a
    ld hl, $d82b
    ld de, $0008
    ld b, $04

jr_002_5a8d::
    push hl
    ld a, [hl]
    res 3, [hl]
    set 1, [hl]
    inc hl
    inc hl
    bit 1, a
    jr nz, jr_002_5aa4

    ld a, [hl]
    cp $98
    inc hl
    inc hl
    inc hl
    ld [hl], $00
    jr nc, jr_002_5aa4

    inc c

jr_002_5aa4::
    pop hl
    add hl, de
    dec b
    jr nz, jr_002_5a8d

    ld a, c
    ld c, $00
    bit 0, a
    jr z, jr_002_5ab2

    ld c, $05

jr_002_5ab2::
    srl a
    ld b, a
    ld hl, $5f0e
    call Call_002_6509
    jp nc, Jump_002_5d58

jr_002_5abe::
    ldh a, [hJoyPressed]
    and $03
    jr z, jr_002_5aed

    ld a, [$d829]
    or a
    jr nz, jr_002_5aed

    ld a, [$d976]
    ld [$d82a], a
    ld a, $1a
    ld [$d829], a
    xor a
    ld [$d828], a
    ld a, $50
    call PlaySound
    ld hl, $79b7
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a

jr_002_5aed::
    call Call_002_5b7f
    call Call_002_4979
    or a
    jr nz, jr_002_5b16

    ld a, $03
    ld [$d93d], a
    ld hl, $79cd
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d954], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    ret


jr_002_5b16::
    ld a, [$d84c]
    dec a
    ld [$d84c], a
    cp $ff
    jr z, jr_002_5b32

    or a
    ret nz

    ld hl, $79bb
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a

jr_002_5b32::
    xor a
    ld [$d84c], a
    ldh a, [hJoyPressed]
    ld b, a
    ld a, [$d976]
    bit 6, b
    jr z, jr_002_5b44

    or a
    jr z, jr_002_5b44

    dec a

jr_002_5b44::
    bit 7, b
    jr z, jr_002_5b4d

    cp $03
    jr nc, jr_002_5b4d

    inc a

jr_002_5b4d::
    ld [$d976], a
    ld hl, $d828
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    or a
    ret z

    ld bc, $0300
    add hl, bc
    ld a, l
    ld [$d828], a
    ld a, h
    ld [$d829], a
    ld a, h
    cp $98
    jr nc, jr_002_5b7a

    ld c, h
    ld a, [$d82a]
    swap a
    add a
    or $16
    ld b, a
    ld d, $62
    call Call_000_0791
    ret


jr_002_5b7a::
    xor a
    ld [$d829], a
    ret


Call_002_5b7f::
    call Call_002_5e5a
    ldh a, [$ffcb]
    ldh [$ffcc], a
    xor a
    ldh [$ffcb], a
    ld a, $04
    ldh [$ffcd], a
    ld hl, $d84b

Jump_002_5b90::
    ldh a, [$ffcd]
    dec a
    ldh [$ffca], a
    swap a
    add a
    or $17
    ldh [$ffc9], a
    ld bc, $fff8
    add hl, bc
    push hl
    ld a, [$d93d]
    cp $04
    jr nz, jr_002_5bac

    set 1, [hl]
    res 3, [hl]

jr_002_5bac::
    ld a, [hl+]
    ld d, a
    and $07
    cp $01
    jr nz, jr_002_5bb9

    ldh a, [$ffcb]
    inc a
    ldh [$ffcb], a

jr_002_5bb9::
    ld bc, $0200
    bit 1, d
    jr nz, jr_002_5bd4

    push hl
    push de
    ld a, [$d811]
    dec a
    ld hl, $5e84
    bit 0, d
    jr z, jr_002_5bcf

    add $0a

jr_002_5bcf::
    rst $20
    ld c, l
    ld b, h
    pop de
    pop hl

jr_002_5bd4::
    bit 3, d
    jr z, jr_002_5bdb

    ld bc, $0000

jr_002_5bdb::
    ld a, c
    add [hl]
    ld [hl+], a
    ld a, b
    adc [hl]
    ld [hl], a
    ld a, [hl-]
    dec hl
    cp $2a
    jr nc, jr_002_5c08

    push hl
    ld a, $03
    ld [$d93d], a
    ld hl, $79cd
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d954], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3
    pop hl

jr_002_5c08::
    inc hl
    inc hl
    ld a, [hl]
    bit 1, d
    jr z, jr_002_5c67

    cp $a8
    jr c, jr_002_5c67

    inc hl
    inc hl
    call Call_002_495b
    and $3f
    add $38
    ld [hl-], a
    dec hl
    call Call_002_495b
    and $3f
    add $a8
    ld [hl-], a
    dec hl
    ld a, [$d811]
    dec a
    add $b8
    ld c, a
    ld a, $00
    adc $5e
    ld b, a
    ld a, [bc]
    ld c, a
    ldh a, [$ffcc]
    cp $03
    jr c, jr_002_5c3d

    ld c, $00

jr_002_5c3d::
    call Call_002_495b
    and $07
    cp c
    ld a, $00
    jr nc, jr_002_5c49

    ld a, $01

jr_002_5c49::
    ld [hl+], a
    inc hl
    ld a, [$d84e]
    or a
    jr nz, jr_002_5c67

    call Call_002_495b
    and $07
    add $0a
    ld [$d84e], a
    ld a, [$d850]
    or a
    jr nz, jr_002_5c67

    ldh a, [$ffcd]
    dec a
    ld [$d84f], a

jr_002_5c67::
    ld a, [$d84f]
    bit 7, a
    jr nz, jr_002_5c7e

    ld a, [$d84f]
    inc a
    ld b, a
    ldh a, [$ffcd]
    cp b
    jr nz, jr_002_5c7e

    ld a, [hl]
    sub $14
    ld [$d850], a

jr_002_5c7e::
    ld a, [hl+]
    ld c, a
    inc hl
    bit 3, d
    jr nz, jr_002_5c97

    bit 0, d
    jr z, jr_002_5ca5

    ld a, [hl]
    cp c
    jr c, jr_002_5ca5

    ld [hl], $30
    pop de
    push de
    ld a, [de]
    set 3, a
    ld [de], a
    jr jr_002_5ca5

jr_002_5c97::
    dec [hl]
    ld a, [hl]
    or a
    jr nz, jr_002_5ca5

    pop de
    push de
    ld a, [de]
    res 3, a
    ld [de], a
    inc hl
    ld a, c
    ld [hl-], a

jr_002_5ca5::
    dec hl
    push hl
    ldh a, [$ffc9]
    ld b, a
    ld a, c
    srl a
    srl a
    srl a
    and $03
    bit 1, d
    jr z, jr_002_5cb9

    ld a, $04

jr_002_5cb9::
    bit 3, d
    jr z, jr_002_5cbf

    ld a, $05

jr_002_5cbf::
    ld hl, $5eac
    bit 0, d
    jr z, jr_002_5cc9

    ld hl, $5eb2

jr_002_5cc9::
    rst $38
    ld d, [hl]
    call Call_000_0785
    pop hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    jr z, jr_002_5d18

    cp $20
    jr nc, jr_002_5d00

    cp $10
    jr c, jr_002_5d00

    ldh a, [$ffca]
    ld b, a
    ld a, [$d976]
    cp b
    jr nz, jr_002_5d00

    ld bc, $79cd
    ld a, c
    ld [$d800], a
    ld a, b
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [hl], a
    ld a, $78
    ld [$d84c], a
    ld a, $51
    call PlaySound

jr_002_5d00::
    inc hl
    ld bc, $fd80
    ld a, [hl]
    add c
    ld [hl-], a
    ld a, [hl]
    adc b
    cp $f0
    jr c, jr_002_5d0e

    xor a

jr_002_5d0e::
    ld [hl], a
    ld c, a
    ldh a, [$ffc9]
    ld b, a
    ld d, $72
    call Call_000_0791

jr_002_5d18::
    pop hl
    ldh a, [$ffcd]
    dec a
    ldh [$ffcd], a
    jp nz, Jump_002_5b90

    ld a, [$d82a]
    swap a
    srl a
    ld hl, $d82b
    rst $38
    inc hl
    inc hl
    ld b, [hl]
    ld a, [$d829]
    cp b
    jr c, jr_002_5d91

    ld a, $52
    call PlaySound
    xor a
    ld [$d829], a
    dec hl
    dec hl
    set 1, [hl]
    res 3, [hl]
    ld bc, $0005
    add hl, bc
    ld [hl], $00
    ld a, [$d8df]
    ld bc, $0005
    ld hl, $5f0e
    call Call_002_6509
    jr c, jr_002_5d82

Jump_002_5d58::
    ld a, $04
    ld [$d93d], a
    ld hl, $79be
    ld a, [$d811]
    cp $0a
    jr nz, jr_002_5d6a

    ld hl, $79d4

jr_002_5d6a::
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d954], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


jr_002_5d82::
    ld a, [$d82a]
    ld b, a
    ld a, [$d84f]
    cp b
    ret nz

    set 7, a
    ld [$d84f], a
    ret


jr_002_5d91::
    inc hl
    inc hl
    inc hl
    ld a, [hl]
    or a
    ret z

    ld b, a
    ld a, [$d829]
    or a
    ret z

    cp b
    ret c

    xor a
    ld [hl], a
    ld [$d829], a
    ret


    ld a, [$d976]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, $d800
    call Call_000_0720
    ld b, $04
    ld hl, $d84b

jr_002_5dbb::
    push bc
    ld e, b
    ld bc, $fff8
    add hl, bc
    push hl
    ld d, $00
    bit 0, [hl]
    jr z, jr_002_5dca

    ld d, $02

jr_002_5dca::
    inc hl
    inc hl
    ld a, e
    dec a
    swap a
    add a
    or $17
    ld b, a
    ld a, [hl]
    ld c, a
    cp $90
    ld a, $00
    jr c, jr_002_5dde

    ld a, $02

jr_002_5dde::
    ldh [hSpriteFlags], a
    ld a, [$d954]
    bit 4, a
    jr nz, jr_002_5de8

    inc d

jr_002_5de8::
    ld a, d
    ld hl, $5ec2
    rst $38
    ld d, [hl]
    call jr_000_0794
    pop hl
    pop bc
    dec b
    jr nz, jr_002_5dbb

    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $90
    ret c

    ld a, $01
    ld [$d95d], a
    ldh a, [hJoyPressed]
    bit 0, a
    jp nz, Jump_002_49cc

    ld a, [$d954]
    cp $ff
    ret nz

    ld a, $7f
    ld [$d954], a
    ret


    ld hl, $d830
    xor a
    ld de, $0008
    ld b, $04

jr_002_5e21::
    ld [hl], a
    add hl, de
    dec b
    jr nz, jr_002_5e21

    call Call_002_5b7f
    ld a, [$d976]
    swap a
    add a
    or $1c
    ld b, a
    ld c, $0f
    ld de, $d800
    call Call_000_0720
    or a
    ret z

    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $40
    ret c

    ld a, $a0
    ld [$d954], a
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    ld hl, $dff9
    xor a
    ld [$d95d], a
    jp Jump_002_49cc


Call_002_5e5a::
    ld a, [$d955]
    inc a
    ld [$d955], a
    srl a
    srl a
    and $06
    ld hl, $5ec6
    rst $38
    ld e, l
    ld d, h
    ld hl, $9823

jr_002_5e70::
    push de
    push hl
    ld bc, $0102
    call QueueTilemapRect
    pop hl
    pop de
    ld bc, $0080
    add hl, bc
    ld a, h
    cp $9a
    jr nz, jr_002_5e70

    ret


    db $80, $ff, $79, $ff

    ld [hl], c
    rst $38
    ld l, c
    rst $38
    ld h, c
    rst $38
    ld e, d
    rst $38
    ld d, d
    rst $38
    ld c, d
    rst $38
    ld b, d
    rst $38
    ld a, [hl-]
    rst $38

    db $40, $ff, $39, $ff

    ld sp, $29ff
    rst $38
    ld hl, $1aff
    rst $38
    ld [de], a
    rst $38
    ld a, [bc]
    rst $38
    ld [bc], a
    rst $38
    db $fa
    db $fe

    db $69, $6a, $69, $6b, $6d, $6d, $6e, $6f, $6e, $70, $75, $71, $01, $01

    ld [bc], a
    ld [bc], a
    inc bc
    inc bc
    inc b
    inc b
    dec b
    dec b
    ld l, h
    ld l, c
    ld [hl], e
    ld [hl], h

    db $91, $a1, $a8, $a9, $aa, $ab, $a8, $a9, $85, $86, $87, $ac, $ac, $ac, $ac, $ac
    db $80, $81, $ac, $ac, $ac, $ac, $82, $83, $84, $00, $00, $04, $00, $00, $00, $00
    db $00, $0d, $0d, $00, $00, $00, $00, $00, $00, $04, $00, $03, $01, $00, $04, $01

    nop
    dec b
    ld bc, jr_000_0600
    ld bc, $0700
    ld bc, $0800
    ld bc, $0900
    ld bc, $0001
    ld bc, $0101
    ld bc, $0201
    ld bc, $0404
    inc b

    db $05, $04, $04, $05, $09, $04

    ld b, $04
    inc b
    ld b, $09
    inc b
    rlca
    inc b
    inc b
    rlca
    add hl, bc
    inc b
    ld [$0404], sp
    ld [$0409], sp
    add hl, bc
    inc b
    inc b
    add hl, bc
    add hl, bc
    inc b

    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $8c
    ldh [hOamMaxY], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $06
    ld hl, $5851
    ld de, $8000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $60db
    ld de, $c800
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $1412
    call jr_000_05f7
    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [$d93d], a
    ld [$d955], a
    ld a, $0e
    ld [$d933], a
    ret


    ld a, [$d93d]
    rst $00

    db $43, $49, $8e, $5f, $db, $60

    call Call_000_0719
    ld bc, $4050
    ld d, $1a
    call Call_000_0791
    ld bc, $4920
    ld d, $3e
    ld a, [$d811]
    cp $04
    call nc, Call_000_0791
    ld bc, $4980
    ld d, $46
    ld a, [$d811]
    cp $07
    call nc, Call_000_0791
    ld a, [$d852]
    cp $ff
    jr nz, jr_002_5fe1

    ld a, [$d811]
    ld [$d971], a
    xor a
    ld [$d970], a
    ld a, $14
    call Call_000_0710
    ld bc, $9a01
    ld de, $9111
    call QueueVramFill
    ld bc, $9a21
    ld de, $0011
    call QueueVramFill
    ld a, $04
    ld [$d852], a
    ret


jr_002_5fe1::
    ld a, [$d954]
    dec a
    ld [$d954], a
    ld b, a
    ld a, [$d852]
    or b
    jp nz, Jump_002_60a2

    call InitSound
    ld a, $24
    call PlaySound_Queue3
    ld de, $6706
    ld hl, $9a01
    ld bc, $1102
    call QueueTilemapRect
    ld bc, $9948
    ld de, $0004
    call QueueVramFill
    ld hl, $9929
    xor a
    call QueueTilemapByte
    ld a, [$d811]
    ld b, a
    sla a
    add b
    ld hl, $6728
    rst $38
    ld e, l
    ld d, h
    ld bc, $0301
    ld hl, $9a2f
    ld a, [de]
    cp $04
    jr nz, jr_002_602f

    inc de
    inc hl
    dec b

jr_002_602f::
    call QueueTilemapRect
    xor a
    ld [$d853], a
    ld a, $09
    ld [$d854], a
    ld [$d855], a
    ld a, $04
    ld [$d856], a
    ld [$d857], a
    ld [$d858], a
    ld a, $32
    ld [$d852], a
    ld a, $02
    ld [$d93d], a
    ld a, $a0
    ld [$d85a], a
    ld hl, $7913
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d8dd], a
    ld [$d956], a
    ld a, $50
    ld [$d975], a
    ld a, $40
    ld [$d976], a
    ld a, $02
    ld [$d977], a
    ld hl, $6846
    ld de, $d8e2
    ld b, $10

jr_002_6084::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_6084

    ld a, $80
    ld hl, $d85d
    ld bc, $0008
    ld d, $10

jr_002_6094::
    ld [hl], a
    add hl, bc
    dec d
    jr nz, jr_002_6094

    call Call_002_495b
    and $03
    ld [$d859], a
    ret


Jump_002_60a2::
    ld a, [$d954]
    or a
    ret nz

    xor a
    ld [$d970], a
    ld a, [$d852]
    dec a
    ld [$d852], a
    add $10
    call Call_000_0710
    ld bc, $9a26
    ld de, $0008
    call QueueVramFill
    ld hl, $9a0c
    ld a, $91
    call QueueTilemapByte
    ld a, $32
    ld [$d954], a
    ld a, [$d852]
    or a
    ld a, $59
    jr nz, jr_002_60d7

    ld a, $5a

jr_002_60d7::
    call PlaySound
    ret


    ld a, [$d957]
    inc a
    ld [$d957], a
    ldh a, [hJoyPressed]
    bit 3, a
    call nz, Call_002_4a1b
    ld a, [$d975]
    ld c, a
    ld a, [$d976]
    ld b, a
    ld de, $d800
    call Call_000_0720
    ld a, [$d956]
    or a
    jr z, jr_002_6108

    dec a
    ld [$d956], a
    bit 3, a
    jr z, jr_002_6108

    xor a
    ldh [hOamWritePos], a

jr_002_6108::
    call Call_002_65b3
    call Call_002_64d9
    ld a, [$d85c]
    inc a
    ld [$d85c], a
    call Call_002_4979
    or a
    jr nz, jr_002_6141

    ld a, $04
    ld [$d8dd], a
    ld hl, $7960
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld a, $01
    ld [$d95d], a
    ld a, $90
    ld [$d954], a
    call InitSound
    ld a, $38
    call PlaySound_Queue3

jr_002_6141::
    ld a, [$d85a]
    dec a
    ld [$d85a], a
    cp $60
    jp nc, jr_002_6204

    and $0f
    jp nz, jr_002_6204

    ld a, [$d859]
    sla a
    sla a
    ld hl, $6749
    rst $38
    ld a, [hl+]
    push hl
    ld h, [hl]
    ld l, a
    ld a, [$d85a]
    ld de, $6759
    bit 4, a
    jr z, jr_002_6176

    ld a, [$d8dd]
    cp $04
    jp z, jr_002_6176

    ld de, $675c

jr_002_6176::
    ld bc, $0301
    call QueueTilemapRect
    pop hl
    ld a, [$d85a]
    or a
    jp nz, jr_002_6204

    ld a, [$d8dd]
    cp $04
    jp z, jr_002_6204

    inc hl
    ld a, [hl+]
    ldh [$ffc9], a
    ld a, [hl]
    ldh [$ffca], a
    ld a, [$d811]
    dec a
    add a
    add a
    ld hl, $676b
    rst $38
    call Call_002_495b
    and $07
    ld b, $00

jr_002_61a4::
    sub [hl]
    jr c, jr_002_61ab

    inc b
    inc hl
    jr jr_002_61a4

jr_002_61ab::
    ld a, b
    ldh [$ffcb], a
    ld a, [$d859]
    ld b, a
    add a
    add b
    ld hl, $675f
    rst $38
    ldh a, [$ffcb]
    cp $03
    jr nz, jr_002_61c8

    call Call_002_495b
    bit 0, a
    jr z, jr_002_61cc

    inc hl
    jr jr_002_61cc

jr_002_61c8::
    call Call_002_4968
    rst $38

jr_002_61cc::
    ld d, [hl]
    ld hl, $d85d
    ld b, $10

jr_002_61d2::
    ld a, [hl]
    bit 7, a
    jr nz, jr_002_61df

    ld a, $08
    rst $38
    dec b
    jr nz, jr_002_61d2

    jr jr_002_6204

jr_002_61df::
    ldh a, [$ffcb]
    ld [hl+], a
    ld [hl], d
    inc hl
    ldh a, [$ffc9]
    ld [hl+], a
    ldh a, [$ffca]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl], a
    call Call_002_495b
    and $7f
    add $40
    ld [$d85a], a
    call Call_002_495b
    and $03
    ld [$d859], a

jr_002_6204::
    ld b, $10
    ld hl, $d85d

Jump_002_6209::
    push bc
    push hl
    ld a, [hl]
    and $c0
    jp nz, jr_002_6290

    ld a, [hl]
    push hl
    cp $03
    call nc, Call_002_62a9
    pop hl
    ld a, [hl]
    sla a
    ld de, $6793
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld bc, $0004
    add hl, bc
    ld a, [de]
    inc de
    add [hl]
    ld [hl], a
    ld a, [de]
    adc $00
    dec hl
    dec hl
    dec hl
    ld b, [hl]
    inc hl
    push hl
    bit 1, b
    jr nz, jr_002_623c

    cpl
    inc a

jr_002_623c::
    bit 0, b
    jr nz, jr_002_6241

    inc hl

jr_002_6241::
    add [hl]
    ld [hl], a
    pop hl
    ld a, [hl]
    ld c, a
    bit 7, a
    jr z, jr_002_6255

    cp $a0
    jr c, jr_002_6255

    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr jr_002_6290

jr_002_6255::
    inc hl
    ld a, [hl]
    ld b, a
    bit 7, a
    jr z, jr_002_6268

    cp $80
    jr c, jr_002_6268

    dec hl
    dec hl
    dec hl
    ld a, $80
    ld [hl], a
    jr jr_002_6290

jr_002_6268::
    dec hl
    dec hl
    ld a, [$d85c]
    and $10
    jr z, jr_002_6272

    scf

jr_002_6272::
    ld a, [hl-]
    rla
    ld d, a
    ld a, [hl]
    swap a
    srl a
    or d
    ld hl, $67a5
    rst $38
    ld a, $01
    ld d, [hl]
    bit 7, d
    jr nz, jr_002_6287

    xor a

jr_002_6287::
    ldh [hSpriteFlags], a
    ld a, d
    and $7f
    ld d, a
    call jr_000_0794

jr_002_6290::
    pop hl
    ld bc, $0008
    add hl, bc
    pop bc
    dec b
    jp nz, Jump_002_6209

    ld a, [$d8dd]
    rst $00

    db $21, $63, $ec, $63

    sbc [hl]
    ld h, l
    xor b
    ld h, d

    db $58, $65

    ret


Call_002_62a9::
    ld a, [hl]
    and $01
    jr z, jr_002_62cd

    ld bc, $0005
    add hl, bc
    ld a, [hl]
    dec hl
    dec hl
    ld bc, $6835
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, [bc]
    add [hl]
    ld [hl], a
    inc hl
    inc hl
    dec [hl]
    ret nz

    ld [hl], $20
    ld bc, $fffb
    add hl, bc
    inc [hl]
    ret


jr_002_62cd::
    ld bc, $0005
    add hl, bc
    dec [hl]
    ld a, [hl]
    cp $10
    jr nz, jr_002_6316

    inc hl
    inc [hl]
    ld e, [hl]
    bit 0, e
    ret nz

    ld bc, $fffb
    add hl, bc
    call Call_002_4968
    dec a
    ld d, a
    ld a, e
    and $fc
    jr nz, jr_002_6310

jr_002_62eb::
    ld a, d
    inc a
    cp $02
    jr nz, jr_002_62f3

    ld a, $ff

jr_002_62f3::
    ld d, a
    add [hl]
    ld b, a
    push hl
    ld c, $3c
    bit 1, b
    jr nz, jr_002_62ff

    ld c, $c4

jr_002_62ff::
    inc hl
    bit 0, b
    jr nz, jr_002_6305

    inc hl

jr_002_6305::
    ld a, c
    add [hl]
    pop hl
    cp $0c
    jr c, jr_002_62eb

    cp $88
    jr nc, jr_002_62eb

jr_002_6310::
    ld a, d
    add [hl]
    and $03
    ld [hl], a
    ret


jr_002_6316::
    ld a, [hl]
    or a
    ret nz

    ld [hl], $10
    ld bc, $fffb
    add hl, bc
    dec [hl]
    ret


    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_634c

    ld a, [$d977]
    and $03
    ld hl, $67dd
    rst $20
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld a, $01
    ld [$d8dd], a
    ld a, $11
    ld [$d954], a
    ld a, $ff
    ld [$d8de], a
    ret


jr_002_634c::
    ldh a, [hJoyHeld]
    and $f0
    jr nz, jr_002_635a

    ld a, [$d802]
    inc a
    ld [$d802], a
    ret


jr_002_635a::
    ld bc, $0180
    ld a, [$d85b]
    add c
    ld [$d85b], a
    ld a, $00
    adc b
    ld c, a
    ld d, $00
    ld e, d
    ldh a, [hJoyHeld]
    ld h, a
    ld b, $ff
    bit 6, h
    jr z, jr_002_637a

    ld b, $00
    ld a, $00
    sub c
    ld e, a

jr_002_637a::
    bit 5, h
    jr z, jr_002_6384

    ld b, $01
    ld a, $00
    sub c
    ld d, a

jr_002_6384::
    bit 7, h
    jr z, jr_002_638b

    ld b, $02
    ld e, c

jr_002_638b::
    bit 4, h
    jr z, jr_002_6392

    ld b, $03
    ld d, c

jr_002_6392::
    ld a, [$d975]
    add d
    ld [$d975], a
    ld a, [$d976]
    add e
    ld [$d976], a
    ld a, [$d977]
    ld hl, $681d
    rst $38
    ld c, [hl]
    ldh a, [hJoyHeld]
    and c
    jr nz, jr_002_63c7

    ld a, b
    bit 7, a
    jr nz, jr_002_63c7

    ld [$d977], a
    and $03
    ld hl, $67d5
    rst $20
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a

jr_002_63c7::
    ld a, [$d975]
    cp $0a
    jr nc, jr_002_63d0

    ld a, $0a

jr_002_63d0::
    cp $95
    jr c, jr_002_63d6

    ld a, $95

jr_002_63d6::
    ld [$d975], a
    ld a, [$d976]
    cp $0a
    jr nc, jr_002_63e2

    ld a, $0a

jr_002_63e2::
    cp $75
    jr c, jr_002_63e8

    ld a, $75

jr_002_63e8::
    ld [$d976], a
    ret


    ld a, [$d8de]
    bit 7, a
    jr z, jr_002_6464

    ld a, [$d977]
    add a
    add a
    ld b, a
    add a
    add b
    ld hl, $67ed
    rst $38
    ld a, [$d954]
    ld bc, $0004
    cp $06
    jr nc, jr_002_640a

    add hl, bc

jr_002_640a::
    cp $0c
    jr nc, jr_002_640f

    add hl, bc

jr_002_640f::
    ld a, [$d975]
    ld b, a
    ld a, [$d976]
    ld c, a
    ld a, [hl+]
    add b
    ldh [$ffc9], a
    ld a, [hl+]
    add c
    ldh [$ffca], a
    ld a, [hl+]
    add b
    ldh [$ffcb], a
    ld a, [hl+]
    add c
    ldh [$ffcc], a
    ld b, $10
    ld hl, $d85d

jr_002_642c::
    push hl
    ld a, [hl+]
    bit 7, a
    jr nz, jr_002_645d

    inc hl
    ld c, [hl]
    ldh a, [$ffc9]
    cp c
    jr nc, jr_002_645d

    ldh a, [$ffcb]
    cp c
    jr c, jr_002_645d

    inc hl
    ld c, [hl]
    ldh a, [$ffca]
    cp c
    jr nc, jr_002_645d

    ldh a, [$ffcc]
    cp c
    jr c, jr_002_645d

    dec hl
    dec hl
    dec hl
    ld a, [hl]
    cp $04
    jr nz, jr_002_6454

    ld a, $03

jr_002_6454::
    ld [$d8de], a
    ld a, $80
    ld [hl], a
    pop hl
    jr jr_002_6464

jr_002_645d::
    pop hl
    ld a, $08
    rst $38
    dec b
    jr nz, jr_002_642c

jr_002_6464::
    ld a, [$d954]
    dec a
    ld [$d954], a
    or a
    ret nz

    xor a
    ld [$d8dd], a
    ld a, [$d8de]
    bit 7, a
    jr nz, jr_002_64c0

    ld [$d8df], a
    ld a, $44
    call PlaySound
    ld a, [$d975]
    ld [$d8e0], a
    ld a, [$d976]
    ld [$d8e1], a
    ld a, $20
    ld [$d955], a
    ld a, [$d8df]
    ld hl, $679d
    rst $20
    ld b, l
    ld c, h
    ld hl, $6728
    call Call_002_6509
    jr c, jr_002_64c0

    ld a, $04
    ld [$d8dd], a
    xor a
    ld [$d95d], a
    ld a, $90
    ld [$d954], a
    xor a
    ld [$d8e6], a
    ld [$d8ee], a
    call InitSound
    ld a, $34
    call PlaySound_Queue3
    ret


jr_002_64c0::
    ld a, [$d977]
    and $03
    ld hl, $67d5
    rst $20
    ld a, $04
    rst $38
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ret


Call_002_64d9::
    ld a, [$d955]
    or a
    ret z

    ld a, [$d955]
    dec a
    ld [$d955], a
    srl a
    ld hl, $6821
    rst $38
    ld a, [$d8e0]
    add [hl]
    ld c, a
    ld a, [$d955]
    srl a
    sub $18
    ld b, a
    ld a, [$d8e1]
    add b
    ld b, a
    ld hl, $6831
    ld a, [$d8df]
    rst $38
    ld d, [hl]
    call Call_000_0791
    ret


Call_002_6509::
    push hl
    ld hl, $d858
    ld a, c
    add [hl]
    ld [hl-], a
    dec de
    ld a, b
    add [hl]
    ld [hl+], a
    ld a, [hl]
    cp $0e
    jr c, jr_002_651e

    sub $0a
    ld [hl-], a
    inc [hl]
    inc hl

jr_002_651e::
    dec hl
    ld a, [hl]
    cp $0e
    jr c, jr_002_6528

    sub $0a
    ld [hl-], a
    inc [hl]

jr_002_6528::
    ld de, $d856
    ld hl, $9a21
    ld b, $03

jr_002_6530::
    ld a, [de]
    cp $04
    jr nz, jr_002_653a

    inc hl
    inc de
    dec b
    jr nz, jr_002_6530

jr_002_653a::
    ld c, $01
    call QueueTilemapRect
    ld a, [$d811]
    ld b, a
    add a
    add b
    pop hl
    rst $38
    ld de, $d856
    ld b, $03

jr_002_654c::
    ld a, [de]
    sub [hl]
    ret c

    jr nz, jr_002_6556

    inc de
    inc hl
    dec b
    jr nz, jr_002_654c

jr_002_6556::
    or a
    ret


    ld a, [$d954]
    cp $60
    jr nz, jr_002_657e

    ld a, [$d95d]
    or a
    jr nz, jr_002_657e

    ld hl, $794b
    ld a, [$d811]
    cp $0a
    jr nz, jr_002_6572

    ld hl, $796e

jr_002_6572::
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a

jr_002_657e::
    ld a, [$d852]
    inc a
    ld [$d852], a
    ld a, [$d954]
    dec a
    ld [$d954], a
    or a
    ret nz

    ld a, $01
    ld [$d954], a
    ldh a, [hJoyHeld]
    bit 0, a
    ret z

    ld hl, $dffa
    jp Jump_002_49cc


    ld a, [$d954]
    dec a
    ld [$d954], a
    or a
    ret nz

    xor a
    ld [$d8dd], a
    ld a, $c0
    ld [$d956], a
    jp jr_002_64c0


Call_002_65b3::
    ld hl, $d8e2
    ld de, $67cd
    ld a, [$d811]
    cp $04
    call nc, Call_002_65d0
    ld hl, $d8ea
    ld de, $67d1
    ld a, [$d811]
    cp $07
    call nc, Call_002_65d0
    ret


Call_002_65d0::
    ld a, [hl+]
    or a
    jp nz, Jump_002_66d7

    push de
    ld c, $00
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [$d975]
    add $08
    sub b
    jr nc, jr_002_65e8

    cpl
    inc a
    set 0, c

jr_002_65e8::
    ldh [$ffc9], a
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [$d976]
    add $08
    sub b
    jr nc, jr_002_65fa

    cpl
    inc a
    set 1, c

jr_002_65fa::
    ldh [$ffca], a
    push hl
    inc hl
    ld a, [hl]
    or a
    jr z, jr_002_660d

    dec a
    ld [hl+], a
    ldh a, [$ffc9]
    ld [hl+], a
    ldh a, [$ffca]
    ld [hl+], a
    ld [hl], c
    jr jr_002_6615

jr_002_660d::
    inc hl
    ld a, [hl+]
    ldh [$ffc9], a
    ld a, [hl+]
    ldh [$ffca], a
    ld c, [hl]

jr_002_6615::
    pop hl
    ldh a, [$ffc9]
    ld b, a
    ldh a, [$ffca]
    cp b
    jr c, jr_002_6628

    ld b, $00
    bit 1, c
    jr nz, jr_002_6630

    ld b, $02
    jr jr_002_6630

jr_002_6628::
    ld b, $01
    bit 0, c
    jr nz, jr_002_6630

    ld b, $03

jr_002_6630::
    ld a, b
    cp $01
    jr z, jr_002_6636

    xor a

jr_002_6636::
    ldh [hSpriteFlags], a
    pop de
    ld a, b
    rst $30
    ld a, [de]
    ldh [$ffcb], a
    ld d, $00
    ld e, d
    ld a, [hl]
    ld b, a
    ldh a, [$ffca]
    cp b
    jr c, jr_002_6656

    ldh a, [$ffc9]
    add b
    ld [hl], a
    ld e, $01
    bit 1, c
    jr z, jr_002_6664

    ld e, $ff
    jr jr_002_6664

jr_002_6656::
    ldh a, [$ffca]
    ld b, a
    ld a, [hl]
    sub b
    ld [hl], a
    ld d, $01
    bit 0, c
    jr z, jr_002_6664

    ld d, $ff

jr_002_6664::
    dec hl
    ld a, [hl]
    add e
    ld b, a
    ld [hl-], a
    ld a, [hl]
    add d
    ld c, a
    ld [hl-], a
    push bc
    ld a, c
    add $08
    cp $f0
    jr nc, jr_002_667c

    ld a, b
    add $08
    cp $f0
    jr c, jr_002_6685

jr_002_667c::
    call Call_002_495b
    and $03
    add $03
    ld [hl+], a
    ld [hl-], a

jr_002_6685::
    pop bc
    push bc
    ld a, [$d975]
    add $0e
    sub c
    cp $1c
    jr nc, jr_002_66c7

    ld a, [$d976]
    add $0e
    sub b
    cp $1c
    jr nc, jr_002_66c7

    ld bc, $0004
    add hl, bc
    xor a
    ld [hl], a
    ld a, [$d8dd]
    cp $02
    jr nc, jr_002_66c7

    ld a, [$d956]
    or a
    jr nz, jr_002_66c7

    ld hl, $7967
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld a, $c0
    ld [$d954], a
    ld a, $02
    ld [$d8dd], a

jr_002_66c7::
    pop bc
    ldh a, [$ffcb]
    ld d, a
    ld a, [$d957]
    bit 3, a
    jr nz, jr_002_66d3

    inc d

jr_002_66d3::
    call jr_000_0794
    ret


Jump_002_66d7::
    ld a, [$d8f2]
    ld b, a
    call Call_002_4968
    add [hl]
    cp b
    jr z, jr_002_66e3

    inc b

jr_002_66e3::
    cp $0c
    jr c, jr_002_66e9

    sub $0c

jr_002_66e9::
    ld [hl], a
    ld a, [$d852]
    cp $01
    ret nz

    dec hl
    dec [hl]
    ret nz

    xor a
    ld [hl+], a
    ld a, [hl]
    add a
    ld de, $6856
    rst $30
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $80
    ld [hl+], a
    ret


    db $85, $86, $87, $91, $91, $91, $91, $91, $80, $81, $91, $91, $91, $91, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

    inc b
    inc b
    inc b

    db $04, $0c, $04, $05, $05, $04

    dec b
    ld [$0504], sp
    dec bc
    inc b
    ld b, $04
    inc b
    ld b, $07
    inc b
    ld b, $0a
    inc b
    ld b, $0d
    inc b
    rlca
    ld b, $04
    rlca
    add hl, bc
    inc b

    db $4b, $98, $64, $14, $a2, $98, $1c, $2c, $2f, $99, $84, $4c, $c5, $99, $34, $74
    db $88, $89, $8a, $8b, $8c, $8d, $01, $02, $03, $02, $03, $00, $00, $01, $02, $00
    db $03, $01, $04, $02, $01, $01, $04, $02, $01, $01

    inc bc
    ld [bc], a
    ld [bc], a
    ld bc, $0203
    ld [bc], a
    ld bc, $0302
    ld [bc], a
    ld bc, $0302
    ld [bc], a
    ld bc, $0202
    inc bc
    ld bc, $0202
    inc bc
    ld bc, $0201
    inc bc
    ld [bc], a
    ld bc, $0202
    inc bc

    db $60, $00, $b0, $00, $00, $01, $e0, $01, $00, $00, $00, $05, $01, $00, $01, $05
    db $02, $00, $33, $4f, $34, $b4, $33, $4f, $34, $b4

    ld d, b
    ld d, c

    db $b7, $b8, $35, $36, $37, $38, $4c, $cc

    xor l
    xor [hl]

    db $2c, $ac, $2d, $2e, $ce, $ce, $b2, $b2, $30, $30

    ld [hl-], a
    ld [hl-], a

    db $cd, $cd, $b1, $b1, $2f, $2f

    db $31

    db $31

    ld b, d
    ld b, b
    ld a, $40
    ld c, d
    ld c, b
    ld b, [hl]
    ld c, b

    db $3d, $79, $2f, $79, $13, $79, $21, $79, $44, $79, $36, $79, $1a, $79, $28, $79

    nop
    xor $ee
    nop
    nop
    ld [de], a
    ld [de], a
    nop

    db $f6, $0c, $0a, $1e, $f6, $f4, $0a, $0c, $f6, $e0, $0a, $f4, $00, $dc, $14, $f0
    db $e4, $e8, $00, $fd, $e4, $fd, $f8, $08, $f6, $dd, $0a, $f4, $f6, $f4, $0a, $0c
    db $f6, $0c, $0a, $1b, $ec, $dc, $00, $f0, $00, $e8, $1c, $fd, $08, $fd, $1c, $08
    db $40, $20, $80, $10, $03, $02, $02, $01, $00, $ff, $fe, $fe, $fe, $fe, $fe, $ff
    db $00, $01, $02, $02, $3c, $3b, $3a, $3d

    nop

    db $03, $03, $02, $03, $02, $01, $01, $00, $00, $ff, $ff, $fe, $fd, $fe, $fd, $fd
    db $00, $20, $48, $00, $00, $01, $00, $01, $00, $80, $48, $00, $00, $01, $00, $00

    ld hl, sp+$74
    ld hl, sp+$48
    ld hl, sp+$1c
    inc e
    ld hl, sp+$48
    ld hl, sp+$74
    ld hl, sp-$58
    inc e
    xor b
    ld c, b
    xor b
    ld [hl], h
    ld [hl], h
    xor b
    ld c, b
    xor b
    inc e
    xor b

    xor a
    ldh [hNeedsReset], a
    ld a, $83
    ld [wLCDCShadow], a
    ld a, $a0
    ldh [hOamMaxY], a
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, [$d93d]
    rst $00

    db $8b, $68

    db $21
    ld l, d

    db $67, $69, $f8, $6c

    call InitSound
    ld a, $14
    call PlaySound_Queue3
    ld a, [$dff8]
    or a
    jr z, jr_002_68ae

    call DelayFramesOrCycles
    ld hl, $6947
    call Call_000_03c8
    call DelayFramesOrCycles
    call Call_000_0709
    xor a
    ldh [rBGP], a
    call DisableLCD

jr_002_68ae::
    ld a, $83
    ld [wLCDCShadow], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, $06
    ld hl, $50c4
    ld de, $8800
    ld bc, $0200
    call BankedMemcpy
    ld a, $06
    ld hl, $6156
    ld de, $8a00
    call LoadMaskedGfx
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    xor a
    ldh [$ffc9], a
    call Call_002_4295
    ld a, $8f
    ldh [$ffc9], a
    ld hl, $9823
    ld bc, $0c04
    call Call_000_08b7
    ld de, $6a13
    ld hl, $9964
    call Call_002_49f5
    xor a
    ld [$d954], a
    ld [$d955], a
    ld a, $82
    ld [$d970], a
    ld a, [$dffe]
    ld b, a
    ld a, [$d979]
    add b
    inc a
    ld [$d971], a
    ld a, $33
    call Call_000_0710
    ld a, $02
    ld [$d970], a
    ld a, [$d979]
    add $15
    call Call_000_0710
    ld a, $05
    ld [$d933], a
    ld a, [$dff8]
    or a
    ret z

    call ApplyLCDC
    call DelayFramesOrCycles
    call DisableLCD
    ld hl, $6957
    call Call_000_03c8
    call DelayFramesOrCycles
    ret


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

    ld a, $06
    ld hl, $762c
    ld de, $c800
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $1412
    call jr_000_05f7
    call InitSound
    ld a, $20
    call PlaySound_Queue3
    ld a, $81
    ld [$d970], a
    ld a, [$d979]
    add $1c
    call Call_000_0710
    ld a, $08
    ld [$d981], a
    ld a, $06
    ld [$d933], a
    ret


    ld a, [$d93d]
    rst $00

    db $ec, $69

    push bc
    ld l, d

    db $ad, $69, $b4, $6d

    ld bc, $1838
    ld d, $b1
    call Call_000_0791
    call Call_000_0719
    ldh a, [hJoyPressed]
    bit 3, a
    jp nz, Jump_002_705e

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_69ca

    ld a, $02
    ld [$d981], a

jr_002_69ca::
    ld a, [$d96d]
    or a
    ret nz

    ld hl, $99d0
    ld a, [$d954]
    inc a
    ld [$d954], a
    bit 4, a
    ld a, $00
    jr z, jr_002_69e1

    ld a, $81

jr_002_69e1::
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    bit 0, a
    ret z

    jp Jump_002_4301


    ld bc, $9080
    ld d, $b2
    call Call_000_0791
    ld a, [$d955]
    inc a
    ld [$d955], a
    cp $ff
    jr z, jr_002_6a04

    ldh a, [hJoyPressed]
    bit 0, a
    ret z

jr_002_6a04::
    xor a
    ld [$d96d], a
    ld [wVramQueue], a
    ld a, $02
    ld [$d93d], a
    ldh [hNeedsReset], a
    ret


    ld c, $00
    rst $18
    nop
    rst $38
    nop
    ccf
    nop
    ld a, $00
    ld a, $00
    ld e, $00
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $07
    ld [$d933], a
    ld a, $06
    ld hl, $641e
    ld de, $8000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $663c
    ld de, $8800
    call LoadMaskedGfx
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $6801
    ld de, $c800
    ld bc, $0168
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $1412
    call jr_000_05f7
    call InitSound
    ld a, $10
    call PlaySound_Queue3
    ld a, [$d97a]
    or a
    jr z, jr_002_6a90

    ld a, $02
    ld [$d970], a
    ld a, $69
    call Call_000_0710
    ld a, $02
    ld [$d970], a
    ld a, $6a
    call Call_000_0710

jr_002_6a90::
    ld a, [$d97a]
    ld [$d971], a
    ld a, $02
    ld [$d970], a
    ld a, $19
    call Call_000_0710
    ld hl, $7989
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d93c], a
    ld [$d93f], a
    ld [$d955], a
    ld [$d956], a
    cpl
    ld [$d93b], a
    ld a, $50
    ld [$d93a], a
    ret


    ld a, [$d955]
    inc a
    ld [$d955], a
    and $0f
    jr nz, jr_002_6b07

    ld a, [$dff8]
    or a
    jr z, jr_002_6b07

    ld hl, $d985
    ld de, $6cd8
    ld b, $10

jr_002_6ade::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_002_6ade

    ld a, [$d955]
    swap a
    and $03
    add a
    add a
    ld hl, $6ce8
    rst $38
    ld a, [hl+]
    ld [$d988], a
    ld a, [hl+]
    ld [$d989], a
    ld a, [hl+]
    ld [$d98a], a
    ld a, [hl+]
    ld [$d98b], a
    ld hl, $d985
    call Call_000_03c8

jr_002_6b07::
    ld a, [$d93a]
    ld c, a
    ld b, $58
    ld de, $d800
    call Call_000_0720
    call Call_000_0719
    ld a, [$d93f]
    rst $00
    jr nz, @+$6d

    inc d
    ld l, h
    ld l, l
    ld l, h
    ld a, [$d97a]
    or a
    jr nz, jr_002_6b34

    ld a, [$d956]
    inc a
    ld [$d956], a
    cp $a0
    jr z, jr_002_6b95

    jp Jump_002_6be7


jr_002_6b34::
    ldh a, [hJoyPressed]
    and $09
    jr z, jr_002_6bb2

    ld a, [$d93c]
    bit 0, a
    jr nz, jr_002_6b95

    ld a, $01
    ld [$d93f], a
    ld hl, $7998
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld hl, $00e0
    ld a, l
    ld [$d967], a
    ld a, h
    ld [$d968], a
    ld hl, $6ccd
    ld a, [hl+]
    ld [$d954], a
    ld a, l
    ld [$d97d], a
    ld a, h
    ld [$d97e], a
    ld a, [$d97a]
    dec a
    ld [$d97a], a
    ld [$d971], a
    xor a
    ld [$d970], a
    ld a, $19
    call Call_000_0710

Jump_002_6b82::
    ld bc, $98c7
    ld de, $0006
    call QueueVramFill
    ld bc, $98e7
    ld de, $0006
    call QueueVramFill
    ret


jr_002_6b95::
    ld a, $02
    ld [$d93f], a
    xor a
    ld [$d805], a
    ld [$d97c], a
    ld a, $b0
    ld [$d97b], a
    ld hl, $79ae
    ld a, l
    ld [$d803], a
    ld a, h
    ld [$d804], a
    ret


jr_002_6bb2::
    ld a, [$d93c]
    ld hl, $9987
    bit 0, a
    jr z, jr_002_6bbf

    ld hl, $99c7

jr_002_6bbf::
    xor a
    call QueueTilemapByte
    ldh a, [hJoyPressed]
    and $c4
    jr z, jr_002_6bd5

    ld a, [$d93c]
    cpl
    ld [$d93c], a
    ld a, $40
    call PlaySound

jr_002_6bd5::
    ld a, [$d93c]
    ld hl, $9987
    bit 0, a
    jr z, jr_002_6be2

    ld hl, $99c7

jr_002_6be2::
    ld a, $0e
    call QueueTilemapByte

Jump_002_6be7::
    ld a, [$d93b]
    and $80
    ld b, a
    ld a, [$d802]
    and $80
    cp b
    jr z, jr_002_6c13

    xor a
    ld [$d970], a
    ld a, [$d802]
    ld [$d93b], a
    bit 7, a
    ld a, $1a
    jr z, jr_002_6c07

    ld a, $1b

jr_002_6c07::
    call Call_000_0710
    ld bc, $98c7
    ld de, $0006
    call QueueVramFill

jr_002_6c13::
    ret


    ld hl, $d97d
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$d967]
    ld c, a
    ld a, [$d968]
    ld b, a
    ld e, [hl]
    ld d, $00
    bit 7, e
    jr z, jr_002_6c2b

    ld d, $ff

jr_002_6c2b::
    ld a, c
    add e
    ld c, a
    ld a, b
    adc d
    ld b, a
    ld a, c
    ld [$d967], a
    ld a, b
    ld [$d968], a
    call Call_002_6c5e
    ld a, [$d954]
    dec a
    ld [$d954], a
    or a
    ret nz

    inc hl
    ld a, [hl+]
    ld [$d954], a
    cp $ff
    jr z, jr_002_6c57

    ld a, l
    ld [$d97d], a
    ld a, h
    ld [$d97e], a
    ret


jr_002_6c57::
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


Call_002_6c5e::
    ld a, [$d93b]
    add c
    ld [$d93b], a
    ld a, [$d93a]
    adc b
    ld [$d93a], a
    ret


    ld a, [$d97b]
    and $1f
    cp $01
    jr nz, jr_002_6c7b

    ld a, $5b
    call PlaySound

jr_002_6c7b::
    ld bc, $ff20
    ld a, [$d97c]
    add c
    ld [$d97c], a
    ld a, [$d97b]
    or a
    jr z, @+$2d

    adc b
    ld [$d97b], a
    ld a, [$d97b]
    ld c, a
    ld b, $58
    ld de, $d803
    call Call_000_0720
    ld a, [$d97b]
    cp $40
    jr nz, jr_002_6cb4

    ld hl, $79a3
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    jp Jump_002_6b82


jr_002_6cb4::
    jp nc, Jump_002_6be7

    ld bc, $ff20
    call Call_002_6c5e
    ld a, [$d93a]
    cp $b0
    ret nz

    ld bc, $0001
    ld de, $0001
    jp RequestStateChange_Menu


    ret


    jr nc, jr_002_6ccf

jr_002_6ccf::
    ld a, [de]
    ldh a, [$ff30]
    nop
    ld a, [hl+]
    db $10
    ld b, a
    nop
    rst $38
    ld bc, $77bd
    pop af
    ld a, d
    adc d
    ld c, l
    nop
    nop
    ccf
    inc sp
    db $d3
    ld [hl], $00
    nop
    nop
    pop af
    ld a, d
    ld c, l
    adc d
    cp a
    ld e, d
    ccf
    ld bc, $4ff3
    and c
    ld hl, $5abf
    ccf
    db $01

    ld a, $83
    ld [wLCDCShadow], a
    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [$d954], a
    ld [$d955], a
    ld [$d956], a
    ld a, [$d979]
    bit 0, a
    jr z, jr_002_6d1b

    call InitSound
    ld a, $20
    call PlaySound_Queue3

jr_002_6d1b::
    ld a, $06
    ld hl, Call_002_7700
    ld de, $8000
    call LoadMaskedGfx
    ld hl, $71ef
    ld a, [$d979]
    srl a
    rst $20
    ld de, $8600
    ld a, $06
    call LoadMaskedGfx
    ld a, $06
    ld hl, $50c4
    ld de, $8e00
    ld bc, $0200
    call BankedMemcpy
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    ld a, $60
    ldh [$ffc9], a
    call Call_002_4295
    ld a, $ef
    ldh [$ffc9], a
    ld hl, $9821
    ld bc, $1007
    call Call_000_08b7
    ld a, [$d979]
    ld c, $0e
    call Call_000_05b4
    ld bc, $729c
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $9962
    call Call_002_49f5
    ld a, [$d979]
    ld hl, $70bf
    rst $20
    ld a, l
    ld [$d80c], a
    ld a, h
    ld [$d80d], a
    ld a, $ff
    ld [$d80e], a
    ld [$d80f], a
    ld [$d810], a
    xor a
    ldh [$ffcb], a
    call Jump_002_6f1e
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, [$d979]
    srl a
    jr nc, jr_002_6dae

    add $08

jr_002_6dae::
    add $08
    ld [$d933], a
    ret


    call Call_002_6ead
    ld a, [$d979]
    cp $07
    jr z, jr_002_6dc5

    ldh a, [hJoyPressed]
    bit 3, a
    jp nz, Jump_002_7066

jr_002_6dc5::
    ld de, $d80e
    ld b, $03

jr_002_6dca::
    push bc
    ld a, b
    dec a
    ld hl, $71d6
    rst $38
    ld c, [hl]
    ld a, [de]
    inc de
    push de
    cp $40
    jr c, jr_002_6de5

    cp $7f
    jr z, jr_002_6df9

    ld d, a
    ld b, $88
    call Call_000_0791
    jr jr_002_6df9

jr_002_6de5::
    ld de, $d800
    ld a, b
    sla a
    add b
    sub $03
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld b, $88
    call Call_000_0720

jr_002_6df9::
    pop de
    pop bc
    dec b
    jr nz, jr_002_6dca

    ld a, [$d955]
    cp $ff
    jr nz, jr_002_6e11

    call InitSound
    ld a, $18
    call PlaySound_Queue3
    xor a
    ld [$d955], a

jr_002_6e11::
    ld a, [$d955]
    cp $30
    jr nz, jr_002_6e1d

    ld a, $49
    call PlaySound_Queue1

jr_002_6e1d::
    ld a, [$d955]
    or a
    jr z, jr_002_6e38

    ld a, [$d955]
    bit 3, a
    ld a, $e4
    jr z, jr_002_6e2d

    cpl

jr_002_6e2d::
    ld [wPaletteBGP], a
    ld a, [$d955]
    dec a
    ld [$d955], a
    ret


jr_002_6e38::
    call Call_000_0719
    ld hl, $9911
    ld a, [$d954]
    bit 4, a
    ld a, $00
    jr z, jr_002_6e49

    ld a, $e1

jr_002_6e49::
    call QueueTilemapByte
    ld a, [$d979]
    cp $07
    jr z, jr_002_6e5e

    ldh a, [hJoyPressed]
    bit 0, a
    jr z, jr_002_6e5e

    ld a, $02
    ld [$d981], a

jr_002_6e5e::
    ld a, [$d96d]
    or a
    ret nz

    ld a, [$d954]
    inc a
    ld [$d954], a
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, jr_002_6e75

    ld a, [$d93c]
    or a
    ret z

jr_002_6e75::
    ld a, [$d93c]
    inc a
    ld [$d93c], a
    ldh [$ffcb], a
    cp $05
    jp z, Jump_002_6f1e

    jr c, jr_002_6e86

    ret


jr_002_6e86::
    dec a
    add a
    ld h, a
    ld l, $02

jr_002_6e8b::
    ld bc, $9822
    ld de, $e210
    ld a, h
    or a
    jr z, jr_002_6e97

    ld d, $00

jr_002_6e97::
    swap a
    and $f0
    add a
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    push hl
    call QueueVramFill
    pop hl
    inc h
    dec l
    jr nz, jr_002_6e8b

    xor a
    ret


Call_002_6ead::
    ld a, [$dff8]
    or a
    ret z

    ld a, [$d956]
    or a
    ret nz

    ld a, [$d979]
    cp $07
    jr nz, jr_002_6ee5

    ld a, [$d80e]
    cp $7f
    jr z, jr_002_6ee5

    ld hl, $727c
    call Call_000_03c8
    ld hl, $724f
    call Call_000_04eb
    ld b, $0d

jr_002_6ed3::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_6ed3

    ldh a, [hVramQueuePos]
    add $0c
    ldh [hVramQueuePos], a
    ld a, $01
    ld [$d956], a
    ret


jr_002_6ee5::
    ld hl, $720c
    ld a, [$d979]
    rst $38
    ld a, [hl]
    bit 7, a
    ret nz

    ld b, a
    ld hl, $d80e
    rst $38
    ld a, [hl]
    cp $7f
    ret nz

    ld a, b
    push af
    ld hl, $721d
    rst $20
    call Call_000_03c8
    pop af
    ld hl, $7217
    rst $20
    call Call_000_04eb
    ldh a, [hVramQueuePos]
    ld b, a

jr_002_6f0d::
    ld a, [hl+]
    ld [de], a
    inc de
    inc b
    or a
    jr nz, jr_002_6f0d

    dec b
    ld a, b
    ldh [hVramQueuePos], a
    ld a, $01
    ld [$d956], a
    ret


Jump_002_6f1e::
    xor a
    ld [$d93c], a
    ld [$d954], a
    ld a, $08
    ld [$d981], a
    ld hl, $d80c
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$d979]
    srl a
    inc a
    ld d, a
    ld a, [$dffe]
    add d
    ld [$d971], a
    ld a, $e1
    ld [$d970], a
    ld a, [hl+]
    cp $ff
    jp z, Jump_002_7066

    ld b, a
    push hl
    cp $29
    jr nz, jr_002_6fa2

    ld a, [$dffd]
    or a
    jr z, jr_002_6f57

    ld b, $3c

jr_002_6f57::
    ld a, $e0
    ld [$d970], a
    ld hl, $46f1
    ld a, [$d979]
    srl a
    inc a
    ld d, a
    ld a, [$dffe]
    add d
    ld d, a
    ld a, [$dffd]
    or a
    ld a, $00
    jr z, jr_002_6f75

    ld a, $04

jr_002_6f75::
    add d
    ld de, $0014

jr_002_6f79::
    add hl, de
    dec a
    jr nz, jr_002_6f79

    push bc
    ld e, l
    ld d, h
    ld hl, $46f9
    ld a, [$d979]
    srl a
    rst $38
    ld b, [hl]
    inc b
    srl b
    ld hl, $98ca
    ld a, l
    sub b
    ld l, a
    ld bc, $0a02
    call QueueTilemapRect
    call InitSound
    ld a, $64
    call PlaySound_Queue3
    pop bc

jr_002_6fa2::
    ld a, b
    call Call_000_0710
    pop hl
    ld a, [hl+]
    ldh [$ffca], a
    ld b, $03
    ld de, $d80e

jr_002_6faf::
    ld a, [de]
    ld c, a
    ld a, [hl+]
    cp c
    jr z, jr_002_6fd9

    ld [de], a
    cp $40
    jr nc, jr_002_6fd9

    push hl
    push de
    ld hl, $71d9
    rst $20
    ld a, b
    sla a
    add b
    sub $03
    ld de, $d800
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    inc de
    xor a
    ld [de], a
    pop de
    pop hl

jr_002_6fd9::
    inc de
    dec b
    jr nz, jr_002_6faf

    ld a, [hl]
    cp $fe
    jr nz, jr_002_6fef

    inc hl
    ld a, [hl+]
    ld [$d974], a
    ld a, [hl+]
    ld [$d972], a
    ld a, [hl+]
    ld [$d973], a

jr_002_6fef::
    ld a, l
    ld [$d80c], a
    ld a, h
    ld [$d80d], a
    ld a, [$dff8]
    or a
    jr z, jr_002_7026

    ld hl, $728c
    ld de, $d985
    ld b, $10

jr_002_7005::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_7005

    ldh a, [$ffca]
    ld b, a
    add a
    add b
    ld hl, $71f7
    rst $38
    ld a, [hl+]
    ld [$d98c], a
    ld a, [hl+]
    ld [$d98d], a
    ld a, [hl+]
    ld [$d98e], a
    ld hl, $d985
    call Call_000_03c8

jr_002_7026::
    ld b, $03
    ld hl, $9924
    ldh a, [$ffca]
    ld c, a

jr_002_702e::
    ld de, $71ce
    rr c
    jr c, jr_002_703d

    ld a, b
    add a
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a

jr_002_703d::
    push bc
    push hl
    ld bc, $0102
    ldh a, [$ffcb]
    or a
    call z, jr_000_05f7
    ldh a, [$ffcb]
    or a
    call nz, QueueTilemapRect
    pop hl
    pop bc
    ld de, $0006
    add hl, de
    ld a, b
    cp $02
    jr nz, jr_002_705a

    dec hl

jr_002_705a::
    dec b
    jr nz, jr_002_702e

    ret


Jump_002_705e::
    ld a, [$d979]
    sla a
    ld [$d979], a

Jump_002_7066::
    xor a
    ld [$d96d], a
    ld [wVramQueue], a
    ld a, [$d95f]
    cp $04
    jp z, Jump_002_4301

    ld a, [$d979]
    bit 0, a
    jr nz, jr_002_709c

    srl a
    ldh [$ff9f], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld a, [$d979]
    inc a
    ld [$d979], a
    cp $01
    ret nz

    ldh a, [hJoyHeld]
    and $08
    ret nz

    ld a, $08
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


jr_002_709c::
    inc a
    ld [$d979], a
    cp $08
    jr z, jr_002_70ad

    ld e, a
    ld d, $08
    ld bc, $0100
    jp RequestStateChange_Menu


jr_002_70ad::
    ld b, $09
    ld a, [$dffe]
    ld c, $00
    or a
    jr z, jr_002_70b9

    ld c, $01

jr_002_70b9::
    ld de, $0400
    jp RequestStateChange_Menu


    rst $08
    ld [hl], b

    db $ec, $70, $0b, $71, $32, $71, $47, $71, $5c, $71, $7a, $71, $a2, $71

    jr nz, @+$06

    nop
    ld a, a
    sub c
    ld hl, $0001
    ld a, a
    sub c
    ld [hl+], a
    inc b
    nop
    ld a, a
    sub c
    cp $7f
    db $10
    ret c

    inc hl
    ld bc, $7f80
    ld a, a
    cp $7b
    ld c, $d8
    rst $38

    db $24, $04, $7b, $7f, $91, $25, $01, $03, $7f, $92, $26, $01, $04, $7f, $92, $27
    db $04, $04, $7f, $92, $28, $01, $05, $7f, $92, $29, $00, $05, $7f, $92, $ff, $2a
    db $04, $7b, $7f, $93, $2b, $01, $7b, $7f, $93, $2c, $04, $7b, $7f, $93, $2d, $01
    db $02, $7f, $93, $2e, $04, $02, $7f, $93, $fe, $7f, $10, $d8, $2f, $01, $02, $7f
    db $7f, $fe, $7b, $0e, $d8, $ff, $30, $04, $7b, $7f, $09, $31, $04, $7b, $7f, $09
    db $32, $01, $7b, $7f, $09, $29, $00, $7b, $7f, $09, $ff, $34, $04, $7b, $7f, $96
    db $35, $01, $01, $7f, $96, $36, $04, $01, $7f, $96, $37, $01, $7b, $7f, $96, $ff
    db $38, $01, $80, $7f, $99, $39, $04, $80, $7f, $99, $fe, $30, $55, $d9, $3a, $04
    db $80, $7f, $99, $3b, $05, $06, $7f, $0a, $29, $00, $06, $7f, $0a, $ff, $3d, $01
    db $07, $9a, $9b, $3e, $04, $07, $9a, $9b, $3f, $01, $7b, $9a, $9b, $40, $02, $7b
    db $9a, $9b, $41, $01, $08, $9a, $9b, $fe, $7f, $0e, $d8, $42, $04, $7f, $9a, $9b
    db $43, $02, $7f, $9a, $9b, $ff, $44, $02, $7f, $9a, $9b, $fe, $7b, $0e, $d8, $45
    db $01, $7b, $9a, $9b, $46, $02, $7b, $9a, $9b, $47, $04, $7b, $9a, $9b, $48, $04
    db $7b, $9a, $9b, $fe, $ff, $55, $d9, $49, $01, $7b, $9a, $9b, $4a, $02, $7b, $9a
    db $9b, $ff, $ff, $e0, $e5, $fd, $e5, $f0, $e5, $f0, $7c, $54, $24

    push hl
    ld a, c

    db $ec, $79, $f3, $79, $fa, $79, $01, $7a, $08, $7a, $0f, $7a, $16, $7a, $1f, $7a
    db $28, $7a, $2f, $7a, $71, $7a, $22, $7b, $0e, $7c, $13, $7e

    nop
    nop
    nop
    ret nz

    nop
    nop
    nop
    inc c
    nop
    ret nz

    inc c
    nop
    nop
    nop
    inc bc
    ret nz

    nop
    inc bc
    nop
    inc c
    inc bc
    ld [bc], a
    rst $38
    ld [bc], a
    rst $38
    rst $38
    rst $38
    nop
    rst $38
    ret nz

    inc c
    inc bc
    inc hl
    ld [hl], d
    ld [hl], $72
    ld [hl], $72
    ld e, h
    ld [hl], d
    ld l, h
    ld [hl], d
    ld l, h
    ld [hl], d
    sbc c
    jp nz, $ef04

    pop af
    ldh a, [c]
    ld sp, hl
    sbc c
    db $e3
    inc bc
    push af
    or $f7
    sbc d
    inc bc
    ld [bc], a
    di
    db $f4
    nop
    sbc c
    xor [hl]
    inc bc
    db $fd
    ldh a, [$fff3]
    sbc c
    adc $03
    rst $28
    pop af
    ldh a, [c]
    sbc c
    xor $03
    xor $f5
    or $9a
    ld c, $03
    ldh a, [$fff3]
    db $f4
    nop
    sbc c
    jp Jump_000_0043


    sbc c
    db $e3
    ld b, e
    nop
    sbc d
    inc bc
    ld b, e
    nop
    nop
    ld hl, $0302
    nop
    ld [bc], a
    ld c, $05
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld hl, $0302
    nop
    ld c, $0d
    db $10
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld hl, $0302
    ld a, [bc]
    inc bc
    ld c, $05
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add hl, sp
    nop
    ld a, [bc]
    stop
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
    ld b, $00
    ld c, $78
    ld c, $70
    inc b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, $00
    ld c, $78
    ld c, $70
    inc b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, $00
    ld c, $70
    ld c, $70
    inc b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    ld [hl], b
    ld c, $70
    ld c, $70
    nop
    nop
    inc c
    nop
    inc c
    nop
    inc c
    nop
    ld c, $70
    inc c
    ld [hl], b
    ld c, $70
    nop
    nop
    ld c, $00
    ld c, $00
    ld c, $00
    ld c, $70
    ld c, $70
    nop
    ld [hl], b
    nop
    nop
    add h
    ld bc, $018e
    adc $01
    adc [hl]
    pop af
    adc [hl]
    ld [hl], c
    adc [hl]
    ld [hl], c
    nop
    nop
    add h
    ld bc, $018e
    adc $01
    adc [hl]
    ld bc, $018e
    adc [hl]
    ld bc, $0000

    ld a, $01
    ldh [rIE], a
    xor a
    ldh [hNeedsReset], a
    ld [wVramQueue], a
    ld [$d93d], a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $a0
    ldh [hOamMaxY], a
    call InitSound
    ld a, $3c
    call PlaySound_Queue3
    ld a, [$d8f3]
    and $01
    rst $00

    db $33, $73

    db $ec
    ld [hl], e

    ld a, $e3
    ld [wLCDCShadow], a
    ld a, $e4
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld a, $d0
    ld [wPaletteOBP0], a
    ld a, $07
    ldh [hWX], a
    ld a, $50
    ldh [hWY], a
    xor a
    ld [$d8fc], a
    ld a, $31
    ld [$d954], a
    ld a, $06
    ld hl, $7099
    ld de, $8000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $7581
    ld de, $8900
    call LoadMaskedGfx
    ld a, $06
    ld hl, $50c4
    ld de, $8800
    ld bc, $0100
    call BankedMemcpy
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    ld a, $06
    ld hl, $75fe
    ld de, $c800
    ld bc, $00a0
    call BankedMemcpy_RLEFF
    ld de, $c800
    ld hl, $9800
    ld bc, $100a
    call Call_000_0651
    ld de, $c800
    ld hl, $9810
    ld bc, $100a
    call Call_000_0651
    ld a, $8f
    ldh [$ffc9], a
    ld hl, $9c00
    ld bc, $1206
    call Call_000_08b7
    ld a, $19
    ld [$d933], a
    ld a, $4d
    ld [$d939], a
    ld de, $d8f4
    ld hl, $77f1
    ld b, $04

jr_002_73ca::
    ld a, [hl+]
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_73ca

    ld hl, $d800
    ld de, $77f5
    ld b, $04

jr_002_73db::
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    xor a
    ld [hl+], a
    dec b
    jr nz, jr_002_73db

    ld a, $ff
    ld [$d95c], a
    ret


    ld a, $83
    ld [wLCDCShadow], a
    ld a, $e1
    ld [wPaletteBGP], a
    ldh [rBGP], a
    ld a, $e0
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, $0f
    ld [$d933], a
    xor a
    ld [$d955], a
    ld [$d956], a
    ld a, $02
    ld hl, $7b8e
    ld de, $8000
    call LoadMaskedGfx
    ld a, $02
    ld hl, $7fe0
    ld de, $8800
    call LoadMaskedGfx
    ld a, $06
    ld hl, $4bc0
    ld de, $9000
    call LoadMaskedGfx
    ld hl, $9800
    ld b, $20

jr_002_7432::
    ld c, $14
    ld de, $7875

jr_002_7437::
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, jr_002_7437

    ld de, $000c
    add hl, de
    dec b
    jr nz, jr_002_7432

    ld hl, $9040
    ld b, $7c
    ld a, $ff

jr_002_744b::
    ld c, $08

jr_002_744d::
    ld [hl+], a
    inc hl
    dec c
    jr nz, jr_002_744d

    dec b
    jr nz, jr_002_744b

    ld b, $08
    ld hl, $d915
    ld de, $7889

jr_002_745d::
    ld a, $f0
    ld [hl+], a
    ld [hl+], a
    inc de
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_002_745d

    xor a
    ld [$d970], a
    ld [$d93d], a
    inc a
    ld [$d974], a
    ld hl, $d93d
    ld a, l
    ld [$d972], a
    ld a, h
    ld [$d973], a
    ld a, $67
    call Call_000_0710
    ld hl, $7b5a
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld hl, $7b85
    ld a, l
    ld [$d803], a
    ld a, h
    ld [$d804], a
    xor a
    ld [$d805], a
    ld a, $40
    ld [$d95c], a
    ret


    ld a, [$d8f3]
    and $01
    rst $00

    db $b2, $74

    ld l, c
    halt

    ld a, [$d955]
    inc a
    ld [$d955], a
    ld hl, $d8f4
    ld de, $d800

jr_002_74bf::
    ld b, $48
    ld c, [hl]
    inc hl
    push hl
    push de
    call Call_000_0720
    pop de
    pop hl
    ld [hl+], a
    inc de
    inc de
    inc de
    ld a, l
    cp $fc
    jr nz, jr_002_74bf

    ld a, [$d8fc]
    add a
    ld bc, $d8f4
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    ld a, [$d93d]
    rst $00

    db $f2, $74, $04, $75, $28, $75, $3b, $75, $4d, $75, $6a, $75, $98, $75

    call Call_002_760e
    call Call_002_75d7
    ld a, [$d955]
    and $03
    ret z

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a
    ret


    ld a, [$d955]
    and $03
    jr z, jr_002_7513

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a
    ld a, [bc]
    inc a
    ld [bc], a

jr_002_7513::
    ld a, [$d8fd]
    ld e, a
    ld a, [bc]
    cp e
    ret nz

    ld a, [$d93d]
    inc a
    ld [$d93d], a
    ld hl, $d901
    call Call_002_75b3
    ret


    ld a, [$d8f5]
    or a
    ret z

    ld a, [$d93d]
    inc a
    ld [$d93d], a
    ld hl, $d905
    call Call_002_75b3
    ret


    inc bc
    ld a, [bc]
    or a
    ret z

    ld a, [$d93d]
    inc a
    ld [$d93d], a
    ld hl, $d909
    call Call_002_75b3
    ret


    ld a, [$d955]
    and $01
    ret z

    ld a, [$d8fe]
    ld e, a
    ld a, [bc]
    inc a
    ld [bc], a
    cp e
    ret c

    ld a, [$d93d]
    inc a
    ld [$d93d], a
    ld hl, $d90d
    call Call_002_75b3
    ret


    ld a, [$d955]
    and $01
    ret z

    ld hl, $d8f4
    ld a, [$d8fc]
    ld b, a

jr_002_7577::
    dec [hl]
    inc hl
    inc hl
    dec b
    jr nz, jr_002_7577

    ld a, [$d8ff]
    ld b, a
    ld a, [$d8f4]
    cp b
    ret nc

    xor a
    ld [$d956], a
    ld a, [$d93d]
    inc a
    ld [$d93d], a
    ld hl, $d911
    call Call_002_75b3
    ret


    ld a, [$d955]
    and $03
    jr z, jr_002_75a4

    ldh a, [hSCX]
    dec a
    ldh [hSCX], a

jr_002_75a4::
    ld a, [$d956]
    inc a
    ld [$d956], a
    cp $90
    ret c

    xor a
    ld [$d93d], a
    ret


Call_002_75b3::
    ld b, $04
    ld de, $d800

jr_002_75b8::
    ld a, [hl+]
    cp $ff
    jr nz, jr_002_75c2

    inc de
    inc de
    inc de
    jr jr_002_75d3

jr_002_75c2::
    push hl
    ld hl, $7849
    push de
    rst $20
    pop de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    inc de
    xor a
    ld [de], a
    inc de
    pop hl

jr_002_75d3::
    dec b
    jr nz, jr_002_75b8

    ret


Call_002_75d7::
    ld a, [$d954]
    cp $31
    ret nz

    ld a, [$d8fc]
    ld hl, $77fd
    rst $38
    ld b, [hl]
    ld a, [$d939]
    cp b
    ret nz

    ld a, [$d8fc]
    ld c, $18
    call Call_000_05b4
    ld de, $7801
    add hl, de
    ld de, $d8fd
    ld b, $18

jr_002_75fb::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, jr_002_75fb

    ld a, [$d8fc]
    inc a
    ld [$d8fc], a
    ld a, $01
    ld [$d93d], a
    ret


Call_002_760e::
    ld a, [$d954]
    cp $31
    jr z, jr_002_761f

    ld a, [$d96d]
    or a
    jr z, jr_002_763b

    call Call_000_0719
    ret


jr_002_761f::
    xor a
    ld [$d954], a
    ld a, $09
    ld [$d970], a
    ld a, [$d939]
    inc a
    ld [$d939], a
    ld a, $10
    ld [$d981], a

jr_002_7634::
    ld a, [$d939]
    call Call_000_0710
    ret


jr_002_763b::
    ld a, [$d939]
    cp $59
    jr nz, jr_002_7653

    call Call_000_07f8
    ld a, [$d95c]
    or a
    ret nz

    ld bc, $0203
    ld de, $0000
    jp RequestStateChange_Menu


jr_002_7653::
    ld a, $0d
    ld [$d970], a
    ld a, $0c
    ld [$d981], a
    ld a, [$d954]
    inc a
    ld [$d954], a
    cp $30
    jr z, jr_002_7634

    ret


    call Call_002_7700
    ld e, $08
    ld hl, $d915
    ld d, $01
    ld a, [$d954]
    bit 0, a
    jr z, jr_002_767c

    ld d, $02

jr_002_767c::
    ld a, [hl]
    add d
    ld c, a
    ld [hl+], a
    ld a, [hl]
    sub d
    ld b, a
    ld [hl+], a
    ld a, [hl]
    inc a
    ld [hl+], a
    push hl
    push de
    cp $50
    jr nz, jr_002_76a3

    dec hl
    dec hl
    dec hl
    ld a, e
    add a
    add e
    ld de, $7889
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl+], a
    xor a
    ld [hl+], a

jr_002_76a3::
    ld d, $f1
    ld a, [$d954]
    bit 3, a
    jr z, jr_002_76ae

    ld d, $f0

jr_002_76ae::
    call Call_000_0791
    pop de
    pop hl
    dec e
    jr nz, jr_002_767c

    ld a, [$d954]
    inc a
    ld [$d954], a
    ld a, [$d96d]
    or a
    ret z

    ld a, [$d954]
    and $03
    ret nz

    ldh a, [hSCY]
    inc a
    ldh [hSCY], a
    and $0f
    jr nz, jr_002_76d5

    call Call_000_0719
    ret


jr_002_76d5::
    ldh a, [hSCY]
    and $07
    cp $04
    ret nz

    ldh a, [hSCY]
    and $f8
    ld l, a
    ld h, $00
    sla l
    rl h
    sla l
    rl h
    ld bc, $03e9
    add hl, bc
    ld a, h
    and $03
    ld h, a
    ld bc, $9800
    add hl, bc
    ld c, l
    ld b, h
    ld de, $010a
    call QueueVramFill
    ret


Call_002_7700::
    ld a, [$d955]
    ld d, a
    ld a, $38
    add d
    ld b, a
    ld a, $50
    sub d
    ld c, a
    ld de, $d800
    call Call_000_0720
    ld a, [$d956]
    ld b, a
    ld a, $50
    sub b
    ld c, a
    ld de, $d803
    call Call_000_0720
    ld a, [$d93d]
    rst $00
    ld l, $77
    cpl
    ld [hl], a
    ld c, a
    ld [hl], a
    ld a, l
    ld [hl], a
    xor a
    ld [hl], a
    ret


    ld a, [$d954]
    and $07
    jr nz, jr_002_7743

    ld a, [$d955]
    inc a
    cp $30
    jr c, jr_002_7740

    ld a, $30

jr_002_7740::
    ld [$d955], a

jr_002_7743::
    ld a, [$d974]
    cp $01
    ret nz

    ld a, $02
    ld [$d974], a
    ret


    ld a, [$d954]
    and $07
    jr nz, jr_002_7762

    ld a, [$d955]
    dec a
    bit 7, a
    jr z, jr_002_775f

    xor a

jr_002_775f::
    ld [$d955], a

jr_002_7762::
    ld a, [$d974]
    cp $02
    ret nz

    ld hl, $7b65
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld a, $03
    ld [$d974], a
    ret


    ld a, [$d954]
    and $07
    jr nz, jr_002_7791

    ld a, [$d955]
    inc a
    cp $30
    jr c, jr_002_778e

    ld a, $30

jr_002_778e::
    ld [$d955], a

jr_002_7791::
    ld a, [$d974]
    cp $03
    ret nz

    ld hl, $7b70
    ld a, l
    ld [$d800], a
    ld a, h
    ld [$d801], a
    xor a
    ld [$d802], a
    ld [$d957], a
    ld a, $04
    ld [$d974], a
    ret


    ld a, [$d957]
    cp $20
    call nc, Call_002_77d7
    ld a, [$d954]
    and $07
    ret nz

    ld a, [$d956]
    inc a
    cp $30
    jr c, jr_002_77c7

    ld a, $30

jr_002_77c7::
    ld [$d956], a
    ld a, [$d96d]
    or a
    ret nz

    ld a, [$d957]
    inc a
    ld [$d957], a
    ret


Call_002_77d7::
    call Call_000_07f8
    ld a, [$d95c]
    or a
    ret nz

    ld bc, $0204
    ld a, [$dffd]
    or a
    jr z, jr_002_77eb

    ld bc, $0205

jr_002_77eb::
    ld de, $0000
    jp RequestStateChange_Menu


    db $50, $f0, $f0, $f0, $97, $7a, $7c, $7a, $88, $7a, $91, $7a, $50, $53, $56, $8e
    db $30, $5c, $45, $00, $01, $0f, $ff, $ff, $ff, $04, $ff, $ff, $ff, $05, $ff, $ff
    db $00, $10, $ff, $ff, $02, $06, $ff, $ff, $24, $68, $39, $00, $03, $11, $ff, $ff
    db $ff, $ff, $08, $ff, $ff, $ff, $09, $ff, $02, $12, $13, $ff, $02, $07, $0a, $ff
    db $18, $74, $2d, $00, $03, $12, $13, $ff, $ff, $ff, $ff, $0c, $ff, $ff, $ff, $0d
    db $02, $12, $14, $15, $02, $07, $0b, $0e, $97, $7a, $a2, $7a, $cb, $7a, $d6, $7a
    db $e5, $7a, $ee, $7a, $f9, $7a, $04, $7b, $0f, $7b, $1c, $7b, $27, $7b, $32, $7b
    db $3d, $7b, $44, $7b, $4f, $7b, $7c, $7a, $7f, $7a, $82, $7a, $85, $7a, $8b, $7a
    db $8e, $7a, $94, $7a

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add b
    ld bc, $0101
    ld bc, $0101
    ld bc, $0101
    ld bc, $f801
    db $10
    jr nz, @-$06

    jr nz, @+$1a

    ld hl, sp+$30
    nop
    ld hl, sp+$60
    jr nc, @+$0a

    sbc b
    ld [$9820], sp
    ld b, b
    jr nc, @-$66

    stop
    nop
    db $28

    db $0c, $01, $0c, $00, $ff, $a1, $78, $0c, $02, $0c, $03, $0c, $04, $0c, $02, $0c
    db $03, $0c, $04, $8c, $02, $8c, $03, $8c, $04, $8c, $02, $8c, $03, $8c, $04, $09
    db $05, $0c, $06, $0c, $07, $0c, $06, $0c, $07, $09, $08, $0c, $09, $0c, $0a, $0c
    db $09, $0c, $0a, $09, $0b, $ff, $a8, $78, $0c, $0c, $0c, $0d, $ff, $d9, $78, $08
    db $0e, $08, $0f, $08, $0e, $08, $10, $ff, $e0, $78

    adc b
    ld c, $88
    rrca
    adc b
    ld c, $88
    db $10
    rst $38
    db $eb
    ld a, b

    db $18, $11, $18, $12, $18, $13, $30, $14, $fe

    or $78

    db $18, $16, $18, $15, $ff, $01, $79, $08, $17, $08, $18, $08, $17, $08, $19, $ff
    db $08, $79, $0c, $1a, $0c, $1b, $ff, $13, $79, $06, $1a, $06, $1c, $7f, $1d

    db $fe

    db $0c, $1e, $0c, $1f, $ff, $21, $79, $06, $1e, $06, $20, $7f, $21

    db $fe

    db $8c, $1e, $8c, $1f, $ff, $2f, $79, $86, $1e, $86, $20, $f0, $21

    db $fe

    db $0c, $22, $0c, $23, $ff, $3d, $79, $06, $22, $06, $24, $7f, $25

    db $fe

    db $04, $26, $04, $27, $04, $28, $04, $29, $04, $26, $04, $27, $04, $28, $04, $29
    db $04, $39, $fe

    ld c, e
    ld a, c
    rrca
    ld a, [hl+]
    rrca
    dec hl
    rst $38
    ld h, b
    ld a, c
    rrca
    ld b, h
    rrca
    ld b, l
    rst $38
    ld h, a
    ld a, c
    inc b
    ld h, $04
    daa
    inc b
    jr z, jr_002_7979

    add hl, hl
    inc b
    ld h, $04

jr_002_7979::
    daa
    inc b
    jr z, jr_002_7981

    add hl, hl
    ld b, b
    ld d, d
    db $10

jr_002_7981::
    ld d, e
    db $10
    ld d, d
    db $10
    ld d, e
    rst $38
    add d
    ld a, c
    jr jr_002_79e1

    ld c, $55
    ld c, $54
    sbc b
    ld d, [hl]
    adc [hl]
    ld d, l
    adc [hl]
    ld d, h
    rst $38
    adc c
    ld a, c
    ld b, $57
    ld b, $58
    ld b, $57
    ld b, $59
    rst $38
    sbc b
    ld a, c
    ld [$085a], sp
    ld e, e
    ld [$085a], sp
    ld e, h
    rst $38
    and e
    ld a, c
    ld [$085d], sp
    ld e, [hl]
    ld [$ff5f], sp
    xor [hl]
    ld a, c

    db $08, $60, $0d, $61, $08, $60, $fe, $40, $60, $08, $63, $20, $64, $08, $65, $08
    db $66, $08, $65, $02, $64, $fe

    rrca
    ld h, a
    rrca
    ld l, b
    rst $38
    call Call_002_4079
    ld h, b
    ld [$0f63], sp
    ld [hl], a
    ld [$0878], sp
    ld a, c
    ld [$087a], sp

jr_002_79e1::
    ld a, c
    ld [$fe78], sp
    db $10
    ld a, l
    db $10
    ld a, h
    rst $38
    push hl
    ld a, c

    db $10, $7e, $10, $7f, $ff, $ec, $79, $10, $81, $10, $82, $ff, $f3, $79, $10, $83
    db $10, $84, $ff, $fa, $79, $10, $85, $10, $86, $ff, $01, $7a, $10, $87, $10, $88
    db $ff, $08, $7a, $08, $89, $08, $8a, $ff, $0f, $7a, $10, $8b, $10, $8c, $10, $8d
    db $ff, $16, $7a, $08, $8f, $08, $90, $08, $8f, $7f, $8e

    db $fe

    db $10, $94, $10, $95, $ff, $28, $7a, $08, $97, $08, $98, $ff, $2f, $7a, $3f, $a2
    db $0f, $a3, $08, $a4, $08, $a5, $08, $a4, $ff, $3c, $7a, $08, $a8, $08, $a9, $08
    db $a8, $08, $aa, $ff, $43, $7a

    ld [$08ae], sp
    xor a
    db $fe

    db $1f, $ae, $1f, $af, $fe, $0f, $ae, $0f, $af, $0f, $ae, $0f, $af, $fe

    ccf
    and d
    rrca
    and e
    ld [$08a4], sp
    and l
    ld [$08a4], sp
    and l
    ld [$08a4], sp
    and l
    ld [$08a4], sp
    and l
    ld [$08a4], sp
    and l
    ld [$feb0], sp

    db $3f, $c4, $fe, $8f, $c4, $fe, $3f, $c9, $fe, $3f, $cc, $fe, $3f, $cf, $fe, $3f
    db $d6, $fe, $3f, $d9

    db $fe

    db $3f, $dc, $fe, $3f, $e3

    db $fe

    db $0c, $b3, $0c, $b4, $0c, $b3, $0c, $b5, $ff, $97, $7a, $20, $b3, $0f, $b6, $0f
    db $b7, $0f, $b6, $0f, $b7, $0f, $b6, $0f, $b7, $0f, $b9, $0f, $b8, $0f, $b9, $0f
    db $b8, $13, $ba, $13, $bb, $13, $bc, $13, $bd, $13, $be, $13, $bd, $13, $be, $13
    db $bd, $13, $be, $fe, $0c, $bf, $0c, $c0, $0c, $bf, $0c, $c1, $ff, $cb, $7a, $20
    db $bf, $0f, $c2, $0f, $c3, $0f, $c2, $0f, $c3, $0f, $c2, $0f, $c3, $fe, $13, $c4
    db $13, $c5, $13, $c4, $13, $c5, $fe, $0c, $c6, $0c, $c7, $0c, $c6, $0c, $c8, $ff
    db $ee, $7a, $0c, $c9, $0c, $ca, $0c, $c9, $0c, $cb, $ff, $f9, $7a, $0c, $cc, $0c
    db $cd, $0c, $cc, $0c, $ce, $ff, $04, $7b, $0c, $d0, $0c, $d1, $0c, $d0, $0c, $d1
    db $0c, $d0, $0c, $d1, $fe, $0c, $d3, $0c, $d4, $0c, $d3, $0c, $d5, $ff, $1c, $7b
    db $0c, $d6, $0c, $d7, $0c, $d6, $0c, $d8, $ff, $27, $7b, $0c, $d9, $0c, $da, $0c
    db $d9, $0c, $db, $ff, $32, $7b, $1c, $dd, $0f, $de, $0f, $df, $fe, $0c, $e0, $0c
    db $e1, $0c, $e0, $0c, $e2, $ff, $44, $7b, $0c, $e3, $0c, $e4, $0c, $e3, $0c, $e5
    db $ff, $4f, $7b

    ld a, [bc]
    and $0a
    rst $20
    ld a, [bc]
    and $0a
    add sp, -$01
    ld e, d
    ld a, e
    rrca
    and $0f
    rst $20
    rrca
    and $0f
    add sp, -$01
    ld h, l
    ld a, e
    ld a, [bc]
    jp hl


    ld [$08ea], sp
    db $eb
    ld [$08ea], sp
    db $eb
    ld [$08ea], sp
    db $eb
    ld [$08ea], sp
    db $eb
    rst $38
    ld [hl], b
    ld a, e
    ld a, [bc]
    db $ec
    ld a, [bc]
    db $ed
    ld a, [bc]
    xor $ff
    add l
    ld a, e

    db $a2, $00, $55, $03, $0f, $1f, $3f, $00, $5b, $43, $7b, $78, $fd, $fc, $ff, $ce
    db $7f, $ff, $c0, $bf, $3f, $f7, $07, $dd, $1c, $55, $00, $c0, $f0, $f8, $75, $fc
    db $fe, $7e, $10, $07, $04, $05, $0f, $0a, $1f, $10, $00, $2f, $20, $3f, $20, $3f
    db $20, $2f, $20, $00

jr_002_7bc2::
    db $ff, $33, $ff, $c3, $ff, $20, $ff, $11, $00, $ef, $e2, $ff, $b7, $7f, $75, $fb
    db $03, $00, $ff, $f9, $7f, $1c, $ff, $0c, $ff, $e0, $00, $ff, $10, $7f, $08, $ff
    db $80, $fe, $80, $7c, $f0, $68, $08, $01, $f8, $08, $f8, $08, $e8, $08, $f0, $01
    db $3f, $20, $17, $10, $0f, $0d, $0b, $00, $09

jr_002_7bfb::
    db $08, $0b, $08, $0b, $08, $0d, $0c, $00, $ff, $00, $ff, $00, $fb, $03, $ff, $fc
    db $00

jr_002_7c0c::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $f6, $06, $ba, $3a, $fd, $c1, $ff
    db $01, $00, $ff, $01, $fb, $09, $ff, $07, $f7, $05, $75, $03, $01, $00, $ff, $07
    db $7f, $00, $df, $c0, $ff, $40, $15, $1c, $1f, $38, $3f, $01, $3f, $15, $ef, $0f
    db $7c, $f8, $f0, $00, $60, $3e, $e0, $be, $c0, $f8, $c0, $e0, $05, $3f, $20, $17
    db $13, $1d, $13, $05, $1a, $12, $17, $15, $0f, $02, $00, $f7, $07, $bb, $38, $ff
    db $c0, $ff, $06, $00, $fd, $05, $fc

jr_002_7c63::
    db $04, $fa, $02, $f2, $02, $51, $00, $80, $c0, $40, $60, $17, $e0, $a0, $e0, $00
    db $05, $bf, $80

jr_002_7c76::
    db $ef, $e0, $7f, $3f, $14, $06, $04, $05, $0f, $06, $07, $04, $f7, $07, $be, $3e
    db $fc, $f0, $f7, $00, $a0, $bf, $00, $fe, $00, $f8, $00, $c0, $7e, $00, $f0, $1f
    db $00, $e0, $00, $05, $1f, $10, $0b, $09, $06, $03, $41, $02, $03, $02, $05, $04
    db $06, $00, $ff, $00, $ff, $80, $fd, $81, $ff, $fe, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $00, $fb, $03, $dc, $1c, $fa, $e2, $fe, $02, $06, $5a, $42, $f6
    db $a6, $fa, $02, $7f, $03, $85, $02, $03, $02, $07, $03, $07, $7f, $00, $df, $c0
    db $ff, $40, $40, $80, $87, $80, $bf, $00, $ff, $14, $ee, $0e, $7c, $fe, $fb, $f9
    db $00, $2f, $27, $1d, $fd, $00, $e0, $00, $80, $01, $1f, $10, $0b, $08, $0f, $0e
    db $1b, $10, $3c, $34, $3f, $1f, $18, $1e, $10, $01, $ff, $00, $ff, $00, $fd, $81
    db $fe, $00, $33, $32, $8f, $8c, $4d, $4c, $ff, $fb, $80, $03, $dc, $1c, $fe, $e0
    db $ff, $00, $05, $cf, $00, $be

jr_002_7d1c::
    db $20, $c3, $ff

jr_002_7d1f::
    db $55, $00, $80, $40, $60, $7c, $e0, $f0, $d0, $55, $10, $0f, $01, $07, $04, $0e
    db $08, $1d, $11, $12, $1f, $1e, $45, $ff, $df, $d0, $70, $ef, $5e, $70, $ff, $8f
    db $00, $df, $1f, $9b, $1b, $37, $36, $f7, $f5, $00, $57, $55, $f7, $f4, $fb, $fa
    db $0f, $ff, $01, $b0, $90, $f8, $c8, $d8, $48, $b0, $01, $f0, $b8, $a0, $30, $c0
    db $70, $c0, $05, $17, $15, $17, $16, $1b, $0f, $7f, $00, $00, $f0, $ff, $c0, $ff
    db $c0, $fe, $80, $f0, $7f, $00, $07, $0f, $ff, $00, $c0, $00, $ff, $01, $1f, $10
    db $0b, $08, $0f, $0e, $0b, $51, $09, $1a, $3c, $34, $3f, $00, $ff, $00, $ff, $00
    db $fd, $81, $ff, $fe, $00, $8f, $80, $43, $42, $35, $34, $8f, $8c, $00, $fb, $03
    db $dc, $1c, $fe, $e0, $ff, $00, $00, $ff, $00, $fe, $00, $cf, $01, $b9, $21, $55
    db $00, $80, $40, $60, $d8, $fe, $f2, $ee, $e6, $0d, $1f, $18, $1e, $10, $0f, $50
    db $01, $07, $0e, $08, $1d, $11, $04, $4d, $4c, $ff, $fb, $ff, $df, $d0, $55, $70
    db $ef, $70, $ff, $50, $c7, $ff, $df, $1f, $9b, $1b, $00

jr_002_7dda::
    db $37, $36, $f7, $f5, $57, $55, $fb, $fa, $d5, $c0, $80, $c0, $90, $40, $a0, $e0
    db $a0, $c0, $60, $01, $95, $91, $ff, $f7, $5f, $5c, $6f, $1f, $3e, $3f, $00, $40
    db $ff, $f8, $ff, $c0, $7f, $c0, $fe, $1f, $00, $f0, $00, $01, $7e, $ff, $3c, $fe
    db $00, $f0, $00, $ff, $50, $c7, $ff, $df, $1f, $9b, $1b, $00, $37, $36, $f7, $f5
    db $57, $55, $f7, $f4, $55, $fa, $c0, $80, $c0, $92, $40, $a0, $e0, $a0, $20, $40
    db $97, $ff, $f4, $5f, $57, $5f, $5b, $47, $6f, $3e, $3f, $00, $40, $ff, $f8, $7f
    db $c0, $ff, $00, $ff, $07, $00, $f8, $00, $c0, $00, $00, $de, $d2, $7e, $ff, $3c
    db $fe, $00, $80, $7f, $00, $50, $03, $04, $07, $04, $06, $04, $50, $05, $0f, $3f
    db $30, $7f, $58, $54, $80, $81, $82, $0d, $0c, $00, $f7, $f0, $ef, $0c, $fb, $03

jr_002_7e6a::
    db $fe, $00, $00, $bf, $a4, $ff, $80, $ff, $90, $ff, $80, $05, $7f, $40, $35, $34
    db $0f, $03, $00, $ff, $00, $ff, $00, $ff, $03, $ff, $00, $01, $ff, $00, $7f, $02
    db $bf, $80, $7f, $75, $00, $20, $30, $40

jr_002_7e92::
    db $28, $38, $28, $fc, $ec, $ea, $42, $00, $ff, $01, $ff, $01, $fd, $01, $7e, $1f
    db $00, $aa, $a3, $5e, $43, $fc, $7e, $e0, $3e, $00, $e0, $bc, $e0, $b0, $e0, $20
    db $c0, $40, $5f, $80, $00, $44, $03, $05, $04, $0f, $3f, $30, $00

jr_002_7ebf::
    db $7f, $58

jr_002_7ec1::
    db $bf, $a4, $ff, $80, $ff, $90, $00, $ff, $80, $7f, $40

jr_002_7ecc::
    db $75, $74, $df, $9f, $07, $e3, $ef, $00, $1c, $00, $ff, $55, $03, $06, $01

jr_002_7edb::
    db $83, $00, $cd, $4c, $f7, $f0, $ef, $0c, $fb, $03, $00, $fe, $00, $ff, $00, $ff
    db $00, $ff, $03, $00, $ff, $00, $ff, $00, $7f, $02, $bf, $80, $41, $ff, $f0, $9e
    db $e0, $bc, $c0, $7f, $00, $40, $c0, $a0, $20, $7c, $3c, $fa, $a2, $00, $bf, $81
    db $ff, $01, $ff, $01, $73, $01, $00, $e7, $e1, $57, $55, $fe, $6e, $f8, $2e, $00
    db $f0, $bc, $e0, $b8, $e0, $30, $c0, $60, $1f, $80, $c0, $00, $45, $01, $03, $02
    db $05, $0f, $00, $3f, $30, $7f, $58, $bf, $a4, $ff, $80, $00, $ff, $90, $ff, $80
    db $7f, $40, $35, $34, $61, $1f, $17, $18, $1f, $00, $ff, $54, $03, $06, $c1, $c3
    db $43, $00, $8d, $8c, $f7, $f0, $ef, $0c, $fb, $03, $00, $fe, $00, $ff, $00, $ff
    db $00, $ff, $03, $00, $ff, $00, $ff, $00

jr_002_7f63::
    db $7f, $02, $bf, $80, $41, $7f, $38, $2f, $30, $3c, $00, $ff, $40, $c0, $a0, $20
    db $7c, $3c, $fb, $a3, $00, $bf, $80, $fe, $00, $f9, $01, $72, $02, $40

jr_002_7f81::
    db $b4, $58, $48, $ec, $64, $fc, $3f, $00

jr_002_7f89::
    db $e0, $be, $e0, $bc, $e0, $30, $c0, $40, $5f, $80, $00, $65, $c0, $40, $80, $00
    db $ff

jr_002_7f9a::
    db $d4, $88, $d9, $fb, $ab, $22, $af, $ad, $a9, $a2, $82

jr_002_7fa5::
    db $83, $54, $02, $06, $0a, $13, $17, $00, $26, $2e, $48

jr_002_7fb0::
    db $5b, $81, $ff, $00, $57, $50, $10, $30, $d0, $f0, $10

jr_002_7fbb::
    db $70, $00, $3e, $fe, $e4, $fc, $18, $f8, $20, $e0, $75, $00, $07, $18, $00

jr_002_7fca::
    db $23, $2f, $44, $5c, $88, $fb, $01, $5f, $55, $00, $04, $cc, $94, $00, $f4, $fc
    db $14, $7c, $e8, $f8, $10, $f0

    db $02, $00, $00, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $00, $ff, $80, $ff, $80

jr_002_7ff0::
    db $ff, $80, $ff, $80

    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
