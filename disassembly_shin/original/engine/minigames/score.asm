Minigame_AddScoreAndCompareGoal::
; B=tens and C=ones to add. HL points to goal tiles by round. Returns carry if the score is below the goal.
    push hl
    ld hl, wMinigameScoreOnes
    ld a, c
    add [hl]
    ld [hl-], a
    dec de
    ld a, b
    add [hl]
    ld [hl+], a
    ld a, [hl]
    cp $0e
    jr c, Minigame_CarryScoreTens

    sub $0a
    ld [hl-], a
    inc [hl]
    inc hl

Minigame_CarryScoreTens::
    dec hl
    ld a, [hl]
    cp $0e
    jr c, Minigame_SelectScoreHudDigits

    sub $0a
    ld [hl-], a
    inc [hl]

Minigame_SelectScoreHudDigits::
    ld de, wMinigameScoreHundreds
    ld hl, _SCRN0 + $221
    ld b, $03

Minigame_SkipLeadingScoreZeros::
    ld a, [de]
    cp $04
    jr nz, Minigame_DrawScoreAndLoadGoal

    inc hl
    inc de
    dec b
    jr nz, Minigame_SkipLeadingScoreZeros

Minigame_DrawScoreAndLoadGoal::
    ld c, $01
    call QueueTilemapRect
    ld a, [wMinigameRound]
    ld b, a
    add a
    add b
    pop hl
    rst $38
    ld de, wMinigameScoreHundreds
    ld b, $03

Minigame_CompareNextScoreDigit::
    ld a, [de]
    sub [hl]
    ret c

    jr nz, Minigame_ScoreAtLeastGoal

    inc de
    inc hl
    dec b
    jr nz, Minigame_CompareNextScoreDigit

Minigame_ScoreAtLeastGoal::
    or a
    ret
