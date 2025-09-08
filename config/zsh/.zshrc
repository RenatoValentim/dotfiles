# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="af-magic" # robbyrussell af-magic
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  gh
  # poetry
  # poetry-env
  vim-interaction
  vi-mode
  docker
  docker-compose
  emoji
  emoji-clock
  golang
  man
  tmux
  tmux-cssh
  tmuxinator
  minikube
  kubectl
  # mise
  # asdf
  z
  zoxide
  uv
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

### Required to the installation of the gossdeep package
export CGO_LDFLAGS_ALLOW="^-[Il].*$"

# Load private if True
[ -f $HOME/.secrets.zsh ] && source $HOME/.secrets.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

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

## Personal alias
# python
alias p3="python3"

# utils
alias rv="NVIM_APPNAME=rootNvim nvim"
alias v="NVIM_APPNAME=nvim nvim"
function ns() {
  items=("rootNvim" "nvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}
bindkey -s ^a "ns\n"

alias lg="lazygit"
alias la="exa -laF --icons --header"
alias ll="exa -lF --icons --header"
alias cl="clear"
alias fd=fdfind
resetnvim() {
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.cache/nvim
}
alias dc=devcontainer
alias dcb="devcontainer up --workspace-folder . --build-no-cache"
alias dce="devcontainer exec --workspace-folder . zsh"
alias zshrc="nvim $HOME/.zshrc"
alias lzsh="exec zsh"
alias pt="ptpython"
alias vd="deactivate"
# Tmux
alias split3="tmux split-window -h -p 66 && tmux split-window -h -p 50"
alias split4='tmux split-window -h "tmux split-window -v; tmux select-pane -t 0; tmux split-window -v -p 50; tmux select-pane -t 2; tmux split-window -v -p 50; tmux select-pane -t 1"'
alias split1_3='tmux split-window -v -p 30 \; split-window -h -p 33 -t 1 \; select-pane -t 1 \; split-window -h -p 50 \; select-pane -t 0'


va() {
  ACTIVATE_FILE=$(find . -maxdepth 3 -type f -path "./*/bin/activate" 2>/dev/null | head -n 1)

  if [ -n "$ACTIVATE_FILE" ]; then
    . "$ACTIVATE_FILE"
    echo "Activate Environment: $ACTIVATE_FILE"

    PYTHON_PATH=$(which python)
    PYTHON_VERSION=$(python --version 2>&1)
    echo "Python Path: $PYTHON_PATH"
    echo "Python Version: $PYTHON_VERSION"
  else
    echo "Python Virtual Environment not found in $(pwd)"
  fi
}

psqldocker() {
  docker exec -it $1 psql -U $2 -d $3
}

# asdf configuration
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# configurations
# fpath=(~/.zsh/completions $fpath)
# autoload -Uz compinit
# compinit

# export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# 
# Define Go paths
# if asdf >/dev/null 2>&1; then
# export GOROOT="$(asdf where golang)/go"
export PATH="${GOROOT}/bin${PATH:+:$PATH}"

  # fpath=(${ASDF_DIR}/completions $fpath)
  # autoload -Uz compinit && compinit
# else
#   export GOROOT=$HOME/go
# fi
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init zsh)"

# Carregar keybindings e funções do fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Definir Ctrl+R para usar fzf no histórico
bindkey '^R' fzf-history-widget
TERM=wezterm

# Load completions
autoload -Uz compinit && compinit

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/rvsj/.local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/home/rvsj/.local/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/home/rvsj/.local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/rvsj/.local/share/google-cloud-sdk/completion.zsh.inc'; fi
