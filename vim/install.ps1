$ErrorActionPreference = "Stop"

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE

Write-Host "🚀 [Vim Setup] Initializing Windows installation..." -ForegroundColor Cyan

function Link-Or-Copy-Item {
    param (
        [string]$Src,
        [string]$Dest
    )

    if (-not (Test-Path -LiteralPath $Src)) {
        Write-Host "⚠️ Source not found: $Src (skipping)" -ForegroundColor Yellow
        return
    }

    $isDir = (Get-Item -LiteralPath $Src) -is [System.IO.DirectoryInfo]

    if (Test-Path -LiteralPath $Dest) {
        $destItem = Get-Item -LiteralPath $Dest -Force -ErrorAction SilentlyContinue
        $isLinked = $false

        # 이미 심볼릭 링크나 Junction으로 정상 연결되어 있는지 확인 (멱등성 보장)
        if ($destItem.LinkType -in @('SymbolicLink', 'Junction')) {
            $currentTarget = if ($destItem.Target -is [array]) { $destItem.Target[0] } else { $destItem.Target }
            if ($currentTarget) {
                $resolvedCurrent = try { (Resolve-Path -LiteralPath $currentTarget -ErrorAction Stop).Path } catch { $currentTarget }
                $resolvedSrc = try { (Resolve-Path -LiteralPath $Src -ErrorAction Stop).Path } catch { $Src }
                if ($resolvedCurrent -eq $resolvedSrc) {
                    $isLinked = $true
                }
            }
        } elseif (-not $isDir) {
            # 파일이 복사(Copy)된 상태인 경우 내용이 동일하면 건너뜀
            $hashSrc = (Get-FileHash -LiteralPath $Src).Hash
            $hashDest = (Get-FileHash -LiteralPath $Dest).Hash
            if ($hashSrc -eq $hashDest) {
                Write-Host "ℹ️  Already up to date: $Dest" -ForegroundColor Cyan
                return
            }
        }

        if ($isLinked) {
            Write-Host "ℹ️  Already linked: $Dest -> $Src" -ForegroundColor Cyan
            return
        }

        # 기존 파일 또는 디렉터리 백업 (.bak)
        $bak = "$Dest.bak"
        if (Test-Path -LiteralPath $bak) {
            Remove-Item -LiteralPath $bak -Recurse -Force
        }
        Move-Item -LiteralPath $Dest -Destination $bak -Force
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
                Copy-Item -LiteralPath $Src -Destination $Dest -Force
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
