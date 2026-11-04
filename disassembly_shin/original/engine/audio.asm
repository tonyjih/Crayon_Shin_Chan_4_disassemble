InitSound::
    ld a, $80
    ldh [rNR52], a
    ld [wSoundPriorityFlags], a
    xor a
    ldh [rNR51], a
    ld [wSoundPanShadow], a
    ld a, $77
    ldh [rNR50], a
    ld hl, wSoundSlots
    ld b, $06
    ld a, $ff

SoundInit_NextVirtualSlot::
    ld [hl], a
    ld de, $0017
    add hl, de
    ld [hl], a
    ld de, $0002
    add hl, de
    dec b
    jr nz, SoundInit_NextVirtualSlot

PlaySound_Queue3::
    call PlaySound

PlaySound_Queue2::
    call PlaySound

PlaySound_Queue1::
    call PlaySound

PlaySound::
    push bc
    push de
    push hl
    ld [wSoundLastQueuedId], a
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld de, SoundDirectory
    add hl, de
    push hl
    pop de
    ld a, [ROM_BANK_ID_ADDR]
    push af
    ld a, $07
    ld [rRomBankSelect], a
    ld a, [de]
    inc de
    ld c, a
    ld b, $00
    ld hl, wSoundSlots
    add hl, bc
    ld a, [hl]
    cp $ff
    jr z, SoundPlay_InstallTrack

    inc hl
    ld a, [hl-]
    ld b, $ee
    and $03
    jr z, SoundPlay_ClearOldChannelPan

    ld b, $dd
    cp $01
    jr z, SoundPlay_ClearOldChannelPan

    ld b, $bb
    cp $02
    jr z, SoundPlay_ClearOldChannelPan

    ld b, $77

SoundPlay_ClearOldChannelPan::
    ld a, [wSoundPanShadow]
    and b
    ld [wSoundPanShadow], a

SoundPlay_InstallTrack::
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
    ld [rRomBankSelect], a
    ld a, [wSoundLastQueuedId]
    inc a
    pop hl
    pop de
    pop bc
    ret


UpdateSound::
    xor a
    ld [wSoundVirtualSlotIndex], a
    ld [wSoundUpdatedChannels], a
    ld hl, wSoundFrameCounter
    inc [hl]
    ld hl, wSoundSlots

SoundUpdate_NextVirtualSlot::
    push hl
    ld de, hSoundCursorLo
    ld b, $19

SoundUpdate_LoadSlotBytes::
    ld a, [hl+]
    ld [de], a
    inc e
    dec b
    jr nz, SoundUpdate_LoadSlotBytes

    ldh a, [hSoundChannelFlags]
    and $03
    ld [wSoundHardwareChannel], a
    ld b, a
    add a
    add a
    add b
    ld [wSoundRegisterOffset], a
    inc b
    ld a, $88

SoundUpdate_BuildChannelMask::
    rlca
    dec b
    jr nz, SoundUpdate_BuildChannelMask

    ld [wSoundChannelMask], a
    ld [wSoundPanClearMask], a
    ld a, [wSoundPriorityFlags]
    bit 7, a
    jr nz, SoundUpdate_CheckSlotState

    ld a, [wSoundVirtualSlotIndex]
    and $fe
    jr z, SoundUpdate_CheckSlotState

    ld a, [wSoundChannelMask]
    ld b, a
    ld a, [wSoundUpdatedChannels]
    and b
    jr nz, SoundUpdate_AdvanceVirtualSlot

    ld a, b
    cpl
    ld b, a
    ld a, [wSoundPanShadow]
    and b
    ld [wSoundPanShadow], a
    jr SoundUpdate_AdvanceVirtualSlot

SoundUpdate_CheckSlotState::
    ldh a, [hSoundCursorLo]
    ld b, a
    ldh a, [hSoundCursorHi]
    or b
    and a
    jr z, SoundUpdate_LoadTrackHeader

    ldh a, [hSoundCursorHi]
    and b
    cp $ff
    jr z, SoundUpdate_AdvanceVirtualSlot

    call SoundUpdateVibrato
    call SoundUpdateEnvelope
    ldh a, [hSoundEnvelopeRate]
    ld b, a
    ldh a, [hSoundEnvelopeFrame]
    inc a
    cp b
    jr c, SoundUpdate_AdvanceTempo

    ld a, b

