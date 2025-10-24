local M = {}

--- @generic T
--- @param x T|fun():T
--- @return T
M.get = function(x)
  return type(x) == 'function' and x() or x
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

local aug = vim.api.nvim_create_augroup('LazyLoad', {})
--- Lazy-load a function on its event or on UIEnter by default.
--- Runs the callback once and then deletes the autocmd.
-- TODO:  fix this signature
---@param cb fun(ev?: vim.api.autocmd.callback.args)  Callback when the event fires.
---@param event? string|string[] The Neovim event(s) to watch (default: VimEnter)
---@param pattern? string|string[] Optional pattern for events like FileType
M.lazyload = function(cb, event, pattern)
  vim.api.nvim_create_autocmd(event or 'VimEnter', {
    callback = type(cb) == 'function' and cb or function()
      vim.cmd(cb)
    end,
    group = aug,
    nested = true,
    once = true,
    pattern = pattern and pattern or '*',
  })
end

M.hotfix = function(mod, fun)
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
