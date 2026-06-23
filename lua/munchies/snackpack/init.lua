--- @class snackpack.Data
--- @field [1] string `user/repo`
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field opts? table|fun():table passed to the plugin's `setup()`
--- @field toggle? table<string, table> Snacks.nvim toggles to register.

--- @class Snackpack: vim.pack.Spec
--- @field data? snackpack.Data

local Snackpack = {}
Snackpack.__index = Snackpack

local M = {}

--- Create a new Snackpack instance from a specification table.
--- Convert the plugin to a format compatible with `vim.pack.add()`.
--- Assumes the plugin has a `setup()` function and calls it with `opts` if provided.
--- @param v string|table
---@return Snackpack
function M.new(v)
  v = type(v) == 'string' and { v } or v --[[@as table]]
  vim.validate('[1]', v[1], 'string')
  vim.validate('build', v.build, { 'string', 'function' }, true)
  vim.validate('opts', v.opts, { 'table', 'function' }, true)
  vim.validate('toggle', v.toggle, 'table', true)
  local rt = {
    src = v.src or ('https://github.com/%s.git'):format(v[1]),
    name = v.name,
    version = v.version,
    -- data = setmetatable(v, Snackpack),
    data = {
      build = v.build,
      opts = v.opts,
      toggle = v.toggle,
    },
  }
  return rt
end

--- @param spec Snackpack
M.load = function(spec)
  local data = spec.data
  if not data then
    return
  end

  -- TODO: highlights
  if data.opts then
    local opts = vim.is_callable(data.opts) and data.opts() or data.opts
    if type(opts) == 'table' then
      require(spec.name:gsub('%.nvim$', '')).setup(opts)
    end
  end

  if data.toggle then
    for key, toggle in pairs(data.toggle) do
      nv.keys.toggles[key] = toggle
    end
  end
end

M.build = require('munchies.snackpack.build')
nv.on('PackChanged', {}, M.build)

local function to_snackpack(plugs)
  return vim.iter(vim.islist(plugs) and plugs or { plugs }):map(M.new):totable()
end

--- @param plug_data { spec: vim.pack.Spec, path: string }))?
local _load = function(plug_data)
  vim.cmd.packadd({ plug_data.spec.name, bang = vim.v.vim_did_enter == 0 })
  if plug_data.spec.data then
    M.load(plug_data.spec --[[@as Snackpack]])
  end
end

--- @param plugs string|table|(string|table)[] list of plugins
_G.Plug = function(plugs)
  vim.pack.add(to_snackpack(plugs), { load = _load })
end

---@param opts snacks.Config
M.setup = function(opts)
  Plug({ 'folke/snacks.nvim', opts = opts })
end

return M