SoundUpdate_AdvanceTempo::
    ldh [hSoundEnvelopeFrame], a
    ld hl, hSoundTempoCounter
    dec [hl]
    ld a, [hl]
    bit 7, a
    jr z, SoundUpdate_SaveCurrentSlot

    ldh a, [hSoundTempoDuty]
    and $0f
    ld [hl], a
    call SoundUpdateVolumeSlide
    ldh a, [hSoundVibratoCounter]
    and a
    jr z, SoundUpdate_AdvanceNoteDuration

    dec a
    ldh [hSoundVibratoCounter], a

SoundUpdate_AdvanceNoteDuration::
    ld hl, hSoundNoteDuration
    dec [hl]
    jr nz, SoundUpdate_SaveCurrentSlot

SoundUpdate_ReadNextEvent::
    ldh a, [hSoundVibratoDelay]
    ldh [hSoundVibratoCounter], a
    call SoundReadEvent

SoundUpdate_SaveCurrentSlot::
    ld a, [wSoundChannelMask]
    ld b, a
    ld a, [wSoundUpdatedChannels]
    or b
    ld [wSoundUpdatedChannels], a
    pop hl
    push hl
    ld de, hSoundCursorLo
    ld b, $19

SoundUpdate_StoreSlotBytes::
    ld a, [de]
    ld [hl+], a
    inc e
    dec b
    jr nz, SoundUpdate_StoreSlotBytes

SoundUpdate_AdvanceVirtualSlot::
    pop hl
    ld de, $0019
    add hl, de
    ld a, [wSoundVirtualSlotIndex]
    inc a
    ld [wSoundVirtualSlotIndex], a
    cp $06
    jp c, SoundUpdate_NextVirtualSlot

    ld a, [wSoundPanShadow]
    ldh [rNR51], a
    ret


SoundUpdate_LoadTrackHeader::
    ldh a, [hSoundTrackPtrLo]
    ld l, a
    ldh a, [hSoundTrackPtrHi]
    ld h, a
    ld a, [hl+]
    and $0f
    ldh [hSoundTempoCounter], a
    ld d, a
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundUpdate_LoadWaveHeader

    ld a, [hl+]
    rrca
    rrca
    and $c0
    or d

SoundUpdate_LoadHeaderVolume::
    ldh [hSoundTempoDuty], a
    ld a, [hl+]
    swap a
    ldh [hSoundVolume], a
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundUpdate_LoadWaveform

    ld a, [hl+]
    ldh [hSoundPitchOffset], a

SoundUpdate_ResetTrackCounters::
    xor a
    ldh [hSoundRepeatCounter0], a
    ldh [hSoundRepeatCounter1], a
    ldh [hSoundEnvelopeId], a
    ldh [hSoundVolumeSlideDelta], a
    ldh [hSoundCursorHi], a
    dec a
    ldh [hSoundPan], a
    ld a, $02
    ldh [hSoundCursorLo], a
    jr SoundUpdate_ReadNextEvent

SoundUpdate_LoadWaveHeader::
    ld a, [hl+]
    ldh [hSoundEnvelopeRate], a
    ld a, d
    jr SoundUpdate_LoadHeaderVolume

SoundUpdate_LoadWaveform::
    xor a
    ldh [rNR30], a
    ld a, [hl]
    ld hl, SoundWavePatterns_10d0
    and $03
    jr z, SoundUpdate_CopyWaveform

    ld de, $0010

SoundUpdate_SelectWaveform::
    add hl, de
    dec a
    jr nz, SoundUpdate_SelectWaveform

SoundUpdate_CopyWaveform::
    ld de, _AUD3WAVERAM
    ld b, $10

SoundUpdate_CopyWaveByte::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, SoundUpdate_CopyWaveByte

    jr SoundUpdate_ResetTrackCounters


INCLUDE "data/audio/waveforms.asm"

SoundReadEvent::
    ldh a, [hSoundCursorLo]
    ld l, a
    ldh a, [hSoundCursorHi]
    ld h, a
    add hl, hl
    ldh a, [hSoundTrackPtrLo]
    ld e, a
    ldh a, [hSoundTrackPtrHi]
    ld d, a
    add hl, de

