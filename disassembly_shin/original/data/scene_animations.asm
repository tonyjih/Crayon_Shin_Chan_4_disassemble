; 73 animation streams in original order; a few labels enter shared tails.
; scene_hold has no pointer operand. The two following legacy words stay literal.

SceneAnim_TitleIntro::
    scene_frame 12, $01
    scene_frame 12, $00
    scene_loop SceneAnim_TitleIntro

SceneAnim_TitleIdle::
    scene_frame 12, $02
    scene_frame 12, $03
    scene_frame 12, $04
    scene_frame 12, $02
    scene_frame 12, $03
    scene_frame 12, $04
    scene_frame 12, $02, SCENE_ANIM_FLIP
    scene_frame 12, $03, SCENE_ANIM_FLIP
    scene_frame 12, $04, SCENE_ANIM_FLIP
    scene_frame 12, $02, SCENE_ANIM_FLIP
    scene_frame 12, $03, SCENE_ANIM_FLIP
    scene_frame 12, $04, SCENE_ANIM_FLIP
    scene_frame 9, $05
    scene_frame 12, $06
    scene_frame 12, $07
    scene_frame 12, $06
    scene_frame 12, $07
    scene_frame 9, $08
    scene_frame 12, $09
    scene_frame 12, $0a
    scene_frame 12, $09
    scene_frame 12, $0a
    scene_frame 9, $0b
    scene_loop SceneAnim_TitleIdle

SceneAnim_TitleSecondary::
    scene_frame 12, $0c
    scene_frame 12, $0d
    scene_loop SceneAnim_TitleSecondary

SceneAnim_Scene3Mode0Primary::
    scene_frame 8, $0e
    scene_frame 8, $0f
    scene_frame 8, $0e
    scene_frame 8, $10
    scene_loop SceneAnim_Scene3Mode0Primary

SceneAnim_Scene3Mode0Variant::
    scene_frame 8, $0e, SCENE_ANIM_FLIP
    scene_frame 8, $0f, SCENE_ANIM_FLIP
    scene_frame 8, $0e, SCENE_ANIM_FLIP
    scene_frame 8, $10, SCENE_ANIM_FLIP
    scene_loop SceneAnim_Scene3Mode0Variant

SceneAnim_Scene3Mode0Secondary::
    scene_frame 24, $11
    scene_frame 24, $12
    scene_frame 24, $13
    scene_frame 48, $14
    scene_hold
    dw SceneAnim_Scene3Mode0Secondary ; Unused legacy target after HOLD; the decoder never reads this word.

SceneAnim_Scene3Mode0State1::
    scene_frame 24, $16
    scene_frame 24, $15
    scene_loop SceneAnim_Scene3Mode0State1

SceneAnim_Scene3Mode0State2::
    scene_frame 8, $17
    scene_frame 8, $18
    scene_frame 8, $17
    scene_frame 8, $19
    scene_loop SceneAnim_Scene3Mode0State2

SceneAnim_7913::
    scene_frame 12, $1a
    scene_frame 12, $1b
    scene_loop SceneAnim_7913

SceneAnim_791a::
    scene_frame 6, $1a
    scene_frame 6, $1c
    scene_frame 127, $1d
    scene_hold

SceneAnim_7921::
    scene_frame 12, $1e
    scene_frame 12, $1f
    scene_loop SceneAnim_7921

SceneAnim_7928::
    scene_frame 6, $1e
    scene_frame 6, $20
    scene_frame 127, $21
    scene_hold

SceneAnim_792f::
    scene_frame 12, $1e, SCENE_ANIM_FLIP
    scene_frame 12, $1f, SCENE_ANIM_FLIP
    scene_loop SceneAnim_792f

SceneAnim_7936::
    scene_frame 6, $1e, SCENE_ANIM_FLIP
    scene_frame 6, $20, SCENE_ANIM_FLIP
    scene_frame 112, $21, SCENE_ANIM_FLIP
    scene_hold

SceneAnim_793d::
    scene_frame 12, $22
    scene_frame 12, $23
    scene_loop SceneAnim_793d

SceneAnim_7944::
    scene_frame 6, $22
    scene_frame 6, $24
    scene_frame 127, $25
    scene_hold

SceneAnim_794b::
    scene_frame 4, $26
    scene_frame 4, $27
    scene_frame 4, $28
    scene_frame 4, $29
    scene_frame 4, $26
    scene_frame 4, $27
    scene_frame 4, $28
    scene_frame 4, $29
    scene_frame 4, $39
    scene_hold
    dw SceneAnim_794b ; Unused legacy target after HOLD; the decoder never reads this word.

SceneAnim_7960::
    scene_frame 15, $2a
    scene_frame 15, $2b
    scene_loop SceneAnim_7960

SceneAnim_7967::
    scene_frame 15, $44
    scene_frame 15, $45
    scene_loop SceneAnim_7967

SceneAnim_796e::
    scene_frame 4, $26
    scene_frame 4, $27
    scene_frame 4, $28
    scene_frame 4, $29
    scene_frame 4, $26
    scene_frame 4, $27
    scene_frame 4, $28
    scene_frame 4, $29
    scene_frame 64, $52
    scene_frame 16, $53

