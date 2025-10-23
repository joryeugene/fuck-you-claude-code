-- Keymaps module - organized keymap configurations
-- Extracted and reconstructed from runtime introspection

local M = {}

-- Helper function to set keymaps with consistent options
local function set_keymap(mode_or_lhs, lhs_or_rhs, rhs_or_desc, desc_or_opts)
  local mode, lhs, rhs, opts

  -- Handle both old and new API styles
  if type(mode_or_lhs) == "table" then
    -- New style: array of modes
    mode = mode_or_lhs
    lhs = lhs_or_rhs
    rhs = rhs_or_desc
    opts = desc_or_opts or {}
  else
    mode = mode_or_lhs
    lhs = lhs_or_rhs
    rhs = rhs_or_desc
    opts = desc_or_opts or {}
  end

  -- Ensure opts is a table
  if type(opts) == "string" then
    opts = { desc = opts }
  end

  -- Set default options
  opts = vim.tbl_extend("force", {
    noremap = true,
    silent = true,
  }, opts)

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Custom command for smart buffer deletion
local function smart_buffer_close()
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  local current_buf = vim.api.nvim_get_current_buf()

  if vim.api.nvim_buf_get_name(0):match("neo%-tree") or vim.bo.filetype == "neo-tree" then
    vim.cmd("enew")
  else
    if #buffers > 1 then
      for _, buf in ipairs(buffers) do
        if buf ~= current_buf then
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win, buf)
          break
        end
      end
    else
      vim.cmd("quit")
    end
  end

  if vim.api.nvim_buf_is_valid(current_buf) and vim.bo[current_buf].buflisted then
    vim.cmd("bd " .. current_buf)
  end
end

vim.api.nvim_create_user_command("BDelete", smart_buffer_close, {})
vim.cmd("cabbrev bd BDelete")
vim.cmd("cabbrev BD BDelete")
vim.cmd("command! BDeleteForce :bd!")
vim.cmd("cabbrev bdf BDeleteForce")
vim.cmd("cabbrev BDF BDeleteForce")

-- Setup general keymaps (Lines 46-90)
function M.setup_general_keymaps()
  local leader = vim.g.mapleader or " "
  local localleader = vim.g.maplocalleader or ","

  -- Edit and reload config
  set_keymap("n", "<leader>ve", ":edit $MYVIMRC<CR>", "Edit Neovim Config")
  set_keymap("n", "<leader>vs", ":source $MYVIMRC<CR>", "Reload Neovim Config")

  -- Window navigation
  set_keymap("n", "<C-h>", "<C-w>h", "Move to left window")
  set_keymap("n", "<C-j>", "<C-w>j", "Move to window below")
  set_keymap("n", "<C-k>", "<C-w>k", "Move to window above")
  set_keymap("n", "<C-l>", "<C-w>l", "Move to right window")

  -- Window resizing
  set_keymap("n", "<C-Up>", ":resize -2<CR>", "Resize window up")
  set_keymap("n", "<C-Down>", ":resize +2<CR>", "Resize window down")
  set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", "Resize window left")
  set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", "Resize window right")

  -- Diagnostic window navigation
  set_keymap("n", "<C-W>d", vim.diagnostic.open_float, "Show diagnostics under the cursor")
  set_keymap("n", "<C-W><C-D>", vim.diagnostic.open_float, "Show diagnostics under the cursor")

  -- File operations
  set_keymap("n", "<leader>w", ":w<CR>", "Save")
  set_keymap("n", "<leader>W", ":wa<CR>", "Save all")
  set_keymap("n", "<leader>Q", ":qa<CR>", "Quit all")
  set_keymap("n", "<leader>q", smart_buffer_close, "Close current buffer")
  set_keymap("n", "<leader>x", function()
    vim.cmd("w")
    smart_buffer_close()
  end, "Save and close buffer")

  -- UI toggles
  set_keymap("n", "<leader>un", function()
    vim.opt.number = not vim.opt.number:get()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
  end, "Toggle line numbers")
  set_keymap("n", "<leader>us", ":setlocal spell!<CR>", "Toggle spell check")
  set_keymap("n", "<leader>uw", function()
    vim.opt.wrap = not vim.opt.wrap:get()
  end, "Toggle word wrap")
  set_keymap("n", "<leader>hl", ":nohlsearch<CR>", "Clear search highlights")
