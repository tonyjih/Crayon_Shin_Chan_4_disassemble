; Matching disassembly of Crayon Shin-chan 4 (Japan, original SGB release).
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $000", ROM0[$0]

RST_00:: ; Jump table dispatch. A indexes word table after rst call, then jumps to target.
    jr DispatchInlineJumpTable

    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_08::
    ret

    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_10::
    ret


    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_18::
    ret


    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

RST_20:: ; Pointer table helper. HL points to word table, A selects entry, returns pointer in HL.
    jr ReadIndexedWord

FillBytesWithA::
    ld [hl+], a
    dec b
    jr nz, FillBytesWithA

    ret

    db $ff

RST_28:: ; abs(A).
    bit 7, a
    ret z

    cpl
    inc a
    ret


    db $ff
    db $ff

RST_30:: ; Add A to DE.
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ret


    db $ff

RST_38:: ; Add A to HL.
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ret

    db $ff

VBlankInterrupt::
    call VBlankHandler
    reti


    db $ff
    db $ff
    db $ff
    db $ff

LCDCInterrupt::
    call LcdcInterruptHandler
    reti

    db $ff
    db $ff
    db $ff
    db $ff

TimerOverflowInterrupt::
    reti

    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

SerialTransferCompleteInterrupt::
    reti


    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

JoypadTransitionInterrupt::
    reti


DispatchInlineJumpTable::	;from rst $00
    add a
    pop hl
    ld e, a
    ld d, $00
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl


ReadIndexedWord::	;from rst $20
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

ZeroMemoryWithInitialA:: ; Write A once, then zero the remaining BC-1 bytes; the loop enters bzero.
    ld [hl+], a
    dec bc
    ld a, c
    or b
    jr nz, bzero

    ret

    db $ff
    db $ff
    db $ff
    db $ff

CompareU16AtHLToDE::
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    sub d
    ret nz

    ld a, l
    sub e
    ret


FarCallFromBankTable:: ; Banked table call. H=bank, L=entry-ish index; calls pointer read from bank:$4000+L+1.
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, h
    ld [rRomBankSelect], a
    ld a, $01
    add l

CallBankTablePointer::
    ld l, a
    ld a, $40
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call CallHLTrampoline
    pop af
    ld [rRomBankSelect], a
    ret


CallHLTrampoline::
    jp hl


CopyDmaStubToHram::
    ld c, $80      ; HRAM destination = FF80
    ld b, $0a      ; copy 10 bytes
    ld hl, OamDmaStub

.copy
    ld a, [hl+]
    ldh [c], a
    inc c
    dec b
    jr nz, .copy
    ret

OamDmaStub::
    ld a, HIGH(wOamBuffer) ; $c0
    ldh [rDMA], a
    ld a, $28
.wait
    dec a
    jr nz, .wait
    ret

ReadJoypad:: ; Updates hJoyHeld, hJoyPressed, and hJoyLast from rP1.
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
    ldh a, [hJoyLast]
    xor c
    and c
    ldh [hJoyPressed], a
    ld a, c
    ldh [hJoyHeld], a
    ldh [hJoyLast], a
    ld a, $30
    ldh [rP1], a
    ret


ApplyLCDC::
    ld a, [wLCDCShadow]
    ldh [rLCDC], a
    ret


    db $ff
    db $ff
    db $ff


Boot::
    nop
    jp StartGame


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

IF DEF(DX)
HeaderTitle::
    db "KUREYON SHIN4DX"
HeaderCGBFlag::
    db $80 ; Supports CGB functions, but still works on DMG/SGB.
ELSE
HeaderTitle::
    db "GB KUREYON SHIN4"

ENDC
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
    db $0c, $01 ; Original ROM global checksum; rgbfix verifies/recomputes it.

StartGame::
    ld sp, wStackTop
    ld a, $01
    ld [wMinigameUnlockedRounds], a
    ld [wMinigameUnlockedRounds + 1], a
    ld [wMinigameUnlockedRounds + 2], a
    xor a
    ld [wAlternateModeFlags], a
    ld [wSpecialModeFlags], a
    ld [wSgbBorderColorMode], a
    xor a
    ld [wSgbEnabled], a
    call DetectSgbOrInitSgb
    jr nc, ResetHardwareAndRuntime

    ld a, $ff
    ld [wSgbEnabled], a
    ld hl, FARCALL_BANK3_INIT_BORDER
    call FarCallFromBankTable

ResetHardwareAndRuntime::
    di
    xor a
    ldh [rIE], a
    ld sp, wStackTop
    ld hl, _HRAM
    ld bc, $007f
    call bzero
    call DisableLCD
    ld hl, _VRAM
    ld bc, $5f80
    call bzero
    call CopyDmaStubToHram
    call ReadJoypad
    call InitSound

ReinitCurrentState:: ; Rebuild current state with LCD off. Repeats if init sets hNeedsReset.
    di
    call DisableLCD
    xor a
    ld [wScreenPaletteId], a
    call ApplySgbScreenPaletteFar
    ld hl, _OAMRAM
    ld bc, $00a0
    call bzero
    ld hl, wOamBuffer
    ld bc, $00a0
    call bzero
    call InitCurrentGameState
    xor a
    ldh [hPrevOamPos], a
    call ApplyLCDC
    ldh a, [hNeedsReset]
    or a
    jr nz, ReinitCurrentState

    call ApplyScrollRegs
    call SgbDelayIfEnabled
    call ApplySgbScreenPaletteFar
    ei

MainWaitForStateReset:: ; Main thread idles here; VBlank update sets hNeedsReset to request a state rebuild.
    ldh a, [hNeedsReset]
    or a
    jr z, MainWaitForStateReset

    jr ReinitCurrentState

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


    ld a, $03
    ldh [hSpriteFlags], a
    jr DrawMetasprite

DrawMetaspriteWithBgPriority::
    ld a, $02
    ldh [hSpriteFlags], a
    jr DrawMetasprite

    ld a, $01
    ldh [hSpriteFlags], a
    jr DrawMetasprite

DrawMetaspriteNormal::
    xor a
    ldh [hSpriteFlags], a

DrawMetasprite::
    ld a, $10
    add b
    ld b, a
    ld a, $08
    add c
    ld c, a
    ldh a, [hOamWritePos]
    cp $a0
    ret z

    ld e, a
    ld d, $c0

DrawMetasprite_NextPart::
    ld a, [hl+]
    cp $80
    jr z, DrawMetasprite_Finish

    add b
    ld [de], a
    push de
    ld d, a
    ldh a, [hOamMaxY]
    cp d
    pop de
    jr c, DrawMetasprite_SkipClippedPart

    inc e
    call WriteMetaspriteX
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    call WriteMetaspriteAttributes
    inc e
    ld a, e
    cp $a0
    jr nz, DrawMetasprite_NextPart

DrawMetasprite_Finish::
    ld a, e
    ldh [hOamWritePos], a
    ret


DrawMetasprite_SkipClippedPart::
    inc hl
    inc hl
    inc hl
    jr DrawMetasprite_NextPart

WriteMetaspriteX::
    ldh a, [hSpriteFlags]
    bit 0, a
    jr nz, WriteMetaspriteX_Mirrored

    ld a, [hl+]
    add c
    ld [de], a
    ret


WriteMetaspriteX_Mirrored::
    ld a, [hl+]
    cpl
    inc a
    sub $08
    add c
    ld [de], a
    ret


WriteMetaspriteAttributes::
    ldh a, [hSpriteFlags]
    or a
    jr z, WriteMetaspriteAttributes_Unchanged

    dec a
    jr z, WriteMetaspriteAttributes_FlipX

    dec a
    jr z, WriteMetaspriteAttributes_Priority

    ld a, [hl+]
    xor $20
    set 7, a
    ld [de], a
    ret


WriteMetaspriteAttributes_Priority::
    ld a, [hl+]
    set 7, a
    ld [de], a
    ret


WriteMetaspriteAttributes_FlipX::
    ld a, [hl+]
    xor $20
    ld [de], a
    ret


WriteMetaspriteAttributes_Unchanged::
    ld a, [hl+]
    ld [de], a
    ret


DisableLCD::
    ld hl, rLCDC
    bit 7, [hl]
    ret z

    ldh a, [rIE]
    push af
    res 0, a
    ldh [rIE], a

DisableLCD_WaitSafeScanline::
    ldh a, [rLY]
    cp $91
    jr nz, DisableLCD_WaitSafeScanline

    res 7, [hl]
    pop af
    ldh [rIE], a
    ret


EnableInterruptsFromShadow::
    xor a
    ldh [rIF], a
    ld a, [wInterruptEnableShadow]
    ldh [rIE], a
    ret


ClearBgMap0::
    ld hl, _SCRN0 + $3ff

ClearBgMapFromEnd::
    ld bc, $0400

ClearBgMapFromEnd_Loop::
    ld a, $00
    ld [hl-], a
    dec bc
    ld a, b
    or c
    jr nz, ClearBgMapFromEnd_Loop

    ret


ClearBgMap1::
    ld hl, _SCRN1 + $3ff
    jr ClearBgMapFromEnd

    ld hl, _SCRN0 + $3ff
    ld bc, $0400

FillBgMapFromEnd_Loop::
    ldh a, [hTileStreamWritePos]
    ld [hl-], a
    dec bc
    ld a, b
    or c
    jr nz, FillBgMapFromEnd_Loop

    ret


ProcessVramQueue_NextCommand::
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
    jr z, ProcessVramQueue_CopyRow

    dec a
    jr z, ProcessVramQueue_ReadFillByte

    dec a
    jr z, ProcessVramQueue_CopyColumn

ProcessVramQueue_FillColumn::
    ld a, [de]
    ld [hl], a
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, ProcessVramQueue_FillColumn

    inc de
    jr ProcessVramQueue_CheckNextCommand

ProcessVramQueue_CopyRow::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, ProcessVramQueue_CopyRow

ProcessVramQueue_CheckNextCommand::
    ld a, [de]
    or a
    jr nz, ProcessVramQueue_NextCommand

    ret


ProcessVramQueue_ReadFillByte::
    ld a, [de]
    inc de

ProcessVramQueue_FillRow::
    ld [hl+], a
    dec b
    jr nz, ProcessVramQueue_FillRow

    jr ProcessVramQueue_CheckNextCommand

ProcessVramQueue_CopyColumn::
    ld a, [de]
    ld [hl], a
    inc de
    ld a, b
    ld bc, $0020
    add hl, bc
    ld b, a
    dec b
    jr nz, ProcessVramQueue_CopyColumn

    jr ProcessVramQueue_CheckNextCommand

CopyBytesWithBCount::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, CopyBytesWithBCount

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


BankedMemcpy:: ; Copy BC bytes from A:HL to DE, preserving the current ROM bank.
    push hl
    ld l, a
    ld a, [ROM_BANK_ID_ADDR]
    ld h, a
    ld a, l
    ld [rRomBankSelect], a
    ld a, h
    pop hl
    push af
    call memcpy
    pop af
    ld [rRomBankSelect], a
    ret


BankedMemcpy_RLEFF:: ; Banked copy with $ff count/value RLE expansion.
    push hl
    ld l, a
    ld a, [ROM_BANK_ID_ADDR]
    ld h, a
    ld a, l
    push hl
    ld [rRomBankSelect], a
    pop hl
    ld a, h
    pop hl
    push af
    call DecodeRleff_NextByte
    pop af
    ld [rRomBankSelect], a
    ret


DecodeRleff_NextByte::
    ld a, [hl+]
    cp $ff
    jr z, DecodeRleff_ReadRun

    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, DecodeRleff_NextByte

    ret


DecodeRleff_ReadRun::
    ld a, [hl+]
    ldh [hTileStreamWritePos], a
    ld a, [hl+]
    push hl
    ld h, a
    ldh a, [hTileStreamWritePos]
    ld l, a

DecodeRleff_CopyRun::
    ld a, h
    ld [de], a
    inc de
    dec l
    jr z, DecodeRleff_RunComplete

    dec bc
    ld a, b
    or c
    jr nz, DecodeRleff_CopyRun

    pop hl
    ret


DecodeRleff_RunComplete::
    pop hl
    dec bc
    ld a, b
    or c
    jr nz, DecodeRleff_NextByte

    ret


SendSgbPacket::
    ld a, [hl]
    and $07
    ret z

    ld b, a
    ld c, $00

SendSgbPacket_NextPacket::
    push bc
    ld a, $00
    ldh [c], a
    ld a, $30
    ldh [c], a
    ld b, $10

SendSgbPacket_NextByte::
    ld e, $08
    ld a, [hl+]
    ld d, a

SendSgbPacket_NextBit::
    bit 0, d
    ld a, $10
    jr nz, SendSgbPacket_PulseBit

    ld a, $20

SendSgbPacket_PulseBit::
    ldh [c], a
    ld a, $30
    ldh [c], a
    rr d
    dec e
    jr nz, SendSgbPacket_NextBit

    dec b
    jr nz, SendSgbPacket_NextByte

    ld a, $20
    ldh [c], a
    ld a, $30
    ldh [c], a
    pop bc
    dec b
    ret z

    call DelayFramesOrCycles
    jr SendSgbPacket_NextPacket

SgbDelayIfEnabled::
    ld a, [wSgbEnabled]
    or a
    ret z

DelayFramesOrCycles::
    ld de, $1b58

DelayFramesOrCycles_Loop::
    nop
    nop
    nop
    dec de
    ld a, d
    or e
    jr nz, DelayFramesOrCycles_Loop

    ret


DetectSgbOrInitSgb:: ; SGB detection/init handshake. Carry set means SGB path was detected.
    ld hl, SgbPacket_MltReq2P_0480
    call SendSgbPacket
    call DelayFramesOrCycles
    ldh a, [rP1]
    and $03
    cp $03
    jr nz, DetectSgbOrInitSgb_Detected

    ld a, $20
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    call DelayFramesOrCycles
    ld a, $30
    ldh [rP1], a
    call DelayFramesOrCycles
    ld a, $10
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    call DelayFramesOrCycles
    ld a, $30
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    call DelayFramesOrCycles
    ldh a, [rP1]
    and $03
    cp $03
    jr nz, DetectSgbOrInitSgb_Detected

    ld hl, SgbPacket_MltReq1P_0470
    call SendSgbPacket
    call DelayFramesOrCycles
    sub a
    ret


DetectSgbOrInitSgb_Detected::
    ld hl, SgbPacket_MltReq1P_0470
    call SendSgbPacket
    call DelayFramesOrCycles
    scf
    ret

SgbPacket_MltReq1P_0470::
    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
SgbPacket_MltReq2P_0480::
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TransferSgbDataFromBuffer:: ; Copies BC bytes from HL to the SGB transfer display, then sends the packet at DE.
    push de
    push hl
    call DisableLCD
    pop hl
    ld a, $e4
    ldh [rBGP], a
    ld de, _VRAM + $800
    call memcpy

TransferSgbData_DisplayTransferTiles::
    ld hl, _SCRN0
    ld de, $000c
    ld a, $80
    ld c, $0d

TransferSgbData_NextTileRow::
    ld b, $14

TransferSgbData_NextTile::
    ld [hl+], a
    inc a
    dec b
    jr nz, TransferSgbData_NextTile

    add hl, de
    dec c
    jr nz, TransferSgbData_NextTileRow

    ld a, $81
    ldh [rLCDC], a
    call DelayFramesOrCycles
    pop hl
    call SendSgbPacket
    call DelayFramesOrCycles

TransferSgbData_Return::
    ret


    ldh [hTileStreamWritePos], a
    push de

TransferSgbDataFromBank::
    call DisableLCD
    ld a, $e4
    ldh [rBGP], a
    ld de, _VRAM + $800
    ld bc, $1000
    ldh a, [hTileStreamWritePos]
    call BankedMemcpy
    jr TransferSgbData_DisplayTransferTiles

    ld hl, hTileStreamWritePos
    ld bc, $0014
    jp bzero


GetVramQueueTail:: ; HL = wVramQueue + hVramQueuePos.
    ld hl, wVramQueue
    ldh a, [hVramQueuePos]
    rst $38
    ret


GetVramQueueTailDE::
    ld de, wVramQueue
    ldh a, [hVramQueuePos]
    rst $30
    ret


AdvanceRandomByte:: ; A = (5 * hRandomByte + $11) mod 256; stores the next random byte.
    ldh a, [hRandomByte]
    ld b, a
    add a
    add a
    add b
    add $11
    ldh [hRandomByte], a

AdvanceRandomByte_Return::
    ret


QueueVramFill_SetHighBit::
    set 7, e
    jr QueueVramFill

QueueVramFill:: ; Queue a VRAM fill/single-byte command at wVramQueue.
    call GetVramQueueTail
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
    ldh a, [hVramQueuePos]
    add $04
    ldh [hVramQueuePos], a
    ret


QueueTilemapByte:: ; Queue one tile byte A at tilemap address HL.
    push de
    ld d, a
    ld e, $01
    ld b, h
    ld c, l
    call QueueVramFill
    pop de
    ret


QueueBankedVramTile8000:: ; Queue one 16-byte tile to VRAM $8000 + E*16. D=bank, HL=source base, C=source tile index.
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, d
    ld [rRomBankSelect], a
    call QueueVramTile8000_FromCurrentBank
    pop af
    ld [rRomBankSelect], a
    ret


QueueBankedVramTile9000:: ; Queue one 16-byte BG tile to VRAM $9000 + E*16. D=bank, HL=source base, C=source tile index.
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, d
    ld [rRomBankSelect], a

QueueBankedVramTile9000_CopyAndRestoreBank::
    call QueueVramTile9000_FromCurrentBank
    pop af
    ld [rRomBankSelect], a
    ret


QueueVramTile9000_FromCurrentBank:: ; Internal version of QueueBankedVramTile9000 after bank has been selected.
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
    ld de, _VRAM + $1000
    jr QueueOne16ByteVramCopy

QueueVramTile8000_FromCurrentBank:: ; Internal version of QueueBankedVramTile8000 after bank has been selected.
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
    ld de, _VRAM

