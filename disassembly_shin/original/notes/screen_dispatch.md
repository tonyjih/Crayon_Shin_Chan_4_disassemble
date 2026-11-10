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
| `InitCurrentGameState`、`UpdateCurrentGameState` | 原版 release 的狀態 1 沒有確認的入口。`EnterDebugMenu` 沒有程式引用，請求 6 只在 DEBUG 建置選狀態 1。狀態 7 有正常寫入，學校關換區的 `01:514b` 會設定它，`00:097d` 接手淡出及重載。DMG 從學校關入口快照回放換區按鍵，觀察到 2 → 7 → 2。 |

### 接關請求 07 與 DEBUG

正常耗盡殘機時，DMG 在 `01:57be` 執行 `PlayerDeath_EnterGameOver`，再進 `02:6ac5` 更新接關畫面。
監看的 `02:4363`（轉場請求 `$07`）沒有執行。另從密碼取消的淡出畫面將保存請求
`wStateChangeParamHi` 改為 `$07`，DMG 隨後執行 `02:4363`，也進入同一個接關畫面。

另用 DEBUG 組譯版跑 DMG，從標題開始遊戲會進狀態 1 的 DEBUG 選單。
按 A 開始遊玩時，`DebugMenu_ResumeGameplay` 把 `wGameplayInitSubstate` 寫成 3。
這是已知的 3 寫入點，對應的 gameplay 初始化表項和 2 共用 `InitGameplaySubstateCommon`。
