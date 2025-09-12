#### 0) Prompt instantâneo do Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#### 1) Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins Oh My Zsh
plugins=(
  git
  gh
  vim-interaction
  vi-mode
  docker
  emoji
  emoji-clock
  golang
  man
  tmux
  tmux-cssh
  tmuxinator
  minikube
  kubectl
  uv
)
source "$ZSH/oh-my-zsh.sh"

#### 2) Loading secrets (if exists)
[[ -f "$HOME/.secrets.zsh" ]] && source "$HOME/.secrets.zsh"

#### 3) Zinit – plugins out of OMZ
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}%F{220}Installing zdharma-continuum/zinit…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" \
    && print -P "%F{34}Installation successful.%f" || print -P "%F{160}Clone failed.%f"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit; (( ${+_comps} )) && _comps[zinit]=_zinit

# Extras Plugins utilities
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

#### 4) History Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey -s '^a' "ns\n"   # Open Neovim config seletor

# fzf (loads once; provides fzf-history-widget)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
bindkey '^R' fzf-history-widget

# History
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

#### 5) Completion (set styles BEFORE compinit)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

autoload -Uz compinit && compinit

#### 6) Environment and PATH
# Go
if [[ -n "$GOROOT" && -d "$GOROOT/bin" ]]; then
  path+="$GOROOT/bin"
fi
if [[ -n "$GOPATH" && -d "$GOPATH/bin" ]]; then
  path+="$GOPATH/bin"
fi
export PATH

# Various Variables
export CGO_LDFLAGS_ALLOW="^-[Il].*$"

#### 7) Prompt P10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#### 8) Manual tools that require init
# zoxide (preferred by OMZ plugin because it's always up-to-date)
eval "$(zoxide init zsh)"

# mise (maintained the activate official; OMZ plugin is redundant)
eval "$($HOME/.local/bin/mise activate zsh)"

#### 9) Aliases and functions personal
# Python
alias p3="python3"
alias pt="ptpython"
alias vd="deactivate"
alias tsplit1_3="tmux split-window -v \; resize-pane -D -y 30% \; split-window -h -t 1 \; resize-pane -t 1 -x 33% \; split-window -h -t 2 \; resize-pane -t 2 -x 33% \; select-pane -t 0"
alias tsplit4="tmux split-window -v \; split-window -h \; select-pane -t 0 \; split-window -h \; select-pane -t 0"

# Neovim / env
alias rv="NVIM_APPNAME=rootNvim nvim"
alias v="NVIM_APPNAME=nvim nvim"
ns() {
  local items=("rootNvim" "nvim")
  local config
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=50% --layout=reverse --border --exit-0)
  [[ -z $config ]] && { echo "Nothing selected"; return 0; }
  [[ $config == "default" ]] && config=""
  NVIM_APPNAME=$config nvim "$@"
}

# Git/TUI/ls
alias lg="lazygit"
alias la="eza -laF --icons --header"
alias ll="eza -lF --icons --header"
alias cl="clear"
alias fd=fdfind

# AI tools
alias gemini="npx https://github.com/google-gemini/gemini-cli"

# Nvim reset
resetnvim() {
  rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
}

# Devcontainer
alias dc="devcontainer"
alias dcb="devcontainer up --workspace-folder . --build-no-cache"
alias dce="devcontainer exec --workspace-folder . zsh"

# Zsh util
alias zshrc="nvim $HOME/.zshrc"
alias lzsh="exec zsh"

# Python venv helper
va() {
  local ACTIVATE_FILE
  ACTIVATE_FILE=$(find . -maxdepth 3 -type f -path "./*/bin/activate" 2>/dev/null | head -n 1)
  if [[ -n "$ACTIVATE_FILE" ]]; then
    . "$ACTIVATE_FILE"
    echo "Activate Environment: $ACTIVATE_FILE"
    echo "Python Path: $(command -v python)"
    echo "Python Version: $(python --version 2>&1)"
  else
    echo "Python Virtual Environment not found in $(pwd)"
  fi
}

uv_init() {
  if [[ -z "$1" ]]; then
    echo "Erro: Python version not specified.\nUse: uv_init <python-version>"
    return 1
  fi
  echo "🔵 Initializing Python $1 environment..."
  uv init --bare --python=$1 && uv python pin $1 && mise use python@$1 && \
    echo "✅ Environment setup completed successfully!\n⬜ Running 'uv venv'..." || \
    { echo "❌ Setup failed"; return 1; }
}

# Postgres inside container
psqldocker() {
  if [[ $# -ne 3 ]]; then
    echo "Error: Missing required parameters.\nUsage: psqldocker <container> <user> <database>"
    return 1
  fi
  echo "🔵 Connecting to PostgreSQL..."
  docker exec -it "$1" psql -U "$2" -d "$3" && \
    echo "✅ Connection successful!" || \
    { echo "❌ Connection failed"; return 1; }
}
