; Sound IDs: $2f
AudioTrack_7573::
    audio_header $00, $00, $08, $00
    audio_envelope $07, $04
.word_03:
    audio_note $0b, $0a
    audio_note $06, $0a
.word_05:
    audio_note $0b, $0a
    audio_note $06, $0a
    audio_repeat $03, (.word_03 - AudioTrack_7573) / 2
.word_08:
    audio_note $0b, $0a
    audio_note $06, $0a
    audio_note $0b, $0a
    audio_note $06, $0a
    audio_repeat $0f, (.word_08 - AudioTrack_7573) / 2
    audio_loop_start $fe
    audio_note $0b, $0a
    audio_note $06, $0a
    audio_note $0b, $0a
    audio_note $06, $0a
    audio_repeat $0f, (.word_05 - AudioTrack_7573) / 2
    audio_repeat $00, (.word_08 - AudioTrack_7573) / 2
    audio_end
