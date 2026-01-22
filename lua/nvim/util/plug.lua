---@class Plugin
---@field name string The plugin name as evaluated by `vim.pack`.
---@field data? any
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
local Plugin = { did_setup = false, enabled = true }
Plugin.__index = Plugin

function Plugin.new(...)
  local args = { ... }
  local t, str
  for _, arg in ipairs(args) do
    if type(arg) == 'table' then
      t = arg
    elseif type(arg) == 'string' then
      str = arg
    end
  end
  vim.validate('t', t, 'table')
  if not t[1] and str then
    t[1] = str
  end
  vim.validate('[1]', t[1], 'string')
  local self = setmetatable(t, Plugin)
  self.name = self[1]:match('[^/]+$') -- `repo` part of `user/repo`
  return self
end

local M = {}

---@class plugin.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field setup? fun():nil Setup function to call after loading the plugin.

--- Convert the `Plugin` to a `vim.pack.Spec` for use with `vim.pack`.
---@return vim.pack.SpecResolved|nil
function Plugin:tospec()
  return {
    src = nv.gh(self[1]),
    version = self.version or self.branch or nil,
    name = self.name or self[1]:match('[^/]+$'),
    data = self.data or {
      build = self.build,
      keys = self.keys,
      setup = function() return self:setup() end,
      toggles = self.toggles,
    },
  }
end

local aug = vim.api.nvim_create_augroup('2lazy4lazy', {})
---@param event string|string[]
---@param cb fun() the module's setup function with opts
local on_event = function(event, cb)
  vim.api.nvim_create_autocmd(event, {
    callback = cb,
    group = aug,
    -- TODO: handle User events and patterns
    -- nested = true,
    once = true,
  })
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  local function setup()
    if self.did_setup then
      return
    end
    local opts = vim.is_callable(self.opts) and self.opts() or self.opts
    if type(opts) == 'table' then
      local modname = self.name:gsub('%.nvim$', '')
      require(modname).setup(opts)
    elseif vim.is_callable(self.config) then
      self.config()
    else
      return
    end
    self.did_setup = true
  end
  return self.event and on_event(self.event, setup) or setup()
end

return setmetatable(M, {
  __call = Plugin.new,
})