end

-- Better movement (Lines 92-146)
set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Move down (including wrapped lines)", expr = true })
set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Move up (including wrapped lines)", expr = true })

-- Setup navigation keymaps (Lines 148-195)
function M.setup_navigation_keymaps()
  -- Quickfix list
  set_keymap("n", "<leader>co", ":copen<CR>", "Open quickfix list")
  set_keymap("n", "<leader>cc", ":cclose<CR>", "Close quickfix list")
  set_keymap("n", "<leader>cn", ":cnext<CR>", "Next quickfix item")
  set_keymap("n", "<leader>cp", ":cprev<CR>", "Previous quickfix item")

  -- Splits
  set_keymap("n", "<leader>sv", ":vsplit<CR>", "Split window vertically")
  set_keymap("n", "<leader>sh", ":split<CR>", "Split window horizontally")
  set_keymap("n", "<leader>sc", ":close<CR>", "Close current window/split")

  -- Jump list
  set_keymap("n", "<leader>zo", "<C-o>", "Jump back")
  set_keymap("n", "<leader>zi", "<C-i>", "Jump forward")

  -- Buffer management
  set_keymap("n", "<C-[>", ":bprevious<CR>", "Previous buffer")
  set_keymap("n", "<C-]>", ":bnext<CR>", "Next buffer")
  set_keymap("n", "<leader>o", ":Telescope buffers<CR>", "Open buffer picker")
  set_keymap("n", "<leader>nf", ":enew<CR>", "New empty buffer")
  set_keymap("n", "<leader>bn", "<leader>o", "Next buffer")
  set_keymap("n", "<leader>bp", "<leader>o", "Previous buffer")
  set_keymap("n", "<leader>bd", smart_buffer_close, "Delete buffer (smart)")
  set_keymap("n", "<leader>bD", ":bd!<CR>", "Force delete buffer")
  set_keymap("n", "<leader>ba", "<leader>nf", "New buffer")
  set_keymap("n", "<leader>bl", ":buffers<CR>", "List buffers")

  -- Tabs
  set_keymap("n", "<leader>ta", ":tabnew<CR>", "New tab")
  set_keymap("n", "<leader>tc", ":tabclose<CR>", "Close tab")
  set_keymap("n", "<leader>to", ":tabonly<CR>", "Close all other tabs")
  set_keymap("n", "<leader>tn", ":tabnext<CR>", "Next tab")
  set_keymap("n", "<leader>tp", ":tabprevious<CR>", "Previous tab")
end

-- Setup editing keymaps (Lines 197-230)
function M.setup_editing_keymaps()
  -- Move lines
  set_keymap("n", "<A-j>", ":m .+1<CR>==", "Move line down")
  set_keymap("n", "<A-k>", ":m .-2<CR>==", "Move line up")
  set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
  set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

  -- Indentation
  set_keymap("v", "<", "<gv", "Decrease indent")
  set_keymap("v", ">", ">gv", "Increase indent")
  set_keymap("v", "<Tab>", ">gv", "Indent right")
  set_keymap("v", "<S-Tab>", "<gv", "Indent left")

  -- Better paste
  set_keymap("v", "p", '"_dP', "Paste without yanking selection")

  -- Comments
  local ok, mini_comment = pcall(require, "mini.comment")
  if ok then
    set_keymap("n", "<leader>/", function()
      mini_comment.toggle_lines(vim.fn.line("."), vim.fn.line("."))
    end, "Toggle comment")
    set_keymap("v", "<leader>/", function()
      mini_comment.toggle_lines(vim.fn.line("v"), vim.fn.line("."))
    end, "Toggle comment (visual)")
  end

  -- Duplicate
  set_keymap("n", "<leader>d", ":t.<CR>", "Duplicate line")
  set_keymap("v", "<leader>d", ":t'><CR>gv", "Duplicate selection")

  -- Format
  set_keymap("n", "<leader>fm", ":Format<CR>", "Format buffer")

  -- Search and replace
  set_keymap("n", "<leader>sr", ":%s/<C-r><C-w>//g<Left><Left>", "Search and replace word under cursor")
