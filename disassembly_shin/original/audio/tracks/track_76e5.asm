; Sound IDs: $3b
AudioTrack_76e5::
    audio_header $01, $00, $05, $00
    audio_envelope $01, $06
.word_03:
    audio_note $0b, $06
    audio_note $06, $03
    audio_repeat $03, (.word_03 - AudioTrack_76e5) / 2
    audio_envelope $03, $30
    audio_note $0f, $0c
    audio_end
