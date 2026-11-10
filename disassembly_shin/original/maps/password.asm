; Standalone source for the 20-by-18 password-screen tilemap.
INCLUDE "text/macros.inc"
INCLUDE "charmap.inc"

NEWCHARMAP password_tilemap, shin_text
CHARMAP "<BACKSPACE>", $b3
CHARMAP "<FORWARD>",   $b4
CHARMAP "<SUBMIT>",    $b5

DEF BOX_LEFT          EQU $93
DEF BOX_RIGHT         EQU $94
DEF BOX_BOTTOM        EQU $95
DEF BOX_BOTTOM_RIGHT  EQU $96
DEF BOX_BOTTOM_LEFT   EQU $97
DEF BOX_TOP_RIGHT     EQU $98
DEF BOX_TOP_LEFT      EQU $99
DEF PROMPT_TIP_LEFT   EQU $9c
DEF PROMPT_TIP_RIGHT  EQU $9d
DEF INPUT_SLOT_BOTTOM EQU $b0

; Visible kana, left margin, right margin, and whether to draw the top edge.
; Emit the accent row above the base glyph row, matching the cursor's two-row stride.
MACRO password_kana_panel
    ASSERT CHARLEN(\1) + \2 + \3 + 2 == 20, "Password panel must fill a 20-tile row"
    ds \2, 0
    IF \4
        db BOX_TOP_LEFT
        DEF panel_right EQU BOX_TOP_RIGHT
        DEF panel_blank EQU PASSWORD_ACCENT_BLANK
        DEF panel_dakuten EQU PASSWORD_ACCENT_DAKUTEN
        DEF panel_handakuten EQU PASSWORD_ACCENT_HANDAKUTEN
    ELSE
        db BOX_LEFT
        DEF panel_right EQU BOX_RIGHT
        DEF panel_blank EQU 0
        DEF panel_dakuten EQU TEXT_DAKUTEN
        DEF panel_handakuten EQU TEXT_HANDAKUTEN
    ENDC
    FOR panel_index, CHARLEN(\1)
        ASSERT INCHARMAP(STRCHAR(\1, panel_index)), "Unmapped password tile"
        IF CHARSIZE(STRCHAR(\1, panel_index)) == 1
            db panel_blank
        ELIF CHARVAL(STRCHAR(\1, panel_index), 0) == TEXT_DAKUTEN
            db panel_dakuten
        ELSE
            ASSERT CHARVAL(STRCHAR(\1, panel_index), 0) == TEXT_HANDAKUTEN, "Invalid password accent"
            db panel_handakuten
        ENDC
    ENDR
    db panel_right
    ds \3, 0

    ds \2, 0
    db BOX_LEFT
    FOR panel_index, CHARLEN(\1)
        db CHARVAL(STRCHAR(\1, panel_index), -1)
    ENDR
    db BOX_RIGHT
    ds \3, 0
    PURGE panel_index, panel_right, panel_blank, panel_dakuten, panel_handakuten
ENDM

SECTION "Password tilemap", ROM0[0]
PasswordTilemap:
    password_kana_panel "ぱすわーどいれれば？", 3, 5, 1

    ; Callout tip and the empty two-row, ten-column password entry area.
    ds 3, 0
    db BOX_LEFT
    ds PASSWORD_CODE_WIDTH, 0
    db PROMPT_TIP_LEFT, PROMPT_TIP_RIGHT
    ds 4, 0
    ds 3, 0
    db BOX_LEFT
    ds PASSWORD_CODE_WIDTH, 0
    db BOX_RIGHT
    ds 5, 0
    ds 3, 0
    db BOX_BOTTOM_LEFT
    ds PASSWORD_CODE_WIDTH, INPUT_SLOT_BOTTOM
    db BOX_BOTTOM_RIGHT
    ds 5, 0
    ds 20, 0

    ; The two gaps between columns are skipped by the cursor.
    password_kana_panel "あいうえお はひふへほ がぎぐげご ", 0, 0, 1
    password_kana_panel "かきくけこ まみむめも ざじずぜぞ ", 0, 0, 0
    password_kana_panel "さしすせそ らりるれろ だぢづでど ", 0, 0, 0
    password_kana_panel "たちつてと やゃゆゅよ ばびぶべぼ ", 0, 0, 0
    password_kana_panel "なにぬねの ょわをん    <BACKSPACE><FORWARD><SUBMIT> ", 0, 0, 0

    db BOX_LEFT
    ds 18, 0
    db BOX_RIGHT, BOX_BOTTOM_LEFT
    ds 18, BOX_BOTTOM
    db BOX_BOTTOM_RIGHT
    ASSERT @ - PasswordTilemap == 20 * 18
