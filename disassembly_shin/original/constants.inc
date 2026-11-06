; Shared original hardware, gameplay and screen constants.
; Aliases at the same address are intentional when work RAM has multiple owners.

DEF wScreenPaletteId EQU $d933
DEF wFadeTransitionTimer EQU $d95c
DEF wMsgSubstitutionId     EQU $d971

DEF wCgbEnabled EQU $dff7
DEF wSgbEnabled EQU $dff8
; Hardware / memory aliases identified during cleanup pass 1.
; Keep these conservative: names below are based on direct register usage in bank 0.
DEF hJoyHeld       EQU $ff8a
DEF hJoyPressed    EQU $ff8b
DEF hJoyLast       EQU $ff8c
DEF hVBlankBusy    EQU $ff8d
DEF hGameState     EQU $ff8e
DEF hNeedsReset    EQU $ff8f

DEF hSCY           EQU $ff90
DEF hSCYHigh       EQU $ff91
DEF hSCX           EQU $ff92
DEF hSCXHigh       EQU $ff93
DEF hWY            EQU $ff94
DEF hWX            EQU $ff95
DEF hCollisionFlag EQU $ff96

DEF hVramQueuePos  EQU $ff99
DEF hOamMaxY       EQU $ff9a
DEF hOamWritePos   EQU $ff9b
DEF hPrevOamPos    EQU $ff9c
DEF hSpriteFlags   EQU $ff9d
DEF hStageIndex    EQU $ff9f ; Current gameplay stage/area index used by bank 1 stage tables.

; Gameplay aliases identified during cleanup pass 3.
; These are based on direct use in bank 1 gameplay update/player/object code.
DEF hPlayerScreenY      EQU $ffa4
DEF hPlayerScreenX      EQU $ffa5
DEF hPlayerAnimId       EQU $ffa6
DEF hPlayerAnimCounter  EQU $ffa7
DEF hPlayerAnimFrame    EQU $ffa8
DEF hPlayerObjectFlags  EQU $ffa9
DEF hPlayerState        EQU $ffaa
DEF hPrevPlayerState    EQU $ffab
DEF hPlayerDirection    EQU $ffac ; direction/facing, 0=right-ish, $ff=left-ish.
DEF hPlayerYSubpixel    EQU $ffad
DEF hPlayerY            EQU $ffae
DEF hPlayerYHigh        EQU $ffaf
DEF hPlayerXSubpixel    EQU $ffb0
DEF hPlayerX            EQU $ffb1
DEF hPlayerXHigh        EQU $ffb2
DEF hPlayerVelYLo       EQU $ffb3
DEF hPlayerVelY         EQU $ffb3 ; Compatibility alias.
DEF hPlayerVelYHi       EQU $ffb4
DEF hPlayerVelYHigh     EQU $ffb4 ; Compatibility alias.
DEF hPlayerMoveSpeedLo  EQU $ffb5
DEF hPlayerSpeedX       EQU $ffb5 ; Compatibility alias.
DEF hPlayerMoveSpeedHi  EQU $ffb6
DEF hPlayerSpeedXHigh   EQU $ffb6 ; Compatibility alias.
DEF hPlayerGravity      EQU $ffb7
DEF hBonusCounter       EQU $ffb8 ; reaches 30, then awards an extra life.
DEF hPlayerHealth       EQU $ffb9 ; max 3; decremented by damage.
DEF hPlayerLives        EQU $ffba
DEF hPlayerForm         EQU $ffbb
DEF hPlayerActionLock   EQU $ffbc
DEF hPlayerAnimTimer    EQU $ffbd ; Compatibility alias.
DEF hPlayerFlags        EQU $ffbe
DEF hPlayerTileEffect   EQU $ffbf
DEF hPlayerJumpProfile   EQU $ffc2

; Player form constants identified from gameplay testing.
DEF PLAYER_FORM_NORMAL          EQU $00 ; 普通小新
DEF PLAYER_FORM_FLYING_SQUIRREL EQU $01 ; 飛鼠小新
DEF PLAYER_FORM_COCKROACH       EQU $02 ; 蟑螂小新
DEF PLAYER_FORM_CHICKEN         EQU $03 ; 母雞小新
DEF PLAYER_FORM_ACTION_KAMEN    EQU $04 ; 動感超人

; Player jump profile constants. These index the jump velocity table in StartPlayerJump.
DEF PLAYER_JUMP_PROFILE_NORMAL  EQU $03
DEF PLAYER_JUMP_PROFILE_CHICKEN EQU $04

; Player collision height offsets. Cockroach Shin-chan uses a shorter vertical hitbox.
DEF PLAYER_COLLISION_HEIGHT_NORMAL    EQU $16
DEF PLAYER_COLLISION_HEIGHT_COCKROACH EQU $0f

DEF wOamBuffer     EQU $c000
DEF wVramQueue     EQU $c100
DEF wLCDCShadow    EQU $c0a2
DEF wPaletteBGP    EQU $c0a3
DEF wPaletteOBP0   EQU $c0a4
DEF wPaletteOBP1   EQU $c0a5

; wObjectSlots is allocated at $c180 by ram/objects.asm.
DEF wSpawnCursor        EQU $c380
DEF wSpawnStateList     EQU $c381
DEF wPendingVramUpdates EQU $c402

