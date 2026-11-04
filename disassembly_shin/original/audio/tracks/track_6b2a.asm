; Sound IDs: $0f
AudioTrack_6b2a::
    audio_header $00, $00, $09, $00
    audio_loop_start $fe
    audio_envelope $01, $02
.word_04:
    audio_note $4b, $0a
    audio_note $24, $0a
    audio_note $4b, $0a
    audio_note $24, $0a
    audio_repeat $0f, (.word_04 - AudioTrack_6b2a) / 2
.word_09:
    audio_note $4c, $0a
    audio_note $4c, $0a
    audio_repeat $0f, (.word_09 - AudioTrack_6b2a) / 2
.word_0c:
    audio_note $4c, $0a
    audio_repeat $0f, (.word_0c - AudioTrack_6b2a) / 2
    audio_envelope $01, $20
.word_0f:
    audio_note $33, $14
    audio_note $35, $14
    audio_repeat $01, (.word_0f - AudioTrack_6b2a) / 2
    audio_envelope $01, $02
.word_13:
    audio_note $4b, $05
    audio_note $24, $05
    audio_note $24, $05
    audio_note $24, $05
    audio_repeat $01, (.word_13 - AudioTrack_6b2a) / 2
    audio_note $4b, $05
.word_19:
    audio_note $24, $05
    audio_repeat $06, (.word_19 - AudioTrack_6b2a) / 2
    audio_repeat $00, $00
    audio_end
