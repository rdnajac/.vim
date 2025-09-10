vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local safe_require = require('util').safe_require

local user_repo_regex = '^[%w._-]+/[%w._-]+$'

local function is_nonempty_string(x)
  return type(x) == 'string' and x ~= ''
end

local M = {}

M.gh = function(user_repo)
  if user_repo:match(user_repo_regex) then
    return 'https://github.com/' .. user_repo .. '.git'
  end
  return user_repo
end

--- @param p string plugin (`user/repo`)
M.to_spec = function(p)
  if not is_nonempty_string(p) then
    return {}
  end
  return {
    src = M.gh(p),
    name = p:match('([^/]+)$'):gsub('%.nvim$', ''),
    version = p:match('treesitter') and 'main' or nil,
    -- data = data or nil,
  }
end

M.spec = function(user_repo)
  local spec = M.to_spec(user_repo)
  spec.data = function()
    local plugspec = require('nvim.plug.spec')
    return plugspec(require('nvim')[spec.name])
  end
  return spec
end

--- If there is a plugin name at [1], this is a primary
--- Plugin that possibly needs setup
--- The absense of [1] generally meanse we can skip setup
--- set up is added to data
---
--- @param m string module name under nvim/ directory
--- @return vim.pack.Spec|nil
function M.plug(m)
  local mod = require('util').safe_require('nvim.' .. m)
  if not mod then
    return nil
  end

  -- PERF: add diretly to result without passing to M/spec
  -- collect specs
  local ret = mod.specs and vim.tbl_map(M.to_spec, mod.specs) or {}
  -- add the main plugin from top of table
  if is_nonempty_string(mod[1]) then
    table.insert(ret, M.spec(mod[1]))
  end
  -- return the transformed list
  return ret
end

M.unloaded = function()
  return vim.tbl_map(
    function(plugin)
      return plugin.spec.name
    end,
    vim.tbl_filter(function(plugin)
      return plugin.active == false
    end, vim.pack.get())
  )
end

function M.end_()
  -- assuming setup happens after calling plug#end()
  nv.did_setup = {}

  vim.api.nvim_create_user_command('PlugClean', function()
    vim.pack.del(M.unloaded())
  end, { desc = 'Remove unloaded plugins' })

  vim.api.nvim_create_user_command('PlugStatus', function()
    print(vim.inspect(vim.pack.get()))
  end, {})

  -- must pass nil to update all plugins with a bang
  vim.api.nvim_create_user_command('PlugUpdate', function(opts)
    vim.pack.update(nil, { force = opts.bang })
  end, { bang = true })
end

M.after = function(module)
  Snacks.util.on_module(module, function()
    require('nvim')[module].after()
  end)
end

M.setup_on_module = function(module)
  Snacks.util.on_module(module, function()
    local spec = require('nvim')[module]
    if vim.is_callable(spec.config) then
      spec.config()
    else
      require(module).setup(type(spec.opts) == 'table' and spec.opts or {})
    end
  end)
end

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
