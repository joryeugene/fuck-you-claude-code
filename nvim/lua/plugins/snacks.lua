-- snacks.nvim - Minimal config to prevent UI conflicts
-- Only enable terminal/window features needed by claudecode.nvim

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Disable all UI components (we use mini.nvim for these)
    statusline = { enabled = false },
    dashboard = { enabled = false },
    notifier = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    scroll = { enabled = false },

    -- Keep terminal/window features (needed by claudecode.nvim)
    terminal = { enabled = true },
    win = { enabled = true },
  },
}
