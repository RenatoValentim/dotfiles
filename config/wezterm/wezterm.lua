local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.color_scheme = "tokyonight_night"
config.enable_tab_bar = false
config.warn_about_missing_glyphs = false
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0
config.font = wezterm.font("JetBrains Mono", { weight = "Regular", italic = true })
config.font_size = 11.0
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.term = "wezterm"
config.enable_wayland = true

-- Opcional:
-- config.macos_window_background_blur = 20        -- macOS blur + opacity  :contentReference[oaicite:6]{index=6}
-- config.kde_window_background_blur = true        -- KDE Wayland (nightly)  :contentReference[oaicite:7]{index=7}

wezterm.GLOBAL = wezterm.GLOBAL or { opacity_step = 1 }

local levels = { { 1.0, 1.0 }, { 0.6, 0.9 }, { 0.3, 0.8 } } -- {window_bg, text_bg}
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

config.keys = {
	{ key = "f", mods = "CTRL", action = wezterm.action.ToggleFullScreen },
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-transparency") },
	{ key = "y", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("cycle-transparency") },
}

return config
