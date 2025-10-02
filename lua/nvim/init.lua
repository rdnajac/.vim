local M = {}

_G.nv = require('nvim.util')
setmetatable(_G.nv, {
  __index = function(t, k)
    local ok, mod = pcall(require, 'nvim.config.' .. k)
    if ok then
      rawset(t, k, mod)
      return mod
    end
    mod = require('nvim.' .. k)
    rawset(t, k, mod)
    return mod
  end,
})

-- make a table, plugins and add to that table
-- using the Plugin 'class'
local Plug = require('nvim.util.plug')

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
Plug(nv.tokyonight)
Plug(nv.treesitter)

require('nvim.config')
-- for loop to set nv[index] to each of the files in config
-- `autorequire` and add status funcs to namespace

return M
