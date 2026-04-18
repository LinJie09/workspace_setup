#!/bin/bash

# =================================================================
# 🛠 macOS 核心環境一鍵引導腳本 (Senior Dynamic Edition)
# 邏輯：動態組合 URL -> 檢查 Brew -> 從 GitHub 下載清單 -> 執行安裝
# =================================================================

# --- 動態變數設定 ---
# 語法解釋：${VAR:-default} 代表如果變數 GH_USER 沒有設定，則預設使用 "ZhuangLinjie"
GITHUB_USER="${GH_USER:-ZhuangLinjie}" 
GITHUB_REPO="${GH_REPO:-mac-init}"
GITHUB_BRANCH="${GH_BRANCH:-main}"
BREWFILE_NAME="Brewfile.core"

# 自動合成 GitHub Raw 下載網址
# 記得加上 macOS/ 資料夾路徑
BREWFILE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/${BREWFILE_NAME}"

echo "🚀 開始執行環境安裝 (User: ${GITHUB_USER}, Repo: ${GITHUB_REPO})..."

# --- 1. 檢查 Homebrew 是否已安裝 ---
if ! command -v brew &> /dev/null; then
    echo "🍺 找不到 Homebrew，正在啟動安裝程序..."
    
    # 執行 Homebrew 官方安裝腳本
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 針對 Apple Silicon (M1/M2/M3) 與 Intel Mac 自動設定環境變數
    # 註解：這步是為了讓接下來的 brew 指令在當前視窗立刻生效，不需要重新開啟終端機
    if [[ -f /opt/homebrew/bin/brew ]]; then
        # Apple Silicon 路徑
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        # Intel 路徑
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew 已存在，準備檢查套件清單..."
fi

# --- 2. 下載遠端的 Brewfile.core ---
# 我們先檢查本地有沒有這份檔案，如果沒有，就從動態產生的 URL 下載
# --- 2. 下載遠端的 Brewfile.core ---
if [ ! -f "$BREWFILE_NAME" ]; then
    echo "📡 正在從網路獲取: ${BREWFILE_URL}"
    
    # 這裡直接將 curl 放入 if 判斷式中，符合 SC2181 的建議
    if ! curl -fsSL "$BREWFILE_URL" -o "$BREWFILE_NAME"; then
        echo "❌ 錯誤：網路連線異常，無法下載 Brewfile.core。"
        exit 1
    fi
    
    # 檢查內容是否為 404 (邏輯維持不變)
    if [[ $(head -n 1 "$BREWFILE_NAME") == "404"* ]]; then
        echo "❌ 錯誤：找不到遠端檔案，請檢查 GitHub 帳號或倉庫名稱是否正確。"
        rm "$BREWFILE_NAME"
        exit 1
    fi
fi

# --- 3. 執行安裝 ---
echo "📦 正在根據清單安裝 Node.js, Python, Git, VS Code..."
# --file: 指定使用的清單檔案名稱
brew bundle --file="$BREWFILE_NAME"

echo "✨ 環境部署完成！你現在可以開始開發了。"