# Complete DApp Launcher Script
# Starts blockchain node, deploys contracts, and opens the DApp

Write-Host ""
Write-Host "========================================"
Write-Host "  COMPLETE DAPP LAUNCHER"
Write-Host "========================================"
Write-Host ""

$scriptPath = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
Set-Location $scriptPath

if (-not (Test-Path "frontend")) {
    Write-Host "Error: Frontend directory not found" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Starting blockchain node..." -ForegroundColor Green
$nodeCmd = "Write-Host 'Blockchain Node - Keep this window open!' -ForegroundColor Cyan; npm run node"
Start-Process powershell -ArgumentList "-NoExit","-Command",$nodeCmd

Start-Sleep -Seconds 8

Write-Host "Deploying contracts..." -ForegroundColor Green
$deployCmd = "Write-Host 'Deploying Contracts' -ForegroundColor Cyan; npm run deploy; Read-Host 'Press Enter to close'"
Start-Process powershell -ArgumentList "-NoExit","-Command",$deployCmd

Start-Sleep -Seconds 10

Write-Host "Starting frontend server..." -ForegroundColor Green
$frontendPath = Join-Path $scriptPath "frontend"
$serverCmd = "Set-Location '$frontendPath'; Write-Host 'Server at http://localhost:8000' -ForegroundColor Green; npx http-server -p 8000"
Start-Process powershell -ArgumentList "-NoExit","-Command",$serverCmd

Start-Sleep -Seconds 3

Write-Host "Opening browser..." -ForegroundColor Green
Start-Process "http://localhost:8000"

Write-Host ""
Write-Host "========================================"
Write-Host "  DAPP IS RUNNING!"
Write-Host "========================================"
Write-Host ""
Write-Host "Services:" -ForegroundColor Cyan
Write-Host "  - Blockchain: localhost:8545"
Write-Host "  - Frontend: http://localhost:8000"
Write-Host ""
Write-Host "Keep all 3 windows open!" -ForegroundColor Yellow
Write-Host ""
