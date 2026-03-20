local keys = require("config.keys")

local leader = {
  key = ",",
  mods = "CTRL",
}

local home_dir = "/tmp/test-home"

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
    name = "builds workspace rows with current workspace first",
    run = function()
      local rows = keys.build_workspace_rows({ "docs", "default", "Docs", "default" }, "default")

      assert(#rows == 3)

      local id, search, display = rows[1]:match("^([^\t]+)\t([^\t]+)\t(.+)$")
      assert(id == "default")
      assert(search == "Current default")
      assert(display:find("Current", 1, true) ~= nil)
      assert(display:find("default", 1, true) ~= nil)
    end,
  },
  {
    name = "adds workspace creation rename and switching bindings",
    run = function()
      local wezterm = {
        action = setmetatable({}, {
          __index = function(_, name)
            return function(...)
              return {
                action = name,
                args = { ... },
              }
            end
          end,
        }),
        action_callback = function(callback)
          return {
            action = "callback",
            callback = callback,
          }
        end,
        config_dir = "/tmp/wezterm",
        mux = {
          get_workspace_names = function()
            return { "docs", "default" }
          end,
        },
        on = function() end,
      }
      local config = { leader = leader }

      keys.apply(config, wezterm)

      local create_workspace
      local rename_workspace
      local switch_workspace
      for _, binding in ipairs(config.keys) do
        if binding.key == "s" and binding.mods == "LEADER" then
          create_workspace = binding
        elseif binding.key == "s" and binding.mods == "LEADER|SHIFT" then
          rename_workspace = binding
        elseif binding.key == "o" and binding.mods == "LEADER" then
          switch_workspace = binding
        end
      end

      assert(create_workspace ~= nil)
      assert(rename_workspace ~= nil)
      assert(switch_workspace ~= nil)

      local performed
      local window = {
        active_workspace = function()
          return "default"
        end,
        perform_action = function(_, action, pane)
          performed = {
            action = action,
            pane = pane,
          }
        end,
      }
      local pane = {
        pane_id = function()
          return 12
        end,
      }

      create_workspace.action.callback(window, pane)
      assert(performed.action.action == "SplitPane")
      assert(performed.action.args[1].command.args[2] == "/tmp/wezterm/wezterm-workspace-picker.sh")
      assert(performed.action.args[1].command.args[3] == "12")
      assert(performed.action.args[1].command.args[4] == "create")

      rename_workspace.action.callback(window, pane)
      assert(performed.action.action == "SplitPane")
      assert(performed.action.args[1].command.args[4] == "rename")
      assert(performed.action.args[1].command.args[5] == "default")

      switch_workspace.action.callback(window, pane)
      assert(performed.action.action == "SplitPane")
      assert(performed.action.args[1].command.args[4] == "switch")
      assert(performed.action.args[1].command.args[5] == "default")
      assert(performed.action.args[1].command.args[6]:find("default", 1, true) ~= nil)
      assert(performed.action.args[1].command.args[7]:find("docs", 1, true) ~= nil)
    end,
  },
  {
    name = "parses workspace action payloads",
    run = function()
      local create_payload = keys.parse_workspace_action_payload("12|create|dev")
      assert(create_payload.target_pane_id == 12)
      assert(create_payload.action == "create")
      assert(create_payload.workspace_name == "dev")

      local rename_payload = keys.parse_workspace_action_payload("12|rename|default|notes")
      assert(rename_payload.target_pane_id == 12)
      assert(rename_payload.action == "rename")
      assert(rename_payload.current_workspace == "default")
      assert(rename_payload.workspace_name == "notes")
    end,
  },
  {
    name = "parses pane text payloads",
    run = function()
      local payload = keys.parse_pane_text_payload("12|notes|draft")

      assert(payload.target_pane_id == 12)
      assert(payload.text == "notes|draft")
    end,
  },
  {
    name = "parses tab rename payloads",
    run = function()
      local payload = keys.parse_tab_rename_payload("12|4|test1")

      assert(payload.target_pane_id == 12)
      assert(payload.tab_id == 4)
      assert(payload.title == "test1")
    end,
  },
  {
    name = "replaces the home prefix in displayed paths",
    run = function()
      assert(keys.display_path(home_dir .. "/projects/dotfiles", home_dir) == "~/projects/dotfiles")
      assert(keys.display_path(home_dir, home_dir) == "~")
      assert(keys.display_path("/tmp/workspace", home_dir) == "/tmp/workspace")
    end,
  },
  {
    name = "builds zoxide path rows",
    run = function()
      local rows = keys.build_path_rows(
        table.concat({
          home_dir .. "/projects/dotfiles",
          home_dir .. "/projects/wiki",
          home_dir .. "/projects/dotfiles",
          "",
        }, "\n"),
        home_dir
      )

      assert(#rows == 2)

      local id, search, display = rows[1]:match("^([^\t]+)\t([^\t]+)\t(.+)$")
      assert(id == home_dir .. "/projects/dotfiles")
      assert(search:find("dotfiles", 1, true) ~= nil)
      assert(search:find("~/projects/dotfiles", 1, true) ~= nil)
      assert(display:find("dotfiles", 1, true) ~= nil)
      assert(display:find("~/projects/dotfiles", 1, true) ~= nil)
    end,
  },
}
