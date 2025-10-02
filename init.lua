_G.t = { vim.uv.hrtime() }

vim.loader.enable()

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
