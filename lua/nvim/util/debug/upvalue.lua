local M = {}

M.get = function(func, name)
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      dd(n)
      return
    end
    i = i + 1
  end
  error('upvalue not found: ' .. name)
end

-- local func = Snacks.picker.local
-- get_upvalue(func, name)

function M.set(func, name, value)
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      debug.setupvalue(func, i, value)
      return
    end
    i = i + 1
  end
  error('upvalue not found: ' .. name)
end

return M
