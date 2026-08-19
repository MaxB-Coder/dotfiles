return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "javascript", "typescript",
          "java", "python", "bash", "json",
          "yaml", "markdown", "html", "css",
          "htmldjango", "go", "gomod", "gosum", "gotmpl",
          "sql", "toml", "dockerfile",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
