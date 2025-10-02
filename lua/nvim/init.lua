vim.g.health = { style = 'float' }
-- for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
--   vim.g[provider] = 0 -- disable to silence warnings
-- end
_G.nv = require('nvim.util')
setmetatable(_G.nv, {
  __index = function(t, k)
    local mod = nv.xprequire('nvim.' .. k, false)
      or nv.xprequire('nvim.config.' .. k, false)
      or nv.xprequire('nvim.util.' .. k, false)
      or nv.xprequire('nvim.plugins.' .. k, false)
    rawset(t, k, mod)
    return mod
  end,
})

-- for loop to set nv[index] to each of the files in config
-- `autorequire` and add status funcs to namespace
-- make a table, plugins and add to that table -- using the Plugin 'class'
local Plug = nv.plug

for _, plugin in ipairs(nv.folke) do
  Plug(plugin)
end

local plugins = vim.tbl_map(function(path)
  return path:match('^.+/(.+).lua$')
end, vim.fn.globpath(nv.stdpath.config .. '/lua/nvim/plugins', '*', true, true))

for _, plugin in pairs(plugins) do
  print(plugin)
  Plug(nv[plugin])
end
Plug(nv.lsp)
Plug(nv.treesitter)
Plug({
  name = 'nvim_config',
  keys = nv.keymaps,
  commands = nv.commands,
  after = nv.autocmds,
  setup = function()
    nv.lazyload('set winbar=%{%v:lua.nv.winbar()%}', 'VimEnter')
  end,
})
