; Sound IDs: $50
AudioTrack_7afc::
    audio_header $00, $00, $0f, $00
.word_02:
    audio_envelope $01, $01
    audio_note $2a, $01
    audio_note $34, $01
    audio_repeat $0f, (.word_02 - AudioTrack_7afc) / 2
    audio_end
