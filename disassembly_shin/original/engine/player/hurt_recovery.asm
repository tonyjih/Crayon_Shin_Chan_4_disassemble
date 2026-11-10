PlayerState_UpdateHurtKnockback:: ; State 06: recovery/knockback-style animation state.
    ldh a, [hPlayerStatePhase]
    or a
    jr z, HurtRecovery_StreamFormTilesAndAnimate

    ld h, $0c
    ld l, $03
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerRecoveryAnimIdsA
    ldh a, [hPlayerAnimFrame]
    cp $02
    jr z, HurtRecovery_RestoreNormalControl

    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    cp $03
    ret nz

    ld a, $04
    ldh [hPlayerAnimId], a
    call DrawPlayerSprite
    ld a, $03
    ldh [hPlayerAnimId], a
    ret



PlayerRecoveryAnimIdsA::
; The 92 tile-stream updates leave index 1 and counter 8. Index 0 is skipped and index 2 exits before lookup.
    db $02, $03, $03

HurtRecovery_RestoreNormalControl::
    ld a, $04
    ldh [hPlayerAnimId], a
    call QueuePlayerFormHudIcon
    ld a, $80
    ld [wPlayerHurtBlinkTimer], a
    ld hl, hPlayerFlags
    set 1, [hl]
    res 4, [hl]
    call AlignPlayerToTileAndResetState
    ldh a, [hPlayerForm]
    cp $04
    ret nz

    call SelectGameplayMusic
    ld hl, wActionKamenMoveSpeedLo
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, l
    ldh [hPlayerSpeedX], a
    ld a, h
    ldh [hPlayerSpeedXHigh], a
    ret


HurtRecovery_StreamFormTilesAndAnimate::
    call StreamPlayerFormTilesUntilComplete
    ldh a, [hPlayerAnimCounter]
    cp $01
    ld a, $48
    call z, PlaySound
    ld h, $0c
    ld l, $02
    ld e, $00
    call AdvancePlayerAnimWithinRange
    ld hl, PlayerRecoveryAnimIdsB
    ldh a, [hPlayerAnimFrame]
    rst $38
    ld a, [hl]
    ldh [hPlayerAnimId], a
    ret



PlayerRecoveryAnimIdsB::
    db $00, $01

StreamPlayerFormTilesUntilComplete::
; Advance the recovery phase after the tile counter reaches magnitude $54.
    call StreamNextPlayerFormTile
    rst $28
    cp $54
    ret c

    ldh a, [hPlayerStatePhase]
    inc a
    ldh [hPlayerStatePhase], a
    ret


StreamNextPlayerFormTile::
; Queue one bank 5 tile on nonnegative animation-counter frames.
    ld hl, PlayerFormGfxTileBaseTable
    ldh a, [hPlayerForm]
    rst $20
    ldh a, [hPlayerAnimTimer]
    bit 7, a
    jr nz, FormTileStream_AdvanceCounter

    ld c, a
    add $13
    ld e, a
    ld d, $05
    call QueueBankedVramTile8000

FormTileStream_AdvanceCounter::
    ldh a, [hPlayerAnimTimer]
    inc a
    ldh [hPlayerAnimTimer], a
    ret



PlayerFormGfxTileBaseTable::
    dw Gfx_b05_4131 ; normal
    dw Gfx_b05_45a1 ; flying squirrel
    dw Gfx_b05_53a1 ; cockroach
    dw Gfx_b05_4f41 ; chicken
    dw Gfx_b05_4ad1 ; Action Kamen
