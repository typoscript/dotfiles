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
    OVERRIDE_FILE="$DIR/config.mac.json"
elif grep -qi microsoft /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]] || [[ -n "$WSLENV" ]]; then
    OS="WSL"
    OVERRIDE_FILE="$DIR/config.wsl.json"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="Windows"
    OVERRIDE_FILE="$DIR/config.win.json"
else
    OS="Linux"
    OVERRIDE_FILE="$DIR/config.wsl.json"
fi

BASE_FILE="$DIR/config.json"
echo "🖥️  Detected OS: $OS"
echo "⚙️  Base config: config.json"
if [ -f "$OVERRIDE_FILE" ]; then
    echo "⚙️  OS Override: $(basename "$OVERRIDE_FILE")"
fi

# 3. settings.json 병합 및 적용
mkdir -p "$TARGET_DIR"
SETTINGS_TARGET="$TARGET_DIR/settings.json"

if [ -f "$SETTINGS_TARGET" ]; then
    cp "$SETTINGS_TARGET" "$SETTINGS_TARGET.bak"
    echo "📦 Backed up existing settings to $SETTINGS_TARGET.bak"
fi

PYTHON_BIN="python3"
if ! command -v python3 >/dev/null 2>&1 && command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
fi

"$PYTHON_BIN" "$DIR/merge_settings.py" --base "$BASE_FILE" --override "$OVERRIDE_FILE" --target "$SETTINGS_TARGET" --home "${HOME:-$USERPROFILE}"

# 4. rules.md 전역 룰 연결
if [ -f "$DIR/rules.md" ]; then
    mkdir -p "$TARGET_DIR/rules"
    ln -sf "$DIR/rules.md" "$TARGET_DIR/rules/global_rules.md"
    echo "📝 Linked global rules to $TARGET_DIR/rules/global_rules.md"
fi

echo "🎉 All done! Please restart your Antigravity CLI session to take effect."
