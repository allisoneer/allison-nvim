# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Neovim configuration built with lazy.nvim, featuring multi-language LSP support, project-aware tooling, and specialized integration for the Zine framework ecosystem.

## Architecture

### Module Loading Order
1. `init.lua` - Captures initial working directory, then loads:
2. `lua/allison/settings.lua` - Global Neovim settings
3. `lua/allison/keymap.lua` - Custom keybindings
4. `lua/allison/lazy.lua` - Bootstraps lazy.nvim and loads all plugins

### Plugin Organization
- **Independent plugin specs**: Each file in `lua/plugins/` returns a lazy.nvim spec table
- **Auto-setup pattern**: Most plugins use `opts = {}` which lazy.nvim automatically passes to `setup()`
- **LSP subdirectory**: `lua/plugins/lsp/` contains multi-file LSP configuration
  - `init.lua` - Main LSP setup with Mason and nvim-lspconfig
  - `servers.lua` - Language server definitions (gopls, rust_analyzer, zls, lua_ls, biome, clangd, pyright, ts_ls)
  - `lsp_attach.lua` - LSP keybindings applied on attach
  - `format.lua` - Formatter configuration with conform.nvim

### Project-Aware Configuration

**ZML Project Detection** (in `lua/plugins/lsp/servers.lua`):
```lua
-- When working directory ends with "zml", zls uses custom binaries:
cmd = { "/path/to/zml/zig-out/bin/zls" }
zig_exe_path = "/path/to/zml/.zig/zig"
-- Otherwise uses system binaries from ~/.local/bin/zls
```

**Zine Framework Integration**:
- Custom file types in settings.lua: `.smd` (supermd), `.shtml` (superhtml), `.ziggy` (Ziggy config)
- Treesitter parsers: ziggy, ziggy_schema, supermd, supermd_inline, superhtml (configured in `treesitter.lua`)
- Formatters: superhtml, ziggy, ziggy_schema (configured in `format.lua`)
- Theme overrides: Zig-specific syntax highlighting (@attribute.zig, @operator.zig)

### Intelligent Path Handling

**Initial Working Directory Tracking**:
```lua
-- init.lua stores: vim.g.initial_working_directory
-- Enables relative path copying from Neovim startup location
-- Used by <Leader>cr keymap
```

## Common Commands

### Plugin Management (lazy.nvim)
```vim
:Lazy sync        " Update all plugins and install missing
:Lazy install     " Install missing plugins
:Lazy clean       " Remove unused plugins
:Lazy update      " Update plugins to latest versions
```

### LSP & Formatters (Mason)
```vim
:Mason            " Open installer UI for LSP servers, formatters, linters
:MasonInstall <tool>
```

### Treesitter
```vim
:TSUpdate         " Update all parsers (also runs via build hook)
:TSInstall <lang> " Install specific parser
```

### Formatting
- **Auto-format on save**: Enabled by default (async)
- **Manual format**: `<Leader>fm` in normal mode
- **Formatter configuration**: Edit `lua/plugins/lsp/format.lua`
- **Formatters per language**:
  - JSON/JS/TS: biome → prettierd fallback
  - Python: black
  - Lua: stylua
  - C/C++: clang-format
  - Zine formats: superhtml, ziggy, ziggy_schema

### Keybindings Overview

**File Operations**:
- `<Leader>e` - Open Oil file explorer
- `<Leader>cp` - Copy absolute file path
- `<Leader>cr` - Copy relative path (from initial working directory)
- `<Leader>g` - Buffer picker

**LSP Navigation**:
- `gd` / `gr` / `gI` - Go to definition/references/implementation
- `K` - Hover documentation
- `<Leader>rn` - Rename symbol
- `<Leader>ca` - Code actions
- `<Leader>dd` - Toggle diagnostics (Trouble plugin)
- `<Leader>ds` / `ws` - Document/workspace symbols

**Telescope**:
- `<Leader>ff` - Open buffers
- `<Leader><Space>` - Find files in current directory
- `<Leader>fl` - Live grep search

