GetStageTileAtSignedWorldPixel::
    bit 7, d
    jp z, GetStageLayoutTileAtWorldPixel

    xor a
    ret


CheckPlayerHeadCollision:: ; Player upward/head collision check.
    xor a
    ldh [hPlayerTileProbeCount], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchPlayerHeadTileContact
    ldh a, [hPlayerTileProbeCount]
    cp $01
    jr nz, HeadCollision_CheckReleaseFromSnapState

    ldh a, [hPrevPlayerState]
    cp $03
    ret z

    ld a, $03
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerVelY], a
    ldh [hPlayerVelYHigh], a
    ldh [hPlayerStatePhase], a
    ld [wPlayerForcedJumpFlags], a
    ldh a, [hPlayerForm]
    cp $02
    jr nz, HeadCollision_SnapPlayerX

    xor a
    ldh [hPlayerActionLock], a

HeadCollision_SnapPlayerX::
    xor a
    ldh [hPlayerTileEffect], a
    ldh a, [hPlayerX]
    and $f8
    or $08
    ldh [hPlayerX], a
    ret


HeadCollision_CheckReleaseFromSnapState::
    ldh a, [hPrevPlayerState]
    cp $03
    ret nz

    jp AlignPlayerToTileAndResetState


DispatchPlayerHeadTileContact::
; Tile attribute in A selects head contact / Stage 1 transition handling.
    cp $06
    jr z, HeadTile_CountSolidProbe

    cp $08
    jr z, HeadTile_CountIfUpperHalf

    cp $09
    jr z, HeadTileAttr09_CountIfNonzeroY

    cp $0a
    jr z, HeadTileAttr0A_CountIfNonzeroY

    cp $1c
    jr z, HeadTile_CheckStage1Profile1Trigger

    cp $1d
    jr z, HeadTile_CheckStage1Profile2Trigger

    ret


HeadTile_CountSolidProbe::
    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_CountIfUpperHalf::
    ldh a, [hPlayerY]
    and $0f
    cp $08
    ret nc

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTileAttr09_CountIfNonzeroY::
    ldh a, [hPlayerY]
    and $0f
    ret z

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTileAttr0A_CountIfNonzeroY::
    ldh a, [hPlayerY]
    and $0f
    ret z

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_CheckStage1Profile1Trigger::
    ldh a, [hPlayerY]
    and $0f
    cp $03
    jr c, HeadTile_SelectStage1Profile1

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_SelectStage1Profile1::
    ld a, $01
    ld [wStage1CameraProfileIndex], a

HeadTile_BeginStage1Transition::
    ld a, $40
    ld [wFadeTransitionTimer], a
    ld a, $07
    ldh [hGameState], a
    ld a, $02
    ld [wGameplayInitSubstate], a
    ld a, $ff
    ld [wStage1ResumeProfileFlag], a
    ret


HeadTile_CheckStage1Profile2Trigger::
    ldh a, [hPlayerY]
    and $0f
    cp $0b
    jr nc, HeadTile_SelectStage1Profile2

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret


HeadTile_SelectStage1Profile2::
    ld a, $02
    ld [wStage1CameraProfileIndex], a
    jr HeadTile_BeginStage1Transition

CheckPlayerRightTileCollision::
; Probe at player world X + 7.
    xor a
    ldh [hPlayerTileCollisionFlag], a
    ld hl, hPlayerX
    ld a, [hl+]
    add $07
    ld c, a
    ld a, [hl]
    adc $00
    ld b, a

CheckPlayerSideTileCollisionAtBC::
; BC=world X; probe the lower and upper edges of the player body.
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    dec de
    push de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    pop de
    call DispatchPlayerSideCollision
    ld e, PLAYER_COLLISION_HEIGHT_NORMAL
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, SideCollision_ProbeUpperBody

    ld e, PLAYER_COLLISION_HEIGHT_COCKROACH

SideCollision_ProbeUpperBody::
    ld hl, hPlayerY
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    push de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    pop de

DispatchPlayerSideCollision::
    and $3f
    add a
    ld hl, PlayerSideCollisionHandlerTable
    add l
    ld l, a
    ld a, $00
    adc h
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp hl

