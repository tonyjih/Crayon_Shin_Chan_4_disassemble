# 原版畫面與小遊戲分派盤點

表項是否有入口，依分派所讀的欄位及其寫入點判定。
SameBoy 1.0.5 使用原版 ROM。多數按鍵回放從標題開始，學校換區從已初始化的入口快照起跑。
受控測試另標出修改的 RAM，DEBUG 入口使用 DEBUG 組譯版。

## 小遊戲

| 分派表 | 入口與驗證 |
| --- | --- |
| `MinigameInitHandlers`、`MinigameUpdateHandlers` | `wMinigameMode` 0 是 BONUS 及共用說明畫面，站點 0～2 由 `RequestState_StartSelectedMinigame` 轉為模式 1～3。DMG、SGB 的標題選單回放皆進入這三個模式。 |
| `BonusStageStateHandlers` | 保留原版 0～7。已確認的正常寫入是 0～6，7 的輪次分級表項見 [BONUS 子狀態追蹤](symbol_cleanup.md#bonus-子狀態-07)。 |
| `Minigame1StateHandlers` | メケメケ寫入 0 等待、1 倒數、2 遊玩、3 失敗、4 過關。DMG、SGB 分別用按鍵跑出失敗與達到目標分數，兩個結果皆有入口。 |
| `Minigame2StateHandlers` | 捉蟲的畫面子狀態只有 0 等待、1 倒數、2 遊玩，DMG、SGB 均觀察到。結果在回合內的另一張表分派。 |
| `BugHuntRoundPhaseHandlers` | `wBugPhase` 的 0 移動、1 捕捉、2 受擊和 4 結算都有寫入來源。3 只指向一條 `ret`，未找到正常寫入。 |
| `Minigame3StateHandlers` | 滑跳的 0～6 都有寫入。DMG 用按鍵完成第 1 輪，再於第 2 輪落在中繼平台觸發 6，之後落空進 5，合計覆蓋 0～6。平台反彈時出現的 `$07` 寫入 `wScreenPhaseCounter`，供示範計時。 |

### 捉蟲回合內階段 03

靜態寫入點包括回合初始化、捕捉開始與結束、障礙命中與恢復、達標及倒數用完。
16 筆 8-byte 的蟲記錄止於 `$d8dc`，下一個 byte `$d8dd` 才是 `wBugPhase`。

DMG、SGB 從標題打贏第 1～3 輪。第 4 輪等障礙命中、恢復並超時返回標題。
監看 `$d8dd`（含 Echo RAM 鏡像）和 `02:62a8`，回放只寫入 `$00/$01/$02/$04`，未執行 `02:62a8`。
另在第 1 輪遊玩中單獨將 `wBugPhase` 改成 `$03`。兩種模式都分派到 `BugHunt_Phase03Return`，
執行 `ret`，該表項本身沒有變更階段。

## 畫面與轉場

| 分派表 | 入口與驗證 |
| --- | --- |
| `TitleMenuUpdateHandlers` | 0 標題、1 密碼輸入、2 密碼正確、3 取消密碼、4 場景測試都有入口。在第一格按 B，`02:45a0` 將輸入索引減為 `$ff`，`02:45b3` 寫入子狀態 3。DMG、SGB 都執行 `02:44ae` 並淡出回主選單。DMG 另輸入正確密碼，經子狀態 2 進場景測試 4。 |
| `TitleMenuPhaseHandlers`、`SceneTestConfirmHandlers` | 標題依 START 或 A 從 0 進主選單 1，選小遊戲進 2。場景測試的四列分別開啟關卡對話、關卡標題卡、片尾、BONUS，DMG 均由原版密碼與選單操作到達。 |
| `StageSceneInitHandlers`、`StageSceneUpdateHandlers` | 0 關卡標題卡、1 接關、2 故事、3 對話都有寫入。接關由 `PlayerDeath_EnterGameOver` 直接寫遊戲狀態 4、子狀態 1。DMG 耗盡殘機後進接關，先選繼續、再於下一次選離開，確認 `ContinueMenuPhaseHandlers` 的 0～2。 |
| `EndingInitHandlers`、`EndingUpdateHandlers`、兩種片尾的子狀態表 | DMG 從場景測試選主片尾和捲動片尾。主片尾跑遍 0～6，捲動片尾由文字 `<WRITE>` 推進並跑遍 0～4。兩者分別以請求 `$02` 的引數 3、4 進 BONUS 的提示畫面，子狀態都是 `$03`。引數 5 是捲動片尾的特殊模式分支。 |
| `RequestStateChange_Menu` | 請求 0～6、8、9 能追到直接呼叫或保存後重播的請求碼。請求 7 的表項 `RequestState_EnterContinueScreen` 未找到正常傳入的 B，也未找到會被重播成 7 的保存請求。 |
| `InitCurrentGameState`、`UpdateCurrentGameState` | 原版 release 保留狀態 1 的 `EnterDebugMenu`，但未找到呼叫端。DEBUG 測試版在遊玩中用 SELECT + START 開啟選單。狀態 7 有正常寫入，學校關換區的 `01:514b` 會設定它，`00:097d` 接手淡出及重載。DMG 從學校關入口快照回放換區按鍵，觀察到 2 → 7 → 2。 |

### 接關請求 07

正常耗盡殘機時，DMG 在 `01:57be` 執行 `PlayerDeath_EnterGameOver`，再進 `02:6ac5` 更新接關畫面。
監看的 `02:4363`（轉場請求 `$07`）沒有執行。另從密碼取消的淡出畫面將保存請求
`wStateChangeParamHi` 改為 `$07`，DMG 隨後執行 `02:4363`，也進入同一個接關畫面。

### DEBUG 原版入口與測試版接線

`00:1703` 的 `EnterDebugMenu` 是原版 ROM 內唯一找到會把 `hGameState` 寫為 1 的程式。
它先將 `hStageIndex + (wAlternateModeFlags & $04)` 寫入 `wDebugStageSelection`，
再把 `hGameState` 和 `hNeedsReset` 設為 1，返回呼叫端。畫面初始化由 `00:1965` 的 `LoadDebugMenu` 接手。
原版 ROM 中和 `$1703` 相符的五組小端序 bytes 都落在物件、地圖、圖片或音軌資料，未找到直接跳轉或分派指標。
DMG、SGB 在遊玩中同時按 A+B+SELECT+START 都執行 `00:017c` 回標題。
原本的開發版如何呼叫 `00:1703` 仍無法確認。

原版關卡開始請求在 `02:4356` 是 `ld a, $04`，進入關卡標題卡。專案早期的 DEBUG 測試 ROM
曾把 `02:4357` 的立即值改成 `$01`，並另外接入 `00:3f6a` 的背景載入。
DMG 從舊標題接線進選單時沒有執行 `EnterDebugMenu`。直接按 A 開始遊戲，
`DebugMenu_ResumeGameplay` 寫入初始化索引 3，跳過原版新遊戲把 `hPlayerLives` 設為 `$02` 的步驟，殘機欄位仍為 `$00`。

現在用 `make debug-rom` 建置。關卡開始請求走原版的 `ld a, $04`。
DEBUG 的 VBlank 在讀取手把後、執行當前狀態前檢查快捷鍵。正常遊玩（狀態 2）時，
只按 SELECT 和 START 且至少一鍵剛按下，便把當幀更新交給 `EnterDebugMenu`。
判定放在原版暫停處理之前，長按不會反覆觸發。

SameBoy 1.0.5 的 DMG、SGB 都以純按鍵從標題進入遊戲。
普通野餐關進出選單後是關卡 `$00`、模式位 `$00`、殘機 `$02`。
輸入原版密碼進第二輪學校關後，選單預選值是 `$05`，離開後是關卡 `$01`、模式位 `$04`、殘機 `$02`。
在選單將殘機加至 `$03` 後，離開並再次進出仍維持 `$03`。
也確認單按 SELECT 會繼續遊玩，單按 START 可暫停和繼續，四鍵重設會回標題。

受控測試從原版密碼進入學校關的第二輪模式，已在遊玩時只於模擬器暫時把 VBlank 的一筆
`call UpdateCurrentGameState` 改送 `EnterDebugMenu`。DMG、SGB 都帶入關卡 `$01` 和模式位 `$04`，
得到選關值 `$05`。按 A 離開選單後，仍是同一關與模式，殘機欄位維持 `$02`。此測試確認入口副程式的行為。

公開資料列出的 Game Genie 碼 `003-57B-F7A` 在此 ROM 會將 `02:4357` 的 `$04` 換成 `$00`。
SameBoy 的 DMG 實測是回到標題，未進 DEBUG。 [公開碼記錄](https://www.arcade-history.com/game/65805/crayon-shin-chan-4-ora-no-itazura-daihenshin-model-dmg-h9j)
