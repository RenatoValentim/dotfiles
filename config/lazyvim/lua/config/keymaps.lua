-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

local function get_keymap_options(noremap, silent, desc)
  return { noremap = noremap, silent = silent, desc = desc }
end

-- Dev
map('n', '<leader>mq', ':q<Return>', get_keymap_options(true, true, 'Quit Current File'))
map('n', '<leader>mQ', ':q!<Return>', get_keymap_options(true, true, 'Force Quit Current File'))
map('n', '<leader>mx', ':x<Return>', get_keymap_options(true, true, 'Save Quit Current File'))
map('n', '<leader>mh', ':nohlsearch<Return>', get_keymap_options(true, true, 'Turn Highlight Off'))
map('n', '<leader>mN', ':e $MYVIMRC <CR>', get_keymap_options(true, true, 'Open Neovim Config'))
map('n', '<leader>mzi', '<c-w>_ | <c-w>|')
map('n', '<leader>mzo', '<c-w>=')
map('n', '<leader>h', ':nohlsearch<Return>', get_keymap_options(true, true, 'Turn Off Highlight'))

-- lsp diagnostic
map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', get_keymap_options(true, true, 'Diagnostic Open Float'))
map('n', 'gk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', get_keymap_options(true, true, 'Diagnostic Go Prev'))
map('n', 'gj', '<cmd>lua vim.diagnostic.goto_next()<CR>', get_keymap_options(true, true, 'Diagnostic Go Next'))

-- Alpha dashboard
map('n', '<leader>;', ':Alpha<Return>', get_keymap_options(true, true, 'Go to Alpha Dashboard'))

-- Increment/decrement
map('n', '+', '<C-a>', get_keymap_options(true, true, 'Increment Number'))
map('n', '-', '<C-x>', get_keymap_options(true, true, 'Decrement Number'))

-- Move cursor on insert mode
map('i', '<C-l>', '<right>', get_keymap_options(true, true, 'Insert Mode Mode Cursor Right'))
map('i', '<C-h>', '<left>', get_keymap_options(true, true, 'Insert Mode Mode Cursor Left'))
map('i', '<C-j>', '<down>', get_keymap_options(true, true, 'Insert Mode Mode Cursor Down'))
map('i', '<C-k>', '<up>', get_keymap_options(true, true, 'Insert Mode Mode Cursor Up'))

map('i', 'jk', '<ESC>')
