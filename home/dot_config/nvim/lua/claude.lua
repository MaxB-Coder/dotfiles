local M = {}

-- Colours come from the shared palette (~/.config/wezterm/palette.lua), so the
-- editor matches the terminal exactly
local p = require("palette")

M.colors = {
  bg          = p.bg,
  bg_dark     = p.bar,
  bg_light    = p.bg1,
  cursor_line = p.bg_soft,
  fg          = p.fg,
  fg_dim      = p.fg4,
  comment     = p.muted,
  orange      = p.accent,
  purple      = p.purple,
  amber       = p.yellow_dim,
  red         = p.red,
  green       = p.green,
  selection   = p.bg2,
  border      = p.bg1,
}

function M.setup()
  local c = M.colors
  local hl = vim.api.nvim_set_hl

  vim.opt.termguicolors = true
  vim.g.colors_name = "claude"
  vim.cmd.highlight("clear")
 
  -- Dashboard
  hl(0, "DashboardHeader", { fg = c.orange, bold = true })
  hl(0, "DashboardFooter", { fg = c.comment, italic = true })

  -- Editor
  hl(0, "Normal",          { fg = c.fg, bg = c.bg })
  hl(0, "NormalFloat",     { fg = c.fg, bg = c.bg_dark })
  hl(0, "CursorLine",      { bg = c.cursor_line })
  hl(0, "CursorLineNr",    { fg = c.orange, bold = true })
  hl(0, "LineNr",          { fg = c.comment })
  hl(0, "SignColumn",      { bg = c.bg })
  hl(0, "ColorColumn",     { bg = c.bg_light })
  hl(0, "Visual",          { bg = c.selection })
  hl(0, "Search",          { fg = c.bg, bg = c.orange })
  hl(0, "IncSearch",       { fg = c.bg, bg = c.amber })
  hl(0, "MatchParen",      { fg = c.orange, bold = true })
  hl(0, "Pmenu",           { fg = c.fg, bg = c.bg_dark })
  hl(0, "PmenuSel",        { fg = c.bg, bg = c.orange })
  hl(0, "PmenuSbar",       { bg = c.bg_light })
  hl(0, "PmenuThumb",      { bg = c.border })
  hl(0, "StatusLine",      { fg = c.fg, bg = c.bg_dark })
  hl(0, "StatusLineNC",    { fg = c.comment, bg = c.bg_dark })
  hl(0, "VertSplit",       { fg = c.border })
  hl(0, "WinSeparator",    { fg = c.border })
  hl(0, "EndOfBuffer",     { fg = c.bg })
  hl(0, "Folded",          { fg = c.comment, bg = c.bg_light })

  -- Syntax
  hl(0, "Comment",         { fg = c.comment, italic = true })
  hl(0, "String",          { fg = c.amber })
  hl(0, "Number",          { fg = c.amber })
  hl(0, "Float",           { fg = c.amber })
  hl(0, "Boolean",         { fg = c.orange })
  hl(0, "Keyword",         { fg = c.orange, bold = true })
  hl(0, "Conditional",     { fg = c.orange, bold = true })
  hl(0, "Repeat",          { fg = c.orange, bold = true })
  hl(0, "Function",        { fg = c.amber })
  hl(0, "Identifier",      { fg = c.fg })
  hl(0, "Type",            { fg = c.amber })
  hl(0, "Constant",        { fg = c.orange })
  hl(0, "Statement",       { fg = c.orange })
  hl(0, "Operator",        { fg = c.fg_dim })
  hl(0, "Delimiter",       { fg = c.fg_dim })
  hl(0, "Special",         { fg = c.orange })
  hl(0, "PreProc",         { fg = c.amber })
  hl(0, "Todo",            { fg = c.bg, bg = c.orange, bold = true })
  hl(0, "Error",           { fg = c.red, bold = true })
  hl(0, "WarningMsg",      { fg = c.orange })
  hl(0, "ErrorMsg",        { fg = c.red })

