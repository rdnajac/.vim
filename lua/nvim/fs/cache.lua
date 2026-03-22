local fn = vim.fn
local cache_dir = fn.stdpath('cache')

---Run fn() and cache result, or load from cache if file exists.
---Tables are JSON-encoded; strings are split on newlines.
---@param path string cache file path (relative to stdpath.cache)
---@param func fun(): string|table function that returns data to cache
---@return string|table
return function(path, func)
  local fpath = fn.resolve(cache_dir .. '/' .. path)

  if fn.filereadable(fpath) == 1 then
    local raw = fn.readblob(fpath)
    local ok, decoded = pcall(vim.json.decode, raw)
    if ok then
      return decoded
    end
    return vim.split(raw, '\n')
  end

  local result = func()
  fn.mkdir(fn.fnamemodify(fpath, ':h'), 'p')

  if type(result) == 'table' then
    fn.writefile({ vim.json.encode(result) }, fpath)
  else
    fn.writefile(vim.split(result, '\n'), fpath)
  end

  return result
end
