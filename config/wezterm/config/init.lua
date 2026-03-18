local options = require("config.options")
local opacity = require("config.opacity")
local tabs = require("config.tabs")
local keys = require("config.keys")

local M = {}

function M.build(wezterm)
	local config = wezterm.config_builder and wezterm.config_builder() or {}

	options.apply(config, wezterm)
	opacity.register(wezterm)
	tabs.register(wezterm)
	keys.apply(config, wezterm)

	return config
end

return M
