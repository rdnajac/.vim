vim.loader.enable()
vim.cmd.runtime('vimrc')
-- vim.cmd.packadd('munchies')

---@type snacks.Config
local opts = {
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { replace_netrw = false, trash = true },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = false },
  quickfile = { enabled = true },
  -- picker = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = true },
}
require('snacks').setup(opts)

_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = require('nvim')

local ui2_opts = { msg = { targets = 'msg' } }
ui2_opts.msg.targsts = nv.ui.msg.targets
require('vim._core.ui2').enable(ui2_opts)

nv.on('PackChanged', {}, require('snackpack.build'))

--- @param plugs string|Snackpack|(string|Snackpack)[] list of plugins
_G.Plug = function(plugs)
  plugs = vim.islist(plugs) and plugs or { plugs }
  vim.pack.add(vim.iter(plugs):map(require('snackpack').new):totable(), {
    load = require('snackpack.load'),
    confirm = true,
  })
end

Plug(vim.g.plugs)
vim.cmd([[ color tokyonight ]])
