; Sound IDs: $36
AudioTrack_7674::
    audio_header $00, $10, $02, $02
.word_02:
    audio_note $30, $0c
    audio_repeat $05, (.word_02 - AudioTrack_7674) / 2
    audio_duty_or_wave_length $40
    audio_note $27, $30
    audio_end
