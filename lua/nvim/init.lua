_G.nv = require('nvim.util')
nv.plugins = require('nvim.plugins')

-- plugins
nv.for_all_files('nvim', 'plugins', function(_, mod)
  for _, t in ipairs(vim.islist(mod) and mod or { mod }) do
  -- for _, t in ipairs(nv.ensure_list(mod)) do
    nv.plugins.Plug(t):init()
  end
end)

local speclist = vim.tbl_map(function(user_repo)
  return {
    src = 'https://github.com/' .. user_repo .. '.git',
    -- HACK: remove this when treesitter defaults to `main`
    version = vim.startswith(user_repo, 'nvim-treesitter') and 'main' or nil,
  }
end, nv.plugins.specs)

vim.list_extend(speclist, vim.g.plugins or {})

vim.pack.add(speclist)

-- Weird stuff happens when enabling extui before vim.pack.add
nv.config = require('nvim.config')

for _, setup in pairs(nv.plugins.todo) do
  setup()
end

return nv
