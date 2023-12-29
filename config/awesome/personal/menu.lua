local M = {}

local awful = require("awful")
local menubar = require("menubar")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local terminal_module = require("personal.terminal")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

M.myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal_module.terminal .. " -e man awesome" },
	---@diagnostic disable-next-line: undefined-global
	{ "edit config", terminal_module.editor_cmd .. " " .. awesome.conffile },
	---@diagnostic disable-next-line: undefined-global
	{ "restart", awesome.restart },
	---@diagnostic disable-next-line: undefined-global
	{
		"quit",
		function()
			---@diagnostic disable-next-line: undefined-global
			awesome.quit()
		end,
	},
}

local menu_awesome = { "awesome", M.myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal_module.terminal }

if has_fdo then
	M.mymainmenu = freedesktop.menu.build({
		before = { menu_awesome },
		after = { menu_terminal },
	})
else
	M.mymainmenu = awful.menu({
		items = {
			menu_awesome,
			{ "Debian", debian.menu.Debian_menu.Debian },
			menu_terminal,
		},
	})
end

M.mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = M.mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal_module.terminal -- Set the terminal for applications that require it

return M
