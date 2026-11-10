VBlankHandler:: ; Main VBlank handler: DMA/OAM, VRAM queue, palettes, joypad, sound.
    push af
    push bc
    push de
    push hl
    ldh a, [hVBlankBusy]
    and a
    jr nz, VBlank_RunReentrantSoundUpdate

    inc a
    ldh [hVBlankBusy], a
    call _HRAM
    ld de, wVramQueue
    call ProcessVramQueue_CheckNextCommand
    call ApplyScrollRegs
    call ApplyPalettes
    xor a
    ld [wVramQueue], a

VBlank_RunGameUpdate::
    ldh [hVramQueuePos], a
    ldh [hOamWritePos], a
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, $07
    ld [rRomBankSelect], a
    call UpdateSound
    pop af
    ld [rRomBankSelect], a
    ei
    call AdvanceRandomByte
    call ReadJoypad
    call UpdateCurrentGameState
    ldh a, [hOamWritePos]
    ldh [hPrevOamPos], a
    call ClearUnusedOAM
    ldh a, [hJoyHeld]
    cp $0f
    jp z, ResetHardwareAndRuntime

    xor a
    ldh [hVBlankBusy], a
    pop hl
    pop de
    pop bc
    pop af
    ret


VBlank_RunReentrantSoundUpdate::
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, $07
    ld [rRomBankSelect], a
    call UpdateSound
    pop af
    ld [rRomBankSelect], a
    ldh a, [hVBlankBusy]
    dec a
    ldh [hVBlankBusy], a
    pop hl
    pop de
    pop bc
    pop af
    ret


LcdcInterruptHandler::
    push af
    push bc
    push de
    push hl
    call LcdcInterruptHook_NoOp
    pop hl
    pop de
    pop bc
    pop af
    ret


LcdcInterruptHook_NoOp:: ; Reserved LCD hook; the original implementation returns immediately.
    ret
