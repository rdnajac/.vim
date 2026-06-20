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
local M = {}
M.__index = M

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil called inside of the `load()` function, after `packadd()`.

--- Create a new Snackpack instance from a specification table.
--- Convert the plugin to a format compatible with `vim.pack.add()`.
---@param self string|table table with required `[1]` field (or just `user/repo`
---@return Snackpack
function M.new(self)
  self = type(self) == 'table' and self or { self } ---@type Snackpack
  vim.validate('[1]', self[1], 'string')
  vim.validate('build', self.build, { 'string', 'function' }, true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('toggle', self.toggle, 'table', true)
  return setmetatable({
    src = self.src or ('https://github.com/%s.git'):format(self[1]),
    name = self.name or (self[1]):match('[^/]*$'),
    version = self.version or self.branch or nil,
    ---@type plug.Data
    data = {
      build = self.build,
      init = function() self:setup() end,
      toggle = self.toggle,
    },
  }, M)
end

--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- The module name is just the plugin name without a `.nvim` suffix, if present.
function M:setup()
  local opts = vim.is_callable(self.opts) and self.opts() or self.opts
  if type(opts) == 'table' then
    require(self.name:gsub('%.nvim$', '')).setup(opts)
  end
end

return setmetatable(M, {
  __call = function(_, ...) return M.new(...) end,
})
