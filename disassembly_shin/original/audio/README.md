# 原版音樂與聲部索引

[音樂索引](music_cues.csv) 收錄原版以固定 ID 呼叫四聲道播放的 19 組 cue，含靜音組。
`cue` 和 `usage` 依遊戲用途命名。`source_symbols` 列出原版呼叫位置的入口，`|` 分隔共用同一組 ID 的入口。

| 場景 | 播放起始 ID | 原版入口 |
| --- | --- | --- |
| 標題與標題選單 | `$28` | `InitTitleMenuPresentation` |
| 野餐、學校、百貨 | `$04` | `SelectGameplayMusic` |
| 關島 | `$08` | `SelectGameplayMusic` |
| 教學 | `$20` | `InitTutorialDemo` |
| 動感超人變身 | `$0c` | `SelectGameplayMusic` 先檢查目前變身 |
| 四關頭目 | `$60` | `StartStageBossCountdownAtRightEdge` |
| 一般與捲動片尾 | `$3c` | `InitEndingScreen` 在分派兩種片尾前選曲 |

`PlaySound_Queue3` 從 `play_id` 開始連續排入四個 ID。索引每個聲部欄位都列出該聲部的 ID
與原版音軌 label。例如標題的脈衝一聲部是 `0x28 AudioTrack_7092`，音軌來源在
[`tracks/track_7092.asm`](tracks/track_7092.asm)。

| 聲部欄位 | 硬體聲道編號 | 音序器槽位 offset |
| --- | ---: | ---: |
| `pulse_1` | 0 | `$32` |
| `pulse_2` | 1 | `$4b` |
| `wave` | 2 | `$64` |
| `noise` | 3 | `$7d` |

靜音組的 `$18`～`$1b` 都指向只含 header 和結束指令的
[`AudioTrack_6c9b`](tracks/track_6c9b.asm)。其餘播放 ID 也可在完整的
[sound_ids.csv](sound_ids.csv) 查槽位與音軌。音序器實際組譯 [sound_data.asm](sound_data.asm) 及原生音軌。
