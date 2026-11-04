; Sound IDs: $2a
AudioTrack_7226::
    audio_header $00, $0c, $02, $02
    audio_note $37, $05
    audio_note $37, $0a
    audio_note $37, $05
.word_05:
    audio_note $37, $0a
    audio_repeat $02, (.word_05 - AudioTrack_7226) / 2
    audio_note $17, $0a
    audio_note $17, $0a
    audio_duty_or_wave_length $12
    audio_note $1f, $0a
    audio_loop_start $fe
    audio_note $20, $14
    audio_note $20, $0f
    audio_note $20, $05
.word_0f:
    audio_note $20, $0a
    audio_note $17, $0a
    audio_repeat $01, (.word_0f - AudioTrack_7226) / 2
    audio_note $25, $14
    audio_note $25, $0f
    audio_note $25, $05
.word_15:
    audio_note $20, $0a
    audio_note $17, $0a
    audio_repeat $01, (.word_15 - AudioTrack_7226) / 2
    audio_note $22, $14
    audio_note $22, $0f
    audio_note $22, $05
    audio_note $24, $0a
    audio_note $25, $0a
    audio_note $26, $0a
    audio_note $26, $0a
    audio_note $27, $14
    audio_note $27, $0f
    audio_note $27, $05
    audio_note $27, $0a
    audio_note $25, $0a
    audio_note $24, $0a
    audio_note $22, $0a
    audio_note $20, $14
    audio_note $20, $0f
    audio_note $20, $05
.word_29:
    audio_note $20, $0a
    audio_note $17, $0a
    audio_repeat $01, (.word_29 - AudioTrack_7226) / 2
    audio_note $25, $14
    audio_note $25, $0f
    audio_note $25, $05
.word_2f:
    audio_note $20, $0a
    audio_note $17, $0a
    audio_repeat $01, (.word_2f - AudioTrack_7226) / 2
    audio_note $15, $14
    audio_note $15, $14
    audio_note $17, $14
    audio_note $17, $14
    audio_note $1f, $0a
.word_37:
    audio_note $20, $0a
    audio_repeat $03, (.word_37 - AudioTrack_7226) / 2
    audio_note $1f, $1e
.word_3a:
    audio_note $15, $0a
    audio_note $19, $0a
    audio_note $20, $0a
    audio_note $19, $0a
    audio_repeat $01, (.word_3a - AudioTrack_7226) / 2
.word_3f:
    audio_note $14, $0a
    audio_note $17, $0a
    audio_note $1b, $0a
    audio_note $17, $0a
    audio_repeat $01, (.word_3f - AudioTrack_7226) / 2
.word_44:
    audio_note $14, $0a
    audio_note $18, $0a
    audio_note $1b, $0a
    audio_note $18, $0a
    audio_repeat $01, (.word_44 - AudioTrack_7226) / 2
    audio_note $19, $0a
    audio_note $20, $0a
    audio_note $24, $0a
    audio_note $27, $0a
    audio_note $29, $0a
    audio_note $27, $0a
    audio_note $24, $0a
    audio_note $20, $0a
.word_51:
    audio_note $22, $0a
    audio_repeat $04, (.word_51 - AudioTrack_7226) / 2
    audio_note $20, $0a
    audio_note $22, $0a
    audio_note $22, $0a
.word_56:
    audio_note $24, $0a
    audio_repeat $04, (.word_56 - AudioTrack_7226) / 2
    audio_note $22, $0a
    audio_note $24, $0a
    audio_note $24, $0a
.word_5b:
    audio_note $25, $0a
    audio_repeat $04, (.word_5b - AudioTrack_7226) / 2
    audio_note $20, $0a
    audio_note $25, $0a
    audio_note $28, $0a
    audio_note $1f, $0a
.word_61:
    audio_note $27, $0a
    audio_repeat $03, (.word_61 - AudioTrack_7226) / 2
    audio_note $1f, $1e
    audio_repeat $00, $00
    audio_end
