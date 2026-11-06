UpdateStageAnimatedTiles:: ; Update stage animated tiles when VRAM queue has room.
    ldh a, [hStageIndex]
    rst $00

    ; Stage animated-tile dispatcher table.
    dw UpdateStageAnimatedTiles_Set0
    dw UpdateStageAnimatedTiles_Set1
    dw UpdateStageAnimatedTiles_NoneA
    dw UpdateStageAnimatedTiles_Set2

UpdateStageAnimatedTiles_Set0::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [wStageInteractionSubstate]
    ld hl, StageAnimatedTileSequence0
    rst $38
    ld a, [hl]
    call DispatchStage0TileAnimationFrame
    ld hl, wStageInteractionSubstate
    inc [hl]
    ld a, [hl]
    cp $18
    ret c

    ld [hl], $00
    ret



StageAnimatedTileSequence0::
    db $01, $04, $00, $06, $01, $00, $00, $05, $02, $00, $00, $00, $02, $04, $00, $00
    db $03, $00, $00, $05, $03, $07, $00, $00

DispatchStage0TileAnimationFrame::
; A indexes the stage 0 tile-animation arrangement.
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw Stage0TileAnim_None ; 00
    dw Stage0TileAnim_01 ; 01
    dw Stage0TileAnim_02 ; 02
    dw Stage0TileAnim_03 ; 03
    dw Stage0TileAnim_04 ; 04
    dw Stage0TileAnim_05 ; 05
    dw Stage0TileAnim_06 ; 06
    dw Stage0TileAnim_07 ; 07

Stage0TileAnim_None::
    ret


Stage0TileAnim_01::
    ld c, $39
    ld e, c
    call QueueStage0AnimatedBgTile
    ld c, $3a
    ld e, c
    call QueueStage0AnimatedBgTile
    ld c, $3b
    ld e, c
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_02::
    ld c, $3a
    ld e, $39
    call QueueStage0AnimatedBgTile
    ld c, $3b
    ld e, $3a
    call QueueStage0AnimatedBgTile
    ld c, $39
    ld e, $3b
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_03::
    ld c, $3b
    ld e, $39
    call QueueStage0AnimatedBgTile
    ld c, $39
    ld e, $3a
    call QueueStage0AnimatedBgTile
    ld c, $3a
    ld e, $3b
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_04::
    ld c, $3c
    ld e, $3c
    call QueueStage0AnimatedBgTile
    ld c, $3d
    ld e, $3d

QueueStage0AnimatedBgTile::
; C=source tile, E=VRAM $9000 tile index.
    ld d, $07
    ld hl, Gfx_b07_4001
    jp QueueBankedVramTile9000


Stage0TileAnim_05::
    ld c, $3c
    ld e, $3d
    call QueueStage0AnimatedBgTile
    ld c, $3d
    ld e, $3c
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_06::
    ld c, $2e
    ld e, $2e
    call QueueStage0AnimatedBgTile
    ld c, $2f
    ld e, $2f
    jr QueueStage0AnimatedBgTile

Stage0TileAnim_07::
    ld c, $2e
    ld e, $2f
    call QueueStage0AnimatedBgTile
    ld c, $2f
    ld e, $2e
    jr QueueStage0AnimatedBgTile

UpdateStageAnimatedTiles_Set1::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [wStage1CameraProfileIndex]
    or a
    ret nz

    ld a, [wStageInteractionSubstate]
    ld hl, StageAnimatedTileSequence1
    rst $38
    ld a, [hl]
    call DispatchStage1TileAnimationFrame
    ld hl, wStageInteractionSubstate
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret



StageAnimatedTileSequence1::
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DispatchStage1TileAnimationFrame::
; A indexes the stage 1 tile-animation arrangement.
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw Stage1TileAnim_None ; 00
    dw Stage1TileAnim_01 ; 01
    dw Stage1TileAnim_02 ; 02

Stage1TileAnim_None::
    ret


Stage1TileAnim_01::
    ld c, $29
    ld e, c
    call QueueStage1AnimatedBgTile
    ld c, $2a
    ld e, c
    jp QueueStage1AnimatedBgTile


Stage1TileAnim_02::
    ld c, $29
    ld e, $2a
    call QueueStage1AnimatedBgTile
    ld c, $2a
    ld e, $29

QueueStage1AnimatedBgTile::
; C=source tile, E=VRAM $9000 tile index.
    ld d, $07
    ld hl, Gfx_b07_46e1
    jp QueueBankedVramTile9000


UpdateStageAnimatedTiles_NoneA::
    ret


UpdateStageAnimatedTiles_Set2::
    ldh a, [hCollisionFlag]
    and $60
    ret nz

    ld a, [wStage1CameraProfileIndex]
    or a
    ret nz

    ld a, [wStageInteractionSubstate]
    ld hl, StageAnimatedTileSequence2
    rst $38
    ld a, [hl]
    call DispatchStage2TileAnimationFrame
    ld hl, wStageInteractionSubstate
    inc [hl]
    ld a, [hl]
    cp $20
    ret c

    ld [hl], $00
    ret



StageAnimatedTileSequence2::
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DispatchStage2TileAnimationFrame::
; A indexes the stage 2 tile-animation arrangement.
    rst $00

    ; Stage animated tile sub-dispatch table.
    dw Stage2TileAnim_None ; 00
    dw Stage2TileAnim_01 ; 01
    dw Stage2TileAnim_02 ; 02

Stage2TileAnim_None::
    ret


Stage2TileAnim_01::
    ld c, $5e
    ld e, c
    call QueueStage2AnimatedBgTile
    ld c, $5f
    ld e, c
    jp QueueStage2AnimatedBgTile


Stage2TileAnim_02::
    ld c, $5e
    ld e, $5f
    call QueueStage2AnimatedBgTile
    ld c, $5f
    ld e, $5e

QueueStage2AnimatedBgTile::
; C=source tile, E=VRAM $9000 tile index.
    ld d, $07
    ld hl, Gfx_b07_5af1
    jp QueueBankedVramTile9000
