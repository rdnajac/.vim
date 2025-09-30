vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
vim.env.PACKDIR = vim.g.plug_home

local did = vim.defaulttable()
local util = require('nvim.util')
local M = {}

--- Safely get a value or evaluate a function field
---@generic T
---@param field T|fun():T
---@return T?
local get = function(field)
  if type(field) == 'function' then
    local ok, res = pcall(field)
    if ok then
      return res
    else
      vim.schedule(function()
        vim.notify('Error evaluating field: ' .. tostring(res), vim.log.levels.ERROR)
      end)
      return nil
    end
  end
  return field
end

--- Hook to run after a plugin is loaded, immediately after `packadd`
--- @param spec vim.pack.Spec see `spec.data` for custom behavior
--- @param path? string
local on_load = function(spec, path)
  vim.schedule(function()
    vim.print(path)
  end)
end

local gh = function(s)
  return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
end

---- @param user_repo string plugin (`user/repo`)
---- @param data? any
---- @return string|vim.pack.Spec
local to_spec = function(user_repo, data)
  -- vim.validate(
  if not util.is_nonempty_string(user_repo) then
    return user_repo
  end
  local spec = {
    src = gh(user_repo),
    name = user_repo:match('([^/]+)$'):gsub('%.nvim$', ''),
    -- HACK: remove this when treesitter is on main
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
  return spec
end

--- @class Plugin
--- @field [1]? string
--- @field after? fun():nil
--- @field build? string|fun():nil
--- @field commands? fun():nil
--- @field config? fun():nil
--- @field enabled? boolean|fun():boolean
--- @field keys? wk.Spec|fun():wk.Spec
--- @field specs? string[]
--- @field opts? table|fun():table
--- TODO: can we get it from the spec instead?
--- @field name string The plugin name, derived from [1]
local Plugin = {}
Plugin.__index = Plugin

--- @param plugin table
function Plugin.new(plugin)
  local self = plugin

  local topspec = util.is_nonempty_string(self[1]) and to_spec(self[1])
  if topspec then
    self.name = topspec.name
    self.specs = vim.list_extend(self.specs or {}, { topspec })
  end

  return setmetatable(self, Plugin)
end

function Plugin:add()
  if util.is_nonempty_list(self.specs) then
    local resolved_specs = vim.tbl_map(to_spec, self.specs)
    vim.pack.add(resolved_specs)
  end
end

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

function Plugin:init()
  if self:is_enabled() then
    self:add()
    -- self:build()
    self:setup()
    self:do_after()
    self:do_keymaps()
    self:do_commands()
  else
    did.disabled[self.name] = true
  end
end

-- TODO: don't do fn if already done
-- function Plugin:do(fn, field, cond, event)
--   local value = self[field]
--   if cond(value) then
--   util.lazyload(function()
--     did[field][self.name] = pcall(fn, value)
--   end, event)
--   end
-- end

--- Call the plugin's `config` function if it exists, otherwise
--- call the plugin's `setup` function with `opts` if it exists.
--- If `opts` is a function, call it to get the options table.
--- If neither `config` nor `opts` exist, call `setup` with an empty table.
--- Assumes the plugin has already been loaded with `packadd`.
function Plugin:setup()
  -- TODO: set self.config = single function instead of checking here
  if vim.is_callable(self.config) then
    did.config[self.name] = pcall(self.config)
  else
    local opts = get(self.opts)
    if type(opts) == 'table' then
      local mod = require(self.name)
      did.setup[self.name] = pcall(mod.setup, opts)
    end
  end
end

function Plugin:do_after()
  util.lazyload(function()
    if vim.is_callable(self.after) then
      did.after[self.name] = pcall(self.after)
    end
  end)
end

function Plugin:do_keymaps()
  local keys = get(self.keys)
  if util.is_nonempty_list(keys) then
    util.lazyload(function()
      local wk = require('which-key')
      did.wk[self.name] = pcall(wk.add, keys)
    end)
  end
end

function Plugin:do_commands()
  if vim.is_callable(self.commands) then
    util.lazyload(function()
      did.commands[self.name] = pcall(self.commands)
    end, 'CmdLineEnter')
  end
end

M.unloaded = function()
  local it = vim.iter(vim.pack.get())
  return it
    --- @param p vim.pack.PlugData
    :filter(function(p)
      return p.active == false
    end)
    --- @param p vim.pack.PlugData
    :map(function(p)
      return p.spec.name
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

  -- TODO: take optional names with a completion list
  command('PlugStatus', function(opts)
    local plugin = util.is_nonempty_string(opts.fargs) and opts.fargs or nil
    vim._print(true, vim.pack.get(plugin, { info = opts.bang }))
  end, {
    bang = true,
    nargs = '*',
    complete = function()
      return vim.tbl_map(function(p)
        return p.spec.name
      end, vim.pack.get())
    end,
  })

  command('Plugins', function()
    local active, inactive = {}, {}
    for _, p in ipairs(vim.pack.get()) do
      if p.active then
        table.insert(active, p.spec.name)
      else
        table.insert(inactive, p.spec.name)
      end
    end
    print(
      string.format(
        'Plugins: %d total (%d active, %d inactive)',
        #active + #inactive,
        #active,
        #inactive
      )
    )
    print('\nActive:\n' .. table.concat(active, '\n'))
    print('\nInactive:\n' .. table.concat(inactive, '\n'))
  end, {})

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

util.lazyload(function()
  M.commands()
  nv.did = did
end, 'CmdLineEnter')

return setmetatable(M, {
  __call = function(_, t)
    local P = Plugin.new(t)
    P:init()
    return P
  end,
})
