--- init.lua
vim.loader.enable()
vim.cmd([[so ~/.vim/vimrc]])

require('snacks').setup({
  -- bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  explorer = { enabled = true },
  image = { enabled = true },
  -- TODO: native intent guides
  indent = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  words = { enabled = true },
})

_G.dd = Snacks and Snacks.debug.inspect or vim.print
_G.bt = Snacks and Snacks.debug.backtrace or require('nvim.util.debug').trace

_G.nv = require('nvim')
