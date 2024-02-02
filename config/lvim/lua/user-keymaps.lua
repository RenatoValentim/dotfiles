lvim.builtin.which_key.mappings["W"] = { ":wa<Return>", "Save All" }
lvim.builtin.which_key.mappings["Q"] = { ":q!<Return>", "Force Quit" }
lvim.builtin.which_key.mappings["x"] = { ":x<Return>", "Save Quit" }
lvim.builtin.which_key.mappings["u"] = {
  name = "utils",
  z = {
    name = "Zoom",
    i = { "<c-w>_ | <c-w>|", "Zoom In" },
    o = { "<c-w>=", "Zoom Out" },
  },
  w = {
    name = "Move window",
    h = { ":wincmd H<Return>", "Move current split window to the far left" },
    j = { ":wincmd J<Return>", "Move current split window to the very bottom" },
    k = { ":wincmd K<Return>", "Move current split window to the very top" },
    l = { ":wincmd L<Return>", "Move current split window to the far right" },
  },
  t = {
    name = "TODO",
    q = { ":TodoQuickFix<Return>", "List quick fix" },
    l = { ":TodoLocList<Return>", "List all todos" },
    t = { ":TodoTelescope<Return>", "List all todos whit telescope" },
  },
}
lvim.builtin.which_key.mappings["v"] = {
  name = "Virtual Text",
  d = { ":lua vim.diagnostic.config({ virtual_text = false })<Return>", "Disable Virtual Text" },
  e = { ":lua vim.diagnostic.config({ virtual_text = true })<Return>", "Enable Virtual Text" },
}
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "Trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
}
lvim.builtin.which_key.mappings.g.d = {
  name = "Git Diff",
  o = { ":DiffviewOpen<Return>", "Open Git Diff" },
  c = { ":DiffviewClose<Return>", "Close Git Diff" },
}
lvim.builtin.which_key.mappings["f"] = { ":Telescope find_files<Return>", "Find Files" }
lvim.builtin.which_key.mappings.d = {
  name = "Debug",
  t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
  x = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", "Clear all Breakpoints" },
  b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
  c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
  d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
  -- g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
  i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
  o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
  -- u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  -- p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
  -- r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
  -- s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
  -- q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
  u = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
}

lvim.keys.normal_mode["gl"] = "<cmd>lua vim.diagnostic.open_float()<CR>"
lvim.keys.normal_mode["gk"] = "<cmd>lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["gj"] = "<cmd>lua vim.diagnostic.goto_next()<CR>"
lvim.keys.normal_mode["+"] = "<C-a>"
lvim.keys.normal_mode["-"] = "<C-x>"
lvim.keys.normal_mode["<C-a>"] = "gg<S-v>G"
lvim.keys.normal_mode["<C-c>"] = ":"
lvim.keys.normal_mode["ss"] = ":split<Return><C-w>w"
lvim.keys.normal_mode["vs"] = ":vsplit<Return><C-w>w"
lvim.keys.insert_mode["<C-l>"] = "<right>"
lvim.keys.insert_mode["<C-h>"] = "<left>"
lvim.keys.insert_mode["<C-j>"] = "<down>"
lvim.keys.insert_mode["<C-k>"] = "<up>"
lvim.keys.normal_mode["<A-left>"] = "<C-w><"
lvim.keys.normal_mode["<A-right>"] = "<C-w>>"
lvim.keys.normal_mode["<A-up>"] = "<C-w>+"
lvim.keys.normal_mode["<A-down>"] = "<C-w>-"
lvim.keys.normal_mode["<A-k>"] = ":move .-2<Return>=="
lvim.keys.normal_mode["<A-j>"] = ":move .+1<Return>=="
lvim.keys.visual_mode["<A-k>"] = ":move '<-2<Return>gv=gv"
lvim.keys.visual_mode["<A-j>"] = ":move '>+1<Return>gv=gv"
lvim.keys.insert_mode["<A-k>"] = "<Esc>:move .-2<Return>==gi"
lvim.keys.insert_mode["<A-j>"] = "<Esc>:move .+1<Return>==gi"
lvim.keys.visual_mode["<"] = "<gv"
lvim.keys.visual_mode[">"] = ">gv"
lvim.keys.insert_mode["jk"] = "<ESC>"
