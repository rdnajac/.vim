local M = {}

local fn, uv = vim.fn, vim.uv

M.count_keys = function(t)
  local ret = {}
  for _, v in pairs(t) do
    if type(v) == 'table' then
      for key in pairs(v) do
        ret[key] = (ret[key] or 0) + 1
      end
    end
  end
  return ret
end

---@return string[]? lines nil when not in visual mode
M.get_visual = function()
  local vis_mode = fn.mode():match('[Vv\22]')
  if not vis_mode then
    return
  end
  return fn.getregion(fn.getpos('v'), fn.getpos('.'), { type = vis_mode })
end

-- Simple function to profile a lua function
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean}
M.profile = function(fn, opts)
  opts = opts or {}
  local start = uv.hrtime()
  for _ = 1, opts.count or 100, 1 do
    if opts.flush ~= false then
      jit.flush(fn, true)
    end
    fn()
  end
  vim.notify(((uv.hrtime() - start) / 1e6 / opts.count) .. 'ms', { title = 'Profile' })
end

M.upvalue = function(func, name, newvalue)
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      vim.notify('upvalue found: ' .. name .. ' = ' .. tostring(debug.getupvalue(func, i)))
      if newvalue then
        debug.setupvalue(func, i, newvalue)
        vim.notify('upvalue set: ' .. name)
      end
      return
    end
    i = i + 1
  end
  error('upvalue not found: ' .. name)
end

return M
