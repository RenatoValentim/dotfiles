local tabs = require("config.tabs")

local M = {}

local mod_names = {
  ALT = "Alt",
  CMD = "Cmd",
  CTRL = "Ctrl",
  META = "Meta",
  OPT = "Opt",
  SHIFT = "Shift",
  SUPER = "Super",
  WIN = "Win",
}

local key_names = {
  DownArrow = "Down",
  Enter = "Enter",
  Escape = "Esc",
  Home = "Home",
  Insert = "Insert",
  LeftArrow = "Left",
  PageDown = "PageDown",
  PageUp = "PageUp",
  RightArrow = "Right",
  Tab = "Tab",
  UpArrow = "Up",
}

local picker_palette = {
  desc = "#e2e9ff",
  leader = "#edb07d",
  section = "#edb07d",
  shortcut = "#9cafeb",
}

local keybinding_picker_var = "WEZTERM_KEYBINDING_PICKER"
local tab_open_path_var = "WEZTERM_TAB_OPEN_PATH"
local tab_rename_var = "WEZTERM_TAB_RENAME"
local workspace_action_var = "WEZTERM_WORKSPACE_ACTION"

local picker_sections = {
  { key = "suggested", label = "Suggested" },
  { key = "pane", label = "Pane" },
  { key = "tab", label = "Tab" },
  { key = "view", label = "View" },
  { key = "send", label = "Send" },
  { key = "ui", label = "UI" },
}

local function split_mods(mods)
  local parts = {}
  if not mods or mods == "" then
    return parts
  end

  for mod in mods:gmatch("[^|]+") do
    table.insert(parts, mod)
  end

  return parts
end

local function key_name(key)
  return key_names[key] or key
end

local function display_key(key, mods)
  local name = key_name(key)
  if #name == 1 and name:match("%l") and mods and mods:find("SHIFT", 1, true) then
    return name:upper()
  end

  return name
end

local function combo_label(mods, key)
  local parts = {}
  for _, mod in ipairs(split_mods(mods)) do
    if mod ~= "LEADER" then
      table.insert(parts, mod_names[mod] or mod)
    end
  end

  table.insert(parts, display_key(key, mods))
  return table.concat(parts, "+")
end

local function remove_mod(mods, needle)
  local parts = {}
  for _, mod in ipairs(split_mods(mods)) do
    if mod ~= needle then
      table.insert(parts, mod)
    end
  end

  return table.concat(parts, "|")
end

local function binding_steps(binding, leader)
  if binding.mods and binding.mods:find("LEADER", 1, true) then
    local leader_step = combo_label(leader.mods, leader.key)
    local tail_mods = remove_mod(binding.mods, "LEADER")
    local tail_step = tail_mods == "" and display_key(binding.key, nil) or combo_label(tail_mods, binding.key)
    return {
      { text = leader_step, color = picker_palette.leader },
      { text = tail_step, color = picker_palette.shortcut },
    }
  end

  return {
    { text = combo_label(binding.mods, binding.key), color = picker_palette.shortcut },
  }
end

function M.binding_shortcut(binding, leader)
  local parts = {}
  for _, step in ipairs(binding_steps(binding, leader)) do
    table.insert(parts, "[" .. step.text .. "]")
  end

  return table.concat(parts, " ")
end

function M.build_picker_entries(bindings)
  local entries = {}

  for _, section in ipairs(picker_sections) do
    for _, binding in ipairs(bindings) do
      local include = section.key == "suggested" and binding.suggested or binding.category == section.key
      if include then
        table.insert(entries, {
          binding = binding,
          section = section.label,
        })
      end
    end
  end

  return entries
end

function M.binding_lookup_id(binding)
  local mods = binding.mods and binding.mods:gsub("|", "_") or "NONE"
  local key = tostring(binding.key):gsub("[^%w]", "_")
  return mods .. "__" .. key
end

local function colorize(hex, text, bold)
  local red, green, blue = hex:match("#(%x%x)(%x%x)(%x%x)")
  if not red then
    return text
  end

  local weight = bold and "1;" or ""
  return string.format(
    "\27[%s38;2;%d;%d;%dm%s\27[0m",
    weight,
    tonumber(red, 16),
    tonumber(green, 16),
    tonumber(blue, 16),
    text
  )
