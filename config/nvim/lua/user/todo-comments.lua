local M = {
  "folke/todo-comments.nvim",
  event = "LspAttach",
  dependencies = {"nvim-lua/plenary.nvim"},
}

local icons = require("utils.icons")

function M.config()
  local todo_comments = require "todo-comments"

  todo_comments.setup {
    keywords = {
      FIX = {
        icon = icons.plugins.todo_comments.fix, -- icon used for the sign, and in search results
        color = "#DC2626", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR", "ERR" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = icons.plugins.todo_comments.hack, color = "#2563EB", },
      HACK = { icon = icons.plugins.todo_comments.hack, color = "#FBBF24" },
      WARN = { icon = icons.plugins.todo_comments.warn, color = "#FBBF24", alt = { "WARNING", "XXX" } },
      PERF = { icon = icons.plugins.todo_comments.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = icons.plugins.todo_comments.note, color = "#10B981", alt = { "INFO" } },
    },
  }

  vim.keymap.set("n", "<leader>tqf", ":TodoQuickFix<Return>", {})
  vim.keymap.set("n", "<leader>tll", ":TodoLocList<Return>", {})
  vim.keymap.set("n", "<leader>tt", ":TodoTelescope<Return>", {})
end

return M
