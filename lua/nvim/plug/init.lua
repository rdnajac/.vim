vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local M = {}

--- @param user_repo string plugin (`user/repo`)
--- @param data boolean|nil if true, add `data` function to spec
--- if false, return minimal spec for non-nvim plugins
--- if nil, return spec optional name and version
--- @return string|vim.pack.Spec
M.to_spec = function(user_repo, data)
  -- if user_repo:match('^[%w._-]+/[%w._-]+$') then
  local src = 'https://github.com/' .. user_repo .. '.git'
  if data == false then
    return src
  end

  return {
    src = src,
    name = user_repo:match('([^/]+)$'):gsub('%.nvim$', ''),
    --- HACK: remove this when treesitter is on main
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
end

local Plugin = require('nvim.plug.spec')

--- Custom load function for `vim.pack.add`
--- This handles both simple plugins and those
--- that need to be initialized and configured via
--- their `data` function in their spec
--- @param plug_data { spec: vim.pack.Spec, path: string }
function M.load(plug_data)
  local spec = plug_data.spec ---@type vim.pack.Spec
  local name = spec.name
  local bang = vim.v.vim_did_enter == 0
  -- print(spec.name .. (bang and '!' or '...'))

  vim.cmd.packadd({ name, bang = bang, magic = { file = false } })
  --
  if spec.data == true then -- create plugin object
    local plugin = Plugin(name)
    if plugin then
      plugin:init() -- calls setup, and adds deps
    end
  end
end

--- @param specs (string|vim.pack.Spec)[]
function M.plug(specs)
  local speclist = vim.islist(specs) and specs or { specs }
  local resolved = vim.tbl_map(nv.plug.to_spec, speclist)
  vim.pack.add(resolved, { load = M.load })
end

-- TODO: need seperate loading for specs vs deps
-- namely who gets to call data() and in turn config
function M.end_()
  nv.did = vim.defaulttable()
  nv.specs = vim
    .iter(vim.g.plug_list)
    :map(function(p)
      -- HACK: most plugins end in `.nvim`, except special cases like blink.cmp
      local is_nvim_plugin = vim.endswith(p, '.nvim') or vim.endswith(p, 'blink.cmp')
      return M.to_spec(p, is_nvim_plugin)
    end)
    :totable()

  vim.pack.add(nv.specs, { load = M.load })
  M.commands()
end

M.unloaded = function()
  return vim
    .iter(vim.pack.get())
    --- @param plugin vim.pack.PlugData
    :filter(function(plugin)
      return plugin.active == false
    end)
    --- @param plugin vim.pack.PlugData
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()
end

M.commands = function()
  local command = vim.api.nvim_create_user_command

  command('PlugUpdate', function(opts)
    local plugs = #opts.fargs > 0 and opts.fargs or nil
    vim.pack.update(plugs, { force = opts.bang })
  end, {
    nargs = '*',
    bang = true,

    complete = function()
      return vim.tbl_map(function(p)
        return p.spec.name
      end, vim.pack.get())
    end,
  })

  -- TODO: take optional names with a completel list
  command('PlugStatus', function(opts)
    vim._print(true, vim.pack.get(nil, { info = opts.bang }))
  end, {
    bang = true,
    nargs = '*',
  })

  command('PlugClean', function(opts)
    local plugs = #opts.fargs > 0 and opts.fargs or M.unloaded()
    vim.pack.del(plugs)
  end, {
    nargs = '*',
    complete = function(_, _, _)
      return M.unloaded()
    end,
  })
end

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
