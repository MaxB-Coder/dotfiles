-- One palette for the whole setup: Gruvbox dark plus the orange from the app
-- icon. WezTerm and Neovim both load this file. Starship (starship.toml) and
-- zsh (plugins.zsh, exports.zsh) can't load Lua, so they repeat these hex
-- values by hand; change them there too.
--
-- Plain Lua, no requires, so any Lua host can dofile() it. It lives next to
-- wezterm.lua because WezTerm on Windows needs it in the same folder.
local palette = {
  bar = "#1d2021", -- bg0_h: tab bar, sidebars, floating windows
  bg = "#282828", -- bg0: terminal and editor background
  bg_soft = "#32302f", -- bg0_s: cursor line
  bg1 = "#3c3836", -- raised surfaces, borders, dark prompt pill
  bg2 = "#504945", -- visual selection
  bg3 = "#665c54", -- terminal selection, autosuggestions
  muted = "#928374", -- comments, inactive text
  fg4 = "#a89984", -- punctuation, secondary text
  fg_dim = "#bdae93",
  fg2 = "#d5c4a1",
  fg = "#ebdbb2",
  accent = "#e07b39", -- the app icon orange

  red = "#fb4934",
  green = "#b8bb26",
  yellow = "#fabd2f",
  yellow_dim = "#d79921",
  blue = "#83a598",
  purple = "#d3869b",
  aqua = "#8ec07c",
}

-- The 16 terminal colours (same as WezTerm's built-in "Gruvbox Dark (Gogh)")
palette.ansi = { "#282828", "#cc241d", "#98971a", "#d79921", "#458588", "#b16286", "#689d6a", "#a89984" }
palette.brights = { "#928374", "#fb4934", "#b8bb26", "#fabd2f", "#83a598", "#d3869b", "#8ec07c", "#ebdbb2" }

return palette
