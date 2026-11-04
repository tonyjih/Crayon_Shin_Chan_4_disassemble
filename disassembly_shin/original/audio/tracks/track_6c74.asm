; Sound IDs: $17
AudioTrack_6c74::
    audio_header $01, $00, $09, $00
    audio_envelope $01, $01
    audio_loop_start $fe
    audio_pan $0f
    audio_note $09, $03
.word_06:
    audio_note $04, $03
    audio_repeat $02, (.word_06 - AudioTrack_6c74) / 2
    audio_pan $f0
    audio_note $0b, $03
.word_0a:
    audio_note $04, $03
    audio_repeat $02, (.word_0a - AudioTrack_6c74) / 2
    audio_repeat $01, $00
    audio_pan $ff
    audio_note $09, $03
.word_0f:
    audio_note $04, $03
    audio_repeat $06, (.word_0f - AudioTrack_6c74) / 2
    audio_note $04, $0c
    audio_note $0b, $0c
    audio_end