QueueOne16ByteVramCopy:: ; Shared tail: append destination + 16 data bytes to the VRAM queue.
    add hl, de
    ld d, h
    ld e, l
    call GetVramQueueTail
    ld a, d
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ld a, $10
    ld [hl+], a
    pop de
    ld b, $10

QueueOne16ByteVramCopy_CopyBytes::
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, QueueOne16ByteVramCopy_CopyBytes

    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $13
    ldh [hVramQueuePos], a
    ret


    push de
    ld d, $10
    ld e, a
    xor a

DivideHlByA_ShiftBit::
    add hl, hl
    rla
    jr c, DivideHlByA_SubtractDivisor

    cp e
    jr c, DivideHlByA_NextBit

DivideHlByA_SubtractDivisor::
    sub e
    inc l

DivideHlByA_NextBit::
    dec d
    jr nz, DivideHlByA_ShiftBit

    pop de
    ret


SplitDecimalTensOnes:: ; Convert A to decimal tens/ones in $ffca/hTileStreamWritePos for HUD drawing.
    ld de, $0000

SplitDecimalTensOnes_SubtractTen::
    ld e, a
    sub $0a
    jr c, SplitDecimalTensOnes_StoreDigits

    inc d
    jr SplitDecimalTensOnes_SubtractTen

SplitDecimalTensOnes_StoreDigits::
    ld a, e
    ldh [hTileStreamWritePos], a
    ld a, d
    ldh [hDecimalTens], a
    ret


MultiplyBCByA8bit:: ; HL = C * A; B is cleared before the 8-bit shift/add multiply.
    push de
    ld hl, $0000
    ld b, l
    ld d, $08

MultiplyBCByA8bit_NextBit::
    rrca
    jr nc, MultiplyBCByA8bit_ShiftMultiplicand

    add hl, bc

MultiplyBCByA8bit_ShiftMultiplicand::
    sla c
    rl b
    dec d
    jr nz, MultiplyBCByA8bit_NextBit

    pop de
    ret


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


CopyTilemapRectToVram::
    call CopyTilemapRowToVram
    dec c
    jr nz, CopyTilemapRectToVram

    ret


CopyTilemapRowToVram::
    push bc
    push hl

CopyTilemapRowToVram_Loop::
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, CopyTilemapRowToVram_Loop

    pop hl
    ld bc, $0020
    add hl, bc
    pop bc
    ret


QueueSequential4x4Tilemap::
; Unused entry: build sixteen sequential tile IDs starting at A, then queue a 4x4 rectangle at HL.
    push hl
    ld b, $10
    ld hl, wSequentialTilemapBuffer

QueueSequential4x4Tilemap_NextTile::
    ld [hl+], a
    inc a
    dec b
    jr nz, QueueSequential4x4Tilemap_NextTile

    pop hl
    ld de, wSequentialTilemapBuffer
    ld bc, $0404

QueueTilemapRect:: ; Queue a rectangular tilemap upload. HL=dest, DE=src, B=width, C=height.
    ld a, l
    ldh [hVramRectDestLo], a
    ld a, h
    ldh [hVramRectDestHi], a
    call GetVramQueueTail

QueueTilemapRect_NextRow::
    ldh a, [hVramRectDestHi]
    ld [hl+], a
    ldh a, [hVramRectDestLo]
    ld [hl+], a
    ld a, b
    ld [hl+], a
    push bc

QueueTilemapRect_CopyRow::
    ld a, [de]
    inc de
    ld [hl+], a
    dec b
    jr nz, QueueTilemapRect_CopyRow

    pop bc
    ldh a, [hVramQueuePos]
    add b
    add $03
    ldh [hVramQueuePos], a
    ldh a, [hVramRectDestLo]
    add $20
    ldh [hVramRectDestLo], a
    ldh a, [hVramRectDestHi]
    adc $00
    ldh [hVramRectDestHi], a
    dec c
    jr nz, QueueTilemapRect_NextRow

    ld [hl], $00
    ret


CopyBankedTilemapRectToVram::
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ldh a, [hTileStreamWritePos]
    ld [rRomBankSelect], a
    call CopyTilemapRectToVram
    pop af
    ld [rRomBankSelect], a
    ret


    ld a, [ROM_BANK_ID_ADDR]
    push af
    ldh a, [hTileStreamWritePos]
    ld [rRomBankSelect], a
    call QueueTilemapRect
    pop af
    ld [rRomBankSelect], a
    ret


CopyTextLineToVram::
    ld a, [de]
    inc de
    cp TEXT_END
    ret z

    cp TEXT_DAKUTEN
    jr z, CopyTextLineToVram_Diacritic

    cp TEXT_HANDAKUTEN
    jr z, CopyTextLineToVram_Diacritic

    ld [hl+], a
    jr CopyTextLineToVram

CopyTextLineToVram_Diacritic::
    ld bc, -$0020
    add hl, bc
    ld [hl], a
    ld bc, $0020
    add hl, bc
    jr CopyTextLineToVram

QueueTextLine:: ; DE is FF-terminated text; dakuten/handakuten are queued one tile row above the base glyphs.
    push hl
    push de
    call QueueTextDiacriticsAndMeasure
    pop de
    pop hl
    push hl
    call GetVramQueueTail
    ld a, b
    pop bc
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    ld [hl+], a
    add $03
    ld b, a

QueueTextLine_NextBaseGlyph::
    ld a, [de]
    cp TEXT_END
    jr z, QueueTextLine_Finish

    inc de
    cp TEXT_DAKUTEN
    jr z, QueueTextLine_NextBaseGlyph

    cp TEXT_HANDAKUTEN
    jr z, QueueTextLine_NextBaseGlyph

    ld [hl+], a
    jr QueueTextLine_NextBaseGlyph

QueueTextLine_Finish::
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add b
    ldh [hVramQueuePos], a
    ret


QueueTextDiacriticsAndMeasure::
    ld bc, -$0020
    add hl, bc
    ld b, $00

QueueTextDiacriticsAndMeasure_Next::
    ld a, [de]
    cp TEXT_END
    ret z

    inc de
    cp TEXT_DAKUTEN
    jr z, QueueTextDiacriticsAndMeasure_Emit

    cp TEXT_HANDAKUTEN
    jr z, QueueTextDiacriticsAndMeasure_Emit

    inc b
    inc hl
    jr QueueTextDiacriticsAndMeasure_Next

QueueTextDiacriticsAndMeasure_Emit::
    push hl
    push bc
    call QueueTilemapByte
    pop bc
    pop hl
    jr QueueTextDiacriticsAndMeasure_Next

    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, b
    ld [rRomBankSelect], a
    ld c, [hl]
    pop af
    ld [rRomBankSelect], a
    ret


ExecuteBankedCopyScript::
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

ExecuteBankedCopyScript_CopyRecord::
    pop de
    pop hl
    call BankedMemcpy
    pop hl
    ld a, $07
    rst $38
    jr ExecuteBankedCopyScript

UpdateSgbBorderColorModeFar::
    ld hl, FARCALL_BANK3_UPDATE_BORDER_COLOR
    call FarCallFromBankTable
    ret


StartMessageFar::
    ldh [hTileStreamWritePos], a
    ld hl, FARCALL_BANK3_INIT_MESSAGE_STREAM
    call FarCallFromBankTable
    ret


UpdateMessageFar::
    ld hl, FARCALL_BANK3_UPDATE_MESSAGE_STREAM
    call FarCallFromBankTable
    ret


INCLUDE "engine/scene_animation.asm"

DrawBank3MetaspriteWithPriority::
    ld a, $02
    ldh [hSpriteFlags], a
    jr DrawBank3MetaspriteFar

    ld a, $01
    ldh [hSpriteFlags], a
    jr DrawBank3MetaspriteFar

DrawBank3MetaspriteNormal::
    xor a
    ldh [hSpriteFlags], a

DrawBank3MetaspriteFar::
    ld hl, FARCALL_BANK3_DRAW_METASPRITE
    call FarCallFromBankTable
    ret


ApplySgbScreenPaletteFar::
    ld hl, FARCALL_BANK3_APPLY_SCREEN_PALETTE
    call FarCallFromBankTable
    ret


LoadMaskedGfx:: ; Load custom bitmask-compressed graphics from A:HL to DE.
    push hl
    ld l, a
    ld a, [ROM_BANK_ID_ADDR]
    ld h, a
    ld a, l
    ld [rRomBankSelect], a
    ld a, h
    pop hl
    push af
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    dec de

LoadMaskedGfx_NextGroup::
    push bc
    ld b, $08
    ld c, [hl]
    inc hl
    ld a, [de]

LoadMaskedGfx_NextByte::
    sla c
    jr c, LoadMaskedGfx_StoreByte

    ld a, [hl+]

LoadMaskedGfx_StoreByte::
    inc de
    ld [de], a
    dec b
    jr nz, LoadMaskedGfx_NextByte

    pop bc
    dec bc
    ld a, c
    or b
    jr nz, LoadMaskedGfx_NextGroup

    pop af
    ld [rRomBankSelect], a
    ret


UpdateTransitionFadeWithLateSgbPalSet::
    ld a, [wFadeTransitionTimer]
    or a
    ret z

    ld b, a
    ld a, $40
    sub b
    ld b, a
    ld a, [wFadeTransitionTimer]
    cp $03
    jr nz, UpdateTransitionFade_AdvanceTimer

    ld hl, SgbPacket_PalSetState14_087d
    ld a, [wScreenPaletteId]
    cp $14
    jr z, UpdateTransitionFade_SendLateSgbPacket

    cp $18
    jr nz, UpdateTransitionFade_AdvanceTimer

    ld hl, SgbPacket_PalSetState18_088d

UpdateTransitionFade_SendLateSgbPacket::
    push bc
    call SendSgbPacket
    pop bc
    jr UpdateTransitionFade_AdvanceTimer

UpdateTransitionFade::
    ld a, [wFadeTransitionTimer]
    or a
    ret z

    cp $3e
    call z, SendSgbTransitionPalSet
    ld b, a

UpdateTransitionFade_AdvanceTimer::
    ld a, [wFadeTransitionTimer]
    dec a
    ld [wFadeTransitionTimer], a
    ld a, b
    cp $40
    ret nc

    ld a, [wSgbEnabled]
    or a
    jr nz, UpdateTransitionFade_ApplySgbPalette

    ld a, b
    swap a
    and $0f
    ld hl, DmgFadePaletteTable_089d
    rst $38
    ld a, b
    and $0f
    cp $07
    jr c, UpdateTransitionFade_ApplyDmgPalette

    bit 0, a
    jr z, UpdateTransitionFade_ApplyDmgPalette

    inc hl

UpdateTransitionFade_ApplyDmgPalette::
    ld a, [hl]
    ld [wPaletteBGP], a
    ld [wPaletteOBP1], a
    ld bc, $0005
    add hl, bc
    ld a, [hl]
    ld [wPaletteOBP0], a
    ret


UpdateTransitionFade_ApplySgbPalette::
    ld hl, SgbFadePaletteTable_08a7
    ld a, b
    srl a
    srl a
    srl a
    rst $38
    ld a, [hl]
    ld [wPaletteBGP], a
    ld [wPaletteOBP0], a
    ld [wPaletteOBP1], a
    ld a, [wScreenPaletteId]
    cp $18
    ret nz

    ld hl, SgbFadePaletteObp0State18_08af
    ld a, b

ApplyFadeObp0FromTable::
    srl a
    srl a
    srl a
    rst $38
    ld a, [hl]
    ld [wPaletteOBP0], a
    ret


SendSgbTransitionPalSet::
    push af
    ld hl, SgbPacket_PalSetDefault_086d
    call SendSgbPacket
    pop af
    ret

SgbPacket_PalSetDefault_086d::
    db $51, $03, $00, $03, $00, $03, $00, $03
	db $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_PalSetState14_087d::
    db $51, $30, $00, $31, $00, $32, $00, $33
	db $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_PalSetState18_088d::
    db $51, $39, $00, $39, $00, $39, $00, $39
	db $00, $00, $00, $00, $00, $00, $00, $00

DmgFadePaletteTable_089d::
    db $00, $00, $40, $90, $e4
	db $00, $00, $40, $90, $d0

SgbFadePaletteTable_08a7::
    db $00, $00, $40, $50, $94, $94, $e4, $e4

SgbFadePaletteObp0State18_08af::
    db $00, $00, $40, $40, $90, $90, $d0, $d0

DrawTilemapBox::
    push bc
    push hl
    ldh a, [hTileStreamWritePos]
    ld e, a
    ld a, [TilemapBoxMaskTable_0902 + 0]
    and e
    ld [hl+], a
    ld a, [TilemapBoxMaskTable_0902 + 1]
    and e

DrawTilemapBox_TopEdge::
    ld [hl+], a
    dec b
    jr nz, DrawTilemapBox_TopEdge

    ld a, [TilemapBoxMaskTable_0902 + 2]
    and e
    ld [hl+], a
    pop hl
    ld a, $20
    rst $38
    pop bc
    ld d, b

DrawTilemapBox_NextInteriorRow::
    ld b, d
    push hl
    ld a, [TilemapBoxMaskTable_0902 + 3]
    and e
    ld [hl+], a
    ld a, [TilemapBoxMaskTable_0902 + 4]
    and e

DrawTilemapBox_Interior::
    ld [hl+], a
    dec b
    jr nz, DrawTilemapBox_Interior

    ld a, [TilemapBoxMaskTable_0902 + 5]
    and e
    ld [hl+], a
    pop hl
    ld a, $20
    rst $38
    dec c
    jr nz, DrawTilemapBox_NextInteriorRow

    ld a, [TilemapBoxMaskTable_0902 + 6]
    and e
    ld [hl+], a
    ld a, [TilemapBoxMaskTable_0902 + 7]
    and e

DrawTilemapBox_BottomEdge::
    ld [hl+], a
    dec d
    jr nz, DrawTilemapBox_BottomEdge

    ld a, [TilemapBoxMaskTable_0902 + 8]
    and e
    ld [hl+], a
    ret


TilemapBoxMaskTable_0902::
    db $f9, $f2, $f8, $f3, $00, $f4, $f7, $f5, $f6

; Bank 1 FarCallFromBankTable parameters.
; FarCallFromBankTable uses H as the ROM bank and L as an offset into the fixed
; per-bank table at ROMX:$4001. These are not ROM addresses.
DEF FARCALL_BANK1_UPDATE_GAMEPLAY     EQU $0100
DEF FARCALL_BANK1_INIT_GAMEPLAY       EQU $0102
DEF FARCALL_BANK1_UPDATE_ENDING_DEMO  EQU $0104
DEF FARCALL_BANK1_INIT_ENDING_DEMO    EQU $0106

; Bank/entry selectors are not CPU addresses.
DEF FARCALL_BANK2_INIT_TITLE_MENU               EQU $0200
DEF FARCALL_BANK2_UPDATE_TITLE_MENU             EQU $0202
DEF FARCALL_BANK2_INIT_MINIGAME                  EQU $0204
DEF FARCALL_BANK2_UPDATE_MINIGAME                EQU $0206
DEF FARCALL_BANK2_INIT_STAGE_SCENE                  EQU $020c
DEF FARCALL_BANK2_UPDATE_STAGE_SCENE                EQU $020e
DEF FARCALL_BANK2_INIT_ENDING                  EQU $0210
DEF FARCALL_BANK2_UPDATE_ENDING                EQU $0212
DEF FARCALL_BANK3_INIT_MESSAGE_STREAM           EQU $0300
DEF FARCALL_BANK3_UPDATE_MESSAGE_STREAM         EQU $0302
DEF FARCALL_BANK3_DRAW_METASPRITE               EQU $0306
DEF FARCALL_BANK3_APPLY_SCREEN_PALETTE                    EQU $0308
DEF FARCALL_BANK3_INIT_BORDER                    EQU $030a
DEF FARCALL_BANK3_UPDATE_BORDER_COLOR                    EQU $030c

UpdateCurrentGameState:: ; Per-frame state dispatcher, called from VBlank after input/sound.
; hGameState update map, current understanding:
;   0 -> bank 2 title/menu update
;   1 -> debug menu update
;   2 -> bank 1 gameplay update
;   3 -> bank 2 screen/update path
;   4 -> bank 2 screen/update path
;   5 -> bank 2 screen/update path
;   6 -> pause-ish handler: wait for START, then return to gameplay
    ldh a, [hGameState]
    rst $00

    ; hGameState update jump table. rst $00 consumes these words as data.
    dw UpdateGameState_TitleMenu ; 00: bank 2 title/menu update
    dw UpdateGameState_DebugMenu ; 01: debug menu update
    dw UpdateGameState_Gameplay ; 02: bank 1 gameplay update
    dw UpdateGameState_Bank2Screen0 ; 03: bank 2 screen/update path
    dw UpdateGameState_Bank2Screen1 ; 04: bank 2 screen/update path
    dw UpdateGameState_Bank2Screen2 ; 05: bank 2 screen/update path
    dw UpdateGameState_Pause ; 06: pause-ish handler
    dw UpdateGameState_FadeReturn ; 07: unused/variant update path
    dw UpdateGameState_EndingDemo ; 08: ending demo / staff-roll style sequence

UpdateGameState_TitleMenu::
	; hGameState == 00
    ld hl, FARCALL_BANK2_UPDATE_TITLE_MENU
    jp FarCallFromBankTable


UpdateGameState_DebugMenu::
	; hGameState == 01
    jp UpdateDebugMenu


UpdateGameState_Gameplay::
	; hGameState == 02
    ld hl, FARCALL_BANK1_UPDATE_GAMEPLAY
    jp FarCallFromBankTable


UpdateGameState_Bank2Screen0::
	; hGameState == 03
    ld hl, FARCALL_BANK2_UPDATE_MINIGAME
    jp FarCallFromBankTable


UpdateGameState_Bank2Screen1::
	; hGameState == 04
    ld hl, FARCALL_BANK2_UPDATE_STAGE_SCENE
    jp FarCallFromBankTable


UpdateGameState_Bank2Screen2::
	; hGameState == 05
    ld hl, FARCALL_BANK2_UPDATE_ENDING
    jp FarCallFromBankTable


