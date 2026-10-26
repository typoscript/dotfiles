$ErrorActionPreference = "Stop"

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE

Write-Host "🚀 [Vim Setup] Initializing Windows installation..." -ForegroundColor Cyan

function Link-Or-Copy-Item {
    param (
        [string]$Src,
        [string]$Dest
    )

    if (-not (Test-Path $Src)) {
        Write-Host "⚠️ Source not found: $Src (skipping)" -ForegroundColor Yellow
        return
    }

    $isDir = (Get-Item $Src) -is [System.IO.DirectoryInfo]

    if (Test-Path $Dest) {
        $bak = "$Dest.bak"
        if (Test-Path $bak) {
            Remove-Item $bak -Recurse -Force
        }
        Move-Item -Path $Dest -Destination $bak -Force
        Write-Host "📦 Backed up existing $Dest to $bak" -ForegroundColor Gray
    }

    try {
        if ($isDir) {
            # 디렉터리는 심볼릭 링크 시도 후 실패 시 Junction으로 안전하게 연결 (Junction은 관리자 권한 불필요)
            try {
                New-Item -ItemType SymbolicLink -Path $Dest -Target $Src -Force -ErrorAction Stop | Out-Null
                Write-Host "🔗 Linked directory $Src -> $Dest (Symlink)" -ForegroundColor Green
            } catch {
                New-Item -ItemType Junction -Path $Dest -Target $Src -Force -ErrorAction Stop | Out-Null
                Write-Host "🔗 Linked directory $Src -> $Dest (Junction)" -ForegroundColor Green
            }
        } else {
            # 파일은 심볼릭 링크 시도 후 실패 시 복사
            try {
                New-Item -ItemType SymbolicLink -Path $Dest -Target $Src -Force -ErrorAction Stop | Out-Null
                Write-Host "🔗 Linked file $Src -> $Dest (Symlink)" -ForegroundColor Green
            } catch {
                Copy-Item -Path $Src -Destination $Dest -Force
                Write-Host "📦 Copied file $Src -> $Dest (Fallback Copy)" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "❌ Failed to link/copy $Src -> $Dest : $_" -ForegroundColor Red
    }
}

# 1. ~/.vimrc & ~/_vimrc
Link-Or-Copy-Item (Join-Path $Dir ".vimrc") (Join-Path $UserHome ".vimrc")
Link-Or-Copy-Item (Join-Path $Dir ".vimrc") (Join-Path $UserHome "_vimrc")

# 2. ~/.ideavimrc & ~/_ideavimrc
Link-Or-Copy-Item (Join-Path $Dir ".ideavimrc") (Join-Path $UserHome ".ideavimrc")
Link-Or-Copy-Item (Join-Path $Dir ".ideavimrc") (Join-Path $UserHome "_ideavimrc")

# 3. ~/.vim & ~/vimfiles
Link-Or-Copy-Item (Join-Path $Dir ".vim") (Join-Path $UserHome ".vim")
Link-Or-Copy-Item (Join-Path $Dir ".vim") (Join-Path $UserHome "vimfiles")

Write-Host "🎉 Vim setup completed successfully!" -ForegroundColor Green
