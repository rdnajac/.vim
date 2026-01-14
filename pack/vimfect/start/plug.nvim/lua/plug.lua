local call = function(v) return vim.is_callable(v) and v() end
local get = function(v) return call(v) or v end

---@class Plugin
---@field name string The plugin name as evaluated by `vim.pack`.
---@field did_setup boolean Tracks if `setup()` has been called.
---@field enabled boolean Defaults to `true`.
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
---@field event? string|string[] Autocommand event(s) to lazy-load on.
---@field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
---@field keys? table|fun():table Keymaps to bind for the plugin.
---@field opts? table|fun():table Options to pass to the plugin's `setup()`.
---@field version? string|vim.VersionRange
---@field branch? string
---@field toggles? table<string, string|fun()|table>
local Plugin = { did_setup = false, enabled = true }
Plugin.__index = Plugin

function Plugin.new(t)
  vim.validate('t', t, 'table')
  vim.validate('[1]', t[1], 'string')
  t = require('nvim.lazy.sanitize')(t)
  local self = setmetatable(t, Plugin)
  self.name = self[1]:match('[^/]+$') -- `repo` part of `user/repo`
  return self
end

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
    data = {
      build = self.build,
      setup = function() return self:setup() end,
    },
  }
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  local function setup()
    if self.did_setup then
      return
    end
    local opts = get(self.opts)
    if type(opts) == 'table' then
      local modname = self.name:gsub('%.nvim$', '')
      require(modname).setup(opts)
    else -- opts likely nil, try calling config
      call(self.config)
    end
    self.did_setup = true
  end

  if self.event then
    require('nvim.lazy.load').on_event(self.event, setup)
  else
    setup()
  end
end

local plugins = {}
local keys = {}
local toggles = {}
local M = {}

function M.plug(t)
  local p = Plugin.new(t)

  if not p.enabled then
    return
  end

  local repo = p[1]
  plugins[repo] = p
  keys[repo] = p.keys
  for k, v in pairs(p.toggles or {}) do
    if toggles[k] ~= nil then
      Snacks.notify.warn(string.format('Toggle key %q already registered', k))
    end
    toggles[k] = v
  end
  return p:tospec()
end

M.add = function(repo)
  -- print('add: ' .. repo)
  table.insert(specs, nv.gh(repo))
end

M.keys = function() return vim.tbl_map(get, vim.tbl_values(keys)) end
M.toggles = function() return toggles end

---@param plug_data {spec: vim.pack.Spec, path: string}
function M.load(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
  if spec.data then
    call(spec.data.setup)
  end
end

return setmetatable(M, {
  __call = function(_, t) return M.plug(t) end,
  -- __index = function(t, k)
  -- if k == 'keys' then return
  -- end
})
