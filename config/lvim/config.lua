-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- lvim.vim.o.cmdheight = 1

-- Personal keymaps
require("keymaps")

-- Personal
lvim.builtin.breadcrumbs.options.separator = " » "
lvim.builtin.bufferline.active = false
lvim.builtin.cmp.cmdline.enable = true
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d %H:%M:%S> - <summary>"
lvim.builtin.gitsigns.opts.current_line_blame_opts.delay = 5

-- Plugins
lvim.plugins = require("plugins")

-- Plugins extentions
lvim.keys.normal_mode["<leader>ub"] = require("file_browser")
