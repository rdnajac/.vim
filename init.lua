vim.loader.enable()

-- local munchies = require('munchies')
require('snacks').setup(vim.tbl_extend('keep', munchies or {}, {
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  image = { enabled = true },
  indent = { enabled = true }, -- TODO: native intent guides
  input = { enabled = true },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = require('munchies').statuscolumn,
  words = { enabled = true },
}))

_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = require('nvim.util') -- expose util as global for easy access
vim.cmd.runtime('vimrc') -- load vimrc for legacy plugins and settings

nv.ui = nv.submodule('nvim.ui')

nv.ui['2'].setup()

vim.o.exrc = true
