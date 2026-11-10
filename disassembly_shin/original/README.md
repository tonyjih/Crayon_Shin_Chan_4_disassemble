# 原版資產與編譯

基準是彩色化前的 `a522210` 原始碼；整理後的 release ROM 必須維持：

```text
size = 131072
MD5  = BCB3D47C291FD0A26B2C7B1082C3AD88
```

在專案根目錄執行 `make check-original` 或 `python -B tools/build_original.py`。
`original/` 是來源；`build/original/` 全部都是可刪除、可重新產生的輸出。

程式用途、共用記憶體與尚未確認的 label，見 [symbol 整理紀錄](notes/symbol_cleanup.md)。
硬體、WRAM／HRAM、畫面及音效引擎的共用常數在 `constants.inc`；
stage object 的儲存區與欄位定義在 `ram/objects.asm`。

## 程式結構

bank 檔保留 ROM 配置順序，已確認的系統透過 INCLUDE 拆出：

- `bank_001.asm`：關卡初始化、主迴圈、頭目入場和教學在 `engine/gameplay/`。
  玩家操作、碰撞和變身在 `engine/player/`，物件生成、敵人、平台和各關頭目在 `engine/objects/`。
- `bank_002.asm`：標題、密碼、場景測試、接關和關卡對話在 `engine/screens/`。
  獎勵關卡、三個小遊戲和共用計分在 `engine/minigames/`。
- `engine/audio.asm`：音效 sequencer；查表與波形宣告在 `data/audio/`。
- `engine/messages.asm`：訊息解碼、換行與動態代字。
- `engine/sgb.asm`：SGB 畫面調色盤與邊框傳輸；相關資料在 `data/sgb/`。
- `engine/scene_animation.asm`、`engine/ending.asm`：場景動畫播放器與結局流程，相關資料在 `data/`。
- `ram/objects.asm`：`$c180`～`$c37f` 的 32 筆 stage object 儲存區，包含 list terminator 的空間。
- `text/`、`charmap.inc`：可直接組譯的日文訊息、DEBUG 文字與字碼；descriptor 表在 `data/messages.asm`。

文字 macro、濁音的兩-byte 編碼及場景字形限制，見 [文字格式](text/README.md)。
場景動畫的時間／翻轉、loop／hold 與結局 cue 格式，見 [場景格式](scene/README.md)。

物件欄位名稱依一般移動／動畫 helper 的讀寫用途定義。部分狀態會把同一個欄位重用為 timer，
例如 thrown-state 的 byte +2；特殊 actor 的 12-byte 記錄不屬於此 16-byte 儲存區。
控制流程檢查會從 `game.asm` 追蹤 INCLUDE，涵蓋拆出的組譯檔。

## 圖片

`gfx/raw/` 的 33 張 PNG 是原本未壓縮的 tile。`gfx/compressed/` 的 22 張 PNG
是解開 previous-byte RLE 後的 tile。編譯會使用 PNG 的索引色順序還原 tile 位元組，
再視需要壓縮；PNG 是實際輸入，不只是預覽。

- 一般 tile 是 Game Boy 2bpp，色號 0～3 對應白、淺灰、深灰、黑。
- SGB 邊框來源是 1bpp；其餘色平面由原版上傳程式補上。
- 每列最多 16 tiles；最後一列補齊的空白 tile 必須維持色號 0。有效 byte 數記在 `assets.json`。
- 檔名中的 bank／地址是原版位置，不是需要手動修改的指標。
- 原版部分 VRAM 載入會跨越相鄰圖塊或與其他載入範圍重疊。來源依 ROM 中實際佔用的範圍切割，避免兩份 PNG 同時決定同一組 ROM 位元組。

上一版誤認為圖片的 bank 7 `$6201` 之後資料，已改整理為音效索引與原生音軌。

## 壓縮與地圖

原版 37 段壓縮資產都在建置時重壓：

- 23 段 previous-byte RLE：16-bit group count、每組 mask 決定八個 byte 是 literal 或重複前值。
  其中 22 段來自 PNG，另一段是 `sgb/border_tilemap.bin`。
- 14 段 RLEFF：`FF count value`，原版壓縮器每段最多 251 bytes；其餘為 literal。
  所有來源都是解壓後的 `.bin`，包含五關地圖及選單／小遊戲地圖。

`levels/stage*/layout.bin` 是實體頁面的 metatile ID，每頁 16×16 bytes。
`metatiles.bin` 每組四個 tile ID，順序為 TL、TR、BL、BR。
Stage 2 切換後的表另外放在 `levels/stage2_after_switch/`。

五張 `levels/stage*/spawns.csv` 都使用 `object,x,y,param`。例如野餐關的
`OBJ_ENEMY_WALKING_KID,176,240,2` 代表 X=176、Y=240、參數 2 的步行敵人。
物件名稱對應 `constants.inc` 的 `OBJ_*`，Y 須為 8 的倍數，`param` 為 0～7。
選填的 `flags` 保存物件 byte 的第 6、7 位，空白時為 0。
建置把 `param` 放回 Y 的低三位，組回每筆原版 5 bytes，並保留表尾的 `$ff`。
重新抽出原版 ROM 時會產生同樣的具名欄位。
`levels/shared/collision_attrs.bin` 保存碰撞屬性的實際存放區；各關取用窗口仍由程式中的 symbol 決定。

## 音樂與音效

音樂是原生 sequencer 指令，並非 WAV／MP3 壓縮音訊。`audio/sound_data.asm` 的
105 筆播放索引指向 102 段音軌，其中包含 BGM 的各聲部、音效與共享的空白音軌；
這不代表 102 首歌曲。

`audio/tracks/` 每段保留四個 header bytes，之後以 `audio_note`、`audio_volume`、
`audio_repeat` 等 macro 表達原版命令。迴圈目標能確認時使用 label 換算原生 word index。
尚無語意名稱的 opcode 用 `audio_command` 保存，沒有把未知值當作音符猜測。
`audio/sound_ids.csv` 是索引對照；實際編譯輸入為 `.asm`。

`audio/waves/` 的四個檔案各為 16 bytes，保存 wave channel 的 32 個 4-bit 樣本。
音軌指令直接由 RGBDS 組回，沒有額外、會改變原版資料的音訊壓縮層。

## 驗證與重新抽出

兩種建置都會核對每段解壓長度、壓縮往返、固定資產尺寸和 ROM 大小。
原版建置另外核對完整 ROM MD5，通過後才更新 `build/original/` 的產物。
修改圖片、地圖或音軌後，可用 `make test-rom` 組譯到 `build/test-rom/`。
若修改使壓縮長度改變，需要更新資產尺寸記錄並重新安排 ROM 空間。

若要從指定 MD5 的原始 ROM 重新抽出資產，可輸出到另一個目錄，避免覆蓋編輯中的來源：

```powershell
python -B tools/extract_original_assets.py clean.gb --out exported_original
```

抽出工具另需 Pillow；正常建置只需要 Python 標準函式庫與 RGBDS。
RGBDS 版本以專案根目錄的 `.rgbds-version` 為準，建置前會檢查四個工具的版本。
