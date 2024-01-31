local M = {}

local telescope = require("telescope")
local actions = require "telescope.actions"
local fb_actions = telescope.extensions.file_browser.actions

local function telescope_buffer_dir()
  return vim.fn.expand "%:p:h"
end

M.mappings = {
  i = {
    ["<Down>"] = actions.cycle_history_next,
    ["<Up>"] = actions.cycle_history_prev,
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
  n = {
    ["q"] = actions.close,
  },
}

M.extensions = {
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
}

telescope.load_extension "file_browser"

function M.file_browser ()
  telescope.extensions.file_browser.file_browser {
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 20 },
  }
end

return M
