local M = {
  "folke/which-key.nvim",
  commit = "65b36cc258e857dea92fc11cdc0d6e2bb01d3e87",
  event = "VeryLazy",
}

function M.config()
  local which_key = {
    setup = {
      plugins = {
        marks = true,
        registers = true,
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = true,
          z = true,
          g = true,
        },
        spelling = { enabled = true, suggestions = 20 },
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left", -- align columns left, center or right
      },
      hidden = { "<silent>", ":", ":", "<Return>", "call", "lua", "^:", "^ " },
      ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      show_help = true,
      triggers = "auto", -- automatically setup triggers
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
      },
    },
    opts = {
      mode = "n",
      prefix = "<leader>",
      buffer = nil,
      silent = false,
      noremap = true,
      nowait = true,
    },
    vopts = {
      mode = "v",
      prefix = "<leader>",
      buffer = nil,
      silent = false,
      noremap = true,
      nowait = true,
    },
    -- NOTE: Prefer using : over : as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    vmappings = {
      ["/"] = { "<ESC>:lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<Return>", "Comment" },
      f = { ":lua vim.lsp.buf.range_formatting()<Return>", "Format select" },
      z = {
        name = "Folding",
        f = { "zf", "Create Fold" },
        o = { "zo", "Open Fold" },
        c = { "zc", "Close Fold" },
      },
    },
    mappings = {
      [";"] = { ":Alpha<Return>", "Dashboard" },
      ["a"] = { ":Lazy<Return>", "Lazy" },
      ["w"] = { ":w<Return>", "Save" },
      ["W"] = { ":w!<Return>", "Force save" },
      ["x"] = { ":x<Return>", "Save quit" },
      ["q"] = { ":q<Return>", "Quit" },
      ["Q"] = { ":q!<Return>", "Force quit" },
      ["d"] = { "dd", "Delete Line" },
      ["N"] = { ":e ~/.config/nvim/init.lua<Return>", "Open neovim config file" },
      ["e"] = { ":NvimTreeToggle<Return>", "NvimTree" },
      c = {
        name = "Commands",
        f = { ":!", "CMD Filter" },
        l = { ":", "CMD Mode" },
      },
      v = {
        name = "Virtual Text",
        d = { ":lua vim.diagnostic.config({ virtual_text = false })<Return>", "Disable Virtual Text" },
        e = { ":lua vim.diagnostic.config({ virtual_text = true })<Return>", "Enable Virtual Text" },
      },
      b = {
        name = "Buffers",
        c = { ":bdelete<Return>", "Close Buffer" },
        L = { ":BufferLineCycleNext<Return>", "buffer left" },
        H = { ":BufferLineCyclePrev<Return>", "Buffer right" },
        l = { ":BufferLineCloseRight<Return>", "Close all right" },
        h = { ":BufferLineCloseLeft<Return>", "Close all left" },
        p = { ":BufferLinePickClose<Return>", "Pick which buffer to close" },
        f = { ":Telescope buffers<Return>", "All open buffers" },
        r = { ":<C-6><Return>", "Reopen recently closed buffer" },
      },
      f = {
        name = "Find",
        f = {
          ":lua require('telescope.builtin').find_files({no_ignore = false, hidden = true})<Return>",
          "Find files",
        },
        g = {
          ":lua require('telescope.builtin').live_grep()<Return>",
          "Find grep",
        },
        b = {
          ":lua require('telescope.builtin').buffers()<Return>",
          "Find buffers",
        },
        t = {
          ":lua require('telescope.builtin').help_tags()<Return>",
          "Find tags",
        },
        r = {
          ":lua require('telescope.builtin').resume()<Return>",
          "Find resume",
        },
        d = {
          ":lua require('telescope.builtin').diagnostics()<Return>",
          "Find diagnostics",
        },
        k = {
          ":lua require('telescope.builtin').keymaps()<Return>",
          "Find Keymaps",
        },
        p = {
          ":lua require('telescope').extensions.projects.projects()<Return>",
          "Find Projects",
        },
      },
      l = {
        name = "LSP",
        d = { ":Telescope lsp_document_symbols<Return>", "Document Symbols" },
        f = { ":lua vim.lsp.buf.format()<Return>", "Format" },
        i = { ":LspInfo<Return>", "Info" },
        m = { ":Mason<Return>", "Installer Info - Mason" },
        r = { ":lua vim.lsp.buf.rename()<Return>", "Rename" },
      },
      g = {
        name = "Git",
        s = { ":Telescope git_status<Return>", "Open changed file in git status" },
        d = {
          ":Gitsigns diffthis HEAD<Return>",
          "Git Diff",
        },
        l = { ":lua require 'gitsigns'.blame_line()<Return>", "Blame" },
        b = { ":Telescope git_branches<Return>", "Checkout branch" },
        c = { ":Telescope git_commits<Return>", "All Commits" },
        g = { "<cmd>lua _LAZYGIT_TOGGLE()<Return>", "Lazygit" },
      },
      u = {
        name = "Utils",
        t = {
          name = "TODO",
          q = { ":TodoQuickFix<Return>", "List quick fix" },
          l = { ":TodoLocList<Return>", "List all todos" },
          t = { ":TodoTelescope<Return>", "List all todos whit telescope" },
        },
        a = { ":Lspsaga code_action<Return>", "Code Action" },
        e = {
          name = "Explorer",
          e = { ":e ", "Native neovim explorer" },
        },
        f = { ":find ", "Native neovim finder" },
        r = { ":luafile %<Return>", "Reload lua files" },
        p = {
          name = "Pomodoro",
          i = { ":PomodoroStart<Return>", "Start pomodoro timer" },
          s = { ":PomodoroStatus<Return>", "Status of the pomodoro timer" },
          e = { ":PomodoroStop<Return>", "Stop pomodoro timer" },
        },
        z = {
          name = "Zoom screen",
          i = { "<c-w>_ | <c-w>|", "Zoom in screen" },
          o = { "<c-w>=", "Zoom out screen" },
        },
      },
      t = {
        name = "Trouble",
        r = { ":Trouble lsp_references<Return>", "References" },
        f = { ":Trouble lsp_definitions<Return>", "Definitions" },
        d = { ":Trouble document_diagnostics<Return>", "Diagnostics" },
        q = { ":Trouble quickfix<Return>", "QuickFix" },
        l = { ":Trouble loclist<Return>", "LocationList" },
        w = { ":Trouble workspace_diagnostics<Return>", "Wordspace Diagnostics" },
      },
    },
  }

  local status_ok, wk = pcall(require, "which-key")
  if not status_ok then
    return
  end

  wk.setup(which_key.setup)

  local opts = which_key.opts
  local vopts = which_key.vopts

  local mappings = which_key.mappings
  local vmappings = which_key.vmappings

  wk.register(mappings, opts)
  wk.register(vmappings, vopts)

  if which_key.on_config_done then
    which_key.on_config_done(wk)
  end
end

return M
