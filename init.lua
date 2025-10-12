vim.loader.enable()
-- require('nvim.util.track')

local _stdpath = {} -- PERF: cache stdpath results
for d in string.gmatch('cache config data state', '%S+') do
  _stdpath[d] = vim.fn.stdpath(d)
end
vim.g.stdpath = _stdpath
vim.g.luaroot = vim.fs.joinpath(vim.g.stdpath.config, 'lua')
vim.g.plugdir = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plugdir, 'snacks.nvim'))
  ---@type snacks.profiler.Config
  local opts = {
    -- startup = { event = 'UIEnter' },
  }
  require('snacks.profiler').startup(opts)
end

_G.dd = function(...)
  Snacks.debug.inspect(...)
  -- require('snacks.debug').inspect(...)
end
_G.bt = function(...)
  Snacks.debug.backtrace(...)
  -- require('snacks.debug').profile(...)
end
_G.p = function(...)
  Snacks.debug.profile(...)
  -- require('snacks.debug').backtrace(...)
end
--- @diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

--- loads vim settings and exports vim.g.plugins
vim.cmd([[runtime vimrc]])

-- These must be set before extui is enabled
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

-- the rest if the owl
require('nvim')
