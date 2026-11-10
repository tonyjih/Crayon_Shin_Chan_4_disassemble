IF DEF(DEBUG)
DebugMenu_InitBackgroundGfx::
    ldh [hNeedsReset], a
    ldh [hSCX], a
    ld hl, Gfx_b05_5701
    ld de, _VRAM + $d00
    ld bc, $0300
    ld a, BANK(Gfx_b05_5701)
    call BankedMemcpy
    ld a, $04
    ld [wScreenPaletteId], a
    ret
ENDC
