local M = {
  "glepnir/lspsaga.nvim",
  branch = "main",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter"
  },
}

local settings = {
  symbol_in_winbar = {
    enable = true,
    separator = " » ",
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  },
}

function M.config()
  local lspsaga = require "lspsaga"

  lspsaga.setup(settings)
end

return M
