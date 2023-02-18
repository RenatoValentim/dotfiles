local M = {}
local awful = require("awful")
local wibox = require("wibox")
-- local docker_widget = require("awesome-wm-widgets.docker-widget.docker")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
-- local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
-- local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
local tbox_margin = wibox.widget.textclock(" ")
local tbox_separator = wibox.widget.textclock(" | ")
local mytextclock = wibox.widget.textclock("  %a %b(%m) %d, %H:%M")
local mykeyboardlayout = awful.widget.keyboardlayout()

local cw = calendar_widget({
    theme = "nord",
    placement = "top_right",
    start_sunday = true,
    radius = 4,
    previous_month_button = 1,
    next_month_button = 3,
})

mytextclock:connect_signal("button::press",
function(_, _, _, button)
    if button == 1 then cw.toggle() end
end)

M.make_widgets = function(s)
	return {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			-- mylauncher,
			s.mytaglist,
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,
			wibox.widget.systray(),
			-- tbox_margin,
			-- docker_widget(),
			tbox_separator,
			volume_widget(),
			tbox_separator,
			-- brightness_widget{
			--     type = 'icon_and_text',
			--     program = 'light',
			--     step = 2,
			-- },
			-- tbox_separator,
			-- ram_widget(),
			-- tbox_separator,
			cpu_widget({
				width = 50,
				step_width = 2,
				step_spacing = 0,
				enable_kill_button = true,
				color = "#434c5e",
			}),
			-- tbox_separator,
			-- net_speed_widget(),
			tbox_separator,
			mytextclock,
			tbox_separator,
			battery_widget({
				font = "Play 9",
				show_current_level = true,
				margin_right = 4,
				margin_left = 4,
			}),
			tbox_separator,
			logout_menu_widget(),
			tbox_margin,
			s.mylayoutbox,
		},
	}
end

return M
