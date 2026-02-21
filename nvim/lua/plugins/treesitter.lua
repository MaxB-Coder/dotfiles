return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_install = {
          "lua",
          "javascript",
          "typescript",
          "python",
          "bash",
          "json",
          "yaml",
          "markdown",
          "html",
          "css",
        },
      })
    end,
  },
}
