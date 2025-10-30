local M = setmetatable({}, {
  __call = function(M, ...)
    return M.source(...)
  end,
})

--- Returns the absolute file path of the first non-self caller.
--- @return string
M.source = function()
  local me = debug.getinfo(1, 'S')
  -- .source:sub(2) when to sub? @...
  local dir = vim.fs.dirname(me.source:sub(2))

  local i = 1
  while true do
    i = i + 1
    -- info and (info.source == me.source or info.source == '@' .. vim.env.MYVIMRC or info.what ~= 'Lua')
    local info = debug.getinfo(i, 'S')
    if not info then
      error('Could not `debug.getinfo()`')
    end

    local src = info.source
    -- source = vim.uv.fs_realpath(source) or source
    src = src:sub(1, 1) == '@' and src:sub(2) or src
    if not vim.startswith(src, dir) then
      return vim.fs.abspath(src)
    end
  end
  return src .. ':' .. info.linedefined
end

return M