PlayerSideCollisionHandlerTable:: ; 48-entry tile attribute dispatch table used by DispatchPlayerSideCollision.
; Tile attributes are masked with $3f before indexing, but entries $30-$3f are unused by known maps.
; Original ROM overlaps the unused tail with handler code starting at PlayerSideCollisionNoHit.
    dw PlayerSideCollisionNoHit ; $00
    dw PlayerSideCollisionSolid ; $01
    dw PlayerSideCollisionNoHit ; $02
    dw PlayerSideCollisionNoHit ; $03
    dw PlayerSideCollisionNoHit ; $04
    dw PlayerSideCollisionNoHit ; $05
    dw PlayerSideCollisionNoHit ; $06
    dw PlayerSideCollisionNoHit ; $07
    dw PlayerSideCollisionNoHit ; $08
    dw PlayerSideCollisionNoHit ; $09
    dw PlayerSideCollisionNoHit ; $0a
    dw PlayerSideCollisionNoHit ; $0b
    dw PlayerSideCollisionNoHit ; $0c
    dw PlayerSideCollisionNoHit ; $0d
    dw PlayerSideCollisionNoHit ; $0e
    dw PlayerSideCollisionNoHit ; $0f
    dw PlayerSideCollisionNoHit ; $10
    dw PlayerSideCollisionSolid ; $11
    dw PlayerSideCollisionSolid ; $12
    dw PlayerSideCollisionNoHit ; $13
    dw PlayerSideCollisionSolid ; $14
    dw PlayerSideCollisionNoHit ; $15
    dw PlayerSideCollisionNoHit ; $16
    dw PlayerSideCollisionNoHit ; $17
    dw PlayerSideCollisionNoHit ; $18
    dw PlayerSideCollisionNoHit ; $19
    dw PlayerSideCollisionNoHit ; $1a
    dw PlayerSideCollisionSolidIfYLowBit3Clear ; $1b
    dw PlayerSideCollisionNoHit ; $1c
    dw PlayerSideCollisionNoHit ; $1d
    dw PlayerSideCollisionSolidIfYLowBit3Set ; $1e
    dw PlayerSideCollisionSpecialStageFlag ; $1f
    dw PlayerSideCollisionNoHit ; $20
    dw PlayerSideCollisionNoHit ; $21
    dw PlayerSideCollisionNoHit ; $22
    dw PlayerSideCollisionNoHit ; $23
    dw PlayerSideCollisionNoHit ; $24
    dw PlayerSideCollisionNoHit ; $25
    dw PlayerSideCollisionNoHit ; $26
    dw PlayerSideCollisionNoHit ; $27
    dw PlayerSideCollisionNoHit ; $28
    dw PlayerSideCollisionNoHit ; $29
    dw PlayerSideCollisionNoHit ; $2a
    dw PlayerSideCollisionNoHit ; $2b
    dw PlayerSideCollisionNoHit ; $2c
    dw PlayerSideCollisionNoHit ; $2d
    dw PlayerSideCollisionNoHit ; $2e
    dw PlayerSideCollisionNoHit ; $2f

PlayerSideCollisionNoHit::
    ret

PlayerSideCollisionSolid::
    ld a, $ff
    ldh [hPlayerTileCollisionFlag], a
    ret


PlayerSideCollisionSolidIfYLowBit3Set::
    bit 3, e
    ret z

    jr PlayerSideCollisionSolid

PlayerSideCollisionSolidIfYLowBit3Clear::
    bit 3, e
    ret nz

    jr PlayerSideCollisionSolid

PlayerSideCollisionSpecialStageFlag::
    ld a, [wStageCheckpointActive]
    or a
    ret nz

    jp ReplacePlayerMetatileWith05AndQueue


CheckPlayerLeftTileCollision::
; Probe at player world X - 8.
    xor a
    ldh [hPlayerTileCollisionFlag], a
    ld hl, hPlayerX
    ld a, [hl+]
    sub $08
    ld c, a
    ld a, [hl]
    sbc $00
    ld b, a
    jp CheckPlayerSideTileCollisionAtBC


ProbePlayerGroundTilesAtHeight18::
; Use the shared two-foot tile probe at player Y - 18.
    xor a
    ldh [hPlayerTileCollisionFlag], a
    ldh [hPlayerTileProbeCount], a
    ld e, $12
    jr GroundCollision_ProbeBothFeet

CheckPlayerGroundCollision:: ; Player downward/ground collision check.
    ldh a, [hPlayerY]
    sub $20
    ldh a, [hPlayerYHigh]
    sbc $00
    ret c

    xor a
    ldh [hPlayerTileCollisionFlag], a
    ldh [hPlayerTileProbeCount], a
    ld e, PLAYER_COLLISION_HEIGHT_NORMAL
    ldh a, [hPlayerForm]
    cp PLAYER_FORM_COCKROACH
    jr nz, GroundCollision_ProbeBothFeet

    ld e, PLAYER_COLLISION_HEIGHT_COCKROACH

