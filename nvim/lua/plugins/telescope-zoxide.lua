-- Telescope Zoxide integration - frequent directory jumping
return {
  "jvgrootveld/telescope-zoxide",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local telescope = require("telescope")
    telescope.load_extension("zoxide")

    -- Keymap for zoxide (cd = change directory)
    vim.keymap.set("n", "<leader>cd", "<cmd>Telescope zoxide list<CR>", { desc = "Zoxide: Jump to directory" })
  end,
}
