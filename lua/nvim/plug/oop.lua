vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
vim.env.PACKDIR = vim.g.plug_home

local is_nonempty_string = require('nvim.util').is_nonempty_string
local is_nonempty_list = require('nvim.util').is_nonempty_list
local lazyload = require('nvim.util').lazyload
local gh = function(s)
  return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
end

nv.did = vim.defaulttable()

-- TODO: stronger overlap between spec and plugin esp. `name` field

---
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
local M = {}
M.__index = M

-- TODO: use to_spec here
function M.new(plugin)
  local self
  if is_nonempty_string(plugin) then
    self = nv.util.xprequire('nvim.' .. plugin, false)
    if self then
      if is_nonempty_string(self[1]) then
        self.name = self[1]:match('([^/]+)$'):gsub('%.nvim$', '')
      else
        self.name = plugin
      end
    end
  elseif type(plugin) == 'table' then
    if is_nonempty_string(plugin[1]) then
      self = plugin
      self.name = plugin[1]:match('([^/]+)$'):gsub('%.nvim$', '')
    end
  end

  if self then
    setmetatable(self, M)
    self:init()
  end
  return self
end

--- Get the value or evaluate the function for a field safely
---@generic T
---@param field T|fun():T
---@return T?
local function get(field)
  -- return vim.is_callable(field) and field() or field
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

function M:is_enabled()
  return get(self.enabled) ~= false
end

function M:init()
  if self:is_enabled() then
    self:add()
    -- self:build()
    self:setup()
    lazyload(function()
      if vim.is_callable(self.after) then
        nv.did.after[self.name] = pcall(self.after)
      end
      self:apply_keymaps()
    end)
    self:apply_commands()
  else
    nv.did.disabled[self.name] = true
  end
end

function M:add()
  --- @type string[]
  local specs = vim.list_extend({ self[1] }, self.specs or {})
  if is_nonempty_list(specs) then
    local resolved_specs = vim.tbl_map(to_spec, specs)
    vim.pack.add(resolved_specs, {
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
end

--- Call the plugin's `config` function if it exists, otherwise
--- call the plugin's `setup` function with `opts` if it exists.
--- If `opts` is a function, call it to get the options table.
--- If neither `config` nor `opts` exist, call `setup` with an empty table.
--- Assumes the plugin has already been loaded with `packadd`.
function M:setup()
  -- TODO: set self.config = single function instead of checking here
  if vim.is_callable(self.config) then
    nv.did.config[self.name] = pcall(self.config)
  else
    local opts = get(self.opts)
    if type(opts) == 'table' then
      -- if self.name == 'which-key' then bt() end
      local mod = require(self.name)
      nv.did.setup[self.name] = pcall(mod.setup, opts)
    end
  end
  if vim.is_callable(self.on_load) then
    self.on_load()
  end
end

function M:apply_keymaps()
  local keys = get(self.keys)
  if is_nonempty_list(keys) then
    track('wk: '..self.name)
    local wk = require('which-key')
    nv.did.wk[self.name] = pcall(wk.add, keys)
  end
end

function M:apply_commands()
  if vim.is_callable(self.commands) then
    lazyload(function()
      nv.did.commands[self.name] = pcall(self.commands)
    end, 'CmdLineEnter')
  end
end

return M
