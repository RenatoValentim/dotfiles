local M = {
  "kyazdani42/nvim-tree.lua",
  commit = "59e65d88db177ad1e6a8cffaafd4738420ad20b6",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
}

function M.config()
  local tree_cb = require("nvim-tree.config").nvim_tree_callback
  require("nvim-tree").setup {
    git = {
      enable = true,
      ignore = false,
      timeout = 200,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = true,
      full_name = false,
      highlight_opened_files = "none",
      root_folder_modifier = ":t",
      indent_width = 2,
      indent_markers = {
        enable = true,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          none = " ",
        },
      },
      icons = {
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "",
            untracked = "U",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
    view = {
      adaptive_size = true,
      mappings = {
        list = {
          { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
          { key = "h", cb = tree_cb "close_node" },
          { key = "v", cb = tree_cb "vsplit" },
        },
      },
    },
  }
end

return M
