local M = {}

-- add this module to the global namespace
_G.N = M

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.' .. k)
    return rawget(t, k)
  end,
})

-- override vim.notify to provide additional highlighting
-- vim.notify = require('nvim.notify')
vim.notify = N.notify

-- test if the override is working (should be colored blue)
vim.notify('init.lua loaded!', vim.log.levels.INFO, { title = 'Test Notification' })

return M
