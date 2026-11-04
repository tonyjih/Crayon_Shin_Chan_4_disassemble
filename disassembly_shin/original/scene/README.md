# 場景動畫與結局演出

`../data/scene_animations.asm` 保留原版順序中的 73 段動畫：291 個 frame pairs、45 個 loop、
28 個 hold。部分 label 指向共用的中途入口；兩個 hold 後面遺留的 word 也保留在來源。
播放器是 `../engine/scene_animation.asm` 的 `AnimateSceneMetasprite`。

```asm
SceneExample:
    scene_frame 12, $02
    scene_frame 8, $03, SCENE_ANIM_FLIP
    scene_loop SceneExample
```

`scene_frame` 寫入「時間／水平翻轉、bank 3 metasprite ID」兩個 bytes；
翻轉使用時間 byte 的 bit 7。時間須為 1～127，翻轉時上限為 125，避免碰到保留的 `$fe/$ff`。
metasprite ID 必須小於 `$f2`；bank 3 的實際指標表也會核對這個筆數。

`scene_loop` 寫 `$ff, target_lo, target_hi`，目標須在相同 ROM bank，且由 frame pair 開始。
`scene_hold` 只寫一個 `$fe`，保持上一個 frame；它沒有 pointer 參數，也不會讀取後面的 word。
原版兩個遺留 word 是明確的 `dw`，不當作有效 loop。

呼叫時 B 是畫面 Y、C 是畫面 X、DE 指向三-byte state：下一個指令的 pointer lo/hi，
以及目前的倒數時間／翻轉 bit。播放器使用目前 bank 的腳本，繪圖時暫切 bank 3 再還原。
回傳 A=1 表示停在 hold，A=0 表示仍在播放。畫面系統不只讀取這個 state，也可能重用或直接操作其 timer。

結局另外拆成 `../engine/ending.asm`、`../data/ending.asm`，變數別名在 `../ram/ending.inc`。
這些別名只用於 state 5；其他場景會重用相同 WRAM。

| 資料 | 格式與作用 |
| --- | --- |
| `wSceneAnim0PtrLo` 起的 12 bytes | 四筆三-byte animation state |
| `wEndingActors` | 四筆兩-byte record：X、動畫 hold 結果 |
| `wEndingCueIndex`／`wEndingCue` | 下個 cue 的索引，以及複製到 RAM 的 24-byte cue |
| `EndingCueRecords` | 三個 X 門檻、一個未確認 reader 的 byte，接著五組四個動畫 selector；`$ff` 保留現有動畫 |
| `wEndingParticles` | scrolling 結局的八筆 X、Y、age |
| `wEndingSceneDelay`／`wEndingSecondaryOffset` | 同為 `$d956`，main 結局是延遲 counter，alternate 結局是第二角色的位移 |

三段 cue 由 credits 訊息 `$50`、`$53`、`$56` 觸發；原表第四個 `$8e` 門檻和 cue 的未讀欄位照原樣保留。
此輪依 consumer 補上 33 個內部跳轉名稱；仍只有地址名稱的動畫，尚未逐段確認畫面角色／動作。

`make check-original` 會實際組譯 macro fixtures，核對翻轉、loop word、hold 及遺留 word，
並拒絕無效時間、metasprite ID、翻轉 flag 與跨 bank 的 loop，最後核對完整 ROM MD5。
