return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local hooks = require("ibl.hooks")
    local clay = { "ClayDeep", "ClayAmber", "ClayTaupe", "ClayCopper", "ClaySand" }
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "ClayDeep",   { fg = "#5E3A28" })
      vim.api.nvim_set_hl(0, "ClayAmber",  { fg = "#7A5A2E" })
      vim.api.nvim_set_hl(0, "ClayTaupe",  { fg = "#4A3A32" })
      vim.api.nvim_set_hl(0, "ClayCopper", { fg = "#6E4A2E" })
      vim.api.nvim_set_hl(0, "ClaySand",   { fg = "#8A6B3A" })
      vim.api.nvim_set_hl(0, "Whitespace", { fg = "#C4602A" })
    end)
    require("ibl").setup({
      indent = { char = "▏", highlight = clay },
      scope = { enabled = false },
    })
  end,
}
