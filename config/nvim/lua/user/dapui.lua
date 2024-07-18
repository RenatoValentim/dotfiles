local M = {
  'rcarriga/nvim-dap-ui',
  commit = '1cd4764221c91686dcf4d6b62d7a7b2d112e0b13',
  event = 'VeryLazy',
  dependencies = {
    {
      'mfussenegger/nvim-dap',
      event = 'VeryLazy',
    },
  },
}

local icons = require 'utils.icons'

function M.config()
  require('dapui').setup {
    expand_lines = true,
    icons = {
      expanded = icons.plugins.dapui.expanded,
      collapsed = icons.plugins.dapui.collapsed,
      circular = icons.plugins.dapui.circular,
    },
    controls = {
      icons = {
        pause = icons.plugins.dapui.pause,
        play = icons.plugins.dapui.play,
        run_last = icons.plugins.dapui.run_last,
        step_back = icons.plugins.dapui.step_back,
        step_out = icons.plugins.dapui.step_out,
        step_into = icons.plugins.dapui.step_into,
        step_over = icons.plugins.dapui.step_over,
        terminate = icons.plugins.dapui.terminate,
      },
    },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { '<CR>', '<2-LeftMouse>' },
      open = 'o',
      remove = 'd',
      edit = 'e',
      repl = 'r',
      toggle = 't',
    },
    layouts = {
      {
        elements = {
          -- { id = "scopes", size = 0.33 },
          { id = 'scopes', size = 0.41 },
          -- { id = "breakpoints", size = 0.17 },
          { id = 'breakpoints', size = 0.25 },
          -- { id = "stacks", size = 0.25 },
          -- { id = "watches", size = 0.25 },
          { id = 'watches', size = 0.33 },
        },
        size = 0.33,
        position = 'right',
      },
      {
        elements = {
          -- { id = "repl", size = 0.45 },
          { id = 'repl', size = 1.10 },
          -- { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = 'bottom',
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5, -- Floats will be treated as percentage of your screen.
      border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
  }

  vim.fn.sign_define(
    'DapBreakpoint',
    { text = icons.plugins.dapui.breakpoint, texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
  )
end

return M
