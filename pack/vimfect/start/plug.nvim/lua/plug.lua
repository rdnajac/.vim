---@class Plugin
---@field name string The plugin name as evaluated by `vim.pack`.
---@field data? any
---@field src? string
---@field did_setup boolean Tracks if `setup()` has been called.
---@field enabled boolean Defaults to `true`.
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
---@field keys? table Keymaps to bind for the plugin.
---@field opts? table|fun():table Options to pass to the plugin's `setup()`.
---@field version? string|vim.VersionRange
---@field branch? string
---@field toggles? table<string, string|fun()|table>
---@field event? string|string[] Autocommand event(s) to lazy-load on.
---@field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
local Plugin = {
  did_setup = false,
  enabled = true,
}
Plugin.__index = Plugin

--- merge and convert dict-like k, v params
local function _resolve_self(...)
  local self = {}

  for i = 1, select('#', ...) do
    local v = select(i, ...)
    if type(v) == 'table' then
      self = vim.tbl_deep_extend('force', self, v)
    elseif type(v) == 'string' then
      self[1] = self[1] or v
    end
  end

  return self
end

-- -- FIXME: cannot use '...' outside a vararg function
-- local function _resolve_self_it(...)
--   return vim
--     .iter(1, select('#', ...))
--     :map(function(i) return select(i, ...) end)
--     :fold({}, function(acc, v)
--       v = type(v) == 'table' and v or { v }
--       return vim.tbl_deep_extend('force', acc, v)
--     end)
-- end

function Plugin.new(...)
  local self = _resolve_self(...)

  vim.validate('[1]', self[1], 'string')
  vim.validate('keys', self.keys, vim.islist, true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('toggles', self.toggles, 'table', true)

  return setmetatable(self, Plugin)
end

---@class plugin.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field setup? fun():nil Setup function to call after loading the plugin.

--- Convert the `Plugin` to a `vim.pack.Spec` for use with `vim.pack`.
---@return vim.pack.Spec
function Plugin:to_spec()
  return {
    src = self.src or nv.gh(self[1]),
    version = self.version or self.branch or nil,
    name = self.name or self[1]:match('[^/]+$'),
    data = self.data or {
      build = self.build,
      setup = function() return self:setup() end,
    },
  }
end

local aug = vim.api.nvim_create_augroup('2lazy4lazy', {})
--- execute a callback once at an event
---@param event string|string[]
---@param cb fun() the module's setup function with opts
local on_event = function(event, cb)
  vim.api.nvim_create_autocmd(event, {
    callback = cb,
    group = aug,
    -- nested = true,
    once = true,
  })
end

function Plugin:modname()
  local name = self.name or self[1]:match('[^/]+$')
  return name:gsub('%.nvim$', '')
end

function Plugin:register_keys()
  local _keys = require('nvim.keys')
  if self.keys then
    _keys.map(self.keys)
  end
  if self.toggles then
    for key, v in pairs(self.toggles) do
      _keys.map_snacks_toggle(key, v)
    end
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  local function _setup()
    if self.did_setup then
      return
    end
    local opts = vim.is_callable(self.opts) and self.opts() or self.opts
    if type(opts) == 'table' then
      require(self:modname()).setup(opts)
    elseif vim.is_callable(self.config) then
      self.config()
    end
    self:register_keys()
    self.did_setup = true
  end
  return self.event and on_event(self.event, _setup) or _setup()
end

---@param ... any
---@return vim.pack.Spec
local call = function(...) return Plugin.new(...):to_spec() end
local to_spec = function(plugins)
  return vim.iter(plugins):filter(function(_, v) return v.enabled ~= false end):map(call):totable()
end

---@param plug_data {spec: vim.pack.Spec, path: string}
local function _load(plug_data)
  vim.cmd.packadd({ plug_data.spec.name, bang = true })
  return vim.tbl_get(plug_data.spec, 'data', 'setup')()
end

return { to_spec = to_spec, _load = _load }
