; Sound IDs: $0a
AudioTrack_691b::
    audio_header $00, $10, $02, $02
.word_02:
    audio_note $20, $12
    audio_note $24, $12
    audio_note $27, $0c
    audio_repeat $01, (.word_02 - AudioTrack_691b) / 2
.word_06:
    audio_note $1a, $12
    audio_note $22, $12
    audio_note $25, $0c
    audio_repeat $01, (.word_06 - AudioTrack_691b) / 2
.word_0a:
    audio_loop_start $fe
.word_0b:
    audio_note $20, $12
    audio_note $24, $12
    audio_note $27, $0c
    audio_note $20, $12
    audio_note $24, $12
    audio_note $27, $0c
    audio_note $1a, $12
    audio_note $22, $12
    audio_note $25, $0c
    audio_note $1a, $12
    audio_note $22, $12
    audio_note $25, $0c
    audio_repeat $03, (.word_0b - AudioTrack_691b) / 2
.word_18:
    audio_note $27, $12
    audio_note $27, $12
    audio_note $27, $0c
    audio_note $25, $12
    audio_note $25, $12
    audio_note $25, $0c
    audio_note $27, $12
    audio_note $27, $12
    audio_note $27, $0c
    audio_note $27, $12
    audio_note $27, $12
    audio_note $27, $0c
    audio_repeat $01, (.word_18 - AudioTrack_691b) / 2
    audio_repeat $01, $00
.word_26:
    audio_note $20, $12
    audio_note $20, $12
    audio_note $20, $0c
    audio_note $1a, $0c
    audio_note $17, $24
    audio_repeat $01, (.word_26 - AudioTrack_691b) / 2
    audio_note $20, $12
    audio_note $20, $12
    audio_note $20, $0c
    audio_note $1a, $12
    audio_note $1a, $12
    audio_note $1a, $0c
    audio_note $20, $18
    audio_note $20, $18
.word_34:
    audio_note $20, $0c
    audio_repeat $03, (.word_34 - AudioTrack_691b) / 2
.word_36:
    audio_note $20, $12
    audio_note $20, $12
    audio_note $20, $0c
    audio_note $1a, $0c
    audio_note $17, $24
    audio_repeat $01, (.word_36 - AudioTrack_691b) / 2
    audio_note $20, $12
    audio_note $20, $12
    audio_note $20, $0c
    audio_note $1a, $12
    audio_note $1a, $12
    audio_note $1a, $0c
    audio_note $17, $18
    audio_note $17, $18
.word_44:
    audio_note $17, $0c
    audio_repeat $03, (.word_44 - AudioTrack_691b) / 2
    audio_repeat $00, (.word_0a - AudioTrack_691b) / 2
    audio_end
