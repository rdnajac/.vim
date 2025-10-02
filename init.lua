_G.t = { vim.uv.hrtime() }

vim.loader.enable()

_G.track = require('nvim.util.track')

vim.cmd([[runtime vimrc]])

vim.o.winborder = 'rounded'
vim.o.cmdheight = 0
require('vim._extui').enable({})
require('snacks')

require('nvim')

-- TODO: use profiler
track('init.lua')
-- TODO: how does LazyVim calculate startuptime?
