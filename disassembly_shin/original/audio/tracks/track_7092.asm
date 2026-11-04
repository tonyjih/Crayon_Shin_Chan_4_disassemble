; Sound IDs: $28
AudioTrack_7092::
    audio_header $00, $00, $0c, $00
    audio_envelope $01, $05
    audio_note $3b, $05
    audio_note $3b, $0a
    audio_note $3b, $05
.word_06:
    audio_note $3b, $0a
    audio_repeat $02, (.word_06 - AudioTrack_7092) / 2
    audio_note $1f, $1e
    audio_loop_start $fe
    audio_pan $0f
    audio_envelope $01, $05
.word_0c:
    audio_pan $01
    audio_note $40, $05
    audio_note $44, $05
    audio_note $40, $05
    audio_note $44, $05
    audio_repeat $05, (.word_0c - AudioTrack_7092) / 2
    audio_envelope $01, $20
.word_13:
    audio_pan $ff
    audio_volume $0a
    audio_note $39, $0a
    audio_repeat $02, (.word_13 - AudioTrack_7092) / 2
    audio_note $37, $0a
    audio_envelope $01, $05
    audio_volume $0c
    audio_pan $0f
.word_1b:
    audio_pan $01
    audio_note $42, $05
    audio_note $45, $05
    audio_note $42, $05
    audio_note $45, $05
    audio_repeat $03, (.word_1b - AudioTrack_7092) / 2
.word_21:
    audio_pan $01
    audio_note $37, $05
    audio_note $3b, $05
    audio_note $37, $05
    audio_note $3b, $05
    audio_repeat $01, (.word_21 - AudioTrack_7092) / 2
    audio_pan $ff
    audio_envelope $01, $20
    audio_volume $0a
    audio_note $49, $0a
    audio_note $4b, $0a
    audio_note $49, $0a
    audio_note $47, $0a
    audio_envelope $01, $05
    audio_volume $0c
    audio_pan $f0
.word_31:
    audio_pan $01
    audio_note $40, $05
    audio_note $44, $05
    audio_note $40, $05
    audio_note $44, $05
    audio_repeat $05, (.word_31 - AudioTrack_7092) / 2
    audio_pan $ff
    audio_volume $0a
    audio_envelope $01, $20
    audio_note $49, $0a
    audio_note $47, $0a
    audio_note $45, $0a
    audio_note $44, $0a
    audio_envelope $01, $40
    audio_note $42, $28
    audio_note $44, $28
    audio_note $1f, $0a
    audio_envelope $01, $05
.word_43:
    audio_note $50, $0a
    audio_repeat $03, (.word_43 - AudioTrack_7092) / 2
    audio_note $1f, $1e
    audio_duty_or_wave_length $02
    audio_volume $06
    audio_envelope $02, $05
    audio_note $39, $32
    audio_note $35, $0a
    audio_note $37, $0a
    audio_note $39, $0a
    audio_note $37, $1e
    audio_note $34, $1e
    audio_note $34, $14
    audio_note $34, $1e
    audio_note $34, $1e
    audio_note $30, $0a
    audio_note $32, $0a
    audio_envelope $04, $40
    audio_note $29, $50
    audio_envelope $01, $0a
    audio_duty_or_wave_length $00
    audio_volume $0c
    audio_pan $f0
.word_5a:
    audio_note $39, $0a
    audio_note $32, $0a
    audio_note $35, $0a
    audio_note $39, $0a
    audio_repeat $01, (.word_5a - AudioTrack_7092) / 2
.word_5f:
    audio_pan $0f
    audio_note $3b, $0a
    audio_note $37, $0a
    audio_note $34, $0a
    audio_note $37, $0a
    audio_repeat $01, (.word_5f - AudioTrack_7092) / 2
.word_65:
    audio_pan $01
    audio_note $43, $0a
    audio_note $40, $0a
    audio_note $38, $0a
    audio_repeat $01, (.word_65 - AudioTrack_7092) / 2
    audio_pan $01
    audio_note $43, $0a
    audio_pan $01
    audio_note $40, $0a
    audio_pan $ff
    audio_note $1f, $0a
.word_70:
    audio_note $3b, $0a
    audio_repeat $03, (.word_70 - AudioTrack_7092) / 2
    audio_note $39, $0a
    audio_note $37, $0a
    audio_note $1f, $0a
    audio_repeat $00, $00
    audio_end