end

-- Setup terminal keymaps (Lines 232-255)
function M.setup_terminal_keymaps()
  -- Open terminal
  set_keymap("n", "<leader>Tv", ":vsplit term://zsh<CR>", "Open terminal in vertical split")
  set_keymap("n", "<leader>Th", ":split term://zsh<CR>", "Open terminal in horizontal split")
  set_keymap("n", "<leader>Tt", ":tabnew term://zsh<CR>", "Open terminal in new tab")

  -- Terminal mode navigation
  set_keymap("t", "<Esc>", "<C-\\><C-n>", "Exit terminal mode")
  set_keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", "Navigate to left window from terminal")
  set_keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", "Navigate to window below from terminal")
  set_keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", "Navigate to window above from terminal")
  set_keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", "Navigate to right window from terminal")

  -- ToggleTerm integration (if available)
  local ok = pcall(require, "toggleterm")
  if ok then
    set_keymap("n", "<leader>Tf", ":ToggleTerm direction=float<CR>", "Floating terminal")
    set_keymap("n", "<leader>Ts", ":ToggleTerm size=15 direction=horizontal<CR>", "Horizontal terminal")
    set_keymap("n", "<leader>Tv", ":ToggleTerm size=80 direction=vertical<CR>", "Vertical terminal")
    set_keymap("n", "<leader>Tl", ":ToggleTermSendCurrentLine<CR>", "Send current line to terminal")
  end
end

-- Setup refactoring keymaps (Lines 257-280)
function M.setup_refactoring_keymaps()
  local ok = pcall(require, "refactoring")
  if not ok then
    return
  end

  -- Treesitter refactor
  local ts_ok = pcall(require, "nvim-treesitter-refactor")
  if ts_ok then
    set_keymap("n", "<leader>rh", ":TSHighlightCapturesUnderCursor<CR>", "Show highlight group under cursor")
  end

  -- Refactoring operations
  set_keymap("v", "<leader>re", ":Refactor extract<CR>", "Extract function")
  set_keymap("v", "<leader>rf", ":Refactor extract_to_file<CR>", "Extract to file")
  set_keymap("v", "<leader>rv", ":Refactor extract_var<CR>", "Extract variable")
  set_keymap("v", "<leader>ri", ":Refactor inline_func<CR>", "Inline function")
  set_keymap("v", "<leader>rI", ":Refactor inline_var<CR>", "Inline variable")

  -- Format with conform or null-ls
  local conform_ok = pcall(require, "conform")
  if conform_ok then
    set_keymap("n", "<leader>fm", ":Format<CR>", "Format file")
  else
    local null_ls_ok = pcall(require, "null-ls")
    if null_ls_ok then
      set_keymap("n", "<leader>fm", ":lua vim.lsp.buf.format({async = true})<CR>", "Format file")
    end
  end
end

