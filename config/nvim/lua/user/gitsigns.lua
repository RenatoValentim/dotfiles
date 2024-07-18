local M = {
  'lewis6991/gitsigns.nvim',
  commit = 'a36bc3360d584d39b4fb076d855c4180842d4444',
  event = 'BufReadPre',
}

local icons = require 'utils.icons'

M.opts = {
  signs = {
    add = { hl = 'GitSignsAdd', text = icons.plugins.gitsigns.add, numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = {
      hl = 'GitSignsChange',
      text = icons.plugins.gitsigns.change,
      numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn',
    },
    delete = {
      hl = 'GitSignsDelete',
      text = icons.plugins.gitsigns.delete,
      numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn',
    },
    topdelete = {
      hl = 'GitSignsDelete',
      text = icons.plugins.gitsigns.topdelete,
      numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn',
    },
    changedelete = {
      hl = 'GitSignsChange',
      text = icons.plugins.gitsigns.changedelete,
      numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn',
    },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = true,
  current_line_blame_formatter = ' <author>, <author_time:%Y-%m-%d %H:%M:%S> - <summary>',
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 5,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
}

return M
