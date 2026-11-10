ApplyScrollRegs:: ; Copy scroll/window shadow values to hardware registers.
    ldh a, [hSCY]
    ldh [rSCY], a
    ldh a, [hSCX]
    ldh [rSCX], a
    ldh a, [hWY]
    ldh [rWY], a
    ldh a, [hWX]
    ldh [rWX], a
    ret


ClearUnusedOAM::
    ld h, $c0
    ldh a, [hOamWritePos]
    ld l, a
    sub $a0
    ret nc

    cpl
    inc a
    ld b, a
    xor a

ClearUnusedOAM_NextByte::
    ld [hl+], a
    dec b
    jr nz, ClearUnusedOAM_NextByte

    ret


ApplyPalettes:: ; Copy palette shadow bytes to BGP/OBP0/OBP1.
    ld hl, wPaletteBGP
    ld a, [hl+]
    ldh [rBGP], a
    ld a, [hl+]
    ldh [rOBP0], a
    ld a, [hl]
    ldh [rOBP1], a
    ret
