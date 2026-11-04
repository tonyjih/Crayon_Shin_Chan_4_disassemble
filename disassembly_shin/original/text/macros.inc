; Native message bytes; the control writer and substitution ID live in WRAM.
DEF TEXT_HANDAKUTEN EQU $43
DEF TEXT_DAKUTEN    EQU $45
DEF TEXT_WRITE     EQU $fc
DEF TEXT_SUB       EQU $fd
DEF TEXT_NEWLINE   EQU $fe
DEF TEXT_END       EQU $ff

MACRO text
    ASSERT _NARG == 1, "text expects one string"
    PUSHC shin_text
    ; RGBDS otherwise copies unmapped characters as UTF-8 bytes.
    FOR text_char_index, CHARLEN(\1)
        ASSERT INCHARMAP(STRCHAR(\1, text_char_index)), "Unmapped message character"
    ENDR
    PURGE text_char_index
    db \1
    POPC
ENDM

MACRO line
    db TEXT_NEWLINE
    text \1
ENDM

MACRO done
    ASSERT _NARG == 0, "done takes no arguments"
    db TEXT_END
ENDM
