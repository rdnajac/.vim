local fn = vim.fn

local M = {}

---@param file string path appended to `stdpath('cache')`
---@param content any string, table, or function returning string/table
---@return string[] the contents as written, or nil on failure
M.write = function(file, content)
  fn.mkdir(fn.fnamemodify(file, ':h'), 'p')
  content = vim.is_callable(content) and content() or content
  if type(content) == 'table' and not vim.islist(content) then
    content = vim.json.encode(content, { indent = '\t', sort_keys = false })
  end
  content = type(content) == 'string' and vim.split(content, '\n') or content
  return fn.writefile(content, file) == 0 and content or nil
end

---@param filename string
---@return table
M.readjson = function(filename) return vim.json.decode(fn.readblob(filename)) end

local cache_dir = fn.stdpath('cache')

-- TODO: see `$PACKDIR/tokyonight.nvim/lua/tokyonight/util.lua`
--- Run fn() and cache result, or load from cache if file exists.
--- Tables are JSON-encoded; strings are split on newlines.
---@param path string cache file path (relative to stdpath.cache)
---@param fun fun(): string|table function that returns data to cache
---@return string|table
M.cache = function(path, fun)
  local fpath = fn.resolve(cache_dir .. '/' .. path)
  if fn.filereadable(fpath) == 1 then
    local ok, decoded = pcall(M.readjson, fpath)
    return ok and decoded or fn.readfile(fpath)
  end
  return M.write(fpath, fun())
end

function M.filesize()
  local size = fn.getfsize(fn.expand('%:p'))
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
  local cfile = fn.expand('<cfile>')
  fn['edit#'](cfile)
  vim.cmd('normal! ' .. lineno .. 'G')
end

--- handles truncated paths in the debug.traceback like `.../path/to/file:line:`
---@param cfile? string defaults to `expand('<cfile>')`
M.better_gf = function()
  local cfile = vim.fn.expand('<cfile>')
  if vim.startswith(cfile, '...') then
    local file
    for dir, pattern in pairs({
      PACKDIR = '/core/opt/',
      VIMRUNTIME = '/nvim/runtime/',
    }) do
      local match = cfile:match('.*' .. pattern .. '(.*)')
      if match and match ~= '' then
        file = vim.fs.joinpath(vim.env[dir], match)
      end
      if file and vim.uv.fs_stat(file) then
        local line = vim.api.nvim_get_current_line()
        local line_num = line:match(':(%d+)')
        -- Close pager window and open file
        vim.cmd('close')
        vim.cmd.edit(file)
        if line_num then
          vim.cmd('normal! ' .. line_num .. 'G')
        end
        return
      end
    end
  end
  -- Fallback to normal gf
  vim.cmd('normal! gf')
end

return M
