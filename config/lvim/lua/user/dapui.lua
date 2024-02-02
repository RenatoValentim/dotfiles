local M = {}

M.layouts = {
  {
    elements = {
      -- { id = "scopes", size = 0.33 },
      { id = "scopes",      size = 0.41 },
      -- { id = "breakpoints", size = 0.17 },
      { id = "breakpoints", size = 0.25 },
      -- { id = "stacks", size = 0.25 },
      -- { id = "watches", size = 0.25 },
      { id = "watches",     size = 0.33 },
    },
    size = 0.33,
    position = "left",
  },
  {
    elements = {
      -- { id = "repl", size = 0.45 },
      { id = "repl", size = 1.10 },
      -- { id = "console", size = 0.55 },
    },
    size = 0.27,
    position = "bottom",
  },
}

return M
