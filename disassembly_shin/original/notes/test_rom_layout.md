# 測試 ROM 的壓縮素材配置

## Bank 空間與固定地址

原版 linker map 的八個 ROM bank 都顯示 0 bytes 可用，因為 section 已含尾端填充。
下表的範圍是依組譯來源、資產邊界和原版 ROM 核對的 `$ff` 尾端填充，兩端位址皆包含。
填充仍須按用途查核才能分配。

| Bank | 尾端填充 | Bytes | 邊界與固定地址 |
| --- | --- | ---: | --- |
| 0 | `$3f6a–$3fff` | 150 | 入口、重設／中斷向量和 cartridge header 固定。DEBUG 背景載入和遊玩快捷鍵使用 `$3f6a–$3f97`，剩 104 bytes。 |
| 1 | `$7f4c–$7fff` | 180 | `$4000` 是 bank ID，`$4001` 起是跨 bank 呼叫表。尾端填充在密碼畫面的 RLEFF 地圖之後。 |
| 2 | `$7ff4–$7fff` | 12 | `$4001` 起是跨 bank 呼叫表。尾端填充在捲動片尾的 `GfxRle_b02_7fe0` 之後。 |
| 3 | `$7f9e–$7fff` | 98 | `$4001` 起是跨 bank 呼叫表。填充是最後一筆 metasprite 的 `$80` 終止碼之後的 `db $ff`。 |
| 4 | `$7ed0–$7fff` | 304 | 在 `Bank4PostCollisionData_Bank4` 的最後一段 `INCBIN` 之後。本批測試搬移使用這段。 |
| 5 | `$7fd4–$7fff` | 44 | 在滑水圖像 `GfxRle_b05_7481` 之後。關卡的圖塊上傳表可能跨相鄰資產，應整段核對讀取範圍。 |
| 6 | `$7fb8–$7fff` | 72 | 在最後一段劇情圖 `GfxRle_b06_7e13` 之後。測試搬移仍保留 `$5334–$53eb` 的原長度與 `$53ec` 後續素材的起點。 |
| 7 | `$7ef3–$7fff` | 269 | `SoundDirectory` 位於 `$6201`。`$7ef2` 的 `$ff` 是末段音軌的結束指令。SDL3 匯出從音效目錄讀到 `$7fff`。 |

所有 ROMX bank 在 `$4000` 都保留原版 bank ID。Bank 4 的碰撞表和瀑布資料有共用區段與切片，
例如 `Bank4PostCollisionData_Bank4` 本身仍是瀑布資產的一部分。表內空間從實際資料結束後算起。

## BONUS 圖像搬移

`gfx/compressed/b06_5334.png` 是 BONUS 角色的 14 個 2bpp 圖塊。原版資料位於 `06:$5334`，
壓縮長度 184 bytes，解壓到 VRAM `$8130–$820f`。唯一組譯載入點
`Bonus_InitPaletteAndTiles` 同時以 `BANK(GfxRle_b06_5334)` 和 `GfxRle_b06_5334` 取得來源。
前一段字形的直接拷貝至多 624 bytes，剛好止於這張圖之前。

以相同索引色模式和尺寸編輯這張圖，再執行 `make test-rom`。壓縮長度變動時，建置會將
`GfxRle_b06_5334` 放到 `04:$7ed0`，原槽補成 `$ff`，載入程式由 linker 更新來源。
224 bytes 的解壓長度仍需通過檢查。此長度的 previous-byte RLE 最多 254 bytes，
也有組譯檢查確保資料留在 bank 4 內。原版建置和等長測試素材使用原位置。其餘資產仍用固定尺寸檢查。

本次在隔離副本改了圖塊像素，壓縮由 184 增至 245 bytes。測試 ROM 的其他 symbol 地址與原版一致。
SameBoy 的 DMG 和 SGB 模式皆由標題選單進入射擊小遊戲的說明畫面，記錄到載入器從
`04:$7ed0` 解壓並寫入 224 bytes。對齊同一動畫畫格後，兩模式的像素差異都在角色的
`x=4–11, y=107–114` 區域。