UpdateGameState_Pause::
	; hGameState == 06
    ld a, $93
    ld [wPaletteBGP], a
    ldh a, [hPrevOamPos]
    ldh [hOamWritePos], a
    ldh a, [hJoyPressed]
    bit 3, a
    ret z

	; hGameState == 07
    ld a, $e4
    ld [wPaletteBGP], a
    ld a, $02
    ldh [hGameState], a
    ld a, $80
    ld [wSoundPriorityFlags], a
    ld a, $5e
    call PlaySound_Queue1
    ret


SelectGameplayMusic:: ; Selects Action Kamen music, stage 3 music, or the shared stage 0-2 music.
    call InitSound
    ldh a, [hPlayerForm]
    cp $04
    ld a, $0c
    jp z, PlaySound_Queue3

    ldh a, [hStageIndex]
    cp $03
    ld a, $04
    jp c, PlaySound_Queue3

    ld a, $08
    jp PlaySound_Queue3


UpdateGameState_FadeReturn::
    jp UpdateFadeReturnToGameplay

UpdateGameState_EndingDemo::
	; hGameState == 08
    ld hl, FARCALL_BANK1_UPDATE_ENDING_DEMO
    jp FarCallFromBankTable


InitCurrentGameState:: ; State init dispatcher, called with LCD off from ReinitCurrentState.
; hGameState init map, current understanding:
;   0 -> bank 2 title/menu init
;   1 -> debug menu init
;   2 -> bank 1 gameplay init
;   3 -> bank 2 screen init
;   4 -> bank 2 screen init
;   5 -> bank 2 screen init
;   6 -> no init
;   7 -> bank 1 gameplay init variant, then set wScreenPaletteId=$18
    ldh a, [hGameState]
    rst $00

    ; hGameState init jump table. rst $00 consumes these words as data.
    dw InitGameState_TitleMenu ; 00: bank 2 title/menu init
    dw InitGameState_DebugMenu ; 01: debug menu init
    dw InitGameState_Gameplay ; 02: bank 1 gameplay init
    dw InitGameState_Bank2Screen0 ; 03: bank 2 screen init
    dw InitGameState_Bank2Screen1 ; 04: bank 2 screen init
    dw InitGameState_Bank2Screen2 ; 05: bank 2 screen init
    dw InitGameState_NoInit ; 06: no init
    dw InitGameState_GameplayStage18Variant ; 07: bank 1 gameplay init variant
    dw InitGameState_EndingDemo ; 08: init stage 4 ending demo sequence

InitGameState_TitleMenu::
    ld hl, FARCALL_BANK2_INIT_TITLE_MENU
    jp FarCallFromBankTable


InitGameState_DebugMenu::
    jp LoadDebugMenu


InitGameState_Gameplay::
    ld hl, FARCALL_BANK1_INIT_GAMEPLAY
    jp FarCallFromBankTable


InitGameState_Bank2Screen0::
    ld hl, FARCALL_BANK2_INIT_MINIGAME
    jp FarCallFromBankTable


InitGameState_Bank2Screen1::
    ld hl, FARCALL_BANK2_INIT_STAGE_SCENE
    jp FarCallFromBankTable


InitGameState_Bank2Screen2::
    ld hl, FARCALL_BANK2_INIT_ENDING
    jp FarCallFromBankTable


InitGameState_NoInit::
    ret


InitGameState_GameplayStage18Variant::
    ld hl, FARCALL_BANK1_INIT_GAMEPLAY
    call FarCallFromBankTable
    ld a, $18
    ld [wScreenPaletteId], a
    ret


UpdateFadeReturnToGameplay::
    ld a, [wFadeReturnPhase]
    or a
    jr z, UpdateFadeReturnToGameplay_Start

    call UpdateTransitionFadeWithLateSgbPalSet
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    xor a
    ld [wFadeReturnPhase], a
    ld a, $02
    ldh [hGameState], a
    ret


UpdateFadeReturnToGameplay_Start::
    call UpdateTransitionFade
    ld a, [wFadeTransitionTimer]
    or a
    ret nz

    ld a, $40
    ld [wFadeTransitionTimer], a
    ld a, $01
    ld [wFadeReturnPhase], a
    ldh [hNeedsReset], a
    ret

InitGameState_EndingDemo::
    ld a, $04
    ldh [hStageIndex], a
    ld hl, FARCALL_BANK1_INIT_GAMEPLAY
    call FarCallFromBankTable
    ld hl, FARCALL_BANK1_INIT_ENDING_DEMO
    jp FarCallFromBankTable


ProjectPlayerWorldToScreen::
    ldh a, [hSCX]
    ld b, a
    ldh a, [hSCY]
    ld c, a
    ldh a, [hPlayerX]
    sub b
    ldh [hPlayerScreenX], a
    ldh a, [hPlayerY]
    sub c
    ldh [hPlayerScreenY], a
    ret


UpdateCameraAndStreamMap:: ; Gameplay camera/scroll update and BG map streaming.
    ldh a, [hCollisionFlag]
    cp $ff
    jr z, ProjectPlayerWorldToScreen

    xor a
    ldh [hCollisionFlag], a
    ldh a, [hPlayerScreenY]
    ld c, a
    ldh a, [hSCY]
    add c
    ld c, a
    ldh a, [hSCYHigh]
    adc $00
    ld b, a
    ld hl, hPlayerY
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call UpdateCameraScrollY
    ldh a, [hPlayerScreenX]
    ld c, a
    ldh a, [hSCX]
    add c
    ld c, a
    ldh a, [hSCXHigh]
    adc $00
    ld b, a
    ld hl, hPlayerX
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call UpdateCameraScrollX
    ldh a, [hCollisionFlag]
    rlca
    ret nc

    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, $04
    ld [rRomBankSelect], a
    ldh a, [hCollisionFlag]
    bit 6, a
    call nz, StreamBgColumnIfNeeded
    ldh a, [hCollisionFlag]
    bit 5, a
    call nz, StreamBgRowIfNeeded
    pop af
    ld [rRomBankSelect], a
    ret


QueueCurrentCameraBgRow::
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, $04
    ld [rRomBankSelect], a
    ldh a, [hSCY]
    ld e, a
    ldh a, [hSCYHigh]
    ld d, a
    call QueueBgRowForWorldY
    pop af
    ld [rRomBankSelect], a
    ret


UpdateCameraScrollX:: ; Adjust SCX toward player X, clamp to min/max, and request column streaming.
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc b
    ld h, a
    jp c, UpdateCameraScrollX_Left

    ld a, l
    or a
    ret z

    ld a, [wCameraScreenRightThreshold]
    ld b, a
    ld a, [wCameraScrollStepX]
    ld c, a
    ldh a, [hPlayerScreenX]
    add l
    ldh [hPlayerScreenX], a
    cp b
    ret c

    ret z

    ldh a, [hCollisionFlag]
    or $c0
    res 0, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, UpdateCameraScrollX_Right_ApplyStep

    ld a, c

UpdateCameraScrollX_Right_ApplyStep::
    ld b, a
    ld hl, wCameraScrollXMaxLo
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, hSCX
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    dec hl
    call CompareU16AtHLToDE
    jr nc, UpdateCameraScrollX_Right_ClampAtMaximum

    ld a, [wCameraScreenRightThreshold]
    ldh [hPlayerScreenX], a
    ret


UpdateCameraScrollX_Right_ClampAtMaximum::
    ld hl, wCameraScrollXMaxLo
    ld a, [hl+]
    ldh [hSCX], a
    ld a, [hl-]
    ldh [hSCXHigh], a
    ldh a, [hPlayerX]
    sub [hl]
    ldh [hPlayerScreenX], a
    ldh a, [hStageIndex]
    cp $02
    jr z, UpdateCameraScrollX_Right_CheckStage2Boss

    cp $01
    jr nz, UpdateCameraScrollX_Right_CheckGrounded

    ld a, [wStage1CameraProfileIndex]
    cp $02
    ret nz

UpdateCameraScrollX_Right_CheckGrounded::
    ldh a, [hPlayerState]
    or a
    ret nz

StartStageBossCountdownAtRightEdge:: ; Lock the stage end and let bank 1 run the boss intro countdown.
    ldh a, [hCollisionFlag]
    cp $ff
    ret z

    ld a, $ff
    ldh [hCollisionFlag], a
    ld a, $ff
    ld [wStageBossCountdown], a
    ld hl, wPlayerXMinLo
    ldh a, [hSCX]
    ld [hl+], a
    ldh a, [hSCXHigh]
    ld [hl+], a
    call InitSound
    ld a, $60
    jp PlaySound_Queue3


UpdateCameraScrollX_Right_CheckStage2Boss::
    ld a, [wStage2TransitionStep]
    cp $06
    jr z, StartStageBossCountdownAtRightEdge

    ret


UpdateCameraScrollX_Left:: ; Camera/player moved left of deadzone; scroll toward wCameraScrollXMin.
    ld a, l
    cpl
    inc a
    ld l, a
    ret z

    ld a, [wCameraScreenLeftThreshold]
    ld b, a
    ld a, [wCameraScrollStepX]
    ld c, a
    ldh a, [hPlayerScreenX]
    sub l
    ldh [hPlayerScreenX], a
    cp b
    ret nc

    ldh a, [hCollisionFlag]
    or $c0
    set 0, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, UpdateCameraScrollX_Left_ApplyStep

    ld a, c

UpdateCameraScrollX_Left_ApplyStep::
    ld b, a
    ld hl, wCameraScrollXMinLo
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, hSCX
    ld a, [hl]
    sub b
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr c, UpdateCameraScrollX_Left_ClampAtMinimum

    dec hl
    call CompareU16AtHLToDE
    jr c, UpdateCameraScrollX_Left_ClampAtMinimum

    ld a, [wCameraScreenLeftThreshold]
    ldh [hPlayerScreenX], a
    ret


UpdateCameraScrollX_Left_ClampAtMinimum::
    ld a, e
    ldh [hSCX], a
    ld a, d
    ldh [hSCXHigh], a
    ldh a, [hPlayerX]
    sub e
    ldh [hPlayerScreenX], a
    ret


UpdateCameraScrollY:: ; Adjust SCY toward player Y, clamp to 0/Y max, and request row streaming.
    ld a, l
    sub c
    ret z

    ld l, a
    ld a, h
    sbc b
    ld h, a
    jp c, UpdateCameraScrollY_Up

    ld a, [wCameraScreenBottomThreshold]
    ld b, a
    ld a, [wCameraScrollStepY]
    ld c, a
    ldh a, [hPlayerScreenY]
    add l
    ldh [hPlayerScreenY], a
    cp b
    ret c

    ret z

    ldh a, [hStageIndex]
    cp $02
    ret z

    ldh a, [hCollisionFlag]
    or $a0
    set 1, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, UpdateCameraScrollY_Down_ApplyStep

    ld a, c

UpdateCameraScrollY_Down_ApplyStep::
    ld b, a
    ld hl, wCameraScrollYMaxLo
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld hl, hSCY
    ld a, [hl]
    add b
    ld [hl+], a
    ld a, [hl]
    adc $00
    ld [hl], a
    dec hl
    call CompareU16AtHLToDE
    jr nc, UpdateCameraScrollY_Down_ClampAtMaximum

    ld a, [wCameraScreenBottomThreshold]
    ldh [hPlayerScreenY], a
    ret


UpdateCameraScrollY_Down_ClampAtMaximum::
    ld hl, wCameraScrollYMaxLo
    ld a, [hl+]
    ldh [hSCY], a
    ld a, [hl-]
    ldh [hSCYHigh], a
    ldh a, [hPlayerY]
    sub [hl]
    ldh [hPlayerScreenY], a
    ret


UpdateCameraScrollY_Up:: ; Camera/player moved above deadzone; scroll upward unless stage 2 overrides Y scrolling.
    ld a, [wCameraScreenTopThreshold]
    ld b, a
    ld a, [wCameraScrollStepY]
    ld c, a
    ld a, l
    cpl
    inc a
    ld l, a
    ldh a, [hPlayerScreenY]
    sub l
    ldh [hPlayerScreenY], a
    cp b
    ret nc

    ldh a, [hStageIndex]
    cp $02
    ret z

    ldh a, [hCollisionFlag]
    or $a0
    res 0, a
    ldh [hCollisionFlag], a
    ld a, l
    cp c
    jr c, UpdateCameraScrollY_Up_ApplyStep

    ld a, c

UpdateCameraScrollY_Up_ApplyStep::
    ld b, a
    ld hl, hSCY
    ld a, [hl]
    sub b
    ld [hl+], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr c, UpdateCameraScrollY_Up_ClampAtZero

    ld a, [wCameraScreenTopThreshold]
    ldh [hPlayerScreenY], a
    ret


UpdateCameraScrollY_Up_ClampAtZero::
    xor a
    ldh [hSCY], a
    ldh [hSCYHigh], a
    ldh a, [hPlayerY]
    ldh [hPlayerScreenY], a
    ret


StreamBgRow_ClearRequest::
    ldh a, [hCollisionFlag]
    cp $ff
    ret z

    ld hl, hCollisionFlag
    res 5, [hl]
    ret


StreamBgRowIfNeeded:: ; If vertical scroll crossed an 8px boundary, queue one BG row update.
    call GetStreamRowWorldY
    ldh a, [hStreamedRowY]
    and $f8
    ld b, a
    ld a, e
    and $f8
    cp b
    jr z, StreamBgRow_ClearRequest

    ldh [hStreamedRowY], a

QueueBgRowForWorldY:: ; Queue one 32-tile BG row for world Y in DE using current SCX.
    ld a, e
    and $f8
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld bc, _SCRN0
    add hl, bc
    ld b, h
    ld c, l
    call GetVramQueueTail
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
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ldh a, [hSCX]
    srl a
    srl a
    srl a
    ld c, a
    ld b, $00
    add hl, bc
    ldh a, [hSCXHigh]
    ld b, a
    ldh a, [hSCX]
    and $f8
    ld c, a
    ld a, $20
    ldh [hTileStreamCount], a
    ld a, l
    ldh [hTileStreamWritePos], a

QueueBgRow_LoadMetatile::
    push de
    call GetStageLayoutTileAtWorldPixel
    pop de

QueueBgRow_SelectQuadrant::
    ld a, [hl]
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    bit 3, c
    jr z, QueueBgRow_SelectVerticalHalf

    set 0, l

QueueBgRow_SelectVerticalHalf::
    bit 3, e
    jr z, QueueBgRow_StoreTile

    set 1, l

QueueBgRow_StoreTile::
    ldh a, [hStageMetatileTableLo]
    add l
    ld l, a
    ldh a, [hStageMetatileTableHi]
    adc h
    ld h, a
    ld a, [hl]
    ld hl, hTileStreamWritePos
    inc [hl]
    ld l, [hl]
    ld h, $c1
    dec hl
    ld [hl], a
    pop hl
    bit 3, c
    jr z, QueueBgRow_AdvanceWorldX

    inc hl

QueueBgRow_AdvanceWorldX::
    ldh a, [hTileStreamCount]
    dec a
    ldh [hTileStreamCount], a
    ret z

    ld a, $08
    add c
    ld c, a
    jr nc, QueueBgRow_SelectQuadrant

    inc b
    ldh a, [hTileStreamWritePos]
    sub $20
    ldh [hTileStreamWritePos], a
    jr QueueBgRow_LoadMetatile

StreamBgColumn_ClearRequest::
    ldh a, [hCollisionFlag]
    cp $ff
    ret z

    ld hl, hCollisionFlag
    res 6, [hl]
    ret


StreamBgColumnIfNeeded:: ; If horizontal scroll crossed an 8px boundary, queue one BG column update.
    call GetStreamColumnWorldX
    ldh a, [hStreamedColumnX]
    and $f8
    ld d, a
    ld a, c
    and $f8
    cp d
    jr z, StreamBgColumn_ClearRequest

    ldh [hStreamedColumnX], a

QueueBgColumnForWorldX:: ; Queue one 32-tile BG column for world X in BC using current SCY.
    call GetVramQueueTail
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
    ldh a, [hVramQueuePos]
    add $23
    ldh [hVramQueuePos], a
    ldh a, [hSCY]
    srl a
    srl a
    srl a
    ld e, a
    ld d, $00
    add hl, de
    ldh a, [hSCYHigh]
    ld d, a
    ldh a, [hSCY]
    and $f8
    ld e, a
    ld a, $20
    ldh [hTileStreamCount], a
    ld a, l
    ldh [hTileStreamWritePos], a

QueueBgColumn_LoadMetatile::
    push de
    call GetStageLayoutTileAtWorldPixel
    pop de

QueueBgColumn_SelectQuadrant::
    ld a, [hl]
    push hl
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    bit 3, c
    jr z, QueueBgColumn_SelectVerticalHalf

    set 0, l

QueueBgColumn_SelectVerticalHalf::
    bit 3, e
    jr z, QueueBgColumn_StoreTile

    set 1, l

QueueBgColumn_StoreTile::
    ldh a, [hStageMetatileTableLo]
    add l
    ld l, a
    ldh a, [hStageMetatileTableHi]
    adc h
    ld h, a
    ld a, [hl]
    ld hl, hTileStreamWritePos
    inc [hl]
    ld l, [hl]
    ld h, $c1
    dec hl
    ld [hl], a
    pop hl
    bit 3, e
    jr z, QueueBgColumn_AdvanceWorldY

    ld a, $10
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a

QueueBgColumn_AdvanceWorldY::
    ldh a, [hTileStreamCount]
    dec a
    ldh [hTileStreamCount], a
    ret z

    ld a, e
    add $08
    ld e, a
    jr nc, QueueBgColumn_SelectQuadrant

    inc d
    ldh a, [hTileStreamWritePos]
    sub $20
    ldh [hTileStreamWritePos], a
    jr QueueBgColumn_LoadMetatile

GetStageLayoutTileAtWorldPixel:: ; Return layout metatile id for world pixel coords BC=X, DE=Y.
                              ; Uses virtual page map at wStageLayoutPageHighTable: row*14+col -> physical page id.
    ld a, d
    or a
    jr z, GetStageLayoutTile_ReadPhysicalPage

    xor a

