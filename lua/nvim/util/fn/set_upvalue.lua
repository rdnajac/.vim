local M = setmetatable({}, {
  __call = function(M, ...)
    return M.set_upvalue(...)
  end,
})

local get_upvalue = function(func, name)
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

function M.set_upvalue(func, name, value)
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
