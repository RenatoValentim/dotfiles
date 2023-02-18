local awful = require("awful")
local beautiful = require("beautiful")

awful.util.spawn("nm-applet")
-- awful.spawn.with_shell(sound_player .. startupSound)
awful.spawn.with_shell("picom --experimental-backends")
awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("numlockx on")
awful.spawn.with_shell("xscreensaver -nosplash")

-- Gaps
beautiful.useless_gap = 6
