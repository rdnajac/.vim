local M = {}

-- _G.nv = require('nvim.util')
_G.nv = setmetatable({}, {
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

Plug = require('nvim.util.plug')
Plug(nv['snacks'])

for _, plugin in ipairs({
  -- 'tokyonight',
  -- 'snacks',
  'mini',
  'oil',
}) do
  Plug(nv[plugin])
end

Plug(nv.blink)
Plug(nv.copilot)
Plug(nv.dial)
Plug(nv.lsp)
Plug(nv.r)
Plug(nv['render-markdown'])
Plug(nv.treesitter)
Plug(nv.tokyonight)

for _, plugin in ipairs(nv.folke) do
  Plug(plugin)
end

require('nvim.config')

return M
