local M = {}

local modname = function(path)
  local lua_start = path:find('/lua/')
  if not lua_start then
    return path
  end

  local mod_path = path:sub(lua_start + #'/lua/')
  local ret = mod_path:gsub('%.lua$', ''):gsub('/', '.'):gsub('^%.', ''):gsub('%.init$', '')
  return ret
end

-- M:init = function()

local this_source = debug.getinfo(1, 'S').source
local this_file = vim.fn.fnamemodify(this_source:sub(2), ':p')
local this_dir = vim.fn.fnamemodify(this_file, ':h')

---@param path string
---@param opts? vim.fs.dir.Opts
---@ret <string, table>
M.autorequire = function(dir, opts)
  local ret = {}
  for name, _ in vim.fs.dir(dir, opts) do
    local absolute_path = vim.fn.fnamemodify(dir .. '/' .. name, ':p')
    if absolute_path ~= this_file then
      local ok, mod = pcall(require, modname(absolute_path))
      if not ok then
        vim.notify(('Failed to load module: %s'):format(mod), vim.log.levels.WARN)
      else
        ret[name] = mod
      end
    end
  end
  return ret
end

return M
