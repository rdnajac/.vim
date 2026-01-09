vim.loader.enable()
if vim.env.PROF then
  require('folke.snacks.profiler')
end
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

_G.nv = require('nvim')

local specs = vim.iter(nv.specs):map(nv.plug):totable()
-- vim.print(specs)

vim.cmd([[runtime vimrc]]) -- Plug command adds urls to `g:plugs` global
vim.list_extend(nv.plug.specs, vim.g.plugs or {}) -- merge in global plugs
vim.pack.add(nv.plug.specs, { load = nv.plug.load }) -- install plugins

vim.schedule(function()
  require('which-key').add(nv.plug.get_keys())
  local toggles = vim.tbl_extend('force', nv.plug.toggles or {}, require('folke.snacks.toggles'))
  for key, opts in pairs(toggles) do
    Snacks.toggle.new(opts):map(key)
  end
end)
