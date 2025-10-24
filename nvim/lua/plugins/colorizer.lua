-- nvim-colorizer.lua - Display colors inline
-- Shows actual colors for hex codes, rgb(), hsl(), etc.

return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- Filetypes to enable colorizer
    "*", -- Highlight all files by default
    css = { css = true }, -- Enable parsing rgb(...) functions in css
    html = { names = false }, -- Disable parsing "names" like Blue
  },
  config = function(_, opts)
    require("colorizer").setup(opts, {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = false, -- "Name" codes like Blue (can be slow)
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      mode = "background", -- Set the display mode: 'foreground', 'background'
    })

    -- Command to toggle colorizer
    vim.api.nvim_create_user_command("ColorizerToggle", function()
      vim.cmd("ColorizerToggle")
    end, { desc = "Toggle colorizer" })
  end,
}
