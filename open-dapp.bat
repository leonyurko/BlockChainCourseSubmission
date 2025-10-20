@echo off
REM Quick DApp Launcher - Batch File Version
REM This batch file runs the PowerShell script with execution policy bypass

echo Starting DApp launcher...
echo.

REM Run the PowerShell script with bypass execution policy
powershell.exe -ExecutionPolicy Bypass -File "%~dp0open-dapp.ps1"

REM Keep window open if there was an error
if errorlevel 1 (
    echo.
    echo An error occurred. Press any key to exit...
    pause > nul
)
