local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.' .. k)
    return rawget(t, k)
  end,
})

_G.N = M

return M
