local M = {
  "nvim-lualine/lualine.nvim",
  commit = "0050b308552e45f7128f399886c86afefc3eb988",
  event = { "VimEnter", "InsertEnter", "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
  dependencies = {
    "wthollingsworth/pomodoro.nvim",
    dependencies = "MunifTanjim/nui.nvim",
  },
}

function M.config()
  local lualine = require "lualine"

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local pomodoro = require "pomodoro"
  local noice_ok, noice = pcall(require, "noice")
  if not noice_ok then
    noice = {}
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = true,
    always_visible = false,
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
    return "󰌒 " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
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

  hide_in_width = function()
    local window_width_limit = 100
    return vim.o.columns > window_width_limit
  end

  local py_component = {
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

  local lsp_component = {
    lsp = {
      function(msg)
        msg = msg or "LS Inactive"
        local buf_clients = vim.lsp.buf_get_clients()
        if next(buf_clients) == nil then
          -- TODO: clean up this if statement
          if type(msg) == "boolean" or #msg == 0 then
            return "LS Inactive"
          end
          return msg
        end
        local buf_client_names = {}

        -- add client
        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            table.insert(buf_client_names, client.name)
          end
        end

        local unique_client_names = vim.fn.uniq(buf_client_names)

        local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"
        if language_servers == "[]" then
          return "Ls Inactive"
        end

        return language_servers
      end,
      color = { gui = "bold", fg = "#0078d7" },
      cond = hide_in_width,
    },
  }

  local pomodoro_component = {
    statusline = {
      pomodoro.statusline,
      color = { gui = "bold", fg = "red" },
      cond = hide_in_width,
    },
  }

  local noice_component = { "" }
  if noice_ok then
    noice_component = {
      noice.api.statusline.mode.get,
      color = { fg = "#ff9e64" },
      cond = noice.api.statusline.mode.has,
    }
  end

  lualine.setup {
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard" },
      always_divide_middle = true,

      ignore_focus = { "NvimTree" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "b:gitsigns_head", icon = "", color = { gui = "bold" } } },
      lualine_c = { diagnostics },
      lualine_x = {
        diff,
        noice_component,
        pomodoro_component.statusline,
        lsp_component.lsp,
        spaces,
        filetype,
        py_component.python_env,
      },
      lualine_y = { location },
      lualine_z = { progress },
    },
  }
end

return M
