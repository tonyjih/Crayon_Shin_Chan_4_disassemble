; Sound IDs: $0c
AudioTrack_69bb::
    audio_header $00, $01, $0d, $00
    audio_loop_start $fe
    audio_envelope $01, $05
.word_04:
    audio_pan $0f
    audio_note $40, $0a
    audio_note $40, $0a
    audio_pan $01
    audio_note $40, $0a
    audio_note $40, $0a
    audio_repeat $03, (.word_04 - AudioTrack_69bb) / 2
.word_0b:
    audio_note $3a, $0a
    audio_pan $01
    audio_note $3a, $05
    audio_note $39, $05
    audio_note $37, $05
    audio_note $3a, $0f
    audio_pan $01
    audio_note $3a, $05
    audio_note $39, $05
    audio_note $37, $05
    audio_note $3a, $19
    audio_repeat $01, (.word_0b - AudioTrack_69bb) / 2
.word_17:
    audio_pan $f0
    audio_note $44, $0a
    audio_note $44, $0a
    audio_pan $01
    audio_note $44, $0a
    audio_note $44, $0a
    audio_repeat $03, (.word_17 - AudioTrack_69bb) / 2
.word_1e:
    audio_note $45, $0a
    audio_pan $01
    audio_note $45, $05
    audio_note $44, $05
    audio_note $42, $05
    audio_note $45, $0f
    audio_pan $01
    audio_note $45, $05
    audio_note $44, $05
    audio_note $42, $05
    audio_note $45, $19
    audio_repeat $01, (.word_1e - AudioTrack_69bb) / 2
    audio_envelope $01, $24
    audio_note $24, $28
    audio_note $22, $0a
    audio_note $1b, $14
    audio_note $22, $0a
    audio_note $24, $0a
.word_30:
    audio_note $24, $0a
    audio_note $25, $0a
    audio_repeat $02, (.word_30 - AudioTrack_69bb) / 2
    audio_note $26, $0a
    audio_pan $f0
    audio_note $27, $28
    audio_note $25, $0a
    audio_note $22, $14
    audio_note $25, $0a
    audio_note $27, $0a
.word_3a:
    audio_note $27, $0a
    audio_note $29, $0a
    audio_repeat $02, (.word_3a - AudioTrack_69bb) / 2
    audio_note $2a, $0a
    audio_pan $01
    audio_note $2b, $28
    audio_note $29, $0a
    audio_note $25, $14
    audio_note $29, $0a
    audio_note $2b, $0a
.word_44:
    audio_note $2b, $0a
    audio_note $30, $0a
    audio_repeat $02, (.word_44 - AudioTrack_69bb) / 2
    audio_note $32, $0a
    audio_pan $ff
    audio_volume $07
    audio_note $3b, $28
    audio_note $3b, $28
.word_4c:
    audio_note $27, $05
    audio_note $2b, $05
    audio_note $32, $05
    audio_note $35, $05
    audio_repeat $03, (.word_4c - AudioTrack_69bb) / 2
    audio_volume $0d
    audio_repeat $00, $00
    audio_end
