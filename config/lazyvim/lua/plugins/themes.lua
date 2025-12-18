return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true, -- true, false
      styles = {
        sidebars = "transparent", -- dark, transparent
        floats = "transparent", -- dark, transparent
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      float = { transparent = true },
      integrations = {
        neotree = true,
        telescope = { enabled = true },
        treesitter = true,
        cmp = true,
        gitsigns = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
