-- nvim-minimal.lua - Neovim-specific configuration for minimal setup (2025)

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP border styling (safe require)
local ok, lsp_windows = pcall(require, "lspconfig.ui.windows")
if ok then
  lsp_windows.default_options.border = "rounded"
end

-- Load and setup keymaps module
local keymaps = require("config.modules.keymaps")
keymaps.setup()
