local M = {
  "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  commit = "0568104bf8d0c3ab16395433fcc5c1638efc25d4",
}

local icons = require("utils.icons")

function M.config()
  require("nvim-web-devicons").setup {
    override = {
      zsh = {
        icon = icons.plugins.nvim_dev_icon.zsh,
        color = "#428850",
        cterm_color = "65",
        name = "Zsh",
      },
      Dockerfile = {
        icon = icons.plugins.nvim_dev_icon.docker,
        color = "#22b2e3",
        name = "dockerfile",
      },
      [".dockerignore"] = {
        icon = icons.plugins.nvim_dev_icon.docker,
        color = "#22b2e3",
        name = ".dockerignore",
      },
      ["docker-compose.yml"] = {
        icon = icons.plugins.nvim_dev_icon.docker,
        color = "#22b2e3",
        name = "dockercompose",
      },
      [".env.example"] = {
        icon = icons.plugins.nvim_dev_icon.env,
        color = "#eed202",
        name = "env",
      },
      ["app.env"] = {
        icon = icons.plugins.nvim_dev_icon.env,
        color = "#eed202",
        name = "env",
      },
      ["app.env.example"] = {
        icon = icons.plugins.nvim_dev_icon.env,
        color = "#eed202",
        name = "env",
      },
      ["go.mod"] = {
        icon = icons.plugins.nvim_dev_icon.go,
        color = "#de5048",
        name = "gomod",
      },
      ["go.sum"] = {
        icon = icons.plugins.nvim_dev_icon.go,
        color = "#de5048",
        name = "gosum",
      },
    },
    color_icons = true,
    default = true,
  }
end

return M
