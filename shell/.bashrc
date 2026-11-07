# ==============================================================================
# WSL / Linux Bash Configuration (~/.bashrc)
# 머신별 설정(회사 PATH, 토큰 등)은 ~/.bashrc.local 에 작성하세요 (git 미추적).
# ==============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ------------------------------------------------------------------------------
# History & Shell Options
# ------------------------------------------------------------------------------
HISTCONTROL=ignoreboth          # 중복 및 공백으로 시작하는 명령 기록 안 함
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend             # 히스토리 파일 덮어쓰기 대신 이어쓰기
shopt -s checkwinsize           # 창 크기 변경 시 LINES/COLUMNS 갱신

# less 에서 비텍스트 파일 보기
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ------------------------------------------------------------------------------
# Prompt (user@host:dir$, 컬러 지원 터미널이면 컬러)
# ------------------------------------------------------------------------------
case "$TERM" in
    xterm-color|*-256color|xterm) PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' ;;
    *)                            PS1='\u@\h:\w\$ ' ;;
esac
# xterm 계열이면 터미널 제목을 user@host: dir 로 설정
case "$TERM" in
    xterm*|rxvt*) PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
esac

# ------------------------------------------------------------------------------
# Environment Variables & PATH
# ------------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------------------
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ------------------------------------------------------------------------------
# Node Version Manager (설치되어 있을 때만)
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# ------------------------------------------------------------------------------
# Shared Aliases
# ------------------------------------------------------------------------------
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

# ------------------------------------------------------------------------------
# Machine-local overrides (git 미추적)
# ------------------------------------------------------------------------------
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi
