local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac = wezterm.target_triple:find("darwin") ~= nil

-- Shared palette (also used by Neovim), kept next to this file
local palette_file = wezterm.config_dir .. "/palette.lua"
local palette = dofile(palette_file)
wezterm.add_to_config_reload_watch_list(palette_file)

-- Appearance
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13.0
config.line_height = 1.0 -- slim prompt pills; the tab bar height is separate

-- Smaller text inside the prompt pills. Starship marks pill text with the
-- blink attribute (nothing else uses it); blinking is switched off and blink
-- text is drawn at 85% so it sits inside the pill with room around it
config.text_blink_rate = 0
config.text_blink_rate_rapid = 0
config.font_rules = {
  {
    blink = "Slow",
    font = wezterm.font_with_fallback({ { family = "JetBrains Mono", weight = "Bold", scale = 0.85 } }),
  },
}
config.adjust_window_size_when_changing_font_size = false
config.max_fps = 120

config.colors = {
  foreground = palette.fg,
  background = palette.bg,
  ansi = palette.ansi,
  brights = palette.brights,
  selection_fg = palette.fg,
  selection_bg = palette.bg3,
  scrollbar_thumb = palette.bg2,
  compose_cursor = palette.yellow,
  cursor_bg = palette.accent,
  cursor_border = palette.accent,
  cursor_fg = palette.bg,
  split = palette.bg1,
  tab_bar = {
    background = palette.bar,
    -- Active tab shares the terminal background so it flows into the pane
    active_tab = { bg_color = palette.bg, fg_color = palette.muted },
    inactive_tab = { bg_color = palette.bar, fg_color = palette.muted },
    inactive_tab_hover = { bg_color = palette.bg1, fg_color = palette.fg_dim },
    inactive_tab_edge = palette.bg1,
    new_tab = { bg_color = palette.bar, fg_color = palette.muted },
    new_tab_hover = { bg_color = palette.bg1, fg_color = palette.fg },
  },
}

-- Underline, not bar: a bar spans the full line and touches the prompt pill
config.default_cursor_style = "BlinkingUnderline"
config.cursor_thickness = "2pt"
config.cursor_blink_rate = 600
config.inactive_pane_hsb = { saturation = 0.85, brightness = 0.7 }

config.command_palette_bg_color = palette.bar
config.command_palette_fg_color = palette.fg
config.command_palette_font_size = 13.0

-- A touch of translucency with a blurred backdrop (macOS blur, Windows 11
-- acrylic). Set the opacity to 1.0 for a solid window
config.window_background_opacity = 0.97
config.macos_window_background_blur = 30
if is_windows then
  config.win32_system_backdrop = "Acrylic"
end

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
-- Fancy bar: its height follows window_frame.font_size, not the terminal
-- font, so the macOS window buttons get room whatever line_height is
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false -- the bar holds the window buttons
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
-- Options from the patched WezTerm build (github.com/MaxB-Coder/wezterm fork,
-- see FORK.md there): tabs fill the bar to the top edge, the close X shows
-- only on the hovered tab, and the macOS traffic lights sit centred in the bar.
-- Stock WezTerm (e.g. on Windows) rejects options it doesn't know, so each one
-- is only set when the running build accepts it
local function set_if_supported(key, value)
  pcall(function()
    config[key] = value
  end)
end
set_if_supported("tab_bar_tabs_fill_height", true)
set_if_supported("show_close_tab_button_on_hover", true)
set_if_supported("macos_center_title_buttons_in_tab_bar", true)

config.window_frame = {
  font = wezterm.font({ family = "JetBrains Mono", weight = "DemiBold" }),
  font_size = 11.0,
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

-- Tab titles: folder (in a shell) or program name, centred
local TAB_WIDTH = 24

local shells = {
  zsh = true, bash = true, fish = true, sh = true, nu = true,
  pwsh = true, powershell = true, cmd = true,
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
    return tab.tab_title
  end
  -- WSL hides the real process; the shell title is the best signal
  if process == "wsl" or process == "wslhost" then
    return pane.title
  end
  if process == "" or shells[process] then
    return cwd_label(pane) or pane.title
  end
  return process
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local label = wezterm.truncate_right(tab_label(tab), TAB_WIDTH - 4)
  local width = wezterm.column_width(label)
  local left = math.max(0, math.floor((TAB_WIDTH - width) / 2))
  local right = math.max(0, TAB_WIDTH - width - left)

  local color = palette.muted
  if tab.is_active then
    color = palette.fg
  elseif hover then
    color = palette.fg_dim
  end

  -- The close X takes the colour of the first title cell, so the leading
  -- padding is muted and only the label gets the bright colour
  return {
    { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
    { Foreground = { Color = palette.muted } },
    { Text = string.rep(" ", left) },
    { Foreground = { Color = color } },
    { Text = label .. string.rep(" ", right) },
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
local split_down_mods = is_windows and "CTRL|SHIFT|ALT" or "CMD|SHIFT"

config.keys = {
  -- Tabs
  { key = "t", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "r", mods = rename_mods, action = rename_tab },
  { key = "1", mods = mod, action = act.ActivateTab(0) },
  { key = "2", mods = mod, action = act.ActivateTab(1) },
  { key = "3", mods = mod, action = act.ActivateTab(2) },

  -- Panes: split right / down; close closes the pane (and the tab with its
  -- last pane). Moving between panes: CMD+OPT+arrows on macOS, and WezTerm's
  -- default CTRL+SHIFT+arrows everywhere
  { key = "d", mods = mod, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = split_down_mods, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = mod, action = act.CloseCurrentPane({ confirm = false }) },
}

-- Window management (macOS only: hide and quit are native app actions)
if is_mac then
  table.insert(config.keys, { key = "m", mods = "CMD", action = act.HideApplication })
  table.insert(config.keys, { key = "q", mods = "CMD", action = act.QuitApplication })
  table.insert(config.keys, { key = "Return", mods = "CMD", action = act.ToggleFullScreen })
  table.insert(config.keys, { key = "Return", mods = "CMD|SHIFT", action = act.TogglePaneZoomState })
  for key, direction in pairs({ LeftArrow = "Left", RightArrow = "Right", UpArrow = "Up", DownArrow = "Down" }) do
    table.insert(config.keys, { key = key, mods = "CMD|OPT", action = act.ActivatePaneDirection(direction) })
    table.insert(config.keys, { key = key, mods = "CMD|CTRL", action = act.AdjustPaneSize({ direction, 3 }) })
  end
end

return config
