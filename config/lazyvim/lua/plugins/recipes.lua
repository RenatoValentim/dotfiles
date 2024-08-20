return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { 'utf-16' }
        end,
      },
    },
    {
      'folke/tokyonight.nvim',
      opts = {
        transparent = false, -- true, false
        styles = {
          sidebars = 'dark', -- dark, transparent
          floats = 'dark', -- dark, transparent
        },
      },
    },
  },
}
