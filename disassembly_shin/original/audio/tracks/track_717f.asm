; Sound IDs: $29
AudioTrack_717f::
    audio_header $00, $01, $0c, $00
    audio_envelope $01, $20
    audio_note $1f, $46
    audio_loop_start $fe
    audio_note $34, $05
    audio_note $35, $05
.word_07:
    audio_note $37, $0a
    audio_repeat $03, (.word_07 - AudioTrack_717f) / 2
    audio_note $34, $0f
    audio_note $30, $0f
    audio_note $37, $0a
.word_0c:
    audio_note $39, $0a
    audio_repeat $02, (.word_0c - AudioTrack_717f) / 2
    audio_note $37, $28
    audio_note $37, $05
    audio_note $38, $05
.word_11:
    audio_note $39, $0a
    audio_repeat $03, (.word_11 - AudioTrack_717f) / 2
    audio_note $35, $0f
    audio_note $32, $0f
    audio_note $3a, $0a
    audio_note $3b, $0a
    audio_note $3b, $0a
    audio_note $39, $0a
    audio_note $37, $28
    audio_note $34, $05
    audio_note $35, $05
.word_1c:
    audio_note $37, $0a
    audio_repeat $03, (.word_1c - AudioTrack_717f) / 2
    audio_note $34, $0f
    audio_note $30, $0f
    audio_note $37, $0a
.word_21:
    audio_note $39, $0a
    audio_repeat $02, (.word_21 - AudioTrack_717f) / 2
    audio_note $37, $32
    audio_note $35, $0a
    audio_note $35, $0a
    audio_note $32, $05
    audio_note $34, $05
    audio_note $35, $0a
    audio_note $37, $0a
    audio_note $37, $0a
    audio_note $34, $05
    audio_note $35, $05
    audio_note $37, $0a
    audio_note $37, $0a
.word_2f:
    audio_note $30, $0a
    audio_repeat $02, (.word_2f - AudioTrack_717f) / 2
    audio_note $30, $28
    audio_note $40, $14
    audio_note $40, $14
    audio_note $39, $0a
    audio_note $40, $14
    audio_note $40, $0a
    audio_note $3b, $14
    audio_note $42, $0a
    audio_note $3b, $32
    audio_note $38, $1e
    audio_note $39, $1e
    audio_note $3b, $14
    audio_note $39, $0a
    audio_note $37, $14
    audio_note $39, $32
    audio_note $32, $0a
    audio_note $34, $14
    audio_note $35, $14
    audio_note $37, $0a
    audio_note $39, $14
    audio_note $34, $0a
    audio_note $35, $14
    audio_note $37, $14
    audio_note $39, $0a
    audio_note $3b, $14
    audio_note $38, $1e
    audio_note $43, $1e
    audio_note $40, $14
    audio_note $1f, $0a
.word_4e:
    audio_note $42, $0a
    audio_repeat $03, (.word_4e - AudioTrack_717f) / 2
    audio_note $40, $0a
    audio_note $3b, $0a
    audio_repeat $00, $00
    audio_end
