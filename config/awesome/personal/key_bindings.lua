local M = {}
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local terminal_module = require("personal.terminal")
local menu_module = require("personal.menu")
local modkey_module = require("personal.modkey")

-- {{{ Key bindings
local globalkeys = gears.table.join(
	awful.key({ modkey_module.modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey_module.modkey, "Control" }, "l", function() awful.spawn("xscreensaver-command -lock") end, { description = "show help", group = "awesome" }),
	awful.key({ modkey_module.modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey_module.modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey_module.modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
	awful.key({ modkey_module.modkey, "Control" }, "k", function() awful.util.spawn("kitty") end, { description = "Open kitty terminal", group = "Terminal" }),
	awful.key({ modkey_module.modkey }, "j", function() awful.client.focus.byidx(1) end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey_module.modkey }, "k", function() awful.client.focus.byidx(-1) end, { description = "focus previous by index", group = "client" }),
	awful.key({ modkey_module.modkey }, "w", function() menu_module.mymainmenu:show() end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ modkey_module.modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey_module.modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end, { description = "swap with previous client by index", group = "client" }),
	-- awful.key({ modkey_module.modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
	--           {description = "focus the next screen", group = "screen"}),
	-- awful.key({ modkey_module.modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
	-- {description = "focus the previous screen", group = "screen"}),
	awful.key(
		{ modkey_module.modkey },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),
	awful.key({ modkey_module.modkey }, "Tab", function()
		awful.client.focus.history.previous()
		---@diagnostic disable-next-line: undefined-global
		if client.focus then
			---@diagnostic disable-next-line: undefined-global
			client.focus:raise()
		end end, { description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey_module.modkey }, "Return", function()
		awful.spawn(terminal_module.terminal) end, { description = "open a alacritty terminal", group = "launcher" }),
	---@diagnostic disable-next-line: undefined-global
	awful.key(
		{ modkey_module.modkey, "Control" },
		"r",
		awesome.restart,
		{ description = "reload awesome", group = "awesome" }
	),
	---@diagnostic disable-next-line: undefined-global
	awful.key({ modkey_module.modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey_module.modkey }, "l", function()
		awful.tag.incmwfact(0.05) end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey_module.modkey }, "h", function()
		awful.tag.incmwfact(-0.05) end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey_module.modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true) end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey_module.modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true) end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey_module.modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true) end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey_module.modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true) end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey_module.modkey }, "space", function()
		awful.layout.inc(1) end, { description = "select next", group = "layout" }),
	awful.key({ modkey_module.modkey, "Shift" }, "space", function()
		awful.layout.inc(-1) end, { description = "select previous", group = "layout" }),

	awful.key({ modkey_module.modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey_module.modkey }, "r", function()
		awful.util.spawn("dmenu_run")
	end, { description = "run dmenu", group = "launcher" }),
	-- awful.key({ modkey_module.modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
	--           {description = "run prompt", group = "launcher"}),

	awful.key({ modkey_module.modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
	-- Menubar
	awful.key({ modkey_module.modkey }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" }),
	-- awful.key({ modkey_module.modkey         }, ";", function () brightness_widget:inc() end, {description = "increase brightness", group = "custom"}),
	-- awful.key({ modkey_module.modkey, "Shift"}, ";", function () brightness_widget:dec() end, {description = "decrease brightness", group = "custom"}),

	awful.key({ modkey_module.modkey }, "XF86MonBrightnessUp", function()
		os.execute("brightnessctl set 10%+")
	end, { description = "+5", group = "hotkeys" }),
	awful.key({ modkey_module.modkey, "Shift" }, "XF86MonBrightnessDown", function()
		os.execute("brightnessctl set 10%-")
	end, { description = "-5%", group = "hotkeys" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute("amixer set Master 5%+")
	end, { description = "volume up", group = "hotkeys" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute("amixer set Master 5%-")
	end, { description = "volume down", group = "hotkeys" }),
	awful.key({}, "XF86AudioMute", function()
		os.execute("amixer -q set Master toggle")
	end, { description = "toggle mute", group = "hotkeys" })
)

M.clientkeys = gears.table.join(
	awful.key({ modkey_module.modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey_module.modkey, "Shift" }, "c", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey_module.modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey_module.modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey_module.modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey_module.modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey_module.modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey_module.modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey_module.modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey_module.modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- -- Bind all key numbers to tags.
-- -- Be careful: we use keycodes to make it work on any keyboard layout.
-- -- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	M.globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey_module.modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey_module.modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey_module.modkey, "Shift" }, "#" .. i + 9, function()
			---@diagnostic disable-next-line: undefined-global
			if client.focus then
				---@diagnostic disable-next-line: undefined-global
				local tag = client.focus.screen.tags[i]
				if tag then
					---@diagnostic disable-next-line: undefined-global
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey_module.modkey, "Control", "Shift" }, "#" .. i + 9, function()
			---@diagnostic disable-next-line: undefined-global
			if client.focus then
				---@diagnostic disable-next-line: undefined-global
				local tag = client.focus.screen.tags[i]
				if tag then
					---@diagnostic disable-next-line: undefined-global
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

M.clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey_module.modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey_module.modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

---@diagnostic disable-next-line: undefined-global
root.keys(globalkeys)
-- Set keys

return M
