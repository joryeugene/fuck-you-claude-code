-- drop.nvim - Screensaver with falling characters

return {
  "folke/drop.nvim",
  event = "VeryLazy",
  opts = {
    theme = "matrix",
    max = 250, -- maximum number of drops on the screen
    interval = 100, -- milliseconds between drops
    screensaver = 60 * 5 * 1000,
    filetypes = {}, -- list of filetypes to enable drops (empty = all)
  },
  config = function(_, opts)
    require("drop").setup(opts)

    -- Manual commands
    vim.api.nvim_create_user_command("DropEnable", function()
      require("drop").setup(opts)
    end, { desc = "Enable drop.nvim screensaver" })

    vim.api.nvim_create_user_command("DropDisable", function()
      require("drop").setup({ screensaver = false })
    end, { desc = "Disable drop.nvim screensaver" })
  end,
}
