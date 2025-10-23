-- mini.lua - Mini.nvim modules for minimal config
-- Dashboard with CALMHIVE header

return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Statusline
      require('mini.statusline').setup({
        use_icons = true,
        set_vim_settings = false,
      })

      -- Dashboard / Starter screen
      local starter = require('mini.starter')
      starter.setup({
        items = {
          starter.sections.recent_files(5, false, false),
          starter.sections.recent_files(5, true, false),
          -- CalmHive shortcuts
          { name = 'Daily Journal', action = 'lua vim.cmd("edit /Users/jory/Documents/calmhive/daily/" .. os.date("%Y") .. "/" .. os.date("%Y-%m-%d") .. ".md")', section = 'CalmHive' },
          { name = 'HOME Dashboard', action = 'edit /Users/jory/Documents/calmhive/000-HOME.md', section = 'CalmHive' },
          { name = 'ACTIVE Projects', action = 'edit /Users/jory/Documents/calmhive/1-active/ACTIVE-INDEX.md', section = 'CalmHive' },
          { name = 'INBOX', action = 'edit /Users/jory/Documents/calmhive/0-inbox/INBOX-INDEX.md', section = 'CalmHive' },
          -- Quick actions
          starter.sections.telescope(),
          { name = 'LazyGit', action = 'LazyGit', section = 'Actions' },
          { name = 'Database', action = 'DBUIToggle', section = 'Actions' },
          { name = 'REST Client', action = 'lua require("kulala").scratchpad()', section = 'Actions' },
          { name = 'File Explorer', action = 'Yazi', section = 'Actions' },
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning('center', 'center'),
        },
        header = [[
   ██████╗ █████╗ ██╗     ███╗   ███╗██╗  ██╗██╗██╗   ██╗███████╗
  ██╔════╝██╔══██╗██║     ████╗ ████║██║  ██║██║██║   ██║██╔════╝
  ██║     ███████║██║     ██╔████╔██║███████║██║██║   ██║█████╗
  ██║     ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗ ██╔╝██╔══╝
  ╚██████╗██║  ██║███████╗██║ ╚═╝ ██║██║  ██║██║ ╚████╔╝ ███████╗
   ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚══════╝
        ]],
        footer = '\n🐝 type to filter | <CR> to select | <C-c> to quit',
      })

      -- Keymap for mini.starter
      vim.keymap.set('n', '<leader>0', '<cmd>lua MiniStarter.open()<cr>', { desc = 'Dashboard' })

      -- Surround
      require('mini.surround').setup()

      -- Pairs (auto-close brackets)
      require('mini.pairs').setup()

      -- Comment
      require('mini.comment').setup({
        options = {
          ignore_blank_line = false,
        },
        mappings = {
          comment = '<leader>/',
          comment_line = '<leader>/',
          comment_visual = '<leader>/',
        },
      })

      -- Indentscope
      require('mini.indentscope').setup({
        symbol = "│",
        options = { try_as_border = true },
      })

      -- Buffer remove
      require('mini.bufremove').setup()

      -- Jump2d (quick navigation)
      require('mini.jump2d').setup({
        mappings = {
          start_jumping = '<leader>j',
        },
      })
    end,
  },
}
