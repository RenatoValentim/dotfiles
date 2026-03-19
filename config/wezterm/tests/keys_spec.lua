local keys = require("config.keys")

local leader = {
  key = ",",
  mods = "CTRL",
}

return {
  {
    name = "formats shortcuts with leader and shift",
    run = function()
      assert(keys.binding_shortcut({ key = "z", mods = "SHIFT" }, leader) == "[Shift+Z]")
      assert(keys.binding_shortcut({ key = "p", mods = "LEADER" }, leader) == "[Ctrl+,] [p]")
    end,
  },
  {
    name = "builds stable lookup ids",
    run = function()
      assert(keys.binding_lookup_id({ key = "-", mods = "CTRL|SHIFT" }) == "CTRL_SHIFT___")
      assert(keys.binding_lookup_id({ key = "LeftArrow", mods = "LEADER" }) == "LEADER__LeftArrow")
    end,
  },
  {
    name = "groups picker entries by section order",
    run = function()
      local bindings = {
        { key = "z", mods = "SHIFT", desc = "Toggle pane zoom", category = "pane", suggested = true },
        { key = "f", mods = "CTRL", desc = "Toggle fullscreen", category = "view" },
      }

      local entries = keys.build_picker_entries(bindings)

      assert(#entries == 3)
      assert(entries[1].section == "Suggested")
      assert(entries[1].binding == bindings[1])
      assert(entries[2].section == "Pane")
      assert(entries[2].binding == bindings[1])
      assert(entries[3].section == "View")
      assert(entries[3].binding == bindings[2])
    end,
  },
  {
    name = "builds fzf rows with ids search text and display",
    run = function()
      local bindings = {
        { key = "z", mods = "SHIFT", desc = "Toggle pane zoom", category = "pane", suggested = true },
      }

      local entries = keys.build_picker_entries(bindings)
      local rows = keys.build_fzf_rows(entries, leader)

      assert(#rows == 2)

      local id, search, display = rows[1]:match("^([^\t]+)\t([^\t]+)\t(.+)$")
      assert(id == "SHIFT__z")
      assert(search == "Suggested Toggle pane zoom [Shift+Z]")
      assert(display:find("Toggle pane zoom", 1, true) ~= nil)
    end,
  },
}
