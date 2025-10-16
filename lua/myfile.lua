local M = {}

local function safe_io(op, ...)
  local ok, res, err = pcall(op, ...)
  if not ok or not res then
    error('File operation failed: ' .. tostring(err or res))
  end
  return res
end

---@param file string
---@param contents string
M.writefile = function(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = safe_io(io.open, file, 'w+')
  safe_io(fd.write, fd, contents)
  fd:close()
end

---@param path string
---@return string[]
M.readlines = function(path)
  local f = safe_io(io.open, path, 'r')
  local lines = {}
  for line in f:lines() do
    lines[#lines + 1] = line
  end
  f:close()
  return lines
end

---@param path string
---@param lines string[]
M.writelines = function(path, lines)
  local f = safe_io(io.open, path, 'w')
  safe_io(f.write, f, table.concat(lines, '\n'))
  f:close()
end

---@param path string
---@return table
M.import_json = function(path)
  local f = safe_io(io.open, path, 'r')
  local t = vim.json.decode(safe_io(f.read, f, '*a'))
  f:close()
  return t
end

return M
