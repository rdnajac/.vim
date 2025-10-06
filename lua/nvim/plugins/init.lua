local M = {}

-- _G.nv = require('nvim.util')
M._specs = {}
M._after = {} ---@type table<string, fun():nil>
M._keys = {} ---@type table<string, table>
M._commands = {} ---@type table<string, fun():nil>

--- @generic T
--- @param field T|fun():T
--- @return T?
local resolve_value = function(field)
  return vim.is_callable(field) and field() or field
end

--- Convert user/repo string to vim.pack.Spec
--- @param user_repo string plugin (`user/repo`)
--- @param data? any
--- @return string|vim.pack.Spec
local to_spec = function(user_repo, data)
  if not nv.is_nonempty_string(user_repo) then
    return user_repo
  end

  local github_url = 'https://github.com/' .. user_repo .. '.git'
  local last_slash_pos = user_repo:find('[^/]+$') or 1
  local plugin_name = user_repo:sub(last_slash_pos)
  if plugin_name:sub(-5) == '.nvim' then
    plugin_name = plugin_name:sub(1, -6)
  end

  return {
    src = github_url,
    name = plugin_name,
    -- HACK: remove this when treesitter is no longer a special case
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
end

--- @class Plugin
--- @field [1]?
--- @field after? fun():nil
--- @field build? string|fun():nil
--- @field commands? fun():nil
--- @field config? fun():nil
--- @field enabled? boolean|fun():boolean
--- @field keys? wk.Spec|fun():wk.Spec
--- @field specs? string[]
--- @field opts? table|fun():table
--- TODO: can we get it from the spec instead?
--- @field name string The plugin name, derived from [1]
local Plugin = {}
Plugin.__index = Plugin

--- @param plugin table
function Plugin.new(plugin)
  local self = plugin

  local primary_spec = nv.is_nonempty_string(self[1]) and to_spec(self[1])
  if primary_spec then
    self.name = primary_spec.name
    self.specs = vim.list_extend(self.specs or {}, { primary_spec })
  else
    self.name = ''
  end

  if nv.is_nonempty_list(self.specs) then
    -- PERF: redundant to_spec call for [1]
    local resolved_specs = vim.tbl_map(to_spec, self.specs)
    vim.list_extend(M._specs, resolved_specs)
  end

  return setmetatable(self, Plugin)
end

M.Plug = Plugin.new

function Plugin:is_enabled()
  return resolve_value(self.enabled) ~= false
end

function Plugin:init()
  if self:is_enabled() then
    -- TODO: move setup to a lazyloader
    self:setup()

    if vim.is_callable(self.after) then
      M._after[self.name] = self.after
    end

    if vim.is_callable(self.commands) then
      M._commands[self.name] = self.commands
    end

    local keymaps = resolve_value(self.keys)
    if nv.is_nonempty_list(keymaps) then
      vim.list_extend(M._keys, keymaps)
    end
  else
    nv.did.disable[#nv.did.disable + 1] = self.name
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` if they exist.
function Plugin:setup()
  local setup_fn
  if vim.is_callable(self.config) then
    setup_fn = self.config
  else
    local options = resolve_value(self.opts)
    if type(options) == 'table' then
      setup_fn = function()
        require(self.name).setup(options)
      end
    end
  end
  if vim.is_callable(setup_fn) then
    nv.did.setup[self.name] = pcall(setup_fn)
  end
end

M.unloaded = function()
  local unloaded_names = {}
  for _, plugin_info in ipairs(vim.pack.get()) do
    if not plugin_info.active then
      unloaded_names[#unloaded_names + 1] = plugin_info.spec.name
    end
  end
  return unloaded_names
end

M.keys = require('nvim.config.keymaps')
M.commands = require('nvim.config.commands')
M.after = function()
  require('nvim.config.diagnostic')
  require('nvim.config.sourcecode').setup()
end

return M
