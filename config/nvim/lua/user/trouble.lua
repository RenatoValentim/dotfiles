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
      '<leader>tdd',
      actions.trouble.diagnostics.command,
      actions.trouble.diagnostics.desc,
    },
    {
      '<leader>tdf',
      actions.trouble.diagnostics_current_file.command,
      actions.trouble.diagnostics_current_file.desc,
    },
    {
      '<leader>ts',
      actions.trouble.symbols.command,
      actions.trouble.symbols.desc,
    },
    {
      '<leader>tr',
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