GetStageLayoutTile_ComputePageRow::
    add $0e
    dec d
    jr nz, GetStageLayoutTile_ComputePageRow

GetStageLayoutTile_ReadPhysicalPage::
    add b
    ld hl, wStageLayoutPageHighTable
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
    ld hl, wStageLayoutMap
    add hl, de
    ld a, [hl]
    ret


GetStreamColumnWorldX:: ; Return world X in BC for the column to stream, based on hCollisionFlag direction.
    ldh a, [hCollisionFlag]
    bit 0, a
    jr nz, GetStreamColumnWorldX_LeftEdge

    ldh a, [hSCX]
    add $e8
    ld c, a
    ldh a, [hSCXHigh]
    adc $00
    ld b, a
    ret


GetStreamColumnWorldX_LeftEdge::
    ldh a, [hSCX]
    ld c, a
    ldh a, [hSCXHigh]
    ld b, a
    ret


GetStreamRowWorldY:: ; Return world Y in DE for the row to stream, based on hCollisionFlag direction.
    ldh a, [hCollisionFlag]
    bit 1, a
    jr z, GetStreamRowWorldY_TopEdge

    ldh a, [hSCY]
    add $e8
    ld e, a
    ldh a, [hSCYHigh]
    adc $00
    ld d, a
    ret


GetStreamRowWorldY_TopEdge::
    ldh a, [hSCY]
    ld e, a
    ldh a, [hSCYHigh]
    ld d, a
    ret


RedrawVisibleBgMapColumns:: ; Rebuild visible BG map columns from current SCX/SCY, used after scroll/init.
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, $04
    ld [rRomBankSelect], a
    ld hl, hSCX
    ld a, [hl+]
    ld c, a
    ld b, [hl]
    xor a

RedrawVisibleBgMapColumns_NextColumn::
    push af
    push bc
    add c
    ld c, a
    ld a, $00
    adc b
    ld b, a
    call QueueBgColumnForWorldX
    ld de, wVramQueue
    call ProcessVramQueue_CheckNextCommand
    xor a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    pop bc
    pop af
    add $08
    jr nz, RedrawVisibleBgMapColumns_NextColumn

    call ApplyScrollRegs
    pop af
    ld [rRomBankSelect], a
    ret


InitGameplayHudAndWindow:: ; Initialize gameplay window/HUD; WY=$80 means bottom 16px is status area.
    call ClearBgMap1
    ld a, $07
    ldh [hWX], a
    ldh [rWX], a
    ld a, $80
    ldh [hWY], a
    ldh [rWY], a
    call QueueInitialHealthHud
    ld a, $df
    ld [_SCRN1 + $00b], a
    ld a, $e0
    ld [_SCRN1 + $02b], a
    ld de, HucIconLife
    ld hl, _SCRN1 + $00f
    ld bc, $0202
    call CopyTilemapRectToVram
    call QueuePlayerFormHudIcon
    call QueueBonusCounterHudDigits
    call QueueLivesHudDigits
    ld de, wVramQueue
    call ProcessVramQueue_CheckNextCommand
    xor a
    ld [wVramQueue], a
    ldh [hVramQueuePos], a
    ret

HucIconLife:
    db $e5, $e6, $e7, $e8

QueuePlayerFormHudIcon:: ; Queue 2x2 HUD icon for current player form.
    ldh a, [hPlayerForm]
    add a
    add a
    ld de, HudIconTileID
    rst $30
    ld hl, _SCRN1 + $008
    ld bc, $0202
    jp QueueTilemapRect

HudIconTileID:
    db $fa, $fb, $fc, $fd ;Empty
	db $d0, $d1, $d2, $d3 ;Flying squirrel
	db $dc, $dd, $d2, $de ;Cockroach
	db $d8, $d9, $da, $db ;Chicken
    db $d4, $d5, $d6, $d7 ;Action Kamen

QueueInitialHealthHud:: ; Draw initial health hearts during HUD init.
    ldh a, [hPlayerHealth]
    ldh [hTileStreamWritePos], a
    or a
    ret z

QueueInitialHealthHud_NextHeart::
    call QueueOneHealthHeartHudTile
    ldh a, [hTileStreamWritePos]
    dec a
    ldh [hTileStreamWritePos], a
    jr nz, QueueInitialHealthHud_NextHeart

    ret


QueueOneHealthHeartHudTile:: ; Queue one 2x2 heart tile group at the HUD position for health index.
    ldh a, [hTileStreamWritePos]
    dec a
    ld hl, HudHealthIconPos
    rst $20
    ld de, HudIconHealth
    ld bc, $0202
    jp CopyTilemapRectToVram


QueueHealthHudAfterGain:: ; Clear pending health-gain flag and redraw gained heart.
    ld a, [wPendingVramUpdates]
    res 0, a
    ld [wPendingVramUpdates], a
    ldh a, [hPlayerHealth]
    dec a
    ld hl, HudHealthIconPos
    rst $20
    ld de, HudIconHealth
    ld bc, $0202
    jp QueueTilemapRect

HudHealthIconPos::
    dw _SCRN1 + $001, _SCRN1 + $003, _SCRN1 + $005
HudIconHealth::
	db $e1, $e2, $e3, $e4
HudIconHealthEmpty::
	db $00, $00, $00, $00

QueueHealthHudAfterDamage:: ; Clear pending health-loss flag and redraw current health heart state.
    ld a, [wPendingVramUpdates]
    res 1, a
    ld [wPendingVramUpdates], a

QueueCurrentHealthHudTile:: ; Queue current health heart tile group.
    ldh a, [hPlayerHealth]
    ld hl, HudHealthIconPos
    rst $20
    ld de, HudIconHealthEmpty
    ld bc, $0202
    jp QueueTilemapRect


QueueBonusCounterHudDigits:: ; Queue two-digit bonus counter at HUD $9c2c.
    ld bc, _SCRN1 + $02c
    ldh a, [hBonusCounter]
    jr QueueHudTwoDecimalDigits

QueueLivesHudDigits:: ; Queue two-digit lives counter at HUD $9c31.
    ld bc, _SCRN1 + $031
    ldh a, [hPlayerLives]

QueueHudTwoDecimalDigits::
    ld d, a
    call GetVramQueueTail
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ld a, $02
    ld [hl+], a
    ld a, d
    push hl
    call SplitDecimalTensOnes
    pop hl
    ldh a, [hDecimalTens]
    call HudDigitToTileId
    ld [hl+], a
    ldh a, [hTileStreamWritePos]
    call HudDigitToTileId
    ld [hl+], a
    ld [hl], $00
    ldh a, [hVramQueuePos]
    add $05
    ldh [hVramQueuePos], a
    ret


HudDigitToTileId:: ; Convert decimal digit 0-9 to HUD tile id $f0-$f9.
    add $f0
    ret


AddBonusCounter:: ; Add A to hBonusCounter; 30 bonus points awards an extra life.
    ld hl, hBonusCounter
    add [hl]
    cp $1e
    jr nc, AddBonusCounter_AwardLife

AddBonusCounter_StoreAndDraw::
    ldh [hBonusCounter], a
    jp QueueBonusCounterHudDigits


AddBonusCounter_AwardLife::
    sub $1e
    call AddBonusCounter_StoreAndDraw
    jr AddExtraLife

    ld b, a
    ldh a, [hBonusCounter]
    sub b
    jr nc, AddBonusCounter_StoreAndDraw

    xor a
    jr AddBonusCounter_StoreAndDraw

AddPlayerHealth:: ; Add A to hPlayerHealth, capped at 3.
    ld a, [wPendingVramUpdates]
    set 0, a
    ld [wPendingVramUpdates], a
    ldh a, [hPlayerHealth]
    inc a
    cp $04
    jr c, AddPlayerHealth_StoreCappedValue

    ld a, $03

AddPlayerHealth_StoreCappedValue::
    ldh [hPlayerHealth], a
    ret


SubtractPlayerHealthAndMarkHudDirty:: ; Decrement health and request health HUD redraw.
    ld a, [wPendingVramUpdates]
    set 1, a
    ld [wPendingVramUpdates], a
    ldh a, [hPlayerHealth]
    dec a
    ldh [hPlayerHealth], a
    ret


AddExtraLife:: ; Award one extra life and update the HUD.
    ld a, $46
    call PlaySound_Queue1

IncrementPlayerLivesWithCap::
    ld hl, hPlayerLives
    inc [hl]
    ld a, [hl]
    cp $64
    jp c, QueueLivesHudDigits

    dec [hl]
    jp QueueLivesHudDigits


    ret


INCLUDE "engine/audio.asm"

EnterDebugMenu::
    ld a, [wAlternateModeFlags]
    and $04
    ld hl, hStageIndex
    add [hl]
    ld [wDebugStageSelection], a
    ld a, $01
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ret


UpdateDebugMenu::
    call HandleDebugMenuInput
    call DrawDebugMenuValues
    ret


DrawDebugMenuValues::
    call DrawDebugMenuCursor
    call DrawDebugStageNumber
    call DrawDebugCheckpointFlag
    call DrawDebugPlayerFlags
    call DrawDebugLives
    call DrawDebugPlayerForm
    call DrawDebugMusicIndex
    call DrawDebugSoundIndex
    ret


DrawDebugStageNumber::
    ld a, [wDebugStageSelection]
    add $f1
    ld hl, _SCRN0 + $06f
    jp QueueTilemapByte


DrawDebugCheckpointFlag::
    ld hl, _SCRN0 + $0ad
    ld de, DebugTextOff
    ld a, [wStageCheckpointActive]
    or a
    jp nz, QueueTextLine

    ld de, DebugTextOn
    jp QueueTextLine


DrawDebugPlayerFlags::
    ld hl, _SCRN0 + $0ed
    ld de, DebugTextOff
    ldh a, [hPlayerFlags]
    or a
    jp nz, QueueTextLine

    ld de, DebugTextOn
    jp QueueTextLine


DrawDebugLives::
    ld bc, _SCRN0 + $12e
    ldh a, [hPlayerLives]
    jp QueueHudTwoDecimalDigits


DrawDebugPlayerForm::
    ld bc, _SCRN0 + $14b
    ld de, $0005
    call QueueVramFill
    ld hl, DebugPlayerFormNameTable
    ldh a, [hPlayerForm]
    rst $20
    ld d, h
    ld e, l
    ld hl, _SCRN0 + $16b
    jp QueueTextLine


DebugPlayerFormNameTable::
    dw DebugTextFormNormal
    dw DebugTextFormFlyingSquirrel
    dw DebugTextFormCockroach
    dw DebugTextFormChicken
    dw DebugTextFormActionKamen

DrawDebugMusicIndex::
    ld bc, _SCRN0 + $1ae
    ld a, [wDebugMusicIndex]
    jp QueueHudTwoDecimalDigits


DrawDebugSoundIndex::
    ld bc, _SCRN0 + $1ee
    ld a, [wDebugSoundIndex]
    jp QueueHudTwoDecimalDigits


DrawDebugMenuCursor::
    ld bc, _SCRN0 + $063
    ld de, $000e
    call QueueVramFill_SetHighBit
    ld a, [wDebugCursorRow]
    ld c, $40
    call MultiplyBCByA8bit
    ld bc, _SCRN0 + $063
    add hl, bc
    ld a, $0e
    jp QueueTilemapByte


HandleDebugMenuInput::
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, DebugMenu_ResumeGameplay

    bit 3, a
    jr nz, DebugMenu_ResumeGameplay

    bit 7, a
    jr nz, DebugMenu_MoveCursorDown

    bit 6, a
    jr nz, DebugMenu_MoveCursorUp

    bit 5, a
    jr nz, DebugMenuLeftActionDispatch

    bit 4, a
    jp nz, DebugMenuRightActionDispatch

    ret


DebugMenu_MoveCursorDown::
    ld hl, wDebugCursorRow
    inc [hl]
    ld a, [hl]
    cp $07
    ret c

    ld [hl], $00
    ret


DebugMenu_MoveCursorUp::
    ld hl, wDebugCursorRow
    dec [hl]
    ld a, [hl]
    cp $ff
    ret nz

    ld [hl], $06
    ret


DebugMenu_ResumeGameplay::
    ld a, $03
    ld [wGameplayInitSubstate], a
    ld a, $02
    ldh [hGameState], a
    ldh [hNeedsReset], a
    ld hl, $0800
    ld a, l
    ld [wFormTimerLo], a
    ld a, h
    ld [wFormTimerHi], a
    xor a
    ld [wAlternateModeFlags], a
    ld a, [wDebugStageSelection]
    ld b, a
    and $03
    ldh [hStageIndex], a
    bit 2, b
    ret z

    ld a, $04
    ld [wAlternateModeFlags], a
    ret


DebugMenuLeftActionDispatch::
    ld a, [wDebugCursorRow]
    rst $00

DebugMenuLeftActionTable::
    dw DebugMenuActionDecStageIndex ; 00: stage index
    dw DebugMenuActionToggleStageFlag ; 01: $c0a8 toggle
    dw DebugMenuActionTogglePlayerFlags ; 02: hPlayerFlags toggle
    dw DebugMenuActionDecLives ; 03: player lives
    dw DebugMenuActionDecPlayerForm ; 04: player form
    dw DebugMenuActionDecMusic ; 05: music id
    dw DebugMenuActionDecSound ; 06: sound effect id

DebugMenuActionDecStageIndex::
    ld a, [wDebugStageSelection]
    dec a
    and $07
    ld [wDebugStageSelection], a
    ret


DebugMenuActionToggleStageFlag::
    ld a, [wStageCheckpointActive]
    xor $ff
    ld [wStageCheckpointActive], a
    ret


DebugMenuActionTogglePlayerFlags::
    ldh a, [hPlayerFlags]
    xor $ff
    ldh [hPlayerFlags], a
    ret


DebugMenuActionDecLives::
    ldh a, [hPlayerLives]
    sub $01
    ldh [hPlayerLives], a
    ret nc

    ld a, $63
    ldh [hPlayerLives], a
    ret


DebugMenuActionDecPlayerForm::
    ldh a, [hPlayerForm]
    sub $01
    ldh [hPlayerForm], a
    ret nc

    ld a, $04
    ldh [hPlayerForm], a
    ret


DebugMenuActionDecMusic::
    call InitSound
    call DebugMenu_DecrementMusicIndex
    ld hl, DebugMenuMusicIdTable
    rst $38
    ld a, [hl]

DebugMenu_PlayMusicId::
    call PlaySound_Queue3
    ret


DebugMenu_DecrementMusicIndex::
    ld a, [wDebugMusicIndex]
    sub $01
    ld [wDebugMusicIndex], a
    ret nc

    ld a, $14
    ld [wDebugMusicIndex], a
    ret


DebugMenuActionDecSound::
    call DebugMenu_DecrementSoundIndex
    jp PlayDebugSelectedSound


DebugMenu_DecrementSoundIndex::
    ld a, [wDebugSoundIndex]

DebugMenu_DecrementSoundIndex_Apply::
    sub $01
    ld [wDebugSoundIndex], a
    ret nc

    ld a, $1e
    ld [wDebugSoundIndex], a
    ret


DebugMenuRightActionDispatch::
    ld a, [wDebugCursorRow]
    rst $00

DebugMenuRightActionTable::
    dw DebugMenuActionIncStageIndex ; 00: stage index
    dw DebugMenuActionToggleStageFlag ; 01: $c0a8 toggle
    dw DebugMenuActionTogglePlayerFlags ; 02: hPlayerFlags toggle
    dw DebugMenuActionIncLives ; 03: player lives
    dw DebugMenuActionIncPlayerForm ; 04: player form
    dw DebugMenuActionIncMusic ; 05: music id
    dw DebugMenuActionIncSound ; 06: sound effect id

DebugMenuActionIncStageIndex::
    ld a, [wDebugStageSelection]
    inc a
    and $07
    ld [wDebugStageSelection], a
    ret


DebugMenuActionIncLives::
    ldh a, [hPlayerLives]
    inc a
    ldh [hPlayerLives], a
    cp $64
    ret c

    xor a
    ldh [hPlayerLives], a
    ret


DebugMenuActionIncPlayerForm::
    ldh a, [hPlayerForm]
    inc a
    ldh [hPlayerForm], a
    cp $05
    ret c

    xor a
    ldh [hPlayerForm], a
    ret


DebugMenuActionIncMusic::
    call InitSound
    call PlaySound_Queue3
    call DebugMenuActionResetMusicId
    ld hl, DebugMenuMusicIdTable
    rst $38
    ld a, [hl]
    call PlaySound_Queue3
    ret


DebugMenuMusicIdTable::
    db $00, $04, $08, $0c, $10, $14, $1c, $20
    db $24, $28, $2c, $30, $34, $38, $3c, $60
    db $64, $18, $18, $18, $18, $18, $18, $18
    db $18, $18, $18, $18, $18, $18, $18, $18

DebugMenuActionResetMusicId::
    ld a, [wDebugMusicIndex]
    inc a
    ld [wDebugMusicIndex], a
    cp $15
    ret c

    xor a

DebugMenu_StoreMusicIndex::
    ld [wDebugMusicIndex], a
    ret


DebugMenuActionIncSound::
    call DebugMenu_IncrementSoundIndex

PlayDebugSelectedSound::
    ld hl, DebugMenuSoundDispatchTable

PlayDebugSelectedSound_Dispatch::
    ld a, [wDebugSoundIndex]
    rst $20
    ld a, l
    dec h
    jp z, PlaySound

    dec h
    jp z, PlaySound_Queue1

    dec h
    jp z, PlaySound_Queue2

    jp PlaySound_Queue3


DebugMenuSoundDispatchTable:: ; high byte selects PlaySound/queue helper; low byte is sound id.
    dw $0140, $0141, $0142, $0143, $0144, $0145, $0246, $0148
    dw $0249, $014b, $014c, $014d, $014e, $014f, $0150, $0151
    dw $0152, $0153, $0154, $0455, $0159, $015a, $015b, $015c
    dw $015d, $025e, $0140, $0140

