local M = {}

-- _G.nv = require('nvim.util')
M.speclist = {}

M._after = {} ---@type table<string, fun():nil>
M._keys = {} ---@type table<string, table>
M._commands = {} ---@type table<string, fun():nil>

---@generic T
---@param field T|fun():T
---@return T?
local get = function(field)
  return vim.is_callable(field) and field() or field
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
    -- HACK: remove this when treesitter is no longer a special case
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
end

--- @class Plugin
--- @field [1]?
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
  else
    self.name = ''
  end

  return setmetatable(self, Plugin)
end

M.Plug = function(plugin)
  local P = Plugin.new(plugin)
  if P:is_enabled() then
    if nv.is_nonempty_list(P.specs) then
      local resolved_specs = vim.tbl_map(to_spec, P.specs)
      vim.list_extend(M.speclist, resolved_specs)
    end
    if vim.is_callable(P.after) then
      M._after[P.name] = P.after
    end
    if vim.is_callable(P.commands) then
      M._commands[P.name] = P.commands
    end
  end
  return P
end

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

function Plugin:init()
  if self:is_enabled() then
    self:setup()
    self:do_keymaps()
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

function Plugin:do_keymaps()
  local keys = get(self.keys)
  if nv.is_nonempty_list(keys) then
    nv.lazyload(function()
      local wk = require('which-key')
      nv.did.wk[self.name] = pcall(wk.add, keys)
    end)
  end
end

M.unloaded = function()
  local names = {}
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then
      names[#names + 1] = p.spec.name
    end
  end
  return names
end

M.keys = require('nvim.config.keymaps')
M.commands = require('nvim.config.commands')
M.after = function()
  require('nvim.config.diagnostic')
  require('nvim.config.sourcecode').setup()
end

return M
