; Native two-byte sequencer commands. FF alone terminates a track.
MACRO audio_header
    db \1, \2, \3, \4
ENDM
MACRO audio_note
    db \1, \2
ENDM
MACRO audio_volume
    db $a0, \1
ENDM
MACRO audio_pitch_offset
    db $a1, \1
ENDM
MACRO audio_duty_or_wave_length
    db $a2, \1
ENDM
MACRO audio_vibrato
    db $a3, \1
ENDM
MACRO audio_pan
    db $a5, \1
ENDM
MACRO audio_master_volume
    db $a6, \1
ENDM
MACRO audio_wait
    db $a7, \1
ENDM
MACRO audio_pitch_mode
    db $ae, \1
ENDM
MACRO audio_tempo
    db $af, \1
ENDM
MACRO audio_loop_start
    db $fd, \1
ENDM
MACRO audio_repeat
    db $b0 | \1, \2
ENDM
MACRO audio_envelope
    db $c0 | \1, \2
ENDM
MACRO audio_volume_up
    db $d0 | \1, \2
ENDM
MACRO audio_volume_down
    db $e0 | \1, \2
ENDM
MACRO audio_command
    db \1, \2
ENDM
MACRO audio_end
    db $ff
ENDM