DebugMenu_IncrementSoundIndex::
    ld a, [wDebugSoundIndex]
    inc a
    ld [wDebugSoundIndex], a
    cp $1f
    ret c

    xor a
    ld [wDebugSoundIndex], a
    ret


LoadDebugMenu::
    xor a
IF DEF(DEBUG)
    call DebugMenu_InitBackgroundGfx
    xor a
ELSE
    ldh [hNeedsReset], a
    ldh [hSCX], a
ENDC
    ldh [hSCY], a
    ldh [hPlayerFlags], a
    ld a, BANK(GfxRle_b06_4bc0)
    ld hl, GfxRle_b06_4bc0
    ld de, _VRAM + $1000
    call LoadMaskedGfx
    call ClearBgMap0
    ld hl, _SCRN0 + $064
    ld de, DebugTextStage
    call CopyTextLineToVram
    ld hl, _SCRN0 + $0a4
    ld de, DebugTextFlagA
    call CopyTextLineToVram
    ld hl, _SCRN0 + $0e4
    ld de, DebugTextFlagB
    call CopyTextLineToVram
    ld hl, _SCRN0 + $124
    ld de, DebugTextLives
    call CopyTextLineToVram
    ld hl, _SCRN0 + $164
    ld de, DebugTextForm
    call CopyTextLineToVram
    ld hl, _SCRN0 + $1a4
    ld de, DebugTextMusic
    call CopyTextLineToVram
    ld hl, _SCRN0 + $1e4
    ld de, DebugTextSound
    call CopyTextLineToVram
    ld hl, wPaletteBGP
    ld [hl], $e4
    ld a, $83
    ld [wLCDCShadow], a
    ret


INCLUDE "text/debug_menu.asm"

SpriteAnimPointerTable_1a19::
    ; Large animation pointer table. Entries point either to nested pointer tables or sprite frame data.
    dw SpriteAnimPointerTable_1a23, SpriteAnimPointerTable_1a4f, SpriteAnimPointerTable_1a83, SpriteAnimPointerTable_1abf, SpriteAnimPointerTable_1af3

SpriteAnimPointerTable_1a23::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_2a7f, SpriteFrameData_2a98, SpriteFrameData_2ab1, SpriteFrameData_2aca
    dw SpriteFrameData_2ae3, SpriteFrameData_2afc, SpriteFrameData_2b1d, SpriteFrameData_2b3e, SpriteFrameData_2b5b, SpriteFrameData_2b6c, SpriteFrameData_2b7d, SpriteFrameData_2b92
    dw SpriteFrameData_2baf, SpriteFrameData_2bc8, SpriteFrameData_2be1, SpriteFrameData_2bf6, SpriteFrameData_2c0f, SpriteFrameData_2c28

SpriteAnimPointerTable_1a4f::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_2cb9, SpriteFrameData_2cd6, SpriteFrameData_2cf3, SpriteFrameData_2d10
    dw SpriteFrameData_2d10, SpriteFrameData_2d2d, SpriteFrameData_2d52, SpriteFrameData_2d77, SpriteFrameData_2d98, SpriteFrameData_2d98, SpriteFrameData_2da9, SpriteFrameData_2dc6
    dw SpriteFrameData_2de3, SpriteFrameData_2dfc, SpriteFrameData_2e15, SpriteFrameData_2e2e, SpriteFrameData_2e47, SpriteFrameData_2e60, SpriteFrameData_2e79, SpriteFrameData_2ea0
    dw SpriteFrameData_2ebd, SpriteFrameData_2c28

SpriteAnimPointerTable_1a83::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_3321, SpriteFrameData_333a, SpriteFrameData_333a, SpriteFrameData_333a
    dw SpriteFrameData_3353, SpriteFrameData_3364, SpriteFrameData_337d, SpriteFrameData_3396, SpriteFrameData_33ab, SpriteFrameData_33ab, SpriteFrameData_33ab, SpriteFrameData_33c4
    dw SpriteFrameData_33dd, SpriteFrameData_33f6, SpriteFrameData_340f, SpriteFrameData_3428, SpriteFrameData_3441, SpriteFrameData_345a, SpriteFrameData_347b, SpriteFrameData_34a0
    dw SpriteFrameData_34c5, SpriteFrameData_34e6, SpriteFrameData_350b, SpriteFrameData_3530, SpriteFrameData_3551, SpriteFrameData_2c28

SpriteAnimPointerTable_1abf::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_2f2e, SpriteFrameData_2f4b, SpriteFrameData_2f4b, SpriteFrameData_2f4b
    dw SpriteFrameData_2f68, SpriteFrameData_2f85, SpriteFrameData_2fa6, SpriteFrameData_2fc7, SpriteFrameData_2fe4, SpriteFrameData_2fe4, SpriteFrameData_3012, SpriteFrameData_2ff5
    dw SpriteFrameData_302f, SpriteFrameData_3048, SpriteFrameData_3061, SpriteFrameData_3076, SpriteFrameData_308f, SpriteFrameData_30e7, SpriteFrameData_3104, SpriteFrameData_30a8
    dw SpriteFrameData_30c5, SpriteFrameData_2c28

SpriteAnimPointerTable_1af3::
    dw SpriteFrameData_2a2b, SpriteFrameData_2a44, SpriteFrameData_2a5d, SpriteFrameData_2a72, SpriteFrameData_3121, SpriteFrameData_313a, SpriteFrameData_3153, SpriteFrameData_316c
    dw SpriteFrameData_316c, SpriteFrameData_3185, SpriteFrameData_31a6, SpriteFrameData_31c7, SpriteFrameData_31e4, SpriteFrameData_31e4, SpriteFrameData_31f5, SpriteFrameData_320a
    dw SpriteFrameData_3227, SpriteFrameData_3240, SpriteFrameData_3259, SpriteFrameData_326e, SpriteFrameData_3287, SpriteFrameData_32a0, SpriteFrameData_32fc, SpriteFrameData_32b9
    dw SpriteFrameData_2c28

SpriteStageAnimPointerTable_1b25:: ; Stage-indexed table used by bank 1 object sprite drawing.
    dw SpriteAnimPointerTable_1b2d, SpriteAnimPointerTable_1b61, SpriteAnimPointerTable_1b99, SpriteAnimPointerTable_1bd1

SpriteAnimPointerTable_1b2d::
    dw SpriteFrameData_1c11, SpriteFrameData_1c2a, SpriteFrameData_1c43, SpriteFrameData_1c5c, SpriteFrameData_1c11, SpriteFrameData_1c11, SpriteFrameData_1c75, SpriteFrameData_1c92
    dw SpriteFrameData_1caf, SpriteFrameData_1ccc, SpriteFrameData_1ce9, SpriteFrameData_1d0a, SpriteFrameData_1d23, SpriteFrameData_1d50, SpriteFrameData_1d7d, SpriteFrameData_1daa
    dw SpriteFrameData_2497, SpriteFrameData_24bc, SpriteFrameData_24e1, SpriteFrameData_24ea, SpriteFrameData_24f3, SpriteFrameData_24fc, SpriteFrameData_251d, SpriteFrameData_253a
    dw SpriteFrameData_255b, SpriteFrameData_257c

SpriteAnimPointerTable_1b61::
    dw SpriteFrameData_1f19, SpriteFrameData_1f3a, SpriteFrameData_1f5b, SpriteFrameData_1f7c, SpriteFrameData_1f99, SpriteFrameData_1fa2, SpriteFrameData_1dc7, SpriteFrameData_1de4
    dw SpriteFrameData_1e01, SpriteFrameData_1e1e, SpriteFrameData_1e3b, SpriteFrameData_1e5c, SpriteFrameData_1e75, SpriteFrameData_1ea2, SpriteFrameData_1ecf, SpriteFrameData_1efc
    dw SpriteFrameData_1fbf, SpriteFrameData_1fd0, SpriteFrameData_1fe1, SpriteFrameData_1ff2, SpriteFrameData_259d, SpriteFrameData_25be, SpriteFrameData_25df, SpriteFrameData_2600
    dw SpriteFrameData_2625, SpriteFrameData_2646, SpriteFrameData_2663, SpriteFrameData_2684

SpriteAnimPointerTable_1b99::
    dw SpriteFrameData_209f, SpriteFrameData_20c0, SpriteFrameData_20e1, SpriteFrameData_2102, SpriteFrameData_211f, SpriteFrameData_2128, SpriteFrameData_1ffb, SpriteFrameData_1ffb
    dw SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_1ffb, SpriteFrameData_2028, SpriteFrameData_2055, SpriteFrameData_2082
    dw SpriteFrameData_2145, SpriteFrameData_215e, SpriteFrameData_2177, SpriteFrameData_2190, SpriteFrameData_21ad, SpriteFrameData_26a5, SpriteFrameData_26da, SpriteFrameData_270f
    dw SpriteFrameData_2740, SpriteFrameData_2771, SpriteFrameData_27aa, SpriteFrameData_27df

SpriteAnimPointerTable_1bd1::
    dw SpriteFrameData_2346, SpriteFrameData_2367, SpriteFrameData_2388, SpriteFrameData_23a9, SpriteFrameData_23c6, SpriteFrameData_23cf, SpriteFrameData_2298, SpriteFrameData_22b5
    dw SpriteFrameData_22d2, SpriteFrameData_22ef, SpriteFrameData_230c, SpriteFrameData_232d, SpriteFrameData_2298, SpriteFrameData_2298, SpriteFrameData_2298, SpriteFrameData_2298
    dw SpriteFrameData_23ec, SpriteFrameData_2405, SpriteFrameData_241e, SpriteFrameData_2437, SpriteFrameData_2454, SpriteFrameData_27e4, SpriteFrameData_2821, SpriteFrameData_285e
    dw SpriteFrameData_2893, SpriteFrameData_28cc, SpriteFrameData_2909, SpriteFrameData_293e, SpriteFrameData_2973, SpriteFrameData_29ac, SpriteFrameData_29e9, SpriteFrameData_2a26

SpriteFrameData_1c11::
    db $eb, $f8, $70, $00, $eb, $00, $71, $00, $f3, $f8, $72, $00, $f3, $00, $73, $00
    db $fb, $f8, $7e, $00, $fb, $00, $7f, $00, $80

SpriteFrameData_1c2a::
    db $ec, $f8, $70, $00, $ec, $00, $71, $00, $f4, $f8, $74, $00, $f4, $00, $75, $00
    db $fc, $f8, $80, $00, $fc, $00, $81, $00, $80

SpriteFrameData_1c43::
    db $ec, $f8, $70, $00, $ec, $00, $71, $00, $f4, $f8, $76, $00, $f4, $00, $77, $00
    db $fc, $f8, $82, $00, $fc, $00, $83, $00, $80

SpriteFrameData_1c5c::
    db $ef, $f8, $78, $00, $ef, $00, $79, $00, $f7, $f8, $7a, $00, $f7, $00, $7b, $00
    db $f7, $08, $7c, $00, $ff, $ff, $7d, $00, $80

SpriteFrameData_1c75::
    db $eb, $f8, $84, $00, $eb, $00, $85, $00, $f3, $f8, $86, $00, $f3, $00, $87, $00
    db $f1, $08, $89, $00, $fb, $f7, $88, $00, $fb, $ff, $7f, $00, $80

SpriteFrameData_1c92::
    db $ec, $f8, $84, $00, $ec, $00, $85, $00, $f4, $f8, $8a, $00, $f4, $00, $8b, $00
    db $f2, $08, $89, $00, $fc, $f8, $80, $00, $fc, $00, $81, $00, $80

SpriteFrameData_1caf::
    db $ec, $f8, $84, $00, $ec, $00, $85, $00, $f4, $f8, $8c, $00, $f4, $00, $8d, $00
    db $f2, $08, $89, $00, $fc, $f8, $82, $00, $fc, $00, $83, $00, $80

SpriteFrameData_1ccc::
    db $eb, $f8, $84, $00, $eb, $00, $85, $00, $f3, $f8, $86, $00, $f3, $00, $87, $00
    db $f1, $08, $89, $00, $fb, $f8, $8e, $00, $fb, $00, $8f, $00, $80

SpriteFrameData_1ce9::
    db $eb, $f9, $84, $00, $eb, $01, $85, $00, $f3, $f9, $90, $00, $f3, $01, $87, $00
    db $f3, $09, $91, $00, $f2, $11, $92, $00, $fb, $f9, $8f, $20, $fb, $00, $8f, $00
    db $80

SpriteFrameData_1d0a::
    db $ee, $f8, $93, $00, $ee, $00, $94, $00, $f6, $f8, $95, $00, $f6, $00, $96, $00
    db $fe, $f8, $97, $00, $fe, $00, $98, $00, $80

SpriteFrameData_1d23::
    db $e0, $f8, $99, $00, $e0, $00, $9a, $00, $e0, $08, $9b, $00, $e0, $10, $9c, $00
    db $e8, $f8, $9d, $00, $e8, $00, $9e, $00, $e8, $08, $9f, $00, $f0, $f8, $a0, $00
    db $f0, $00, $a1, $00, $f8, $f8, $a2, $00, $f8, $00, $a3, $00, $80

SpriteFrameData_1d50::
    db $e1, $f8, $99, $00, $e1, $00, $9a, $00, $e1, $08, $9b, $00, $e1, $10, $9c, $00
    db $e9, $f8, $9d, $00, $e9, $00, $9e, $00, $e9, $08, $9f, $00, $f1, $f8, $a0, $00
    db $f1, $00, $a1, $00, $f9, $f8, $a4, $00, $f9, $00, $a5, $00, $80

SpriteFrameData_1d7d::
    db $e1, $f8, $99, $00, $e1, $00, $9a, $00, $e1, $08, $9b, $00, $e1, $10, $9c, $00
    db $e9, $f8, $9d, $00, $e9, $00, $9e, $00, $e9, $08, $9f, $00, $f1, $f8, $a0, $00
    db $f1, $00, $a1, $00, $f9, $f8, $a6, $00, $f9, $00, $a7, $00, $80

SpriteFrameData_1daa::
    db $e8, $f8, $a8, $00, $e8, $00, $a9, $00, $f0, $f7, $aa, $00, $f0, $ff, $ab, $00
    db $f8, $f8, $ac, $00, $f8, $00, $ad, $00, $f8, $08, $ae, $00, $80

SpriteFrameData_1dc7::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f7, $79, $00, $fb, $ff, $70, $00, $80

SpriteFrameData_1de4::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7b, $00, $f4, $00, $7c, $00
    db $f2, $08, $7a, $00, $fc, $f8, $71, $00, $fc, $00, $72, $00, $80

SpriteFrameData_1e01::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7d, $00, $f4, $00, $7e, $00
    db $f2, $08, $7a, $00, $fc, $f8, $73, $00, $fc, $00, $74, $00, $80

SpriteFrameData_1e1e::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f8, $7f, $00, $fb, $00, $80, $00, $80

SpriteFrameData_1e3b::
    db $eb, $f9, $75, $00, $eb, $01, $76, $00, $f3, $f9, $81, $00, $f3, $01, $78, $00
    db $f3, $09, $82, $00, $f2, $11, $83, $00, $fb, $f9, $80, $20, $fb, $00, $80, $00
    db $80

SpriteFrameData_1e5c::
    db $ee, $f8, $84, $00, $ee, $00, $85, $00, $f6, $f8, $86, $00, $f6, $00, $87, $00
    db $fe, $f8, $88, $00, $fe, $00, $89, $00, $80

SpriteFrameData_1e75::
    db $e0, $f8, $8a, $00, $e0, $00, $8b, $00, $e0, $08, $8c, $00, $e0, $10, $8d, $00
    db $e8, $f8, $8e, $00, $e8, $00, $8f, $00, $e8, $08, $90, $00, $f0, $f8, $91, $00
    db $f0, $00, $92, $00, $f8, $f8, $93, $00, $f8, $00, $94, $00, $80

SpriteFrameData_1ea2::
    db $e1, $f8, $8a, $00, $e1, $00, $8b, $00, $e1, $08, $8c, $00, $e1, $10, $8d, $00
    db $e9, $f8, $8e, $00, $e9, $00, $8f, $00, $e9, $08, $90, $00, $f1, $f8, $91, $00
    db $f1, $00, $92, $00, $f9, $f8, $95, $00, $f9, $00, $96, $00, $80

SpriteFrameData_1ecf::
    db $e1, $f8, $8a, $00, $e1, $00, $8b, $00, $e1, $08, $8c, $00, $e1, $10, $8d, $00
    db $e9, $f8, $8e, $00, $e9, $00, $8f, $00, $e9, $08, $90, $00, $f1, $f8, $91, $00
    db $f1, $00, $92, $00, $f9, $f8, $97, $00, $f9, $00, $98, $00, $80

SpriteFrameData_1efc::
    db $e8, $f8, $99, $00, $e8, $00, $9a, $00, $f0, $f7, $9b, $00, $f0, $ff, $9c, $00
    db $f8, $f8, $9d, $00, $f8, $00, $9e, $00, $f8, $08, $9f, $00, $80

SpriteFrameData_1f19::
    db $e8, $f8, $ab, $00, $e8, $00, $ac, $00, $e8, $08, $ad, $00, $f0, $f8, $ae, $00
    db $f0, $00, $af, $00, $f0, $08, $b0, $00, $f8, $f8, $b1, $00, $f8, $00, $b2, $00
    db $80

SpriteFrameData_1f3a::
    db $e9, $f8, $ab, $00, $e9, $00, $ac, $00, $e9, $08, $ad, $00, $f1, $f8, $b3, $00
    db $f1, $00, $af, $00, $f1, $08, $b0, $00, $f9, $f8, $b4, $00, $f9, $00, $b5, $00
    db $80

SpriteFrameData_1f5b::
    db $e9, $f8, $ab, $00, $e9, $00, $ac, $00, $e9, $08, $ad, $00, $f1, $f8, $b6, $00
    db $f1, $00, $b7, $00, $f1, $08, $b0, $00, $f9, $f8, $b8, $00, $f9, $00, $b9, $00
    db $80

