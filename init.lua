_G.t = { vim.uv.hrtime() }

vim.loader.enable()

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

setmetatable(_G.t, {
  __call = require('nvim.util.track').log,
})

vim.cmd([[runtime vimrc]])

require('vim._extui').enable({})
require('snacks')
require('nvim')

nv.lazyload(function(ev)
  t(ev.event)
end, { 'BufWinEnter', 'VimEnter', 'UIEnter' })
