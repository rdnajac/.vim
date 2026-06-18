---@class Snackpack
---@field [1] string `owner/repo`
---@field src? string derived from [1] if missing
---@field name? string derived from [1] if missing
---@field version? string|vim.VersionRange
---@field branch? string alias for `version`
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field init? fun():nil
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field toggle? table<string, table> Snacks.nvim toggles to register.
local Snackpack = {}
Snackpack.__index = Snackpack

--- Create a new Snackpack instance from a specification table.
---@param v string|table table with required `[1]` field (or just `user/repo`
---@return Snackpack
function Snackpack.new(v)
  local self = type(v) == 'table' and v or { v } ---@type Snackpack
  vim.validate('[1]', self[1], 'string')
  vim.validate('build', self.build, { 'string', 'function' }, true)
  vim.validate('init', self.init, 'function', true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('toggle', self.toggle, 'table', true)
  -- add required fields and defaults
  self.src = self.src or ('https://github.com/%s.git'):format(self[1])
  self.name = self.name or (self[1]):match('[^/]*$')
  self.version = self.version or self.branch or nil
  return setmetatable(self, Snackpack)
end

--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- The module name is just the plugin name without a `.nvim` suffix, if present.
function Snackpack:setup()
  if self.init then
    self.init()
  else
    local opts = vim.is_callable(self.opts) and self.opts() or self.opts
    if type(opts) == 'table' then
      require(self.name:gsub('%.nvim$', '')).setup(opts)
    end
  end
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil called inside of the `load()` function, after `packadd()`.

--- Convert the plugin to a format compatible with `vim.pack.add()`.
function Snackpack:package()
  return {
    src = self.src,
    name = self.name,
    version = self.version,
    ---@type plug.Data
    data = {
      build = self.build,
      init = function() self:setup() end,
      toggle =self.toggle,
    },
  }
end

---@param v string|table
---@return vim.pack.Spec
return function(v)
  return Snackpack.new(v):package()
end
