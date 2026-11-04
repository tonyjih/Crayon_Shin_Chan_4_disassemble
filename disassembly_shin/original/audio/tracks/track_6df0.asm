; Sound IDs: $1e
AudioTrack_6df0::
    audio_header $01, $10, $02, $02
    audio_loop_start $fe
.word_03:
    audio_pan $0f
    audio_note $20, $06
    audio_pan $01
    audio_note $17, $06
    audio_pan $01
    audio_note $20, $06
    audio_pan $01
    audio_note $17, $06
    audio_pan $01
    audio_note $20, $06
    audio_pan $01
    audio_note $17, $06
    audio_pan $01
    audio_note $19, $06
    audio_pan $01
    audio_note $1b, $06
    audio_pan $01
    audio_repeat $01, (.word_03 - AudioTrack_6df0) / 2
    audio_pan $01
    audio_note $22, $06
    audio_pan $01
    audio_note $19, $06
    audio_pan $01
    audio_note $22, $06
    audio_pan $01
    audio_note $19, $06
    audio_pan $01
    audio_note $22, $06
    audio_pan $01
    audio_note $19, $06
    audio_pan $01
    audio_note $24, $06
    audio_pan $01
    audio_note $25, $06
    audio_pan $01
    audio_note $27, $06
    audio_pan $01
    audio_note $22, $06
    audio_pan $01
    audio_note $27, $06
    audio_pan $01
    audio_note $22, $06
    audio_pan $01
    audio_note $27, $06
    audio_pan $01
    audio_note $25, $06
    audio_pan $01
    audio_note $24, $06
    audio_pan $01
    audio_note $22, $06
    audio_repeat $01, $00
    audio_pan $ff
.word_37:
    audio_note $25, $06
    audio_note $25, $06
    audio_note $29, $06
    audio_note $29, $06
    audio_note $30, $06
    audio_note $30, $06
    audio_note $32, $06
    audio_note $30, $06
    audio_note $20, $06
    audio_note $20, $06
    audio_note $24, $06
    audio_note $24, $06
    audio_note $27, $06
    audio_note $27, $06
    audio_note $29, $06
    audio_note $27, $06
    audio_repeat $01, (.word_37 - AudioTrack_6df0) / 2
.word_48:
    audio_note $25, $06
    audio_repeat $07, (.word_48 - AudioTrack_6df0) / 2
.word_4a:
    audio_note $27, $06
    audio_repeat $07, (.word_4a - AudioTrack_6df0) / 2
    audio_repeat $00, $00
    audio_end
