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
--- @field event? vim.api.keyset.events|vim.api.keyset.events[]
--- @field enabled? boolean|fun():boolean
--- @field specs? (string|vim.pack.Spec)[]
--- @field opts? table|any
local Plugin = {}
Plugin.__index = Plugin

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

  local spec = { src = src, name = name, version = version, data = data }
  -- list of strings
  local deps = self.deps or self.specs or nil
  if deps then
    local ret = vim.tbl_map(function(dep)
      return gh(dep)
    end, deps)
    ret[#ret + 1] = spec
    -- info(ret)
    return ret
  end
  return spec
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
    -- elseif spec_data.p then
    -- info(spec_data.p():spec())
  end
end
function Plugin.new(t)
  return setmetatable(t or {}, Plugin)
end

return setmetatable(Plugin, {
  __call = function(_, t)
    return Plugin.new(t)
  end,
})
