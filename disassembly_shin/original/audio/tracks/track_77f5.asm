; Sound IDs: $3d
AudioTrack_77f5::
    audio_header $00, $01, $0c, $00
.word_02:
    audio_envelope $04, $60
    audio_note $37, $60
    audio_note $39, $30
    audio_note $44, $30
    audio_repeat $01, (.word_02 - AudioTrack_77f5) / 2
    audio_envelope $04, $0c
.word_08:
    audio_note $1f, $0c
    audio_note $37, $0c
    audio_note $37, $0c
    audio_note $34, $0c
    audio_note $37, $0c
    audio_note $39, $06
    audio_note $37, $1e
    audio_note $1f, $0c
    audio_note $38, $18
    audio_note $34, $0c
    audio_note $38, $06
    audio_note $34, $06
    audio_note $38, $06
    audio_note $34, $1e
.word_16:
    audio_note $39, $06
    audio_note $35, $06
    audio_repeat $03, (.word_16 - AudioTrack_77f5) / 2
.word_19:
    audio_note $3b, $06
    audio_repeat $03, (.word_19 - AudioTrack_77f5) / 2
    audio_note $3b, $0c
    audio_note $39, $0c
    audio_note $37, $30
    audio_note $32, $06
    audio_note $34, $06
    audio_note $35, $06
    audio_note $35, $06
    audio_note $37, $0c
    audio_note $37, $0c
    audio_note $1f, $0c
    audio_note $37, $0c
    audio_note $37, $0c
    audio_note $34, $0c
    audio_note $37, $0c
    audio_note $39, $06
    audio_note $37, $1e
    audio_note $1f, $0c
    audio_note $38, $18
    audio_note $34, $0c
    audio_note $38, $06
    audio_note $34, $06
    audio_note $38, $06
    audio_note $34, $1e
.word_32:
    audio_note $39, $06
    audio_note $35, $06
    audio_repeat $03, (.word_32 - AudioTrack_77f5) / 2
.word_35:
    audio_note $3b, $06
    audio_note $37, $06
    audio_repeat $03, (.word_35 - AudioTrack_77f5) / 2
    audio_note $1f, $0c
    audio_note $40, $18
    audio_note $39, $06
    audio_note $37, $06
    audio_note $39, $06
    audio_note $40, $06
    audio_note $1f, $06
    audio_note $40, $1e
    audio_loop_start $fe
    audio_note $38, $0c
    audio_note $35, $0c
    audio_note $38, $0c
    audio_note $38, $0c
    audio_command $fe, $fe
    audio_note $3a, $18
    audio_note $3a, $18
    audio_note $37, $0c
    audio_note $35, $0c
    audio_note $37, $0c
    audio_note $33, $24
    audio_note $35, $0c
    audio_note $37, $0c
    audio_repeat $01, $00
    audio_note $1f, $0c
.word_50:
    audio_note $38, $0c
    audio_repeat $06, (.word_50 - AudioTrack_77f5) / 2
.word_52:
    audio_note $3b, $0c
    audio_repeat $03, (.word_52 - AudioTrack_77f5) / 2
    audio_note $3b, $30
    audio_loop_start $fe
    audio_note $40, $18
    audio_note $40, $18
    audio_note $3b, $12
    audio_note $39, $12
    audio_note $3b, $0c
.word_5b:
    audio_note $40, $0c
    audio_repeat $02, (.word_5b - AudioTrack_77f5) / 2
    audio_note $40, $18
    audio_note $37, $0c
    audio_note $39, $0c
    audio_note $3b, $0c
    audio_repeat $01, $00
    audio_note $40, $18
    audio_note $40, $18
    audio_note $42, $12
    audio_note $40, $12
    audio_note $42, $0c
    audio_note $44, $12
    audio_note $40, $12
    audio_note $39, $24
    audio_note $37, $18
    audio_note $35, $18
    audio_note $37, $0c
    audio_note $39, $0c
    audio_note $3b, $18
    audio_note $40, $18
    audio_note $43, $24
    audio_note $42, $24
    audio_note $40, $0c
    audio_note $3b, $0c
    audio_note $40, $60
    audio_note $1f, $60
    audio_repeat $00, (.word_08 - AudioTrack_77f5) / 2
    audio_end
