-- nvim-treesitter "main" branch (the old "master" branch is locked to
-- Neovim 0.11). Needs Neovim 0.12+, tree-sitter-cli and a C compiler;
-- install.sh sets these up
local parsers = {
  "lua", "javascript", "typescript",
  "java", "python", "bash", "json",
  "yaml", "markdown", "markdown_inline", "html", "css",
  "htmldjango", "go", "gomod", "gosum", "gotmpl",
  "sql", "toml", "dockerfile",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false, -- the plugin doesn't support lazy-loading
    config = function()
      -- Installs anything missing in the background; no-op once installed
      require("nvim-treesitter").install(parsers)

      -- Highlighting and indentation for any buffer that has a parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
