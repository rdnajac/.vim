-- let g:plug_home = join([stdpath('data'), 'site', 'pack', 'core', 'opt'], '/')
vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local _load = function(plug_data)
  local spec = plug_data.spec
  local opts = spec.data and spec.data.opts or nil
  local config = spec.data and spec.data.config or nil

  -- we have to `packadd` oureslves since load overrides this step
  -- TODO: no bang if loaded?
  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })

  if config then
    config()
  elseif opts then
    require(spec.name).setup(opts)
  end
end

local M = {}

M.begin = function()
  M.plugins = {} -- initialize the plugin list
  -- vim.cmd([[command! -nargs=+ -bar Plug call plug#(<args>)]])
end

local _to_spec = function(plugin)
  if plugin and plugin.specs then
    return plugin.specs
  end

  local repo = plugin[1]
  local src = 'http://github.com/' .. repo .. '.git'
  local name = repo:match('([^/]+)$'):gsub('%..*$', '')
  local version = plugin.version or nil
  local opts = plugin.opts or nil
  local config = plugin.config or nil

  vim.validate('opts', opts, 'table', true, 'opts must be a table')
  vim.validate('config', config, 'function', true, 'config must be a function')

  local data = (opts or config) and { opts = opts, config = config } or nil

  return { src = src, name = name, version = version, data = data }
end

M._plug = function(repo)
  -- Ensure repo is a string like "user/repo"
  local name = repo[1] or repo -- support either table or single string
  local user, plugin = name:match('^([^/]+)/([^/]+)$')
  if not (user and plugin) then
    error(string.format('Invalid plugin repo format: %s (expected user/repo)', tostring(name)))
  end
  print(name)

  -- Case 1: plugin starts with "nvim/" → load as Lua module
  if vim.startswith(name, 'nvim/') then
    print('case1')
    local plugin_module = require(name)

    if vim.is_callable(plugin_module.init) then
      plugin_module.init()
    end
    -- Extend with module specs if present
    local specs = plugin_module.specs
    if specs then
      if type(specs) == 'table' then
        vim.list_extend(M.plugins, specs)
      else
        table.insert(M.plugins, specs)
      end
    end
  else
    -- Case 2: plain GitHub repo
    if not vim.endswith(plugin, '.nvim') then
      print('case2')
      table.insert(M.plugins, 'https://github.com/' .. name .. '.git')
    else
      print('case3')
      -- Case 3: require as module under "nvim.<plugin>"
      local mod_name = 'nvim.' .. plugin:gsub('%.nvim$', '')
      local ok, mod = pcall(require, mod_name)
      if not ok or mod == nil then
        return
      end

      local spec = _to_spec(mod)
      if type(spec) == 'table' and type(spec[1]) == 'table' then
        vim.list_extend(M.plugins, spec)
      else
        table.insert(M.plugins, spec)
      end
    end
  end
end

---@param module string|vim.pack.Spec|PlugSpec
---@return vim.pack.Spec|nil
local function to_spec(module)
  if not M.enabled(module) then
    return nil
  end

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

M.end_ = function()
  vim.pack.add(M.plugins, { confirm = false, load = _load })
end

---@param plugin string|vim.pack.Spec|PlugSpec
---@return vim.pack.Spec[]
function M.import_specs(plugin)
  local specs = setmetatable({}, {
    __newindex = function(t, _, value)
      local spec = to_spec(value)

      if spec then
        rawset(t, #t + 1, spec)
      end
    end,
  })

  specs[1] = plugin

  if type(plugin) == 'table' then
    for _, field in ipairs({ 'dependencies', 'specs' }) do
      local list = plugin[field]
      if type(list) == 'table' then
        for _, f in ipairs(list) do
          specs[#specs + 1] = f
        end
      end
    end
  end

  return specs
end

-- ---@param plug plug_data: { spec: vim.pack.Spec, path: string }
-- local load = function(spec, path)
--   vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter != 0, magic = { file = false } })
-- end

-- Load a plugin module and return its spec table without calling config
M.Plug = function(modname)
  local plugin = require('util').safe_require(modname)

  if plugin then
    local specs = M.import_specs(plugin)

    if #specs > 0 then
      -- rely on default loading behavior (ie packadd with or without !)
      -- and automatically install if starting up
      local opts = {
        confirm = vim.v.vim_did_enter == 0,
        -- load = load,
      }
      vim.pack.add(specs, opts)
    end
  end

  return plugin
end

-- see `:h vim.pack` for more information on the new package manager
--- @alias PackEvents "PackChangedPre" | "PackChanged"

--- @class PackChangedEventData
--- @field kind "install" | "update" | "delete"
--- @field spec vim.pack.Spec
--- @field path string

--- Helper to report build results
--- @param plugin_name string
--- @param ok boolean true if build succeeded, false if failed
--- @param err? string optional error or output
local function notify_build(plugin_name, ok, err)
  local msg = 'Build '
    .. (ok and 'succeeded' or 'failed')
    .. ' for '
    .. plugin_name
    .. (err and (': ' .. err) or '')
  Snacks.notify(msg, ok and 'info' or 'error')
end

-- TODO: fix the function signature
--- Setup an autocmd to trigger a build command when the plugin is updated
--- @param plugin_name string The name of the plugin to track
--- @param build string|fun():string The build command or function to run
M.build = function(plugin_name, build)
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      local data = event.data
      if data.kind ~= 'update' then
        return
      end

      local spec = data.spec
      if not spec or spec.name ~= plugin_name then
        return
      end

      if vim.is_callable(build) then
        local ok, result = pcall(build)
        notify_build(plugin_name, ok, ok and nil or result)
      elseif type(build) == 'string' then
        local cmd = string.format('cd %s && %s', vim.fn.shellescape(spec.dir), build)
        local output = vim.fn.system(cmd)
        notify_build(plugin_name, vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
      else
        notify_build(plugin_name, false, 'Invalid build command type: ' .. type(build))
      end
    end,
  })
end

-- Autocmd setup for lazy configs
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param plugin PlugSpec
M.config = function(plugin)
  if vim.is_callable(plugin.config) then
    if plugin.event then
      vim.api.nvim_create_autocmd(plugin.event, {
        group = aug,
        once = true,
        callback = plugin.config,
      })
    else
      plugin.config()
    end
  end
end

--- Execute all queued plugin configs a la `lazy.nvim`
---@param plugins table<string, PlugSpec>
-- TODO: save a table of names mapped to config functions with the optional event
-- TODO: print for debugging
M.do_configs = function(plugins)
  for name, plugin in pairs(plugins) do
    if plugin.enabled and not M.enabled(plugin) then
      print('Skipping plugin: ' .. name)
    else
      M.config(plugin)
    end
  end
end

---@param plugin any
---@return boolean
M.enabled = function(plugin)
  local enabled = plugin.enabled

  if vim.is_callable(enabled) then
    local ok, res = pcall(enabled)
    return ok and res
  end
  return enabled == nil or enabled == true
end

return setmetatable(M, {
  __call = function(_, modname)
    return M.Plug(modname)
  end,
})
