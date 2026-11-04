; Sound IDs: $5b
AudioTrack_7bb1::
    audio_header $00, $00, $1f, $2f
.word_02:
    audio_note $40, $03
    audio_note $1f, $0d
    audio_repeat $03, (.word_02 - AudioTrack_7bb1) / 2
    audio_end
