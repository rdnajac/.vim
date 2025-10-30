-- fn/init.lua
-- build a table from all the files in this dir
-- each file returns a function, so lazily load them by
-- setting a metatable on the module table and the filename is the function
local M = {}

local function get_syn_name(line, col)
  return vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name')
end

return setmetatable(M, {
  __index = function(_, key)
    local ok, mod = pcall(require, 'nv.util.fn.' .. key)
    if ok then
      rawset(M, key, mod)
      return mod
    else
      return nil
    end
  end,
})