SoundReadEvent_AdvanceCursor::
    ldh a, [hSoundCursorLo]
    add $01
    ldh [hSoundCursorLo], a
    ldh a, [hSoundCursorHi]
    adc $00
    ldh [hSoundCursorHi], a
    ld a, [hl+]
    cp $d0
    jr nc, SoundCommand_VolumeSlide

    cp $b0
    jr nc, SoundCommand_Repeat

    cp $a0
    jp nc, SoundCommand_DispatchControl

    jp SoundNote_Play


SoundCommand_MarkerOrEnd::
    cp $fd
    jr nz, SoundCommand_CheckEnd

    ldh a, [hSoundCursorLo]
    ldh [hSoundLoopCursorLo], a
    ldh a, [hSoundCursorHi]
    ldh [hSoundLoopCursorHi], a

SoundCommand_SkipParameter::
    inc hl
    jr SoundReadEvent_AdvanceCursor

SoundCommand_CheckEnd::
    cp $ff
    jr nz, SoundCommand_SkipParameter

    ldh [hSoundCursorLo], a
    ldh [hSoundCursorHi], a
    call SoundStopCurrentChannel
    ret


SoundCommand_VolumeSlide::
    cp $f0
    jr nc, SoundCommand_MarkerOrEnd

    cp $e0
    jr nc, SoundCommand_VolumeSlideDown

    and $0f
    jr SoundCommand_StoreVolumeSlide

SoundCommand_VolumeSlideDown::
    and $0f
    cpl
    inc a

SoundCommand_StoreVolumeSlide::
    ld b, a
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundCommand_VolumeSlideContinue

    ld a, b
    ldh [hSoundVolumeSlideDelta], a
    ld a, [hl]
    ldh [hSoundVolumeSlidePeriod], a
    ldh [hSoundVolumeSlideCounter], a

SoundCommand_VolumeSlideContinue::
    inc hl
    jr SoundReadEvent_AdvanceCursor

SoundCommand_Envelope::
    and $0f
    ld b, a
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundCommand_EnvelopeContinue

    ldh a, [hSoundVolume]
    and $0f
    jr nz, SoundCommand_EnvelopeContinue

    ld a, [hl]
    ldh [hSoundEnvelopeRate], a
    ld a, b
    swap a
    ldh [hSoundEnvelopeId], a

SoundCommand_EnvelopeContinue::
    inc hl
    jr SoundReadEvent_AdvanceCursor

SoundCommand_Repeat::
    cp $c0
    jr nc, SoundCommand_Envelope

    and $0f
    jr z, SoundCommand_ResolveRepeatTarget

    ld e, a
    ld a, [hl]
    and a
    jr nz, SoundCommand_RepeatCounter1

    ldh a, [hSoundRepeatCounter0]
    dec a
    ldh [hSoundRepeatCounter0], a
    jr z, SoundCommand_RestartEventReader

    bit 7, a
    jr z, SoundCommand_ResolveRepeatTarget

    ld a, e
    ldh [hSoundRepeatCounter0], a
    jr SoundCommand_ResolveRepeatTarget

SoundCommand_RepeatCounter1::
    ldh a, [hSoundRepeatCounter1]
    dec a
    ldh [hSoundRepeatCounter1], a
    jr z, SoundCommand_RestartEventReader

    bit 7, a
    jr z, SoundCommand_ResolveRepeatTarget

    ld a, e
    ldh [hSoundRepeatCounter1], a

SoundCommand_ResolveRepeatTarget::
    ld a, [hl]
    and a
    jr nz, SoundCommand_SetRepeatCursorLo

    ldh a, [hSoundLoopCursorLo]

SoundCommand_SetRepeatCursorLo::
    ldh [hSoundCursorLo], a
    jr nz, SoundCommand_ClearRepeatCursorHi

    ldh a, [hSoundLoopCursorHi]
    jr SoundCommand_SetRepeatCursorHi

SoundCommand_ClearRepeatCursorHi::
    xor a

SoundCommand_SetRepeatCursorHi::
    ldh [hSoundCursorHi], a

SoundCommand_RestartEventReader::
    jp SoundReadEvent


SoundCommand_DispatchControl::
    cp $a0
    jr nz, SoundCommand_CheckPitchOffset

    ld a, [hl+]
    swap a
    ldh [hSoundVolume], a
    call SoundWriteVolume
    jp SoundReadEvent_AdvanceCursor


