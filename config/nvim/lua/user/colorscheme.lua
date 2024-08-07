local M = {
  'folke/tokyonight.nvim',
  commit = 'e52c41314e83232840d6970e6b072f9fba242eb9',
  priority = 1000,
}

_G.transparent = true

local function apply_theme()
  require("tokyonight").setup({
    style = "night", -- night storm day moon
    transparent = _G.transparent and "transparent" or false,
    styles = {
      sidebars = _G.transparent and "transparent" or "dark",
      floats = _G.transparent and "transparent" or "dark",
    },
  })
  vim.cmd("colorscheme tokyonight")
end

local function toggle_transparency()
  _G.transparent = not _G.transparent
  apply_theme()
end

vim.api.nvim_create_user_command("ToggleTransparency", toggle_transparency, {})

function M.config()
  apply_theme()
end

return M
