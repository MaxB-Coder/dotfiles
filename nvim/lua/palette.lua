-- The shared palette lives with the WezTerm config (dotfiles/wezterm/palette.lua)
-- so WezTerm and Neovim always use the same colours. ~/.config/nvim is a link
-- to dotfiles/nvim, so resolve it to find the dotfiles folder
local dotfiles = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config")), ":h")
return dofile(dotfiles .. "/wezterm/palette.lua")
