#!/usr/bin/env fish
# Fish Shell Configuration - Referência Rápida
# Migração completa do Zsh (oh-my-zsh + Powerlevel10k + Zinit)

#==============================================================================
# 📋 ESTRUTURA DE CONFIGURAÇÃO
#==============================================================================

# ~/.config/fish/config.fish          - Configuração principal
# ~/.config/fish/functions/           - Funções personalizadas
# ~/.config/fish/conf.d/              - Configurações modulares
# ~/.config/starship.toml             - Tema do prompt (Starship)
# ~/.secrets.fish                     - Secretos (opcional)

#==============================================================================
# 🎨 TEMA & PROMPT
#==============================================================================

# Starship (equivalente ao Powerlevel10k)
# - Config: ~/.config/starship.toml
# - Prompt minimalista com 2 linhas
# - Suporte a Git, Docker, Kubernetes, linguagens, etc.
# - Inicialização automática via config.fish

# Alternativa: P10K + Zinit em Zsh (não migrado para Fish)
# Se quiser usar Powerlevel10k em Fish, veja:
#   https://github.com/romkatv/powerlevel10k#fish

#==============================================================================
# 🔧 FERRAMENTAS INTEGRADAS
#==============================================================================

# ✅ Zoxide  - Navegação inteligente
#    Use: z <directory>  ou  zi <directory_interactive>

# ✅ Mise    - Gerenciador de versões de linguagens
#    Use: mise use python@3.12  (e outras ferramentas)

# ✅ FZF     - Fuzzy finder
#    Use: Ctrl+R para buscar histórico

# ✅ Starship - Prompt inteligente
#    Use: starship config para editar configuração

#==============================================================================
# 📝 ALIASES
#==============================================================================

# Python
#   p3           - python3
#   pt           - ptpython
#   vd           - deactivate

# Git/UI/LS
#   lg           - lazygit
#   la           - eza -laF --icons --header
#   ll           - eza -lF --icons --header
#   cl           - clear
#   fd           - fdfind
#   cd           - z (zoxide override)

# Neovim
#   v            - nvim com config padrão
#   rv           - nvim com config rootNvim
#   ns           - Seletor interativo de config

# DevContainer
#   dc           - devcontainer
#   dcb          - devcontainer up com rebuild
#   dce          - devcontainer exec com fish

# Utilidades
#   fishrc       - Editar config.fish
#   lfish        - Recarregar shell

#==============================================================================
# 🔨 FUNÇÕES PERSONALIZADAS
#==============================================================================

# ns [arquivo]                      - Seletor de config Neovim
# resetnvim                         - Reset das configs do Neovim
# killproc <processo>               - Mata um processo por nome
# va                                - Ativa Python venv automático
# uv_init <python-version>          - Inicializa projeto Python com UV
# psqldocker <container> <user> <db> - Conecta ao PostgreSQL em container

#==============================================================================
# ⌨️  KEYBINDINGS
#==============================================================================

# Fish possui keybindings sensatos por padrão:
# - Ctrl+P / Ctrl+N      - Histórico anterior/próximo
# - Ctrl+R               - FZF history search (quando fzf está instalado)
# - Ctrl+A / Ctrl+E      - Início/fim da linha
# - Alt+F / Alt+B        - Palavra frente/trás

# Para adicionar mais keybindings, edite: ~/.config/fish/conf.d/000_init.fish

#==============================================================================
# 📚 HISTÓRIA
#==============================================================================

# Configuração ativa:
#   - fish_history = max (salva todo histórico)
#   - Histórico compartilhado entre abas abertas
#   - Arquivo: ~/.local/share/fish/fish_history

# Comandos úteis:
#   builtin history                 - Ver histórico
#   builtin history delete <item>   - Deletar item
#   builtin history clear           - Limpar tudo

#==============================================================================
# 🔐 SECRETS
#==============================================================================

# Crie ~/.secrets.fish com variáveis sensíveis:
#   set -gx API_KEY "sua_chave"
#   set -gx DATABASE_URL "postgresql://..."

# Será carregado automaticamente (se existir)

#==============================================================================
# 🚀 COMO INICIAR
#==============================================================================

# 1. Fazer Fish o shell padrão:
#    chsh -s /usr/bin/fish

# 2. Recarregar configuração:
#    source ~/.config/fish/config.fish

# 3. Ou simplesmente:
#    exec fish

#==============================================================================
# 📖 DOCUMENTAÇÃO
#==============================================================================

# Fish Official: https://fishshell.com/docs/current/
# Starship:      https://starship.rs/
# Zoxide:        https://github.com/ajeetdsouza/zoxide
# FZF:           https://github.com/junegunn/fzf
# Mise:          https://github.com/jdx/mise

#==============================================================================
# 💡 DICAS
#==============================================================================

# 1. Completions automáticas funcionam muito bem em Fish
# 2. Variáveis de ambiente com set -gx (global export)
# 3. Funções em arquivos separados em ~/.config/fish/functions/
# 4. Teste config com: fish -c "source ~/.config/fish/config.fish"
# 5. Ver todas as funções: functions (sem parâmetros)
# 6. Ver todas as variáveis: set (sem parâmetros)

#==============================================================================
