local M = {}

-- Highlight groups for different log levels
-- 1 = DEBUG, 2 = INFO, 3 = WARN, 4 = ERROR
local groups = { 'Ok', 'More', 'Warning', 'Error' }
-- local groups = require('nvim.config.diagnostic').opts.signs.numhl

--- Override for vim.notify that provides additional highlighting
--- @param msg string
--- @param level vim.log.levels|nil
--- @param opts? table
M.notify = function(msg, level, opts)
  local hl = groups[level or 1] .. 'Msg'
  vim.api.nvim_echo({ { msg, hl } }, true, { err = level == vim.log.levels.ERROR })
end

M.setup = function()
  vim.notify = M.notify
  for level in string.gmatch('notify info warn error', '%S+') do
    Snacks.notify[level]('Notifier enabled!')
  end
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.notify(...)
  end,
})
