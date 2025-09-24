vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
vim.env.PACKDIR = vim.g.plug_home
local is_nonempty_string = require('nvim.util').is_nonempty_string
local is_nonempty_list = require('nvim.util').is_nonempty_list

local M = {}

local gh = function(s)
  return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
end

--- @param user_repo string plugin (`user/repo`)
--- @param data? any
--- @return string|vim.pack.Spec
local to_spec = function(user_repo, data)
  local spec = {
    src = gh(user_repo),
    name = user_repo:match('([^/]+)$'):gsub('%.nvim$', ''),
    --- HACK: remove this when treesitter is on main
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
  return spec
end

--- Hook to run after a plugin is loaded, immediately after `packadd`
--- @param spec vim.pack.Spec see `spec.data` for custom behavior
--- @param path? string
local on_load = function(spec, path)
  vim.schedule(function()
    vim.print(path)
  end)
end

function M.add(specs)
  vim.pack.add(specs, {
    --- Custom load function for `vim.pack.add`
    --- @param plug_data { spec: vim.pack.Spec, path: string }
    load = function(plug_data)
      local spec = plug_data.spec
      local bang = vim.v.vim_did_enter == 0
      vim.cmd.packadd({ spec.name, bang = bang, magic = { file = false } })
      -- on_load(spec, plug_data.path) -- additional load logic goes here
    end,
  })
end

-- HACK: defer loading this
function M.after()
  local status = (' %d'):format(#vim.pack.get())
  M.status = function()
    return status
  end
end

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

function Plugin.new(plugin)
  local self

  if is_nonempty_string(plugin) then
    -- require it under nvim topmod
    local ok, module = pcall(require, 'nvim.' .. plugin)
    if ok and module then
      self = module
      self.name = plugin
    end
  elseif type(plugin) == 'table' then
    -- check if topmod
    if is_nonempty_string(plugin[1]) then
      -- TODO: use to_spec
      self = plugin
      self.name = plugin[1]:match('([^/]+)$'):gsub('%.nvim$', '')
    end
  end
  if self then
    setmetatable(self, Plugin)
    self:init()
  end
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
-- TODO: rename to :add
-- TODO: only one acll to packadd, don't use M.add
function Plugin:deps() -- TODO: handle [1] in spec
  local specs = { self[1] }
  vim.list_extend(specs, get(self.specs) or {})
  if is_nonempty_list(specs) then
    M.add(vim.tbl_map(to_spec, specs))
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
  print('register autocmd')
  local keys = get(self.keys)
  if is_nonempty_list(keys) then
    nv.lazyload(function()
      print('fire autocmd')
      -- NOTE: do not have to wait for wk if lazyloaded on VimEnter
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

function M.plug(t)
  return Plugin.new(t)
end

return setmetatable(M, {
  __call = function(_, t)
    return M.plug(t)
    -- return Plugin.new(t)
  end,
})
