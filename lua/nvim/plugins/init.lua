--- @module "which-key"

--- @class PluginToDo
--- @field after table<string, fun():nil>
--- @field commands table<string, fun():nil>
--- @field keys table<string, wk.Spec>
--- @field setup table<string, fun():nil>
--- @field specs string[]
local M = {
  commands = {},
  disabled = {},
  keys = {},
  specs = {},
  todo = {},
}

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field name string The plugin name, derived from [1]
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field commands? fun():nil Ex commands to create.
--- @field config? fun():nil Function to run to configure the plugin.
--- @field enabled? boolean|fun():boolean Whether the plugin is disabled.
--- @field keys? wk.Spec|fun():wk.Spec Key mappings to create.
--- @field opts? table|fun():table Options to pass to the plugin's `setup()`.
--- @field specs? string[] Additional plugin specs in `user/repo` format.
local Plugin = {}
Plugin.__index = Plugin

function Plugin:is_enabled()
  return nv.get(self.enabled) ~= false
end

--- @param t table
function Plugin.new(t)
  local self = setmetatable(t, Plugin)

  self.name = self[1]:match('[^/]+$'):gsub('%.nvim$', '')
  self.name = #self.name == 1 and self.name:lower() or self.name -- R.nvim

  return self
end

function Plugin:init()
  --__index?
  if self:is_enabled() then
    M.specs[#M.specs + 1] = self[1]
    if nv.is_nonempty_list(self.specs) then
      vim.list_extend(M.specs, self.specs)
    end

    -- add command function to queue
    if vim.is_callable(self.commands) then
      M.commands[self.name] = self.commands
    end

    -- add keys to queue
    -- PERF: beeeeg table
    local keys = nv.get(self.keys)
    if nv.is_nonempty_list(keys) then
      M.keys[self.name] = keys
    end

    M.todo[self.name] = function()
      return self:setup()
    end
  else
    table.insert(M.disabled, self.name)
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  local setup ---@type fun():nil
  if vim.is_callable(self.config) then
    setup = self.config
  else
    local opts = nv.get(self.opts)
    if type(opts) == 'table' then
      setup = function()
        require(self.name).setup(opts)
      end
    end
  end

  -- call setup
  if vim.is_callable(setup) then
    nv.did.setup[self.name] = pcall(setup)
  end

  -- call after
  if vim.is_callable(self.after) then
    nv.did.after[self.name] = pcall(self.after)
  end
end

-- - @type table<string, Plugin>
-- local plugins = {}
local dir = vim.fs.joinpath(nv.stdpath.config, 'lua', 'nvim', 'plugins')
-- HACK: ignore files starting with 'i'
local files = vim.fn.globpath(dir, '[^i]*.lua', false, true)

for _, path in ipairs(files) do
  local name = path:match('([^/]+)%.lua$')
  local mod = require('nvim.plugins.' .. name)
  for _, t in ipairs(vim.islist(mod) and mod or { mod }) do
    local P = Plugin.new(t)
    P:init()
  end
end

return M
