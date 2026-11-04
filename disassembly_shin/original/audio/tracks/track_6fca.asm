; Sound IDs: $24
AudioTrack_6fca::
    audio_header $00, $00, $06, $00
    audio_loop_start $fe
    audio_envelope $01, $03
.word_04:
    audio_note $40, $06
    audio_repeat $0f, (.word_04 - AudioTrack_6fca) / 2
.word_06:
    audio_note $42, $06
    audio_repeat $0f, (.word_06 - AudioTrack_6fca) / 2
.word_08:
    audio_note $40, $06
    audio_repeat $0f, (.word_08 - AudioTrack_6fca) / 2
.word_0a:
    audio_note $42, $06
    audio_repeat $0f, (.word_0a - AudioTrack_6fca) / 2
.word_0c:
    audio_note $45, $06
    audio_repeat $07, (.word_0c - AudioTrack_6fca) / 2
.word_0e:
    audio_note $40, $06
    audio_repeat $07, (.word_0e - AudioTrack_6fca) / 2
.word_10:
    audio_note $45, $06
    audio_repeat $07, (.word_10 - AudioTrack_6fca) / 2
.word_12:
    audio_note $47, $06
    audio_repeat $07, (.word_12 - AudioTrack_6fca) / 2
    audio_repeat $00, $00
    audio_end
