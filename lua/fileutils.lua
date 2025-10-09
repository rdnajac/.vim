--- Utility functions for file I/O operations

local M = {}

---@param file string
---@param contents string
M.writefile = function(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = assert(io.open(file, 'w+'))
  fd:write(contents)
  fd:close()
end

---@param path string
---@return string[]
M.readlines = function(path)
  local lines = {}
  local f = io.open(path, 'r')
  if f then
    for line in f:lines() do
      lines[#lines + 1] = line
    end
    f:close()
  end
  return lines
end

M.import_json = function(path)
  local f = assert(io.open(path, 'r'))
  local t = vim.json.decode(f:read('*a'))
  f:close()
  return t
end

return M
