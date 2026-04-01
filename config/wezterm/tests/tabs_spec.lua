local tabs = require("config.tabs")

local home_dir = "/tmp/test-home"

return {
  {
    name = "extracts basenames and cwd names",
    run = function()
      assert(tabs.basename("/tmp/project/file.lua") == "file.lua")
      assert(tabs.basename("C:\\Users\\tester\\wezterm.exe") == "wezterm.exe")
      assert(tabs.cwd_name("file://" .. home_dir .. "/projects/wezterm/") == "wezterm")
      assert(tabs.cwd_name({ file_path = home_dir .. "/projects/dotfiles/" }) == "dotfiles")
    end,
  },
  {
    name = "prefers explicit titles and process names",
    run = function()
      assert(tabs.tab_title({
        tab_title = "notes",
        active_pane = {},
      }) == "notes")

      assert(tabs.tab_title({
        tab_title = "",
        active_pane = {
          foreground_process_name = "/usr/bin/nvim",
          current_working_dir = "file://" .. home_dir .. "/projects/wezterm",
          title = "shell",
        },
      }) == "nvim")
    end,
  },
  {
    name = "falls back to directory then pane title",
    run = function()
      assert(tabs.tab_title({
        tab_title = "",
        active_pane = {
          foreground_process_name = "/usr/bin/bash",
          current_working_dir = "file://" .. home_dir .. "/projects/dotfiles/",
          title = "shell",
        },
      }) == "dotfiles")

      assert(tabs.tab_title({
        tab_title = "",
        active_pane = {
          foreground_process_name = "",
          current_working_dir = nil,
          title = "fallback-shell",
        },
      }) == "fallback-shell")
    end,
  },
  {
    name = "builds zoom badges only for split zoomed tabs",
    run = function()
      assert(tabs.zoom_badge_from_panes({ { is_zoomed = true }, { is_zoomed = false } }) == "⛶ +1")
      assert(tabs.zoom_badge_from_panes({ { is_zoomed = true } }) == nil)
      assert(tabs.zoom_badge_from_panes({ { is_zoomed = false }, { is_zoomed = false } }) == nil)
    end,
  },
  {
    name = "builds right status cells with workspace only",
    run = function()
      local cells = tabs.right_status_cells("default", nil)

      assert(#cells == 3)
      assert(cells[1].Background.Color == "#9cafeb")
      assert(cells[2].Foreground.Color == "#1d2028")
      assert(cells[3].Text == " default ")
    end,
  },
  {
    name = "orders zoom before workspace in right status",
    run = function()
      local cells = tabs.right_status_cells("notes", "⛶ +1")

      assert(#cells == 6)
      assert(cells[1].Background.Color == "#f7768e")
      assert(cells[3].Text == " ⛶ +1 ")
      assert(cells[4].Background.Color == "#9cafeb")
      assert(cells[6].Text == " notes ")
    end,
  },
  {
    name = "truncates long workspace names in right status",
    run = function()
      local workspace_name = string.rep("a", 51)
      local cells = tabs.right_status_cells(workspace_name, nil)

      assert(cells[3].Text == " " .. string.rep("a", 47) .. "... ")
    end,
  },
}
