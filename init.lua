vim.loader.enable()

require('snacks').setup({
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { replace_netrw = false, trash = true },
  image = { enabled = true },
  indent = { enabled = true },
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
_G.nv = require('nvim')
vim.cmd.runtime('vimrc')

nv.on('VimEnter', function()
  nv.ui['2'].setup()
  -- vim.cmd.colorscheme('tokyonight')
  vim.o.winbar = '%{%v:lua.nv.ui.winbar()%}'
  vim.fn['chromatophore#setup']()
end)
