# 角色、動作與姿勢索引

## 用 OAM 圖鑑找素材

已經有 `Shin4-Sprites-GB-Original/` 的原版灰階姿勢包時，執行：

```powershell
python -B tools/export_oam_gallery.py
```

打開 `build/oam-gallery/index.html`。可依角色群組篩選，或搜尋動作、ROM 位址、metasprite 名稱與原版 PNG 檔名。
點選姿勢會顯示 OAM 部件的原始順序、相對座標、OBJ tile 和旗標。點部件可定位編譯用 PNG 中的圖塊，
也可反查同一張 PNG 供應哪些姿勢。列、欄及圖塊編號從 0 起算。

圖鑑涵蓋灰階包現有的 41 組、649 個姿勢，另外可瀏覽全部 55 張編譯用 PNG。
目前有 35 張能從姿勢回查。背景、字形、SGB 邊框等資料按 tilemap 或各自的畫面配置使用。
圖鑑讀取灰階包的 `reference/` 並核對像素雜湊。`sprite_tile_sources.csv` 把姿勢包的 VRAM 圖塊表
對回原版 PNG 和起始圖塊編號。空白來源代表該 VRAM 圖塊在目前的配置中未上傳。
生成器需要 Pillow。若灰階包放在別處，可把包的路徑傳給生成器。

## 用 CSV 查找

先在 [動作索引](sprite_actions.csv) 找角色或動作，再用 `groups` 中的群組及
`frames` 中的十六進位畫格編號查 [姿勢索引](sprite_poses.csv)。
兩張表涵蓋現有姿勢匯出的 41 組、649 張 PNG，包含場景動畫的 76 個入口及已確認的遊戲內動作。

例如雨傘敵人巡邏使用 `EnemyWalkerAnimIdsB`。在 `02-actors/picnic` 查 `0x0c`，
可找到原版 `00:1d23` 的 `SpriteFrameData_1d23` 和匯出檔 `editable/02-actors/picnic/012.png`。
該列也列出供應這個姿勢的原版圖塊 PNG。

## 姿勢索引

- `pose_png` 相對於姿勢包根目錄。彩色包 `Shin4-Sprites-Editable` 和原版灰階包
  `Shin4-Sprites-GB-Original` 共用相對路徑。這兩包可由 SDL3 的 `sprite_workspace.py export` 產生。
- `rom_pointer_table` 和 `frame` 指向原版指標表。直接引用的 metasprite 沒有指標表。
  同址別名照實保留，例如場景畫格 `$d1` 和 `$d2` 都指向 `UiMetasprite_d1`。
- `reference_sheets` 是匯出包 `reference/tiles/` 下的圖塊表名稱，加上 `.png` 就是檔名。
  `original_tile_sources` 則是相對於 `original/` 的建置輸入，依該姿勢的 VRAM 上傳與覆蓋順序反查。
  一個姿勢可以引用多張原版 PNG。 `zero` 表示姿勢匯出所用的未上傳空白圖塊，空欄表示該記錄沒有精靈部件。
- `border_part` 是從 BONUS 的水平及垂直邊框記錄抽出的共用星星圖塊。匯出 PNG 將它放在局部原點。
- `|` 分隔多個值。同一個 metasprite 在不同關卡可能使用不同圖塊，所以查圖時要一起看 `group`。

## 動作索引

- `scene_script` 保留場景腳本順序。`0x02@12F` 是畫格 `$02`、12 ticks、水平翻轉。
  `hold` 保持最後一格，`loop:` 後是原版循環目標。部分入口共用同一段尾端。
- `id_table` 保留原版畫格表的排列。 `selector` 列出程式選用的畫格，
  `direct` 列出直接繪製的姿勢。這些遊戲內動作的時機由各自的狀態機控制。
- `groups` 列出包含所需畫格的匯出群組。相同場景指標可能被多組共用，實際在哪裡觸發以
  `action` 和 `rom_symbol` 為準。未確認觸發用途的入口保留原版 symbol 和畫格順序。

五種型態的 `$08–$0b` 共用玩家狀態 `$05` 的 `PlayerUnusedMove05AnimIds`，目前查不到正常入口。
畫格 `$09` 的小圖塊靠近手部，`$0a` 的小圖塊出現在斜上方，
`$0b` 移除這個部件，看起來像拋物。程式會暫時設受傷保護旗標，播放兩輪後套用既有的地形對齊並回到狀態 `$00`。
在 SameBoy 的野餐關強制進入 `$05` 時，播放期間玩家世界座標和地圖均維持原樣。
動作索引保留原始表，末尾那筆 `$08` 會被結束判斷跳過。原版 DMG 教學的梯子走狀態 `$03`，
靜止用 `$10`，移動時交替用 `$10/$11`。

核對基準是 MD5 `BCB3D47C291FD0A26B2C7B1082C3AD88` 的 ROM 和兩份姿勢包的 manifest。
指標從原版 ROM 讀取，精靈部件、匯出底稿雜湊和供應圖塊的 2bpp bytes 都有交叉核對。
