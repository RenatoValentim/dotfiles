# Fish Configuration
# Migrated from Zsh to Fish while keeping compatibility with modern tooling

# ============================================================================
# 1) Starship prompt (Powerlevel10k equivalent)
# ============================================================================
if status is-interactive
    # Use local Starship config (avoid an initial blank line)
    set -gx STARSHIP_CONFIG ~/.config/fish/starship.toml
    if command -v starship &> /dev/null
        starship init fish | source
    end
end

# ============================================================================
# 2) Secrets (if exists)
# ============================================================================
if test -f ~/.config/fish/.secrets.fish
    source ~/.config/fish/.secrets.fish
else if test -f ~/.secrets.fish
    source ~/.secrets.fish
end

# ============================================================================
# 3) Tools that require init (Zoxide, Mise, FZF)
# ============================================================================

# Zoxide - smart directory jumping
if command -v zoxide &> /dev/null
    zoxide init fish | source
end

# Mise - version manager
if test -f ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

# FZF - fuzzy finder
if test -f ~/.fzf.fish
    source ~/.fzf.fish
end

# ============================================================================
# 4) History configuration
# ============================================================================
set -U fish_history max
set -U fish_greeting  # Disable default greeting

# ============================================================================
# 5) Colors and highlighting
# ============================================================================
set -g fish_color_command green  # commands like `cd` show as green

# ============================================================================
# 6) Environment variables
# ============================================================================
set -gx CGO_LDFLAGS_ALLOW '^-[Il].*$'

# Go paths
if test -n "$GOROOT" -a -d "$GOROOT/bin"
    set -gx PATH "$GOROOT/bin" $PATH
end

if test -n "$GOPATH" -a -d "$GOPATH/bin"
    set -gx PATH "$GOPATH/bin" $PATH
end

# ============================================================================
# 7) Aliases
# ============================================================================

# Python
alias p3="python3"
alias pt="ptpython"
alias vd="deactivate"

# Git/TUI/ls
alias lg="lazygit"
alias la="eza -laF --icons --header"
alias ll="eza -lF --icons --header"
alias cl="clear"
alias fd="fdfind"
alias cd="z"  # zoxide override

# Neovim
alias v="env NVIM_APPNAME=nvim nvim"
alias rv="env NVIM_APPNAME=rootNvim nvim"

# VsCode
alias code="code-insiders"

# AI tools
alias gemini="npx https://github.com/google-gemini/gemini-cli"

# Devcontainer
alias dc="devcontainer"
alias dcb="devcontainer up --workspace-folder . --build-no-cache"
alias dce="devcontainer exec --workspace-folder . fish"

# Fish util
alias fishrc="nvim $HOME/.config/fish/config.fish"
alias lfish="exec fish"

# ============================================================================
# 8) Carregando funções personalizadas
# ============================================================================
# Functions live in `~/.config/fish/functions/`
