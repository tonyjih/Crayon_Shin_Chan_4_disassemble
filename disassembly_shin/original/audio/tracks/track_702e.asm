; Sound IDs: $26
AudioTrack_702e::
    audio_header $00, $10, $02, $02
    audio_loop_start $fe
.word_03:
    audio_note $30, $0c
    audio_note $30, $0c
    audio_note $27, $0c
    audio_note $27, $0c
    audio_note $30, $0c
    audio_note $30, $0c
    audio_note $27, $0c
    audio_note $27, $0c
    audio_note $2a, $12
    audio_note $2a, $1e
    audio_note $2a, $12
    audio_note $2a, $1e
    audio_repeat $01, (.word_03 - AudioTrack_702e) / 2
.word_10:
    audio_note $25, $0c
    audio_note $24, $0c
    audio_note $22, $0c
    audio_note $20, $0c
    audio_note $20, $0c
    audio_note $20, $0c
    audio_note $22, $0c
    audio_note $24, $0c
    audio_repeat $01, (.word_10 - AudioTrack_702e) / 2
    audio_repeat $00, $00
    audio_end
