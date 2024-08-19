-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

local key_options = require('me.utils.keymap_options_config').set_keymap_options

-- Dev
map('n', '<C-q>', ':q<Return>', key_options({ desc = 'Quit Current File' }))
map('n', '<A-n>', ':e $MYVIMRC <CR>', key_options({ desc = 'Open Neovim Config' }))
map('n', '<C-x>', ':x<Return>', key_options({ desc = 'Save Quit Current File' }))
map('n', '<leader>zi', '<c-w>_ | <c-w>|')
map('n', '<leader>zo', '<c-w>=')
map('n', '<leader>h', ':nohlsearch<Return>', key_options({ desc = 'Turn Off Highlight' }))

-- lsp diagnostic
map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', key_options({ desc = 'Diagnostic Open Float' }))
map('n', 'gk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', key_options({ desc = 'Diagnostic Go Prev' }))
map('n', 'gj', '<cmd>lua vim.diagnostic.goto_next()<CR>', key_options({ desc = 'Diagnostic Go Next' }))

-- Alpha dashboard
map('n', '<leader>;', ':Alpha<Return>', key_options({ desc = 'Go to Alpha Dashboard' }))

-- Increment/decrement
map('n', '+', '<C-a>', key_options({ desc = 'Increment Number' }))
map('n', '-', '<C-x>', key_options({ desc = 'Decrement Number' }))

-- Move cursor on insert mode
map('i', '<C-l>', '<right>', key_options({ desc = 'Insert Mode Mode Cursor Right' }))
map('i', '<C-h>', '<left>', key_options({ desc = 'Insert Mode Mode Cursor Left' }))
map('i', '<C-j>', '<down>', key_options({ desc = 'Insert Mode Mode Cursor Down' }))
map('i', '<C-k>', '<up>', key_options({ desc = 'Insert Mode Mode Cursor Up' }))

map('i', 'jk', '<ESC>')
