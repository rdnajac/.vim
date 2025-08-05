-- use nvim's native package manager to clone plugins and load them
-- Manages plugins only in a dedicated [vim.pack-directory]() (see |packages|):
-- `$XDG_DATA_HOME/nvim/site/pack/core/opt`.
-- vim.g.PACKDIR = vim.fn.stdpath('data') .. '/site/pack/core/opt/'
-- /Users/rdn/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:198
-- `return vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')`
vim.g.PACKDIR = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/')

---- Extend the `vim.pack.Spec` type with additional fields
---@class PlugSpec : vim.pack.Spec
---@field build? string|fun(): nil
---@field config? fun(): nil
---@field dependencies? (string|PlugSpec)[]
---@field event? vim.api.keyset.events|vim.api.keyset.events[]
---@field enabled? boolean|fun():boolean
---@field priority? number

local M = {}

---@param module any
---@return boolean
M.is_enabled = function(module)
  if type(module) ~= 'table' then
    return true
  end
  local enabled = module.enabled
  if enabled == nil then
    return true
  end
  if type(enabled) == 'function' then
    local ok, res = pcall(enabled)
    return ok and res
  end
  return enabled
end

---@param module string|vim.pack.Spec|PlugSpec
---@return vim.pack.Spec|nil
M.to_spec = function(module)
  if not M.is_enabled(module) then
    return nil
  end

  local src = type(module) == 'string' and module or module[1] or module.src
  if type(src) ~= 'string' or src == '' then
    return nil
  end

  if src:match('^%S+/%S+$') and not src:match('^https?://') and not src:match('^~/') then
    src = 'https://github.com/' .. src
  end

  return {
    src = src,
    name = type(module) == 'table' and module.name or nil,
    version = type(module) == 'table' and module.version or nil,
  }
end

---@param name string
---@param plugin PlugSpec
M.build = function(name, plugin)
  if plugin.build then
    require('nvim.plug.build')(name, plugin.build)
  end
end

-- Autocmd setup for lazy configs
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param event string|string[]
---@param config fun(): nil
M.lazyload = function(event, config)
  vim.api.nvim_create_autocmd(event, {
    group = aug,
    once = true,
    callback = config,
  })
end

local start_configs = {}

--- Queue plugin config for execution
---@param name string
---@param plugin PlugSpec
M.config = function(name, plugin)
  if type(plugin.config) ~= 'function' then
    return
  end

  if plugin.event then
    M.lazyload(plugin.event, plugin.config)
  else
    local entry = { name, plugin.config }
    if plugin.priority and plugin.priority ~= 0 then
      table.insert(start_configs, 1, entry)
    else
      table.insert(start_configs, entry)
    end
  end
end

--- Execute all queued plugin configs
M.do_configs = function()
  for _, entry in ipairs(start_configs) do
    local ok, err = pcall(entry[2])
    if not ok then
      vim.notify(('Failed to configure plugin "%s": %s'):format(entry[1], err), vim.log.levels.ERROR)
    end
  end
end

--- Collect valid plugin specs (with dependencies) for `vim.pack.add`
---@param plugins table<string, PlugSpec>
---@return vim.pack.Spec[]
M.collect_specs = function(plugins)
  local specs = {}

  local function add(module)
    local spec = M.to_spec(module)
    if spec then
      table.insert(specs, spec)
    end
  end

  for _, plugin in pairs(plugins) do
    add(plugin)
    if type(plugin.dependencies) == 'table' then
      for _, dep in ipairs(plugin.dependencies) do
        add(dep)
      end
    end
  end

  return specs
end

-- vim.api.nvim_create_user_command('Plug', function(args)
--   assert(type(args.fargs) == 'table', 'Plug command requires a table argument')
--   vim.pack.add(args.fargs)
-- end, { nargs = '*', force = true })
vim.api.nvim_create_user_command('PackUpdate', function(opts)
  -- must pass nil to update all plugins
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true })

-- restart +qall! lua vim.pack.update()

return M
