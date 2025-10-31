local M = {}

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

M.patch = function(mod, fun)
  package.preload[mod] = function()
    local mp = mod:gsub('%.', '/')
    local path = vim.api.nvim_get_runtime_file('lua/' .. mp .. '.lua', false)[1]
      or vim.api.nvim_get_runtime_file('lua/' .. mp .. '/init.lua', false)[1]
    if not path then
      error('Module ' .. mod .. ' not found')
    end
    local loader, err = loadfile(path)
    if not loader then
      error(err)
    end
    local orig = loader()
    fun(orig)
    return orig
  end
end

local prefixes = {
  'nvim.util',
  'nvim',
  'nvim.config',
  'nvim.plugins',
}

return setmetatable(M, {
  __index = function(t, k)
    for _, prefix in ipairs(prefixes) do
      local ok, mod = pcall(require, prefix .. '.' .. k)
      if ok then
        t[k] = mod
        return mod
      end
    end
    return nil
  end,
})
