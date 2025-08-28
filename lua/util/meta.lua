local M = {}

M.sep = package.config:sub(1, 1)
M.modname = require('util.modname')
M.source = require('util.source')

M.module = {}
M.module.__index = M.module

---@param source? string
function M.module.new(source)
  source = source or M.source()
  -- TODO: use vim.validate
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
---@param bail? boolean
---@return table<string, any>
function M.module:load(opts)
  local modules = {}
  local self_file = self.file and vim.fn.resolve(self.file) or nil
  local base_prefix = M.modname(self.dir)

  -- TODO: use vim.fn.globpath?
  for name in vim.fs.dir(self.dir, opts) do
    local full = self.dir .. '/' .. name
    -- basename?
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

  local ret = {}

  for k, module in pairs(modules) do
    local ok, mod = pcall(require, module)
    if ok then
      ret[k] = mod
    end
  end

  return ret
end

setmetatable(M.module, {
  __call = function(_, source, opts)
    return M.module.new(source):load(opts)
  end,
})

return M
