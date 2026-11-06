BugHuntHudTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $85, $86, $87, $91, $91, $91, $91, $91, $80, $81, $91, $91, $91, $91, $82, $83
    db $84, $00, $00, $04, $00, $00, $00, $00, $00, $0d, $0d, $00, $00, $00, $00, $00
    db $00, $04

BugHuntRoundGoalTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $04, $04, $04, $0c, $04, $05, $05, $04, $05, $08, $04, $05, $0b, $04, $06
    db $04, $04, $06, $07, $04, $06, $0a, $04, $06, $0d, $04, $07, $06, $04, $07, $09
    db $04

BugHuntSpawnGates::
; VRAM address, then X and Y for the spawned bug.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    dw _SCRN0 + $04b
    db $64, $14
    dw _SCRN0 + $0a2
    db $1c, $2c
    dw _SCRN0 + $12f
    db $84, $4c
    dw _SCRN0 + $1c5
    db $34, $74

BugHuntGateBaseTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $88, $89, $8a

BugHuntGateBlinkTiles::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $8b, $8c, $8d

BugHuntGateDirectionChoices::
; Three movement axis/sign combinations per gate.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $01, $02, $03, $02, $03, $00, $00, $01, $02, $00, $03, $01

BugHuntRoundSpawnWeights::
; Four weights per round with a total of eight.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $04, $02, $01, $01, $04, $02, $01, $01, $03, $02, $02, $01, $03, $02, $02, $01
    db $02, $03, $02, $01, $02, $03, $02, $01, $02, $02, $03, $01, $02, $02, $03, $01
    db $01, $02, $03, $02, $01, $02, $02, $03

BugHuntMotionSteps::
; Signed-axis motion uses these unsigned 8.8 magnitudes.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $60, $00, $b0, $00, $00, $01, $e0, $01, $00, $00

BugHuntTypeScoreDigits::
; Tens and ones score increments per caught type.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $05, $01, $00, $01, $05, $02, $00

BugHuntBugFrames::
; Eight frame selectors per type. Bit 7 flips the metasprite.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $33, $4f, $34, $b4, $33, $4f, $34, $b4, $50, $51, $b7, $b8, $35, $36, $37, $38
    db $4c, $cc, $ad, $ae, $2c, $ac, $2d, $2e, $ce, $ce, $b2, $b2, $30, $30, $32, $32
    db $cd, $cd, $b1, $b1, $2f, $2f, $31, $31

BugHuntFirstHazardFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $42, $40, $3e, $40

BugHuntSecondHazardFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $4a, $48, $46, $48

; Indexed screen data; scene-specific interpretation is documented at its consumer.

Minigame2IdleAnimationPointers::
    dw SceneAnim_793d
    dw SceneAnim_792f
    dw SceneAnim_7913
    dw SceneAnim_7921

Minigame2ActionAnimationPointers::
    dw SceneAnim_7944
    dw SceneAnim_7936
    dw SceneAnim_791a
    dw SceneAnim_7928

Minigame2ActionOffsets::
    db $00, $ee, $ee, $00, $00, $12, $12, $00

BugHuntCatchBounds::
; Four directions, three animation phases, four signed offsets per rectangle.
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $f6, $0c, $0a, $1e, $f6, $f4, $0a, $0c, $f6, $e0, $0a, $f4, $00, $dc, $14, $f0
    db $e4, $e8, $00, $fd, $e4, $fd, $f8, $08, $f6, $dd, $0a, $f4, $f6, $f4, $0a, $0c
    db $f6, $0c, $0a, $1b, $ec, $dc, $00, $f0, $00, $e8, $1c, $fd, $08, $fd, $1c, $08

BugHuntFacingJoyMasks::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $40, $20, $80, $10

BugHuntCaughtPopupXOffsets::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $03, $02, $02, $01, $00, $ff, $fe, $fe, $fe, $fe, $fe, $ff, $00, $01, $02, $02

BugHuntCaughtPopupFrames::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $3c, $3b, $3a, $3d

BugHuntSpecialBugYOffsets::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $03, $03, $02, $03, $02, $01, $01, $00, $00, $ff, $ff, $fe, $fd, $fe, $fd
    db $fd

BugHuntInitialHazardRecords::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $00, $20, $48, $00, $00, $01, $00, $01, $00, $80, $48, $00, $00, $01, $00, $00

BugHuntHazardRespawnPositions::
; Indexed screen data; scene-specific interpretation is documented at its consumer.
    db $f8, $74, $f8, $48, $f8, $1c, $1c, $f8, $48, $f8, $74, $f8, $a8, $1c, $a8, $48
    db $a8, $74, $74, $a8, $48, $a8, $1c, $a8
