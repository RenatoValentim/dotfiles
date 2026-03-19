local M = {}

local shells = {
  bash = true,
  sh = true,
  zsh = true,
  fish = true,
  nu = true,
  nushell = true,
}

local function path_value(path)
  if path == nil then
    return nil
  end

  if type(path) == "table" and path.file_path then
    return path.file_path
  end

  local ok, file_path = pcall(function()
    return path.file_path
  end)
  if ok and file_path and file_path ~= "" then
    return file_path
  end

  return tostring(path)
end

function M.basename(path)
  if not path or path == "" then
    return ""
  end

  return path:gsub("(.*[/\\])(.*)", "%2")
end

function M.cwd_name(cwd)
  if not cwd then
    return ""
  end

  local value = path_value(cwd)
  value = value:gsub("^file://", "")
  value = value:gsub("/+$", "")

  return M.basename(value)
end

function M.tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end

  local pane = tab_info.active_pane
  local process = M.basename(pane.foreground_process_name)
  local directory = M.cwd_name(pane.current_working_dir)

  if process ~= "" and not shells[process] then
    return process
  end

  if directory ~= "" then
    return directory
  end

  if process ~= "" then
    return process
  end

  return pane.title or "shell"
end

local function label_width(wezterm, label)
  if wezterm.column_width then
    return wezterm.column_width(label)
  end

  return #label
end

function M.zoom_badge_from_panes(panes)
  local pane_count = 0
  local is_zoomed = false

  for _, pane in ipairs(panes or {}) do
    pane_count = pane_count + 1
    if pane.is_zoomed then
      is_zoomed = true
    end
  end

  if not is_zoomed or pane_count < 2 then
    return nil
  end

  return string.format("⛶ +%d", pane_count - 1)
end

local function tab_panes_with_info(wezterm, tab_info, fallback_panes)
  if tab_info.panes and #tab_info.panes > 0 then
    return tab_info.panes
  end

  if wezterm.mux and wezterm.mux.get_tab and tab_info.tab_id then
    local ok_tab, mux_tab = pcall(wezterm.mux.get_tab, tab_info.tab_id)
    if ok_tab and mux_tab and mux_tab.panes_with_info then
      local ok_panes, mux_panes = pcall(function()
        return mux_tab:panes_with_info()
      end)
      if ok_panes and mux_panes and #mux_panes > 0 then
        return mux_panes
      end
    end
  end

  return fallback_panes or {}
end

local function zoom_badge_text(wezterm, tab_info, fallback_panes)
  return M.zoom_badge_from_panes(tab_panes_with_info(wezterm, tab_info, fallback_panes))
end

local function tab_palette(tab_info, hover)
  local bar_bg = "#232733"
  local tab_bg = "#313548"
  local tab_fg = "#e2e9ff"
  local badge_bg = "#9cafeb"
  local badge_fg = "#1d2028"
  local zoom_bg = "#f7768e"
  local zoom_fg = "#1d2028"

  if tab_info.is_active then
    tab_fg = "#e2e9ff"
    badge_bg = "#edb07d"
    badge_fg = "#1d2028"
  elseif hover then
    badge_bg = "#9cafeb"
    badge_fg = "#1d2028"
  end

  return {
    bar_bg = bar_bg,
    tab_bg = tab_bg,
    tab_fg = tab_fg,
    badge_bg = badge_bg,
    badge_fg = badge_fg,
    zoom_bg = zoom_bg,
    zoom_fg = zoom_fg,
  }
end

function M.register(wezterm)
  wezterm.on("format-tab-title", function(tab, tabs, panes, _, hover, max_width)
    tabs = tabs or { tab }
    local colors = tab_palette(tab, hover)

    local index = tostring(tab.tab_index + 1)
    local title = M.tab_title(tab)
    local zoom_label = zoom_badge_text(wezterm, tab, panes)
    local reserved_width = 4 + #index
    if zoom_label then
      reserved_width = reserved_width + label_width(wezterm, zoom_label) + 2
    end
    title = wezterm.truncate_right(title, math.max(4, max_width - reserved_width))

    local cells = {
      { Background = { Color = colors.tab_bg } },
      { Foreground = { Color = colors.tab_fg } },
      { Text = " " .. title .. " " },
    }

    if zoom_label then
      table.insert(cells, { Background = { Color = colors.zoom_bg } })
      table.insert(cells, { Foreground = { Color = colors.zoom_fg } })
      table.insert(cells, { Text = " " .. zoom_label .. " " })
    end

    table.insert(cells, { Background = { Color = colors.badge_bg } })
    table.insert(cells, { Foreground = { Color = colors.badge_fg } })
    table.insert(cells, { Text = " " .. index .. " " })

    return cells
  end)

  wezterm.on("update-status", function(window, _)
    local tab = window:active_tab()
    if not tab or not tab.panes_with_info then
      window:set_right_status("")
      return
    end

    local ok, panes = pcall(function()
      return tab:panes_with_info()
    end)
    if not ok then
      window:set_right_status("")
      return
    end

    local zoom_label = M.zoom_badge_from_panes(panes)
    if not zoom_label then
      window:set_right_status("")
      return
    end

    window:set_right_status(wezterm.format({
      { Background = { Color = "#f7768e" } },
      { Foreground = { Color = "#1d2028" } },
      { Text = " " .. zoom_label .. " " },
    }))
  end)
end

return M
