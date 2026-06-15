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
    dd('Running custom init for %s', self.name)
    self.init()
  else
    local opts = vim.is_callable(self.opts) and self.opts() or self.opts
    if type(opts) == 'table' then
      require(self.name:gsub('%.nvim$', '')).setup(opts)
    end
  end
  if self.toggle then
    vim.iter(self.toggle):each(function(k, v) Snacks.toggle.new(v):map(k) end)
  end
end

---@class plug.Data passed as `spec.data` to `vim.pack.add()`
---@field build? string|fun():nil Callback after plugin is installed/updated.
---@field init? fun():nil called inside of the `load()` function, after `packadd()`.

--- Convert the plugin to a format compatible with `vim.pack.add()`.
---@return vim.pack.Spec
function Snackpack:package()
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

local _build = function(build)
  if type(build) == 'function' then
    build()
  elseif type(build) == 'string' then -- trim leading ':' or '<Cmd>' and trailing '<CR>'
    vim.cmd(vim.trim(build):gsub('^(%:|<[Cc][Mm][Dd]>)', ''):gsub('<[Cc][Rr]>$', ''))
  end
end

nv.on('PackChanged', function(ev)
  ---@cast ev {data:vim.event.packchanged.data}
  local data = ev.data
  local name = data.spec.name
  local build = vim.tbl_get(data.spec, 'data', 'build')
  if data.kind ~= 'delete' and build then
    print(('[PackChanged:%s]: building %s'):format(data.kind, name))
    if not data.active then
      vim.cmd.packadd(name)
    end
    _build(build)
  end
end)

---@param plug_data {spec: vim.pack.Spec, path: string}
local _load = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
  local init = vim.tbl_get(spec, 'data', 'init')
  if vim.is_callable(init) then
    init()
  end
end

return {
  ---@param plugs string|Snackpack|(string|Snackpack)[] list of plugins
  add = function(plugs)
    local speclist = vim
      .iter(vim.islist(plugs) and plugs or { plugs })
      :filter(function(v) return v.enabled ~= false end)
      :map(function(v) return Snackpack.new(v):package() end)
      :totable()
    vim.pack.add(speclist, { load = _load })
  end,
}
