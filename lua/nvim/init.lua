_G.nv = {}

nv.ui = require('nvim.ui') -- must be first
nv.fs = require('nvim.fs')
nv.keys = require('nvim.keys')
nv.lsp = require('nvim.lsp')
nv.treesitter = require('nvim.treesitter')
nv.util = require('nvim.util')

vim.iter(nv):each(function(k, v)
  if v.specs then
    Plug(v.specs)
  else
    print('No specs for ' .. k)
  end
end)

return nv
