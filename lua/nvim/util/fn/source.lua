local M = setmetatable({}, {
  __call = function(M, ...)
    return M.source(...)
  end,
})

--- Returns the absolute file path of the first non-self caller.
--- @return string
M.source = function()
  local self_path = debug.getinfo(1, 'S').source:sub(2)
  local self_dir = vim.fs.dirname(self_path)

  local i = 2
  while true do
    local info = debug.getinfo(i, 'S')
    if not info then
      error('Could not `debug.getinfo()`')
    end

    local src = info.source
    src = src:sub(1, 1) == '@' and src:sub(2) or src
    if not vim.startswith(src, self_dir) then
      return vim.fs.abspath(src)
    end
    i = i + 1
  end
end

return M