GroundCollision_ProbeBothFeet::
    ld hl, hPlayerY
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl]
    sbc $00
    ld d, a
    ld a, e
    ldh [hPlayerGroundProbeY], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    dec bc
    dec bc
    push de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchGroundTileCollision
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    inc bc
    inc bc
    pop de
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchGroundTileCollision
    ldh a, [hPlayerTileProbeCount]
    cp $02
    ret nz

    ldh a, [hPlayerState]
    cp $04
    ret z

    ld a, $04
    ldh [hPlayerState], a
    xor a
    ldh [hPlayerStatePhase], a
    ldh [hPlayerAnimFrame], a
    ldh a, [hPlayerForm]
    cp $02
    jr nz, GroundCollision_SnapPlayerY

    xor a
    ldh [hPlayerActionLock], a

GroundCollision_SnapPlayerY::
    ldh a, [hPlayerY]
    and $f0
    or $08
    ldh [hPlayerY], a
    ret


DispatchGroundTileCollision::
    and $3f
    rst $00


    ; Ground tile collision / interaction dispatch table.
    dw GroundTileCollisionNone ; 00
    dw GroundTileSolidOrFallState ; 01
    dw GroundTileCollisionNone ; 02
    dw GroundTileCollisionNone ; 03
    dw GroundTileCollisionNone ; 04
    dw GroundTileCollisionNone ; 05
    dw GroundTileCollisionNone ; 06
    dw GroundTileSolidIfNearTop ; 07
    dw GroundTileCollisionNone ; 08
    dw GroundTileCollisionNone ; 09
    dw GroundTileCollisionNone ; 0a
    dw GroundTileSolidOnlyWhenSnapState ; 0b
    dw GroundTileCollisionNone ; 0c
    dw GroundTileCollisionNone ; 0d
    dw GroundTileSolidOnlyWhenSnapState ; 0e
    dw GroundTileCollisionNone ; 0f
    dw GroundTileCollisionNone ; 10
    dw GroundTileSolidOrFallState ; 11
    dw GroundTileSolidOrFallState ; 12
    dw GroundTileCollisionNone ; 13
    dw GroundTileSolidOrFallState ; 14
    dw GroundTileCollisionNone ; 15
    dw GroundTileSolidIfNearTop ; 16
    dw GroundTileCollisionNone ; 17
    dw GroundTileCollisionNone ; 18
    dw GroundTileCollisionNone ; 19
    dw GroundTileCollisionNone ; 1a
    dw GroundTileSlopeRightIfUpperHalf ; 1b
    dw GroundTileCollisionNone ; 1c
    dw GroundTileCollisionNone ; 1d
    dw GroundTileSlopeLeftIfLowerHalf ; 1e
    dw GroundTileCollisionNone ; 1f
    dw GroundTileCollisionNone ; 20
    dw GroundTileCollisionNone ; 21
    dw GroundTileCollisionNone ; 22
    dw GroundTileEnterStageInteraction03 ; 23
    dw GroundTileEnterStageInteraction01 ; 24
    dw GroundTileCollisionNone ; 25
    dw GroundTileCollisionNone ; 26
    dw GroundTileCollisionNone ; 27
    dw GroundTileCollisionNone ; 28
    dw GroundTileCollisionNone ; 29
    dw GroundTileCollisionNone ; 2a
    dw GroundTileCollisionNone ; 2b
    dw GroundTileCollisionNone ; 2c
    dw GroundTileCollisionNone ; 2d
    dw GroundTileCollisionNone ; 2e
    dw GroundTileCollisionNone ; 2f

GroundTileEnterStageInteraction03::
    ldh a, [hPlayerState]
    cp $0c
    ret z

    ld a, $0c
    ldh [hPlayerState], a
    ld a, $03
    ld [wStageInteractionSubstate], a
    ret

GroundTileEnterStageInteraction01::
    ldh a, [hPlayerState]
    cp $0c
    ret z

    ld a, $0c
    ldh [hPlayerState], a
    xor a
    ld [wStageInteractionCounter], a
    inc a
    ld [wStageInteractionSubstate], a
    ret

