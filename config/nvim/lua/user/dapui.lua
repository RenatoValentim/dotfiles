local M = {
  "rcarriga/nvim-dap-ui",
  commit = "1cd4764221c91686dcf4d6b62d7a7b2d112e0b13",
  event = "VeryLazy",
  dependencies = {
    {
      "mfussenegger/nvim-dap",
      event = "VeryLazy",
    },
  },
}

function M.config()
  require("dapui").setup {
    expand_lines = true,
    icons = {
      expanded = "",
      collapsed = "",
      circular = "",
    },
    controls = {
      icons = {
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_out = "",
        step_into = "",
        step_over = "",
        terminate = "",
      }
    },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          -- { id = "scopes", size = 0.33 },
          { id = "scopes",      size = 0.41 },
          -- { id = "breakpoints", size = 0.17 },
          { id = "breakpoints", size = 0.25 },
          -- { id = "stacks", size = 0.25 },
          -- { id = "watches", size = 0.25 },
          { id = "watches",     size = 0.33 },
        },
        size = 0.33,
        position = "left",
      },
      {
        elements = {
          -- { id = "repl", size = 0.45 },
          { id = "repl", size = 1.10 },
          -- { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5,             -- Floats will be treated as percentage of your screen.
      border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  }

  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
end

return M
