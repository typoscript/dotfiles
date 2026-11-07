#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=../lib/common.sh
source "$DIR/../lib/common.sh"

TARGET_DIR="$HOME/.gemini/antigravity-cli"
CONFIG_DIR="$HOME/.config/agy"

echo "🚀 [Antigravity Setup] Initializing installation..."

# 1. 상태바 스크립트 심볼릭 링크 (기존 파일은 비파괴 백업)
chmod +x "$DIR/statusline.py"
link_file "$DIR/statusline.py" "$CONFIG_DIR/statusline.py"

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
#    백업/검증은 merge_settings.py 가 담당:
#    - 내용이 바뀔 때만 비파괴 백업(.bak / .bak.<timestamp>)
#    - 기존 settings.json 이나 config 가 깨진 JSON 이면 아무것도 쓰지 않고 실패
SETTINGS_TARGET="$TARGET_DIR/settings.json"

PYTHON_BIN="python3"
if ! command -v python3 >/dev/null 2>&1 && command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
fi

"$PYTHON_BIN" "$DIR/merge_settings.py" --base "$BASE_FILE" --override "$OVERRIDE_FILE" --target "$SETTINGS_TARGET" --home "${HOME:-$USERPROFILE}"

# 4. rules.md 전역 룰 연결 (기존 파일은 비파괴 백업)
if [ -f "$DIR/rules.md" ]; then
    link_file "$DIR/rules.md" "$TARGET_DIR/rules/global_rules.md"
fi

echo "🎉 All done! Please restart your Antigravity CLI session to take effect."
