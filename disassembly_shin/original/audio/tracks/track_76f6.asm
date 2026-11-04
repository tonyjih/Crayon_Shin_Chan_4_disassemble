; Sound IDs: $3c
AudioTrack_76f6::
    audio_header $00, $01, $0a, $00
.word_02:
    audio_envelope $04, $60
    audio_note $34, $60
    audio_note $35, $30
    audio_note $3b, $30
    audio_repeat $01, (.word_02 - AudioTrack_76f6) / 2
.word_07:
    audio_duty_or_wave_length $00
    audio_envelope $01, $0c
    audio_loop_start $fe
    audio_note $1f, $0c
    audio_note $44, $0c
    audio_note $44, $0c
    audio_note $1f, $0c
    audio_note $44, $12
    audio_note $44, $12
    audio_note $44, $0c
    audio_repeat $01, $00
    audio_duty_or_wave_length $01
    audio_envelope $04, $0c
    audio_volume $01
.word_15:
    audio_note $40, $06
    audio_note $39, $06
    audio_repeat $03, (.word_15 - AudioTrack_76f6) / 2
.word_18:
    audio_note $42, $06
    audio_repeat $03, (.word_18 - AudioTrack_76f6) / 2
    audio_note $42, $0c
    audio_note $40, $0c
    audio_note $39, $60
    audio_volume $0a
    audio_duty_or_wave_length $00
    audio_envelope $01, $0c
    audio_loop_start $fe
    audio_note $1f, $0c
    audio_note $44, $0c
    audio_note $44, $0c
    audio_note $1f, $0c
    audio_note $44, $12
    audio_note $44, $12
    audio_note $44, $0c
    audio_repeat $01, $00
    audio_volume $08
    audio_duty_or_wave_length $01
.word_2b:
    audio_note $40, $06
    audio_note $39, $06
    audio_repeat $03, (.word_2b - AudioTrack_76f6) / 2
.word_2e:
    audio_note $42, $06
    audio_note $3b, $06
    audio_repeat $03, (.word_2e - AudioTrack_76f6) / 2
    audio_note $1f, $48
    audio_volume $08
    audio_duty_or_wave_length $02
    audio_envelope $04, $0c
    audio_note $30, $06
    audio_note $31, $06
    audio_note $32, $06
    audio_note $33, $06
    audio_envelope $01, $0c
    audio_loop_start $fe
.word_3b:
    audio_note $30, $06
    audio_note $35, $06
    audio_note $38, $06
    audio_note $40, $06
    audio_repeat $01, (.word_3b - AudioTrack_76f6) / 2
.word_40:
    audio_note $35, $06
    audio_note $3a, $06
    audio_note $42, $06
    audio_note $45, $06
    audio_repeat $01, (.word_40 - AudioTrack_76f6) / 2
.word_45:
    audio_note $2a, $06
    audio_note $33, $06
    audio_note $37, $06
    audio_note $3a, $06
    audio_repeat $01, (.word_45 - AudioTrack_76f6) / 2
.word_4a:
    audio_note $27, $06
    audio_note $30, $06
    audio_note $33, $06
    audio_note $37, $06
    audio_repeat $01, (.word_4a - AudioTrack_76f6) / 2
    audio_repeat $01, $00
.word_50:
    audio_note $30, $06
    audio_note $35, $06
    audio_note $38, $06
    audio_note $40, $06
    audio_repeat $03, (.word_50 - AudioTrack_76f6) / 2
.word_55:
    audio_note $32, $06
    audio_note $37, $06
    audio_note $3b, $06
    audio_note $42, $06
    audio_repeat $02, (.word_55 - AudioTrack_76f6) / 2
    audio_note $47, $06
    audio_note $42, $06
    audio_note $3b, $06
    audio_note $37, $06
    audio_duty_or_wave_length $01
    audio_volume $0a
    audio_loop_start $fe
    audio_envelope $04, $0c
    audio_note $39, $18
    audio_note $39, $18
    audio_note $37, $12
    audio_note $35, $12
.word_66:
    audio_note $37, $0c
    audio_repeat $03, (.word_66 - AudioTrack_76f6) / 2
    audio_note $37, $18
    audio_note $1f, $24
    audio_repeat $01, $00
    audio_note $39, $18
    audio_note $39, $18
    audio_note $3b, $12
    audio_note $39, $12
    audio_note $3b, $0c
    audio_note $40, $12
    audio_note $39, $12
    audio_note $34, $24
    audio_note $34, $18
    audio_duty_or_wave_length $00
    audio_envelope $01, $06
.word_76:
    audio_note $40, $06
    audio_repeat $0f, (.word_76 - AudioTrack_76f6) / 2
.word_78:
    audio_note $3b, $06
    audio_repeat $0f, (.word_78 - AudioTrack_76f6) / 2
.word_7a:
    audio_note $40, $06
    audio_repeat $0f, (.word_7a - AudioTrack_76f6) / 2
.word_7c:
    audio_note $47, $06
    audio_repeat $0f, (.word_7c - AudioTrack_76f6) / 2
    audio_repeat $00, (.word_07 - AudioTrack_76f6) / 2
    audio_end
