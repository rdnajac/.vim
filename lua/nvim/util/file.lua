local M = {}

---@param path string
---@return string[]
M.lines = function(path) return vim.iter(io.lines(path)):totable() or {} end

---@param op function
---@param ... any
---@return any
local function safe_io(op, ...)
  local ok, res, err = pcall(op, ...)
  if not ok or not res then
    error('File operation failed: ' .. tostring(err or res))
  end
  return res
end

---@param path string
---@return string
M.read = function(path)
  local f = safe_io(io.open, path, 'r')
  local contents = safe_io(f.read, f, '*a')
  safe_io(f.close, f)
  return contents
end

---@param file string
---@param contents string
M.write = function(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = safe_io(io.open, file, 'w+')
  safe_io(fd.write, fd, contents)
  safe_io(fd.close, fd)
end

-- TODO:  vim.fn.writefile?
---@param path string
---@param lines string[]
M.write_lines = function(path, lines) M.write(path, table.concat(lines, '\n')) end

return M