GroundTileCollisionNone::
    ret

GroundTileSlopeLeftIfLowerHalf::
    ldh a, [hPlayerGroundProbeY]
    bit 3, a
    ret z

    jr GroundTileSolidOrFallState

GroundTileSlopeRightIfUpperHalf::
    ldh a, [hPlayerGroundProbeY]
    bit 3, a
    ret nz

GroundTileSolidOrFallState::
    ldh a, [hPlayerState]
    cp $03
    jp nz, EnterPlayerFallState

    ld a, $ff
    ldh [hPlayerTileCollisionFlag], a
    ret

GroundTileSolidIfNearTop::
    ldh a, [hPlayerY]
    sub $18
    and $0f
    cp $04
    ret nc

    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret

GroundTileSolidOnlyWhenSnapState::
    ldh a, [hPlayerState]
    cp $03
    ret nz

    ld a, $ff
    ldh [hPlayerTileCollisionFlag], a
    ret


CheckPlayerFootTileContact::
; Dispatch the metatile under each of the two feet; clear contact/alignment scratch first.
    xor a
    ldh [hPlayerTileProbeCount], a
    ld [wPlayerTileAligned], a
    ldh [hPlayerObjectFlags], a
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    dec bc
    dec bc
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]
    call DispatchPlayerTileContact
    ldh a, [hPlayerX]
    ld c, a
    ldh a, [hPlayerXHigh]
    ld b, a
    inc bc
    inc bc
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call GetStageTileAtSignedWorldPixel
    ld e, a
    ld d, $00
    ld hl, wStageTileAttrTable
    add hl, de
    ld a, [hl]


DispatchPlayerTileContact::
    and $3f
    rst $00


    ; Player tile collision / interaction dispatch table.
    dw PlayerTileContactSolid ; 00
    dw PlayerTileSnapToTileTopClearEffect ; 01
    dw PlayerTileSlopeContactLeft ; 02
    dw PlayerTileSlopeContactRight ; 03
    dw PlayerTileSetEffect1IfNearTop ; 04
    dw PlayerTileSetEffect2IfMiddle ; 05
    dw PlayerTileContactSolid ; 06
    dw PlayerTileSetEffect1IfNearTop ; 07
    dw PlayerTileSetEffect2IfMiddle ; 08
    dw PlayerTileContactSolid ; 09
    dw PlayerTileSetEffect1IfNearTop ; 0a
    dw PlayerTileContactSolid ; 0b
    dw PlayerTileEffect2LeftHalf ; 0c
    dw PlayerTileEffect2RightHalf ; 0d
    dw PlayerTileSetEffect1IfNearTop ; 0e
    dw PlayerTileSetEdgeFlagLeft ; 0f
    dw PlayerTileSetEdgeFlagRight ; 10
    dw PlayerTileSnapAndSetEdgeFlagRight ; 11
    dw PlayerTileSnapAndSetEdgeFlagLeft ; 12
    dw PlayerTileSetEdgeFlagSolid ; 13
    dw PlayerTileSnapAndSetEdgeFlag ; 14
    dw PlayerTileEffect1AndEdgeFlag ; 15
    dw PlayerTileContactSolid ; 16
    dw PlayerTileEffect1EdgeRight ; 17
    dw PlayerTileEffect1EdgeLeft ; 18
    dw PlayerTileContactSolid ; 19
    dw PlayerTileSpawnDropPlatform ; 1a
    dw PlayerTileSnapHighHalf ; 1b
    dw PlayerTileContactSolid ; 1c
    dw PlayerTileStageTransitionIfLow ; 1d
    dw PlayerTileSnapLowHalf ; 1e
    dw PlayerTileTriggerCollectibleBlock ; 1f
    dw PlayerTileBounceLaunch ; 20
    dw PlayerTileSnapToTileTop ; 21
    dw PlayerTileDeathIfDeepContact ; 22
    dw PlayerTileSnapToTileTopClearEffect ; 23
    dw PlayerTileSnapToTileTopClearEffect ; 24
    dw PlayerTileContactSolid ; 25
    dw PlayerTileContactSolid ; 26
    dw PlayerTileContactSolid ; 27
    dw PlayerTileContactSolid ; 28
    dw PlayerTileContactSolid ; 29
    dw PlayerTileContactSolid ; 2a
    dw PlayerTileContactSolid ; 2b
    dw PlayerTileContactSolid ; 2c
    dw PlayerTileContactSolid ; 2d
    dw PlayerTileContactSolid ; 2e
    dw PlayerTileContactSolid ; 2f

