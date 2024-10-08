local actions = require('utils.actions')

local M = {
  'nvim-telescope/telescope.nvim',
  commit = '00cf15074a2997487813672a75f946d2ead95eb0',
  event = 'Bufenter',
  cmd = { 'Telescope' },
  dependencies = {
    {
      'ahmedkhalf/project.nvim',
      commit = '685bc8e3890d2feb07ccf919522c97f7d33b94e4',
    },
    {
      'nvim-telescope/telescope-file-browser.nvim',
    },
  },
  keys = {
    {
      '<leader>ff',
      actions.telescope.find_files.command,
      actions.telescope.find_files.desc,
    },
    {
      '<leader>fg',
      actions.telescope.live_grep.command,
      actions.telescope.live_grep.desc,
    },
    {
      '<leader>fb',
      actions.telescope.find_buffers.command,
      actions.telescope.find_buffers.desc,
    },
    {
      '<leader>fr',
      actions.telescope.find_resume.command,
      actions.telescope.find_resume.desc,
    },
    {
      '<leader>fd',
      actions.telescope.find_diagnostics.command,
      actions.telescope.find_diagnostics.desc,
    },
    {
      '<leader>fk',
      actions.telescope.find_keymaps.command,
      actions.telescope.find_keymaps.desc,
    },
    {
      '<leader>fs',
      actions.telescope.find_buffer_fuzzy_find.command,
      actions.telescope.find_buffer_fuzzy_find.desc,
    },
  },
}

local icons = require('utils.icons')

function M.config()
  local telescope = require('telescope')

  local actions = require('telescope.actions')

  local function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
  end

  local fb_actions = require('telescope').extensions.file_browser.actions

  telescope.setup({
    defaults = {
      prompt_prefix = icons.plugins.telescope.prompt_prefix,
      selection_caret = icons.plugins.telescope.selection_caret,
      path_display = { 'smart' },
      file_ignore_patterns = { '.git/', 'node_modules', 'venv', '.venv' },
      mappings = {
        i = {
          ['<Down>'] = actions.cycle_history_next,
          ['<Up>'] = actions.cycle_history_prev,
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
        },
        n = {
          ['q'] = actions.close,
        },
      },
    },
    extensions = {
      file_browser = {
        theme = 'dropdown',
        -- theme = "ivy",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          -- your custom insert mode mappings
          ['i'] = {
            ['<C-w>'] = function()
              vim.cmd('normal vbd')
            end,
          },
          ['n'] = {
            -- your custom normal mode mappings
            ['N'] = fb_actions.create,
            ['r'] = fb_actions.rename,
            ['c'] = fb_actions.copy,
            ['m'] = fb_actions.move,
            ['x'] = fb_actions.remove,
            ['h'] = fb_actions.goto_parent_dir,
            ['/'] = function()
              vim.cmd('startinsert')
            end,
          },
        },
      },
    },
  })

  telescope.load_extension('file_browser')

  vim.keymap.set('n', '<leader>fe', function()
    telescope.extensions.file_browser.file_browser({
      path = '%:p:h',
      cwd = telescope_buffer_dir(),
      respect_gitignore = false,
      hidden = true,
      grouped = true,
      previewer = false,
      initial_mode = 'normal',
      layout_config = { height = 40 },
    })
  end)
end

return M
