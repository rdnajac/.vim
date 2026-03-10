---@class plug.Spec
---@field [1] string `owner/repo`
---@field build? string|fun(ev: table):nil Callback after plugin is installed/updated.
---@field data? any accessible from `vim.pack.add()`
---@field init? fun():nil
---@field keys? table flexible keymap definitions
---@field name? string derived from [1] if missing
---@field opts? table|fun():table passed to the plugin's `setup()`
---@field src? string derived from [1] if missing
---@field toggles? table<string, string|table> Snacks.nvim toggles to register.
---@field version? string|vim.VersionRange alias `branch`
---@field event? string|string[] event to call `init()` on -- TODO:
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
  validate('keys', self.keys, vim.islist, true)
  validate('lazy', self.lazy, 'boolean', true)
  validate('opts', self.opts, { 'table', 'function' }, true)
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

--- Overrides `packadd`ing in `vim.pack.add`, then calls the plugin's `init()`
---@param plug_data { spec: vim.pack.Spec, path: string }
local _load = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
  local init = vim.tbl_get(spec, 'data', 'init')
  return vim.is_callable(init) and init() or nil
end

--- Wraps instantiation, initialization, and conversion, skipping disabled plugins.
---@param plugs table|table[]  list of plugin specs or single spec table
---@return vim.pack.Spec|nil
_G.Plug = function(plugs)
  local speclist = vim
    .iter(vim.islist(plugs) and plugs or { plugs })
    :filter(function(v) return v.enabled ~= false end)
    :map(function(v) return M.new(v):package() end)
    :totable()
  vim.pack.add(speclist, { load = _load })
end

vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev)
    local kind = ev.data.kind ---@type "install"|"update"|"delete"
    local spec = ev.data.spec ---@type vim.pack.Spec
    local name = spec.name
    local build = vim.tbl_get(spec, 'data', 'build')
    if kind == 'delete' or not build then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(name)
    end
    if type(build) == 'function' then
      build()
      print('Build function called for ' .. name)
    elseif type(build) == 'string' then
      -- trim leading ':' or '<Cmd>' and trailing '<CR>'
      build = build:gsub('^:*', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
      vim.cmd(build)
      print('Build string executed for ' .. name)
    end
  end,
})

--- Helper function to get plugin names for command completion.
---@param active boolean? filter by active/inactive plugins, or return all if nil
---@return string[] list of plugin names
local function spec_names(active)
  return vim
    .iter(vim.pack.get())
    :filter(function(p) return active == nil or p.active == active end)
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