; Camera / stage runtime parameters. Stage init code seeds these, and
; UpdateCameraAndStreamMap consumes them every frame.
DEF wCameraScreenLeftThreshold   EQU $c408 ; Player screen X must stay >= this before camera scrolls left.
DEF wCameraScreenRightThreshold  EQU $c409 ; Player screen X must stay < this before camera scrolls right.
DEF wCameraScreenTopThreshold    EQU $c40a ; Player screen Y must stay >= this before camera scrolls up.
DEF wCameraScreenBottomThreshold EQU $c40b ; Player screen Y must stay < this before camera scrolls down.
DEF wCameraScrollStepX           EQU $c40c ; Max camera X scroll step per frame.
DEF wCameraScrollStepY           EQU $c40d ; Max camera Y scroll step per frame.
DEF wCameraScrollXMinLo          EQU $c40e
DEF wCameraScrollXMinHi          EQU $c40f
DEF wPlayerXMinLo                EQU $c410
DEF wPlayerXMinHi                EQU $c411
DEF wPlayerXMaxLo                EQU $c414
DEF wPlayerXMaxHi                EQU $c415
DEF wPlayerYFallThresholdLo      EQU $c416 ; Player/world Y threshold used by stage death-fall logic.
DEF wPlayerYFallThresholdHi      EQU $c417
DEF wCameraScrollXMaxLo          EQU $c418
DEF wCameraScrollXMaxHi          EQU $c419
DEF wCameraScrollYMaxLo          EQU $c41a
DEF wCameraScrollYMaxHi          EQU $c41b

; Scroll-streaming scratch in HRAM. These remember the last streamed tile row/column.
DEF hStreamedColumnX             EQU $ff97
DEF hStreamedRowY                EQU $ff98
DEF hTileStreamWritePos          EQU $ffc9
DEF hTileStreamCount             EQU $ffcb

; Stage layout/map runtime buffers.
DEF wStageTileAttrTable       EQU $c700 ; 256-byte tile/metatile collision/attribute lookup.
DEF wStageLayoutMap           EQU $c800 ; Decompressed stage metatile layout pages.
DEF wStageLayoutPageHighTable EQU $c41c ; Page high-byte table used by world->layout lookup.

; Stage metatile graphics table pointer in HRAM. Each metatile id maps to 4 BG tile bytes.
DEF hStageMetatileTableLo EQU $ffa2
DEF hStageMetatileTableHi EQU $ffa3

; Object system constants. Object type is stored in slot byte +0, masked by OBJECT_TYPE_MASK.
DEF OBJECT_SLOT_SIZE  EQU $10
DEF SPAWN_RECORD_SIZE EQU $05
DEF OBJECT_TYPE_MASK  EQU $3f
DEF OBJECT_LIST_END   EQU $ff
DEF OBJECT_SLOT_EMPTY EQU $00
DEF SPAWN_STATE_READY   EQU $01
DEF SPAWN_STATE_BLOCKED EQU $02
DEF SPAWN_LIST_END      EQU $ff


; Object type constants. Object type is stored in slot byte +0, masked by OBJECT_TYPE_MASK.
DEF OBJ_NONE                       EQU $00

; Boss actors. These are spawned by the boss-intro flow, not by the normal stage spawn list.
DEF OBJ_STAGE0_BOSS                EQU $01 ; たけし: kid who steals Shin-chan's Chocobi.
DEF OBJ_STAGE1_BOSS                EQU $02 ; 河村: Rose Class student; fast runner and high jumper.
DEF OBJ_STAGE2_BOSS                EQU $03 ; Kangaroo-man boss; throws small balls.
DEF OBJ_STAGE3_BOSS                EQU $04 ; Heavy man boss; climbs tree, drops coconuts, then ground-pounds.
DEF OBJ_STAGE0_BOSS_PROJECTILE     EQU $05 ; Stage 0 boss hat projectile; flies forward, then drifts diagonally upward.

; Confirmed stage interactables / hazards.
DEF OBJ_BOUNCING_BALL              EQU $06 ; Stage 2: bouncing ball, hurts on contact, stompable.
DEF OBJ_ACTION_KAMEN_HANGING_DOLL  EQU $07 ; Stage 2: hanging Action Kamen doll that Shin-chan can grab/ride.
DEF OBJ_FLOATING_BEACH_BALL        EQU $08 ; Stage 3: beach ball floating on water; sinks while stood on.
DEF OBJ_PLATFORM_DROP_A_VARIANT    EQU $09 ; Shares UpdateObjDropPlatformA behavior; visual role pending.

; Enemies / projectiles.
DEF OBJ_ENEMY_WALKING_KID          EQU $0a
DEF OBJ_ENEMY_PARTY_HORN_KID       EQU $0b
DEF OBJ_ENEMY_UMBRELLA_KID         EQU $0c
DEF OBJ_ENEMY_PAPER_AIRPLANE_KID   EQU $0d
DEF OBJ_ENEMY_PAPER_AIRPLANE       EQU $0e
DEF OBJ_ENEMY_TOUGH_KID            EQU $0f ; Heavy kid enemy with higher HP.

; Pickups.
DEF OBJ_PICKUP_CHOCOBI             EQU $10 ; Chocobi; 30 awards an extra life.
DEF OBJ_PICKUP_HIDDEN_CHOCOBI      EQU $11 ; Hidden Chocobi; appears/effects after being collected.
DEF OBJ_PICKUP_EXTRA_LIFE          EQU $12
DEF OBJ_PICKUP_HIDDEN_EXTRA_LIFE     EQU $13 ; Hidden extra-life pickup; appears/effects after collection.
DEF OBJ_PICKUP_HEALTH              EQU $14 ; Adds hPlayerHealth, max 3.
DEF OBJ_PICKUP_HIDDEN_HEALTH         EQU $15 ; Hidden health pickup; appears/effects after collection.