-- Treesitter
  hl(0, "@keyword",            { fg = c.orange, bold = true })
  hl(0, "@keyword.function",   { fg = c.orange, bold = true })
  hl(0, "@keyword.return",     { fg = c.orange, bold = true })
  hl(0, "@string",             { fg = c.green })
  hl(0, "@string.escape",      { fg = c.amber })
  hl(0, "@function",           { fg = c.amber, bold = true })
  hl(0, "@function.call",      { fg = c.amber })
  hl(0, "@method",             { fg = c.amber })
  hl(0, "@method.call",        { fg = c.amber })
  hl(0, "@type",               { fg = c.purple, bold = true })
  hl(0, "@type.builtin",       { fg = c.purple })
  hl(0, "@constructor",        { fg = c.purple })
  hl(0, "@parameter",          { fg = c.fg })
  hl(0, "@variable",           { fg = c.fg })
  hl(0, "@variable.builtin",   { fg = c.orange })
  hl(0, "@constant",           { fg = c.orange })
  hl(0, "@constant.builtin",   { fg = c.orange })
  hl(0, "@property",           { fg = c.fg_dim })
  hl(0, "@field",              { fg = c.fg_dim })
  hl(0, "@number",             { fg = c.purple })
  hl(0, "@boolean",            { fg = c.orange, bold = true })
  hl(0, "@comment",            { fg = c.comment, italic = true })
  hl(0, "@tag",                { fg = c.orange })
  hl(0, "@tag.attribute",      { fg = c.amber })
  hl(0, "@punctuation",        { fg = c.fg_dim })
  hl(0, "@operator",           { fg = c.fg_dim })

  -- LSP
  hl(0, "DiagnosticError",       { fg = c.red })
  hl(0, "DiagnosticWarn",        { fg = c.orange })
  hl(0, "DiagnosticInfo",        { fg = c.fg_dim })
  hl(0, "DiagnosticHint",        { fg = c.comment })
  hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = c.orange })

  -- Git (gitsigns)
  hl(0, "GitSignsAdd",     { fg = c.green })
  hl(0, "GitSignsChange",  { fg = c.orange })
  hl(0, "GitSignsDelete",  { fg = c.red })

  -- Floating windows (picker, completion menu, docs, notifications)
  hl(0, "FloatBorder",     { fg = c.border, bg = c.bg_dark })
  hl(0, "FloatTitle",      { fg = c.orange, bg = c.bg_dark, bold = true })

  -- snacks.nvim (dashboard, picker, notifier)
  hl(0, "SnacksDashboardHeader", { link = "DashboardHeader" })
  hl(0, "SnacksDashboardFooter", { link = "DashboardFooter" })
  hl(0, "SnacksDashboardKey",    { fg = c.orange, bold = true })
  hl(0, "SnacksDashboardIcon",   { fg = c.orange })
  hl(0, "SnacksDashboardDesc",   { fg = c.fg })
  hl(0, "SnacksPickerMatch",     { fg = c.orange, bold = true })
  hl(0, "SnacksPickerPrompt",    { fg = c.orange })
  hl(0, "SnacksPickerListCursorLine", { bg = c.selection })

  -- blink.cmp (completion menu)
  hl(0, "BlinkCmpMenu",          { fg = c.fg, bg = c.bg_dark })
  hl(0, "BlinkCmpMenuBorder",    { link = "FloatBorder" })
  hl(0, "BlinkCmpMenuSelection", { fg = c.bg, bg = c.orange })
  hl(0, "BlinkCmpDocBorder",     { link = "FloatBorder" })
  hl(0, "BlinkCmpLabelMatch",    { fg = c.orange, bold = true })

  -- NvimTree
  hl(0, "NvimTreeNormal",      { fg = c.fg, bg = c.bg_dark })
  hl(0, "NvimTreeFolderName",  { fg = c.orange })
  hl(0, "NvimTreeOpenedFolderName", { fg = c.orange, bold = true })
  hl(0, "NvimTreeRootFolder",  { fg = c.amber })
  hl(0, "NvimTreeGitDirty",    { fg = c.orange })
  hl(0, "NvimTreeGitNew",      { fg = c.green })
end

return M
