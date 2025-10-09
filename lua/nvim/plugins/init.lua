_G.nv = _G.nv or {}
_G.nv.todo = {
  specs = {},
  after = {},
  commands = {},
  keys = {},
}

--- @module "which-key"

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field name string The plugin name, derived from [1]
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field commands? fun():nil Ex commands to create.
--- @field config? fun():nil Function to run to configure the plugin.
--- @field enabled? boolean|fun():boolean Whether the plugin is disabled.
--- @field keys? wk.Spec|fun():wk.Spec Key mappings to create.
--- @field specs? string[] Additional plugin specs in `user/repo` format.
--- @field opts? table|fun():table Options to pass to the plugin's `setup()`.

local Plugin = {}
Plugin.__index = Plugin

function Plugin:is_enabled()
  return nv.get(self.enabled) ~= false
end

--- @param t table
function Plugin.new(t)
  local self = setmetatable(t, Plugin)

  self.name = self[1]:match('[^/]+$'):gsub('%.nvim$', '')
  -- handle 'R.nvim'
  self.name = #self.name == 1 and self.name:lower() or self.name

  self.specs = self.specs or {}
  vim.list_extend(self.specs, { self[1] })

  if self:is_enabled() then
    vim.list_extend(nv.todo.specs, self.specs)
  end

  return self
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  if self:is_enabled() then
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
      nv.todo.after[self.name] = self.after
    end

    -- add command function to queue
    if vim.is_callable(self.commands) then
      nv.todo.commands[self.name] = self.commands
    end

    -- add keys to queue
    local keys = nv.get(self.keys)
    if nv.is_nonempty_list(keys) then
      nv.todo.keys[self.name] = keys
    end
  else
    nv.did.disable[#nv.did.disable + 1] = self.name
  end
end

--- @type table<string, Plugin>
local plugins = {}
local dir = vim.fs.joinpath(nv.stdpath.config, 'lua', 'nvim', 'plugins')
-- HACK: ignore files starting with 'i'
local files = vim.fn.globpath(dir, '[^i]*.lua', false, true)

for _, path in ipairs(files) do
  local name = path:match('([^/]+)%.lua$')
  local ok, mod = pcall(require, 'nvim.plugins.' .. name)
  if ok and mod then
    for _, t in ipairs(vim.islist(mod) and mod or { mod }) do
      plugins[t[1]] = Plugin.new(t)
    end
  end
end

return plugins
