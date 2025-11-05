-- fn/init.lua
-- build a table from all the files in this dir
-- each file returns a function, so lazily load them by
-- setting a metatable on the module table and the filename is the function
local M = {}

local function get_syn_name(line, col)
  return vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name')
end

M.is_nonempty_string = function(x)
  return type(x) == 'string' and x ~= ''
end

M.is_nonempty_list = function(x)
  return vim.islist(x) and #x > 0
end

--- @param subdir string subdirectory of `nvim/` to search
--- @return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local path = vim.fs.joinpath(vim.g.luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f)
    return f:sub(#vim.g.luaroot + 2, -5)
  end, files)
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
