local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap.set("n", "<Space>", "<Nop>")

keymap.set("n", "<leader>w", ":w<Return>")
keymap.set("n", "<leader>W", ":wa<Return>")
keymap.set("n", "<leader>q", ":q<Return>")
keymap.set("n", "<leader>Q", ":q!<Return>")
keymap.set("n", "<leader>x", ":x<Return>")
keymap.set("n", "<leader>ue", ":e ")
keymap.set("n", "<leader>uf", ":find ")
keymap.set("n", "<leader>uc", ":! ")
keymap.set("n", "<leader>ur", ":luafile %<Return>")
keymap.set("n", "<leader>d", "dd")
keymap.set("n", "<leader>uh", ":nohlsearch<Return>")
keymap.set("n", "<leader>Nc", ":e ~/.config/nvim/init.lua<Return>")
keymap.set("n", "<leader>Nl", ":luafile %<Return>")
keymap.set("n", "<C-f>", ":%s///gc")
keymap.set("n", "<C-f>f", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
keymap.set("n", "te", ":tabedit ")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "vs", ":vsplit<Return><C-w>w")

-- Move window
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- Resize window
keymap.set("n", "<A-left>", "<C-w><")
keymap.set("n", "<A-right>", "<C-w>>")
keymap.set("n", "<A-up>", "<C-w>+")
keymap.set("n", "<A-down>", "<C-w>-")

-- Move current line / block with Alt-j/k a la vscode.
-- Move text up and down
keymap.set("n", "<A-k>", ":move .-2<Return>==")
keymap.set("n", "<A-j>", ":move .+1<Return>==")
keymap.set("v", "<A-k>", ":move '<-2<Return>gv=gv")
keymap.set("v", "<A-j>", ":move '>+1<Return>gv=gv")
keymap.set("i", "<A-k>", "<Esc>:move .-2<Return>==gi")
keymap.set("i", "<A-j>", "<Esc>:move .+1<Return>==gi")

keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

keymap.set("i", "jk", "<ESC>")
