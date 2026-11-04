; Sound IDs: $67
AudioTrack_7ebd::
    audio_header $00, $00, $0b, $00
    audio_envelope $01, $01
    audio_loop_start $fe
    audio_pan $f0
    audio_note $0b, $06
.word_06:
    audio_note $04, $06
    audio_repeat $02, (.word_06 - AudioTrack_7ebd) / 2
    audio_pan $01
    audio_note $0b, $06
.word_0a:
    audio_note $04, $06
    audio_repeat $02, (.word_0a - AudioTrack_7ebd) / 2
    audio_repeat $01, $00
    audio_volume $08
    audio_pan $ff
    audio_note $09, $06
.word_10:
    audio_note $04, $06
    audio_repeat $06, (.word_10 - AudioTrack_7ebd) / 2
    audio_note $04, $18
    audio_note $0b, $18
    audio_end
