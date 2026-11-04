; Sound IDs: $00
AudioTrack_63a5::
    audio_header $00, $02, $0b, $00
.word_02:
    audio_loop_start $fe
    audio_envelope $09, $06
    audio_note $30, $0c
    audio_note $30, $0c
    audio_note $34, $06
    audio_note $30, $06
    audio_note $34, $06
    audio_note $30, $06
    audio_note $1f, $06
    audio_note $37, $12
    audio_note $39, $18
    audio_note $30, $0c
    audio_note $30, $0c
    audio_note $34, $06
    audio_note $30, $06
    audio_note $34, $06
    audio_note $30, $06
    audio_note $1f, $06
    audio_note $29, $12
    audio_note $2b, $18
    audio_repeat $03, $00
    audio_loop_start $fe
    audio_note $32, $0c
    audio_note $32, $0c
    audio_note $32, $06
    audio_note $30, $06
    audio_note $32, $06
    audio_note $30, $06
    audio_note $34, $12
    audio_note $34, $12
    audio_note $33, $0c
    audio_repeat $02, $00
    audio_note $37, $0c
    audio_note $37, $0c
    audio_note $3b, $06
    audio_note $39, $12
    audio_note $37, $30
    audio_repeat $00, (.word_02 - AudioTrack_63a5) / 2
    audio_end
