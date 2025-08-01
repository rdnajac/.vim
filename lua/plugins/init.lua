local M = {}

---@type vim.pack.Spec[]
M.specs = {}

---@type table<string, PlugSpec>
M.plugins = {}

-- Path utils
local this_source = debug.getinfo(1, 'S').source
local this_file = vim.fn.fnamemodify(this_source:sub(2), ':p')
local this_dir = vim.fn.fnamemodify(this_file, ':h')

local function add_spec(spec)
  if spec ~= nil then
    table.insert(M.specs, spec)
  end
end

-- Discover plugin files and directories in this_dir
---@param path string
---@param opts? vim.fs.dir.Opts
local function import(path, opts)
  for name, _ in vim.fs.dir(path, opts) do
    local absolute_path = vim.fn.fnamemodify(path .. '/' .. name, ':p')
    if absolute_path ~= this_file then
      local mod = require('nvim.util.path').modname(absolute_path)
      local ok, result = pcall(function()
        local spec, module = require('nvim.plug').load(mod)
        return { spec = spec, module = module }
      end)
      if not ok then
        vim.notify(('Failed to load plugin module "%s": %s'):format(mod, result), vim.log.levels.WARN)
      elseif result.module then
        local spec = result.spec
        local module = result.module
        M.plugins[spec and spec.name or mod:match('[^%.]+$')] = module

        add_spec(spec)

        if module and type(module) == 'table' then
          if type(module.dependencies) == 'table' then
            for _, dep in ipairs(module.dependencies) do
              add_spec(dep)
            end
          end
        end
      end
    end
  end
end

import(this_dir, { depth = 1 })

return M
