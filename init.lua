-- init.lua
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.file_explorer = 'oil' ---@type 'netrw'|'snacks'|'oil'
vim.g.loaded_netrw = vim.g.file_explorer ~= 'netrw' and 1 or nil

vim.loader.enable()

-- ui options [[
-- set these options first so it is apparent if vimrc overrides them
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'
-- also try `:options`

require('util').safe_require('vim._extui').enable({})
-- ]]

-- print and notify [[
_G.ddd = function(...)
  print(vim.inspect(...))
end

_G.nv = require('nvim')

vim.notify = nv.notify
_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end
vim.print = info
-- ]]

vim.cmd([[runtime vimrc]])
vim.cmd([[packadd vimline.nvim]])

_G.bt = Snacks.debug.backtrace
nv.plug.after('oil')
nv.plug.after('render-markdown')
require('nvim.config')
require('nvim.copilot')
-- vim:fdm=marker:fmr=[[,]]:fdl=0
