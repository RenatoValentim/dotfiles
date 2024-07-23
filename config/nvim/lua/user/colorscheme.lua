local M = {
  'folke/tokyonight.nvim',
  commit = 'e52c41314e83232840d6970e6b072f9fba242eb9',
  lazy = true, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = 'tokyonight-night' -- tokyonight tokyonight-night tokyonight-storm tokyonight-day tokyonight-moon

function M.config()
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
