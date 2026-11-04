# 原版文字

`messages.asm` 是 107 筆 descriptor 引用的 105 段訊息，以及 14 段有效動態代字來源。
`debug_menu.asm` 是 14 段單行 DEBUG 文字。兩者都直接參與組譯，沒有額外的文字轉檔步驟。
訊息指標和 VRAM 目的地在 `../data/messages.asm`；文字仍依原版 ROM 順序排列。

```asm
    text "きょうは しんちゃんが"
    line "たのしみにしていたピクニック"
    done
```

`text` 只寫入字形 bytes；`line` 先寫入 `$fe` 再寫文字；`done` 寫入 `$ff`。
`charmap.inc` 對照 `../gfx/compressed/b06_4bc0.png` 的 128 個基礎 tiles，
並將濁音、半濁音轉成「修飾 byte、基底假名」兩個 bytes，例如 `が = $45, $15`。
`ヘ／ベ／ペ` 共用ひらがな `へ` 的 tile；`レベル` 與 `スペシャル` 也使用這個共用字形。
數字使用全形 `０`～`９`，句點使用 `．`，保留原版的空格與大小假名。

`text` 會逐個檢查 charmap 項目，不支援的漢字、ASCII 字母或拼錯的 token 都會停止組譯，
避免 RGBDS 把未映射字元直接寫成 UTF-8。請使用預組合濁音字，例如 `が`；
分離的 combining mark 不會自動正規化。macro 結束後會恢復呼叫端的 charmap。

| 來源寫法 | 原生 byte／作用 |
| --- | --- |
| `<DPAD>`、`<A>`、`<B>` | `$0f`、`$40`、`$7b`，按鍵圖示 |
| `<VAR>` | `$fd`，由 `wMsgSubstitutionId` 選擇代字串；代字串的 `$ff` 會回到原訊息 |
| `<WRITE>` | `$fc`，將 `wMessageControlValue` 寫入 `wMessageControlPtrLo/Hi` 指向的位置 |
| `<DAKUTEN>`、`<HANDAKUTEN>` | `$45`、`$43`，需要單獨保留修飾 tile 時使用 |
| `<FILL_01>`～`<FILL_03>` | 實際色號 1～3 的實心 tiles；credits 中的 `$01` 保持原值 |
| `<TILE_8E>`、`<TILE_8F>`、`<TILE_A0>`、`<TILE_A1>`、`<TILE_C5>` | 場景相關字形，尚未確認圖像用途，保留明確的 tile 編號 |

`<WRITE>` 的目的地／值和 `<VAR>` 的選擇都由程式預先設定，文字中沒有額外參數 bytes。
`$fe` 每次往下兩個 tile rows，供上一列放濁音；`$ff` 結束訊息或返回代字呼叫端。
單行的 `CopyTextLineToVram`／`QueueTextLine` 只識別濁音和 `$ff`，不識別這三種控制碼。
DEBUG 的 Action Kamen 字串原本就帶有一個 `$fe` tile byte，來源明確保留為 `db $fe`。

原版資料的共用和特殊情況也保留：

- descriptor `$14`／`$4c` 共用 level 字串，`$4b`／`$4d` 共用 START 提示。
- 一些較早命名的 `Message_*` ID 後綴與實際 descriptor ID 不同；以 `data/messages.asm` 註解為準。
- Chicken 代字串的最後一個 `り` 仍有原本的 `MessageSubstitutionLastGlyph` label。
- 代字指標 `$0e`／`$0f` 原本指向 descriptor 表，並非另兩段已確認的有效字串。
- 文字保留 ROM 的實際字形，例如 `おべんきでね` 和 credits 的 `エッグメン`，不依舊註解修正文案。

`make check-original` 會測試濁音、共用字形、控制碼、空行、代字尾端、charmap scope
與非法字元拒絕，再驗證完整 ROM MD5。改寫對話也可能需要調整顯示寬度、字串長度和 ROM 配置；
原版 matching 模式仍要求所有 bytes 一致。
