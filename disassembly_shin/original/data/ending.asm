EndingInitialObjectX::
    db $50, $f0, $f0, $f0
    ASSERT @ - EndingInitialObjectX == ENDING_ACTOR_COUNT

EndingInitialAnimationPointers::
    dw SceneAnim_7a97
    dw SceneAnim_7a7c
    dw SceneAnim_7a88
    dw SceneAnim_7a91
    ASSERT @ - EndingInitialAnimationPointers == ENDING_ACTOR_COUNT * 2

EndingCueMessageIds::
; Three scene triggers; the original fourth threshold $8e is beyond final credit $59.
    db $50, $53, $56, $8e

EndingCueRecords::
; Each cue: three X targets, one unread byte, then five sets of four animation IDs.
; Animation IDs index EndingAnimationPointers; $ff leaves that actor's script alone.
    db $30, $5c, $45, $00
    db $01, $0f, $ff, $ff
    db $ff, $04, $ff, $ff
    db $ff, $05, $ff, $ff
    db $00, $10, $ff, $ff
    db $02, $06, $ff, $ff

    db $24, $68, $39, $00
    db $03, $11, $ff, $ff
    db $ff, $ff, $08, $ff
    db $ff, $ff, $09, $ff
    db $02, $12, $13, $ff
    db $02, $07, $0a, $ff

    db $18, $74, $2d, $00
    db $03, $12, $13, $ff
    db $ff, $ff, $ff, $0c
    db $ff, $ff, $ff, $0d
    db $02, $12, $14, $15
    db $02, $07, $0b, $0e
    ASSERT @ - EndingCueRecords == 3 * ENDING_CUE_SIZE

EndingAnimationPointers::
    dw SceneAnim_7a97
    dw SceneAnim_7aa2
    dw SceneAnim_7acb
    dw SceneAnim_7ad6
    dw SceneAnim_7ae5
    dw SceneAnim_7aee
    dw SceneAnim_7af9
    dw SceneAnim_7b04
    dw SceneAnim_7b0f
    dw SceneAnim_7b1c
    dw SceneAnim_7b27
    dw SceneAnim_7b32
    dw SceneAnim_7b3d
    dw SceneAnim_7b44
    dw SceneAnim_7b4f
    dw SceneAnim_7a7c
    dw SceneAnim_7a7f
    dw SceneAnim_7a82
    dw SceneAnim_7a85
    dw SceneAnim_7a8b
    dw SceneAnim_7a8e
    dw SceneAnim_7a94
    ASSERT @ - EndingAnimationPointers == 22 * 2

EndingScrollBgRow::
    db $00, $00, $00, $00, $00, $00, $00, $00, $80, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01
    ASSERT @ - EndingScrollBgRow == 20

EndingParticleSeeds::
; Reset X, reset Y, initial age. Init first hides X/Y at $f0 and uses only the age.
    db $f8, $10, $20
    db $f8, $20, $18
    db $f8, $30, $00
    db $f8, $60, $30
    db $08, $98, $08
    db $20, $98, $40
    db $30, $98, $10
    db $00, $00, $28
    ASSERT @ - EndingParticleSeeds == ENDING_PARTICLE_COUNT * ENDING_PARTICLE_SIZE
