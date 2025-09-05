--- Override for vim.notify that provides additional highlighting
---@param msg string
---@param level vim.log.levels|nil
---@param opts table|nil
---@diagnostic disable-next-line: unused-local opts
local M = function(msg, level, opts)
  local chunks = {
    {
      msg,
      level == vim.log.levels.DEBUG and 'Statement'
        or level == vim.log.levels.INFO and 'MoreMsg'
        or level == vim.log.levels.WARN and 'WarningMsg'
        or nil,
    },
  }
  vim.api.nvim_echo(chunks, true, { err = level == vim.log.levels.ERROR })
end

-- test if the override is working (should be colored blue)
-- Snacks.notify.info('init.lua loaded!')

return M
