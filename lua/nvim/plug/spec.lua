---@class plug.Spec
---@field [1] string `owner/repo`
---@field src? string derived from [1] if missing
---@field name? string derived from [1] if missing
---@field version? string|vim.VersionRange alias `branch`
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field init? fun():nil
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field keys? table|fun():table flexible keymap definitions
---@field toggles? table<string, string|table> Snacks.nvim toggles to register.
---@field event? string|string[] event on which to call `init()`
---@field lazy? boolean whether to defer `packadd()` on startup -- TODO:
local M = {}
M.__index = M

local validate = vim.validate

--- Create a new Plugin instance from a specification table.
---@param v string|table table with required `[1]` field (or just `user/repo`
---@return plug.Spec
function M.new(v)
  local self = type(v) == 'table' and v or { v }
  validate('[1]', self[1], 'string')
  validate('build', self.build, { 'string', 'function' }, true)
  validate('event', self.event, { 'string', 'table' }, true)
  validate('init', self.init, 'function', true)
  validate('lazy', self.lazy, 'boolean', true)
  validate('opts', self.opts, { 'table', 'function' }, true)
  validate('keys', self.keys, { 'table', 'function' }, true)
  validate('toggles', self.toggles, 'table', true)
  -- add required fields and defaults
  self.src = self.src or ('https://github.com/%s.git'):format(self[1])
  self.name = self.name or self[1]:match('[^/]*$')
  self.version = self.version or self.branch or nil
  return setmetatable(self, M)
end

--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- The module name is just the plugin name without a `.nvim` suffix, if present.
function M:setup()
  vim.schedule(function() return require('nvim.keys').register(self) end)
  if self.init then
    return self.init()
  end
  local opts = vim.is_callable(self.opts) and self.opts() or self.opts
  if type(opts) == 'table' then
    local modname = (self.name or vim.fs.basename(self[1])):gsub('%.nvim$', '')
    return require(modname).setup(opts)
  end
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil called inside of the `load()` function, after `packadd()`.

local aug = vim.api.nvim_create_augroup('2lazy4lazy', {})

--- Convert the plugin to a format compatible with `vim.pack.add()`.
---@return vim.pack.Spec
function M:package()
  local spec = { src = self.src, name = self.name, version = self.version }
  ---@type plug.Data
  spec.data = {
    build = self.build,
    init = function()
      if not self.event then
        return self:setup()
      end
      vim.api.nvim_create_autocmd(self.event, {
        callback = function() self:setup() end,
        group = aug,
        -- nested = true,
        once = true,
      })
    end,
  }
  return spec
end

return M
