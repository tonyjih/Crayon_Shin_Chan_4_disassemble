; Sound IDs: $3f
AudioTrack_79df::
    audio_header $00, $00, $0d, $00
.word_02:
    audio_envelope $07, $04
    audio_pan $0f
    audio_note $06, $0c
    audio_note $03, $0c
    audio_pan $01
    audio_note $06, $06
    audio_note $06, $06
    audio_note $03, $06
    audio_pan $01
    audio_note $06, $0c
    audio_note $06, $0c
    audio_pan $01
    audio_note $03, $06
    audio_pan $01
    audio_note $06, $0c
    audio_pan $01
    audio_note $03, $0c
    audio_repeat $03, (.word_02 - AudioTrack_79df) / 2
.word_14:
    audio_envelope $07, $01
    audio_pan $01
    audio_note $0b, $06
    audio_note $06, $06
    audio_note $06, $06
    audio_note $06, $06
    audio_pan $01
    audio_note $09, $06
    audio_note $06, $06
    audio_note $06, $06
    audio_note $06, $06
    audio_repeat $00, (.word_14 - AudioTrack_79df) / 2
    audio_end
