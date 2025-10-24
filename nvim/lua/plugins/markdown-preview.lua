-- Live Preview - Browser-based preview for Markdown, HTML, AsciiDoc, SVG
return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    "folke/snacks.nvim", -- Integrated picker support
  },
  ft = { "markdown", "html", "asciidoc", "svg" },
  keys = {
    { "<leader>zp", "<cmd>LivePreview pick<cr>", desc = "Live Preview Pick File", ft = { "markdown", "html", "asciidoc", "svg" } },
    { "<leader>zs", "<cmd>LivePreview start<cr>", desc = "Start Live Preview", ft = { "markdown", "html", "asciidoc", "svg" } },
    { "<leader>zx", "<cmd>LivePreview close<cr>", desc = "Stop Live Preview", ft = { "markdown", "html", "asciidoc", "svg" } },
  },
  config = function()
    require("livepreview").setup({
      -- Port for preview server (default: 5500)
      port = 5500,

      -- Auto-open browser on start
      autokill = false,

      -- Sync scrolling between editor and browser
      sync_scroll = true,

      -- Use system default browser
      browser = "default",

      -- Enable for these file types
      dynamic_root = true,
    })
  end,
}
