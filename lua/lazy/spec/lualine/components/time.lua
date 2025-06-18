local M = {}

M.clock = function()
  return ' ' .. os.date('%T')
end

M.date = function()
  return ' ' .. os.date('%F')
end

return M