SoundCommand_CheckPitchOffset::
    cp $a1
    jr nz, SoundCommand_CheckDutyOrWaveLength

    ld a, [hl+]
    ldh [hSoundPitchOffset], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_CheckDutyOrWaveLength::
    cp $a2
    jr nz, SoundCommand_CheckVibrato

    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundCommand_SetWaveLength

    ld a, [hl+]
    rrca
    rrca
    and $c0
    ld d, a
    ldh a, [hSoundTempoDuty]
    and $3f
    or d
    ldh [hSoundTempoDuty], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_SetWaveLength::
    ld a, [hl+]
    ldh [hSoundEnvelopeRate], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_CheckVibrato::
    cp $a3
    jr nz, SoundCommand_CheckPan

    ld a, [hl+]
    bit 7, a
    jr nz, SoundCommand_DisableVibrato

    ld b, a
    and $0f
    add a
    ldh [hSoundVibratoDelay], a
    ldh [hSoundVibratoCounter], a
    ld a, b
    and $70
    ld e, a
    ldh a, [hSoundChannelFlags]
    and $0f
    or e
    or $80

SoundCommand_StoreVibratoFlags::
    ldh [hSoundChannelFlags], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_DisableVibrato::
    ldh a, [hSoundChannelFlags]
    and $0f
    jr SoundCommand_StoreVibratoFlags

SoundCommand_CheckPan::
    cp $a5
    jr nz, SoundCommand_CheckMasterVolume

    ld a, [hl+]
    cp $01
    jr nz, SoundCommand_StorePan

    ldh a, [hSoundPan]
    swap a

SoundCommand_StorePan::
    ldh [hSoundPan], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_CheckMasterVolume::
    cp $a6
    jr nz, SoundCommand_CheckWait

    ld a, [hl+]
    ldh [rNR50], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_CheckWait::
    cp $a7
    jr nz, SoundCommand_CheckPitchMode

    ld a, [hl]
    ldh [hSoundNoteDuration], a
    jp SoundApplyPan


SoundCommand_CheckPitchMode::
    cp $ae
    jr nz, SoundCommand_CheckTempo

    ld a, [hl+]
    and $10
    ld b, a
    ldh a, [hSoundTempoDuty]
    or b
    ldh [hSoundTempoDuty], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_CheckTempo::
    cp $af
    jr nz, SoundCommand_IgnoreReserved

    ld a, [hl+]
    and $0f
    ldh [hSoundTempoCounter], a
    ld b, a
    ldh a, [hSoundTempoDuty]
    and $f0
    or b
    ldh [hSoundTempoDuty], a
    jp SoundReadEvent_AdvanceCursor


SoundCommand_IgnoreReserved::
    inc hl
    jp SoundReadEvent_AdvanceCursor


SoundNoiseNoteIndexTable_1282:: ; note index table used by channel 4/noise playback.
    db $00, $01, $11, $12, $14, $23, $07, $15, $17, $32, $33, $60, $61, $45, $53, $62

SoundNote_Rest::
    call SoundStopCurrentChannel
    ret


SoundNote_Play::
    ld b, a
    ld a, [hl]
    ldh [hSoundNoteDuration], a
    ld a, [wSoundHardwareChannel]
    cp $03
    jr nz, SoundNote_DecodePitch

    ld a, b
    cp $1f
    jr z, SoundNote_Rest

    cp $10
    jr nc, SoundNote_RawNoiseRegister

    ld hl, SoundNoiseNoteIndexTable_1282
    add l
    ld l, a
    ld a, h
    adc $00
    ld h, a
    ld l, [hl]
    ld h, $00
    jr SoundNote_ResetEnvelopeFrame

SoundNote_RawNoiseRegister::
    ld l, a
    ld h, $00
    jr SoundNote_ResetEnvelopeFrame

SoundNote_DecodePitch::
    ld a, b
    and $0f
    cp $0c
    jr nc, SoundNote_Rest

    add a
    ld e, a
    ldh a, [hSoundTempoDuty]
    and $10
    jr z, SoundNote_LoadFrequency

    ld a, e
    add $18
    ld e, a

SoundNote_LoadFrequency::
    ld d, $00
    ld hl, SoundFrequencyTable_14c3
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, b
    swap a
    and $0f
    jr z, SoundNote_ConvertHardwareFrequency

    ld b, a

