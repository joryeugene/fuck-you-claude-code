# Neovim Configuration

This is a modular Neovim configuration focused on productivity, AI coding assistance, and efficient workflows.

## Essential Vim Commands and Concepts

### Navigation

- `h`, `j`, `k`, `l`: Basic movement (left, down, up, right)
- `w`, `b`, `e`: Move by word (next word start, previous word start, word end)
- `0`, `$`, `^`: Line navigation (beginning, end, first non-blank)
- `gg`, `G`: Go to first line, last line
- `:{number}`: Go to specific line number
- `Ctrl+o`, `Ctrl+i`: Jump back, jump forward in jump list
- `Ctrl+u`, `Ctrl+d`: Half-page up, half-page down
- `Ctrl+f`, `Ctrl+b`: Full-page down, full-page up
- `%`: Jump to matching bracket
- `*`, `#`: Search for word under cursor (forward, backward)

### Editing

- `i`, `a`: Insert mode (at cursor, after cursor)
- `I`, `A`: Insert at beginning of line, append at end of line
- `o`, `O`: Open new line below, above
- `r`, `R`: Replace one character, enter Replace mode
- `c{motion}`: Change text (e.g., `cw` change word)
- `d{motion}`: Delete text (e.g., `dw` delete word)
- `y{motion}`: Yank (copy) text (e.g., `yy` yank line)
- `p`, `P`: Paste after, before cursor
- `u`, `Ctrl+r`: Undo, redo
- `.`: Repeat last change

### Visual Mode

- `v`: Enter Visual mode (character-wise)
- `V`: Enter Visual Line mode
- `Ctrl+v`: Enter Visual Block mode
- `>`, `<`: Indent, outdent selected text
- `gv`: Re-select last visual selection

### Search and Replace

- `/pattern`, `?pattern`: Search forward, backward
- `n`, `N`: Next, previous search result
- `:%s/old/new/g`: Replace all occurrences in file
- `:%s/old/new/gc`: Replace with confirmation

## Keymapping Reference

### Navigation and Window Management

| Keymap | Action | Context |
|--------|--------|---------|
| `<C-h/j/k/l>` | Navigate between windows | Normal |
| `<C-[>`, `<C-]>` | Previous/next buffer | Normal |
| `<leader>o` | Open buffer picker (Telescope) | Normal |
| `<leader>sv` | Split window vertically | Normal |
| `<leader>sh` | Split window horizontally | Normal |
| `<leader>sc` | Close current window/split | Normal |
| `<leader>e` | Open yazi file explorer | Normal |

### File Operations

| Keymap | Action | Context |
|--------|--------|---------|
| `<leader>w` | Save file | Normal |
| `WW` | Save file (force) | Normal |
| `<leader>q` | Close current buffer | Normal |
| `<leader>x` | Save and close buffer | Normal |
| `QQ` | Quit Neovim (force) | Normal |

### Search and Find (Telescope)

| Keymap | Action | Context |
|--------|--------|---------|
| `<leader>ff` | Find files | Normal |
| `<leader>fg` | Live grep | Normal |
| `<leader>fb` | Find buffers | Normal |
| `<leader>fh` | Search help tags | Normal |
| `<leader>fr` | Find recent files | Normal |
| `<leader>fc` | Find commands | Normal |
| `<leader>fk` | Find keymaps | Normal |
| `<C-p>` | Find commands (alt) | Normal |

### Code and LSP

| Keymap | Action | Context |
|--------|--------|---------|
| `<leader>/` | Toggle comment | Normal/Visual |
| `gD` | Go to declaration | Normal |
| `gd` | Go to definition | Normal |
| `K` | Show hover information | Normal |
| `gi` | Go to implementation | Normal |
| `gr` | Find references | Normal |
| `<leader>ca` | Code action | Normal |
| `<leader>rn` | Rename symbol | Normal |
| `<leader>fm` | Format buffer | Normal |
| `]d`, `[d` | Next/prev diagnostic | Normal |
| `<leader>dl` | Show line diagnostics | Normal |

