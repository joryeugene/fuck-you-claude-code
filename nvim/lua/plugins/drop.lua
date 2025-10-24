-- drop.nvim - Screensaver with falling characters
-- Matrix rain, snow, spring, and summer themes

return {
  "folke/drop.nvim",
  event = "VeryLazy",
  opts = {
    theme = "auto", -- "auto" cycles through themes, or pick: "snow", "stars", "xmas", "spring", "summer"
    max = 40, -- maximum number of drops on the screen
    interval = 150, -- milliseconds between drops
    screensaver = 1000 * 60 * 5, -- show after 5 minutes of inactivity (5000ms = 5 min)
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
