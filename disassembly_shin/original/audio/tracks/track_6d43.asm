; Sound IDs: $1c
AudioTrack_6d43::
    audio_header $01, $00, $07, $00
    audio_loop_start $fe
    audio_envelope $07, $06
.word_04:
    audio_note $40, $03
    audio_note $40, $03
    audio_repeat $0f, (.word_04 - AudioTrack_6d43) / 2
.word_07:
    audio_note $42, $03
    audio_note $42, $03
    audio_repeat $07, (.word_07 - AudioTrack_6d43) / 2
    audio_note $47, $03
    audio_note $47, $03
    audio_envelope $05, $0c
    audio_volume $0d
    audio_note $37, $06
    audio_note $35, $06
    audio_note $34, $06
    audio_note $35, $06
    audio_note $34, $06
    audio_note $30, $06
    audio_note $32, $06
    audio_volume $07
    audio_envelope $07, $06
.word_17:
    audio_note $40, $03
    audio_note $40, $03
    audio_repeat $0f, (.word_17 - AudioTrack_6d43) / 2
.word_1a:
    audio_note $42, $03
    audio_note $42, $03
    audio_repeat $07, (.word_1a - AudioTrack_6d43) / 2
    audio_note $47, $03
    audio_note $47, $03
    audio_envelope $05, $0c
    audio_volume $0d
    audio_note $37, $06
    audio_note $37, $06
    audio_note $37, $06
    audio_note $39, $06
    audio_note $37, $06
    audio_note $39, $06
    audio_note $3b, $06
    audio_volume $07
    audio_envelope $07, $06
.word_2a:
    audio_note $39, $03
    audio_note $35, $03
    audio_note $39, $03
    audio_note $3b, $03
    audio_note $40, $03
    audio_note $3b, $03
    audio_note $39, $03
    audio_note $35, $03
    audio_note $39, $03
    audio_note $35, $03
    audio_note $39, $03
    audio_note $3b, $03
    audio_note $40, $03
    audio_note $39, $03
    audio_note $40, $03
    audio_note $39, $03
    audio_note $34, $03
    audio_note $30, $03
    audio_note $34, $03
    audio_note $35, $03
    audio_note $37, $03
    audio_note $35, $03
    audio_note $34, $03
    audio_note $30, $03
    audio_note $34, $03
    audio_note $30, $03
    audio_note $34, $03
    audio_note $35, $03
    audio_note $37, $03
    audio_note $34, $03
    audio_note $37, $03
    audio_note $34, $03
    audio_repeat $01, (.word_2a - AudioTrack_6d43) / 2
.word_4b:
    audio_note $35, $03
    audio_note $39, $03
    audio_note $3b, $03
    audio_note $40, $03
    audio_repeat $03, (.word_4b - AudioTrack_6d43) / 2
.word_50:
    audio_note $37, $03
    audio_note $3b, $03
    audio_note $40, $03
    audio_note $42, $03
    audio_repeat $03, (.word_50 - AudioTrack_6d43) / 2
    audio_repeat $00, $00
    audio_end
