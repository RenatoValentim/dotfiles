local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight_night"
config.enable_tab_bar = false
config.font_size = 11.3
config.font = wezterm.font("JetBrains Mono", {
	weight = "Bold",
	italic = true,
})
config.window_padding = {
	left = 8,
	right = 8,
	top = 0,
	bottom = 0,
}

return config
