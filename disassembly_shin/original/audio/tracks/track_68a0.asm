; Sound IDs: $09
AudioTrack_68a0::
    audio_header $00, $01, $0c, $00
    audio_note $1f, $c0
.word_03:
    audio_loop_start $fe
    audio_envelope $01, $20
.word_05:
    audio_note $34, $0c
    audio_note $34, $0c
    audio_note $34, $0c
    audio_note $32, $0c
    audio_note $30, $12
    audio_note $30, $0c
    audio_note $29, $06
    audio_note $30, $0c
    audio_note $2a, $30
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $29, $0c
    audio_note $27, $0c
    audio_note $1f, $48
    audio_note $25, $06
    audio_note $24, $06
    audio_note $22, $06
    audio_note $24, $06
    audio_note $25, $60
    audio_repeat $01, (.word_05 - AudioTrack_68a0) / 2
.word_19:
    audio_note $2b, $0c
    audio_repeat $03, (.word_19 - AudioTrack_68a0) / 2
    audio_note $29, $06
    audio_note $27, $06
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $29, $0c
    audio_note $2b, $48
    audio_note $2b, $0c
    audio_note $30, $0c
.word_23:
    audio_note $32, $0c
    audio_repeat $03, (.word_23 - AudioTrack_68a0) / 2
    audio_note $30, $06
    audio_note $2b, $06
    audio_note $29, $0c
    audio_note $30, $0c
    audio_note $34, $0c
    audio_note $32, $60
    audio_repeat $01, $00
.word_2c:
    audio_note $1f, $18
    audio_note $37, $18
    audio_note $35, $0c
    audio_note $32, $18
    audio_note $35, $0c
    audio_note $37, $0c
    audio_note $37, $0c
    audio_note $35, $0c
    audio_note $37, $3c
    audio_note $1f, $18
    audio_note $37, $18
    audio_note $35, $0c
    audio_note $32, $0c
    audio_note $35, $0c
    audio_note $37, $6c
    audio_repeat $01, (.word_2c - AudioTrack_68a0) / 2
    audio_repeat $00, (.word_03 - AudioTrack_68a0) / 2
    audio_end
