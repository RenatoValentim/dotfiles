return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        gopls = function(_, opts)
          Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
            if not client.server_capabilities.semanticTokensProvider then
              local caps = client.config and client.config.capabilities
              local semantic = caps and caps.textDocument and caps.textDocument.semanticTokens
              if semantic then
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
        end,
      },
    },
  },
}
