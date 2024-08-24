local key_options = require('me.utils.keymap_options_config').set_keymap_options

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'ahmedkhalf/project.nvim',
    },
    keys = {
      {
        '<leader>fB',
        ':Telescope file_browser file_browser path=%:p:h=%:p:h<cr>',
        key_options({ desc = 'Browse Files' }),
      },
      {
        '<leader>cbs',
        ':Telescope lsp_document_symbols<Return>',
        key_options({ noremap = false, silent = false, desc = 'LSP Document Symbols, Buffer' }),
      },
      {
        '<leader>cbf',
        ':lua require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })<CR>',
        key_options({ noremap = false, silent = false, desc = 'LSP Document Find, Buffer' }),
      },
      {
        '<leader>cd',
        ':Telescope diagnostics<Return>',
        key_options({ noremap = false, silent = false, desc = 'Diagnostics' }),
      },
      {
        '<leader>fp',
        ':lua require("telescope").extensions.projects.projects()<Return>',
        key_options({ noremap = false, silent = false, desc = 'Find Projects' }),
      },
    },

    config = function(_, opts)
      local telescope = require('telescope')
      telescope.load_extension('undo')
      telescope.load_extension('file_browser')
    end,
  },
}
