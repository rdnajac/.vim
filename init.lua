vim.loader.enable()
-- require('nvim.util.track')

local _stdpath = {} -- PERF: cache stdpath results
for d in string.gmatch('cache config data state', '%S+') do
  _stdpath[d] = vim.fn.stdpath(d)
end
vim.g.stdpath = _stdpath
vim.g.plug_dir = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.g.lua_root = vim.fs.joinpath(vim.g.stdpath.config, 'lua')

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_dir, 'snacks.nvim'))
  ---@type snacks.profiler.Config
  local opts = { startup = { event = 'UIEnter' } }

  require('snacks.profiler').startup(opts)
end

--- loads vim settings and exports vim.g.plugins
vim.cmd([[runtime vimrc]])

-- the rest if the owl
require('nvim')
