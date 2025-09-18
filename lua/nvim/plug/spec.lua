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
    print('configuring ' .. self.name)
    self.config()
  else
    local opts = self.opts and vim.is_callable(self.opts) and self.opts() or self.opts
    print('setting up ' .. self.name)
    require(self.name).setup(opts or {})
  end
  -- TODO: test for success?
  table.insert(nv.did_setup, self.name)
end

-- TODO: use snacks?
local on_module = require('nvim.util.module').on_module

function Plugin:on_load()
  -- loads after VimEnter and on module
  if vim.is_callable(self.after) then
    on_module(self.name, function()
      self.after()
    end)
  end
end

function Plugin:apply_keymaps()
  local keys = vim.is_callable(self.keys) and self.keys() or self.keys
  if vim.islist(keys) and #keys > 0 then
    on_module('which-key', function()
      --- @diagnostic disable-next-line: param-type-mismatch
      require('which-key').add(keys)
    end)
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
      -- info(ev)
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
  -- info ('checking deps for ' .. self.name)
  local specs = self.specs
  -- info(specs)
  if specs and vim.is_callable(specs) then
    specs = specs()
  end
  if type(specs) == 'table' and #specs > 0 then
    local deps = vim.tbl_map(nv.plug.to_spec, specs)
    -- info(deps)
    nv.plug.plug(deps)
  end
end

function Plugin:init()
  if not self:is_enabled() then
    return
  end

  local lazy = self.lazy == true -- opt-in

  if not lazy then
    self:setup()
    self:deps()
  end

  lazyload(function()
    if lazy then
      self:setup()
      self:deps()
    end -- alawys lazy load these 
    self:on_load() -- call after if it exist
    self:apply_keymaps() -- call after if it exist
  end)
end

function Plugin.new(t)
  local self = setmetatable(t, Plugin)
  self.name = t.name or t[1]:match('[^/]+$'):gsub('%.nvim$', '')
  -- if not name then info(t) end
  return self
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
