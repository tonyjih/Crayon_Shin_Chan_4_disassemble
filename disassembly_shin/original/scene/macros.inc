DEF SCENE_ANIM_HOLD          EQU $fe
DEF SCENE_ANIM_LOOP          EQU $ff
DEF SCENE_ANIM_DURATION_MASK EQU $7f
DEF SCENE_ANIM_FLIP          EQU $80
DEF SCENE_ANIM_STATE_SIZE    EQU 3
DEF NUM_SCENE_METASPRITES    EQU $f2

; Duration in frames, bank-3 metasprite ID, optional horizontal flip.
MACRO scene_frame
    ASSERT _NARG == 2 || _NARG == 3, "scene_frame expects duration, ID[, SCENE_ANIM_FLIP]"
    ASSERT 1 <= (\1) && (\1) <= SCENE_ANIM_DURATION_MASK, "Invalid scene frame duration"
    ASSERT 0 <= (\2) && (\2) < NUM_SCENE_METASPRITES, "Invalid scene metasprite ID"
    IF _NARG == 3
        ASSERT (\3) == SCENE_ANIM_FLIP, "Invalid scene facing flag"
        ASSERT (\1) < $7e, "Flipped duration collides with HOLD/LOOP"
        db (\1) | SCENE_ANIM_FLIP, \2
    ELSE
        db \1, \2
    ENDC
ENDM

MACRO scene_loop
    ASSERT _NARG == 1, "scene_loop expects a target"
    ASSERT BANK(\1) == BANK(@), "Scene loops must stay in the current ROM bank"
    db SCENE_ANIM_LOOP
    dw \1
ENDM

MACRO scene_hold
    ASSERT _NARG == 0, "scene_hold takes no arguments"
    db SCENE_ANIM_HOLD
ENDM
