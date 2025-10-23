-- Better UI for vim.ui.select and vim.ui.input
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
      default_prompt = "Input:",
      border = "rounded",
      relative = "editor",
      prefer_width = 40,
      win_options = {
        winblend = 0,
      },
    },
    select = {
      enabled = true,
      backend = { "telescope", "builtin", "nui" },
      telescope = {
        theme = "dropdown",
      },
      builtin = {
        border = "rounded",
        relative = "editor",
        win_options = {
          winblend = 0,
        },
      },
    },
  },
}
