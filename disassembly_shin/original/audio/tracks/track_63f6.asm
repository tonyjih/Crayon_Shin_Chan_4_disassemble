; Sound IDs: $01
AudioTrack_63f6::
    audio_header $00, $02, $0b, $00
.word_02:
    audio_loop_start $fe
    audio_vibrato $40
    audio_note $1f, $01
    audio_envelope $09, $06
    audio_note $24, $0c
    audio_note $24, $0c
    audio_note $27, $06
    audio_note $24, $06
    audio_note $27, $06
    audio_note $24, $06
    audio_note $1f, $06
    audio_note $2b, $12
    audio_note $30, $18
    audio_note $24, $0c
    audio_note $24, $0c
    audio_note $27, $06
    audio_note $24, $06
    audio_note $27, $06
    audio_note $24, $06
    audio_note $1f, $06
    audio_note $20, $12
    audio_note $22, $17
    audio_repeat $03, $00
    audio_loop_start $fe
    audio_note $1f, $01
    audio_note $25, $0c
    audio_note $25, $0c
    audio_note $25, $06
    audio_note $22, $06
    audio_note $25, $06
    audio_note $22, $06
    audio_note $27, $12
    audio_note $27, $12
    audio_note $26, $0b
    audio_repeat $02, $00
    audio_note $1f, $01
    audio_note $2b, $0c
    audio_note $2b, $0c
    audio_note $32, $06
    audio_note $30, $12
    audio_note $2b, $2f
    audio_repeat $00, (.word_02 - AudioTrack_63f6) / 2
    audio_end
