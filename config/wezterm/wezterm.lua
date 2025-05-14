local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight_night" -- tokyonight tokyonight_night tokyonight_storm tokyonight_day tokyonight_moon
config.enable_tab_bar = false
config.warn_about_missing_glyphs = false
config.window_background_opacity = 0.8
-- MesloLGS NF
config.font = wezterm.font("JetBrains Mono", {
	weight = "Regular",
	italic = true,
})
config.font_size = 11.0
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_decorations = "RESIZE"
config.term = "xterm-256color"
config.enable_wayland = true
config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
}

return config
