-- -- init.lua

-- --- optional LuaJIT profiling
-- --- https://luajit.org/ext_profiler.html
-- -- require('jit.p').start('ri1', '/tmp/prof')

-- --- overrides `loadfile()` and default nvim package loader
-- --- https://github.com/neovim/neovim/discussions/36905
-- vim.loader.enable()

-- --- source vimrc
-- --- - `autoload/plug.vim` overrides vim-plug
-- --- - `plug#end()` will `vim.pack.add` vim plugins
-- vim.cmd([[ runtime vimrc ]])
vim.cmd.source('vimrc')

--- snack attack!
-- require('snacks')
-- assert(Snacks)
-- _G.dd = Snacks.debug.inspect
-- _G.bt = Snacks.debug.backtrace
-- _G.p = Snacks.debug.profile
if vim.env.PROF then
  local snacks = vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim'
  vim.opt.rtp:append(snacks)
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

_G.nv = require('nvim')

vim.pack.add(nv.specs, { load = nv.plug.load })

-- require('jit.p').stop()
