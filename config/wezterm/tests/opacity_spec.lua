local opacity = require("config.opacity")

local function fake_wezterm()
	local handlers = {}

	return {
		wezterm = {
			on = function(name, handler)
				handlers[name] = handler
			end,
		},
		handlers = handlers,
	}
end

local function fake_window(overrides)
	local window = {
		overrides = overrides,
	}

	function window:get_config_overrides()
		return self.overrides
	end

	function window:set_config_overrides(value)
		self.overrides = value
	end

	return window
end

return {
	{
		name = "registers handlers and cycles levels",
		run = function()
			local fake = fake_wezterm()

			opacity.register(fake.wezterm)

			assert(type(fake.handlers["cycle-transparency"]) == "function")
			assert(type(fake.handlers["toggle-transparency"]) == "function")
			assert(fake.wezterm.GLOBAL.opacity_step == 1)

			local window = fake_window()
			fake.handlers["cycle-transparency"](window, nil)

			assert(fake.wezterm.GLOBAL.opacity_step == 2)
			assert(window.overrides.window_background_opacity == 0.6)
			assert(window.overrides.text_background_opacity == 0.9)
		end,
	},
	{
		name = "toggles between opaque and transparent",
		run = function()
			local fake = fake_wezterm()

			opacity.register(fake.wezterm)

			local window = fake_window()
			fake.handlers["toggle-transparency"](window, nil)
			assert(window.overrides.window_background_opacity == 0.8)
			assert(window.overrides.text_background_opacity == 0.8)

			fake.handlers["toggle-transparency"](window, nil)
			assert(window.overrides.window_background_opacity == 1.0)
			assert(window.overrides.text_background_opacity == 1.0)
		end,
	},
}
