local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "Catppuccin Mocha"   -- matches your Neovim theme
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

-- Window
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
config.window_decorations = "RESIZE"        -- clean borderless look
config.initial_cols = 220
config.initial_rows = 50

-- Tab bar
config.use_fancy_tab_bar = false            -- simpler, cleaner tab bar
config.tab_bar_at_bottom = true

-- Shell
config.default_prog = { "/bin/zsh", "-l" } -- use zsh as default shell

-- Scrollback
config.scrollback_lines = 10000

return config
