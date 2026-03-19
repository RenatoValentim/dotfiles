<div align="center">

# 🚀 Dotfiles

**Personal development environment configuration**

*Configs live under `config/` and are intended to be linked into your XDG config directory (usually `~/.config`)*

---

</div>

## 📦 What's Included

| Tool             | Path               | Description                                                              |
| ---------------- | ------------------ | ------------------------------------------------------------------------ |
| 🐟 **Fish Shell** | `config/fish/`     | Modern shell with smart completions ([docs](config/fish/FISH_README.md)) |
| 🖥️ **Tmux**       | `config/tmux/`     | Terminal multiplexer (includes vendored plugins)                         |
| 💻 **WezTerm**    | `config/wezterm/`  | GPU-accelerated terminal emulator ([docs](config/wezterm/README.md))     |
| 🌳 **Lazygit**    | `config/lazygit/`  | Terminal UI for git commands                                             |
| ⚡ **LazyVim**    | `config/lazyvim/`  | Neovim config (primary)                                                  |
| 🔧 **RootNvim**   | `config/RootNvim/` | Alternate Neovim config                                                  |
| ✅ **Validation** | `scripts/check.sh` | Local validation script (mirrors CI)                                     |

---

## 🔧 Installation

### Quick Setup

Link only what you use:

```bash
# Fish Shell
ln -sfn "$PWD/config/fish" ~/.config/fish

# Tmux
ln -sfn "$PWD/config/tmux" ~/.config/tmux

# Lazygit
ln -sfn "$PWD/config/lazygit" ~/.config/lazygit

# WezTerm
ln -sfn "$PWD/config/wezterm" ~/.config/wezterm

# Neovim (LazyVim)
ln -sfn "$PWD/config/lazyvim" ~/.config/nvim
```

> **⚠️ Important:** If you already have configs in place, back them up first!

### 🔒 Local Overrides

Prefer putting machine-specific values into local, untracked override files:

| Tool    | Override File                      | Status           |
| ------- | ---------------------------------- | ---------------- |
| Fish    | `config/fish/conf.d/local.fish`    | 🚫 Ignored by Git |
| Lazygit | `config/lazygit/config.local.yml`  | 🚫 Ignored by Git |

## 💻 WezTerm

The WezTerm config is split into focused modules so behavior stays easier to change and test:

- `config/wezterm/wezterm.lua`: thin bootstrap that loads the composed config
- `config/wezterm/config/init.lua`: wires modules together
- `config/wezterm/config/options.lua`: shared options, theme, font, and leader key
- `config/wezterm/config/opacity.lua`: transparency toggles and opacity cycling
- `config/wezterm/config/tabs.lua`: dynamic tab titles, zoom badge, and right status
- `config/wezterm/config/keys.lua`: keymaps and the searchable keybinding picker
- `config/wezterm/tests/`: Lua test runner and focused module specs

Notable behavior:

- `Ctrl-a` acts as the leader key to stay close to the tmux setup
- `Leader+p` opens the keybinding picker powered by `fzf`
- `Ctrl+Shift+t` toggles transparency and `Ctrl+Shift+y` cycles opacity levels
- tab labels prefer explicit names, then the foreground process, then the current directory
- zoomed split tabs show a badge in the tab bar and in the right status area

Requirements and helpers:

- `JetBrains Mono Nerd Font` is the configured font
- `fzf` is required for the keybinding picker helper
- `bash` is required for `config/wezterm/wezterm-fzf-picker.sh`
- `lua` is required to run the WezTerm test suite locally

---

## ✅ Validation

Validate your changes before committing:

```bash
# Standard checks (Fish, WezTerm helper shell syntax, Stylua, WezTerm Lua tests)
./scripts/check.sh

# Include Neovim validation (slower)
CHECK_NVIM=1 ./scripts/check.sh
```

---

## ⌨️ WezTerm Shortcuts

