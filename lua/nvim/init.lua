_G.nv = require('nvim.util')
nv.plugins = require('nvim.plugins')
local config = require('nvim.config')


vim.pack.add(nv.todo.specs)

for _, plugin in pairs(nv.plugins) do
  plugin:init() -- calls setup
end
nv.plugins(require('nvim.snacks')):init()

vim.schedule(function()
  for name, fn in pairs(nv.todo.after) do
    nv.did.after[name] = pcall(fn)
  end

  local wk = require('which-key')
  for name, keys in pairs(nv.todo.keys) do
    nv.did.keys[name] = wk.add(keys)
  end

  nv.lazyload(function()
    for name, cmd in pairs(nv.todo.commands) do
      nv.did.commands[name] = pcall(cmd)
    end
  end, 'CmdLineEnter')
end)

return nv