SpriteFrameData_1f7c::
    db $e8, $fa, $ab, $00, $e8, $02, $ba, $00, $f0, $f9, $bb, $00, $f0, $01, $bc, $00
    db $f0, $09, $bd, $00, $f8, $f9, $a0, $00, $f8, $01, $a1, $00, $80

SpriteFrameData_1f99::
    db $f8, $f4, $a2, $00, $f8, $fc, $a3, $00, $80

SpriteFrameData_1fa2::
    db $ec, $fc, $a4, $00, $ec, $04, $a5, $00, $f4, $f4, $a6, $00, $f4, $fc, $a7, $00
    db $f4, $04, $a8, $00, $fc, $fb, $a9, $00, $fc, $03, $aa, $00, $80

SpriteFrameData_1fbf::
    db $f8, $f8, $be, $10, $f8, $00, $c4, $10, $00, $f8, $bf, $10, $00, $00, $c0, $10
    db $80

SpriteFrameData_1fd0::
    db $f7, $f8, $c1, $10, $f7, $00, $c1, $30, $ff, $f8, $c2, $10, $ff, $00, $c3, $10
    db $80

SpriteFrameData_1fe1::
    db $f0, $f8, $c5, $10, $f0, $00, $c6, $10, $f8, $f8, $c7, $10, $f8, $00, $c8, $10
    db $80

SpriteFrameData_1ff2::
    db $f8, $f8, $c9, $10, $f8, $00, $c9, $30, $80

SpriteFrameData_1ffb::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e0, $08, $72, $00, $e0, $10, $73, $00
    db $e8, $f8, $74, $00, $e8, $00, $75, $00, $e8, $08, $76, $00, $f0, $f8, $77, $00
    db $f0, $00, $78, $00, $f8, $f8, $79, $00, $f8, $00, $7a, $00, $80

SpriteFrameData_2028::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e1, $08, $72, $00, $e1, $10, $73, $00
    db $e9, $f8, $74, $00, $e9, $00, $75, $00, $e9, $08, $76, $00, $f1, $f8, $77, $00
    db $f1, $00, $78, $00, $f9, $f8, $7b, $00, $f9, $00, $7c, $00, $80

SpriteFrameData_2055::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e1, $08, $72, $00, $e1, $10, $73, $00
    db $e9, $f8, $74, $00, $e9, $00, $75, $00, $e9, $08, $76, $00, $f1, $f8, $77, $00
    db $f1, $00, $78, $00, $f9, $f8, $7d, $00, $f9, $00, $7e, $00, $80

SpriteFrameData_2082::
    db $e8, $f8, $7f, $00, $e8, $00, $80, $00, $f0, $f7, $81, $00, $f0, $ff, $82, $00
    db $f8, $f8, $83, $00, $f8, $00, $84, $00, $f8, $08, $85, $00, $80

SpriteFrameData_209f::
    db $e8, $f8, $91, $00, $e8, $00, $92, $00, $e8, $08, $93, $00, $f0, $f8, $94, $00
    db $f0, $00, $95, $00, $f0, $08, $96, $00, $f8, $f8, $97, $00, $f8, $00, $98, $00
    db $80

SpriteFrameData_20c0::
    db $e9, $f8, $91, $00, $e9, $00, $92, $00, $e9, $08, $93, $00, $f1, $f8, $99, $00
    db $f1, $00, $95, $00, $f1, $08, $96, $00, $f9, $f8, $9a, $00, $f9, $00, $9b, $00
    db $80

SpriteFrameData_20e1::
    db $e9, $f8, $91, $00, $e9, $00, $92, $00, $e9, $08, $93, $00, $f1, $f8, $9c, $00
    db $f1, $00, $9d, $00, $f1, $08, $96, $00, $f9, $f8, $9e, $00, $f9, $00, $9f, $00
    db $80

SpriteFrameData_2102::
    db $e8, $fa, $91, $00, $e8, $02, $a0, $00, $f0, $f9, $a1, $00, $f0, $01, $a2, $00
    db $f0, $09, $a3, $00, $f8, $f9, $86, $00, $f8, $01, $87, $00, $80

SpriteFrameData_211f::
    db $f8, $f4, $88, $00, $f8, $fc, $89, $00, $80

SpriteFrameData_2128::
    db $ec, $fc, $8a, $00, $ec, $04, $8b, $00, $f4, $f4, $8c, $00, $f4, $fc, $8d, $00
    db $f4, $04, $8e, $00, $fc, $fb, $8f, $00, $fc, $03, $90, $00, $80

SpriteFrameData_2145::
    db $e8, $f8, $af, $00, $e8, $00, $b0, $00, $f0, $f8, $b1, $00, $f0, $00, $b2, $00
    db $f8, $f8, $b3, $00, $f8, $00, $b4, $00, $80

SpriteFrameData_215e::
    db $e9, $f8, $af, $00, $e9, $00, $b0, $00, $f1, $f8, $b5, $00, $f1, $00, $b6, $00
    db $f9, $f8, $b7, $00, $f9, $00, $b8, $00, $80

SpriteFrameData_2177::
    db $e9, $f8, $af, $00, $e9, $00, $b0, $00, $f1, $f8, $b9, $00, $f1, $00, $ba, $00
    db $f9, $f8, $bb, $00, $f9, $00, $bc, $00, $80

SpriteFrameData_2190::
    db $ed, $f8, $bd, $00, $ed, $00, $be, $00, $f5, $f8, $bf, $00, $f5, $00, $a4, $00
    db $f5, $08, $a5, $00, $fd, $f8, $a6, $00, $fd, $00, $a7, $00, $80

SpriteFrameData_21ad::
    db $ed, $f8, $bd, $00, $ed, $00, $a8, $00, $f5, $f8, $a9, $00, $f5, $00, $aa, $00
    db $f5, $08, $ab, $00, $fd, $f8, $ac, $00, $fd, $00, $ad, $00, $fd, $08, $ae, $00
    db $80

SpriteFrameData_21ce:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $d8, $ec, $c0, $00, $e0, $ec, $c1, $00, $e0, $f4, $c2, $00, $e0, $fc, $c3
    db $00, $e0, $04, $c4, $00, $e8, $f4, $c5, $00, $e8, $fc, $c6, $00, $e8, $04, $c7
    db $00, $f0, $f4, $cd, $00, $f8, $f4, $c8, $00, $f8, $fc, $c9, $00, $f8, $04, $ca
    db $00, $80

SpriteFrameData_21ff:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $d9, $ec, $c0, $00, $e1, $ec, $c1, $00, $e1, $f4, $c2, $00, $e1, $fc
    db $c3, $00, $e1, $04, $c4, $00, $e9, $f4, $c5, $00, $e9, $fc, $c6, $00, $e9, $04
    db $c7, $00, $f1, $f4, $cd, $00, $f9, $f4, $cb, $00, $f9, $fc, $c9, $00, $f9, $04
    db $cc, $00, $80

SpriteFrameData_2230:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fc, $c0, $10, $80

SpriteFrameData_2235:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fc, $c1, $10, $80

SpriteFrameData_223a:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fc, $c2, $10, $80

SpriteFrameData_223f:: ; Object type $1f small frame, direct bank 1 xref.
    db $f8, $fb, $c0, $10, $80

SpriteFrameData_2244:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c3, $00, $f0, $00, $c4, $00, $f8
    db $f8, $c5, $00, $f8, $00, $c6, $00, $80

SpriteFrameData_2255:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c4, $20, $f0, $00, $c3, $20
    db $f8, $f8, $c6, $20, $f8, $00, $c5, $20, $80

SpriteFrameData_2266:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f2, $f8, $c5, $40, $f2, $00, $c6
    db $40, $fa, $f8, $c3, $40, $fa, $00, $c4, $40, $80

SpriteFrameData_2277:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $e8, $f4, $c7, $00, $e8, $fc
    db $c8, $00, $e8, $04, $c7, $20, $f0, $f4, $c9, $00, $f0, $fc, $ca, $00, $f0, $04
    db $c9, $20, $f8, $f8, $cb, $00, $f8, $00, $cc, $00, $80

SpriteFrameData_2298::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f7, $79, $00, $fb, $ff, $70, $00, $80

SpriteFrameData_22b5::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7b, $00, $f4, $00, $7c, $00
    db $f2, $08, $7a, $00, $fc, $f8, $71, $00, $fc, $00, $72, $00, $80

SpriteFrameData_22d2::
    db $ec, $f8, $75, $00, $ec, $00, $76, $00, $f4, $f8, $7d, $00, $f4, $00, $7e, $00
    db $f2, $08, $7a, $00, $fc, $f8, $73, $00, $fc, $00, $74, $00, $80

SpriteFrameData_22ef::
    db $eb, $f8, $75, $00, $eb, $00, $76, $00, $f3, $f8, $77, $00, $f3, $00, $78, $00
    db $f1, $08, $7a, $00, $fb, $f8, $7f, $00, $fb, $00, $80, $00, $80

SpriteFrameData_230c::
    db $eb, $f9, $75, $00, $eb, $01, $76, $00, $f3, $f9, $81, $00, $f3, $01, $78, $00
    db $f3, $09, $82, $00, $f2, $11, $83, $00, $fb, $f9, $80, $20, $fb, $00, $80, $00
    db $80

SpriteFrameData_232d::
    db $ee, $f8, $84, $00, $ee, $00, $85, $00, $f6, $f8, $86, $00, $f6, $00, $87, $00
    db $fe, $f8, $88, $00, $fe, $00, $89, $00, $80

SpriteFrameData_2346::
    db $e8, $f8, $95, $00, $e8, $00, $96, $00, $e8, $08, $97, $00, $f0, $f8, $98, $00
    db $f0, $00, $99, $00, $f0, $08, $9a, $00, $f8, $f8, $9b, $00, $f8, $00, $9c, $00
    db $80

SpriteFrameData_2367::
    db $e9, $f8, $95, $00, $e9, $00, $96, $00, $e9, $08, $97, $00, $f1, $f8, $9d, $00
    db $f1, $00, $99, $00, $f1, $08, $9a, $00, $f9, $f8, $9e, $00, $f9, $00, $9f, $00
    db $80

SpriteFrameData_2388::
    db $e9, $f8, $95, $00, $e9, $00, $96, $00, $e9, $08, $97, $00, $f1, $f8, $a0, $00
    db $f1, $00, $a1, $00, $f1, $08, $9a, $00, $f9, $f8, $a2, $00, $f9, $00, $a3, $00
    db $80

SpriteFrameData_23a9::
    db $e8, $fa, $95, $00, $e8, $02, $a4, $00, $f0, $f9, $a5, $00, $f0, $01, $a6, $00
    db $f0, $09, $a7, $00, $f8, $f9, $8a, $00, $f8, $01, $8b, $00, $80

SpriteFrameData_23c6::
    db $f8, $f4, $8c, $00, $f8, $fc, $8d, $00, $80

SpriteFrameData_23cf::
    db $ec, $fc, $8e, $00, $ec, $04, $8f, $00, $f4, $f4, $90, $00, $f4, $fc, $91, $00
    db $f4, $04, $92, $00, $fc, $fb, $93, $00, $fc, $03, $94, $00, $80

SpriteFrameData_23ec::
    db $e8, $f8, $b3, $00, $e8, $00, $b4, $00, $f0, $f8, $b5, $00, $f0, $00, $b6, $00
    db $f8, $f8, $b7, $00, $f8, $00, $b8, $00, $80

SpriteFrameData_2405::
    db $e9, $f8, $b3, $00, $e9, $00, $b4, $00, $f1, $f8, $b9, $00, $f1, $00, $ba, $00
    db $f9, $f8, $bb, $00, $f9, $00, $bc, $00, $80

SpriteFrameData_241e::
    db $e9, $f8, $b3, $00, $e9, $00, $b4, $00, $f1, $f8, $bd, $00, $f1, $00, $be, $00
    db $f9, $f8, $bf, $00, $f9, $00, $c0, $00, $80

SpriteFrameData_2437::
    db $ed, $f8, $c1, $00, $ed, $00, $c2, $00, $f5, $f8, $c3, $00, $f5, $00, $a8, $00
    db $f5, $08, $a9, $00, $fd, $f8, $aa, $00, $fd, $00, $ab, $00, $80

SpriteFrameData_2454::
    db $ed, $f8, $c1, $00, $ed, $00, $ac, $00, $f5, $f8, $ad, $00, $f5, $00, $ae, $00
    db $f5, $08, $af, $00, $fd, $f8, $b0, $00, $fd, $00, $b1, $00, $fd, $08, $b2, $00
    db $80

SpriteFrameData_2475:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c4, $00, $f0, $00, $c5, $00, $f8, $f8, $c6, $10, $f8, $00, $c7
    db $10, $80

SpriteFrameData_2486:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f0, $f8, $c8, $00, $f0, $00, $c9, $00, $f8, $f8, $ca, $00, $f8, $00
    db $cb, $00, $80

SpriteFrameData_2497::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00
    db $f0, $f8, $74, $00, $f0, $00, $75, $00, $ed, $08, $78, $00, $f8, $f8, $76, $00
    db $f8, $00, $77, $00, $80

SpriteFrameData_24bc::
    db $e0, $f9, $70, $00, $e0, $01, $71, $00, $e8, $f9, $72, $00, $e8, $01, $79, $00
    db $f0, $f8, $7a, $00, $f0, $00, $7b, $00, $f0, $08, $7c, $00, $f8, $f8, $7d, $00
    db $f8, $00, $77, $00, $80

SpriteFrameData_24e1::
    db $f8, $f8, $7e, $00, $f8, $00, $7f, $00, $80

SpriteFrameData_24ea::
    db $f8, $f8, $81, $20, $f8, $00, $80, $20, $80

SpriteFrameData_24f3::
    db $f8, $f8, $83, $20, $f8, $00, $82, $20, $80

SpriteFrameData_24fc::
    db $e8, $fc, $84, $00, $e8, $04, $71, $00, $f0, $f4, $85, $00, $f0, $fc, $86, $00
    db $f0, $04, $87, $00, $f8, $f4, $88, $00, $f8, $fc, $89, $00, $f8, $04, $8a, $00
    db $80

SpriteFrameData_251d::
    db $e8, $fc, $84, $00, $e8, $04, $71, $00, $f0, $fc, $8b, $00, $f0, $04, $8c, $00
    db $f8, $f4, $8d, $00, $f8, $fc, $8e, $00, $f8, $04, $8f, $00, $80

SpriteFrameData_253a::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $79, $00
    db $f0, $f8, $90, $00, $f0, $00, $91, $00, $f8, $f8, $92, $00, $f8, $00, $93, $00
    db $80

SpriteFrameData_255b::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $79, $00
    db $f1, $f8, $94, $00, $f1, $00, $95, $00, $f9, $f8, $96, $00, $f9, $00, $97, $00
    db $80

SpriteFrameData_257c::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $79, $00
    db $f1, $f8, $98, $00, $f1, $00, $99, $00, $f9, $f8, $9a, $00, $f9, $00, $9b, $00
    db $80

SpriteFrameData_259d::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00
    db $f0, $f8, $74, $00, $f0, $00, $75, $00, $f8, $f8, $76, $00, $f8, $00, $77, $00
    db $80

SpriteFrameData_25be::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $73, $00
    db $f1, $f8, $78, $00, $f1, $00, $79, $00, $f9, $f8, $7a, $00, $f9, $00, $7b, $00
    db $80

SpriteFrameData_25df::
    db $e1, $f8, $70, $00, $e1, $00, $71, $00, $e9, $f8, $72, $00, $e9, $00, $73, $00
    db $f1, $f8, $7c, $00, $f1, $00, $7d, $00, $f9, $f8, $7e, $00, $f9, $00, $7f, $00
    db $80

SpriteFrameData_2600::
    db $e5, $f8, $70, $00, $e5, $00, $71, $00, $ed, $f8, $80, $00, $ed, $00, $81, $00
    db $f5, $f8, $82, $00, $f5, $00, $83, $00, $f5, $08, $84, $00, $fd, $f8, $85, $00
    db $fd, $00, $86, $00, $80

SpriteFrameData_2625::
    db $e5, $f8, $70, $00, $e5, $00, $71, $00, $ed, $f9, $87, $00, $ed, $01, $88, $00
    db $f5, $f8, $89, $00, $f5, $00, $8a, $00, $fd, $f8, $85, $00, $fd, $00, $8b, $00
    db $80

SpriteFrameData_2646::
    db $e8, $fc, $8c, $00, $e8, $04, $8d, $00, $f0, $fa, $8e, $00, $f0, $02, $8f, $00
    db $f8, $f4, $90, $00, $f8, $fc, $91, $00, $f8, $04, $92, $00, $80

SpriteFrameData_2663::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $93, $00, $e8, $00, $94, $00
    db $f0, $f8, $95, $00, $f0, $00, $96, $00, $f8, $f8, $97, $00, $f8, $00, $98, $00
    db $80

SpriteFrameData_2684::
    db $e0, $f8, $70, $00, $e0, $00, $71, $00, $e8, $f8, $72, $00, $e8, $00, $73, $00
    db $f0, $f8, $99, $00, $f0, $00, $9a, $00, $f8, $f8, $9b, $00, $f8, $00, $9c, $00
    db $80

SpriteFrameData_26a5::
    db $d9, $f3, $70, $00, $e0, $ee, $71, $10, $e0, $f6, $72, $10, $e0, $fe, $73, $10
    db $e8, $f1, $74, $00, $e8, $f9, $75, $00, $e8, $01, $76, $00, $f0, $f4, $77, $10
    db $f0, $fc, $78, $10, $f0, $04, $79, $10, $f8, $f3, $7a, $10, $f8, $fb, $7b, $10
    db $f8, $03, $7c, $10, $80

SpriteFrameData_26da::
    db $d9, $f3, $70, $00, $e0, $ee, $71, $10, $e0, $f6, $72, $10, $e0, $fe, $73, $10
    db $e8, $f1, $7d, $00, $e8, $f9, $75, $00, $e8, $01, $76, $00, $f0, $f2, $7e, $10
    db $f0, $fa, $7f, $10, $f0, $02, $80, $10, $f8, $f2, $81, $10, $f8, $fa, $82, $10
    db $f8, $02, $83, $10, $80