SceneAnim_7982::
    scene_frame 16, $52
    scene_frame 16, $53
    scene_loop SceneAnim_7982

SceneAnim_ContinueIdle::
    scene_frame 24, $56
    scene_frame 14, $55
    scene_frame 14, $54
    scene_frame 24, $56, SCENE_ANIM_FLIP
    scene_frame 14, $55, SCENE_ANIM_FLIP
    scene_frame 14, $54, SCENE_ANIM_FLIP
    scene_loop SceneAnim_ContinueIdle

SceneAnim_ContinueAccepted::
    scene_frame 6, $57
    scene_frame 6, $58
    scene_frame 6, $57
    scene_frame 6, $59
    scene_loop SceneAnim_ContinueAccepted

SceneAnim_ContinueExitReaction::
    scene_frame 8, $5a
    scene_frame 8, $5b
    scene_frame 8, $5a
    scene_frame 8, $5c
    scene_loop SceneAnim_ContinueExitReaction

SceneAnim_ContinueExit::
    scene_frame 8, $5d
    scene_frame 8, $5e
    scene_frame 8, $5f
    scene_loop SceneAnim_ContinueExit

SceneAnim_79b7::
    scene_frame 8, $60
    scene_frame 13, $61

SceneAnim_79bb::
    scene_frame 8, $60
    scene_hold

SceneAnim_79be::
    scene_frame 64, $60
    scene_frame 8, $63
    scene_frame 32, $64
    scene_frame 8, $65
    scene_frame 8, $66
    scene_frame 8, $65
    scene_frame 2, $64
    scene_hold

SceneAnim_79cd::
    scene_frame 15, $67
    scene_frame 15, $68
    scene_loop SceneAnim_79cd

SceneAnim_79d4::
    scene_frame 64, $60
    scene_frame 8, $63
    scene_frame 15, $77
    scene_frame 8, $78
    scene_frame 8, $79
    scene_frame 8, $7a
    scene_frame 8, $79
    scene_frame 8, $78
    scene_hold

SceneAnim_79e5::
    scene_frame 16, $7d
    scene_frame 16, $7c
    scene_loop SceneAnim_79e5

SceneAnim_79ec::
    scene_frame 16, $7e
    scene_frame 16, $7f
    scene_loop SceneAnim_79ec

SceneAnim_79f3::
    scene_frame 16, $81
    scene_frame 16, $82
    scene_loop SceneAnim_79f3

SceneAnim_79fa::
    scene_frame 16, $83
    scene_frame 16, $84
    scene_loop SceneAnim_79fa

SceneAnim_7a01::
    scene_frame 16, $85
    scene_frame 16, $86
    scene_loop SceneAnim_7a01

SceneAnim_7a08::
    scene_frame 16, $87
    scene_frame 16, $88
    scene_loop SceneAnim_7a08

SceneAnim_7a0f::
    scene_frame 8, $89
    scene_frame 8, $8a
    scene_loop SceneAnim_7a0f

SceneAnim_7a16::
    scene_frame 16, $8b
    scene_frame 16, $8c
    scene_frame 16, $8d
    scene_loop SceneAnim_7a16

SceneAnim_7a1f::
    scene_frame 8, $8f
    scene_frame 8, $90
    scene_frame 8, $8f
    scene_frame 127, $8e
    scene_hold

SceneAnim_7a28::
    scene_frame 16, $94
    scene_frame 16, $95
    scene_loop SceneAnim_7a28

SceneAnim_7a2f::
    scene_frame 8, $97
    scene_frame 8, $98
    scene_loop SceneAnim_7a2f

SceneAnim_7a36::
    scene_frame 63, $a2
    scene_frame 15, $a3
    scene_frame 8, $a4

SceneAnim_7a3c::
    scene_frame 8, $a5
    scene_frame 8, $a4
    scene_loop SceneAnim_7a3c

SceneAnim_7a43::
    scene_frame 8, $a8
    scene_frame 8, $a9
    scene_frame 8, $a8
    scene_frame 8, $aa
    scene_loop SceneAnim_7a43

SceneAnim_7a4e::
    scene_frame 8, $ae
    scene_frame 8, $af
    scene_hold

SceneAnim_7a53::
    scene_frame 31, $ae
    scene_frame 31, $af
    scene_hold

SceneAnim_7a58::
    scene_frame 15, $ae
    scene_frame 15, $af
    scene_frame 15, $ae
    scene_frame 15, $af
    scene_hold

SceneAnim_7a61::
    scene_frame 63, $a2
    scene_frame 15, $a3
    scene_frame 8, $a4
    scene_frame 8, $a5
    scene_frame 8, $a4
    scene_frame 8, $a5
    scene_frame 8, $a4
    scene_frame 8, $a5
    scene_frame 8, $a4
    scene_frame 8, $a5
    scene_frame 8, $a4
    scene_frame 8, $a5
    scene_frame 8, $b0
    scene_hold

SceneAnim_7a7c::
    scene_frame 63, $c4
    scene_hold

SceneAnim_7a7f::
    scene_frame 15, $c4, SCENE_ANIM_FLIP
    scene_hold

