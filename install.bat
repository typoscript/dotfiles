@echo off
setlocal
echo =============================================
echo Dotfiles Windows Installation Launcher
echo =============================================

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Installation exited with code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)
