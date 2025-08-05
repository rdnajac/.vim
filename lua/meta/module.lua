local M = {}
M.__index = M

--- Flexible constructor: pass a file or directory; if nil, uses the caller's source file
---@param source? string
function M.new(source)
  if not source then
    source = debug.getinfo(2, 'S').source:sub(2)
  end

  local path = vim.fn.fnamemodify(source, ':p')
  local is_dir = vim.fn.isdirectory(path) == 1

  return setmetatable({
    file = is_dir and nil or path,
    dir = is_dir and path or vim.fn.fnamemodify(path, ':h'),
  }, M)
end

--- Load all Lua modules in the same directory, excluding self.file
---@param opts? vim.fs.dir.Opts
---@return table<string, any>
function M:load(opts)
  local modules = {}
  local modname = require('util.path').modname
  local prefix_to_strip
  local self_file = self.file and vim.fn.resolve(self.file) or nil

  for name, _ in vim.fs.dir(self.dir, opts) do
    local path = self.dir .. '/' .. name
    local abs = vim.fn.fnamemodify(path, ':p')
    local resolved_abs = vim.fn.resolve(abs)

    if not self_file or resolved_abs ~= self_file then
      local mod = modname(abs)

      if mod and mod ~= '' and not mod:find('%.%.$') then
        if not prefix_to_strip then
          prefix_to_strip = mod:match('^(.*)%.') or ''
        end

        local key = mod
        if prefix_to_strip ~= '' and mod:sub(1, #prefix_to_strip + 1) == prefix_to_strip .. '.' then
          key = mod:sub(#prefix_to_strip + 2)
        end

        local ok, value = pcall(require, mod)
        if ok then
          modules[key] = value
        else
          vim.notify('Error loading module ' .. mod .. ': ' .. value, vim.log.levels.ERROR)
        end
      end
    end
  end

  return modules
end

return M
