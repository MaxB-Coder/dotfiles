return {
  -- Mason: installs language servers
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Bridges mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "bashls",
          "cssls",
          "html",
          "jdtls",      -- Java
          "gopls",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = vim.keymap.set
          map("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to definition" })
          map("n", "gr", vim.lsp.buf.references, { buffer = event.buf, desc = "Find references" })
          map("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover documentation" })
          map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code actions" })
          map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename symbol" })
        end,
      })

      -- All servers except jdtls (it needs special handling)
      local servers = {
        lua_ls = {},
        ts_ls = {},
        pyright = {},
        bashls = {},
        cssls = {},
        html = { filetypes = { "html", "templ", "htmldjango" } },
        gopls = {},
      }
      for server, opts in pairs(servers) do
        opts.capabilities = capabilities
        vim.lsp.config(server, opts)
        -- Only start servers that are installed (Mason can't build gopls
        -- until Go is installed, for example)
        local cmd = vim.lsp.config[server].cmd
        if type(cmd) ~= "table" or vim.fn.executable(cmd[1]) == 1 then
          vim.lsp.enable(server)
        end
      end
    end,
  },

  -- Java specific LSP (jdtls needs its own plugin for proper setup)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",    -- only load when opening a java file
    config = function()
      local jdtls = require("jdtls")
      local home = os.getenv("HOME")

      jdtls.start_or_attach({
        cmd = {
          "jdtls",
        },
        root_dir = vim.fs.dirname(vim.fs.find({
          "gradlew", "mvnw", ".git", "pom.xml", "build.gradle"
        }, { upward = true })[1]),
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = {
          java = {
            format = { enabled = true },
            completion = { enabled = true },
          },
        },
      })
    end,
  },

  -- Completion: blink.cmp (faster than nvim-cmp, one plugin instead of five).
  -- Same keys as before: Tab / S-Tab move, Enter accepts, C-Space opens,
  -- C-e closes
  {
    "saghen/blink.cmp",
    version = "1.*", -- release builds ship a prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        menu = { border = "rounded" },
        documentation = { auto_show = true, auto_show_delay_ms = 250, window = { border = "rounded" } },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- Formatting: conform.nvim formats on save with the tools below (installed
  -- by Mason). <leader>cf formats by hand, :FormatToggle turns saving off/on
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo", "FormatToggle" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format file",
      },
    },
    config = function()
      local prettier = { "prettier" }
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format" },
          javascript = prettier,
          typescript = prettier,
          javascriptreact = prettier,
          typescriptreact = prettier,
          json = prettier,
          yaml = prettier,
          markdown = prettier,
          css = prettier,
          html = prettier,
          sh = { "shfmt" },
          bash = { "shfmt" },
          go = { "gofmt" },
        },
        -- Only the formatters above run on save (no surprise LSP reformat)
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 1000, lsp_format = "never" }
        end,
        notify_no_formatters = false,
      })
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
      end, { desc = "Turn format on save off or on" })
    end,
  },

  -- Installs the formatters conform uses (gofmt comes with Go via mise)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = { "stylua", "prettier", "ruff", "shfmt" },
      run_on_start = true,
    },
  },
}
