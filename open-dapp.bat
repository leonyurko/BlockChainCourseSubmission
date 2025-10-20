@echo off
REM ===================================================================
REM Complete DApp Launcher - Batch File Version
REM ===================================================================
REM This batch file runs the PowerShell script with execution policy bypass
REM It will start the blockchain node, deploy contracts, and open the DApp
REM ===================================================================

echo.
echo ========================================
echo   COMPLETE DAPP LAUNCHER
echo ========================================
echo.
echo Starting all services...
echo.

REM Run the PowerShell script with bypass execution policy
powershell.exe -ExecutionPolicy Bypass -File "%~dp0open-dapp.ps1"

REM Keep window open if there was an error
if errorlevel 1 (
    echo.
    echo An error occurred. Press any key to exit...
    pause > nul
)
