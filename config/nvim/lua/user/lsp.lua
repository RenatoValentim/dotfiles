local M = {
  'neovim/nvim-lspconfig',
  commit = '649137cbc53a044bffde36294ce3160cb18f32c7',
  lazy = true,
  dependencies = {
    {
      'hrsh7th/cmp-nvim-lsp',
      commit = '0e6b2ed705ddcff9738ec4ea838141654f12eeef',
    },
    {
      'b0o/schemastore.nvim',
    },
  },
}

local icons = require('utils.icons')

local cmp_nvim_lsp = require('cmp_nvim_lsp')
function M.config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

  local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    keymap(bufnr, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    keymap(bufnr, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    keymap(bufnr, 'n', 'gk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    keymap(bufnr, 'n', 'gj', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    keymap(bufnr, 'n', '<leader>li', '<cmd>LspInfo<cr>', opts)
    keymap(bufnr, 'n', '<leader>lI', '<cmd>Mason<cr>', opts)
    keymap(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    keymap(bufnr, 'n', '<leader>lj', '<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>', opts)
    keymap(bufnr, 'n', '<leader>lk', '<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>', opts)
    keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    keymap(bufnr, 'n', '<leader>lq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  end

  local lspconfig = require('lspconfig')
  local on_attach = function(client, bufnr)
    if client.name == 'tsserver' then
      client.server_capabilities.documentFormattingProvider = false
    end

    if client.name == 'sumneko_lua' then
      client.server_capabilities.documentFormattingProvider = false
    end

    lsp_keymaps(bufnr)
    require('illuminate').on_attach(client)
  end

  for _, server in pairs(require('utils.language-servers').servers) do
    Opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    if server == 'jsonls' then
      Opts.settings = Opts.settings or {}
      Opts.settings.json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      }
    end

    if server == 'yamlls' then
      Opts.settings = Opts.settings or {}
      Opts.settings.yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require('schemastore').yaml.schemas(),
      }
    end

    if server == 'tailwindcss' then
      Opts.settings = Opts.settings or {}
      Opts.filetypes = { 'aspnetcorerazor', 'astro', 'astro-markdown', 'blade', 'clojure', 'django-html', 'htmldjango',
        'edge', 'eelixir', 'elixir', 'ejs', 'erb', 'eruby', 'gohtml', 'gohtmltmpl', 'haml', 'handlebars', 'hbs', 'html',
        'htmlangular', 'html-eex', 'heex', 'jade', 'leaf', 'liquid', 'markdown', 'mdx', 'mustache', 'njk', 'nunjucks',
        'php', 'razor', 'slim', 'twig', 'css', 'less', 'postcss', 'sass', 'scss', 'stylus', 'sugarss',
        'javascriptreact', 'reason', 'rescript', 'typescriptreact', 'vue', 'svelte', 'templ' }
    end

    if server == 'emmet_ls' then
      Opts.filetypes = Opts.filetypes or {}
      Opts.init_options = Opts.init_options or {}
      Opts.filetypes = {
        'css',
        'eruby',
        'html',
        'javascriptreact',
        'less',
        'sass',
        'scss',
        'svelte',
        'pug',
        'typescriptreact',
        'vue'
      }
      Opts.init_options = {
        html = {
          options = {
            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
            ["bem.enabled"] = true,
          },
        },
      }
    end

    server = vim.split(server, '@')[1]

    local require_ok, conf_opts = pcall(require, 'settings.' .. server)
    if require_ok then
      Opts = vim.tbl_deep_extend('force', conf_opts, Opts)
    end

    lspconfig[server].setup(Opts)
  end

  local signs = {
    { name = 'DiagnosticSignError', text = icons.lsp.transparent_error },
    { name = 'DiagnosticSignWarn',  text = icons.lsp.transparent_warn },
    { name = 'DiagnosticSignHint',  text = icons.lsp.transparent_hint },
    { name = 'DiagnosticSignInfo',  text = icons.lsp.transparent_info },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
      suffix = '',
    },
  }

  vim.diagnostic.config(config)

  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = "rounded",
  -- })
  --
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = "rounded",
  -- })
end

return M
