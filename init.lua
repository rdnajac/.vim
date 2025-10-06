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

require('vim._extui').enable({})
require('snacks')
-- require('nvim')
require('nvim.util').xprequire('nvim')
