return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    keys = {
      {
        '<leader>fB',
        ':Telescope file_browser file_browser path=%:p:h=%:p:h<cr>',
        desc = 'Browse Files',
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.load_extension('undo')
      telescope.load_extension('file_browser')
    end,
  },
}
