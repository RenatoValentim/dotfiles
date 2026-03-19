local M = {}

function M.apply(config, wezterm)
  config.color_scheme = "tokyonight_night" -- tokyonight_night tokyonight_storm tokyonight_moon
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false
  config.show_tab_index_in_tab_bar = false
  config.tab_max_width = 18
  config.status_update_interval = 1000
  config.warn_about_missing_glyphs = false
  config.window_background_opacity = 1.0
  config.text_background_opacity = 1.0
  config.font = wezterm.font("JetBrains Mono Nerd Font", { weight = "Regular", italic = true })
  config.font_size = 11.0
  config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
  config.window_decorations = "RESIZE"
  config.term = "wezterm"
  config.enable_wayland = true
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 3000 }
  config.colors = {
    selection_bg = "#232733",
    selection_fg = "#e2e9ff",
    tab_bar = {
      background = "#232733",
      active_tab = {
        bg_color = "#232733",
        fg_color = "#e2e9ff",
      },
      inactive_tab = {
        bg_color = "#232733",
        fg_color = "#f5dcc0",
      },
      inactive_tab_hover = {
        bg_color = "#232733",
        fg_color = "#ffead2",
      },
      new_tab = {
        bg_color = "#232733",
        fg_color = "#232733",
      },
      new_tab_hover = {
        bg_color = "#232733",
        fg_color = "#232733",
      },
    },
  }

  -- Opcional:
  -- config.macos_window_background_blur = 20        -- macOS blur + opacity  :contentReference[oaicite:6]{index=6}
  -- config.kde_window_background_blur = true        -- KDE Wayland (nightly)  :contentReference[oaicite:7]{index=7}
end

return M