> You can manage tabs and panes directly in WezTerm with this setup, no tmux required.  
> **Leader:** `Ctrl-a`

### 🪟 Tabs

| Shortcut           | Action                               |
| ------------------ | ------------------------------------ |
| `Leader + c`       | New tab (prompts for an optional name) |
| `Leader + r`       | Rename current tab                   |
| `Alt-n` / `Alt-p`  | Next / previous tab                  |
| `Leader + ←` / `Leader + →` | Move current tab left / right |

### 📐 Panes / Splits

| Shortcut                 | Action                         |
| ------------------------ | ------------------------------ |
| `Leader + -`             | Split vertically               |
| `Leader + \|`            | Split horizontally             |
| `Ctrl+Shift+h/j/k/l`     | Focus pane left/down/up/right  |
| `Super+Shift+h/j/k/l`    | Resize pane left/down/up/right |
| `Leader + x`             | Close current pane             |
| `Shift+z`                | Toggle pane zoom               |

### 🛠️ View / Utilities

| Shortcut           | Action                          |
| ------------------ | ------------------------------- |
| `Ctrl+f`           | Toggle fullscreen               |
| `Ctrl+Shift+t`     | Toggle transparency             |
| `Ctrl+Shift+y`     | Cycle transparency levels       |
| `Leader + p`       | Open keybinding picker          |
| `Leader + Ctrl+a`  | Send literal `Ctrl+a` to a pane |

---

## ⌨️ Tmux Shortcuts

> **Prefix:** `Ctrl-a` (instead of tmux's default `Ctrl-b`)  
> Below, "prefix" means `Ctrl-a` then the key.

### 🪟 Windows

| Shortcut           | Action                                                     |
| ------------------ | ---------------------------------------------------------- |
| Prefix + `c`       | New window (prompts for name, starts in current pane path) |
| Prefix + `W`       | New window in `$HOME`                                      |
| Prefix + `Ctrl-c`  | New window in `$HOME` (prompts for name)                   |
| Prefix + `Ctrl-d`  | Detach session                                             |
| Prefix + `r`       | Rename window                                              |
| Prefix + `R`       | Reload tmux config                                         |
| `Alt-n` / `Alt-p`  | Next / previous window *(no prefix)*                       |
| Prefix + `←` / `→` | Move current window left / right                           |
| Prefix + `w`       | Choose window                                              |
| Prefix + `=`       | List clients                                               |

### 📐 Panes / Splits

| Shortcut          | Action                                                    |
| ----------------- | --------------------------------------------------------- |
| Prefix + `\|`     | Split horizontally (keeps current directory)              |
| Prefix + `-`      | Split vertically (keeps current directory)                |
| Prefix + `Ctrl-t` | Split vertical with ~30% height (bottom)                  |
| Prefix + `t`      | Split vertical with 100% height ("full pane")             |
| Prefix + `k`      | Select pane up and toggle zoom                            |
| Prefix + `j`      | Select pane down and resize left                          |
| Prefix + `x`      | Kill current pane                                         |
| `Ctrl-h/j/k/l`    | Resize panes *(repeatable)*                               |
| `Ctrl-\`          | Jump to last pane *(smart: passes through to Vim/Neovim)* |
| `Ctrl-t`          | Select the pane below and toggle zoom                     |

### 📋 Copy Mode

| Shortcut     | Action                            |
| ------------ | --------------------------------- |
| Prefix + `[` | Enter copy-mode (vi keys enabled) |
| `v`          | Start selection *(in copy-mode)*  |

### 🛠️ Utilities

| Shortcut     | Action                                       |
| ------------ | -------------------------------------------- |
| Prefix + `:` | Command prompt                               |
| Prefix + `*` | Toggle synchronize-panes                     |
| Prefix + `P` | Toggle pane border status                    |
| Prefix + `o` | Open tmux-sessionx (session/window switcher) |

---
