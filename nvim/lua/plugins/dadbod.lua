-- dadbod.lua - Database client configuration

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plpgsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Database UI settings
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40

      -- Default query execution
      vim.g.db_ui_execute_on_save = 0

      -- Icons
      vim.g.db_ui_icons = {
        expanded = {
          db = "▾ ",
          buffers = "▾ ",
          saved_queries = "▾ ",
          schemas = "▾ ",
          schema = "▾ פּ",
          tables = "▾ 藺",
          table = "▾ ",
        },
        collapsed = {
          db = "▸ ",
          buffers = "▸ ",
          saved_queries = "▸ ",
          schemas = "▸ ",
          schema = "▸ פּ",
          tables = "▸ 藺",
          table = "▸ ",
        },
        saved_query = "",
        new_query = "璘",
        tables = "離",
        buffers = "﬘",
        add_connection = "",
        connection_ok = "✓",
        connection_error = "✕",
      }

      -- Keymaps
      vim.keymap.set("n", "<leader>ldb", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })
      vim.keymap.set("n", "<leader>ldf", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })
      vim.keymap.set("n", "<leader>ldr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Rename DB buffer" })
      vim.keymap.set("n", "<leader>ldq", "<cmd>DBUILastQueryInfo<cr>", { desc = "Last query info" })
    end,
    config = function()
      -- SQL file autocmd for keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plpgsql" },
        callback = function()
          -- Execute query under cursor or selection
          vim.keymap.set("n", "<leader>lr", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute query" })
          vim.keymap.set("v", "<leader>lr", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute selection" })

          -- Save query
          vim.keymap.set("n", "<leader>ls", "<Plug>(DBUI_SaveQuery)", { buffer = true, desc = "Save query" })

          -- Completion from dadbod
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          })
        end,
      })
    end,
  },
}