; Form items.
DEF OBJ_FORM_FLYING_SQUIRREL       EQU $16
DEF OBJ_FORM_COCKROACH             EQU $17
DEF OBJ_FORM_CHICKEN               EQU $18
DEF OBJ_FORM_ACTION_KAMEN          EQU $19

; Platforms / stage hazards.
DEF OBJ_PLATFORM_MOVING_VERTICAL_A EQU $1a
DEF OBJ_PLATFORM_MOVING_VERTICAL_B EQU $1b
DEF OBJ_PLATFORM_DROP_A            EQU $1c
DEF OBJ_PLATFORM_BOUNCE_PAD        EQU $1d
DEF OBJ_PLATFORM_DROP_B            EQU $1e
DEF OBJ_STAGE2_FALLING_PRODUCT     EQU $1f ; Stage 2: loose shelf product that falls when approached.
DEF OBJ_STAGE2_SOCCER_BALL         EQU $20 ; Stage 2: rolling soccer ball; stomp gives a higher bounce.
DEF OBJ_STAGE2_BOSS_PROJECTILE     EQU $21 ; Stage 2 boss small-ball projectile.
DEF OBJ_STAGE2_SHOPPING_CART       EQU $22 ; Stage 2: shopping cart platform; starts moving when stood on.
DEF OBJ_STAGE3_FALLING_COCONUT     EQU $23 ; Stage 3: coconut that shakes, then falls when approached.
DEF OBJ_STAGE3_BOSS_PROJECTILE     EQU $24 ; Stage 3 boss coconut projectile/dropped hazard.

; Player form/action work variables.
DEF wSavedPlayerState     EQU $c0ac
DEF wFormActionStep       EQU $c0ad
DEF wFormActionTimer      EQU $c0ae
DEF wPlayerActionMeter     EQU $c0af
DEF wFormActionTemp       EQU $c0af ; Compatibility alias.
DEF wStoredPlayerForm     EQU $c0be
DEF wPlayerSpecialActor0  EQU $c0bf
DEF wPlayerSpecialActor1  EQU $c0cb
DEF wFormTimerLo          EQU $c0a6
DEF wFormTimerHi          EQU $c0a7

; Player action/projectile hitboxes in screen coordinates.
DEF wPlayerActionHitbox0X EQU $c0c7
DEF wPlayerActionHitbox0Y EQU $c0c8
DEF wPlayerActionHitbox1X EQU $c0d3
DEF wPlayerActionHitbox1Y EQU $c0d4
DEF hActionHitboxHalfWidth  EQU $ffd1
DEF hActionHitboxHalfHeight EQU $ffd2

; Player special actor/projectile constants. These are stored at wPlayerSpecialActor* + 0.
DEF SPECIAL_ACTOR_NONE                       EQU $00
DEF SPECIAL_ACTOR_FLYING_SQUIRREL_PROJECTILE EQU $01
DEF SPECIAL_ACTOR_CHICKEN_PROJECTILE         EQU $02
DEF SPECIAL_ACTOR_ACTION_KAMEN_PROJECTILE    EQU $03

; Runtime camera/stage-transition work RAM aliases used by this bank.
DEF wCameraDeadzoneLeft       EQU $c408
DEF wCameraDeadzoneRight      EQU $c409
DEF wCameraDeadzoneTop        EQU $c40a
DEF wCameraDeadzoneBottom     EQU $c40b
DEF wCameraMaxStepX           EQU $c40c
DEF wCameraMaxStepY           EQU $c40d

; These $c0b* slots are shared by several stage systems: Stage 1 camera profiles,
; Stage 2 transitions, and the boss intro/clear flow.
DEF wStageInteractionSubstate EQU $c0b1
DEF wStageInteractionCounter  EQU $c0b2
DEF wStage2TransitionStep     EQU $c0b3
DEF wStage1CameraProfileIndex EQU $c0b4
DEF wStageBossCountdown      EQU $c0b5
DEF wStageBossStateFlag      EQU $c0b6
DEF STAGE_BOSS_STATE_INACTIVE EQU $00
DEF STAGE_BOSS_STATE_ACTIVE   EQU $01 ; countdown/tile-load/boss-active phase; disables fall death boundary
DEF STAGE_BOSS_STATE_CLEAR    EQU $ff ; boss defeated / stage-clear phase; disables right clamp and child collisions
DEF wStage1ResumeProfileFlag  EQU $c0bc

DEF PlayerState_NormalGround          EQU $00
DEF PlayerState_Duck                  EQU $01
DEF PlayerState_JumpFall              EQU $02
DEF PlayerState_GroundedSnap          EQU $03
DEF PlayerState_GroundedActionCheck   EQU $04; grounded/action check state
DEF PlayerState_ClimbOrVerticalMove   EQU $05; climb/vertical move state
DEF PlayerState_HurtKnockback         EQU $06
DEF PlayerState_FlyingSquirrelAction  EQU $07
DEF PlayerState_ChickenAction         EQU $08
DEF PlayerState_ActionKamenAction     EQU $09
DEF PlayerState_DamageBounce          EQU $0a; damage bounce state
DEF PlayerState_DeathFall             EQU $0b
DEF PlayerState_StageTransition0C     EQU $0c; scripted stage transition state
DEF PlayerState_StageInteraction0D    EQU $0d; special/stage interaction state

; Fixed bank id and FarCallFromBankTable entry table.
; ROMX:$4000 must remain the bank id byte; ROMX:$4001 is indexed by bank 0
; FARCALL_BANK1_* constants. Insertions for Bank 1 shift tests should be after
; this table unless the far-call mechanism is also updated.

