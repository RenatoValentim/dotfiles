local actions = require('utils.actions')

local M = {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    auto_close = true,
  },
  keys = {
    r = 'refresh',
    q = 'close',
    o = 'jump_close',
    {
      '<leader>td',
      actions.trouble.diagnostics.command,
      actions.trouble.diagnostics.desc,
    },
    {
      '<leader>tdf',
      actions.trouble.diagnostics_current_file.command,
      actions.trouble.diagnostics_current_file.desc,
    },
    {
      '<leader>cs',
      actions.trouble.symbols.command,
      actions.trouble.symbols.desc,
    },
    {
      '<leader>tr',
      '<cmd>Trouble lsp toggle focus=true<Return>',
      desc = 'LSP Definitions / references / ... (Trouble)',
      actions.trouble.lsp_definitions_references.command,
      actions.trouble.lsp_definitions_references.desc,
    },
    {
      '<leader>tl',
      actions.trouble.loclist.command,
      actions.trouble.loclist.desc,
    },
    {
      '<leader>tq',
      actions.trouble.qflist.command,
      actions.trouble.qflist.desc,
    },
  },
}

return M
