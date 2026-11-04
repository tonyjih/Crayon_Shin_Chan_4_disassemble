; Sound IDs: $08
AudioTrack_679f::
    audio_header $00, $00, $0c, $00
    audio_pan $0f
    audio_envelope $01, $02
.word_04:
    audio_pan $01
    audio_note $47, $06
    audio_note $44, $06
    audio_note $44, $06
    audio_note $47, $06
    audio_note $44, $06
    audio_note $44, $06
    audio_note $47, $06
    audio_note $44, $06
    audio_repeat $01, (.word_04 - AudioTrack_679f) / 2
.word_0e:
    audio_pan $01
    audio_note $45, $06
    audio_note $42, $06
    audio_note $42, $06
    audio_note $45, $06
    audio_note $42, $06
    audio_note $42, $06
    audio_note $45, $06
    audio_note $42, $06
    audio_repeat $01, (.word_0e - AudioTrack_679f) / 2
.word_18:
    audio_loop_start $fe
    audio_envelope $06, $0c
    audio_note $1f, $c0
.word_1b:
    audio_pan $01
    audio_note $40, $0c
    audio_note $30, $0c
    audio_note $40, $0c
    audio_note $30, $06
    audio_pan $01
    audio_note $40, $0c
    audio_note $40, $0c
    audio_note $30, $06
    audio_note $40, $0c
    audio_note $30, $0c
    audio_repeat $01, (.word_1b - AudioTrack_679f) / 2
    audio_pan $ff
    audio_volume $08
    audio_note $1f, $6c
    audio_envelope $04, $0c
    audio_note $35, $0c
    audio_note $37, $0c
    audio_note $39, $18
    audio_note $37, $0c
    audio_note $35, $0c
    audio_note $34, $6c
    audio_note $35, $60
    audio_envelope $01, $20
.word_33:
    audio_note $42, $0c
    audio_repeat $03, (.word_33 - AudioTrack_679f) / 2
    audio_note $40, $06
    audio_note $3b, $06
    audio_note $39, $0c
    audio_note $3b, $0c
    audio_note $40, $0c
.word_3a:
    audio_note $42, $06
    audio_note $42, $0c
    audio_note $37, $06
    audio_repeat $01, (.word_3a - AudioTrack_679f) / 2
    audio_note $40, $06
    audio_note $3b, $06
    audio_note $39, $0c
    audio_note $42, $0c
    audio_note $44, $0c
    audio_envelope $01, $50
    audio_note $45, $30
    audio_note $44, $30
    audio_note $47, $18
    audio_note $37, $06
    audio_note $3b, $06
    audio_note $37, $0c
    audio_note $39, $0c
    audio_note $3b, $0c
    audio_note $39, $0c
    audio_note $37, $0c
    audio_volume $0c
    audio_pan $0f
    audio_repeat $01, $00
    audio_loop_start $fe
    audio_envelope $01, $03
    audio_pan $0f
    audio_volume $0c
.word_55:
    audio_note $47, $06
    audio_repeat $03, (.word_55 - AudioTrack_679f) / 2
.word_57:
    audio_pan $01
    audio_note $47, $06
    audio_repeat $03, (.word_57 - AudioTrack_679f) / 2
    audio_repeat $05, $00
    audio_volume $09
    audio_pan $ff
    audio_envelope $01, $06
    audio_note $1f, $06
    audio_note $4a, $0c
    audio_note $4a, $06
    audio_note $49, $0c
    audio_note $47, $0c
    audio_note $45, $0c
    audio_note $47, $0c
    audio_note $49, $0c
    audio_note $47, $0c
    audio_volume $0c
    audio_envelope $01, $03
    audio_loop_start $fe
    audio_pan $f0
.word_6b:
    audio_note $47, $06
    audio_repeat $03, (.word_6b - AudioTrack_679f) / 2
.word_6d:
    audio_pan $01
    audio_note $47, $06
    audio_repeat $03, (.word_6d - AudioTrack_679f) / 2
    audio_repeat $05, $00
    audio_pan $ff
    audio_volume $09
    audio_note $1f, $06
    audio_envelope $01, $06
    audio_note $52, $0c
    audio_note $52, $06
    audio_note $52, $0c
    audio_note $52, $0c
    audio_note $52, $0c
    audio_note $54, $0c
    audio_note $55, $0c
    audio_note $57, $0c
    audio_volume $0c
    audio_pan $f0
    audio_repeat $00, (.word_18 - AudioTrack_679f) / 2
    audio_end