SoundNote_ApplyOctave::
    srl h
    rr l
    dec b
    jr nz, SoundNote_ApplyOctave

SoundNote_ConvertHardwareFrequency::
    ld a, $00
    sub l
    ld l, a
    ld a, $08
    sbc h
    ld h, a

SoundNote_ResetEnvelopeFrame::
    xor a
    ldh [hSoundEnvelopeFrame], a
    call SoundSkipIfChannelAlreadyUpdated
    ld a, [wSoundHardwareChannel]
    cp $02
    jr nz, SoundNote_WriteEnvelope

    ld a, $80
    ldh [rNR30], a

SoundNote_WriteEnvelope::
    push hl
    call SoundApplyEnvelope
    pop hl
    ld a, [wSoundHardwareChannel]
    and a
    ldh a, [hSoundPitchOffset]
    ld c, $10
    call z, SoundWriteChannelRegister
    ld a, l
    ld c, $13
    call SoundWriteChannelRegister
    ld a, l
    cp $02
    jr c, SoundNote_ClampSweepLow

    cp $fe
    jr c, SoundNote_WriteFrequencyLow

    ld a, $fd
    jr SoundNote_WriteFrequencyLow

SoundNote_ClampSweepLow::
    ld a, $02

SoundNote_WriteFrequencyLow::
    ldh [hSoundFrequencyLo], a
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundNote_TriggerWaveChannel

    cp $02
    jr nc, SoundNote_BuildTrigger

    ldh a, [hSoundTempoDuty]
    and $c0
    ld c, $11
    call SoundWriteChannelRegister

SoundNote_BuildTrigger::
    ld a, h
    and $07
    or $80

SoundNote_WriteFrequencyHigh::
    ldh [hSoundFrequencyHi], a
    ld c, $14
    call SoundWriteChannelRegister

SoundApplyPan::
    ld a, [wSoundPanClearMask]
    ld b, a
    cpl
    ld c, a
    ldh a, [hSoundPan]
    and b
    ld b, a
    ld a, [wSoundPanShadow]
    and c
    or b
    ld [wSoundPanShadow], a
    ret


SoundNote_TriggerWaveChannel::
    xor a
    ldh [rNR31], a
    ldh a, [rNR52]
    and $04
    jr z, SoundNote_BuildTrigger

    ld a, h
    and $07
    jr SoundNote_WriteFrequencyHigh

SoundUpdateVolumeSlide::
    ld a, [wSoundHardwareChannel]
    cp $02
    ret z

    ldh a, [hSoundVolumeSlideDelta]
    and a
    ret z

    ld hl, hSoundVolumeSlideCounter
    dec [hl]
    ret nz

    ldh a, [hSoundVolume]
    swap a
    cp $10
    ret nc

    and $0f
    ld b, a
    ldh a, [hSoundVolumeSlidePeriod]
    ldh [hSoundVolumeSlideCounter], a
    ld hl, hSoundVolumeSlideDelta
    ld a, [hl]
    bit 7, a
    jr nz, SoundUpdateVolumeSlide_Decrease

    dec [hl]
    ld a, b
    cp $0f
    ret z

    ldh a, [hSoundVolume]
    add $10
    ldh [hSoundVolume], a
    jp SoundWriteVolume


SoundUpdateVolumeSlide_Decrease::
    inc [hl]
    ld a, b
    and a
    ret z

    ldh a, [hSoundVolume]
    sub $10
    ldh [hSoundVolume], a
    jr SoundWriteVolume

SoundUpdateVibrato::
    call SoundSkipIfChannelAlreadyUpdated
    ld a, [wSoundHardwareChannel]
    cp $03
    ret z

    ldh a, [hSoundVibratoCounter]
    and a
    ret nz

    ldh a, [hSoundChannelFlags]
    bit 7, a
    ret z

    and $70
    ld b, a
    ld a, [wSoundFrameCounter]
    and $0f
    or b
    ld e, a
    ld d, $00
    ld hl, SoundVibratoOffsetTable_1683
    add hl, de
    ldh a, [hSoundFrequencyLo]
    add [hl]
    ld c, $13
    jr SoundWriteChannelRegister

SoundApplyEnvelope::
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundWriteWaveVolume

    ldh a, [hSoundEnvelopeId]
    and a
    jr nz, SoundUpdateEnvelope_ComputePhase

    ldh a, [hSoundVolume]

