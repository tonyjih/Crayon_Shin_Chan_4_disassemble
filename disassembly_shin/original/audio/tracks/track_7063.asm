; Sound IDs: $27
AudioTrack_7063::
    audio_header $00, $00, $09, $00
.word_02:
    audio_loop_start $fe
    audio_envelope $01, $06
    audio_pan $f0
    audio_note $0c, $0c
    audio_pan $01
    audio_note $08, $0c
    audio_pan $01
    audio_note $0c, $06
    audio_note $0c, $06
    audio_pan $01
    audio_note $08, $0c
    audio_pan $01
    audio_note $0c, $0c
    audio_pan $01
    audio_note $08, $06
    audio_pan $01
    audio_note $0c, $0c
    audio_note $0c, $06
    audio_pan $01
    audio_note $08, $0c
    audio_repeat $00, (.word_02 - AudioTrack_7063) / 2
    audio_end
