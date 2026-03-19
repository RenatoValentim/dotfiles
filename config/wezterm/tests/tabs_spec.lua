local tabs = require("config.tabs")

return {
	{
		name = "extracts basenames and cwd names",
		run = function()
			assert(tabs.basename("/tmp/project/file.lua") == "file.lua")
			assert(tabs.basename("C:\\Users\\rvsj\\wezterm.exe") == "wezterm.exe")
			assert(tabs.cwd_name("file:///home/rvsj/projects/wezterm/") == "wezterm")
			assert(tabs.cwd_name({ file_path = "/home/rvsj/projects/dotfiles/" }) == "dotfiles")
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
					current_working_dir = "file:///home/rvsj/projects/wezterm",
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
					current_working_dir = "file:///home/rvsj/projects/dotfiles/",
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
}
