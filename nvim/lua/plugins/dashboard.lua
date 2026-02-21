return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

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

      math.randomseed(os.time())
      local quote = quotes[math.random(#quotes)]

      dashboard.section.header.val = {
        "                                                      ",
        "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
        "                                                      ",
      }

      dashboard.section.header.opts = {
        hl = "DashboardHeader",
        position = "center",
      }

      -- Quote as its own section
      local quote_section = {
        type = "text",
        val = quote,
        opts = {
          hl = "DashboardFooter",
          position = "center",
        },
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file",    ":Telescope find_files<cr>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<cr>"),
        dashboard.button("g", "  Search text",  ":Telescope live_grep<cr>"),
        dashboard.button("e", "  New file",     ":enew<cr>"),
        dashboard.button("q", "  Quit",         ":qa<cr>"),
      }

      -- Empty footer
      dashboard.section.footer.val = ""

      dashboard.config.layout = {
        { type = "padding", val = 8 },
        dashboard.section.header,
        { type = "padding", val = 1 },
        quote_section,
        { type = "padding", val = 3 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)
    end,
  },
}
