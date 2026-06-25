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

log "Done."
