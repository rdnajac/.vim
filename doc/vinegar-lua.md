# Vinegar.lua - Netrw Enhancement Plugin

This is a Lua port of Tim Pope's [vinegar.vim](https://github.com/tpope/vim-vinegar) plugin for Neovim.

## Overview

Vinegar.vim enhances Vim's built-in netrw file browser with convenient features and better defaults.

## Features

### Quick Navigation
- Press `-` in any buffer to open netrw in the current file's directory
- Press `-` in netrw to go up one directory level
- Works with splits and tabs: `<Plug>VinegarSplitUp`, `<Plug>VinegarVerticalSplitUp`, `<Plug>VinegarTabUp`

### Better Defaults
- Hides banner by default (`g:netrw_banner = 0`)
- Respects `wildignore` patterns in file listing
- Smart dotfile hiding/showing based on current file context
- Better sort sequence matching Vim's `suffixes` option

### File Operations
- `.` - Start command-line with selected file(s) path(s)
- `y.` - Yank absolute path(s) of file(s) under cursor
- `!` - Shortcut for `.!` to pipe files to shell commands
- Works in both normal and visual mode for multiple file selection

### Other Enhancements
- `~` - Quick access to home directory
- Syntax highlighting for files matching `suffixes` patterns

## Installation

This plugin is located at `after/ftplugin/netrw.lua` and loads automatically when entering a netrw buffer in Neovim.

No special installation steps are needed - it's part of this vim configuration.

### Relationship to Original Plugin

The original VimScript version is located at `pack/vimfect/start/vim-tpope/plugin/vinegar.vim`. 

The Lua version uses a load guard (`g:loaded_vinegar`) to coordinate with the VimScript version. When placed in `after/ftplugin/netrw.lua`, it will execute after the VimScript plugin during Vim's initialization, but the guard prevents double-loading:

1. If the VimScript version loads first (default), it sets `g:loaded_vinegar = 1`
2. When the Lua ftplugin runs, it checks the guard and skips global setup
3. Only buffer-local mappings are applied to netrw buffers

To use the Lua version exclusively, remove or disable the VimScript plugin at `pack/vimfect/start/vim-tpope/plugin/vinegar.vim`.

### Implementation as ftplugin

This plugin is implemented as an ftplugin, which means it executes each time a netrw buffer is opened. To handle this efficiently:

- Global setup (settings, <Plug> mappings, autocommands) is guarded and runs only once
- Buffer-local mappings are set up each time a netrw buffer opens
- Shared functions are stored in `_G.vinegar` for access across buffer loads

## Implementation Notes

### Differences from Original

This Lua port maintains functional parity with the original VimScript version with the following considerations:

1. **Modern Neovim APIs**: Uses `vim.keymap.set()`, `vim.api.nvim_create_autocmd()`, and other modern Lua APIs
2. **Vim Patterns**: Preserves VimScript regex patterns where needed for compatibility with netrw's behavior
3. **Error Handling**: More explicit error handling in some edge cases
4. **Documentation**: Enhanced inline comments explaining each function's purpose

### Technical Details

The plugin sets up:
- Global `<Plug>VinegarUp` mappings for flexible key binding
- FileType autocommand for netrw buffers to set up local mappings
- OptionSet autocommand to update sort sequence when `suffixes` changes
- Proper guard against multiple loads via `g:loaded_vinegar`

### Compatibility

- Requires Neovim 0.5+ for Lua API support
- Should work alongside the original VimScript version if both are present (though only one will activate due to the load guard)

## Credits

Original plugin by Tim Pope: https://github.com/tpope/vim-vinegar

Lua port by rdnajac
