# 原版 symbol 整理紀錄

本次只整理 `original/` 的名稱、資料格式與註解。release ROM 與整理前備份、
`clean.gb` 的 131,072 bytes 逐位元組相同：

```text
MD5 = BCB3D47C291FD0A26B2C7B1082C3AD88
```

## 已確認並整理的部分

- 硬體、WRAM／HRAM、畫面與聲音引擎常數移入 `constants.inc`，新增 154 個 `DEF` 名稱。
- 直接 `jp`／`jr`／`call` 的數字目標為 0；61 個 RST $00 分派表與三個跨 bank 呼叫表均使用 symbol。
- 指令中的裸記憶體操作數，例如 `[$d940]`，為 0。已確認的欄位使用用途名稱，
  其餘使用具名工作區加 offset。這些 offset 欄位仍保留在待查清單中。
- bank 0 的共用函式、聲音 sequencer、DEBUG 選單，以及 bank 3 的訊息與 SGB 程式，
  已沒有 `Call_`／`Jump_`／`jr_`／`label_` 形式的自動名稱。
- bank 1 補上玩家碰撞、跳躍速度、圖塊載入、敵人與頭目的狀態入口名稱。
  狀態編號能確認而細節尚不明的入口，以所屬狀態機及實際索引命名，註明待細分行為。
- bank 2 補上標題、密碼、場景測試、小遊戲、接關、關卡對話與結局的主要入口和分派表名稱。
- 73 段場景動畫拆成「時間／朝向、metasprite ID」記錄，45 個迴圈目標改用 `dw symbol`。
  `$fe` 是保持上一影格；其後兩個原版遺留 word 保留並註明不會被解碼器讀取。
- 關卡對話拆出四組指標表、43 筆訊息／調色盤／角色動畫記錄及 8 個控制寫入地址。
- bank 3 的 242 筆 metasprite 指標、107 筆訊息描述、16 筆動態代字指標，以及 SGB 邊框資料表，
  使用可閱讀的資料宣告。訊息描述的起點已確認是 `$5f2f`。
- 資料區中沒有外部引用的假跳轉 label 已移除；既有 symbolic `dw` 沒有被凍結成原始 bytes。

自動名稱的數量變化如下；減少量包含重新命名、移除重複別名及資料區假 label，不能解讀為函式數。

| Bank | 整理前 | 目前 |
| --- | ---: | ---: |
| 0 | 263 | 0 |
| 1 | 439 | 0 |
| 2 | 518 | 0 |
| 3 | 103 | 0 |
| 合計 | 1,323 | 0 |

## 容易誤讀的地方

- 原版 MBC1 bank latch 寫入 `$2100`，仍由 `rRomBankSelect` 表達，沒有改成硬體 include 的 `$2000`。
  每個 ROMX bank 的 `$4000` 是 bank ID byte；它不是 RAM，也不是一般函式入口。
- `MovePlayerYBySignedHL` 暫借 Y velocity 套用一次 HL 位移，之後恢復 velocity，並非增加速度。
- `ZeroMemoryWithInitialA` 只把第一個 byte 寫成 A，其餘進入 `bzero`。真正保持 A 的填值迴圈是 `FillBytesWithA`。
- `$ff00`／`$fe00` 曾被誤標成 `rP1`／`_OAMRAM` 的部分，實際是負位移或 signed 8.8 速度，已改用負數表示。
  同樣修正了以 `rNR41` 表示負位移，以及把 packed hitbox 值當作函式指標的情況。
- 密碼畫面的兩個 cursor 資料是 metasprite，不是單純的座標 offset 陣列。
- `$67d5`／`$67dd` 是四筆動畫指標表；真正的動畫腳本位於 `$7913` 等地址。
- `$c412/$c413` 目前只確認被初始化成 `$0004`，用途保留為 `wUnconfirmedStageInitWordLo/Hi`。
- 原版特殊跳轉、固定資產大小、資料重疊及進入指令中間的路徑都保留，沒有調整遊戲邏輯。

## 共用記憶體的命名規則

同一個 WRAM／HRAM 位址會隨遊戲狀態改變用途。精確別名只用在確認的 consumer 範圍內。

