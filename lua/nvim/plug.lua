---- Extend the `vim.pack.Spec` type with additional fields
---@class PlugSpec : vim.pack.Spec
---@field build? string|fun(): nil
---@field config? fun(): nil
---@field dependencies? (string|vim.pack.Spec|PlugSpec)[]
---@field event? vim.api.keyset.events|vim.api.keyset.events[]
---@field enabled? boolean|fun():boolean
---@field specs? (string|vim.pack.Spec|PlugSpec)[]

local M = {}

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
  }
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
  local plugin = Require(modname)

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
        notify_build(
          plugin_name,
          vim.v.shell_error == 0,
          vim.v.shell_error ~= 0 and output or nil
        )
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
  for _, plugin in pairs(plugins) do
    -- print('Configuring plugin: ' .. name)
    M.config(plugin)
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

vim.api.nvim_create_user_command('PlugClean', function()
  vim.pack.del(vim.tbl_map(
    function(plugin)
      return plugin.spec.name
    end,
    vim.tbl_filter(function(plugin)
      return plugin.active == false
    end, vim.pack.get())
  ))
end, { desc = 'Remove unused plugins' })

vim.api.nvim_create_user_command('Plug', function(args)
  if #args.fargs == 0 then
    print(vim.inspect(vim.pack.get()))
  else
    vim.pack.add({ 'https://github.com/' .. args.fargs[1] })
  end
end, { nargs = '?', desc = 'Add a plugin' })

-- must pass nil to update all plugins with a bang
vim.api.nvim_create_user_command('PlugUpdate', function(opts)
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true })

-- TODO: _G.Plug=require('nvim.plug')
return setmetatable(M, {
  __call = function(_, modname)
    return M.Plug(modname)
  end,
})
