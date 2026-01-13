local nv = require('nvim.util') -- exposes all util functions

-- collect specs
local specs = vim
  .iter({ 'blink', 'keymaps', 'lsp', 'mini', 'treesitter', 'plugins' })
  :map(function(v)
    nv[v] = require('nvim.' .. v)
    return nv[v].spec
  end)
  :flatten()
  :totable()

nv.specs = specs

return nv
