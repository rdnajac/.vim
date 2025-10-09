_G.nv = require('nvim.util')
nv.plugins = require('nvim.plugins')
local Plug = nv.plugins.Plug
Plug(require('nvim.snacks')):init()

nv.config = require('nvim.config')

local plugins = {}
local dir = nv.stdpath.config .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)

for _, path in ipairs(files) do
  local name = path:match('([^/]+)%.lua$')
  if name ~= 'init' then
    local ok, mod = pcall(require, 'nvim.plugins.' .. name)
    if ok and mod then
      for _, spec in ipairs(vim.islist(mod) and mod or { mod }) do
      -- for _, spec in ipairs(nv.ensure_list(mod)) do
        plugins[spec[1]] = Plug(spec)
      end
    end
  end
end

-- _G.nv = vim._defer_require('nvim', mods)

-- TODO: load func
vim.pack.add(nv.plugins._specs)

for _, plugin in pairs(plugins) do
  plugin:init() -- calls setup
end

vim.schedule(function()
  require('which-key').add(nv.plugins._keys)
  for name, fn in pairs(nv.plugins._after) do
    nv.did.after[name] = pcall(fn)
  end
  nv.lazyload(function()
    for name, cmd in pairs(nv.plugins._commands) do
      nv.did.commands[name] = pcall(cmd)
    end
  end, 'CmdLineEnter')
end)

return nv
