local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})

lvim.autocommands = {
  {
    "BufWritePre", {

    pattern = { "*.go" },
    callback = function()
      require("go.format").goimport()
    end,
    group = format_sync_grp,
  }
  }
}
