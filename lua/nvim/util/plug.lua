vim.g.plug_home = vim.fs.joinpath(nv.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.env.PACKDIR = vim.g.plug_home

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

---- @param user_repo string plugin (`user/repo`)
---- @param data? any
---- @return string|vim.pack.Spec
local to_spec = function(user_repo, data)
  if not nv.is_nonempty_string(user_repo) then
    return user_repo
  end

  local src = 'https://github.com/' .. user_repo .. '.git'
  local last = user_repo:find('[^/]+$') or 1
  local name = user_repo:sub(last)
  if name:sub(-5) == '.nvim' then
    name = name:sub(1, -6)
  end

  return {
    src = src,
    name = name,
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
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

  local topspec = nv.is_nonempty_string(self[1]) and to_spec(self[1])
  if topspec then
    self.name = topspec.name
    self.specs = vim.list_extend(self.specs or {}, { topspec })
  end

  return setmetatable(self, Plugin)
end

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

function Plugin:init()
  if self:is_enabled() then
    self:add()
    -- self:build()
    self:do_setup()
    self:do_after()
    self:do_keymaps()
    self:do_commands()
  else
    nv.did.disable[#nv.did.disable + 1] = self.name
  end
end

function Plugin:add()
  if nv.is_nonempty_list(self.specs) then
    local resolved_specs = vim.tbl_map(to_spec, self.specs)
    vim.pack.add(resolved_specs)
  end
end
---
--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:do_setup()
  local setup
  if vim.is_callable(self.config) then
    setup = self.config
  else
    local opts = get(self.opts)
    if type(opts) == 'table' then
      setup = function()
        require(self.name).setup(opts)
      end
    end
  end
  if vim.is_callable(setup) then
    nv.did.setup[self.name] = pcall(setup)
  end
end

function Plugin:do_after()
  nv.lazyload(function()
    if vim.is_callable(self.after) then
      nv.did.after[self.name] = pcall(self.after)
    end
  end)
end

function Plugin:do_keymaps()
  local keys = get(self.keys)
  if nv.is_nonempty_list(keys) then
    nv.lazyload(function()
      local wk = require('which-key')
      nv.did.wk[self.name] = pcall(wk.add, keys)
    end)
  end
end

function Plugin:do_commands()
  if vim.is_callable(self.commands) then
    nv.lazyload(function()
      nv.did.commands[self.name] = pcall(self.commands)
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

return setmetatable(M, {
  __call = function(_, t)
    local P = Plugin.new(t)
    P:init()
    return P
  end,
})
