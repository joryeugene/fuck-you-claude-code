-- Zen Mode - Distraction-free writing for markdown
return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      -- Main toggle (120 cols, balanced)
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode (toggle)" },

      -- Presets by width
      {
        "<leader>zn",
        function()
          require("zen-mode").toggle({
            window = { width = 80 },
            plugins = { twilight = { enabled = true } },
          })
        end,
        desc = "Zen: Narrow (80 cols)",
      },

      {
        "<leader>zw",
        function()
          require("zen-mode").toggle({ window = { width = 140 } })
        end,
        desc = "Zen: Wide (140 cols)",
      },

      {
        "<leader>zf",
        function()
          require("zen-mode").toggle({ window = { width = 1.0 } })
        end,
        desc = "Zen: Full screen",
      },

      -- Presets by purpose
      {
        "<leader>zm",
        function()
          require("zen-mode").toggle({
            window = {
              width = 90,
              options = {
                number = false,
                relativenumber = false,
                signcolumn = "no",
                foldcolumn = "0",
                list = false,
              },
            },
            plugins = { twilight = { enabled = true } },
          })
        end,
        desc = "Zen: Markdown (ultra-clean)",
      },

      {
        "<leader>zc",
        function()
          require("zen-mode").toggle({
            window = {
              width = 120,
              options = {
                number = true,
                relativenumber = true,
                signcolumn = "yes",
              },
            },
            plugins = { gitsigns = { enabled = true } },
          })
        end,
        desc = "Zen: Coding (with numbers)",
      },

      -- Twilight toggle
      { "<leader>zt", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
    },
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {
      dimming = {
        alpha = 0.25,
        inactive = true,
      },
      context = 10,
    },
  },
}
