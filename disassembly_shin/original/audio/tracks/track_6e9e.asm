; Sound IDs: $20
AudioTrack_6e9e::
    audio_header $00, $01, $09, $00
    audio_loop_start $fe
    audio_pan $0f
    audio_envelope $06, $10
    audio_vibrato $51
.word_06:
    audio_note $39, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $10
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $08
    audio_repeat $01, (.word_06 - AudioTrack_6e9e) / 2
.word_0e:
    audio_note $3b, $08
    audio_note $36, $08
    audio_note $39, $08
    audio_note $3b, $10
    audio_note $36, $08
    audio_note $39, $08
    audio_note $3b, $08
    audio_repeat $01, (.word_0e - AudioTrack_6e9e) / 2
.word_16:
    audio_note $38, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $38, $10
    audio_note $34, $08
    audio_note $36, $08
    audio_note $38, $08
    audio_repeat $01, (.word_16 - AudioTrack_6e9e) / 2
    audio_note $39, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $10
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $08
    audio_note $35, $08
    audio_note $35, $08
    audio_note $1f, $08
    audio_note $34, $18
    audio_command $a4, $fe
    audio_envelope $00, $fe
    audio_duty_or_wave_length $00
    audio_pitch_offset $3d
    audio_note $44, $10
    audio_pitch_offset $00
    audio_duty_or_wave_length $01
    audio_repeat $00, $00
    audio_end
