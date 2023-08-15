local M = {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = "markdown",
}

function M.config()
  vim.g.mkdp_auto_start = 1
end

return M
