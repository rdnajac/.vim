# Mini.nvim Modular Configuration

This directory contains configuration files for individual [mini.nvim](https://github.com/echasnovski/mini.nvim) submodules.

## Available Submodules

- **icons** (`mini.icons`): Icon support, required by other plugins like aerial.nvim
- **align** (`mini.align`): Text alignment with the `ga` operator
- **ai** (`mini.ai`): Extended text objects for more intuitive text selections
- **diff** (`mini.diff`): Git diff integration with inline signs and overlays
- **hipatterns** (`mini.hipatterns`): Highlight patterns in text (e.g., hex colors)

## Enabling/Disabling Submodules

Each submodule can be independently enabled or disabled in `lua/nvim/plugins/mini.lua` by setting the `enabled` field:

```lua
local submodules = {
  icons = {
    enabled = true,  -- Keep icons enabled (required by other plugins)
    config = function()
      require('mini.icons').setup(nv.icons.mini)
    end,
  },
  align = {
    enabled = false,  -- Disable mini.align
    config = function()
      require('mini.align').setup({})
    end,
  },
  -- ... other submodules
}
```

## Benefits

- **Reduced overhead**: Only load the submodules you actually use
- **Faster startup**: Fewer plugins to initialize
- **Lower memory usage**: Less code loaded into memory
- **Easier debugging**: Isolate issues by disabling specific modules
- **Flexible configuration**: Enable/disable based on environment or conditions

## Configuration Files

- `ai.lua`: Extended text object configuration
- `diff.lua`: Git diff signs and overlay configuration
- `hipatterns.lua`: Pattern highlighter configuration
- `lazy.lua`: (Currently disabled) Lazy loading alternatives
- `splitjoin.lua`: (Currently disabled) Code splitting/joining

## Note

⚠️ **mini.icons** should generally remain enabled as it's required by other plugins in this configuration (e.g., aerial.nvim).
