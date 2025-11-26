_G.t = { vim.uv.hrtime() }

vim.loader.enable()
require('nvim.util.track')

--- @diagnostic disable-next-line: duplicate-set-field
function vim.print(...)
  return vim._print(true, ...)
end

vim.g.stdpath = vim.iter({ 'cache', 'config', 'data', 'state' }):fold({}, function(stdpath, d)
  stdpath[d] = vim.fn.stdpath(d)
  return stdpath
end)

vim.g.plug_home = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.g.loaded_netrw = false

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim'))
  ---@type snacks.profiler.Config
  local opts = {
    -- startup = { event = 'UIEnter' },
  }
  require('snacks.profiler').startup(opts)
end

--- loads vim settings and exports vim.g.plugins
vim.cmd([[
  runtime vimrc
  let s:me = resolve(expand('<sfile>:p'))
  " echueuuueeeom s:me
]])

vim.o.pumblend = 0
vim.o.pumborder = 'rounded'
vim.o.pumheight = 10
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})
local ok, nv = pcall(require, 'nvim')
if not ok then
  require('vim._extui').enable({ enable = false })
end
-- stylua: ignore start
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function(...) Snacks.debug.backtrace(...) end
_G.p  = function(...) Snacks.debug.profile(...) end
