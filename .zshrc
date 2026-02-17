
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
fi

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'

# Define the tree function
function tree() { 
    local level=3 
    local long_option="" 
    local dotfiles_option="" 
    for arg in "$@"; do 
        if [[ "$arg" =~ ^[0-9]+$ ]]; then 
            level="$arg" 
        elif [[ "$arg" == "long" ]]; then 
            long_option="--long" 
        elif [[ "$arg" == "--dotfiles" ]]; then 
            dotfiles_option="--all" 
        fi 
    done 
    eza $long_option --tree --level="$level" --git-ignore $dotfiles_option 
} 

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


[ -f "/Users/sebasusnik/.ghcup/env" ] && . "/Users/sebasusnik/.ghcup/env" # ghcup-env
# bun completions
[ -s "/Users/sebasusnik/.bun/_bun" ] && source "/Users/sebasusnik/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sebasusnik/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sebasusnik/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sebasusnik/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sebasusnik/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# ============================================
# DEV ENVIRONMENT - NVIM + OPENCODE
# ============================================

# Alias principal: matar sesión existente si hay, crear nueva
alias dev='tmux kill-session -t dev 2>/dev/null; tmux new-session -d -s dev \; \
    send-keys "nvim ." C-m \; \
    split-window -h -p 40 \; \
    send-keys "opencode" C-m \; \
    select-pane -t 0 \; \
    split-window -v -p 30 \; \
    select-pane -t 0 \; \
    attach'

# Re-attach a sesión existente (útil si solo cerraste la ventana)
alias dev-attach='tmux attach -t dev'

# Matar sesión manualmente
alias dev-kill='tmux kill-session -t dev 2>/dev/null; echo "✓ Sesión dev cerrada"'

# Ver sesiones activas
alias dev-ls='tmux ls 2>/dev/null || echo "No hay sesiones tmux"'

# ============================================
# NVIM ATAJOS RÁPIDOS (sin tmux)
# ============================================

# Abrir nvim solo (para edición rápida sin opencode)
alias n='nvim'
alias nn='nvim .'

# Abrir último archivo editado en nvim
alias n-last='nvim -c "normal '\''0"'