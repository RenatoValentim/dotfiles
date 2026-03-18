local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.color_scheme = "tokyonight_night" -- tokyonight_night tokyonight_storm tokyonight_moon
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 18
config.status_update_interval = 1000
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
	selection_bg = "#232733",
	selection_fg = "#e2e9ff",
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

local function label_width(label)
	if wezterm.column_width then
		return wezterm.column_width(label)
	end

	return #label
end

local function zoom_badge_from_panes(panes)
	local pane_count = 0
	local is_zoomed = false

	for _, pane in ipairs(panes or {}) do
		pane_count = pane_count + 1
		if pane.is_zoomed then
			is_zoomed = true
		end
	end

	if not is_zoomed or pane_count < 2 then
		return nil
	end

	return string.format("⛶ +%d", pane_count - 1)
end

local function tab_panes_with_info(tab_info, fallback_panes)
	if tab_info.panes and #tab_info.panes > 0 then
		return tab_info.panes
	end

	if wezterm.mux and wezterm.mux.get_tab and tab_info.tab_id then
		local ok_tab, mux_tab = pcall(wezterm.mux.get_tab, tab_info.tab_id)
		if ok_tab and mux_tab and mux_tab.panes_with_info then
			local ok_panes, mux_panes = pcall(function()
				return mux_tab:panes_with_info()
			end)
			if ok_panes and mux_panes and #mux_panes > 0 then
				return mux_panes
			end
		end
	end

	return fallback_panes or {}
end

local function zoom_badge_text(tab_info, fallback_panes)
	return zoom_badge_from_panes(tab_panes_with_info(tab_info, fallback_panes))
end

local function tab_palette(tab_info, hover)
	local bar_bg = "#232733"
	local tab_bg = "#313548"
	local tab_fg = "#e2e9ff"
	local badge_bg = "#9cafeb"
	local badge_fg = "#1d2028"
	local zoom_bg = "#f7768e"
	local zoom_fg = "#1d2028"

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
		zoom_bg = zoom_bg,
		zoom_fg = zoom_fg,
	}
end

wezterm.on("format-tab-title", function(tab, tabs, panes, _, hover, max_width)
	tabs = tabs or { tab }
	local colors = tab_palette(tab, hover)

	local index = tostring(tab.tab_index + 1)
	local title = tab_title(tab)
	local zoom_label = zoom_badge_text(tab, panes)
	local reserved_width = 4 + #index
	if zoom_label then
		reserved_width = reserved_width + label_width(zoom_label) + 2
	end
	title = wezterm.truncate_right(title, math.max(4, max_width - reserved_width))

	local cells = {
		{ Background = { Color = colors.tab_bg } },
		{ Foreground = { Color = colors.tab_fg } },
		{ Text = " " .. title .. " " },
	}

	if zoom_label then
		table.insert(cells, { Background = { Color = colors.zoom_bg } })
		table.insert(cells, { Foreground = { Color = colors.zoom_fg } })
		table.insert(cells, { Text = " " .. zoom_label .. " " })
	end

	table.insert(cells, { Background = { Color = colors.badge_bg } })
	table.insert(cells, { Foreground = { Color = colors.badge_fg } })
	table.insert(cells, { Text = " " .. index .. " " })

	return cells
end)

wezterm.on("update-status", function(window, _)
	local tab = window:active_tab()
	if not tab or not tab.panes_with_info then
		window:set_right_status("")
		return
	end

	local ok, panes = pcall(function()
		return tab:panes_with_info()
	end)
	if not ok then
		window:set_right_status("")
		return
	end

	local zoom_label = zoom_badge_from_panes(panes)
	if not zoom_label then
		window:set_right_status("")
		return
	end

	window:set_right_status(wezterm.format({
		{ Background = { Color = "#f7768e" } },
		{ Foreground = { Color = "#1d2028" } },
		{ Text = " " .. zoom_label .. " " },
	}))
end)

local act = wezterm.action

local mod_names = {
	ALT = "Alt",
	CMD = "Cmd",
	CTRL = "Ctrl",
	META = "Meta",
	OPT = "Opt",
	SHIFT = "Shift",
	SUPER = "Super",
	WIN = "Win",
}

local key_names = {
	DownArrow = "Down",
	Enter = "Enter",
	Escape = "Esc",
	Home = "Home",
	Insert = "Insert",
	LeftArrow = "Left",
	PageDown = "PageDown",
	PageUp = "PageUp",
	RightArrow = "Right",
	Tab = "Tab",
	UpArrow = "Up",
}