; Bank 2 password/menu work variables identified during password cleanup.
; Keep these guarded so the names can later move to the global WRAM alias block.
IF !DEF(wPasswordInputTopRow)
DEF wPasswordInputTopRow    EQU $d940 ; 10 bytes: modifiers/diacritics for password entry.
DEF wPasswordInputBottomRow EQU $d94a ; 10 bytes: base kana tile IDs for password entry.
DEF wPasswordCursorCol      EQU $d93a
DEF wPasswordInputIndex     EQU $d93b
DEF wPasswordCursorRow      EQU $d93c
DEF wPasswordErrorFlag      EQU $d958
DEF wPasswordMatchIndex     EQU $d959
DEF wPasswordRepeatHeld     EQU $d95a
DEF wPasswordRepeatTimer    EQU $d95b
DEF wStateChangeParamLo     EQU $d95e
DEF wStateChangeParamHi     EQU $d95f
ENDC

; Additional aliases verified from the original readers and writers.
DEF rRomBankSelect                   EQU $2100 ; MBC1 low ROM bank latch; this cartridge writes the mirrored address $2100.
DEF ROM_BANK_ID_ADDR                 EQU $4000 ; Read-only bank-id byte at the start of the selected ROMX bank.
DEF wStackTop                        EQU $dff0 ; Initial descending stack pointer.
DEF hRandomByte                      EQU $ff9e ; Byte advanced once per game update by the 5*x+$11 generator.
DEF wInterruptEnableShadow           EQU $c0a0 ; Copied into IE by EnableInterruptsFromShadow.
DEF wStageCheckpointActive           EQU $c0a8 ; Nonzero selects checkpoint/resume layout and player initialization.
DEF wGameplayInitSubstate            EQU $c0a9 ; Gameplay initialization selector; also set by death and DEBUG resume.
DEF wFadeReturnPhase                 EQU $c0bd ; Two-phase transition used while returning to gameplay.
DEF wDebugStageSelection             EQU $c0d7 ; DEBUG stage index, including alternate-mode bit 2.
DEF wDebugCursorRow                  EQU $c0d8 ; DEBUG menu row 0-6.
DEF wDebugMusicIndex                 EQU $c0d9 ; Index into DebugMenuMusicIdTable, not a raw sound ID.
DEF wDebugSoundIndex                 EQU $c0da ; Index into DebugMenuSoundDispatchTable.
DEF wScreenSubstate                  EQU $d93d ; Shared per-screen dispatch selector; meaning depends on hGameState.
DEF wScreenFrameCounter              EQU $d954 ; Shared primary frame counter; reset when screen phases change.
DEF wScreenPhaseCounter              EQU $d955 ; Shared secondary animation/delay counter.
DEF wSceneAnim0PtrLo                 EQU $d800 ; First scene animation state: script pointer low.
DEF wSceneAnim0PtrHi                 EQU $d801 ; First scene animation script pointer high.
DEF wSceneAnim0Timer                 EQU $d802 ; First animation duration; bit 7 selects facing.
DEF wSceneAnim1PtrLo                 EQU $d803 ; Second scene animation state: script pointer low.
DEF wSceneAnim1PtrHi                 EQU $d804 ; Second scene animation script pointer high.
DEF wSceneAnim1Timer                 EQU $d805 ; Second animation duration; bit 7 selects facing.
DEF wMessageSourceLo                 EQU $d969 ; Message byte-stream cursor low.
DEF wMessageSourceHi                 EQU $d96a ; Message byte-stream cursor high.
DEF wMessageDestLo                   EQU $d96b ; Current tilemap line destination low.
DEF wMessageDestHi                   EQU $d96c ; Current tilemap line destination high.
DEF wMessageState                    EQU $d96d ; 0=idle, 1=active, 2=last line pending.
DEF wMessageDakutenTile              EQU $d96e ; Tile used for dakuten marks on this line.
DEF wMessageHandakutenTile           EQU $d96f ; Tile used for handakuten marks on this line.
DEF wMessageFlags                    EQU $d970 ; Bit 0=typewriter, bit 1=buffered/blocking mode, bit 2=blank glyphs, bit 3=mute typing.
DEF wMessageControlPtrLo             EQU $d972 ; FC control code destination pointer low.
DEF wMessageControlPtrHi             EQU $d973 ; FC control code destination pointer high.
DEF wMessageControlValue             EQU $d974 ; Byte written by the FC message control code.
DEF wMessagePrintedGlyphs            EQU $d97f ; Base glyphs already emitted from the current line.
DEF wMessageLineGlyphs               EQU $d980 ; Base glyph count of the current line.
DEF wMessageCharPeriod               EQU $d981 ; Reload value for typewriter character delay.
DEF wMessageCharDelay                EQU $d982 ; Current typewriter delay countdown.
DEF wTitleSavedMainCursor            EQU $d983 ; Last selection in the title main menu.
DEF wTitleSavedMinigameCursor        EQU $d984 ; Last selection in the title minigame menu.
DEF wSgbPalSetPacket                 EQU $d985 ; 16-byte PAL_SET command assembled from the screen profile.
DEF wSgbBorderColorMode              EQU $dffc ; 0=default, 1=alternate flag, 2=special flag; selects SGB border color tables.
DEF wSpecialModeFlags                EQU $dffd ; Persistent special-mode flag; takes precedence in the border palette selector.
DEF wAlternateModeFlags              EQU $dffe ; Persistent alternate-stage/mode flags; DEBUG uses bit 2.
DEF hObjectScreenX                   EQU $ffd3 ; Current object screen X, produced from its world X.
DEF hObjectScreenY                   EQU $ffd4 ; Current object screen Y, produced from its world Y.
DEF hObjectOffscreen                 EQU $ffd5 ; Nonzero when the current object fails the viewport checks.
DEF hObjectAnimId                    EQU $ffd6 ; Current stage-object metasprite ID.
DEF hSgbColorScale                   EQU $ffc9 ; SGB color conversion scratch; shares the generic tile-stream parameter byte.
DEF wSoundSlots                      EQU $dd00 ; Six 25-byte virtual channel records.
DEF wSoundUpdatedChannels            EQU $dd96 ; Hardware channels already claimed this audio tick.
DEF wSoundPanShadow                  EQU $dd97 ; Mixed NR51 left/right output shadow.
DEF wSoundHardwareChannel            EQU $dd98 ; Current hardware channel 0-3.
DEF wSoundChannelMask                EQU $dd99 ; Current hardware channel LR mask: $11/$22/$44/$88.
DEF wSoundPanClearMask               EQU $dd9a ; LR mask replaced by the current virtual channel.
DEF wSoundRegisterOffset             EQU $dd9b ; 5 * hardware-channel index, added to NR1x register offsets.
DEF wSoundFrameCounter               EQU $dd9c ; Free-running frame phase used by vibrato.
DEF wSoundVirtualSlotIndex           EQU $dd9d ; Current virtual slot index 0-5.
DEF wSoundLastQueuedId               EQU $dd9e ; Saved queued ID; PlaySound returns the next ID in A.
DEF wSoundPriorityFlags              EQU $dd9f ; Bit 7 controls how virtual music and effect slots arbitrate.
DEF hSoundCursorLo                   EQU $ffe6 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundChannelFlags               EQU $ffe7 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundTrackPtrLo                 EQU $ffe8 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundTrackPtrHi                 EQU $ffe9 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundTempoDuty                  EQU $ffea ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundTempoCounter               EQU $ffeb ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundVolume                     EQU $ffec ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundNoteDuration               EQU $ffed ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundPitchOffset                EQU $ffee ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundRepeatCounter0             EQU $ffef ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundRepeatCounter1             EQU $fff0 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundEnvelopeId                 EQU $fff1 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundEnvelopeRate               EQU $fff2 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundEnvelopeFrame              EQU $fff3 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundVolumeSlideDelta           EQU $fff4 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundVolumeSlidePeriod          EQU $fff5 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundVolumeSlideCounter         EQU $fff6 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundFrequencyLo                EQU $fff7 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundFrequencyHi                EQU $fff8 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundLoopCursorLo               EQU $fff9 ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundPan                        EQU $fffa ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundVibratoDelay               EQU $fffb ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundVibratoCounter             EQU $fffc ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundCursorHi                   EQU $fffd ; Current sound-slot scratch; copied from/to wSoundSlots each tick.
DEF hSoundLoopCursorHi               EQU $fffe ; Current sound-slot scratch; copied from/to wSoundSlots each tick.

