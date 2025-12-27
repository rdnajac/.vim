local M = setmetatable({}, {
  __call = function(M, ...)
    return M.submodules(...)
  end,
})

---@param opts? {dir?: string, pattern?: string, level?: number}
---@return string[] files
function M.submodules(opts)
  opts = opts or {}
  local level = opts.level or 2
  local dir = opts.dir or vim.fs.dirname(debug.getinfo(level, 'S').source:sub(2))
  local pattern = opts.pattern or '*'
  local files = vim.fn.globpath(dir, pattern, false, true)

  return vim
    .iter(files)
    :filter(function(f)
      if vim.fn.isdirectory(f) == 1 then
        return vim.uv.fs_stat(f .. '/init.lua') ~= nil
      else
        return vim.endswith(f, '.lua') and not vim.endswith(f, 'init.lua')
      end
    end)
    :map(function(f)
      return vim.fn.fnamemodify(f, ':r:s?^.*/lua/??')
    end)
    :totable()
end

return M
