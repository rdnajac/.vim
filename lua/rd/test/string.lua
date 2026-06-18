local M = {}

M.capitalize = function(s) return s:gsub('^%l', string.upper) end
M.camelCase = function(s) return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper) end

return M
