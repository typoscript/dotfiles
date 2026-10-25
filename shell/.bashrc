# ==============================================================================
# WSL / Linux Bash Configuration (~/.bashrc)
# ==============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ------------------------------------------------------------------------------
# Environment Variables & PATH
# ------------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
alias ll='ls -la'
alias cls='clear'
alias py='python3'
alias gpm='git push origin main'

# Enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi
