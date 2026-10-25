# ==============================================================================
# Shared Shell Aliases (~/.aliases)
# Supported shells: zsh, bash (macOS, WSL, Linux)
# ==============================================================================

# Directory navigation
alias wd='cd ~/Desktop'

# Configuration editing
alias vrc='vi ~/.vimrc'

# Git shortcuts
alias gpm='git push origin main'

# Command abbreviations & quality of life
alias ll='ls -la'
alias cls='clear'
alias py='python3'

# Color support for ls / grep on Linux / WSL
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi
