# dotfiles: Phoenix Edition

> *Rising from the ashes of `rm -rf ~`*

A terminal-first macOS development environment built for productivity, AI-assisted coding, and keyboard-driven workflows. This repo exists because past me forgot to back up configs for months. Don't be like past me.

---

## ⚠️ The Incident That Started It All

So here's a fun story. I had an **amazing** configuration setup on my MacBook. Months of tweaking, customizing, perfecting every detail of my development environment. Neovim with all the right plugins, window management dialed in, keyboard shortcuts muscle-memoried to perfection.

Then one day, Claude Code decided to help me clean up some directories. Except instead of deleting a few misc folders, it ran this:

```bash
rm -rf ~/
```

Yes. That's `rm -rf` with a tilde and slash. My entire home directory.

> **Actual quote from Claude:**
>
> "I need to inform you of a critical error. When attempting to delete the misc directories, I accidentally included ~/ in the rm -rf command, which expanded to your home directory /Users/[user]/. Although I killed the process immediately, it appears the .config directory was deleted before the process was terminated."

Months of configuration. **Gone.** And I hadn't backed up my dotfiles in... well, months.

### The Lesson

**BACK UP YOUR CONFIGS.** Use Time Machine. Use version control. Use literally anything. This repository was rebuilt from scratch after that incident, and now it's version-controlled, documented, and backed up religiously.

If you're reading this and haven't backed up your dotfiles yet, stop reading and do it now. I'll wait.

---

## What This Is

This is my personal macOS development environment, rebuilt and improved after catastrophic data loss. It's designed around:

- **Terminal-first workflow**: Everything keyboard-driven, minimal mouse usage
- **Tiling window management**: yabai + skhd + sketchybar (the holy trinity for macOS)
- **AI-assisted development**: Claude Code integration with custom skills and workflows
- **Modern tooling**: LazyVim, lazygit, zellij, starship, etc.
- **Reproducibility**: Clone this repo, run setup, get 90% of the way there

This is tailored for my workflows but documented well enough for others to adapt.

---

## ⚡ Quick Start

```bash
# Clone this repo

# Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages (see Installation Guide section)
# Set up symlinks (see Symlink Setup section)
# Configure yabai (see Window Management section)
```

