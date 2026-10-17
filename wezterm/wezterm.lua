local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local nf = wezterm.nerdfonts

local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac = wezterm.target_triple:find("darwin") ~= nil

-- Palette: Gruvbox Dark, plus the orange from the app icon as accent
local palette = {
  bar = "#1d2021", -- bg0_h, a step darker than the terminal
  bg = "#282828", -- bg0, terminal background
  bg1 = "#3c3836",
  bg2 = "#504945",
  muted = "#928374",
  fg_dim = "#bdae93",
  fg = "#ebdbb2",
  accent = "#e07b39",
}

-- Appearance
config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0
config.adjust_window_size_when_changing_font_size = false
config.max_fps = 120

config.colors = {
  cursor_bg = palette.accent,
  cursor_border = palette.accent,
  cursor_fg = palette.bg,
  split = palette.bg1,
  tab_bar = {
    background = palette.bar,
    -- Active tab shares the terminal background so it flows into the pane
    active_tab = { bg_color = palette.bg, fg_color = palette.fg, intensity = "Bold" },
    inactive_tab = { bg_color = palette.bar, fg_color = palette.muted },
    inactive_tab_hover = { bg_color = palette.bg1, fg_color = palette.fg_dim },
    inactive_tab_edge = palette.bg1,
    new_tab = { bg_color = palette.bar, fg_color = palette.muted },
    new_tab_hover = { bg_color = palette.bg1, fg_color = palette.fg },
  },
}

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.inactive_pane_hsb = { saturation = 0.85, brightness = 0.7 }

config.command_palette_bg_color = palette.bar
config.command_palette_fg_color = palette.fg
config.command_palette_font_size = 14.0

-- Window (pt, so padding looks the same on Retina and 100% scale screens)
config.window_padding = {
  left = "14pt",
  right = "14pt",
  top = "10pt",
  bottom = "8pt",
}

-- Window decorations: window buttons sit inside the tab bar, no title bar
if is_windows then
  config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
  config.integrated_title_button_style = "Windows"
  config.integrated_title_button_alignment = "Right"
  config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
else
  config.window_decorations = "INTEGRATED_BUTTONS | RESIZE | MACOS_FORCE_ENABLE_SHADOW"
  config.integrated_title_button_style = "MacOsNative"
end

config.initial_cols = 220
config.initial_rows = 50

-- Close the window or quit straight away, no "really close?" prompt
config.window_close_confirmation = "NeverPrompt"

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false -- the bar holds the window buttons
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
config.window_frame = {
  font = wezterm.font({ family = "JetBrains Mono", weight = "DemiBold" }),
  font_size = 12.0,
  active_titlebar_bg = palette.bar,
  inactive_titlebar_bg = palette.bar,
  active_titlebar_fg = palette.fg,
  inactive_titlebar_fg = palette.muted,
  active_titlebar_border_bottom = palette.bar,
  inactive_titlebar_border_bottom = palette.bar,
  button_fg = palette.fg_dim,
  button_bg = palette.bar,
  button_hover_fg = palette.fg,
  button_hover_bg = palette.bg1,
}

-- Performance
config.send_composed_key_when_left_alt_is_pressed = true
config.use_ime = false

-- Shell (OS aware)
if is_windows then
  config.default_prog = { "wsl.exe", "--distribution", "Ubuntu" }
else
  config.default_prog = { "/bin/zsh", "-l" }
end

-- Scrollback
config.scrollback_lines = 10000

-- Tab titles: process icon + folder (in a shell) or program name, centred
local TAB_WIDTH = 24

local shells = {
  zsh = true, bash = true, fish = true, sh = true, nu = true,
  pwsh = true, powershell = true, cmd = true,
}

