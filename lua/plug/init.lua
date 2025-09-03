local M = {}

M.plugins = {}

local enabled = function(plugin)
  local enabled = plugin.enabled
  if vim.is_callable(enabled) then
    local ok, res = pcall(enabled)
    return ok and res
  end
  return enabled == nil or enabled == true
end

-- TODO: add logic from to_spec
---@param module string|vim.pack.Spec|PlugSpec
---@return vim.pack.Spec|nil
local function to_spec(module)
  -- if not M.enabled(module) then
  --   return nil
  -- end

  local t = type(module)
  local src = t == 'string' and module or module[1] or module.src

  if type(src) ~= 'string' or src == '' then
    return nil
  end

  -- convert shorthand github user/repo to full git url
  if src:match('^%w[%w._-]*/[%w._-]+$') then
    -- src = 'https://github.com/' .. src .. (src:sub(-4) ~= '.git' and '.git' or '')
    src = 'https://github.com/' .. src .. (vim.endswith(src, '.git') and '' or '.git')
  end

  return {
    src = src,
    name = t == 'table' and module.name or nil,
    version = t == 'table' and module.version or nil,
    -- data = module,
  }
end

local function add_spec(list, plugin)
  list = list or {}
  if not plugin then
    return list
  end

  local function _add(p)
    if not p then
      return
    end
    local spec

    -- TODO:
    -- if its a list, handle it

    if type(p) == 'string' then
      spec = { src = 'https://github.com/' .. p .. '.git', name = p:match('([^/]+)$') }
    elseif type(p) == 'table' then
      if not enabled(plugin) then
        return
      end
      if p[1] and type(p[1]) == 'string' then
        spec = {
          src = 'https://github.com/' .. p[1] .. '.git',
          name = p[1]:match('([^/]+)$'):gsub('%.nvim$', ''),
          version = p.version,
          data = p.config and { config = p.config } or p.opts and { opts = p.opts } or nil,
        }
      elseif p.src then
        spec = p -- already a spec table
      end
    end

    if spec then
      table.insert(list, spec)
    end
  end

  _add(plugin)

  if type(plugin) == 'table' then
    for _, field in ipairs({ 'dependencies', 'specs' }) do
      local sub = plugin[field]
      if type(sub) == 'table' then
        for _, f in ipairs(sub) do
          _add(f)
        end
      end
    end
  end

  return list
end

-- Plug a single plugin/module
function M.plug(repo)
  -- unwrap table if needed
  if type(repo) == 'table' and type(repo[1]) == 'string' then
    repo = repo[1]
  end

  local user, plugin = repo:match('^([^/]+)/([^/]+)$')
  if not (user and plugin) then
    error(string.format('Invalid plugin repo format: %s (expected user/repo)', tostring(repo)))
  end

  if vim.startswith(repo, 'nvim/') then
    local mod = require(repo)
    if vim.is_callable(mod.init) then
      mod.init()
    end
    add_spec(M.plugins, mod.specs or mod)
  elseif vim.endswith(plugin, '.nvim') then
    local ok, mod = pcall(require, 'nvim.' .. plugin:gsub('%.nvim$', ''))
    if ok and mod then
      add_spec(M.plugins, mod.specs or mod)
    end
  else
    add_spec(M.plugins, repo) -- plain GitHub repo
  end
end

-- Plugin load callback
local _load = function(plug_data)
  local spec = plug_data.spec
  local opts = spec.data and spec.data.opts
  local config = spec.data and spec.data.config

  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })

  if config and vim.is_callable(config) then
    print('Running config for ' .. spec.name)
    config()
  elseif opts then
    print('Running setup for ' .. spec.name)
    require(spec.name).setup(opts)
  end
end

-- Finalize plugin loading
function M.end_()
  -- Load manually added plugins
  vim.pack.add(M.plugins, { confirm = false, load = _load })

  -- Build a second list from all plug modules
  local dir = 'plug/'
  local module_plugins = {}

  require('util').for_each_module(function(plugin)
    local mod = require('util').safe_require(plugin)
    if mod then
      add_spec(module_plugins, mod)
    end
  end, dir)

  -- Load all module plugins
  if #module_plugins > 0 then
    vim.pack.add(module_plugins, { confirm = false, load = _load })
  end
end

return setmetatable(M, {
  __call = function(_, modname)
    return M.plug(modname)
  end,
})
