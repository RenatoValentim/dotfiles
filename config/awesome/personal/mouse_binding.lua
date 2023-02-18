local M = {}
local awful = require("awful")
local gears = require("gears")
local menu_module = require("personal.menu")

-- {{{ Mouse bindings
---@diagnostic disable-next-line: undefined-global
root.buttons(gears.table.join(
    awful.button({}, 3, function()
        menu_module.mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

return M
