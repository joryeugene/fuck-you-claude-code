-- marks.nvim - Enhanced mark visualization and management
-- Complements harpoon with more comprehensive mark features

return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  config = function()
    require("marks").setup({
      -- Custom mappings - use <leader>m* namespace
      default_mappings = false,

      -- Show builtin marks
      builtin_marks = { ".", "<", ">", "^" },

      -- Cycle through marks
      cyclic = true,

      -- Update shada for uppercase marks
      force_write_shada = false,

      -- Refresh interval (ms) - balance between performance and visual lag
      refresh_interval = 250,

      -- Sign priorities
      sign_priority = {
        lower = 10,
        upper = 15,
        builtin = 8,
        bookmark = 20,
      },

      -- Exclude certain filetypes
      excluded_filetypes = {
        "neo-tree",
        "Avante",
        "AvanteInput",
        "qf",
      },

      -- Bookmark groups with custom signs
      bookmark_0 = {
        sign = "⚑",
        virt_text = "",
        annotate = false,
      },
      bookmark_1 = {
        sign = "⚐",
        virt_text = "",
      },
      bookmark_2 = {
        sign = "☰",
        virt_text = "",
      },
      bookmark_3 = {
        sign = "✓",
        virt_text = "",
      },

      mappings = {
        -- Basic mark operations
        set = "<leader>ms",           -- Set mark (will prompt for letter)
        set_next = "<leader>m,",      -- Set next available lowercase mark
        toggle = "<leader>m;",        -- Toggle next available mark
        delete = "<leader>md",        -- Delete mark (will prompt)
        delete_line = "<leader>m-",   -- Delete all marks on line
        delete_buf = "<leader>mD",    -- Delete all marks in buffer

        -- Navigation
        next = "<leader>mn",          -- Next mark
        prev = "<leader>mp",          -- Previous mark
        preview = "<leader>mv",       -- Preview mark (v for view)

        -- Bookmarks (groups 0-3 configured above)
        set_bookmark0 = "<leader>m0",
        set_bookmark1 = "<leader>m1",
        set_bookmark2 = "<leader>m2",
        set_bookmark3 = "<leader>m3",
        delete_bookmark0 = "<leader>md0",
        delete_bookmark1 = "<leader>md1",
        delete_bookmark2 = "<leader>md2",
        delete_bookmark3 = "<leader>md3",
        delete_bookmark = "<leader>mx",  -- Delete bookmark under cursor
        next_bookmark = "<leader>m]",    -- Next bookmark of same type
        prev_bookmark = "<leader>m[",    -- Prev bookmark of same type
        annotate = "<leader>ma",         -- Annotate bookmark
      },
    })

    -- Additional useful keymaps for mark lists
    vim.keymap.set("n", "<leader>ml", "<cmd>MarksListBuf<cr>", { desc = "List marks (buffer)" })
    vim.keymap.set("n", "<leader>mL", "<cmd>MarksListAll<cr>", { desc = "List marks (all)" })
    vim.keymap.set("n", "<leader>mb", "<cmd>BookmarksListAll<cr>", { desc = "List bookmarks (all)" })
    vim.keymap.set("n", "<leader>mt", "<cmd>MarksToggleSigns<cr>", { desc = "Toggle mark signs" })
  end,
}
