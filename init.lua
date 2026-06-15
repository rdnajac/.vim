vim.loader.enable()

require('snacks').setup({
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
  -- statuscolumn = require('munchies').statuscolumn,
  words = { enabled = true },
})

_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = require('nvim.util')
nv.ui = nv.submodule('nvim.ui')
nv.ui['2'].setup()

vim.cmd.runtime('vimrc')
nv.on('VimEnter', function() vim.cmd.colorscheme('tokyonight') end)
