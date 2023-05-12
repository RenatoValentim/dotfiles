local M = {
  "mg979/vim-visual-multi",
  branch = "main",
}

function M.config()
  require("vim-visual-multi").setup()
end

return M