end

local function binding_search_text(entry, leader)
  return table.concat({
    entry.section,
    entry.binding.desc,
    M.binding_shortcut(entry.binding, leader),
  }, " ")
end

local function notify(window, message)
  if window and window.toast_notification then
    window:toast_notification("WezTerm", message, nil, 4000)
  end
end

local function call_method(object, method_name)
  if not object or not object[method_name] then
    return nil
  end

  local ok, value = pcall(function()
    return object[method_name](object)
  end)
  if not ok then
    return nil
  end

  return value
end

local function trim_text(text)
  return (text or ""):match("^%s*(.-)%s*$")
end

local function path_value(path)
  if path == nil then
    return nil
  end

  local ok, file_path = pcall(function()
    return path.file_path
  end)
  if ok and file_path and file_path ~= "" then
    return file_path
  end

  if type(path) == "string" then
    return path
  end

  local value = tostring(path)
  if value == "" or value:match("^table: ") or value:match("^userdata: ") then
    return nil
  end

  return value
end

local function cwd_path(cwd)
  local value = path_value(cwd)
  if not value or value == "" then
    return nil
  end

  if value:match("^[%a][%w+.-]*://") then
    if not value:find("file://", 1, true) then
      return nil
    end

    value = value:gsub("^file://", "")
  end

  return value ~= "" and value or nil
end

local function current_pane_cwd(pane)
  return cwd_path(call_method(pane, "get_current_working_dir"))
end

function M.parse_pane_text_payload(value)
  local target_pane_id, text = (value or ""):match("^(%d+)|(.*)$")
  if not target_pane_id then
    return nil
  end

  return {
    target_pane_id = tonumber(target_pane_id),
    text = text,
  }
end

function M.parse_tab_rename_payload(value)
  local target_pane_id, tab_id, title = (value or ""):match("^(%d+)|(%d+)|(.*)$")
  if not target_pane_id or not tab_id then
    return nil
  end

  return {
    target_pane_id = tonumber(target_pane_id),
    tab_id = tonumber(tab_id),
    title = title,
  }
end

function M.parse_workspace_action_payload(value)
  local target_pane_id, action, payload = (value or ""):match("^(%d+)|([^|]+)|(.*)$")
  if not target_pane_id or not action then
    return nil
  end

  if action == "rename" then
    local current_workspace, workspace_name = payload:match("^([^|]+)|(.*)$")
    if not current_workspace then
      return nil
    end

    return {
      target_pane_id = tonumber(target_pane_id),
      action = action,
      current_workspace = current_workspace,
      workspace_name = workspace_name,
    }
  end

  if action ~= "create" and action ~= "switch" then
    return nil
  end

  return {
    target_pane_id = tonumber(target_pane_id),
    action = action,
    workspace_name = payload,
  }
end

function M.parse_zoxide_output(output)
  local paths = {}
  local seen = {}

  for path in (output or ""):gmatch("[^\r\n]+") do
    if path ~= "" and not seen[path] then
      seen[path] = true
      table.insert(paths, path)
    end
  end

  return paths
end

local function escape_lua_pattern(text)
  return (text:gsub("([^%w])", "%%%1"))
end

function M.display_path(path, home_dir)
  if not path or path == "" then
    return ""
  end

  if not home_dir or home_dir == "" then
    return path
  end

  local normalized_path = path:gsub("[/\\]+$", "")
  local normalized_home = home_dir:gsub("[/\\]+$", "")

  if normalized_path == normalized_home then
    return "~"
  end

  local suffix = normalized_path:match("^" .. escape_lua_pattern(normalized_home) .. "([/\\].*)$")
  if suffix then
    return "~" .. suffix
  end

  return path
end

function M.path_choice_label(path, home_dir)
  local name = tabs.basename(path)
  local display_path = M.display_path(path, home_dir)

  if name == "" or name == path then
    return display_path
  end

  return string.format("%s  %s", name, display_path)
end

