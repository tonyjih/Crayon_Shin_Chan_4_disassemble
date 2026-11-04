; Sound IDs: $4d
AudioTrack_7ad3::
    audio_header $03, $00, $07, $00
.word_02:
    audio_envelope $07, $01
    audio_note $40, $01
    audio_note $20, $01
    audio_repeat $03, (.word_02 - AudioTrack_7ad3) / 2
    audio_note $40, $02
    audio_end
