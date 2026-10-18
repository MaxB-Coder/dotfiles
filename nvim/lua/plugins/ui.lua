return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local p = require("palette")
      require("lualine").setup({
        options = {
          theme = {
            normal = {
              a = { fg = p.bar, bg = p.accent, bold = true },
              b = { fg = p.fg, bg = p.bg1 },
              c = { fg = p.fg4, bg = p.bar },
            },
            insert = {
              a = { fg = p.bar, bg = p.yellow_dim, bold = true },
            },
            visual = {
              a = { fg = p.bar, bg = p.purple, bold = true },
            },
            replace = {
              a = { fg = p.bar, bg = p.red, bold = true },
            },
            inactive = {
              c = { fg = p.muted, bg = p.bar },
            },
          },
          -- Rounded ends to match the prompt pills
          section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
          component_separators = { left = "", right = "" },
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
