vim.loader.enable()
-- require('nvim.util.track')

local stdpath_dict = {}
vim.tbl_map(function(d)
  stdpath_dict[d] = vim.fn.stdpath(d)
end, { 'cache', 'config', 'data', 'state' })
vim.g.stdpath = stdpath_dict
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
vim.cmd([[
runtime vimrc

hi link vimMap @keyword
" hi link PmenuSel C
]])

-- the rest if the owl
require('nvim')
