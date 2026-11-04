; Sound IDs: $02
AudioTrack_644f::
    audio_header $00, $10, $02, $02
.word_02:
    audio_loop_start $fe
.word_03:
    audio_note $20, $0c
    audio_repeat $03, (.word_03 - AudioTrack_644f) / 2
.word_05:
    audio_note $17, $0c
    audio_repeat $03, (.word_05 - AudioTrack_644f) / 2
    audio_repeat $07, $00
    audio_loop_start $fe
.word_09:
    audio_note $19, $0c
    audio_repeat $03, (.word_09 - AudioTrack_644f) / 2
.word_0b:
    audio_note $1b, $0c
    audio_repeat $03, (.word_0b - AudioTrack_644f) / 2
    audio_repeat $02, $00
.word_0e:
    audio_note $22, $0c
    audio_repeat $04, (.word_0e - AudioTrack_644f) / 2
    audio_note $1f, $24
    audio_repeat $00, (.word_02 - AudioTrack_644f) / 2
    audio_end
