; Sound IDs: $61
AudioTrack_7ce5::
    audio_header $00, $01, $0c, $00
    audio_note $1f, $78
.word_03:
    audio_envelope $01, $19
    audio_loop_start $fe
    audio_note $30, $04
    audio_note $30, $04
.word_07:
    audio_note $30, $08
    audio_repeat $03, (.word_07 - AudioTrack_7ce5) / 2
    audio_note $34, $08
    audio_note $35, $08
    audio_note $37, $08
    audio_repeat $01, $00
    audio_note $1f, $08
    audio_note $33, $08
    audio_note $23, $08
    audio_note $33, $08
    audio_note $23, $08
    audio_note $37, $08
    audio_note $39, $08
    audio_note $3a, $10
    audio_note $39, $08
    audio_note $37, $10
    audio_note $37, $20
    audio_loop_start $fe
    audio_note $30, $04
    audio_note $30, $04
.word_1b:
    audio_note $30, $08
    audio_repeat $03, (.word_1b - AudioTrack_7ce5) / 2
    audio_note $34, $08
    audio_note $35, $08
    audio_note $37, $08
    audio_repeat $01, $00
    audio_note $1f, $08
    audio_note $42, $10
    audio_note $42, $10
    audio_note $40, $08
    audio_note $3b, $08
    audio_note $39, $10
.word_27:
    audio_note $3b, $08
    audio_repeat $03, (.word_27 - AudioTrack_7ce5) / 2
    audio_note $3b, $20
    audio_note $39, $10
    audio_note $39, $10
.word_2c:
    audio_note $34, $04
    audio_note $35, $04
    audio_note $37, $04
    audio_note $39, $04
    audio_repeat $01, (.word_2c - AudioTrack_7ce5) / 2
    audio_note $37, $10
    audio_note $35, $10
    audio_note $34, $08
    audio_note $32, $10
    audio_note $30, $08
    audio_note $32, $10
    audio_note $32, $10
    audio_note $2b, $04
    audio_note $30, $04
    audio_note $32, $10
    audio_note $30, $10
    audio_note $32, $10
    audio_note $34, $10
    audio_note $37, $10
    audio_note $37, $08
    audio_note $39, $10
    audio_note $39, $10
.word_42:
    audio_note $34, $04
    audio_note $35, $04
    audio_note $37, $04
    audio_note $39, $04
    audio_repeat $01, (.word_42 - AudioTrack_7ce5) / 2
    audio_note $37, $10
    audio_note $35, $10
    audio_note $34, $08
    audio_note $32, $10
    audio_note $30, $08
    audio_note $33, $10
    audio_note $37, $10
    audio_note $35, $10
    audio_note $39, $10
    audio_note $3b, $08
    audio_note $3a, $08
    audio_note $39, $08
    audio_note $38, $08
    audio_note $37, $18
    audio_repeat $00, (.word_03 - AudioTrack_7ce5) / 2
    audio_end
