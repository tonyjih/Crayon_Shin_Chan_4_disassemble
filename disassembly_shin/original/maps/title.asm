; Standalone 20-by-18 title tilemap. Logo and credit tiles refer to b06_4001.png.
INCLUDE "text/macros.inc"
INCLUDE "charmap.inc"

DEF TITLE_SUBTITLE EQUS "\"ーオラのいたずらだいへんしんー\""
DEF TITLE_COPYRIGHT_TILE EQU $8f

SECTION "Title tilemap", ROM0[0]
TitleTilemap:
    ; Rows 0-3. クレヨンしんちゃん logo on the left, drawn number 4 at the far right.
    ds 18, 0
    db $84, 0
    db $90, $91, $92, $93, $94, $95, $96, $97, $98, 0, $9a, $9b, $9c, $9d, $9e, $9f, 0
    db $85, $86, $87
    db $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, 0
    db $88, $89, $8a
    db 0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf, $99
    db $8b, $8c, $8d

TitleSubtitleRows:
    ; Rows 4-5. Accent tiles sit above the base glyphs. The number 4 ends at the right of row 4.
    PUSHC shin_text
    ASSERT CHARLEN(TITLE_SUBTITLE) == 15
    ds 2, 0
    FOR subtitle_index, CHARLEN(TITLE_SUBTITLE)
        ASSERT INCHARMAP(STRCHAR(TITLE_SUBTITLE, subtitle_index)), "Unmapped title subtitle glyph"
        IF CHARSIZE(STRCHAR(TITLE_SUBTITLE, subtitle_index)) == 2
            db CHARVAL(STRCHAR(TITLE_SUBTITLE, subtitle_index), 0)
        ELSE
            db 0
        ENDC
    ENDR
    db 0, $b0, $8e

    ds 2, 0
    FOR subtitle_index, CHARLEN(TITLE_SUBTITLE)
        db CHARVAL(STRCHAR(TITLE_SUBTITLE, subtitle_index), -1)
    ENDR
    ds 3, 0
    PURGE subtitle_index
    POPC

    ; Rows 6-12 are blank background behind the animated characters.
    ds 7 * 20, 0

TitleCreditRows:
    ; © YOSHITO USUI/FUTABASHA, followed by ・SHINEI・TV ASAHI.
    db 0, TITLE_COPYRIGHT_TILE, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7
    db $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf, $d0, 0
    db 0, 0, 0, $d1, $c2, $c3, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da
    ds 5, 0

    ; © BANDAI 1994. The year uses the shared font.
    db 0, TITLE_COPYRIGHT_TILE, $db, $cd, $dc, $dd, $de, 0, 0
    text "１９９４"
    ds 7, 0

    ; LICENSED BY NINTENDO.
    db 0, 0, $df, $e0, $e1, $e2, $e3, $e4, 0, $e5, $e6, 0, $e7, $e8, $d5, $e9, $ea, $eb, 0, 0
    ds 20, 0
    ASSERT @ - TitleTilemap == 20 * 18
