return {
  "samir-roy/code-bridge.nvim",
  config = function()
    require('code-bridge').setup({
      tmux = {
        -- Minimal tmux config since we're primarily using chat interface
        target_mode = 'window_name',
        window_name = 'claude',
        process_name = 'claude',
        switch_to_target = false, -- Don't switch since we're using chat
        find_node_process = true,  -- Claude Code runs in node.js
      },
      interactive = {
        use_telescope = false,
      },
    })

    -- Chat interface keybindings under <leader>i* namespace
    local opts = { silent = true, noremap = true }

    -- Query with context (normal mode: current file, visual mode: selection)
    vim.keymap.set("n", "<leader>iq", ":CodeBridgeQuery<CR>",
      vim.tbl_extend("force", opts, { desc = "Query Claude with context" }))
    vim.keymap.set("v", "<leader>iq", ":CodeBridgeQuery<CR>",
      vim.tbl_extend("force", opts, { desc = "Query Claude with selection" }))

    -- Chat without context
    vim.keymap.set("n", "<leader>ic", ":CodeBridgeChat<CR>",
      vim.tbl_extend("force", opts, { desc = "Chat with Claude (no context)" }))

    -- Chat window management
    vim.keymap.set("n", "<leader>ih", ":CodeBridgeHide<CR>",
      vim.tbl_extend("force", opts, { desc = "Hide chat window" }))
    vim.keymap.set("n", "<leader>is", ":CodeBridgeShow<CR>",
      vim.tbl_extend("force", opts, { desc = "Show chat window" }))
    vim.keymap.set("n", "<leader>ix", ":CodeBridgeWipe<CR>",
      vim.tbl_extend("force", opts, { desc = "Wipe chat & clear history" }))

    -- Query control
    vim.keymap.set("n", "<leader>ik", ":CodeBridgeCancelQuery<CR>",
      vim.tbl_extend("force", opts, { desc = "Cancel running query" }))
    vim.keymap.set("n", "<leader>ip", ":CodeBridgeResumePrompt<CR>",
      vim.tbl_extend("force", opts, { desc = "Resume hidden prompt" }))

    -- Git diff integration
    vim.keymap.set("n", "<leader>id", ":CodeBridgeTmuxDiff<CR>",
      vim.tbl_extend("force", opts, { desc = "Send git diff to Claude" }))
    vim.keymap.set("n", "<leader>iD", ":CodeBridgeTmuxDiffStaged<CR>",
      vim.tbl_extend("force", opts, { desc = "Send staged diff to Claude" }))
  end,
}
