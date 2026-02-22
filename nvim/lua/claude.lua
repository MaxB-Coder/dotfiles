local M = {}

M.colors = {
  bg          = "#2a2a2a",    -- matches Starship terminal bg
  bg_dark     = "#222222",
  bg_light    = "#333333",
  cursor_line = "#333333",
  fg          = "#e0e0e0",
  fg_dim      = "#A8A8A8",    -- exact Starship grey
  comment     = "#6b6b6b",
  orange      = "#E07B39",
  purple      = "#9B7EC8",
  amber       = "#C8A97E",    -- exact Starship amber
  red         = "#CC4A32",    -- exact Starship error red
  green       = "#7DAF75",
  selection   = "#2f2f2f",
  border      = "#3a3a3a",
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
  hl(0, "@type",               { fg = "#9B7EC8", bold = true })
  hl(0, "@type.builtin",       { fg = "#9B7EC8" })
  hl(0, "@constructor",        { fg = "#9B7EC8" })
  hl(0, "@parameter",          { fg = c.fg })
  hl(0, "@variable",           { fg = c.fg })
  hl(0, "@variable.builtin",   { fg = c.orange })
  hl(0, "@constant",           { fg = c.orange })
  hl(0, "@constant.builtin",   { fg = c.orange })
  hl(0, "@property",           { fg = c.fg_dim })
  hl(0, "@field",              { fg = c.fg_dim })
  hl(0, "@number",             { fg = "#9B7EC8" })
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

  -- Telescope
  hl(0, "TelescopeBorder",         { fg = c.border })
  hl(0, "TelescopeNormal",         { fg = c.fg, bg = c.bg_dark })
  hl(0, "TelescopeSelection",      { fg = c.fg, bg = c.selection })
  hl(0, "TelescopeSelectionCaret", { fg = c.orange })
  hl(0, "TelescopeMatching",       { fg = c.orange, bold = true })

  -- NvimTree
  hl(0, "NvimTreeNormal",      { fg = c.fg, bg = c.bg_dark })
  hl(0, "NvimTreeFolderName",  { fg = c.orange })
  hl(0, "NvimTreeOpenedFolderName", { fg = c.orange, bold = true })
  hl(0, "NvimTreeRootFolder",  { fg = c.amber })
  hl(0, "NvimTreeGitDirty",    { fg = c.orange })
  hl(0, "NvimTreeGitNew",      { fg = c.green })
end

return M
