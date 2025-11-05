local M = setmetatable({}, {
  __call = function(M, ...)
    return M.patch(...)
  end,
})

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

return M
