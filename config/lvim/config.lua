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

-- Plugins
lvim.plugins = require("plugins")

-- Plugins extentions
lvim.keys.normal_mode["<leader>ub"] = require("file_browser")

