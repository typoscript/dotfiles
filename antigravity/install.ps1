$ErrorActionPreference = "Stop"

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE
$TargetDir = Join-Path $UserHome ".gemini\antigravity-cli"
$ConfigDir = Join-Path $UserHome ".config\agy"

Write-Host "🚀 [Antigravity Setup] Initializing Windows installation..." -ForegroundColor Cyan

# 1. 상태바 디렉터리 생성 및 statusline.py 링크/복사
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

$StatuslineTarget = Join-Path $ConfigDir "statusline.py"
$StatuslineSrc = Join-Path $Dir "statusline.py"

try {
    if (Test-Path $StatuslineTarget) {
        Remove-Item $StatuslineTarget -Force
    }
    New-Item -ItemType SymbolicLink -Path $StatuslineTarget -Target $StatuslineSrc -Force -ErrorAction Stop | Out-Null
    Write-Host "🔗 Linked statusline.py to $StatuslineTarget (Symlink)" -ForegroundColor Green
} catch {
    Copy-Item -Path $StatuslineSrc -Destination $StatuslineTarget -Force
    Write-Host "📦 Copied statusline.py to $StatuslineTarget (Fallback Copy)" -ForegroundColor Yellow
}

# 2. settings.json 병합 및 적용
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

$SettingsTarget = Join-Path $TargetDir "settings.json"
if (Test-Path $SettingsTarget) {
    Copy-Item -Path $SettingsTarget -Destination "$SettingsTarget.bak" -Force
    Write-Host "📦 Backed up existing settings to $SettingsTarget.bak" -ForegroundColor Gray
}

$BaseFile = Join-Path $Dir "config.json"
$OverrideFile = Join-Path $Dir "config.win.json"
$MergeScript = Join-Path $Dir "merge_settings.py"

# Python 실행을 통해 settings.json 병합
python $MergeScript --base $BaseFile --override $OverrideFile --target $SettingsTarget --home $UserHome

# 3. rules.md 전역 룰 연결
$RulesSrc = Join-Path $Dir "rules.md"
if (Test-Path $RulesSrc) {
    $RulesDir = Join-Path $TargetDir "rules"
    if (-not (Test-Path $RulesDir)) {
        New-Item -ItemType Directory -Path $RulesDir -Force | Out-Null
    }
    $RulesTarget = Join-Path $RulesDir "global_rules.md"
    try {
        if (Test-Path $RulesTarget) {
            Remove-Item $RulesTarget -Force
        }
        New-Item -ItemType SymbolicLink -Path $RulesTarget -Target $RulesSrc -Force -ErrorAction Stop | Out-Null
        Write-Host "📝 Linked global rules to $RulesTarget (Symlink)" -ForegroundColor Green
    } catch {
        Copy-Item -Path $RulesSrc -Destination $RulesTarget -Force
        Write-Host "📝 Copied global rules to $RulesTarget (Fallback Copy)" -ForegroundColor Yellow
    }
}

Write-Host "🎉 Antigravity setup completed successfully!" -ForegroundColor Green
