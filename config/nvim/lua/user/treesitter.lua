local M = {
  'nvim-treesitter/nvim-treesitter',
  commit = '150a4c9fa4743b9af7b95f68746778394ce2ac93',
  event = 'BufReadPost',
  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      event = 'VeryLazy',
      commit = '729d83ecb990dc2b30272833c213cc6d49ed5214',
    },
    {
      'nvim-tree/nvim-web-devicons',
      event = 'VeryLazy',
      commit = '0568104bf8d0c3ab16395433fcc5c1638efc25d4',
    },
    {
      'romgrk/nvim-treesitter-context',
      event = 'VeryLazy',
      commit = 'add_the_commit_you_want_here',
    },
  },
}

function M.config()
  local treesitter = require('nvim-treesitter')
  local configs = require('nvim-treesitter.configs')
  local status, ts_context = pcall(require, 'treesitter-context')
  if not status then
    vim.notify('Failed to load treesitter-context', vim.log.levels.ERROR)
    return
  end

  configs.setup({
    ensure_installed = {
      'lua',
      'markdown',
      'markdown_inline',
      'bash',
      'python',
      'astro',
      'css',
      'graphql',
      'html',
      'javascript',
      'nix',
      'php',
      'scss',
      'svelte',
      'tsx',
      'twig',
      'typescript',
      'vim',
      'vue',
    }, -- put the language you want in this array
    -- ensure_installed = "all", -- one of "all" or a list of languages
    ignore_install = { '' }, -- List of parsers to ignore installing
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    auto_install = true,

    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { 'css' }, -- list of language that will be disabled
      additional_vim_regex_highlighting = false,
    },
    autopairs = {
      enable = true,
    },
    indent = { enable = true, disable = { 'python', 'css' } },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    -- Configure nvim-treesitter-context
    context = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      throttle = true, -- Throttles plugin updates (may improve performance)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
          'class',
          'function',
          'method',
        },
      },
      -- Silenciar erros ao não carregar contexto
      silent = true,
    },
  })
end

return M
