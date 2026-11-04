; Font tile IDs verified against gfx/compressed/b06_4bc0.png.
; A voiced kana emits a mark BEFORE its base tile, not a Unicode byte sequence.
; FILL_01..03 are solid color tiles. TILE_* depend on the screen graphics.
PUSHC
NEWCHARMAP shin_text

CHARMAP " ", $00
CHARMAP "<FILL_01>", $01
CHARMAP "<FILL_02>", $02
CHARMAP "<FILL_03>", $03
CHARMAP "０", $04
CHARMAP "１", $05
CHARMAP "２", $06
CHARMAP "３", $07
CHARMAP "４", $08
CHARMAP "５", $09
CHARMAP "６", $0a
CHARMAP "７", $0b
CHARMAP "８", $0c
CHARMAP "９", $0d
CHARMAP "<TIMER>", $0e
CHARMAP "<DPAD>", $0f
CHARMAP "あ", $10
CHARMAP "い", $11
CHARMAP "う", $12
CHARMAP "え", $13
CHARMAP "お", $14
CHARMAP "か", $15
CHARMAP "き", $16
CHARMAP "く", $17
CHARMAP "け", $18
CHARMAP "こ", $19
CHARMAP "さ", $1a
CHARMAP "し", $1b
CHARMAP "す", $1c
CHARMAP "せ", $1d
CHARMAP "そ", $1e
CHARMAP "た", $1f
CHARMAP "ち", $20
CHARMAP "つ", $21
CHARMAP "っ", $22
CHARMAP "て", $23
CHARMAP "と", $24
CHARMAP "な", $25
CHARMAP "に", $26
CHARMAP "ぬ", $27
CHARMAP "ね", $28
CHARMAP "の", $29
CHARMAP "は", $2a
CHARMAP "ひ", $2b
CHARMAP "ふ", $2c
CHARMAP "へ", $2d
CHARMAP "ほ", $2e
CHARMAP "ま", $2f
CHARMAP "み", $30
CHARMAP "む", $31
CHARMAP "め", $32
CHARMAP "も", $33
CHARMAP "ら", $34
CHARMAP "り", $35
CHARMAP "る", $36
CHARMAP "れ", $37
CHARMAP "ろ", $38
CHARMAP "や", $39
CHARMAP "ゃ", $3a
CHARMAP "ゆ", $3b
CHARMAP "ゅ", $3c
CHARMAP "よ", $3d
CHARMAP "ょ", $3e
CHARMAP "わ", $3f
CHARMAP "<A>", $40
CHARMAP "を", $41
CHARMAP "ん", $42
CHARMAP "<HANDAKUTEN>", $43
CHARMAP "．", $44
CHARMAP "<DAKUTEN>", $45
CHARMAP "ア", $46
CHARMAP "ァ", $47
CHARMAP "イ", $48
CHARMAP "ィ", $49
CHARMAP "ウ", $4a
CHARMAP "ゥ", $4b
CHARMAP "エ", $4c
CHARMAP "ェ", $4d
CHARMAP "オ", $4e
CHARMAP "ォ", $4f
CHARMAP "カ", $50
CHARMAP "キ", $51
CHARMAP "ク", $52
CHARMAP "ケ", $53
CHARMAP "コ", $54
CHARMAP "サ", $55
CHARMAP "シ", $56
CHARMAP "ス", $57
CHARMAP "セ", $58
CHARMAP "ソ", $59
CHARMAP "タ", $5a
CHARMAP "チ", $5b
CHARMAP "ツ", $5c
CHARMAP "ッ", $5d
CHARMAP "テ", $5e
CHARMAP "ト", $5f
CHARMAP "ナ", $60
CHARMAP "ニ", $61
CHARMAP "ヌ", $62
CHARMAP "ネ", $63
CHARMAP "ノ", $64
CHARMAP "ハ", $65
CHARMAP "ヒ", $66
CHARMAP "フ", $67
CHARMAP "「", $68
CHARMAP "ホ", $69
CHARMAP "マ", $6a
CHARMAP "ミ", $6b
CHARMAP "ム", $6c
CHARMAP "メ", $6d
CHARMAP "モ", $6e
CHARMAP "ヤ", $6f
CHARMAP "ャ", $70
CHARMAP "」", $71
CHARMAP "ュ", $72
CHARMAP "ヨ", $73
CHARMAP "ョ", $74
CHARMAP "ラ", $75
CHARMAP "リ", $76
CHARMAP "ル", $77
CHARMAP "レ", $78
CHARMAP "ロ", $79
CHARMAP "ワ", $7a
CHARMAP "<B>", $7b
CHARMAP "ン", $7c
CHARMAP "！", $7d
CHARMAP "ー", $7e
CHARMAP "？", $7f

; The font shares the hiragana he tile with katakana he/be/pe.
CHARMAP "ヘ", $2d
CHARMAP "が", $45, $15
CHARMAP "ぎ", $45, $16
CHARMAP "ぐ", $45, $17
CHARMAP "げ", $45, $18
CHARMAP "ご", $45, $19
CHARMAP "ざ", $45, $1a
CHARMAP "じ", $45, $1b
CHARMAP "ず", $45, $1c
CHARMAP "ぜ", $45, $1d
CHARMAP "ぞ", $45, $1e
CHARMAP "だ", $45, $1f
CHARMAP "ぢ", $45, $20
CHARMAP "づ", $45, $21
CHARMAP "で", $45, $23
CHARMAP "ど", $45, $24
CHARMAP "ば", $45, $2a
CHARMAP "び", $45, $2b
CHARMAP "ぶ", $45, $2c
CHARMAP "べ", $45, $2d
CHARMAP "ぼ", $45, $2e
CHARMAP "ぱ", $43, $2a
CHARMAP "ぴ", $43, $2b
CHARMAP "ぷ", $43, $2c
CHARMAP "ぺ", $43, $2d
CHARMAP "ぽ", $43, $2e
CHARMAP "ガ", $45, $50
CHARMAP "ギ", $45, $51
CHARMAP "グ", $45, $52
CHARMAP "ゲ", $45, $53
CHARMAP "ゴ", $45, $54
CHARMAP "ザ", $45, $55
CHARMAP "ジ", $45, $56
CHARMAP "ズ", $45, $57
CHARMAP "ゼ", $45, $58
CHARMAP "ゾ", $45, $59
CHARMAP "ダ", $45, $5a
CHARMAP "ヂ", $45, $5b
CHARMAP "ヅ", $45, $5c
CHARMAP "デ", $45, $5e
CHARMAP "ド", $45, $5f
CHARMAP "バ", $45, $65
CHARMAP "ビ", $45, $66
CHARMAP "ブ", $45, $67
CHARMAP "ベ", $45, $2d
CHARMAP "ボ", $45, $69
CHARMAP "パ", $43, $65
CHARMAP "ピ", $43, $66
CHARMAP "プ", $43, $67
CHARMAP "ペ", $43, $2d
CHARMAP "ポ", $43, $69
CHARMAP "ヴ", $45, $4a
CHARMAP "<TILE_8E>", $8e
CHARMAP "<TILE_8F>", $8f
CHARMAP "<TILE_A0>", $a0
CHARMAP "<TILE_A1>", $a1
CHARMAP "<TILE_C5>", $c5
CHARMAP "<WRITE>", TEXT_WRITE
CHARMAP "<VAR>", TEXT_SUB

POPC
