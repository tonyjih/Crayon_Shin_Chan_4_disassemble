v14b stage4 fix

Stage4's layout RLEFF decodes to 0x100 bytes, i.e. a single 16x16 metatile page.
The previous v14 treated every stage as the normal 14-page-wide layout and tried
to decode stage4 to 0x0e00 bytes, causing:

  RLEFF ended early: produced 0x100/0xe00 bytes

v14b treats stage4 as a one-page Tiled map:

  tiled/stage4/stage4_normal.tmx width=16 height=16
  assets/levels/stage4/layout.raw size=0x100
  assets/levels/stage4/page_table.bin = 00

Stages 0-3 keep the previous 14-page-wide behavior.
