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
Plug(nv.blink)
Plug(nv.dial)
Plug(nv.lsp)
Plug(nv.markdown)
Plug(nv.mason)
Plug(nv.mini)
Plug(nv.oil)
Plug(nv.r)
Plug(nv.sidekick)
Plug(nv.tokyonight)
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
