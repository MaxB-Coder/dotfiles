return {
  -- Fuzzy finding (files, text, buffers, help) is snacks.picker, see snacks.lua

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
  },

  -- Auto close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Comment toggling is built in since Neovim 0.10: gcc (line), gc (selection)

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup()
    end,
  },
}
