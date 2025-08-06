local meta = require('meta')

local M = {}
M.__index = M

---@param source? string
function M.new(source)
  source = source or meta.source()
  assert(type(source) == 'string' and source ~= '', 'Expected a valid string path')

  local stat = vim.uv.fs_stat(source)
  assert(stat, 'Path does not exist: ' .. source)

  local is_dir = stat.type == 'directory'

  return setmetatable({
    file = not is_dir and source or nil,
    dir = is_dir and source or vim.fn.fnamemodify(source, ':h'),
  }, M)
end

local meta = require('meta')

local M = {}
M.__index = M

---@param source? string
function M.new(source)
  source = source or meta.source()
  assert(type(source) == 'string' and source ~= '', 'Expected a valid string path')

  local stat = vim.uv.fs_stat(source)
  assert(stat, 'Path does not exist: ' .. source)

  local is_dir = stat.type == 'directory'

  return setmetatable({
    file = not is_dir and source or nil,
    dir = is_dir and source or vim.fn.fnamemodify(source, ':h'),
  }, M)
end

--- Load Lua modules from the same directory
---@param opts? vim.fs.dir.Opts
---@param lazy? boolean
---@param bail? boolean
---@return table<string, any>
function M:load(opts, lazy, bail)
  local modules = {}
  local self_file = self.file and vim.fn.resolve(self.file) or nil
  local base_prefix = meta.modname(self.dir)

  for name in vim.fs.dir(self.dir, opts) do
    local full = self.dir .. '/' .. name
    local resolved = vim.fn.resolve(vim.fn.fnamemodify(full, ':p'))

    if not self_file or resolved ~= self_file then
      local mod = meta.modname(resolved)
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
    return meta.lazy_require(modules, bail)
  end

  local out = {}
  for k, mod in pairs(modules) do
    local value = meta.safe_require(mod, bail)
    if value ~= nil then
      out[k] = value
    end
  end

  return out
end

-- Allow: local mods = require('meta.module')(source?)
return setmetatable(M, {
  __call = function(_, source, opts)
    return M.new(source):load(opts)
  end,
})
