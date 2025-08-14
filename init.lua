-- init.lua
-- see `$VIMRUNTIME/example_init.lua`
vim.loader.enable()

---@type 'netrw'|'snacks'|'oil'
vim.g.default_file_explorer = 'oil'

-- disable netrw if using another file explorer
vim.g.loaded_netrw = vim.g.default_file_explorer == 'netrw' and 1 or nil

-- set the plugin directory if the new native package manager is available
if vim.is_callable(vim.pack.add) then
  vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
end

-- set these ooptions first so it is apparent if vimrc overrides them
-- also try `:options`
vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

vim.cmd.runtime('vimrc')

-- Override require to handle errors gracefully
local require = function(module)
  local ok, mod = pcall(require, module)
  if not ok then
    vim.notify(
      'Failed to load module: ' .. module .. '\n' .. mod,
      vim.log.levels.ERROR,
      { title = 'Module Load Error' }
    )
    return nil
  end
  return mod
end

-- use the new extui module if available
require('vim._extui').enable({})

-- override vim.notify to provide additional highlighting
vim.notify = require('nvim.notify')

-- test if the override is working (should be colored blue)
vim.notify('init.lua loaded!', vim.log.levels.INFO, { title = 'Test Notification' })

local Plug = require('plug').Plug

Plug('nvim.snacks')

-- stylua: ignore start
_G.bt = function() Snacks.debug.backtrace() end
_G.ddd = function(...) return Snacks.debug.inspect(...) end
-- stylua: ignore end
vim.print = _G.ddd

Plug('nvim.colorscheme')
Plug('nvim.mini')
Plug('nvim.lsp')
Plug('nvim.oil')
Plug('nvim.treesitter')

_G.icons = require('nvim.icons')
_G.plugins = require('plugins')
_G.config = require('nvim.config')
