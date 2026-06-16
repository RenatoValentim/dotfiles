local M = {}

-- Records the currently focused WezTerm pane id to a state file. The Claude
-- Code notification hook reads it and suppresses alerts when the session's pane
-- is already in the foreground.
local function state_path()
  local runtime = os.getenv("XDG_RUNTIME_DIR") or "/tmp"
  return runtime .. "/wezterm-focused-pane"
end

local function write_state(value)
  local f = io.open(state_path(), "w")
  if f then
    f:write(tostring(value))
    f:close()
  end
end

function M.register(wezterm)
  -- Keep the focused pane id current. update-status also fires on pane/tab
  -- switches, so the id stays correct without an OS focus change. Only the
  -- focused window writes, so background windows never clobber the value.
  wezterm.on("update-status", function(window, pane)
    if window:is_focused() then
      write_state(pane:pane_id())
    end
  end)

  -- OS focus gain/loss. On loss write -1 so the hook still notifies when the
  -- active pane is unchanged (e.g. user alt-tabbed to another application).
  wezterm.on("window-focus-changed", function(window, pane)
    if window:is_focused() then
      write_state(pane:pane_id())
    else
      write_state(-1)
    end
  end)
end

return M
