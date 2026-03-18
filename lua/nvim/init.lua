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
  end
  vim.keymap.set(
    'n',
    'gl' .. (k == 'util' and 'v' or k:sub(1, 1)),
    function() vim.fn['edit#luamod']('nvim/' .. k) end,
    { desc = 'Edit ' .. k }
  )
end)

return nv
