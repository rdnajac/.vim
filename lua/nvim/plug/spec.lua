local util = require('nvim.util')
local to_spec = require('nvim.plug').to_spec
local is_nonempty_string = util.is_nonempty_string
local is_nonempty_list = util.is_nonempty_list

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
  local plug
  -- vim.validate('modname', is_nonempty_string, 'string', true)
  -- try to require the module under nvim
  -- TODO pcall snippet
  local ok, module = pcall(require, 'nvim.' .. modname)
  if ok and module then
    plug = module
  end
  if is_nonempty_string(module[1]) then vim.pack.add({{
    src = 'http://github.com/'..module[1]..'.git',
    name = modname,
  }}) end
  -- here we have the module, we should check if there is a titlespec
  local self = setmetatable(plug or {}, Plugin)
  self.name = self.name or modname -- XXX:
  -- init
  self:deps()
  self:setup()
  self:on_load()
  self:apply_commands()
  self:apply_keymaps()
  return self
end

-- TODO: should this be an `__index`
--- Get the value or evaluate the function for a field safely
---@generic T
---@param field T|fun():T
---@return T|nil
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

--- If there are any dependencies, `vim.pack.add()` them
--- Dependencies are not initialized or configured, just installed
--- and are assumed to be in the form `user/repo`
function Plugin:deps() -- TODO: handle [1] in spec
  local specs = get(self.specs)
  if is_nonempty_list(specs) or is_nonempty_string(specs) then
    vim.schedule(function()
  local speclist = vim.islist(specs) and specs or { specs }
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
    ok, err = pcall(self.config)
    nv.did.config[self.name] = ok
  else
    local opts = get(self.opts)
    if type(opts) == 'table' then
    local mod = require(self.name) -- TODO: safe require
    ok, err = pcall(mod.setup, opts)
    nv.did.setup[self.name] = ok
    end
  end
  if ok == false then
    vim.notify(string.format('Plugin %s setup failed: %s', self.name, err), vim.log.levels.ERROR)
  end
end

function Plugin:on_load()
  -- TODO: does this need to guard against unloaded modules?
  -- we assume it is only run after `packadd` in the load func
  if vim.is_callable(self.after) then
    local ok, err = pcall(self.after)
    nv.did.after[self.name] = ok
    vim.list_extend(nv.did.after, { self.name })
  end
end

function Plugin:apply_keymaps()
  local keys = get(self.keys)
  if is_nonempty_list(keys) then
    nv.lazyload(function()
      -- Snacks.util.on_module('which-key', function()
      --- @diagnostic disable-next-line: param-type-mismatch
      require('which-key').add(keys)
      vim.list_extend(nv.did.wk, { self.name })
      -- end)
    end)
  end
end

function Plugin:apply_commands()
  if vim.is_callable(self.commands) then
    nv.lazyload(function()
      self:commands()
      vim.list_extend(nv.did.commands, { self.name })
    end, 'CmdLineEnter')
  end
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
