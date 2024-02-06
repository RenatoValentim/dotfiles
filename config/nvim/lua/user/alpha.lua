local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  commit = "dafa11a6218c2296df044e00f88d9187222ba6b0",
}

local icons = require("utils.icons")

function M.config()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  dashboard.section.header.val = {
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
  }
  dashboard.section.buttons.val = {
    dashboard.button("f", icons.dashboard.find_files .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", icons.dashboard.new_files .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("p", icons.dashboard.find_project .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
    dashboard.button("r", icons.dashboard.recent_files .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", icons.dashboard.find_text .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", icons.dashboard.config .. " Config", ":e $MYVIMRC <CR>"),
    dashboard.button("q", icons.dashboard.quit .. " Quit", ":qa<CR>"),
  }
  local function footer()
    return {
    "                                  ",
    "          Renato Valentim         ",
    "github.com/RenatoValentim/dotfiles"
  }
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true
  alpha.setup(dashboard.opts)
end

return M
