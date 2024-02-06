local M = {
  "glepnir/lspsaga.nvim",
  branch = "main",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter"
  },
}
local icons = require("utils.icons")

local settings = {
  symbol_in_winbar = {
    enable = true,
    separator = icons.plugins.lspsaga.breadcrumbs_separator,
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
