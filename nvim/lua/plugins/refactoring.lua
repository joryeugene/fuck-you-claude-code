-- refactoring.nvim - The Refactoring library by ThePrimeagen
-- Based on Martin Fowler's "Refactoring" book

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
  config = function()
    require("refactoring").setup({
      -- Prompt for function return/param types (language-specific)
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
      },
      -- Show success messages
      show_success_message = true,
    })

    -- Refactoring operations with Ex command (allows preview!)
    -- Extract operations (visual mode)
    vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract function" })
    vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" })
    vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable" })

    -- Inline operations (normal and visual mode)
    vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Inline variable" })
    vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline function" })

    -- Extract block operations (normal mode)
    vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract block" })
    vim.keymap.set("n", "<leader>rB", ":Refactor extract_block_to_file", { desc = "Extract block to file" })

    -- Select refactor prompt (opens selection menu)
    vim.keymap.set({ "n", "x" }, "<leader>rr", function()
      require("refactoring").select_refactor({ prefer_ex_cmd = true })
    end, { desc = "Select refactor" })

    -- Debug operations
    -- Printf statement insertion
    vim.keymap.set("n", "<leader>rp", function()
      require("refactoring").debug.printf({ below = false })
    end, { desc = "Debug: printf" })

    vim.keymap.set("n", "<leader>rP", function()
      require("refactoring").debug.printf({ below = true })
    end, { desc = "Debug: printf (below)" })

    -- Print var (works in both visual and normal mode)
    vim.keymap.set({ "x", "n" }, "<leader>rv", function()
      require("refactoring").debug.print_var()
    end, { desc = "Debug: print var" })

    -- Cleanup all debug statements
    vim.keymap.set("n", "<leader>rc", function()
      require("refactoring").debug.cleanup({})
    end, { desc = "Debug: cleanup" })
  end,
}
