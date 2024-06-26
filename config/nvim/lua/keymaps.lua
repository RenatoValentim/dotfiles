local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<Space>", "<Nop>", opts)

keymap.set("n", "<leader>w", ":w<Return>", opts)
keymap.set("n", "<leader>W", ":wa<Return>", opts)
keymap.set("n", "<leader>q", ":q<Return>", opts)
keymap.set("n", "<leader>Q", ":q!<Return>", opts)
keymap.set("n", "<leader>x", ":x<Return>", opts)
keymap.set("n", "<leader>ue", ":e ")
keymap.set("n", "<leader>uf", ":find ")
keymap.set("n", "<C-c>c", ":!")
keymap.set("n", "<C-c>", ":")
keymap.set("n", "<leader>ur", ":luafile %<Return>", opts)
keymap.set("n", "<leader>h", ":nohlsearch<Return>", opts)
keymap.set("n", "<leader>N", ":e $MYVIMRC <CR>", opts)
keymap.set("n", "<leader>Nl", ":luafile %<Return>", opts)
keymap.set("n", "<C-f>", ":%s///gc")
keymap.set("n", "<C-f>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]])
keymap.set("n", "<C-f>f", [[:/\<<C-r><C-w>\>/<Return>]])
keymap.set("n", "<leader>uzi", "<c-w>_ | <c-w>|")
keymap.set("n", "<leader>uzo", "<c-w>=")

keymap.set("n", "x", '"_x', opts)

-- Increment/decrement
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w", opts)
keymap.set("n", "vs", ":vsplit<Return><C-w>w", opts)

-- Move window
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Move cursor on insert mode
keymap.set("i", "<C-l>", "<right>", opts)
keymap.set("i", "<C-h>", "<left>", opts)
keymap.set("i", "<C-j>", "<down>", opts)
keymap.set("i", "<C-k>", "<up>", opts)

-- Resize window
keymap.set("n", "<A-left>", "<C-w><", opts)
keymap.set("n", "<A-right>", "<C-w>>", opts)
keymap.set("n", "<A-up>", "<C-w>+", opts)
keymap.set("n", "<A-down>", "<C-w>-", opts)

-- Move current line / block with Alt-j/k a la vscode.
-- Move text up and down
keymap.set("n", "<A-k>", ":move .-2<Return>==", opts)
keymap.set("n", "<A-j>", ":move .+1<Return>==", opts)
keymap.set("v", "<A-k>", ":move '<-2<Return>gv=gv", opts)
keymap.set("v", "<A-j>", ":move '>+1<Return>gv=gv", opts)
keymap.set("i", "<A-k>", "<Esc>:move .-2<Return>==gi", opts)
keymap.set("i", "<A-j>", "<Esc>:move .+1<Return>==gi", opts)

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

keymap.set("i", "jk", "<ESC>", opts)

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<Return>", opts)
keymap.set("n", "<leader>fg", ":Telescope live_grep<Return>", opts)
keymap.set("n", "<leader>fb", ":Telescope buffers<Return>", opts)
keymap.set("n", "<leader>fr", ":Telescope resume<Return>", opts)
keymap.set("n", "<leader>fd", ":Telescope diagnostics<Return>", opts)
keymap.set("n", "<leader>fd", ":Telescope keymaps<Return>", opts)
keymap.set("n", "<leader>fs", ":Telescope current_buffer_fuzzy_find<Return>", opts)

-- Trouble
keymap.set("n", "<leader>tr", ":Trouble lsp_references<Return>")
keymap.set("n", "<leader>tf", ":Trouble lsp_definitions<Return>")
keymap.set("n", "<leader>td", ":Trouble document_diagnostics<Return>")
keymap.set("n", "<leader>tq", ":Trouble quickfix<Return>")
keymap.set("n", "<leader>tl", ":Trouble loclist<Return>")
keymap.set("n", "<leader>tw", ":Trouble workspace_diagnostics<Return>")

-- lspsaga
keymap.set({ "n", "v" }, "<leader>ua", ":Lspsaga code_action<Return>")

-- Git
keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap.set("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)
