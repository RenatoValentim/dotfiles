local M = {
  "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  commit = "0568104bf8d0c3ab16395433fcc5c1638efc25d4",
}

function M.config()
  require("nvim-web-devicons").setup {
    override = {
      zsh = {
        icon = "",
        color = "#428850",
        cterm_color = "65",
        name = "Zsh",
      },
      dockerfile = {
        icon = "",
        color = "#22b2e3",
        name = "Dockerfile",
      },
      [".dockerignore"] = {
        icon = "",
        color = "#22b2e3",
        name = "Dockerignore",
      },
      ["docker-compose.yml"] = {
        icon = "",
        color = "#22b2e3",
        name = "dockercompose",
      },
    },
    color_icons = true,
    default = true,
  }
end

return M
