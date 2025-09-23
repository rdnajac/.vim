local to_spec = require('nvim.plug').to_spec
local is_nonempty_string = require('nvim.util').is_nonempty_string
local is_nonempty_list = require('nvim.util').is_nonempty_list

--- @class Plugin
--- @field [1]? string
--- @field after? fun(): nil
--- @field build? string|fun(): nil
--- @field commands? fun(): nil
--- @field config? fun(): nil
--- @field enabled? boolean|fun():boolean
--- @field keys? wk.Spec|fun():wk.Spec
--- @field lazy? boolean
--- @field specs? string[]|fun():string[]
--- @field opts? table|fun():table
--- TODO: can we get it from the spec instead?
--- @field name string The plugin name, derived from [1]
local Plugin = {}
Plugin.__index = Plugin

function Plugin.new(modname)
  local plug, name

  if is_nonempty_string(modname) then
    print('got string ' .. modname)
    local ok, mod = pcall(require, 'nvim.' .. modname)
    if not ok or not mod then
      print('got bad module: ' .. modname)
      return nil
    end
    plug = mod
    plug.name = modname
  elseif type(modname) == 'table' then
    plug = modname
  else
    return nil
  end

  -- normalize the repo string
  if is_nonempty_string(plug[1]) then
    local repo = plug[1]
    plug.name = repo:match('([^/]+)$'):gsub('%.nvim$', '')
    vim.pack.add({
      {
        src = 'https://github.com/' .. repo .. '.git',
        name = name,
      },
    })
  end
  local self = setmetatable(plug, Plugin)
  print(self.name)
  self:init()
  return self
end

-- TODO: should this be an `__index`
--- Get the value or evaluate the function for a field safely
---@generic T
---@param field T|fun():T
---@return T?
local function get(field)
  if vim.is_callable(field) then
    local ok, res = xpcall(field, debug.traceback)
    if ok then
      return res
    else
      vim.schedule(function()
        vim.notify(('Error evaluating field: %s'):format(res), vim.log.levels.ERROR)
      end)
      return nil
    end
  end
  return field
end

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

function Plugin:init()
  if self:is_enabled() then
    self:deps()
    self:setup()
    self:on_load()
    self:apply_commands()
    self:apply_keymaps()
  end
end

--- If there are any dependencies, `vim.pack.add()` them
--- Dependencies are not initialized or configured, just installed
--- and are assumed to be in the form `user/repo`
function Plugin:deps() -- TODO: handle [1] in spec
  local specs = get(self.specs)
  if is_nonempty_list(specs) or is_nonempty_string(specs) then
    vim.schedule(function()
      local speclist = vim.islist(specs) and specs or { specs }
      --- @cast speclist string[]
      local resolved = vim.tbl_map(to_spec, speclist)
      vim.pack.add(resolved)
    end)
  end
end

--- Call the plugin's `config` function if it exists, otherwise
--- call the plugin's `setup` function with `opts` if it exists.
--- If `opts` is a function, call it to get the options table.
--- If neither `config` nor `opts` exist, call `setup` with an empty table.
--- Assumes the plugin has already been loaded with `packadd`.
function Plugin:setup()
  local ok, err
  if vim.is_callable(self.config) then
    nv.did.config[self.name] = pcall(self.config)
  else
    local opts = get(self.opts)
    if type(opts) == 'table' then
      local mod = require(self.name) -- TODO: safe require
      ok, err = pcall(mod.setup, opts)
      if not ok then
        err = string.format('Error calling setup for %s with opts: %s', self.name, err)
      end
      nv.did.setup[self.name] = ok
    end
  end
end

function Plugin:on_load()
  if vim.is_callable(self.after) then
    nv.did.after[self.name] = pcall(self.after)
  end
end

function Plugin:apply_keymaps()
  local keys = get(self.keys)
  if is_nonempty_list(keys) then
    nv.lazyload(function()
      -- Snacks.util.on_module('which-key', function()
      local wk = require('which-key')
      nv.did.wk[self.name] = pcall(wk.add, keys)
      -- end)
    end)
  end
end

function Plugin:apply_commands()
  if vim.is_callable(self.commands) then
    nv.lazyload(function()
      nv.did.commands[self.name] = pcall(self.commands)
    end, 'CmdLineEnter')
  end
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
