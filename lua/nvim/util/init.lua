local M = vim.defaulttable(function(k)
  return require('nvim.util.' .. k)
end)

M.sep = package.config:sub(1, 1)

-- stylua: ignore start
M.is_nonempty_string = function(x) return type(x) == 'string' and x ~= '' end
M.is_nonempty_list = function(t) return vim.islist(t) and #t > 0 end
M.modname = function(path) return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??') end
--stylua: ignore end

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
    if not vim.endswith(mod, '/init') then
      fn(mod)
    end
  end
end

--- Returns the file path of the first non-self caller.
---@return string|nil
M.source = function()
  local self_path = debug.getinfo(1, 'S').source:sub(2)
  local self_dir = vim.fn.fnamemodify(self_path, ':h')

  local i = 2
  while true do
    local info = debug.getinfo(i, 'S')
    if not info then
      return nil
    end

    local src = info.source
    if src:sub(1, 1) == '@' then
      local abs = vim.fn.fnamemodify(src:sub(2), ':p')
      if not vim.startswith(abs, self_dir) then
        return abs
      end
    end
    i = i + 1
  end
end

return M
