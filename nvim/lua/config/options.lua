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