local process_icons = {
  nvim = nf.custom_neovim,
  vim = nf.custom_vim,
  git = nf.dev_git,
  lazygit = nf.dev_git,
  node = nf.dev_nodejs_small,
  bun = nf.dev_nodejs_small,
  python = nf.dev_python,
  python3 = nf.dev_python,
  cargo = nf.dev_rust,
  go = nf.seti_go,
  docker = nf.linux_docker,
  ssh = nf.md_ssh,
  lua = nf.md_language_lua,
}

local function basename(path)
  path = (path or ""):gsub("[/\\]+$", "")
  return path:match("([^/\\]+)$") or path
end

local function cwd_label(pane)
  local cwd = pane.current_working_dir
  if not cwd then
    return nil
  end
  local path = type(cwd) == "userdata" and cwd.file_path or tostring(cwd):gsub("^file://[^/]*", "")
  if path:gsub("/$", "") == wezterm.home_dir then
    return "~"
  end
  return basename(path)
end

local function tab_label(tab)
  local pane = tab.active_pane
  local process = basename(pane.foreground_process_name):gsub("%.exe$", "")
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title, process
  end
  -- WSL hides the real process; the shell title is the best signal
  if process == "wsl" or process == "wslhost" then
    return pane.title, process
  end
  if process == "" or shells[process] then
    return cwd_label(pane) or pane.title, process
  end
  return process, process
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local label, process = tab_label(tab)
  local icon = process_icons[process] or nf.dev_terminal

  label = wezterm.truncate_right(label, TAB_WIDTH - 6)
  local content_width = wezterm.column_width(icon .. "  " .. label)
  local left = math.max(0, math.floor((TAB_WIDTH - content_width) / 2))
  local right = math.max(0, TAB_WIDTH - content_width - left)

  local icon_color = palette.muted
  local label_color = palette.muted
  if tab.is_active then
    icon_color, label_color = palette.accent, palette.fg
  elseif hover then
    icon_color, label_color = palette.fg_dim, palette.fg_dim
  end

  return {
    { Text = string.rep(" ", left) },
    { Foreground = { Color = icon_color } },
    { Text = icon .. "  " },
    { Foreground = { Color = label_color } },
    { Text = label },
    { Text = string.rep(" ", right) },
  }
end)

-- Gap between the macOS window buttons and the first tab
wezterm.on("update-status", function(window, pane)
  local gap = is_mac and "  " or ""
  window:set_left_status(wezterm.format({ { Background = { Color = palette.bar } }, { Text = gap } }))
end)

-- Rename the current tab; an empty name goes back to the automatic title
local rename_tab = act.PromptInputLine({
  description = wezterm.format({
    { Foreground = { Color = palette.accent } },
    { Text = "Rename tab" },
    { Foreground = { Color = palette.muted } },
    { Text = "  (leave empty for automatic name)" },
  }),
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
})

wezterm.on("augment-command-palette", function(window, pane)
  return {
    { brief = "Rename tab", icon = "md_rename_box", action = rename_tab },
  }
end)

-- Key bindings: CMD on macOS, CTRL+SHIFT on Windows (Win+key belongs to the OS)
local mod = is_windows and "CTRL|SHIFT" or "CMD"
local rename_mods = is_windows and "CTRL|SHIFT" or "CMD|SHIFT"

config.keys = {
  -- Tabs
  { key = "t", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "r", mods = rename_mods, action = rename_tab },
  { key = "w", mods = mod, action = act.CloseCurrentTab({ confirm = false }) },
  { key = "1", mods = mod, action = act.ActivateTab(0) },
  { key = "2", mods = mod, action = act.ActivateTab(1) },
  { key = "3", mods = mod, action = act.ActivateTab(2) },
}

-- Window management (macOS only: hide and quit are native app actions)
if is_mac then
  table.insert(config.keys, { key = "m", mods = "CMD", action = act.HideApplication })
  table.insert(config.keys, { key = "q", mods = "CMD", action = act.QuitApplication })
  table.insert(config.keys, { key = "Return", mods = "CMD", action = act.ToggleFullScreen })
end

return config
