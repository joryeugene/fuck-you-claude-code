-- Quick file navigation bookmarks
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
    vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Menu" })

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: File 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: File 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: File 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: File 4" })

    -- Navigation shortcuts
    vim.keymap.set("n", "[h", function() harpoon:list():prev() end, { desc = "Harpoon: Previous file" })
    vim.keymap.set("n", "]h", function() harpoon:list():next() end, { desc = "Harpoon: Next file" })
    vim.keymap.set("n", "<leader>hh", function() harpoon:list():select(1) end, { desc = "Harpoon: Quick switch" })
  end,
}
