local keys = require("config.keys")

local leader = {
  key = ",",
  mods = "CTRL",
}

local function fake_pane(data)
  return {
    get_foreground_process_name = function()
      return data.foreground_process_name
    end,
    get_current_working_dir = function()
      return data.current_working_dir
    end,
    get_title = function()
      return data.title
    end,
  }
end

local function fake_tab(data)
  local pane = fake_pane(data.pane)

  return {
    tab_id = function()
      return data.tab_id
    end,
    get_title = function()
      return data.tab_title
    end,
    active_pane = function()
      return pane
    end,
  }
end

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
  {
    name = "builds tab choices for the rename picker",
    run = function()
      local choices = keys.build_tab_choices({
        {
          tab = fake_tab({
            tab_id = 3,
            tab_title = "",
            pane = {
              foreground_process_name = "/usr/bin/bash",
              current_working_dir = { file_path = "/home/rvsj/projects/dotfiles/" },
              title = "shell",
            },
          }),
          index = 2,
          is_active = true,
        },
        {
          tab = fake_tab({
            tab_id = 4,
            tab_title = "notes",
            pane = {
              foreground_process_name = "/usr/bin/bash",
              current_working_dir = "file:///home/rvsj/projects/wiki/",
              title = "shell",
            },
          }),
          index = 3,
          is_active = false,
        },
      })

      assert(#choices == 2)
      assert(choices[1].id == "3")
      assert(choices[1].label == "[*] 3  dotfiles")
      assert(choices[2].id == "4")
      assert(choices[2].label == "[ ] 4  notes  wiki")
    end,
  },
  {
    name = "builds zoxide path choices",
    run = function()
      local choices = keys.build_path_choices(table.concat({
        "/home/rvsj/projects/dotfiles",
        "/home/rvsj/projects/wiki",
        "/home/rvsj/projects/dotfiles",
        "",
      }, "\n"))

      assert(#choices == 2)
      assert(choices[1].id == "/home/rvsj/projects/dotfiles")
      assert(choices[1].label == "dotfiles  /home/rvsj/projects/dotfiles")
      assert(choices[2].id == "/home/rvsj/projects/wiki")
      assert(choices[2].label == "wiki  /home/rvsj/projects/wiki")
    end,
  },
}