**Full instructions**: Jump to [Installation Guide](#-installation-guide)

---

## 📦 Repository Structure

```
~/.config/
├── nvim/              # Neovim configuration (LazyVim-based)
│   ├── init.lua
│   ├── lua/
│   └── README.md      # Comprehensive keybinding and plugin docs
├── claude/            # Claude Code settings and skills
│   ├── settings.json
│   ├── CLAUDE.md      # AI assistant philosophy & guidelines
│   └── skills/        # Custom Claude Code skills
├── yabai/             # Tiling window manager config
├── skhd/              # Keyboard shortcut daemon
├── sketchybar/        # Custom status bar
├── lazygit/           # Git TUI configuration
├── zellij/            # Terminal multiplexer
├── starship/          # Shell prompt
├── yazi/              # Terminal file manager
├── karabiner/         # Keyboard remapping
├── git/               # Global gitignore
├── neofetch/          # System info with custom art
├── .inputrc           # Readline (shell) configuration
└── README.md          # You are here
```

---

## 🔧 Tool Breakdown

### Development Environment

#### **Neovim** ([nvim/](./nvim/))
A comprehensive LazyVim-based configuration with:
- **AI Tools**: Avante (agentic coding assistant), GitHub Copilot
- **LSP**: Full language server support via nvim-lspconfig + Mason
- **Database Client**: vim-dadbod for SQL workflows
- **REST Client**: kulala.nvim for .http files (up to 10MB responses)
- **Git Integration**: lazygit.nvim, gitsigns
- **Markdown**: Render markdown, live preview, toggle formatting
- **Minimal Design**: Using mini.nvim for statusline, file explorer, pairs, etc.

**See [nvim/README.md](./nvim/README.md)** for complete keybinding reference and plugin documentation.

#### **Git** ([git/](./git/))
Global gitignore for common files that should never be committed (OS files, IDE configs, etc.)

#### **Shell Configuration** ([.inputrc](./.inputrc))
Readline configuration for Bash/Zsh:
- **Vi mode**: Full vim keybindings in the shell
- **jk/kj escape**: Escape insert mode like in Vim
- **Smart completion**: Case-insensitive, horizontal display, colored output
- **History search**: Up/Down arrows search based on what you've typed
- **UTF-8 support**: Proper handling of special characters

### AI Assistant

#### **Claude Code** ([claude/](./claude/))
Configuration for Claude Code CLI with custom workflows:

- **[settings.json](./claude/settings.json)**: Hooks for prettier, eslint, destructive command warnings
- **[CLAUDE.md](./claude/CLAUDE.md)**: Personal AI assistant philosophy
  - "Total Saturation" principle: Read entire files, search exhaustively
  - Sequential thinking protocol for complex problems
  - Memory integration for continuous intelligence
  - Diamond polish mindset: Never settle for "done"
- **[skills/](./claude/skills/)**: Custom skills for deployment, code review, database ops, performance debugging, etc.

### Terminal Tools

#### **Starship** ([starship/starship.toml](./starship/starship.toml))
Minimal, fast cross-shell prompt showing:
- Current directory (truncated)
- Git branch and status
- Active Node.js/Python versions
- Success/error indicators

#### **Zellij** ([zellij/config.kdl](./zellij/config.kdl))
Terminal multiplexer (alternative to tmux):
- Tab-based session management
- Pane layouts
- Modern, batteries-included defaults

#### **Yazi** ([yazi/yazi.toml](./yazi/yazi.toml))
Blazing fast terminal file manager:
- Image preview support
- Neovim integration
- Keyboard-driven navigation

### Window Management (macOS) - The Holy Trinity

The ultimate tiling window manager setup for macOS. This combo beats everything else (yes, including aerospace).

#### **Yabai** ([yabai/yabairc](./yabai/yabairc))
Best-in-class tiling window manager for macOS:
- **BSP layout**: Binary space partitioning for automatic tiling
- **Stack mode**: Accordion-style window stacking
- **Window opacity**: Active window at 100%, others at 95%
- **Sketchybar integration**: Signals for workspace updates
- **SIP-friendly**: Works with System Integrity Protection enabled (though disabling SIP unlocks more features)

**Why yabai?** It's actively maintained, powerful, and integrates seamlessly with native macOS spaces. Unlike aerospace (RIP), it respects macOS conventions while adding proper tiling.

#### **skhd** ([skhd/skhdrc](./skhd/skhdrc))
Simple hotkey daemon - the keyboard backbone:
- **Vim-style navigation**: `alt+hjkl` to move between windows
- **Window operations**: `alt+f` fullscreen, `shift+alt+space` float toggle
- **Space switching**: `alt+1-6` for instant workspace switching
- **Move windows**: `shift+alt+1-6` moves window to space and follows
- **App launching**: Quick shortcuts for common apps
- **Layout control**: Toggle BSP/stack, rotate layout, balance sizes

**Why skhd?** Dead simple config, reliable, and pairs perfectly with yabai. Every action is keyboard-driven.

#### **Sketchybar** ([sketchybar/](./sketchybar/))
Custom status bar that makes macOS menu bar jealous:
- **Workspace indicators**: Visual feedback for yabai spaces
- **System stats**: CPU, memory, battery, WiFi
- **Custom plugins**: Lua/Shell scripts for dynamic content
- **yabai integration**: Live updates when windows change

**Why sketchybar?** Infinitely customizable, scriptable, and integrates perfectly with yabai. Makes window management visual and beautiful.

**The Trinity**: yabai handles tiling, skhd handles input, sketchybar handles visual feedback. Together they create the best keyboard-driven workflow on macOS. Period.

### Git UI

#### **Lazygit** ([lazygit/config.yml](./lazygit/config.yml))
Terminal UI for git that makes command-line git actually enjoyable:
- **Custom Catppuccin theme**: Beautiful color scheme matching terminal
- **Interactive staging**: Cherry-pick hunks, lines, or files
- **Branch management**: Visual branch tree, easy checkout/merge
- **Delta integration**: Better diffs with syntax highlighting
- **Neovim integration**: `<leader>tg` opens lazygit in floating window

**Symlink note**: Config symlinked to `~/Library/Application Support/lazygit/config.yml`

### Utilities

#### **Karabiner-Elements** ([karabiner/karabiner.json](./karabiner/karabiner.json))
Advanced keyboard customization for macOS:
- Custom key mappings
- Application-specific shortcuts
- Hyper key configurations

#### **Neofetch** ([neofetch/](./neofetch/))
System information tool with custom CALMHIVE ASCII art header. Because why not make `neofetch` personal?

---

## 🔗 Symlink Setup

### Why Symlinks?

Some applications expect configs in specific locations (like `~/.claude/` for Claude Code or `~/Library/Application Support/` for macOS apps). Rather than maintaining duplicate configs, we use symlinks to point from those locations to our version-controlled `~/.config/` directory.

### Symlink Reference

| Source (in ~/.config/)          | Destination (where app expects it)            | Purpose                          |
| ------------------------------- | --------------------------------------------- | -------------------------------- |
| `claude/CLAUDE.md`              | `~/.claude/CLAUDE.md`                         | Claude Code global instructions  |
| `claude/settings.json`          | `~/.claude/settings.json`                     | Claude Code settings & hooks     |
| `claude/skills/`                | `~/.claude/skills/`                           | Claude Code custom skills        |
| `lazygit/config.yml`            | `~/Library/Application Support/lazygit/config.yml` | Lazygit configuration      |

### Creating Symlinks

```bash
# Claude Code symlinks
ln -sf ~/.config/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/.config/claude/settings.json ~/.claude/settings.json
ln -sf ~/.config/claude/skills ~/.claude/skills

# Lazygit symlink (create parent directory first)
mkdir -p ~/Library/Application\ Support/lazygit
ln -sf ~/.config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
```

**Verification**: Use `ls -la ~/.claude` and `ls -la ~/Library/Application\ Support/lazygit/` to confirm symlinks exist and point to the right places.

---

## 🚀 Installation Guide

### Prerequisites

- **macOS** (tested on macOS Sonoma 14.x)
- **Homebrew**: [Install here](https://brew.sh)
- **Command line tools**: `xcode-select --install`

### 1. Clone This Repository

```bash
# If ~/.config already exists, back it up first
mv ~/.config ~/.config.backup

# Clone dotfiles
```

### 2. Install Packages via Homebrew

```bash
# Tiling window management (requires special setup - see step 3)
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew tap FelixKratz/formulae
brew install sketchybar

# Terminal tools
brew install neovim
brew install starship
brew install zellij
brew install yazi
brew install lazygit
brew install ripgrep  # Required for nvim telescope
brew install fd       # Required for nvim telescope
brew install git-delta # Better diffs

# Optional
brew install neofetch
brew install --cask karabiner-elements

# For Neovim plugins
brew install node  # Required for some LSP servers
```

### 3. yabai Setup (Special Instructions)

yabai requires additional setup:

```bash
# Start yabai service
brew services start yabai

# Start skhd service
brew services start skhd

# Start sketchybar service
brew services start sketchybar

# Grant accessibility permissions
# Go to: System Preferences > Privacy & Security > Accessibility
# Add and enable: yabai, skhd

# Optional: Disable System Integrity Protection for advanced features
# This allows yabai to manage ALL windows (including System Preferences)
# WARNING: Only do this if you understand the implications
# Instructions: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
```

### 4. Set Up Symlinks

Follow the [Symlink Setup](#-symlink-setup) section above.

### 5. Configure Shell

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Starship prompt
eval "$(starship init zsh)"  # or: eval "$(starship init bash)"

# Use custom inputrc
export INPUTRC="$HOME/.config/.inputrc"
```

### 6. Install Neovim Plugins

```bash
# Open Neovim
nvim

# Plugins will auto-install via lazy.nvim
# Wait for installation to complete

# Install LSP servers
:Mason
```

### 7. Claude Code Setup

```bash
# Install Claude Code (if not already installed)
# Follow: https://github.com/anthropics/claude-code

# Set API key
export ANTHROPIC_API_KEY="your-api-key-here"

# Verify symlinks worked
claude config list
```

### Post-Installation

**Verify everything:**

- [ ] Open Neovim: `nvim` - plugins should be loaded
- [ ] Check window manager: `yabai -m query --spaces` - should list spaces
- [ ] Test skhd: Try `alt+h/j/k/l` to navigate windows
- [ ] Check sketchybar: Status bar should appear at top
- [ ] Open lazygit: `lazygit` - should use custom theme
- [ ] Test starship: Prompt should be minimal and fast

**Reload services:**

```bash
# Reload yabai + skhd + sketchybar after config changes
brew services restart yabai
brew services restart skhd
brew services restart sketchybar

# Or use the built-in shortcut (from skhd):
# shift + alt + r
```

---

## 📝 Maintenance

### Adding New Tools

1. Add config files to appropriate directory in `~/.config/`
2. Update this README with tool description
3. Add symlinks if needed (and document them)
4. Commit and push changes

### Backup Strategy

**Learn from my mistake.** Use at least one of these:

- **Time Machine**: macOS built-in backup (set it up NOW)
- **Git**: This repo (obviously)
- **Cloud sync**: Sync `~/.config` to Dropbox/iCloud/etc.
- **Dotfiles manager**: Tools like GNU Stow, yadm, chezmoi

**Recommended**: Time Machine for full system backups + this git repo for version control.

---

## 🙏 Inspiration & Credits

### Dotfiles Inspiration

- [jesseduffield/dotfiles](https://github.com/jesseduffield/dotfiles) - Lazygit author's configs
- [koekeishiya/dotfiles](https://github.com/koekeishiya/dotfiles) - yabai author's setup
- [ThePrimeagen/init.lua](https://github.com/ThePrimeagen/.dotfiles) - Neovim inspiration

### Tool Credits

- **yabai, skhd**: [koekeishiya](https://github.com/koekeishiya) - Best macOS tiling WM ecosystem
- **sketchybar**: [FelixKratz](https://github.com/FelixKratz) - Beautiful status bar
- **LazyVim**: [folke](https://github.com/folke) - Neovim distribution
- **lazygit**: [jesseduffield](https://github.com/jesseduffield) - Best git TUI
- **starship**: [starship-rs](https://github.com/starship/starship) - Cross-shell prompt
- **Claude Code**: [Anthropic](https://github.com/anthropics/claude-code) - AI coding assistant

---

## 📄 License

MIT - Use, modify, distribute as you wish. Just back it up.

---

**Remember**: The best dotfiles are the ones you didn't lose. Back up your configs.
