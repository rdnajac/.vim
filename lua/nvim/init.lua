_G.nv = require('nvim.util')

local _submodules = {
  'ui', -- should be first
  'fs',
  'keys',
  'lsp',
  'treesitter',
}

-- vim.iter(nv):each(function(_, v) Plug(v.specs) end)
vim.iter(ipairs(_submodules)):each(function(_, name)
  local mod = require('nvim.' .. name)
  if type(mod) == 'table' and mod.specs then
    Plug(mod.specs)
  end
  rawset(nv, name, mod)
end)

return nv
