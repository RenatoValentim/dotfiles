local key_options = require("me.utils.keymap_options_config").set_keymap_options

return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    auto_close = true,
  },
  keys = {
    r = "refresh",
    q = "close",
    o = "jump_close",
    { "<leader>ms", false },
    { "<leader>mS", false },
    {
      "<leader>mtd",
      "<cmd>Trouble diagnostics toggle focus=true<Return>",
      key_options({ desc = "Diagnostics (Trouble)" }),
    },
    {
      "<leader>mtf",
      "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<Return>",
      key_options({ desc = "Buffer Diagnostics (Trouble)" }),
    },
    {
      "<leader>mtr",
      "<cmd>Trouble lsp toggle focus=true win.position=bottom<Return>",
      key_options({ desc = "LSP Definitions / references / ... (Trouble)" }),
    },
  },
}
