#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================="
echo "🚀 Dotfiles Full Installation"
echo "============================================="

# 1. Shell 설정 설치 (~/.zshrc, ~/.bashrc)
if [ -f "$DIR/shell/install.sh" ]; then
    bash "$DIR/shell/install.sh"
    echo ""
fi

# 2. Vim 설정 설치 (~/.vimrc, ~/.ideavimrc, ~/.vim)
if [ -f "$DIR/vim/install.sh" ]; then
    bash "$DIR/vim/install.sh"
    echo ""
fi

# 3. Antigravity 설정 설치 (statusline.py, settings.json)
if [ -f "$DIR/antigravity/install.sh" ]; then
    bash "$DIR/antigravity/install.sh"
    echo ""
fi

echo "============================================="
echo "🎉 All installations completed successfully!"
echo "============================================="
