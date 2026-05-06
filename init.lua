--- init.lua
vim.cmd([[source ~/.vim/vimrc]])
vim.cmd([[colorscheme tokyonight]])

_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end

require('snacks').setup({
  -- bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  explorer = { enabled = true },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  words = { enabled = true },
})

_G.nv = require('nvim')

require('vim._core.ui2').enable({ msg = { target = 'msg' } })
