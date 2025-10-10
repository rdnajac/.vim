-- _G.nv = _G.nv or require('nvim.util')
local lazyload = require('nvim.util').lazyload

-- TODO:  make an opts keyset

--- @class Plugins
--- @field Plug fun(t:table):Plugin
--- @field did table<string, boolean> Tracks plugin fun calls
--- @field specs string[] List of plugins (`user/repo`)
--- @field disabled string[] List of disabled plugin (`user/repo`)
--- @field keys table<string, wk.Spec> Key mappings to create
--- @field todo table<string, fun():nil> Functions to call to setup plugins
local M = {
  did = vim.defaulttable(),
  specs = {},
  disabled = {},
  keys = {},
  todo = {},
}

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field name string The plugin name, derived from [1]
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil Callback after plugin is installed/updated.
--- @field config? fun():nil Function to run to configure the plugin.
--- @field enabled? boolean|fun():boolean Whether the plugin is disabled.
--- @field event? string
--- @field keys? wk.Spec|fun():wk.Spec Key mappings to create.
--- @field opts? table|fun():table Options to pass to the plugin's `setup()`.
--- @field specs? string[] Additional plugin specs in `user/repo` format.
local Plugin = {}
Plugin.__index = Plugin

--- @param t table
function Plugin.new(t)
  local self = t
  self.name = self[1]:match('[^/]+$'):gsub('%.nvim$', '')
  if #self.name == 1 then --`R.nvim` -> `R` -> `r`
    self.name = self.name:lower()
  end
  return setmetatable(self, Plugin)
end

setmetatable(M, {
  -- __call = Plugin.new,
  __call = function(_, k)
    return Plugin.new(k)
  end,
})

--- @generic T
--- @param x T|fun():T
--- @return T
local function get(x)
  return type(x) == 'function' and x() or x
end

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

function Plugin:init()
  local enabled = self:is_enabled()
  local speclist = { self[1] }

  if vim.islist(self.specs) then
    vim.list_extend(speclist, self.specs)
  end
  vim.list_extend(M[enabled and 'specs' or 'disabled'], speclist)

  if enabled then
    M.keys[self.name] = get(self.keys) or nil
    M.todo[self.name] = function()
      -- TODO: if lazy = true, lazyload with default nil param
      if self.event then
        nv.lazyload(function()
          self:setup()
        end, self.event)
      elseif self.ft then
        lazyload(function()
          self:setup()
        end, 'FileType', self.ft)
      else
        self:setup()
      end
    end
    if vim.is_callable(self.after) then
      vim.schedule(function()
        M.did.after[self.name] = pcall(self.after)
      end)
    end
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
-- PERF: skip trying to get opts if there is a config
-- TODO: handle config = true and no opts
function Plugin:setup()
  local setup = vim.is_callable(self.config) and self.config or nil
  -- try to guess setup function if opts and no config
  if not setup then
    local opts = get(self.opts)
    if type(opts) == 'table' then
      setup = function()
        require(self.name).setup(opts)
      end
    end
  end
  -- call setup
  if vim.is_callable(setup) then
    M.did.setup[self.name] = pcall(setup)
  end
end

lazyload(function()
  require('which-key').add(vim.tbl_values(M.keys))
end)

return M
