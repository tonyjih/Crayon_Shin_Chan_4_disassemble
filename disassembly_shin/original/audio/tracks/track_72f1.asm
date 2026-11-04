; Sound IDs: $2b
AudioTrack_72f1::
    audio_header $00, $00, $0c, $00
    audio_envelope $07, $01
    audio_note $16, $05
    audio_note $16, $0a
    audio_note $16, $05
    audio_note $16, $0a
    audio_note $16, $0a
    audio_note $16, $0a
    audio_note $02, $0a
    audio_note $02, $0a
    audio_note $02, $0a
.word_0c:
    audio_note $16, $14
    audio_note $16, $0f
    audio_note $44, $05
    audio_note $16, $0a
    audio_note $44, $0a
    audio_note $14, $0a
    audio_note $44, $0a
    audio_repeat $06, (.word_0c - AudioTrack_72f1) / 2
    audio_note $44, $0a
.word_15:
    audio_note $14, $0a
    audio_repeat $03, (.word_15 - AudioTrack_72f1) / 2
    audio_note $24, $0a
    audio_note $24, $0a
    audio_note $27, $0a
.word_1a:
    audio_note $44, $0a
    audio_note $14, $0a
    audio_repeat $0f, (.word_1a - AudioTrack_72f1) / 2
    audio_loop_start $fe
    audio_note $34, $0a
.word_1f:
    audio_note $16, $0a
    audio_repeat $06, (.word_1f - AudioTrack_72f1) / 2
    audio_repeat $01, $00
.word_22:
    audio_note $16, $0a
    audio_note $34, $0a
    audio_note $34, $0a
    audio_repeat $01, (.word_22 - AudioTrack_72f1) / 2
    audio_note $16, $0a
    audio_note $34, $0a
    audio_note $1f, $05
    audio_note $16, $05
.word_2a:
    audio_note $16, $0a
    audio_repeat $06, (.word_2a - AudioTrack_72f1) / 2
    audio_repeat $00, (.word_0c - AudioTrack_72f1) / 2
    audio_end
