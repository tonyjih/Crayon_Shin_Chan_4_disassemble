; Sound IDs: $0e
AudioTrack_6ae9::
    audio_header $00, $10, $02, $02
.word_02:
    audio_loop_start $fe
.word_03:
    audio_note $20, $0a
    audio_note $24, $0a
    audio_note $27, $0a
    audio_note $29, $0a
    audio_note $2a, $0a
    audio_note $29, $0a
    audio_note $27, $0a
    audio_note $24, $0a
    audio_repeat $01, (.word_03 - AudioTrack_6ae9) / 2
.word_0c:
    audio_note $1a, $0a
    audio_note $22, $0a
    audio_note $25, $0a
    audio_note $27, $0a
    audio_note $28, $0a
    audio_note $27, $0a
    audio_note $25, $0a
    audio_note $22, $0a
    audio_repeat $01, (.word_0c - AudioTrack_6ae9) / 2
    audio_repeat $01, $00
.word_16:
    audio_note $27, $0a
    audio_note $27, $0a
    audio_note $27, $0a
    audio_repeat $0f, (.word_16 - AudioTrack_6ae9) / 2
    audio_duty_or_wave_length $05
.word_1b:
    audio_note $27, $05
    audio_note $27, $05
    audio_repeat $0f, (.word_1b - AudioTrack_6ae9) / 2
    audio_duty_or_wave_length $10
    audio_repeat $00, (.word_02 - AudioTrack_6ae9) / 2
    audio_end
