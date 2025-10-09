--- @module "which-key"

--- @class PluginToDo
--- @field commands table<string, fun():nil>
--- @field keys table<string, wk.Spec>
--- @field todo fun()[]
--- @field specs string[]
local M = {
  specs = {}, -- packadd
  todo = {}, -- set up
  keys = {},
  after = {},
  disabled = {},
}

-- keep track of stuff
M.did = vim.defaulttable()

-- TODO:  make an opts keyset

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

-- TODO: cache everthing,
-- recording them in keyed entries
-- then go through the list, skipping the ones that were disabled?

--- @param t table
function Plugin.new(t)
  local self = t
  -- normalize the name
  self.name = self[1]:match('[^/]+$'):gsub('%.nvim$', '')
  --`R.nvim` -> `R` -> `r`
  if #self.name == 1 then
    self.name = self.name:lower()
  end

  return setmetatable(self, Plugin)
end

function Plugin:init()
  if nv.get(self.enabled) == false then
    table.insert(M.disabled, self.name)
    return
  end

  -- add self, optionally extend specs
  M.specs[#M.specs + 1] = self[1]
  -- only blink uses specs. mini should too.
  if nv.is_nonempty_list(self.specs) then
    vim.list_extend(M.specs, self.specs)
  end

  M.todo[self.name] = function()
    if self.event then
      nv.lazyload(function()
        self:setup()
      end, self.event)
    else
      self:setup()
    end
  end

  -- add keys to queue
  -- PERF: use a beeeeg table. or vim.tbl_values?
  local keys = nv.get(self.keys)
  if nv.is_nonempty_list(keys) then
    vim.list_extend(M.keys, keys)
  end

  if vim.is_callable(self.after) then
    vim.schedule(function()
      M.did.after = pcall(self.after)
    end)
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
    local opts = nv.get(self.opts)
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

local dir = vim.fs.joinpath(vim.g.lua_root, 'nvim', 'plugins')
-- HACK: ignore files starting with 'i'
local files = vim.fn.globpath(dir, '[^i]*.lua', false, true)

for _, file in ipairs(files) do
  local modname = file:sub(#vim.g.lua_root + 2, -5)
  local mod = require(modname)
  for _, t in ipairs(vim.islist(mod) and mod or { mod }) do
    local P = Plugin.new(t)
    P:init()
  end
end

return M
