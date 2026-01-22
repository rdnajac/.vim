-- TODO: register notify setup
local M = setmetatable({}, {
  __call = function(t, ...) return t.notify(...) end,
  __index = function(t, k)
    if k == 'warn' or k == 'info' or k == 'error' then
      local fn = function(msg, opts)
        return t.notify(
          msg,
          vim.tbl_extend('keep', { level = vim.log.levels[k:upper()] }, opts or {})
        )
      end
      rawset(t, k, fn)
      return fn
    end
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

M.setup = function(opts)
  opts = opts or {}
  vim.notify = M.notify
  if opts.verbose == true then
    for level in string.gmatch('notify info warn error', '%S+') do
      Snacks.notify[level]('Notifier enabled!')
    end
  end
end

local goto_file = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = vim.fn.expand('<cfile>')
  vim.cmd(([[split +%s %s]]):format(lineno, cfile))
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'pager',
  group = aug,
  callback = function()
    vim.treesitter.start(0, 'lua')
    vim.keymap.set('n', '<CR>', goto_file, { buffer = true, desc = 'Go to file under cursor' })
  end,
})

return M
