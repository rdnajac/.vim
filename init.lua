---@type 'netrw'|'snacks'|'oil'
vim.g.default_file_explorer = 'oil'

-- disable netrw if using another file explorer
vim.g.loaded_netrw = vim.g.default_file_explorer == 'netrw' and 1 or nil

-- set the plugin directory if the new native package manager is available
if vim.is_callable(vim.pack.add) then
  vim.g.plug_home =
    vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
end

-- set these options first so it is apparent if vimrc overrides them
-- also try `:options`
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'

vim.cmd.runtime('vimrc')

vim.loader.enable()

-- Override require to handle errors gracefully
_G.Require = function(module)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    vim.schedule(function()
      error(mod) -- why are we scheduling the error?
    end)
    return nil
  end
  return mod
end

-- use the new extui module if available
Require('vim._extui').enable({})
Require('nvim')

local Plug = N.plug

-- stylua: ignore start
_G.bt = function() Snacks.debug.backtrace() end
_G.ddd = function(...) return Snacks.debug.inspect(...) end
-- stylua: ignore end
vim.print = _G.ddd
-- TODO: Make this make sense
-- local snacks = Plug('nvim.snacks')
-- Plug.do_configs({ Plug('nvim.snacks') })
require('nvim.snacks')


Plug.do_configs({
  Plug('nvim.colorscheme'),
  Plug('nvim.diagnostic'),
  Plug('nvim.lsp'),
  Plug('nvim.treesitter'),
})

require('plug')
