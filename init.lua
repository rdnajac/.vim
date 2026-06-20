vim.loader.enable()
vim.cmd.runtime('vimrc')
require('snacks').setup({
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { replace_netrw = false, trash = true },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  --picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('munchies').statuscolumn,
  words = { enabled = true },
})

_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = require('nvim')

local opts = { msg = { targets = 'msg' } }
opts.msg.targsts = nv.ui.msg.targets
require('vim._core.ui2').enable(opts)

nv.on('PackChanged', '*', nv.pack.build) -- needed before the first vim.pack.add

--- @param plugs string|Snackpack|(string|Snackpack)[] list of plugins
_G.Plug = function(plugs)
  plugs = vim.islist(plugs) and plugs or { plugs }
  local to_spec = require('munchies.snackpack')
  local speclist = vim.iter(plugs):map(to_spec):totable()
  vim.pack.add(speclist, { load = nv.pack.load })
end

Plug(vim.g.plugs)
