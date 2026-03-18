local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.color_scheme = "tokyonight_night" -- tokyonight_night tokyonight_storm tokyonight_moon
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 18
config.warn_about_missing_glyphs = false
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0
config.font = wezterm.font("JetBrains Mono Nerd Font", { weight = "Regular", italic = true })
config.font_size = 11.0
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.term = "wezterm"
config.enable_wayland = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.colors = {
	tab_bar = {
		background = "#232733",
		active_tab = {
			bg_color = "#232733",
			fg_color = "#e2e9ff",
		},
		inactive_tab = {
			bg_color = "#232733",
			fg_color = "#f5dcc0",
		},
		inactive_tab_hover = {
			bg_color = "#232733",
			fg_color = "#ffead2",
		},
		new_tab = {
			bg_color = "#232733",
			fg_color = "#232733",
		},
		new_tab_hover = {
			bg_color = "#232733",
			fg_color = "#232733",
		},
	},
}

-- Opcional:
-- config.macos_window_background_blur = 20        -- macOS blur + opacity  :contentReference[oaicite:6]{index=6}
-- config.kde_window_background_blur = true        -- KDE Wayland (nightly)  :contentReference[oaicite:7]{index=7}

wezterm.GLOBAL = wezterm.GLOBAL or { opacity_step = 1 }

local levels = { { 1.0, 1.0 }, { 0.6, 0.9 }, { 0.3, 0.8 } } -- {window_bg, text_bg}
local shells = {
	bash = true,
	sh = true,
	zsh = true,
	fish = true,
	nu = true,
	nushell = true,
}

local function basename(path)
	if not path or path == "" then
		return ""
	end

	return path:gsub("(.*[/\\])(.*)", "%2")
end

local function cwd_name(cwd)
	if not cwd then
		return ""
	end

	local value = tostring(cwd)
	value = value:gsub("^file://", "")
	value = value:gsub("/+$", "")

	return basename(value)
end

local function apply_level(window)
	local i = wezterm.GLOBAL.opacity_step
	local win_op, text_op = levels[i][1], levels[i][2]
	local overrides = window:get_config_overrides() or {}
	overrides.window_background_opacity = win_op
	overrides.text_background_opacity = text_op
	window:set_config_overrides(overrides)
end

wezterm.on("cycle-transparency", function(window, _)
	wezterm.GLOBAL.opacity_step = (wezterm.GLOBAL.opacity_step % #levels) + 1
	apply_level(window)
end)

wezterm.on("toggle-transparency", function(window, _)
	local over = window:get_config_overrides() or {}
	local is_transparent = (over.window_background_opacity and over.window_background_opacity < 1.0)
	if is_transparent then
		over.window_background_opacity = 1.0
		over.text_background_opacity = 1.0
	else
		over.window_background_opacity = 0.8
		over.text_background_opacity = 0.8
	end
	window:set_config_overrides(over)
end)

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end

	local pane = tab_info.active_pane
	local process = basename(pane.foreground_process_name)
	local directory = cwd_name(pane.current_working_dir)

	if process ~= "" and not shells[process] then
		return process
	end

	if directory ~= "" then
		return directory
	end

	if process ~= "" then
		return process
	end

	return pane.title or "shell"
end

local function tab_palette(tab_info, hover)
	local bar_bg = "#232733"
	local tab_bg = "#313548"
	local tab_fg = "#e2e9ff"
	local badge_bg = "#9cafeb"
	local badge_fg = "#1d2028"

	if tab_info.is_active then
		tab_fg = "#e2e9ff"
		badge_bg = "#edb07d"
		badge_fg = "#1d2028"
	elseif hover then
		badge_bg = "#9cafeb"
		badge_fg = "#1d2028"
	end

	return {
		bar_bg = bar_bg,
		tab_bg = tab_bg,
		tab_fg = tab_fg,
		badge_bg = badge_bg,
		badge_fg = badge_fg,
	}
end

wezterm.on("format-tab-title", function(tab, tabs, _, _, hover, max_width)
	tabs = tabs or { tab }
	local colors = tab_palette(tab, hover)

	local index = tostring(tab.tab_index + 1)
	local title = tab_title(tab)
	local reserved_width = 4 + #index
	title = wezterm.truncate_right(title, math.max(4, max_width - reserved_width))

	local cells = {
		{ Background = { Color = colors.tab_bg } },
		{ Foreground = { Color = colors.tab_fg } },
		{ Text = " " .. title .. " " },
		{ Background = { Color = colors.badge_bg } },
		{ Foreground = { Color = colors.badge_fg } },
		{ Text = " " .. index .. " " },
	}

	return cells
end)

config.keys = {
	{ key = "f", mods = "CTRL", action = wezterm.action.ToggleFullScreen },
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-transparency") },
	{ key = "y", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("cycle-transparency") },
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "h", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 3 }) },
	{ key = "k", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 3 }) },
	{ key = "l", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 3 }) },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "n", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "LeftArrow", mods = "LEADER", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "LEADER", action = wezterm.action.MoveTabRelative(1) },
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "New tab name (Enter for automatic)",
			action = wezterm.action_callback(function(window, _, line)
				if line == nil then
					return
				end

				local mux_window = window:mux_window()
				if not mux_window then
					return
				end

				local tab = mux_window:spawn_tab({})
				tab:activate()

				if line ~= "" then
					tab:set_title(line)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename current tab",
			action = wezterm.action_callback(function(window, _, line)
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
}

return config
