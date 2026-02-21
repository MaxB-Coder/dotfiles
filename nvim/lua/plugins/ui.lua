return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = {
            normal = {
              a = { fg = "#1a1a1a", bg = "#E07B39", bold = true },
              b = { fg = "#e0e0e0", bg = "#2a2a2a" },
              c = { fg = "#A8A8A8", bg = "#1a1a1a" },
            },
            insert = {
              a = { fg = "#1a1a1a", bg = "#C8A97E", bold = true },
            },
            visual = {
              a = { fg = "#1a1a1a", bg = "#C8A97E", bold = true },
            },
            replace = {
              a = { fg = "#1a1a1a", bg = "#CC4A32", bold = true },
            },
            inactive = {
              c = { fg = "#6b6b6b", bg = "#1a1a1a" },
            },
          },
        },
      })
    end,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
}
