local M = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  { "mg979/vim-visual-multi" },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    config = function()
      -- You don't need to set any of these options.
      -- IMPORTANT!: this is only a showcase of how you can set default options!
      local telescope = require "telescope"
      local fb_actions = telescope.extensions.file_browser.actions
      telescope.setup({
        extensions = {
          file_browser = {
            theme = "dropdown",
            -- theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              -- your custom insert mode mappings
              ["i"] = {
                ["<C-w>"] = function()
                  vim.cmd "normal vbd"
                end,
              },
              ["n"] = {
                -- your custom normal mode mappings
                ["N"] = fb_actions.create,
                ["r"] = fb_actions.rename,
                ["c"] = fb_actions.copy,
                ["m"] = fb_actions.move,
                ["x"] = fb_actions.remove,
                ["h"] = fb_actions.goto_parent_dir,
                ["/"] = function()
                  vim.cmd "startinsert"
                end,
              },
            },
          },
        },
      })
    end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        presets = {
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        }
      })
    end
  },
  {
    "ravenxrz/DAPInstall.nvim",
    commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de",
    config = function()
      require("dap-install").setup {}
      require("dap-install").config("python", {})
      require("dap-install").config("go_delve", {})
    end
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
}
return M
