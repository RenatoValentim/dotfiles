return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  opts = function(_, opts)
    opts.options = {
      component_separators = { left = '»', right = '|' },
      section_separators = { left = '', right = '' },
    }
  end,
}
