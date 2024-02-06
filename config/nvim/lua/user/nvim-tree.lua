local M = {
  "kyazdani42/nvim-tree.lua",
  commit = "59e65d88db177ad1e6a8cffaafd4738420ad20b6",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
}

local icons = require("utils.icons")

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
          corner = icons.plugins.nvim_tree.corner,
          edge = icons.plugins.nvim_tree.edge,
          item = icons.plugins.nvim_tree.item,
          none = icons.plugins.nvim_tree.none,
        },
      },
      icons = {
        git_placement = "before",
        padding = icons.plugins.nvim_tree.padding,
        symlink_arrow = icons.plugins.nvim_tree.symlink_arrow,
        glyphs = {
          default = icons.plugins.nvim_tree.default,
          symlink = icons.plugins.nvim_tree.symlink,
          folder = {
            arrow_open = icons.plugins.nvim_tree.arrow_open,
            arrow_closed = icons.plugins.nvim_tree.arrow_closed,
            default = icons.plugins.nvim_tree.folder_default,
            open = icons.plugins.nvim_tree.open,
            empty = icons.plugins.nvim_tree.empty,
            empty_open = icons.plugins.nvim_tree.empty_open,
            symlink = icons.plugins.nvim_tree.folder_symlink,
            symlink_open = icons.plugins.nvim_tree.open,
          },
          git = {
            unstaged = icons.plugins.nvim_tree.git_unstaged,
            staged = icons.plugins.nvim_tree.git_staged,
            unmerged = icons.plugins.nvim_tree.git_unstaged,
            renamed = icons.plugins.nvim_tree.git_renamed,
            untracked = icons.plugins.nvim_tree.git_untracked,
            deleted = icons.plugins.nvim_tree.git_deleted,
            ignored = icons.plugins.nvim_tree.git_ignored,
          },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = icons.plugins.nvim_tree.hint,
        info = icons.plugins.nvim_tree.info,
        warning = icons.plugins.nvim_tree.warning,
        error = icons.plugins.nvim_tree.error,
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
