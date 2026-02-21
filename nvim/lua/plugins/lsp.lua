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
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
      local servers = { "lua_ls", "ts_ls", "pyright", "bashls", "cssls", "html" }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
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
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          java = {
            format = { enabled = true },
            completion = { enabled = true },
          },
        },
      })
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
