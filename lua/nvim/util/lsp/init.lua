return setmetatable({}, {
  __index = function(t, k)
    t[k] = require('nvim.util.lsp.' .. k)
    -- return rawget(t, k)
    return t[k]
  end,
})
