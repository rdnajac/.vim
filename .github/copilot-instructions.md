# Neovim Configuration

Personal (n)vim configuration with a hybrid Vimscript/Lua architecture.

## init.lua

- Loads vimrc via `vim.cmd([[ runtime vimrc ]])`
- Initializes Snacks.nvim with global debugging helpers (`dd`, `bt`, `p`)

## vimrc

- Sets core options (fold, indent, UI, sessions)
- Defines autogroups for cursor behavior, file reloading, auto-resize
- Hybrid compatible (works with Vim and Neovim)

## lua

### lua/nvim/ - Custom utility module namespace

- Loading module proxy using `vim.defaulttable()`
  - Submodules: `blink`, `keys`, `lsp`, `treesitter`
  - Falls back to `nvim.util.*` for utilities

### plugins

specs...