SoundWriteVolume::
    ld c, a
    call SoundSkipIfChannelAlreadyUpdated
    ld a, c
    ld c, $12
    call SoundWriteChannelRegister
    ldh a, [hSoundFrequencyHi]
    ld c, $14

SoundWriteChannelRegister::
    ld b, a
    ld a, [wSoundRegisterOffset]
    add c
    ld c, a
    ld a, b
    ldh [c], a
    ret


SoundWriteWaveVolume::
    ldh a, [hSoundVolume]
    ld c, $12
    jr SoundWriteChannelRegister

SoundApplyWaveEnvelope::
    ld a, e
    srl a
    add $02
    swap a
    ld hl, hSoundVolume
    cp [hl]
    ret c

    and $60
    ldh [rNR32], a
    ret


SoundUpdateEnvelope::
    call SoundSkipIfChannelAlreadyUpdated
    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundUpdateEnvelope_ComputePhase

    ldh a, [hSoundEnvelopeId]
    and a
    ret z

SoundUpdateEnvelope_ComputePhase::
    ldh a, [hSoundEnvelopeRate]
    and a
    ret z

    ld e, $00
    ld c, a
    ldh a, [hSoundEnvelopeFrame]
    ld b, $04

SoundUpdateEnvelope_DivideStep::
    add a
    cp c
    jr c, SoundUpdateEnvelope_ShiftPhase

    sub c

SoundUpdateEnvelope_ShiftPhase::
    ccf
    rl e
    dec b
    jr nz, SoundUpdateEnvelope_DivideStep

    ld a, [wSoundHardwareChannel]
    cp $02
    jr z, SoundApplyWaveEnvelope

    ldh a, [hSoundEnvelopeId]
    or e
    ld e, a
    ld d, $00
    ld hl, SoundPitchEnvelopeTable_14e3
    add hl, de
    ldh a, [hSoundVolume]
    swap a
    ld e, a
    ld a, [hl]
    ld h, a
    and $f0
    or e
    ld e, a
    bit 2, h
    jr nz, SoundUpdateEnvelope_CombineRegister

    inc b
    ld a, c
    swap a
    and $0f
    jr z, SoundUpdateEnvelope_CombineRegister

    ld b, a
    bit 3, e
    jr nz, SoundUpdateEnvelope_ClampDelta

    sla b
    bit 2, e
    jr nz, SoundUpdateEnvelope_ClampDelta

    sla b
    bit 1, e
    jr z, SoundUpdateEnvelope_ClearDelta

SoundUpdateEnvelope_ClampDelta::
    ld a, b
    cp $08
    jr c, SoundUpdateEnvelope_CombineRegister

SoundUpdateEnvelope_ClearDelta::
    ld b, $00

SoundUpdateEnvelope_CombineRegister::
    ld a, h
    and $08
    or b
    ld b, a
    bit 0, h
    jr z, SoundUpdateEnvelope_WriteRegister

    ld hl, SoundDutyEnvelopeTable_1583
    add hl, de
    ld a, [hl]
    or b
    ld b, a
    ld c, $12
    ld a, [wSoundRegisterOffset]
    add c
    ld c, a
    ldh a, [c]
    cp b
    ret z

    ld a, b
    jp SoundWriteVolume


SoundUpdateEnvelope_WriteRegister::
    ld c, $12
    ld a, [wSoundRegisterOffset]
    add c
    ld c, a
    ldh a, [c]
    and $08
    ld l, a
    ld a, h
    and $08
    cp l
    ret z

    ld hl, SoundDutyEnvelopeTable_1583
    add hl, de
    ld a, [hl]
    or b
    jp SoundWriteVolume


SoundStopCurrentChannel::
    call SoundSkipIfChannelAlreadyUpdated
    ld a, [wSoundChannelMask]
    cpl
    ld b, a
    ld a, [wSoundPanShadow]
    and b
    ld [wSoundPanShadow], a
    ret


SoundSkipIfChannelAlreadyUpdated:: ; If another virtual slot owns this hardware channel, discards this helper return address and returns to its caller.
    ld a, [wSoundChannelMask]
    ld b, a
    ld a, [wSoundUpdatedChannels]
    and b
    ret z

    pop af
    ret


INCLUDE "data/audio/tables.asm"
