# =================================================================
# Windows Core Environment Setup Script (Senior Optimized)
# =================================================================

# --- 1. Dynamic Variables Configuration ---
$GitHubUser = if ($env:GH_USER) { $env:GH_USER } else { "LinJie09" }
$GitHubRepo = if ($env:GH_REPO) { $env:GH_REPO } else { "workspace_setup" }
$PackageListFile = "packages.txt"
$Url = "https://raw.githubusercontent.com/$GitHubUser/$GitHubRepo/main/windows/$PackageListFile"

Write-Host "Starting Windows environment automation setup (User: $GitHubUser)..." -ForegroundColor Cyan

# --- 2. Elevate Execution Policy ---
# Only execute on Windows platforms
if ($IsWindows) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
}

# --- 3. Check if Winget exists ---
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: winget not found. Please ensure 'App Installer' is installed." -ForegroundColor Red
    return
}

# --- 4. Download Package List ---
if (-not (Test-Path $PackageListFile)) {
    Write-Host "Fetching package list from GitHub..." -ForegroundColor Yellow
    try {
        # Use -UseBasicParsing to avoid Internet Explorer dependencies
        Invoke-WebRequest -Uri $Url -OutFile $PackageListFile -UseBasicParsing
    } catch {
        Write-Host "Error: Failed to download package list from $Url." -ForegroundColor Red
        return
    }
}

# --- 5. Execution ---
# Read content and exclude empty lines
$apps = Get-Content $PackageListFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

foreach ($app in $apps) {
    # Trim potential hidden characters or whitespace
    $appId = $app.Trim()
    Write-Host "Processing: $appId ..." -ForegroundColor Green
    
    # Run Winget install
    # --upgrade: Attempt to upgrade if already installed
    winget install --id $appId --silent --accept-package-agreements --accept-source-agreements --upgrade
}

Write-Host "Windows environment deployment completed!" -ForegroundColor Cyan