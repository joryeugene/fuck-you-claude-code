-- core.lua - Core settings shared between Neovim and VSCode

local opt = vim.opt

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- UI
opt.number = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false
opt.cmdheight = 0 -- Hide command line when not in use (shows in floating window)

-- Modern UI enhancements
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 0 -- Window transparency (keep 0 for readability)
opt.fillchars = {
  eob = " ", -- Hide ~ on empty lines
  diff = "╱", -- Diagonal for diff
  vert = "│", -- Vertical separator
  fold = " ", -- Space for fold lines
  foldopen = "▾", -- Down triangle (U+25BE)
  foldclose = "▸", -- Right triangle (U+25B8)
  foldsep = "│", -- Vertical separator for folds
}
opt.conceallevel = 2 -- Better concealing for markdown
opt.concealcursor = "" -- Don't conceal on cursor line
opt.smoothscroll = true -- Smooth scrolling (Neovim 0.10+)
opt.shortmess:append("IWcsC") -- Less intrusive messages (C = no 'command' messages)

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Better editing experience
opt.virtualedit = "block" -- Cursor can go anywhere in visual block mode
opt.wildmode = "longest:full,full" -- Better command-line completion
opt.wildoptions = "pum" -- Show completion in popup menu
opt.formatoptions:remove("cro") -- Don't auto-continue comments on newline

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.lazyredraw = false
opt.redrawtime = 10000 -- Increase for large files with syntax highlighting

-- Disable unused providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Fold
opt.foldmethod = "manual"
opt.foldenable = false

-- Better wrapping for prose (markdown)
opt.linebreak = true -- Break on word boundaries
opt.breakindent = true -- Preserve indentation in wrapped lines
opt.showbreak = "↪ " -- Show indicator for wrapped lines

-- Session and diff options
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.diffopt:append("linematch:60") -- Better diff highlighting (Neovim 0.9+)
