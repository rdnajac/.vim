local M = {}

---@param path string
---@return string[]
M.lines = function(path)
  local iter = io.lines(path)
  return iter and vim.iter(iter):totable() or {}
end

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

---@param path string
---@param lines string[]
M.write_lines = function(path, lines)
  M.write(path, table.concat(lines, '\n'))
end

---@param path string
---@return table
M.read_json = function(path)
  return vim.json.decode(M.read(path))
end

M.write_json = function(path, tbl)
  M.write(path, vim.json.encode(tbl))
end

return M
