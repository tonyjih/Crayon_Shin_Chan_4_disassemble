; Sound IDs: $21
AudioTrack_6f01::
    audio_header $00, $01, $09, $00
    audio_loop_start $fe
    audio_envelope $06, $10
.word_04:
    audio_note $39, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $10
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $08
    audio_repeat $01, (.word_04 - AudioTrack_6f01) / 2
.word_0c:
    audio_note $3b, $08
    audio_note $36, $08
    audio_note $39, $08
    audio_note $3b, $10
    audio_note $36, $08
    audio_note $39, $08
    audio_note $3b, $08
    audio_repeat $01, (.word_0c - AudioTrack_6f01) / 2
.word_14:
    audio_note $38, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $38, $10
    audio_note $34, $08
    audio_note $36, $08
    audio_note $38, $08
    audio_repeat $01, (.word_14 - AudioTrack_6f01) / 2
    audio_note $39, $08
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $10
    audio_note $34, $08
    audio_note $36, $08
    audio_note $39, $08
    audio_note $35, $08
    audio_note $35, $08
    audio_note $1f, $08
    audio_note $34, $28
    audio_repeat $00, $00
    audio_end
