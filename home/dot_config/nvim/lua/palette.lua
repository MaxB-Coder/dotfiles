-- The shared palette lives with the WezTerm config (~/.config/wezterm/palette.lua,
-- from home/dot_config/wezterm/ in the dotfiles) so WezTerm and Neovim always
-- use the same colours
return dofile(vim.fn.expand("~/.config/wezterm/palette.lua"))
