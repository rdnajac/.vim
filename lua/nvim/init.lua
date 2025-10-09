_G.nv = require('nvim.util')
nv.config = require('nvim.config')
nv.plugins = require('nvim.plugins')

local speclist = vim.tbl_map(function(user_repo)
  return {
    src = 'https://github.com/' .. user_repo .. '.git',
    -- HACK: remove this when treesitter defaults to `main`
    version = vim.startswith(user_repo, 'nvim-treesitter') and 'main' or nil,
  }
end, nv.todo.specs)

vim.pack.add(speclist)

for _, plugin in pairs(nv.plugins) do
  plugin:setup()
end

vim.schedule(function()
  for name, fn in pairs(nv.todo.after) do
    nv.did.after[name] = pcall(fn)
  end

  nv.lazyload(function()
    for name, cmd in pairs(nv.todo.commands) do
      nv.did.commands[name] = pcall(cmd)
    end
  end, 'CmdLineEnter')
end)
