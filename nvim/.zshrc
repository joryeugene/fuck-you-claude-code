# Modern Zsh Config - Enhanced Edition

# ============================================================================
# ZINIT PLUGIN MANAGER
# ============================================================================
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

if [ -f "$ZINIT_HOME/zinit.zsh" ]; then
    source "$ZINIT_HOME/zinit.zsh"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit
else
    echo "Zinit not found. Install with: sh -c \"\$(curl -fsSL https://git.io/zinit-install)\""
fi

# Run neofetch on terminal startup
if command -v neofetch &> /dev/null; then
    neofetch
fi

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Load environment variables from ~/.env
if [ -f "$HOME/.env" ]; then
  set -a
  source "$HOME/.env"
  set +a
fi

# Core environment settings
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export FUNCNEST=100
export TERM=xterm-256color

# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# ============================================================================
# FZF CONFIGURATION
# ============================================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .DS_Store'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .DS_Store"

# Enhanced preview options
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
  --preview-window 'right:60%'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --header 'Press CTRL-/ to toggle preview'
  --prompt '🔍 '
  --pointer '▶'
  --marker '✓'
"

export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
  --preview-window 'right:60%'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --header 'Press CTRL-/ to toggle preview'
  --prompt '📁 '
  --pointer '▶'
  --marker '✓'
"

# ============================================================================
# ZINIT PLUGINS
# ============================================================================
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

# ============================================================================
# PYENV CONFIGURATION
# ============================================================================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi

# ============================================================================
# VI MODE SETTINGS
# ============================================================================
bindkey -v
export KEYTIMEOUT=1

# Function to update cursor and Starship keymap
function update_vim_mode() {
    case ${KEYMAP} in
        vicmd)
            echo -ne '\e[2 q'  # Block cursor
            STARSHIP_SHELL_KEYMAP=NORMAL
            ;;
        main|viins)
            echo -ne '\e[5 q'  # Beam cursor
            STARSHIP_SHELL_KEYMAP=INSERT
            ;;
    esac
}

# Set up Zle hooks
function zle-line-init zle-keymap-select {
    update_vim_mode
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Use beam shape cursor on startup and for each new prompt
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Write timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_VERIFY               # Show command with history expansion
setopt SHARE_HISTORY             # Share history between sessions
setopt APPEND_HISTORY            # Append to history file

# ============================================================================
# DIRECTORY NAVIGATION
# ============================================================================
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ============================================================================
# COMPLETION
# ============================================================================
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# ============================================================================
# KEY BINDINGS
# ============================================================================
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^R' fzf-history-widget
bindkey '^F' fzf-cd-widget
bindkey '^T' fzf-file-widget

# ============================================================================
# COLORIZE MAN PAGES
# ============================================================================
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ============================================================================
# ALIASES
# ============================================================================

# Modern CLI tool replacements (originals still accessible with \cat, \ls, etc.)
alias cat='bat'
alias ls='eza'
alias ll='eza -la --icons'
alias tree='eza --tree'
alias find='fd'
alias grep='rg'
alias top='btop'
alias vim='nvim'

# Basic navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias cdp='cd -'

# Quick locations
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gst='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gcm='git commit -m'
alias gp='git push'
alias gpu='git push'
alias gl='git log --oneline --graph'
alias gpl='git pull'
alias gco='git checkout'
alias gd='git diff'

# LazyGit
alias lg='lazygit'

# Zellij
alias ze='zellij'

# Editor
alias v='nvim'
alias vl='nvim -c "normal '\''0"'  # Open last edited file
alias vf='nvim $(fzf)'

# Buffer management
alias c='clear'

# npm shortcuts
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'

# Config shortcuts
alias zc='nvim ~/.zshrc'
alias zz='source ~/.zshrc'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Create directory and cd into it
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# Load external function files
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Node global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Local bin
path=(
    $HOME/.local/bin
    $path
)
export PATH

# ============================================================================
# DEVELOPMENT ENVIRONMENT
# ============================================================================

# PostgreSQL development libraries
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/opt/libpq/lib"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# PostgreSQL specialized pager (pspg) for enhanced psql output
export PSQL_PAGER='pspg -bX --no-mouse'

# System-wide environment settings for zsh
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi

# ============================================================================
# EXTERNAL FILE LOADING
# ============================================================================

# Load aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Load Cargo environment
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Load local customizations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================================
# TOOL INITIALIZATION
# ============================================================================

# Initialize zoxide (smart cd)
eval "$(zoxide init zsh)"

# Initialize Starship prompt (with vi mode support)
eval "$(starship init zsh)"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun completions
[ -s "/Users/jory/.bun/_bun" ] && source "/Users/jory/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
### End of Zinit's installer chunk
