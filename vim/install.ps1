$ErrorActionPreference = "Stop"

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE
. (Join-Path $Dir "..\lib\common.ps1")

Write-Host "🚀 [Vim Setup] Initializing Windows installation..." -ForegroundColor Cyan

# 1. ~/.vimrc & ~/_vimrc
Install-Link (Join-Path $Dir ".vimrc") (Join-Path $UserHome ".vimrc")
Install-Link (Join-Path $Dir ".vimrc") (Join-Path $UserHome "_vimrc")

# 2. ~/.ideavimrc & ~/_ideavimrc
Install-Link (Join-Path $Dir ".ideavimrc") (Join-Path $UserHome ".ideavimrc")
Install-Link (Join-Path $Dir ".ideavimrc") (Join-Path $UserHome "_ideavimrc")

# 3. ~/.vim & ~/vimfiles
Install-Link (Join-Path $Dir ".vim") (Join-Path $UserHome ".vim")
Install-Link (Join-Path $Dir ".vim") (Join-Path $UserHome "vimfiles")

Write-Host "🎉 Vim setup completed successfully!" -ForegroundColor Green
