v15s: Fix export-tiled crash from v15r.

v15r accidentally referenced LAYOUT_BANK, but the canonical constant in this tool is LEVEL_DATA_BANK.
This broke export-tiled while reading original layout RLEFF ranges.

Only code change: LAYOUT_BANK -> LEVEL_DATA_BANK in two layout RLEFF slice sites.
