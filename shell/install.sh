#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=../lib/common.sh
source "$DIR/../lib/common.sh"

echo "🚀 [Shell Setup] Initializing installation..."

# OS 감지 (macOS -> WSL -> Windows(Git Bash) -> Linux)
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$(uname -s)" == "Darwin" ]]; then
    OS="macOS"
elif grep -qi microsoft /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]] || [[ -n "$WSLENV" ]]; then
    OS="WSL"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="Windows"
else
    OS="Linux"
fi

echo "🖥️  Detected OS: $OS"

# 1. 공통 별칭(Aliases) 심볼릭 링크 (~/.aliases)
link_file "$DIR/aliases.sh" "$HOME/.aliases"

# 2. OS별 기본 셸 설정 파일 연결
if [ "$OS" = "macOS" ]; then
    # macOS: zsh가 기본 셸
    link_file "$DIR/.zshrc" "$HOME/.zshrc"
elif [ "$OS" = "WSL" ] || [ "$OS" = "Linux" ]; then
    # WSL / Linux: bash가 기본 셸
    link_file "$DIR/.bashrc" "$HOME/.bashrc"
    
    # zsh 설정도 존재할 경우 함께 링크 (zsh를 설치해 쓰는 사용자 고려)
    if [ -f "$DIR/.zshrc" ] && command -v zsh >/dev/null 2>&1; then
        link_file "$DIR/.zshrc" "$HOME/.zshrc"
    fi
fi

echo "🎉 Shell setup completed successfully!"
