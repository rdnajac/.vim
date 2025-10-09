local M = {}

-- _G.nv = require('nvim.util')
M._specs = {}
M._after = {} ---@type table<string, fun():nil>
M._keys = {} ---@type table<string, table>
M._commands = {} ---@type table<string, fun():nil>

---@generic T
---@param field T|fun():T
---@return T?
local get = function(field)
  return vim.is_callable(field) and field() or field
end

-- TODO: use data for the plugin class

--- @param user_repo string plugin (`user/repo`)
--- @param data? any
--- @return string|vim.pack.Spec
local to_spec = function(user_repo, data)
  if not nv.is_nonempty_string(user_repo) then
    return user_repo
  end

  local src = 'https://github.com/' .. user_repo .. '.git'
  -- local last = user_repo:find('[^/]+$') or 1
  -- local name = user_repo:sub(last)
  -- if name:sub(-5) == '.nvim' then
  --   name = name:sub(1, -6)
  -- end

  return {
    src = src,
    -- name = name,
    -- HACK: remove this when treesitter is no longer a special case
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
end

--- @class Plugin
--- @field [1]? string The plugin name in `user/repo` format.
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil
--- @field commands? fun():nil Ex commands to create.
--- @field config? fun():nil Function to run to configure the plugin.
--- @field enabled? boolean|fun():boolean
--- @field keys? wk.Spec|fun():wk.Spec
--- @field specs? string[]
--- @field opts? table|fun():table
--- TODO: can we get it from the spec instead?
--- @field name string The plugin name, derived from [1]
local Plugin = {}
Plugin.__index = Plugin

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

--- @param plugin table
function Plugin.new(t)
  local self = setmetatable(t, Plugin)

  -- normalize some fields
  -- this is not the same as the spec name
  self.name = self[1]:match('[^/]+$'):gsub('%.nvim$', '')
  -- handles R.nvim
  -- if #self.name == 1 then
  -- self.name = self.name:upper()
  -- end
  self.specs = vim.list_extend(self.specs or {}, { self[1] })

  -- TODO: move to init when setup loader is ready
  if self:is_enabled() then
    vim.list_extend(M._specs, vim.tbl_map(to_spec, self.specs))
  end

  return self
end

M.Plug = Plugin.new

function Plugin:init()
  if self:is_enabled() then
    -- TODO: move setup to a lazyloader
    self:setup()

    if vim.is_callable(self.after) then
      M._after[self.name] = self.after
    end

    if vim.is_callable(self.commands) then
      M._commands[self.name] = self.commands
    end

    local keys = get(self.keys)
    if nv.is_nonempty_list(keys) then
      -- table.insert(M._keys, keys)
      vim.list_extend(M._keys, keys)
    end
  else
    nv.did.disable[#nv.did.disable + 1] = self.name
  end
end
---
--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
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

return M
