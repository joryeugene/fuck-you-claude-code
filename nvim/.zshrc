# Modern Zsh Config - Rebuilt Better

# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Better directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Prompt - Simple and fast
PROMPT='%F{blue}%~%f %F{green}❯%f '

# Aliases
alias ls='ls -G'
alias ll='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias v='nvim'
alias lg='lazygit'
alias ze='zellij'
alias c='clear'

# Enhanced Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias cdp='cd -'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph'

# Node
export PATH="$HOME/.npm-global/bin:$PATH"

# Editor
export EDITOR='nvim'

# Source local configs if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Ultra-productive aliases

alias cat='bat'

alias ls='eza'

alias ll='eza -la --icons'

alias tree='eza --tree'

alias find='fd'

alias grep='rg'

alias top='btop'

alias vim='nvim'

# Quick navigation

alias dl='cd ~/Downloads'

alias dt='cd ~/Desktop'

# Git shortcuts for speed

alias gaa='git add .'

alias gcm='git commit -m'

alias gco='git checkout'

alias gd='git diff'

alias gpl='git pull'

alias gpu='git push'

alias gst='git status'

# npm shortcuts

alias ni='npm install'

alias nr='npm run'

alias nrd='npm run dev'

alias nrb='npm run build'

# Quick edit

alias zc='nvim ~/.zshrc'

alias zz='source ~/.zshrc'