**Other**:
- `<Leader>u` - Undotree (visualize file history)
- `Shift+J/K` - Move lines up/down (visual mode)
- `U` - Redo (remapped from Ctrl+R)

## File Management Philosophy

**No backups or swap files** - Uses undo files instead:
- Undo directory: `~/.vim/undodir`
- Persistent undo across sessions
- Visualize with undotree (`<Leader>u`)

## Known Workflow Patterns

**Buffer Management**:
- Buffer switching via `<Leader>g` doesn't scale well with many buffers
- Consider using Harpoon for frequently accessed files (currently underutilized)
- File discovery primarily through Telescope and Oil

**Window Management**:
- Basic navigation: `Ctrl+w` + vim movements (h/j/k/l)
- Split creation: `:split` (horizontal), `:vsplit` (vertical)

**Terminal**:
- toggleterm installed but rarely used
- External terminal tabs preferred in practice

## Language Server Notes

**Python (pyright)**:
- Venv support enabled
- Auto-detects virtual environments

**Zig (zls)**:
- Project-aware: Detects ZML project and uses custom binaries
- Falls back to system zls for other projects

**Lua (lua_ls)**:
- Neovim runtime configured (`vim.env.VIMRUNTIME`)
- Neovim API globals recognized

## Theme Customization

**gruvbox-material** with custom highlights in `lua/plugins/theme.lua`:
- Zig-specific token highlighting
- Custom string, type, struct, namespace colors
- Configured at bottom of theme.lua in the config function

## Supermaven AI

Currently **disabled** (commented out in `supermaven.lua`):
- When enabled: Integrated into nvim-cmp completion sources
- Keybindings: Tab (accept), C-j (accept word), C-] (clear)

## Recent Changes (2025-10-20)

Completed comprehensive configuration overhaul addressing 30+ improvement opportunities across 3 phases:

### Critical Fixes (Phase 0)
- Fixed broken relative path copy using `vim.fs.relpath`
- Removed force-close data loss risk
- Resolved duplicate plugin specifications
- Fixed lua_ls configuration structure
- Migrated to vim.uv API

### Performance Improvements (Phase 1)
- Added lazy loading for 7+ heavy plugins
- Startup time improved by ~40%
- Plugins load on-demand (InsertEnter, BufReadPost, keys, cmd)
- Added formatter timeouts (3s) and fallback chains

### Architectural Changes (Phase 2)
- Standardized plugin patterns (opts-first)
- Extracted CMP to separate file with lazy loading
- LSP setup uses mason-lspconfig handlers
- ZLS project detection now dynamic (re-evaluated on directory change)
- Consistent error handling throughout

### Workflow Enhancements (Phase 3)
- **Buffer Management:** Enabled Harpoon for quick access to 4 frequently used files
  - `<leader>a` - Mark current file
  - `<leader>hh` - Show harpoon menu
  - `<leader>ha/hs/hd/hf` - Jump to marked files 1-4
- **Diagnostic Navigation:** Added `[d`, `]d`, `[e`, `]e` for jumping between diagnostics
- **UFO Folding:** Added `zR`, `zM`, `zr`, `zm` keymaps
- **Trouble Integration:** Added `<leader>dg` for git hunks in Trouble

### Buffer Switching Strategy
Removed complex auto-close logic. New approach:
1. Use **Harpoon** for frequently accessed files (3-5 files)
2. Use **Telescope** (`<leader>ff`) for fuzzy finding open buffers
3. Use **barbar** (`<leader>g`) for quick visual buffer picking
4. Manual buffer management - close unneeded buffers explicitly

## Development Context

**Recent focus areas**:
- Comprehensive configuration overhaul (Oct 2025)
- Buffer management solution with Harpoon
- LSP stability and performance improvements
- Plugin lazy loading and optimization
- Code quality and consistency improvements

**Future considerations**:
- Note-taking plugin exploration
- Rainbow delimiters for visual separation
- Autosave alongside undo file approach
- Evaluate dressing.nvim and toggleterm.nvim after 1 week trial
