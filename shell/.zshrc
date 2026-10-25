# ==============================================================================
# Environment Variables & PATH Configuration
# ==============================================================================
# Java JDK configuration
export JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home

# Prepend custom binary directories to system PATH
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"



# ==============================================================================
# Shell Behavior & Keybindings
# ==============================================================================
# Enable Vi editing mode on command line
bindkey -v



# ==============================================================================
# Shared Aliases
# ==============================================================================
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

# ==============================================================================
# Prompt Customization & Git Integration
# ==============================================================================
# Load version control system (vcs_info) module
autoload -Uz vcs_info

# Hook to refresh git status before every prompt display
precmd() { vcs_info }

# Set git branch format string
zstyle ':vcs_info:git:*' formats 'on %b'

# Enable parameter and command substitution in prompt strings
setopt PROMPT_SUBST

# Left prompt: <username><current_working_directory> >
PROMPT='%n%~% > '

# Right prompt: Display active git branch name
RPROMPT=\$vcs_info_msg_0_
