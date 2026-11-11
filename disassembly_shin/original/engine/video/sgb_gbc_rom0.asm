; Reuse the original packet call sites. The packet may live in the caller's ROM bank.
SendSgbPacket::
    call IsCgbColorMode
    jp nz, SendSgbPacketToSgb
    ld de, wCgbPacket
    ld b, 16
    call CopyBytesWithBCount
    ld hl, FARCALL_CGB_PACKET
    jp FarCallFromBankTable

DelayFramesOrCycles::
    call IsCgbColorMode
    ret z
    jp DelayFramesOrCyclesOnGb

InitSgbOrCgb::
    cp $11
    jr z, .cgb
    xor a
    ld [wSgbEnabled], a
    jp DetectSgbOrInitSgb
.cgb
    di
    xor a
    ldh [rIE], a
    ldh [rIF], a
    ld a, $30
    ldh [rP1], a
    ld a, $01
    ASSERT SGB_EFFECTS_ON_CGB == $01
    ld [wSgbEnabled], a
    ldh [rKEY1], a
    stop
    and a ; Only the physical SGB handshake returns carry set.
    ret

IsCgbColorMode::
    ld a, [wSgbEnabled]
    cp SGB_EFFECTS_ON_CGB
    ret

CgbResetVideo::
    call IsCgbColorMode
    jp nz, CopyDmaStubToHram
    ld a, $01
    ldh [rVBK], a
    ld hl, _SCRN0
    ld bc, $0800
    call bzero
    ldh [rVBK], a
    jp CopyDmaStubToHram

ApplyLcdcOnGb::
    call IsCgbColorMode
    ret z
    jp ApplyLCDC

FinishColorScreenInit::
    call IsCgbColorMode
    jr z, .cgb
    call SgbDelayIfEnabled
    jp ApplySgbScreenPaletteFar
.cgb
    call ApplySgbScreenPaletteFar
    ld hl, FARCALL_CGB_FINISH_SCREEN
    call FarCallFromBankTable
    jp ApplyLCDC

CgbUpdateGameState::
    call UpdateCurrentGameState
    call IsCgbColorMode
    ret nz
    ld hl, FARCALL_CGB_PREPARE_FRAME
    jp FarCallFromBankTable

CgbDmaAndUpload::
    call IsCgbColorMode
    jp nz, _HRAM
    call _HRAM
    ld hl, FARCALL_CGB_UPLOAD_FRAME
    jp FarCallFromBankTable
