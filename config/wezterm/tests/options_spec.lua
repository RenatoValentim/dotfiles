local options = require("config.options")

return {
	{
		name = "applies static defaults",
		run = function()
			local config = {}
			local wezterm = {
				font = function(name, attrs)
					return {
						name = name,
						attrs = attrs,
					}
				end,
			}

			options.apply(config, wezterm)

			assert(config.color_scheme == "tokyonight_night")
			assert(config.enable_tab_bar == true)
			assert(config.tab_bar_at_bottom == true)
			assert(config.leader.key == ",")
			assert(config.leader.mods == "CTRL")
			assert(config.font.name == "JetBrains Mono Nerd Font")
			assert(config.font.attrs.italic == true)
			assert(config.colors.tab_bar.active_tab.fg_color == "#e2e9ff")
		end,
	},
}
