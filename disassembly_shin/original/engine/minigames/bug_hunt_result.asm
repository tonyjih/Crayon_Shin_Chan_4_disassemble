BugHunt_UpdateResult::
    ld a, [wScreenFrameCounter]
    cp $60
    jr nz, BugHunt_WaitForResultConfirm

    ld a, [wMinigameResultFlag]
    or a
    jr nz, BugHunt_WaitForResultConfirm

    ld hl, SceneAnim_794b
    ld a, [wMinigameRound]
    cp $0a
    jr nz, BugHunt_StartWinAnimation

    ld hl, SceneAnim_796e

BugHunt_StartWinAnimation::
    ld a, l
    ld [wSceneAnim0PtrLo], a
    ld a, h
    ld [wSceneAnim0PtrHi], a
    xor a
    ld [wSceneAnim0Timer], a

BugHunt_WaitForResultConfirm::
    ld a, [wMinigamePhaseCounter]
    inc a
    ld [wMinigamePhaseCounter], a
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    ld a, $01
    ld [wScreenFrameCounter], a
    ldh a, [hJoyHeld]
    bit 0, a
    ret z

    ld hl, wMinigameUnlockedRounds + 1
    jp AdvanceMinigameRoundOrExit


BugHunt_UpdateHitReaction::
    ld a, [wScreenFrameCounter]
    dec a
    ld [wScreenFrameCounter], a
    or a
    ret nz

    xor a
    ld [wBugPhase], a
    ld a, $c0
    ld [wBugPlayerBlinkTimer], a
    jp BugHunt_RestoreFacingAnimation
