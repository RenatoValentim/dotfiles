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
      '<leader>ctd',
      '<cmd>Trouble diagnostics toggle focus=true<Return>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>ctf',
      '<cmd>Trouble diagnostics toggle focus=true filter.buf=0<Return>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>ctr',
      '<cmd>Trouble lsp toggle focus=true win.position=bottom<Return>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
  },
}

return M