PlayerTileTriggerCollectibleBlock::
    ld a, [wStageCheckpointActive]
    or a
    jp nz, PlayerTileContactSolid

    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call ReplacePlayerMetatileWith05AndQueue
    jp PlayerTileContactSolid


ReplacePlayerMetatileWith05AndQueue::
; Set metatile $05, compute its BG position, and mark the replacement for VRAM upload.
    push de
    call GetStageTileAtSignedWorldPixel
    ld [hl], $05
    pop de
    call GetWorldMetatileBgAddress
    ld a, l
    ld [wPendingMetatile05DestLo], a
    ld a, h
    ld [wPendingMetatile05DestHi], a
    ld a, [wPendingVramUpdates]
    set 2, a
    ld [wPendingVramUpdates], a
    ld a, $ff
    ld [wStageCheckpointActive], a
    ld a, $5b
    jp PlaySound


GetWorldMetatileBgAddress::
; World Y comes from E; horizontal tile coordinate comes from C.
    ld a, e
    jp GetMetatileBgAddressForYAndC

PlayerTileSnapToTileTop::
    jp PlayerTileSnapToTileTopClearEffect

PlayerTileDeathIfDeepContact::
    ldh a, [hPlayerDeathCollisionDisabled]
    cp $ff
    ret z

    ldh a, [hPlayerY]
    and $0f
    cp $08
    jr c, PlayerTileContactSolid

    jp EnterPlayerDeathFallState

PlayerTileBounceLaunch::
    ld a, $5c
    call PlaySound
    ld a, $10
    ldh [hPlayerGravity], a
    ld a, $02
    ldh [hPlayerState], a
    ld [wPlayerForcedJumpFlags], a
    call PlayerTileSnapToTileTopClearEffect
    ld hl, -$0390
    jp StorePlayerJumpVelocityHL

PlayerTileStageTransitionIfLow::
    ldh a, [hPlayerY]
    and $0f
    cp $0b
    jp nc, HeadTile_SelectStage1Profile2

PlayerTileContactSolid::
    ld hl, hPlayerTileProbeCount
    inc [hl]
    ret

PlayerTileSnapLowHalf::
    ldh a, [hPlayerY]
    bit 3, a
    jr z, PlayerTileContactSolid

    ld a, $ff
    ld [wPlayerTileAligned], a
    xor a
    ldh [hPlayerTileEffect], a
    ldh a, [hPlayerY]
    and $f0
    or $08
    ldh [hPlayerY], a
    ret

PlayerTileSnapHighHalf::
    ldh a, [hPlayerY]
    bit 3, a
    jr nz, PlayerTileContactSolid

PlayerTileSnapToTileTopClearEffect::
    ld a, $ff
    ld [wPlayerTileAligned], a
    xor a
    ldh [hPlayerTileEffect], a
    ldh a, [hPlayerY]
    and $f0
    ldh [hPlayerY], a
    ret

PlayerTileSlopeContactLeft::
    bit 3, c
    jr z, PlayerTileContactSolid

    jr PlayerTileSetEffect1IfNearTop

PlayerTileSlopeContactRight::
    bit 3, c
    jr nz, PlayerTileContactSolid

    jr PlayerTileSetEffect1IfNearTop

PlayerTileSetEffect1IfNearTop::
    ldh a, [hPlayerY]
    and $0f
    cp $04
    jr nc, PlayerTileContactSolid

    ld a, $01
    ldh [hPlayerTileEffect], a
    ret

PlayerTileSetEffect2IfMiddle::
    ldh a, [hPlayerY]
    and $0f
    cp $08
    jr c, PlayerTileContactSolid

    cp $0c
    jr nc, PlayerTileContactSolid

    ld a, $02
    ldh [hPlayerTileEffect], a
    ret

PlayerTileEffect2LeftHalf::
    bit 3, c
    jr z, PlayerTileContactSolid

    jr PlayerTileSetEffect2IfMiddle

PlayerTileEffect2RightHalf::
    bit 3, c
    jr nz, PlayerTileContactSolid

    jr PlayerTileSetEffect2IfMiddle

PlayerTileSetEdgeFlagLeft::
    bit 3, c
    jr z, PlayerTileContactSolid

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jr PlayerTileContactSolid

PlayerTileSetEdgeFlagRight::
    bit 3, c
    jr nz, PlayerTileContactSolid

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jr PlayerTileContactSolid

