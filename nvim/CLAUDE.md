# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Structure
- All plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim)
- Core settings are in `lua/config/core.lua` (common to both VSCode and regular Neovim)
- Neovim-specific settings are in `lua/config/nvim-minimal.lua`
- Plugin configurations are in `lua/plugins/` directory

## Directive Reminder
- Do not use key mappings that would overlap with single letter lead keys to avoid conflicts

## Keybinding Rules (2025 Minimal Config)

1. **No capital letter namespaces** - Use lowercase only (e.g., `<leader>p*` not `<leader>P*`)
2. **No single-letter conflicts** - If `<leader>x` exists as single mapping, cannot use `<leader>x*` as namespace
3. **Current namespace allocation:**
   - `<leader>a*` = Avante AI assistant
   - `<leader>c*` = Compile/quickfix list
   - `<leader>f*` = Find/Telescope
   - `<leader>k*` = Knowledge base (CalmHive)
   - `<leader>l*` = sqL/Database (dadbod)
   - `<leader>m*` = Marks (marks.nvim)
   - `<leader>n*` = Notes/Markdown editing
   - `<leader>p*` = Postman/HTTP REST (kulala)
   - `<leader>r*` = Refactoring (refactoring.nvim)
   - `<leader>s*` = Splits/windows
   - `<leader>t*` = Tabs/terminal
   - `<leader>x*` = Diagnostics/Quickfix (Trouble)
   - `<leader>z*` = Zen mode & markdown preview
4. **Single-letter only (NO namespace):**
   - `<leader>d` = Duplicate
   - `<leader>e` = Yazi file explorer
   - `<leader>o` = Open buffer picker
   - `<leader>q` = Close buffer
   - `<leader>w` = Save
   - `<leader>x` = Save and close
   - `<leader>0` = Dashboard
   - `<leader>j` = Jump2d
   - `<leader>/` = Comment toggle

## Plugin Notes

### Mini.nvim Dashboard
- Custom CALMHIVE ASCII header
- Quick access to CalmHive notes and projects
- Actions: LazyGit, Database, REST Client, File Explorer

### Kulala (REST Client)
- Max response size: 10MB (fixed from 32KB default)
- Supports .http files
- All keymaps under `<leader>p*` prefix

### Dadbod (Database)
- DBUI toggle: `<leader>ldb`
- Execute query: `<leader>lr` in SQL files
- Icons and nerd fonts enabled

### LSP Configuration
- Deprecation warnings suppressed for lspconfig (until v3.0.0)
- Standard LSP keymaps: gd, gr, gi, K, etc.
- Format with `<leader>fm`

### Marks (marks.nvim)
- Enhanced mark visualization in sign column
- 10 bookmark groups with custom signs/virtual text
- Quick navigation, preview, extract to quickfix
- All keymaps under `<leader>m*` prefix
- Complements harpoon for file navigation

### Refactoring (refactoring.nvim)
- Extract function/variable/block operations
- Inline function/variable operations
- Debug printf and print var statements
- Preview changes with Ex commands
- All keymaps under `<leader>r*` prefix

### Zen Mode & Live Preview
Comprehensive zen mode presets for different workflows:
- `<leader>zz` - Toggle zen mode (default 120 cols)
- `<leader>zn` - Narrow zen (80 cols, pure writing)
- `<leader>zw` - Wide zen (140 cols, tables/code)
- `<leader>zf` - Full screen zen (100% width)
- `<leader>zm` - Markdown zen (ultra-clean for CalmHive)
- `<leader>zc` - Coding zen (keeps line numbers & git signs)
- `<leader>zt` - Toggle Twilight (dim inactive code)
- `<leader>zp` - Live preview toggle
- `<leader>zs` - Start live preview
- `<leader>zx` - Stop live preview

Live preview features (live-preview.nvim):
- Zero dependencies (pure Lua, no Node.js required)
- Supports Markdown, HTML, AsciiDoc, SVG
- Browser-based with sync scrolling
- KaTeX math + Mermaid diagrams
- Integrates with snacks.nvim picker
- Auto-updates on save (HTML) or as you type (Markdown)

### Markdown Editing (markdown-toggle.nvim)
Comprehensive markdown editing tools with mini.surround integration:
- `<leader>nt` - Toggle markdown element (checkbox/list/heading)
- `<leader>nc` - Toggle checkbox: `[ ]` ↔ `[x]` ↔ `[-]`
- `<leader>nl` - Toggle list type: `-` ↔ `*` ↔ `+` ↔ `1.`
- `<leader>nh` - Toggle heading level
- `<leader>nq` - Toggle quote
- `<leader>nb` - Bold text (visual) or word (normal)
- `<leader>ni` - Italic text (visual) or word (normal)
- `<leader>nk` - Inline code (visual) or word (normal)
- Auto-continue bullets/checkboxes on new line

Features:
- Treesitter-based parsing for accuracy
- Works seamlessly with render-markdown.nvim visual rendering
- Uses mini.surround for text formatting operations
- Markdown FileType only, no interference elsewhere

### AI Tools
Two AI tools are configured:
1. **Avante** - Cursor-like sidebar AI assistant with full agentic mode, tool use, and direct API integration (`<leader>a*`)
2. **Copilot** - GitHub Copilot for inline code completions (insert mode)

## Code Style Guidelines
- Lua: Use 2-space indentation
- Keep plugin configs modular in separate files
- Use descriptive keymap descriptions
- Prefer lazy-loading plugins when possible
