local M = {}

--- Overrides `packadd`ing in `vim.pack.add`, then calls the plugin's `init()`
---@param plug_data { spec: vim.pack.Spec, path: string }
local _load = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
  local init = vim.tbl_get(spec, 'data', 'init')
  return vim.is_callable(init) and init() or nil
end

local Plugin = require('nvim.plug.spec')

--- Wraps instantiation, initialization, and conversion, skipping disabled plugins.
---@param plugs table|table[]  list of plugin specs or single spec table
---@return vim.pack.Spec|nil
_G.Plug = function(plugs)
  local speclist = vim
    .iter(vim.islist(plugs) and plugs or { plugs })
    :filter(function(v) return v.enabled ~= false end)
    :map(function(v) return Plugin.new(v):package() end)
    :totable()
  vim.pack.add(speclist, { load = _load })
end

vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  desc = 'build plugins',
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
      build = build:gsub('^:', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
      vim.cmd(build)
      print('Build string executed for ' .. name)
    end
  end,
})

M.specs = require('nvim.plug.ins')

M.after = function()
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
end

return M
