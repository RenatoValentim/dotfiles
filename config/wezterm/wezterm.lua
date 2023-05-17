local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "tokyonight_night"
config.enable_tab_bar = false
config.font = wezterm.font 'Fira Code'
config.font = wezterm.font("JetBrains Mono", {
	weight = "Regular", -- "Regular" "Thin" "ExtraLight" "Light" "DemiLight" "Book" "Regular" "Medium" "DemiBold" "Bold" "ExtraBold" "Black" "ExtraBlack"
	italic = true,
})
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 0,
}

return config