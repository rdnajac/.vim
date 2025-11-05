return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.' .. k)
    return t[k]
  end,
})
