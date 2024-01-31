-- Personal keymaps
require("keymaps")

-- Personal
lvim.builtin.breadcrumbs.options.separator = " » "
lvim.builtin.bufferline.active = false
lvim.builtin.cmp.cmdline.enable = true
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d %H:%M:%S> - <summary>"
lvim.builtin.gitsigns.opts.current_line_blame_opts.delay = 5
lvim.builtin.terminal.open_mapping = "<c-t>"

lvim.builtin.telescope.theme = "ivy"
lvim.builtin.telescope.defaults.mappings = require("user.telescope").mappings
lvim.builtin.telescope.extensions = require("user.telescope").extensions

-- Plugins
lvim.plugins = require("plugins")

-- Plugins extentions
lvim.keys.normal_mode["<leader>ub"] = require("user.telescope").file_browser

-- FIXME: This is not working
local noice = require("noice")
local noice_component = {
  noice.api.statusline.mode.get,
  color = { fg = "#ff9e64" },
  cond = noice.api.statusline.mode.has,
}
table.insert(
  lvim.builtin.lualine.sections.lualine_c,
  noice_component
)
