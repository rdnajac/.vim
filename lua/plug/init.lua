local M = {}

---- transforms the shortform `user_repo` to a github url
local function gh(user_repo)
  return user_repo and 'https://github.com/' .. user_repo .. '.git' or nil
end

--- Represents a lua plugin.
---
--- A |Plugin| object contains the metadata needed for...
--- To create a new |Plugin| object, call `nv.Plug()`.
---
---
--- @class Plugin
--- @field [1]? string|vim.pack.Spec
--- @field build? string|fun(): nil
--- @field config? fun(): nil
--- @field dependencies? (string|vim.pack.Spec|PlugSpec)[]
--- @field event? vim.api.keyset.events|vim.api.keyset.events[]
--- @field enabled? boolean|fun():boolean
--- @field specs? (string|vim.pack.Spec)[]
--- @field opts? table|any
local Plugin = {}
Plugin.__index = Plugin

-- constructor
function Plugin.new(t)
  return setmetatable(t or {}, Plugin)
end

setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})

function Plugin:spec()
  local src = gh(self.src or self[1])
  -- TODO: vim.validate?
  if type(src) ~= 'string' or src == '' then
    return specs or nil
  end

  local name = self.name or src:match('[^/]+$'):match('^(.-)%.nvim')
  -- use gsub? what avout repo.git?
  local version = self.version or nil
  -- TODO: make an opts table?
  -- what if no opts table?
  -- TODO can data be a metatable? can it be the plugin and we pass the plugin to data when we ivm.pack.add?
  local data = {}
  data.config = self.config or nil
  data.opts = self.opts or nil
  if data.config then
    data.opts = nil
  end

  -- data.self = self

  local spec = { src = src, name = name, version = version, data = data }
  -- list of strings
  local deps = self.deps or self.specs or nil

  return spec, deps
end

function Plugin:enabled()
  if vim.is_callable(self.enabled) then
    local ok, res = pcall(self.enabled)
    return ok and res
  end
  return self.enabled ~= false
end

function Plugin:setup()
  local config = self.config or nil
  local opts = self.opts or nil
  local name = self.name or self.src
  if config and vim.is_callable(config) then
    info('configuring ' .. name)
    config()
  elseif opts and name then
    info('setting up ' .. name)
    require(self).setup(opts)
  elseif spec_data.p then
    -- info(spec_data.p():spec())
  end
end

M.specs = function()
  return vim.pack.get()
end

-- this should be called on every entry
-- and should contain the plugin handling logic
function M.plug(plugin)
  local m = require('util').safe_require(m)
  return m and Plugin(m) or nil
end

local setup = function(spec_name, spec_data)
  local config = spec_data.config or nil
  -- local opts = spec_data.opts or {}
  if config and vim.is_callable(config) then
    info('configuring ' .. spec_name)
    config()
  elseif spec_data.opts then
    info('setting up ' .. spec_name)
    require(spec_name).setup(spec_data.opts)
  elseif spec_data.p then
    info(spec_data.p():spec())
  end
end

local _load = function(plug_data)
  local spec = plug_data.spec

  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })

  if spec.data then
    -- pass plugin object in and try to call methods on that
    -- info(spec.data.self)
    local p = spec.data.self or nil
    -- if p then p:setup() end
    setup(spec.name, spec.data)
  end
end

function M.end_()
  local extra = {}
  local specs = vim.tbl_map(
    ---@param plugin string
    function(plugin)
      if vim.endswith(plugin, '.nvim') then
        local modname = 'nvim/' .. plugin:match('([^/]+)$'):gsub('%.nvim$', '')
        local mod = require('util').safe_require(modname)
        if mod then
          local spec, deps = Plugin(mod):spec()
          if deps then
            vim.list_extend(extra, deps) -- add to extras table
          end
          return spec -- add to specs table
        end
      end
      return gh(plugin)
    end,
    vim.g['plug#list']
  )

  local blink_spec, blink_deps = Plugin(require('plug/blink')):spec()
  table.insert(specs, blink_spec)
  vim.list_extend(specs, vim.tbl_map(gh, blink_deps))
  vim.list_extend(specs, vim.tbl_map(gh, require('nvim.lsp').specs))
  vim.list_extend(specs, require('nvim.treesitter').specs)

  -- add to extras table
  -- local test = {
  --   src = 'https://github.com/rdnajac/vim-lol.git',
  --   data = {
  --     p = function()
  --       return Plugin.new({ 'user/repo' })
  --     end,
  --   },
  -- }

  vim.pack.add(specs, { confirm = false, load = _load })
end

function M.test(plugin, dict)
  info(plugin)
  info('type(plugin) = ' .. type(plugin))
end

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