local picker_palette = {
	bracket = "#6b7089",
	desc = "#e2e9ff",
	leader = "#edb07d",
	muted = "#8b92ad",
	section = "#edb07d",
	shortcut = "#9cafeb",
}

local keybinding_picker_script = wezterm.config_dir .. "/wezterm-fzf-picker.sh"
local keybinding_picker_var = "WEZTERM_KEYBINDING_PICKER"

local picker_sections = {
	{ key = "suggested", label = "Suggested" },
	{ key = "pane", label = "Pane" },
	{ key = "tab", label = "Tab" },
	{ key = "view", label = "View" },
	{ key = "send", label = "Send" },
	{ key = "ui", label = "UI" },
}

local function split_mods(mods)
	local parts = {}
	if not mods or mods == "" then
		return parts
	end

	for mod in mods:gmatch("[^|]+") do
		table.insert(parts, mod)
	end

	return parts
end

local function key_name(key)
	return key_names[key] or key
end

local function display_key(key, mods)
	local name = key_name(key)
	if #name == 1 and name:match("%l") and mods and mods:find("SHIFT", 1, true) then
		return name:upper()
	end

	return name
end

local function combo_label(mods, key)
	local parts = {}
	for _, mod in ipairs(split_mods(mods)) do
		if mod ~= "LEADER" then
			table.insert(parts, mod_names[mod] or mod)
		end
	end

	table.insert(parts, display_key(key, mods))
	return table.concat(parts, "+")
end

local function remove_mod(mods, needle)
	local parts = {}
	for _, mod in ipairs(split_mods(mods)) do
		if mod ~= needle then
			table.insert(parts, mod)
		end
	end

	return table.concat(parts, "|")
end

local function binding_steps(binding)
	if binding.mods and binding.mods:find("LEADER", 1, true) then
		local leader_step = combo_label(config.leader.mods, config.leader.key)
		local tail_mods = remove_mod(binding.mods, "LEADER")
		local tail_step = tail_mods == "" and display_key(binding.key, nil) or combo_label(tail_mods, binding.key)
		return {
			{ text = leader_step, color = picker_palette.leader },
			{ text = tail_step, color = picker_palette.shortcut },
		}
	end

	return {
		{ text = combo_label(binding.mods, binding.key), color = picker_palette.shortcut },
	}
end

local function binding_shortcut(binding)
	local parts = {}
	for _, step in ipairs(binding_steps(binding)) do
		table.insert(parts, "[" .. step.text .. "]")
	end

	return table.concat(parts, " ")
end

local function build_picker_entries(bindings)
	local entries = {}

	for _, section in ipairs(picker_sections) do
		for _, binding in ipairs(bindings) do
			local include = section.key == "suggested" and binding.suggested or binding.category == section.key
			if include then
				table.insert(entries, {
					binding = binding,
					section = section.label,
				})
			end
		end
	end

	return entries
end

local function binding_lookup_id(binding)
	local mods = binding.mods and binding.mods:gsub("|", "_") or "NONE"
	local key = tostring(binding.key):gsub("[^%w]", "_")
	return mods .. "__" .. key
end

local function colorize(hex, text, bold)
	local red, green, blue = hex:match("#(%x%x)(%x%x)(%x%x)")
	if not red then
		return text
	end

	local weight = bold and "1;" or ""
	return string.format(
		"\27[%s38;2;%d;%d;%dm%s\27[0m",
		weight,
		tonumber(red, 16),
		tonumber(green, 16),
		tonumber(blue, 16),
		text
	)
end

local function binding_search_text(entry)
	return table.concat({
		entry.section,
		entry.binding.desc,
		binding_shortcut(entry.binding),
	}, " ")
end