### Database (Dadbod)

| Keymap | Action | Context |
|--------|--------|---------|
| `<leader>ldb` | Toggle DBUI | Normal |
| `<leader>ldf` | Find DB buffer | Normal |
| `<leader>lr` | Execute query | Normal/Visual in SQL |
| `<leader>ls` | Save query | Normal in SQL |

### REST Client (Kulala)

| Keymap | Action | Context |
|--------|--------|---------|
| `<leader>pr` | Run request | Normal in .http |
| `<leader>pa` | Run all requests | Normal in .http |
| `]r`, `[r` | Next/prev request | Normal in .http |
| `<leader>pi` | Inspect request | Normal in .http |
| `<leader>pt` | Toggle view | Normal in .http |
| `<leader>pc` | Copy as cURL | Normal in .http |
| `<leader>ps` | Open scratchpad | Normal in .http |

### Terminal

| Keymap | Action | Context |
|--------|--------|---------|
| `<leader>tg` | Toggle lazygit (float) | Normal |

## Dashboard (Mini.starter)

The dashboard features a CALMHIVE ASCII art header and quick access to:
- Recent files
- CalmHive journal and notes
- Quick actions (LazyGit, Database, REST Client, File Explorer)

**Keymap**: `<leader>0` - Open dashboard

## Common Workflows

### File Navigation and Editing

1. **Quickly browse files**:
   - Press `<leader>e` to open yazi file explorer
   - Press `<leader>ff` to fuzzy find files
   - Press `<leader>o` to switch between open buffers

2. **Working with multiple files**:
   - Open multiple files with Telescope
   - Switch between buffers with `<C-[>` and `<C-]>`
   - Split windows with `<leader>sv` or `<leader>sh>`

### Command and Search Workflow

1. **Searching in project**:
   - Use `<leader>ff` to find files
   - Use `<leader>fg` to search text across files
   - Use `<leader>fb` to find open buffers

### Database Workflow

1. **Using Dadbod**:
   - Press `<leader>ldb` to toggle database UI
   - Navigate to your database and tables
   - Write SQL queries in buffer
   - Press `<leader>lr` to execute query or selection
   - Press `<leader>ls` to save query

### REST Client Workflow

1. **Using Kulala**:
   - Create `.http` file
   - Write HTTP requests
   - Press `<leader>pr` to execute request
   - Press `<leader>pt` to toggle between headers and body view
   - Large responses (up to 10MB) are supported

## Installation

1. Ensure Neovim >= 0.10
2. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```
3. Set the `ANTHROPIC_API_KEY` environment variable for Claude API access
4. Start Neovim (`nvim`). Plugins will be installed automatically via `lazy.nvim`
5. Run `:Lazy sync` if needed
6. Run `:Mason` to install LSP servers, formatters, etc.

## Plugin List (Minimal Setup 2025)

1. **lazy.nvim** - Plugin manager
2. **mini.nvim** - Collection of minimal modules (statusline, starter, surround, pairs, comment, indentscope, bufremove, jump2d)
3. **telescope.nvim** - Fuzzy finder
4. **yazi.nvim** - File explorer
5. **blink.cmp** - Completion engine
6. **nvim-lspconfig** - LSP configuration
7. **nvim-treesitter** - Syntax highlighting
8. **conform.nvim** - Formatting
9. **vim-dadbod** + **vim-dadbod-ui** - Database client
10. **kulala.nvim** - REST client
11. **lazygit.nvim** - Git interface
12. **render-markdown.nvim** - Markdown preview
13. **avante.nvim** - AI coding assistant

## Configuration Structure

- `init.lua` - Entry point, bootstraps lazy.nvim
- `lua/config/core.lua` - Core settings (shared with VSCode)
- `lua/config/nvim-minimal.lua` - Neovim-specific settings
- `lua/config/modules/keymaps.lua` - Core keybindings
- `lua/plugins/` - Plugin configurations
