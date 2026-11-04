; Sound IDs: $60
AudioTrack_7bf8::
    audio_header $00, $00, $0c, $00
    audio_pitch_offset $77
.word_03:
    audio_pan $0f
    audio_note $47, $10
    audio_pan $f0
    audio_note $44, $10
    audio_repeat $03, (.word_03 - AudioTrack_7bf8) / 2
.word_08:
    audio_pitch_offset $00
    audio_envelope $01, $01
.word_0a:
    audio_pan $01
    audio_note $44, $04
    audio_note $4a, $04
    audio_note $47, $04
    audio_note $40, $04
    audio_note $44, $04
    audio_note $47, $04
    audio_note $4a, $04
    audio_note $40, $04
    audio_repeat $03, (.word_0a - AudioTrack_7bf8) / 2
    audio_envelope $01, $20
    audio_pan $0f
    audio_note $4a, $08
    audio_note $43, $08
    audio_note $47, $08
    audio_note $4a, $08
    audio_pan $f0
    audio_note $40, $08
    audio_note $45, $08
    audio_note $49, $08
    audio_note $40, $08
    audio_pan $01
    audio_note $40, $08
    audio_pan $01
    audio_note $47, $08
    audio_pan $01
    audio_note $40, $08
    audio_pan $01
    audio_note $47, $08
    audio_note $1f, $08
    audio_pitch_offset $5d
    audio_note $37, $18
    audio_pitch_offset $00
.word_2b:
    audio_envelope $01, $01
    audio_pan $01
    audio_note $44, $04
    audio_note $4a, $04
    audio_note $47, $04
    audio_note $40, $04
    audio_note $44, $04
    audio_note $47, $04
    audio_note $4a, $04
    audio_note $40, $04
    audio_repeat $03, (.word_2b - AudioTrack_7bf8) / 2
    audio_envelope $01, $20
    audio_pan $ff
    audio_volume $0a
    audio_note $3b, $10
    audio_note $3b, $10
    audio_note $39, $08
    audio_note $37, $08
    audio_note $36, $10
.word_3e:
    audio_note $37, $08
    audio_repeat $03, (.word_3e - AudioTrack_7bf8) / 2
    audio_note $37, $20
    audio_volume $0c
.word_42:
    audio_envelope $04, $10
    audio_pan $0f
    audio_note $29, $10
    audio_pan $01
    audio_note $25, $10
    audio_repeat $01, (.word_42 - AudioTrack_7bf8) / 2
.word_48:
    audio_pan $01
    audio_note $24, $10
    audio_pan $01
    audio_note $20, $10
    audio_repeat $01, (.word_48 - AudioTrack_7bf8) / 2
    audio_pan $01
    audio_note $2b, $10
    audio_pan $01
    audio_note $27, $10
    audio_pan $01
    audio_note $2b, $10
    audio_pan $01
    audio_note $27, $08
    audio_pan $0f
    audio_note $40, $10
    audio_note $3b, $08
    audio_note $39, $08
    audio_note $37, $08
    audio_note $35, $08
    audio_note $34, $08
    audio_note $32, $08
    audio_note $30, $08
    audio_envelope $01, $01
    audio_loop_start $fe
    audio_pan $01
.word_61:
    audio_note $29, $04
    audio_repeat $03, (.word_61 - AudioTrack_7bf8) / 2
.word_63:
    audio_note $30, $04
    audio_repeat $03, (.word_63 - AudioTrack_7bf8) / 2
    audio_repeat $01, $00
    audio_loop_start $fe
    audio_pan $01
.word_68:
    audio_note $24, $04
    audio_repeat $03, (.word_68 - AudioTrack_7bf8) / 2
.word_6a:
    audio_note $27, $04
    audio_repeat $03, (.word_6a - AudioTrack_7bf8) / 2
    audio_repeat $01, $00
    audio_pan $ff
    audio_envelope $02, $10
    audio_volume $0a
    audio_note $27, $20
    audio_note $29, $20
    audio_note $2b, $40
    audio_volume $0c
    audio_pan $0f
    audio_repeat $00, (.word_08 - AudioTrack_7bf8) / 2
    audio_end
