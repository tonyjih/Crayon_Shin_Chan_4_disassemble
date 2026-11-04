; Sound IDs: $4e
AudioTrack_7ae2::
    audio_header $04, $01, $08, $00
.word_02:
    audio_envelope $01, $01
    audio_note $47, $01
    audio_note $47, $01
    audio_note $47, $01
    audio_note $47, $01
    audio_repeat $0e, (.word_02 - AudioTrack_7ae2) / 2
    audio_end
