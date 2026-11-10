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

DEF PASSWORD_CODE_WIDTH EQU 10
DEF PASSWORD_CODE_SIZE  EQU 2 * PASSWORD_CODE_WIDTH
DEF PASSWORD_CODE_COUNT EQU 12

; Password-screen accent tiles with the top edge of the box drawn in.
DEF PASSWORD_ACCENT_BLANK      EQU $92
DEF PASSWORD_ACCENT_DAKUTEN    EQU $9a
DEF PASSWORD_ACCENT_HANDAKUTEN EQU $9b

MACRO password_code_length
    PUSHC shin_text
    db CHARLEN(\2)
    POPC
ENDM

MACRO password_code
    \1::
    PUSHC shin_text
    ASSERT 1 <= CHARLEN(\2) && CHARLEN(\2) <= PASSWORD_CODE_WIDTH, "Password must contain 1 to 10 characters"

    ; The input screen and the dialogue reveal both use a row of marks above the kana.
    FOR password_index, CHARLEN(\2)
        ASSERT INCHARMAP(STRCHAR(\2, password_index)), "Unmapped password character"
        IF CHARSIZE(STRCHAR(\2, password_index)) == 1
            db 0
        ELSE
            ASSERT CHARSIZE(STRCHAR(\2, password_index)) == 2 && CHARVAL(STRCHAR(\2, password_index), 0) == TEXT_DAKUTEN, "Password only supports dakuten"
            db TEXT_DAKUTEN
        ENDC
    ENDR
    ds PASSWORD_CODE_WIDTH - CHARLEN(\2), 0

    FOR password_index, CHARLEN(\2)
        DEF password_tile EQU CHARVAL(STRCHAR(\2, password_index), -1)
        ; The grid has spaces and hiragana, with no small っ or A button tile.
        ASSERT password_tile == 0 || ($10 <= password_tile && password_tile <= $42 && password_tile != $22 && password_tile != $40), "Password character is not on the input grid"
        db password_tile
        PURGE password_tile
    ENDR
    ds PASSWORD_CODE_WIDTH - CHARLEN(\2), 0
    PURGE password_index
    POPC
ENDM
