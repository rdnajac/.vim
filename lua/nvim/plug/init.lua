vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local user_repo_regex = '^[%w._-]+/[%w._-]+$'

local function is_nonempty_string(x)
  return type(x) == 'string' and x ~= ''
end

local function gh(user_repo)
  if user_repo:match(user_repo_regex) then
    return 'https://github.com/' .. user_repo .. '.git'
  end
  return user_repo
end

--- @param p string plugin (`user/repo`)
--- @param data? any
local function to_spec(p)
  if not is_nonempty_string(p) then
    return {}
  end
  return {
    src = gh(p),
    name = p:match('([^/]+)$'):gsub('%.nvim$', ''),
    version = p:match('treesitter') and 'main' or nil,
    -- data = data or nil,
  }
end

local M = {}

-- TODO lazy load?
M.spec = function(user_repo)
  local ret = {}

  local spec = to_spec(user_repo)
  -- check if we have a spec table available
  local modname = 'nvim.' .. spec.name
  local ok, plug = pcall(require, modname)
  if ok and plug and type(plug) == 'table' then
    local config = vim.is_callable(plug.config) and plug.config or nil
    local opts = config == nil and type(plug.opts) == 'table' and plug.opts or nil
    -- add to data
    if config or opts then
      spec.data = {
        config = config,
        opts = vim.deepcopy(opts),
      }
    end
    -- handle deps
    -- if vim.is_list(mod.specs)
    -- ret = vim.tbl_map(gh, vim.list_extend({ spec }, mod.specs or {}))
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
  local ret = mod.specs and vim.tbl_map(to_spec, mod.specs) or {}
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
  vim.api.nvim_create_user_command('PlugClean', function()
    vim.pack.del(M.unloaded())
  end, { desc = 'Remove unloaded plugins' })

  vim.api.nvim_create_user_command('PlugStatus', function(args)
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

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
