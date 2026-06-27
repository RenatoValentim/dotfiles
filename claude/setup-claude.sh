#!/usr/bin/env bash
set -euo pipefail

log() { echo "[setup-claude] $*"; }

log "Installing rtk..."
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
log "rtk installed."

log "Registering extra marketplaces..."
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add JuliusBrussee/caveman
claude plugin marketplace add obra/superpowers-marketplace
log "Marketplaces registered."

log "Installing plugins..."
claude plugin install zscaler@claude-plugins-official
claude plugin install caveman@caveman
claude plugin install gopls-lsp@claude-plugins-official
claude plugin install context7@claude-plugins-official
claude plugin install superpowers@superpowers-marketplace
log "All plugins installed."

log "Linking Claude configs..."
mkdir -p "$HOME/.claude/skills"
ln -sf "$HOME/dotfiles/claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$HOME/dotfiles/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
for skill in "$HOME/dotfiles/claude/skills/"*; do
  ln -sf "$skill" "$HOME/.claude/skills/$(basename "$skill")"
done
log "Claude configs linked."

log "Done."