-- Setup debug keymaps (Lines 282-302)
function M.setup_debug_keymaps()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end

  set_keymap("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint")
  set_keymap("n", "<leader>dB", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", "Set conditional breakpoint")
  set_keymap("n", "<leader>dc", ":lua require('dap').continue()<CR>", "Continue/Start debugging")
  set_keymap("n", "<leader>di", ":lua require('dap').step_into()<CR>", "Step into")
  set_keymap("n", "<leader>do", ":lua require('dap').step_over()<CR>", "Step over")
  set_keymap("n", "<leader>dO", ":lua require('dap').step_out()<CR>", "Step out")
  set_keymap("n", "<leader>dr", ":lua require('dap').repl.open()<CR>", "Open REPL")
  set_keymap("n", "<leader>dl", ":lua require('dap').run_last()<CR>", "Run last debug configuration")
  set_keymap("n", "<leader>dt", ":lua require('dap').terminate()<CR>", "Terminate debug session")
  set_keymap("n", "<leader>dh", ":lua require('dap.ui.widgets').hover()<CR>", "Variables hover")

  local dapui_ok = pcall(require, "dapui")
  if dapui_ok then
    set_keymap("n", "<leader>du", ":lua require('dapui').toggle()<CR>", "Toggle DAP UI")
    set_keymap("n", "<leader>de", ":lua require('dapui').eval()<CR>", "Evaluate expression")
  end
end

-- Setup plugin keymaps (Lines 304-606)
function M.setup_plugin_keymaps()
  -- Telescope
  local telescope_ok = pcall(require, "telescope")
  if telescope_ok then
    set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", "Find files")
    set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", "Find text")
    set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", "Find buffers")
    set_keymap("n", "<leader>fh", ":Telescope help_tags<CR>", "Find help")
    set_keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", "Find recent files")
    set_keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", "Find symbols in file")
    set_keymap("n", "<leader>fc", ":Telescope commands<CR>", "Find commands")
    set_keymap("n", "<leader>fk", ":Telescope keymaps<CR>", "Find keymaps")
  end

  -- CalmHive knowledge base
  set_keymap("n", "<leader>kj", function()
    local script = "/Users/jory/Documents/calmhive/resources/scripts/create-daily-note.sh"
    local output = vim.fn.system(script)
    local lines = vim.split(vim.trim(output), "\n")
    local path = lines[1]
    if vim.fn.filereadable(path) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    else
      vim.notify("Failed to create daily note: " .. output, vim.log.levels.ERROR)
    end
  end, "CalmHive: Open today's journal")

  set_keymap("n", "<leader>kh", ":edit /Users/jory/Documents/calmhive/000-HOME.md<CR>", "CalmHive: Open HOME dashboard")
  set_keymap("n", "<leader>ka", ":edit /Users/jory/Documents/calmhive/1-active/ACTIVE-INDEX.md<CR>", "CalmHive: Open ACTIVE index")
  set_keymap("n", "<leader>ki", ":edit /Users/jory/Documents/calmhive/0-inbox/INBOX-INDEX.md<CR>", "CalmHive: Open INBOX index")

  set_keymap("n", "<leader>kn", function()
    local title = vim.fn.input("Note title: ")
    if title == "" then return end

    local template_path = "/Users/jory/Documents/calmhive/resources/templates/quick-capture-template.md"
    local template_content = vim.fn.readfile(template_path)

    local today = vim.fn.strftime("%Y-%m-%d")
    local content = {}
    for _, line in ipairs(template_content) do
      line = line:gsub("{{title}}", title)
      line = line:gsub("{{date:YYYY%-MM%-DD}}", today)
      table.insert(content, line)
    end

    local filename = title:lower():gsub("[^%w%-]", "-")
    local counter = ""
    local note_path
    repeat
      note_path = "/Users/jory/Documents/calmhive/0-inbox/" .. filename .. counter .. ".md"
      if vim.fn.filereadable(note_path) == 0 then break end
      counter = (counter == "" and 1) or (tonumber(counter) + 1)
    until false

    vim.fn.writefile(content, note_path)
    vim.cmd("edit " .. vim.fn.fnameescape(note_path))
  end, "CalmHive: Quick capture to inbox")

  set_keymap("n", "<leader>ko", ":cd /Users/jory/Documents/calmhive | Telescope find_files<CR>", "CalmHive: Open vault files")
  set_keymap("n", "<leader>ks", ":cd /Users/jory/Documents/calmhive | Telescope live_grep<CR>", "CalmHive: Search vault text")

  set_keymap("n", "<leader>is", function()
    local script = "/Users/jory/Documents/calmhive/resources/scripts/inbox-stats.sh"
    local output = vim.fn.system(script)
    vim.cmd("split")
    vim.cmd("resize 15")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
    vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile")
  end, "CalmHive: Show inbox stats")

  set_keymap("n", "<leader>vs", function()
    local script = "/Users/jory/Documents/calmhive/resources/scripts/vault-stats.sh"
    local output = vim.fn.system(script)
    vim.cmd("split")
    vim.cmd("resize 15")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
    vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile")
  end, "CalmHive: Show vault stats")

  -- Oil file manager
  local oil_ok, oil = pcall(require, "oil")
  if oil_ok then
    -- Toggle Oil sidebar function
    local function toggle_oil_sidebar()
      local oil_winnr = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match("^oil://") then
          oil_winnr = win
          break
        end
      end

      if oil_winnr then
        vim.api.nvim_win_close(oil_winnr, false)
      else
        vim.cmd("vsplit")
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 30")
        oil.open()
      end
    end

    set_keymap("n", "<leader>e", toggle_oil_sidebar, "Toggle Oil sidebar")
    set_keymap("n", "<C-e>", toggle_oil_sidebar, "Toggle Oil sidebar")
    set_keymap("n", "<leader>E", "<CMD>Oil --float<CR>", "Open Oil in float window")
    set_keymap("n", "<leader>fo", "<CMD>Oil<CR>", "Open parent directory in Oil")
    set_keymap("n", "<leader>fv", "<CMD>Oil --float<CR>", "Open parent directory in Oil (float)")
    set_keymap("n", "<leader>fV", "<CMD>vsplit | Oil<CR>", "Open Oil in vertical split")
    set_keymap("n", "<leader>fH", "<CMD>split | Oil<CR>", "Open Oil in horizontal split")

    -- Oil-specific keymaps in FileType autocmd
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.keymap.set("n", "<C-e>", toggle_oil_sidebar, { buffer = true, silent = true, nowait = true, desc = "Toggle Oil sidebar" })
        vim.keymap.set("n", "<C-c>", function()
          vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
        end, { buffer = true, silent = true, nowait = true, desc = "Force close Oil window" })
        vim.keymap.set("n", "q", function()
          vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
        end, { buffer = true, silent = true, nowait = true, desc = "Close Oil window" })

        -- Smart selection in Oil
        vim.keymap.set("n", "<CR>", function()
          local entry = oil.get_cursor_entry()
          if not entry then return end

          local dir = oil.get_current_dir()
          if entry.type == "directory" then
            oil.select()
          else
            local name = entry.name
            local current_win = vim.api.nvim_get_current_win()
            local target_win = nil

            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype ~= "oil" then
                target_win = win
                break
              end
            end

            if not target_win then
              vim.cmd("wincmd v")
              target_win = vim.api.nvim_get_current_win()
            end

            vim.api.nvim_set_current_win(target_win)
            vim.cmd("edit " .. vim.fn.fnameescape(dir .. name))
            vim.api.nvim_win_close(current_win, false)
          end
        end, { buffer = true, desc = "Oil smart selection" })
      end,
    })
  end

  -- Yazi file manager
  set_keymap("n", "<C-E>", function()
    require("yazi").yazi()
  end, "Open yazi file manager")

  -- Git
  local gitsigns_ok = pcall(require, "gitsigns")
  if gitsigns_ok then
    set_keymap("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", "Preview git hunk")
    set_keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>", "Git blame line")
    set_keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset git hunk")
    set_keymap("n", "<leader>gn", ":Gitsigns next_hunk<CR>", "Next git hunk")
    set_keymap("n", "<leader>gp", ":Gitsigns prev_hunk<CR>", "Previous git hunk")
    set_keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage git hunk")
    set_keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", "Undo stage git hunk")
  end

  -- Fugitive (if available)
  local fugitive_ok = pcall(function()
    vim.cmd("command Git")
  end)
  if fugitive_ok then
    set_keymap("n", "<leader>gf", ":Git<CR>", "Git fugitive status")
    set_keymap("n", "<leader>gc", ":Git commit<CR>", "Git commit")
    set_keymap("n", "<leader>gP", ":Git push<CR>", "Git push")
    set_keymap("n", "<leader>gl", ":Git pull<CR>", "Git pull")
  end

  -- Which-key (if available)
  local which_key_ok = pcall(require, "which-key")
  if which_key_ok then
    set_keymap("n", "<leader>k", ":WhichKey<CR>", "Show all keybindings")
  end

  -- Database (dadbod)
  set_keymap("n", "<leader>ld", ":DBUIToggle<CR>", "Toggle Database UI")

  -- LSP signature help
  set_keymap("i", "<C-S>", vim.lsp.buf.signature_help, "LSP signature help")
  set_keymap("v", "<C-S>", vim.lsp.buf.signature_help, "LSP signature help")

  -- Blink.cmp scrolling (if available)
  local blink_ok = pcall(require, "blink.cmp")
  if blink_ok then
    set_keymap("i", "<C-F>", function()
      if require("blink.cmp").is_visible() then
        require("blink.cmp").scroll_documentation_down()
      end
    end, "Scroll info/signature down")
    set_keymap("i", "<C-B>", function()
      if require("blink.cmp").is_visible() then
        require("blink.cmp").scroll_documentation_up()
      end
    end, "Scroll info/signature up")
    set_keymap("i", "<C-Space>", function()
      require("blink.cmp").show({ providers = {"lsp", "path", "snippets", "buffer"} })
    end, "Complete with two-stage")
  end

  -- Preserve default Ctrl-W and Ctrl-U in insert mode
  set_keymap("i", "<C-W>", "<C-W>", ":help i_CTRL-W-default")
  set_keymap("i", "<C-U>", "<C-U>", ":help i_CTRL-U-default")
