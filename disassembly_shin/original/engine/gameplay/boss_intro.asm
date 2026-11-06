BossIntro_AdjustCameraBeforeTiles::
    ldh a, [hStageIndex]
    cp $03
    jr z, BossIntro_ApproachStage3CameraY

    ld hl, hSCY
    ld a, [wCameraScrollYMaxLo]
    cp [hl]
    ret z

    inc [hl]
    ret


BossIntro_ApproachStage3CameraY::
    ld hl, hSCY
    ld a, [hl]
    cp $80
    ret z

    jr nc, BossIntro_ScrollStage3CameraUp

    inc [hl]
    jp QueueCurrentCameraBgRow


BossIntro_ScrollStage3CameraUp::
    dec [hl]
    jp QueueCurrentCameraBgRow


; Boss intro flow:
;   BANK0 camera clamp sets wStageBossCountdown=$ff when the player reaches the stage end.
;   While the countdown is nonzero, this handler adjusts boss-area camera position,
;   streams boss sprite graphics from bank 5, then spawns OBJ_STAGE0_BOSS-OBJ_STAGE3_BOSS.
UpdateStageBossIntro:: ; Boss intro/countdown handler. Loads boss tiles, then spawns the stage boss.
    dec a
    ld [wStageBossCountdown], a
    jr z, SpawnStageBossFromIntro

    ld b, a
    ld a, $bd
    sub b
    ld b, a
    cp $60
    jr nc, BossIntro_AdjustCameraBeforeTiles

    ld a, STAGE_BOSS_STATE_ACTIVE
    ld [wStageBossStateFlag], a
    ld hl, BossSpriteGfxSourceBaseTable
    ldh a, [hStageIndex]
    rst $20
    ld c, b
    ld a, $70
    add b
    ld e, a
    ld d, $05
    jp QueueBankedVramTile8000


BossSpriteGfxSourceBaseTable:: ; Bank 5 source bases for boss sprite graphics loaded during intro.
    dw Gfx_b05_64e1 + $80 ; Stage 0 boss graphics base in bank 5.
    dw Gfx_b05_64e1 + $340 ; Stage 1 boss graphics base in bank 5.
    dw Gfx_b05_64e1 + $610 ; Stage 2 boss graphics base in bank 5.
    dw Gfx_b05_64e1 + $9a0 ; Stage 3 boss graphics base in bank 5.

SpawnStageBossFromIntro::
    ld hl, BossSpawnRecordPtrs
    ldh a, [hStageIndex]
    rst $20
    ld a, l
    ldh [hSpawnRecordPtrLo], a
    ld a, h
    ldh [hSpawnRecordPtrHi], a
    jp FindFreeObjectSlot


BossSpawnRecordPtrs:: ; Bosses are spawned by the countdown flow, not normal stage spawn lists.
    dw BossSpawnRecord_Stage0
    dw BossSpawnRecord_Stage1
    dw BossSpawnRecord_Stage2
    dw BossSpawnRecord_Stage3

BossSpawnRecord_Stage0::
    db OBJ_STAGE0_BOSS, $08, $0e, $f0, $00 ; type, x_lo, x_hi, y_lo, y_hi
BossSpawnRecord_Stage1::
    db OBJ_STAGE1_BOSS, $08, $0e, $c0, $00
BossSpawnRecord_Stage2::
    db OBJ_STAGE2_BOSS, $08, $02, $c0, $00
BossSpawnRecord_Stage3::
    db OBJ_STAGE3_BOSS, $08, $0a, $f0, $00
