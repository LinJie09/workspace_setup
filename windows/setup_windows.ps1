# =================================================================
# 🛠 Windows 核心環境一鍵引導腳本 (Senior Optimized)
# =================================================================

# --- 1. 動態變數設定 ---
$GitHubUser = if ($env:GH_USER) { $env:GH_USER } else { "ZhuangLinjie" }
$GitHubRepo = if ($env:GH_REPO) { $env:GH_REPO } else { "mac-init" }
$PackageListFile = "packages.txt"
$Url = "https://raw.githubusercontent.com/$GitHubUser/$GitHubRepo/main/windows/$PackageListFile"

Write-Host "🚀 開始執行 Windows 環境自動化安裝 (User: $GitHubUser)..." -ForegroundColor Cyan

# --- 2. 提升執行權限 ---
# 只有在 Windows 平台才執行權限提升
if ($IsWindows) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
}

# --- 3. 檢查 Winget 是否存在 ---
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ 錯誤：找不到 winget 指令。請確保已安裝應用程式安裝程式 (App Installer)。" -ForegroundColor Red
    return
}

# --- 4. 下載軟體清單 ---
if (-not (Test-Path $PackageListFile)) {
    Write-Host "📡 正在從 GitHub 獲取軟體清單..." -ForegroundColor Yellow
    try {
        # 使用 -UseBasicParsing 避免對 Internet Explorer 的相依性
        Invoke-WebRequest -Uri $Url -OutFile $PackageListFile -UseBasicParsing
    } catch {
        Write-Host "❌ 錯誤：無法從 $Url 下載清單。" -ForegroundColor Red
        return
    }
}

# --- 5. 執行安裝 ---
# 讀取內容並排除空白行
$apps = Get-Content $PackageListFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

foreach ($app in $apps) {
    # 清理每行可能存在的隱藏字元或空白
    $appId = $app.Trim()
    Write-Host "📦 正在處理: $appId ..." -ForegroundColor Green
    
    # 執行 Winget 安裝
    # --upgrade: 如果已經裝過，就嘗試更新到最新版
    winget install --id $appId --silent --accept-package-agreements --accept-source-agreements --upgrade
}

Write-Host "✨ Windows 環境部署完成！" -ForegroundColor Cyan