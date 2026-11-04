; Sound IDs: $05
AudioTrack_65b2::
    audio_header $00, $02, $0c, $00
    audio_envelope $01, $40
    audio_note $1f, $80
    audio_note $1f, $80
.word_05:
    audio_loop_start $fe
.word_06:
    audio_note $1f, $10
    audio_note $34, $18
    audio_note $32, $18
    audio_note $30, $18
    audio_note $30, $10
    audio_note $29, $08
    audio_note $30, $10
    audio_note $2a, $48
    audio_note $25, $08
    audio_note $27, $08
    audio_note $29, $10
    audio_note $27, $08
    audio_note $25, $08
    audio_note $24, $08
    audio_repeat $01, (.word_06 - AudioTrack_65b2) / 2
    audio_note $27, $18
    audio_note $27, $18
    audio_note $27, $10
    audio_note $25, $18
    audio_note $24, $10
    audio_note $22, $08
    audio_note $24, $08
    audio_note $25, $08
    audio_note $27, $18
    audio_note $27, $18
    audio_note $27, $10
    audio_note $25, $18
    audio_note $24, $18
    audio_note $29, $10
    audio_note $2b, $18
    audio_note $2b, $18
    audio_note $2b, $10
    audio_note $29, $18
    audio_note $27, $10
    audio_note $25, $08
    audio_note $27, $08
    audio_note $29, $08
    audio_note $2b, $20
    audio_note $30, $20
    audio_note $32, $10
    audio_note $34, $10
    audio_note $35, $10
    audio_note $37, $10
    audio_note $1f, $10
    audio_note $34, $18
    audio_note $32, $18
    audio_note $30, $18
    audio_note $30, $10
    audio_note $29, $08
    audio_note $30, $10
    audio_note $2a, $48
    audio_note $25, $08
    audio_note $27, $08
    audio_note $29, $10
    audio_note $27, $08
    audio_note $25, $08
    audio_note $24, $08
    audio_note $1f, $10
    audio_note $34, $18
    audio_note $32, $18
    audio_note $37, $18
    audio_note $35, $18
    audio_note $34, $10
    audio_command $fe, $fe
    audio_note $35, $48
    audio_note $32, $08
    audio_note $34, $08
    audio_note $35, $10
    audio_note $32, $08
    audio_note $34, $08
    audio_note $35, $08
    audio_note $27, $18
    audio_note $27, $18
    audio_note $27, $10
    audio_note $25, $18
    audio_note $24, $10
    audio_note $22, $08
    audio_note $24, $08
    audio_note $25, $08
    audio_note $27, $18
    audio_note $27, $18
    audio_note $27, $10
    audio_note $25, $18
    audio_note $24, $18
    audio_note $29, $10
    audio_note $2b, $18
    audio_note $2b, $18
    audio_note $2b, $10
    audio_note $29, $18
    audio_note $27, $10
    audio_note $25, $08
    audio_note $27, $08
    audio_note $29, $08
    audio_note $2b, $20
    audio_note $30, $20
    audio_note $32, $10
    audio_note $34, $10
    audio_note $35, $10
    audio_note $37, $10
.word_69:
    audio_note $30, $10
    audio_note $30, $10
    audio_note $33, $08
    audio_note $34, $08
    audio_note $35, $08
    audio_note $37, $10
    audio_note $37, $10
    audio_note $35, $04
    audio_note $34, $04
    audio_note $35, $08
    audio_note $34, $08
    audio_note $35, $08
    audio_note $34, $08
    audio_repeat $01, (.word_69 - AudioTrack_65b2) / 2
    audio_envelope $04, $10
.word_78:
    audio_note $32, $10
    audio_note $2b, $10
    audio_repeat $01, (.word_78 - AudioTrack_65b2) / 2
.word_7b:
    audio_note $32, $08
    audio_note $2b, $08
    audio_repeat $03, (.word_7b - AudioTrack_65b2) / 2
    audio_envelope $01, $40
    audio_repeat $00, (.word_05 - AudioTrack_65b2) / 2
    audio_end
