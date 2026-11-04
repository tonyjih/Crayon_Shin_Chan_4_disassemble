; State-5 aliases only: other screens reuse this shared WRAM overlay.
DEF ENDING_ACTOR_COUNT       EQU 4
DEF ENDING_ACTOR_SIZE        EQU 2 ; X, animation-held result.
DEF ENDING_ACTOR_OFS_HELD    EQU 1
DEF ENDING_CUE_SIZE          EQU 24
DEF ENDING_CUE_OFS_ENTER_X   EQU 0
DEF ENDING_CUE_OFS_MOVE_X    EQU 1
DEF ENDING_CUE_OFS_EXIT_X    EQU 2
DEF ENDING_CUE_OFS_ANIMS1    EQU 4
DEF ENDING_CUE_OFS_ANIMS2    EQU 8
DEF ENDING_CUE_OFS_ANIMS3    EQU 12
DEF ENDING_CUE_OFS_ANIMS4    EQU 16
DEF ENDING_CUE_OFS_ANIMS5    EQU 20
DEF ENDING_PARTICLE_COUNT    EQU 8
DEF ENDING_PARTICLE_SIZE     EQU 3 ; X, Y, age.

DEF wEndingMode              EQU $d8f3 ; Low bit chooses the two ending presentations.
DEF wEndingActors            EQU $d8f4 ; Four X/held records, separate from the animation states at d800.
DEF wEndingCueIndex          EQU $d8fc
DEF wEndingCue               EQU $d8fd ; Copied 24-byte cue; byte +3 has no confirmed reader.
DEF wEndingParticles         EQU $d915 ; Eight X/Y/age records in the scrolling presentation.
DEF wEndingCreditMessageId   EQU $d939
DEF wEndingSceneDelay        EQU $d956 ; Main ending phase 6 counter.
DEF wEndingSecondaryOffset   EQU $d956 ; Alternate ending only: second actor's movement offset.
DEF wEndingExitDelay         EQU $d957 ; Alternate ending: post-message exit delay.

ASSERT wEndingActors + ENDING_ACTOR_COUNT * ENDING_ACTOR_SIZE == wEndingCueIndex
ASSERT wSceneAnim0PtrLo + SCENE_ANIM_STATE_SIZE == wSceneAnim1PtrLo
ASSERT wSceneAnim0PtrLo + ENDING_ACTOR_COUNT * SCENE_ANIM_STATE_SIZE == wStageDialogueScriptPtrLo
ASSERT wEndingCue + ENDING_CUE_SIZE == wEndingParticles
ASSERT ENDING_CUE_OFS_ANIMS5 + ENDING_ACTOR_COUNT == ENDING_CUE_SIZE
