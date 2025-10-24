-- mini.lua - Mini.nvim modules for minimal config
-- Dashboard with CALMHIVE header

return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Statusline (minimal)
      local statusline = require('mini.statusline')
      statusline.setup({
        use_icons = true,
        set_vim_settings = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.section_location({ trunc_width = 75 })

            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%<', -- Mark truncation point
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              '%=', -- End left, begin right
              { hl = 'MiniStatuslineFileinfo', strings = { location } },
            })
          end,
        },
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

      -- Clue (which-key alternative)
      require('mini.clue').setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          require('mini.clue').gen_clues.builtin_completion(),
          require('mini.clue').gen_clues.g(),
          require('mini.clue').gen_clues.marks(),
          require('mini.clue').gen_clues.registers(),
          require('mini.clue').gen_clues.windows(),
          require('mini.clue').gen_clues.z(),

          -- Custom leader namespace descriptions
          { mode = 'n', keys = '<Leader>a', desc = '+AI (Avante)' },
          { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
          { mode = 'n', keys = '<Leader>c', desc = '+Compile/Quickfix' },
          { mode = 'n', keys = '<Leader>f', desc = '+Find (Telescope)' },
          { mode = 'n', keys = '<Leader>g', desc = '+Git' },
          { mode = 'n', keys = '<Leader>k', desc = '+Knowledge (CalmHive)' },
          { mode = 'n', keys = '<Leader>l', desc = '+sqL (Database)' },
          { mode = 'n', keys = '<Leader>m', desc = '+Model (Claude Code)' },
          { mode = 'n', keys = '<Leader>n', desc = '+Notes/Markdown' },
          { mode = 'n', keys = '<Leader>p', desc = '+Postman (REST/HTTP)' },
          { mode = 'n', keys = '<Leader>r', desc = '+Refactoring' },
          { mode = 'n', keys = '<Leader>s', desc = '+Splits/Windows' },
          { mode = 'n', keys = '<Leader>t', desc = '+Tabs/Terminal' },
          { mode = 'n', keys = '<Leader>u', desc = '+UI Toggles' },
          { mode = 'n', keys = '<Leader>v', desc = '+Vault/Config' },
          { mode = 'n', keys = '<Leader>z', desc = '+Zen Mode & Preview' },

          -- Visual mode namespaces
          { mode = 'x', keys = '<Leader>a', desc = '+AI (Avante)' },
          { mode = 'x', keys = '<Leader>f', desc = '+Find' },
          { mode = 'x', keys = '<Leader>n', desc = '+Notes/Markdown' },
          { mode = 'x', keys = '<Leader>r', desc = '+Refactoring' },
        },

        window = {
          delay = 300,
          config = {
            width = 'auto',
            border = 'rounded',
          },
        },
      })
    end,
  },
}
