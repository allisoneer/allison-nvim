# Neovim Config

A personalized Neovim configuration with modern features including LSP integration, auto-completion, file navigation, and a clean UI.

## Notes to self:
1. Tabline:
   - RESOLVED: Using barbar and satisfied with it
2. Startup section:
   - https://github.com/TobinPalmer/Tip.nvim
   - https://github.com/CWood-sdf/spaceport.nvim
3. Note taking:
   - https://github.com/stevearc/gkeep.nvim
   - look for others(markdown/notes)
4. Utility:
   - Consider better buffer managers
   - https://github.com/chrisgrieser/nvim-early-retirement Something like this may be useful in addition to current buffer management
5. Terminal additions:
   - https://github.com/willothy/flatten.nvim This looks fascinating and potentially useful!
   - RESOLVED: Using toggleterm.nvim
6. UI/Visual:
   - Potential desire to expand into rainbow delimiters for more obvious separation display
   - Consider removing dressing.nvim and seeing if it makes a difference
7. File Management:
   - Consider approach for file saving - need an autosave plugin alongside the undo file approach?
8. Telescope:
   - Go through pickers and find what I actually want to use

## Project Structure
```bash
.
├── README.md # This file
├── init.lua # loads all the lua files
├── lua/
│   ├── allison/
│   │   ├── settings.lua # global settings for neovim
│   │   ├── lazy.lua # setup lazy.nvim and load plugins
│   │   ├── keymap.lua # setup keymaps
│   ├── plugins/
│   │   ├── barbar.lua # tab/buffer line
│   │   ├── comment.lua # comment toggle keymap
│   │   ├── dressing.lua # better UI elements
│   │   ├── git-signs.lua # git signs in the gutter
│   │   ├── harpoon.lua # quick file switching
│   │   ├── image.lua # image viewing in markdown
│   │   ├── indent-blankline.lua # indentation guides
│   │   ├── lualine.lua # statusline
│   │   ├── minimap.lua # code minimap
│   │   ├── oil.lua # file explorer
│   │   ├── render-markdown.lua # markdown rendering
│   │   ├── supermaven.lua # AI code completion
│   │   ├── telescope.lua # fuzzy finder
│   │   ├── theme.lua # gruvbox-material theme
│   │   ├── toggleterm.lua # terminal integration
│   │   ├── treesitter.lua # syntax highlighting
│   │   ├── ufo.lua # code folding
│   │   ├── undotree.lua # visualize file changes
│   │   ├── which-key.lua # keymap popup
│   │   ├── lsp/ # LSP related settings
│   │   │   ├── init.lua
│   │   │   ├── format.lua # formatting configuration
│   │   │   ├── lsp_attach.lua # LSP keymaps
│   │   │   ├── servers.lua # LSP server configs
```

## keymaps
- `Shift + J` and `Shift + K` to move lines up and down 
  > (press `Shift + V` to select lines and then `Shift + J` or `Shift + K` to move them)

- Remap `Shift + U` to redo

- `<Leader> + y` to copy to system clipboard
- `<Leader> + Shift + y` to copy to system clipboard from the cursor to end of the line
- `<Leader> + p` to paste from system clipboard
- `<Leader> + Shift + p` to paste from system clipboard before the cursor
- `<Leader> + e` to open the file explorer (oil.nvim)
- `<Leader> + g` to pick a buffer
- `Alt + s` to force apply any changes without a conformation
- `gcc` to comment or uncomment a line
- `gc` to comment or uncomment a block of code (visual mode)

- `<Leader> + ff` to get a list of all open buffers
- `<Leader> + space` to get a list of all the files in the current dir where nvim is opened
- `<Leader> + fl` to run a search over all the files in the current dir (Live Grep)
- `<C-t>` to create a new buffer tab
- `<C-q>` to force close current buffer

- `<Leader> + u` to toggle undotree to look at all the changes made to the files

## LSP Keymaps (only if you have LSP enabled for the current file)
- `Ctrl + space` to get auto completions
    - `Tab` or `Ctrl + n` to select the next completion
    - `Shift + Tab` or `Ctrl + p` to select the previous completion
    - `Enter` to select the current completion
    - `Ctrl + f` to scroll down the docs window
    - `Ctrl + d` to scroll up the docs window
    - `Alt + e` to close the completion window