SceneAnim_7a82::
    scene_frame 63, $c9
    scene_hold

SceneAnim_7a85::
    scene_frame 63, $cc
    scene_hold

SceneAnim_7a88::
    scene_frame 63, $cf
    scene_hold

SceneAnim_7a8b::
    scene_frame 63, $d6
    scene_hold

SceneAnim_7a8e::
    scene_frame 63, $d9
    scene_hold

SceneAnim_7a91::
    scene_frame 63, $dc
    scene_hold

SceneAnim_7a94::
    scene_frame 63, $e3
    scene_hold

SceneAnim_7a97::
    scene_frame 12, $b3
    scene_frame 12, $b4
    scene_frame 12, $b3
    scene_frame 12, $b5
    scene_loop SceneAnim_7a97

SceneAnim_7aa2::
    scene_frame 32, $b3
    scene_frame 15, $b6
    scene_frame 15, $b7
    scene_frame 15, $b6
    scene_frame 15, $b7
    scene_frame 15, $b6
    scene_frame 15, $b7
    scene_frame 15, $b9
    scene_frame 15, $b8
    scene_frame 15, $b9
    scene_frame 15, $b8
    scene_frame 19, $ba
    scene_frame 19, $bb
    scene_frame 19, $bc
    scene_frame 19, $bd
    scene_frame 19, $be
    scene_frame 19, $bd
    scene_frame 19, $be
    scene_frame 19, $bd
    scene_frame 19, $be
    scene_hold

SceneAnim_7acb::
    scene_frame 12, $bf
    scene_frame 12, $c0
    scene_frame 12, $bf
    scene_frame 12, $c1
    scene_loop SceneAnim_7acb

SceneAnim_7ad6::
    scene_frame 32, $bf
    scene_frame 15, $c2
    scene_frame 15, $c3
    scene_frame 15, $c2
    scene_frame 15, $c3
    scene_frame 15, $c2
    scene_frame 15, $c3
    scene_hold

SceneAnim_7ae5::
    scene_frame 19, $c4
    scene_frame 19, $c5
    scene_frame 19, $c4
    scene_frame 19, $c5
    scene_hold

SceneAnim_7aee::
    scene_frame 12, $c6
    scene_frame 12, $c7
    scene_frame 12, $c6
    scene_frame 12, $c8
    scene_loop SceneAnim_7aee

SceneAnim_7af9::
    scene_frame 12, $c9
    scene_frame 12, $ca
    scene_frame 12, $c9
    scene_frame 12, $cb
    scene_loop SceneAnim_7af9

SceneAnim_7b04::
    scene_frame 12, $cc
    scene_frame 12, $cd
    scene_frame 12, $cc
    scene_frame 12, $ce
    scene_loop SceneAnim_7b04

SceneAnim_7b0f::
    scene_frame 12, $d0
    scene_frame 12, $d1
    scene_frame 12, $d0
    scene_frame 12, $d1
    scene_frame 12, $d0
    scene_frame 12, $d1
    scene_hold

SceneAnim_7b1c::
    scene_frame 12, $d3
    scene_frame 12, $d4
    scene_frame 12, $d3
    scene_frame 12, $d5
    scene_loop SceneAnim_7b1c

SceneAnim_7b27::
    scene_frame 12, $d6
    scene_frame 12, $d7
    scene_frame 12, $d6
    scene_frame 12, $d8
    scene_loop SceneAnim_7b27

SceneAnim_7b32::
    scene_frame 12, $d9
    scene_frame 12, $da
    scene_frame 12, $d9
    scene_frame 12, $db
    scene_loop SceneAnim_7b32

SceneAnim_7b3d::
    scene_frame 28, $dd
    scene_frame 15, $de
    scene_frame 15, $df
    scene_hold

SceneAnim_7b44::
    scene_frame 12, $e0
    scene_frame 12, $e1
    scene_frame 12, $e0
    scene_frame 12, $e2
    scene_loop SceneAnim_7b44

SceneAnim_7b4f::
    scene_frame 12, $e3
    scene_frame 12, $e4
    scene_frame 12, $e3
    scene_frame 12, $e5
    scene_loop SceneAnim_7b4f

SceneAnim_7b5a::
    scene_frame 10, $e6
    scene_frame 10, $e7
    scene_frame 10, $e6
    scene_frame 10, $e8
    scene_loop SceneAnim_7b5a

SceneAnim_7b65::
    scene_frame 15, $e6
    scene_frame 15, $e7
    scene_frame 15, $e6
    scene_frame 15, $e8
    scene_loop SceneAnim_7b65

SceneAnim_7b70::
    scene_frame 10, $e9
    scene_frame 8, $ea
    scene_frame 8, $eb
    scene_frame 8, $ea
    scene_frame 8, $eb
    scene_frame 8, $ea
    scene_frame 8, $eb
    scene_frame 8, $ea
    scene_frame 8, $eb
    scene_loop SceneAnim_7b70

SceneAnim_7b85::
    scene_frame 10, $ec
    scene_frame 10, $ed
    scene_frame 10, $ee
    scene_loop SceneAnim_7b85