function M.build_path_rows(output, home_dir)
  local rows = {}
  local paths = M.parse_zoxide_output(output)
  local max_name_width = 0

  for _, path in ipairs(paths) do
    max_name_width = math.max(max_name_width, #tabs.basename(path))
  end

  for _, path in ipairs(paths) do
    local name = tabs.basename(path)
    local display_path = M.display_path(path, home_dir)
    local search = table.concat({ name, display_path, path }, " ")
    local display

    if name == "" or name == path then
      display = colorize(picker_palette.desc, display_path, false)
    else
      local padded_name = string.format("%-" .. tostring(max_name_width) .. "s", name)
      display = table.concat({
        colorize(picker_palette.section, padded_name, true),
        "  ",
        colorize(picker_palette.desc, display_path, false),
      })
    end

    table.insert(rows, table.concat({ path, search, display }, "\t"))
  end

  return rows
end

function M.build_workspace_rows(workspace_names, current_workspace)
  local rows = {}
  local names = {}
  local seen = {}

  for _, workspace_name in ipairs(workspace_names or {}) do
    if workspace_name ~= "" and not seen[workspace_name] then
      seen[workspace_name] = true
      table.insert(names, workspace_name)
    end
  end

  table.sort(names, function(left, right)
    local left_is_current = left == current_workspace
    local right_is_current = right == current_workspace

    if left_is_current ~= right_is_current then
      return left_is_current
    end

    return left:lower() < right:lower()
  end)

  for _, workspace_name in ipairs(names) do
    local is_current = workspace_name == current_workspace
    local search = is_current and table.concat({ "Current", workspace_name }, " ") or workspace_name
    local display

    if is_current then
      display = table.concat({
        colorize(picker_palette.section, "Current", true),
        "  ",
        colorize(picker_palette.desc, workspace_name, false),
      })
    else
      display = colorize(picker_palette.desc, workspace_name, false)
    end

    table.insert(rows, table.concat({ workspace_name, search, display }, "\t"))
  end

  return rows
end

function M.build_fzf_rows(entries, leader)
  local rows = {}
  local max_desc_width = 0
  local max_section_width = 0

  for _, entry in ipairs(entries) do
    max_desc_width = math.max(max_desc_width, #entry.binding.desc)
    max_section_width = math.max(max_section_width, #entry.section)
  end

  for _, entry in ipairs(entries) do
    local section = string.format("%-" .. tostring(max_section_width) .. "s", entry.section)
    local desc = string.format("%-" .. tostring(max_desc_width) .. "s", entry.binding.desc)
    local shortcut = M.binding_shortcut(entry.binding, leader)
    local search = binding_search_text(entry, leader)
    local display = table.concat({
      colorize(picker_palette.section, section, true),
      "  ",
      colorize(picker_palette.desc, desc, false),
      "  ",
      colorize(picker_palette.shortcut, shortcut, true),
    })

    table.insert(rows, table.concat({ M.binding_lookup_id(entry.binding), search, display }, "\t"))
  end

  return rows
end

local function open_tab_rename_prompt(wezterm, window, pane, tab_id, current_title)
  window:perform_action(
    wezterm.action.SpawnCommandInNewTab({
      args = {
        "bash",
        wezterm.config_dir .. "/wezterm-tab-rename.sh",
        tostring(pane:pane_id()),
        tostring(tab_id),
        current_title or "",
      },
      domain = "CurrentPaneDomain",
    }),
    pane
  )
end

local function open_tab_create_prompt(wezterm, window, pane, cwd)
  local args = {
    "bash",
    wezterm.config_dir .. "/wezterm-tab-create.sh",
    tostring(pane:pane_id()),
    tostring(window:window_id()),
  }

  if cwd and cwd ~= "" then
    table.insert(args, cwd)
  end

  window:perform_action(
    wezterm.action.SpawnCommandInNewTab({
      args = args,
      domain = "CurrentPaneDomain",
    }),
    pane
  )
end

local function rename_current_tab(wezterm, window, pane)
  local active_tab = call_method(window, "active_tab")
  if not active_tab then
    notify(window, "No active tab to rename")
    return
  end

  local tab_id = call_method(active_tab, "tab_id")
  if not tab_id then
    notify(window, "No active tab to rename")
    return
  end

  open_tab_rename_prompt(wezterm, window, pane, tab_id, call_method(active_tab, "get_title") or "")
end

local function open_tab_at_path(wezterm, window, pane)
  local ok, stdout, stderr = wezterm.run_child_process({ "zoxide", "query", "-l" })
  if not ok then
    notify(window, stderr and stderr ~= "" and stderr or "Unable to query zoxide")
    return
  end

  local rows = M.build_path_rows(stdout, wezterm.home_dir or os.getenv("HOME"))
  if #rows == 0 then
    notify(window, "No zoxide paths found")
    return
  end

  local args = {
    "bash",
    wezterm.config_dir .. "/wezterm-zoxide-picker.sh",
    tostring(pane:pane_id()),
  }

  for _, row in ipairs(rows) do
    table.insert(args, row)
  end

  window:perform_action(
    wezterm.action.SpawnCommandInNewTab({
      args = args,
      domain = "CurrentPaneDomain",
    }),
    pane
  )
end

local function open_workspace_picker(wezterm, window, pane, extra_args)
  local args = {
    "bash",
    wezterm.config_dir .. "/wezterm-workspace-picker.sh",
    tostring(pane:pane_id()),
  }

  for _, value in ipairs(extra_args or {}) do
    table.insert(args, value)
  end

  window:perform_action(
    wezterm.action.SpawnCommandInNewTab({
      args = args,
      domain = "CurrentPaneDomain",
    }),
    pane
  )
end

local function open_workspace_create_prompt(wezterm, window, pane)
  open_workspace_picker(wezterm, window, pane, { "create" })
end

local function active_workspace_name(wezterm, window)
  local workspace_name = call_method(window, "active_workspace")
  if workspace_name and workspace_name ~= "" then
    return workspace_name
  end

  if not wezterm.mux or not wezterm.mux.get_active_workspace then
    return nil
  end

  local ok, active_workspace = pcall(wezterm.mux.get_active_workspace)
  if ok then
    return active_workspace
  end

  return nil
end

local function open_workspace_rename_prompt(wezterm, window, pane)
  local current_workspace = active_workspace_name(wezterm, window)
  if not current_workspace then
    notify(window, "No active workspace to rename")
    return
  end

  open_workspace_picker(wezterm, window, pane, { "rename", current_workspace })
end

local function open_workspace_switch_picker(wezterm, window, pane)
  if not wezterm.mux or not wezterm.mux.get_workspace_names then
    notify(window, "Unable to list workspaces")
    return
  end

  local ok, workspace_names = pcall(wezterm.mux.get_workspace_names)
  if not ok or not workspace_names then
    notify(window, "Unable to list workspaces")
    return
  end

  local current_workspace = active_workspace_name(wezterm, window)
  local rows = M.build_workspace_rows(workspace_names, current_workspace)
  if #rows == 0 then
    notify(window, "No workspaces found")
    return
  end

  local args = { "switch", current_workspace or "" }
  for _, row in ipairs(rows) do
    table.insert(args, row)
  end

  open_workspace_picker(wezterm, window, pane, args)
end

local function build_custom_keys(wezterm)
  local act = wezterm.action

  return {
    {
      key = "z",
      mods = "SHIFT",
      action = act.TogglePaneZoomState,
      desc = "Toggle pane zoom",
      category = "pane",
      suggested = true,
    },
    {
      key = "f",
      mods = "CTRL",
      action = act.ToggleFullScreen,
      desc = "Toggle fullscreen",
      category = "view",
      suggested = true,
    },
    {
      key = "F",
      mods = "CTRL|SHIFT",
      action = act.EmitEvent("search-scrollback-fzf"),
      desc = "Search scrollback",
      category = "view",
    },
    {
      key = "t",
      mods = "CTRL|SHIFT",
      action = act.EmitEvent("toggle-transparency"),
      desc = "Toggle transparency",
      category = "view",
    },
    {
      key = "y",
      mods = "CTRL|SHIFT",
      action = act.EmitEvent("cycle-transparency"),
      desc = "Cycle transparency",
      category = "view",
    },
    {
      key = "a",
      mods = "LEADER|CTRL",
      action = act.SendKey({ key = "a", mods = "CTRL" }),
      desc = "Send Ctrl+A to pane",
      category = "send",
    },
    {
      key = "h",
      mods = "SUPER|SHIFT",
      action = act.AdjustPaneSize({ "Left", 3 }),
      desc = "Resize left",
      category = "pane",
    },
    {
      key = "j",
      mods = "SUPER|SHIFT",
      action = act.AdjustPaneSize({ "Down", 3 }),
      desc = "Resize down",
      category = "pane",
    },
    {
      key = "k",
      mods = "SUPER|SHIFT",
      action = act.AdjustPaneSize({ "Up", 3 }),
      desc = "Resize up",
      category = "pane",
    },
    {
      key = "l",
      mods = "SUPER|SHIFT",
      action = act.AdjustPaneSize({ "Right", 3 }),
      desc = "Resize right",
      category = "pane",
    },
    {
      key = "h",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Left"),
      desc = "Focus left pane",
      category = "pane",
    },
    {
      key = "j",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Down"),
      desc = "Focus pane below",
      category = "pane",
    },
    {
      key = "k",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Up"),
      desc = "Focus pane above",
      category = "pane",
    },
    {
      key = "l",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Right"),
      desc = "Focus right pane",
      category = "pane",
    },
    { key = "n", mods = "ALT", action = act.ActivateTabRelative(1), desc = "Next tab", category = "tab" },
    { key = "p", mods = "ALT", action = act.ActivateTabRelative(-1), desc = "Previous tab", category = "tab" },
    {
      key = "LeftArrow",
      mods = "LEADER",
      action = act.MoveTabRelative(-1),
      desc = "Move tab left",
      category = "tab",
    },
    {
      key = "RightArrow",
      mods = "LEADER",
      action = act.MoveTabRelative(1),
      desc = "Move tab right",
      category = "tab",
    },
    {
      key = "w",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        open_tab_at_path(wezterm, window, pane)
      end),
      desc = "Open tab at path",
      category = "tab",
      suggested = true,
    },
    {
      key = "c",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        open_tab_create_prompt(wezterm, window, pane, current_pane_cwd(pane))
      end),
      desc = "Create a new named tab here",
      category = "tab",
      suggested = true,
    },
    {
      key = "t",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        open_tab_create_prompt(wezterm, window, pane)
      end),
      desc = "Create a new named tab",
      category = "tab",
      suggested = true,
    },
    {
      key = "r",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        rename_current_tab(wezterm, window, pane)
      end),
      desc = "Rename current tab",
      category = "tab",
      suggested = true,
    },
    {
      key = "s",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        open_workspace_create_prompt(wezterm, window, pane)
      end),
      desc = "Create a new workspace",
      category = "ui",
      suggested = true,
    },
    {
      key = "s",
      mods = "LEADER|SHIFT",
      action = wezterm.action_callback(function(window, pane)
        open_workspace_rename_prompt(wezterm, window, pane)
      end),
      desc = "Rename current workspace",
      category = "ui",
      suggested = true,
    },
    {
      key = "o",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        open_workspace_switch_picker(wezterm, window, pane)
      end),
      desc = "Switch workspace",
      category = "ui",
      suggested = true,
    },
    {
      key = "p",
      mods = "LEADER",
      action = act.EmitEvent("show-keybindings-fzf"),
      desc = "Open keybinding picker",
      category = "ui",
    },
    {
      key = "x",
      mods = "LEADER",
      action = act.CloseCurrentPane({ confirm = true }),
      desc = "Close pane",
      category = "pane",
    },
    {
      key = "-",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
      desc = "Split vertically",
      category = "pane",
      suggested = true,
    },
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
      desc = "Split horizontally",
      category = "pane",
      suggested = true,
    },
  }
