local M = {
  "norcalli/nvim-colorizer.lua",
}

function M.config()
  local colorizer = require "colorizer"

  colorizer.setup {
    "*";
  }
end

return M