DEF HITBOX_STAGE1_BOSS EQU ($07 << 8) | $10 ; D=object half-width, E=half-height; not a pointer to StartMessageFar.

; Shared title, minigame, boss and ending work identified from all readers/writers.
DEF wMinigameRound                   EQU $d811 ; Round number, 1-10.
DEF wMinigamePhaseCounter            EQU $d852 ; Shared pre-round countdown, running timer tick, and result-animation counter; ownership depends on substate.
DEF wMinigameTimerHundreds           EQU $d853 ; Decimal countdown hundreds digit during a round.
DEF wMinigameTimerTens               EQU $d854 ; Decimal countdown tens digit during a round.
DEF wMinigameTimerOnes               EQU $d855 ; Decimal countdown ones digit during a round.
DEF wEndingDemoJoyHeld               EQU $d92d ; Held input from the ending demo script.
DEF wEndingDemoInputTimer            EQU $d92e ; Decrement to $ff before reading the next input/duration pair.
DEF wEndingDemoInputPtrLo            EQU $d92f ; Next ending demo input pair, low byte.
DEF wEndingDemoInputPtrHi            EQU $d930 ; Next ending demo input pair, high byte.
DEF wBossHitFlashTimer               EQU $d931 ; Boss invulnerability/blink countdown; set to $84 after a hit, bit 3 hides the sprite.
DEF wMinigamePaused                  EQU $d932 ; Nonzero freezes the minigame update and reuses the previous OAM list.
DEF wTitleMenuPhase                  EQU $d934 ; 0=press start, 1=main choices, 2=minigame choices.
DEF wMinigameMode                    EQU $d93e ; State 3 selector: 0=bonus stage, 1-3=selectable minigames.
DEF wMinigameResultFlag              EQU $d95d ; Phase-dependent result flag; nonzero prevents normal round advancement.
DEF wScreenRandomByte                EQU $d978 ; Screen/minigame PRNG state; ror(previous) + DIV.
DEF wStageSceneIndex                 EQU $d979 ; Stage transition/dialogue index: 2 * stage + intro/clear variant.
DEF wContinuesRemaining              EQU $d97a ; Initialized to 3 at the title screen; decremented on accepting CONTINUE.
DEF wMinigameUnlockedRounds          EQU $dff9 ; Three bytes, highest unlocked round for each selectable minigame.
DEF wMenuCursorRow                  EQU $d93c ; Title and scene-test cursor; password and minigame states reuse this byte.

