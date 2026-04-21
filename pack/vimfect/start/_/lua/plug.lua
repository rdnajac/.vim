vim.api.nvim_create_autocmd('PackChanged', {
  callback = require('plug.build'),
  group = 'plug.nvim',
})

---@class Plugin
---@field [1] string `owner/repo`
---@field src? string derived from [1] if missing
---@field name? string derived from [1] if missing
---@field version? string|vim.VersionRange
---@field branch? string alias for `version`
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field init? fun():nil
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field keys? table|fun():table flexible keymap definitions
---@field toggle? table<string, table> Snacks.nvim toggles to register.
local Plugin = {}
Plugin.__index = Plugin

--- Create a new Plugin instance from a specification table.
---@param v string|table table with required `[1]` field (or just `user/repo`
---@return Plugin
function Plugin.new(v)
  local self = type(v) == 'table' and v or { v } ---@type Plugin
  vim.validate('[1]', self[1], 'string')
  vim.validate('build', self.build, { 'string', 'function' }, true)
  vim.validate('init', self.init, 'function', true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('keys', self.keys, { 'table', 'function' }, true)
  vim.validate('toggle', self.toggle, 'table', true)
  -- add required fields and defaults
  self.src = self.src or ('https://github.com/%s.git'):format(self[1])
  self.name = self.name or (self[1]):match('[^/]*$')
  self.version = self.version or self.branch or nil
  return setmetatable(self, Plugin)
end

-- gets a value that may be the result of a function or a static value
local function resolve(v) return vim.is_callable(v) and v() or v end

--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- The module name is just the plugin name without a `.nvim` suffix, if present.
function Plugin:setup()
  if self.init then
    self.init()
  else
    local opts = resolve(self.opts)
    if type(opts) == 'table' then
      require(self.name:gsub('%.nvim$', '')).setup(opts)
    end
  end
  -- assuming keys are a list of { mode, lhs, rhs, opts? } or a function returning such a list
  local keys = resolve(self.keys)
  if vim.islist(keys) then
    vim.iter(keys):map(unpack):each(vim.keymap.set)
  end
  if self.toggle and Snacks then
    vim.iter(self.toggle):each(function(k, v) Snacks.toggle.new(v):map(k) end)
  end
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil called inside of the `load()` function, after `packadd()`.

--- Convert the plugin to a format compatible with `vim.pack.add()`.
---@return vim.pack.Spec
function Plugin:package()
  return {
    src = self.src,
    name = self.name,
    version = self.version,
    ---@type plug.Data
    data = {
      build = self.build,
      init = function() self:setup() end,
    },
  }
end

--- Wraps instantiation, initialization, and conversion, skipping disabled plugins.
---@param plugs string|Plugin|(string|Plugin)[]  list of plugin specs or single spec (string or table)
_G.Plug = function(plugs)
  local speclist = vim
    .iter(vim.islist(plugs) and plugs or { plugs })
    :filter(function(v) return v.enabled ~= false end)
    :map(function(v) return Plugin.new(v):package() end)
    :totable()

  vim.pack.add(speclist, {
    ---@param plug_data {spec: vim.pack.Spec, path: string}
    load = function(plug_data)
      local spec = plug_data.spec
      vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
      local init = vim.tbl_get(spec, 'data', 'init')
      if vim.is_callable(init) then
        init()
      end
    end,
  })
end
