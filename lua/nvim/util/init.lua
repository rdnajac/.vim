local M = {}

M.is_nonempty_string = function(x)
  return type(x) == 'string' and x ~= ''
end

M.is_nonempty_list = function(x)
  return vim.islist(x) and #x > 0
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

--- Iterates over all lua files in a subdirectory of a top-level module.
--- Requires each module and calls the callback with the module and its name.
M.for_each_submodule = function(topmod, subdir, callback)
  local path = vim.fs.joinpath(vim.g.lua_root, topmod, subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  for _, file in ipairs(files) do
    local modname = file:sub(#vim.g.lua_root + 2, -5)
    local ok, mod = pcall(require, modname)
    if ok and mod then
      callback(mod, modname)
    end
  end
end

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

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})
