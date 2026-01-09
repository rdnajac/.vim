local M = {}

M.call = function(v)
  return vim.is_callable(v) and v()
end

M.get = function(v)
  return M.call(v) or v
end

return M
