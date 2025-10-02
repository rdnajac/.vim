_G.nv = require('nvim.util')

setmetatable(nv, {
  __index = function(t, k)
    for submod in ('. .config. .util. .plugins.'):gmatch('%S+') do
      local mod = nv.xprequire('nvim' .. submod .. '.' .. k, false)
      if mod then
        rawset(t, k, mod)
        return mod
      end
    end
  end,
})

local Plug = nv.plug

for _, spec in ipairs(nv.plugins) do
  Plug(spec)
end

-- TODO: replace with lualine...
vim.schedule(function()
  vim.o.winbar = '%{%v:lua.nv.winbar()%}'
end)

t('nvim required!')
