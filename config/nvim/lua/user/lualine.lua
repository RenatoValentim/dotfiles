local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = true,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local filetype = {
  "filetype",
  icons_enabled = true,
}

local location = {
  "location",
  padding = 1.5,
}

local progress = {
  "progress",
  fmt = function()
    return "%P/%L"
  end,
  color = {},
}

local spaces = function()
  return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local function env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch "([^/]+)" do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

local hide_in_width = function()
  local window_width_limit = 100
  return vim.o.columns > window_width_limit
end

local component = {
  python_env = {
    function()
      if vim.bo.filetype == "python" then
        local venv = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV"
        if venv then
          return string.format("(%s)", env_cleanup(venv))
        end
      end
      return ""
    end,
    color = { fg = "#98be65" },
    cond = hide_in_width,
  },
}

lualine.setup {
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "b:gitsigns_head", icon = "", color = { gui = "bold" } } },
    lualine_c = { diagnostics },
    lualine_x = {
      diff,
      spaces,
      filetype,
      component.python_env,
    },
    lualine_y = { location },
    lualine_z = { progress },
  },
}
