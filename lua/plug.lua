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

--- Create a new Plugin instance from a specification table.
--- @param v table Plugin specification with required `[1]` field.
--- @return plug.Spec
function M.new(v)
  local self = type(v) == 'table' and v or { v }
  vim.validate('[1]', self[1], 'string')
  vim.validate('init', self.init, 'function', true)
  vim.validate('build', self.build, { 'string', 'function' }, true)
  vim.validate('keys', self.keys, vim.islist, true)
  vim.validate('name', self.name, 'string', true)
  vim.validate('opts', self.opts, { 'table', 'function' }, true)
  vim.validate('src', self.src, 'string', true)
  vim.validate('toggles', self.toggles, 'table', true)
  vim.validate('event', self.event, { 'string', 'table' }, true)
  vim.validate('lazy', self.lazy, 'boolean', true)
  -- add required fields and defaults
  self.src = self.src or ('https://github.com/%s.git'):format(self[1])
  self.name = self.name or self[1]:match('[^/]*$')
  self.version = self.version or self.branch or nil
  return setmetatable(self, M)
end

--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- The module name is just the plugin name without a `.nvim` suffix, if present.
function M:infer_setup()
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
---@param event string|string[]
---@param cb fun() the module's setup function with opts
local on_event = function(event, cb)
  vim.api.nvim_create_autocmd(event, {
    callback = cb,
    group = aug,
    -- nested = true,
    once = true,
  })
end

--- Convert the plugin specification to a format compatible with `vim.pack.add()`.
---@return vim.pack.Spec
function M:to_pack_spec()
  local spec = { src = self.src, name = self.name, version = self.version }
  ---@type plug.Data
  spec.data = {
    build = self.build,
    init = function()
      vim.schedule(function() return nv.keys.register(self) end)
      -- return self.init and self.init() or self:infer_setup()
      local setup = self.init or function() self:infer_setup() end
      return self.event and on_event(self.event, setup) or setup()
    end,
  }
  return spec
end

--- @param plug_data { spec: vim.pack.Spec, path: string }
M.load = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
  -- local init = vim.tbl_get(plug_data, 'spec', 'data', 'init')
  -- if vim.is_callable(init) then
  --   init()
  -- end
  plug_data.spec.data.init() -- assume `init` is always defined...
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
