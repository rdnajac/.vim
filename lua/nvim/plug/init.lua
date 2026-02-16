local M = {
  load = require('nvim.plug.load'),
  spec = require('nvim.plug.spec'),
}

setmetatable(M, {
  __call = function(_, t) return M.spec(t):pack() end,
})
return M
