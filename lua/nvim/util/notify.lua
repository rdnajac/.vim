-- TODO: register notify setup
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.notify(...)
  end,
})

-- Highlight groups for different log levels
-- 1 = DEBUG, 2 = INFO, 3 = WARN, 4 = ERROR
local groups = { 'Ok', 'More', 'Warning', 'Error' }

--- Override for vim.notify that provides additional highlighting
--- @param msg string
--- @param level? vim.log.levels|nil
--- @param opts? table
M.notify = function(msg, level, opts)
  vim.api.nvim_echo(
    { { msg, groups[level or 1] .. 'Msg' } },
    true,
    { err = level == vim.log.levels.ERROR }
  )
end

---@param msg string|string[]
---@param opts? snacks.notify.Opts
function M.snacks_notify(msg, opts)
  opts = opts or {}
  local notify = vim[opts.once and 'notify_once' or 'notify'] --[[@as fun(...)]]
  notify = vim.in_fast_event() and vim.schedule_wrap(notify) or notify
  msg = type(msg) == 'table' and table.concat(msg, '\n') or msg --[[@as string]]
  msg = vim.trim(msg)
  opts.title = opts.title or 'Snacks'
  return notify(msg, opts.level, opts)
end

vim.tbl_map(function(level)
  M[level] = function(msg, opts)
    return M.notify(msg, vim.tbl_extend('keep', { level = vim.log.levels[level] }, opts or {}))
  end
end, { 'warn', 'info', 'error' })

M.setup = function()
  vim.notify = M.notify
  for level in string.gmatch('notify info warn error', '%S+') do
    Snacks.notify[level]('Notifier enabled!')
  end
end

return M
