local M = {}

local aug = vim.api.nvim_create_augroup('2lazu4lazy', {})

-- TODO: handle User events and patterns
---@param event string|string[]
function M.on_event(event, callback)
  vim.api.nvim_create_autocmd(event, {
    -- callback = callback,
    callback = function(ev)
      -- dd(ev)
      callback()
    end,
    group = aug,
    -- nested = true,
    once = true,
  })
end

-- setmetatable(M, {
--   __call = function(cb)
--     return M.on_event(require('nvim.lazy.file').events, cb)
--   end,
-- })

return M
