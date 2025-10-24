-- GitHub Copilot - AI-powered code completion
--
-- FIRST TIME SETUP:
-- 1. Open Neovim
-- 2. Run: :Copilot setup
-- 3. Browser will open for GitHub authentication
-- 4. Enter the device code shown
-- 5. Return to Neovim - you're ready!
--
-- USEFUL COMMANDS:
-- :Copilot status    - Check authentication status
-- :Copilot enable    - Enable Copilot suggestions
-- :Copilot disable   - Disable Copilot suggestions
-- :Copilot panel     - Show suggestions panel
-- :Copilot signout   - Sign out of GitHub account

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Disable default Tab mapping (we use custom)
    vim.g.copilot_no_tab_map = true

    -- Accept suggestion with Ctrl+J (Tab is used by other plugins)
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Copilot: Accept suggestion",
    })

    -- Navigate between multiple suggestions
    vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
    vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })

    -- Dismiss current suggestion
    vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })

    -- Show suggestions panel (insert mode)
    vim.keymap.set("i", "<C-P>", "<Plug>(copilot-suggest)", { desc = "Copilot: Request suggestion" })
  end,
}
