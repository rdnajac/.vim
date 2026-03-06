--- init.lua
local t_1 = vim.uv.hrtime()

vim.loader.enable() -- `https://github.com/neovim/neovim/discussions/36905`

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

_G.dd = require('nvim.util.debug').dd

 -- exposes global `Plug` lua function
 -- registers autocmd for build on install/update
require('plug')

-- the command `Plug` adds plugins to `g:plugs` (see `autoload/plug.vim`)
vim.cmd([[ source ~/.vim/vimrc | lua vim.pack.add(vim.g.plugs) ]])

vim.o.cmdheight = 0 -- XXX: unstable features!
-- BUG: ui2 freaks out if startup is interrupted
-- BUG: `msg` should inferred from cmdheight=0
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

vim
  .iter(require('nvim'))
  :map(function(_, v)
    -- vim.validate('submodule', v, 'table')
    if vim.is_callable(v.after) then
      vim.schedule(v.after)
    end
    dd()
    return v.specs
  end)
  -- :map(function(submodule) return submodule.specs end)
  :each(Plug) -- `vim.pack.add`s transformed plugins

local elapsed = (vim.uv.hrtime() - t_1) / 1e6
local msg = ('_init.lua_: Loaded in **%s** ms'):format(elapsed)
vim.schedule(function() print(msg) end)