| 範圍／別名 | 已確認的用途或限制 |
| --- | --- |
| `wSoundSlots`、`hSound*` | 六個虛擬音軌槽，以及每次音效更新使用的 HRAM record |
| `wMessage*`、`hMessageResumePtr*` | 文字來源、VRAM 位置、打字延遲及動態代字返回指標 |
| `wSceneAnim0*`、`wSceneAnim1*` | 三-byte 動畫狀態：指標 lo/hi、時間／朝向 |
| `wStageDialogueScriptPtr*`、`wStageDialogueAnimSelectors` | state 4 關卡對話；小遊戲會重用同一區 |
| `wPassword*` | 密碼畫面中的輸入列、cursor、重複按鍵與比對結果 |
| `hPlayerTileProbeCount`／`hPlayerObjectProbeBelow` | 同為 `$ffcd`，分別是 tile probe 計數與物件碰撞距離門檻 |
| `wMinigamePhaseCounter` | 開始前倒數、遊戲中的 timer tick、結果動畫 counter，依 substate 切換 |
| `wSharedWork`、`hSharedScratch` | 剩餘三處未確認用途的 WRAM／HRAM 中性基底 |

## 尚未確認的部分

原先清單中的 **542 個自動 label** 均已追查，其中三個是同址別名。
[unresolved_labels.csv](unresolved_labels.csv) 目前只有欄位名稱。
`preceding_symbol` 只表示原始碼中的位置，不保證是函式或呼叫關係的邊界。

[unresolved_memory.csv](unresolved_memory.csv) 記錄中性工作區 offset 的 **3 處引用、3 個不同位址**。
同一個位址可能有多個用途，不能把這個數字視為尚未辨識的變數數。

| 位址 | 仍待確認的讀寫點 |
| --- | --- |
| `$ffca` | `Bonus_StoreRoundRewardSelection` 依輪次寫入一個值。其下游讀取點尚未確認。 |
| `$d8df` | `Mekemeke_NextLaneOrCheckPlayerShot` 讀入 A。計分 helper 在使用 A 前先覆寫它。 |
| `$d8f2` | `BugHunt_UpdateHazardRespawn` 讀入 B。`ChooseScreenRandomThird` 在比較前先覆寫 B。 |

另有部分資料只確認格式而未確認畫面內容，例如 `ScreenData_*`、以地址命名的音軌；
音軌播放索引仍可由 `audio/sound_ids.csv` 追查。

這兩份 CSV 是目前來源的快照。後續若更名或移動程式，來源行與統計需要一起更新。
[symbol_cleanup.json](symbol_cleanup.json) 保存目前待查統計；`new_def_symbols` 保留首次整理的新增數量。

## 驗證

```powershell
make check-original
python -B tools/check_control_flow.py --self-test
```

已通過完整 release 編譯、7 個資產測試、控制流程與 symbolic-memory 檢查，
並另行完成 `DEBUG=1` 的組譯與連結。原版圖片、解壓資料、音軌及資產 manifest 都沒有變動。
尚未逐段使用模擬器追蹤待查 label；MD5 證明 ROM bytes 一致，不能單獨證明用途註解正確。

