--- init.lua
local t_1 = vim.uv.hrtime()

--- optional LuaJIT profiling
--- `https://luajit.org/ext_profiler.html`
-- require('jit.p').start('ri1', '/tmp/prof')

--- overrides `loadfile()` and default nvim package loader
--- `https://github.com/neovim/neovim/discussions/36905`
-- vim.loader.enable()

--- `autoload/plug.vim` overrides vim-plug
--- `plug#end()` will `vim.pack.add` vim plugins
vim.cmd.source('vimrc')

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

_G.nv = require('nvim')

local elapsed = (vim.uv.hrtime() - t_1) / 1e6
vim.schedule(function() print('init.lua in ' .. elapsed .. 'ms') end)
-- require('jit.p').stop()
