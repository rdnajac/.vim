_G.t = { vim.uv.hrtime() }

vim.loader.enable()

_G.track = require('nvim.util.track')

vim.cmd([[runtime vimrc]])

vim.o.winborder = 'rounded'
vim.o.cmdheight = 0
require('vim._extui').enable({})
require('snacks')

-- TODO: move to snacks
_G.dd = function(...)
  require('snacks.debug').inspect(...)
end
_G.bt = function(...)
  require('snacks.debug').backtrace(...)
end
_G.p = function(...)
  require('snacks.debug').profile(...)
end
--- @diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

require('nvim')

-- TODO: use profiler
track('init.lua')
-- TODO: how does LazyVim calculate startuptime?
