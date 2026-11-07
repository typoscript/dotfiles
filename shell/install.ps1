$ErrorActionPreference = "Stop"

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE
$ConfigShellDir = Join-Path $UserHome ".config\shell"

Write-Host "🚀 [Shell Setup] Initializing Windows installation..." -ForegroundColor Cyan

if (-not (Test-Path $ConfigShellDir)) {
    New-Item -ItemType Directory -Path $ConfigShellDir -Force | Out-Null
}

# 1. PowerShell 별칭 복사 및 $PROFILE 등록
$AliasesPs1Src = Join-Path $Dir "aliases.ps1"
$AliasesPs1Dest = Join-Path $ConfigShellDir "aliases.ps1"
Copy-Item -Path $AliasesPs1Src -Destination $AliasesPs1Dest -Force
Write-Host "📦 Copied aliases.ps1 -> $AliasesPs1Dest" -ForegroundColor Green

# PowerShell 프로필에 소싱 추가
# Windows PowerShell 5.1 과 PowerShell 7(pwsh) 은 프로필 경로가 다르므로 둘 다 등록
# (문서 폴더가 OneDrive 등으로 리디렉션된 경우도 고려해 MyDocuments 경로 사용)
$Documents = [Environment]::GetFolderPath('MyDocuments')
$ProfilePaths = @(
    (Join-Path $Documents "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"),
    (Join-Path $Documents "PowerShell\Microsoft.PowerShell_profile.ps1")
)

$SourceLine = ". `"$AliasesPs1Dest`""
foreach ($ProfilePath in $ProfilePaths) {
    $ProfileDir = Split-Path -Parent $ProfilePath
    if (-not (Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }

    if (-not (Test-Path $ProfilePath)) {
        Set-Content -Path $ProfilePath -Value "# Dotfiles PowerShell Profile`n$SourceLine`n" -Encoding UTF8
        Write-Host "✨ Created PowerShell profile and added aliases: $ProfilePath" -ForegroundColor Green
    } else {
        $ProfileContent = Get-Content -Path $ProfilePath -Raw
        if ($ProfileContent -notmatch [regex]::Escape($AliasesPs1Dest)) {
            Add-Content -Path $ProfilePath -Value "`n# Dotfiles Aliases`n$SourceLine`n" -Encoding UTF8
            Write-Host "✨ Added aliases source line to existing profile: $ProfilePath" -ForegroundColor Green
        } else {
            Write-Host "ℹ️  PowerShell profile already sources aliases: $ProfilePath" -ForegroundColor Gray
        }
    }
}

# Windows PowerShell 5.1 의 기본 실행 정책(Restricted)에서는 프로필 스크립트가 차단되어 별칭이 로드되지 않음.
# 보안 설정이므로 자동으로 바꾸지 않고 안내만 함.
$Policy = powershell.exe -NoProfile -Command "Get-ExecutionPolicy"
if ($Policy -in @('Restricted', 'AllSigned')) {
    Write-Host "⚠️  Windows PowerShell execution policy is '$Policy', so the profile (aliases) will not load." -ForegroundColor Yellow
    Write-Host "   To allow local profile scripts for your user only, run:" -ForegroundColor Yellow
    Write-Host "   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned" -ForegroundColor Yellow
}

# 2. Windows CMD doskey 매크로 복사 및 자동 실행(AutoRun) 등록
$MacrosSrc = Join-Path $Dir "macros.doskey"
$MacrosDest = Join-Path $ConfigShellDir "macros.doskey"
Copy-Item -Path $MacrosSrc -Destination $MacrosDest -Force
Write-Host "📦 Copied macros.doskey -> $MacrosDest" -ForegroundColor Green

try {
    $AutoRunCmd = "doskey /macrofile=`"$MacrosDest`""
    $RegPath = "HKCU:\Software\Microsoft\Command Processor"
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }
    $CurrentAutoRun = (Get-ItemProperty -Path $RegPath -Name "AutoRun" -ErrorAction SilentlyContinue).AutoRun
    if ([string]::IsNullOrWhiteSpace($CurrentAutoRun)) {
        Set-ItemProperty -Path $RegPath -Name "AutoRun" -Value $AutoRunCmd
        Write-Host "✨ Configured CMD AutoRun in Registry: $AutoRunCmd" -ForegroundColor Green
    } elseif ($CurrentAutoRun -notmatch [regex]::Escape($MacrosDest)) {
        Set-ItemProperty -Path $RegPath -Name "AutoRun" -Value "$CurrentAutoRun & $AutoRunCmd"
        Write-Host "✨ Appended CMD AutoRun in Registry: $AutoRunCmd" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  CMD AutoRun is already configured in Registry." -ForegroundColor Gray
    }
} catch {
    Write-Host "⚠️  Could not set CMD AutoRun registry automatically: $_" -ForegroundColor Yellow
}

Write-Host "🎉 Shell setup completed successfully!" -ForegroundColor Green
