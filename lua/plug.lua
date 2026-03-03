--- OOP

---@class plug.Spec
---@field [1] string `owner/repo`
---@field branch? string Git branch to use.
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field data? any accessible from `vim.pack.add()`
---@field init? fun():nil
---@field keys? table flexible keymap definitions
---@field name? string derived from [1] if missing
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field src? string derived from [1] if missing
---@field toggles? table<string, string|table> Snacks.nvim toggles to register.
---@field version? string|vim.VersionRange Version constraint for the plugin.
---@field event? string|string[] event to call `init()` on -- TODO:
---@field lazy? boolean whether to defer `packadd()` on startup -- TODO:
local M = {}
M.__index = M

--- Create a new Plugin instance from a specification table.
---
--- @param v table Plugin specification with required `[1]` field.
--- @return plug.Spec
function M.new(v)
  local self = type(v) == 'table' and v or { v }
  vim.validate('[1]', self[1], 'string')
  vim.validate('init', self.init, { 'function' }, true)
  vim.validate('build', self.build, { 'string', 'function' }, true)
  vim.validate('keys', self.keys, vim.islist, true)
  vim.validate('name', self.name, 'string', true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('src', self.src, 'string', true)
  vim.validate('toggles', self.toggles, 'table', true)
  self.name = self.name or self[1]:match('[^/]+$')
  return setmetatable(self, M)
end

function M:modname() return (self.name or vim.fs.basename(self[1])):gsub('%.nvim$', '') end

function M:infer_setup()
  local opts = vim.is_callable(self.opts) and self.opts() or self.opts
  return type(opts) == 'table' and require(self:modname()).setup(opts)
end

function M:map_keys()
  local keys = require('nvim.keys')
  if self.keys then
    keys.map(self.keys)
  end
  if self.toggles then
    for key, v in pairs(self.toggles) do
      keys.new_snacks_toggle(key, v)
    end
  end
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil

---@return vim.pack.Spec
function M:spec()
  return {
    src = self.src or ('https://github.com/%s.git'):format(self[1]),
    -- version = self.version or self.branch or nil,
    name = self.name or vim.fs.basename(self[1]),
    ---@type plug.Data
    data = self.data or {
      build = self.build,
      init = self.init or function() return self:infer_setup() end,
      map_keys = function()
        vim.schedule(function() return self:map_keys() end)
      end,
    },
  }
end

_G.Plug = function(t) return t.enabled ~= false and M.new(t):spec() or nil end

M.build = function(event)
  local kind = event.data.kind ---@type "install"|"update"|"delete"
  if kind == 'delete' then
    return
  end
  local spec = event.data.spec ---@type vim.pack.Spec
  local build = spec.data and spec.data.build
  if type(build) == 'function' then
    if not event.data.active then
      vim.cmd.packadd(spec.name)
    end
    build()
    print('Build function executed for ' .. spec.name)
  elseif type(build) == 'string' then
    -- trim leading ':' or '<Cmd>' and trailing '<CR>'
    build = build:gsub('^:*', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
    vim.cmd(build)
    print('Build string executed for ' .. spec.name)
  end
end

-- TODO: build command to force rebuild of a plugin
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev) require(M.build)(ev) end,
})

-- FIXME: this is broken
local function spec_names(active)
  return vim
    .iter(vim.pack.get())
    :filter(function(p) return active ~= nil and p.active == active or true end)
    :map(function(p) return p.spec.name end)
    :totable()
end

vim.api.nvim_create_user_command(
  'PlugStatus',
  function() vim.pack.update(nil, { offline = true }) end,
  {}
)
vim.api.nvim_create_user_command(
  'PlugUpdate',
  function(opts) vim.pack.update(#opts.fargs > 0 and opts.fargs or nil, { force = opts.bang }) end,
  { nargs = '*', bang = true, complete = function() return spec_names(true) end }
)
vim.api.nvim_create_user_command(
  'PlugSpecs',
  function(opts)
    vim.print(true, vim.pack.get(#opts.fargs > 0 and opts.fargs or nil, { info = opts.bang }))
  end,
  { bang = true, nargs = '*', complete = spec_names }
)
vim.api.nvim_create_user_command(
  'PlugClean',
  function(opts) vim.pack.del(#opts.fargs > 0 and opts.fargs or spec_names(false)) end,
  { nargs = '*', complete = function(_, _, _) return spec_names(false) end }
)

return M
