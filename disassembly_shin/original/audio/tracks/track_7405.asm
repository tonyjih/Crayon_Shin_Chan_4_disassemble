; Sound IDs: $2d
AudioTrack_7405::
    audio_header $00, $01, $0c, $00
    audio_envelope $04, $0b
.word_03:
    audio_note $2a, $0a
    audio_repeat $0e, (.word_03 - AudioTrack_7405) / 2
.word_05:
    audio_loop_start $fe
    audio_note $25, $03
    audio_note $27, $03
    audio_note $29, $04
    audio_note $2a, $0a
    audio_note $2a, $0a
    audio_note $29, $0a
    audio_note $29, $0a
    audio_note $27, $0a
    audio_note $27, $0a
    audio_note $25, $0f
    audio_note $27, $0a
    audio_note $1f, $41
    audio_note $25, $03
    audio_note $27, $03
    audio_note $29, $04
    audio_note $2a, $0a
    audio_note $2a, $0a
    audio_note $29, $0a
    audio_note $29, $0a
    audio_note $27, $0a
    audio_note $29, $0a
    audio_note $32, $0f
    audio_note $30, $0a
    audio_note $1f, $41
    audio_repeat $01, $00
    audio_note $1f, $0a
    audio_note $2a, $0a
    audio_note $2a, $0a
    audio_note $1f, $0a
    audio_note $2a, $1e
    audio_note $27, $05
    audio_note $29, $05
    audio_note $2a, $0a
    audio_note $29, $14
    audio_note $27, $0a
    audio_note $29, $0a
    audio_note $1f, $28
    audio_note $2a, $0a
    audio_note $2a, $0a
    audio_note $1f, $0a
    audio_note $2a, $1e
    audio_note $27, $05
    audio_note $29, $05
    audio_note $2a, $0a
    audio_note $30, $14
    audio_note $32, $0a
    audio_note $30, $32
    audio_note $2a, $0a
    audio_note $2a, $0a
    audio_note $1f, $0a
    audio_note $2a, $1e
    audio_note $27, $05
    audio_note $29, $05
    audio_note $2a, $0a
    audio_note $29, $14
    audio_note $25, $0a
    audio_note $29, $14
    audio_note $25, $0a
    audio_note $29, $14
    audio_note $1f, $0a
    audio_loop_start $fe
    audio_note $30, $0a
    audio_note $32, $0a
    audio_repeat $04, $00
    audio_note $32, $0a
    audio_note $32, $0a
    audio_note $1f, $14
    audio_repeat $00, (.word_05 - AudioTrack_7405) / 2
    audio_end
