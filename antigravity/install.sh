#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.gemini/antigravity-cli"
CONFIG_DIR="$HOME/.config/agy"

echo "🚀 [Antigravity Setup] Initializing installation..."

# 1. 상태바 디렉터리 및 심볼릭 링크 설정
mkdir -p "$CONFIG_DIR"
echo "🔗 Linking statusline.py to $CONFIG_DIR/statusline.py..."
ln -sf "$DIR/statusline.py" "$CONFIG_DIR/statusline.py"
chmod +x "$CONFIG_DIR/statusline.py"

# 2. OS 감지
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$(uname -s)" == "Darwin" ]]; then
    OS="macOS"
    CONFIG_FILE="$DIR/config.mac.json"
elif grep -qi microsoft /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]] || [[ -n "$WSLENV" ]]; then
    OS="WSL"
    CONFIG_FILE="$DIR/config.wsl.json"
else
    OS="Linux"
    CONFIG_FILE="$DIR/config.wsl.json"
fi

echo "🖥️  Detected OS: $OS (Using $(basename "$CONFIG_FILE"))"

# 3. settings.json 병합 및 적용
mkdir -p "$TARGET_DIR"
SETTINGS_TARGET="$TARGET_DIR/settings.json"

if [ -f "$SETTINGS_TARGET" ]; then
    cp "$SETTINGS_TARGET" "$SETTINGS_TARGET.bak"
    echo "📦 Backed up existing settings to $SETTINGS_TARGET.bak"
fi

# Python을 이용한 안전한 JSON 병합 ($HOME 치환 지원)
python3 - <<EOF
import os
import json

config_file = "$CONFIG_FILE"
settings_target = "$SETTINGS_TARGET"
home_dir = os.environ.get("HOME", "")

# 1. OS별 설정 읽기 및 $HOME 경로 치환
with open(config_file, "r", encoding="utf-8") as f:
    config_str = f.read().replace("\$HOME", home_dir)
    new_config = json.loads(config_str)

# 2. 기존 설정이 있다면 읽기
existing_config = {}
if os.path.exists(settings_target):
    try:
        with open(settings_target, "r", encoding="utf-8") as f:
            existing_config = json.load(f)
    except Exception as e:
        print(f"⚠️  Could not parse existing settings.json: {e}")

# 3. 딥 머지 (기존 권한, 신뢰 워크스페이스, 모델 등 보존)
def deep_merge(target, src):
    for k, v in src.items():
        if isinstance(v, dict) and k in target and isinstance(target[k], dict):
            deep_merge(target[k], v)
        else:
            target[k] = v
    return target

merged = deep_merge(existing_config, new_config)

# 4. 저장
with open(settings_target, "w", encoding="utf-8") as f:
    json.dump(merged, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(f"✅ Successfully updated {settings_target}")
EOF

# 4. rules.md 전역 룰 연결
if [ -f "$DIR/rules.md" ]; then
    mkdir -p "$TARGET_DIR/rules"
    ln -sf "$DIR/rules.md" "$TARGET_DIR/rules/global_rules.md"
    echo "📝 Linked global rules to $TARGET_DIR/rules/global_rules.md"
fi

echo "🎉 All done! Please restart your Antigravity CLI session to take effect."
