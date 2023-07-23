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
      Dockerfile = {
        icon = "",
        color = "#22b2e3",
        name = "dockerfile",
      },
      [".dockerignore"] = {
        icon = "",
        color = "#22b2e3",
        name = ".dockerignore",
      },
      ["docker-compose.yml"] = {
        icon = "",
        color = "#22b2e3",
        name = "dockercompose",
      },
      [".env.example"] = {
        icon = "",
        color = "#eed202",
        name = "env",
      },
      ["app.env"] = {
        icon = "",
        color = "#eed202",
        name = "env",
      },
      ["app.env.example"] = {
        icon = "",
        color = "#eed202",
        name = "env",
      },
      ["go.mod"] = {
        icon = "ﳑ",
        color = "#de5048",
        name = "gomod",
      },
      ["go.sum"] = {
        icon = "ﳑ",
        color = "#de5048",
        name = "gosum",
      },
    },
    color_icons = true,
    default = true,
  }
end

return M