end

local function build_keybinding_actions(bindings)
  local actions = {}

  for _, binding in ipairs(bindings) do
    actions[M.binding_lookup_id(binding)] = binding.action
  end

  return actions
end

local function register_picker_events(wezterm, bindings, leader)
  local act = wezterm.action
  local keybinding_picker_script = wezterm.config_dir .. "/wezterm-fzf-picker.sh"
  local scrollback_search_script = wezterm.config_dir .. "/wezterm-scrollback-search.sh"
  local keybinding_actions = build_keybinding_actions(bindings)

  wezterm.on("show-keybindings-fzf", function(window, pane)
    local args = { "bash", keybinding_picker_script, tostring(pane:pane_id()) }

    for _, row in ipairs(M.build_fzf_rows(M.build_picker_entries(bindings), leader)) do
      table.insert(args, row)
    end

    window:perform_action(
      act.SpawnCommandInNewTab({
        args = args,
        domain = "CurrentPaneDomain",
      }),
      pane
    )
  end)

  wezterm.on("search-scrollback-fzf", function(window, pane)
    local lines = pane:get_lines_as_text(2000)
    local tmpfile = wezterm.home_dir .. "/.cache/wezterm-scrollback-" .. tostring(pane:pane_id()) .. ".txt"

    local f = io.open(tmpfile, "w")
    if not f then
      notify(window, "Unable to write scrollback")
      return
    end
    f:write(lines)
    f:close()

    window:perform_action(
      act.SpawnCommandInNewTab({
        args = { "bash", scrollback_search_script, tostring(pane:pane_id()), tmpfile },
        domain = "CurrentPaneDomain",
      }),
      pane
    )
  end)

  wezterm.on("user-var-changed", function(window, _, name, value)
    if name == keybinding_picker_var then
      local target_pane_id, action_id = value:match("^(%d+)|(.+)$")
      if not target_pane_id or not action_id then
        return
      end

      local target_pane = wezterm.mux.get_pane(tonumber(target_pane_id))
      local action = keybinding_actions[action_id]
      if not target_pane or not action then
        return
      end

      target_pane:activate()
      window:perform_action(action, target_pane)
      return
    end

    if name == workspace_action_var then
      local payload = M.parse_workspace_action_payload(value)
      if not payload then
        return
      end

      local target_pane = wezterm.mux.get_pane(payload.target_pane_id)
      if not target_pane then
        return
      end

      target_pane:activate()

      local workspace_name = trim_text(payload.workspace_name)
      if payload.action == "rename" then
        local current_workspace = trim_text(payload.current_workspace)
        if workspace_name == "" or current_workspace == "" or workspace_name == current_workspace then
          return
        end

        local ok = pcall(function()
          wezterm.mux.rename_workspace(current_workspace, workspace_name)
        end)
        if not ok then
          notify(window, "Unable to rename workspace")
        end

        return
      end

      if workspace_name == "" then
        return
      end

      window:perform_action(wezterm.action.SwitchToWorkspace({ name = workspace_name }), target_pane)
      return
    end

    if name == tab_open_path_var then
      local payload = M.parse_pane_text_payload(value)
      if not payload or payload.text == "" then
        return
      end

      local target_pane = wezterm.mux.get_pane(payload.target_pane_id)
      if not target_pane then
        return
      end

      target_pane:activate()
      window:perform_action(
        wezterm.action.SpawnCommandInNewTab({
          cwd = payload.text,
          domain = "CurrentPaneDomain",
        }),
        target_pane
      )
      return
    end

    if name ~= tab_rename_var then
      return
    end

    local payload = M.parse_tab_rename_payload(value)
    if not payload then
      return
    end

    local target_pane = wezterm.mux.get_pane(payload.target_pane_id)
    if not target_pane then
      return
    end

    local target_tab = wezterm.mux.get_tab(payload.tab_id)
    if target_tab then
      target_tab:set_title(payload.title)
    end

    target_pane:activate()
  end)
end

function M.apply(config, wezterm)
  local bindings = build_custom_keys(wezterm)

  register_picker_events(wezterm, bindings, config.leader)

  config.keys = {}
  for _, binding in ipairs(bindings) do
    table.insert(config.keys, {
      key = binding.key,
      mods = binding.mods,
      action = binding.action,
    })
  end
end

return M
