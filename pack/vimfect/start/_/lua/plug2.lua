vim.api.nvim_create_autocmd('PackChanged', {
  callback = require('plug.build'),
  group = 'plug.nvim',
})

-- gets a value that may be the result of a function or a static value
local function resolve(v) return vim.is_callable(v) and v() or v end

---@class plug.Spec
---@field [1] string `owner/repo`
---@field src? string derived from [1] if missing
---@field name? string derived from [1] if missing
---@field mod? string require name, derived from `name` if missing
---@field version? string|vim.VersionRange
---@field branch? string alias for `version`
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field init? fun():nil
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field keys? table|fun():table flexible keymap definitions
---@field toggle? table<string, table> Snacks.nvim toggles to register.
---@field enabled? boolean|fun():boolean whether the plugin should be loaded

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.

local Plugin = {}
Plugin.__index = Plugin

--- Run after install/update.
function Plugin:build()
  local b = self.data.build
  if type(b) == 'string' then
    vim.cmd(b)
  elseif vim.is_callable(b) then
    b({ spec = self })
  end
end

--- Called after `packadd`.
function Plugin:init()
  local ok, err = pcall(function()
    local v = self._v
    if v.init then
      v.init()
    else
      -- assumes `setup()` exists; module name strips `.nvim` suffix if present
      local opts = resolve(v.opts)
      if type(opts) == 'table' then
        require(name:gsub('%.nvim$', '')).setup(opts)
      end
    end
    -- keys are a list of { mode, lhs, rhs, opts? } or a function returning such a list
    local keys = resolve(v.keys)
    if vim.islist(keys) then
      vim.iter(keys):each(function(k) vim.keymap.set(table.unpack(k)) end)
    end
    if v.toggle and rawget(_G, 'Snacks') then
      vim.iter(v.toggle):each(function(k, opts) Snacks.toggle.new(opts):map(k) end)
    end
  end)
  if not ok then
    vim.notify(('plug: init failed for %s\n%s'):format(self.name, err), vim.log.levels.ERROR)
  end
end

--- packadd + init.
function Plugin:load()
  vim.cmd.packadd({ self.name, bang = vim.v.vim_did_enter == 0 })
  self:init()
end

--- Create and return a `vim.pack.Spec` from a plugin specification table.
---@param v string|plug.Spec
---@return vim.pack.Spec?
function Plugin.new(v)
  v = type(v) == 'string' and { v } or v
  if resolve(v.enabled) == false then
    return nil
  end
  vim.validate('[1]', v[1], 'string')
  vim.validate('init', v.init, 'function', true)
  vim.validate('build', v.build, { 'string', 'function' }, true)
  vim.validate('opts', v.opts, { 'table', 'function' }, true)
  vim.validate('keys', v.keys, { 'table', 'function' }, true)
  vim.validate('toggles', v.toggles, 'table', true)
  return setmetatable({
    _v = v,
    src = v.src or ('https://github.com/%s.git'):format(v[1]),
    name = v.name or v[1]:match('[^/]+$'),
    version = v.version or v.branch,
    data = { build = v.build },
  }, Plugin)
end

--- Wraps plugin packaging and setup, skipping disabled plugins.
---@param plugs string|plug.Spec|(string|plug.Spec)[]
_G.Plug = function(plugs)
  vim.pack.add(vim.iter(vim.islist(plugs) and plugs or { plugs }):map(Plugin.new):totable(), {
    ---@param ev {spec: vim.pack.Spec, path: string}
    load = function(ev) ev.spec:load() end,
  })
end
