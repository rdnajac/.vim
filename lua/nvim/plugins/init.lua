_G.nv = _G.nv or {}
_G.nv.todo = {
  specs = {},
  after = {},
  commands = {},
  keys = {},
}

---@generic T
---@param field T|fun():T
---@return T?
local get = function(field)
  return vim.is_callable(field) and field() or field
end

--- @param user_repo string plugin (`user/repo`)
--- @return vim.pack.Spec
local to_spec = function(user_repo)
  return {
    src = 'https://github.com/' .. user_repo .. '.git',
    -- HACK: remove this when treesitter defaults to `main`
    version = vim.startswith(user_repo, 'nvim-treesitter') and 'main' or nil,
  }
end

--- @class Plugin
--- @field [1] string The plugin name in `user/repo` format.
--- @field name string The plugin name, derived from [1]
--- @field after? fun():nil Commands to run after the plugin is loaded.
--- @field build? string|fun():nil
--- @field commands? fun():nil Ex commands to create.
--- @field config? fun():nil Function to run to configure the plugin.
--- @field enabled? boolean|fun():boolean
--- @field keys? wk.Spec|fun():wk.Spec
--- @field specs? string[]
--- @field opts? table|fun():table
local Plugin = {}
Plugin.__index = Plugin

function Plugin:is_enabled()
  return get(self.enabled) ~= false
end

--- @param t table
function Plugin.new(t)
  local self = setmetatable(t, Plugin)

  self.name = self[1]:match('[^/]+$'):gsub('%.nvim$', '')
  -- handles R.nvim
  -- if #self.name == 1 then
  -- self.name = self.name:upper()
  -- end
  self.specs = vim.list_extend(self.specs or {}, { self[1] })
  self.specs = vim.list.unique(self.specs)

  -- TODO: move to init when setup loader is ready
  if self:is_enabled() then
    vim.list_extend(nv.todo.specs, vim.tbl_map(to_spec, self.specs))
  end

  return self
end

function Plugin:init()
  if self:is_enabled() then
    self:setup()

    if vim.is_callable(self.after) then
      nv.todo.after[self.name] = self.after
    end

    if vim.is_callable(self.commands) then
      nv.todo.commands[self.name] = self.commands
    end

    local keys = get(self.keys)
    if nv.is_nonempty_list(keys) then
      nv.todo.keys[self.name] = keys
    else
      print(self.name .. ' has no keys')
    end
  else
    nv.did.disable[#nv.did.disable + 1] = self.name
  end
end

--- Call the `Plugin`'s `config` function if it exists, otherwise
--- call the named module's `setup` function with `opts` they exist.
function Plugin:setup()
  local setup ---@type fun():nil
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

local dir = nv.stdpath.config .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)

local M = {}

for _, path in ipairs(files) do
  local name = path:match('([^/]+)%.lua$')
  if name ~= 'init' then
    local ok, mod = pcall(require, 'nvim.plugins.' .. name)
    if ok and mod then
      for _, spec in ipairs(vim.islist(mod) and mod or { mod }) do
        M[spec[1]] = Plugin.new(spec)
      end
    end
  end
end

return setmetatable(M, {
  __call = function(t, k)
    return Plugin.new(k)
  end,
})
