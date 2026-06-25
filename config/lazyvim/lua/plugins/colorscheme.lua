-- lua/plugins/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
      },
    },
  },
  -- lua/plugins/rose-pine.lua
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function()
  --     vim.cmd("colorscheme rose-pine-dawn") -- rose-pine, rose-pine-moon, and rose-pine-dawn
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
