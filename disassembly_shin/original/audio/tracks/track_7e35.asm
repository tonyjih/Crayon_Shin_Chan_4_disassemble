; Sound IDs: $63
AudioTrack_7e35::
    audio_header $00, $00, $08, $00
    audio_note $1f, $08
    audio_loop_start $fe
.word_04:
    audio_envelope $01, $03
    audio_note $5b, $08
    audio_note $31, $08
    audio_note $5b, $08
    audio_note $32, $08
    audio_repeat $00, (.word_04 - AudioTrack_7e35) / 2
    audio_end
