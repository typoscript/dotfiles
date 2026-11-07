# ==============================================================================
# 공통 설치 헬퍼 (Windows) - 각 <tool>\install.ps1 에서 dot-source 해서 사용
#   . (Join-Path $Dir "..\lib\common.ps1")
#
# 백업 원칙 (lib/common.sh 와 동일):
#   - 기존 백업(.bak)은 절대 삭제/덮어쓰지 않는다.
#     .bak 이 이미 있으면 .bak.<타임스탬프> 로 새로 만든다.
#   - 이미 올바르게 연결/복사된 경우 아무것도 하지 않는다 (멱등성).
#   - 대상이 깨진(dangling) 링크면 보존할 데이터가 없으므로 링크만 제거한다.
# ==============================================================================

function Get-ItemOrNull {
    param([string]$Path)
    # Test-Path 는 깨진 링크를 $false 로 판단하므로 Get-Item -Force 로 확인
    return Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
}

function Resolve-FullPath {
    param([string]$Path)
    try {
        return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath.TrimEnd('\')
    } catch {
        return $null
    }
}

# 링크(SymbolicLink/Junction)면 절대 경로 타깃, 아니면 $null
function Get-LinkTargetPath {
    param($Item)
    if ($Item.LinkType -notin @('SymbolicLink', 'Junction')) { return $null }
    $target = if ($Item.Target -is [array]) { $Item.Target[0] } else { $Item.Target }
    if (-not $target) { return $null }
    if (-not [System.IO.Path]::IsPathRooted($target)) {
        $target = Join-Path (Split-Path -Parent $Item.FullName) $target
    }
    return $target
}

function Get-FreeBackupPath {
    param([string]$Path)
    $bak = "$Path.bak"
    if ($null -eq (Get-ItemOrNull $bak)) { return $bak }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $bak = "$Path.bak.$stamp"
    $n = 1
    while ($null -ne (Get-ItemOrNull $bak)) {
        $bak = "$Path.bak.$stamp.$n"
        $n++
    }
    return $bak
}

function Backup-Existing {
    param([string]$Path)
    $item = Get-ItemOrNull $Path
    if ($null -eq $item) { return }

    $linkTarget = Get-LinkTargetPath $item
    if ($linkTarget -and $null -eq (Resolve-FullPath $linkTarget)) {
        # 깨진 링크: 링크 자체만 삭제 (Remove-Item -Recurse 는 Junction 대상까지 지울 수 있어 사용하지 않음)
        if ($item.PSIsContainer) { [System.IO.Directory]::Delete($item.FullName) }
        else { [System.IO.File]::Delete($item.FullName) }
        Write-Host "🧹 Removed dangling link $Path -> $linkTarget" -ForegroundColor Gray
        return
    }

    $bak = Get-FreeBackupPath $Path
    Move-Item -LiteralPath $Path -Destination $bak
    Write-Host "📦 Backed up existing $Path to $bak" -ForegroundColor Gray
}

# 심볼릭 링크 생성. 권한이 없으면 디렉터리는 Junction, 파일은 Copy 로 Fallback.
function Install-Link {
    param(
        [string]$Src,
        [string]$Dest
    )

    if (-not (Test-Path -LiteralPath $Src)) {
        Write-Host "⚠️ Source not found: $Src (skipping)" -ForegroundColor Yellow
        return
    }

    $srcFull = Resolve-FullPath $Src
    $isDir = (Get-Item -LiteralPath $Src) -is [System.IO.DirectoryInfo]
    $destItem = Get-ItemOrNull $Dest

    if ($null -ne $destItem) {
        $linkTarget = Get-LinkTargetPath $destItem
        if ($linkTarget) {
            if ((Resolve-FullPath $linkTarget) -eq $srcFull) {
                Write-Host "ℹ️  Already linked: $Dest -> $Src" -ForegroundColor Cyan
                return
            }
        } elseif (-not $isDir -and -not $destItem.PSIsContainer) {
            # Fallback Copy 로 설치된 파일이 최신이면 건너뜀
            if ((Get-FileHash -LiteralPath $Src).Hash -eq (Get-FileHash -LiteralPath $Dest).Hash) {
                Write-Host "ℹ️  Already up to date: $Dest" -ForegroundColor Cyan
                return
            }
        }
        Backup-Existing $Dest
    }

    $parent = Split-Path -Parent $Dest
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Dest -Target $Src -ErrorAction Stop | Out-Null
        Write-Host "🔗 Linked $Src -> $Dest (Symlink)" -ForegroundColor Green
    } catch {
        if ($isDir) {
            # Junction 은 관리자 권한/개발자 모드 불필요
            New-Item -ItemType Junction -Path $Dest -Target $Src -ErrorAction Stop | Out-Null
            Write-Host "🔗 Linked $Src -> $Dest (Junction)" -ForegroundColor Green
        } else {
            Copy-Item -LiteralPath $Src -Destination $Dest -Force
            Write-Host "📦 Copied $Src -> $Dest (Fallback Copy)" -ForegroundColor Yellow
        }
    }
}