; Scoped scratch aliases: never substitute these across unrelated owners.
DEF hVramRectDestLo       EQU $ffc5 ; QueueTilemapRect destination cursor low.
DEF hVramRectDestHi       EQU $ffc6 ; QueueTilemapRect destination cursor high.
DEF hSceneAnimHeld        EQU $ffce ; AnimateSceneMetasprite returns 1 at a HOLD command.
DEF hDecimalTens          EQU $ffca ; SplitDecimalTensOnes result; units use hTileStreamWritePos.
DEF hMessageResumePtrLo   EQU $ffcb ; Source pointer saved while expanding an FD substitution.
DEF hMessageResumePtrHi   EQU $ffcc ; Zero when no message substitution is active.
DEF wSgbBorderTilemapBuffer EQU $c800 ; Shared stage-layout work buffer during SGB initialization.
DEF wSgbBorderPaletteBuffer EQU $d000 ; Follows the 2048-byte SNES border tilemap.

; Bank-1 player-state / tile-contact work (HRAM is reused by other screen engines).
DEF hPlayerTileCollisionFlag       EQU $ffc0 ; $ff when a side/ground probe blocks movement.
DEF hPlayerStatePhase              EQU $ffc1 ; Current player-state phase; moving/idle and action phase meanings depend on hPlayerState.
DEF hPlayerDeathCollisionDisabled  EQU $ffc3 ; $ff during death fall, suppressing pickup/platform interaction.
DEF hPlayerPlatformAttached        EQU $ffc4 ; Set each frame by a supporting platform; prevents ordinary falling.
DEF hPlayerTileProbeCount          EQU $ffcd ; Tile-contact handler count; reused as an object collision threshold outside tile probing.
DEF wPlayerTileAligned             EQU $c0aa ; Set by foot contact handlers that already snapped Y to a metatile edge.
DEF wPlayerForcedJumpFlags         EQU $c0b0 ; Nonzero suppresses A-release jump-height control; bit 7 also latches glide descent.
DEF wPlayerNormalSpeedLo           EQU $d996 ; Saved default horizontal 8.8 speed restored after losing a form.
DEF wPlayerNormalSpeedHi           EQU $d997
DEF wUnconfirmedStageInitWordLo                  EQU $c412 ; Initialized to $0004 with stage limits; no confirmed consumer. Keep its purpose unassigned.
DEF wUnconfirmedStageInitWordHi                  EQU $c413

DEF hPlayerObjectProbeRangeX EQU $ffcb ; Exclusive horizontal-distance threshold for the selected five-byte body probe.
DEF hPlayerObjectProbeAbove  EQU $ffcc ; Exclusive distance threshold when object Y is above player Y.
DEF hPlayerObjectProbeBelow  EQU $ffcd ; Exclusive distance threshold when object Y is below player Y.

; Additional confirmed runtime fields and coarse bases for shared/unclassified work.
DEF wPlayerHurtBlinkTimer              EQU $c0ab ; Decremented by DrawPlayerSprite; bit 3 controls hurt/form-change blinking.
DEF wPlayerSpecialActor0Timer          EQU $c0c9 ; Special actor 0 byte +$0a; projectile age / animation timer according to actor type.
DEF wPendingMetatile05DestLo           EQU $c404 ; Deferred 2x2 metatile-$05 replacement VRAM destination low.
DEF wPendingMetatile05DestHi           EQU $c405 ; Deferred metatile-$05 replacement VRAM destination high.
DEF wPendingClearedMetatileDestLo      EQU $c406 ; Deferred Stage 1 cleared-metatile VRAM destination low.
DEF wPendingClearedMetatileDestHi      EQU $c407 ; Deferred cleared-metatile VRAM destination high.
DEF wStage3BossSavedScrollYLo          EQU $c464 ; Saved SCY before the Stage 3 boss camera-shake sequence.
DEF wStage3BossSavedScrollYHi          EQU $c465 ; Saved SCY high byte, restored when the boss attack finishes.
DEF wActionKamenMoveSpeedLo            EQU $d998 ; Saved Action Kamen 8.8 move speed: $0140 normally, $0200 in special mode.
DEF wActionKamenMoveSpeedHi            EQU $d999 ; High byte of the saved Action Kamen horizontal move speed.
DEF wStage1ClearedMetatileTiles        EQU $da00 ; Four tile IDs used after clearing a Stage 1 metatile; overlaps the stage-layout work area.
DEF wSequentialTilemapBuffer           EQU $da80 ; 16-byte scratch for the unused sequential 4x4 tilemap helper.
DEF wMessageLineBuffer         EQU $c820 ; Temporary base-glyph line inside the shared map buffer.
; These bases give unresolved fields a bank-independent symbol without claiming their individual meanings.
; See notes/unresolved_memory.csv for the remaining field/consumer pairs.
DEF wRuntimeWork               EQU $c0a0 ; Main-loop/player/stage shared runtime area.
DEF wGameplayWork              EQU $c400 ; Gameplay queue, camera, and stage scratch area.
DEF wSharedWork                EQU $d800 ; Shared screen/minigame/ending/player work overlay.
DEF hSharedScratch             EQU $ffc0 ; Shared temporary HRAM bytes; interpretation depends on the caller.

; State-4 stage dialogue overlay; minigame states give the same bytes other meanings.
DEF wStageDialogueScriptPtrLo EQU $d80c
DEF wStageDialogueScriptPtrHi EQU $d80d
DEF wStageDialogueAnimSelectors EQU $d80e ; Three animation selectors, one per dialogue actor slot.

