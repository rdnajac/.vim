_G.t = { vim.uv.hrtime() }
_G.track = require('nvim.util.chrono').track
vim.g.transparent = true
vim.g.health = { style = 'float' }
-- for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
--   vim.g[provider] = 0 -- disable to silence warnings
-- end

vim.cmd([[runtime vimrc]])

vim.loader.enable()
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})
require('nvim')
track('init.lua')