SGB 命令名稱參照 [Pan Docs 原始命令表](https://raw.githubusercontent.com/gbdev/pandocs/master/src/SGB_Command_Summary.md)。

## 後續模組化與建置護欄

- `.rgbds-version` 固定已驗證的 RGBDS 1.0.1，四個工具均須通過版本核對才會開始產生資產。
  原版 CI 使用同版官方套件及 SHA-256，執行完整 `check-original`。
- 音效、訊息與 SGB 程式拆入 `engine/`，其波形、查表及傳輸資料拆入 `data/`。
  INCLUDE 仍位於原版資料順序中的相同位置，未重新安排 ROM。
- `ram/objects.asm` 明確配置 stage object 的 512-byte WRAM 區，並為確認過的欄位提供 offset 名稱。
  組譯期檢查記錄長度及儲存區終點；type/state 共用的工作欄位仍註明用途限制。
- 控制流程檢查改為追蹤 `game.asm` 的 INCLUDE，拆檔後仍涵蓋所有原有 2,546 個 symbolic branches。

拆分後原有 3,154 個 symbol 的 bank／地址與完整 ROM bytes 均不變。
模組拆分這一批尚未細分當時其餘 575 個 label 的用途，兩份 CSV 的來源位置也已核對仍有效。

## 日文字碼與文字來源

- 基礎字型 128 個 tiles 對照到 `charmap.inc`；濁音／半濁音以兩-byte CHARMAP 編碼。
- 107 筆 descriptor 引用的 105 段訊息、14 段有效代字串，以及 14 段 DEBUG 單行字串，
  改為 `text`／`line`／`done` 可讀來源，實際 bytes 和既有 string alias 均保留。
- 35 個文字 label 補上依內容確認的名稱；該批尚未減少 bank 1／2 當時的 575 個待查自動 label。
- 文字與指標表分別拆到 `text/`、`data/messages.asm`；表的筆數新增組譯期檢查。
- 五個場景相關 tile ID 尚未確認用途，使用 `<TILE_XX>`；沒有當作已確認字形命名。
- 加入三項原生組譯測試，涵蓋濁音、控制碼、空行、共用尾端、charmap 還原及非法字元。

編輯規則與保留的原版特殊資料見 [文字格式](../text/README.md)。

Windows 與 Ubuntu 均已通過完整編譯、9 個資產測試、3 個文字組譯測試與控制流程檢查；
另外通過 `DEBUG=1` 組譯及連結。35 個 label 改名對照後，既有 3,156 個 symbol 的 bank／地址不變，
ROM 與本輪修改前逐 byte 相同；兩份待查 CSV 的 575／588 個來源位置也仍有效。

## 場景動畫與結局

- 73 段場景動畫改用 `scene_frame`／`scene_loop`／`scene_hold`，包含 291 個 frame pairs。
  翻轉、metasprite ID、保留 opcode 及 loop bank 有組譯期檢查；兩個 hold 後的原版遺留 word 未移除。
- 共用播放器、結局流程及資料拆檔；33 個結局內部自動 label 依實際 consumer 命名，
  另補上各個已確認的結局 state 和資料表名稱。
- 結局專用 RAM 別名明確區分角色 X/hold、cue、credits ID、粒子及不同模式共用 `$d956` 的用途。
  44 處中性記憶體引用改成用途名稱，未全域套用到其他畫面。
- 待查 label 由 575 減至 542；中性記憶體引用由 588 減至 544，涉及 92 個不同位址。
  JSON 和兩份 CSV 已一起更新，來源掃描涵蓋 INCLUDE 模組。

詳細格式與仍未確認的欄位，見 [場景格式](../scene/README.md)。

Windows／Ubuntu 的完整 `check-original` 均通過：9 個資產測試、6 個 macro 組譯測試，
以及控制流程與 symbolic-memory 檢查。`DEBUG=1` 亦可組譯及連結。
55 個用途名稱的改名對照後，既有 3,156 個 symbol 的 bank／地址不變，完整 ROM bytes 相同；
542 個待查 label 和 544 個記憶體引用的 CSV 來源位置已核對。

## 後續用途追查

- 關卡過場、接關與對話已補上 47 個自動 label 和 61 處 RAM 引用的用途。接關朝向與 X 小數共用 $d93b，對話遮罩與 SGB 封包欄位只在各自的讀寫範圍套用。

- 獎勵關卡、場景測試和游標補上 44 個自動 label 與 66 處 RAM 引用。獎勵站的三個關卡等級和選單解鎖等級分開命名。依關卡等級寫入 $ffca 的獎勵選擇值尚無確認的讀取點。

- 滑行跳躍小遊戲補上 56 個自動 label 與 152 處 RAM 引用。已辨識 24-bit 座標、8.8 速度、鏡頭、平台指標與結果流程，並將兩個被誤標為 HRAM 的鏡頭位移改回 signed scalar。

- メケメケ與共用計分補上 58 個自動 label 和 82 處 RAM 引用。敵人跑道記錄、投射物、爆炸、分數與勝負分支已命名，敵人變種機率表也改用 symbol 指向。

- 昆蟲小遊戲補上 71 個自動 label 與 92 處 RAM 引用。出蟲閘門、16 筆昆蟲記錄、捕捉矩形、得分提示和兩個會撞到玩家的物件都有用途名稱。bank 2 的自動 label 已清完，三處仍待查的 RAM 引用保留在清單。

- 遊戲主迴圈、玩家投射物和物件生成已處理 61 個自動 label 與 10 處 RAM 引用。頭目生成入口的重複別名合併到同址 symbol，四個頭目圖塊來源改用已確認的資產基底。

- 玩家的地面、空中、受傷和型態動作已處理 77 個自動 label 與 12 處 HRAM 引用。地形探測 Y 和蟑螂動作影格指標各有用途別名，側碰撞入口的同址別名已合併。

- 拾取物、巡邏敵人和紙飛機補上 22 個自動 label 與 3 處 HRAM 引用。喇叭伸長的加成會同時調整碰撞中心與半寬。

- 四個頭目與其投射物補上 47 個自動 label 及 53 處 RAM 引用。$c0b7～$c0ba 依頭目分開命名，第三關頭目的升降輔助程式也依實際存取的 Y 欄位改名。

- 平台、場景物件與教學示範已處理最後 59 個自動 label 和 10 處 RAM 引用。第二種移動平台依實際 X 軸移動改名，state 8 依輸入腳本和教學訊息改名。

本輪共處理 542 個自動 label，RAM 待查引用從 544 降至 3。每批皆通過原版重建與 symbol 地址比對。
最終來源在 Windows 和 Ubuntu 通過 `check-original`，Windows 也通過 `DEBUG=1` 組譯與連結。
完整 131,072 bytes 與原始 ROM dump 相同。
