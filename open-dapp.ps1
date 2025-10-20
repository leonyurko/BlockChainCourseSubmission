# ===================================================================
# Complete DApp Launcher Script
# ===================================================================
# This script starts the blockchain node, deploys contracts, and opens the DApp
#
# If you get an execution policy error, run this first:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# ===================================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🚀 COMPLETE DAPP LAUNCHER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get the script's directory
$scriptPath = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
Set-Location $scriptPath

# Verify project structure
if (-not (Test-Path "frontend")) {
    Write-Host "❌ Error: Frontend directory not found" -ForegroundColor Red
    Write-Host "Please ensure you're running this script from the project root directory." -ForegroundColor Yellow
    pause
    exit 1
}

if (-not (Test-Path "package.json")) {
    Write-Host "❌ Error: package.json not found" -ForegroundColor Red
    Write-Host "Please ensure you're in the correct project directory." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "✅ Project structure verified" -ForegroundColor Green
Write-Host ""

# Step 1: Start Hardhat Node
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "STEP 1/3: Starting Hardhat Blockchain Node..." -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$nodeWindow = Start-Process powershell -ArgumentList @(
    '-NoExit',
    '-Command',
    "Write-Host '🔗 Hardhat Blockchain Node' -ForegroundColor Cyan; Write-Host 'Keep this window open!' -ForegroundColor Yellow; Write-Host ''; npm run node"
) -PassThru -WindowStyle Normal

Write-Host "✅ Blockchain node started in separate window" -ForegroundColor Green
Write-Host "⏳ Waiting 8 seconds for node to initialize..." -ForegroundColor Cyan

Start-Sleep -Seconds 8

# Step 2: Deploy Contracts
Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "STEP 2/3: Deploying Smart Contracts..." -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$deployWindow = Start-Process powershell -ArgumentList @(
    '-NoExit',
    '-Command',
    "Write-Host '📝 Deploying Contracts to Local Blockchain' -ForegroundColor Cyan; Write-Host ''; npm run deploy; Write-Host ''; Write-Host '✅ Deployment Complete! You can close this window.' -ForegroundColor Green; Write-Host 'Press any key to close...'; `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')"
) -PassThru -WindowStyle Normal

Write-Host "✅ Deployment started in separate window" -ForegroundColor Green
Write-Host "⏳ Waiting 10 seconds for deployment to complete..." -ForegroundColor Cyan

Start-Sleep -Seconds 10

# Step 3: Start HTTP Server and Open Browser
Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "STEP 3/3: Starting Frontend Server..." -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$frontendPath = Join-Path $scriptPath "frontend"
$serverWindow = Start-Process powershell -ArgumentList @(
    '-NoExit',
    '-Command',
    "Set-Location '$frontendPath'; Write-Host '🌐 HTTP Server Running on http://localhost:8000' -ForegroundColor Green; Write-Host 'Keep this window open!' -ForegroundColor Yellow; Write-Host 'Press Ctrl+C to stop the server' -ForegroundColor Cyan; Write-Host ''; npx http-server -p 8000"
) -PassThru -WindowStyle Normal

Write-Host "✅ Frontend server started" -ForegroundColor Green
Write-Host "⏳ Waiting 3 seconds for server to start..." -ForegroundColor Cyan

Start-Sleep -Seconds 3

# Open Browser
Write-Host ""
Write-Host "🌐 Opening DApp in browser..." -ForegroundColor Cyan

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    Start-Process $chromePath -ArgumentList "http://localhost:8000"
    Write-Host "✅ Opened in Chrome" -ForegroundColor Green
} else {
    Start-Process "http://localhost:8000"
    Write-Host "✅ Opened in default browser" -ForegroundColor Green
}

# Final Instructions
Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  ✅ DAPP IS NOW RUNNING!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "📊 Services Running:" -ForegroundColor Cyan
Write-Host "   🔗 Blockchain Node: localhost:8545" -ForegroundColor White
Write-Host "   🌐 Frontend Server: http://localhost:8000" -ForegroundColor White
Write-Host ""
Write-Host "📝 MetaMask Setup:" -ForegroundColor Yellow
Write-Host "   1. Install MetaMask extension (https://metamask.io)" -ForegroundColor White
Write-Host "   2. Add Network: Localhost 8545" -ForegroundColor White
Write-Host "      - Network Name: Localhost 8545" -ForegroundColor Gray
Write-Host "      - RPC URL: http://127.0.0.1:8545" -ForegroundColor Gray
Write-Host "      - Chain ID: 31337" -ForegroundColor Gray
Write-Host "      - Currency: ETH" -ForegroundColor Gray
Write-Host "   3. Import Test Account with this private key:" -ForegroundColor White
Write-Host "      0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" -ForegroundColor Gray
Write-Host "   4. Connect wallet in the DApp" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Important:" -ForegroundColor Red
Write-Host "   - Keep all 3 terminal windows open" -ForegroundColor Yellow
Write-Host "   - To stop: Close all terminal windows or press Ctrl+C in each" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎉 Happy testing!" -ForegroundColor Green
Write-Host ""
