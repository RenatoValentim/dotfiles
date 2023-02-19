local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

local function telescope_buffer_dir()
	return vim.fn.expand("%:p:h")
end

local fb_actions = require("telescope").extensions.file_browser.actions

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    -- file_ignore_patterns = { ".git/", "node_modules" },

    mappings = {
      i = {
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["q"] = actions.close,
      }
    },
  },
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
            vim.cmd("normal vbd")
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
            vim.cmd("startinsert")
          end,
        },
      },
    },
  }
}

telescope.load_extension("file_browser")

vim.keymap.set("n", "<leader>e", function()
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = telescope_buffer_dir(),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40 },
	})
end)
