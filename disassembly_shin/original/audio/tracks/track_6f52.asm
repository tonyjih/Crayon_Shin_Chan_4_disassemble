; Sound IDs: $22
AudioTrack_6f52::
    audio_header $00, $10, $02, $02
    audio_loop_start $fe
.word_03:
    audio_note $29, $08
    audio_note $29, $08
    audio_note $31, $08
    audio_note $31, $08
    audio_note $32, $08
    audio_note $32, $08
    audio_note $34, $08
    audio_note $34, $08
    audio_repeat $01, (.word_03 - AudioTrack_6f52) / 2
.word_0c:
    audio_note $2b, $08
    audio_note $2b, $08
    audio_note $32, $08
    audio_note $32, $08
    audio_note $34, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $36, $08
    audio_repeat $01, (.word_0c - AudioTrack_6f52) / 2
.word_15:
    audio_note $24, $08
    audio_note $24, $08
    audio_note $28, $08
    audio_note $28, $08
    audio_note $29, $08
    audio_note $29, $08
    audio_note $2b, $08
    audio_note $2b, $08
    audio_repeat $01, (.word_15 - AudioTrack_6f52) / 2
    audio_note $29, $08
    audio_note $29, $08
    audio_note $31, $08
    audio_note $31, $08
    audio_note $32, $08
    audio_note $32, $08
    audio_note $34, $08
    audio_note $34, $08
    audio_note $25, $08
    audio_note $29, $08
    audio_note $30, $08
    audio_note $24, $10
    audio_note $28, $08
    audio_note $2b, $08
    audio_note $32, $08
    audio_repeat $00, $00
    audio_end
