_G.t = { vim.uv.hrtime() }

vim.loader.enable()
require('nvim.util.track')
---@diagnostic disable-next-line: duplicate-set-field
function vim.print(...)
  return vim._print(true, ...)
end

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
  let s:me = resolve(expand('<sfile>:p'))
  " echom s:me
]])

-- the rest if the owl
require('nvim').init()
vim.pack.add({ vim.fn['git#url']('LazyVim/LazyVim') }, { load = false })
-- require('nvim.util.git.extmarks')
require('nvim.util.netrw').setup()
