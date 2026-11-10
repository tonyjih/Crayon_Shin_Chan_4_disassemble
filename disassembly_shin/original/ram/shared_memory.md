# 原版共用 RAM

先看 `hGameState`（`$ff8e`）的更新分派，再看該畫面的子狀態或模式。
同一地址可以在不同畫面、同畫面不同階段，甚至同一幀的不同副程式之間重用。
表中的狀態指實際讀寫該欄位的流程。離開該流程後，記憶體仍可能保留上一個值。

## 畫面分派

| `hGameState` | 更新流程 | 次級分派 |
| --- | --- | --- |
| 0 | 標題選單 | `wScreenSubstate` 0 標題、1 密碼輸入、2 密碼正確確認、3 淡出前往儲存目的地、4 場景測試。標題另用 `wTitleMenuPhase` 0 等待 START、1 主選單、2 小遊戲選單。 |
| 1 | DEBUG 選單 | 游標、關卡、音樂、音效選擇使用 `wDebugCursorRow`、`wDebugStageSelection`、`wDebugMusicIndex`、`wDebugSoundIndex`（`$c0d7–$c0da`）。 |
| 2 | 正常遊玩 | `hStageIndex` 選關卡，`hPlayerState` 與 `hPlayerForm` 選玩家更新路徑。 |
| 3 | 獎勵關卡和小遊戲 | `wMinigameMode`（`$d93e`）0 BONUS、1 メケメケ、2 捉蟲、3 滑跳。各模式獨立解讀 `wScreenSubstate`。 |
| 4 | 關卡過場 | `wScreenSubstate` 0 關卡標題卡、1 接關、2 故事、3 關卡對話。接關另用 `wContinuePhase` 0 選擇、1 接受後移動、2 離場。 |
| 5 | 片尾 | `wEndingMode` 的 bit 0 選主片尾或捲動畫面。兩個模式各有自己的 `wScreenSubstate` 表。 |
| 6 | 主關卡暫停 | 用 `hPrevOamPos` 重用上一幀 sprite，等 START 回狀態 2。 |
| 7 | 淡入回到主關卡 | 進入時跑關卡初始化並選 SGB palette profile `$18`，更新期間依 `wFadeReturnPhase` 做兩段淡入淡出，結束回狀態 2。 |
| 8 | 教學示範 | 走 bank 1 的教學更新，借用主關卡玩家、鏡頭和地圖欄位。 |

狀態 3 的 `wScreenSubstate`：

| `wMinigameMode` | 子狀態 |
| --- | --- |
| 0 | 0 站間走動、1 等待、2 入場動畫、3 說明或密碼提示、4 淡出離開、5 淡出進入小遊戲、6 顯示結果和給獎。原版表中的 7 依輪次分級，已查到的正常轉移只寫入 0～6。 |
| 1 | 0 等待 START、1 開場倒數、2 遊玩、3 失敗、4 過關。 |
| 2 | 0 等待 START、1 開場倒數、2 回合更新。回合內的 `wBugPhase` 使用 0 移動、1 捕捉、2 受擊、4 結算。3 只有返回指令，未找到正常寫入。 |
| 3 | 0 等待 START、1 回合標題、2 接近跳台或落地、3 滯空、4 過關或示範結果、5 失誤離場、6 平台反彈。 |

