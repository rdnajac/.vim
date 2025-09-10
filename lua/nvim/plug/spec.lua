--- Represents a lua plugin.

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

function Plugin:enabled()
  if vim.is_callable(self.enabled) then
    local ok, res = pcall(self.enabled)
    return ok and res
  end
  return self.enabled ~= false
end

function Plugin:setup()
  if vim.is_callable(self.config) then
    -- info('configuring ' .. self.name)
    self.config()
  else
    -- info('setting up ' .. self.name)
    require(self.name).setup(self.opts or {})
  end
end

function Plugin:deps()
    info(self.name)
  if type(self.specs) == 'table' and #self.specs > 0 then
    local specs = vim.tbl_map(require('nvim.plug').gh, self.specs)
    info(specs)
    vim.pack.add(specs, { confirm = false })
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
