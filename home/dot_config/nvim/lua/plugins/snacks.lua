-- snacks.nvim: start screen, fuzzy picker, notifications and input boxes.
-- Replaces alpha-nvim (dashboard) and Telescope; the <leader>f keys are the same
local quotes = {
  "It works on my machine.",
  "// TODO: fix this later (2019)",
  "There are only 2 hard problems in CS: cache invalidation and naming things.",
  "git commit -m 'final fix (for real this time)'",
  "Stack Overflow is just fancy documentation.",
  "The best code is no code at all.",
  "Works? Ship it.",
  "undefined is not a function.",
  "Have you tried turning it off and on again?",
  "rm -rf and pray.",
  "It's not a bug, it's an undocumented feature.",
  "console.log('here') console.log('here2')",
}

local header = table.concat({
  "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}, "\n")

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = header,
          keys = {
            { icon = "\u{f15b} ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
            { icon = "\u{f017} ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
            { icon = "\u{f002} ", key = "g", desc = "Search text", action = ":lua Snacks.picker.grep()" },
            { icon = "\u{f067} ", key = "e", desc = "New file", action = ":ene | startinsert" },
            { icon = "\u{f1e6} ", key = "l", desc = "Plugins", action = ":Lazy" },
            { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header", padding = 1 },
          function()
            math.randomseed(os.time())
            return { text = { quotes[math.random(#quotes)], hl = "DashboardFooter" }, align = "center", padding = 2 }
          end,
          { section = "keys", gap = 1, padding = 2 },
          { section = "startup" },
        },
      },
      picker = { enabled = true },
      notifier = { enabled = true, style = "compact" },
      input = { enabled = true },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Search in files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    },
  },
}
