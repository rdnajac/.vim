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
  local spec = {
    src = src,
    name = user_repo:match('([^/]+)$'):gsub('%.nvim$', ''),
    --- XXX: remove this hack when treesitter is on main
    version = user_repo:match('treesitter') and 'main' or nil,
  }
  if data == true then
    spec.data = function()
      local plugspec = require('nvim.plug.spec')
      return plugspec(require('nvim')[spec.name])
    end
  end
  return spec
end

--- `:packadd!` equivalent that works during startup
--- @param name string
function M.packadd(name)
  local bang = vim.v.vim_did_enter == 0
  vim.cmd.packadd({ name, bang = bang, magic = { file = false } })
end

--- Custom load function for `vim.pack.add`
--- This handles both simple plugins and those
--- that need to be initialized and configured via
--- their `data` function in their spec
--- @param plug_data { spec: vim.pack.Spec, path: string }
function M.load(plug_data)
  local spec = plug_data.spec ---@type vim.pack.Spec
  if vim.is_callable(spec.data) then
    -- info('loading ' .. spec.name)
    local plugin = spec.data() ---@type Plugin
    plugin:init() -- calls packadd, setup, and adds deps
  else
    -- info('`packadd`ing ' .. spec.name .. ' (no init)')
    M.packadd(spec.name)
    -- if vim.endswith(spec.name, '.nvim') then
    --   require(spec.name).config({})
    -- end
  end
end

--- @param specs (string|vim.pack.Spec)[]
function M.plug(specs)
  local speclist = vim.islist(specs) and specs or { specs }
  vim.pack.add(speclist, { load = M.load })
end

-- TODO: need seperate loading for specs vs deps
-- namely who gets to call data() and in turn config
function M.end_()
  nv.did_setup = {}
  nv.specs = vim
    .iter(vim.g.plug_list)
    :map(function(p)
      -- HACK: most plugins end in `.nvim`, except special cases like blink.cmp
      local is_nvim_plugin = vim.endswith(p, '.nvim') or vim.endswith(p, 'blink.cmp')
      return M.to_spec(p, is_nvim_plugin)
    end)
    :totable()

  M.plug(nv.specs)

  local command = vim.api.nvim_create_user_command
  -- TODO: move these to a cmd submodule
  command('PlugClean', M.clean, {})
  command('PlugUpdate', M.update, {})
  command( 'PlugStatus', M.status,
  { bang = true } 
)
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

-- stylua: ignore
M.clean = function() vim.pack.del(M.unloaded()) end
M.update = function(opts)
  vim.pack.update(nil, opts or {})
end
-- stylua: ignore end
M.status = function(opts)
  -- opts.bang is true if the user ran `:PlugStatus!`
  --- @type vim.pack.keyset.get
  local get_opts = { info = opts.bang }
  vim._print(true, vim.pack.get(nil, get_opts))
end

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
