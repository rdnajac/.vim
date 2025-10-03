_G.nv = require('nvim.util')

setmetatable(nv, {
  __index = function(t, k)
    print('Loading nvim.' .. k)
    for submod in ('. .config. .util. '):gmatch('%S+') do
      local mod = nv.xprequire('nvim' .. submod .. k, false)
      if mod then
        rawset(t, k, mod)
        return mod
      end
    end
  end,
})

require('nvim.plugins')
