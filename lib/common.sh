# shellcheck shell=bash
# ==============================================================================
# 공통 설치 헬퍼 (각 <tool>/install.sh 에서 source 해서 사용)
#
# 백업 원칙:
#   - 기존 백업(.bak)은 절대 삭제/덮어쓰지 않는다.
#     .bak 이 이미 있으면 .bak.<타임스탬프> 로 새로 만든다.
#   - 이미 올바르게 연결된 경우 아무것도 하지 않는다 (멱등성).
#   - 대상이 깨진(dangling) 심볼릭 링크면 보존할 데이터가 없으므로 제거만 한다.
# ==============================================================================

# 실제(물리) 경로 반환. 존재하지 않으면 빈 문자열.
real_path() {
    local target="$1"
    [ -e "$target" ] || return 0
    if readlink -f / >/dev/null 2>&1; then
        readlink -f "$target"
    elif command -v realpath >/dev/null 2>&1; then
        realpath "$target"
    else
        python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$target" 2>/dev/null \
            || python -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$target"
    fi
}

# 기존 백업을 덮어쓰지 않는 백업 경로 반환
free_backup_path() {
    local dest="$1"
    local bak="${dest}.bak"
    if [ -e "$bak" ] || [ -L "$bak" ]; then
        bak="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
        local n=1
        while [ -e "$bak" ] || [ -L "$bak" ]; do
            bak="${dest}.bak.$(date +%Y%m%d-%H%M%S).$n"
            n=$((n + 1))
        done
    fi
    printf '%s\n' "$bak"
}

# 기존 파일/디렉터리/링크를 안전하게 백업 (dangling 링크는 제거만)
backup_existing() {
    local dest="$1"
    if [ -L "$dest" ] && [ ! -e "$dest" ]; then
        echo "🧹 Removing dangling symlink $dest -> $(readlink "$dest")"
        rm -f "$dest"
        return 0
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local bak
        bak="$(free_backup_path "$dest")"
        echo "📦 Backing up existing $dest to $bak"
        mv "$dest" "$bak"
    fi
}

# 심볼릭 링크 생성 (멱등성 + 비파괴 백업)
link_file() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "⚠️  Source not found: $src (skipping)"
        return 0
    fi

    if [ -e "$dest" ] && [ "$(real_path "$dest")" = "$(real_path "$src")" ]; then
        echo "ℹ️  Already linked: $dest -> $src"
        return 0
    fi

    backup_existing "$dest"
    mkdir -p "$(dirname "$dest")"
    echo "🔗 Linking $src -> $dest"
    ln -s "$src" "$dest"
}
