; Sound IDs: $48
AudioTrack_7a76::
    audio_header $00, $02, $0a, $26
.word_02:
    audio_volume_up $03, $06
    audio_note $16, $09
    audio_note $17, $09
    audio_repeat $03, (.word_02 - AudioTrack_7a76) / 2
    audio_end
