_G.nv = require('nvim.util')
nv.plugins = require('nvim.plugins')

local speclist = vim.tbl_map(function(user_repo)
  return {
    src = 'https://github.com/' .. user_repo .. '.git',
    -- HACK: remove this when treesitter defaults to `main`
    version = vim.startswith(user_repo, 'nvim-treesitter') and 'main' or nil,
  }
end, nv.plugins.specs)

vim.list_extend(speclist, vim.g.plugins or {})

vim.pack.add(speclist)

-- These need to be set before extui is enabled
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
-- Weird stuff happens when this is enabled before vim.pack.add
require('vim._extui').enable({})

for _, setup in pairs(nv.plugins.todo) do
  setup()
end

-- defer loading the commands

local wk = require('which-key')
-- TODO: combine
-- local bigkeys = vim.tbl_map(function(t)
-- return t end, nv.plugins.keys)
for name, keys in pairs(nv.plugins.keys) do
  nv.plugins.did.keys[name] = pcall(wk.add, keys)
end

-- defer configs
vim.schedule(function()
  local dir = vim.fs.joinpath(vim.g.lua_root, 'nvim', 'config')
  local files = vim.fn.globpath(dir, '*.lua', false, true)
  for _, file in ipairs(files) do
    local modname = file:sub(#vim.g.lua_root + 2, -5)
    require(modname).setup()
  end
end)

return nv
