_G.t = { vim.uv.hrtime() }

vim.loader.enable()
vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim'))
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
else
  -- setmetatable(_G.t, { __call = require('nvim.util.track').log })
  -- nv.lazyload(function(ev) t(ev.event) end, { 'BufWinEnter', 'VimEnter', 'UIEnter' })
end

vim.cmd([[runtime vimrc]])

local require = require('nvim.util').xprequire

require('vim._extui').enable({})
require('snacks').setup(require('nvim.snacks'))

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function(...)
  Snacks.debug.backtrace(...)
end
_G.p = function(...)
  Snacks.debug.profile(...)
end
--- @diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

require('nvim')
