-- GitHub Copilot
return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Accept suggestion with Tab
    vim.g.copilot_no_tab_map = true
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot suggestion",
    })

    -- Navigate suggestions
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
    vim.keymap.set("i", "<C-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
    vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
  end,
}
