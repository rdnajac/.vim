_G.nv = require('nvim.util')
nv.config = require('nvim.config')
nv.plugins = require('nvim.plugins')

local speclist = vim.tbl_map(function(user_repo)
  return {
    src = 'https://github.com/' .. user_repo .. '.git',
    -- HACK: remove this when treesitter defaults to `main`
    version = vim.startswith(user_repo, 'nvim-treesitter') and 'main' or nil,
  }
end, nv.plugins.specs)

vim.pack.add(speclist)

for _, setup in pairs(nv.plugins.todo) do
  setup()
end

nv.lazyload(function()
  for name, cmd in pairs(nv.plugins.commands) do
    nv.did.commands[name] = pcall(cmd)
  end
end, 'CmdLineEnter')