SpriteFrameData_270f::
    db $e0, $f4, $84, $10, $e0, $fc, $85, $10, $e0, $04, $86, $10, $e8, $f4, $87, $00
    db $e8, $fc, $88, $00, $e8, $04, $89, $00, $f0, $f4, $8a, $10, $f0, $fc, $8b, $10
    db $f0, $04, $8c, $10, $f8, $f3, $7a, $10, $f8, $fb, $7b, $10, $f8, $03, $7c, $10
    db $80

SpriteFrameData_2740::
    db $e0, $f4, $84, $10, $e0, $fc, $85, $10, $e0, $04, $86, $10, $e8, $f4, $90, $00
    db $e8, $fc, $88, $00, $e8, $04, $89, $00, $f0, $f2, $7e, $10, $f0, $fa, $91, $10
    db $f0, $02, $92, $10, $f8, $f2, $81, $10, $f8, $fa, $82, $10, $f8, $02, $83, $10
    db $80

SpriteFrameData_2771::
    db $e5, $f4, $93, $10, $e5, $fc, $94, $10, $e5, $04, $95, $10, $ed, $ed, $96, $00
    db $ed, $f5, $97, $00, $ed, $fd, $98, $00, $ed, $05, $99, $00, $f5, $ed, $9a, $10
    db $f5, $f5, $9b, $10, $f5, $fd, $9c, $10, $f5, $05, $9d, $10, $fd, $f4, $9e, $10
    db $fd, $fc, $9f, $10, $fd, $04, $7c, $10, $80

SpriteFrameData_27aa::
    db $e5, $f4, $a0, $10, $e5, $fc, $a1, $10, $ea, $ec, $a2, $10, $ed, $f4, $a3, $10
    db $ed, $fc, $a4, $10, $ea, $04, $a5, $10, $f5, $f4, $a6, $10, $f5, $fc, $a7, $10
    db $f2, $04, $a8, $10, $f6, $0c, $8d, $10, $fd, $f4, $8e, $10, $fd, $fc, $9f, $10
    db $fa, $04, $8f, $10, $80

SpriteFrameData_27df::
    db $f8, $fc, $70, $00, $80

SpriteFrameData_27e4::
    db $db, $f7, $70, $10, $db, $ff, $71, $10, $e3, $f0, $72, $00, $e3, $f8, $73, $00
    db $e3, $00, $74, $00, $e3, $08, $75, $00, $eb, $f0, $76, $00, $eb, $f8, $77, $00
    db $eb, $00, $78, $00, $eb, $08, $79, $00, $f3, $f4, $7a, $10, $f3, $fc, $7b, $10
    db $f3, $04, $b9, $10, $fb, $f9, $7c, $10, $fb, $00, $7c, $10, $80

SpriteFrameData_2821::
    db $dc, $f7, $70, $10, $dc, $ff, $71, $10, $e4, $f0, $7e, $00, $e4, $f8, $73, $00
    db $e4, $00, $74, $00, $e4, $08, $7f, $00, $ec, $f0, $80, $00, $ec, $f8, $77, $00
    db $ec, $00, $78, $00, $ec, $08, $81, $00, $f4, $f1, $82, $10, $f4, $f9, $83, $10
    db $f4, $01, $84, $10, $fc, $f7, $85, $10, $fc, $ff, $86, $10, $80

SpriteFrameData_285e::
    db $dc, $f7, $70, $10, $dc, $ff, $71, $10, $e4, $f2, $87, $00, $e4, $fa, $88, $00
    db $e4, $02, $89, $00, $ec, $f2, $8a, $00, $ec, $fa, $8b, $00, $ec, $02, $8c, $00
    db $f4, $f2, $8d, $10, $f4, $fa, $8e, $10, $f4, $02, $8f, $10, $fc, $f5, $90, $10
    db $fc, $02, $7d, $10, $80

SpriteFrameData_2893::
    db $e0, $f0, $92, $10, $e0, $f8, $93, $10, $e0, $00, $94, $10, $e8, $f0, $95, $00
    db $e8, $f8, $96, $00, $e8, $00, $97, $00, $e8, $08, $98, $00, $f0, $f0, $99, $00
    db $f0, $f8, $9a, $00, $f0, $00, $9b, $00, $f0, $08, $9c, $00, $f8, $f8, $9d, $10
    db $f8, $00, $9e, $10, $f8, $08, $9f, $10, $80

SpriteFrameData_28cc::
    db $e0, $f7, $a0, $10, $e0, $ff, $a1, $10, $e0, $08, $a2, $10, $e8, $f0, $7e, $00
    db $e8, $f8, $73, $00, $e8, $00, $a3, $00, $e8, $08, $a4, $00, $f0, $f0, $80, $00
    db $f0, $f8, $a5, $00, $f0, $00, $a6, $00, $f0, $08, $a7, $00, $f8, $f6, $a8, $10
    db $f8, $fe, $a9, $10, $f8, $06, $aa, $10, $f8, $0e, $91, $10, $80

SpriteFrameData_2909::
    db $e1, $f7, $a0, $10, $e1, $ff, $a1, $10, $e9, $f0, $ac, $00, $e9, $f8, $73, $00
    db $e9, $00, $74, $00, $e9, $08, $ad, $00, $f1, $f0, $ae, $00, $f1, $f8, $b1, $00
    db $f1, $00, $ab, $00, $f1, $08, $af, $00, $f9, $f6, $a8, $10, $f9, $fe, $a9, $10
    db $f9, $06, $b0, $10, $80

SpriteFrameData_293e::
    db $db, $f7, $70, $10, $db, $ff, $71, $10, $e3, $f3, $b3, $00, $e3, $fb, $b4, $00
    db $e3, $03, $bf, $00, $eb, $f3, $b6, $00, $eb, $fb, $b7, $00, $eb, $03, $b8, $00
    db $f3, $f4, $7a, $10, $f3, $fc, $7b, $10, $f3, $04, $b9, $10, $fb, $f9, $7c, $10
    db $fb, $00, $7c, $10, $80

SpriteFrameData_2973::
    db $e3, $fa, $c5, $10, $e3, $00, $70, $10, $e3, $08, $71, $10, $eb, $f4, $bc, $10
    db $eb, $fc, $bd, $00, $eb, $04, $b4, $00, $eb, $0c, $bf, $00, $f3, $f6, $b2, $10
    db $f3, $fe, $b5, $10, $f3, $06, $ba, $00, $f3, $0e, $bb, $00, $fb, $f9, $be, $10
    db $fb, $06, $7c, $10, $f8, $0e, $cf, $00, $80

SpriteFrameData_29ac::
    db $d9, $fa, $c5, $10, $e1, $f7, $c6, $00, $e1, $ff, $c7, $00, $e8, $ef, $c0, $00
    db $e8, $f7, $c1, $00, $e9, $ff, $ca, $00, $e8, $07, $c0, $20, $f0, $ef, $c2, $00
    db $f0, $f7, $cc, $00, $f0, $ff, $cc, $00, $f0, $07, $c2, $20, $f8, $ef, $c3, $10
    db $f8, $f7, $ce, $10, $f8, $ff, $c4, $10, $f8, $07, $c3, $30, $80

SpriteFrameData_29e9::
    db $d8, $fa, $c5, $10, $e0, $f7, $c6, $00, $e0, $ff, $c7, $00, $e8, $ef, $c8, $00
    db $e8, $f7, $c9, $00, $e8, $ff, $ca, $00, $e8, $07, $c8, $20, $f0, $ef, $cb, $00
    db $f0, $f7, $cc, $00, $f0, $ff, $cc, $00, $f0, $07, $cb, $20, $f8, $ef, $cd, $10
    db $f8, $f7, $ce, $10, $f8, $ff, $c4, $10, $f8, $07, $cd, $30, $80

SpriteFrameData_2a26::
    db $f8, $fc, $cf, $00, $80

SpriteFrameData_2a2b::
    db $eb, $f8, $00, $01, $eb, $00, $01, $01, $f3, $f8, $02, $01, $f3, $00, $03, $01
    db $fb, $f8, $04, $01, $fb, $00, $05, $01, $80

SpriteFrameData_2a44::
    db $eb, $f8, $06, $01, $eb, $00, $07, $01, $f3, $f8, $08, $01, $f3, $00, $09, $01
    db $fb, $f8, $0a, $01, $fb, $00, $0b, $01, $80

SpriteFrameData_2a5d::
    db $eb, $fc, $0c, $01, $f3, $f8, $0d, $01, $f3, $00, $0e, $01, $fb, $f8, $0f, $01
    db $fb, $00, $10, $01, $80

SpriteFrameData_2a72::
    db $eb, $00, $11, $01, $f3, $f7, $11, $21, $f3, $00, $12, $01, $80

SpriteFrameData_2a7f::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01
    db $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_2a98::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $19, $01, $f4, $00, $1a, $01
    db $fc, $f8, $1b, $01, $fc, $00, $1c, $01, $80

SpriteFrameData_2ab1::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $1d, $01, $f4, $00, $1e, $01
    db $fc, $f8, $1f, $01, $fc, $00, $20, $01, $80

SpriteFrameData_2aca::
    db $eb, $f8, $21, $01, $eb, $00, $22, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01
    db $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_2ae3::
    db $ed, $f8, $23, $01, $ed, $00, $24, $01, $f5, $f8, $25, $01, $f5, $00, $26, $01
    db $fd, $f8, $27, $01, $fd, $00, $28, $01, $80

SpriteFrameData_2afc::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f9, $29, $01, $f4, $01, $2a, $01
    db $f4, $09, $2b, $01, $f1, $0d, $2d, $01, $fc, $f7, $1f, $01, $fc, $ff, $2c, $01
    db $80

SpriteFrameData_2b1d::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $ee, $12, $2e, $01, $f4, $f9, $29, $01
    db $f4, $01, $2a, $01, $f4, $09, $2b, $01, $fc, $f7, $1f, $01, $fc, $ff, $2c, $01
    db $80

SpriteFrameData_2b3e::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f9, $29, $01, $f4, $01, $2a, $01
    db $f4, $09, $2b, $01, $fc, $f7, $1f, $01, $fc, $ff, $2c, $01, $80

SpriteFrameData_2b5b::
    db $f0, $f8, $2f, $01, $f0, $00, $30, $01, $f8, $f8, $31, $01, $f8, $00, $32, $01
    db $80

SpriteFrameData_2b6c::
    db $f0, $f8, $33, $01, $f0, $00, $34, $01, $f8, $f8, $35, $01, $f8, $00, $32, $01
    db $80

SpriteFrameData_2b7d::
    db $eb, $f8, $36, $01, $eb, $00, $37, $01, $f3, $f8, $38, $01, $f3, $00, $39, $01
    db $fb, $fc, $3a, $01, $80

SpriteFrameData_2b92::
    db $ec, $f8, $3b, $01, $ec, $00, $3c, $01, $f4, $f1, $3d, $01, $f4, $f9, $3e, $01
    db $f4, $01, $3f, $01, $fc, $f8, $40, $01, $fc, $00, $41, $01, $80

SpriteFrameData_2baf::
    db $ef, $f8, $42, $01, $ef, $00, $43, $01, $f7, $f8, $47, $01, $f7, $00, $48, $01
    db $fe, $f8, $46, $01, $fe, $00, $46, $21, $80

SpriteFrameData_2bc8::
    db $ee, $f8, $42, $01, $ee, $00, $43, $01, $f6, $f8, $44, $01, $f6, $00, $45, $01
    db $fe, $f8, $46, $01, $fe, $00, $46, $21, $80

SpriteFrameData_2be1::
    db $eb, $f8, $49, $01, $eb, $00, $4a, $01, $f3, $f8, $4b, $01, $f3, $00, $4c, $01
    db $fb, $fc, $3a, $01, $80

SpriteFrameData_2bf6::
    db $eb, $f8, $4d, $01, $eb, $00, $4e, $01, $f3, $f8, $4f, $01, $f3, $00, $50, $01
    db $fa, $f8, $1f, $01, $fa, $00, $20, $01, $80

SpriteFrameData_2c0f::
    db $eb, $f8, $51, $01, $eb, $00, $52, $01, $f3, $f8, $53, $01, $f3, $00, $54, $01
    db $fa, $f8, $1b, $01, $fa, $00, $1c, $01, $80

SpriteFrameData_2c28::
    db $eb, $f8, $eb, $01, $eb, $00, $ec, $01, $f3, $f8, $ed, $01, $f3, $00, $ee, $01
    db $fb, $f9, $ef, $21, $fb, $00, $ef, $01, $80

SpriteFrameData_2c41:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $d0, $10, $f8, $00, $d1
    db $10, $00, $f8, $d2, $10, $00, $00, $d3, $10, $80

SpriteFrameData_2c52:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $d4, $10, $f8, $00
    db $d5, $10, $00, $f8, $d6, $10, $00, $00, $d7, $10, $80

SpriteFrameData_2c63:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $d8, $10, $f8
    db $00, $d9, $10, $00, $f8, $da, $10, $00, $00, $db, $10, $80

SpriteFrameData_2c74:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $dc, $10
    db $f8, $00, $dd, $10, $00, $f8, $d2, $10, $00, $00, $de, $10, $80

SpriteFrameData_2c85:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $fc, $df
    db $10, $00, $fc, $e0, $10, $80

SpriteFrameData_2c8e:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $e1, $10, $f8, $00, $e2, $10, $00, $f8
    db $e3, $10, $00, $00, $e4, $10, $80

SpriteFrameData_2c9f:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $e5, $10, $f8, $00, $e6, $10, $00
    db $f8, $e7, $10, $00, $00, $e8, $10, $80, $f0, $fc, $e9, $10, $f8, $fc, $ea, $10
    db $80

SpriteFrameData_2cb9::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f4, $f0, $19, $01, $f3, $f8, $15, $01
    db $f3, $00, $16, $01, $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_2cd6::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f0, $1e, $01, $f4, $f8, $1a, $01
    db $f4, $00, $1b, $01, $fc, $f8, $1c, $01, $fc, $00, $1d, $01, $80

SpriteFrameData_2cf3::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f0, $1e, $01, $f4, $f8, $1f, $01
    db $f4, $00, $20, $01, $fc, $f8, $21, $01, $fc, $00, $22, $01, $80

SpriteFrameData_2d10::
    db $ed, $f8, $23, $01, $ed, $00, $24, $01, $f5, $f0, $29, $01, $f5, $f8, $25, $01
    db $f5, $00, $26, $01, $fd, $f8, $27, $01, $fd, $00, $28, $01, $80

SpriteFrameData_2d2d::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f1, $29, $01, $f4, $f9, $2a, $01
    db $f4, $01, $2b, $01, $f4, $09, $2c, $01, $f1, $0d, $2f, $01, $fc, $f9, $2d, $01
    db $fc, $01, $2e, $01, $80

SpriteFrameData_2d52::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $ee, $12, $30, $01, $f4, $f1, $29, $01
    db $f4, $f9, $2a, $01, $f4, $01, $2b, $01, $f4, $09, $2c, $01, $fc, $f9, $2d, $01
    db $fc, $01, $2e, $01, $80

SpriteFrameData_2d77::
    db $ec, $f9, $23, $01, $ec, $01, $24, $01, $f4, $f1, $29, $01, $f4, $f9, $2a, $01
    db $f4, $01, $2b, $01, $f4, $09, $2c, $01, $fc, $f9, $2d, $01, $fc, $01, $2e, $01
    db $80

SpriteFrameData_2d98::
    db $f0, $f8, $31, $01, $f0, $00, $32, $01, $f8, $f8, $33, $01, $f8, $00, $34, $01
    db $80

SpriteFrameData_2da9::
    db $e8, $f8, $13, $01, $e8, $00, $14, $01, $f0, $f1, $35, $01, $f0, $f9, $36, $01
    db $f0, $01, $37, $01, $f8, $f5, $38, $01, $f8, $fd, $39, $01, $80

SpriteFrameData_2dc6::
    db $e7, $f8, $13, $01, $e7, $00, $14, $01, $ef, $f0, $3a, $01, $ef, $f8, $3b, $01
    db $ef, $00, $3c, $01, $f7, $f5, $3d, $01, $f7, $fd, $3e, $01, $80

SpriteFrameData_2de3::
    db $ef, $f8, $3f, $01, $ef, $00, $40, $01, $f7, $f8, $44, $01, $f7, $00, $45, $01
    db $fe, $f8, $43, $01, $fe, $00, $43, $21, $80

SpriteFrameData_2dfc::
    db $ee, $f8, $3f, $01, $ee, $00, $40, $01, $f6, $f8, $41, $01, $f6, $00, $42, $01
    db $fe, $f8, $43, $01, $fe, $00, $43, $21, $80

SpriteFrameData_2e15::
    db $eb, $f8, $46, $01, $eb, $00, $47, $01, $f3, $f8, $48, $01, $f3, $00, $49, $01
    db $fb, $f8, $4a, $01, $fb, $00, $4b, $01, $80

SpriteFrameData_2e2e::
    db $eb, $f8, $4c, $01, $eb, $00, $4d, $01, $f3, $f8, $4e, $01, $f3, $00, $4f, $01
    db $fb, $f8, $50, $01, $fb, $00, $51, $01, $80

SpriteFrameData_2e47::
    db $eb, $f8, $52, $01, $eb, $00, $53, $01, $f3, $f8, $54, $01, $f3, $00, $55, $01
    db $fb, $f8, $56, $01, $fb, $00, $57, $01, $80

SpriteFrameData_2e60::
    db $e7, $f8, $58, $01, $e7, $00, $59, $01, $ef, $f8, $5a, $01, $ef, $00, $5b, $01
    db $f7, $f5, $5c, $01, $f7, $fd, $39, $01, $80

SpriteFrameData_2e79::
    db $e8, $f8, $58, $01, $e8, $00, $59, $01, $f0, $f1, $5d, $01, $f0, $f9, $5e, $01
    db $f0, $01, $5f, $01, $f8, $f2, $60, $01, $f8, $fa, $61, $01, $80

