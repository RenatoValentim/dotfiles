local actions = require('utils.actions')

local M = {
  'folke/which-key.nvim',
  commit = '65b36cc258e857dea92fc11cdc0d6e2bb01d3e87',
  event = 'VeryLazy',
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
        breadcrumb = '»',
        separator = '➜',
        group = '+',
      },
      window = {
        border = 'single',   -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = 'left', -- align columns left, center or right
      },
      hidden = { '<silent>', ':', ':', '<Return>', 'call', 'lua', '^:', '^ ' },
      ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      show_help = true,
      triggers = 'auto',     -- automatically setup triggers
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { 'j', 'k' },
        v = { 'j', 'k' },
      },
    },
    opts = {
      mode = 'n',
      prefix = '<leader>',
      buffer = nil,
      silent = false,
      noremap = true,
      nowait = true,
    },
    vopts = {
      mode = 'v',
      prefix = '<leader>',
      buffer = nil,
      silent = false,
      noremap = true,
      nowait = true,
    },
    -- NOTE: Prefer using : over : as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    vmappings = {
      ['/'] = { "<ESC>:lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<Return>", 'Comment' },
      f = { ':lua vim.lsp.buf.range_formatting()<Return>', 'Format select' },
      z = {
        name = 'Folding',
        f = { 'zf', 'Create Fold' },
        o = { 'zo', 'Open Fold' },
        c = { 'zc', 'Close Fold' },
      },
    },
    mappings = {
      [';'] = { ':Alpha<Return>', 'Dashboard' },
      ['a'] = { ':Lazy<Return>', 'Lazy' },
      ['w'] = { ':w<Return>', 'Save' },
      ['W'] = { ':w!<Return>', 'Force save' },
      ['x'] = { ':x<Return>', 'Save quit' },
      ['q'] = { ':q<Return>', 'Quit' },
      ['Q'] = { ':q!<Return>', 'Force quit' },
      ['N'] = { ':e $MYVIMRC <CR>', 'Open neovim config file' },
      ['e'] = { ':NvimTreeToggle<Return>', 'NvimTree' },
      c = {
        name = 'CMDs',
        f = { ':!', 'CMD Filer' },
        c = { ':', 'CMD mode' },
      },
      d = {
        name = 'Debug',
        t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Toggle Breakpoint' },
        x = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", 'Clear all Breakpoints' },
        b = { "<cmd>lua require'dap'.step_back()<cr>", 'Step Back' },
        c = { "<cmd>lua require'dap'.continue()<cr>", 'Continue' },
        C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", 'Run To Cursor' },
        d = { "<cmd>lua require'dap'.disconnect()<cr>", 'Disconnect' },
        g = { "<cmd>lua require'dap'.session()<cr>", 'Get Session' },
        i = { "<cmd>lua require'dap'.step_into()<cr>", 'Step Into' },
        o = { "<cmd>lua require'dap'.step_over()<cr>", 'Step Over' },
        u = { "<cmd>lua require'dap'.step_out()<cr>", 'Step Out' },
        p = { "<cmd>lua require'dap'.pause()<cr>", 'Pause' },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", 'Toggle Repl' },
        s = { "<cmd>lua require'dap'.continue()<cr>", 'Start' },
        q = { "<cmd>lua require'dap'.close()<cr>", 'Quit' },
        U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", 'Toggle UI' },
      },
      v = {
        name = 'Virtual Text',
        d = { ':lua vim.diagnostic.config({ virtual_text = false })<Return>', 'Disable Virtual Text' },
        e = { ':lua vim.diagnostic.config({ virtual_text = true })<Return>', 'Enable Virtual Text' },
      },
      b = {
        name = 'Buffers',
        c = { ':bdelete<Return>', 'Close Buffer' },
        L = { ':BufferLineCycleNext<Return>', 'buffer left' },
        H = { ':BufferLineCyclePrev<Return>', 'Buffer right' },
        l = { ':BufferLineCloseRight<Return>', 'Close all right' },
        h = { ':BufferLineCloseLeft<Return>', 'Close all left' },
        p = { ':BufferLinePickClose<Return>', 'Pick which buffer to close' },
        f = { actions.telescope.open_all_buffers.command, actions.telescope.open_all_buffers.desc },
        r = { ':<C-6><Return>', 'Reopen recently closed buffer' },
      },
      f = {
        name = 'Find',
        f = { actions.telescope.find_files.command, actions.telescope.find_files.desc },
        g = { actions.telescope.live_grep.command, actions.telescope.live_grep.desc },
        b = { actions.telescope.find_buffers.command, actions.telescope.find_buffers.desc },
        t = { actions.telescope.find_tags.command, actions.telescope.find_tags.desc },
        r = { actions.telescope.find_resume.command, actions.telescope.find_resume.desc },
        d = { actions.telescope.find_diagnostics.command, actions.telescope.find_diagnostics.desc },
        k = { actions.telescope.find_keymaps.command, actions.telescope.find_keymaps.desc },
        p = { actions.telescope.find_projects.command, actions.telescope.find_projects.desc },
        s = { actions.telescope.find_buffer_fuzzy_find.command, actions.telescope.find_buffer_fuzzy_find.desc },
      },
      l = {
        name = 'LSP',
        d = { actions.telescope.lsp_document_symbols.command, actions.telescope.lsp_document_symbols.desc },
        f = { ':lua vim.lsp.buf.format()<Return>', 'Format' },
        i = { ':LspInfo<Return>', 'Info' },
        m = { ':Mason<Return>', 'Installer Info - Mason' },
        r = { ':lua vim.lsp.buf.rename()<Return>', 'Rename' },
      },
      g = {
        name = 'Git',
        s = { actions.telescope.git_status.command, actions.telescope.git_status.desc },
        d = {
          name = 'Git Diff',
          o = { ':DiffviewOpen<Return>', 'Open Git Diff' },
          c = { ':DiffviewClose<Return>', 'Close Git Diff' },
        },
        l = { ":lua require 'gitsigns'.blame_line()<Return>", 'Blame' },
        b = { actions.telescope.git_branch.command, actions.telescope.git_branch.desc },
        c = { actions.telescope.git_commit.command, actions.telescope.git_commit.desc },
        g = { '<cmd>lua _LAZYGIT_TOGGLE()<Return>', 'Lazygit' },
      },
      u = {
        name = 'Utils',
        c = {
          name = 'Colorscheme',
          t = {':ToggleTransparency<Return>', 'Enable | Disable Transparency'},
        },
        t = {
          name = 'TODO',
          q = { actions.todo_comments.quickfix.command, actions.todo_comments.quickfix.desc },
          l = { actions.todo_comments.loclist.command, actions.todo_comments.loclist.desc },
          t = { actions.todo_comments.telescope.command, actions.todo_comments.telescope.desc },
        },
        a = { ':Lspsaga code_action<Return>', 'Code Action' },
        e = { ':e ', 'Native neovim explorer' },
        f = { ':find ', 'Native neovim finder' },
        r = { ':luafile %<Return>', 'Reload lua files' },
        p = {
          name = 'Pomodoro',
          a = { ':PomodoroStart<Return>', 'Start pomodoro timer' },
          o = { ':PomodoroStop<Return>', 'Stop pomodoro timer' },
        },
        z = {
          name = 'Zoom screen',
          i = { '<c-w>_ | <c-w>|', 'Zoom in screen' },
          o = { '<c-w>=', 'Zoom out screen' },
        },
        w = {
          name = 'Move window',
          h = { ':wincmd H<Return>', 'Move current split window to the far left' },
          j = { ':wincmd J<Return>', 'Move current split window to the very bottom' },
          k = { ':wincmd K<Return>', 'Move current split window to the very top' },
          l = { ':wincmd L<Return>', 'Move current split window to the far right' },
        },
        d = {
          name = 'Docker',
          v = { actions.telescope.docker_volumes.command, actions.telescope.docker_volumes.desc },
          i = { actions.telescope.docker_images.command, actions.telescope.docker_images.desc },
          p = { actions.telescope.docker_processes.command, actions.telescope.docker_processes.desc },
        },
        l = { ':luafile %<Return>', 'Reload current Lua file' },
      },
      t = {
        name = 'Trouble',
        r = { actions.trouble.lsp_definitions_references.command, actions.trouble.lsp_definitions_references.desc },
        d = {
          name = 'Diagnostics',
          d = { actions.trouble.diagnostics.command, actions.trouble.diagnostics.desc },
          f = { actions.trouble.diagnostics_current_file.command, actions.trouble.diagnostics_current_file.desc },
        },
        q = { actions.trouble.qflist.command, actions.trouble.qflist.desc },
        l = { actions.trouble.loclist.command, actions.trouble.loclist.desc },
        s = { actions.trouble.symbols.command, actions.trouble.symbols.desc },
      },
    },
  }

  local status_ok, wk = pcall(require, 'which-key')
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
