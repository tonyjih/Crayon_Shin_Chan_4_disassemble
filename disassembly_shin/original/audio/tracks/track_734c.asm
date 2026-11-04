; Sound IDs: $2c
AudioTrack_734c::
    audio_header $00, $00, $0c, $00
.word_02:
    audio_envelope $01, $02
    audio_pan $0f
    audio_note $40, $05
    audio_note $37, $05
    audio_note $40, $05
    audio_note $37, $05
    audio_pan $01
    audio_note $50, $05
    audio_note $40, $05
    audio_note $47, $05
    audio_note $40, $05
    audio_repeat $03, (.word_02 - AudioTrack_734c) / 2
.word_0e:
    audio_pan $0f
    audio_note $40, $05
    audio_note $37, $05
    audio_note $40, $05
    audio_note $37, $05
    audio_pan $01
    audio_note $50, $05
    audio_note $40, $05
    audio_note $47, $05
    audio_note $40, $05
    audio_repeat $0f, (.word_0e - AudioTrack_734c) / 2
    audio_loop_start $fe
    audio_pan $ff
.word_1b:
    audio_volume $08
    audio_note $43, $05
    audio_note $3a, $05
    audio_note $43, $05
    audio_note $3a, $05
    audio_note $53, $05
    audio_note $3a, $05
    audio_note $4a, $05
    audio_note $3a, $05
    audio_repeat $01, (.word_1b - AudioTrack_734c) / 2
.word_25:
    audio_note $45, $05
    audio_note $40, $05
    audio_note $45, $05
    audio_note $40, $05
    audio_note $55, $05
    audio_note $40, $05
    audio_note $50, $05
    audio_note $40, $05
    audio_repeat $01, (.word_25 - AudioTrack_734c) / 2
    audio_repeat $01, $00
.word_2f:
    audio_note $43, $05
    audio_note $3a, $05
    audio_note $43, $05
    audio_note $3a, $05
    audio_note $53, $05
    audio_note $3a, $05
    audio_note $5a, $05
    audio_note $3a, $05
    audio_repeat $01, (.word_2f - AudioTrack_734c) / 2
.word_38:
    audio_note $42, $05
    audio_note $39, $05
    audio_note $42, $05
    audio_note $39, $05
    audio_note $52, $05
    audio_note $39, $05
    audio_note $49, $05
    audio_note $39, $05
    audio_repeat $01, (.word_38 - AudioTrack_734c) / 2
.word_41:
    audio_note $47, $05
    audio_note $42, $05
    audio_note $47, $05
    audio_note $42, $05
    audio_note $57, $05
    audio_note $42, $05
    audio_note $52, $05
    audio_note $42, $05
    audio_repeat $01, (.word_41 - AudioTrack_734c) / 2
    audio_note $37, $05
    audio_note $3b, $05
    audio_note $42, $05
    audio_note $45, $05
    audio_note $47, $05
    audio_note $4b, $05
    audio_note $52, $05
    audio_note $55, $05
    audio_note $57, $05
    audio_note $55, $05
    audio_note $52, $05
    audio_note $4b, $05
    audio_note $47, $05
    audio_note $45, $05
    audio_note $42, $05
    audio_note $3b, $05
    audio_volume $0c
    audio_repeat $00, (.word_0e - AudioTrack_734c) / 2
    audio_end
