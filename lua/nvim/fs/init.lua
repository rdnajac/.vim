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

---@param filename string
---@return table
M.fpath_to_json = function(filename) return vim.json.decode(vim.fn.readblob(filename)) end

---@param contents string
---@param filename string
M.write_json = function(contents, filename)
  return vim.fn.writefile(vim.json.encode(contents, { indent = '\t', sort_keys = false }), filename)
end

M.cache = require('nvim.fs.cache')

function M.filesize()
  local size = vim.fn.getfsize(vim.fn.expand('%:p'))
  if size == -1 then
    error('file not found')
  elseif size == -2 then
    error('filesize too big to handle')
  end
  local prefixes = { '', 'K', 'M', 'G' }
  local i = 1
  while size > 1024 and i < #prefixes do
    size = size / 1024
    i = i + 1
  end

  local fmt = (i == 1 and '%d bytes' or '%.2f %sib')
  return string.format(fmt, size, prefixes[i])
end

M['goto'] = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = vim.fn.expand('<cfile>')
  vim.fn['edit#'](cfile)
  vim.cmd('normal! ' .. lineno .. 'G')
end

return M
