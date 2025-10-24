-- markdown-toggle.lua - Comprehensive markdown editing tools
-- Provides checkbox toggling, list cycling, heading management, and more

return {
  "roodolv/markdown-toggle.nvim",
  ft = "markdown",
  config = function()
    require("markdown-toggle").setup({
      -- Use Treesitter for better parsing
      use_treesitter = true,

      -- Checkbox settings
      checkbox = {
        -- Checkbox states to cycle through
        states = { " ", "x", "-" },
        -- Custom icons per state (optional, render-markdown handles display)
        icons = {
          [" "] = "[ ]",
          ["x"] = "[x]",
          ["-"] = "[-]",
        },
      },

      -- List settings
      list = {
        -- Unordered list markers to cycle through
        unordered_markers = { "-", "*", "+" },
        -- Whether to cycle ordered lists
        cycle_ordered = true,
      },

      -- Heading settings
      heading = {
        -- Cycle through heading levels 1-6
        min_level = 1,
        max_level = 6,
      },

      -- Auto-continue lists/checkboxes on <CR>
      auto_continue = {
        enabled = true,
        -- Continue bullets
        bullet = true,
        -- Continue numbered lists
        ordered = true,
        -- Continue checkboxes
        checkbox = true,
      },
    })
  end,
  keys = {
    -- Primary toggle command (context-aware)
    { "<leader>nt", "<cmd>MDToggle<cr>", desc = "Toggle markdown element", ft = "markdown" },

    -- Specific toggles
    { "<leader>nc", "<cmd>MDToggleCheckbox<cr>", desc = "Toggle checkbox", ft = "markdown" },
    { "<leader>nl", "<cmd>MDToggleList<cr>", desc = "Toggle list type", ft = "markdown" },
    { "<leader>nh", "<cmd>MDToggleHeading<cr>", desc = "Toggle heading level", ft = "markdown" },
    { "<leader>nq", "<cmd>MDToggleQuote<cr>", desc = "Toggle quote", ft = "markdown" },
  },
}
