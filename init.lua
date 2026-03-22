--- init.lua
vim.loader.enable()

vim.cmd([[ source ~/.vim/vimrc ]])

vim.o.cmdheight = 0
require('vim._core.ui2').enable({
  -- BUG: not inferred from cmdheight=0
  msg = { target = 'msg' },
})

require('snacks').setup({
  -- bigfile = { enabled = true },
  -- dashboard = require('munchies.dashboard'),
  explorer = { replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('munchies.notifier'),
  quickfile = { enabled = true },
  picker = require('munchies.picker'),
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('munchies.statuscolumn'),
  styles = { lazygit = { height = 0, width = 0 } },
  toggle = { which_key = false },
  words = { enabled = true },
})

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

require('nvim')

vim.iter(nv):each(function(k, v)
  if v.specs then
    Plug(v.specs)
  end
end)
