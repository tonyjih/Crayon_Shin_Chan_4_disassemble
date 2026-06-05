v17e: Fix Stage 2 after_switch VRAM replay size.

Call_001_56a9/Call_001_56c2 streams c0b2=0..0x3a inclusive, tile IDs $45-$7f, so a complete after_switch snapshot needs 0x3b0 bytes from bank0:$3902 -> VRAM $9450. Previous v16g/v17 used 0x390 bytes, leaving tile IDs $7e-$7f stale; metatile decimal 34 / $22 uses tile $7e as its top-left tile.
