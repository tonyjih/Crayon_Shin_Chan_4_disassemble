; Sound IDs: $0d
AudioTrack_6a62::
    audio_header $00, $01, $0c, $00
    audio_envelope $01, $24
    audio_loop_start $fe
.word_04:
    audio_note $33, $02
    audio_note $34, $12
    audio_note $32, $14
    audio_note $2b, $02
    audio_note $30, $08
    audio_note $29, $0a
    audio_note $30, $0a
    audio_note $30, $0a
    audio_note $33, $02
    audio_note $34, $12
    audio_note $32, $14
    audio_note $2b, $02
    audio_note $30, $08
    audio_note $29, $0a
    audio_note $30, $0a
    audio_note $30, $0a
    audio_note $29, $02
    audio_note $2a, $12
    audio_note $29, $14
    audio_note $26, $02
    audio_note $27, $08
    audio_note $25, $0a
    audio_note $27, $0a
    audio_note $29, $0a
    audio_note $29, $02
    audio_note $2a, $12
    audio_note $29, $14
    audio_note $26, $02
    audio_note $27, $08
    audio_note $29, $0a
    audio_note $32, $0a
    audio_note $30, $0a
    audio_repeat $01, (.word_04 - AudioTrack_6a62) / 2
    audio_note $27, $28
    audio_note $25, $0a
    audio_note $22, $14
    audio_note $25, $0a
    audio_note $27, $32
    audio_note $27, $0a
    audio_note $29, $0a
    audio_note $2a, $0a
    audio_note $2b, $28
    audio_note $29, $0a
    audio_note $25, $14
    audio_note $29, $0a
    audio_note $2b, $32
    audio_note $2b, $0a
    audio_note $30, $0a
    audio_note $31, $0a
    audio_note $32, $1e
    audio_note $32, $0a
    audio_note $30, $0a
    audio_note $29, $14
    audio_note $30, $0a
    audio_note $32, $32
    audio_note $32, $0a
    audio_note $34, $0a
    audio_note $35, $0a
    audio_note $37, $28
    audio_note $37, $28
.word_40:
    audio_note $37, $14
    audio_repeat $03, (.word_40 - AudioTrack_6a62) / 2
    audio_repeat $00, $00
    audio_end
