#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 [Vim Setup] Initializing installation..."

# OS 감지
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

# 파일 및 디렉터리 심볼릭 링크 생성 함수
link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$(readlink -f "$dest" 2>/dev/null)" = "$src" ] || [ "$(readlink "$dest" 2>/dev/null)" = "$src" ]; then
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

# 1. ~/.vimrc 심볼릭 링크
link_file "$DIR/.vimrc" "$HOME/.vimrc"

# 2. ~/.ideavimrc 심볼릭 링크
link_file "$DIR/.ideavimrc" "$HOME/.ideavimrc"

# 3. ~/.vim 디렉터리 심볼릭 링크
link_file "$DIR/.vim" "$HOME/.vim"

echo "🎉 Vim setup completed successfully!"
