local M = {}

local levels = { { 1.0, 1.0 }, { 0.6, 0.9 }, { 0.3, 0.8 } }

local function apply_level(wezterm, window)
  local index = wezterm.GLOBAL.opacity_step
  local win_op, text_op = levels[index][1], levels[index][2]
  local overrides = window:get_config_overrides() or {}

  overrides.window_background_opacity = win_op
  overrides.text_background_opacity = text_op

  window:set_config_overrides(overrides)
end

function M.register(wezterm)
  wezterm.GLOBAL = wezterm.GLOBAL or {}
  wezterm.GLOBAL.opacity_step = wezterm.GLOBAL.opacity_step or 1

  wezterm.on("cycle-transparency", function(window, _)
    wezterm.GLOBAL.opacity_step = (wezterm.GLOBAL.opacity_step % #levels) + 1
    apply_level(wezterm, window)
  end)

  wezterm.on("toggle-transparency", function(window, _)
    -- Step 1 is opaque; any other step is transparent. Toggle between opaque and
    -- the first transparent level, keeping opacity_step in sync so a following
    -- cycle continues from the visible state.
    wezterm.GLOBAL.opacity_step = wezterm.GLOBAL.opacity_step == 1 and 2 or 1
    apply_level(wezterm, window)
  end)
end

return M
