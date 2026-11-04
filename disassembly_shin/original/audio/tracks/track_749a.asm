; Sound IDs: $2e
AudioTrack_749a::
    audio_header $00, $0c, $02, $02
.word_02:
    audio_note $20, $0a
    audio_repeat $0f, (.word_02 - AudioTrack_749a) / 2
.word_04:
    audio_loop_start $fe
.word_05:
    audio_note $20, $0a
    audio_note $20, $0a
    audio_note $24, $0a
    audio_note $20, $0a
    audio_repeat $01, (.word_05 - AudioTrack_749a) / 2
    audio_note $20, $0a
    audio_note $20, $0a
    audio_note $24, $0a
    audio_note $24, $0a
    audio_note $27, $0a
    audio_note $27, $0a
    audio_note $2a, $0a
    audio_note $2a, $0a
.word_12:
    audio_note $20, $0a
    audio_note $20, $0a
    audio_note $24, $0a
    audio_note $20, $0a
    audio_repeat $01, (.word_12 - AudioTrack_749a) / 2
.word_17:
    audio_note $20, $0a
    audio_note $20, $0a
    audio_note $1a, $0a
    audio_note $1a, $0a
    audio_repeat $01, (.word_17 - AudioTrack_749a) / 2
    audio_repeat $01, $00
    audio_loop_start $fe
    audio_duty_or_wave_length $06
    audio_note $23, $0a
    audio_note $23, $0a
    audio_note $23, $05
    audio_note $23, $05
    audio_note $1f, $05
    audio_note $23, $05
    audio_note $23, $0a
    audio_note $1a, $0a
    audio_note $20, $0a
    audio_note $23, $0a
    audio_note $25, $0a
    audio_note $25, $0a
    audio_note $25, $05
    audio_note $25, $05
    audio_note $1f, $05
    audio_note $25, $05
    audio_note $25, $0a
    audio_note $20, $0a
    audio_note $22, $0a
    audio_note $25, $0a
    audio_note $23, $0a
    audio_note $23, $0a
    audio_note $23, $05
    audio_note $23, $05
    audio_note $1f, $05
    audio_note $23, $05
    audio_note $23, $0a
    audio_note $1a, $0a
    audio_note $20, $0a
    audio_note $23, $0a
    audio_note $25, $0a
    audio_note $25, $0a
    audio_note $25, $05
    audio_note $25, $05
    audio_note $1f, $05
    audio_note $25, $05
    audio_note $30, $0a
    audio_note $25, $0a
    audio_note $30, $0a
    audio_note $25, $0a
    audio_note $23, $0a
    audio_note $23, $0a
    audio_note $23, $05
    audio_note $23, $05
    audio_note $1f, $05
    audio_note $23, $05
    audio_note $23, $0a
    audio_note $1a, $0a
    audio_note $20, $0a
    audio_note $23, $0a
    audio_note $22, $0a
    audio_note $22, $0a
    audio_note $22, $05
    audio_note $22, $05
    audio_note $1f, $05
    audio_note $22, $05
    audio_note $29, $0a
    audio_note $22, $0a
    audio_note $29, $0a
    audio_note $22, $0a
    audio_note $27, $0a
    audio_note $27, $0a
    audio_note $2b, $05
    audio_note $1f, $05
    audio_note $2b, $05
    audio_note $30, $05
    audio_note $1f, $05
    audio_note $30, $05
    audio_note $1f, $05
    audio_note $30, $05
    audio_note $31, $0a
    audio_note $31, $0a
.word_67:
    audio_note $32, $0a
    audio_repeat $04, (.word_67 - AudioTrack_749a) / 2
    audio_note $1f, $1e
    audio_duty_or_wave_length $10
    audio_repeat $00, (.word_04 - AudioTrack_749a) / 2
    audio_end
