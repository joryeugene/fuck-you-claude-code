-- Catppuccin colorscheme
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        telescope = true,
        mini = true,
        markdown = true,
        gitsigns = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    })

    -- Set colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
