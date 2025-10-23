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
   - `<leader>f*` = Find/Telescope
   - `<leader>l*` = sqL/Database (dadbod)
   - `<leader>p*` = Postman/HTTP REST (kulala)
   - `<leader>r*` = Refactoring/LSP rename
   - `<leader>s*` = Splits/windows
   - `<leader>t*` = Tabs/terminal
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

## Code Style Guidelines
- Lua: Use 2-space indentation
- Keep plugin configs modular in separate files
- Use descriptive keymap descriptions
- Prefer lazy-loading plugins when possible
