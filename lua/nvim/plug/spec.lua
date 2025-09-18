--- @class Plugin
--- @field [1]? string
--- @field after? fun(): nil
--- @field build? string|fun(): nil
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

local safe_require = nv.util.safe_require

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
    info(ok)
  else
    local mod = require(self.name)
    ok, err = pcall(mod.setup, self.opts)
    nv.did.setup[self.name] = ok
  end
  if ok == false then
    vim.notify(string.format('Plugin %s setup failed: %s', self.name, err), vim.log.levels.ERROR)
  end
end

local function is_nonempty_string(x)
  return type(x) == 'string' and x ~= ''
end

local function is_nonempty_list(t)
  return vim.islist(t) and #t > 0
end

-- TODO: use snacks?
local on_module = require('nvim.util.module').on_module

function Plugin:on_load()
  -- loads after VimEnter and on module
  if vim.is_callable(self.after) then
    -- on_module(self.name, function()
    self.after()
    vim.list_extend(nv.did.after, { self.name })
    -- end)
  end
end

function Plugin:apply_keymaps()
  local keys = get(self.keys)
  -- info(keys)
  if is_nonempty_list(keys) then
    -- on_module('which-key', function()
      --- @diagnostic disable-next-line: param-type-mismatch
      require('which-key').add(keys)
      vim.list_extend(nv.did.wk, { self.name })
    -- end)
  end
end

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
--- Lazy-load a function on its event or on VimEnter by default.
---@param cb fun() The function to call when the event fires
---@param event? string|string[] The Neovim event(s) to watch (default: VimEnter)
---@param pattern? string|string[] Optional pattern for events like FileType
local function lazyload(cb, event, pattern)
  vim.api.nvim_create_autocmd(event or 'VimEnter', {
    callback = function(ev)
      cb()
    end,
    group = aug,
    once = true,
    pattern = pattern and pattern or '*',
  })
end

--- If there are any dependencies, `vim.pack.add()` them
--- Dependencies are not initialized or configured, just installed
--- and are assumed to be in the form `user/repo`
function Plugin:deps()
  local specs = get(self.specs)
  if is_nonempty_list(specs) then
    nv.plug(specs)
  end
end

function Plugin:init()
  self:deps()
  self:setup()

  -- vim.schedule(function()
  lazyload(function()
    self:on_load()
    self:apply_keymaps()
  end)
  -- end)
end

function Plugin.new(t)
  local self
  local plug
  local name

  if type(t) == 'table' then
    plug = t
  elseif is_nonempty_string(t) then
    name = t
    -- try to require the module under nvim
    local ok, module = pcall(require, 'nvim.' .. t)
    if ok and module then
      plug = module
    end
  end
  -- plug[1] = plug[1] or t
  self = setmetatable(plug or {}, Plugin)
  self.name = self.name or name or self[1] or 'N/A'
  self.opts = self.opts or {}
  return self
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
