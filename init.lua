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
vim.cmd.runtime('vimrc')

require('nvim')
