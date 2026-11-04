# 蠟筆小新 4：原版 matching disassembly

預設建置原版日版／SGB ROM，大小 131,072 bytes，MD5：

```text
BCB3D47C291FD0A26B2C7B1082C3AD88
```

```powershell
make
make check-original
```

沒有 Make 也可直接執行：

```powershell
python -B tools/build_original.py
```

輸出是 `build/original/game.gb`，另有 `game.sym`、`game.map`。建置會從 PNG
產生 tile data，重新壓縮圖片／地圖、編譯原生音軌，最後驗證 ROM 大小與 MD5。
建置不讀取原始 ROM，不依賴 Git 歷史或舊的壓縮檔。

需要 Python 3.10+ 和 RGBDS **1.0.1**；版本記在 `.rgbds-version`。
工具會先找專案上一層的 `rgbasm.exe`、`rgblink.exe`、`rgbfix.exe`、`rgbgfx.exe`，再找 PATH。
建置前會核對四個工具的版本；版本不符、混用版本或工具無法執行時會停止，尚未開始產生資產。
Linux 環境若只有 `python3`，可執行 `make check-original PYTHON=python3`。

GitHub Actions 的 [Original ROM workflow](../.github/workflows/original.yml) 會在 `master` push、
PR 或手動執行時，以 Python 3.12 和同版官方 RGBDS Linux 套件執行 `make check-original`。
套件下載另核對 SHA-256。未來升級 RGBDS 時，需同步更新版本檔及 workflow 的套件雜湊。

## 原版來源

- `original/bank_000.asm`～`bank_007.asm`：原版 ROM 配置及尚未拆分的程式／資料；已補齊直接分支與 dispatch table 的 symbol。
- `original/engine/`：已確認的音效、訊息與 SGB 系統；bank 檔依原版順序 INCLUDE，維持地址不變。
- `original/data/`：上述系統的波形、查表、SGB 傳輸資料及文字 descriptor。
- `original/text/`、`original/charmap.inc`：可直接組譯的日文訊息／DEBUG 文字、原生文字控制碼及字碼對照。
- `original/ram/objects.asm`：stage object 的實際 WRAM 配置、16-byte 欄位 offset 及容量／邊界檢查。
- `original/gfx/`：55 張可編輯 PNG；包含未壓縮 tile、解壓後 tile、1bpp SGB 邊框。
- `original/levels/`：五個關卡的解壓地圖、metatile、碰撞資料、物件 CSV。
- `original/maps/`、`original/sgb/`：選單／小遊戲 tilemap、SGB 邊框 tilemap。
- `original/audio/`：105 筆音效索引、102 段原生音軌／音效指令、四個波形。
- `original/assets.json`：資產來源、原版位置、壓縮格式及尺寸清單。

資產格式與位元組對應方式見 [original/README.md](original/README.md)。

`make clean` 與 `make clean-original` 都只刪除 `build/original/`，不刪除來源資料。

## 分支與來源

`master` 保存原版 matching disassembly；彩色化工作位於 `DX` 分支。
此分支的 release 建置只讀取 `original/`，根目錄早期 bank、Tiled 與工具資料保留供歷史工作流程參考。
本次 symbol 整理與仍待確認的用途見 [整理紀錄](original/notes/symbol_cleanup.md)。
