-- lspconfig.lua - LSP configuration

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      -- Note: Deprecation warning expected until nvim-lspconfig v3.0.0
      -- The plugin itself uses deprecated API, will be fixed in future release
      -- Suppress both vim.notify and vim.deprecate
      local notify_orig = vim.notify
      local deprecate_orig = vim.deprecate

      vim.notify = function(msg, level, opts)
        if msg and msg:match("lspconfig") then
          return
        end
        notify_orig(msg, level, opts)
      end

      vim.deprecate = function(name, alternative, version, plugin, backtrace)
        if name and name:match("lspconfig") then
          return
        end
        return deprecate_orig(name, alternative, version, plugin, backtrace)
      end

      local lspconfig = require("lspconfig")
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- LSP keymaps (attached to buffers when LSP starts)
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        opts.desc = "Show LSP references"
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end

      -- Configure language servers
      local servers = {
        "ts_ls",      -- TypeScript
        "lua_ls",     -- Lua
        "pyright",    -- Python
        "html",       -- HTML
        "cssls",      -- CSS
        "tailwindcss", -- Tailwind
        "jsonls",     -- JSON
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end

      -- Lua specific settings
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })

      -- Restore original notify and deprecate after all lspconfig calls
      vim.notify = notify_orig
      vim.deprecate = deprecate_orig
    end,
  },
}
