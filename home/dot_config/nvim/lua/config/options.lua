local opt = vim.opt

-- Line numbers
opt.number = true           -- show line numbers
opt.relativenumber = true   -- show relative line numbers (great for jumping between lines)

-- Tabs and indentation
opt.tabstop = 2             -- number of spaces a tab counts for
opt.shiftwidth = 2          -- number of spaces for each indentation level
opt.expandtab = true        -- convert tabs to spaces
opt.smartindent = true      -- auto indent new lines intelligently

-- Appearance
opt.termguicolors = true    -- enable full colour support in terminal
opt.signcolumn = "yes"      -- always show the sign column (prevents layout shifting)
opt.cursorline = true       -- highlight the line your cursor is on

-- Behaviour
opt.wrap = false            -- don't wrap long lines
opt.mouse = "a"             -- enable mouse support
opt.clipboard = "unnamedplus" -- use system clipboard
opt.ignorecase = true       -- case insensitive search
opt.smartcase = true        -- unless you type a capital letter
opt.splitright = true       -- new vertical splits open on the right
opt.splitbelow = true       -- new horizontal splits open below

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Tell lua_ls about the vim global
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- Clipboard: on macOS Neovim uses pbcopy/pbpaste by itself. Over SSH and in
-- WSL there's no local clipboard tool, so copy through the terminal with
-- OSC 52. WezTerm doesn't answer OSC 52 paste requests, so pasting uses
-- Neovim's last yank instead of waiting for a reply that never comes
-- (Cmd/Ctrl+V still pastes from the system clipboard)
if vim.env.SSH_TTY or vim.fn.has("mac") == 0 then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "» ", nbsp = "␣" }

-- Syntax colour overrides
local function my_highlights()
  vim.api.nvim_set_hl(0, "@tag", { fg = "#E07B39" })
  vim.api.nvim_set_hl(0, "@string", { fg = "#A3A9CE" })
  vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#A8A8A8" })
end

my_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = my_highlights })