SpriteFrameData_2e96:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $fc, $fc, $62
    db $00, $80

SpriteFrameData_2e9b:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $fc, $fc, $63, $00, $80

SpriteFrameData_2ea0::
    db $ec, $f9, $13, $01, $ec, $01, $14, $01, $f4, $f2, $64, $01, $f4, $fa, $36, $01
    db $f4, $01, $3c, $01, $fc, $f9, $2d, $01, $fc, $01, $2e, $01, $80

SpriteFrameData_2ebd::
    db $ec, $fb, $58, $01, $ec, $03, $59, $01, $f4, $f5, $65, $01, $f4, $fc, $5e, $01
    db $f4, $04, $5f, $01, $fc, $f9, $2d, $01, $fc, $01, $2e, $01, $80, $eb, $f8, $00
    db $01, $eb, $00, $01, $01, $f3, $f8, $02, $01, $f3, $00, $03, $01, $fb, $f8, $04
    db $01, $fb, $00, $05, $01, $80, $eb, $f8, $06, $01, $eb, $00, $07, $01, $f3, $f8
    db $08, $01, $f3, $00, $09, $01, $fb, $f8, $0a, $01, $fb, $00, $0b, $01, $80, $eb
    db $fc, $0c, $01, $f3, $f8, $0d, $01, $f3, $00, $0e, $01, $fb, $f8, $0f, $01, $fb
    db $00, $10, $01, $80, $eb, $00, $11, $01, $f3, $f7, $11, $21, $f3, $00, $12, $01
    db $80

SpriteFrameData_2f2e::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f0, $15, $01, $f3, $f8, $16, $01
    db $f3, $00, $17, $01, $fb, $f8, $18, $01, $fb, $00, $19, $01, $80

SpriteFrameData_2f4b::
    db $ec, $f9, $13, $01, $ec, $01, $14, $01, $f4, $f1, $1a, $01, $f4, $f9, $1b, $01
    db $f4, $01, $1c, $01, $fc, $f8, $1d, $01, $fc, $00, $1e, $01, $80

SpriteFrameData_2f68::
    db $ed, $f8, $1f, $01, $ed, $00, $20, $01, $f5, $f0, $21, $01, $f5, $f8, $22, $01
    db $f5, $00, $23, $01, $fd, $f8, $24, $01, $fd, $00, $25, $01, $80

SpriteFrameData_2f85::
    db $ec, $f9, $1f, $01, $ec, $01, $20, $01, $f4, $f7, $26, $01, $f4, $ff, $27, $01
    db $f4, $07, $28, $01, $f1, $0d, $2b, $01, $fc, $f9, $29, $01, $fc, $01, $2a, $01
    db $80

SpriteFrameData_2fa6::
    db $ec, $f9, $1f, $01, $ec, $01, $20, $01, $ee, $12, $2c, $01, $f4, $f7, $26, $01
    db $f4, $ff, $27, $01, $f4, $07, $28, $01, $fc, $f9, $29, $01, $fc, $01, $2a, $01
    db $80

SpriteFrameData_2fc7::
    db $ec, $f9, $1f, $01, $ec, $01, $20, $01, $f4, $f7, $26, $01, $f4, $ff, $27, $01
    db $f4, $07, $28, $01, $fc, $f9, $29, $01, $fc, $01, $2a, $01, $80

SpriteFrameData_2fe4::
    db $f0, $f8, $2d, $01, $f0, $00, $2e, $01, $f8, $f8, $2f, $01, $f8, $00, $30, $01
    db $80

SpriteFrameData_2ff5::
    db $eb, $f8, $31, $01, $eb, $00, $14, $01, $f3, $f0, $32, $01, $f3, $f8, $33, $01
    db $f3, $00, $34, $01, $fb, $f8, $35, $01, $fb, $00, $36, $01, $80

SpriteFrameData_3012::
    db $ea, $f8, $13, $01, $ea, $00, $14, $01, $f2, $f0, $37, $01, $f2, $f8, $38, $01
    db $f2, $00, $39, $01, $fa, $f8, $35, $01, $fa, $00, $36, $01, $80

SpriteFrameData_302f::
    db $ef, $f8, $3a, $01, $ef, $00, $3b, $01, $f7, $f8, $3f, $01, $f7, $00, $40, $01
    db $fe, $f8, $3e, $01, $fe, $00, $3e, $21, $80

SpriteFrameData_3048::
    db $ee, $f8, $3a, $01, $ee, $00, $3b, $01, $f6, $f8, $3c, $01, $f6, $00, $3d, $01
    db $fe, $f8, $3e, $01, $fe, $00, $3e, $21, $80

SpriteFrameData_3061::
    db $eb, $f8, $41, $01, $eb, $00, $42, $01, $f3, $f8, $43, $01, $f3, $00, $44, $01
    db $fb, $fc, $45, $01, $80

SpriteFrameData_3076::
    db $eb, $f8, $46, $01, $eb, $00, $47, $01, $f3, $f8, $48, $01, $f3, $00, $49, $01
    db $fb, $f8, $4a, $01, $fb, $00, $4b, $01, $80

SpriteFrameData_308f::
    db $eb, $f8, $4c, $01, $eb, $00, $4d, $01, $f3, $f8, $4e, $01, $f3, $00, $4f, $01
    db $fb, $f8, $50, $01, $fb, $00, $51, $01, $80

SpriteFrameData_30a8::
    db $ec, $f8, $31, $01, $ec, $00, $14, $01, $f4, $f0, $32, $01, $f4, $f8, $33, $01
    db $f4, $00, $17, $01, $fc, $f8, $1d, $01, $fc, $00, $1e, $01, $80

SpriteFrameData_30c5::
    db $ec, $f9, $52, $01, $ec, $01, $53, $01, $f4, $f2, $54, $01, $f4, $fa, $55, $01
    db $f4, $02, $56, $01, $fc, $f8, $57, $01, $fc, $00, $1e, $01, $80

SpriteFrameData_30e2:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $fc, $fc, $58
    db $01, $80

SpriteFrameData_30e7::
    db $eb, $f8, $52, $01, $eb, $00, $53, $01, $f3, $f1, $54, $01, $f3, $f9, $55, $01
    db $f3, $01, $56, $01, $fb, $f8, $35, $01, $fb, $00, $36, $01, $80

SpriteFrameData_3104::
    db $ea, $f8, $52, $01, $ea, $00, $53, $01, $f2, $f1, $54, $01, $f2, $f9, $55, $01
    db $f2, $01, $56, $01, $fa, $f8, $35, $01, $fa, $00, $36, $01, $80

SpriteFrameData_3121::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $15, $01, $f3, $00, $16, $01
    db $fb, $f8, $17, $01, $fb, $00, $18, $01, $80

SpriteFrameData_313a::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $19, $01, $f4, $00, $1a, $01
    db $fc, $f8, $1b, $01, $fc, $00, $1c, $01, $80

SpriteFrameData_3153::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $1d, $01, $f4, $00, $1e, $01
    db $fc, $f8, $1f, $01, $fc, $00, $20, $01, $80

SpriteFrameData_316c::
    db $ed, $f8, $21, $01, $ed, $00, $22, $01, $f5, $f8, $23, $01, $f5, $00, $24, $01
    db $fd, $f8, $25, $01, $fd, $00, $26, $01, $80

SpriteFrameData_3185::
    db $ec, $f9, $21, $01, $ec, $01, $22, $01, $f4, $f9, $27, $01, $f4, $01, $28, $01
    db $f4, $09, $29, $01, $f1, $0d, $2b, $01, $fc, $f7, $1f, $01, $fc, $ff, $2a, $01
    db $80

SpriteFrameData_31a6::
    db $ec, $f9, $21, $01, $ec, $01, $22, $01, $ee, $12, $2c, $01, $f4, $f9, $27, $01
    db $f4, $01, $28, $01, $f4, $09, $29, $01, $fc, $f7, $1f, $01, $fc, $ff, $2a, $01
    db $80

SpriteFrameData_31c7::
    db $ec, $f9, $21, $01, $ec, $01, $22, $01, $f4, $f9, $27, $01, $f4, $01, $28, $01
    db $f4, $09, $29, $01, $fc, $f7, $1f, $01, $fc, $ff, $2a, $01, $80

SpriteFrameData_31e4::
    db $f0, $f8, $2d, $01, $f0, $00, $2e, $01, $f8, $f8, $2f, $01, $f8, $00, $30, $01
    db $80

SpriteFrameData_31f5::
    db $eb, $f8, $31, $01, $eb, $00, $32, $01, $f3, $f8, $33, $01, $f3, $00, $34, $01
    db $fb, $fc, $35, $01, $80

SpriteFrameData_320a::
    db $ec, $f8, $36, $01, $ec, $00, $37, $01, $f4, $f1, $38, $01, $f4, $f9, $39, $01
    db $f4, $01, $3a, $01, $fc, $f8, $3b, $01, $fc, $00, $3c, $01, $80

SpriteFrameData_3227::
    db $ef, $f8, $3d, $01, $ef, $00, $3e, $01, $f7, $f8, $42, $01, $f7, $00, $43, $01
    db $fe, $f8, $44, $01, $fe, $00, $44, $21, $80

SpriteFrameData_3240::
    db $ee, $f8, $3d, $01, $ee, $00, $3e, $01, $f6, $f8, $3f, $01, $f6, $00, $40, $01
    db $fe, $f8, $44, $01, $fe, $00, $44, $21, $80

SpriteFrameData_3259::
    db $eb, $f8, $45, $01, $eb, $00, $46, $01, $f3, $f8, $47, $01, $f3, $00, $48, $01
    db $fb, $fc, $35, $01, $80

SpriteFrameData_326e::
    db $eb, $f8, $49, $01, $eb, $00, $4a, $01, $f3, $f8, $4b, $01, $f3, $00, $4c, $01
    db $fa, $f8, $1f, $01, $fa, $00, $20, $01, $80

SpriteFrameData_3287::
    db $eb, $f8, $4d, $01, $eb, $00, $4e, $01, $f3, $f8, $4f, $01, $f3, $00, $50, $01
    db $fa, $f8, $1b, $01, $fa, $00, $1c, $01, $80

SpriteFrameData_32a0::
    db $eb, $f8, $13, $01, $eb, $00, $14, $01, $f3, $f8, $51, $01, $f3, $00, $52, $01
    db $fb, $f9, $53, $21, $fb, $00, $53, $01, $80

SpriteFrameData_32b9::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $54, $01, $f4, $00, $55, $01
    db $fc, $f9, $56, $21, $fc, $00, $56, $01, $80

SpriteFrameData_32d2:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f8, $f8, $57, $01, $f8, $00, $58
    db $01, $fb, $08, $59, $01, $00, $f8, $57, $41, $00, $00, $58, $41, $80

SpriteFrameData_32e7:: ; Direct bank 1 xref into bank 0 sprite/graphics data.
    db $f7, $f8
    db $57, $01, $f7, $00, $58, $01, $fa, $08, $59, $01, $ff, $f8, $57, $41, $ff, $00
    db $58, $41, $80

SpriteFrameData_32fc::
    db $ec, $f8, $13, $01, $ec, $00, $14, $01, $f4, $f8, $54, $01, $f4, $00, $55, $01
    db $f0, $08, $58, $01, $f3, $10, $59, $01, $fc, $f9, $56, $21, $fc, $00, $56, $01
    db $f8, $08, $58, $41, $80

SpriteFrameData_3321::
    db $f8, $04, $18, $01, $f8, $fc, $17, $01, $f8, $f4, $16, $01, $f0, $04, $15, $01
    db $f0, $fc, $14, $01, $f0, $f4, $13, $01, $80

SpriteFrameData_333a::
    db $f9, $04, $1b, $01, $f9, $fc, $1a, $01, $f9, $f4, $19, $01, $f1, $04, $15, $01
    db $f1, $fc, $14, $01, $f1, $f4, $13, $01, $80

SpriteFrameData_3353::
    db $f8, $00, $1f, $01, $f8, $f8, $1e, $01, $f0, $00, $1d, $01, $f0, $f8, $1c, $01
    db $80

SpriteFrameData_3364::
    db $f5, $0c, $23, $01, $f0, $f9, $1c, $01, $f0, $01, $1d, $01, $f8, $08, $22, $01
    db $f8, $00, $21, $01, $f8, $f8, $20, $01, $80

SpriteFrameData_337d::
    db $f2, $11, $24, $01, $f0, $f9, $1c, $01, $f0, $01, $1d, $01, $f8, $08, $22, $01
    db $f8, $00, $21, $01, $f8, $f8, $20, $01, $80

SpriteFrameData_3396::
    db $f0, $f9, $1c, $01, $f0, $01, $1d, $01, $f8, $08, $22, $01, $f8, $00, $21, $01
    db $f8, $f8, $20, $01, $80

SpriteFrameData_33ab::
    db $f8, $04, $18, $01, $f0, $04, $15, $01, $f8, $fc, $17, $01, $f0, $fc, $26, $01
    db $f8, $f4, $27, $01, $f0, $f4, $25, $01, $80

SpriteFrameData_33c4::
    db $f8, $04, $18, $01, $f8, $fc, $17, $01, $f8, $f4, $29, $01, $f0, $04, $15, $01
    db $f0, $fc, $26, $01, $f0, $f4, $28, $01, $80

SpriteFrameData_33dd::
    db $ef, $00, $2b, $01, $ef, $f8, $2a, $01, $f7, $00, $31, $01, $f7, $f8, $30, $01
    db $ff, $f8, $32, $01, $ff, $00, $33, $01, $80

SpriteFrameData_33f6::
    db $fe, $00, $2f, $01, $fe, $f8, $2e, $01, $f6, $00, $2d, $01, $f6, $f8, $2c, $01
    db $ee, $00, $2b, $01, $ee, $f8, $2a, $01, $80

SpriteFrameData_340f::
    db $eb, $00, $35, $01, $eb, $f8, $34, $01, $f3, $00, $37, $01, $f3, $f8, $36, $01
    db $fb, $00, $39, $01, $fb, $f8, $38, $01, $80

SpriteFrameData_3428::
    db $eb, $00, $3b, $01, $eb, $f8, $3a, $01, $f3, $00, $3d, $01, $f3, $f8, $3c, $01
    db $fb, $00, $3f, $01, $fb, $f8, $3e, $01, $80

SpriteFrameData_3441::
    db $eb, $00, $41, $01, $eb, $f8, $40, $01, $f3, $00, $43, $01, $f3, $f8, $42, $01
    db $fb, $00, $45, $01, $fb, $f8, $44, $01, $80

SpriteFrameData_345a::
    db $f0, $08, $47, $01, $f0, $10, $48, $01, $f0, $04, $46, $01, $f8, $04, $18, $01
    db $f8, $fc, $17, $01, $f0, $fc, $14, $01, $f0, $f4, $13, $01, $f8, $f4, $16, $01
    db $80

SpriteFrameData_347b::
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $14, $01, $f8, $fc, $17, $01, $f0, $f4, $13, $01
    db $f8, $f4, $16, $01, $80

SpriteFrameData_34a0::
    db $f1, $1c, $48, $01, $f1, $14, $47, $01, $f1, $0c, $47, $01, $f1, $04, $46, $01
    db $f9, $04, $1b, $01, $f1, $fc, $14, $01, $f9, $fc, $1a, $01, $f1, $f4, $13, $01
    db $f9, $f4, $19, $01, $80

SpriteFrameData_34c5::
    db $f0, $08, $47, $01, $f0, $10, $48, $01, $f0, $04, $46, $01, $f8, $04, $18, $01
    db $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $25, $01, $f8, $f4, $27, $01
    db $80

SpriteFrameData_34e6::
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $25, $01
    db $f8, $f4, $27, $01, $80

SpriteFrameData_350b::
    db $f0, $1c, $48, $01, $f0, $14, $47, $01, $f0, $0c, $47, $01, $f0, $04, $46, $01
    db $f8, $04, $18, $01, $f0, $fc, $26, $01, $f8, $fc, $17, $01, $f0, $f4, $28, $01
    db $f8, $f4, $29, $01, $80

SpriteFrameData_3530::
    db $f1, $10, $48, $01, $f1, $08, $47, $01, $f1, $04, $46, $01, $f1, $fc, $14, $01
    db $f1, $f4, $13, $01, $f9, $04, $1b, $01, $f9, $fc, $1a, $01, $f9, $f4, $19, $01
    db $80

SpriteFrameData_3551::
    db $F0, $10, $48, $01, $F0, $08, $47, $01, $F0, $04, $46, $01, $F8, $04, $18, $01
    db $F0, $FC, $26, $01, $F8, $FC, $17, $01, $F0, $F4, $28, $01, $F8, $F4, $29, $01
    db $80


Bank0TrailingGraphicsData_3572::
Gfx_b00_3572::
; Source: gfx/raw/b00_3572_stage2_before_switch.png (raw, 912 decoded bytes).
    INCBIN "../build/original/assets/b00_3572.bin"


Bank0TrailingGraphicsData_3902::
Gfx_b00_3902::
; Source: gfx/raw/b00_3902_stage2_after_switch.png (raw, 928 decoded bytes).
    INCBIN "../build/original/assets/b00_3902.bin"


Bank0TrailingGraphicsData_3ca2::
Gfx_b00_3ca2::
; Source: gfx/raw/b00_3ca2_sgb_border.png (raw, 712 decoded bytes).
    INCBIN "../build/original/assets/b00_3ca2.bin", $0, $25e

Bank0TrailingGraphicsData_3f00::
    INCBIN "../build/original/assets/b00_3ca2.bin", $25e, $6a

IF DEF(DEBUG)
DebugMenu_InitBackgroundGfx::
    ldh [hNeedsReset], a
    ldh [hSCX], a
    ld hl, Gfx_b05_5701
    ld de, _VRAM + $d00
    ld bc, $0300
    ld a, BANK(Gfx_b05_5701)
    call BankedMemcpy
    ld a, $04
    ld [wScreenPaletteId], a
    ret
ENDC
    ds $4000 - @, $FF