; State-4 continue and dialogue overlays. Other screens reuse these addresses.
DEF wContinueActorX                   EQU $d93a
DEF wContinueFacingCache              EQU $d93b ; Idle phase compares bit 7 with the current animation facing.
DEF wContinueActorXSubpixel           EQU $d93b ; Once moving, the same byte is the fractional X accumulator.
DEF wContinueChoice                   EQU $d93c ; Bit 0 selects the continue or exit row.
DEF wContinuePhase                    EQU $d93f ; Choice, accepted motion, or exit motion.
DEF wContinueGameOverDelay            EQU $d956 ; Starts the exit animation when no continues remain.
DEF wContinueAcceptedVelocityLo      EQU $d967 ; Signed 8.8 X velocity, adjusted by the motion script.
DEF wContinueAcceptedVelocityHi      EQU $d968
DEF wContinueExitActorX               EQU $d97b
DEF wContinueExitActorXSubpixel       EQU $d97c
DEF wContinueMotionPtrLo              EQU $d97d ; Pointer to the active velocity delta byte.
DEF wContinueMotionPtrHi              EQU $d97e
DEF wStageDialogueAdvanceStep         EQU $d93c ; Nonzero while erasing text rows before the next message.
DEF wStageDialogueHighlightApplied    EQU $d956 ; SGB scene patch has been applied once.
DEF hStageDialogueSpeakerMask         EQU $ffca ; Speaker marker bits also index the SGB attribute data.

; Title, scene-test, and bonus overlays. These aliases describe only these consumers.
DEF hMenuCursorOptionCount   EQU $ffc9
DEF hMenuCursorDestLo        EQU $ffca
DEF hMenuCursorDestHi        EQU $ffcb
DEF hMinigameTimerTiles      EQU $ffc9 ; Three digit tiles assembled for the countdown HUD.
DEF wSceneTestValues         EQU $d940 ; Dialogue, scene, ending, and bonus health test values.
DEF wSceneTestLastEditedValue EQU $d93a ; Copy of the displayed value. No scene-test reader confirmed.
DEF wBonusActorX             EQU $d93a
DEF wBonusDestination        EQU $d93b ; Station selector, also passed to the instruction/hint screen.
DEF wBonusBlinkCounter       EQU $d93c ; Border sprite offsets or instruction advance marker.
DEF wBonusRewardChoiceDelay  EQU $d956
DEF wBonusReturnRequest      EQU $d960 ; Saved request type, compared with the scene-test return selector.
DEF wBonusMinigameRounds     EQU $d961 ; Three per-station round numbers for bonus play.
DEF wBonusInstructionPending EQU $d964 ; Three flags cleared the first time each instruction is shown.
DEF wBonusWalkDeltaX         EQU $d967 ; Signed pixels per update, +1 or -1.

; Slide jump (minigame 3). Positions are three-byte fixed point and velocities are signed 8.8.
DEF wSlideCameraXLo          EQU $d812 ; Integer world X, clamped to 0 through $300.
DEF wSlideCameraXHi          EQU $d813
DEF wSlideCameraY            EQU $d814 ; Integer world Y, clamped to 0 through $70.
DEF wSlideVelocityXLo       EQU $d815
DEF wSlideVelocityXHi       EQU $d816
DEF wSlideVelocityYLo       EQU $d817
DEF wSlideVelocityYHi       EQU $d818
DEF wSlideResultDelay       EQU $d819
DEF wSlidePlatformPtrLo     EQU $d81a ; Current collision platform record in the round's list.
DEF wSlidePlatformPtrHi     EQU $d81b
DEF wSlideReuseLayout       EQU $d81c ; A screen reload reuses the previously expanded layout and tiles.
DEF wSlidePlayerControl     EQU $d81d ; Zero runs the demo, one enables player input.
DEF wSlideWorldXSubpixel     EQU $d81e
DEF wSlideWorldXLo          EQU $d81f
DEF wSlideWorldXHi          EQU $d820
DEF wSlideWorldYSubpixel     EQU $d821
DEF wSlideWorldYLo          EQU $d822
DEF wSlideWorldYHi          EQU $d823
DEF wSlideEffectActive      EQU $d824 ; Animation slot 1 is active at the ramp or bounce point.
DEF wSlideEffectXLo         EQU $d825
DEF wSlideEffectXHi         EQU $d826
DEF wSlideEffectY           EQU $d827
DEF wSlideLandingFrame      EQU $d956 ; Selects the alternating ground arrival metasprite.
DEF wSlideActorScreenX      EQU $d97b ; Saved projected X for the result animation.
DEF hSlidePlatformDrawPtrLo EQU $ffca ; Backtracked record used to highlight a platform during bounce.
DEF hSlidePlatformDrawPtrHi EQU $ffcb

