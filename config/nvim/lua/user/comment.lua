local M = {
  "numToStr/Comment.nvim",
  commit = "e1fe53117aab24c378d5e6deaad786789c360123",
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
      commit = "0bf8fbc2ca8f8cdb6efbd0a9e32740d7a991e4c3",
    },
  },
}

function M.config()
  pre_hook = function(ctx)
    -- Only calculate commentstring for tsx filetypes
    if vim.bo.filetype == "typescriptreact" then
      local U = require "Comment.utils"

      -- Determine whether to use linewise or blockwise commentstring
      local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

      -- Determine the location where to calculate commentstring from
      local location = nil
      if ctx.ctype == U.ctype.blockwise then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring {
        key = type,
        location = location,
      }
    end
  end
end

return M
