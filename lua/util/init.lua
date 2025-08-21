local M = {}

M.sep = package.config:sub(1, 1)

-- does not normalize the path, that is the responsibility of the caller
M.modname = function(path)
  return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??')
end

--- Iterate over modules under $XDG_CONFIG_HOME/nvim/lua
---@param fn fun(modname: string)   -- callback with the module name (e.g. "plug.mini.foo")
---@param subpath? string           -- optional subpath inside lua/, e.g. "plug/mini"
---@param recursive? boolean        -- recurse into subdirs if true
function M.for_each_module(fn, subpath, recursive)
  local base = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
  subpath = subpath or ''
  local pattern = vim.fs.joinpath(subpath, (recursive and '**' or '*'))
  local files = vim.fn.globpath(base, pattern, false, true)

  for _, f in ipairs(files) do
    local mod = M.modname(f)
    -- if mod:sub(-5) ~= '/init' then
    if not vim.endswith(mod, '/init') then
      fn(mod)
    end
  end
end

return M
