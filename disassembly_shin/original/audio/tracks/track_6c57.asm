; Sound IDs: $16
AudioTrack_6c57::
    audio_header $01, $10, $02, $02
    audio_note $25, $06
    audio_note $29, $06
    audio_note $30, $06
    audio_note $29, $06
    audio_note $2b, $06
    audio_note $27, $06
    audio_note $2b, $06
    audio_note $32, $06
.word_0a:
    audio_note $30, $06
    audio_repeat $03, (.word_0a - AudioTrack_6c57) / 2
    audio_note $30, $0c
    audio_note $20, $0c
    audio_end
