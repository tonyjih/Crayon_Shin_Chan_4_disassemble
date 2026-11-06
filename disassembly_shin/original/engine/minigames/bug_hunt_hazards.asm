BugHunt_UpdateRoundHazards::
    ld hl, wBugHazardSlots
    ld de, BugHuntFirstHazardFrames
    ld a, [wMinigameRound]
    cp $04
    call nc, BugHunt_UpdateHazard
    ld hl, wBugHazardSlots + BUG_HAZARD_SIZE
    ld de, BugHuntSecondHazardFrames
    ld a, [wMinigameRound]
    cp $07
    call nc, BugHunt_UpdateHazard
    ret


BugHunt_UpdateHazard::
; HL points to an eight-byte hazard record. DE points to its directional metasprite IDs.
    ld a, [hl+]
    or a
    jp nz, BugHunt_UpdateHazardRespawn

    push de
    ld c, $00
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [wBugPlayerX]
    add $08
    sub b
    jr nc, BugHunt_SaveHazardAbsXDelta

    cpl
    inc a
    set 0, c

BugHunt_SaveHazardAbsXDelta::
    ldh [hBugHazardAimAbsX], a
    ld a, [hl+]
    add $08
    ld b, a
    ld a, [wBugPlayerY]
    add $08
    sub b
    jr nc, BugHunt_CheckHazardAimRefresh

    cpl
    inc a
    set 1, c

BugHunt_CheckHazardAimRefresh::
    ldh [hBugHazardAimAbsY], a
    push hl
    inc hl
    ld a, [hl]
    or a
    jr z, BugHunt_LoadCachedHazardAim

    dec a
    ld [hl+], a
    ldh a, [hBugHazardAimAbsX]
    ld [hl+], a
    ldh a, [hBugHazardAimAbsY]
    ld [hl+], a
    ld [hl], c
    jr BugHunt_SelectHazardMotionDirection

BugHunt_LoadCachedHazardAim::
    inc hl
    ld a, [hl+]
    ldh [hBugHazardAimAbsX], a
    ld a, [hl+]
    ldh [hBugHazardAimAbsY], a
    ld c, [hl]

BugHunt_SelectHazardMotionDirection::
    pop hl
    ldh a, [hBugHazardAimAbsX]
    ld b, a
    ldh a, [hBugHazardAimAbsY]
    cp b
    jr c, BugHunt_SelectHorizontalHazardFacing

    ld b, $00
    bit 1, c
    jr nz, BugHunt_SelectHazardFlip

    ld b, $02
    jr BugHunt_SelectHazardFlip

BugHunt_SelectHorizontalHazardFacing::
    ld b, $01
    bit 0, c
    jr nz, BugHunt_SelectHazardFlip

    ld b, $03

BugHunt_SelectHazardFlip::
    ld a, b
    cp $01
    jr z, BugHunt_SelectHazardFrameAndStep

    xor a

BugHunt_SelectHazardFrameAndStep::
    ldh [hSpriteFlags], a
    pop de
    ld a, b
    rst $30
    ld a, [de]
    ldh [hBugHazardMetasprite], a
    ld d, $00
    ld e, d
    ld a, [hl]
    ld b, a
    ldh a, [hBugHazardAimAbsY]
    cp b
    jr c, BugHunt_StepHazardHorizontally

    ldh a, [hBugHazardAimAbsX]
    add b
    ld [hl], a
    ld e, $01
    bit 1, c
    jr z, BugHunt_ApplyHazardPositionDelta

    ld e, $ff
    jr BugHunt_ApplyHazardPositionDelta

BugHunt_StepHazardHorizontally::
    ldh a, [hBugHazardAimAbsY]
    ld b, a
    ld a, [hl]
    sub b
    ld [hl], a
    ld d, $01
    bit 0, c
    jr z, BugHunt_ApplyHazardPositionDelta

    ld d, $ff

BugHunt_ApplyHazardPositionDelta::
    dec hl
    ld a, [hl]
    add e
    ld b, a
    ld [hl-], a
    ld a, [hl]
    add d
    ld c, a
    ld [hl-], a
    push bc
    ld a, c
    add $08
    cp $f0
    jr nc, BugHunt_StartHazardRespawnTimer

    ld a, b
    add $08
    cp $f0
    jr c, BugHunt_TestHazardPlayerOverlap

BugHunt_StartHazardRespawnTimer::
    call AdvanceScreenRandomByte
    and $03
    add $03
    ld [hl+], a
    ld [hl-], a

BugHunt_TestHazardPlayerOverlap::
    pop bc
    push bc
    ld a, [wBugPlayerX]
    add $0e
    sub c
    cp $1c
    jr nc, BugHunt_SelectHazardWingFrame

    ld a, [wBugPlayerY]
    add $0e
    sub b
    cp $1c
    jr nc, BugHunt_SelectHazardWingFrame

    ld bc, $0004
    add hl, bc
    xor a
    ld [hl], a
    ld a, [wBugPhase]
    cp $02
    jr nc, BugHunt_SelectHazardWingFrame

    ld a, [wBugPlayerBlinkTimer]
    or a
    jr nz, BugHunt_SelectHazardWingFrame

    ld hl, SceneAnim_7967
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a
    ld a, $c0
    ld [wScreenFrameCounter], a
    ld a, $02
    ld [wBugPhase], a

BugHunt_SelectHazardWingFrame::
    pop bc
    ldh a, [hBugHazardMetasprite]
    ld d, a
    ld a, [wBugHazardFrameCounter]
    bit 3, a
    jr nz, BugHunt_DrawHazard

    inc d

BugHunt_DrawHazard::
    call DrawBank3MetaspriteFar
    ret


BugHunt_UpdateHazardRespawn::
    ld a, [wBugHazardSlotsEnd] ; The byte after both records is loaded into B and overwritten by the RNG call.
    ld b, a
    call ChooseScreenRandomThird
    add [hl]
    cp b
    jr z, BugHunt_WrapHazardSpawnIndex

    inc b

BugHunt_WrapHazardSpawnIndex::
    cp $0c
    jr c, BugHunt_TickHazardRespawnTimer

    sub $0c

BugHunt_TickHazardRespawnTimer::
    ld [hl], a
    ld a, [wMinigamePhaseCounter]
    cp $01
    ret nz

    dec hl
    dec [hl]
    ret nz

    xor a
    ld [hl+], a
    ld a, [hl]
    add a
    ld de, BugHuntHazardRespawnPositions
    rst $30
    ld a, [de]
    inc de
    ld [hl+], a
    ld a, [de]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld a, $80
    ld [hl+], a
    ret
