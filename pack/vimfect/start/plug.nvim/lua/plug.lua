local call = function(v) return vim.is_callable(v) and v() end
local get = function(v) return call(v) or v end

---@module 'snacks'

---@class Plugin
---@field [1] string The plugin name in `user/repo` format.
---@field enabled boolean Defaults to `true`.
---@field name string The plugin name as evaluated by `vim.pack`.
---@field did_setup? boolean Tracks if `setup()` has been called.
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field config? boolean|fun():nil Setup fun or, if true, mod.setup({})
---@field event? string |string[] Autocommand event(s) to lazy-load on.
---@field lazy? boolean Defaults to `false`. Load on `VimEnter` if `true`.
---@field keys? table|fun():table Keymaps to bind for the plugin.
---@field opts? table|fun():table Options to pass to the plugin's `setup()`.
---@field toggles? snacks.toggle.Opts[]|fun():snacks.toggle.Opts[]
---@field version? string Git tag or version to checkout.
---@field branch? string Git branch to checkout.
---@field data? any additional data to pass to `vim.pack.add()`
local Plugin = {
  did_setup = false,
  enabled = true,
}
Plugin.__index = Plugin

function Plugin.new(t)
  vim.validate('t', t, 'table')
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
    src = 'https://github.com/' .. self[1] .. '.git',
    version = self.version or self.branch or nil,
    name = self.name,
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

  if self.event then -- lazyload on autocmd
    -- print(self.name .. ' lazy loading on event: ' .. vim.inspect(self.event))
    require('nvim.lazy.load').on_event(self.event, setup)
  else
    setup()
  end
end

local M = { keys = {}, toggles = {}, specs = {} }

function M.plug(t)
  local plugin = Plugin.new(t)

  if not plugin.enabled then
    return
  end
  M[plugin.name] = plugin
  M.keys[plugin.name] = plugin.keys
  if plugin.toggles then
    M.toggles = vim.tbl_deep_extend('force', M.toggles, get(plugin.toggles))
  end
  table.insert(M.specs, plugin:tospec())

  return plugin
end

function M.get_keys() return vim.tbl_map(get, vim.tbl_values(M.keys)) end

---@param plug_data {spec: vim.pack.Spec, path: string}
function M.load(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
  if spec.data and vim.is_callable(spec.data.setup) then
    spec.data.setup()
  end
end

return setmetatable(M, {
  __call = function(_, t) return M.plug(t) end,
  -- TODO: __index should access the plugins table
  -- __index = function(t, k)
  -- if k == 'keys' then return
  -- end
})
