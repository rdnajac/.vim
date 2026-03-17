local M = {}

M.specs = {
  {
    'mason-org/mason.nvim',
    opts = {},
    -- TODO: implement one-time install func to hook into packinstall event 
    once = function() vim.cmd.MasonInstall(nv.util.tools()) end,
  },
  {
    'stevearc/oil.nvim',
    enabled = false,
    opts = {},
    keys = { { '-', '<Cmd>Oil<CR>' } },
  },
}

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

--- cache/read lines file in the cache directory,
--- or read lines from a file in the cache directory
---@param fname string filename relative to cache directory
---@param lines string[]|nil lines to write, or nil to read
---@return string[]? lines read from file or written to file
M.cache = function(fname, lines)
  local cache_path = vim.fs.joinpath(vim.g.stdpath.cache, fname)
  if lines == nil and vim.fn.filereadable(cache_path) then
    lines = vim.fn.readfile(cache_path)
  else
    vim.fn.mkdir(vim.fs.dirname(cache_path), 'p')
    vim.fn.writefile(lines, cache_path)
  end
  return lines
end

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
