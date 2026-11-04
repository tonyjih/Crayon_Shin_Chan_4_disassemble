; Sound IDs: $3e
AudioTrack_78e4::
    audio_header $00, $0c, $02, $02
    audio_loop_start $fe
    audio_note $30, $0c
    audio_note $30, $0c
    audio_note $30, $12
    audio_note $31, $0c
    audio_note $31, $0c
    audio_note $31, $06
    audio_note $31, $18
    audio_note $32, $0c
    audio_note $32, $0c
    audio_note $32, $12
    audio_note $32, $0c
    audio_note $32, $0c
    audio_note $32, $06
    audio_note $32, $18
    audio_repeat $01, $00
.word_12:
    audio_duty_or_wave_length $20
.word_13:
    audio_note $20, $0c
    audio_note $17, $0c
    audio_repeat $03, (.word_13 - AudioTrack_78e4) / 2
.word_16:
    audio_note $24, $0c
    audio_note $1b, $0c
    audio_repeat $03, (.word_16 - AudioTrack_78e4) / 2
.word_19:
    audio_note $25, $0c
    audio_note $20, $0c
    audio_repeat $01, (.word_19 - AudioTrack_78e4) / 2
.word_1c:
    audio_note $27, $0c
    audio_note $22, $0c
    audio_repeat $01, (.word_1c - AudioTrack_78e4) / 2
.word_1f:
    audio_note $20, $0c
    audio_note $17, $0c
    audio_repeat $01, (.word_1f - AudioTrack_78e4) / 2
.word_22:
    audio_note $27, $0c
    audio_note $22, $0c
    audio_repeat $01, (.word_22 - AudioTrack_78e4) / 2
.word_25:
    audio_note $20, $0c
    audio_note $17, $0c
    audio_repeat $03, (.word_25 - AudioTrack_78e4) / 2
.word_28:
    audio_note $24, $0c
    audio_note $1b, $0c
    audio_repeat $03, (.word_28 - AudioTrack_78e4) / 2
.word_2b:
    audio_note $25, $0c
    audio_note $20, $0c
    audio_repeat $01, (.word_2b - AudioTrack_78e4) / 2
.word_2e:
    audio_note $27, $0c
    audio_note $22, $0c
    audio_repeat $01, (.word_2e - AudioTrack_78e4) / 2
    audio_note $1f, $0c
    audio_note $20, $18
    audio_note $20, $0c
    audio_note $25, $12
    audio_note $20, $12
    audio_note $23, $0c
.word_37:
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $28, $0c
    audio_note $30, $0c
    audio_note $2a, $0c
    audio_note $28, $0c
    audio_note $27, $0c
    audio_note $25, $0c
    audio_note $23, $0c
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $22, $0c
    audio_note $20, $0c
    audio_note $23, $0c
    audio_note $27, $0c
    audio_note $23, $0c
    audio_repeat $01, (.word_37 - AudioTrack_78e4) / 2
.word_48:
    audio_note $28, $0c
    audio_note $23, $0c
    audio_repeat $03, (.word_48 - AudioTrack_78e4) / 2
.word_4b:
    audio_note $27, $0c
    audio_repeat $04, (.word_4b - AudioTrack_78e4) / 2
    audio_note $22, $0c
    audio_note $1b, $0c
    audio_note $17, $0c
.word_50:
    audio_note $25, $0c
    audio_note $25, $0c
    audio_note $29, $0c
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $27, $0c
    audio_note $2b, $0c
    audio_note $27, $0c
    audio_note $20, $0c
    audio_note $20, $0c
    audio_note $24, $0c
    audio_note $27, $0c
    audio_note $30, $0c
    audio_note $27, $0c
    audio_note $24, $0c
    audio_note $20, $0c
    audio_repeat $01, (.word_50 - AudioTrack_78e4) / 2
    audio_note $25, $0c
    audio_note $25, $0c
    audio_note $29, $0c
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $27, $0c
    audio_note $2b, $0c
    audio_note $27, $0c
.word_69:
    audio_note $29, $0c
    audio_repeat $05, (.word_69 - AudioTrack_78e4) / 2
    audio_note $27, $0c
    audio_note $27, $0c
.word_6d:
    audio_note $25, $0c
    audio_repeat $07, (.word_6d - AudioTrack_78e4) / 2
.word_6f:
    audio_note $27, $0c
    audio_repeat $07, (.word_6f - AudioTrack_78e4) / 2
.word_71:
    audio_note $20, $0c
    audio_repeat $07, (.word_71 - AudioTrack_78e4) / 2
    audio_note $27, $0c
    audio_note $27, $0c
    audio_note $2b, $0c
    audio_note $27, $06
    audio_note $30, $0c
    audio_note $30, $0c
    audio_note $27, $06
    audio_note $32, $0c
    audio_note $27, $0c
    audio_repeat $00, (.word_12 - AudioTrack_78e4) / 2
    audio_end