; Mekemeke (minigame 1). Four enemy records in lane order.
DEF MEKEMEKE_ENEMY_COUNT       EQU 4
DEF MEKEMEKE_ENEMY_SIZE        EQU 8
DEF MEKEMEKE_ENEMY_OFS_SHOT_X  EQU 5
DEF wMekemekePlayerShotXSubpixel EQU $d828
DEF wMekemekePlayerShotX       EQU $d829 ; Zero means inactive.
DEF wMekemekePlayerShotLane    EQU $d82a
; Flags, X fraction, X, original byte +3, attack X/windup, shot X, shot fraction, original byte +7.
; Flags: bit 0 selects the variant, bit 1 marks retreat, and bit 3 holds X during windup.
DEF wMekemekeEnemySlots        EQU $d82b
DEF wMekemekeEnemySlotsEnd     EQU wMekemekeEnemySlots + MEKEMEKE_ENEMY_COUNT * MEKEMEKE_ENEMY_SIZE
DEF wMekemekeHitReactionTimer  EQU $d84c
DEF wMekemekePaletteFlashTimer EQU $d84d
DEF wMekemekeBlastPickCooldown EQU $d84e
DEF wMekemekeBlastLaneFlags    EQU $d84f ; Lane in bits 0-6, bit 7 arms the blast after a hit.
DEF wMekemekeBlastSpan         EQU $d850 ; Tracks enemy X before the hit, then counts down.
DEF wMekemekePlayerLane        EQU $d976
DEF hMekemekeLaneY             EQU $ffc9
DEF hMekemekeLaneIndex         EQU $ffca
DEF hMekemekeVariantCount      EQU $ffcb
DEF hMekemekePrevVariantCount  EQU $ffcc
DEF hMekemekeSlotsRemaining    EQU $ffcd

; Modes 1 and 2 share three decimal score digits encoded as tile IDs ($04 = zero).
DEF wMinigameScoreHundreds     EQU $d856
DEF wMinigameScoreTens         EQU $d857
DEF wMinigameScoreOnes         EQU $d858

; Bug catching (minigame 2). Each bug holds type, axis/sign, X, Y, motion fraction,
; special motion timer, direction phase, and the original trailing byte.
DEF BUG_SLOT_COUNT             EQU 16
DEF BUG_SLOT_SIZE              EQU 8
DEF BUG_HAZARD_SIZE            EQU 8
DEF BUG_HAZARD_OFS_AIM_REFRESH EQU 4
DEF wBugSpawnGate              EQU $d859
DEF wBugSpawnDelay             EQU $d85a
DEF wBugPlayerStepFraction     EQU $d85b ; Carry alternates one- and two-pixel steps.
DEF wBugWingFrameCounter       EQU $d85c
DEF wBugSlots                  EQU $d85d
DEF wBugPhase                  EQU $d8dd ; Move, catch, hit reaction, empty phase, or result.
DEF wBugCatchType              EQU $d8de ; $ff until a bug is caught in the current swing.
DEF wBugLastCaughtType          EQU $d8df ; Popup and score type for the most recent catch.
DEF wBugPopupX                  EQU $d8e0
DEF wBugPopupY                  EQU $d8e1
; Hazard records hold respawn timer, X or spawn index, Y, step error,
; aim refresh timer, absolute aim X/Y, and aim sign bits.
DEF wBugHazardSlots             EQU $d8e2
DEF wBugPlayerBlinkTimer        EQU $d956 ; Hit recovery flicker and hazard invulnerability.
DEF wBugHazardFrameCounter      EQU $d957
DEF wBugPlayerX                 EQU $d975
DEF wBugPlayerY                 EQU $d976
DEF wBugPlayerFacing            EQU $d977 ; Up, left, down, right.
DEF hBugSpawnX                  EQU $ffc9
DEF hBugSpawnY                  EQU $ffca
DEF hBugSpawnType               EQU $ffcb
DEF hBugCatchMinX               EQU $ffc9
DEF hBugCatchMinY               EQU $ffca
DEF hBugCatchMaxX               EQU $ffcb
DEF hBugCatchMaxY               EQU $ffcc
DEF hBugHazardAimAbsX           EQU $ffc9
DEF hBugHazardAimAbsY           EQU $ffca
DEF hBugHazardMetasprite        EQU $ffcb
ASSERT wBugSlots + BUG_SLOT_COUNT * BUG_SLOT_SIZE == wBugPhase

; Gameplay scratch aliases. Other owners of these HRAM bytes keep their own names.
DEF hSpawnRecordPtrLo          EQU $ffc5 ; Active five-byte record used to initialize a stage object.
DEF hSpawnRecordPtrHi          EQU $ffc6
DEF hObjectScreenYHi           EQU $ffca ; Signed high byte after subtracting camera Y.
DEF wDropPlatformMinXDistance  EQU $c403 ; Reset each frame. X candidates update it before the Y test.

; Player-only HRAM overlays used by ground collision and cockroach action frames.
DEF hPlayerGroundProbeY          EQU $ffca ; Low byte of world Y for the two-foot probe.
DEF hCockroachActionFramePtrLo   EQU $ffc5 ; Selected animation frame table, read by all three action steps.
DEF hCockroachActionFramePtrHi   EQU $ffc6

DEF hPartyHornReachBonus EQU $ffce ; Added to the forward offset and half-width when the horn extends.

; Different boss phases overlay the same four runtime bytes.
DEF wStage1BossAttackPhase        EQU $c0b7 ; Low nibble is the phase, bit 7 alternates the patrol entry.
DEF wStage1BossWindupTimer        EQU $c0b8
DEF wStage1BossJumpVelocityLo    EQU $c0b9
DEF wStage1BossJumpVelocityHi    EQU $c0ba
DEF wStage2BossBouncePhase        EQU $c0b7
DEF wStage2BossBounceVelocityLo   EQU $c0b9
DEF wStage2BossBounceVelocityHi   EQU $c0ba
DEF wStage3BossAttackPhase        EQU $c0b7
DEF wStage3BossAttackTimer        EQU $c0b8 ; Used for both the throw pose and the camera shake.
DEF wStage3BossCoconutFallEnabled EQU $c0b9 ; Set on the return walk, cleared in the throw sequence.
DEF wStage3BossNormalHitEnabled  EQU $c0ba ; Stomp and ordinary action hits register on the return walk.
