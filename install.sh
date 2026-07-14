#!/usr/bin/env bash
# Run by the devcontainer CLI after it clones this repo to ~/dotfiles.
# Idempotent: safe to re-run on an existing container.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config/fish/conf.d"

for f in config.fish fish_plugins fish_variables starship.toml completions functions; do
  ln -sfn "$DOTFILES/config/fish/$f" "$HOME/.config/fish/$f"
done

for f in "$DOTFILES"/config/fish/conf.d/*; do
  ln -sfn "$f" "$HOME/.config/fish/conf.d/"
done

# The base image ships a throwaway LazyVim starter to warm the plugin cache.
# Replace it with the real config.
rm -rf "$HOME/.config/nvim"
ln -sfn "$DOTFILES/config/lazyvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES/config/lazygit" "$HOME/.config/lazygit"

git config --global core.editor nvim
