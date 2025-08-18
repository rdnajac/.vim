---@type 'netrw'|'snacks'|'oil'
vim.g.default_file_explorer = 'oil'

-- disable netrw if using another file explorer
vim.g.loaded_netrw = vim.g.default_file_explorer == 'netrw' and 1 or nil

-- set the plugin directory if the new native package manager is available
if vim.is_callable(vim.pack.add) then
  vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
end

-- set these options first so it is apparent if vimrc overrides them
-- also try `:options`
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

vim.cmd.runtime('vimrc')

vim.loader.enable()

-- Override require to handle errors gracefully
local require = function(module)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    vim.schedule(function()
      error(mod)
    end)
    return nil
  end
  return mod
end

_G.N = require('nvim')

-- use the new extui module if available
require('vim._extui').enable({})

-- override vim.notify to provide additional highlighting
-- vim.notify = require('nvim.notify')
vim.notify = N.notify

-- test if the override is working (should be colored blue)
vim.notify('init.lua loaded!', vim.log.levels.INFO, { title = 'Test Notification' })

local Plug = require('nvim.plug').Plug

Plug('nvim.snacks')
Snacks.notify.info('snacks loaded')

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

for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath('config'), '/lua/plug/*', false, true)) do
  local modname = require('util.modname')(f)
  Plug(modname)
end

require('nvim.config')
