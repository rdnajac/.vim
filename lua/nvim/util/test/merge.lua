local Plugin = {}
Plugin.__index = Plugin

--- merge and convert dict-like k, v params
local function _resolve_self(...)
  local self = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    if type(v) == 'table' then
      self = vim.tbl_deep_extend('force', self, v)
    elseif type(v) == 'string' then
      self[1] = self[1] or v
    end
  end
  return self
end

function Plugin.new(...)
  local self = _resolve_self(...)
  vim.validate('[1]', self[1], 'string')
  return setmetatable(self, Plugin)
end
