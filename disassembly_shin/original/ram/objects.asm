; Stage object storage. BC is the record base in the object update helpers.
; Movement/animation names describe the common view; object states can reuse
; fields as timers or other work (for example, thrown-state delay at byte +2).
DEF OBJECT_SLOT_COUNT         EQU 32 ; Physical capacity, including the $ff list terminator record.
DEF OBJECT_OFS_TYPE_FLAGS     EQU $00 ; Low six bits = type; bit 7 = facing.
DEF OBJECT_OFS_STATE_FLAGS    EQU $01 ; Low state bits and type-specific flags.
DEF OBJECT_OFS_X_SUBPIXEL     EQU $02
DEF OBJECT_OFS_X_LO           EQU $03
DEF OBJECT_OFS_X_HI           EQU $04
DEF OBJECT_OFS_Y_SUBPIXEL     EQU $05
DEF OBJECT_OFS_Y_LO           EQU $06
DEF OBJECT_OFS_Y_HI           EQU $07
DEF OBJECT_OFS_SPEED_LO       EQU $08 ; Signed 8.8 step; axis depends on the active object state.
DEF OBJECT_OFS_SPEED_HI       EQU $09
DEF OBJECT_OFS_TYPE_WORK_A    EQU $0a ; Patrol turn reload, projectile age, or other type-specific work.
DEF OBJECT_OFS_ANIM_FRAME     EQU $0b
DEF OBJECT_OFS_ANIM_COUNTER   EQU $0c
DEF OBJECT_OFS_TIMER          EQU $0d
DEF OBJECT_OFS_TYPE_WORK_E    EQU $0e ; Type/state-specific flags and parameters; not fully decoded.
DEF OBJECT_OFS_SPAWN_INDEX    EQU $0f ; Index into wSpawnStateList for normal spawned objects.
DEF OBJECT_DIRECTION_MASK    EQU $80

ASSERT OBJECT_OFS_SPAWN_INDEX + 1 == OBJECT_SLOT_SIZE

SECTION "Stage object slots", WRAM0[$c180]
wObjectSlots::
    ds OBJECT_SLOT_COUNT * OBJECT_SLOT_SIZE
wObjectSlotsEnd::
ASSERT wObjectSlotsEnd == wSpawnCursor
