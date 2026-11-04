; Sound IDs: $25
AudioTrack_6ff5::
    audio_header $00, $03, $0b, $00
    audio_loop_start $fe
    audio_envelope $07, $18
.word_04:
    audio_note $1f, $06
    audio_note $37, $06
    audio_note $30, $0c
    audio_note $34, $0c
    audio_note $35, $0c
    audio_note $37, $0c
    audio_note $37, $0c
    audio_note $34, $0c
    audio_note $30, $0c
    audio_note $2a, $12
    audio_note $2a, $1e
    audio_note $2a, $12
    audio_note $2a, $1e
    audio_repeat $01, (.word_04 - AudioTrack_6ff5) / 2
.word_12:
    audio_note $25, $0c
    audio_note $25, $0c
    audio_note $27, $0c
    audio_note $29, $0c
    audio_note $2a, $0c
    audio_note $2a, $0c
    audio_note $29, $0c
    audio_note $27, $0c
    audio_repeat $01, (.word_12 - AudioTrack_6ff5) / 2
    audio_repeat $00, $00
    audio_end
