_G.nv = require('nvim.util')
nv.plugins = require('nvim.plugins')

nv.for_each_submodule('nvim', 'plugins', function(m, name)
  for _, t in ipairs(vim.islist(m) and m or { m }) do
    nv.plugins.Plug(t):init()
  end
end)

vim.pack.add(vim.tbl_map(function(user_repo)
  local spec = { src = 'https://github.com/' .. user_repo .. '.git' }
  -- HACK: remove this once default branches become `main`
  spec.version = vim.startswith(user_repo, 'nvim-treesitter') and 'main' or nil
  return spec
end, vim.list_extend(nv.plugins.specs, vim.g.plugins or {})))

-- Weird stuff happens if extui enabled before vim.pack.add
-- but it should be loaded before the plugins' setup functions
nv.config = require('nvim.config')

for _, setup in pairs(nv.plugins.todo) do
  setup()
end

return nv
