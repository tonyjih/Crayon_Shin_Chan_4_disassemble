; Sound IDs: $13
AudioTrack_6bc8::
    audio_header $01, $00, $07, $00
    audio_envelope $05, $03
.word_03:
    audio_pan $0f
    audio_note $0a, $0c
    audio_pan $01
    audio_note $0a, $0c
    audio_pan $01
    audio_note $04, $0c
    audio_pan $01
    audio_note $0a, $0c
    audio_repeat $01, (.word_03 - AudioTrack_6bc8) / 2
    audio_pan $01
    audio_note $0a, $0c
    audio_pan $01
    audio_note $0a, $0d
    audio_pan $01
    audio_note $04, $10
    audio_pan $01
    audio_note $0a, $12
    audio_pan $ff
    audio_note $0a, $30
    audio_end
