# 原版畫面與小遊戲分派盤點

表項是否有入口，依分派所讀的欄位及其寫入點判定。
SameBoy 1.0.5 使用原版 ROM。按鍵回放從標題開始，受控測試另外標出修改的 RAM。

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
