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
| 💻 **WezTerm**    | `config/wezterm/`  | GPU-accelerated terminal emulator                                        |
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
| WezTerm | `config/wezterm/wezterm.local.lua` | 🚫 Ignored by Git |

---

## ✅ Validation

Validate your changes before committing:

```bash
# Standard checks
./scripts/check.sh

# Include Neovim validation (slower)
CHECK_NVIM=1 ./scripts/check.sh
```

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
