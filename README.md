# Dotfiles

Configs live under `config/` and are intended to be linked into your XDG config directory (usually `~/.config`).

## What’s Included

- `config/fish/`: Fish shell config
- `config/tmux/`: tmux config (includes vendored plugins under `config/tmux/plugins/`)
- `config/wezterm/`: WezTerm config
- `config/lazygit/`: Lazygit config
- `config/lazyvim/`: Neovim config (LazyVim)
- `config/RootNvim/`: alternate Neovim config
- `scripts/check.sh`: local validation script (mirrors CI)

## Install (symlinks)

Link only what you use:

- Fish: `ln -sfn "$PWD/config/fish" ~/.config/fish`
- Tmux: `ln -sfn "$PWD/config/tmux" ~/.config/tmux`
- Lazygit: `ln -sfn "$PWD/config/lazygit" ~/.config/lazygit`
- WezTerm: `ln -sfn "$PWD/config/wezterm" ~/.config/wezterm`
- Neovim (LazyVim): `ln -sfn "$PWD/config/lazyvim" ~/.config/nvim`

If you already have configs in place, back them up first. Prefer putting machine-specific values into local, untracked override files (see `.gitignore`).

Common local override files (ignored by Git):

- `config/fish/conf.d/local.fish`
- `config/lazygit/config.local.yml`
- `config/wezterm/wezterm.local.lua`

## Validate changes

- Run repo checks: `./scripts/check.sh`
- Optional (may take longer): `CHECK_NVIM=1 ./scripts/check.sh`

## Tmux shortcuts

Prefix is `Ctrl-a` (instead of tmux’s default `Ctrl-b`). Below, “prefix” means `Ctrl-a` then the key.

- **Windows**
  - Prefix + `c`: new window (prompts for name, starts in current pane path)
  - Prefix + `W`: new window in `$HOME`
  - Prefix + `Ctrl-c`: new window in `$HOME` (prompts for name)
  - Prefix + `Ctrl-d`: detach
  - Prefix + `r`: rename window
  - Prefix + `R`: reload tmux config
  - `Alt-n` / `Alt-p`: next / previous window (no prefix)
  - Prefix + `Left` / `Right`: move current window left / right
  - Prefix + `w`: choose window
  - Prefix + `=`: list clients
- **Panes / splits**
  - Prefix + `|`: split horizontally (keeps current directory)
  - Prefix + `-`: split vertically (keeps current directory)
  - Prefix + `Ctrl-t`: split vertical with ~30% height (bottom)
  - Prefix + `t`: split vertical with `100%` height (“full pane”)
  - Prefix + `k`: select pane up and toggle zoom
  - Prefix + `j`: select pane down and resize left
  - Prefix + `x`: kill current pane
  - `Ctrl-h/j/k/l`: resize panes (repeatable)
  - `Ctrl-\\`: jump to last pane (smart: passes through to Vim/Neovim when focused)
  - `Ctrl-t`: select the pane below and toggle zoom
- **Copy mode**
  - Prefix + `[`: enter copy-mode (vi keys enabled)
  - In copy-mode: press `v` to start selection
- **Utilities**
  - Prefix + `:`: command prompt
  - Prefix + `*`: toggle synchronize-panes
  - Prefix + `P`: toggle pane border status
  - Prefix + `o`: open tmux-sessionx (session/window switcher)
