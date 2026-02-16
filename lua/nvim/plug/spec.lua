---@class plug.Spec
---@field [1] string Plugin identifier (GitHub owner/repo or name).
---@field name? string The plugin name as evaluated by `vim.pack`. Defaults to repo name.
---@field data? any Custom data to pass to `vim.pack.add()`.
---@field src? string Plugin source URL. Defaults to GitHub via `nv.gh()`.
---@field did_setup boolean Tracks if `setup()` has been called.
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
---@field keys? table Keymaps to bind for the plugin.
---@field opts? table|fun():table Options to pass to the plugin's `setup()`.
---@field version? string|vim.VersionRange Version constraint for the plugin.
---@field branch? string Git branch to use.
---@field toggles? table<string, string|fun()|table> Snacks.nvim toggles to register.
---@field event? string|string[] Autocommand event(s) to lazy-load on.
---@field dependencies? string|string[] Dependencies to load before this plugin.
---@field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
---@field init? fun():nil Called just before `packadd`ing the plugin.
local M = {}
M.__index = M

--- Create a new Plugin instance from a specification table.
---
--- @param v table Plugin specification with required `[1]` field.
--- @return plug.Spec
function M.new(v)
  local self = type(v) == 'table' and v or { v }
  vim.validate('[1]', self[1], 'string')
  vim.validate('keys', self.keys, vim.islist, true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('toggles', self.toggles, 'table', true)
  return setmetatable(self, M)
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field setup? fun():nil Setup function to call after loading the plugin.

--- Convert the `M` to a `vim.pack.Spec` for use with `vim.pack`.
---@return vim.pack.Spec
function M:pack()
  return {
    src = self.src or nv.gh(self[1]),
    version = self.version or self.branch or nil,
    name = self.name or self[1]:match('[^/]+$'),
    data = self.data or {
      build = self.build,
      init = self.init,
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

function M:modname()
  local name = self.name or self[1]:match('[^/]+$')
  return name:gsub('%.nvim$', '')
end

function M:register_keys()
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

--- Call the Plugin's configuration or setup function.
---
--- Executes the plugin's configuration in the following order:
--- 1. If `opts` is a function, calls it to get options
--- 2. If `opts` is a table, calls `require(modname).setup(opts)`
--- 3. If `config` is callable, calls it
--- 4. Registers keymaps and toggles
---
--- If `event` is specified, defers setup until the event fires.
--- Ensures setup runs only once via `did_setup` flag.
function M:setup()
  self.did_setup = false

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

  if self.event then
    on_event(self.event, _setup)
  else
    _setup()
  end
end

setmetatable(M, {
  __call = function(_, t) return M.new(t) end,
})
return M