對照 `UpdateCurrentGameState`、`InitCurrentGameState` 和各模組內的更新表。
BONUS 的入口與結算寫入見 [子狀態追蹤](../notes/symbol_cleanup.md#bonus-子狀態-07)。
其他分派表見 [畫面與小遊戲分派盤點](../notes/screen_dispatch.md)。

## WRAM 畫面重疊欄位

| 地址 | 生效狀態及欄位 |
| --- | --- |
| `$d8df` | **3／模式 1** `wMekemekeUnusedHitByte` 在命中時讀取，計分程式先覆蓋讀值。**3／模式 2** `wBugLastCaughtType` 保留最近抓到的蟲種，供分數與提示 sprite 使用。 |
| `$d93a` | **0／子狀態 1** `wPasswordCursorCol`。**0／4** `wSceneTestLastEditedValue` 保存當次改動值，目前只找到寫入。**4／1** `wContinueActorX`。**3／模式 0** `wBonusActorX`。 |
| `$d93b` | **0／1** `wPasswordInputIndex`。**4／1** 選擇階段用 `wContinueFacingCache` 比對角色朝向，接受接關或離場時移動的主角改用同一 byte 作 `wContinueActorXSubpixel`。**3／模式 0** `wBonusDestination` 選目的地站點，也傳給說明畫面。 |
| `$d93c` | **0／1** `wPasswordCursorRow`。**0／0、4** `wMenuCursorRow`。**4／1** `wContinueChoice` 的 bit 0 選接關或離開。**4／3** `wStageDialogueAdvanceStep` 逐列清除舊文字。**3／模式 0** `wBonusBlinkCounter` 用於邊框 sprite 與說明畫面進度。 |
| `$d940–$d953` | **0／1** `wPasswordInputTopRow`、`wPasswordInputBottomRow` 各 10 bytes，前列是濁音等修飾，後列是基本假名 tile。**0／4** `wSceneTestValues` 重用起頭四個 bytes（`$d940–$d943`），依序選關卡對話、密碼結果、片尾、BONUS 生命值。 |
| `$d956` | **4／1** `wContinueGameOverDelay` 在接關選擇階段且接關數歸零時計時。**4／3** `wStageDialogueHighlightApplied` 記錄 SGB 場景 patch 已套用。 |
| `$d956` | **3／模式 0、子狀態 6** `wBonusRewardChoiceDelay` 控制變身獎勵選擇。**3／模式 2、子狀態 2** `wBugPlayerBlinkTimer` 控制受擊閃爍和無敵時間。**3／模式 3** `wSlideLandingFrame` 選落地圖格。 |
| `$d956` | **5／主片尾、子狀態 6** `wEndingSceneDelay` 等待下一個 cue。**5／捲動畫面** `wEndingSecondaryOffset` 是第二角色的位移。**8** `wTutorialMessageIndex` 選下一段教學訊息。 |
| `$d957` | **3／模式 2、子狀態 2** `wBugHazardFrameCounter` 供危險物件動畫使用。**5／捲動畫面、子狀態 4** `wEndingExitDelay` 在訊息結束後累加。**8** `wTutorialMessageDelay` 控制教學訊息開始時間。 |
| `$d967–$d968` | **4／1、接關階段 1** `wContinueAcceptedVelocityLo`、`wContinueAcceptedVelocityHi` 為 8.8 X 速度。**3／模式 0** 只重用 `$d967` 作 `wBonusWalkDeltaX`，每幀移動 +1 或 −1 像素。 |
| `$d976` | **3／模式 1** `wMekemekePlayerLane` 選跑道。**3／模式 2** `wBugPlayerY` 是玩家 Y 座標。 |
| `$d97b–$d97e` | **4／1** `wContinueExitActorX`、`wContinueExitActorXSubpixel` 在接關階段 2 生效，`wContinueMotionPtrLo`、`wContinueMotionPtrHi` 在階段 1 供移動腳本使用。**3／模式 3** 只重用 `$d97b` 為 `wSlideActorScreenX`，投影時儲存 X，結果動畫讀回。 |

### 相鄰工作區及共用控制欄位

| 地址 | 生效範圍 |
| --- | --- |
| `$d800–$d80b` | 共用場景動畫記錄，每筆為 2-byte 腳本指標與 1-byte 時間／朝向。標題、密碼和接關使用前兩筆，多個小遊戲流程也借用起頭的記錄。關卡對話（4／3）用前三筆，主片尾（5／模式 0）用四筆。 |
| `$d80c–$d810` | 關卡對話（4／3）的 `wStageDialogueScriptPtrLo`、`wStageDialogueScriptPtrHi` 和三個 `wStageDialogueAnimSelectors`。 |
| `$d811–$d858` | `wMinigameRound`（`$d811`）供狀態 3 的模式 1–3 選回合。模式 3 的鏡頭、速度、平台、座標和特效在 `$d812–$d827`。模式 1 的投射物、敵人記錄及爆炸狀態在 `$d828–$d850`。模式 1、2 共用 `wMinigamePhaseCounter`（`$d852`，倒數、回合 tick 或結算動畫）及三位數時間和分數（`$d853–$d858`）。 |
| `$d859–$d8f1` | 捉蟲（3／模式 2）回合工作區，含 16 筆蟲記錄和 2 筆危險物件記錄，每筆 8 bytes。讀取記錄後方的 `wBugHazardSlotsEnd`（`$d8f2`）後，亂數呼叫會覆蓋該讀值。 |
| `$d8f3–$d930` | 狀態 5 的片尾模式、角色、cue 與捲動畫面粒子在 `$d8f3–$d92c`。狀態 8 的教學示範按鍵、時間與腳本指標在 `$d92d–$d930`。 |
| `$d932–$d933` | `wMinigamePaused` 只影響狀態 3 的更新分派，暫停時重用上一幀 OAM。多個畫面的初始化會設定 `wScreenPaletteId`，SGB palette 程式依它選資料。 |
| `$d954–$d955` | `wScreenFrameCounter`、`wScreenPhaseCounter` 供選單、過場、片尾、小遊戲、教學等流程計時。各流程依需要初始化，個別流程也會借用位元作動畫或階段標誌。 |
| `$d95c–$d95f` | `wFadeTransitionTimer` 在呼叫淡入淡出 helper 的畫面生效。`wMinigameResultFlag` 由小遊戲回合／結果處理讀寫，非零會阻止正常晉級。`wStateChangeParamLo`、`wStateChangeParamHi` 可保存返回選單的參數和請求類型，供 `RequestSavedMenuDestination` 取回。 |
| `$d969–$d974`、`$d97f–$d982` | 訊息解碼的來源、目的地、狀態、flags、代字、控制碼及打字計時。生命週期由 `StartMessageFar` 與 `UpdateMessageFar` 決定，畫面使用同一套訊息引擎。 |

### 關卡及地圖工作區

| 地址 | 生效範圍 |
| --- | --- |
| `$c0af` | `wPlayerActionMeter` 是飛鼠小新進入滑翔後的動作計量，`wFormActionTemp` 是同欄位的相容名稱。 |
| `$c0b7–$c0ba` | **Stage 1 頭目** `wStage1BossAttackPhase`、`wStage1BossWindupTimer`、`wStage1BossJumpVelocityLo`、`wStage1BossJumpVelocityHi`。**Stage 2 頭目** `wStage2BossBouncePhase`、`wStage2BossBounceVelocityLo`、`wStage2BossBounceVelocityHi`，略過 `$c0b8`。**Stage 3 頭目** `wStage3BossAttackPhase`、`wStage3BossAttackTimer`、`wStage3BossCoconutFallEnabled`、`wStage3BossNormalHitEnabled`。 |
| `$c408–$c40d` | `wCameraDeadzoneLeft`、`wCameraDeadzoneRight`、`wCameraDeadzoneTop`、`wCameraDeadzoneBottom`、`wCameraMaxStepX`、`wCameraMaxStepY` 是關卡初始化用的名稱。鏡頭更新用 `wCameraScreenLeftThreshold`、`wCameraScreenRightThreshold`、`wCameraScreenTopThreshold`、`wCameraScreenBottomThreshold`、`wCameraScrollStepX`、`wCameraScrollStepY` 讀取同一組值。 |
| `$c800` 起 | `wStageLayoutMap` 存放解壓後的關卡 metatile 頁面，也供選單、小遊戲和片尾載入圖資。SGB 邊框傳輸時改作 `wSgbBorderTilemapBuffer`（`$c800–$cfff`）和 `wSgbBorderPaletteBuffer`（`$d000–$d07f`）。 |
| `$c800`、`$c820` | 打字機訊息暫存當行字形。濁音與半濁音標記從 `$c800` 起，基本字形從 `wMessageLineBuffer`（`$c820`）起。 |
| `$da00`、`$da80` | Stage 1 的 `wStage1ClearedMetatileTiles` 提供清除 metatile 後的四格 tile；`wSequentialTilemapBuffer` 是未使用的連續 4×4 上傳 helper 的 16-byte 工作區。兩者都在地圖工作區的範圍內，地圖實際寫入長度隨關卡而變。 |

## HRAM 副程式暫存

相同位址可以在一次畫面更新中連續換用途。下表以設定欄位及消費該值的副程式界定範圍。

| 地址 | 生效流程 | 欄位 |
| --- | --- | --- |
| `$ffb3–$ffb6` | 玩家移動與教學示範 | `hPlayerVelYLo`、`hPlayerVelYHi` 和 `hPlayerMoveSpeedLo`、`hPlayerMoveSpeedHi`。相容名稱依序為 `hPlayerVelY`、`hPlayerVelYHigh`、`hPlayerSpeedX`、`hPlayerSpeedXHigh`。 |
| `$ffc5–$ffc6` | 矩形 VRAM queue、關卡物件生成、蟑螂小新動作 | `hVramRectDestLo`、`hVramRectDestHi` 為矩形目的地游標；`hSpawnRecordPtrLo`、`hSpawnRecordPtrHi` 指向正在處理的物件生成記錄；`hCockroachActionFramePtrLo`、`hCockroachActionFramePtrHi` 選蟑螂小新三段動作的圖格表。 |
| `$ffc9`、`$ffcb` | 地圖列／欄更新與其他 bank 0 helper | `hTileStreamWritePos` 和 `hTileStreamCount` 分別暫存 tile 串流位置與計數。前者也借作 RLEFF run 長度、十進位個位、訊息 descriptor 與部分 actor/tile selector。後者在關卡對話暫存進度，決定 speaker highlight 直接寫 VRAM 或送 queue。 |
| `$ffc9` | SGB 調色 | `hSgbColorScale` 只在產生漸層調色盤時保存目前比例。 |
| `$ffc9–$ffcb` | 標題或場景測試游標 | `hMenuCursorOptionCount`、`hMenuCursorDestLo`、`hMenuCursorDestHi` 為本次游標更新的選項數與 tilemap 指標。 |
| `$ffc9–$ffcb` | メケメケ和捉蟲的回合 HUD | `hMinigameTimerTiles` 為此次上傳組好的三個倒數數字 tile。 |
| `$ffca` | HUD、關卡對話、BONUS、滑跳 | `hDecimalTens` 為十進位十位。`hStageDialogueSpeakerMask` 為當次台詞的 speaker bits。`hBonusRoundTierScratch` 由 BONUS 子狀態 7 寫入輪次分級，實測領獎返回主關卡和從說明畫面進メケメケ時皆先被覆蓋。滑跳反彈時與 `$ffcb` 一起作 `hSlidePlatformDrawPtrLo`、`hSlidePlatformDrawPtrHi`。 |
| `$ffca` | 關卡物件投影及玩家踩地判定 | `hObjectScreenYHi` 暫存物件相對鏡頭的 Y 高 byte，`hPlayerGroundProbeY` 暫存兩腳探測的世界 Y 低 byte。 |
| `$ffcb–$ffcc` | 訊息 `FD` 代字 | `hMessageResumePtrLo`、`hMessageResumePtrHi` 保留原訊息的回復位置，展開完畢時清除高 byte。 |
| `$ffcb–$ffcd` | 玩家對物件的身體碰撞 | `hPlayerObjectProbeRangeX`、`hPlayerObjectProbeAbove`、`hPlayerObjectProbeBelow` 是此次探測的距離門檻。玩家對地圖 tile 的接觸判定另用 `$ffcd` 作 `hPlayerTileProbeCount`。 |
| `$ffc9–$ffcd` | メケメケ回合 | `hMekemekeLaneY`、`hMekemekeLaneIndex` 用於跑道與敵人更新；`hMekemekeVariantCount`、`hMekemekePrevVariantCount` 和 `hMekemekeSlotsRemaining` 用於選變種或迭代記錄。 |
| `$ffc9–$ffcc` | 捉蟲回合 | 生成蟲用 `hBugSpawnX`、`hBugSpawnY`、`hBugSpawnType`；捕捉用 `hBugCatchMinX`、`hBugCatchMinY`、`hBugCatchMaxX`、`hBugCatchMaxY`；危險物件用 `hBugHazardAimAbsX`、`hBugHazardAimAbsY`、`hBugHazardMetasprite`。 |
| `$ffce` | 場景動畫或關卡派對吹龍 | `hSceneAnimHeld` 由 `AnimateSceneMetasprite` 逐次呼叫設定並在 A 回傳。派對吹龍的攻擊判定另用 `hPartyHornReachBonus` 加大伸出時的攻擊距離。 |

## VBlank 與跨畫面常駐工作區

- **OAM**（`$c000–$c09f`）。畫面更新寫入 `wOamBuffer` 並推進 `hOamWritePos`。`hOamMaxY` 是各畫面設定的 metasprite 下緣裁切門檻。更新結束把位置存到 `hPrevOamPos`，並清掉多餘的 sprite。下一次一般 VBlank 執行 DMA。主關卡及小遊戲的暫停更新可用前次的 OAM 位置維持畫面。
- **VRAM queue**（起點 `$c100`）。畫面程式透過 `hVramQueuePos` 找 `wVramQueue` 的尾端。一般 VBlank 執行佇列後清首 byte 及尾端位置，再更新畫面狀態，讓下一幀的命令能重新累積。部分場景載入和主關卡重畫也會直接執行佇列。
- **顯示暫存值**（`hSCY` 至 `hWX`、`wLCDCShadow`、`wPaletteBGP`、`wPaletteOBP0`、`wPaletteOBP1`）。一般 VBlank 寫入捲動、視窗和 DMG 調色盤暫存值。高 byte 的捲動座標用於遊戲邏輯。LCD 控制暫存值由畫面初始化期間的 `ApplyLCDC` 寫入。
- **音效**。六筆 25-byte 的 `wSoundSlots` 從 `$dd00` 開始。每次更新一筆時，sequencer 將該筆複製到 `$ffe6–$fffe`，處理後寫回。VBlank 如果發現 `hVBlankBusy` 非零，會走重入音效路徑，不進行 DMA、VRAM queue 或畫面更新。

`$ffca` 的 BONUS 寫入及其他追蹤結果見 [symbol 整理紀錄](../notes/symbol_cleanup.md)。
