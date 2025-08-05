-- `$XDG_DATA_HOME/nvim/site/pack/core/opt`.
-- /Users/rdn/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:198
-- `return vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')`

---- Extend the `vim.pack.Spec` type with additional fields
---@class PlugSpec : vim.pack.Spec
---@field build? string|fun(): nil
---@field config? fun(): nil
---@field dependencies? (string|PlugSpec)[]
---@field event? vim.api.keyset.events|vim.api.keyset.events[]
---@field enabled? boolean|fun():boolean
---@field priority? number

local M = {}

---@param plugin PlugSpec
---@return boolean
local function is_enabled(plugin)
  local enabled = plugin.enabled
  if type(enabled) == 'function' then
    local ok, res = pcall(enabled)
    return ok and res
  end
  return enabled == nil or enabled
end

---@param module string|vim.pack.Spec|PlugSpec
---@return vim.pack.Spec|nil
M.to_spec = function(module)
  if not is_enabled(module) then
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

-- TODO: when to build?
-- plug.build(name, plugin)
---@param name string
---@param plugin PlugSpec
M.build = function(name, plugin)
  if plugin.build then
    require('nvim.plug.build')(name, plugin.build)
  end
end

-- Autocmd setup for lazy configs
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param name string
---@param plugin PlugSpec
local function config(plugin)
  if type(plugin.config) == 'function' then
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
M.do_configs = function(plugins)
  for name, plugin in pairs(plugins) do
    if is_enabled(plugin) then
      config(plugin)
    end
  end
end

vim.api.nvim_create_user_command('Plug', function(args)
  if #args.fargs == 0 then
    print(vim.inspect(vim.pack.get()))
  else
    vim.pack.add({ 'https://github.com/' .. args.fargs[1] })
  end
end, { nargs = '?', force = true })

-- must pass nil to update all plugins with a bang
vim.api.nvim_create_user_command('PlugUpdate', function(opts)
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true, force = true })

-- vim.api.nvim_create_user_command('PlugClean', function(opts)
-- get plugins and see whats not bring used
-- restart +qall! lua vim.pack.update()

return M
