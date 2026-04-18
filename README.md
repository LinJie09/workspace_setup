# 🚀 Workspace Setup

自動化初始化 macOS 與 Windows 開發環境的一鍵設定腳本，快速建立一致的開發環境。

---

## 📋 目錄

- [功能介紹](#-功能介紹)
- [安裝方式](#-安裝方式)
  - [macOS](#-macos)
  - [Windows](#-windows)
- [注意事項](#-注意事項)
- [貢獻方式](#-貢獻方式)

---

## ✨ 功能介紹

- 🍎 支援 macOS 環境自動化初始化
- 🪟 支援 Windows 環境自動化初始化
- ⚡ 一行指令完成環境建置
- 🔧 安裝常用開發工具與套件

---

## 📦 安裝方式

### 🍎 macOS

開啟終端機（Terminal），執行以下指令：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ZhuangLinjie/mac-init/main/macOS/core_setup.sh)"
```

---

### 🪟 Windows

以**系統管理員身分**開啟 PowerShell，執行以下指令：

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb https://raw.githubusercontent.com/ZhuangLinjie/mac-init/main/windows/setup_windows.ps1 | iex
```

> ⚠️ 請確認以「系統管理員身分執行」PowerShell，否則可能因權限不足而失敗。

---

## ⚠️ 注意事項

- 執行前請確認網路連線正常
- 安裝過程中可能需要輸入系統密碼（macOS）或確認 UAC 提示（Windows）
- 建議在乾淨的系統環境下執行，以避免設定衝突
- 腳本內容皆為開源，執行前可至 [GitHub](https://github.com/ZhuangLinjie/mac-init) 查閱原始碼

---

## 🤝 貢獻方式

歡迎提交 Issue 或 Pull Request！

1. Fork 此專案
2. 建立你的 Feature Branch：`git checkout -b feature/your-feature`
3. 提交你的修改：`git commit -m 'Add some feature'`
4. 推送到 Branch：`git push origin feature/your-feature`
5. 開啟 Pull Request

---

## 📄 授權

本專案採用 [MIT License](LICENSE) 授權。