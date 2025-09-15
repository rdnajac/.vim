local M = {}

-- Highlight groups for different log levels
-- 1 = DEBUG, 2 = INFO, 3 = WARN, 4 = ERROR
local groups = { 'Statement', 'MoreMsg', 'WarningMsg' }

--- Override for vim.notify that provides additional highlighting
---@param msg string
---@param level vim.log.levels|nil
---@param opts table|nil
---@diagnostic disable-next-line: unused-local opts
M.notify = function(msg, level, opts)
  -- if error, index it out of bounds and hl = nil
  local hl = groups[level]
  opts = opts or {}
  opts.err = level == vim.log.levels.ERROR

  vim.api.nvim_echo({ { msg, hl } }, true, opts)
end

--- Override vim.notify with custom function
M.setup = function()
  vim.notify = M.notify
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.notify(...)
  end,
})
