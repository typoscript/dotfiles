$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "🚀 Dotfiles Full Installation (Windows)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# 1. Shell 설정 설치 (PowerShell $PROFILE & CMD doskey)
if (Test-Path (Join-Path $ScriptDir "shell\install.ps1")) {
    & (Join-Path $ScriptDir "shell\install.ps1")
    Write-Host ""
}

# 2. Vim 설정 설치 (~/.vimrc, ~/.ideavimrc, ~/.vim)
if (Test-Path (Join-Path $ScriptDir "vim\install.ps1")) {
    & (Join-Path $ScriptDir "vim\install.ps1")
    Write-Host ""
}

# 3. Antigravity 설정 설치 (statusline.py, settings.json, rules.md)
if (Test-Path (Join-Path $ScriptDir "antigravity\install.ps1")) {
    & (Join-Path $ScriptDir "antigravity\install.ps1")
    Write-Host ""
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "🎉 All installations completed successfully!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
