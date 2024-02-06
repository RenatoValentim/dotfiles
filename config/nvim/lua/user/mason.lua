local M = {
  "williamboman/mason.nvim",
  commit = "4546dec8b56bc56bc1d81e717e4a935bc7cd6477",
  cmd = "Mason",
  event = "BufReadPre",
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      commit = "93e58e100f37ef4fb0f897deeed20599dae9d128",
      lazy = true,
    },
  },
}

local icons = require("utils.icons")

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = icons.plugins.mason.installed,
      package_pending = icons.plugins.mason.pending,
      package_uninstalled = icons.plugins.mason.uninstalled,
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

function M.config()
  require("mason").setup(settings)
  require("mason-lspconfig").setup {
    ensure_installed = require("utils.get-os-architecture").servers,
    automatic_installation = true,
  }
end

return M
