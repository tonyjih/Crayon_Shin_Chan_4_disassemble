; Sound IDs: $1d
AudioTrack_6ca0::
    audio_header $01, $02, $0f, $00
    audio_loop_start $fe
    audio_envelope $01, $0c
    audio_note $30, $06
    audio_note $34, $06
    audio_note $35, $06
    audio_note $37, $06
    audio_note $39, $06
    audio_note $3b, $0c
    audio_note $39, $06
    audio_note $37, $1e
    audio_note $34, $0c
    audio_note $37, $06
    audio_note $39, $1e
    audio_note $35, $0c
    audio_note $34, $06
    audio_note $32, $06
    audio_duty_or_wave_length $00
    audio_envelope $05, $0c
    audio_volume $05
    audio_note $3b, $06
    audio_note $39, $06
    audio_note $37, $06
    audio_note $39, $06
    audio_note $37, $06
    audio_note $35, $06
    audio_note $37, $06
    audio_volume $0f
    audio_duty_or_wave_length $02
    audio_envelope $01, $0c
    audio_note $30, $06
    audio_note $34, $06
    audio_note $35, $06
    audio_note $37, $06
    audio_note $39, $06
    audio_note $3b, $0c
    audio_note $39, $06
    audio_note $37, $1e
    audio_note $39, $0c
    audio_note $3b, $06
    audio_note $40, $1e
    audio_note $37, $06
    audio_note $35, $06
    audio_note $34, $06
    audio_note $32, $06
    audio_duty_or_wave_length $00
    audio_volume $05
    audio_envelope $05, $0c
    audio_note $3b, $06
    audio_note $3b, $06
    audio_note $3b, $06
    audio_note $40, $06
    audio_note $3b, $06
    audio_note $40, $06
    audio_note $42, $06
    audio_volume $0f
    audio_duty_or_wave_length $02
    audio_envelope $01, $18
.word_3b:
    audio_note $1f, $06
    audio_note $39, $06
    audio_note $39, $06
    audio_note $39, $06
    audio_note $39, $0c
    audio_note $39, $0c
    audio_note $37, $06
    audio_note $37, $06
    audio_note $34, $06
    audio_note $37, $1e
    audio_repeat $01, (.word_3b - AudioTrack_6ca0) / 2
    audio_note $35, $0c
    audio_note $34, $0c
    audio_note $32, $0c
    audio_note $30, $0c
    audio_note $32, $0c
    audio_note $34, $0c
    audio_note $35, $06
    audio_note $34, $06
    audio_note $35, $06
    audio_note $37, $06
    audio_repeat $00, $00
    audio_end
