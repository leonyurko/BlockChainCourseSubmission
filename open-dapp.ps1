# Quick DApp Launcher Script
# This script opens the DApp in Chrome (or default browser) with a local server
#
# If you get an execution policy error, run this first:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Write-Host "Starting DApp..." -ForegroundColor Cyan

# Get the script's directory and navigate to frontend
$scriptPath = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$frontendPath = Join-Path $scriptPath "frontend"

# Verify frontend directory exists
if (-not (Test-Path $frontendPath)) {
    Write-Host "Error: Frontend directory not found at $frontendPath" -ForegroundColor Red
    Write-Host "Please ensure you're running this script from the project root directory." -ForegroundColor Yellow
    pause
    exit 1
}

Set-Location $frontendPath
Write-Host "Changed directory to: $frontendPath" -ForegroundColor Green

Write-Host "Starting local HTTP server on port 8000..." -ForegroundColor Yellow

# Start HTTP server in background
Start-Process powershell -ArgumentList '-NoExit', '-Command', "Write-Host 'HTTP Server Running on http://localhost:8000' -ForegroundColor Green; Write-Host 'Press Ctrl+C to stop' -ForegroundColor Yellow; npx http-server -p 8000"

# Wait a moment for server to start
Start-Sleep -Seconds 3

Write-Host "Opening DApp in browser..." -ForegroundColor Green

# Try to open in Chrome first, then fall back to default browser
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    Start-Process $chromePath -ArgumentList "http://localhost:8000"
    Write-Host "Opened in Chrome" -ForegroundColor Green
} else {
    Start-Process "http://localhost:8000"
    Write-Host "Opened in default browser" -ForegroundColor Green
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "DApp is now running at: http://localhost:8000" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Install MetaMask extension (https://metamask.io)" -ForegroundColor White
Write-Host "   2. Add Localhost network (Chain ID: 31337)" -ForegroundColor White
Write-Host "   3. Import test account with private key from RUNNING_STATUS.md" -ForegroundColor White
Write-Host "   4. Connect wallet in the DApp" -ForegroundColor White
Write-Host ""
Write-Host "See METAMASK_TROUBLESHOOTING.md for detailed help" -ForegroundColor Cyan
