; Sound IDs: $62
AudioTrack_7d92::
    audio_header $00, $0b, $02, $02
.word_02:
    audio_note $20, $08
    audio_repeat $0c, (.word_02 - AudioTrack_7d92) / 2
    audio_note $17, $08
    audio_note $19, $08
    audio_note $1b, $08
.word_07:
    audio_loop_start $fe
.word_08:
    audio_note $20, $08
    audio_repeat $0b, (.word_08 - AudioTrack_7d92) / 2
    audio_note $20, $08
    audio_note $17, $08
    audio_note $19, $08
    audio_note $1b, $08
.word_0e:
    audio_note $23, $08
    audio_repeat $03, (.word_0e - AudioTrack_7d92) / 2
.word_10:
    audio_note $25, $08
    audio_repeat $03, (.word_10 - AudioTrack_7d92) / 2
.word_12:
    audio_note $20, $08
    audio_repeat $07, (.word_12 - AudioTrack_7d92) / 2
.word_14:
    audio_note $20, $08
    audio_repeat $0b, (.word_14 - AudioTrack_7d92) / 2
    audio_note $20, $08
    audio_note $17, $08
    audio_note $19, $08
    audio_note $1b, $08
.word_1a:
    audio_note $22, $08
    audio_repeat $03, (.word_1a - AudioTrack_7d92) / 2
    audio_note $26, $08
    audio_note $26, $08
    audio_note $29, $08
    audio_note $29, $08
.word_20:
    audio_note $27, $08
    audio_repeat $07, (.word_20 - AudioTrack_7d92) / 2
.word_22:
    audio_note $25, $08
    audio_repeat $03, (.word_22 - AudioTrack_7d92) / 2
    audio_note $25, $08
    audio_note $20, $08
    audio_note $25, $08
    audio_note $20, $08
.word_28:
    audio_note $20, $08
    audio_repeat $03, (.word_28 - AudioTrack_7d92) / 2
    audio_note $20, $08
    audio_note $17, $08
    audio_note $20, $08
    audio_note $17, $08
.word_2e:
    audio_note $17, $08
    audio_repeat $07, (.word_2e - AudioTrack_7d92) / 2
.word_30:
    audio_note $20, $08
    audio_repeat $04, (.word_30 - AudioTrack_7d92) / 2
    audio_note $24, $08
    audio_note $25, $08
    audio_note $27, $08
.word_35:
    audio_note $25, $08
    audio_repeat $03, (.word_35 - AudioTrack_7d92) / 2
    audio_note $25, $08
    audio_note $20, $08
    audio_note $25, $08
    audio_note $20, $08
.word_3b:
    audio_note $20, $08
    audio_repeat $03, (.word_3b - AudioTrack_7d92) / 2
    audio_note $20, $08
    audio_note $17, $08
    audio_note $20, $08
    audio_note $17, $08
    audio_note $23, $08
    audio_note $23, $08
    audio_note $27, $08
    audio_note $23, $08
    audio_note $25, $08
    audio_note $25, $08
    audio_note $29, $08
    audio_note $25, $08
    audio_note $27, $08
    audio_note $27, $08
    audio_note $2b, $08
    audio_note $30, $08
    audio_note $32, $08
.word_4e:
    audio_note $32, $08
    audio_repeat $02, (.word_4e - AudioTrack_7d92) / 2
    audio_repeat $00, (.word_07 - AudioTrack_7d92) / 2
    audio_end