end

-- Setup Obsidian-style link following (Lines 609-653)
function M.setup_obsidian_links()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local bufpath = vim.fn.expand("%:p")
      if not bufpath:match("^/Users/jory/Documents/calmhive") then
        return
      end

      vim.keymap.set("n", "gf", function()
        local line = vim.api.nvim_get_current_line()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))

        -- Find [[ and ]] around cursor
        local before = line:sub(1, col + 1)
        local after = line:sub(col + 2)

        local link_start = before:reverse():find("%]%]")
        local link_end = after:find("%[%[")

        if not link_start or not link_end then
          vim.cmd("normal! gf")
          return
        end

        link_start = col + 2 - link_start
        link_end = col + 1 + link_end

        local link = line:sub(link_start, link_end)
        local vault = "/Users/jory/Documents/calmhive"
        local search_cmd = string.format('find %s -name "%s.md" 2>/dev/null | head -1', vault, link)
        local found = vim.trim(vim.fn.system(search_cmd))

        if vim.fn.filereadable(found) == 1 then
          vim.cmd("edit " .. vim.fn.fnameescape(found))
        else
          vim.notify("Link not found: [[" .. link .. "]]", vim.log.levels.WARN)
          vim.cmd("normal! gf")
        end
      end, { buffer = true, desc = "Follow Obsidian link" })
    end,
  })
end

-- Main setup function (Lines 655-664)
function M.setup()
  M.setup_general_keymaps()
  M.setup_navigation_keymaps()
  M.setup_editing_keymaps()
  M.setup_terminal_keymaps()
  M.setup_refactoring_keymaps()
  M.setup_debug_keymaps()
  M.setup_plugin_keymaps()
  M.setup_obsidian_links()
end

return M
