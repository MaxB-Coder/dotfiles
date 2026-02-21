local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

-- Window
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- Window decorations
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.window_decorations = "TITLE | RESIZE"
else
  config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"
  config.integrated_title_buttons = { "Close", "Hide", "Maximize" }
end

config.initial_cols = 220
config.initial_rows = 50

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
config.window_frame = {
  font_size = 14.0,
}

-- Performance
config.send_composed_key_when_left_alt_is_pressed = false
config.use_ime = false

-- Shell
config.default_prog = { "/bin/zsh", "-l" }

-- Scrollback
config.scrollback_lines = 10000

-- Custom tab title with centred padding
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  local width = 24
  local padded = string.rep(" ", math.floor((width - #title) / 2)) .. title .. string.rep(" ", math.ceil((width - #title) / 2))
  return {
    { Text = padded },
  }
end)

-- Key bindings
local act = wezterm.action

config.keys = {
  -- Window management
  { key = "m", mods = "CMD", action = act.HideApplication },
  { key = "q", mods = "CMD", action = act.QuitApplication },
  { key = "Return", mods = "CMD", action = act.ToggleFullScreen },

  -- Tabs
  { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "1", mods = "CMD", action = act.ActivateTab(0) },
  { key = "2", mods = "CMD", action = act.ActivateTab(1) },
  { key = "3", mods = "CMD", action = act.ActivateTab(2) },
}

return config
