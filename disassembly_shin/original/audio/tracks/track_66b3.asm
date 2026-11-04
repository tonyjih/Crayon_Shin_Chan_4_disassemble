; Sound IDs: $06
AudioTrack_66b3::
    audio_header $00, $10, $02, $02
.word_02:
    audio_note $20, $10
    audio_note $20, $08
    audio_note $17, $08
    audio_note $19, $08
    audio_note $20, $08
    audio_note $20, $08
    audio_note $1a, $10
    audio_note $1a, $10
    audio_note $19, $10
    audio_note $17, $08
    audio_note $19, $08
    audio_note $1a, $08
    audio_repeat $01, (.word_02 - AudioTrack_66b3) / 2
.word_0f:
    audio_loop_start $fe
.word_10:
    audio_note $20, $10
    audio_note $20, $10
    audio_note $17, $08
    audio_note $19, $08
    audio_note $20, $08
    audio_note $20, $10
    audio_note $20, $10
    audio_note $17, $10
    audio_note $19, $08
    audio_note $20, $10
    audio_note $1a, $10
    audio_note $1a, $10
    audio_note $22, $08
    audio_note $23, $08
    audio_note $24, $08
    audio_note $25, $10
    audio_note $25, $10
    audio_note $23, $10
    audio_note $22, $08
    audio_note $1a, $10
    audio_repeat $01, (.word_10 - AudioTrack_66b3) / 2
.word_25:
    audio_note $27, $10
    audio_note $22, $10
    audio_note $27, $10
    audio_note $22, $10
    audio_note $15, $08
    audio_note $20, $08
    audio_note $17, $08
    audio_note $22, $08
    audio_note $19, $08
    audio_note $24, $08
    audio_note $1b, $08
    audio_note $25, $08
    audio_note $27, $10
    audio_note $22, $10
    audio_note $27, $10
    audio_note $22, $10
    audio_duty_or_wave_length $20
    audio_note $25, $10
    audio_note $24, $10
    audio_duty_or_wave_length $10
    audio_note $22, $08
    audio_note $20, $08
    audio_note $22, $08
    audio_note $22, $08
    audio_repeat $01, (.word_25 - AudioTrack_66b3) / 2
    audio_repeat $01, $00
    audio_loop_start $fe
    audio_note $30, $10
    audio_note $30, $10
    audio_note $2a, $08
    audio_note $29, $08
    audio_note $27, $08
    audio_note $25, $10
    audio_note $25, $10
    audio_note $27, $10
    audio_note $25, $08
    audio_note $27, $08
    audio_note $25, $08
    audio_repeat $01, $00
.word_4c:
    audio_note $27, $08
    audio_repeat $03, (.word_4c - AudioTrack_66b3) / 2
    audio_note $27, $10
    audio_note $22, $10
.word_50:
    audio_note $27, $08
    audio_note $22, $08
    audio_repeat $03, (.word_50 - AudioTrack_66b3) / 2
    audio_repeat $00, (.word_0f - AudioTrack_66b3) / 2
    audio_end
