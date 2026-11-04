; Sound IDs: $32
AudioTrack_75fa::
    audio_header $00, $30, $02, $02
    audio_note $17, $06
    audio_note $19, $06
    audio_note $1b, $06
.word_05:
    audio_note $20, $12
    audio_note $17, $12
    audio_note $19, $12
    audio_note $1b, $12
    audio_repeat $01, (.word_05 - AudioTrack_75fa) / 2
.word_0a:
    audio_note $20, $12
    audio_note $17, $12
    audio_repeat $01, (.word_0a - AudioTrack_75fa) / 2
.word_0d:
    audio_note $2b, $0c
    audio_note $22, $06
    audio_repeat $03, (.word_0d - AudioTrack_75fa) / 2
    audio_end
