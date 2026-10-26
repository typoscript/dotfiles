#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# 심볼릭 링크 대상 실제 경로 확인 헬퍼 함수 (macOS/Linux 호환)
get_real_path() {
    local target="$1"
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$target" 2>/dev/null || true
    elif command -v python >/dev/null 2>&1; then
        python -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$target" 2>/dev/null || true
    else
        readlink -f "$target" 2>/dev/null || readlink "$target" 2>/dev/null || true
    fi
}

# 파일 심볼릭 링크 생성 함수 (멱등성 및 백업 지원)
link_file() {
    local src="$1"
    local dest="$2"

    if [ ! -f "$src" ]; then
        echo "⚠️  Source file not found: $src (skipping)"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local current_target
        current_target="$(get_real_path "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo "ℹ️  Already linked: $dest -> $src"
            return
        fi
        echo "📦 Backing up existing $dest to ${dest}.bak..."
        rm -rf "${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    echo "🔗 Linking $src -> $dest..."
    ln -s "$src" "$dest"
}

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
