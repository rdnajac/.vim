vim.loader.enable()

local stdpath_dict = {}
vim.tbl_map(function(d)
  stdpath_dict[d] = vim.fn.stdpath(d)
end, { 'cache', 'config', 'data', 'state' })
vim.g.stdpath = stdpath_dict
vim.g.luaroot = vim.fs.joinpath(vim.g.stdpath.config, 'lua')
vim.g.plug_home = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')

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
hi link vimMap @keyword
" let s:me = resolve(expand('<sfile>:p')) | echom s:me
]])

-- the rest if the owl
require('nvim').init()
require('nvim.config')
