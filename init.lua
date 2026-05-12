--- init.lua
vim.cmd([[so ~/.vim/vimrc]])
vim.cmd([[colo tokyonight]])

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

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.nv = require('nvim')
