$ErrorActionPreference = "Stop"

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE
$TargetDir = Join-Path $UserHome ".gemini\antigravity-cli"
$ConfigDir = Join-Path $UserHome ".config\agy"
. (Join-Path $Dir "..\lib\common.ps1")

Write-Host "🚀 [Antigravity Setup] Initializing Windows installation..." -ForegroundColor Cyan

# 1. statusline.py 링크/복사 (기존 파일은 비파괴 백업)
Install-Link (Join-Path $Dir "statusline.py") (Join-Path $ConfigDir "statusline.py")

# 2. settings.json 병합 및 적용
#    백업/검증은 merge_settings.py 가 담당 (변경 시에만 비파괴 백업, 깨진 JSON 이면 중단)
$SettingsTarget = Join-Path $TargetDir "settings.json"
$BaseFile = Join-Path $Dir "config.json"
$OverrideFile = Join-Path $Dir "config.win.json"
$MergeScript = Join-Path $Dir "merge_settings.py"

python $MergeScript --base $BaseFile --override $OverrideFile --target $SettingsTarget --home $UserHome
if ($LASTEXITCODE -ne 0) {
    throw "merge_settings.py failed (exit code $LASTEXITCODE). settings.json was not modified."
}

# 3. rules.md 전역 룰 연결 (기존 파일은 비파괴 백업)
$RulesSrc = Join-Path $Dir "rules.md"
if (Test-Path -LiteralPath $RulesSrc) {
    Install-Link $RulesSrc (Join-Path $TargetDir "rules\global_rules.md")
}

Write-Host "🎉 Antigravity setup completed successfully!" -ForegroundColor Green
