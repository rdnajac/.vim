local M = {}

-- Highlight groups for different log levels
-- 1 = DEBUG, 2 = INFO, 3 = WARN, 4 = ERROR
local groups = { 'Ok', 'More', 'Warning', 'Error' }

--- Override for vim.notify that provides additional highlighting
--- @param msg string
--- @param level vim.log.levels|nil
--- @param opts table|nil
M.notify = function(msg, level, opts)
  vim.api.nvim_echo(
    { { msg, groups[level or 1] .. 'Msg' } },
    true,
    { err = level == vim.log.levels.ERROR }
  )
end

M.setup = function()
  vim.notify = M.notify
  Snacks.notify('Notifier enabled')
  -- Snacks.notify.info('Notifier enabled')
  -- Snacks.notify.warn('Notifier enabled')
  -- Snacks.notify.error('Notifier enabled')
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.notify(...)
  end,
})
