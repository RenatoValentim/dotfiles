# 🐟 Fish Shell Configuration - Quick Reference

## 📋 Configuration Structure

```
~/.config/fish/config.fish          # Main configuration
~/.config/fish/functions/           # Custom functions
~/.config/fish/conf.d/              # Modular configuration
~/.config/starship.toml             # Prompt theme (Starship)
~/.secrets.fish                     # Secrets (optional)
```

---

## 🎨 Theme & Prompt

### Starship (equivalent to Powerlevel10k)

- **Config:** `~/.config/starship.toml`
- **Features:**
  - Minimal 2-line prompt
  - Support for Git, Docker, Kubernetes, languages, etc.
  - Auto-initialized via `config.fish`

> **Alternative:** P10K + Zinit on Zsh (not migrated to Fish)  
> If you want to use Powerlevel10k in Fish, see: https://github.com/romkatv/powerlevel10k#fish

---

## 🔧 Integrated Tools

| Tool           | Description                   | Usage                                           |
| -------------- | ----------------------------- | ----------------------------------------------- |
| ✅ **Zoxide**   | Smart navigation              | `z <directory>` or `zi <directory_interactive>` |
| ✅ **Mise**     | Language/tool version manager | `mise use python@3.12`                          |
| ✅ **FZF**      | Fuzzy finder                  | `Ctrl+R` to search history                      |
| ✅ **Starship** | Smart prompt                  | `starship config` to edit configuration         |

---

## 📝 Aliases

### Python
- `p3` → `python3`
- `pt` → `ptpython`
- `vd` → `deactivate`

### Git/UI/LS
- `lg` → `lazygit`
- `la` → `eza -laF --icons --header`
- `ll` → `eza -lF --icons --header`
- `cl` → `clear`
- `fd` → `fdfind`
- `cd` → `z` (zoxide override)

### Neovim
- `v` → nvim with default config
- `rv` → nvim with rootNvim config
- `ns` → Interactive config selector

### DevContainer
- `dc` → `devcontainer`
- `dcb` → `devcontainer up` with rebuild
- `dce` → `devcontainer exec` with fish

### Utilities
- `fishrc` → Edit `config.fish`
- `lfish` → Reload shell

---

## 🔨 Custom Functions

| Function                             | Description                          |
| ------------------------------------ | ------------------------------------ |
| `ns [file]`                          | Neovim config selector               |
| `resetnvim`                          | Reset Neovim configs                 |
| `killproc <process>`                 | Kill a process by name               |
| `va`                                 | Auto-activate Python venv            |
| `uv_init <python-version>`           | Initialize a Python project with UV  |
| `psqldocker <container> <user> <db>` | Connect to PostgreSQL in a container |

---

## ⌨️ Keybindings

Fish has sensible default keybindings:

| Keybinding          | Action                                     |
| ------------------- | ------------------------------------------ |
| `Ctrl+P` / `Ctrl+N` | Previous/next history entry                |
| `Ctrl+R`            | FZF history search (when fzf is installed) |
| `Ctrl+A` / `Ctrl+E` | Start/end of line                          |
| `Alt+F` / `Alt+B`   | Word forward/backward                      |

> **Note:** To add more keybindings, edit: `~/.config/fish/conf.d/000_init.fish`

---

## 📚 History

### Active Configuration
- `fish_history = max` (saves all history)
- History shared across open tabs
- **File:** `~/.local/share/fish/fish_history`

### Useful Commands
```fish
builtin history                 # View history
builtin history delete <item>   # Delete item
builtin history clear           # Clear everything
```

---

## 🔐 Secrets

Create `~/.secrets.fish` with sensitive variables:

```fish
set -gx API_KEY "your_key"
set -gx DATABASE_URL "postgresql://..."
```

It will be loaded automatically (if it exists).

---

## 🚀 Getting Started

1. **Make Fish the default shell:**
   ```bash
   chsh -s /usr/bin/fish
   ```

2. **Reload configuration:**
   ```fish
   source ~/.config/fish/config.fish
   ```

3. **Or simply:**
   ```fish
   exec fish
   ```

---

## 📖 Documentation

- **Fish Official:** https://fishshell.com/docs/current/
- **Starship:** https://starship.rs/
- **Zoxide:** https://github.com/ajeetdsouza/zoxide
- **FZF:** https://github.com/junegunn/fzf
- **Mise:** https://github.com/jdx/mise

---

## 💡 Tips

1. Auto-completions work really well in Fish
2. Environment variables with `set -gx` (global export)
3. Functions in separate files under `~/.config/fish/functions/`
4. Test config with: `fish -c "source ~/.config/fish/config.fish"`
5. List all functions: `functions` (no args)
6. List all variables: `set` (no args)
