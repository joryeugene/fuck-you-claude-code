-- avante.lua - AI coding assistant

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    -- Use legacy mode for manual approval of all changes
    mode = "legacy",

    provider = "claude",
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-5-20250929",
        extra_request_body = {
          temperature = 0,
          max_tokens = 64000, -- Maximum for Claude Sonnet 4.5 (not 200k!)
        },
      },
    },

    -- Behavior configuration
    behaviour = {
      auto_suggestions = false,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false, -- Safety: require manual approval
      minimize_diff = true,
      auto_add_current_file = true,
      auto_approve_tool_permissions = false, -- Always require manual approval
      confirmation_ui_style = "inline_buttons",
    },

    -- File selector configuration
    file_selector = {
      provider = "telescope", -- Use telescope for better UX
      filters = {
        "kulala://.*",  -- Kulala UI buffers
        ".*://.*",      -- Any other special protocol buffers
      },
    },

    -- Selection hints
    selection = {
      enabled = true,
      hint_display = "delayed",
    },

    -- Window configuration
    windows = {
      position = "right",
      wrap = true,
      width = 45, -- Increased from default 30% for better readability
      sidebar_header = {
        enabled = true,
        align = "center",
        rounded = true,
      },
      input = {
        prefix = "> ",
        height = 8,
      },
      edit = {
        border = "rounded",
        start_insert = true,
      },
      ask = {
        floating = false,
        start_insert = true,
        border = "rounded",
        focus_on_apply = "ours",
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
