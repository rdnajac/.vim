local utils = require('nvim.plug')

--- @class Plugin
--- @field [1]? string
--- @field after? fun(): nil
--- @field build? string|fun(): nil
--- @field config? fun(): nil
--- @field event? vim.api.keyset.events|vim.api.keyset.events[]
--- @field enabled? boolean|fun():boolean
--- @field specs? string[]|fun():string[]
--- @field opts? table|fun():table
--- TODO: can we get it from the spec instead?
--- @field name string The plugin name, derived from [1]
local Plugin = {}
Plugin.__index = Plugin

--- Determine if the plugin is enabled.
function Plugin:is_enabled()
  if vim.is_callable(self.enabled) then
    ---@diagnostic disable-next-line: param-type-mismatch
    local ok, res = pcall(self.enabled)
    return ok and res
  end
  return self.enabled ~= false
end

--- Call the plugin's `config` function if it exists, otherwise
--- call the plugin's `setup` function with `opts` if it exists.
--- If `opts` is a function, call it to get the options table.
--- If neither `config` nor `opts` exist, call `setup` with an empty table.
--- Assumes the plugin has already been loaded with `packadd`.
function Plugin:setup()
  if vim.is_callable(self.config) then
    -- info('configuring ' .. self.name)
    self.config()
  else
    local opts = self.opts
    if opts and vim.is_callable(opts) then
      opts = opts()
    end
    -- info('setting up ' .. self.name)
    require(self.name).setup(opts or {})
  end
  -- TODO: test for success?
  table.insert(nv.did_setup, self.name)
end

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
--- Lazy-load a plugin based on its event or call init immediately
---@param cb fun() The function to call when the event fires
---@param event string|string[] The Neovim event(s) to watch
---@param pattern? string|string[] Optional pattern for events like FileType
local function lazyload(cb, event, pattern)
  vim.api.nvim_create_autocmd(event, {
    callback = function(ev)
      -- info(ev)
      cb()
    end,
    group = aug,
    once = true,
    pattern = pattern and pattern or '*',
  })
end

function Plugin:init()
  if not self:is_enabled() then
    return
  end

  local _init = function()
    utils.packadd(self.name) -- add the plugin to runtimepath
    self:setup() -- call config or setup
    self:deps() -- add any dependencies
  end

  if self.event then
    lazyload(_init, self.event)
  else
    _init()
  end

  if self.after and vim.is_callable(self.after) then
    require('munchies').on_module(self.name, function()
      self.after()
    end)
  end
end

--- If there are any dependencies, `vim.pack.add()` them
--- Dependencies are not initialized or configured, just installed
--- and are assumed to be in the form `user/repo`
function Plugin:deps()
  -- info ('checking deps for ' .. self.name)
  local specs = self.specs
  -- info(specs)
  if specs and vim.is_callable(specs) then
    specs = specs()
  end
  if type(specs) == 'table' and #specs > 0 then
    local deps = vim.tbl_map(utils.spec, specs)
    -- info(deps)
    utils.plug(deps)
  end
end

function Plugin.new(t)
  local self = setmetatable(t, Plugin)
  self.name = t[1]:match('[^/]+$'):gsub('%.nvim$', '')
  -- info(self.name)
  return self
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
