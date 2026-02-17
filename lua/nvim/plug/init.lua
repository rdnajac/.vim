local M = {
  after = function()
    -- TODO: who sets this global??
    vim.env.PACKDIR = vim.g.PACKDIR
  end,
  load = require('nvim.plug.load'),
  spec = require('nvim.plug.spec'),
  specs = require('nvim._plugins'),
}

setmetatable(M, {
  __call = function(_, t) return M.spec(t):pack() end,
})
return M
