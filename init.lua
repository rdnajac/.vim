vim.loader.enable()
if vim.env.PROF then
  require('folke.snacks.profiler')
end
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

_G.nv = require('nvim')
_G.Plug = require('plug')

-- plug begin
vim.iter(nv.specs):each(Plug) --[[@as function]]
vim.cmd([[runtime vimrc]]) -- exposes `g:plugs`
-- vim.list_extend(Plug.specs, vim.g.plugs or {})

vim.pack.add(Plug.specs, { load = Plug.load })

-- plug end
vim.schedule(function()
  require('which-key').add(Plug.get_keys())
  local toggles = vim.tbl_extend('force', Plug.toggles or {}, require('folke.snacks.toggles'))
  for key, opts in pairs(toggles) do
    Snacks.toggle.new(opts):map(key)
  end
end)
