; Sound IDs: $04
AudioTrack_6497::
    audio_header $00, $02, $0c, $00
    audio_pan $0f
    audio_note $1f, $80
    audio_vibrato $30
    audio_note $1f, $80
.word_06:
    audio_loop_start $fe
    audio_envelope $01, $40
.word_08:
    audio_note $1f, $13
    audio_note $34, $18
    audio_note $32, $18
    audio_note $30, $18
    audio_note $30, $10
    audio_note $29, $08
    audio_note $30, $10
    audio_note $2a, $0d
    audio_envelope $04, $10
    audio_pan $f0
    audio_note $34, $08
    audio_note $35, $08
    audio_note $36, $08
    audio_note $37, $10
    audio_note $39, $10
    audio_note $39, $10
    audio_note $37, $28
    audio_pan $0f
    audio_repeat $01, (.word_08 - AudioTrack_6497) / 2
    audio_pan $ff
    audio_note $24, $18
    audio_note $24, $18
    audio_note $24, $10
    audio_note $22, $18
    audio_note $20, $10
    audio_note $1b, $08
    audio_note $20, $08
    audio_note $22, $08
    audio_note $24, $18
    audio_note $24, $18
    audio_note $24, $10
    audio_note $22, $18
    audio_note $20, $18
    audio_note $25, $10
    audio_note $27, $18
    audio_note $27, $18
    audio_note $27, $10
    audio_note $25, $18
    audio_note $24, $10
    audio_note $22, $08
    audio_note $24, $08
    audio_note $25, $08
    audio_note $27, $20
    audio_note $29, $20
    audio_note $2b, $10
    audio_note $30, $10
    audio_note $32, $10
    audio_note $30, $10
    audio_pan $0f
    audio_note $1f, $13
    audio_note $34, $18
    audio_note $32, $18
    audio_note $30, $18
    audio_note $30, $10
    audio_note $29, $08
    audio_note $30, $10
    audio_note $2a, $0d
    audio_envelope $04, $10
    audio_pan $f0
    audio_note $34, $08
    audio_note $35, $08
    audio_note $36, $08
    audio_note $37, $10
    audio_note $39, $10
    audio_note $39, $10
    audio_note $37, $28
    audio_pan $0f
    audio_note $1f, $13
    audio_note $34, $18
    audio_note $32, $18
    audio_note $37, $18
    audio_note $35, $18
    audio_note $34, $10
    audio_note $35, $0d
    audio_envelope $04, $10
    audio_pan $f0
    audio_note $34, $08
    audio_note $35, $08
    audio_note $36, $08
    audio_note $37, $10
    audio_note $39, $10
    audio_note $3b, $10
    audio_note $40, $28
    audio_pan $ff
    audio_note $2b, $18
    audio_note $2b, $18
    audio_note $2b, $10
    audio_note $29, $18
    audio_note $27, $10
    audio_note $25, $08
    audio_note $27, $08
    audio_note $29, $08
    audio_note $2b, $18
    audio_note $2b, $18
    audio_note $2b, $10
    audio_note $29, $18
    audio_note $27, $18
    audio_note $30, $10
    audio_note $32, $18
    audio_note $32, $18
    audio_note $32, $10
    audio_note $35, $18
    audio_note $35, $08
    audio_note $35, $08
    audio_note $32, $08
    audio_note $34, $08
    audio_note $35, $08
    audio_note $37, $20
    audio_note $37, $20
    audio_note $37, $10
    audio_note $37, $10
    audio_note $39, $10
    audio_note $3b, $10
    audio_pan $0f
    audio_loop_start $fe
    audio_envelope $01, $04
.word_7c:
    audio_note $40, $04
    audio_repeat $03, (.word_7c - AudioTrack_6497) / 2
    audio_note $40, $10
    audio_envelope $01, $08
.word_80:
    audio_note $1f, $08
    audio_note $40, $08
    audio_repeat $05, (.word_80 - AudioTrack_6497) / 2
    audio_repeat $01, $00
    audio_envelope $04, $20
.word_85:
    audio_note $27, $10
    audio_repeat $03, (.word_85 - AudioTrack_6497) / 2
.word_87:
    audio_envelope $07, $08
    audio_note $35, $08
    audio_note $35, $08
    audio_repeat $03, (.word_87 - AudioTrack_6497) / 2
    audio_envelope $01, $40
    audio_repeat $00, (.word_06 - AudioTrack_6497) / 2
    audio_end
