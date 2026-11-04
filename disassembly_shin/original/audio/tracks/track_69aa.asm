; Sound IDs: $0b
AudioTrack_69aa::
    audio_header $00, $00, $09, $00
    audio_envelope $07, $01
.word_03:
    audio_note $3c, $06
    audio_note $14, $06
    audio_note $15, $06
    audio_note $15, $06
    audio_repeat $00, (.word_03 - AudioTrack_69aa) / 2
    audio_end
