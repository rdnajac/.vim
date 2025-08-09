local M = {}

M.sep = package.config:sub(1, 1)
M.modname = require('meta.modname').modname
M.source = require('meta.source').source
M.safe_require = require('meta.require').safe
M.lazy_require = require('meta.require').lazy

-- -------------------------------------------------------------------------
-- Meta Module Loader
-- -------------------------------------------------------------------------

M.module = {}
M.module.__index = M.module

---@param source? string
function M.module.new(source)
  source = source or M.source()
  assert(type(source) == 'string' and source ~= '', 'Expected a valid string path')

  local stat = vim.uv.fs_stat(source)
  assert(stat, 'Path does not exist: ' .. source)

  local is_dir = stat.type == 'directory'

  return setmetatable({
    file = not is_dir and source or nil,
    dir = is_dir and source or vim.fn.fnamemodify(source, ':h'),
  }, M.module)
end

--- Load Lua modules from the same directory
---@param opts? vim.fs.dir.Opts
---@param lazy? boolean
---@param bail? boolean
---@return table<string, any>
function M.module:load(opts, lazy, bail)
  local modules = {}
  local self_file = self.file and vim.fn.resolve(self.file) or nil
  local base_prefix = M.modname(self.dir)

  for name in vim.fs.dir(self.dir, opts) do
    local full = self.dir .. '/' .. name
    local resolved = vim.fn.resolve(vim.fn.fnamemodify(full, ':p'))

    if not self_file or resolved ~= self_file then
      local mod = M.modname(resolved)
      if mod and mod ~= '' and not mod:find('%.%.$') then
        local key = mod
        if base_prefix and mod:sub(1, #base_prefix + 1) == base_prefix .. '.' then
          key = mod:sub(#base_prefix + 2)
        end
        modules[key] = mod
      end
    end
  end

  if lazy then
    return M.lazy_require(modules, bail)
  end

  local out = {}
  for k, mod in pairs(modules) do
    local value = M.safe_require(mod, bail)
    if value ~= nil then
      out[k] = value
    end
  end

  return out
end

-- Allow: local mods = M.module(source?)
setmetatable(M.module, {
  __call = function(_, source, opts)
    return M.module.new(source):load(opts)
  end,
})

return M
