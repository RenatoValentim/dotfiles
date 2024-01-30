local telescope = require("telescope")

local function telescope_buffer_dir()
  return vim.fn.expand "%:p:h"
end

telescope.load_extension "file_browser"

return function()
  telescope.extensions.file_browser.file_browser {
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 },
  }
end
