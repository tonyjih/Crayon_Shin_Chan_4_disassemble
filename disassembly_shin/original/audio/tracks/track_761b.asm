; Sound IDs: $33
AudioTrack_761b::
    audio_header $00, $00, $08, $00
    audio_envelope $01, $10
    audio_note $31, $06
    audio_note $31, $06
    audio_note $31, $06
.word_06:
    audio_note $31, $0c
    audio_note $21, $06
    audio_note $21, $0c
    audio_note $21, $06
    audio_note $31, $12
    audio_note $42, $12
    audio_repeat $01, (.word_06 - AudioTrack_761b) / 2
.word_0d:
    audio_note $31, $12
    audio_note $42, $12
    audio_repeat $01, (.word_0d - AudioTrack_761b) / 2
.word_10:
    audio_note $22, $0c
    audio_note $11, $06
    audio_repeat $03, (.word_10 - AudioTrack_761b) / 2
    audio_end
