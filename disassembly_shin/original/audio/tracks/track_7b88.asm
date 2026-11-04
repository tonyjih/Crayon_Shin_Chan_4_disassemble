; Sound IDs: $58
AudioTrack_7b88::
    audio_header $00, $00, $07, $00
.word_02:
    audio_envelope $07, $02
    audio_note $5c, $0a
    audio_note $32, $05
    audio_repeat $03, (.word_02 - AudioTrack_7b88) / 2
    audio_note $5c, $0f
    audio_note $32, $0f
    audio_note $32, $0f
    audio_end
