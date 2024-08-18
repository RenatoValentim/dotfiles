-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

local function getKeymapOptions(noremap, silent, desc)
  return { noremap = noremap, silent = silent, desc = desc }
end

-- Dev
map('n', '<leader>mw', ':w<Return>', getKeymapOptions(true, true, 'Save Current File'))
map('n', '<leader>mq', ':q<Return>', getKeymapOptions(true, true, 'Quit Current File'))
map('n', '<leader>mQ', ':q!<Return>', getKeymapOptions(true, true, 'Force Quit Current File'))
map('n', '<leader>mx', ':x<Return>', getKeymapOptions(true, true, 'Save Quit Current File'))
map('n', '<leader>mh', ':nohlsearch<Return>', getKeymapOptions(true, true, 'Turn Highlight Off'))
map('n', '<leader>mN', ':e $MYVIMRC <CR>', getKeymapOptions(true, true, 'Open Neovim Config'))
map('n', '<leader>mzi', '<c-w>_ | <c-w>|')
map('n', '<leader>mzo', '<c-w>=')

-- Increment/decrement
map('n', '+', '<C-a>', getKeymapOptions(true, true, 'Increment Number'))
map('n', '-', '<C-x>', getKeymapOptions(true, true, 'Decrement Number'))

-- Move cursor on insert mode
map('i', '<C-l>', '<right>', getKeymapOptions(true, true, 'Insert Mode Mode Cursor Right'))
map('i', '<C-h>', '<left>', getKeymapOptions(true, true, 'Insert Mode Mode Cursor Left'))
map('i', '<C-j>', '<down>', getKeymapOptions(true, true, 'Insert Mode Mode Cursor Down'))
map('i', '<C-k>', '<up>', getKeymapOptions(true, true, 'Insert Mode Mode Cursor Up'))

map('i', 'jk', '<ESC>')
