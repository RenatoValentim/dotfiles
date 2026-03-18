local M = {}

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
	desc = "#e2e9ff",
	leader = "#edb07d",
	section = "#edb07d",
	shortcut = "#9cafeb",
}

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

local function binding_steps(binding, leader)
	if binding.mods and binding.mods:find("LEADER", 1, true) then
		local leader_step = combo_label(leader.mods, leader.key)
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

function M.binding_shortcut(binding, leader)
	local parts = {}
	for _, step in ipairs(binding_steps(binding, leader)) do
		table.insert(parts, "[" .. step.text .. "]")
	end

	return table.concat(parts, " ")
end

function M.build_picker_entries(bindings)
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

function M.binding_lookup_id(binding)
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

local function binding_search_text(entry, leader)
	return table.concat({
		entry.section,
		entry.binding.desc,
		M.binding_shortcut(entry.binding, leader),
	}, " ")
end

function M.build_fzf_rows(entries, leader)
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
		local shortcut = M.binding_shortcut(entry.binding, leader)
		local search = binding_search_text(entry, leader)
		local display = table.concat({
			colorize(picker_palette.section, section, true),
			"  ",
			colorize(picker_palette.desc, desc, false),
			"  ",
			colorize(picker_palette.shortcut, shortcut, true),
		})

		table.insert(rows, table.concat({ M.binding_lookup_id(entry.binding), search, display }, "\t"))
	end

	return rows
end

local function build_custom_keys(wezterm)
	local act = wezterm.action

	return {
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
end

local function build_keybinding_actions(bindings)
	local actions = {}

	for _, binding in ipairs(bindings) do
		actions[M.binding_lookup_id(binding)] = binding.action
	end

	return actions
end

local function register_picker_events(wezterm, bindings, leader)
	local act = wezterm.action
	local keybinding_picker_script = wezterm.config_dir .. "/wezterm-fzf-picker.sh"
	local keybinding_actions = build_keybinding_actions(bindings)

	wezterm.on("show-keybindings-fzf", function(window, pane)
		local args = { "bash", keybinding_picker_script, tostring(pane:pane_id()) }

		for _, row in ipairs(M.build_fzf_rows(M.build_picker_entries(bindings), leader)) do
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
end

function M.apply(config, wezterm)
	local bindings = build_custom_keys(wezterm)

	register_picker_events(wezterm, bindings, config.leader)

	config.keys = {}
	for _, binding in ipairs(bindings) do
		table.insert(config.keys, {
			key = binding.key,
			mods = binding.mods,
			action = binding.action,
		})
	end
end

return M
