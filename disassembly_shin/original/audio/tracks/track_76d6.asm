; Sound IDs: $3a
AudioTrack_76d6::
    audio_header $01, $0c, $02, $02
.word_02:
    audio_note $20, $06
    audio_note $20, $03
    audio_repeat $03, (.word_02 - AudioTrack_76d6) / 2
    audio_duty_or_wave_length $30
    audio_note $22, $24
    audio_end