local function build_fzf_rows(entries)
	local rows = {}
	local max_desc_width = 0
	local max_section_width = 0

	for _, entry in ipairs(entries) do
		max_desc_width = math.max(max_desc_width, #entry.binding.desc)
		max_section_width = math.max(max_section_width, #entry.section)
	end

	for _, entry in ipairs(entries) do
		local section = string.format("%-" .. tostring(max_section_width) .. "s", entry.section)
		local desc = string.format("%-" .. tostring(max_desc_width) .. "s", entry.binding.desc)
		local shortcut = binding_shortcut(entry.binding)
		local search = binding_search_text(entry)
		local display = table.concat({
			colorize(picker_palette.section, section, true),
			"  ",
			colorize(picker_palette.desc, desc, false),
			"  ",
			colorize(picker_palette.shortcut, shortcut, true),
		})

		table.insert(rows, table.concat({ binding_lookup_id(entry.binding), search, display }, "\t"))
	end

	return rows
end

local custom_keys = {
	{
		key = "z",
		mods = "SHIFT",
		action = act.TogglePaneZoomState,
		desc = "Toggle pane zoom",
		category = "pane",
		suggested = true,
	},
	{
		key = "f",
		mods = "CTRL",
		action = act.ToggleFullScreen,
		desc = "Toggle fullscreen",
		category = "view",
		suggested = true,
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = act.EmitEvent("toggle-transparency"),
		desc = "Toggle transparency",
		category = "view",
	},
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = act.EmitEvent("cycle-transparency"),
		desc = "Cycle transparency",
		category = "view",
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.SendKey({ key = "a", mods = "CTRL" }),
		desc = "Send Ctrl+A to pane",
		category = "send",
	},
	{
		key = "h",
		mods = "SUPER|SHIFT",
		action = act.AdjustPaneSize({ "Left", 3 }),
		desc = "Resize left",
		category = "pane",
	},
	{
		key = "j",
		mods = "SUPER|SHIFT",
		action = act.AdjustPaneSize({ "Down", 3 }),
		desc = "Resize down",
		category = "pane",
	},
	{
		key = "k",
		mods = "SUPER|SHIFT",
		action = act.AdjustPaneSize({ "Up", 3 }),
		desc = "Resize up",
		category = "pane",
	},
	{
		key = "l",
		mods = "SUPER|SHIFT",
		action = act.AdjustPaneSize({ "Right", 3 }),
		desc = "Resize right",
		category = "pane",
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
		desc = "Focus left pane",
		category = "pane",
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
		desc = "Focus pane below",
		category = "pane",
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
		desc = "Focus pane above",
		category = "pane",
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
		desc = "Focus right pane",
		category = "pane",
	},
	{ key = "n", mods = "ALT", action = act.ActivateTabRelative(1), desc = "Next tab", category = "tab" },
	{ key = "p", mods = "ALT", action = act.ActivateTabRelative(-1), desc = "Previous tab", category = "tab" },
	{ key = "LeftArrow", mods = "LEADER", action = act.MoveTabRelative(-1), desc = "Move tab left", category = "tab" },
	{ key = "RightArrow", mods = "LEADER", action = act.MoveTabRelative(1), desc = "Move tab right", category = "tab" },
	{
		key = "c",
		mods = "LEADER",
		action = act.PromptInputLine({
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
		desc = "Create a new named tab",
		category = "tab",
		suggested = true,
	},
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename current tab",
			action = wezterm.action_callback(function(window, _, line)
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
		desc = "Rename current tab",
		category = "tab",
		suggested = true,
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.EmitEvent("show-keybindings-fzf"),
		desc = "Open keybinding picker",
		category = "ui",
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
		desc = "Close pane",
		category = "pane",
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		desc = "Split vertically",
		category = "pane",
		suggested = true,
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		desc = "Split horizontally",
		category = "pane",
		suggested = true,
	},
}

local keybinding_actions = {}

for _, binding in ipairs(custom_keys) do
	keybinding_actions[binding_lookup_id(binding)] = binding.action
end

wezterm.on("show-keybindings-fzf", function(window, pane)
	local args = { "bash", keybinding_picker_script, tostring(pane:pane_id()) }

	for _, row in ipairs(build_fzf_rows(build_picker_entries(custom_keys))) do
		table.insert(args, row)
	end

	window:perform_action(
		act.SplitPane({
			direction = "Down",
			top_level = true,
			size = { Percent = 84 },
			command = {
				args = args,
				domain = "CurrentPaneDomain",
			},
		}),
		pane
	)
end)

wezterm.on("user-var-changed", function(window, _, name, value)
	if name ~= keybinding_picker_var then
		return
	end

	local target_pane_id, action_id = value:match("^(%d+)|(.+)$")
	if not target_pane_id or not action_id then
		return
	end

	local target_pane = wezterm.mux.get_pane(tonumber(target_pane_id))
	local action = keybinding_actions[action_id]
	if not target_pane or not action then
		return
	end

	target_pane:activate()
	window:perform_action(action, target_pane)
end)

config.keys = {}

for _, binding in ipairs(custom_keys) do
	table.insert(config.keys, {
		key = binding.key,
		mods = binding.mods,
		action = binding.action,
	})
end

return config