- `gd` to go to definition of the word under the cursor
- `gD` to go to the declaration of the word under the cursor
- `gr` to find references of the word under the cursor
- `gI` to go to the implementations of the word under the cursor
- `K` to get the documentation of the word under the cursor
- `Ctrl + k` to get signature help for the word under the cursor
- `<Leader> + D` to get the type of the word under the cursor
- `<Leader> + ds` to get all the symbols in the current files
- `<Leader> + ws` to get all the symbols in the current workspace
- `<Leader> + rn` to LSP rename the word under the cursor
- `<Leader> + ca` to LSP code action for the word under the cursor
- `<Leader + dd` to show LSP diagnostics
    - `q` to close the diagnostics window (if cursor is in the diagnostics window)
    - `<Leader> + dd` to toggle the diagnostics window (if not in diagnostics window already)
    - `Shift + K` on a line to see the full error message
- `<Leader> + f` to format the current file

## Formatting
For formatting `conform.nvim` is used.
It uses a formatter configured in the `lua/lsp/format.lua` file
or the one provided by the LSP server if it's available.
To install a formatter run `:Mason` and select the formatter you want to install,
and then tell `conform.nvim` to use that formatter by adding it to the `lua/lsp/format.lua` file.

## Harpoon
Harpoon is a plugin that allows you to switch between a set of files
quickly and easily. It's like a bookmark system for files.

Harpoon holds a list of files that you can switch between using a keymap.
You can add the current file to the list of files and then switch to any of the files in the list.

- `<Leader> + a` to add the current file to the list of files
- `<Leader> + hh` to show the list of files
    - Harpoon window is a normal buffer so you can use `j` and `k` to move up and down
    - `Enter` to open the file under the cursor
    - `q` to close the Harpoon window
    - `dd` to delete the file under the cursor from the list
    - any other vim command to do whatever you want with the file list

- `<Leader> + ha` to open the first file in the list
- `<Leader> + hs` to open the second file in the list
- `<Leader> + hd` to open the third file in the list
- `<Leader> + hf` to open the forth file in the list

You can set more keymaps in the `lua/plugins/harpoon.lua` file.

## Global Settings
- Enable line numbers
- Enable relative line numbers
- Enable wrap
- Set scrolloff to 8 (:help scrolloff for more info)

- Enable termguicolors (enables true color support)

- Set some good split defaults
  - splitbelow
  - splitright

- Set tabstop=2 and shiftwidth=2

- Disable swap files and backup files in favor of undo files
- Set the undodir to ~/.vim/undodir

- Set some good search defaults

- Always show the signcolumn

- Set some code folding defaults with `ufo.nvim`

## Workflow Notes and Improvement Areas

### Buffer Management
- Current approach: Using `<Leader> + g` for buffer switching works, but doesn't scale well with many open buffers
- Issue: No good way to manage how many buffers are open
- Workaround: Often restarting Neovim when it gets too crowded
- Finding files relies on:
  - Telescope file search (`<Leader> + space`)
  - Live grep search (`<Leader> + fl`) 
  - Oil file explorer (`<Leader> + e`)
  - Buffer list (`<Leader> + ff`) has limitations with many buffers

### Window/Pane Management
- Basic usage: `Ctrl + w` followed by vim movements (h,j,k,l) to move between splits
- Issue: Not yet comfortable with creating and managing multiple windows/panes
- More efficient window management commands to learn:
  - Creating splits: `:split` (horizontal) and `:vsplit` (vertical)
  - Resizing: `Ctrl + w` followed by `+`, `-`, `>`, `<`
  - Balancing: `Ctrl + w` followed by `=`

### Terminal Usage
- Despite having toggleterm installed, rarely using it in practice
- Current workflow: Using multiple tabs in terminal emulator instead of Neovim's terminal
- Opening a new terminal tab for command-line operations rather than using Neovim's built-in terminal

## Recent Additions

### Supermaven AI Code Completion
- Integrated AI code suggestions
- Accept with `<Tab>`
- Clear with `<C-]>`
- Accept word with `<C-j>`

### Image Support in Markdown
- View images directly in Neovim
- Uses kitty terminal backend
- Automatically clears images when windows overlap

### Enhanced Markdown Rendering
- Better markdown rendering with syntax highlighting
- Integrated with image support

## Theme (Customization)
The theme `gruvbox-material`
is setup at the bottom of the `lua/plugins/theme.lua` file.
Customizations are also done in the same file in the config
function at the bottom of the file.