PlayerTileSnapAndSetEdgeFlagRight::
    call PlayerTileSnapToTileTopClearEffect
    bit 3, c
    ret nz

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileSnapAndSetEdgeFlagLeft::
    call PlayerTileSnapToTileTopClearEffect
    bit 3, c
    ret z


    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileSetEdgeFlagSolid::
    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jp PlayerTileContactSolid

PlayerTileSnapAndSetEdgeFlag::
    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jp PlayerTileSnapToTileTopClearEffect

PlayerTileEffect1AndEdgeFlag::
    ld hl, hPlayerObjectFlags
    set 1, [hl]
    jp PlayerTileSetEffect1IfNearTop

PlayerTileEffect1EdgeRight::
    call PlayerTileSetEffect1IfNearTop
    bit 3, c
    ret nz

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileEffect1EdgeLeft::
    call PlayerTileSetEffect1IfNearTop
    bit 3, c
    ret z

    ld hl, hPlayerObjectFlags
    set 1, [hl]
    ret

PlayerTileSpawnDropPlatform::
    ldh a, [hPlayerY]
    and $0f
    cp $04
    jp nc, PlayerTileContactSolid

    push bc
    call ClearPlayerFootMetatileAndQueue
    pop bc
    ld hl, wObjectSlots

DropPlatformTile_FindFreeSlot::
    ld a, [hl]
    or a
    jr z, DropPlatformTile_SelectObjectType

    cp $ff
    jr z, DropPlatformTile_AppendBeforeTerminator

    ld de, $0010
    add hl, de
    jr DropPlatformTile_FindFreeSlot

DropPlatformTile_AppendBeforeTerminator::
    call DropPlatformTile_SelectObjectType
    ld [hl], $ff
    ret


DropPlatformTile_SelectObjectType::
    push hl
    ldh a, [hStageIndex]
    cp $01
    ld a, $1c
    jr nz, DropPlatformTile_InitObjectAndUpdate

    ld a, $1e

DropPlatformTile_InitObjectAndUpdate::
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld a, c
    and $f0
    or $08
    ld [hl+], a
    ld a, b
    ld [hl+], a
    xor a
    ld [hl+], a
    ldh a, [hPlayerY]
    and $f0
    or $08
    ld [hl+], a
    ldh a, [hPlayerYHigh]
    ld [hl+], a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld a, $40
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld a, $20
    ld [hl+], a
    ld a, $01
    ld [hl+], a
    xor a
    ld [hl+], a
    pop bc
    push hl
    ldh a, [hStageIndex]
    cp $01
    jr z, DropPlatformTile_UpdateStage1Variant

    call UpdateObjDropPlatformA
    pop hl
    ret


DropPlatformTile_UpdateStage1Variant::
    call UpdateObjDropPlatformB
    pop hl
    ret


ClearPlayerFootMetatileAndQueue::
; Set the contacted metatile to zero and queue its 2x2 BG replacement.
    ldh a, [hPlayerY]
    ld e, a
    ldh a, [hPlayerYHigh]
    ld d, a
    call GetStageTileAtSignedWorldPixel
    ld [hl], $00
    call GetPlayerMetatileBgAddress
    ldh a, [hStageIndex]
    cp $01
    jr z, ClearFootTile_ScheduleStage1Patch

    ld b, h
    ld c, l
    ld de, $0002
    jp QueueVramFill


ClearFootTile_ScheduleStage1Patch::
    ld a, [wPendingVramUpdates]
    bit 3, a
    jr nz, ClearFootTile_QueueStage1PatchImmediately

    set 3, a
    ld [wPendingVramUpdates], a
    ld a, l
    ld [wPendingClearedMetatileDestLo], a
    ld a, h
    ld [wPendingClearedMetatileDestHi], a
    ret


ClearFootTile_QueueStage1PatchImmediately::
    ld de, wStage1ClearedMetatileTiles
    ld bc, $0202
    jp QueueTilemapRect


GetPlayerMetatileBgAddress::
; Use player Y and the world X coordinate in C.
    ldh a, [hPlayerY]

GetMetatileBgAddressForYAndC::
; Map A=world Y, C=world X to the top-left BG address of the 16x16 metatile.
    and $f0
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld d, $98
    ld a, c
    and $f0
    rrca
    rrca
    rrca
    ld e, a
    add hl, de
    ret
