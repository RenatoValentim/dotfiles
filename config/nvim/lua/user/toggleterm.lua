local M = {
  'akinsho/toggleterm.nvim',
  commit = '19aad0f41f47affbba1274f05e3c067e6d718e1e',
  event = 'VeryLazy',
}

function M.config()
  local status_ok, toggleterm = pcall(require, 'toggleterm')
  if not status_ok then
    return
  end

  toggleterm.setup {
    size = 20,
    open_mapping = [[<c-t>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = false,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      width = 100000,
      height = 40,
    },
  }

  function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    -- vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    -- vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
  end

  vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new {
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
    float_opts = {
      border = 'none',
      width = 100000,
      height = 45,
    },
    on_open = function(_)
      vim.cmd 'startinsert!'
    end,
    on_close = function(_) end,
    count = 99,
  }

  function _LAZYGIT_TOGGLE()
    lazygit:toggle()
  end
end

return M
